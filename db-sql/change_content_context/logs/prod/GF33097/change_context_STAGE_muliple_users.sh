#!/bin/sh
#Please run with user SBR
#************* DATABASE SETTINS *************
#------------- Please change according to your environment before executing the script -------------
echo input parameters in the order specified:
echo "old_context to new_context from_date(format YYYY-MM-DD) end_date (format YYYY-MM-DD) curator_id"
export user=SBR
export pwd=xxx
#export SQLPLUS_PATH=~/Dropbox/nih/instantclient_10_2/
export SQLPLUS_PATH=
#export HOST=@"(description=(address_list=(address=(protocol=TCP)(host=137.187.181.4)(port=1551)))(connect_data=(SID=DSRDEV)))"
#export HOST=@"(description=(address_list=(address=(protocol=TCP)(host=ncidb-dsr-p.nci.nih.gov)(port=1551)))(connect_data=(SID=DSRPROD)))"
export HOST=@"(description=(address_list=(address=(protocol=TCP)(host=ncidb-dsr-s.nci.nih.gov)(port=1551)))(connect_data=(SID=DSRSTG)))"

#************* APPLICATION SETTINS *************
#------------- Please change according to the request before executing the script -------------
export FROM_CONTEXT=CTEP
export TO_CONTEXT=COG

export DATE_TIME=$(date)
export CHANGE_NOTE="'Changed from $FROM_CONTEXT to $TO_CONTEXT for $CREATOR by script $DATE_TIME'"
#echo $CHANGE_NOTE
#exit

echo 'Purging old backup ...'
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @change_user_ac_context_cleanup.sql
echo 'Backup purged! About to execute the real stuff ...'

export FROM_DATE=2010-02-04
export TO_DATE=2012-03-16
export CREATOR=HARTLEYG
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export FROM_DATE=2010-03-19
export TO_DATE=2013-10-22
export CREATOR=WATSONB
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=GEORGIEB
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=MATTHEWK
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=SIDDIQIF
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=MARTINC
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=STEWARDN
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=BEELEST
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=HASENAUB
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=CORRALC
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=TSANE
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=SUBRAMAS
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=JONGS
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=WONGW
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=REEDK
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=DONOVANN
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
