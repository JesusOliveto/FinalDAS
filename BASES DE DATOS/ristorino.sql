/* =========================================================
   Base de datos: RISTORINO
   Motor: Microsoft SQL Server (T-SQL)
   ========================================================= */

-- Crear/usar la base
IF DB_ID('RISTORINO') IS NULL CREATE DATABASE RISTORINO;
GO
USE RISTORINO;
GO

/* =========================================================
   DROP en orden seguro (hijos → padres)
   ========================================================= */
IF OBJECT_ID('dbo.preferencias_reservas_restaurantes','U') IS NOT NULL DROP TABLE dbo.preferencias_reservas_restaurantes;
IF OBJECT_ID('dbo.reservas_restaurantes','U') IS NOT NULL DROP TABLE dbo.reservas_restaurantes;
IF OBJECT_ID('dbo.clicks_contenidos_restaurantes','U') IS NOT NULL DROP TABLE dbo.clicks_contenidos_restaurantes;

IF OBJECT_ID('dbo.idiomas_zonas_suc_restaurantes','U') IS NOT NULL DROP TABLE dbo.idiomas_zonas_suc_restaurantes;
IF OBJECT_ID('dbo.zonas_turnos_sucursales_restaurantes','U') IS NOT NULL DROP TABLE dbo.zonas_turnos_sucursales_restaurantes;
IF OBJECT_ID('dbo.turnos_sucursales_restaurantes','U') IS NOT NULL DROP TABLE dbo.turnos_sucursales_restaurantes;
IF OBJECT_ID('dbo.zonas_sucursales_restaurantes','U') IS NOT NULL DROP TABLE dbo.zonas_sucursales_restaurantes;

IF OBJECT_ID('dbo.contenidos_restaurantes','U') IS NOT NULL DROP TABLE dbo.contenidos_restaurantes;
IF OBJECT_ID('dbo.preferencias_restaurantes','U') IS NOT NULL DROP TABLE dbo.preferencias_restaurantes;
IF OBJECT_ID('dbo.preferencias_clientes','U') IS NOT NULL DROP TABLE dbo.preferencias_clientes;
IF OBJECT_ID('dbo.configuracion_restaurantes','U') IS NOT NULL DROP TABLE dbo.configuracion_restaurantes;

IF OBJECT_ID('dbo.idiomas_dominio_cat_preferencias','U') IS NOT NULL DROP TABLE dbo.idiomas_dominio_cat_preferencias;
IF OBJECT_ID('dbo.idiomas_categorias_preferencias','U') IS NOT NULL DROP TABLE dbo.idiomas_categorias_preferencias;

IF OBJECT_ID('dbo.sucursales_restaurantes','U') IS NOT NULL DROP TABLE dbo.sucursales_restaurantes;

IF OBJECT_ID('dbo.clientes','U') IS NOT NULL DROP TABLE dbo.clientes;

IF OBJECT_ID('dbo.dominio_categorias_preferencias','U') IS NOT NULL DROP TABLE dbo.dominio_categorias_preferencias;
IF OBJECT_ID('dbo.categorias_preferencias','U') IS NOT NULL DROP TABLE dbo.categorias_preferencias;

IF OBJECT_ID('dbo.idiomas_estados','U') IS NOT NULL DROP TABLE dbo.idiomas_estados;
IF OBJECT_ID('dbo.estados_reservas','U') IS NOT NULL DROP TABLE dbo.estados_reservas;

IF OBJECT_ID('dbo.idiomas','U') IS NOT NULL DROP TABLE dbo.idiomas;

IF OBJECT_ID('dbo.atributos','U') IS NOT NULL DROP TABLE dbo.atributos;

IF OBJECT_ID('dbo.localidades','U') IS NOT NULL DROP TABLE dbo.localidades;
IF OBJECT_ID('dbo.provincias','U') IS NOT NULL DROP TABLE dbo.provincias;

IF OBJECT_ID('dbo.restaurantes','U') IS NOT NULL DROP TABLE dbo.restaurantes;

IF OBJECT_ID('dbo.costos','U') IS NOT NULL DROP TABLE dbo.costos;
GO

/* =========================================================
   MAESTROS BÁSICOS
   ========================================================= */

CREATE TABLE dbo.provincias (
    cod_provincia  INT           NOT NULL,
    nom_provincia  VARCHAR(100)  NOT NULL,
    CONSTRAINT PK_provincias PRIMARY KEY (cod_provincia)
);

CREATE TABLE dbo.localidades (
    nro_localidad  INT           NOT NULL,
    nom_localidad  VARCHAR(120)  NOT NULL,
    cod_provincia  INT           NOT NULL,
    CONSTRAINT PK_localidades PRIMARY KEY (nro_localidad),
    CONSTRAINT UQ_localidades_codprov_nom UNIQUE (cod_provincia, nom_localidad),
    CONSTRAINT FK_localidades_provincias
        FOREIGN KEY (cod_provincia) REFERENCES dbo.provincias(cod_provincia)
);

CREATE TABLE dbo.restaurantes (
    nro_restaurante INT            NOT NULL,
    razon_social    VARCHAR(200)   NOT NULL,
    cuit            VARCHAR(20)    NOT NULL,
    CONSTRAINT PK_restaurantes PRIMARY KEY (nro_restaurante),
    CONSTRAINT UQ_restaurantes_cuit UNIQUE (cuit)
);

CREATE TABLE dbo.atributos (
    cod_atributo  INT            NOT NULL,
    nom_atributo  VARCHAR(120)   NOT NULL,
    tipo_dato     VARCHAR(30)    NOT NULL,
    CONSTRAINT PK_atributos PRIMARY KEY (cod_atributo)
);

