"""Funciones de limpieza del DataFrame 1 de Olist."""

import pandas as pd


def tipar_fechas(df):
    """Convierte las columnas de fecha a formato datetime."""

    columnas_fecha = [
        "order_purchase_timestamp",
        "order_delivered_customer_date",
        "order_estimated_delivery_date"
    ]

    for columna in columnas_fecha:
        df[columna] = pd.to_datetime(df[columna], errors="coerce")

    return df


""" Limpieza DataFrame 3 de Olist"""

def eliminar_categorias_repetidas(df):
    """Unifica categorías que se refieren a lo mismo."""
    df['categoria'] = df['categoria'].replace({
    'casa_conforto_2': 'casa_conforto',
    'eletrodomesticos_2': 'eletrodomesticos'
})

    return df 


def agrupacion_categoria_vendedor(df):
    """Unifica las categorías iguales de un mismo vendedor."""
    df = (
    df.groupby(['vendedor', 'estado', 'categoria'], as_index=False)
      .agg({'ventas': 'sum'})
)
    return df



def actualizacion_ventas_porcentajes(df):
    """Recalcula las métricas derivadas después de la unificación de categorías."""

    df['ventas_totales_vendedor'] = (
        df.groupby('vendedor')['ventas'].transform('sum')
    )

    df['num_categorias'] = (
        df.groupby('vendedor')['categoria'].transform('count')
    )

    df['ranking_categoria'] = (
        df.groupby('vendedor')['ventas']
        .rank(method='first', ascending=False)
        .astype(int)
    )

    df['porcentaje_vendedor'] = round(
        100 * df['ventas'] / df['ventas_totales_vendedor'],
        2
    )

    df = df.sort_values(
        ['ventas_totales_vendedor', 'vendedor', 'ventas'],
        ascending=[False, True, False]
    ).reset_index(drop=True)

    return df




# Reglas que se aplican a todos los datasets.
COMUNES = []


# Reglas propias de cada dataset.

LIMPIEZA = {
    "df1_actividad_clientes": [
        tipar_fechas
    ],

    "df2_productos": [
        crear_df_final
    ],

    "df3_vendedores_categorias": [
        eliminar_categorias_repetidas,
        agrupacion_categoria_vendedor,
        actualizacion_ventas_porcentajes
    ]
}



def limpiar(df, nombre):
    """Aplica las reglas comunes y las específicas del dataset."""

    for regla in COMUNES + LIMPIEZA.get(nombre, []):
        antes = len(df)

        df = regla(df)

        diferencia = antes - len(df)

        if diferencia > 0:
            print(f"    {regla.__name__}: {diferencia} filas fuera")

        elif diferencia < 0:
            print(
                f"    {regla.__name__}: {-diferencia} filas DE MAS, "
                "revisad la regla"
            )

    return df



"""Funciones de limpieza del DataFrame 2 de Olist."""

def calcular_unidades_vendidas(df):
    """Calcula cuántas veces se ha vendido cada producto."""
    
    return (
        df
        .groupby("product_id")
        .size()
        .reset_index(name="unidades_vendidas")
    )


def calcular_precio_habitual(df):
    """Obtiene el precio que más veces aparece para cada producto."""
    
    return (
        df
        .groupby(["product_id", "precio"])
        .size()
        .reset_index(name="veces")
        .sort_values(
            ["product_id", "veces"],
            ascending=[True, False]
        )
        .drop_duplicates("product_id")
    )


def obtener_categoria(df):
    """Obtiene una categoría para cada producto."""
    
    return (
        df[["product_id", "categoria"]]
        .drop_duplicates("product_id")
    )


def rellenar_categorias(df):
    """Sustituye las categorías vacías por 'sin_categoria'."""
    
    df = df.copy()
    df["categoria"] = df["categoria"].fillna("sin_categoria")
    
    return df


def crear_df_final(df):
    """Crea el DataFrame final con una fila por producto."""
    
    ventas_producto = calcular_unidades_vendidas(df)
    precio_habitual = calcular_precio_habitual(df)
    categoria_producto = obtener_categoria(df)

    df_final = (
        precio_habitual[["product_id", "precio"]]
        .merge(
            categoria_producto,
            on="product_id",
            how="left"
        )
        .merge(
            ventas_producto,
            on="product_id",
            how="left"
        )
    )

    df_final = rellenar_categorias(df_final)

    return df_final