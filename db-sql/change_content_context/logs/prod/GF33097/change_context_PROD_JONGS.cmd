:Please run with user SBR
:************* DATABASE SETTINS *************
:------------- Please change according to your environment before executing the script -------------
echo input parameters in the order specified:
echo old_context to new_context from_date(format YYYY-MM-DD) end_date (format YYYY-MM-DD) curator_id
set user=SBR
set pwd=xxx
set SQLPLUS_PATH=C:\instantclient_12_1\sqlplus
:set SQLPLUS_PATH=sqlplus
set HOST=@"(description=(address_list=(address=(protocol=TCP)(host=137.187.181.4)(port=1551)))(connect_data=(SID=DSRDEV)))"

:************* APPLICATION SETTINS *************
:------------- Please change according to the request before executing the script -------------
set FROM_CONTEXT=CTEP
set TO_CONTEXT=COG

:set CHANGE_NOTE='Changed from %FROM_CONTEXT% to %TO_CONTEXT% for %CREATOR% by script %DATE% %TIME%'
:echo %CHANGE_NOTE%
:exit

echo 'Purging old backup ...'
%SQLPLUS_PATH% %user%/%pwd%%HOST% @change_user_ac_context_cleanup.sql
echo 'Backup purged! About to execute the real stuff ...'
pause

:set FROM_DATE=2010-02-04
:set TO_DATE=2012-03-16
set FROM_DATE=2010-03-19
set TO_DATE=2013-10-22
set CREATOR=JONGS
set CHANGE_NOTE='Changed from %FROM_CONTEXT% to %TO_CONTEXT% for %CREATOR% by script %DATE% %TIME%'
:%SQLPLUS_PATH% %user%/%pwd%%HOST% @change_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%' '%CHANGE_NOTE%'
%SQLPLUS_PATH% %user%/%pwd%%HOST% @check_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%'

pause