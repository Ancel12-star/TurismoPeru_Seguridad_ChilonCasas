USE [TURISMOPERU_lacc];
GO

-- Datos finales que serán exportados
SELECT
    p.numero_documento AS Documento,
    p.nombres AS Nombres,
    p.apaterno AS ApellidoPaterno,
    p.amaterno AS ApellidoMaterno
FROM [lacc].[persona] AS p
INNER JOIN [lacc].[cliente] AS c
    ON c.id_persona = p.id_persona
WHERE p.numero_documento IN
(
    SELECT Documento
    FROM [lacc].[cliente_importacion]
);
GO