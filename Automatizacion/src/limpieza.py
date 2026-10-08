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


# Reglas que se aplican a todos los datasets.
COMUNES = []


# Reglas propias de cada dataset.
LIMPIEZA = {
    "df1_actividad_clientes": [tipar_fechas],
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