# Proyecto 3 - SQL y Data Analysis

## DF1 - Actividad de clientes

Proyecto realizado durante el Bootcamp de Data Analysis utilizando la base de datos de Olist.

En esta parte del proyecto se ha trabajado exclusivamente con el **DataFrame 1: Actividad de clientes**.

---

# 🎯 Objetivo del proyecto

El objetivo es transformar los datos originales de la base de datos Olist en un dataset preparado para su posterior análisis.

Para ello se han utilizado:

- MySQL
- SQL
- SQLAlchemy
- Python
- Pandas
- Git
- GitHub

El proceso seguido consiste en:

1. Consultar y relacionar las tablas de la base de datos.
2. Aplicar filtros y transformaciones mediante SQL.
3. Definir el grano del DataFrame.
4. Evitar la duplicación de pedidos mediante agrupaciones.
5. Obtener el resultado mediante Python y SQLAlchemy.
6. Realizar la limpieza y validación final con Pandas.
7. Exportar el DataFrame limpio.
8. Versionar el trabajo mediante Git y GitHub.

---

# 📊 DataFrame 1 - Actividad de clientes

## Elección del grano

Una de las decisiones principales del proyecto ha sido determinar qué representa **una fila del DataFrame final**.

### Grano elegido

> **1 fila = 1 pedido entregado**

La clave utilizada para representar cada pedido es:

```text
order_id
```

Por tanto, cada `order_id` debe aparecer una única vez en el DataFrame final.

### ¿Por qué se ha elegido este grano?

Se ha elegido el **pedido** como unidad de análisis porque las tablas utilizadas contienen información relacionada directamente con los pedidos:

- Información del pedido.
- Información del cliente.
- Información de los pagos.
- Información de las reseñas.
- Información de la geolocalización.

Trabajar a nivel de pedido permite integrar toda esta información manteniendo una estructura en la que:

```text
1 fila = 1 pedido
```

De esta forma se evita que un pedido aparezca varias veces debido a que pueda tener varios pagos o registros relacionados.

---

## 🔍 Validación del grano

Una vez construido el DataFrame se ha comprobado que el número total de filas coincide con el número de `order_id` diferentes.

```python
filas = len(df)
pedidos_unicos = df["order_id"].nunique()

print("Filas:", filas)
print("Pedidos únicos:", pedidos_unicos)
print("¿El grano es correcto?", filas == pedidos_unicos)
```

Resultado obtenido:

```text
Filas: 96469
Pedidos únicos: 96469
¿El grano es correcto? True
```

Por tanto:

> **El grano seleccionado se cumple: cada fila representa un pedido entregado único.**

---

# 🗄️ Tablas utilizadas

Para construir el DataFrame se han utilizado las siguientes tablas:

- `orders`
- `customers`
- `order_payments`
- `order_reviews`
- `geolocation`

La tabla principal es:

```text
orders
```

A partir de ella se incorpora información procedente del resto de tablas.

---

# 🔗 Relación entre las tablas

El esquema general del proceso es:

```text
                         ┌──────────────┐
                         │  customers   │
                         └──────┬───────┘
                                │
                                │ customer_id
                                │
                                ▼
                         ┌──────────────┐
                         │    orders    │
                         └──────┬───────┘
                                │
               ┌────────────────┼────────────────┐
               │                │                │
               ▼                ▼                ▼
        ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
        │order_payments│ │order_reviews │ │ geolocation  │
        └──────────────┘ └──────────────┘ └──────────────┘
               │                │                │
               └────────────────┼────────────────┘
                                ▼
                       ┌──────────────────┐
                       │ DataFrame final  │
                       │ 1 fila = 1 pedido│
                       └──────────────────┘
```

---

# 🔗 JOIN utilizados

## 1. INNER JOIN con `customers`

Se relaciona `orders` con `customers` mediante `customer_id`:

```sql
JOIN customers c
    ON o.customer_id = c.customer_id
```

En SQL, escribir `JOIN` sin especificar el tipo equivale a utilizar un `INNER JOIN`.

La finalidad es incorporar a cada pedido la información correspondiente a su cliente.

---

## 2. LEFT JOIN con `order_payments`

Los pagos se agrupan previamente por pedido:

```sql
SELECT
    order_id,
    SUM(payment_value) AS payment_total
FROM order_payments
WHERE payment_value > 0
GROUP BY order_id
```

Después se incorporan mediante:

```sql
LEFT JOIN (
    ...
) p
    ON o.order_id = p.order_id
```

### ¿Por qué agrupamos antes de hacer el JOIN?

Un pedido puede tener varios pagos.

Por ejemplo:

```text
Pedido 1001
    ├── Pago 20 €
    ├── Pago 15 €
    └── Pago 10 €
```

Si uniéramos directamente los pagos con `orders`, podríamos obtener:

```text
1001 → 20 €
1001 → 15 €
1001 → 10 €
```