CREATE TABLE dbo.categorias_preferencias (
    cod_categoria  INT            NOT NULL,
    nom_categoria  VARCHAR(120)   NOT NULL,
    CONSTRAINT PK_categorias_preferencias PRIMARY KEY (cod_categoria)
);

CREATE TABLE dbo.idiomas (
    nro_idioma   INT            NOT NULL,
    nom_idioma   VARCHAR(100)   NOT NULL,
    cod_idioma   VARCHAR(10)    NOT NULL,
    CONSTRAINT PK_idiomas PRIMARY KEY (nro_idioma),
    CONSTRAINT UQ_idiomas_cod UNIQUE (cod_idioma)
);

/* =========================================================
   CONFIGURACIONES y DOMINIOS DE PREFERENCIAS
   ========================================================= */

CREATE TABLE dbo.configuracion_restaurantes (
    nro_restaurante  INT           NOT NULL,
    cod_atributo     INT           NOT NULL,
    valor            VARCHAR(1000) NULL,
    CONSTRAINT PK_config_restaurantes PRIMARY KEY (nro_restaurante, cod_atributo),
    CONSTRAINT FK_config_restaurantes_rest
        FOREIGN KEY (nro_restaurante) REFERENCES dbo.restaurantes(nro_restaurante),
    CONSTRAINT FK_config_restaurantes_atrib
        FOREIGN KEY (cod_atributo)    REFERENCES dbo.atributos(cod_atributo)
);

CREATE TABLE dbo.dominio_categorias_preferencias (
    cod_categoria       INT           NOT NULL,
    nro_valor_dominio   INT           NOT NULL,
    nom_valor_dominio   VARCHAR(150)  NOT NULL,
    CONSTRAINT PK_dom_cat_pref PRIMARY KEY (cod_categoria, nro_valor_dominio),
    CONSTRAINT FK_dom_cat_pref_categoria
        FOREIGN KEY (cod_categoria) REFERENCES dbo.categorias_preferencias(cod_categoria)
);

CREATE TABLE dbo.idiomas_categorias_preferencias (
    cod_categoria   INT            NOT NULL,
    nro_idioma      INT            NOT NULL,
    categoria       VARCHAR(150)   NOT NULL,
    desc_categoria  VARCHAR(500)   NULL,
    CONSTRAINT PK_idiomas_cat_pref PRIMARY KEY (cod_categoria, nro_idioma),
    CONSTRAINT FK_idiomas_cat_pref_cat
        FOREIGN KEY (cod_categoria) REFERENCES dbo.categorias_preferencias(cod_categoria),
    CONSTRAINT FK_idiomas_cat_pref_idioma
        FOREIGN KEY (nro_idioma)    REFERENCES dbo.idiomas(nro_idioma)
);

CREATE TABLE dbo.idiomas_dominio_cat_preferencias (
    cod_categoria       INT            NOT NULL,
    nro_valor_dominio   INT            NOT NULL,
    nro_idioma          INT            NOT NULL,
    valor_dominio       VARCHAR(150)   NOT NULL,
    desc_valor_dominio  VARCHAR(500)   NULL,
    CONSTRAINT PK_idiomas_dom_cat_pref PRIMARY KEY (cod_categoria, nro_valor_dominio, nro_idioma),
    CONSTRAINT FK_idiomas_dom_cat_pref_dom
        FOREIGN KEY (cod_categoria, nro_valor_dominio)
        REFERENCES dbo.dominio_categorias_preferencias(cod_categoria, nro_valor_dominio),
    CONSTRAINT FK_idiomas_dom_cat_pref_idioma
        FOREIGN KEY (nro_idioma) REFERENCES dbo.idiomas(nro_idioma)
);

/* =========================================================
   SUCURSALES
   ========================================================= */

CREATE TABLE dbo.sucursales_restaurantes (
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
    min_tolerencia_reserva    INT            NOT NULL,
    cod_sucursal_restaurante  VARCHAR(30)    NOT NULL,
    CONSTRAINT PK_sucursales_restaurantes PRIMARY KEY (nro_restaurante, nro_sucursal),
    CONSTRAINT UQ_suc_rest_cod UNIQUE (nro_restaurante, cod_sucursal_restaurante),
    CONSTRAINT FK_suc_rest_restaurantes
        FOREIGN KEY (nro_restaurante) REFERENCES dbo.restaurantes(nro_restaurante),
    CONSTRAINT FK_suc_rest_localidades
        FOREIGN KEY (nro_localidad)  REFERENCES dbo.localidades(nro_localidad),
    CONSTRAINT CK_suc_rest_tot_no_neg CHECK (total_comensales >= 0),
    CONSTRAINT CK_suc_rest_tol_no_neg CHECK (min_tolerencia_reserva >= 0)
);

/* =========================================================
   PREFERENCIAS por RESTAURANTE y por CLIENTE
   ========================================================= */

CREATE TABLE dbo.preferencias_restaurantes (
    nro_restaurante     INT           NOT NULL,
    cod_categoria       INT           NOT NULL,
    nro_valor_dominio   INT           NOT NULL,
    nro_preferencia     INT           NOT NULL,
    observaciones       VARCHAR(500)  NULL,
    nro_sucursal        INT           NULL,
    CONSTRAINT PK_pref_restaurantes PRIMARY KEY (nro_restaurante, cod_categoria, nro_valor_dominio, nro_preferencia),
    CONSTRAINT FK_pref_rest_rest       FOREIGN KEY (nro_restaurante) REFERENCES dbo.restaurantes(nro_restaurante),
    CONSTRAINT FK_pref_rest_dom        FOREIGN KEY (cod_categoria, nro_valor_dominio)
        REFERENCES dbo.dominio_categorias_preferencias(cod_categoria, nro_valor_dominio),
    CONSTRAINT FK_pref_rest_sucursal   FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES dbo.sucursales_restaurantes(nro_restaurante, nro_sucursal)
);

