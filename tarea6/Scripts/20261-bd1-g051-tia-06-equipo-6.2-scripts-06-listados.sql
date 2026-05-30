--
-- Scripts de LISTADOS de la Base de Datos  - SGBD PostgreSQL
--
-- 


-- 6) Script de consultas de listados (SELECT)

-- Consulta #1: simple sin JOIN
-- Listar municipios del cuadro academico (anexo B) en orden alfabetico ascendente
SELECT DISTINCT ciudad AS municipio
FROM mercado
WHERE departamento IN (
    'Antioquia', 'Cundinamarca', 'Boyaca', 'Santander', 'Huila',
    'Meta', 'Cordoba', 'Sucre', 'Magdalena', 'Valle del Cauca'
)
ORDER BY municipio ASC;

-- Consulta #2: con 1 JOIN
-- Listar departamentos con sus municipios del anexo B
SELECT DISTINCT
    m.departamento,
    m.ciudad AS municipio
FROM mercado m
JOIN usuarios u ON u.id_mercado = m.id_mercado
WHERE m.departamento IN (
    'Antioquia', 'Cundinamarca', 'Boyaca', 'Santander', 'Huila',
    'Meta', 'Cordoba', 'Sucre', 'Magdalena', 'Valle del Cauca'
)
ORDER BY m.departamento ASC, m.ciudad ASC;

-- Consulta #3: con 2 JOIN
-- Listar municipios con sus apicultores y apiarios respectivos
SELECT
    m.departamento,
    m.ciudad AS municipio,
    (u.nombre || ' ' || u.apellido) AS apicultor,
    a.nombre AS apiario
FROM mercado m
JOIN usuarios u ON u.id_mercado = m.id_mercado
JOIN apiario a ON a.id_responsable = u.id_usuario
WHERE u.rol = 'APICULTOR'
    AND m.departamento IN (
            'Antioquia', 'Cundinamarca', 'Boyaca', 'Santander', 'Huila',
            'Meta', 'Cordoba', 'Sucre', 'Magdalena', 'Valle del Cauca'
    )
ORDER BY m.departamento, m.ciudad, apicultor, a.nombre;

-- Consulta #4: con 3 JOIN
-- Listar apicultores, apiarios y productos del anexo C
SELECT
    (u.nombre || ' ' || u.apellido) AS apicultor,
    a.nombre AS apiario,
    p.nombre AS producto
FROM usuarios u
JOIN apiario a ON a.id_responsable = u.id_usuario
JOIN apicultor_producto ap ON ap.id_usuario = u.id_usuario
JOIN producto p ON p.id_producto = ap.id_producto
WHERE u.rol = 'APICULTOR'
    AND p.nombre IN ('Miel', 'Polen', 'Propoleo', 'Jalea Real', 'Cera', 'Apitoxina')
ORDER BY apicultor, apiario, producto;

-- Consulta #5: con 3 JOIN
-- Pedidos de un municipio del anexo B (eleccion: Cali)
SELECT
    pe.fecha_solicitud,
    mc.ciudad AS municipio_pedido,
    (c.nombre || ' ' || c.apellido) AS consumidor,
    (pr.nombre || ' ' || pr.apellido) AS productor
FROM pedido pe
JOIN mercado mc ON mc.id_mercado = pe.id_mercado
JOIN usuarios c ON c.id_usuario = pe.id_comprador
JOIN pedido_lote pl ON pl.id_pedido = pe.id_pedido
JOIN lote l ON l.id_lote = pl.id_lote
JOIN publicacion pub ON pub.id_lote = l.id_lote
JOIN usuarios pr ON pr.id_usuario = pub.id_productor
WHERE mc.ciudad = 'Cali'
GROUP BY
    pe.fecha_solicitud,
    mc.ciudad,
    c.nombre,
    c.apellido,
    pr.nombre,
    pr.apellido
ORDER BY pe.fecha_solicitud ASC;
