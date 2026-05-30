--
-- Scripts de AGRUPAMIENTOS de la Base de Datos  - SGBD PostgreSQL
--
-- 



-- 7) Script de consultas de grupos (GROUP BY y HAVING)

-- Consulta #1: Agrupar productores por departamento y municipio
SELECT
    m.departamento,
    m.ciudad AS municipio,
    COUNT(*) AS total_productores
FROM usuarios u
JOIN mercado m ON m.id_mercado = u.id_mercado
WHERE u.rol = 'APICULTOR'
GROUP BY m.departamento, m.ciudad
ORDER BY m.departamento, m.ciudad;

-- Consulta #2: Agrupar consumidores por departamento y municipio
SELECT
    m.departamento,
    m.ciudad AS municipio,
    COUNT(*) AS total_consumidores
FROM usuarios u
JOIN mercado m ON m.id_mercado = u.id_mercado
WHERE u.rol = 'COMPRADOR'
GROUP BY m.departamento, m.ciudad
ORDER BY m.departamento, m.ciudad;

-- Consulta #3: Productores de un departamento por municipio y apiarios
-- Departamento elegido: Antioquia
SELECT
    m.departamento,
    m.ciudad AS municipio,
    a.id_apiario,
    a.nombre AS apiario,
    COUNT(DISTINCT u.id_usuario) AS total_productores
FROM usuarios u
JOIN mercado m ON m.id_mercado = u.id_mercado
JOIN apiario a ON a.id_responsable = u.id_usuario
WHERE u.rol = 'APICULTOR'
    AND m.departamento = 'Antioquia'
GROUP BY m.departamento, m.ciudad, a.id_apiario, a.nombre
ORDER BY m.ciudad, a.nombre;

-- Consulta #4: Pedidos de un departamento por municipio y apiario con HAVING
-- Debe incluir total de pedidos en COP
SELECT
    m.departamento,
    m.ciudad AS municipio,
    a.id_apiario,
    a.nombre AS apiario,
    SUM(pl.subtotal) AS total_pedidos_cop
FROM pedido pe
JOIN mercado m ON m.id_mercado = pe.id_mercado
JOIN pedido_lote pl ON pl.id_pedido = pe.id_pedido
JOIN lote l ON l.id_lote = pl.id_lote
JOIN apiario a ON a.id_apiario = l.id_apiario
WHERE m.departamento = 'Antioquia'
GROUP BY m.departamento, m.ciudad, a.id_apiario, a.nombre
HAVING SUM(pl.subtotal) >= 1000
ORDER BY total_pedidos_cop DESC;

-- Consulta #5: Productos pedidos en todos los departamentos/municipios de mayor a menor
SELECT
    m.departamento,
    m.ciudad AS municipio,
    p.id_producto,
    p.nombre AS producto,
    SUM(pl.cantidad) AS cantidad_total_pedida,
    SUM(pl.subtotal) AS total_cop
FROM pedido pe
JOIN mercado m ON m.id_mercado = pe.id_mercado
JOIN pedido_lote pl ON pl.id_pedido = pe.id_pedido
JOIN lote l ON l.id_lote = pl.id_lote
JOIN producto p ON p.id_producto = l.id_producto
GROUP BY m.departamento, m.ciudad, p.id_producto, p.nombre
ORDER BY cantidad_total_pedida DESC, total_cop DESC;

-- Respuestas solicitadas

-- a) Productor que mas recibio pedidos
SELECT
    pr.id_usuario AS codigo_productor,
    (pr.nombre || ' ' || pr.apellido) AS productor,
    COUNT(DISTINCT pe.id_pedido) AS total_pedidos_recibidos
FROM publicacion pub
JOIN usuarios pr ON pr.id_usuario = pub.id_productor
JOIN pedido_lote pl ON pl.id_lote = pub.id_lote
JOIN pedido pe ON pe.id_pedido = pl.id_pedido
GROUP BY pr.id_usuario, pr.nombre, pr.apellido
ORDER BY total_pedidos_recibidos DESC;

-- b) Departamento con mas pedidos y con menos pedidos
SELECT
    m.departamento,
    COUNT(DISTINCT pe.id_pedido) AS total_pedidos
FROM pedido pe
JOIN mercado m ON m.id_mercado = pe.id_mercado
GROUP BY m.departamento
ORDER BY total_pedidos DESC;

-- c) Producto que recibio menos pedidos (por cantidad)
SELECT
    p.id_producto,
    p.nombre AS producto,
    SUM(pl.cantidad) AS cantidad_total_pedida
FROM pedido_lote pl
JOIN lote l ON l.id_lote = pl.id_lote
JOIN producto p ON p.id_producto = l.id_producto
GROUP BY p.id_producto, p.nombre
ORDER BY cantidad_total_pedida ASC;

-- d) Municipio con mayor monto (COP) de pedidos
SELECT
    m.ciudad AS municipio,
    SUM(pl.subtotal) AS monto_total_cop
FROM pedido pe
JOIN mercado m ON m.id_mercado = pe.id_mercado
JOIN pedido_lote pl ON pl.id_pedido = pe.id_pedido
GROUP BY m.ciudad
ORDER BY monto_total_cop DESC;
