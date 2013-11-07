#!/bin/sh
#Please run with user SBR
#Wiki https://wiki.nci.nih.gov/display/caDSRproj/Moving+the+Context+of+Content
#----------------------------------------------------------------------------------------------------------------------------------
#	DATABASE SETTINGS

export user=SBR
export pwd=
export SQLPLUS_PATH=sqlplus
export HOST=@"(description=(address_list=(address=(protocol=TCP)(host=ncidb-dsr-p.nci.nih.gov)(port=1551)))(connect_data=(SID=DSRPROD)))"

echo $SQLPLUS_PATH $user/$pwd$HOST @run_create_context.sql 'COG' "Children's Oncology Group"
$SQLPLUS_PATH $user/$pwd$HOST @run_create_context.sql 'COG' "Children's Oncology Group"
