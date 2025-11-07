/* =========================================================
   Base de datos: BODEGON
   Motor destino: Microsoft SQL Server (T-SQL)
   ========================================================= */
    
-- crear y usar la base
IF DB_ID('BODEGON') IS NULL CREATE DATABASE BODEGON;
GO


USE BODEGON;
GO

/* =======================
   DROP en orden seguro
   ======================= */
IF OBJECT_ID('dbo.reservas_sucursales','U') IS NOT NULL DROP TABLE dbo.reservas_sucursales;
IF OBJECT_ID('dbo.clicks_contenidos','U')      IS NOT NULL DROP TABLE dbo.clicks_contenidos;

IF OBJECT_ID('dbo.zonas_turnos_sucursales','U') IS NOT NULL DROP TABLE dbo.zonas_turnos_sucursales;
IF OBJECT_ID('dbo.turnos_sucursales','U')       IS NOT NULL DROP TABLE dbo.turnos_sucursales;
IF OBJECT_ID('dbo.zonas_sucursales','U')        IS NOT NULL DROP TABLE dbo.zonas_sucursales;

IF OBJECT_ID('dbo.tipos_comidas_sucursales','U')            IS NOT NULL DROP TABLE dbo.tipos_comidas_sucursales;
IF OBJECT_ID('dbo.especialidades_alimentarias_sucursales','U') IS NOT NULL DROP TABLE dbo.especialidades_alimentarias_sucursales;
IF OBJECT_ID('dbo.estilos_sucursales','U')                  IS NOT NULL DROP TABLE dbo.estilos_sucursales;

IF OBJECT_ID('dbo.contenidos','U')   IS NOT NULL DROP TABLE dbo.contenidos;
IF OBJECT_ID('dbo.clientes','U')     IS NOT NULL DROP TABLE dbo.clientes;
IF OBJECT_ID('dbo.sucursales','U')   IS NOT NULL DROP TABLE dbo.sucursales;

IF OBJECT_ID('dbo.zonas','U')                        IS NOT NULL DROP TABLE dbo.zonas;
IF OBJECT_ID('dbo.tipos_comidas','U')                IS NOT NULL DROP TABLE dbo.tipos_comidas;
IF OBJECT_ID('dbo.especialidades_alimentarias','U')  IS NOT NULL DROP TABLE dbo.especialidades_alimentarias;
IF OBJECT_ID('dbo.estilos','U')                      IS NOT NULL DROP TABLE dbo.estilos;

IF OBJECT_ID('dbo.localidades','U') IS NOT NULL DROP TABLE dbo.localidades;
IF OBJECT_ID('dbo.provincias','U')  IS NOT NULL DROP TABLE dbo.provincias;

IF OBJECT_ID('dbo.categorias_precios','U') IS NOT NULL DROP TABLE dbo.categorias_precios;
IF OBJECT_ID('dbo.restaurantes','U')      IS NOT NULL DROP TABLE dbo.restaurantes;
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
    -- AK1: (cod_provincia, nom_localidad)
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
    nro_preferencia INT            NOT NULL,
    nom_preferencia VARCHAR(120)   NOT NULL,
    CONSTRAINT PK_especialidades_alimentarias PRIMARY KEY (nro_preferencia)
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
   Turnos por sucursal y cruce con zonas
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
    -- Permitir turnos que cruzan medianoche (ej: 23:00 -> 02:00) evitando solo igualdad
    CONSTRAINT CK_turnos_rango_valido CHECK (hora_desde <> hora_hasta)
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
    nro_preferencia   INT   NOT NULL,
    habilitada        BIT   NOT NULL,
    CONSTRAINT PK_especialidades_alimentarias_sucursales
        PRIMARY KEY (nro_restaurante, nro_sucursal, nro_preferencia),
    CONSTRAINT FK_eas_sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES dbo.sucursales (nro_restaurante, nro_sucursal),
    CONSTRAINT FK_eas_preferencias
        FOREIGN KEY (nro_preferencia) REFERENCES dbo.especialidades_alimentarias (nro_preferencia)
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
   Clientes
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

