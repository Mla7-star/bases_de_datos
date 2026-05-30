--
-- Scripst de Creación de la Base de Datos  - SGBD PostgreSQL
--
-- Todas las instrucciones se DEBEN EJECUTAR EN SECUENCIA SIN ERRORES
-- NOTA: Ojo con las tablas relacionadas. Primero las independientes y después las dependientes
--

--
-- Creación de las tablas
-- 


-- Script PostgreSQL para pgAdmin4
-- Sistema de informacion apicola
-- Crea 20 tablas e inserta datos mock (>= 2 registros por tabla)

BEGIN;

-- Limpieza previa (orden inverso de dependencias)
DROP TABLE IF EXISTS obligacion CASCADE;
DROP TABLE IF EXISTS actividad_comunidad CASCADE;
DROP TABLE IF EXISTS documento CASCADE;
DROP TABLE IF EXISTS envio CASCADE;
DROP TABLE IF EXISTS pago CASCADE;
DROP TABLE IF EXISTS pedido_lote CASCADE;
DROP TABLE IF EXISTS pedido CASCADE;
DROP TABLE IF EXISTS publicacion CASCADE;
DROP TABLE IF EXISTS control CASCADE;
DROP TABLE IF EXISTS lectura_sensor CASCADE;
DROP TABLE IF EXISTS apicultor_producto CASCADE;
DROP TABLE IF EXISTS lote CASCADE;
DROP TABLE IF EXISTS cosecha CASCADE;
DROP TABLE IF EXISTS sensor CASCADE;
DROP TABLE IF EXISTS colmena CASCADE;
DROP TABLE IF EXISTS apiario CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;
DROP TABLE IF EXISTS organizacion CASCADE;
DROP TABLE IF EXISTS mercado CASCADE;
DROP TABLE IF EXISTS producto CASCADE;

-- 1) producto
CREATE TABLE producto (
    id_producto       BIGSERIAL PRIMARY KEY,
    nombre            VARCHAR(120) NOT NULL UNIQUE,
    categoria         VARCHAR(60) NOT NULL,
    unidad_medida     VARCHAR(20) NOT NULL,
    precio_referencia NUMERIC(12,2),
    codigo_referencia INTEGER,
    descripcion       TEXT,
    activo            BOOLEAN NOT NULL DEFAULT TRUE,
    created_at        TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 2) mercado
CREATE TABLE mercado (
    id_mercado        BIGSERIAL PRIMARY KEY,
    nombre            VARCHAR(120) NOT NULL,
    ciudad            VARCHAR(80) NOT NULL,
    departamento      VARCHAR(80) NOT NULL,
    direccion         VARCHAR(200),
    tipo_mercado      VARCHAR(40) NOT NULL,
    activo            BOOLEAN NOT NULL DEFAULT TRUE,
    created_at        TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 3) organizacion
CREATE TABLE organizacion (
    id_organizacion   BIGSERIAL PRIMARY KEY,
    nombre            VARCHAR(120) NOT NULL UNIQUE,
    tipo              VARCHAR(40) NOT NULL,
    nit               VARCHAR(30) NOT NULL UNIQUE,
    ciudad            VARCHAR(80) NOT NULL,
    fecha_registro    DATE NOT NULL DEFAULT CURRENT_DATE
);

-- 4) usuarios
CREATE TABLE usuarios (
    id_usuario        BIGSERIAL PRIMARY KEY,
    id_organizacion   BIGINT REFERENCES organizacion(id_organizacion) ON UPDATE CASCADE,
    id_mercado        BIGINT REFERENCES mercado(id_mercado) ON UPDATE CASCADE,
    nombre            VARCHAR(80) NOT NULL,
    apellido          VARCHAR(80) NOT NULL,
    email             VARCHAR(140) NOT NULL UNIQUE,
    telefono          VARCHAR(30),
    rol               VARCHAR(30) NOT NULL,
    fecha_registro    DATE NOT NULL DEFAULT CURRENT_DATE,
    activo            BOOLEAN NOT NULL DEFAULT TRUE
);

-- 5) apiario
CREATE TABLE apiario (
    id_apiario        BIGSERIAL PRIMARY KEY,
    id_organizacion   BIGINT NOT NULL REFERENCES organizacion(id_organizacion) ON UPDATE CASCADE,
    id_responsable    BIGINT NOT NULL REFERENCES usuarios(id_usuario) ON UPDATE CASCADE,
    id_mercado        BIGINT REFERENCES mercado(id_mercado) ON UPDATE CASCADE,
    nombre            VARCHAR(120) NOT NULL,
    latitud           NUMERIC(9,6) NOT NULL,
    longitud          NUMERIC(9,6) NOT NULL,
    altitud_msnm      INTEGER,
    fecha_registro    DATE NOT NULL DEFAULT CURRENT_DATE,
    estado            VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

-- 6) colmena
CREATE TABLE colmena (
    id_colmena            BIGSERIAL PRIMARY KEY,
    id_apiario            BIGINT NOT NULL REFERENCES apiario(id_apiario) ON UPDATE CASCADE,
    codigo                VARCHAR(40) NOT NULL UNIQUE,
    id_producto_principal BIGINT REFERENCES producto(id_producto) ON UPDATE CASCADE,
    tipo                  VARCHAR(30) NOT NULL,
    fecha_instalacion     DATE NOT NULL,
    estado                VARCHAR(20) NOT NULL DEFAULT 'OPERATIVA'
);