El mismo pedido aparecería tres veces.

Para evitarlo, primero hacemos:

```sql
SUM(payment_value)
GROUP BY order_id
```

Y obtenemos:

```text
1001 → 45 €
```

De esta forma seguimos manteniendo:

```text
1 fila = 1 pedido
```

---

## 3. LEFT JOIN con `order_reviews`

Las reseñas se agrupan por pedido calculando su puntuación media:

```sql
SELECT
    order_id,
    AVG(review_score) AS review_score
FROM order_reviews
GROUP BY order_id
```

Después se incorporan mediante un `LEFT JOIN`.

Se utiliza `LEFT JOIN` porque puede existir un pedido sin reseña.

En ese caso:

```text
review_score = NULL
```

El pedido no se elimina.

---

## 4. LEFT JOIN con `geolocation`

La tabla de geolocalización puede contener varios registros para un mismo código postal.

Por ello se calcula una media:

```sql
SELECT
    geolocation_zip_code_prefix,
    AVG(geolocation_lat) AS latitude,
    AVG(geolocation_lng) AS longitude
FROM geolocation
GROUP BY geolocation_zip_code_prefix
```

Después se relaciona con `customers`:

```sql
ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
```

De esta manera obtenemos:

- `latitude`
- `longitude`

Los pedidos que no tienen información de geolocalización mantienen esos valores como nulos.

---

# 🧹 Limpieza y transformación mediante SQL

La mayor parte de la transformación inicial se realiza mediante SQL.

## Pedidos seleccionados

Se seleccionan únicamente los pedidos entregados:

```sql
WHERE o.order_status = 'delivered'
```

También se eliminan los pedidos que no tienen fecha de entrega:

```sql
AND o.order_delivered_customer_date IS NOT NULL
```

Se comprueba que la fecha de entrega sea posterior a la fecha de compra:

```sql
AND o.order_delivered_customer_date > o.order_purchase_timestamp
```

Y se seleccionan pedidos cuyo total de pagos sea mayor que cero:

```sql
AND p.payment_total > 0
```

---

# 🧹 Normalización de textos

Se normalizan los campos de ciudad y estado utilizando:

```sql
LOWER(TRIM(c.customer_city))
```

y:

```sql
LOWER(TRIM(c.customer_state))
```

### `TRIM()`

Elimina espacios innecesarios:

```text
" Sevilla "
```

se convierte en:

```text
"Sevilla"
```

### `LOWER()`

Convierte el texto a minúsculas:

```text
"Sevilla"
```

se convierte en:

```text
"sevilla"
```

Esto permite tener los valores de texto en un formato homogéneo.

---

# 📅 Variables calculadas

## Días de entrega

Se calcula el número de días entre la compra y la entrega:

```sql
DATEDIFF(
    o.order_delivered_customer_date,
    o.order_purchase_timestamp
) AS delivery_days
```

El resultado se almacena en:

```text
delivery_days
```

---

## Pedido retrasado

Se crea la variable `is_late` mediante `CASE WHEN`:

```sql
CASE
    WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
    THEN 1
    ELSE 0
END AS is_late
```

Interpretación:

```text
is_late = 1 → pedido entregado tarde

is_late = 0 → pedido no entregado tarde
```

---

# 🐍 Python y SQLAlchemy

Una vez preparada la consulta SQL, se utiliza Python para ejecutarla y obtener el resultado como DataFrame.

El flujo es:

```text
MySQL
   │
   ▼
 SQL
   │
   ▼
SQLAlchemy
   │
   ▼
Python
   │
   ▼
Pandas
   │
   ▼
DataFrame
```

SQLAlchemy actúa como puente entre Python y MySQL.

En `main.py` se utiliza:

```python
from sqlalchemy import create_engine, text
```

La conexión se crea mediante:

```python
def crear_engine():
    url = f"mysql+mysqlconnector://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"
    return create_engine(url)
```

La consulta SQL se ejecuta y se transforma directamente en un DataFrame:

```python
def ejecutar(engine, consulta_sql):
    with engine.connect() as conexion:
        return pd.read_sql(text(consulta_sql), conexion)
```

---

# 🐼 Limpieza final con Pandas

Una vez obtenido el DataFrame se utiliza Pandas para realizar la limpieza y validación final.

---

## 📅 Conversión de fechas

Las columnas de fecha se convierten utilizando:

```python
columnas_fecha = [
    "order_purchase_timestamp",
    "order_delivered_customer_date",
    "order_estimated_delivery_date"
]

for columna in columnas_fecha:
    df[columna] = pd.to_datetime(
        df[columna],
        errors="coerce"
    )
```

Esto permite que Pandas interprete correctamente estas columnas como fechas.

---

# ❓ Tratamiento de valores nulos

Se mantienen los valores nulos presentes en:

- `review_score`
- `latitude`
- `longitude`

