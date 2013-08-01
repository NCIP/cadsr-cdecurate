/*L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L*/

/*
 * Fix related to issue https://gforge.nci.nih.gov/tracker/index.php?func=detail&aid=30681.
 */
revoke select, insert, update on SBR.DATA_ELEMENT_CONCEPTS from cdebrowser
/
revoke select, insert, update on SBR.DATA_ELEMENT_CONCEPTS_VIEW from cdebrowser
/
ALTER TABLE SBR.DATA_ELEMENT_CONCEPTS
  DROP COLUMN CDR_NAME;
/