-- 7) sensor
CREATE TABLE sensor (
    id_sensor          BIGSERIAL PRIMARY KEY,
    id_apiario         BIGINT NOT NULL REFERENCES apiario(id_apiario) ON UPDATE CASCADE,
    id_colmena         BIGINT REFERENCES colmena(id_colmena) ON UPDATE CASCADE,
    codigo_serie       VARCHAR(60) NOT NULL UNIQUE,
    tipo_sensor        VARCHAR(40) NOT NULL,
    unidad             VARCHAR(20) NOT NULL,
    fecha_instalacion  DATE NOT NULL,
    estado             VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

-- 8) cosecha
CREATE TABLE cosecha (
    id_cosecha         BIGSERIAL PRIMARY KEY,
    id_colmena         BIGINT NOT NULL REFERENCES colmena(id_colmena) ON UPDATE CASCADE,
    id_producto        BIGINT NOT NULL REFERENCES producto(id_producto) ON UPDATE CASCADE,
    fecha_cosecha      DATE NOT NULL,
    cantidad           NUMERIC(10,2) NOT NULL,
    unidad             VARCHAR(20) NOT NULL,
    humedad_pct        NUMERIC(5,2),
    observaciones      TEXT
);

-- 9) lote
CREATE TABLE lote (
    id_lote                BIGSERIAL PRIMARY KEY,
    id_cosecha             BIGINT NOT NULL REFERENCES cosecha(id_cosecha) ON UPDATE CASCADE,
    id_producto            BIGINT NOT NULL REFERENCES producto(id_producto) ON UPDATE CASCADE,
    id_apiario             BIGINT NOT NULL REFERENCES apiario(id_apiario) ON UPDATE CASCADE,
    codigo_lote            VARCHAR(50) NOT NULL UNIQUE,
    fecha_produccion       DATE NOT NULL,
    fecha_vencimiento      DATE,
    cantidad_disponible    NUMERIC(10,2) NOT NULL,
    estado_calidad         VARCHAR(20) NOT NULL DEFAULT 'APROBADO'
);

-- 10) apicultor_producto
CREATE TABLE apicultor_producto (
    id_apicultor_producto  BIGSERIAL PRIMARY KEY,
    id_usuario             BIGINT NOT NULL REFERENCES usuarios(id_usuario) ON UPDATE CASCADE,
    id_producto            BIGINT NOT NULL REFERENCES producto(id_producto) ON UPDATE CASCADE,
    capacidad_mensual      NUMERIC(10,2) NOT NULL,
    unidad                 VARCHAR(20) NOT NULL,
    experiencia_anios      INTEGER NOT NULL DEFAULT 1,
    activo                 BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (id_usuario, id_producto)
);

-- 11) lectura_sensor
CREATE TABLE lectura_sensor (
    id_lectura         BIGSERIAL PRIMARY KEY,
    id_sensor          BIGINT NOT NULL REFERENCES sensor(id_sensor) ON UPDATE CASCADE,
    fecha_lectura      TIMESTAMP NOT NULL,
    data               JSONB NOT NULL,
    alerta             BOOLEAN NOT NULL DEFAULT FALSE
);

-- 12) control
CREATE TABLE control (
    id_control             BIGSERIAL PRIMARY KEY,
    id_colmena             BIGINT NOT NULL REFERENCES colmena(id_colmena) ON UPDATE CASCADE,
    id_usuario_responsable BIGINT NOT NULL REFERENCES usuarios(id_usuario) ON UPDATE CASCADE,
    fecha_control          DATE NOT NULL,
    tipo_control           VARCHAR(40) NOT NULL,
    diagnostico            VARCHAR(120),
    tratamiento            VARCHAR(120),
    observaciones          TEXT
);

-- 13) publicacion
CREATE TABLE publicacion (
    id_publicacion     BIGSERIAL PRIMARY KEY,
    id_lote            BIGINT NOT NULL REFERENCES lote(id_lote) ON UPDATE CASCADE,
    id_productor       BIGINT NOT NULL REFERENCES usuarios(id_usuario) ON UPDATE CASCADE,
    id_mercado         BIGINT NOT NULL REFERENCES mercado(id_mercado) ON UPDATE CASCADE,
    precio_unitario    NUMERIC(12,2) NOT NULL,
    moneda             CHAR(3) NOT NULL DEFAULT 'COP',
    estado             VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
    fecha_publicacion  DATE NOT NULL DEFAULT CURRENT_DATE
);

-- 14) pedido
CREATE TABLE pedido (
    id_pedido          BIGSERIAL PRIMARY KEY,
    id_comprador       BIGINT NOT NULL REFERENCES usuarios(id_usuario) ON UPDATE CASCADE,
    id_mercado         BIGINT NOT NULL REFERENCES mercado(id_mercado) ON UPDATE CASCADE,
    fecha_solicitud    TIMESTAMP NOT NULL DEFAULT NOW(),
    estado             VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    total_estimado     NUMERIC(12,2) NOT NULL DEFAULT 0
);

