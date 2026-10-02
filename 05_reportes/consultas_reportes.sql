USE [TURISMOPERU_lacc];
GO

/* =====================================================
   1. INDICADORES PRINCIPALES
   ===================================================== */

SELECT
    (SELECT COUNT(*) FROM [lacc].[cliente])
        AS TotalClientes,

    (SELECT COUNT(*) FROM [lacc].[reserva])
        AS TotalReservas,

    (SELECT ISNULL(SUM(monto), 0) FROM [lacc].[pago])
        AS TotalIngresos,

    CAST
    (
        (SELECT ISNULL(SUM(monto), 0) FROM [lacc].[pago])
        /
        NULLIF
        (
            (SELECT COUNT(*) FROM [lacc].[reserva]),
            0
        )
        AS DECIMAL(10,2)
    ) AS TicketPromedio;
GO

/* =====================================================
   2. RESERVAS POR ESTADO
   ===================================================== */

SELECT
    er.nombre AS EstadoReserva,
    COUNT(r.id_reserva) AS CantidadReservas
FROM [lacc].[reserva] AS r
INNER JOIN [lacc].[estado_reserva] AS er
    ON er.id_estado_reserva = r.id_estado_reserva
GROUP BY er.nombre
ORDER BY CantidadReservas DESC;
GO

/* =====================================================
   3. INGRESOS POR MEDIO DE PAGO
   ===================================================== */

SELECT
    mp.nombre AS MedioPago,
    ISNULL(SUM(p.monto), 0) AS TotalIngresos
FROM [lacc].[pago] AS p
INNER JOIN [lacc].[medio_pago] AS mp
    ON mp.id_medio_pago = p.id_medio_pago
GROUP BY mp.nombre
ORDER BY TotalIngresos DESC;
GO

/* =====================================================
   4. RESERVAS POR FECHA
   ===================================================== */

SELECT
    CAST(r.fecha_reserva AS DATE) AS Fecha,
    COUNT(r.id_reserva) AS CantidadReservas
FROM [lacc].[reserva] AS r
GROUP BY CAST(r.fecha_reserva AS DATE)
ORDER BY Fecha;
GO

/* =====================================================
   5. TOP 10 CLIENTES POR CANTIDAD DE RESERVAS
   ===================================================== */

SELECT TOP 10
    p.id_persona AS IdCliente,
    LTRIM(RTRIM
    (
        CONCAT
        (
            p.nombres, ' ',
            p.apaterno, ' ',
            p.amaterno
        )
    )) AS Cliente,
    COUNT(r.id_reserva) AS CantidadReservas
FROM [lacc].[persona] AS p
INNER JOIN [lacc].[cliente] AS c
    ON c.id_persona = p.id_persona
INNER JOIN [lacc].[reserva] AS r
    ON r.id_cliente = c.id_persona
GROUP BY
    p.id_persona,
    p.nombres,
    p.apaterno,
    p.amaterno
ORDER BY CantidadReservas DESC;
GO

/* =====================================================
   6. INGRESOS POR CLIENTE
   ===================================================== */

SELECT
    p.id_persona AS IdCliente,
    LTRIM(RTRIM
    (
        CONCAT
        (
            p.nombres, ' ',
            p.apaterno, ' ',
            p.amaterno
        )
    )) AS Cliente,
    ISNULL(SUM(pg.monto), 0) AS TotalIngresos
FROM [lacc].[persona] AS p
INNER JOIN [lacc].[cliente] AS c
    ON c.id_persona = p.id_persona
INNER JOIN [lacc].[reserva] AS r
    ON r.id_cliente = c.id_persona
INNER JOIN [lacc].[pago] AS pg
    ON pg.id_reserva = r.id_reserva
GROUP BY
    p.id_persona,
    p.nombres,
    p.apaterno,
    p.amaterno
ORDER BY TotalIngresos DESC;
GO