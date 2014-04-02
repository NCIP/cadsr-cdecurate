#!/bin/sh
#Please run with user SBR
#Wiki https://wiki.nci.nih.gov/display/caDSRproj/Moving+the+Context+of+Content
#----------------------------------------------------------------------------------------------------------------------------------
#	DATABASE SETTINGS

export user=SBR
export pwd=replace_me
export SQLPLUS_PATH=sqlplus
export HOST=@"(description=(address_list=(address=(protocol=TCP)(host=ncidb-dsr-p.nci.nih.gov)(port=1551)))(connect_data=(SID=DSRPROD)))"

echo 'Creating context ...'
echo $SQLPLUS_PATH $user/$pwd$HOST @run_create_context.sql 'SDC Pilot Project' 'SDC Pilot Project'
$SQLPLUS_PATH $user/$pwd$HOST @run_create_context.sql 'SDC Pilot Project' 'SDC Pilot Project'
echo 'Done'
