--
-- Script de MANIPULACIÓN DE DATO JSON de la Base de Datos  - SGBD PostgreSQL
-- 


-- =============================================================
-- Script 2: Insercion, consulta y actualizacion de dato JSONB
-- Tabla objetivo: lectura_sensor(data JSONB)
-- =============================================================

-- Requisito previo:
-- Debe existir al menos un sensor con id_sensor=1
-- (creado por el script base de inventario)

-- 1) INSERCION de dato JSONB
INSERT INTO lectura_sensor (id_sensor, fecha_lectura, data, alerta)
VALUES (
    1,
    NOW(),
    '{
      "temperatura": 31.4,
      "humedad": 58.2,
      "peso": 26.1,
      "bateria": 87,
      "ubicacion": {
        "lat": 4.7110,
        "lon": -74.0721
      },
      "evento": "lectura_inicial"
    }'::jsonb,
    FALSE
);

-- 2) CONSULTA del dato JSONB insertado
-- (se consulta el ultimo insertado para id_sensor=1)
SELECT
    id_lectura,
    fecha_lectura,
    data,
    data->>'evento' AS evento,
    (data->>'temperatura')::numeric AS temperatura,
    (data->'ubicacion'->>'lat')::numeric AS latitud
FROM lectura_sensor
WHERE id_sensor = 1
ORDER BY id_lectura DESC
LIMIT 1;

-- 3) ACTUALIZACION de un campo interno del JSONB
-- Cambia bateria de 87 a 95
UPDATE lectura_sensor
SET data = jsonb_set(data, '{bateria}', '95'::jsonb, TRUE)
WHERE id_lectura = (
    SELECT id_lectura
    FROM lectura_sensor
    WHERE id_sensor = 1
    ORDER BY id_lectura DESC
    LIMIT 1
);

-- 4) CONSULTA posterior para verificar cambio dentro del JSONB
SELECT
    id_lectura,
    data,
    (data->>'bateria')::int AS bateria_actualizada
FROM lectura_sensor
WHERE id_sensor = 1
ORDER BY id_lectura DESC
LIMIT 1;
