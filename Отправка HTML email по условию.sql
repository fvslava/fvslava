DECLARE @html  nvarchar(MAX);
CREATE TABLE #new_event(
	[CreatedOn] [datetime] NULL,
	[Name] [nvarchar](100) NOT NULL)


insert into #new_event
SELECT TOP (1) 
	   [CreatedOn]
      ,[Name]
  FROM [YOU_DB].[dbo].[YOU_Table]
  order by CreatedOn desc;

--  select * from #new_event;

set @html = 
N'<table border = "1">' + 
N'<tr>
<th>CreatedOn</th>
<th>Name</th>

</tr>' +
cast
	(
		(
			select
				td = CreatedOn, '',
				td = Name, ''
			from #new_event
			for xml path('tr')
		) as nvarchar(max)
	) +
N'</table>'

	EXEC msdb.dbo.sp_send_dbmail
	    @profile_name = N'you-profile',
		@recipients = N'you-adress@gmail.com',
		@body = @html,
		@body_format = 'HTML',
		@subject = N'WorkflowBase New Event';

drop table #new_event;