# Proyecto 3 - SQL y Data Analysis

Proyecto realizado durante el Bootcamp de Data Analysis utilizando la base de datos **Olist**.

---

## 🎯 Objetivo

Construir un DataFrame preparado para análisis a partir de diferentes tablas de Olist mediante **SQL, MySQL, Python, SQLAlchemy y Pandas**.

---

## 📊 Grano del DataFrame

La primera decisión fue definir el **grano**, es decir, qué representa cada fila del DataFrame final.

> **1 fila = 1 pedido entregado**

Se utiliza `order_id` como identificador del pedido.

Esta decisión es fundamental para evitar duplicaciones al combinar tablas, ya que un mismo pedido puede tener varios pagos, reseñas u otros registros asociados.

---

## 🔗 JOINs y control de duplicados

La tabla principal es `orders`, sobre la que se incorpora información de:

- `customers`
- `order_payments`
- `order_reviews`
- `geolocation`

Se utilizan diferentes tipos de `JOIN` según la finalidad:

- **INNER JOIN:** cuando es necesaria una correspondencia entre las tablas.
- **LEFT JOIN:** cuando se quiere conservar el pedido aunque no exista información relacionada.

Las tablas que pueden contener varios registros por pedido se **agrupan previamente** antes de realizar el `JOIN`.

Por ejemplo, los pagos se agrupan por `order_id` para obtener un único importe total:

```sql
SELECT
    order_id,
    SUM(payment_value) AS payment_total
FROM order_payments
GROUP BY order_id;
```

De esta forma, al realizar el `JOIN`, no se multiplica el número de filas y se mantiene el grano:

> **1 fila = 1 pedido**

Este mismo principio se aplica a las reseñas y a la información de geolocalización cuando es necesario.

---

## 🧹 Transformación y limpieza

Mediante SQL se realizan los filtros y transformaciones iniciales:

- Selección de pedidos válidos.
- Normalización de textos con `LOWER()` y `TRIM()`.
- Agrupación de información.
- Creación de variables derivadas mediante funciones como `DATEDIFF()` y `CASE WHEN`.

Posteriormente, los datos se obtienen mediante **SQLAlchemy** y se cargan en **Pandas** para realizar la limpieza y validación final.

### ❓ Tratamiento de valores nulos

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

## 🔍 Validación

Se comprueba que el grano definido se mantiene:

```python
filas = len(df)

pedidos_unicos = df["order_id"].nunique()

filas == pedidos_unicos
```

La validación confirma que cada pedido aparece una única vez en el DataFrame final.

---

## 📄 Resultado

El DataFrame validado se exporta a CSV para su posterior análisis.

Las credenciales de la base de datos se gestionan mediante variables de entorno y el proyecto se versiona mediante **Git y GitHub**.

---

## 📌 Resumen

El trabajo realizado en el **DataFrame 1 - Actividad de clientes** consiste en transformar varias tablas normalizadas de Olist en un único dataset preparado para análisis.

La decisión principal ha sido establecer:

> **Grano: 1 fila = 1 pedido entregado**

Para mantener este grano se han utilizado agrupaciones de pagos, reseñas y geolocalización antes de realizar los `JOIN` correspondientes.

Los **pagos se han agrupado por `order_id` y sumado** para obtener el importe total pagado por cada pedido, evitando que los diferentes pagos asociados a un mismo pedido generen varias filas. Las **reseñas se han agrupado por `order_id` calculando la puntuación media**, de forma que cada pedido aporte un único valor de valoración. Por último, la **geolocalización se ha agrupado por código postal**, calculando la latitud y longitud medias para obtener una única referencia geográfica.

De esta forma, se evita que los `JOIN` multipliquen las filas y se mantiene el objetivo de que **cada fila del DataFrame represente un único pedido entregado**.

Posteriormente se ha utilizado **Python, SQLAlchemy y Pandas** para ejecutar la consulta, convertir las fechas, mantener los valores nulos justificados y validar que el número de pedidos únicos coincide con el número de filas.

El resultado final es un DataFrame de:

> **96.469 pedidos y 15 columnas**

con una estructura preparada para su posterior análisis.
