
-- GRANO: una fila por línea de pedido

SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    order_purchase_timestamp,
    price,
    freight_value
FROM fact_ventas;