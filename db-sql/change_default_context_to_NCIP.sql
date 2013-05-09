--Run with SBR user
update sbr.contexts_view  set name='NCIP' where conte_idseq=(select tv.value from sbrext.tool_options_view_ext tv , sbr.contexts_view  cv where tv.tool_name = 'caDSR' and tv.property = 'DEFAULT_CONTEXT' and tv.value = cv.conte_idseq)
/
commit
/
-- To Check whether default context is changed to "NCIP" in Database
SELECT name from sbr.contexts_view where conte_idseq=(select tv.value from sbrext.tool_options_view_ext tv , sbr.contexts_view  cv where 
tv.tool_name = 'caDSR' and tv.property = 'DEFAULT_CONTEXT' and tv.value = cv.conte_idseq)
/
-- To Check whether DE's exists with "NCIP" context in Database
SELECT count(*) FROM sbr.data_elements where conte_idseq = (select CONTE_IDSEQ from SBR.contexts where name='NCIP')
/
-- To Check whether DEC's exists with "NCIP" context in Database
SELECT count(*) FROM sbr.data_element_concepts where conte_idseq = (select CONTE_IDSEQ from SBR.contexts where name='NCIP')
/
-- To Check whether VD's exists with "NCIP" context in Database
SELECT count(*) FROM sbr.value_domains where conte_idseq = (select CONTE_IDSEQ from SBR.contexts where name='NCIP')
/
