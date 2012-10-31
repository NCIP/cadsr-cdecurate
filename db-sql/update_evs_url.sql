update sbrext.tool_options_view_ext set value = 'http://lexevsapi60.nci.nih.gov/lexevsapi60'
where Tool_name = 'CURATION' and Property = 'EVS.URL'
/
update sbrext.tool_options_view_ext set value = 'http://lexevsapi60.nci.nih.gov/lexevsapi60'
where Tool_name = 'EVSAPI' and Property = 'URL'
/
commit
/