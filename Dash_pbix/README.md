# 📊 Olist · Dashboard de Ventas y Logística en Power BI

![Power BI](https://img.shields.io/badge/Power%20BI-Desktop-F2C811?logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/An%C3%A1lisis-DAX-1F3A5F)
![Power Query](https://img.shields.io/badge/ETL-Power%20Query-1F3A5F)
![Dataset](https://img.shields.io/badge/Dataset-Olist-F26B38)
![Estado](https://img.shields.io/badge/Estado-En%20desarrollo-yellow)

> **Proyecto V · Bootcamp de Data Analytics.** Rehacemos con Power BI el tablero que construimos en Excel en el Proyecto IV, aprovechando lo que Excel no nos permitía: modelo de datos, medidas DAX e interactividad real.

---

## 📑 Índice

1. [Descripción del proyecto](#-descripción-del-proyecto)
2. [Objetivos](#-objetivos)
3. [Origen de los datos](#-origen-de-los-datos)
4. [Tecnologías](#️-tecnologías)
5. [Estructura del repositorio](#-estructura-del-repositorio)
6. [Cómo usar el proyecto](#-cómo-usar-el-proyecto)
7. [Proceso ETL (Power Query)](#-proceso-etl-power-query)
8. [Modelo de datos](#-modelo-de-datos)
9. [Medidas DAX](#-medidas-dax)
10. [El dashboard](#-el-dashboard)
11. [Hallazgos principales](#-hallazgos-principales)
12. [Niveles de entrega](#-niveles-de-entrega)
13. [Decisiones y lecciones aprendidas](#-decisiones-y-lecciones-aprendidas)
14. [Gestión del proyecto](#-gestión-del-proyecto)
15. [Equipo](#-equipo)

---

## 🔍 Descripción del proyecto

Este repositorio recoge el **Proyecto V** de la formación: un dashboard de **dos páginas** en Power BI sobre el dataset público de **Olist** (comercio electrónico en Brasil, 2016–2018).

Somos el departamento de Business Intelligence de una startup que quiere demostrar, con visualizaciones claras e *insights* accionables, que puede transformar datos en información útil con herramientas de BI profesionales.

El proyecto cierra una cadena de tres entregas con los mismos datos y el mismo equipo:

| Proyecto | Qué hicimos | Con qué |
|---|---|---|
| **III** | Extraer un dataset analítico a mano y decidir el grano | SQL |
| **IV** | Convertir esa extracción en un ETL automático y montar un tablero | Python + Excel |
| **V** *(este)* | Rehacer el tablero con la herramienta profesional | **Power BI** |

---

## 🎯 Objetivos

- 🧹 Cargar y transformar datos con **Power Query**.
- 🧩 Modelar los datos para el análisis multidimensional.
- 📈 Construir **paneles interactivos** con visualizaciones profesionales.
- 💡 Extraer **conclusiones accionables** para decisiones de negocio.
- 🧮 Aplicar **medidas DAX**: medias, varianzas y desviaciones por grupo.

---

## 🗃️ Origen de los datos

Hemos elegido la vía **🅰️ Continuidad · Olist**: los CSV que genera el ETL del Proyecto IV (MySQL → Python → CSV).

| Tabla | Filas | Contenido |
|---|---|---|
| `ventas_detalle` | 112.650 | Una fila por línea de pedido: `order_id`, `order_item_id`, `product_id`, `seller_id`, fecha de compra, `price`, `freight_value` |
| `df1_actividad_clientes` | 96.469 | Una fila por pedido entregado: estado, fechas, `payment_total`, `review_score`, ciudad, estado, coordenadas, `delivery_days`, `is_late` |
| `df2_catalogo_productos` | 32.951 | Catálogo: categoría, dimensiones, peso, fotos |
| `df3_vendedores_productos` | 6.604 | Vendedores: estado, categoría, ventas y ranking por categoría |

> 📌 **Equivalencia con el enunciado (caso AirBnB → Olist):** precios → `price` y `payment_total`; ubicación → estados y ciudades de Brasil; disponibilidad → estados del pedido y tiempos de entrega; análisis entre ciudades → análisis entre estados o categorías.

---

## ⚙️ Tecnologías

| Herramienta | Uso |
|---|---|
| **Microsoft Power BI Desktop** | Modelo, medidas y dashboard |
| **Power Query (M)** | Carga y transformación |
| **DAX** | Medidas y columnas calculadas |
| **Python** | ETL del Proyecto IV |
| **MySQL** | Base de datos de origen |
| **Excel (tablas dinámicas)** | Dashboard del Proyecto IV |
| **Google Colab** | Exploración y apoyo |
| **Git / GitHub** | Control de versiones y documentación |


---

## 📁 Estructura del repositorio


```text
ProyectoFinal_Javi_Dani_Jesus/
├── Automatizacion/
│   ├── dashboard/
│   │   ├── Olist_Dashboard.xlsx
│   │   ├── REALME.md
│   │   └── ~$Olist_Dashboard.xlsx
│   │
│   ├── output/
│   │   ├── .gitkeep
│   │   ├── df1_actividad_clientes.csv
│   │   ├── df2_catalogo_productos.csv
│   │   ├── df3_vendedores_productos.csv
│   │   └── ventas_detalle.csv
│   │
│   ├── queries/
│   │   ├── df1_actividad_clientes.sql
│   │   ├── df2_catalogo_productos.sql
│   │   ├── df3_vendedores_productos.sql
│   │   └── ventas_detalle.sql
│   │
│   ├── src/
│   │   ├── __init__.py
│   │   ├── config.py
│   │   ├── excel.py
│   │   ├── limpieza.py
│   │   └── olist_ETL.py
│   │
│   └── main.py
│
├── Dash_pbix/
│   └── Dashboard_olist_v2.pbix
│
├── README.md
├── .env_example
├── .gitignore
└── requirements.txt
```

---

## 🚀 Cómo usar el proyecto

1. Clona el repositorio:
```bash
   git clone https://github.com/Bootcamp-DA-P3/ProyectoFinal_Javi_Dani_Jesus.git
```
2. Abre `Dashboard_olist_v2.pbix` con **Power BI Desktop**.
3. Si Power BI no encuentra los CSV, ve a **Inicio → Transformar datos → Configuración de origen de datos** y apunta cada fuente a la carpeta donde tengas los CSV (`ventas_detalle.csv`, `df1_actividad_clientes.csv`, `df2_catalogo_productos.csv`, `df3_vendedores_productos.csv`).
4. Pulsa **Actualizar** para recargar los datos.
5. *(Opcional)* Para aplicar la paleta de colores: **Vista → Temas → Examinar temas → `Olist_Rediseno_tema.json`**.

> 💡 Para regenerar los CSV desde MySQL, sigue las instrucciones del ETL del Proyecto IV (carpeta `Automatizacion/`).

---

## 🧹 Proceso ETL (Power Query)

Los CSV de partida proceden del ETL del Proyecto IV, donde se aplicó la mayor parte de la limpieza y se fijó el grano de cada tabla. En Power BI se revisó y comprobó lo siguiente:

- [x] Conexión a las cuatro fuentes CSV.
- [x] Tipos de dato correctos en las columnas que se usan en medidas: `delivery_days` (entero), `review_score` (decimal) e `is_late` (entero).
- [x] Columna `AñoMes` para el análisis temporal.
- [x] Documentar paso a paso las transformaciones de Power Query.
- [x] Documentar el tratamiento de nulos y duplicados.

---

## 🧩 Modelo de datos

El modelo se organiza alrededor de una tabla de hechos (`ventas_detalle`) y tablas descriptivas.

| Relación | Clave | Estado |
|---|---|---|
| `ventas_detalle` ↔ `df1_actividad_clientes` | `order_id` | ✅ Verificada (ticket medio por ciudad) |



---

## 🧮 Medidas DAX

### Medidas de ventas *(página «Ventas»)*

| Medida | Resultado | Fórmula |
|---|---|---|
| `Ventas de productos` | 13,59 mill. |= SUM(ventas_detalle[price]) |
| `Ticket medio` | 137,75 |  = DIVIDE(    [Ventas de productos],    [Pedidos distintos],    0 |
| `Unidades vendidas` | 113 mil | = COUNTROWS(ventas_detalle)|
| `Gastos de envio` | 2 mill. | = SUM(ventas_detalle[freight_value])|

### Medidas de entrega y satisfacción *(media y varianza)*

```dax
Media Dias Entrega = AVERAGE(df1_actividad_clientes[delivery_days])

Varianza Dias Entrega = VAR.S(df1_actividad_clientes[delivery_days])

Desv Dias Entrega = SQRT([Varianza Dias Entrega])

Media Reseña = AVERAGE(df1_actividad_clientes[review_score])

Varianza Reseña = VAR.S(df1_actividad_clientes[review_score])
```

### Columna calculada

```dax
Estado Entrega = IF(df1_actividad_clientes[is_late] = 1, "Con retraso", "A tiempo")
```

> 📝 Se usa `VAR.S` (varianza muestral). La **desviación típica** se añade porque la varianza viene en días², que es difícil de interpretar.

---

## 📊 El dashboard

Dos páginas con una cabecera común, un navegador entre ellas y una paleta de colores propia (azul `#1F3A5F` de base y naranja `#F26B38` solo para destacar).


### 1️⃣ Página «Ventas y evolución comercial»

| Visual | Qué muestra |
|---|---|
| Tarjetas | Ventas de productos, ticket medio, unidades vendidas y gastos de envío |
| Gráfico de líneas | Ventas mensuales (2017-01 a 2018-08) |
| Gráfico de líneas | Ticket medio por mes |
| Gráfico de barras | Top 10 ciudades por ticket medio |
| Mapa de burbujas | Ubicación de los clientes (latitud y longitud) |

### 2️⃣ Página «Entrega y satisfacción del cliente»

| Visual | Qué muestra |
|---|---|
| Tarjetas | Días medios de entrega y reseña media |
| Segmentación | Filtro por estado de Brasil |
| Gráfico de barras | Días medios de entrega por estado |
| Gráfico de dispersión | **Rapidez frente a regularidad**: media y varianza de los días de entrega por estado |
| Gráfico de columnas | Reseña media según el pedido llegue a tiempo o con retraso |

---

## 💡 Hallazgos principales

| Hallazgo | Dato |
|---|---|
| 🚚 Los estados más lentos son también los más irregulares | SP: **8,7 días** de media (varianza ≈ 46) frente a RR: **29,3 días** (varianza ≈ 771) |
| 🕒 Tiempo medio de entrega global | **12,5 días** |
| ⭐ El retraso penaliza la satisfacción | Reseña media **4,29** a tiempo frente a **2,57** con retraso |
| ⭐ Reseña media global | **4,16 / 5** |
| ⚠️ Cuidado con los estados pequeños | RR (41 pedidos), AP (67) y AC (80) tienen varianzas poco fiables |

**Recomendación de negocio:** priorizar la mejora logística en los estados del norte y noreste, donde la entrega es lenta y muy variable, porque el retraso es lo que más hunde las reseñas.

---

## 🧠 Decisiones y lecciones aprendidas

- **Tipos de dato:** una columna numérica importada como texto hace fallar `AVERAGE` y similares. Se comprobó el tipo de `delivery_days`, `review_score` e `is_late` antes de crear medidas.
- **Meses incompletos:** 2016-09, 2016-10, 2016-12 y 2018-09 tienen muy pocos pedidos. Se excluyen de los gráficos de línea para evitar caídas artificiales, pero no de las tarjetas totales.
- **Mapa:** usar solo `customer_city` hacía que Bing colocase ciudades brasileñas en Portugal o África por homonimia. Se resolvió usando `latitude` y `longitude`.
- **Top N con filtros:** un filtro Top N no se combina bien con otro filtro sobre una medida en el mismo visual. Se simplificó a un Top 10 único.
- **Varianza en grupos pequeños:** se avisa de que estados con pocos pedidos distorsionan la comparación.

---





---

## 📚 Fuentes y agradecimientos

- Dataset: [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).
- Proyecto formativo del **Bootcamp de Data Analytics**.

---

