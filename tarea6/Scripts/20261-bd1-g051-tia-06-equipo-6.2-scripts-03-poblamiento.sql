--
-- Scripts de Poblamiento de la Base de Datos  - SGBD PostgreSQL
--
-- Todas las instrucciones se DEBEN EJECUTAR EN SECUENCIA SIN ERRORES
-- NOTA: Ojo con los insert en tablas relacionadas. Primero las independientes y después las dependientes
--

--
-- Poblamiento de las tablas según Anexo B
-- 


BEGIN;

-- ======================
-- Datos base (incluye ciudades y productos de anexos)
-- Basado en cuadro Departamento-Municipios de Apiarios
-- ======================

INSERT INTO producto (nombre, categoria, unidad_medida, precio_referencia, codigo_referencia, descripcion, activo)
VALUES
    ('Miel', 'Derivado Apicola', '1 kg', 25000, 100, 'Producto cargado desde cuadro academico', TRUE),
    ('Polen', 'Derivado Apicola', '250 g', 20000, 200, 'Producto cargado desde cuadro academico', TRUE),
    ('Propoleo', 'Derivado Apicola', '30 ml (extracto)', 35000, 300, 'Producto cargado desde cuadro academico', TRUE),
    ('Jalea Real', 'Derivado Apicola', '10-20 g', 40000, 400, 'Producto cargado desde cuadro academico', TRUE),
    ('Cera', 'Derivado Apicola', '1 kg', 30000, 500, 'Producto cargado desde cuadro academico', TRUE),
    ('Apitoxina', 'Derivado Apicola', '1 g', 300000, 600, 'Producto cargado desde cuadro academico', TRUE);

WITH muni_plan AS (
    SELECT *
    FROM (VALUES
        ('Antioquia', 'Caucasia', 5, 2, 3, 50),
        ('Antioquia', 'El Bagre', 5, 2, 3, 50),
        ('Antioquia', 'Zaragoza', 5, 2, 3, 50),
        ('Antioquia', 'Santa Fe de Antioquia', 5, 3, 5, 50),
        ('Antioquia', 'Medellin (Santa Elena)', 5, 5, 10, 100),
        ('Cundinamarca', 'Fusagasuga', 5, 3, 5, 50),
        ('Cundinamarca', 'Girardot', 5, 2, 5, 50),
        ('Cundinamarca', 'Ubate', 5, 3, 3, 50),
        ('Cundinamarca', 'Zipaquira', 5, 3, 5, 50),
        ('Cundinamarca', 'La Mesa', 5, 1, 3, 50),
        ('Boyaca', 'Tunja', 5, 4, 10, 50),
        ('Boyaca', 'Duitama', 5, 3, 3, 50),
        ('Boyaca', 'Sogamoso', 5, 2, 5, 50),
        ('Boyaca', 'Chiquinquira', 5, 1, 3, 50),
        ('Boyaca', 'Paipa', 5, 1, 3, 50),
        ('Santander', 'Bucaramanga', 4, 4, 8, 50),
        ('Santander', 'San Gil', 4, 1, 3, 50),
        ('Santander', 'Socorro', 4, 2, 3, 50),
        ('Santander', 'Barbosa', 4, 1, 3, 50),
        ('Huila', 'Neiva', 4, 4, 10, 50),
        ('Huila', 'Pitalito', 4, 1, 3, 50),
        ('Huila', 'Garzon', 4, 2, 3, 50),
        ('Huila', 'La Plata', 4, 2, 3, 50),
        ('Meta', 'Villavicencio', 3, 4, 9, 50),
        ('Meta', 'Granada', 3, 2, 3, 50),
        ('Meta', 'Acacias', 3, 3, 3, 50),
        ('Cordoba', 'Monteria', 3, 3, 8, 50),
        ('Cordoba', 'Planeta Rica', 3, 1, 3, 50),
        ('Cordoba', 'Sahagun', 3, 1, 3, 50),
        ('Sucre', 'Sincelejo', 3, 3, 9, 50),
        ('Sucre', 'Corozal', 3, 3, 6, 50),
        ('Sucre', 'Sampues', 3, 1, 3, 50),
        ('Magdalena', 'Santa Marta', 3, 4, 9, 50),
        ('Magdalena', 'Cienaga', 3, 3, 5, 50),
        ('Magdalena', 'Fundacion', 3, 3, 5, 50),
        ('Valle del Cauca', 'Cali', 4, 5, 8, 50),
        ('Valle del Cauca', 'Palmira', 4, 3, 6, 50),
        ('Valle del Cauca', 'Buga', 4, 3, 7, 50),
        ('Valle del Cauca', 'Tulua', 4, 4, 8, 50)
    ) AS t(departamento, municipio, total_municipios, productores, apiarios, consumidores)
)
INSERT INTO organizacion (nombre, tipo, nit, ciudad, fecha_registro)
SELECT
    'Cooperativa ' || d.departamento,
    'Cooperativa',
    'NIT-' || LPAD(ROW_NUMBER() OVER (ORDER BY d.departamento)::text, 6, '0'),
    MIN(d.municipio),
    CURRENT_DATE
