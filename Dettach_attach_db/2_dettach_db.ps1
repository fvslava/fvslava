#
#
[xml]$databases = Get-Content "C:\dadb.xml"
#
#
ForEach ($database in $databases.SQL.Databases) {
    $DBName = $database.dbname
    Add-PSSnapin SqlServerCmdletSnapin* -ErrorAction SilentlyContinue
If (!$?) {Import-Module SQLPS -WarningAction SilentlyContinue}
If (!$?) {"Error loading Microsoft SQL Server PowerShell module. Please check if it is installed."; Exit}
$attachSQLCMD = @"
USE [master]
GO
ALTER DATABASE [$DBName] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
EXEC master.dbo.sp_detach_db @dbname = N'$DBName'
GO
"@
    Invoke-Sqlcmd $attachSQLCMD -QueryTimeout 3600 -ServerInstance 'localhost'
}