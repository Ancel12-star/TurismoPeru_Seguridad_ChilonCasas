USE [TURISMOPERU_lacc];
GO

-- PERMISOS DEL VENDEDOR

GRANT SELECT, INSERT
ON OBJECT::[lacc].[cliente]
TO [rol_vendedor];
GO

GRANT SELECT, INSERT
ON OBJECT::[lacc].[reserva]
TO [rol_vendedor];
GO

GRANT SELECT
ON OBJECT::[lacc].[alojamiento]
TO [rol_vendedor];
GO

GRANT SELECT
ON OBJECT::[lacc].[habitacion]
TO [rol_vendedor];
GO

DENY DELETE
ON OBJECT::[lacc].[cliente]
TO [rol_vendedor];
GO

DENY DELETE
ON OBJECT::[lacc].[reserva]
TO [rol_vendedor];
GO


-- PERMISOS DEL ANALISTA

GRANT SELECT
ON OBJECT::[lacc].[cliente]
TO [rol_analista];
GO

GRANT SELECT
ON OBJECT::[lacc].[reserva]
TO [rol_analista];
GO

GRANT SELECT
ON OBJECT::[lacc].[pago]
TO [rol_analista];
GO

GRANT SELECT
ON OBJECT::[lacc].[alojamiento]
TO [rol_analista];
GO

GRANT SELECT
ON OBJECT::[lacc].[habitacion]
TO [rol_analista];
GO

GRANT SELECT
ON OBJECT::[lacc].[paquete]
TO [rol_analista];
GO

GRANT SELECT
ON OBJECT::[lacc].[lugar_turistico]
TO [rol_analista];
GO

DENY INSERT, UPDATE, DELETE
ON OBJECT::[lacc].[cliente]
TO [rol_analista];
GO

DENY INSERT, UPDATE, DELETE
ON OBJECT::[lacc].[reserva]
TO [rol_analista];
GO

DENY INSERT, UPDATE, DELETE
ON OBJECT::[lacc].[pago]
TO [rol_analista];
GO

DENY INSERT, UPDATE, DELETE
ON OBJECT::[lacc].[alojamiento]
TO [rol_analista];
GO

DENY INSERT, UPDATE, DELETE
ON OBJECT::[lacc].[habitacion]
TO [rol_analista];
GO

DENY INSERT, UPDATE, DELETE
ON OBJECT::[lacc].[paquete]
TO [rol_analista];
GO

DENY INSERT, UPDATE, DELETE
ON OBJECT::[lacc].[lugar_turistico]
TO [rol_analista];
GO


-- PERMISOS DEL ADMINISTRADOR

ALTER ROLE [db_owner]
ADD MEMBER [lacc_turismo_admin];
GO


-- COMPROBACIÓN DE PERMISOS

SELECT
    usuario.name AS Rol,
    permiso.state_desc AS Estado,
    permiso.permission_name AS Permiso,
    esquema.name AS Esquema,
    objeto.name AS Tabla
FROM sys.database_permissions AS permiso
INNER JOIN sys.database_principals AS usuario
    ON permiso.grantee_principal_id = usuario.principal_id
INNER JOIN sys.objects AS objeto
    ON permiso.major_id = objeto.object_id
INNER JOIN sys.schemas AS esquema
    ON objeto.schema_id = esquema.schema_id
WHERE usuario.name IN
(
    N'rol_vendedor',
    N'rol_analista'
)
ORDER BY
    usuario.name,
    objeto.name,
    permiso.permission_name;
GO


USE [TURISMOPERU_lacc];
GO

-- Tablas complementarias necesarias para Power BI
GRANT SELECT ON OBJECT::[lacc].[persona]
TO [rol_analista];

GRANT SELECT ON OBJECT::[lacc].[estado_reserva]
TO [rol_analista];

GRANT SELECT ON OBJECT::[lacc].[medio_pago]
TO [rol_analista];

DENY INSERT, UPDATE, DELETE ON OBJECT::[lacc].[persona]
TO [rol_analista];

DENY INSERT, UPDATE, DELETE ON OBJECT::[lacc].[estado_reserva]
TO [rol_analista];

DENY INSERT, UPDATE, DELETE ON OBJECT::[lacc].[medio_pago]
TO [rol_analista];
GO