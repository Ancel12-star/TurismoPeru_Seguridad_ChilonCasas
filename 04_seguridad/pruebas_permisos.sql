USE [TURISMOPERU_lacc];
GO

/* =====================================================
   PRUEBA DEL ANALISTA
   ===================================================== */

EXECUTE AS USER = 'lacc_turismo_analista';
GO

SELECT
    USER_NAME() AS UsuarioActual,
    'Consulta permitida para el analista' AS Prueba;
GO

-- Esta consulta debe funcionar.
SELECT TOP 5 *
FROM [lacc].[pago];
GO

-- Este INSERT debe ser rechazado.
BEGIN TRY

    INSERT INTO [lacc].[pago]
    (
        id_reserva,
        id_medio_pago,
        monto
    )
    VALUES
    (
        1,
        1,
        10.00
    );

    SELECT 'ERROR: el analista logró insertar' AS Resultado;

END TRY
BEGIN CATCH

    SELECT
        'CORRECTO: la inserción fue rechazada' AS Resultado,
        ERROR_NUMBER() AS NumeroError,
        ERROR_MESSAGE() AS MensajeError;

END CATCH;
GO

REVERT;
GO


/* =====================================================
   PRUEBA DEL VENDEDOR
   ===================================================== */

EXECUTE AS USER = 'lacc_turismo_vendedor';
GO

SELECT
    USER_NAME() AS UsuarioActual,
    'Consulta permitida para el vendedor' AS Prueba;
GO

-- Esta consulta debe funcionar.
SELECT TOP 5 *
FROM [lacc].[reserva];
GO

-- Este DELETE debe ser rechazado.
-- Se utiliza -1 para evitar eliminar un registro real.
BEGIN TRY

    DELETE FROM [lacc].[reserva]
    WHERE id_reserva = -1;

    SELECT 'ERROR: el vendedor logró ejecutar DELETE' AS Resultado;

END TRY
BEGIN CATCH

    SELECT
        'CORRECTO: la eliminación fue rechazada' AS Resultado,
        ERROR_NUMBER() AS NumeroError,
        ERROR_MESSAGE() AS MensajeError;

END CATCH;
GO

REVERT;
GO


/* =====================================================
   COMPROBACIÓN DEL USUARIO ORIGINAL
   ===================================================== */

SELECT
    USER_NAME() AS UsuarioActual,
    'Las pruebas finalizaron correctamente' AS Resultado;
GO










---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

USE [TURISMOPERU_lacc];
GO

/* =====================================================
   PRUEBA 1: EL ANALISTA PUEDE CONSULTAR PAGOS
   ===================================================== */

EXECUTE AS USER = 'lacc_turismo_analista';

SELECT USER_NAME() AS UsuarioActual;

SELECT TOP 5
    id_pago,
    id_reserva,
    id_medio_pago,
    monto,
    fecha_pago,
    estado
FROM [lacc].[pago];

PRINT 'CORRECTO: el analista puede consultar pagos.';

/* =====================================================
   PRUEBA 2: EL ANALISTA NO PUEDE INSERTAR PAGOS
   ===================================================== */

BEGIN TRY
    EXEC
    (
        'INSERT INTO [lacc].[pago]
        (
            id_reserva,
            id_medio_pago,
            monto,
            fecha_pago,
            estado
        )
        VALUES
        (
            -1,
            -1,
            10.00,
            GETDATE(),
            ''Prueba''
        );'
    );

    PRINT 'ERROR: el analista logró insertar un pago.';
END TRY
BEGIN CATCH
    PRINT 'CORRECTO: SQL Server rechazó la inserción del analista.';
    PRINT ERROR_MESSAGE();
END CATCH;

REVERT;
GO

/* =====================================================
   PRUEBA 3: EL VENDEDOR PUEDE CONSULTAR RESERVAS
   ===================================================== */

EXECUTE AS USER = 'lacc_turismo_vendedor';

SELECT USER_NAME() AS UsuarioActual;

SELECT TOP 5
    id_reserva,
    codigo_reserva,
    fecha_reserva,
    precio_total,
    saldo_pendiente
FROM [lacc].[reserva];

PRINT 'CORRECTO: el vendedor puede consultar reservas.';

/* =====================================================
   PRUEBA 4: EL VENDEDOR NO PUEDE ELIMINAR RESERVAS
   ===================================================== */

BEGIN TRY
    EXEC
    (
        'DELETE FROM [lacc].[reserva]
         WHERE id_reserva = -1;'
    );

    PRINT 'ERROR: el vendedor logró ejecutar DELETE.';
END TRY
BEGIN CATCH
    PRINT 'CORRECTO: SQL Server rechazó el DELETE del vendedor.';
    PRINT ERROR_MESSAGE();
END CATCH;

REVERT;
GO

-- Confirmar que regresamos al usuario original
SELECT USER_NAME() AS UsuarioRestaurado;
GO