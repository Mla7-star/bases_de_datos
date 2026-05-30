--
-- Scripts de CONSULTA CON PARÁMETROS de la Base de Datos  - SGBD PostgreSQL
-- 


-- 9) Script de consultas con parametros (PREPARE)
-- Consulta parametrizada con 3 parametros, 3 JOIN, WHERE, HAVING y agregacion

DEALLOCATE ALL;

PREPARE reporte_pedidos_por_zona (TEXT, TEXT, NUMERIC) AS
SELECT
    pr.id_usuario AS codigo_productor,
    (pr.nombre || ' ' || pr.apellido) AS productor,
    m.departamento,
    m.ciudad AS municipio,
    COUNT(DISTINCT pe.id_pedido) AS total_pedidos,
    SUM(pl.subtotal) AS total_vendido_cop,
    AVG(pl.precio_unitario) AS precio_promedio_cop
FROM pedido pe
JOIN mercado m ON m.id_mercado = pe.id_mercado
JOIN pedido_lote pl ON pl.id_pedido = pe.id_pedido
JOIN lote l ON l.id_lote = pl.id_lote
JOIN publicacion pub ON pub.id_lote = l.id_lote
JOIN usuarios pr ON pr.id_usuario = pub.id_productor
WHERE m.departamento = $1
  AND m.ciudad = $2
GROUP BY pr.id_usuario, pr.nombre, pr.apellido, m.departamento, m.ciudad
HAVING SUM(pl.subtotal) >= $3
ORDER BY total_vendido_cop DESC;

-- Ejecuciones de ejemplo
EXECUTE reporte_pedidos_por_zona('Valle del Cauca', 'Cali', 1000);
EXECUTE reporte_pedidos_por_zona('Antioquia', 'Caucasia', 500);
