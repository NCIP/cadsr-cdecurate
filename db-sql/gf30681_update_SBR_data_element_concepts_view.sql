-- run this as SBREXT user
/*
 * Fix related to issue https://gforge.nci.nih.gov/tracker/index.php?func=detail&aid=30681.
 */
--------------------------------------------------------
--  File created - Thursday-February-07-2013   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View DATA_ELEMENT_CONCEPTS_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SBR"."DATA_ELEMENT_CONCEPTS_VIEW" ("DEC_IDSEQ", "VERSION", "PREFERRED_NAME", "CONTE_IDSEQ", "CD_IDSEQ", "PROPL_NAME", "OCL_NAME", "PREFERRED_DEFINITION", "ASL_NAME", "LONG_NAME", "LATEST_VERSION_IND", "DELETED_IND", "DATE_CREATED", "BEGIN_DATE", "CREATED_BY", "END_DATE", "DATE_MODIFIED", "MODIFIED_BY", "OBJ_CLASS_QUALIFIER", "PROPERTY_QUALIFIER", "CHANGE_NOTE", "OC_IDSEQ", "PROP_IDSEQ", "ORIGIN", "DEC_ID", "CDR_NAME") AS 
  (Select "DEC_IDSEQ","VERSION","PREFERRED_NAME","CONTE_IDSEQ","CD_IDSEQ","PROPL_NAME","OCL_NAME","PREFERRED_DEFINITION","ASL_NAME","LONG_NAME","LATEST_VERSION_IND","DELETED_IND","DATE_CREATED","BEGIN_DATE","CREATED_BY","END_DATE","DATE_MODIFIED","MODIFIED_BY","OBJ_CLASS_QUALIFIER","PROPERTY_QUALIFIER","CHANGE_NOTE","OC_IDSEQ","PROP_IDSEQ","ORIGIN","DEC_ID","CDR_NAME" from data_element_concepts)
 ;
/
