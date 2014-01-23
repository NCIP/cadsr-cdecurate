#!/bin/sh
#Please run with user SBR
#************* DATABASE SETTINS *************
#------------- Please change according to your environment before executing the script -------------
echo input parameters in the order specified:
echo "old_context to new_context from_date(format YYYY-MM-DD) end_date (format YYYY-MM-DD) curator_id"
export user=SBR
export pwd=xxx
#export SQLPLUS_PATH=~/Dropbox/nih/instantclient_10_2/sqlplus
export SQLPLUS_PATH=sqlplus
#export HOST=@"(description=(address_list=(address=(protocol=TCP)(host=137.187.181.4)(port=1551)))(connect_data=(SID=DSRDEV)))"
export HOST=@"(description=(address_list=(address=(protocol=TCP)(host=ncidb-dsr-s.nci.nih.gov)(port=1551)))(connect_data=(SID=DSRSTG)))"

#************* APPLICATION SETTINS *************
#------------- Please change according to the request before executing the script -------------
export FROM_CONTEXT=CTEP
export TO_CONTEXT=NRG

export DATE_TIME=$(date)
export CHANGE_NOTE="'Changed from $FROM_CONTEXT to $TO_CONTEXT for $CREATOR by script $DATE_TIME'"
#echo $CHANGE_NOTE
#exit

echo 'Purging old backup ...'
$SQLPLUS_PATH $user/$pwd$HOST @change_user_ac_context_cleanup.sql
echo 'Backup purged! About to execute the real stuff ...'

export FROM_DATE=2011-11-10
export TO_DATE=2014-01-17
export CREATOR=KRYSTKIA
$SQLPLUS_PATH $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATH $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=GRANTD
$SQLPLUS_PATH $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATH $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=WELSHE
$SQLPLUS_PATH $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATH $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=SERIANNJ
$SQLPLUS_PATH $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATH $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=THOMASJ
$SQLPLUS_PATH $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATH $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=REBOYJ
$SQLPLUS_PATH $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATH $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=RUETERJ
$SQLPLUS_PATH $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATH $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=OBROPTAJ
$SQLPLUS_PATH $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATH $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=JAINK
$SQLPLUS_PATH $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATH $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=LEVENTHM
$SQLPLUS_PATH $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATH $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=BONANNIR
$SQLPLUS_PATH $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATH $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=GEINOZS
$SQLPLUS_PATH $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATH $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=BRETTS
$SQLPLUS_PATH $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATH $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=PATELV
$SQLPLUS_PATH $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATH $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
export CREATOR=BERGANTW
$SQLPLUS_PATH $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
$SQLPLUS_PATH $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