FROM (SELECT DISTINCT departamento, municipio FROM muni_plan) d
GROUP BY d.departamento;

WITH muni_plan AS (
    SELECT *
    FROM (VALUES
        ('Antioquia', 'Caucasia', 5, 2, 3, 50),
        ('Antioquia', 'El Bagre', 5, 2, 3, 50),
        ('Antioquia', 'Zaragoza', 5, 2, 3, 50),
        ('Antioquia', 'Santa Fe de Antioquia', 5, 3, 5, 50),
        ('Antioquia', 'Medellin (Santa Elena)', 5, 5, 10, 100),
        ('Cundinamarca', 'Fusagasuga', 5, 3, 5, 50),
        ('Cundinamarca', 'Girardot', 5, 2, 5, 50),
        ('Cundinamarca', 'Ubate', 5, 3, 3, 50),
        ('Cundinamarca', 'Zipaquira', 5, 3, 5, 50),
        ('Cundinamarca', 'La Mesa', 5, 1, 3, 50),
        ('Boyaca', 'Tunja', 5, 4, 10, 50),
        ('Boyaca', 'Duitama', 5, 3, 3, 50),
        ('Boyaca', 'Sogamoso', 5, 2, 5, 50),
        ('Boyaca', 'Chiquinquira', 5, 1, 3, 50),
        ('Boyaca', 'Paipa', 5, 1, 3, 50),
        ('Santander', 'Bucaramanga', 4, 4, 8, 50),
        ('Santander', 'San Gil', 4, 1, 3, 50),
        ('Santander', 'Socorro', 4, 2, 3, 50),
        ('Santander', 'Barbosa', 4, 1, 3, 50),
        ('Huila', 'Neiva', 4, 4, 10, 50),
        ('Huila', 'Pitalito', 4, 1, 3, 50),
        ('Huila', 'Garzon', 4, 2, 3, 50),
        ('Huila', 'La Plata', 4, 2, 3, 50),
        ('Meta', 'Villavicencio', 3, 4, 9, 50),
        ('Meta', 'Granada', 3, 2, 3, 50),
        ('Meta', 'Acacias', 3, 3, 3, 50),
        ('Cordoba', 'Monteria', 3, 3, 8, 50),
        ('Cordoba', 'Planeta Rica', 3, 1, 3, 50),
        ('Cordoba', 'Sahagun', 3, 1, 3, 50),
        ('Sucre', 'Sincelejo', 3, 3, 9, 50),
        ('Sucre', 'Corozal', 3, 3, 6, 50),
        ('Sucre', 'Sampues', 3, 1, 3, 50),
        ('Magdalena', 'Santa Marta', 3, 4, 9, 50),
        ('Magdalena', 'Cienaga', 3, 3, 5, 50),
        ('Magdalena', 'Fundacion', 3, 3, 5, 50),
        ('Valle del Cauca', 'Cali', 4, 5, 8, 50),
        ('Valle del Cauca', 'Palmira', 4, 3, 6, 50),
        ('Valle del Cauca', 'Buga', 4, 3, 7, 50),
        ('Valle del Cauca', 'Tulua', 4, 4, 8, 50)
    ) AS t(departamento, municipio, total_municipios, productores, apiarios, consumidores)
)
INSERT INTO mercado (nombre, ciudad, departamento, direccion, tipo_mercado, activo)
SELECT
    'Mercado ' || m.municipio,
    m.municipio,
    m.departamento,
    'Zona Comercial ' || m.municipio,
    'Regional',
    TRUE
