DECLARE @html  nvarchar(MAX);
DECLARE @srv nvarchar(50);
--drop table #old_tbl;

SELECT 
	c.session_id,
	s.host_name,
    s.program_name,
    s.login_name,
    c.connect_time,
	s.last_request_start_time,
	s.last_request_end_time,
	t.text
into #old_tbl
FROM sys.dm_exec_connections AS c
INNER JOIN sys.dm_exec_sessions AS s
ON c.session_id = s.session_id
left join sys.dm_exec_requests r
on c.session_id = r.session_id
outer apply sys.dm_exec_sql_text(r.sql_handle) t
       where DB_NAME(s.database_id)='your_db_name'
       and c.connect_time < DATEADD(hh, -24, GETDATE())
       and s.program_name='Your_APP'

set @srv = N'Старые сессии на ' + @@servername
set @html = 
N'На your_db_name обнаружены сессии, висящие больше 24 часов:</br>' +
N'<table border = "1">' + 
N'<tr>
<th>Session ID</th>
<th>Host Name</th>
<th>Program Name</th>
<th>Login Name</th>
<th>Connect Time</th>
<th>Last request start</th>
<th>Last request end</th>
<th>Text</th>
</tr>' +
cast
	(
		(
			select
				td = session_id, '',
				td = host_name, '',
				td = program_name, '',
				td = login_name, '',
				td = connect_time, '',
				td = last_request_start_time, '',
				td = last_request_end_time, '',
				td = text, ''
			from #old_tbl
			for xml path('tr')
		) as nvarchar(max)
	) +
N'</table>'
if exists
	(
		select *
		from #old_tbl
	)

--print @html
--/*

exec msdb.dbo.sp_send_dbmail
@profile_name = 'your-mail-server',
@recipients = 'your-mail@adress;',
@body = @html,
@subject = @srv,
@body_format = 'HTML';
--*/

/*
select *
from #old_tbl
*/