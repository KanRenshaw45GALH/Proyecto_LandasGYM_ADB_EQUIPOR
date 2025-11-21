+/** Base de Datos LandasGYM **/
/*Esquema de Gimnasio con las relaciones necesarias*/
------GYM$
		----MIEMBROS `$
					--Categoria-`
		----CLASES @`
					--Inscripciones &@`
		----UTILERIAS ~@#
					--Mantenimientos #~`
		----PAGOS $`

USE master;
CREATE DATABASE LandasGYM;
USE LandasGYM;


---Logins, Usuarios y Roles de la base de datos.
/*
Existen dos Loggins y user dentro de la base de datos de GimnasioLandas
			para el trabajo de Estudiantes: (L_ESTUDIANTE), (U_ESTUDIANTE)
			para las vistas de Profesor: (L_PROFESOR), (U_PROFESOR).

Haciendo uso de los roles predeterminados:
		db_owner para los Estudiantes
		db_datareader para el Profesor
*/
			CREATE LOGIN L_ESTUDIANTE WITH PASSWORD = 'Estudiantes1',
			CHECK_POLICY = ON,
			CHECK_EXPIRATION = ON;

			CREATE USER U_ESTUDIANTE FOR LOGIN L_ESTUDIANTE;
			ALTER ROLE db_owner ADD MEMBER U_ESTUDIANTE;

			CREATE LOGIN L_PROFESOR WITH PASSWORD = 'Profesor1',
			CHECK_POLICY = ON,
			CHECK_EXPIRATION = ON;

			CREATE USER U_PROFESOR FOR LOGIN L_PROFESOR;
			ALTER ROLE db_datareader ADD MEMBER U_PROFESOR;


---Tablas y Esquemas Prototipo

/* Tablas para la base de datos. */
/***  Tabla de almacenamiento de Gimnasio  ***/
CREATE TABLE Gimnasio(
	Id_Gimnasio INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR(20),
	Direccion VARCHAR(100),
	Telefono VARCHAR(12),
	Email VARCHAR(50)
);

/***  Tabla de almacenamiento de informacion personal de Miembros 
    y sus Subcategorias: Socios, Entrenadores, Empleados         ***/
CREATE TABLE Miembros(
	Id_Miembro INT PRIMARY KEY IDENTITY,
	Id_Gimnasio INT FOREIGN KEY (Id_Gimnasio) REFERENCES Gimnasio(Id_Gimnasio),
	Tipo_Miembro VARCHAR(15) CHECK(Tipo_Miembro IN ('Socio', 'Entrenador', 'Empleado')),
	Codigo_Miembro AS (
        CASE 
            WHEN Tipo_Miembro = 'Socio' THEN 'S'  + RIGHT('000' + CAST(Id_Miembro AS VARCHAR(9)), 6)
            WHEN Tipo_Miembro = 'Entrenador' THEN 'EN' + RIGHT('000' + CAST(Id_Miembro AS VARCHAR(9)), 6)
			WHEN Tipo_Miembro = 'Empleado' THEN 'EM' + RIGHT('000' + CAST(Id_Miembro AS VARCHAR(9)), 6)
        END
					   ) PERSISTED,
	Nombre VARCHAR(50),
	Apellido VARCHAR(50),
	Fecha_nacimiento DATE NOT NULL,
	Telefono VARCHAR(12),
	Email VARCHAR(50)
);
--------
		CREATE TABLE CategoriaMiembros (
			Id_Miembro INT PRIMARY KEY FOREIGN KEY REFERENCES Miembros(Id_Miembro),
			Tipo_Membresia VARCHAR(20) CHECK(Tipo_Membresia IN('Plata', 'Oro', 'Diamante')) NULL,
			Especialidad VARCHAR(20) CHECK(Especialidad IN('Zumba y Yoga', 'Fisico general', 'Atletico', 'Musculatura')) NULL,
			Tipo_Servicio VARCHAR(15) CHECK(Tipo_Servicio IN ('Limpieza', 'Mantenimiento', 'Administracion')) NULL,
			Fecha_Inicio DATE NOT NULL,
			Fecha_Fin DATE NOT NULL
		);
		
/***  Tabla de almacenamiento de informacion importante de las clases con sus inscripciones, utilerias y mantenimientos  ***/
CREATE TABLE Clases(
	Id_Clase INT PRIMARY KEY IDENTITY,
	Id_Miembro INT FOREIGN KEY (Id_Miembro) REFERENCES Miembros(Id_Miembro),
	Id_Gimnasio INT FOREIGN KEY (Id_Gimnasio) REFERENCES Gimnasio(Id_Gimnasio),
	Nombre VARCHAR(100),
	Cupo_Max INT NOT NULL,
	Dias VARCHAR(50),
	HoraInicio TIME,
	HoraFin TIME
);
--------
		CREATE TABLE Inscripciones(
			Id_Inscripcion INT PRIMARY KEY IDENTITY,
			Id_Miembro INT FOREIGN KEY (Id_miembro) REFERENCES Miembros(Id_miembro),
			Id_Clase INT FOREIGN KEY (Id_Clase) REFERENCES Clases(Id_Clase),
			Fecha_Inscripcion DATE
		);
--------
		CREATE TABLE Utilerias(
			Id_Utileria INT PRIMARY KEY IDENTITY,
			Id_Clase INT FOREIGN KEY (Id_Clase) REFERENCES Clases(Id_Clase),
			Tipo_utileria VARCHAR(100),
			Descripcion VARCHAR(300),
			Ultimo_mantenimiento DATETIME DEFAULT GETDATE()	
		);
		--------
				CREATE TABLE Mantenimientos(
					Id_Mantenimiento INT PRIMARY KEY IDENTITY,
					Id_Utileria INT FOREIGN KEY (Id_Utileria) REFERENCES Utilerias(Id_Utileria),
					Id_Miembro INT FOREIGN KEY (Id_miembro) REFERENCES Miembros(Id_miembro),
					Tipo_mantenimiento VARCHAR(15) CHECK(Tipo_mantenimiento IN ('Basico', 'Completo')),
					Resumen_mantenimiento VARCHAR(1000),
					Proximo_Mantenimiento DATE
				);
				
/***  Creacion de secuencia para numero de Factura para a tabla Pagos y la tabla de registro de pagos  ***/
CREATE SEQUENCE S_Factura 
AS INT START WITH 1 INCREMENT BY 1
NO CYCLE CACHE 50;

CREATE TABLE Pagos(
	Id_Pago INT PRIMARY KEY IDENTITY,
	Id_Miembro INT FOREIGN KEY (Id_miembro) REFERENCES Miembros(Id_miembro),
	Factura_codigo INT CONSTRAINT DF_Factura DEFAULT(NEXT VALUE FOR S_Factura),
	Monto DECIMAL(10,2) NOT NULL,
	Descripcion_pago VARCHAR(100),
	Metodo_pago VARCHAR(20) CHECK(Metodo_pago IN('En linea', 'Efectivo')),
	Fecha_pago DATE
);
--------
		CREATE TABLE Pagos_Archivo (
			Id_Pago_Archivo INT IDENTITY(1,1) PRIMARY KEY,
			Id_Pago_Original INT NOT NULL,
			Id_Miembro INT NULL,
			Fecha_Pago DATE NOT NULL,
			Monto DECIMAL(10,2) NOT NULL,
			Metodo_Pago VARCHAR(50) NOT NULL,

			Fecha_Archivado DATETIME NOT NULL DEFAULT GETDATE(),
			Motivo_Archivado VARCHAR(200) NOT NULL
		);





/*** Esquemas para la base de datos. ***/
--Elementos del Gimnasio.
	CREATE SCHEMA ElementosGimnasio AUTHORIZATION U_ESTUDIANTE;

		ALTER SCHEMA ElementosGimnasio TRANSFER dbo.Gimnasio;
		ALTER SCHEMA ElementosGimnasio TRANSFER dbo.Clases;
		ALTER SCHEMA ElementosGimnasio TRANSFER dbo.Utilerias;

--Para miembros.
	CREATE SCHEMA MiembrosAlmacenados AUTHORIZATION U_ESTUDIANTE;

		ALTER SCHEMA MiembrosAlmacenados TRANSFER dbo.Miembros;
		ALTER SCHEMA MiembrosAlmacenados TRANSFER dbo.CategoriaMiembros;

--Para pagos, inscripciones, mantenimientos.
	CREATE SCHEMA RegistrosAlmacenados AUTHORIZATION U_ESTUDIANTE;

		ALTER SCHEMA RegistrosAlmacenados TRANSFER dbo.Pagos;
		ALTER SCHEMA RegistrosAlmacenados TRANSFER dbo.Pagos_Archivo;
		ALTER SCHEMA RegistrosAlmacenados TRANSFER dbo.Inscripciones;
		ALTER SCHEMA RegistrosAlmacenados TRANSFER dbo.Mantenimientos;



