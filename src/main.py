"""
Proyecto III · Flujo de datos de SQL a Python

Lee UNA de las consultas de sql/, la ejecuta contra MySQL y exporta el
resultado a data/.

Ejecutar desde la RAÍZ del proyecto:

    python src/main.py

Las funciones están declaradas pero vacías: os toca a vosotros.
Cada TODO dice qué hacer, no cómo.
"""

from pathlib import Path

import pandas as pd
from sqlalchemy import create_engine, text

from config import DB_USER, DB_PASSWORD, DB_HOST, DB_NAME

RAIZ = Path(__file__).resolve().parent.parent
SQL = RAIZ / "sql"
DATA = RAIZ / "data"


# ---------------------------------------------------------------------------
# CONFIGURACIÓN DEL EQUIPO · rellenad estas tres líneas antes de programar
# ---------------------------------------------------------------------------

# ¿Cuál de las tres consultas lleváis hasta el CSV?
CONSULTA = "df1_actividad_clientes.sql"

# El grano, en lenguaje de negocio. Ejemplo: "un pedido entregado"
GRANO = "un pedido entregado"

# La columna que identifica una fila según ese grano. Ejemplo: "order_id"
# Sirve para comprobar que el JOIN no está multiplicando filas.
CLAVE_DE_GRANO = "order_id"


# ---------------------------------------------------------------------------


def crear_engine():
    """Crea el motor de conexión a MySQL con las credenciales del .env."""
    url = f"mysql+mysqlconnector://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"
    return create_engine(url)


def leer_consulta(nombre):
    """Devuelve el contenido del fichero .sql que hay en sql/.

    La consulta vive en su fichero, no incrustada aquí: así la misma que
    probasteis en Workbench es la que ejecuta el script.
    """
    # TODO: leer el fichero SQL / nombre y devolver su texto
    #       Pista: los objetos Path tienen un método read_text()
    return (SQL / nombre).read_text(encoding="utf-8")


def ejecutar(engine, consulta_sql):
    """Ejecuta la consulta y devuelve un DataFrame de pandas."""
    with engine.connect() as conexion:
        return pd.read_sql(text(consulta_sql), conexion)


def comprobar_grano(df):
    """Comprueba que cada fila representa un único pedido."""
    filas = len(df)
    claves = df[CLAVE_DE_GRANO].nunique()

    if filas == claves:
        print("Grano OK: cada fila corresponde a un pedido.")
    else:
        print(
            f"AVISO: hay {filas:,} filas pero "
            f"{claves:,} {CLAVE_DE_GRANO} distintos."
        )


def exportar(df, nombre_csv):
    """Guarda el DataFrame en data/ como CSV."""
    DATA.mkdir(exist_ok=True)
    df.to_csv(
        DATA / nombre_csv,
        index=False,
        encoding="utf-8-sig"
    )

def main():
    if not GRANO or not CLAVE_DE_GRANO:
        raise SystemExit(
            "Antes de ejecutar: rellenad GRANO y CLAVE_DE_GRANO arriba.\n"
            "Si no sabéis qué poner, aún no estáis listos para escribir el JOIN."
        )

    print(f"Consulta ....... {CONSULTA}")
    print(f"Grano .......... una fila = {GRANO}")

    engine = crear_engine()
    consulta_sql = leer_consulta(CONSULTA)
    df = ejecutar(engine, consulta_sql)

    print(f"Filas .......... {len(df):,}")
    print(f"Columnas ....... {df.shape[1]}")

    comprobar_grano(df)
    exportar(df, CONSULTA.replace(".sql", ".csv"))


if __name__ == "__main__":
    main()