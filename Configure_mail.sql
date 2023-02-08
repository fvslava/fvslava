sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO

sp_configure 'Database Mail XPs', 1;
GO
RECONFIGURE
GO

DECLARE @sn  varchar(32);
DECLARE @sm  varchar(64);
DECLARE @mg  varchar(32);

--select @@servername
set @sn=@@servername
set @sm=@sn+'@your_domain.com' -- change this
set @mg='name.mail.gateway' -- change this

EXECUTE msdb.dbo.sysmail_add_profile_sp 
    @profile_name = @sn;  

EXECUTE msdb.dbo.sysmail_add_principalprofile_sp 
    @profile_name = @sn, 
    @principal_name = 'public', 
    @is_default = 1 ;

EXECUTE msdb.dbo.sysmail_add_account_sp 
    @account_name = @sn,
    @email_address = @sm, 
    @display_name = @sn, 
    @mailserver_name = @mg,
    @port = 25,
    @enable_ssl = 0;

EXECUTE msdb.dbo.sysmail_add_profileaccount_sp 
    @profile_name = @sn, 
    @account_name = @sn, 
    @sequence_number =1 ; 

EXEC msdb.dbo.sp_add_operator @name=N'DBA',
	@enabled=1,
	@pager_days=0,
	@email_address=N'Your_adress@mail.com' -- change this one time
GO