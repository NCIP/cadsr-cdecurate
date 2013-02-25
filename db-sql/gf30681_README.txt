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

SQL> @gf30681_update_SBREXT_Set_Row_SET_DEC_SPEC.sql

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


SQL> @gf30681_update_SBREXT_Set_Row_SET_DEC_BODY.sql

Package body created.


*** UNDOING CHANGES ***

Please use the previous version in the SVN.