--
-- Scripts de DELETE de la Base de Datos  - SGBD PostgreSQL
--
 


-- 5) Script de eliminacion (DELETE)
-- Requisito: insertar y eliminar 1 producto + insertar y eliminar 1 apicultor

-- 1) Insertar producto temporal y eliminarlo
INSERT INTO producto (nombre, categoria, unidad_medida, descripcion, activo)
VALUES ('Producto Temporal No Comercial', 'Miel', 'kg', 'Registro temporal para prueba de eliminacion', TRUE);

SELECT id_producto, nombre, categoria, unidad_medida, activo
FROM producto
WHERE nombre = 'Producto Temporal No Comercial';

DELETE FROM producto
WHERE nombre = 'Producto Temporal No Comercial';

SELECT id_producto, nombre
FROM producto
WHERE nombre = 'Producto Temporal No Comercial';

-- 2) Insertar apicultor temporal y eliminarlo
INSERT INTO usuarios (
    id_organizacion,
    id_mercado,
    nombre,
    apellido,
    email,
    telefono,
    rol,
    fecha_registro,
    activo
)
SELECT
    o.id_organizacion,
    m.id_mercado,
    'Apicultor',
    'Temporal',
    'apicultor.temporal.delete@apicola.test',
    '3009990000',
    'APICULTOR',
    CURRENT_DATE,
    TRUE
FROM organizacion o
JOIN mercado m ON m.departamento = 'Valle del Cauca' AND m.ciudad = 'Cali'
WHERE o.nombre = 'Cooperativa Valle del Cauca'
LIMIT 1;

SELECT id_usuario, nombre, apellido, email, rol
FROM usuarios
WHERE email = 'apicultor.temporal.delete@apicola.test';

DELETE FROM usuarios
WHERE email = 'apicultor.temporal.delete@apicola.test';

SELECT id_usuario, nombre, apellido, email
FROM usuarios
WHERE email = 'apicultor.temporal.delete@apicola.test';
