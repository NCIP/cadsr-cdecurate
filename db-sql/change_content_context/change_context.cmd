:Please run with user SBR
:************* DATABASE SETTINS *************
:------------- Please change according to your environment before executing the script -------------
echo input parameters in the order specified:
echo old_context to new_context from_date(format YYYY-MM-DD) end_date (format YYYY-MM-DD) curator_id
set user=SBR
set pwd=xxx
set SQLPLUS_PATH=C:\instantclient_12_1\
:set SQLPLUS_PATH=
set HOST=@"(description=(address_list=(address=(protocol=TCP)(host=137.187.181.4)(port=1551)))(connect_data=(SID=DSRDEV)))"

:************* APPLICATION SETTINS *************
:------------- Please change according to the request before executing the script -------------
set FROM_CONTEXT=CTEP
set TO_CONTEXT=COG

set CHANGE_NOTE='Changed from %FROM_CONTEXT% to %TO_CONTEXT% for %CREATOR% by script %DATE% %TIME%'
#echo %CHANGE_NOTE%
#exit

set FROM_DATE=2010-02-04
set TO_DATE=2012-03-16
set CREATOR=HARTLEYG
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_all_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%' '%CHANGE_NOTE%'
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%'
pause
set FROM_DATE=2010-03-19
set TO_DATE=2013-10-22
set CREATOR=WATSONB
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_all_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%' '%CHANGE_NOTE%'
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%'
pause
set CREATOR=GEORGIEB
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_all_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%' '%CHANGE_NOTE%'
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%'
pause
set CREATOR=MATTHEWK
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_all_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%' '%CHANGE_NOTE%'
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%'
pause
set CREATOR=SIDDIQIF
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_all_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%' '%CHANGE_NOTE%'
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%'
pause
set CREATOR=MARTINC
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_all_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%' '%CHANGE_NOTE%'
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%'
pause
set CREATOR=STEWARDN
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_all_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%' '%CHANGE_NOTE%'
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%'
pause
set CREATOR=BEELEST
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_all_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%' '%CHANGE_NOTE%'
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%'
pause
set CREATOR=HASENAUB
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_all_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%' '%CHANGE_NOTE%'
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%'
pause
set CREATOR=CORRALC
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_all_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%' '%CHANGE_NOTE%'
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%'
pause
set CREATOR=TSANE
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_all_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%' '%CHANGE_NOTE%'
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%'
pause
set CREATOR=SUBRAMAS
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_all_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%' '%CHANGE_NOTE%'
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%'
pause
set CREATOR=JONGS
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_all_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%' '%CHANGE_NOTE%'
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%'
pause
set CREATOR=WONGW
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_all_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%' '%CHANGE_NOTE%'
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%'
pause
set CREATOR=REEDK
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_all_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%' '%CHANGE_NOTE%'
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%'
pause
set CREATOR=DONOVANN
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_all_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%' '%CHANGE_NOTE%'
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%'
pause
