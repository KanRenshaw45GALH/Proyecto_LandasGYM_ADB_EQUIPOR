/** Vistas y Indices de GimnsioPrueba **/
USE LandasGYM;


------ Vistas
/** Utilería por Clase **/
CREATE OR ALTER VIEW VW_UtileriaPorClase
AS
SELECT
    C.Nombre AS NombreClase,
    C.Dias,
    C.HoraInicio,
    U.Tipo_utileria,
    U.Descripcion AS DescripcionUtileria,
    U.Ultimo_mantenimiento,
	RANK() OVER(ORDER BY C.Id_Clase) AS Ranking_Utilerias
FROM
    ElementosGimnasio.Clases AS C
JOIN
    ElementosGimnasio.Utilerias AS U ON C.Id_Clase = U.Id_Clase;
/* Activacion SELECT * FROM VW_UtileriaPorClase; */


/** Mantenimiento por Utilería **/
CREATE OR ALTER VIEW VW_MantenimientoPorUtileria
AS
SELECT
    U.Tipo_utileria,
    U.Descripcion AS DescripcionUtileria,
    M.Tipo_mantenimiento,
    M.Resumen_mantenimiento,
    M.Proximo_Mantenimiento,
    E.Nombre AS NombreEmpleado,
    E.Apellido AS ApellidoEmpleado,
    ROW_NUMBER() OVER (PARTITION BY U.Id_Utileria ORDER BY M.Proximo_Mantenimiento DESC) AS NumeroMantenimiento
FROM
    ElementosGimnasio.Utilerias AS U
JOIN
    RegistrosAlmacenados.Mantenimientos AS M ON U.Id_Utileria = M.Id_Utileria
JOIN
    MiembrosAlmacenados.Miembros AS E ON M.Id_Miembro = E.Id_Miembro
WHERE
    E.Tipo_Miembro = 'Empleado'; -- Asegura que solo se muestre el empleado responsable
/* Activacion SELECT * FROM VW_MantenimientoPorUtileria; */


/** Miembros por Gimnasio **/
CREATE OR ALTER VIEW VW_MiembrosPorGimnasio AS
SELECT 
    g.Id_Gimnasio,
    g.Nombre AS NombreGimnasio,
    m.Id_Miembro,
    m.Nombre AS NombreMiembro,
    m.Apellido,
    m.Tipo_Miembro,
    m.Email
FROM ElementosGimnasio.Gimnasio g
JOIN MiembrosAlmacenados.Miembros m 
    ON g.Id_Gimnasio = m.Id_Gimnasio;
/* Activacion  SELECT * FROM VW_MiembrosPorGimnasio; */


/** Clases por Gimnasio**/
CREATE OR ALTER VIEW VW_ClasesPorGimnasio AS
SELECT 
    g.Id_Gimnasio,
    g.Nombre AS NombreGimnasio,
    c.Id_Clase,
    c.Nombre AS NombreClase,
    c.Cupo_Max,
    c.Dias,
    c.HoraInicio,
    c.HoraFin,
	RANK() OVER(PARTITION BY g.Id_Gimnasio ORDER BY c.Cupo_Max DESC) AS Ranking_Cupo
FROM ElementosGimnasio.Gimnasio g
JOIN ElementosGimnasio.Clases c 
    ON g.Id_Gimnasio = c.Id_Gimnasio;
/* Activacion SELECT * FROM VW_ClasesPorGimnasio; */




------Indices
-- PagosAlmacenados.Pagos
CREATE NONCLUSTERED INDEX I_Pagos_MetodoYFecha
ON RegistrosAlmacenados.Pagos (Metodo_pago, Fecha_pago DESC);

--- RegistrosAlmacenados.Inscripciones
CREATE NONCLUSTERED INDEX IX_Inscripciones_IdClaseIdMiembro
ON RegistrosAlmacenados.Inscripciones (Id_Clase)
INCLUDE (Id_Miembro);

--- RegistrosAlmacenados.Mantenimientos
CREATE NONCLUSTERED INDEX IX_Mantenimientos_IdUtileriaIdMiembro
ON RegistrosAlmacenados.Mantenimientos (Id_Utileria)
INCLUDE (Id_Miembro);

--- MiembrosAlmacenados.Miembros
CREATE NONCLUSTERED INDEX IX_Miembros_TipoMiembroIdMiembro
ON MiembrosAlmacenados.Miembros (Tipo_Miembro)
INCLUDE (Id_Miembro);

--- ElementosGimnasio.Clases
CREATE NONCLUSTERED INDEX IX_Clases_Gimnasio
ON ElementosGimnasio.Clases (Id_Gimnasio);

--- ElementosGimnasio.Utilerias
CREATE NONCLUSTERED INDEX IX_Clases_Utileria
ON ElementosGimnasio.Utilerias (Id_Clase);

