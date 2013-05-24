#!/bin/sh
#Please run with user SBR
echo input parameters in the order specified:
echo "old_context to new_context from_date(format YYYY-MM-DD) end_date (format YYYY-MM-DD) curator_id"
export user=SBR
export pwd=jjsbr
export SQLPLUS_PATH=~/Dropbox/nih/instantclient_10_2
#export SQLPLUS_PATH=
export HOST=@"(description=(address_list=(address=(protocol=TCP)(host=137.187.181.4)(port=1551)))(connect_data=(SID=DSRDEV)))"

#$SQLPLUS_PATH/sqlplus $user/$pwd$HOST @change_user_ac_context.sql 'NCIP' 'NHLBI' '2013-04-01' '2013-04-30' xxx
#$SQLPLUS_PATH/sqlplus $user/$pwd$HOST @check_user_ac_context.sql 'NCIP' 'NHLBI' '2013-04-01' '2013-04-30' xxx

#$SQLPLUS_PATH/sqlplus $user/$pwd$HOST @change_user_ac_context.sql 'NIDA' 'NHLBI' '2013-05-01' '2013-05-22' xxx
#$SQLPLUS_PATH/sqlplus $user/$pwd$HOST @check_user_ac_context.sql 'NIDA' 'NHLBI' '2013-05-01' '2013-05-22' xxx
