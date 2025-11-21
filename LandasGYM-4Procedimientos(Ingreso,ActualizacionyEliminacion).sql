/** Procedimientos de GimnasioPrueba **/
USE LandasGYM;

------Procedimientos

--De Ingreso de Datos
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/** Procedimiento para ingresar a un nuevo Gimnasio **/
CREATE OR ALTER PROCEDURE dbo.IngresarNuevoGimnasio
@Nombre VARCHAR(50), 
@Direccion VARCHAR(100),
@Telefono VARCHAR(12),
@Email VARCHAR(50)
AS 
BEGIN
	SET NOCOUNT ON;

--Insertar gimnasio
	INSERT INTO ElementosGimnasio.Gimnasio (Nombre, Direccion, Telefono, Email) 
	VALUES (@Nombre, @Direccion, @Telefono, @Email);
	PRINT 'Gimnasio ingresado en la base exitosamente';

END;
/* Activacion EXEC dbo.IngresarNuevoGimnasio 'NombredeGimnasio', 'DirecciondeGimnasio', 'TelefonodeGimnasio', 'EmaildeGimnasio'; */


/** Procedimiento para ingresar a un nuevo Miembro **/
CREATE OR ALTER PROCEDURE dbo.IngresarNuevoMiembro 
@IdGimnasio INT,
@Nombre VARCHAR(50), 
@Apellido VARCHAR(50), 
@TipoMiembro VARCHAR(15),
@FechaNacimiento DATE,
@Telefono VARCHAR(12),
@Email VARCHAR(50),
@TipoMembresia VARCHAR(20) =NULL,
@Especialidad VARCHAR(20) =NULL,
@TipoServicio VARCHAR(15) =NULL
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @IdMiembro INT;

--Verificar el Tipo de miembro
	IF @TipoMiembro NOT IN ('Socio', 'Entrenador', 'Empleado')
    BEGIN
        RAISERROR('Tipo de miembro inválido.', 16, 1);
        RETURN;
	END;

--Insertar miembro
	INSERT INTO MiembrosAlmacenados.Miembros (Id_Gimnasio, Nombre, Apellido, Tipo_Miembro, Fecha_nacimiento, Telefono, Email) 
	VALUES (@IdGimnasio, @Nombre, @Apellido, @TipoMiembro, @FechaNacimiento, @Telefono, @Email);
	SET @IdMiembro = SCOPE_IDENTITY();
	PRINT 'Miembro ingresado en la base exitosamente';

	--Si el Miembro es Socio, Y el tipo de membresia que posee.  	
		IF @TipoMiembro = 'Socio'
			BEGIN 
				IF @TipoMembresia NOT IN ('Plata', 'Oro', 'Diamante')
					BEGIN
						RAISERROR('Debe ingresar un tipo de membresía valido. ', 16, 1);
						RETURN;
					END;

						INSERT INTO MiembrosAlmacenados.CategoriaMiembros (Id_Miembro, Tipo_Membresia, Fecha_Inicio	, Fecha_Fin	)
								VALUES (@IdMiembro, @TipoMembresia, GETDATE(), 
																				DATEADD(MONTH, CASE 
																					WHEN @TipoMembresia = 'Plata' THEN 1 
																					WHEN @TipoMembresia = 'Oro' THEN 3 
																					WHEN @TipoMembresia = 'Diamante' THEN 12 
																				END, GETDATE())
										);
								PRINT 'Socio creado con membresía de manera exitosa. ' + @TipoMembresia;
			END;
	--Si el Miembro es Entrenador, Y el tipo de Especialidad que posee.  	
		IF @TipoMiembro = 'Entrenador'
			BEGIN 
				IF @Especialidad NOT IN ('Zumba y Yoga', 'Fisico general', 'Atletico', 'Musculatura')
					BEGIN
						RAISERROR('Debe ingresar un tipo de especialidad valido. ', 16, 1);
						RETURN;
					END;

						INSERT INTO MiembrosAlmacenados.CategoriaMiembros(Id_Miembro, Especialidad, Fecha_Inicio, Fecha_Fin)
								VALUES (@IdMiembro, @Especialidad, GETDATE(), DATEADD(YEAR, 1, GETDATE()));

								PRINT 'Entrenador creado con Especialidad de manera exitosa. ' + @Especialidad;
			END;
	--Si el Miembro es Empleado, Y el tipo de Servicio que posee.  	
		IF @TipoMiembro = 'Empleado'
			BEGIN 
				IF @TipoServicio NOT IN ('Limpieza', 'Mantenimiento', 'Administracion')
					BEGIN
						RAISERROR('Debe ingresar un tipo de servicio valido. ', 16, 1);
						RETURN;
					END;

						INSERT INTO MiembrosAlmacenados.CategoriaMiembros(Id_Miembro, Tipo_Servicio, Fecha_Inicio, Fecha_Fin)
								VALUES (@IdMiembro, @TipoServicio, GETDATE(), DATEADD(YEAR, 1, GETDATE()));

								PRINT 'Empleado creado con Servicio de manera exitosa. ' + @TipoServicio;
			END;

