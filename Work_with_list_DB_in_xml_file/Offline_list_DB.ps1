#

#

[xml]$databases = Get-Content "C:\List_DB.xml"

#

#

ForEach ($database in $databases.SQL.Databases) {

    $DBName = $database.DB_Name

    Add-PSSnapin SqlServerCmdletSnapin* -ErrorAction SilentlyContinue

If (!$?) {Import-Module SQLPS -WarningAction SilentlyContinue}

If (!$?) {"Error loading Microsoft SQL Server PowerShell module. Please check if it is installed."; Exit}

$attachSQLCMD = @"

USE [master]

GO

ALTER DATABASE [$DBName] SET  OFFLINE

GO

"@

    Invoke-Sqlcmd $attachSQLCMD -QueryTimeout 3600 -ServerInstance 'localhost'

 

}