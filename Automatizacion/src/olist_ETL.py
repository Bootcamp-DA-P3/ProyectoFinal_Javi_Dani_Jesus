"""ETL de Olist: extrae con SQL, comprueba el grano y deja un CSV por consulta.

Las tres fases del proceso estan separadas a proposito:
    extraer   -> lee el .sql y lo ejecuta contra MySQL
    comprobar -> valida que el resultado tiene el grano declarado
    limpiar   -> aplica las reglas de src/limpieza.py
    exportar  -> escribe el CSV que consumira Excel

Las comprobaciones de grano son las que diferencian un ETL de un script que
escribe ficheros.
"""

from urllib.parse import quote_plus

import pandas as pd
from sqlalchemy import create_engine, text

from src.limpieza import limpiar
from src.config import (
    CARPETA_OUTPUT,
    CARPETA_QUERIES,
    DB_HOST,
    DB_NAME,
    DB_PASSWORD,
    DB_PORT,
    DB_USER,
)

# Cada consulta con la columna que define su grano.
# Si la consulta devuelve mas filas que valores distintos en esa columna,
# algun JOIN esta multiplicando y el CSV es incorrecto.
CONSULTAS = {
    "df1_actividad_clientes": ["order_id"],
    "df2_catalogo_productos": ["product_id"],
    "df3_vendedores_productos": ["vendedor", "categoria"],
    "ventas_detalle": ["order_id", "order_item_id"],
}

def crear_engine():
    """Devuelve el engine de SQLAlchemy a partir de las credenciales del .env."""
    if not DB_USER or not DB_PASSWORD:
        raise RuntimeError(
            "Faltan DB_USER o DB_PASSWORD en el fichero .env. "
            "Copiad .env.example como .env y rellenadlo."
        )
    # quote_plus escapa los caracteres que romperian la URL (@, #, /, ...).
    url = (
        f"mysql+mysqlconnector://{quote_plus(DB_USER)}:{quote_plus(DB_PASSWORD)}"
        f"@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    )
    return create_engine(url)


def extraer(engine, nombre):
    """Ejecuta la consulta SQL y devuelve un DataFrame."""
    ruta = CARPETA_QUERIES / f"{nombre}.sql"

    if not ruta.exists():
        raise FileNotFoundError(f"No existe la consulta {ruta}")

    consulta = ruta.read_text(encoding="utf-8").strip().rstrip(";")

    print(f"Archivo SQL: {ruta}")
    print(f"Inicio de la consulta: {consulta[:100]!r}")

    with engine.connect() as conexion:
        return pd.read_sql_query(text(consulta), conexion)

def comprobar_grano(df, claves, nombre):
    """Comprueba que las columnas declaradas identifican cada fila."""

    if isinstance(claves, str):
        claves = [claves]

    for clave in claves:
        if clave not in df.columns:
            raise KeyError(
                f"{nombre}: falta la columna de grano '{clave}'"
            )

    duplicados = df.duplicated(subset=claves).sum()

    if duplicados > 0:
        raise ValueError(
            f"{nombre}: hay {duplicados} filas duplicadas "
            f"para la combinación {claves}."
        )

def exportar(df, nombre):
    """Escribe el CSV en output/ y devuelve la ruta."""
    CARPETA_OUTPUT.mkdir(parents=True, exist_ok=True)
    destino = CARPETA_OUTPUT / f"{nombre}.csv"
    # utf-8-sig para que Excel abra los acentos correctamente.
    df.to_csv(destino, index=False, encoding="utf-8-sig")
    return destino

def ejecutar_etl():
    """Recorre todas las consultas. Devuelve {nombre: (filas, ruta del csv)}."""
    engine = crear_engine()
    resultados = {}

    try:
        for nombre, clave_de_grano in CONSULTAS.items():
            print(f"\nEjecutando consulta: {nombre}")

            df = extraer(engine, nombre)
            print(f"Consulta correcta: {len(df)} filas")

            # Comprueba el grano antes de limpiar.
            comprobar_grano(df, clave_de_grano, f"{nombre} (SQL)")

            # Aplica las reglas de limpieza.
            df = limpiar(df, nombre)

            # Comprueba el grano después de limpiar.
            comprobar_grano(df, clave_de_grano, f"{nombre} (tras limpiar)")

            # Exporta el CSV.
            destino = exportar(df, nombre)
            resultados[nombre] = (len(df), destino)

            print(f"CSV generado: {destino}")

        return resultados

    finally:
        engine.dispose()