No se han imputado valores artificialmente.

La decisión es mantenerlos porque:

- Un pedido puede no tener una reseña.
- Puede no existir información de geolocalización para un código postal.
- No se considera adecuado inventar información que no existe en los datos originales.

Por tanto, los valores nulos se mantienen de forma justificada.

---

# 🔍 Validaciones realizadas

## Validación del grano

Se comprueba:

```python
filas = len(df)
pedidos_unicos = df["order_id"].nunique()

filas == pedidos_unicos
```

El resultado obtenido es:

```text
96469 == 96469
True
```

Esto confirma que:

```text
1 fila = 1 order_id
```

y por tanto se mantiene el grano elegido.

---

# 📊 Resultado final

El DataFrame final obtenido contiene:

```text
96.469 filas
15 columnas
```

El grano final es:

```text
1 fila = 1 pedido entregado
```

La clave de grano es:

```text
order_id
```

---

# 📄 Exportación

El DataFrame final se exporta a:

```text
data/df1_actividad_clientes_limpio.csv
```

mediante:

```python
df.to_csv(
    "../data/df1_actividad_clientes_limpio.csv",
    index=False,
    encoding="utf-8-sig"
)
```

El CSV se mantiene fuera del control de versiones según las indicaciones del proyecto.

---

# 📁 Estructura del proyecto

```text
Proyecto3_SQL_Javi_Dani_Jesus/
│
├── data/
│   └── .gitkeep
│
├── notebooks/
│   └── limpieza.ipynb
│
├── sql/
│   └── df1_actividad_clientes.sql
│
├── src/
│   ├── config.py
│   └── main.py
│
├── .env
├── .env_example
├── .gitignore
├── requirements.txt
└── README.md
```

---

# 🔐 Variables de entorno

Las credenciales de acceso a MySQL se almacenan en:

```text
.env
```

Este archivo contiene información privada y **no se sube al repositorio**.

Para indicar qué variables son necesarias se utiliza:

```text
.env_example
```

Ejemplo:

```text
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=TU_PASSWORD
DB_NAME=olist
```

---

# 🌿 Control de versiones

El desarrollo del DataFrame se ha realizado en una rama independiente:

```text
desarrollo_df1
```

De esta manera se puede trabajar sobre el DataFrame 1 sin modificar directamente la rama `main`.

El flujo utilizado es:

```text
Cambios locales
      │
      ▼
  git add
      │
      ▼
 git commit
      │
      ▼
  git push
      │
      ▼
GitHub
      │
      ▼
desarrollo_df1
```

---

# 🧠 Flujo completo del proyecto

```text
┌────────────────────────────┐
│      BASE DE DATOS OLIST   │
│                            │
│ orders                     │
│ customers                  │
│ order_payments             │
│ order_reviews              │
│ geolocation                │
└──────────────┬─────────────┘
               │
               ▼
┌────────────────────────────┐
│            SQL             │
│                            │
│ JOIN                       │
│ WHERE                      │
│ GROUP BY                   │
│ SUM                        │
│ AVG                        │
│ CASE WHEN                  │
│ Normalización              │
└──────────────┬─────────────┘
               │
               ▼
┌────────────────────────────┐
│         SQLAlchemy         │
│                            │
│ Python ↔ MySQL             │
└──────────────┬─────────────┘
               │
               ▼
┌────────────────────────────┐
│          PANDAS            │
│                            │
│ Conversión de fechas       │
│ Tratamiento de nulos       │
│ Validación del grano       │
└──────────────┬─────────────┘
               │
               ▼
┌────────────────────────────┐
│       DATAFRAME FINAL      │
│                            │
│ 96.469 filas               │
│ 15 columnas                │
│                            │
│ 1 fila = 1 pedido          │
└──────────────┬─────────────┘
               │
               ▼
┌────────────────────────────┐
│            CSV             │
│                            │
│ df1_actividad_clientes     │
│ _limpio.csv                │
└──────────────┬─────────────┘
               │
               ▼
┌────────────────────────────┐
│       GIT / GITHUB         │
│                            │
│ rama: desarrollo_df1       │
└────────────────────────────┘
```

---

# 📌 Resumen

El trabajo realizado en el **DataFrame 1 - Actividad de clientes** consiste en transformar varias tablas normalizadas de Olist en un único dataset preparado para análisis.

La decisión principal ha sido establecer:

> **Grano: 1 fila = 1 pedido entregado**

Para mantener este grano se han utilizado agrupaciones de pagos, reseñas y geolocalización antes de realizar los JOIN correspondientes.

Posteriormente se ha utilizado Python, SQLAlchemy y Pandas para ejecutar la consulta, convertir las fechas, mantener los valores nulos justificados y validar que el número de pedidos únicos coincide con el número de filas.

El resultado final es un DataFrame de:

> **96.469 pedidos y 15 columnas**

con una estructura preparada para su posterior análisis.
