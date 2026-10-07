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