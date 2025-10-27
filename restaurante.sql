/* =========================================================
   Base de datos: RESTAURANTE
   Motor destino: Microsoft SQL Server (T-SQL)
   ========================================================= */

-- crear y usar la base
CREATE DATABASE RESTAURANTE;
GO
USE RESTAURANTE;
GO

/* =======================
   DROP en orden seguro
   ======================= */
IF OBJECT_ID('dbo.reservas_sucursales','U') IS NOT NULL DROP TABLE dbo.reservas_sucursales;
IF OBJECT_ID('dbo.zonas_turnos_sucursales','U') IS NOT NULL DROP TABLE dbo.zonas_turnos_sucursales;
IF OBJECT_ID('dbo.turnos_sucursales','U') IS NOT NULL DROP TABLE dbo.turnos_sucursales;
IF OBJECT_ID('dbo.zonas_sucursales','U') IS NOT NULL DROP TABLE dbo.zonas_sucursales;

IF OBJECT_ID('dbo.tipos_comidas_sucursales','U') IS NOT NULL DROP TABLE dbo.tipos_comidas_sucursales;
IF OBJECT_ID('dbo.especialidades_alimentarias_sucursales','U') IS NOT NULL DROP TABLE dbo.especialidades_alimentarias_sucursales;
IF OBJECT_ID('dbo.estilos_sucursales','U') IS NOT NULL DROP TABLE dbo.estilos_sucursales;

IF OBJECT_ID('dbo.contenidos','U') IS NOT NULL DROP TABLE dbo.contenidos;

IF OBJECT_ID('dbo.clientes','U') IS NOT NULL DROP TABLE dbo.clientes;

IF OBJECT_ID('dbo.sucursales','U') IS NOT NULL DROP TABLE dbo.sucursales;

IF OBJECT_ID('dbo.zonas','U') IS NOT NULL DROP TABLE dbo.zonas;
IF OBJECT_ID('dbo.tipos_comidas','U') IS NOT NULL DROP TABLE dbo.tipos_comidas;
IF OBJECT_ID('dbo.especialidades_alimentarias','U') IS NOT NULL DROP TABLE dbo.especialidades_alimentarias;
IF OBJECT_ID('dbo.estilos','U') IS NOT NULL DROP TABLE dbo.estilos;

IF OBJECT_ID('dbo.localidades','U') IS NOT NULL DROP TABLE dbo.localidades;
IF OBJECT_ID('dbo.provincias','U') IS NOT NULL DROP TABLE dbo.provincias;

IF OBJECT_ID('dbo.categorias_precios','U') IS NOT NULL DROP TABLE dbo.categorias_precios;
IF OBJECT_ID('dbo.restaurantes','U') IS NOT NULL DROP TABLE dbo.restaurantes;
GO

/* =======================
   TABLAS MAESTRAS
   ======================= */

CREATE TABLE dbo.provincias (
    cod_provincia   INT           NOT NULL,
    nom_provincia   VARCHAR(100)  NOT NULL,
    CONSTRAINT PK_provincias PRIMARY KEY (cod_provincia)
);

CREATE TABLE dbo.localidades (
    nro_localidad   INT           NOT NULL,
    nom_localidad   VARCHAR(120)  NOT NULL,
    cod_provincia   INT           NOT NULL,
    CONSTRAINT PK_localidades PRIMARY KEY (nro_localidad),
    CONSTRAINT UQ_localidades_codprov_nom UNIQUE (cod_provincia, nom_localidad),
    CONSTRAINT FK_localidades_provincias
        FOREIGN KEY (cod_provincia) REFERENCES dbo.provincias (cod_provincia)
);

CREATE TABLE dbo.restaurantes (
    nro_restaurante INT            NOT NULL,
    razon_social    VARCHAR(200)   NOT NULL,
    cuit            VARCHAR(20)    NOT NULL,
    CONSTRAINT PK_restaurantes PRIMARY KEY (nro_restaurante),
    CONSTRAINT UQ_restaurantes_cuit UNIQUE (cuit)
);