CREATE TABLE dbo.clientes (
    nro_cliente   INT            NOT NULL,
    apellido      VARCHAR(120)   NOT NULL,
    nombre        VARCHAR(120)   NOT NULL,
    clave         VARCHAR(200)   NOT NULL,
    correo        VARCHAR(200)   NOT NULL,
    telefonos     VARCHAR(120)   NULL,
    nro_localidad INT            NOT NULL,
    habilitado    BIT            NOT NULL DEFAULT 1,
    CONSTRAINT PK_clientes PRIMARY KEY (nro_cliente),
    CONSTRAINT UQ_clientes_correo UNIQUE (correo),
    CONSTRAINT FK_clientes_localidades FOREIGN KEY (nro_localidad) REFERENCES dbo.localidades(nro_localidad)
);

CREATE TABLE dbo.preferencias_clientes (
    nro_cliente        INT           NOT NULL,
    cod_categoria      INT           NOT NULL,
    nro_valor_dominio  INT           NOT NULL,
    observaciones      VARCHAR(500)  NULL,
    CONSTRAINT PK_pref_clientes PRIMARY KEY (nro_cliente, cod_categoria, nro_valor_dominio),
    CONSTRAINT FK_pref_cli_cliente  FOREIGN KEY (nro_cliente) REFERENCES dbo.clientes(nro_cliente),
    CONSTRAINT FK_pref_cli_dom      FOREIGN KEY (cod_categoria, nro_valor_dominio)
        REFERENCES dbo.dominio_categorias_preferencias(cod_categoria, nro_valor_dominio)
);

/* =========================================================
   CONTENIDOS (por restaurante, idioma y opcionalmente sucursal)
   ========================================================= */

CREATE TABLE dbo.contenidos_restaurantes (
    nro_restaurante        INT             NOT NULL,
    nro_idioma             INT             NOT NULL,
    nro_contenido          INT             NOT NULL,
    nro_sucursal           INT             NULL,           -- NULL => contenido a nivel restaurante
    contenido_promocional  VARCHAR(1000)   NULL,
    imagen_promocional     VARCHAR(500)    NULL,
    contenido_a_publicar   VARCHAR(2000)   NULL,
    fecha_ini_vigencia     DATE            NULL,
    fecha_fin_vigencia     DATE            NULL,
    costo_click            DECIMAL(12,2)   NULL,
    cod_contenido_restaurante VARCHAR(40)  NULL,          -- según modelo lógico
    CONSTRAINT PK_contenidos_rest PRIMARY KEY (nro_restaurante, nro_idioma, nro_contenido),
    CONSTRAINT FK_cont_rest_rest FOREIGN KEY (nro_restaurante) REFERENCES dbo.restaurantes(nro_restaurante),
    CONSTRAINT FK_cont_rest_idioma FOREIGN KEY (nro_idioma) REFERENCES dbo.idiomas(nro_idioma),
    CONSTRAINT FK_cont_rest_sucursal FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES dbo.sucursales_restaurantes(nro_restaurante, nro_sucursal)
);

/* =========================================================
   TURNOS, ZONAS y su cruce
   ========================================================= */

CREATE TABLE dbo.turnos_sucursales_restaurantes (
    nro_restaurante  INT    NOT NULL,
    nro_sucursal     INT    NOT NULL,
    hora_desde       TIME   NOT NULL,
    hora_hasta       TIME   NOT NULL,
    habilitado       BIT    NOT NULL,
    CONSTRAINT PK_turnos_suc_rest PRIMARY KEY (nro_restaurante, nro_sucursal, hora_desde),
    CONSTRAINT FK_turnos_suc_rest_sucursal FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES dbo.sucursales_restaurantes(nro_restaurante, nro_sucursal),
    CONSTRAINT CK_turnos_rango_valido CHECK (hora_desde < hora_hasta)
);

CREATE TABLE dbo.zonas_sucursales_restaurantes (
    nro_restaurante  INT            NOT NULL,
    nro_sucursal     INT            NOT NULL,
    cod_zona         INT            NOT NULL,
    desc_zona        VARCHAR(500)   NULL,
    cant_comensales  INT            NOT NULL,
    permite_menores  BIT            NOT NULL,
    habilitada       BIT            NOT NULL,
    CONSTRAINT PK_zonas_suc_rest PRIMARY KEY (nro_restaurante, nro_sucursal, cod_zona),
    CONSTRAINT FK_zonas_suc_rest_sucursal FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES dbo.sucursales_restaurantes(nro_restaurante, nro_sucursal),
    CONSTRAINT CK_zonas_suc_rest_cant_no_neg CHECK (cant_comensales >= 0)
);

CREATE TABLE dbo.idiomas_zonas_suc_restaurantes (
    nro_restaurante  INT            NOT NULL,
    nro_sucursal     INT            NOT NULL,
    cod_zona         INT            NOT NULL,
    nro_idioma       INT            NOT NULL,
    zona             VARCHAR(150)   NOT NULL,
    desc_zona        VARCHAR(500)   NULL,
    CONSTRAINT PK_idiomas_zonas_suc_rest PRIMARY KEY (nro_restaurante, nro_sucursal, cod_zona, nro_idioma),
    CONSTRAINT FK_idiomas_zonas_suc_rest_zona FOREIGN KEY (nro_restaurante, nro_sucursal, cod_zona)
        REFERENCES dbo.zonas_sucursales_restaurantes(nro_restaurante, nro_sucursal, cod_zona),
    CONSTRAINT FK_idiomas_zonas_suc_rest_idioma FOREIGN KEY (nro_idioma)
        REFERENCES dbo.idiomas(nro_idioma)
);

