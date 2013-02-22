/*
 * Notes related to issue https://gforge.nci.nih.gov/tracker/index.php?func=detail&aid=32398.
 */

*** APPLYING CHANGES ***

The scripts need to be executed in the correct order for them to work. They are showed as below -

Run with user SBR:

SQL>@gf30681_alter_grant_dec_table.sql

grant succeeded.

grant succeeded.

table SBR.DATA_ELEMENT_CONCEPTS altered.


SQL> @gf30681_update_SBR_INS_UPD_SPEC.sql

Package created.

SQL> @gf30681_update_SBR_INS_UPD_BODY.sql

Package body created.

Run with user SBREXT:

SQL> @gf30681_update_SBREXT_Set_Row_SET_DEC.sql

Package created.


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

*** UNDOING CHANGES ***

Most scripts that belong to this tickets have a corresponding *-rollback.sql, try to run that first if found. Otherwise, if
SVN is available, please get the previous version of the script.

Last resort, please request the DBA to refresh (say SBR package specs and bodies) the database back to Feb 13, 2013 (last known good copy).
