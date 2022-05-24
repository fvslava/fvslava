USE [master]

declare @tmp_tbl table

(

       name nvarchar(128),

       status nvarchar(128)

);

declare @fn int, @st int, @dbname nvarchar(128), @dbbackup nvarchar(256), @dbstatus nvarchar(256), @dbpath nvarchar(256);

 

insert into @tmp_tbl

select name, state_desc from sys.databases

where state_desc = 'offline';

 

set @fn = @@ROWCOUNT;

set @st =0;

 

while (@st<@fn)

begin

       set @dbname = (select name from @tmp_tbl order by name offset @st row fetch next 1 rows only)

       set @dbstatus = 'alter database ' + @dbname + ' set online';

       exec (@dbstatus)

       set @dbstatus = 'alter database ' + @dbname + ' set single_user with rollback immediate';

       exec (@dbstatus)

       set @dbpath = 'E:\Archive\'+@dbname+'.bak'

       select @dbpath;

       backup database @dbname to disk = @dbpath with init, compression, copy_only;

--     set @dbstatus = 'alter database ' + @dbname + ' set offline';

--     exec (@dbstatus)

       set @dbstatus = 'drop database ' + @dbname;

       exec (@dbstatus)

       set @st=@st+1;

end;