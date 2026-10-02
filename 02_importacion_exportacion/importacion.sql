USE [TURISMOPERU_lacc];
GO

CREATE TABLE [lacc].[cliente_importacion]
(
    Documento VARCHAR(20) NOT NULL,
    Nombres VARCHAR(100) NOT NULL,
    ApellidoPaterno VARCHAR(100) NOT NULL,
    ApellidoMaterno VARCHAR(100) NULL
);
GO

SELECT *
FROM [lacc].[cliente_importacion];
GO

SELECT
    id_tipo_documento,
    nombredoc,
    abreviatura
FROM [lacc].[tipo_documento];
GO

SELECT
    id_nacionalidad,
    nombrenacionalidad
FROM [lacc].[nacionalidad];
GO





-- Verificar los registros importados con bcp
USE [TURISMOPERU_lacc];
GO

SELECT *
FROM [lacc].[cliente_importacion];
GO



-- Validar la longitud y el contenido del documento
SELECT
    Documento,
    Nombres,
    ApellidoPaterno,
    ApellidoMaterno,
    CASE
        WHEN LEN(LTRIM(RTRIM(Documento))) = 8
             AND Documento NOT LIKE '%[^0-9]%'
        THEN 'VALIDO'
        ELSE 'INVALIDO'
    END AS EstadoValidacion
FROM [lacc].[cliente_importacion];
GO

-- Identificar documentos duplicados dentro del archivo importado
SELECT
    Documento,
    COUNT(*) AS Cantidad
FROM [lacc].[cliente_importacion]
GROUP BY Documento
HAVING COUNT(*) > 1;
GO

-- Comprobar si algún documento ya existe en persona
SELECT
    ci.Documento,
    ci.Nombres,
    ci.ApellidoPaterno,
    ci.ApellidoMaterno
FROM [lacc].[cliente_importacion] AS ci
INNER JOIN [lacc].[persona] AS p
    ON p.numero_documento = ci.Documento;
GO




USE [TURISMOPERU_lacc];
GO

SELECT
    id_tipo_documento,
    nombredoc,
    abreviatura
FROM [lacc].[tipo_documento]
WHERE abreviatura LIKE '%DNI%';
GO

SELECT
    id_nacionalidad,
    nombrenacionalidad
FROM [lacc].[nacionalidad]
WHERE nombrenacionalidad LIKE 'Per%';
GO


USE [TURISMOPERU_lacc];
GO

DECLARE @IdTipoDocumento INT;
DECLARE @IdNacionalidad INT;

-- Obtener automáticamente el identificador del DNI
SELECT TOP 1
    @IdTipoDocumento = id_tipo_documento
FROM [lacc].[tipo_documento]
WHERE abreviatura LIKE '%DNI%';

-- Obtener automáticamente la nacionalidad peruana
SELECT TOP 1
    @IdNacionalidad = id_nacionalidad
FROM [lacc].[nacionalidad]
WHERE nombrenacionalidad LIKE 'Per%';

-- Mostrar los identificadores encontrados
SELECT
    @IdTipoDocumento AS IdTipoDocumentoDNI,
    @IdNacionalidad AS IdNacionalidadPeruana;

-- Insertar personas válidas, únicas y que todavía no existen
INSERT INTO [lacc].[persona]
(
    tipo_persona,
    nombres,
    apaterno,
    amaterno,
    razon_social,
    id_tipo_documento,
    numero_documento,
    id_nacionalidad
)
SELECT
    'N',
    ci.Nombres,
    ci.ApellidoPaterno,
    ci.ApellidoMaterno,
    LTRIM(RTRIM(
        CONCAT(
            ci.Nombres, ' ',
            ci.ApellidoPaterno, ' ',
            ci.ApellidoMaterno
        )
    )),
    @IdTipoDocumento,
    ci.Documento,
    @IdNacionalidad
FROM [lacc].[cliente_importacion] AS ci
WHERE LEN(LTRIM(RTRIM(ci.Documento))) = 8
  AND ci.Documento NOT LIKE '%[^0-9]%'
  AND ci.Documento IN
  (
      SELECT Documento
      FROM [lacc].[cliente_importacion]
      GROUP BY Documento
      HAVING COUNT(*) = 1
  )
  AND NOT EXISTS
  (
      SELECT 1
      FROM [lacc].[persona] AS p
      WHERE p.id_tipo_documento = @IdTipoDocumento
        AND p.numero_documento = ci.Documento
  );

PRINT 'Personas insertadas: ' + CAST(@@ROWCOUNT AS VARCHAR(10));

-- Registrar como clientes las personas válidas importadas
INSERT INTO [lacc].[cliente] (id_persona)
SELECT p.id_persona
FROM [lacc].[persona] AS p
INNER JOIN [lacc].[cliente_importacion] AS ci
    ON ci.Documento = p.numero_documento
WHERE p.id_tipo_documento = @IdTipoDocumento
  AND LEN(LTRIM(RTRIM(ci.Documento))) = 8
  AND ci.Documento NOT LIKE '%[^0-9]%'
  AND ci.Documento IN
  (
      SELECT Documento
      FROM [lacc].[cliente_importacion]
      GROUP BY Documento
      HAVING COUNT(*) = 1
  )
  AND NOT EXISTS
  (
      SELECT 1
      FROM [lacc].[cliente] AS c
      WHERE c.id_persona = p.id_persona
  );

PRINT 'Clientes insertados: ' + CAST(@@ROWCOUNT AS VARCHAR(10));
GO

-- Comprobar los clientes procesados
SELECT
    p.id_persona,
    p.numero_documento,
    p.nombres,
    p.apaterno,
    p.amaterno,
    p.estado
FROM [lacc].[persona] AS p
INNER JOIN [lacc].[cliente] AS c
    ON c.id_persona = p.id_persona
WHERE p.numero_documento IN
(
    SELECT Documento
    FROM [lacc].[cliente_importacion]
);
GO