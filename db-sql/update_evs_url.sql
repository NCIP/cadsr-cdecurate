/*L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L*/

-- run this with SBREXT user

--update sbrext.tool_options_view_ext set value = 'http://lexevsapi60.nci.nih.gov/lexevsapi60'
--where Tool_name = 'CURATION' and Property = 'EVS.URL'
--/
update sbrext.tool_options_view_ext set value = 'http://lexevsapi60.nci.nih.gov/lexevsapi60'
where Tool_name = 'EVSAPI' and Property = 'URL'
/
commit
/
