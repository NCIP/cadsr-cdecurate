*** APPLYING CHANGES ***

Run with user SBREXT:

SQL> @change_default_context.sql

1 row updated.


Commit complete.

SQL> 

SQL> select name from sbr.contexts_view where conte_idseq=(select tv.value from sbrext.tool_options_view_ext tv , sbr.contexts_view  cv where tv.tool_name = 'caDSR' and tv.property = 'DEFAULT_CONTEXT' and tv.value = cv.conte_idseq);

NAME
------------------------------
NCI

SQL> 