END;
/* Activacion	EXEC dbo.IngresarNuevoMiembro 'NombredeMiembro', 'ApellidodeMiembro', 'TipodeMiembro', 'FechadeNacimiento', 'TelefonodeMiembro', 'EmaildeMiembro', 'TipoMembresia/Especialidad/TipoServicio'; */


/** Procedimiento para ingresar una nueva Clase **/
CREATE OR ALTER PROCEDURE dbo.IngresarNuevaClase
@IdMiembro INT,
@IdGimnasio INT,
@Nombre VARCHAR(50), 
@CupoMax INT,
@Dias VARCHAR(50),
@HorarioInicio TIME,
@HorarioFin TIME
AS 
BEGIN
	SET NOCOUNT ON;

--Insertar Clase
	INSERT INTO ElementosGimnasio.Clases (Id_Miembro, Id_Gimnasio, Nombre, Cupo_Max, Dias, HoraInicio, HoraFin) 
	VALUES (@IdMiembro, @IdGimnasio, @Nombre, @CupoMax, @Dias, @HorarioInicio, @HorarioFin);
	PRINT 'Clase ingresada en la base exitosamente';

END;
/* Activacion EXEC dbo.IngresarNuevaClase 'IdGimnasio', 'NombredeClase', 'CupoMaxdeClase', 'DiasdeClase', 'HoraInicioClase', 'HoraFinClase'; */


/** Procedimiento para ingresar una nueva Inscripcion **/
CREATE OR ALTER PROCEDURE dbo.IngresarNuevaInscripcion
@IdClase INT,
@IdMiembro INT,
@FechaInscripcion DATE
AS 
BEGIN
	SET NOCOUNT ON;

--Insertar gimnasio
	INSERT INTO RegistrosAlmacenados.Inscripciones(Id_Clase, Id_Miembro, Fecha_Inscripcion) 
	VALUES (@IdClase, @IdMiembro, @FechaInscripcion);
	PRINT 'Inscripcion ingresada en la base exitosamente';

END;
/* Activacion EXEC dbo.IngresarNuevaInscripcion 'IdClase', 'IdMiembro', 'FechaInscripcion'; */


/** Procedimiento para ingresar una nueva Utileria **/
CREATE OR ALTER PROCEDURE dbo.IngresarNuevaUtileria
@IdClase INT,
@TipoUtileria VARCHAR(100),
@Descripcion VARCHAR(300),
@UltimoMantenimiento DATETIME
AS 
BEGIN
	SET NOCOUNT ON;

--Insertar gimnasio
	INSERT INTO ElementosGimnasio.Utilerias (Id_Clase, Tipo_utileria, Descripcion, Ultimo_mantenimiento) 
	VALUES (@IdClase, @TipoUtileria, @Descripcion, @UltimoMantenimiento);
	PRINT 'Utileria ingresada en la base exitosamente';

END;
/* Activacion EXEC dbo.IngresarNuevaUtileria 'IdClase', 'TipodeUtileria', 'DescripciondeUtileria', 'UltimoMantenimientodeUtileria'; */


/** Procedimiento para ingresar un nuevo Mantenimiento **/
CREATE OR ALTER PROCEDURE dbo.IngresarNuevoMantenimiento
@IdUtileria INT, 
@IdMiembro INT, 
@TipoMantenimiento VARCHAR(15),
@ResumenMantenimiento VARCHAR(1000),
@ProximoMantenimiento DATE
AS 
BEGIN
	SET NOCOUNT ON;

--Insertar gimnasio
	INSERT INTO RegistrosAlmacenados.Mantenimientos (Id_Utileria, Id_Miembro, Tipo_Mantenimiento, Resumen_Mantenimiento, Proximo_Mantenimiento) 
	VALUES (@IdUtileria, @IdMiembro, @TipoMantenimiento, @ResumenMantenimiento, @ProximoMantenimiento);
	PRINT 'Mantenimiento ingresado en la base exitosamente';

END;
/* Activacion EXEC dbo.IngresarNuevoMantenimiento 'IddeUtileria', 'IddeMiembro', 'TipodeMantenimiento', 'ResumendeMantenimiento', 'ProximodeMantenimiento'; */


/** Procedimiento para realizar un pago por tipo de Miembro(Socio[TipoMemresia]), (Entrenador[Especialidad]) y (Empleado[TipoServicio]) **/
/*		El pago se realiza por tipo de miembro
			Si la membresia es de Plata el precio es 50$ el mes con acceso a una unica clase y a maquinas basicas(5 Utilerias).
			Si la membresia es de Oro el precio sube a 210$ por tres meses con acceso a dos clases y acceso completo a maquinas(10 Utilerias). 
			Si la membresia es de Diamante  el precio sube a 840$ al anio o 70$ al mes con acceso a tres clases y acceso completo a maquinas(10 Utilerias).

			Si el pago se realiza a un entrenador se le otorga 40$ por dia,
			Si el pago se realiza a un empleado se le otorga 20$ por dia.                                                                                        */
