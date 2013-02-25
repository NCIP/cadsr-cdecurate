/*
 * Notes related to issue https://gforge.nci.nih.gov/tracker/index.php?func=detail&aid=30681.
 */

*** APPLYING CHANGES ***

The scripts need to be executed in the correct order for them to work. They are showed as below -

Run with user SBREXT:

SQL> @gf32398_SBREXT_CDE_CURATOR_PKG_SPEC.sql

Package created.


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

SQL> @gf32398_SBREXT_CDE_CURATOR_PKG_BODY.sql

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

SQL>

*** UNDOING CHANGES ***

Please use the previous version in the SVN.