CREATE TABLE dbo.zonas_turnos_sucursales_restaurantes (
    nro_restaurante  INT   NOT NULL,
    nro_sucursal     INT   NOT NULL,
    cod_zona         INT   NOT NULL,
    hora_desde       TIME  NOT NULL,
    permite_menores  BIT   NOT NULL,
    CONSTRAINT PK_zonas_turnos_suc_rest PRIMARY KEY (nro_restaurante, nro_sucursal, cod_zona, hora_desde),
    CONSTRAINT FK_ztsr_turno FOREIGN KEY (nro_restaurante, nro_sucursal, hora_desde)
        REFERENCES dbo.turnos_sucursales_restaurantes(nro_restaurante, nro_sucursal, hora_desde),
    CONSTRAINT FK_ztsr_zona  FOREIGN KEY (nro_restaurante, nro_sucursal, cod_zona)
        REFERENCES dbo.zonas_sucursales_restaurantes(nro_restaurante, nro_sucursal, cod_zona)
);

/* =========================================================
   ESTADOS de RESERVA (y traducciones)
   ========================================================= */

CREATE TABLE dbo.estados_reservas (
    cod_estado  INT            NOT NULL,
    nom_estado  VARCHAR(120)   NOT NULL,
    CONSTRAINT PK_estados_reservas PRIMARY KEY (cod_estado)
);

CREATE TABLE dbo.idiomas_estados (
    cod_estado  INT            NOT NULL,
    nro_idioma  INT            NOT NULL,
    estado      VARCHAR(120)   NOT NULL,
    CONSTRAINT PK_idiomas_estados PRIMARY KEY (cod_estado, nro_idioma),
    CONSTRAINT FK_idiomas_estados_estado FOREIGN KEY (cod_estado) REFERENCES dbo.estados_reservas(cod_estado),
    CONSTRAINT FK_idiomas_estados_idioma FOREIGN KEY (nro_idioma) REFERENCES dbo.idiomas(nro_idioma)
);

/* =========================================================
   RESERVAS y PREFERENCIAS de la RESERVA
   ========================================================= */

CREATE TABLE dbo.reservas_restaurantes (
    nro_cliente           INT            NOT NULL,
    nro_reserva           INT            NOT NULL,
    cod_reserva_sucursal  VARCHAR(40)    NOT NULL,  -- AK legible
    fecha_hora_registro   DATETIME2(0)   NOT NULL DEFAULT SYSDATETIME(), -- (modelo lógico)
    fecha_reserva         DATE           NOT NULL,
    hora_reserva          TIME           NOT NULL,  -- FK a hora_desde del cruce
    nro_restaurante       INT            NOT NULL,
    nro_sucursal          INT            NOT NULL,
    cod_zona              INT            NOT NULL,
    cant_adultos          INT            NOT NULL,
    cant_menores          INT            NOT NULL DEFAULT 0,
    cod_estado            INT            NOT NULL,
    fecha_cancelacion     DATE           NULL,
    costo_reserva         DECIMAL(12,2)  NULL,
    CONSTRAINT PK_reservas_restaurantes PRIMARY KEY (nro_cliente, nro_reserva),
    CONSTRAINT UQ_reservas_cod_sucursal UNIQUE (cod_reserva_sucursal),
    CONSTRAINT FK_reservas_cliente FOREIGN KEY (nro_cliente) REFERENCES dbo.clientes(nro_cliente),
    CONSTRAINT FK_reservas_estado  FOREIGN KEY (cod_estado)  REFERENCES dbo.estados_reservas(cod_estado),
    CONSTRAINT FK_reservas_turno_zona
        FOREIGN KEY (nro_restaurante, nro_sucursal, cod_zona, hora_reserva)
        REFERENCES dbo.zonas_turnos_sucursales_restaurantes(nro_restaurante, nro_sucursal, cod_zona, hora_desde),
    CONSTRAINT CK_reservas_cant_nonneg CHECK (cant_adultos >= 0 AND cant_menores >= 0)
);

CREATE TABLE dbo.preferencias_reservas_restaurantes (
    nro_cliente        INT  NOT NULL,
    nro_reserva        INT  NOT NULL,
    nro_restaurante    INT  NOT NULL,
    cod_categoria      INT  NOT NULL,
    nro_valor_dominio  INT  NOT NULL,
    nro_preferencia    INT  NOT NULL,
    observaciones      VARCHAR(500) NULL,
    CONSTRAINT PK_pref_reservas_rest PRIMARY KEY (
        nro_cliente, nro_reserva, cod_categoria, nro_valor_dominio, nro_preferencia
    ),
    CONSTRAINT FK_pref_res_rest_reserva
        FOREIGN KEY (nro_cliente, nro_reserva)
        REFERENCES dbo.reservas_restaurantes(nro_cliente, nro_reserva),
    CONSTRAINT FK_pref_res_rest_pref_rest
        FOREIGN KEY (nro_restaurante, cod_categoria, nro_valor_dominio, nro_preferencia)
        REFERENCES dbo.preferencias_restaurantes(nro_restaurante, cod_categoria, nro_valor_dominio, nro_preferencia),
    CONSTRAINT FK_pref_res_rest_dom
        FOREIGN KEY (cod_categoria, nro_valor_dominio)
        REFERENCES dbo.dominio_categorias_preferencias(cod_categoria, nro_valor_dominio)
);

