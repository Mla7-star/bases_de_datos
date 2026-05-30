--
-- Scripst de VALIDACIÓN PROPIEDADES ACID de la Base de Datos  - SGBD PostgreSQL
-- 


-- =============================================================
-- Script 1: Verificacion de propiedades ACID
-- Base esperada: tablas del script 1_2_inventario_apicola.sql
-- =============================================================

-- RECOMENDACION:
-- 1) Ejecutar primero databases/1_2_inventario_apicola.sql
-- 2) Abrir 2 pestañas de Query Tool para tomar capturas ANTES y DESPUES

-- =============================================================
-- A) ATOMICIDAD (BEGIN + ROLLBACK en 2 tablas)
-- =============================================================
-- PESTANA 1 (ANTES):
-- SELECT id_usuario, nombre, apellido FROM usuarios WHERE id_usuario = 1;
-- SELECT id_mercado, nombre, ciudad FROM mercado WHERE id_mercado = 1;

BEGIN;

UPDATE usuarios
SET nombre = 'AtomicoTemp',
    apellido = 'RollbackTemp'
WHERE id_usuario = 1;

UPDATE mercado
SET nombre = 'Mercado Atomico Temp',
    ciudad = 'Ciudad Atomica Temp'
WHERE id_mercado = 1;

-- Verificacion dentro de la misma transaccion (cambio visible temporalmente)
SELECT id_usuario, nombre, apellido
FROM usuarios
WHERE id_usuario = 1;

SELECT id_mercado, nombre, ciudad
FROM mercado
WHERE id_mercado = 1;

ROLLBACK;

-- PESTANA 2 (DESPUES DEL ROLLBACK):
SELECT id_usuario, nombre, apellido
FROM usuarios
WHERE id_usuario = 1;

SELECT id_mercado, nombre, ciudad
FROM mercado
WHERE id_mercado = 1;


-- =============================================================
-- B) CONSISTENCIA (3 operaciones que deben FALLAR)
-- =============================================================
-- Escenario 1: INSERT con PK duplicada (viola unicidad de PK)
-- Escenario 2: UPDATE que viola CHECK en documento
-- Escenario 3: DELETE de producto referenciado por FK en cosecha/lote/colmena

-- 1) INSERT inconsistente: PK duplicada
DO $$
BEGIN
    BEGIN
        INSERT INTO producto (id_producto, nombre, categoria, unidad_medida, descripcion, activo)
        VALUES (1, 'Producto Duplicado', 'Miel', 'kg', 'Debe fallar por PK duplicada', TRUE);
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'CONSISTENCIA 1 OK: Fallo esperado por PK/UNIQUE duplicada (%).', SQLERRM;
    END;
END $$;

-- 2) UPDATE inconsistente: viola CHECK de documento
-- CHECK: al menos uno entre id_usuario/id_apiario/id_lote debe ser NOT NULL
DO $$
BEGIN
    BEGIN
        UPDATE documento
        SET id_usuario = NULL,
            id_apiario = NULL,
            id_lote = NULL
        WHERE id_documento = 1;
    EXCEPTION WHEN check_violation THEN
        RAISE NOTICE 'CONSISTENCIA 2 OK: Fallo esperado por CHECK (%).', SQLERRM;
    END;
END $$;

-- 3) DELETE inconsistente: producto referenciado por otras tablas
DO $$
BEGIN
    BEGIN
        DELETE FROM producto
        WHERE id_producto = 1;
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'CONSISTENCIA 3 OK: Fallo esperado por FK (%).', SQLERRM;
    END;
END $$;

-- Explicacion breve de por que fallan:
-- 1) La PK (id_producto=1) ya existe, por lo tanto se rompe la unicidad.
-- 2) El CHECK de documento exige al menos una referencia (usuario/apiario/lote).
-- 3) No se puede borrar un producto que esta siendo referenciado por claves foraneas.


-- =============================================================
-- C) AISLAMIENTO (CASO HIPOTETICO, NO EJECUTAR)
-- =============================================================
-- Caso propuesto:
-- - Transaccion T1: inicia y actualiza precio_unitario de publicacion id_publicacion=1,
--   pero no hace COMMIT aun.
-- - Transaccion T2: consulta ese mismo registro.
--   * Con READ COMMITTED, T2 NO ve el cambio no confirmado de T1 (evita dirty read).
--   * Con SERIALIZABLE, ademas se restringen anomalias de lectura/escritura concurrente,
--     pudiendo producirse reintentos por serializacion.


-- =============================================================
-- D) DURABILIDAD (BEGIN + COMMIT)
-- =============================================================
-- PESTANA 1 (ANTES):
-- SELECT id_producto, nombre, descripcion FROM producto WHERE id_producto = 2;

BEGIN;

UPDATE producto
SET descripcion = 'Cambio durable confirmado por COMMIT',
    activo = TRUE
WHERE id_producto = 2;

-- Verificacion antes del COMMIT (en la misma sesion)
SELECT id_producto, nombre, descripcion
FROM producto
WHERE id_producto = 2;

COMMIT;

-- PESTANA 2 (DESPUES DEL COMMIT):
-- Si cierras y abres nueva sesion, el valor debe permanecer.
SELECT id_producto, nombre, descripcion
FROM producto
WHERE id_producto = 2;
