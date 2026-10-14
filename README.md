
# 🚀 Guía del Proyecto: Automatización MySQL → Python → Excel

## 📝 Descripción general

Este proyecto tiene como objetivo principal transformar un flujo de análisis manual en un **pipeline automatizado de Extracción, Transformación y Carga (ETL)**. Utilizando **Python**, conectaremos una base de datos relacional **MySQL** para extraer los datasets analíticos, preprocesarlos y exportarlos en formato CSV, los cuales servirán como fuente dinámica para un **Dashboard interactivo en Microsoft Excel**.

Esta práctica representa el puente perfecto entre el análisis estático y la ingeniería de datos ligera, preparando el terreno para la migración a herramientas de Business Intelligence avanzadas.

---

## 🎯 Objetivos de aprendizaje y entregables

1. **Automatizar el flujo de datos:** Reemplazar consultas manuales repetitivas por scripts ejecutables en Python.
2. **Controlar el grano de los datos:** Evitar la duplicación y el inflado métrico (como el error común del $26\%$ en `JOINs` no agregados).
3. **Generar una arquitectura limpia:** Organizar código, consultas SQL, datasets de salida y visualizaciones en una estructura de directorios estandarizada.
4. **Construir un Dashboard en Excel:** Conectar los datos automatizados a tablas dinámicas, gráficos interactivos y segmentadores de datos (*slicers*).

---

## 🔗 Contexto y evolución (De P-III a P-V)

Este proyecto da continuidad al **Proyecto III** (donde se realizaban extracciones manuales y consultas estáticas) y sirve como antesala directa al **Proyecto V** (donde toda esta lógica se migrará a un modelo en estrella en Power BI con medidas DAX).

| Fase anterior (P-III) | Fase actual (P-IV) | Fase siguiente (P-V) |
| :--- | :--- | :--- |
| Extracción manual puntual | **Automatización mediante Python (`main.py`)** | Modelo relacional avanzado (Star Schema) |
| Archivos CSV estáticos | **CSVs generados automáticamente en `output/`** | Visualización interactiva en Power BI |
| Análisis aislado | **Dashboard operativo en Excel** | KPIs avanzados y medidas DAX |

---

## 🗄️ Requisitos previos y Base de Datos

* **Motor de Base de Datos:** MySQL instalado localmente o accesible mediante red.
* **Dataset:** Olist E-commerce ($99.441$ registros reales de pedidos, clientes, pagos, productos y vendedores en Brasil entre 2016 y 2018).
* **Volcado inicial:** Si no dispones de la base de datos, puedes descargar el archivo comprimido `olist.sql.gz` desde la [carpeta de formación en Drive](https://drive.google.com/drive/folders/1apSXjn6eQ5o9RdutbD4skSjvH6ytvR06?usp=sharing).

---

## 🧰 Stack Tecnológico

* **Lenguaje:** Python $3.x$
* **Base de Datos:** MySQL
* **Librerías clave:** `pandas`, `sqlalchemy`, `mysql-connector-python`, `python-dotenv`
* **Visualización:** Microsoft Excel (`openpyxl` / Conexiones de datos)
* **Control de versiones:** Git & GitHub

---

## 🏗️ Estructura del Repositorio de Trabajo

El equipo debe mantener estrictamente la siguiente organización de archivos y carpetas:

```text
proyecto-olist-automation/
│
├── main.py                    ⭐ Script principal (Punto de entrada ETL)
│
├── src/                       📦 Código fuente y lógica de negocio
│   ├── __init__.py
│   ├── olist_ETL.py          (Extracción, transformación y exportación)
│   └── config.py              (Carga de credenciales desde .env)
│
├── queries/                   📜 Consultas SQL organizadas por temática
│   ├── clientes_actividad.sql
│   ├── catalogo_productos.sql
│   └── entregas_retrasos.sql
│
├── output/                    📂 Datasets limpios generados automáticamente (CSVs)
│   ├── clientes_actividad.csv
│   └── ...
│
├── dashboard/                 📊 Capa de visualización final
│   └── Olist_Dashboard.xlsx   (Libro de Excel vinculado a los CSVs)
│
├── requirements.txt           (Dependencias de Python)
├── .env.example               (Plantilla de configuración de entorno)
├── .gitignore                 (Archivos excluidos de Git)
└── README.md                  (Documentación pública del repositorio)
```

---

## ⚙️ Instrucciones de Puesta en Marcha

### Paso 1: Configurar el Entorno Virtual y Dependencias
```bash
python -m venv .venv
source .venv/bin/activate  # En Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

### Paso 2: Configurar las Credenciales
Crea un archivo `.env` en la raíz del proyecto basándote en `.env.example`:
```env
DB_HOST=localhost
DB_USER=tu_usuario
DB_PASSWORD=tu_contraseña
DB_NAME=olist
DB_PORT=3306
```

### Paso 3: Ejecutar el Pipeline ETL
Ejecuta el script principal para conectar a MySQL, procesar las consultas y actualizar los archivos de salida:
```bash
python main.py
```

### Paso 4: Refrescar el Dashboard en Excel
Abre `dashboard/Olist_Dashboard.xlsx`, dirígete a la pestaña **Datos** de Excel y haz clic en **Actualizar todo** para volcar los nuevos datos en las tablas dinámicas y gráficos.

---

## ⚠️ Puntos Críticos a Evitar (Avisos Importantes)

* **Cuidado con el Grano:** Validar que los `JOINs` entre tablas relacionales no multipliquen artificialmente los valores monetarios. Revisa las agregaciones antes de exportar a CSV.
* **Seguridad de Credenciales:** Nunca subas el archivo `.env` con contraseñas reales a GitHub. Asegúrate de que figure en el `.gitignore`.
* **Rutas relativas:** Los scripts de Python deben utilizar rutas relativas (`os.path` o `pathlib`) para garantizar que la ejecución funcione independientemente de la máquina del evaluador.

---

## 📋 Criterios de Evaluación

* **Automatización funcional:** El script `main.py` se ejecuta de extremo a extremo sin errores y actualiza los CSVs de la carpeta `output/`.
* **Calidad de los datos:** Integridad del grano analítico y ausencia de duplicidades métricas.
* **Estructura y Mantenibilidad:** Cumplimiento estricto de la arquitectura de carpetas y uso correcto de entornos virtuales.
* **Documentación:** Un `README.md` claro que permita a cualquier compañero replicar el entorno y levantar el proyecto en menos de 5 minutos.