CREATE TABLE dbo.categorias_precios (
    nro_categoria   INT           NOT NULL,
    nom_categoria   VARCHAR(100)  NOT NULL,
    CONSTRAINT PK_categorias_precios PRIMARY KEY (nro_categoria)
);

CREATE TABLE dbo.zonas (
    cod_zona   INT            NOT NULL,
    nom_zona   VARCHAR(120)   NOT NULL,
    CONSTRAINT PK_zonas PRIMARY KEY (cod_zona)
);

CREATE TABLE dbo.tipos_comidas (
    nro_tipo_comida INT            NOT NULL,
    nom_tipo_comida VARCHAR(120)   NOT NULL,
    CONSTRAINT PK_tipos_comidas PRIMARY KEY (nro_tipo_comida)
);

CREATE TABLE dbo.especialidades_alimentarias (
    nro_restriccion INT            NOT NULL,
    nom_restriccion VARCHAR(120)   NOT NULL,
    CONSTRAINT PK_especialidades_alimentarias PRIMARY KEY (nro_restriccion)
);

CREATE TABLE dbo.estilos (
    nro_estilo  INT            NOT NULL,
    nom_estilo  VARCHAR(120)   NOT NULL,
    CONSTRAINT PK_estilos PRIMARY KEY (nro_estilo)
);

/* =======================
   SUCURSALES y relación geográfica
   ======================= */

CREATE TABLE dbo.sucursales (
    nro_restaurante           INT            NOT NULL,
    nro_sucursal              INT            NOT NULL,
    nom_sucursal              VARCHAR(150)   NOT NULL,
    calle                     VARCHAR(120)   NULL,
    nro_calle                 INT            NULL,
    barrio                    VARCHAR(120)   NULL,
    nro_localidad             INT            NOT NULL,
    cod_postal                VARCHAR(20)    NULL,
    telefonos                 VARCHAR(120)   NULL,
    total_comensales          INT            NOT NULL,
    min_tolerencia_reserva    INT            NOT NULL, -- minutos
    nro_categoria             INT            NOT NULL,
    CONSTRAINT PK_sucursales PRIMARY KEY (nro_restaurante, nro_sucursal),
    CONSTRAINT FK_sucursales_restaurantes
        FOREIGN KEY (nro_restaurante) REFERENCES dbo.restaurantes (nro_restaurante),
    CONSTRAINT FK_sucursales_localidades
        FOREIGN KEY (nro_localidad) REFERENCES dbo.localidades (nro_localidad),
    CONSTRAINT FK_sucursales_categorias
        FOREIGN KEY (nro_categoria) REFERENCES dbo.categorias_precios (nro_categoria),
    CONSTRAINT CK_sucursales_totales_no_neg CHECK (total_comensales >= 0),
    CONSTRAINT CK_sucursales_tolerancia_no_neg CHECK (min_tolerencia_reserva >= 0)
);

/* =======================
   Zonas habilitadas por sucursal
   ======================= */

CREATE TABLE dbo.zonas_sucursales (
    nro_restaurante   INT   NOT NULL,
    nro_sucursal      INT   NOT NULL,
    cod_zona          INT   NOT NULL,
    cant_comensales   INT   NOT NULL,
    permite_menores   BIT   NOT NULL,
    habilitada        BIT   NOT NULL,
    CONSTRAINT PK_zonas_sucursales PRIMARY KEY (nro_restaurante, nro_sucursal, cod_zona),
    CONSTRAINT FK_zonas_sucursales_sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES dbo.sucursales (nro_restaurante, nro_sucursal),
    CONSTRAINT FK_zonas_sucursales_zonas
        FOREIGN KEY (cod_zona) REFERENCES dbo.zonas (cod_zona),
    CONSTRAINT CK_zonas_sucursales_cant_no_neg CHECK (cant_comensales >= 0)
);

/* =======================
   Turnos por sucursal y su cruce con zonas
   ======================= */

