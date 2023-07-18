IF OBJECT_ID(N'tempdb..#temp_dbsize') IS NOT NULL
DROP TABLE #temp_dbsize


DECLARE @RowsToProcess  int
DECLARE @CurrentRow     int
DECLARE @Size_tbl       int
DECLARE @Nametbl     varchar(128)
DECLARE @cmd		varchar(max)
DECLARE @tcount as int;

begin transaction
SET NOCOUNT ON
SELECT
t.name as Table_name
, avg(s.row_count) as Row_count
, SUM (CASE WHEN (i.index_id < 2) 
          THEN (in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count)
          ELSE lob_used_page_count + row_overflow_used_page_count
     END) * 8 / 1024 / 1024 as Table_size_gb
into #temp_dbsize
FROM sys.dm_db_partition_stats  AS s 
JOIN sys.tables AS t ON s.object_id = t.object_id
JOIN sys.indexes AS i ON i.[object_id] = t.[object_id] AND s.index_id = i.index_id
where t.name in ('_AccRg21207', '_AccRgED21240', '_AccRg24641', '_AccRgED24674', '_AccRg10410', '_AccRgChngR10433', '_AccRgED10432', '_AccRg10461', '_AccRgChngR10480', '_AccRgED10479', 
	'_AccRg10481', '_AccRgChngR10508', '_AccRgED10507', '_AccRg15997', '_AccRgChngR16031', '_AccRgED16030', '_AccRg24675', '_AccRgED24703', '_AccRg10434', '_AccRgChngR10460', 
	'_AccRgED10459') 
GROUP BY t.name
order by table_size_gb desc
SET @RowsToProcess=@@ROWCOUNT
commit

ALTER TABLE #temp_dbsize 
  ADD [RowID] INT NOT NULL
  IDENTITY(1, 1)
  PRIMARY KEY;

--select @RowsToProcess

SET @CurrentRow=0

--select * from #temp_dbsize

WHILE @CurrentRow<@RowsToProcess
BEGIN
    SET @CurrentRow=@CurrentRow+1
	    SELECT 
        @Nametbl=Table_name,
		@tcount=Row_count,
		@Size_tbl=Table_size_gb
        FROM #temp_dbsize
        WHERE RowID=@CurrentRow
--select @Nametbl, @tcount, @Size_tbl

set @cmd ='IF ((COL_LENGTH('''+@Nametbl+''',''_Period'') IS NOT NULL) AND ('+CONVERT(varchar(max), @tcount)+' > 0))
	Begin
		EXEC( ''SELECT YEAR(_Period) as '+@Nametbl+', 
		count(_Period) as count_rows, 
		(CAST(COUNT(_Period) as decimal(12,2))/'+CONVERT(varchar(max), @tcount)+')*'+CONVERT(varchar(max), @Size_tbl)+' as data_size_gb
		FROM '+@Nametbl+' group by YEAR(_Period) order by YEAR(_Period)'')
	END
ELSE
    PRINT ''Table '+@Nametbl+' without _Period has '+CONVERT(varchar(max), @tcount)+' rows and uses '+CONVERT(varchar(max), @Size_tbl)+' gb'';'

--print @cmd
exec (@cmd)
END



