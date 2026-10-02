USE [master];
GO

CREATE LOGIN [lacc_turismo_admin]
WITH PASSWORD = N'RocaAzul#47Sol!',
     CHECK_POLICY = ON,
     CHECK_EXPIRATION = OFF;
GO

CREATE LOGIN [lacc_turismo_vendedor]
WITH PASSWORD = N'Bosque$29NubeX',
     CHECK_POLICY = ON,
     CHECK_EXPIRATION = OFF;
GO

CREATE LOGIN [lacc_turismo_analista]
WITH PASSWORD = N'MarVerde!83Luna',
     CHECK_POLICY = ON,
     CHECK_EXPIRATION = OFF;
GO

SELECT
    name AS Login,
    default_database_name AS BasePredeterminada,
    is_disabled AS Deshabilitado,
    is_policy_checked AS PoliticaActivada,
    is_expiration_checked AS ExpiracionActivada
FROM sys.sql_logins
WHERE name IN
(
    N'lacc_turismo_admin',
    N'lacc_turismo_vendedor',
    N'lacc_turismo_analista'
);
GO