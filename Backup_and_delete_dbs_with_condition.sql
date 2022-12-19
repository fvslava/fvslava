DECLARE @RowsToProcess  int
DECLARE @CurrentRow     int
DECLARE @namedb     varchar(128)
DECLARE @pathbackup varchar(100)
DECLARE @tabledbfordel TABLE (RowID int not null primary key identity(1,1), namedb varchar(128));  

INSERT into @tabledbfordel (namedb) select top(5) name from sys.databases where state_desc='offline' order by name
SET @RowsToProcess=@@ROWCOUNT
SET @CurrentRow=0

WHILE @CurrentRow<@RowsToProcess
BEGIN
    SET @CurrentRow=@CurrentRow+1
	SET @pathbackup='Q:\Backup\';

    SELECT @namedb=namedb FROM @tabledbfordel WHERE RowID=@CurrentRow
	SET @pathbackup=@pathbackup+@namedb+'.bak';

	USE [master]
	EXEC('ALTER DATABASE ' + @namedb + ' SET ONLINE')
	backup database @namedb 
	to disk = @pathbackup
	with init,
	compression,
	copy_only,
	stats = 10;

	IF @@ERROR = 0
	BEGIN
		EXEC('DROP DATABASE ' + @namedb);
	END

END

select namedb from @tabledbfordel