/* =======================
   Clicks en contenidos (modelo lógico)
   ======================= */
CREATE TABLE dbo.clicks_contenidos (
    nro_restaurante      INT            NOT NULL,
    nro_contenido        INT            NOT NULL,
    nro_click            INT            NOT NULL,
    fecha_hora_registro  DATETIME2(0)   NOT NULL DEFAULT SYSDATETIME(),
    nro_cliente          INT            NOT NULL,
    costo_click          DECIMAL(12,2)  NULL,
    CONSTRAINT PK_clicks_contenidos PRIMARY KEY (nro_restaurante, nro_contenido, nro_click),
    CONSTRAINT FK_clicks_contenidos_contenidos
        FOREIGN KEY (nro_restaurante, nro_contenido)
        REFERENCES dbo.contenidos (nro_restaurante, nro_contenido),
    CONSTRAINT FK_clicks_contenidos_clientes
        FOREIGN KEY (nro_cliente) REFERENCES dbo.clientes (nro_cliente)
);

/* =========================================================
   PROCEDIMIENTO: Registrar click de contenido
   Uso previsto: API REST del Bodegón consumida por Ristorino
   Objetivo: Insertar un click evitando colisiones y devolviendo datos útiles.
   Parámetros:
       @nro_restaurante INT
       @nro_contenido   INT
       @nro_cliente     INT            -- cliente origen del click (puede ser proxy)
       @costo_click     DECIMAL(12,2) = NULL  -- costo recibido desde Ristorino (override)
       @fecha_registro  DATETIME2(0) = NULL   -- si NULL usa SYSDATETIME()
   Lógica:
       - Verifica que contenido exista y esté publicado (opcional, si se quiere validar publicado=1)
       - Genera nro_click incremental por contenido
       - Inserta fila y retorna JSON con los datos del click
   Respuesta JSON:
       {"nro_restaurante":1,"nro_contenido":4,"nro_click":12,"fecha_hora_registro":"2025-11-07T12:34:00","costo_click":40.00}
   ========================================================= */
IF OBJECT_ID('dbo.usp_registrar_click_contenido','P') IS NOT NULL
    DROP PROCEDURE dbo.usp_registrar_click_contenido;
