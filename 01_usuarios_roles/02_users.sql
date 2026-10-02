USE [TURISMOPERU_lacc];
GO

CREATE USER [lacc_turismo_admin]
FOR LOGIN [lacc_turismo_admin]
WITH DEFAULT_SCHEMA = [lacc];
GO

CREATE USER [lacc_turismo_vendedor]
FOR LOGIN [lacc_turismo_vendedor]
WITH DEFAULT_SCHEMA = [lacc];
GO

CREATE USER [lacc_turismo_analista]
FOR LOGIN [lacc_turismo_analista]
WITH DEFAULT_SCHEMA = [lacc];
GO

SELECT
    name AS Usuario,
    type_desc AS TipoUsuario,
    default_schema_name AS EsquemaPredeterminado
FROM sys.database_principals
WHERE name IN
(
    N'lacc_turismo_admin',
    N'lacc_turismo_vendedor',
    N'lacc_turismo_analista'
);
GO