CREATE OR ALTER PROCEDURE dbo.IngresarNuevoPago
@IdMiembro INT,
@MetodoPago VARCHAR(20) = 'En linea'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @TipoMiembro VARCHAR(50),
        @TipoMembresia VARCHAR(50),
        @TipoServicio VARCHAR(50),
        @Especialidad VARCHAR(50),
        @Pago MONEY,
        @Descripcion VARCHAR(200),
        @IdPago INT;

    --Determinar el tipo de miembro
    SELECT @TipoMiembro = Tipo_Miembro FROM MiembrosAlmacenados.Miembros
    WHERE Id_Miembro = @IdMiembro;

    IF @TipoMiembro IS NULL
    BEGIN
        PRINT 'El ID de miembro no existe. ';
        RETURN;
    END

    -- Si es SOCIO 
    IF @TipoMiembro = 'Socio'
    BEGIN
        SELECT @TipoMembresia = Tipo_Membresia FROM MiembrosAlmacenados.CategoriaMiembros
        WHERE Id_Miembro = @IdMiembro;

        IF @TipoMembresia = 'Plata'
            SET @Pago = 50;
        ELSE IF @TipoMembresia = 'Oro'
            SET @Pago = 70; -- 210 / 3 meses
        ELSE IF @TipoMembresia = 'Diamante'
            SET @Pago = 70; -- mensual equivalente
        ELSE
            SET @Pago = 0;

        SET @Descripcion = CONCAT('Pago de membresía tipo ', @TipoMembresia, ' para Socio.');
    END

    -- Si es ENTRENADOR
    ELSE IF @TipoMiembro = 'Entrenador'
    BEGIN
        SELECT @Especialidad = Especialidad FROM MiembrosAlmacenados.CategoriaMiembros
        WHERE Id_Miembro = @IdMiembro;

        SET @Pago = 1200; 
        SET @Descripcion = CONCAT('Pago mensual para Entrenador especializado en ', @Especialidad, '.');
    END

    --Si es EMPLEADO
    ELSE IF @TipoMiembro = 'Empleado'
    BEGIN
        SELECT @TipoServicio = Tipo_Servicio FROM MiembrosAlmacenados.CategoriaMiembros
        WHERE Id_Miembro = @IdMiembro;

        IF @TipoServicio = 'Limpieza'
            SET @Pago = 600;
        ELSE IF @TipoServicio = 'Mantenimiento'
            SET @Pago = 800;
        ELSE IF @TipoServicio = 'Administracion'
            SET @Pago = 300; 
        ELSE
            SET @Pago = 0;

        SET @Descripcion = CONCAT('Pago mensual para Empleado de ', @TipoServicio, '.');
    END

    ELSE
    BEGIN
        PRINT 'Tipo de miembro desconocido.';
        RETURN;
    END

    --Registrar en la tabla Pagos
    INSERT INTO RegistrosAlmacenados.Pagos (Id_Miembro, Monto, Descripcion_pago, Metodo_pago, Fecha_Pago)
    VALUES (@IdMiembro, @Pago, @Descripcion, @MetodoPago, GETDATE()	);

    SET @IdPago = SCOPE_IDENTITY();
    PRINT CONCAT('Pago registrado correctamente: $', @Pago, ' (', @Descripcion, ')');
END;
/* Activacion EXEC dbo.IngresarNuevoPago @IdMiembro = 1, @MetodoPago = 'En linea/Efectivo'; */


/* Procedimiento para Almacenar Pagos por eliminacion */
CREATE OR ALTER PROCEDURE dbo.ArchivarPagosDeMiembro
    @IdMiembro INT,
    @Motivo VARCHAR(200) = 'Eliminación de miembro'
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar que existan pagos
        IF NOT EXISTS (
            SELECT 1 FROM RegistrosAlmacenados.Pagos
            WHERE Id_Miembro = @IdMiembro
        )
        BEGIN
            PRINT 'No hay pagos que archivar para este miembro.';
            COMMIT TRANSACTION;
            RETURN;
        END

        -- ARCHIVAR PAGOS
        INSERT INTO RegistrosAlmacenados.Pagos_Archivo
            (Id_Pago_Original, Id_Miembro, Fecha_Pago, Monto, Metodo_Pago, Motivo_Archivado)
        SELECT 
            P.Id_Pago,
            P.Id_Miembro,
            P.Fecha_pago,
            P.Monto,
            P.Metodo_Pago,
            @Motivo
        FROM RegistrosAlmacenados.Pagos P
        WHERE P.Id_Miembro = @IdMiembro;

        -- BORRAR PAGOS ORIGINALES
        DELETE FROM RegistrosAlmacenados.Pagos
        WHERE Id_Miembro = @IdMiembro;

        COMMIT TRANSACTION;
        PRINT 'Pagos archivados correctamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Error al archivar pagos: %s', 16, 1, @Msg);
    END CATCH
END;
/* Activacion EXEC dbo.ArchivarPagosDeMiembro */


--De Actualizacion de Datos
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Procedimiento paara Actualizar un Gimnasio*/
CREATE OR ALTER PROCEDURE dbo.ActualizarGimnasio
    @Id_Gimnasio INT,
    @Nombre VARCHAR(20) = NULL,
    @Direccion VARCHAR(100) = NULL,
    @Telefono VARCHAR(12) = NULL,
    @Email VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ElementosGimnasio.Gimnasio WHERE Id_Gimnasio = @Id_Gimnasio)
    BEGIN
        PRINT 'El gimnasio con el ID especificado no existe. ';
        RETURN;
    END;

    UPDATE ElementosGimnasio.Gimnasio
    SET 
        Nombre = ISNULL(@Nombre, Nombre),
        Direccion = ISNULL(@Direccion, Direccion),
        Telefono = ISNULL(@Telefono, Telefono),
        Email = ISNULL(@Email, Email)
    WHERE Id_Gimnasio = @Id_Gimnasio;

    PRINT 'Gimnasio actualizado correctamente.';
