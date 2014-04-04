-- Run with SBREXT

update sbr.contexts_view  set name='NCIP' where conte_idseq=(select tv.value from sbrext.tool_options_view_ext tv , sbr.contexts_view  cv where tv.tool_name = 'caDSR' and tv.property = 'DEFAULT_CONTEXT' and tv.value = cv.conte_idseq)
/
update sbr.contexts  set name='NCIP' where conte_idseq=(select tv.value from sbrext.tool_options_view_ext tv , sbr.contexts_view  cv where tv.tool_name = 'caDSR' and tv.property = 'DEFAULT_CONTEXT' and tv.value = cv.conte_idseq)
/
select conte_idseq from sbr.contexts_view  where conte_idseq=(select tv.value from sbrext.tool_options_view_ext tv , sbr.contexts_view  cv where tv.tool_name = 'caDSR' and tv.property = 'DEFAULT_CONTEXT' and tv.value = cv.conte_idseq)
/
select conte_idseq from sbr.contexts  where conte_idseq=(select tv.value from sbrext.tool_options_view_ext tv , sbr.contexts_view  cv where tv.tool_name = 'caDSR' and tv.property = 'DEFAULT_CONTEXT' and tv.value = cv.conte_idseq)
/
