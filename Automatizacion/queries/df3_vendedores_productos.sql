-- GRANO DECLARADO: una fila = un vendedor y una categoría

SELECT
    oi.seller_id AS vendedor,
    UPPER(TRIM(s.seller_state)) AS estado,
    LOWER(TRIM(p.product_category_name)) AS categoria,
    COUNT(*) AS ventas,
    COUNT(DISTINCT oi.product_id) AS productos_distintos,
    COUNT(DISTINCT oi.order_id) AS pedidos_atendidos
FROM order_items oi
JOIN sellers s
    ON oi.seller_id = s.seller_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY
    oi.seller_id,
    UPPER(TRIM(s.seller_state)),
    LOWER(TRIM(p.product_category_name))
ORDER BY ventas DESC;