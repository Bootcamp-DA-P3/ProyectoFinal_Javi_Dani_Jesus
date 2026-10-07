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


# Reglas comunes a todos los datasets.
# En este proyecto no tenemos ninguna.
COMUNES = []


# Reglas específicas de cada dataset.
LIMPIEZA = {
    "df1_actividad_clientes": [tipar_fechas],
}


def limpiar(df, nombre):
    """Aplica las reglas de limpieza correspondientes al dataset."""

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