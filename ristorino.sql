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
