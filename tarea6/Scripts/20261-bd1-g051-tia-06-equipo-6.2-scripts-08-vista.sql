--
-- Script de VIEW de la Base de Datos  - SGBD PostgreSQL
-- 


-- 8) Script de consultas con vistas (VIEW)
-- Vista con 3 JOIN, WHERE, HAVING y funcion de agregacion

DROP VIEW IF EXISTS vw_resumen_pedidos_productor;

CREATE VIEW vw_resumen_pedidos_productor AS
SELECT
    pr.id_usuario AS codigo_productor,
    (pr.nombre || ' ' || pr.apellido) AS productor,
    m.departamento,
    m.ciudad AS municipio,
    COUNT(DISTINCT pe.id_pedido) AS total_pedidos,
    SUM(pl.subtotal) AS total_vendido_cop,
    AVG(pl.precio_unitario) AS precio_promedio_cop
FROM publicacion pub
JOIN usuarios pr ON pr.id_usuario = pub.id_productor
JOIN lote l ON l.id_lote = pub.id_lote
JOIN pedido_lote pl ON pl.id_lote = l.id_lote
JOIN pedido pe ON pe.id_pedido = pl.id_pedido
JOIN mercado m ON m.id_mercado = pe.id_mercado
WHERE pub.estado IN ('ACTIVA', 'PAUSADA')
GROUP BY pr.id_usuario, pr.nombre, pr.apellido, m.departamento, m.ciudad
HAVING SUM(pl.subtotal) >= 1000;

-- Consulta de la vista
SELECT *
FROM vw_resumen_pedidos_productor
ORDER BY total_vendido_cop DESC, productor ASC;
