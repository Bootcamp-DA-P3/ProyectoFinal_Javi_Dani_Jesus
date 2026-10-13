-- GRANO: una fila por línea de pedido
-- Se obtiene directamente de las tablas originales de Olist.

SELECT
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    o.order_purchase_timestamp,
    oi.price,
    oi.freight_value
FROM order_items AS oi
INNER JOIN orders AS o
    ON oi.order_id = o.order_id;
    