/* =========================================================
   COSTOS (vigencias)
   ========================================================= */
CREATE TABLE dbo.costos (
    tipo_costo         VARCHAR(50)  NOT NULL,
    fecha_ini_vigencia DATE         NOT NULL,
    fecha_fin_vigencia DATE         NULL,
    monto              DECIMAL(12,2) NOT NULL,
    CONSTRAINT PK_costos PRIMARY KEY (tipo_costo, fecha_ini_vigencia),
    CONSTRAINT CK_costos_monto_no_neg CHECK (monto >= 0)
);

/* =========================================================
   CLICKS en CONTENIDOS (modelo lógico)
   ========================================================= */
CREATE TABLE dbo.clicks_contenidos_restaurantes (
    nro_restaurante      INT            NOT NULL,
    nro_idioma           INT            NOT NULL,
    nro_contenido        INT            NOT NULL,
    nro_click            INT            NOT NULL,
    fecha_hora_registro  DATETIME2(0)   NOT NULL DEFAULT SYSDATETIME(),
    nro_cliente          INT            NOT NULL,
    costo_click          DECIMAL(12,2)  NULL,
    notificado           BIT            NOT NULL DEFAULT 0,
    CONSTRAINT PK_clicks_cont_rest PRIMARY KEY (nro_restaurante, nro_idioma, nro_contenido, nro_click),
    CONSTRAINT FK_clicks_cont_rest_contenido
        FOREIGN KEY (nro_restaurante, nro_idioma, nro_contenido)
        REFERENCES dbo.contenidos_restaurantes(nro_restaurante, nro_idioma, nro_contenido),
    CONSTRAINT FK_clicks_cont_rest_cliente
        FOREIGN KEY (nro_cliente) REFERENCES dbo.clientes(nro_cliente)
);

/* =========================================================
   ÍNDICES recomendados
   ========================================================= */

-- Localidades
CREATE INDEX IX_localidades_codprov ON dbo.localidades(cod_provincia);

-- Sucursales
CREATE INDEX IX_suc_rest_localidad ON dbo.sucursales_restaurantes(nro_localidad);
CREATE INDEX IX_suc_rest_codlegible ON dbo.sucursales_restaurantes(nro_restaurante, cod_sucursal_restaurante);

-- Configuración
CREATE INDEX IX_conf_rest_atrib ON dbo.configuracion_restaurantes(cod_atributo);

-- Preferencias
CREATE INDEX IX_dom_cat_pref_dom ON dbo.dominio_categorias_preferencias(cod_categoria, nro_valor_dominio);
CREATE INDEX IX_pref_rest_sucursal ON dbo.preferencias_restaurantes(nro_restaurante, nro_sucursal);
CREATE INDEX IX_pref_cli_dom ON dbo.preferencias_clientes(cod_categoria, nro_valor_dominio);

-- Contenidos
CREATE INDEX IX_cont_rest_sucursal ON dbo.contenidos_restaurantes(nro_restaurante, nro_sucursal);

-- Turnos/Zonas
CREATE INDEX IX_turnos_suc_rest ON dbo.turnos_sucursales_restaurantes(nro_restaurante, nro_sucursal);
CREATE INDEX IX_zonas_suc_rest ON dbo.zonas_sucursales_restaurantes(nro_restaurante, nro_sucursal);
CREATE INDEX IX_ztsr_turno ON dbo.zonas_turnos_sucursales_restaurantes(nro_restaurante, nro_sucursal, hora_desde);

-- Estados
CREATE INDEX IX_idiomas_estados_idioma ON dbo.idiomas_estados(nro_idioma);

-- Reservas
CREATE INDEX IX_reservas_por_turno_zona ON dbo.reservas_restaurantes(nro_restaurante, nro_sucursal, cod_zona, hora_reserva);
CREATE INDEX IX_reservas_por_estado ON dbo.reservas_restaurantes(cod_estado);
CREATE INDEX IX_reservas_por_cliente ON dbo.reservas_restaurantes(nro_cliente);

-- Clicks
CREATE INDEX IX_clicks_cont_rest_cliente ON dbo.clicks_contenidos_restaurantes(nro_cliente);
GO
/* =========================================================
   SEED: PROVINCIAS y LOCALIDADES de ARGENTINA
   - Motor: SQL Server (T-SQL)
   - Idempotente: usa MERGE para upsert
   - Códigos:
       * Provincias: 1..24 (incluye CABA como jurisdicción)
       * Localidades: cod_provincia*100 + correlativo (1..5)
   ========================================================= */