FROM muni_plan m;

WITH muni_plan AS (
    SELECT *
    FROM (VALUES
        ('Antioquia', 'Caucasia', 2, 50),
        ('Antioquia', 'El Bagre', 2, 50),
        ('Antioquia', 'Zaragoza', 2, 50),
        ('Antioquia', 'Santa Fe de Antioquia', 3, 50),
        ('Antioquia', 'Medellin (Santa Elena)', 5, 100),
        ('Cundinamarca', 'Fusagasuga', 3, 50),
        ('Cundinamarca', 'Girardot', 2, 50),
        ('Cundinamarca', 'Ubate', 3, 50),
        ('Cundinamarca', 'Zipaquira', 3, 50),
        ('Cundinamarca', 'La Mesa', 1, 50),
        ('Boyaca', 'Tunja', 4, 50),
        ('Boyaca', 'Duitama', 3, 50),
        ('Boyaca', 'Sogamoso', 2, 50),
        ('Boyaca', 'Chiquinquira', 1, 50),
        ('Boyaca', 'Paipa', 1, 50),
        ('Santander', 'Bucaramanga', 4, 50),
        ('Santander', 'San Gil', 1, 50),
        ('Santander', 'Socorro', 2, 50),
        ('Santander', 'Barbosa', 1, 50),
        ('Huila', 'Neiva', 4, 50),
        ('Huila', 'Pitalito', 1, 50),
        ('Huila', 'Garzon', 2, 50),
        ('Huila', 'La Plata', 2, 50),
        ('Meta', 'Villavicencio', 4, 50),
        ('Meta', 'Granada', 2, 50),
        ('Meta', 'Acacias', 3, 50),
        ('Cordoba', 'Monteria', 3, 50),
        ('Cordoba', 'Planeta Rica', 1, 50),
        ('Cordoba', 'Sahagun', 1, 50),
        ('Sucre', 'Sincelejo', 3, 50),
        ('Sucre', 'Corozal', 3, 50),
        ('Sucre', 'Sampues', 1, 50),
        ('Magdalena', 'Santa Marta', 4, 50),
        ('Magdalena', 'Cienaga', 3, 50),
        ('Magdalena', 'Fundacion', 3, 50),
        ('Valle del Cauca', 'Cali', 5, 50),
        ('Valle del Cauca', 'Palmira', 3, 50),
        ('Valle del Cauca', 'Buga', 3, 50),
        ('Valle del Cauca', 'Tulua', 4, 50)
    ) AS t(departamento, municipio, productores, consumidores)
)
INSERT INTO usuarios (id_organizacion, id_mercado, nombre, apellido, email, telefono, rol, fecha_registro, activo)
SELECT
    o.id_organizacion,
    m.id_mercado,
    'Prod' || gs,
    REPLACE(mp.municipio, ' ', ''),
    'prod_' || m.id_mercado || '_' || gs || '@apicola.test',
    '31' || LPAD((m.id_mercado * 100 + gs)::text, 8, '0'),
    'APICULTOR',
    CURRENT_DATE - ((m.id_mercado + gs) || ' days')::interval,
    TRUE
FROM muni_plan mp
JOIN mercado m ON m.ciudad = mp.municipio AND m.departamento = mp.departamento
JOIN organizacion o ON o.nombre = 'Cooperativa ' || mp.departamento
JOIN generate_series(1, 100) gs ON gs <= mp.productores;

