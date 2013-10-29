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
export HOST=@"(description=(address_list=(address=(protocol=TCP)(host=137.187.181.4)(port=1551)))(connect_data=(SID=DSRDEV)))"

#************* APPLICATION SETTINS *************
#------------- Please change according to the request before executing the script -------------
export FROM_CONTEXT=CTEP
export TO_CONTEXT=Alliance
export FROM_DATE=2012-01-01
export TO_DATE=2013-10-24

#------------- One generally DO NOT need to change anything beyond this line -------------
export DATE_TIME=$(date)
export CHANGE_NOTE="'Changed from $FROM_CONTEXT to $TO_CONTEXT for $CREATOR by script $DATE_TIME'"
#echo $CHANGE_NOTE
#exit

export CREATOR=ZIEGLERK
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @change_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @check_user_ac_context.sql $FROM_CONTEXT $TO_CONTEXT $FROM_DATE $TO_DATE $CREATOR