-- Provincias (AR)
MERGE dbo.provincias AS tgt
USING (
    VALUES
        (1,  'Buenos Aires'),
        (2,  'Catamarca'),
        (3,  'Chaco'),
        (4,  'Chubut'),
        (5,  'Córdoba'),
        (6,  'Corrientes'),
        (7,  'Entre Ríos'),
        (8,  'Formosa'),
        (9,  'Jujuy'),
        (10, 'La Pampa'),
        (11, 'La Rioja'),
        (12, 'Mendoza'),
        (13, 'Misiones'),
        (14, 'Neuquén'),
        (15, 'Río Negro'),
        (16, 'Salta'),
        (17, 'San Juan'),
        (18, 'San Luis'),
        (19, 'Santa Cruz'),
        (20, 'Santa Fe'),
        (21, 'Santiago del Estero'),
        (22, 'Tierra del Fuego, Antártida e Islas del Atlántico Sur'),
    (23, 'Tucumán'),
    (24, 'Ciudad Autónoma de Buenos Aires')
) AS src(cod_provincia, nom_provincia)
ON tgt.cod_provincia = src.cod_provincia
WHEN MATCHED THEN UPDATE SET tgt.nom_provincia = src.nom_provincia
WHEN NOT MATCHED THEN INSERT (cod_provincia, nom_provincia)
VALUES (src.cod_provincia, src.nom_provincia);
GO
/* =========================================================
   SEED: SINCRONIZACIÓN INICIAL DESDE BODEGÓN (Ristorino)
   Premisas:
   - Sin reservas ni clicks cargados
   - Único idioma: Español (es-AR)
   - Sin clientes cargados
   - Atributos + Configuración: diseño invertido (catálogos del restaurante como atributos/valores)
   ========================================================= */

-- Idioma base (Español)
INSERT INTO dbo.idiomas (nro_idioma, nom_idioma, cod_idioma)
VALUES (1, 'Español', 'es-AR');
GO

-- Restaurante comunicado: Bodegón La Esquina
INSERT INTO dbo.restaurantes (nro_restaurante, razon_social, cuit)
VALUES (1, 'Bodegón La Esquina', '30-71234567-8');
GO

-- Sucursales del Bodegón (localidad Córdoba: 501)
INSERT INTO dbo.sucursales_restaurantes (
    nro_restaurante, nro_sucursal, nom_sucursal, calle, nro_calle, barrio, nro_localidad,
    cod_postal, telefonos, total_comensales, min_tolerencia_reserva, cod_sucursal_restaurante
) VALUES
    (1, 1, 'Av. Colón',        'Av. Colón',        3450, 'Alta Córdoba',       501, '5000', '+54 351 555-0101', 120, 15, 'COLON'),
    (1, 2, 'Bv. San Juan',     'Bv. San Juan',      950, 'Centro',             501, '5000', '+54 351 555-0202',  90, 15, 'SANJUAN'),
    (1, 3, 'Av. Rafael Núñez', 'Av. Rafael Núñez', 5235, 'Cerro de las Rosas', 501, '5009', '+54 351 555-0303',  80, 15, 'RAFANUNEZ');
GO

-- Zonas habilitadas por sucursal (capacidad por zona reducida 10..20)
INSERT INTO dbo.zonas_sucursales_restaurantes (
    nro_restaurante, nro_sucursal, cod_zona, desc_zona, cant_comensales, permite_menores, habilitada
) VALUES
    -- Sucursal 1
    (1, 1, 1, 'Salón Principal', 20, 1, 1),
    (1, 1, 2, 'Patio Interno',   18, 1, 1),
    (1, 1, 3, 'Terraza',         16, 1, 1),
    (1, 1, 4, 'Exterior',        12, 1, 1),
    -- Sucursal 2
    (1, 2, 1, 'Salón Principal', 20, 1, 1),
    (1, 2, 2, 'Patio Interno',   16, 1, 1),
    (1, 2, 4, 'Exterior',        12, 1, 1),
    -- Sucursal 3
    (1, 3, 1, 'Salón Principal', 18, 1, 1),
    (1, 3, 2, 'Patio Interno',   16, 1, 1),
    (1, 3, 5, 'Ala Norte',       15, 1, 1);
GO

-- Traducciones de zonas (Español)
INSERT INTO dbo.idiomas_zonas_suc_restaurantes (
    nro_restaurante, nro_sucursal, cod_zona, nro_idioma, zona, desc_zona
) VALUES
    (1,1,1,1,'Salón Principal', NULL),
    (1,1,2,1,'Patio Interno',   NULL),
    (1,1,3,1,'Terraza',         NULL),
    (1,1,4,1,'Exterior',        NULL),
    (1,2,1,1,'Salón Principal', NULL),
    (1,2,2,1,'Patio Interno',   NULL),
    (1,2,4,1,'Exterior',        NULL),
    (1,3,1,1,'Salón Principal', NULL),
    (1,3,2,1,'Patio Interno',   NULL),
    (1,3,5,1,'Ala Norte',       NULL);
GO

-- Turnos por sucursal (5 turnos, 3 horas)
INSERT INTO dbo.turnos_sucursales_restaurantes (nro_restaurante, nro_sucursal, hora_desde, hora_hasta, habilitado) VALUES
    -- Sucursal 1
    (1,1,'11:00','14:00',1), (1,1,'14:00','17:00',1), (1,1,'17:00','20:00',1), (1,1,'20:00','23:00',1), (1,1,'23:00','02:00',1),
    -- Sucursal 2
    (1,2,'11:00','14:00',1), (1,2,'14:00','17:00',1), (1,2,'17:00','20:00',1), (1,2,'20:00','23:00',1), (1,2,'23:00','02:00',1),
    -- Sucursal 3
    (1,3,'11:00','14:00',1), (1,3,'14:00','17:00',1), (1,3,'17:00','20:00',1), (1,3,'20:00','23:00',1), (1,3,'23:00','02:00',1);
GO

