#!/bin/sh
#Please run with user SBR
#************* DATABASE SETTINS *************
#------------- Please change according to your environment before executing the script -------------
echo input parameters in the order specified:
echo "old_context to new_context from_date(format YYYY-MM-DD) end_date (format YYYY-MM-DD) curator_id"
export user=SBR
export pwd=xxx
export SQLPLUS_PATH=~/Dropbox/nih/instantclient_10_2
#export SQLPLUS_PATH=
export HOST=@"(description=(address_list=(address=(protocol=TCP)(host=137.187.181.4)(port=1551)))(connect_data=(SID=DSRDEV)))"

#************* APPLICATION SETTINS *************
#------------- Please change according to the request before executing the script -------------
export DATE_TIME=$(date)
export FROM_CONTEXT=NHLBI
export TO_CONTEXT=NHLBI
export FROM_DATE=2013-05-22
export TO_DATE=2013-05-23
export CREATOR=yyy

#------------- One generally DO NOT need to change anything beyond this line -------------
export CHANGE_NOTE="'Changed from $FROM_CONTEXT to $TO_CONTEXT for $CREATOR by script $DATE_TIME'"
#echo $CHANGE_NOTE
#exit
#$SQLPLUS_PATH/sqlplus $user/$pwd$HOST @change_user_ac_context.sql 'NHLBI' 'NHLBI' '2013-05-22' '2013-05-23' xxx
#$SQLPLUS_PATH/sqlplus $user/$pwd$HOST @check_user_ac_context.sql 'NHLBI' 'NHLBI' '2013-05-22' '2013-05-23' xxx

$SQLPLUS_PATH/sqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR $CHANGE_NOTE
#$SQLPLUS_PATH/sqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR 'Test'
$SQLPLUS_PATH/sqlplus $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
