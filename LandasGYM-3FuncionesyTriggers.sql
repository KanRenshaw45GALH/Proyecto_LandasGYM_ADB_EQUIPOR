/** Funciones y Triggers de GimnasioPrueba **/
USE LandasGYM;


------Funciones
/** Funciones para Determinar si un Miembro es SOCIO, ENTRENADOR, EMPLEADO **/
CREATE OR ALTER FUNCTION ObtenerTipoMiembro
(@IdMiembro INT)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @TipoMiembro VARCHAR(20);

	SELECT @TipoMiembro = Tipo_Miembro FROM MiembrosAlmacenados.Miembros WHERE @IdMiembro = Id_Miembro;
   RETURN @TipoMiembro;
END;
/* Activacion			SELECT dbo.ObtenerTipoMiembro(#Miembro) AS Tipo_Miembro; */


/** Funciones para Determinar DetalleMiembro de un Socio **/
CREATE OR ALTER FUNCTION ObtenerDetalleMiembro
(@IdMiembro INT)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @TipoMiembro VARCHAR(20);
    DECLARE @TipoMembresia VARCHAR(20);
    DECLARE @Especialidad VARCHAR(20);
    DECLARE @TipoServicio VARCHAR(15);
    DECLARE @Resultado VARCHAR(100);

	SELECT @TipoMiembro = Tipo_Miembro 
	FROM MiembrosAlmacenados.Miembros WHERE @IdMiembro = Id_Miembro;

	SELECT 
		@TipoMembresia = Tipo_Membresia,
        @Especialidad = Especialidad,
        @TipoServicio = Tipo_Servicio
    FROM MiembrosAlmacenados.CategoriaMiembros WHERE @IdMiembro = Id_Miembro;

	 IF @TipoMiembro = 'Socio'
        BEGIN
			IF @TipoMembresia = 'Plata'
				SET @resultado = 'El Socio posee una membresia de PLATA. ';
			ELSE IF	@TipoMembresia = 'Oro'
				SET @resultado = 'El Socio posee una membresia de Oro. ';
			ELSE IF @TipoMembresia = 'Diamante'
			   SET @resultado = 'El Socio posee una membresia de Diamante. ';
			ELSE
			   SET @resultado = 'El Socio no esta registrado. '
		   RETURN @resultado;
		END

	 ELSE IF @TipoMiembro = 'Entrenador'
        BEGIN
		   IF @Especialidad = 'Zumba y Yoga'
				SET @resultado = 'El Entrenador se especiliza en ZUMBA y en YOGA. ';
			ELSE IF @Especialidad = 'Fisico general'
				SET @resultado = 'El Entrenador se especiliza en FISICO GENERAL. ';
			ELSE IF @Especialidad = 'Atletico'
				SET @resultado = 'El Entrenador se especiliza en ATLETICO. ';
			ELSE IF @Especialidad = 'Musculatura'
				SET @resultado = 'El Entrenador se especiliza en MUSCULATURA. ';
			ELSE
			   SET @resultado = 'El Entrenador no esta registrado. '
		   RETURN @resultado;
		END
	ELSE IF @TipoMiembro = 'Empleado'
        BEGIN
		   IF @TipoServicio = 'Limpieza'
				SET @resultado = 'El Empleado posee un servicio de LIMPIEZA. ';
			ELSE IF	@TipoServicio = 'Mantenimiento'
				SET @resultado = 'El Empleado posee un servicio de MANTENIMIENTO. ';
			ELSE IF @TipoServicio = 'Administracion'
			   SET @resultado = 'El Empleado posee un servicio de ADMINISTRACION. ';
			ELSE
			   SET @resultado = 'El Empleado no esta registrado. '
		END
	ELSE
        SET @Resultado = 'El miembro no está registrado en el gimnasio.';

    RETURN @Resultado;
END;
/* Activacion			SELECT dbo.ObtenerDetalleMiembro(#Socio); */


/** Funciones para Determinar la Inscripcion de un miembro SOCIO **/
CREATE OR ALTER FUNCTION dbo.ObtenerInscripcion
(@IdMiembro INT)
RETURNS TABLE
AS
RETURN(

	SELECT I.Id_Inscripcion, I.Id_Miembro, I.Id_Clase, I.Fecha_Inscripcion  FROM RegistrosAlmacenados.Inscripciones AS I 
	WHERE @IdMiembro = Id_Miembro
	AND dbo.ObtenerTipoMiembro(@IdMiembro) = 'Socio'
);
/* Activacion			SELECT * FROM dbo.ObtenerInscripcion(#Miembro); */





