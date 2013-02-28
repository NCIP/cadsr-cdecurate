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


SQL> @gf30681_update_existing_DEC_CDR_no_oc.sql
CREATE TABLE SBR.DATA_ELEMENT_CONCEPTS_BACKUP AS SELECT * FROM SBR.DATA_ELEMENT_CONCEPTS
                 *
ERROR at line 1:
ORA-00955: name is already used by an existing object



No data found for Lavage Instilled (2014581)

No data found for Adverse event to anesthesia (2014465)

No data found for Tobacco chew (2014487)

No data found for Eligibility Expected Answer (2014489)

No data found for Metastasis Location (2181933)

No data found for Event Location Type Name (2179308)

No data found for Adjacent 13-cis Retinoic Acid Reporting Anesthesia (2014840)

No data found for Gynecologic Location (2183721)

No data found for Adverse Event Location (2188121)

No data found for desmin DESIPRAMINE(1) (2201489)

PL/SQL procedure successfully completed.

SQL> 

SQL> @gf30681_update_existing_DEC_CDR_no_prop.sql
CREATE TABLE SBR.DATA_ELEMENT_CONCEPTS_BACKUP AS SELECT * FROM SBR.DATA_ELEMENT_CONCEPTS
                 *
ERROR at line 1:
ORA-00955: name is already used by an existing object



No data found for CELLMARK (2201460)

No data found for Horsepox (disorder) (2201493)

PL/SQL procedure successfully completed.

SQL> 

SQL> @gf30681_update_existing_DEC_CDR_no_oc.sql
CREATE TABLE SBR.DATA_ELEMENT_CONCEPTS_BACKUP AS SELECT * FROM SBR.DATA_ELEMENT_CONCEPTS
                 *
ERROR at line 1:
ORA-00955: name is already used by an existing object



PL/SQL procedure successfully completed.

SQL> 


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