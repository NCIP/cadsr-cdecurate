/*
 * GF32649	Context name caBIG is being used instead of the context identifier
 * Notes related to issue https://gforge.nci.nih.gov/tracker/index.php?func=detail&aid=32649.
 */

*** APPLYING CHANGES ***

The scripts need to be executed in the correct order for them to work. They are showed as below -

Run with user SBREXT (note: there is no need to run the specs, just the bodies where applicable):

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

SQL> @gf32649_CADSR_XLS_LOADER_PKG_WORK3_BODY.sql

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

SQL> @gf32649_MAINTAIN_CONCEPTS_BODY.sql

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

SQL> @change_default_context.sql

1 row updated.


Commit complete.

SQL> 


*** UNDOING CHANGES ***

Please use the previous version in the SVN.