END;
/* Activacion EXEC dbo.ActualizarGimnasio @Id_Gimnasio = #, @Nombre = 'Nombre', @Direccion = 'Direccion', @Telefono = Telefono, @Email = Email; */


/*Procedimiento para Actualizar un Miembro*/
CREATE OR ALTER PROCEDURE dbo.ActualizarMiembro
    @IdMiembro INT, 
	@IdGimnasio INT,
	@TipoMiembro VARCHAR(15) = NULL,
    @Nombre VARCHAR(50) = NULL,
    @Apellido VARCHAR(50) = NULL,
    @FechaNacimiento DATE= NULL,
    @Telefono VARCHAR(12) = NULL,
    @Email VARCHAR(50) = NULL,
	@TipoMembresia VARCHAR(20) = NULL,
	@Especialidad VARCHAR(20) = NULL,
	@TipoServicio VARCHAR(50) = NULL,
    @FechaInicio DATE= NULL,
    @FechaFin DATE= NULL

AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM MiembrosAlmacenados.Miembros  WHERE Id_Miembro = @IdMiembro)
    BEGIN
        PRINT 'El miembro con el ID especificado no existe. ';
        RETURN;
    END;

    UPDATE MiembrosAlmacenados.Miembros
    SET 
        Id_Gimnasio = ISNULL(@IdGimnasio, Id_Gimnasio),
		Tipo_Miembro = ISNULL(@TipoMiembro, Tipo_Miembro),
		Nombre = ISNULL(@Nombre, Nombre),
		Apellido = ISNULL(@Apellido, Apellido),
        Fecha_nacimiento = ISNULL(@FechaNacimiento, Fecha_Nacimiento),
        Telefono = ISNULL(@Telefono, Telefono),
        Email = ISNULL(@Email, Email)
    WHERE Id_Miembro = @IdMiembro;

	 IF EXISTS (SELECT 1 FROM CategoriaMiembros WHERE Id_Miembro = @IdMiembro)
    BEGIN
        UPDATE CategoriaMiembros
        SET
            Tipo_Membresia = ISNULL(@TipoMembresia, Tipo_Membresia),
            Especialidad = ISNULL(@Especialidad, Especialidad),
            Tipo_Servicio = ISNULL(@TipoServicio, Tipo_Servicio),
            Fecha_Inicio = ISNULL(@FechaInicio, Fecha_Inicio),
            Fecha_Fin = ISNULL(@FechaFin, Fecha_Fin)
        WHERE Id_Miembro = @IdMiembro;
    END
    ELSE
    BEGIN
        INSERT INTO CategoriaMiembros (Id_Miembro, Tipo_Membresia, Especialidad, Tipo_Servicio, Fecha_Inicio, Fecha_Fin)
        VALUES (@IdMiembro, @TipoMembresia, @Especialidad, @TipoServicio,
                ISNULL(@FechaInicio, GETDATE()),
                ISNULL(@FechaFin, DATEADD(MONTH, 6, GETDATE())));
    END;

    PRINT 'Miembro actualizado correctamente.';
END;
/* Activacion EXEC dbo.ActualizarMiembro 
@IdMiembro = #, 
@IdGimansio = #, 
@Nombre = 'Nombre', 
@Apellido = 'Apellido', 
@FechaNacimiento = Fecha_nacimiento, 
@Telefono = 'Telefono', 
@Email = 'Email', 
@TipoMmebresia/@Especialidad/@TipoServicio = 'Tipo_Mmebresia/Especialidad/Tipo_Servicio', 
@FechaInicio = Fecha_Inicio,
@FechaFin = Fecha_Fin; */


/*Procedimiento para Actualizar una Clase*/
CREATE OR ALTER PROCEDURE dbo.ActualizarClase
    @IdClase INT, 
	@IdGimnasio INT NULL,
    @Nombre VARCHAR(50) = NULL,
	@CupoMax INT = NULL,
    @Dias VARCHAR(50) = NULL,
	@HoraInicio TIME = NULL,
    @HoraFin TIME = NULL

AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ElementosGimnasio.Clases  WHERE Id_Clase = @IdClase)
    BEGIN
        PRINT 'La Clase con el ID especificado no existe. ';
        RETURN;
    END;

    UPDATE ElementosGimnasio.Clases
    SET 
        Id_Gimnasio = ISNULL(@IdGimnasio, Id_Gimnasio),
		Nombre = ISNULL(@Nombre, Nombre),
		Cupo_Max = ISNULL(@CupoMax, Cupo_Max),
		Dias = ISNULL(@Dias, Dias),
		HoraInicio = ISNULL(@HoraInicio, HoraInicio),
		HoraFin = ISNULL(@HoraFin, HoraFin)	
    WHERE Id_Clase = @IdClase;

    PRINT 'Clase actualizada correctamente.';
