#!/bin/sh
#************* DATABASE  SETTINS *************
export user=SBR
export pwd=
export SQLPLUS_PATH=~/Dropbox/nih/instantclient_10_2/sqlplus
#export SQLPLUS_PATH=sqlplus
export HOST=@"(description=(address_list=(address=(protocol=TCP)(host=137.187.181.4)(port=1551)))(connect_data=(SID=DSRDEV)))"
#export HOST=@"(description=(address_list=(address=(protocol=TCP)(host=ncidb-dsr-p.nci.nih.gov)(port=1551)))(connect_data=(SID=DSRPROD)))"
 
#************* APPLICATION SETTINS *************
#NONE

$SQLPLUS_PATH $user/$pwd$HOST @check_all_user_ac_context.sql 'NCIP' 'NCIP' '2001-01-01' '2013-08-07' '%%' > ./check_all_ac_counts_NCIP.txt 2>&1

$SQLPLUS_PATH $user/$pwd$HOST @check_all_user_ac_context.sql 'caBIG' 'caBIG' '2001-01-01' '2013-08-07' '%%' > ./check_all_ac_counts_caBIG.txt 2>&1