WITH muni_plan AS (
    SELECT *
    FROM (VALUES
        ('Antioquia', 'Caucasia', 50),
        ('Antioquia', 'El Bagre', 50),
        ('Antioquia', 'Zaragoza', 50),
        ('Antioquia', 'Santa Fe de Antioquia', 50),
        ('Antioquia', 'Medellin (Santa Elena)', 100),
        ('Cundinamarca', 'Fusagasuga', 50),
        ('Cundinamarca', 'Girardot', 50),
        ('Cundinamarca', 'Ubate', 50),
        ('Cundinamarca', 'Zipaquira', 50),
        ('Cundinamarca', 'La Mesa', 50),
        ('Boyaca', 'Tunja', 50),
        ('Boyaca', 'Duitama', 50),
        ('Boyaca', 'Sogamoso', 50),
        ('Boyaca', 'Chiquinquira', 50),
        ('Boyaca', 'Paipa', 50),
        ('Santander', 'Bucaramanga', 50),
        ('Santander', 'San Gil', 50),
        ('Santander', 'Socorro', 50),
        ('Santander', 'Barbosa', 50),
        ('Huila', 'Neiva', 50),
        ('Huila', 'Pitalito', 50),
        ('Huila', 'Garzon', 50),
        ('Huila', 'La Plata', 50),
        ('Meta', 'Villavicencio', 50),
        ('Meta', 'Granada', 50),
        ('Meta', 'Acacias', 50),
        ('Cordoba', 'Monteria', 50),
        ('Cordoba', 'Planeta Rica', 50),
        ('Cordoba', 'Sahagun', 50),
        ('Sucre', 'Sincelejo', 50),
        ('Sucre', 'Corozal', 50),
        ('Sucre', 'Sampues', 50),
        ('Magdalena', 'Santa Marta', 50),
        ('Magdalena', 'Cienaga', 50),
        ('Magdalena', 'Fundacion', 50),
        ('Valle del Cauca', 'Cali', 50),
        ('Valle del Cauca', 'Palmira', 50),
        ('Valle del Cauca', 'Buga', 50),
        ('Valle del Cauca', 'Tulua', 50)
    ) AS t(departamento, municipio, consumidores)
)
INSERT INTO usuarios (id_organizacion, id_mercado, nombre, apellido, email, telefono, rol, fecha_registro, activo)
SELECT
    o.id_organizacion,
    m.id_mercado,
    'Cons' || gs,
    REPLACE(mp.municipio, ' ', ''),
    'cons_' || m.id_mercado || '_' || gs || '@apicola.test',
    '32' || LPAD((m.id_mercado * 100 + gs)::text, 8, '0'),
    'COMPRADOR',
    CURRENT_DATE - ((m.id_mercado + gs) || ' days')::interval,
    TRUE
FROM muni_plan mp
JOIN mercado m ON m.ciudad = mp.municipio AND m.departamento = mp.departamento
JOIN organizacion o ON o.nombre = 'Cooperativa ' || mp.departamento
JOIN generate_series(1, 100) gs ON gs <= mp.consumidores;

INSERT INTO usuarios (id_organizacion, id_mercado, nombre, apellido, email, telefono, rol, fecha_registro, activo)
SELECT
    o.id_organizacion,
    m.id_mercado,
    'Admin',
    REPLACE(m.ciudad, ' ', ''),
    'admin_' || m.id_mercado || '@apicola.test',
    '33' || LPAD(m.id_mercado::text, 8, '0'),
    'ADMIN',
    CURRENT_DATE,
    TRUE
FROM mercado m
JOIN organizacion o ON o.nombre = 'Cooperativa ' || m.departamento;

