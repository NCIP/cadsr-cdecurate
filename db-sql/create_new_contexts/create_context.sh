#!/bin/sh
#Please run with user SBR
#----------------------------------------------------------------------------------------------------------------------------------
#	DATABASE SETTINGS

export user=SBR
export pwd=jjsbr
export SQLPLUS_PATH=~/Dropbox/nih/instantclient_10_2/
#export HOST=@"(description=(address_list=(address=(protocol=TCP)(host=137.187.181.4)(port=1551)))(connect_data=(SID=DSRDEV)))"


$SQLPLUS_PATHsqlplus $user/$pwd$HOST @run_create_context.sql 'NHC-NCI' 'Norton Cancer Institute'
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @run_create_context.sql 'PBTC' 'Pediatric Brain Tumor Consortium'
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @run_create_context.sql 'CITN' 'Cancer Immunotherapy Trials Network'
$SQLPLUS_PATHsqlplus $user/$pwd$HOST @run_create_context.sql 'OHSU Knight' 'Oregon Health & Science University Knight Cancer Institute'