END;
/* Activacion EXEC dbo.ActualizarMiembro 
@IdClase = #, 
@IdGimansio = #, 
@Nombre = 'Nombre', 
@CupoMax = #', 
@Dias = 'Dias', 
@HoraInicio = FechaInicio, 
@HoraFin = FechaFin; */


/*Procedimiento para Actualizar una Inscripcion*/
CREATE OR ALTER PROCEDURE dbo.ActualizarInscripcion
    @IdInscripcion INT,
	@IdClase INT = NULL, 
	@IdMiembro INT = NULL,
	@FechaInscripcion DATE = NULL

AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM RegistrosAlmacenados.Inscripciones  WHERE Id_Inscripcion = @IdInscripcion)
    BEGIN
        PRINT 'La Inscripcion con el ID especificado no existe. ';
        RETURN;
    END;

    UPDATE RegistrosAlmacenados.Inscripciones
    SET 
       Id_Clase = ISNULL(@IdClase, Id_Clase),
	   Id_Miembro = ISNULL(@IdMiembro, Id_Miembro),
	   Fecha_Inscripcion = ISNULL(@FechaInscripcion, Fecha_Inscripcion)
		
    WHERE Id_Inscripcion = @IdInscripcion;

    PRINT 'Inscripcion actualizada correctamente.';
END;
/* Activacion EXEC dbo.ActualizarInscripcion 
@IdInscripcion = #,
@IdClase = #, 
@IdMiembro = #, 
@FechaInscripcion = 'Fecha_Inscripcion'; */


/*Procedimiento para Actualizar una Utileria*/
CREATE OR ALTER PROCEDURE dbo.ActualizarUtileria
    @IdUtileria INT,
	@IdClase INT = NULL, 
	@TipoUtileria VARCHAR(100) = NULL,
	@Descripcion VARCHAR(300) = NULL,
	@UltimoMantenimiento DATETIME = NULL

AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ElementosGimnasio.Utilerias  WHERE Id_Utileria = @IdUtileria)
    BEGIN
        PRINT 'La Utileria con el ID especificado no existe. ';
        RETURN;
    END;

    UPDATE	ElementosGimnasio.Utilerias
    SET 
       Id_Clase = ISNULL(@IdClase, Id_Clase),
	   Tipo_utileria = ISNULL(@TipoUtileria, Tipo_utileria),
	   Descripcion = ISNULL(@Descripcion, Descripcion),
	   Ultimo_mantenimiento = ISNULL(@UltimoMantenimiento,Ultimo_mantenimiento)
		
    WHERE Id_Utileria = @IdUtileria;

    PRINT 'Utileria actualizada correctamente.';
END;
/* Activacion EXEC dbo.ActualizarUtileria 
@IdUtileria = #,
@IdClase = #, 
@TipoUtileria = 'Tipo_utileria',
@Descripcion = 'Descripcion',
@UltimoMantenimiento = 'Ultimo_mantenimiento'; */


/*Procedimiento para Actualizar una Mantenimeinto*/
CREATE OR ALTER PROCEDURE dbo.ActualizarMantenimiento
    @IdMantenimiento INT,
	@IdUtileria INT = NULL,
	@IdMiembro INT = NULL,
	@TipoMantenimiento VARCHAR(15) = NULL,
	@ResumenMantenimiento VARCHAR(1000) = NULL,
	@ProximoMantenimiento DATETIME = NULL

AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM RegistrosAlmacenados.Mantenimientos  WHERE Id_Mantenimiento = @IdMantenimiento)
    BEGIN
        PRINT 'El Mantenimiento con el ID especificado no existe. ';
        RETURN;
    END;

    UPDATE RegistrosAlmacenados.Mantenimientos
    SET 
       Id_Utileria = ISNULL(@IdUtileria, Id_Utileria),
	   Id_Miembro= ISNULL(@IdMiembro, Id_Miembro),
	   Tipo_mantenimiento = ISNULL(@TipoMantenimiento, Tipo_mantenimiento),
	   Resumen_mantenimiento = ISNULL(@ResumenMantenimiento, Resumen_mantenimiento),
	   Proximo_Mantenimiento = ISNULL(@ProximoMantenimiento, Proximo_Mantenimiento)
		
    WHERE Id_Mantenimiento = @IdMantenimiento;

    PRINT 'Mantenimiento actualizado correctamente.';
END;
/* Activacion EXEC dbo.ActualizarMantenimiento
@IdMantenimiento = #,
@IdUtileria = #,
@IdMiembro = #, 
@TipoMantenimiento = 'Tipo_mantenimiento',
@ResumenMantenimiento = 'Resumen_mantenimiento',
@ProximoMantenimiento = 'Proximo_Mantenimiento'; */


/*Procedimiento para Actualizar un Pago*/
CREATE OR ALTER PROCEDURE dbo.ActualizarPago
    @IdPago INT,
	@IdMiembro INT = NULL,
	@FacturaCodigo INT = NULL,
	@Monto DECIMAL(10,2) = NULL,
	@MetodoPago VARCHAR(20) = NULL,
	@FechaPago DATE = NULL

AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM RegistrosAlmacenados.Pagos  WHERE Id_Pago = @IdPago)
    BEGIN
        PRINT 'El Pago con el ID especificado no existe. ';
        RETURN;
    END;

    UPDATE RegistrosAlmacenados.Pagos
    SET 
	   Id_Miembro = ISNULL(@IdMiembro, Id_Miembro),
	   Factura_codigo = ISNULL(@FacturaCodigo, Factura_codigo),
	   Monto = ISNULL(@Monto, Monto),
	   Metodo_pago = ISNULL(@MetodoPago, Metodo_pago),
	   Fecha_pago = ISNULL(@FechaPago, Fecha_pago)
		
    WHERE Id_Pago = @IdPago;

    PRINT 'Pago actualizado correctamente.';
END;
/* Activacion EXEC dbo.ActualizarPago
@IdPago = #,
@IdMiembro = #, 
@FacturaCodigo = #,
@Monto = Monto,
@MetodoPago = 'Metodo_pago',
@ResumenMantenimiento = 'Resumen_mantenimiento',
@FechaPago = 'Fecha_pago'; */


------Actualiza toda la base de datos
CREATE OR ALTER PROCEDURE dbo.ActualizarTodoGimnasio
    /* Valores para Gimnasio */
    @Id_Gimnasio INT = NULL,
    @NombreGimnasio VARCHAR(20) = NULL,
    @Direccion VARCHAR(100) = NULL,
    @Telefono VARCHAR(12) = NULL,
    @Email VARCHAR(50) = NULL,

    /* Valores para Miembro */
    @IdMiembro INT = NULL,
    @IdGimnasioMiembro INT = NULL,
    @TipoMiembro VARCHAR(15) = NULL,
    @NombreMiembro VARCHAR(50) = NULL,
    @Apellido VARCHAR(50) = NULL,
    @FechaNacimiento DATE = NULL,
    @TelefonoMiembro VARCHAR(12) = NULL,
    @EmailMiembro VARCHAR(50) = NULL,
    @TipoMembresia VARCHAR(20) = NULL,
    @Especialidad VARCHAR(20) = NULL,
    @TipoServicio VARCHAR(50) = NULL,
    @FechaInicio DATE = NULL,
    @FechaFin DATE = NULL,

    /* Valores para Clase */
    @IdClase INT = NULL,
    @IdGimnasioClase INT = NULL,
    @NombreClase VARCHAR(50) = NULL,
    @CupoMax INT = NULL,
    @Dias VARCHAR(50) = NULL,
    @HoraInicio TIME = NULL,
    @HoraFin TIME = NULL,

    /* Valorespara Inscripción */
    @IdInscripcion INT = NULL,
    @IdClaseInscripcion INT = NULL,
    @IdMiembroInscripcion INT = NULL,
    @FechaInscripcion DATE = NULL,

    /* Valorespara Utilería */
    @IdUtileria INT = NULL,
    @IdClaseUtileria INT = NULL,
    @TipoUtileria VARCHAR(100) = NULL,
    @Descripcion VARCHAR(300) = NULL,
    @UltimoMantenimiento DATETIME = NULL,

    /* Valores para Mantenimiento */
    @IdMantenimiento INT = NULL,
    @IdUtileriaM INT = NULL,
    @IdMiembroM INT = NULL,
    @TipoMantenimiento VARCHAR(15) = NULL,
    @ResumenMantenimiento VARCHAR(1000) = NULL,
    @ProximoMantenimiento DATETIME = NULL,

    /* Valores para Pago */
    @IdPago INT = NULL,
    @IdMiembroPago INT = NULL,
    @FacturaCodigo INT = NULL,
    @Monto DECIMAL(10,2) = NULL,
    @MetodoPago VARCHAR(20) = NULL,
    @FechaPago DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        /* Actualizar Gimnasio */
        IF @Id_Gimnasio IS NOT NULL
            EXEC dbo.ActualizarGimnasio 
                @Id_Gimnasio = @Id_Gimnasio,
                @Nombre = @NombreGimnasio,
                @Direccion = @Direccion,
                @Telefono = @Telefono,
                @Email = @Email;

        /* Actualizar Miembro */
        IF @IdMiembro IS NOT NULL
            EXEC dbo.ActualizarMiembro 
                @IdMiembro = @IdMiembro,
                @IdGimnasio = @IdGimnasioMiembro,
                @TipoMiembro = @TipoMiembro,
                @Nombre = @NombreMiembro,
                @Apellido = @Apellido,
                @FechaNacimiento = @FechaNacimiento,
                @Telefono = @TelefonoMiembro,
                @Email = @EmailMiembro,
                @TipoMembresia = @TipoMembresia,
                @Especialidad = @Especialidad,
                @TipoServicio = @TipoServicio,
                @FechaInicio = @FechaInicio,
                @FechaFin = @FechaFin;

        /* Actualizar Clase */
        IF @IdClase IS NOT NULL
            EXEC dbo.ActualizarClase 
                @IdClase = @IdClase,
                @IdGimnasio = @IdGimnasioClase,
                @Nombre = @NombreClase,
                @CupoMax = @CupoMax,
                @Dias = @Dias,
                @HoraInicio = @HoraInicio,
                @HoraFin = @HoraFin;

        /* Actualizar Inscripción */
        IF @IdInscripcion IS NOT NULL
            EXEC dbo.ActualizarInscripcion 
                @IdInscripcion = @IdInscripcion,
                @IdClase = @IdClaseInscripcion,
                @IdMiembro = @IdMiembroInscripcion,
                @FechaInscripcion = @FechaInscripcion;

        /* Actualizar Utilería */
        IF @IdUtileria IS NOT NULL
            EXEC dbo.ActualizarUtileria 
                @IdUtileria = @IdUtileria,
                @IdClase = @IdClaseUtileria,
                @TipoUtileria = @TipoUtileria,
                @Descripcion = @Descripcion,
                @UltimoMantenimiento = @UltimoMantenimiento;

        /* Actualizar Mantenimiento */
        IF @IdMantenimiento IS NOT NULL
            EXEC dbo.ActualizarMantenimiento 
                @IdMantenimiento = @IdMantenimiento,
                @IdUtileria = @IdUtileriaM,
                @IdMiembro = @IdMiembroM,
                @TipoMantenimiento = @TipoMantenimiento,
                @ResumenMantenimiento = @ResumenMantenimiento,
                @ProximoMantenimiento = @ProximoMantenimiento;

        /* Actualizar Pago */
        IF @IdPago IS NOT NULL
            EXEC dbo.ActualizarPago 
                @IdPago = @IdPago,
                @IdMiembro = @IdMiembroPago,
                @FacturaCodigo = @FacturaCodigo,
                @Monto = @Monto,
                @MetodoPago = @MetodoPago,
                @FechaPago = @FechaPago;

        COMMIT TRANSACTION;
        PRINT 'Todas las actualizaciones se realizaron correctamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error en la actualización general.';
        PRINT ERROR_MESSAGE();
    END CATCH
