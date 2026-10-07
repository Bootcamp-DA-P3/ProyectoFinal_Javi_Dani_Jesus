

-- GRANO DECLARADO: una fila = un pedido entregado

SELECT

    -- Identificación del pedido y del cliente
    o.order_id,
    c.customer_unique_id,

    -- Estado y fechas del pedido
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    -- Información agregada de pagos
    p.payment_total,

    -- Valoración media del pedido
    r.review_score,

    -- Información geográfica del cliente
    c.customer_zip_code_prefix,
    LOWER(TRIM(c.customer_city)) AS customer_city,
    LOWER(TRIM(c.customer_state)) AS customer_state,
    g.latitude,
    g.longitude,

    -- Días que tardó el pedido en entregarse
    DATEDIFF(
        o.order_delivered_customer_date,
        o.order_purchase_timestamp
    ) AS delivery_days,

    -- 1 = entrega fuera de plazo / 0 = entrega a tiempo
    CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
        THEN 1
        ELSE 0
    END AS is_late

FROM orders o

-- Relacionamos cada pedido con su cliente
JOIN customers c
    ON o.customer_id = c.customer_id


-- =====================================================
-- PAGOS
-- Una fila por pedido
-- =====================================================
LEFT JOIN (
    SELECT
        order_id,
        SUM(payment_value) AS payment_total
    FROM order_payments
    WHERE payment_value > 0
    GROUP BY order_id
) p
    ON o.order_id = p.order_id


-- =====================================================
-- RESEÑAS
-- Una fila por pedido
-- =====================================================
LEFT JOIN (
    SELECT
        order_id,
        AVG(review_score) AS review_score
    FROM order_reviews
    GROUP BY order_id
) r
    ON o.order_id = r.order_id


-- =====================================================
-- GEOLOCALIZACIÓN
-- Una fila por código postal
-- =====================================================
LEFT JOIN (
    SELECT
        geolocation_zip_code_prefix,
        AVG(geolocation_lat) AS latitude,
        AVG(geolocation_lng) AS longitude
    FROM geolocation
    GROUP BY geolocation_zip_code_prefix
) g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix


-- =====================================================
-- LIMPIEZA PRELIMINAR
-- =====================================================
WHERE
    o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
    AND o.order_delivered_customer_date > o.order_purchase_timestamp
    AND p.payment_total > 0;