# Reporte Power BI

## Fuente de datos

El reporte fue desarrollado en **Power BI Desktop** y utiliza como fuente de datos:

- Motor: SQL Server.
- Base de datos: `TURISMOPERU_lacc`.
- Esquema: `lacc`.
- Acceso mediante el usuario analista, con permisos de consulta.
- Las credenciales y contraseñas no se incluyen en este repositorio.

## Modelo de datos

El modelo principal relaciona las siguientes tablas:

- `lacc.persona` → `lacc.cliente`
- `lacc.cliente` → `lacc.reserva`
- `lacc.reserva` → `lacc.pago`

También se utilizaron las tablas auxiliares:

- `lacc.estado_reserva`, para identificar el estado de cada reserva.
- `lacc.medio_pago`, para identificar el medio utilizado en cada pago.

Las relaciones permiten analizar la información de cada cliente, sus reservas y los pagos correspondientes.

## Medidas

Se crearon las siguientes medidas en Power BI:

```DAX
Total Clientes =
DISTINCTCOUNT('lacc cliente'[id_persona])
```

```DAX
Total Reservas =
COUNTROWS('lacc reserva')
```

```DAX
Total Ingresos =
SUM('lacc pago'[monto])
```

```DAX
Ticket Promedio =
DIVIDE([Total Ingresos], [Total Reservas], 0)
```

También se creó la columna calculada:

```DAX
Nombre Completo =
TRIM(
    'lacc persona'[nombres] & " " &
    'lacc persona'[apaterno] & " " &
    'lacc persona'[amaterno]
)
```

## Visualizaciones

El dashboard contiene las siguientes visualizaciones:

- Tarjeta de total de clientes.
- Tarjeta de total de reservas.
- Tarjeta de total de ingresos.
- Tarjeta de ticket promedio.
- Reservas por estado.
- Ingresos por medio de pago.
- Reservas por fecha.
- Top 10 clientes por cantidad de reservas.
- Ingresos por cliente.

## Principales resultados

1. La base de datos registra **54 clientes** y un total de **102 reservas**.

2. Los pagos representan aproximadamente **353,28 mil** en ingresos, con un ticket promedio de **3,46 mil por reserva**.

3. El estado **Completada** presenta la mayor cantidad de reservas, con aproximadamente **36 registros**, equivalente a cerca del 35 % del total.

4. **Raúl Figueroa Aguilar** es el cliente con mayor cantidad de reservas, con **4 reservas registradas**.

5. El comportamiento temporal muestra un aumento de reservas entre mayo y julio de 2026, alcanzando un máximo cercano a **7 reservas en un mismo periodo**.

## Archivos

- Reporte de Power BI: `06_powerbi/TurismoPeru_Reporte.pbix`
- Evidencia del dashboard: `evidencias/reporte_powerbi.png`