WITH muni_plan AS (
    SELECT *
    FROM (VALUES
        ('Antioquia', 'Caucasia', 3),
        ('Antioquia', 'El Bagre', 3),
        ('Antioquia', 'Zaragoza', 3),
        ('Antioquia', 'Santa Fe de Antioquia', 5),
        ('Antioquia', 'Medellin (Santa Elena)', 10),
        ('Cundinamarca', 'Fusagasuga', 5),
        ('Cundinamarca', 'Girardot', 5),
        ('Cundinamarca', 'Ubate', 3),
        ('Cundinamarca', 'Zipaquira', 5),
        ('Cundinamarca', 'La Mesa', 3),
        ('Boyaca', 'Tunja', 10),
        ('Boyaca', 'Duitama', 3),
        ('Boyaca', 'Sogamoso', 5),
        ('Boyaca', 'Chiquinquira', 3),
        ('Boyaca', 'Paipa', 3),
        ('Santander', 'Bucaramanga', 8),
        ('Santander', 'San Gil', 3),
        ('Santander', 'Socorro', 3),
        ('Santander', 'Barbosa', 3),
        ('Huila', 'Neiva', 10),
        ('Huila', 'Pitalito', 3),
        ('Huila', 'Garzon', 3),
        ('Huila', 'La Plata', 3),
        ('Meta', 'Villavicencio', 9),
        ('Meta', 'Granada', 3),
        ('Meta', 'Acacias', 3),
        ('Cordoba', 'Monteria', 8),
        ('Cordoba', 'Planeta Rica', 3),
        ('Cordoba', 'Sahagun', 3),
        ('Sucre', 'Sincelejo', 9),
        ('Sucre', 'Corozal', 6),
        ('Sucre', 'Sampues', 3),
        ('Magdalena', 'Santa Marta', 9),
        ('Magdalena', 'Cienaga', 5),
        ('Magdalena', 'Fundacion', 5),
        ('Valle del Cauca', 'Cali', 8),
        ('Valle del Cauca', 'Palmira', 6),
        ('Valle del Cauca', 'Buga', 7),
        ('Valle del Cauca', 'Tulua', 8)
    ) AS t(departamento, municipio, apiarios)
), productores AS (
    SELECT
        u.id_usuario,
        u.id_mercado,
        ROW_NUMBER() OVER (PARTITION BY u.id_mercado ORDER BY u.id_usuario) AS rn,
        COUNT(*) OVER (PARTITION BY u.id_mercado) AS cnt
    FROM usuarios u
    WHERE u.rol = 'APICULTOR'
)
INSERT INTO apiario (id_organizacion, id_responsable, id_mercado, nombre, latitud, longitud, altitud_msnm, fecha_registro, estado)
SELECT
    o.id_organizacion,
    p.id_usuario,
    m.id_mercado,
    'Apiario ' || m.ciudad || ' ' || gs,
    (4.100000 + (m.id_mercado * 0.003) + (gs * 0.0001))::numeric(9,6),
    (-74.100000 - (m.id_mercado * 0.003) - (gs * 0.0001))::numeric(9,6),
    1000 + m.id_mercado + gs,
    CURRENT_DATE - ((m.id_mercado + gs) || ' days')::interval,
    'ACTIVO'
FROM muni_plan mp
JOIN mercado m ON m.ciudad = mp.municipio AND m.departamento = mp.departamento
JOIN organizacion o ON o.nombre = 'Cooperativa ' || m.departamento
JOIN generate_series(1, 20) gs ON gs <= mp.apiarios
JOIN productores p ON p.id_mercado = m.id_mercado
    AND p.rn = ((gs - 1) % p.cnt) + 1;

INSERT INTO colmena (id_apiario, codigo, id_producto_principal, tipo, fecha_instalacion, estado)
SELECT
    a.id_apiario,
    'COL-' || LPAD(a.id_apiario::text, 6, '0'),
    ((a.id_apiario - 1) % 6) + 1,
    CASE WHEN a.id_apiario % 2 = 0 THEN 'Langstroth' ELSE 'TopBar' END,
    CURRENT_DATE - ((30 + (a.id_apiario % 20)) || ' days')::interval,
    'OPERATIVA'
FROM apiario a;

