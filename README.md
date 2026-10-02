TurismoPeru_Seguridad_ChilonCasas
Descripción
Proyecto de administración y seguridad para la base de datos TURISMOPERU_lacc. Incluye la creación de logins, usuarios y roles; la asignación de permisos bajo el principio de mínimo privilegio; la importación y exportación de datos con bcp; un respaldo lógico en formato BACPAC; pruebas de seguridad; consultas de reportes; y un dashboard desarrollado en Power BI.
La información principal se encuentra en el esquema lacc y comprende clientes, personas, reservas, pagos, alojamientos, habitaciones, paquetes y lugares turísticos.
Tecnologías utilizadas
- Microsoft SQL Server.
- SQL Server Management Studio (SSMS).
- Utilidad de línea de comandos bcp.
- Power BI Desktop.
- Visual Studio Code.
- Git y GitHub.
Requisitos
- Tener acceso a una instancia de SQL Server.
- Tener creada o restaurada la base de datos TURISMOPERU_lacc.
- Contar con SSMS para ejecutar los scripts.
- Tener instalada la utilidad bcp para la importación y exportación.
- Tener Power BI Desktop para abrir el reporte.
- Tener Git para gestionar el repositorio.
Estructura del proyecto
TurismoPeru_Seguridad_ChilonCasas/
│
├── README.md
├── .gitignore
│
├── 01_usuarios_roles/
│   ├── 01_logins.sql
│   ├── 02_users.sql
│   ├── 03_roles.sql
│   └── 04_permisos.sql
│
├── 02_importacion_exportacion/
│   └── importacion.sql
│
├── 03_backups/
│   └── TurismoPeru_lacc_Full.bacpac
│
├── 04_seguridad/
│   └── pruebas_permisos.sql
│
├── 05_reportes/
│   ├── consultas_reportes.sql
│   ├── reportes.pdf
│   └── README.md
│
├── 06_powerbi/
│   ├── TurismoPeru_Reporte.pbix
│   └── README.md
│
└── evidencias/
    ├── login.png
    ├── permisos.png
    ├── backup.png
    ├── github.png
    └── reporte_powerbi.png
