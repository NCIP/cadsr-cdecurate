*** APPLYING CHANGES ***

=========> Run with user SBR:

SQL> @change_default_context_to_NCIP.sql

1 row updated.


Commit complete.

SQL> 

SQL> select name from sbr.contexts_view where conte_idseq=(select tv.value from sbrext.tool_options_view_ext tv , sbr.contexts_view  cv where tv.tool_name = 'caDSR' and tv.property = 'DEFAULT_CONTEXT' and tv.value = cv.conte_idseq);

NAME
------------------------------
NCI

SQL> 

=========> Run with user SBREXT:

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

=========> Run with user SBR:

SQL> @change_user_groups_sc_groups_to_NCIP.sql

Table created.


Table created.



  COUNT(*)
----------
       205


  COUNT(*)
----------
	 4



*************************************************************************************
*** DO NOT EXECUTE THIS !!! ***
*************************************************************************************
ONLY IF the update is successful (like after the user's test), execute the following:

SQL> @change_user_groups_sc_groups_to_NCIP_cleanup.sql

Table dropped.


Table dropped.

ERROR:
ORA-04043: object sbr.user_groups_backup does not exist


ERROR:
ORA-04043: object sbr.sc_groups_backup does not exist


SQL> 