CREATE TABLE dbo.turnos_sucursales (
    nro_restaurante  INT    NOT NULL,
    nro_sucursal     INT    NOT NULL,
    hora_desde       TIME   NOT NULL,
    hora_hasta       TIME   NOT NULL,
    habilitado       BIT    NOT NULL,
    CONSTRAINT PK_turnos_sucursales PRIMARY KEY (nro_restaurante, nro_sucursal, hora_desde),
    CONSTRAINT FK_turnos_sucursales_sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES dbo.sucursales (nro_restaurante, nro_sucursal),
    CONSTRAINT CK_turnos_rango_valido CHECK (hora_desde < hora_hasta)
);

CREATE TABLE dbo.zonas_turnos_sucursales (
    nro_restaurante  INT    NOT NULL,
    nro_sucursal     INT    NOT NULL,
    cod_zona         INT    NOT NULL,
    hora_desde       TIME   NOT NULL,
    permite_menores  BIT    NOT NULL,
    CONSTRAINT PK_zonas_turnos_sucursales 
        PRIMARY KEY (nro_restaurante, nro_sucursal, cod_zona, hora_desde),
    CONSTRAINT FK_zts_turnos
        FOREIGN KEY (nro_restaurante, nro_sucursal, hora_desde)
        REFERENCES dbo.turnos_sucursales (nro_restaurante, nro_sucursal, hora_desde),
    CONSTRAINT FK_zts_zonas_sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal, cod_zona)
        REFERENCES dbo.zonas_sucursales (nro_restaurante, nro_sucursal, cod_zona)
);

/* =======================
   Contenidos (restaurante/sucursal)
   ======================= */

CREATE TABLE dbo.contenidos (
    nro_restaurante       INT             NOT NULL,
    nro_contenido         INT             NOT NULL,
    contenido_a_publicar  VARCHAR(1000)   NULL,
    imagen_a_publicar     VARCHAR(500)    NULL, -- URL o ruta
    publicado             BIT             NOT NULL DEFAULT 0,
    costo_click           DECIMAL(12,2)   NULL,
    nro_sucursal          INT             NULL, -- si NULL: aplica al restaurante
    CONSTRAINT PK_contenidos PRIMARY KEY (nro_restaurante, nro_contenido),
    CONSTRAINT FK_contenidos_restaurantes
        FOREIGN KEY (nro_restaurante) REFERENCES dbo.restaurantes (nro_restaurante),
    CONSTRAINT FK_contenidos_sucursal
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES dbo.sucursales (nro_restaurante, nro_sucursal)
);

/* =======================
   Tipificaciones por sucursal
   ======================= */

CREATE TABLE dbo.tipos_comidas_sucursales (
    nro_restaurante   INT   NOT NULL,
    nro_sucursal      INT   NOT NULL,
    nro_tipo_comida   INT   NOT NULL,
    habilitado        BIT   NOT NULL,
    CONSTRAINT PK_tipos_comidas_sucursales 
        PRIMARY KEY (nro_restaurante, nro_sucursal, nro_tipo_comida),
    CONSTRAINT FK_tcs_sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES dbo.sucursales (nro_restaurante, nro_sucursal),
    CONSTRAINT FK_tcs_tipos_comidas
        FOREIGN KEY (nro_tipo_comida) REFERENCES dbo.tipos_comidas (nro_tipo_comida)
);

CREATE TABLE dbo.especialidades_alimentarias_sucursales (
    nro_restaurante   INT   NOT NULL,
    nro_sucursal      INT   NOT NULL,
    nro_restriccion   INT   NOT NULL,
    habilitada        BIT   NOT NULL,
    CONSTRAINT PK_especialidades_alimentarias_sucursales
        PRIMARY KEY (nro_restaurante, nro_sucursal, nro_restriccion),
    CONSTRAINT FK_eas_sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES dbo.sucursales (nro_restaurante, nro_sucursal),
    CONSTRAINT FK_eas_restricciones
        FOREIGN KEY (nro_restriccion) REFERENCES dbo.especialidades_alimentarias (nro_restriccion)
);