GO
CREATE PROCEDURE dbo.usp_registrar_click_contenido
    @nro_restaurante INT,
    @nro_contenido   INT,
    @nro_cliente     INT = NULL,              -- opcional: si se pasa y existe se usa; si no existe se crea
    @apellido        VARCHAR(120),            -- requerido para alta si cliente no existe
    @nombre          VARCHAR(120),            -- requerido para alta si cliente no existe
    @correo          VARCHAR(200),            -- clave única de búsqueda / alta
    @telefonos       VARCHAR(120) = NULL,     -- opcional
    @costo_click     DECIMAL(12,2) = NULL,
    @fecha_registro  DATETIME2(0) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ahora DATETIME2(0) = SYSDATETIME();
    IF @fecha_registro IS NULL SET @fecha_registro = @ahora;

    BEGIN TRY
        BEGIN TRAN;

        -- Validar contenido
        IF NOT EXISTS (
            SELECT 1 FROM dbo.contenidos c
            WHERE c.nro_restaurante = @nro_restaurante
              AND c.nro_contenido   = @nro_contenido
        )
        BEGIN
            RAISERROR('Contenido inexistente para el restaurante.', 16, 1);
            ROLLBACK TRAN; RETURN;
        END;

        -- Resolver/crear cliente
        DECLARE @cliente_resuelto INT = NULL;

        IF @nro_cliente IS NOT NULL AND EXISTS(SELECT 1 FROM dbo.clientes WHERE nro_cliente=@nro_cliente)
        BEGIN
            SET @cliente_resuelto = @nro_cliente;
            -- opcional: actualizar datos básicos si vinieron distintos
            UPDATE c SET apellido=@apellido, nombre=@nombre, telefonos=@telefonos
            FROM dbo.clientes c
            WHERE c.nro_cliente = @cliente_resuelto
              AND (c.apellido<>@apellido OR c.nombre<>@nombre OR ISNULL(c.telefonos,'')<>ISNULL(@telefonos,''));
        END
        ELSE
        BEGIN
            -- Buscar por correo existente
            SELECT @cliente_resuelto = nro_cliente FROM dbo.clientes WHERE correo = @correo;

            IF @cliente_resuelto IS NULL
            BEGIN
                -- Crear nuevo cliente
                SELECT @cliente_resuelto = ISNULL(MAX(nro_cliente),0) + 1 FROM dbo.clientes WITH (TABLOCKX);
                INSERT INTO dbo.clientes (nro_cliente, apellido, nombre, correo, telefonos)
                VALUES (@cliente_resuelto, @apellido, @nombre, @correo, @telefonos);
            END
            ELSE
            BEGIN
                -- Actualizar datos si cambiaron
                UPDATE dbo.clientes
                   SET apellido=@apellido, nombre=@nombre, telefonos=@telefonos
                 WHERE nro_cliente=@cliente_resuelto
                   AND (apellido<>@apellido OR nombre<>@nombre OR ISNULL(telefonos,'')<>ISNULL(@telefonos,''));
            END
        END

        -- Obtener siguiente nro_click
        DECLARE @nro_click INT = 1;
        SELECT @nro_click = ISNULL(MAX(nro_click),0) + 1
        FROM dbo.clicks_contenidos
        WHERE nro_restaurante = @nro_restaurante
          AND nro_contenido   = @nro_contenido;

        INSERT INTO dbo.clicks_contenidos (
            nro_restaurante, nro_contenido, nro_click,
            fecha_hora_registro, nro_cliente, costo_click
        ) VALUES (
            @nro_restaurante, @nro_contenido, @nro_click,
            @fecha_registro, @cliente_resuelto, @costo_click
        );

        COMMIT TRAN;

        SELECT
            click = (
                SELECT
                    @nro_restaurante AS nro_restaurante,
                    @nro_contenido   AS nro_contenido,
                    @nro_click       AS nro_click,
                    @fecha_registro  AS fecha_hora_registro,
                    @costo_click     AS costo_click
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            ),
            cliente = (
                SELECT nro_cliente, apellido, nombre, correo, telefonos
                FROM dbo.clientes WHERE nro_cliente = @cliente_resuelto
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@msg,16,1);
    END CATCH
END
GO

/* Ejemplo de ejecución
EXEC dbo.usp_registrar_click_contenido
    @nro_restaurante = 1,
    @nro_contenido   = 4,
    @nro_cliente     = 1001,      -- asumir cliente precargado
    @costo_click     = 42.50;     -- opcional
*/

/* =======================
   Reservas
   ======================= */
CREATE TABLE dbo.reservas_sucursales (
    cod_reserva          INT            NOT NULL,
    fecha_hora_registro  DATETIME2(0)   NOT NULL DEFAULT SYSDATETIME(),
    nro_cliente          INT            NOT NULL,
    fecha_reserva        DATE           NOT NULL,
    hora_reserva         TIME           NOT NULL,  -- (FK) coincide con el ER
    nro_restaurante      INT            NOT NULL,
    nro_sucursal         INT            NOT NULL,
    cod_zona             INT            NOT NULL,
    cant_adultos         INT            NOT NULL,
    cant_menores         INT            NOT NULL DEFAULT 0,
    costo_reserva        DECIMAL(12,2)  NULL,
    cancelada            BIT            NOT NULL DEFAULT 0,
    fecha_cancelacion    DATETIME2(0)   NULL,
    CONSTRAINT PK_reservas_sucursales PRIMARY KEY (cod_reserva),
    CONSTRAINT FK_reservas_clientes
        FOREIGN KEY (nro_cliente) REFERENCES dbo.clientes (nro_cliente),
    -- FK al cruce zona/turno: hora_reserva -> hora_desde
    CONSTRAINT FK_reservas_zonas_turnos
        FOREIGN KEY (nro_restaurante, nro_sucursal, cod_zona, hora_reserva)
        REFERENCES dbo.zonas_turnos_sucursales (nro_restaurante, nro_sucursal, cod_zona, hora_desde),
    CONSTRAINT CK_reservas_cant_no_neg CHECK (cant_adultos >= 0 AND cant_menores >= 0)
);

