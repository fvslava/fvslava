--select top (10) name, is_read_committed_snapshot_on, create_date from sys.databases where is_read_committed_snapshot_on<>1 and database_id>4 order by create_date desc

DECLARE @RowsToProcess  int
DECLARE @CurrentRow     int
DECLARE @Namedb     varchar(128)
DECLARE @cmd		varchar(256)

DECLARE @table1 TABLE (RowID int not null primary key identity(1,1), namedb varchar(128))  
INSERT into @table1 (namedb) select top(10) name from sys.databases where is_read_committed_snapshot_on<>1 and database_id>4 order by create_date desc
SET @RowsToProcess=@@ROWCOUNT

SET @CurrentRow=0
WHILE @CurrentRow<@RowsToProcess
BEGIN
    SET @CurrentRow=@CurrentRow+1
    SELECT 
        @Namedb=namedb
        FROM @table1
        WHERE RowID=@CurrentRow
set @cmd = 'ALTER DATABASE ' + @Namedb + ' SET READ_COMMITTED_SNAPSHOT ON;'
print @cmd
exec (@cmd)

END

