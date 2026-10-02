USE [TURISMOPERU_lacc];
GO

CREATE ROLE [rol_vendedor];
GO

CREATE ROLE [rol_analista];
GO

ALTER ROLE [rol_vendedor]
ADD MEMBER [lacc_turismo_vendedor];
GO

ALTER ROLE [rol_analista]
ADD MEMBER [lacc_turismo_analista];
GO

SELECT
    rol.name AS Rol,
    usuario.name AS Usuario
FROM sys.database_role_members AS relacion
INNER JOIN sys.database_principals AS rol
    ON relacion.role_principal_id = rol.principal_id
INNER JOIN sys.database_principals AS usuario
    ON relacion.member_principal_id = usuario.principal_id
WHERE rol.name IN
(
    N'rol_vendedor',
    N'rol_analista'
);
GO