INSERT INTO sensor (id_apiario, id_colmena, codigo_serie, tipo_sensor, unidad, fecha_instalacion, estado)
SELECT
    c.id_apiario,
    c.id_colmena,
    'SNS-' || LPAD(c.id_colmena::text, 6, '0'),
    CASE c.id_colmena % 3 WHEN 0 THEN 'Temperatura' WHEN 1 THEN 'Humedad' ELSE 'Peso' END,
    CASE c.id_colmena % 3 WHEN 0 THEN 'C' WHEN 1 THEN '%' ELSE 'kg' END,
    CURRENT_DATE - ((20 + (c.id_colmena % 15)) || ' days')::interval,
    'ACTIVO'
FROM colmena c;

INSERT INTO cosecha (id_colmena, id_producto, fecha_cosecha, cantidad, unidad, humedad_pct, observaciones)
SELECT
    c.id_colmena,
    c.id_producto_principal,
    CURRENT_DATE - ((10 + (c.id_colmena % 12)) || ' days')::interval,
    (18 + (c.id_colmena % 9) * 1.7)::numeric(10,2),
    'kg',
    (16 + (c.id_colmena % 4) * 0.8)::numeric(5,2),
    'Cosecha municipio ' || m.ciudad
FROM colmena c
JOIN apiario a ON a.id_apiario = c.id_apiario
JOIN mercado m ON m.id_mercado = a.id_mercado;

INSERT INTO lote (id_cosecha, id_producto, id_apiario, codigo_lote, fecha_produccion, fecha_vencimiento, cantidad_disponible, estado_calidad)
SELECT
    co.id_cosecha,
    co.id_producto,
    c.id_apiario,
    'LOT-' || TO_CHAR(CURRENT_DATE, 'YYYY') || '-' || LPAD(co.id_cosecha::text, 6, '0'),
    co.fecha_cosecha,
    co.fecha_cosecha + INTERVAL '365 days',
    (co.cantidad * 0.85)::numeric(10,2),
    'APROBADO'
FROM cosecha co
JOIN colmena c ON c.id_colmena = co.id_colmena;

INSERT INTO apicultor_producto (id_usuario, id_producto, capacidad_mensual, unidad, experiencia_anios, activo)
SELECT DISTINCT
    a.id_responsable,
    l.id_producto,
    60,
    p.unidad_medida,
    3 + (a.id_responsable % 7),
    TRUE
FROM lote l
JOIN apiario a ON a.id_apiario = l.id_apiario
JOIN producto p ON p.id_producto = l.id_producto
ON CONFLICT (id_usuario, id_producto) DO NOTHING;

INSERT INTO lectura_sensor (id_sensor, fecha_lectura, data, alerta)
SELECT
    s.id_sensor,
    NOW() - ((s.id_sensor % 24) || ' hours')::interval,
    jsonb_build_object(
        'temperatura', (28 + (s.id_sensor % 7) * 0.6)::numeric(5,2),
        'humedad', (52 + (s.id_sensor % 10) * 0.9)::numeric(5,2),
        'peso', (24 + (s.id_sensor % 8) * 0.7)::numeric(6,2),
        'bateria', (95 - (s.id_sensor % 30))
    ),
    (s.id_sensor % 11 = 0)
FROM sensor s;

INSERT INTO control (id_colmena, id_usuario_responsable, fecha_control, tipo_control, diagnostico, tratamiento, observaciones)
SELECT
    c.id_colmena,
    a.id_responsable,
    CURRENT_DATE - ((c.id_colmena % 20) || ' days')::interval,
    CASE WHEN c.id_colmena % 2 = 0 THEN 'Sanitario' ELSE 'Preventivo' END,
    CASE WHEN c.id_colmena % 9 = 0 THEN 'Varroa leve' ELSE 'Sin novedades' END,
    CASE WHEN c.id_colmena % 9 = 0 THEN 'Tratamiento organico' ELSE 'No aplica' END,
    'Control programado'
FROM colmena c
JOIN apiario a ON a.id_apiario = c.id_apiario;

INSERT INTO publicacion (id_lote, id_productor, id_mercado, precio_unitario, moneda, estado, fecha_publicacion)
SELECT
    l.id_lote,
    a.id_responsable,
    a.id_mercado,
    COALESCE(p.precio_referencia, 25000),
    'COP',
    'ACTIVA',
    CURRENT_DATE - ((l.id_lote % 15) || ' days')::interval