/* =======================
   Índices recomendados (FK lookups)
   ======================= */
CREATE INDEX IX_localidades_codprov           ON dbo.localidades (cod_provincia);
CREATE INDEX IX_sucursales_localidad          ON dbo.sucursales (nro_localidad);
CREATE INDEX IX_sucursales_categoria          ON dbo.sucursales (nro_categoria);
CREATE INDEX IX_zs_sucursal                   ON dbo.zonas_sucursales (nro_restaurante, nro_sucursal);
CREATE INDEX IX_ts_sucursal                   ON dbo.turnos_sucursales (nro_restaurante, nro_sucursal);
CREATE INDEX IX_zts_turno                     ON dbo.zonas_turnos_sucursales (nro_restaurante, nro_sucursal, hora_desde);
CREATE INDEX IX_contenidos_sucursal           ON dbo.contenidos (nro_restaurante, nro_sucursal);
CREATE INDEX IX_tcs_sucursal                  ON dbo.tipos_comidas_sucursales (nro_restaurante, nro_sucursal);
CREATE INDEX IX_eas_sucursal                  ON dbo.especialidades_alimentarias_sucursales (nro_restaurante, nro_sucursal);
CREATE INDEX IX_es_sucursal                   ON dbo.estilos_sucursales (nro_restaurante, nro_sucursal);
CREATE INDEX IX_reservas_turno_zona           ON dbo.reservas_sucursales (nro_restaurante, nro_sucursal, cod_zona, hora_reserva);
CREATE INDEX IX_reservas_cliente              ON dbo.reservas_sucursales (nro_cliente);
CREATE INDEX IX_clicks_contenidos_cliente     ON dbo.clicks_contenidos (nro_cliente);
GO




/* =========================================================
   SEED DE DATOS REALISTAS PARA BODEGÓN (solo INSERT INTO)
   - Mantener vacías: reservas_sucursales, clicks_contenidos, clientes
   - Inserta: provincias/localidades, restaurante, categorías de precios,
              zonas, tipos_comidas, especialidades_alimentarias (preferencias),
              estilos, sucursales, zonas_sucursales, turnos_sucursales,
              zonas_turnos_sucursales, contenidos, tipos_comidas_sucursales,
              especialidades_alimentarias_sucursales, estilos_sucursales
   ========================================================= */

-- Provincias y Localidades (Córdoba)
INSERT INTO dbo.provincias (cod_provincia, nom_provincia) VALUES
    (5, 'Córdoba');

INSERT INTO dbo.localidades (nro_localidad, nom_localidad, cod_provincia) VALUES
    (501, 'Córdoba', 5);

-- Restaurante
INSERT INTO dbo.restaurantes (nro_restaurante, razon_social, cuit) VALUES
    (1, 'Bodegón La Esquina', '30-71234567-8');

-- Categorías de precios
INSERT INTO dbo.categorias_precios (nro_categoria, nom_categoria) VALUES
    (1, 'Económico'),
    (2, 'Accesible'),
    (3, 'Medio'),
    (4, 'Premium');

-- Zonas del restaurante (catálogo)
INSERT INTO dbo.zonas (cod_zona, nom_zona) VALUES
    (1, 'Salón Principal'),
    (2, 'Patio Interno'),
    (3, 'Terraza'),
    (4, 'Exterior'),
    (5, 'Ala Norte');

-- Tipos de comidas
INSERT INTO dbo.tipos_comidas (nro_tipo_comida, nom_tipo_comida) VALUES
    (1, 'Pastas'),
    (2, 'Pizzas'),
    (3, 'Lomitos'),
    (4, 'Minutas'),
    (5, 'Parrilla'),
    (6, 'Empanadas'),
    (7, 'Pollo a las brasas');

