--Run with SBREXT user
update sbr.contexts_view  set name='NCI' where conte_idseq=(select tv.value from sbrext.tool_options_view_ext tv , sbr.contexts_view  cv where tv.tool_name = 'caDSR' and tv.property = 'DEFAULT_CONTEXT' and tv.value = cv.conte_idseq)
/
commit
/