FROM lote l
JOIN apiario a ON a.id_apiario = l.id_apiario
JOIN producto p ON p.id_producto = l.id_producto;

INSERT INTO pedido (id_comprador, id_mercado, fecha_solicitud, estado, total_estimado)
SELECT
    u.id_usuario,
    u.id_mercado,
    NOW() - ((ROW_NUMBER() OVER (ORDER BY u.id_usuario) % 72) || ' hours')::interval,
    CASE ROW_NUMBER() OVER (ORDER BY u.id_usuario) % 4
        WHEN 0 THEN 'NUEVO'
        WHEN 1 THEN 'PAGADO'
        WHEN 2 THEN 'DESPACHADO'
        ELSE 'ENTREGADO'
    END,
    0
FROM usuarios u
WHERE u.rol = 'COMPRADOR';

WITH pub_mercado AS (
    SELECT id_mercado, MIN(id_publicacion) AS id_publicacion
    FROM publicacion
    GROUP BY id_mercado
)
INSERT INTO pedido_lote (id_pedido, id_lote, cantidad, precio_unitario, subtotal)
SELECT
    pe.id_pedido,
    pu.id_lote,
    (1 + (pe.id_pedido % 4))::numeric(10,2) AS cantidad,
    pu.precio_unitario,
    ((1 + (pe.id_pedido % 4)) * pu.precio_unitario)::numeric(12,2) AS subtotal
FROM pedido pe
JOIN pub_mercado pm ON pm.id_mercado = pe.id_mercado
JOIN publicacion pu ON pu.id_publicacion = pm.id_publicacion;

UPDATE pedido pe
SET total_estimado = x.total
FROM (
    SELECT id_pedido, SUM(subtotal)::numeric(12,2) AS total
    FROM pedido_lote
    GROUP BY id_pedido
) x
WHERE x.id_pedido = pe.id_pedido;

INSERT INTO pago (id_pedido, id_pagador, fecha_pago, monto, metodo, estado, referencia)
SELECT
    pe.id_pedido,
    pe.id_comprador,
    pe.fecha_solicitud + INTERVAL '2 hours',
    pe.total_estimado,
    CASE pe.id_pedido % 3 WHEN 0 THEN 'Transferencia' WHEN 1 THEN 'Tarjeta' ELSE 'PSE' END,
    CASE WHEN pe.estado IN ('PAGADO', 'DESPACHADO', 'ENTREGADO') THEN 'APROBADO' ELSE 'PENDIENTE' END,
    'PAY-' || TO_CHAR(CURRENT_DATE, 'YYYYMMDD') || '-' || LPAD(pe.id_pedido::text, 8, '0')
FROM pedido pe;

INSERT INTO envio (id_pedido, id_destinatario, direccion, ciudad, transportadora, guia, estado, fecha_envio, fecha_entrega_estimada)
SELECT
    pe.id_pedido,
    pe.id_comprador,
    COALESCE(m.direccion, 'Direccion principal ' || m.ciudad),
    m.ciudad,
    CASE pe.id_pedido % 3 WHEN 0 THEN 'ServiEntrega' WHEN 1 THEN 'RapidoExpress' ELSE 'EnviosNacionales' END,
    'GUIA-' || LPAD(pe.id_pedido::text, 8, '0'),
    CASE pe.estado
        WHEN 'DESPACHADO' THEN 'EN_TRANSITO'
        WHEN 'ENTREGADO' THEN 'ENTREGADO'
        ELSE 'PREPARACION'
    END,
    CURRENT_DATE - ((pe.id_pedido % 5) || ' days')::interval,
    CURRENT_DATE + ((2 + (pe.id_pedido % 3)) || ' days')::interval
FROM pedido pe
JOIN mercado m ON m.id_mercado = pe.id_mercado;