-- Cruce Zonas x Turnos (permite menores = 1)
INSERT INTO dbo.zonas_turnos_sucursales_restaurantes (nro_restaurante, nro_sucursal, cod_zona, hora_desde, permite_menores) VALUES
    -- Sucursal 1
    (1,1,1,'11:00',1),(1,1,1,'14:00',1),(1,1,1,'17:00',1),(1,1,1,'20:00',1),(1,1,1,'23:00',1),
    (1,1,2,'11:00',1),(1,1,2,'14:00',1),(1,1,2,'17:00',1),(1,1,2,'20:00',1),(1,1,2,'23:00',1),
    (1,1,3,'11:00',1),(1,1,3,'14:00',1),(1,1,3,'17:00',1),(1,1,3,'20:00',1),(1,1,3,'23:00',1),
    (1,1,4,'11:00',1),(1,1,4,'14:00',1),(1,1,4,'17:00',1),(1,1,4,'20:00',1),(1,1,4,'23:00',1),
    -- Sucursal 2
    (1,2,1,'11:00',1),(1,2,1,'14:00',1),(1,2,1,'17:00',1),(1,2,1,'20:00',1),(1,2,1,'23:00',1),
    (1,2,2,'11:00',1),(1,2,2,'14:00',1),(1,2,2,'17:00',1),(1,2,2,'20:00',1),(1,2,2,'23:00',1),
    (1,2,4,'11:00',1),(1,2,4,'14:00',1),(1,2,4,'17:00',1),(1,2,4,'20:00',1),(1,2,4,'23:00',1),
    -- Sucursal 3
    (1,3,1,'11:00',1),(1,3,1,'14:00',1),(1,3,1,'17:00',1),(1,3,1,'20:00',1),(1,3,1,'23:00',1),
    (1,3,2,'11:00',1),(1,3,2,'14:00',1),(1,3,2,'17:00',1),(1,3,2,'20:00',1),(1,3,2,'23:00',1),
    (1,3,5,'11:00',1),(1,3,5,'14:00',1),(1,3,5,'17:00',1),(1,3,5,'20:00',1),(1,3,5,'23:00',1);
GO

-- Contenidos sincronizados (Español)
INSERT INTO dbo.contenidos_restaurantes (
    nro_restaurante, nro_idioma, nro_contenido, nro_sucursal,
    contenido_promocional, imagen_promocional, contenido_a_publicar,
    fecha_ini_vigencia, fecha_fin_vigencia, costo_click, cod_contenido_restaurante
) VALUES
    (1,1,1, NULL, 'Promo Milanesa Napo + bebida', NULL, 'Promo: Milanesa napolitana con papas y bebida', CAST(GETDATE() AS DATE), NULL, 50.00, 'GEN-1'),
    (1,1,2, NULL, 'Finde Asado para compartir',   NULL, 'Finde: Asado a la parrilla - porciones para compartir', CAST(GETDATE() AS DATE), NULL, 70.00, 'GEN-2'),
    (1,1,3, NULL, 'Martes 2x1 Empanadas',         NULL, '2x1 en empanadas los martes', CAST(GETDATE() AS DATE), NULL, 30.00, 'GEN-3'),
    (1,1,4, 1,    'Lomito completo + papas',      NULL, 'Lomito completo + papas (Sucursal Av. Colón)', CAST(GETDATE() AS DATE), NULL, 40.00, 'S1-LOMITO'),
    (1,1,5, 3,    'Pollo a las brasas al peso',   NULL, 'Pollo a las brasas al peso (Sucursal Rafael Núñez)', CAST(GETDATE() AS DATE), NULL, 45.00, 'S3-POLLO');
GO

-- Diseño invertido: Atributos que representan catálogos del restaurante
INSERT INTO dbo.atributos (cod_atributo, nom_atributo, tipo_dato) VALUES
    (1, 'tipos_comidas', 'JSON'),
    (2, 'preferencias_alimentarias', 'JSON'),
    (3, 'estilos', 'JSON'),
    (4, 'zonas', 'JSON');
GO

-- Configuración del restaurante (valores como JSON)
INSERT INTO dbo.configuracion_restaurantes (nro_restaurante, cod_atributo, valor) VALUES
    (1, 1, '["Pastas","Pizzas","Lomitos","Minutas","Parrilla","Empanadas","Pollo a las brasas"]'),
    (1, 2, '["Sin TAAC (celíacos)","Vegano","Vegetariano","Sin lactosa","Hiposódico"]'),
    (1, 3, '["Argentina","Italiana","Parrilla","Rotisería"]'),
    (1, 4, '["Salón Principal","Patio Interno","Terraza","Exterior","Ala Norte"]');
GO


