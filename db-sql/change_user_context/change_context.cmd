:Please run with user SBR
echo input parameters in the order specified:
echo old_context to new_context from_date(format YYYY-MM-DD) end_date (format YYYY-MM-DD) curator_id
set user=SBR
set pwd=jjsbr
set SQLPLUS_PATH=C:\instantclient_11_2\
:set SQLPLUS_PATH=
set HOST=@"(description=(address_list=(address=(protocol=TCP)(host=137.187.181.4)(port=1551)))(connect_data=(SID=DSRDEV)))"

%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @change_user_ac_context.sql 'NIDA' 'NHLBI' '2013-03-01' '2013-03-22' 'dwarzel'
:%SQLPLUS_PATH%sqlplus %user%/%pwd%%HOST% @change_user_ac_context.sql 'NIDA' 'NHLBI' '2013-05-22' '2013-05-22' 'dwarzel'
