/*
 * Notes related to issue https://gforge.nci.nih.gov/tracker/index.php?func=detail&aid=11372.
 */

*** APPLYING CHANGES ***

Run with user SBREXT:

SQL> @customDownload.sql
insert into sbrext.tool_options_view_ext (tool_name, property, value)
*
ERROR at line 1:
ORA-00001: unique constraint (SBREXT.TOOL_OPTIONS_UNIQ) violated


insert into sbrext.tool_options_view_ext (tool_name, property, Value)
*
ERROR at line 1:
ORA-00001: unique constraint (SBREXT.TOOL_OPTIONS_UNIQ) violated



Table dropped.


Table created.


Grant succeeded.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


View created.


Grant succeeded.


Grant succeeded.


Grant succeeded.


View created.


Grant succeeded.


Grant succeeded.


Grant succeeded.


View created.


Grant succeeded.


Grant succeeded.


Grant succeeded.


Commit complete.

SQL> 


*** UNDOING CHANGES ***

Please use the previous version in the SVN.