-- Localidades principales (5 por provincia)
MERGE dbo.localidades AS tgt
USING (
    VALUES
        -- 1 Buenos Aires
        (101, 'La Plata',                         1),
        (102, 'Mar del Plata',                    1),
        (103, 'Bahía Blanca',                     1),
        (104, 'Tandil',                           1),
        (105, 'San Nicolás de los Arroyos',       1),

        -- 2 Catamarca
        (201, 'San Fernando del Valle de Catamarca', 2),
        (202, 'Andalgalá',                        2),
        (203, 'Tinogasta',                        2),
        (204, 'Belén',                            2),
        (205, 'Santa María',                      2),

        -- 3 Chaco
        (301, 'Resistencia',                      3),
        (302, 'Presidencia Roque Sáenz Peña',     3),
        (303, 'Villa Ángela',                     3),
        (304, 'Barranqueras',                     3),
        (305, 'Charata',                          3),

        -- 4 Chubut
        (401, 'Rawson',                           4),
        (402, 'Comodoro Rivadavia',               4),
        (403, 'Trelew',                           4),
        (404, 'Puerto Madryn',                    4),
        (405, 'Esquel',                           4),

        -- 5 Córdoba
        (501, 'Córdoba',                          5),
        (502, 'Río Cuarto',                       5),
        (503, 'Villa Carlos Paz',                 5),
        (504, 'Villa María',                      5),
        (505, 'San Francisco',                    5),

        -- 6 Corrientes
        (601, 'Corrientes',                       6),
        (602, 'Goya',                             6),
        (603, 'Paso de los Libres',               6),
        (604, 'Mercedes',                         6),
        (605, 'Curuzú Cuatiá',                    6),

        -- 7 Entre Ríos
        (701, 'Paraná',                           7),
        (702, 'Concordia',                        7),
        (703, 'Gualeguaychú',                     7),
        (704, 'Concepción del Uruguay',           7),
        (705, 'Gualeguay',                        7),

        -- 8 Formosa
        (801, 'Formosa',                          8),
        (802, 'Clorinda',                         8),
        (803, 'Pirané',                           8),
        (804, 'El Colorado',                      8),
        (805, 'Ibarreta',                         8),

        -- 9 Jujuy
        (901,  'San Salvador de Jujuy',           9),
        (902,  'Palpalá',                         9),
        (903,  'Perico',                          9),
        (904,  'Libertador General San Martín',   9),
        (905,  'San Pedro de Jujuy',              9),

        -- 10 La Pampa
        (1001, 'Santa Rosa',                      10),
        (1002, 'General Pico',                    10),
        (1003, 'Toay',                            10),
        (1004, 'Realicó',                         10),
        (1005, 'General Acha',                    10),

        -- 11 La Rioja
        (1101, 'La Rioja',                        11),
        (1102, 'Chilecito',                       11),
        (1103, 'Aimogasta',                       11),
        (1104, 'Chamical',                        11),
        (1105, 'Chepes',                          11),

        -- 12 Mendoza
        (1201, 'Mendoza',                         12),
        (1202, 'Godoy Cruz',                      12),
        (1203, 'Guaymallén',                      12),
        (1204, 'Luján de Cuyo',                   12),
        (1205, 'San Rafael',                      12),

        -- 13 Misiones
        (1301, 'Posadas',                         13),
        (1302, 'Oberá',                           13),
        (1303, 'Eldorado',                        13),
        (1304, 'Puerto Iguazú',                   13),
        (1305, 'Apóstoles',                       13),

        -- 14 Neuquén
        (1401, 'Neuquén',                         14),
        (1402, 'Plottier',                        14),
        (1403, 'Centenario',                      14),
        (1404, 'Cutral Có',                       14),
        (1405, 'San Martín de los Andes',         14),

        -- 15 Río Negro
        (1501, 'Viedma',                          15),
        (1502, 'General Roca',                    15),
        (1503, 'Cipolletti',                      15),
        (1504, 'San Carlos de Bariloche',         15),
        (1505, 'Villa Regina',                    15),

        -- 16 Salta
        (1601, 'Salta',                           16),
        (1602, 'San Ramón de la Nueva Orán',      16),
        (1603, 'Tartagal',                        16),
        (1604, 'Metán',                           16),
        (1605, 'Cafayate',                        16),

        -- 17 San Juan
        (1701, 'San Juan',                        17),
        (1702, 'Rawson',                          17),
        (1703, 'Rivadavia',                       17),
        (1704, 'Chimbas',                         17),
        (1705, 'Pocito',                          17),

        -- 18 San Luis
        (1801, 'San Luis',                        18),
        (1802, 'Villa Mercedes',                  18),
        (1803, 'Merlo',                           18),
        (1804, 'La Punta',                        18),
        (1805, 'Justo Daract',                    18),

        -- 19 Santa Cruz
        (1901, 'Río Gallegos',                    19),
        (1902, 'Caleta Olivia',                   19),
        (1903, 'El Calafate',                     19),
        (1904, 'Pico Truncado',                   19),
        (1905, 'Puerto Deseado',                  19),

        -- 20 Santa Fe
        (2001, 'Santa Fe',                        20),
        (2002, 'Rosario',                         20),
        (2003, 'Rafaela',                         20),
        (2004, 'Venado Tuerto',                   20),
        (2005, 'Reconquista',                     20),

        -- 21 Santiago del Estero
        (2101, 'Santiago del Estero',             21),
        (2102, 'La Banda',                        21),
        (2103, 'Termas de Río Hondo',             21),
        (2104, 'Frías',                           21),
        (2105, 'Añatuya',                         21),

        -- 22 Tierra del Fuego, AIAS
        (2201, 'Ushuaia',                         22),
        (2202, 'Río Grande',                      22),
        (2203, 'Tolhuin',                         22),
        (2204, 'Puerto Almanza',                  22),
        (2205, 'San Sebastián',                   22),

        -- 23 Tucumán
        (2301, 'San Miguel de Tucumán',           23),
        (2302, 'Tafí Viejo',                      23),
        (2303, 'Yerba Buena',                     23),
        (2304, 'Concepción',                      23),
    (2305, 'Monteros',                        23),

    -- 24 Ciudad Autónoma de Buenos Aires (CABA)
    (2401, 'Ciudad Autónoma de Buenos Aires', 24),
    (2402, 'Palermo',                         24),
    (2403, 'Recoleta',                        24),
    (2404, 'Belgrano',                        24),
    (2405, 'Caballito',                       24)
) AS src(nro_localidad, nom_localidad, cod_provincia)
ON tgt.nro_localidad = src.nro_localidad
WHEN MATCHED THEN UPDATE SET tgt.nom_localidad = src.nom_localidad, tgt.cod_provincia = src.cod_provincia
WHEN NOT MATCHED THEN INSERT (nro_localidad, nom_localidad, cod_provincia)
VALUES (src.nro_localidad, src.nom_localidad, src.cod_provincia);
GO
/* =========================================================
   FIN SCRIPT
   ========================================================= */


   