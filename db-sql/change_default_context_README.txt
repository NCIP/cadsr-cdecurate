*** APPLYING CHANGES ***

Run with user SBR:

SQL> @change_default_context.sql

1 row updated.

SQL> 

SQL> select name from sbr.contexts_view where conte_idseq=(select tv.value from sbrext.tool_options_view_ext tv , sbr.contexts_view  cv where tv.tool_name = 'caDSR' and tv.property = 'DEFAULT_CONTEXT' and tv.value = cv.conte_idseq);

NAME
------------------------------
NCI

SQL> 