Configuración
1. Clonar o descargar el repositorio.
2. Abrir SSMS y conectarse con una cuenta autorizada para administrar logins y usuarios.
3. Comprobar que la base de datos TURISMOPERU_lacc y el esquema lacc estén disponibles.
4. Crear una copia local de 01_logins.sql y sustituir los marcadores de contraseña por claves seguras.
5. Ejecutar los scripts en el orden indicado.
6. Mantener las contraseñas reales fuera del repositorio y de las capturas de pantalla.
Orden de ejecución
1. 01_usuarios_roles/01_logins.sql
2. 01_usuarios_roles/02_users.sql
3. 01_usuarios_roles/03_roles.sql
4. 01_usuarios_roles/04_permisos.sql
5. 02_importacion_exportacion/importacion.sql
6. 04_seguridad/pruebas_permisos.sql
7. 05_reportes/consultas_reportes.sql
Los bloques separados por GO pueden ejecutarse juntos desde SSMS respetando este orden.
Usuarios y roles
El proyecto utiliza tres cuentas de SQL Server:
- lacc_turismo_admin: destinada a tareas administrativas y de respaldo.
- lacc_turismo_vendedor: destinada al registro y consulta de clientes y reservas.
- lacc_turismo_analista: destinada exclusivamente a consultas y elaboración de reportes.
Se crearon los siguientes roles:
- rol_vendedor.
- rol_analista.
Permisos del vendedor
El vendedor puede:
- Consultar e insertar clientes.
- Consultar e insertar reservas.
- Consultar alojamientos y habitaciones.
No puede eliminar clientes o reservas ni administrar logins, usuarios, roles o respaldos.
Permisos del analista
El analista puede consultar la información necesaria para elaborar reportes, incluyendo clientes, reservas, pagos, alojamientos, habitaciones, paquetes, lugares turísticos, personas, estados de reserva y medios de pago.
No puede ejecutar operaciones INSERT, UPDATE o DELETE sobre las tablas del sistema.
Principio de mínimo privilegio
No se asigna db_owner al vendedor ni al analista porque este rol permite modificar la estructura de la base de datos, cambiar permisos, eliminar objetos y acceder a operaciones administrativas que no corresponden a sus funciones.
El vendedor recibe únicamente los permisos necesarios para registrar y consultar datos relacionados con las ventas. El analista recibe permisos de lectura para construir consultas y reportes. Esta separación reduce el riesgo de modificaciones accidentales o accesos no autorizados.
El archivo 04_seguridad/pruebas_permisos.sql demuestra que el analista puede ejecutar consultas SELECT, mientras que SQL Server rechaza sus intentos de insertar, actualizar o eliminar registros.
Importación y exportación
El archivo 02_importacion_exportacion/importacion.sql crea la tabla de staging:
lacc.cliente_importacion
Esta tabla recibe los campos:
- Documento.
- Nombres.
- Apellido paterno.
- Apellido materno.
El procedimiento realizado fue:
1. Preparar el archivo CSV.
2. Importar la información con bcp.
3. Validar campos obligatorios.
4. identificar registros duplicados.
5. Insertar únicamente los registros válidos en las tablas definitivas.
6. Exportar información de la base de datos a archivos CSV.
Los comandos se ejecutan solicitando la contraseña de forma interactiva para evitar que quede visible en la terminal o en el historial.
Respaldo BACPAC
El respaldo lógico de la base de datos se encuentra en:
03_backups/TurismoPeru_lacc_Full.bacpac
Procedimiento de importación o restauración
1. Abrir SSMS y conectarse al servidor de destino.
2. Hacer clic derecho en Bases de datos.
3. Seleccionar Importar aplicación de capa de datos.
4. Elegir el archivo TurismoPeru_lacc_Full.bacpac.
5. Indicar el nombre de la base de datos de destino.
6. Revisar el resumen y finalizar la importación.
7. Comprobar que las tablas, esquemas y datos estén disponibles.
Consultas y reportes
El archivo 05_reportes/consultas_reportes.sql contiene las consultas utilizadas para analizar clientes, reservas, pagos, estados y medios de pago.
El reporte exportado se encuentra en:
05_reportes/reportes.pdf
Configuración de Power BI
El archivo principal del reporte es:
06_powerbi/TurismoPeru_Reporte.pbix
Power BI se conecta a SQL Server utilizando la base de datos TURISMOPERU_lacc y la cuenta del analista. El reporte no almacena contraseñas dentro de la documentación pública.
Modelo
El modelo contiene las relaciones principales:
- lacc.persona → lacc.cliente.
- lacc.cliente → lacc.reserva.
- lacc.reserva → lacc.pago.
- lacc.estado_reserva → lacc.reserva.
- lacc.medio_pago → lacc.pago.
Medidas
- Total Clientes.
- Total Reservas.
- Total Ingresos.
- Ticket Promedio.
Visualizaciones
- Reservas por estado.
- Ingresos por medio de pago.
- Reservas por fecha.
- Top 10 clientes por cantidad de reservas.
- Ingresos por cliente.
Principales resultados
1. La base de datos registra 54 clientes y 102 reservas.
2. Los pagos representan aproximadamente 353,28 mil en ingresos.
3. El ticket promedio es de aproximadamente 3,46 mil por reserva.
4. El estado Completada concentra la mayor cantidad de reservas, con aproximadamente 36 registros.
5. El comportamiento temporal presenta un crecimiento entre mayo y julio de 2026, con un máximo cercano a 7 reservas en un mismo periodo.
Evidencias
La carpeta evidencias contiene capturas de:
- Creación y verificación de logins.
- Asignación y prueba de permisos.
- Generación del respaldo BACPAC.
- Repositorio e historial de GitHub.
- Dashboard final de Power BI.
La evidencia principal del reporte está guardada como:
evidencias/reporte_powerbi.png
Las capturas y documentos públicos no deben mostrar contraseñas reales.
Control de versiones
El repositorio debe conservar un historial con al menos cinco commits significativos, por ejemplo:
1. Configuración inicial del proyecto.
2. Implementación de usuarios y roles.
3. Configuración de permisos y pruebas de seguridad.
4. Importación, exportación y respaldo.
5. Integración de consultas y reporte de Power BI.
Seguridad del repositorio
- Las contraseñas reales deben reemplazarse por *** antes de publicar los scripts.
- No se deben guardar credenciales en capturas, archivos de texto o comandos.
- El archivo .gitignore debe excluir archivos temporales y configuraciones locales.
- El reporte debe conectarse mediante el usuario analista y respetar los permisos de solo lectura.
Autor
Chilon Casas
