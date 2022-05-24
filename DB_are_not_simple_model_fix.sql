--select DB_NAME(m.database_id), m.name from sys.master_files as m, sys.databases as d where m.database_id=d.database_id and d.recovery_model_desc<>'simple' and m.type_desc='log' and m.database_id>4

DECLARE @RowsToProcess  int
DECLARE @CurrentRow     int
DECLARE @Namedb     varchar(128)
DECLARE @Namelog     varchar(128)
DECLARE @cmd		varchar(256)

DECLARE @table1 TABLE (RowID int not null primary key identity(1,1), namedb varchar(128), namelog varchar(128))  
INSERT into @table1 (namedb, namelog) select top(10) DB_NAME(m.database_id), m.name from sys.master_files as m, sys.databases as d where m.database_id=d.database_id and d.recovery_model_desc<>'simple' and m.type_desc='log' and m.database_id>4

SET @RowsToProcess=@@ROWCOUNT

SET @CurrentRow=0
WHILE @CurrentRow<@RowsToProcess
BEGIN
    SET @CurrentRow=@CurrentRow+1
    SELECT 
        @Namedb=namedb,
		@Namelog=namelog
        FROM @table1
        WHERE RowID=@CurrentRow
set @cmd = 'ALTER DATABASE [' + @Namedb + '] SET RECOVERY SIMPLE WITH NO_WAIT; USE [' + @Namedb + ']; DBCC SHRINKFILE (N''' + @Namelog + ''' , 1024);'
print @cmd
exec (@cmd)

END