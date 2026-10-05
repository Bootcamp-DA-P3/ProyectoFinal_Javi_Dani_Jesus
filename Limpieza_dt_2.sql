SELECT DISTINCT
    product_category_name,
    LOWER(TRIM(product_category_name)) AS categoria_normalizada
FROM products
WHERE product_category_name IS NOT NULL
ORDER BY product_category_name;

SELECT COUNT(*) AS categorias_diferentes
FROM (
    SELECT DISTINCT
        LOWER(TRIM(product_category_name)) AS categoria_normalizada
    FROM products
    WHERE product_category_name IS NOT NULL
) AS categorias;
# Para comprobar las categorías


SELECT COUNT(*) AS productos_sin_categoria
FROM products
WHERE product_category_name IS NULL;
# Productos sin categoría

UPDATE products
SET product_category_name = 'sin_categoria'
WHERE product_category_name IS NULL;
# Cambiar los NULL a "Sin categoria

SELECT COUNT(*) AS productos_sin_categoria
FROM products
WHERE product_category_name IS NULL;
# Comprobar si los NULL han cambiado

SELECT COUNT(*) AS productos_peso_incorrecto
FROM products
WHERE product_weight_g <= 0;
# Comprobar productos con peso incorrecto

DESCRIBE products;

ALTER TABLE products
ADD COLUMN observacion_peso VARCHAR(50);

UPDATE products
SET observacion_peso = 'peso_incorrecto'
WHERE product_id IN (
    '36ba42dd187055e1fbe943b2d11430ca',
    '8038040ee2a71048d4bdbbdc985b69ab',
    '81781c0fed9fe1ad6e8c81fca1e1cb08',
    'e673e90efa65a5409ff4196c038bb5af'
);

SELECT
    product_id,
    product_weight_g,
    observacion_peso
FROM products
WHERE observacion_peso = 'peso_incorrecto';
# Creamos una columna de observación para identificar pesos incorrectos

SELECT COUNT(*) AS productos_dimensiones_nulas
FROM products
WHERE product_length_cm IS NULL
   OR product_height_cm IS NULL
   OR product_width_cm IS NULL;
   # Comprobar dimensiones nulas

ALTER TABLE products
ADD COLUMN observacion_dimensiones VARCHAR(50);
# Crear columna observacióon dimensiones

UPDATE products
SET observacion_dimensiones = 'dimensiones_incompletas'
WHERE product_length_cm IS NULL
   OR product_height_cm IS NULL
   OR product_width_cm IS NULL;
   
   SELECT
    product_id,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM products
WHERE product_length_cm IS NULL
   OR product_height_cm IS NULL
   OR product_width_cm IS NULL;
   
   UPDATE products
SET observacion_dimensiones = 'dimensiones_incompletas'
WHERE product_id IN (
    '09ff539a621711667c43eba6a3bd8466',
    '5eb564652db742ff8f28759cd8d2652a'
);

SELECT
    product_id,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    observacion_dimensiones
FROM products
WHERE product_id IN (
    '09ff539a621711667c43eba6a3bd8466',
    '5eb564652db742ff8f28759cd8d2652a'
);
# Dos productos erroneos

SELECT DISTINCT
    p.product_category_name,
    ct.product_category_name_english
FROM products AS p
LEFT JOIN categoria_traduccion AS ct
    ON p.product_category_name = ct.product_category_name
WHERE ct.product_category_name_english IS NULL;

SELECT
    product_category_name,
    COUNT(*) AS numero_productos
FROM products
WHERE product_category_name IN (
    'pc_gamer',
    'portateis_cozinha_e_preparadores_de_alimentos',
    'sin_categoria'
)
GROUP BY product_category_name;

## TRADUCCION
SELECT
    p.product_id,
    p.product_category_name,
    ct.product_category_name_english AS categoria_ingles
FROM products AS p
LEFT JOIN categoria_traduccion AS ct
    ON p.product_category_name = ct.product_category_name;
    
    ALTER TABLE products
ADD COLUMN product_category_name_english VARCHAR(59);

DESCRIBE products;
SELECT
    p.product_category_name,
    ct.product_category_name_english
FROM products AS p
LEFT JOIN categoria_traduccion AS ct
    ON p.product_category_name = ct.product_category_name
GROUP BY
    p.product_category_name,
    ct.product_category_name_english
ORDER BY p.product_category_name;

UPDATE products AS p
INNER JOIN categoria_traduccion AS ct
    ON p.product_category_name = ct.product_category_name
SET p.product_category_name_english = ct.product_category_name_english
WHERE p.product_id IS NOT NULL;

SELECT
    oi.product_id
FROM order_items AS oi
LEFT JOIN products AS p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;