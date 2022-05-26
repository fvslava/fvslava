#
# Load configuration XML file
#
[xml]$databases = Get-Content "C:\AttachDatabasesConfig.xml"

#
# Get SQL Server database (MDF/LDF)
#
ForEach ($database in $databases.SQL.Databases) {
    $mdfFilename = $database.MDF
    $ldfFilename = $database.LDF
	$newmdfFilename = $database.NEWMDF
    $newldfFilename = $database.NEWLDF
    $DBName = $database.DB_Name
    #
    # Detach SQL Server database
    #
    Add-PSSnapin SqlServerCmdletSnapin* -ErrorAction SilentlyContinue
    If (!$?) {Import-Module SQLPS -WarningAction SilentlyContinue}
    If (!$?) {"Error loading Microsoft SQL Server PowerShell module. Please check if it is installed."; Exit}
$attachSQLCMD = @"
USE [master]
GO
alter database $DBName set single_user with rollback immediate
GO
sp_detach_db $DBName
GO
"@
    Invoke-Sqlcmd $attachSQLCMD -QueryTimeout 3600 -ServerInstance 'localhost'
#
# Copy SQL Server database
#
Copy-Item $mdfFilename -Destination $newmdfFilename
Copy-Item $ldfFilename -Destination $newldfFilename
#
# Attach SQL Server database
#
$attachSQLCMD = @"
USE [master]
GO
CREATE DATABASE [$DBName] ON (FILENAME = '$newmdfFilename'),(FILENAME = '$newldfFilename') for ATTACH
GO
"@ 
    Invoke-Sqlcmd $attachSQLCMD -QueryTimeout 3600 -ServerInstance 'localhost'
}
