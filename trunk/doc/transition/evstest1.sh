#!/bin/bash

DATE=`date +%Y%m%d`
JAVA_HOME=/usr/jdk1.5.0_04
BASE_DIR=/local/content/cdecurate/bin/.

export JAVA_HOME BASE_DIR

ORACLE_HOME=/app/oracle/product/dbhome/9.2.0
PATH=$ORACLE_HOME/bin:$PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
TNS_ADMIN=$ORACLE_HOME/network/admin
JAVA_PARMS='-Xms512m -Xmx512m -XX:PermSize=64m'

export JAVA_PARMS ORACLE_HOME TNS_ADMIN PATH LD_LIBRARY_PATH

echo "Executing EVSTest1"
echo "Executing job as `id`"
echo "Executing on `date`"

$JAVA_HOME/bin/java -client $JAVA_PARMS -classpath $BASE_DIR/log4j-1.2.8.jar:$BASE_DIR/ojdbc14.jar:$BASE_DIR/servlet.jar:$BASE_DIR/commons-logging.jar:$BASE_DIR/spring.jar:$BASE_DIR/hibernate3.jar:$BASE_DIR/client.jar:$BASE_DIR/cdecurate.jar gov.nih.nci.cadsr.cdecurate.test.EVSTest1 log4j.xml EVSTest1.xml

