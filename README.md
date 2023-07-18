Dettach_attach_db - Скрипт для переноса баз между инстансами. Записывает всю информацию в xml, дэттачит и аттачит базы с помощью ps скриптов<br/>
Work_with_list_DB_in_temp_table - Работы с множеством бд через временную таблицу<br/>
Work_with_list_DB_in_xml_file - Работы с множеством бд через xml файл<br/>

Backup_and_delete_dbs_with_condition.sql - Бэкап, а затем удаление множества баз на инстансе по условию (в примере 5 баз в статусе оффлайн)<br/>
DB_are_not_simple_model_fix.sql - Проверка баз инстанса на режим восстановления. Если не Simple, то исправление и шринк лога<br/>
DB_turn_off_read_commit_tran_fix.sql - Тоже самое, но с параметром is_read_commit_transaction<br/>
Mail_configure.sql - Автонастройка почты на новом инстансе<br/>
Old_session.sql - Уведомление на почту о старых сессиях <br/>
Period_size.sql - Отчёт количества и размера строк по группировке _Period у выбранных таблиц<br/>
Send_html_mail_on_condition.sql - Отправка временной таблицы на почту<br/>