#!/bin/sh
#Please run with user SBR
#----------------------------------------------------------------------------------------------------------------------------------
#	DATABASE SETTINGS

export user=SBR
export pwd=
#export SQLPLUS_PATH=~/Dropbox/nih/instantclient_10_2/
export SQLPLUS_PATH=sqlplus
#export HOST=@"(description=(address_list=(address=(protocol=TCP)(host=137.187.181.4)(port=1551)))(connect_data=(SID=DSRDEV)))"
export HOST=@"(description=(address_list=(address=(protocol=TCP)(host=ncidb-dsr-q.nci.nih.gov)(port=1551)))(connect_data=(SID=DSRQA)))"
#export HOST=@"(description=(address_list=(address=(protocol=TCP)(host=ncidb-dsr-p.nci.nih.gov)(port=1551)))(connect_data=(SID=DSRPROD)))"

$SQLPLUS_PATH $user/$pwd$HOST @run_create_context_NCIP.sql 'NCIP' 'NCI cancer Biomedical Informatics'