END;
/*Activacion EXEC dbo.ActualizarTodoGimnasio;*/


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--PROCEDIMIENTOS DE ELIMINACION DE: Gimnasio, Miembros(Inscripciones), Clase, Pago, Utileria
-- Procedimiento que elimina un gimnasio del sistema de forma permanente.
CREATE OR ALTER PROCEDURE EliminarGimnasio
    @IdGimnasio INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM ElementosGimnasio.Gimnasio WHERE Id_Gimnasio = @IdGimnasio)
        BEGIN
            RAISERROR('No existe el gimnasio con Id = %d', 16, 1, @IdGimnasio);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 1) Obtener clases y utilerias del gimnasio
        -- (Se usan subconsultas para limpiar mantenimientos, utilerias, inscripciones, miembros, pagos y categorias)
        -- Eliminamos mantenimientos asociados a utilerias de las clases del gimnasio
        DELETE M
        FROM RegistrosAlmacenados.Mantenimientos M
        WHERE M.Id_Utileria IN (
            SELECT U.Id_Utileria
            FROM ElementosGimnasio.Utilerias U
            JOIN ElementosGimnasio.Clases C ON U.Id_Clase = C.Id_Clase
            WHERE C.Id_Gimnasio = @IdGimnasio
        );

        -- Eliminamos utilerias de las clases del gimnasio
        DELETE U
        FROM ElementosGimnasio.Utilerias U
        WHERE U.Id_Clase IN (
            SELECT C.Id_Clase FROM ElementosGimnasio.Clases C WHERE C.Id_Gimnasio = @IdGimnasio
        );

        -- Eliminamos inscripciones de las clases del gimnasio
        DELETE I
        FROM RegistrosAlmacenados.Inscripciones I
        WHERE I.Id_Clase IN (
            SELECT C.Id_Clase FROM ElementosGimnasio.Clases C WHERE C.Id_Gimnasio = @IdGimnasio
        );

        -- Eliminamos pagos de los miembros del gimnasio (opcional: comentar si no quieres borrar pagos)
        DELETE P
        FROM RegistrosAlmacenados.Pagos P
        WHERE P.Id_Miembro IN (
            SELECT M.Id_Miembro FROM MiembrosAlmacenados.Miembros M WHERE M.Id_Gimnasio = @IdGimnasio
        );

        -- Eliminamos mantenimientos hechos por miembros del gimnasio (si existen otros mantenimientos)
        DELETE M2
        FROM RegistrosAlmacenados.Mantenimientos M2
        WHERE M2.Id_Miembro IN (
            SELECT Id_Miembro FROM MiembrosAlmacenados.Miembros WHERE Id_Gimnasio = @IdGimnasio
        );

        -- Eliminamos categorias de miembros
        DELETE CM
        FROM MiembrosAlmacenados.CategoriaMiembros CM
        WHERE CM.Id_Miembro IN (
            SELECT Id_Miembro FROM MiembrosAlmacenados.Miembros WHERE Id_Gimnasio = @IdGimnasio
        );

        -- Eliminamos inscripciones de los miembros del gimnasio (por si las hay en otras clases)
        DELETE I2
        FROM RegistrosAlmacenados.Inscripciones I2
        WHERE I2.Id_Miembro IN (
            SELECT Id_Miembro FROM MiembrosAlmacenados.Miembros WHERE Id_Gimnasio = @IdGimnasio
        );

        -- Eliminamos miembros
        DELETE FROM MiembrosAlmacenados.Miembros
        WHERE Id_Gimnasio = @IdGimnasio;

        -- Eliminamos clases del gimnasio
        DELETE FROM ElementosGimnasio.Clases
        WHERE Id_Gimnasio = @IdGimnasio;

        -- Finalmente, eliminamos el gimnasio
        DELETE FROM ElementosGimnasio.Gimnasio
        WHERE Id_Gimnasio = @IdGimnasio;

        COMMIT TRANSACTION;
        PRINT 'Gimnasio y dependencias eliminados correctamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Error al eliminar gimnasio: %s',16,1,@msg);
    END CATCH
