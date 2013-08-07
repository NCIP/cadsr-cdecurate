:************* DATABASE  SETTINS *************
set user=SBREXT
set pwd=
set SQLPLUS_PATH=C:\instantclient_11_2\sqlplus
:set SQLPLUS_PATH=sqlplus
set HOST=@"(description=(address_list=(address=(protocol=TCP)(host=137.187.181.4)(port=1551)))(connect_data=(SID=DSRDEV)))"
:set HOST=@"(description=(address_list=(address=(protocol=TCP)(host=ncidb-dsr-p.nci.nih.gov)(port=1551)))(connect_data=(SID=DSRPROD)))"
 
:************* APPLICATION SETTINS *************
:NONE
 
%SQLPLUS_PATH% %user%/%pwd%%HOST% @check_user_ac_context.sql 'NCIP' 'NCIP' '2001-01-01' '2013-08-07' '%%' > check_ac_counts.txt
