# 📊 Olist Data Analysis & Dashboard

Este proyecto consiste en un análisis de datos comerciales y logísticos de **Olist** (el e-commerce marketplace líder en Brasil) desarrollado en **Microsoft Excel**. El objetivo principal es ofrecer una visión clara del rendimiento de ventas, el volumen logístico por región y la concentración de proveedores para facilitar la toma de decisiones estratégicas.

---

## 🎯 Objetivos del Análisis

El dashboard busca responder a las siguientes preguntas clave de negocio:
1. **Evolución Temporal:** ¿Cómo han evolucionado la facturación y los ingresos a lo largo de los años (2016-2018)?
2. **Eficiencia Logística:** ¿Qué estados concentran el mayor volumen de pedidos y en cuáles se identifican mayores tasas de entrega con retraso (`is_late`)?
3. **Distribución de Proveedores:** ¿Cómo se distribuyen las ventas y la presencia de vendedores/proveedores según su ubicación geográfica?

---

## 🛠️ Metodología y Preparación de Datos

Para la obtención de los datos y la posterior elaboración del dashboard, se realizaron las siguientes fases:

1. **Estructuración del Modelo de Datos:** 
   * Limpieza y modelado a partir de las tablas de actividad de clientes (`df1_actividad_clientes`), ventas e histórico de compras (`ventas_detalle`) y registro de vendedores (`df3_vendedores_productos`).
2. **Creación de Tablas Dinámicas:**
   * **KPIs Principales:** Métrica de volumen total de pedidos entregados ($11.354$), facturación global acumulada ($444.151.317$) y total de ventas registradas ($112.650$).
   * **Análisis Temporal:** Agrupación de la variable `order_purchase_timestamp` por años y meses junto con la suma de `price`.
   * **Análisis Geográfico y Logístico:** Cruce del estado del cliente (`customer_state`) con el recuento de pedidos (`order_id`) y la tasa promedio de retraso (`is_late`).
   * **Análisis de Proveedores:** Evaluación por estado del vendedor (`estado`) relacionando la suma de ventas y la densidad de vendedores registrados (`vendedor`).
3. **Diseño e Interactividad:**
   * Generación de gráficos dinámicos integrados.
   * Incorporación de **Segmentadores de Datos (Slicers)** por año (`order_purchase_timestamp`) y región (`customer_state` y `estado`) para permitir un filtrado interactivo e inmediato en todo el cuadro de mando.

---

## 📈 Visualizaciones Incluidas

* **KPI Cards (Cabecera):** Muestran las métricas agregadas fundamentales del negocio de un vistazo.
* **Ventas por Mes/Año (Gráfico de Líneas):** Muestra la tendencia histórica de la facturación mes a mes.
* **Pedidos y Retrasos según Estados (Gráfico Combinado):** Identifica el volumen de demanda por región frente a incidencias en los tiempos de entrega.
* **Ventas y Proveedores según Estados (Gráfico de Columnas):** Refleja la concentración comercial y logística por estado de origen de los vendedores.