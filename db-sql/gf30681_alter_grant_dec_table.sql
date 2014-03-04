/*L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L*/

-- run this as SBREXT user
/*
 * Fix related to issue https://gforge.nci.nih.gov/tracker/index.php?func=detail&aid=30681.
 */
grant select, insert, update on SBR.DATA_ELEMENT_CONCEPTS to cdebrowser
/
grant select, insert, update on SBR.DATA_ELEMENT_CONCEPTS_VIEW to cdebrowser
/
ALTER TABLE SBR.DATA_ELEMENT_CONCEPTS
  ADD CDR_NAME varchar2 (255);
/
create or replace view sbr.data_element_concepts_view as select * from sbr.data_element_concepts
/
