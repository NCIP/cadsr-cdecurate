:Please run with user SBR
:************* DATABASE SETTINS *************
:------------- Please change according to your environment before executing the script -------------
echo input parameters in the order specified:
echo old_context to new_context from_date(format YYYY-MM-DD) end_date (format YYYY-MM-DD) curator_id
set user=SBR
set pwd=xxx
set SQLPLUS_PATH=C:\instantclient_11_2\
:set SQLPLUS_PATH=
set HOST=@"(description=(address_list=(address=(protocol=TCP)(host=137.187.181.4)(port=1551)))(connect_data=(SID=DSRDEV)))"

:************* APPLICATION SETTINS *************
:------------- Please change according to the request before executing the script -------------
set FROM_CONTEXT=NHLBI
set TO_CONTEXT=NHLBI
set FROM_DATE=2013-05-22
set TO_DATE=2013-05-23
set CREATOR=yyy

:------------- One generally DO NOT need to change anything beyond this line -------------
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @change_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%' 'Changed from [%FROM_CONTEXT%] to [%TO_CONTEXT%] for [%CREATOR%] by script [%DATE% %TIME%]'
%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @check_user_ac_context.sql '%FROM_CONTEXT%' '%TO_CONTEXT%' '%FROM_DATE%' '%TO_DATE%' '%CREATOR%'