------Triggers
----Triggers para ejecutar BITACORAS de ALMACENAMIENTO
--BITACORA GIMNASIO
CREATE TRIGGER T_BITACORA_GIMNASIO
ON [ElementosGimnasio].[Gimnasio]
AFTER INSERT, UPDATE, DELETE
AS BEGIN 
	IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Gimnasio', 'INSERT', SYSTEM_USER, GETDATE() FROM inserted;
		END
	IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Gimnasio', 'DELETE', SYSTEM_USER, GETDATE() FROM deleted;
		END
	IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Gimnasio', 'UPDATE', SYSTEM_USER, GETDATE() FROM inserted;
		END
	END;
	

--BITACORA MIEMBROS
CREATE TRIGGER T_BITACORA_MIEMBROS
ON [MiembrosAlmacenados].[Miembros]
AFTER INSERT, UPDATE, DELETE
AS BEGIN 
	IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Miembros', 'INSERT', SYSTEM_USER, GETDATE() FROM inserted;
		END
	IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Miembros', 'DELETE', SYSTEM_USER, GETDATE() FROM deleted;
		END
	IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Miembros', 'UPDATE', SYSTEM_USER, GETDATE() FROM inserted;
		END
	END;


--BITACORA CATEGORIAMIEMBROS
CREATE TRIGGER T_BITACORA_CATEGORIAMIEMBROS
ON [MiembrosAlmacenados].[CategoriaMiembros]
AFTER INSERT, UPDATE, DELETE
AS BEGIN 
	IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Categoria Miembros', 'INSERT', SYSTEM_USER, GETDATE() FROM inserted;
		END
	IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Categoria Miembros', 'DELETE', SYSTEM_USER, GETDATE() FROM deleted;
		END
	IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Categoria Miembros', 'UPDATE', SYSTEM_USER, GETDATE() FROM inserted;
		END
	END;


--BITACORA CLASES
CREATE TRIGGER T_BITACORA_CLASES
ON [ElementosGimnasio].[Clases]
AFTER INSERT, UPDATE, DELETE
AS BEGIN 
	IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Clases', 'INSERT', SYSTEM_USER, GETDATE() FROM inserted;
		END
	IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Clases', 'DELETE', SYSTEM_USER, GETDATE() FROM deleted;
		END
	IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Clases', 'UPDATE', SYSTEM_USER, GETDATE() FROM inserted;
		END
	END;

	
--BITACORA INSCRIPCIONES
CREATE TRIGGER T_BITACORA_INSCRIPCIONES
ON [RegistrosAlmacenados].[Inscripciones]
AFTER INSERT, UPDATE, DELETE
AS BEGIN 
	IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Inscripciones', 'INSERT', SYSTEM_USER, GETDATE() FROM inserted;
		END
	IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Inscripciones', 'DELETE', SYSTEM_USER, GETDATE() FROM deleted;
		END
	IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Inscripciones', 'UPDATE', SYSTEM_USER, GETDATE() FROM inserted;
		END
	END;


--BITACORA UTILERIAS
CREATE TRIGGER T_BITACORA_UTILERIAS
ON [ElementosGimnasio].[Utilerias]
AFTER INSERT, UPDATE, DELETE
AS BEGIN 
	IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Utilerias', 'INSERT', SYSTEM_USER, GETDATE() FROM inserted;
		END
	IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Utilerias', 'DELETE', SYSTEM_USER, GETDATE() FROM deleted;
		END
	IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Utilerias', 'UPDATE', SYSTEM_USER, GETDATE() FROM inserted;
		END
	END;
	

--BITACORA MANTENIMIENTOS
CREATE TRIGGER T_BITACORA_MANTENIMIENTOS
ON [RegistrosAlmacenados].[Mantenimientos]
AFTER INSERT, UPDATE, DELETE
AS BEGIN 
	IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Mantenimientos', 'INSERT', SYSTEM_USER, GETDATE() FROM inserted;
		END
	IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Mantenimientos', 'DELETE', SYSTEM_USER, GETDATE() FROM deleted;
		END
	IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Mantenimientos', 'UPDATE', SYSTEM_USER, GETDATE() FROM inserted;
		END
	END;


--BITACORA PAGOS
CREATE TRIGGER T_BITACORA_PAGOS
ON [RegistrosAlmacenados].[Pagos]
AFTER INSERT, UPDATE, DELETE
AS BEGIN 
	IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Pagos', 'INSERT', SYSTEM_USER, GETDATE() FROM inserted;
		END
	IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Pagos', 'DELETE', SYSTEM_USER, GETDATE() FROM deleted;
		END
	IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
	BEGIN
		INSERT INTO [dbo].[AuditHistorial] (Tabla, Accion, Usuario, fecha)
		SELECT 'Pagos', 'UPDATE', SYSTEM_USER, GETDATE() FROM inserted;
		END
	END;