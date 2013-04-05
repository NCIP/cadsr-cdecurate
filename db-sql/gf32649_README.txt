/*
 * Notes related to issue https://gforge.nci.nih.gov/tracker/index.php?func=detail&aid=32649.
 */

*** APPLYING CHANGES ***

The scripts need to be executed in the correct order for them to work. They are showed as below -

Run with user SBREXT (note: there is no need to run the specs):

SQL> @gf32649_SBREXT_GET_ROW_BODY.sql

Package body created.

SQL> 

SQL> @gf32649_SBREXT_SET_ROW_BODY.sql

Package body created.


Grant succeeded.


Grant succeeded.


Grant succeeded.


Grant succeeded.


Grant succeeded.


Grant succeeded.


Grant succeeded.


Grant succeeded.


Grant succeeded.


Grant succeeded.

SQL> 


*** UNDOING CHANGES ***

Please use the previous version in the SVN.