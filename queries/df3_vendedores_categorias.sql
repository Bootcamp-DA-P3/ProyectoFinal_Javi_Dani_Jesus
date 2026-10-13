SELECT * FROM sellers;
SELECT * FROM order_items;
SELECT * FROM products;

-- Ver qué y cuántos productos vende cada vendedor

SELECT
    oi.seller_id,
    p.product_category_name,
    COUNT(*) AS ventas
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY oi.seller_id, p.product_category_name
ORDER BY ventas DESC;

-- Cuántos productos distintos tiene cada vendedor

SELECT
    seller_id,
    COUNT(DISTINCT product_id) AS productos_distintos
FROM order_items
GROUP BY seller_id
ORDER BY productos_distintos DESC;

-- Frecuencia de ventas de cada producto por vendedor

SELECT
    oi.seller_id,
    oi.product_id,
    COUNT(*) AS veces_vendido
FROM order_items oi
GROUP BY
    oi.seller_id,
    oi.product_id
ORDER BY veces_vendido DESC;

-- Identificar qué vendedores concentran las ventas

SELECT 
seller_id,
COUNT(*) AS total_ventas
FROM order_items
GROUP BY seller_id
ORDER BY total_ventas DESC
LIMIT 20;


-- Vendedores ordenados por categoría de producto y número de ventas

    
SELECT
    oi.seller_id,
    p.product_id,
    s.seller_state,
    p.product_category_name,
    COUNT(*) AS ventas
FROM order_items oi
JOIN sellers s 
ON oi.seller_id = s.seller_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    oi.seller_id,
    p.product_id,
    s.seller_state,
    p.product_category_name
ORDER BY ventas DESC;

-- Limpieza: normalización de seller_state con UPPER(TRIM()) y
-- eliminación de productos sin categoría asignada (product_category_name IS NOT NULL).

SELECT
    oi.seller_id AS vendedor,
    oi.product_id AS producto,
    UPPER(TRIM(s.seller_state)) AS estado,
    p.product_category_name AS categoria,
    COUNT(*) AS ventas
FROM order_items oi
JOIN sellers s
    ON oi.seller_id = s.seller_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY
    oi.seller_id,
    oi.product_id,
    estado,
    p.product_category_name
ORDER BY ventas DESC;

-- Consulta final -- 

SELECT
    oi.seller_id AS vendedor,
    UPPER(TRIM(s.seller_state)) AS estado,
    p.product_category_name AS categoria,
    COUNT(*) AS ventas
FROM order_items oi
JOIN sellers s
    ON oi.seller_id = s.seller_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY
    oi.seller_id,
    UPPER(TRIM(s.seller_state)),
    p.product_category_name
ORDER BY ventas DESC; 



-- Mejora de la última ---

WITH ventas_categoria AS (
    SELECT
        oi.seller_id AS vendedor,
        UPPER(TRIM(s.seller_state)) AS estado,
        p.product_category_name AS categoria,
        COUNT(*) AS ventas
    FROM order_items oi
    JOIN sellers s
        ON oi.seller_id = s.seller_id
    JOIN products p
        ON oi.product_id = p.product_id
    WHERE p.product_category_name IS NOT NULL
    GROUP BY
        oi.seller_id,
        UPPER(TRIM(s.seller_state)),
        p.product_category_name
)
SELECT *,
       SUM(ventas) OVER(PARTITION BY vendedor) AS ventas_totales_vendedor
FROM ventas_categoria
ORDER BY
       ventas_totales_vendedor DESC,
       vendedor,
       ventas DESC;




-- Mejora 2 --

WITH ventas_categoria AS (
    SELECT
        oi.seller_id AS vendedor,
        UPPER(TRIM(s.seller_state)) AS estado,
        p.product_category_name AS categoria,
        COUNT(*) AS ventas
    FROM order_items oi
    JOIN sellers s
        ON oi.seller_id = s.seller_id
    JOIN products p
        ON oi.product_id = p.product_id
    WHERE p.product_category_name IS NOT NULL
    GROUP BY
        oi.seller_id,
        UPPER(TRIM(s.seller_state)),
        p.product_category_name
)

SELECT
    vendedor,
    estado,
    categoria,
    ventas,

    SUM(ventas) OVER (
        PARTITION BY vendedor
    ) AS ventas_totales_vendedor,

    COUNT(*) OVER (
        PARTITION BY vendedor
    ) AS num_categorias,

    ROW_NUMBER() OVER (
        PARTITION BY vendedor
        ORDER BY ventas DESC
    ) AS ranking_categoria,

    ROUND(
        100.0 * ventas /
        SUM(ventas) OVER (PARTITION BY vendedor),
        2
    ) AS porcentaje_vendedor

FROM ventas_categoria

ORDER BY
    ventas_totales_vendedor DESC,
    vendedor,
    ventas DESC;