-- Preferencias / Especialidades alimentarias (restricciones)
INSERT INTO dbo.especialidades_alimentarias (nro_preferencia, nom_preferencia) VALUES
    (1, 'Sin TAAC (celíacos)'),
    (2, 'Vegano'),
    (3, 'Vegetariano'),
    (4, 'Sin lactosa'),
    (5, 'Hiposódico');

-- Estilos (origen)
INSERT INTO dbo.estilos (nro_estilo, nom_estilo) VALUES
    (1, 'Argentina'),
    (2, 'Italiana'),
    (3, 'Parrilla'),
    (4, 'Rotisería');

-- Sucursales (nombres por calle)
INSERT INTO dbo.sucursales (
    nro_restaurante, nro_sucursal, nom_sucursal, calle, nro_calle, barrio, nro_localidad,
    cod_postal, telefonos, total_comensales, min_tolerencia_reserva, nro_categoria
) VALUES
    (1, 1, 'Av. Colón',         'Av. Colón',        3450, 'Alta Córdoba',       501, '5000', '+54 351 555-0101', 120, 15, 2),
    (1, 2, 'Bv. San Juan',      'Bv. San Juan',      950, 'Centro',             501, '5000', '+54 351 555-0202',  90, 15, 3),
    (1, 3, 'Av. Rafael Núñez',  'Av. Rafael Núñez', 5235, 'Cerro de las Rosas', 501, '5009', '+54 351 555-0303',  80, 15, 3);

-- Zonas habilitadas por sucursal
INSERT INTO dbo.zonas_sucursales (nro_restaurante, nro_sucursal, cod_zona, cant_comensales, permite_menores, habilitada) VALUES
    -- Sucursal 1
    (1, 1, 1, 20, 1, 1),
    (1, 1, 2, 18, 1, 1),
    (1, 1, 3, 16, 1, 1),
    (1, 1, 4, 12, 1, 1),
    -- Sucursal 2
    (1, 2, 1, 20, 1, 1),
    (1, 2, 2, 16, 1, 1),
    (1, 2, 4, 12, 1, 1),
    -- Sucursal 3
    (1, 3, 1, 18, 1, 1),
    (1, 3, 2, 16, 1, 1),
    (1, 3, 5, 15, 1, 1);

-- Turnos por sucursal (5 turnos, 3 horas c/u: 11:00,14:00,17:00,20:00,23:00)
INSERT INTO dbo.turnos_sucursales (nro_restaurante, nro_sucursal, hora_desde, hora_hasta, habilitado) VALUES
    -- Sucursal 1
    (1, 1, '11:00', '14:00', 1),
    (1, 1, '14:00', '17:00', 1),
    (1, 1, '17:00', '20:00', 1),
    (1, 1, '20:00', '23:00', 1),
    (1, 1, '23:00', '02:00', 1),
    -- Sucursal 2
    (1, 2, '11:00', '14:00', 1),
    (1, 2, '14:00', '17:00', 1),
    (1, 2, '17:00', '20:00', 1),
    (1, 2, '20:00', '23:00', 1),
    (1, 2, '23:00', '02:00', 1),
    -- Sucursal 3
    (1, 3, '11:00', '14:00', 1),
    (1, 3, '14:00', '17:00', 1),
    (1, 3, '17:00', '20:00', 1),
    (1, 3, '20:00', '23:00', 1),
    (1, 3, '23:00', '02:00', 1);