CREATE TABLE dbo.estilos_sucursales (
    nro_restaurante   INT   NOT NULL,
    nro_sucursal      INT   NOT NULL,
    nro_estilo        INT   NOT NULL,
    habilitado        BIT   NOT NULL,
    CONSTRAINT PK_estilos_sucursales 
        PRIMARY KEY (nro_restaurante, nro_sucursal, nro_estilo),
    CONSTRAINT FK_es_sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES dbo.sucursales (nro_restaurante, nro_sucursal),
    CONSTRAINT FK_es_estilos
        FOREIGN KEY (nro_estilo) REFERENCES dbo.estilos (nro_estilo)
);

/* =======================
   Clientes y Reservas
   ======================= */

CREATE TABLE dbo.clientes (
    nro_cliente   INT            NOT NULL,
    apellido      VARCHAR(120)   NOT NULL,
    nombre        VARCHAR(120)   NOT NULL,
    correo        VARCHAR(200)   NOT NULL,
    telefonos     VARCHAR(120)   NULL,
    CONSTRAINT PK_clientes PRIMARY KEY (nro_cliente),
    CONSTRAINT UQ_clientes_correo UNIQUE (correo)
);

CREATE TABLE dbo.reservas_sucursales (
    cod_reserva       INT            NOT NULL,
    nro_cliente       INT            NOT NULL,
    fecha_reserva     DATE           NOT NULL,
    hora_reserva      TIME           NOT NULL,
    nro_restaurante   INT            NOT NULL,
    nro_sucursal      INT            NOT NULL,
    cod_zona          INT            NOT NULL,
    hora_desde        TIME           NOT NULL,  -- FK al turno
    cant_adultos      INT            NOT NULL,
    cant_menores      INT            NOT NULL DEFAULT 0,
    costo_reserva     DECIMAL(12,2)  NULL,
    cancelada         BIT            NOT NULL DEFAULT 0,
    fecha_cancelacion DATE           NULL,
    CONSTRAINT PK_reservas_sucursales PRIMARY KEY (cod_reserva),
    CONSTRAINT FK_reservas_clientes
        FOREIGN KEY (nro_cliente) REFERENCES dbo.clientes (nro_cliente),
    CONSTRAINT FK_reservas_zonas_turnos
        FOREIGN KEY (nro_restaurante, nro_sucursal, cod_zona, hora_desde)
        REFERENCES dbo.zonas_turnos_sucursales (nro_restaurante, nro_sucursal, cod_zona, hora_desde),
    CONSTRAINT CK_reservas_cant_no_neg CHECK (cant_adultos >= 0 AND cant_menores >= 0)
);

/* =======================
   Índices recomendados (FK lookups)
   ======================= */

CREATE INDEX IX_localidades_codprov ON dbo.localidades (cod_provincia);
CREATE INDEX IX_sucursales_localidad ON dbo.sucursales (nro_localidad);
CREATE INDEX IX_sucursales_categoria ON dbo.sucursales (nro_categoria);
CREATE INDEX IX_zs_sucursal ON dbo.zonas_sucursales (nro_restaurante, nro_sucursal);
CREATE INDEX IX_ts_sucursal ON dbo.turnos_sucursales (nro_restaurante, nro_sucursal);
CREATE INDEX IX_zts_turno ON dbo.zonas_turnos_sucursales (nro_restaurante, nro_sucursal, hora_desde);
CREATE INDEX IX_contenidos_sucursal ON dbo.contenidos (nro_restaurante, nro_sucursal);
CREATE INDEX IX_tcs_sucursal ON dbo.tipos_comidas_sucursales (nro_restaurante, nro_sucursal);
CREATE INDEX IX_eas_sucursal ON dbo.especialidades_alimentarias_sucursales (nro_restaurante, nro_sucursal);
CREATE INDEX IX_es_sucursal  ON dbo.estilos_sucursales (nro_restaurante, nro_sucursal);
CREATE INDEX IX_reservas_turno_zona ON dbo.reservas_sucursales (nro_restaurante, nro_sucursal, cod_zona, hora_desde);
CREATE INDEX IX_reservas_cliente ON dbo.reservas_sucursales (nro_cliente);
GO
