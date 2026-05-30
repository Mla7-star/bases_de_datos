--
-- Scripts de Update de la Base de Datos  - SGBD PostgreSQL
--
-- Update de las tablas
-- 


-- 4) Script de actualizacion (UPDATE)
-- Requisito: 3 actualizaciones de direccion en mercado y 3 de precio en producto

-- Verificacion inicial
SELECT id_mercado, nombre, ciudad, departamento, direccion
FROM mercado
ORDER BY id_mercado;

SELECT id_producto, nombre, precio_referencia
FROM producto
ORDER BY id_producto;

-- Tres actualizaciones de direccion en mercados
UPDATE mercado
SET direccion = 'Calle 10 # 20-30, Centro'
WHERE ciudad = 'Cali' AND departamento = 'Valle del Cauca';

UPDATE mercado
SET direccion = 'Carrera 7 # 45-12, Zona Norte'
WHERE ciudad = 'Palmira' AND departamento = 'Valle del Cauca';

UPDATE mercado
SET direccion = 'Avenida Principal # 100-50, Bodega 3'
WHERE ciudad = 'Cali' AND departamento = 'Valle del Cauca';

-- Tres actualizaciones de precio en productos
UPDATE producto
SET precio_referencia = 18500.00
WHERE nombre = 'Miel';

UPDATE producto
SET precio_referencia = 22300.00
WHERE nombre = 'Polen';

UPDATE producto
SET precio_referencia = 19990.00
WHERE nombre = 'Miel';

-- Verificacion final
SELECT id_mercado, nombre, ciudad, departamento, direccion
FROM mercado
ORDER BY id_mercado;

SELECT id_producto, nombre, precio_referencia
FROM producto
ORDER BY id_producto;