-- Cruce Zonas x Turnos (permite menores: 1 en todos los casos)
INSERT INTO dbo.zonas_turnos_sucursales (nro_restaurante, nro_sucursal, cod_zona, hora_desde, permite_menores) VALUES
    -- Sucursal 1: zonas 1,2,3,4 en todos los turnos
    (1,1,1,'11:00',1),(1,1,1,'14:00',1),(1,1,1,'17:00',1),(1,1,1,'20:00',1),(1,1,1,'23:00',1),
    (1,1,2,'11:00',1),(1,1,2,'14:00',1),(1,1,2,'17:00',1),(1,1,2,'20:00',1),(1,1,2,'23:00',1),
    (1,1,3,'11:00',1),(1,1,3,'14:00',1),(1,1,3,'17:00',1),(1,1,3,'20:00',1),(1,1,3,'23:00',1),
    (1,1,4,'11:00',1),(1,1,4,'14:00',1),(1,1,4,'17:00',1),(1,1,4,'20:00',1),(1,1,4,'23:00',1),
    -- Sucursal 2: zonas 1,2,4
    (1,2,1,'11:00',1),(1,2,1,'14:00',1),(1,2,1,'17:00',1),(1,2,1,'20:00',1),(1,2,1,'23:00',1),
    (1,2,2,'11:00',1),(1,2,2,'14:00',1),(1,2,2,'17:00',1),(1,2,2,'20:00',1),(1,2,2,'23:00',1),
    (1,2,4,'11:00',1),(1,2,4,'14:00',1),(1,2,4,'17:00',1),(1,2,4,'20:00',1),(1,2,4,'23:00',1),
    -- Sucursal 3: zonas 1,2,5
    (1,3,1,'11:00',1),(1,3,1,'14:00',1),(1,3,1,'17:00',1),(1,3,1,'20:00',1),(1,3,1,'23:00',1),
    (1,3,2,'11:00',1),(1,3,2,'14:00',1),(1,3,2,'17:00',1),(1,3,2,'20:00',1),(1,3,2,'23:00',1),
    (1,3,5,'11:00',1),(1,3,5,'14:00',1),(1,3,5,'17:00',1),(1,3,5,'20:00',1),(1,3,5,'23:00',1);

-- Contenidos promocionales (a nivel restaurante y sucursal)
INSERT INTO dbo.contenidos (nro_restaurante, nro_contenido, contenido_a_publicar, imagen_a_publicar, publicado, costo_click, nro_sucursal) VALUES
    (1, 1, 'Promo: Milanesa napolitana con papas y bebida', NULL, 1, 50.00, NULL),
    (1, 2, 'Finde: Asado a la parrilla - porciones para compartir', NULL, 1, 70.00, NULL),
    (1, 3, '2x1 en empanadas los martes', NULL, 1, 30.00, NULL),
    (1, 4, 'Lomito completo + papas (Sucursal Av. Colón)', NULL, 1, 40.00, 1),
    (1, 5, 'Pollo a las brasas al peso (Sucursal Rafael Núñez)', NULL, 1, 45.00, 3);

-- Tipos de comidas habilitados por sucursal
INSERT INTO dbo.tipos_comidas_sucursales (nro_restaurante, nro_sucursal, nro_tipo_comida, habilitado) VALUES
    -- Av. Colón
    (1,1,1,1),(1,1,2,1),(1,1,3,1),(1,1,4,1),(1,1,5,1),(1,1,6,1),(1,1,7,1),
    -- Bv. San Juan
    (1,2,1,1),(1,2,2,1),(1,2,3,1),(1,2,4,1),(1,2,6,1),
    -- Av. Rafael Núñez
    (1,3,2,1),(1,3,3,1),(1,3,4,1),(1,3,5,1),(1,3,7,1);

-- Preferencias habilitadas por sucursal
INSERT INTO dbo.especialidades_alimentarias_sucursales (nro_restaurante, nro_sucursal, nro_preferencia, habilitada) VALUES
    -- Av. Colón
    (1,1,1,1),(1,1,3,1),(1,1,4,1),
    -- Bv. San Juan
    (1,2,1,1),(1,2,2,1),(1,2,4,1),
    -- Av. Rafael Núñez
    (1,3,1,1),(1,3,3,1),(1,3,5,1);

-- Estilos por sucursal
INSERT INTO dbo.estilos_sucursales (nro_restaurante, nro_sucursal, nro_estilo, habilitado) VALUES
    -- Av. Colón
    (1,1,1,1),(1,1,4,1),
    -- Bv. San Juan
    (1,2,1,1),(1,2,2,1),
    -- Av. Rafael Núñez
    (1,3,1,1),(1,3,3,1);

-- NOTA: No se insertan clientes, reservas ni clicks según requisitos


