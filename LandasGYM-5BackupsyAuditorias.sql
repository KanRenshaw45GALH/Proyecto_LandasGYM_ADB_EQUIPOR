/** Backups y Auditorias de GimnasioPrueba **/
USE LandasGYM;


------Backups FULL, DIFF, LOG
--FULL Steps
BACKUP DATABASE LandasGYM
TO DISK = 'C:\BackupLandasGYM\Gimnasio_full.bak'
WITH INIT,
NAME = 'Full Backup LandasGYM',
DESCRIPTION = 'Copia completa de seguridad de la base de datos LandasGYM';

--DIFF Steps
BACKUP DATABASE LandasGYM
TO DISK = 'C:\BackupLandasGYM\Gimnasio_diff.bak'
WITH DIFFERENTIAL,
NAME = 'Backup Diferencial LandasGYM';

--LOG Steps
BACKUP LOG LandasGYM
TO DISK = 'C:\BackupLandasGYM\Gimnasio_log.trn'
WITH INIT,
NAME = 'Backup Log LandasGYM';

USE master;


------Auditorias
--Vista general de Cambios, Ingresos y Eliminaciones Registradas
CREATE TABLE AuditHistorial
(
Tabla varchar(50),
Accion Varchar(50),
Usuario Varchar(50),
fecha datetime
);
/* Activacion SELECT * FROM AuditHistorial; */



