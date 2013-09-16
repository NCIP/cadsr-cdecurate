#!/bin/sh
#************* DATABASE  SETTINS *************
export user=SBR
export pwd=jjuser
export SQLPLUS_PATH=~/Dropbox/nih/instantclient_10_2/sqlplus
#export SQLPLUS_PATH=sqlplus
export HOST=@"(description=(address_list=(address=(protocol=TCP)(host=137.187.181.4)(port=1551)))(connect_data=(SID=DSRDEV)))"
#export HOST=@"(description=(address_list=(address=(protocol=TCP)(host=ncidb-dsr-p.nci.nih.gov)(port=1551)))(connect_data=(SID=DSRPROD)))"
 
#************* APPLICATION SETTINS *************
#NONE
 
$SQLPLUS_PATH $user/$pwd$HOST @check_user_ac_context.sql 'CTEP' 'SWOG' '2001-12-01' '2013-06-19' 'KEARNSD' > /tmp/check_ac_counts.txt 2>&1
 
$SQLPLUS_PATH $user/$pwd$HOST @check_user_ac_context.sql 'CTEP' 'SWOG' '2001-12-01' '2013-06-19' 'SMITHA' >> /tmp/check_ac_counts.txt 2>&1
 
$SQLPLUS_PATH $user/$pwd$HOST @check_user_ac_context.sql 'CTEP' 'SWOG' '2001-12-01' '2013-06-19' 'SCOTTM' >> /tmp/check_ac_counts.txt 2>&1