INSERT INTO documento (id_usuario, id_apiario, id_lote, tipo_documento, nombre_archivo, url_documento, fecha_emision, fecha_vencimiento, estado)
SELECT
    a.id_responsable,
    a.id_apiario,
    l.id_lote,
    'Certificacion',
    'cert_' || LPAD(l.id_lote::text, 6, '0') || '.pdf',
    'https://mock.apicola.local/documentos/cert_' || LPAD(l.id_lote::text, 6, '0') || '.pdf',
    CURRENT_DATE - ((l.id_lote % 40) || ' days')::interval,
    CURRENT_DATE + INTERVAL '365 days',
    'VIGENTE'
FROM lote l
JOIN apiario a ON a.id_apiario = l.id_apiario
WHERE l.id_lote <= 100;

INSERT INTO actividad_comunidad (id_usuario, id_organizacion, titulo, descripcion, tipo_actividad, fecha_publicacion, fecha_evento, estado)
SELECT
    u.id_usuario,
    u.id_organizacion,
    'Actividad ' || u.id_usuario,
    'Actividad comunitaria en ' || m.ciudad,
    CASE u.id_usuario % 3 WHEN 0 THEN 'Evento' WHEN 1 THEN 'Capacitacion' ELSE 'Anuncio' END,
    NOW() - ((u.id_usuario % 48) || ' hours')::interval,
    CURRENT_DATE + ((u.id_usuario % 20) || ' days')::interval,
    'PUBLICADA'
FROM usuarios u
JOIN mercado m ON m.id_mercado = u.id_mercado
WHERE u.rol = 'APICULTOR'
  AND u.id_usuario <= 120;

INSERT INTO obligacion (id_usuario, id_organizacion, tipo_obligacion, descripcion, fecha_inicio, fecha_fin, estado)
SELECT
    u.id_usuario,
    u.id_organizacion,
    CASE u.id_usuario % 4 WHEN 0 THEN 'Aporte' WHEN 1 THEN 'Asistencia' WHEN 2 THEN 'Reporte' ELSE 'Capacitacion' END,
    'Obligacion activa para productor ' || u.id_usuario,
    CURRENT_DATE - ((u.id_usuario % 30) || ' days')::interval,
    CURRENT_DATE + ((30 + (u.id_usuario % 30)) || ' days')::interval,
    'ACTIVA'
FROM usuarios u
WHERE u.rol = 'APICULTOR';

COMMIT;

-- Verificacion rapida (opcional):
 SELECT 'producto' AS tabla, COUNT(*) AS registros FROM producto
 UNION ALL SELECT 'mercado', COUNT(*) FROM mercado
 UNION ALL SELECT 'organizacion', COUNT(*) FROM organizacion
 UNION ALL SELECT 'usuarios', COUNT(*) FROM usuarios
 UNION ALL SELECT 'apiario', COUNT(*) FROM apiario
 UNION ALL SELECT 'colmena', COUNT(*) FROM colmena
 UNION ALL SELECT 'sensor', COUNT(*) FROM sensor
 UNION ALL SELECT 'cosecha', COUNT(*) FROM cosecha
 UNION ALL SELECT 'lote', COUNT(*) FROM lote
 UNION ALL SELECT 'apicultor_producto', COUNT(*) FROM apicultor_producto
 UNION ALL SELECT 'lectura_sensor', COUNT(*) FROM lectura_sensor
 UNION ALL SELECT 'control', COUNT(*) FROM control
 UNION ALL SELECT 'publicacion', COUNT(*) FROM publicacion
 UNION ALL SELECT 'pedido', COUNT(*) FROM pedido
 UNION ALL SELECT 'pedido_lote', COUNT(*) FROM pedido_lote
 UNION ALL SELECT 'pago', COUNT(*) FROM pago
 UNION ALL SELECT 'envio', COUNT(*) FROM envio
 UNION ALL SELECT 'documento', COUNT(*) FROM documento
 UNION ALL SELECT 'actividad_comunidad', COUNT(*) FROM actividad_comunidad
 UNION ALL SELECT 'obligacion', COUNT(*) FROM obligacion;