END;
/* Activacio EXEC dbo.EliminarGimnasio @IdGimnasio = #; */


--EliminarMiembro(A su vez elimina Inscripciones)
--Elimina al miembro y sus inscripciones pero guarda los pagos en la tabla de Pagos_Archivados
CREATE OR ALTER PROCEDURE dbo.EliminarMiembro_ArchivandoPagos
    @IdMiembro INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar existencia
        IF NOT EXISTS (
            SELECT 1 FROM MiembrosAlmacenados.Miembros
            WHERE Id_Miembro = @IdMiembro
        )
        BEGIN
            RAISERROR('El miembro no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Archivar pagos
        EXEC dbo.ArchivarPagosDeMiembro 
            @IdMiembro = @IdMiembro,
            @Motivo = 'Eliminación del miembro';

        --Eliminar dependencias
        DELETE FROM RegistrosAlmacenados.Inscripciones
        WHERE Id_Miembro = @IdMiembro;

        DELETE FROM RegistrosAlmacenados.Mantenimientos
        WHERE Id_Miembro = @IdMiembro;

        DELETE FROM MiembrosAlmacenados.CategoriaMiembros
        WHERE Id_Miembro = @IdMiembro;

        -- Eliminar miembro
        DELETE FROM MiembrosAlmacenados.Miembros
        WHERE Id_Miembro = @IdMiembro;

        COMMIT TRANSACTION;

        PRINT 'Miembro eliminado y pagos archivados correctamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Error al eliminar miembro archivando pagos: %s', 16, 1, @Msg);
    END CATCH
END;
/* Activacion EXEC EliminarMiembro @IdMiembro = # */


--PROCEDIMIENTO ELIMINACIÓN CLASE
-- Procedimiento que elimina una clase del sistema de manera segura.
-- No elimina ni modifica inscripciones ni otros registros asociados.
CREATE OR ALTER PROCEDURE EliminarClase
    @IdClase INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM ElementosGimnasio.Clases WHERE Id_Clase = @IdClase)
        BEGIN
            RAISERROR('No existe la clase con Id = %d', 16, 1, @IdClase);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Eliminamos mantenimientos de utilerias de la clase
        DELETE M
        FROM RegistrosAlmacenados.Mantenimientos M
        WHERE M.Id_Utileria IN (SELECT Id_Utileria FROM ElementosGimnasio.Utilerias WHERE Id_Clase = @IdClase);

        -- Eliminamos utilerias de la clase
        DELETE FROM ElementosGimnasio.Utilerias WHERE Id_Clase = @IdClase;

        -- Eliminamos inscripciones de la clase
        DELETE FROM RegistrosAlmacenados.Inscripciones WHERE Id_Clase = @IdClase;

        -- Finalmente eliminamos la clase
        DELETE FROM ElementosGimnasio.Clases WHERE Id_Clase = @IdClase;

        COMMIT TRANSACTION;
        PRINT 'Clase y sus dependencias eliminadas correctamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Error al eliminar clase: %s',16,1,@msg);
    END CATCH
END;
/* Activacion EXEC EliminarClase @IdClase = #; */


--PROCEDIMIENTO ELIMINACIÓN UTILERIA
-- Procedimiento que elimina una utilería del sistema sin afectar los registros de mantenimiento.
CREATE OR ALTER PROCEDURE EliminarUtileria
    @IdUtileria INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM ElementosGimnasio.Utilerias WHERE Id_Utileria = @IdUtileria)
        BEGIN
            RAISERROR('No existe la utilería con Id = %d', 16, 1, @IdUtileria);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Si la columna Id_Utileria de Mantenimientos permite NULL -> setear NULL
        -- Si NO permite NULL -> eliminar registros de mantenimientos (o moverlos a tabla de historial)
        IF COLUMNPROPERTY(OBJECT_ID('RegistrosAlmacenados.Mantenimientos'), 'Id_Utileria', 'AllowsNull') = 1
        BEGIN
            UPDATE RegistrosAlmacenados.Mantenimientos
            SET Id_Utileria = NULL
            WHERE Id_Utileria = @IdUtileria;
        END
        ELSE
        BEGIN
            DELETE FROM RegistrosAlmacenados.Mantenimientos
            WHERE Id_Utileria = @IdUtileria;
        END

        DELETE FROM ElementosGimnasio.Utilerias WHERE Id_Utileria = @IdUtileria;

        COMMIT TRANSACTION;
        PRINT 'Utilería eliminada correctamente (mantenimientos actualizados/eliminados según esquema).';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Error al eliminar utilería: %s',16,1,@msg);
    END CATCH
END;
/* Activacion EXEC EliminarUtileria @IdUtileria = #; */



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
