-- =========================================================
-- Fromza EMR - Full database restore script
-- Restores the bundled production/development backup and re-applies
-- the base admin DB seed script required by the app.
-- =========================================================
-- This script is intended to be run in SQL Server Management Studio
-- or via sqlcmd against a local SQL Server instance.
--
-- Prerequisites:
--   1. SQL Server (Express / Developer / Standard) is installed
--   2. The backup file exists at:
--      Database/2. EMR-Db/FromzaInternationalDB/Dev_DanpheEMR_INT1.bak
--   3. The admin seed script exists at:
--      Database/1. Admin-Db/1. FromzaAdmin_CompleteDB.sql
-- =========================================================

USE [master];
GO

-- Restore the EMR database from the supplied backup.
-- Replace the backup path and data/log file paths below to match the
-- local SQL Server instance on the target machine.
RESTORE DATABASE [DEV_FromzaEMR_INT]
FROM DISK = N'<PATH_TO_BACKUP>\Dev_DanpheEMR_INT1.bak'
WITH
    MOVE N'DanpheEMR_Data' TO N'<SQL_DATA_PATH>\DEV_FromzaEMR_INT.mdf',
    MOVE N'DanpheEMR_Log'  TO N'<SQL_DATA_PATH>\DEV_FromzaEMR_INT.ldf',
    REPLACE,
    STATS = 10;
GO

-- Reset the default admin password to the project default value.
USE [DEV_FromzaEMR_INT];
GO
UPDATE RBAC_User
SET Password = 'b/ECdMP/loE='
WHERE UserName = 'admin' OR UserName = 'Admin';
GO

-- Optional verification
SELECT UserName, Password
FROM RBAC_User
WHERE UserName IN ('admin', 'Admin');
GO

-- =========================================================
-- Admin database setup
-- =========================================================
USE [master];
GO

-- If the admin database does not exist yet, create it by running the
-- bundled script. This script contains the schema + seed data for the
-- FromzaAdmin database used by the application.
-- Run the same file from the repo relative path on the target machine.
:r 'Database\1. Admin-Db\1. FromzaAdmin_CompleteDB.sql'
GO

PRINT 'DEV_FromzaEMR_INT and FromzaAdmin are ready for the app.';
GO