-- 15) pedido_lote
CREATE TABLE pedido_lote (
    id_pedido_lote     BIGSERIAL PRIMARY KEY,
    id_pedido          BIGINT NOT NULL REFERENCES pedido(id_pedido) ON UPDATE CASCADE ON DELETE CASCADE,
    id_lote            BIGINT NOT NULL REFERENCES lote(id_lote) ON UPDATE CASCADE,
    cantidad           NUMERIC(10,2) NOT NULL,
    precio_unitario    NUMERIC(12,2) NOT NULL,
    subtotal           NUMERIC(12,2) NOT NULL
);

-- 16) pago
CREATE TABLE pago (
    id_pago            BIGSERIAL PRIMARY KEY,
    id_pedido          BIGINT NOT NULL REFERENCES pedido(id_pedido) ON UPDATE CASCADE,
    id_pagador         BIGINT NOT NULL REFERENCES usuarios(id_usuario) ON UPDATE CASCADE,
    fecha_pago         TIMESTAMP NOT NULL DEFAULT NOW(),
    monto              NUMERIC(12,2) NOT NULL,
    metodo             VARCHAR(30) NOT NULL,
    estado             VARCHAR(20) NOT NULL DEFAULT 'APROBADO',
    referencia         VARCHAR(60) NOT NULL UNIQUE
);

-- 17) envio
CREATE TABLE envio (
    id_envio               BIGSERIAL PRIMARY KEY,
    id_pedido              BIGINT NOT NULL REFERENCES pedido(id_pedido) ON UPDATE CASCADE,
    id_destinatario        BIGINT NOT NULL REFERENCES usuarios(id_usuario) ON UPDATE CASCADE,
    direccion              VARCHAR(200) NOT NULL,
    ciudad                 VARCHAR(80) NOT NULL,
    transportadora         VARCHAR(80) NOT NULL,
    guia                   VARCHAR(50) NOT NULL UNIQUE,
    estado                 VARCHAR(20) NOT NULL DEFAULT 'PREPARACION',
    fecha_envio            DATE,
    fecha_entrega_estimada DATE
);

-- 18) documento
CREATE TABLE documento (
    id_documento       BIGSERIAL PRIMARY KEY,
    id_usuario         BIGINT REFERENCES usuarios(id_usuario) ON UPDATE CASCADE,
    id_apiario         BIGINT REFERENCES apiario(id_apiario) ON UPDATE CASCADE,
    id_lote            BIGINT REFERENCES lote(id_lote) ON UPDATE CASCADE,
    tipo_documento     VARCHAR(40) NOT NULL,
    nombre_archivo     VARCHAR(160) NOT NULL,
    url_documento      VARCHAR(255) NOT NULL,
    fecha_emision      DATE NOT NULL,
    fecha_vencimiento  DATE,
    estado             VARCHAR(20) NOT NULL DEFAULT 'VIGENTE',
    CHECK (id_usuario IS NOT NULL OR id_apiario IS NOT NULL OR id_lote IS NOT NULL)
);

-- 19) actividad_comunidad
CREATE TABLE actividad_comunidad (
    id_actividad       BIGSERIAL PRIMARY KEY,
    id_usuario         BIGINT NOT NULL REFERENCES usuarios(id_usuario) ON UPDATE CASCADE,
    id_organizacion    BIGINT REFERENCES organizacion(id_organizacion) ON UPDATE CASCADE,
    titulo             VARCHAR(140) NOT NULL,
    descripcion        TEXT NOT NULL,
    tipo_actividad     VARCHAR(30) NOT NULL,
    fecha_publicacion  TIMESTAMP NOT NULL DEFAULT NOW(),
    fecha_evento       DATE,
    estado             VARCHAR(20) NOT NULL DEFAULT 'PUBLICADA'
);

-- 20) obligacion
CREATE TABLE obligacion (
    id_obligacion      BIGSERIAL PRIMARY KEY,
    id_usuario         BIGINT NOT NULL REFERENCES usuarios(id_usuario) ON UPDATE CASCADE,
    id_organizacion    BIGINT NOT NULL REFERENCES organizacion(id_organizacion) ON UPDATE CASCADE,
    tipo_obligacion    VARCHAR(50) NOT NULL,
    descripcion        TEXT NOT NULL,
    fecha_inicio       DATE NOT NULL,
    fecha_fin          DATE,
    estado             VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
    UNIQUE (id_usuario, id_organizacion, tipo_obligacion, fecha_inicio)
);

-- Ajustes de compatibilidad para scripts posteriores (ALTER solicitados)
ALTER TABLE mercado
ADD COLUMN IF NOT EXISTS direccion VARCHAR(200);

ALTER TABLE producto
ADD COLUMN IF NOT EXISTS precio_referencia NUMERIC(12,2),
ADD COLUMN IF NOT EXISTS codigo_referencia INTEGER;


COMMIT;
