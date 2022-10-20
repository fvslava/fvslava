#
#
[xml]$databases = Get-Content "C:\dadb.xml"
#
#
ForEach ($database in $databases.SQL.Databases) {
    $DBName = $database.dbname
                $DBfile = $database.data_file
                $DBlog = $database.log_file
    Add-PSSnapin SqlServerCmdletSnapin* -ErrorAction SilentlyContinue
If (!$?) {Import-Module SQLPS -WarningAction SilentlyContinue}
If (!$?) {"Error loading Microsoft SQL Server PowerShell module. Please check if it is installed."; Exit}
$attachSQLCMD = @"
USE [master]
GO
CREATE DATABASE [$DBName] ON
( FILENAME = N'$DBfile' ),
( FILENAME = N'$DBlog' )
FOR ATTACH
GO
"@
    Invoke-Sqlcmd $attachSQLCMD -QueryTimeout 3600 -ServerInstance 'localhost'
}