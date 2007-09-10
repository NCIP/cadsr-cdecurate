/* COPYRIGHT SCENPRO, INC, 2005

   $HEADER: /CVSNT/CDECURATE/CONF/SANDBOX/LOAD_TOOL_OPTIONS.SQL,V 1.10 2007/07/18 17:34:32 LHEBEL EXP $
   $NAME:  $

   AUTHOR: ANUPAMA CHICKERUR

   THIS SCRIPT LOADS THE TOOL OPTIONS TABLE WITH REQUIRED AND OPTIONAL VALUES
   FOR THE CURATION TOOL.

   EACH IS DESCRIBED BRIEFLY BELOW. A FULL DESCRIPTION OF EACH CAN BE FOUND IN
   THE CURATION TOOL INSTALLATION GUIDE (FILE:DISTRIB/DOC/INSTALLATION GUIDE.DOC). 
   THESE VALUES MUST BE REVIEWED AND CHANGED AS NEEDED PER THE LOCAL INSTALLATION 
   AND DATABASE INSTANCE.  IF REQUIRED VALUES ARE MISSING OR SOMETHING IS MISCODED 
   OR INVALID APPROPRIATE ERROR MESSAGES ARE DISPLAYED VIA THE CURATION TOOL LOGIN PAGE.
*/


MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (
SELECT 'caDSR' AS TOOL_NAME, 'DEFAULT.LANGUAGE' AS PROPERTY, 'ENGLISH' AS VALUE, 'The default language for all caDSR tools.' AS DESCRIPTION FROM DUAL
UNION SELECT 'BROWSER' AS TOOL_NAME, 'URL' AS PROPERTY, 'http://cdebrowser@TIER@.nci.nih.gov' AS VALUE, 'Store browser url cde browser' AS DESCRIPTION FROM DUAL
UNION SELECT 'EVS' AS TOOL_NAME, 'URL' AS PROPERTY, 'http://cabio.nci.nih.gov/cacore32/http/remoteService' AS VALUE, 'Store evs url specific to the evs server' AS DESCRIPTION FROM DUAL
UNION SELECT 'EVS' AS TOOL_NAME, 'NEWTERM.URL' AS PROPERTY, 'http://ncimeta.nci.nih.gov/MetaServlet/FormalizationFailedServlet' AS VALUE, 'The EVS URL to suggest a new term in a vocabulary.' AS DESCRIPTION FROM DUAL
) T
ON (S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);


/* AS WE ARE USING MERGE, WE NEED NOT DELETE AND START FROM SCRATCH.
--first delete the existing data
DELETE FROM SBREXT.TOOL_OPTIONS_VIEW_EXT WHERE TOOL_NAME = 'CURATION';
*/

/*
 --store url for curation tool, evs alternate url and CSI type for uml package name and alias.
 */	   
MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (
SELECT 'CURATION' AS TOOL_NAME, 'URL' AS PROPERTY, 'http://cdecurate@TIER@.nci.nih.gov' AS VALUE, 'Store evs alternate url specific to curation tool if needed' AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.URL' AS PROPERTY,'http://cabio.nci.nih.gov/cacore32/http/remoteService' AS VALUE,'Store evs alternate url specific to curation tool if needed' AS DESCRIPTION FROM DUAL 
UNION SELECT 'CURATION' AS TOOL_NAME, 'CSI.PACKAGE.ALIAS' AS PROPERTY,'UML_PACKAGE_ALIAS' AS VALUE,'The special CSI type for the UML Package Alias' AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'CSI.PACKAGE.NAME' AS PROPERTY,'UML_PACKAGE_NAME' AS VALUE,'The special CSI type for the UML Package Name' AS DESCRIPTION FROM DUAL  
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);



/*
 --ALL VOCAB ATTRIBUTES
 */	   
MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (
--ALL VOCAB ATTRIBUTES
--Store vocab search-in Name for all vocabulary
SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.ALL.SEARCH_IN.NAME' AS PROPERTY, 'Name' AS VALUE, 'Store vocab search-in Name for all vocabulary' AS DESCRIPTION FROM DUAL 
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.ALL.SEARCH_IN.CONCODE' AS PROPERTY,'Concept Code' AS VALUE,'Store vocab search-in Concept Code for all vocabulary' AS DESCRIPTION FROM DUAL 
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.ALL.RETSEARCH' AS PROPERTY,'false' AS VALUE,'Store vocab Retired Search filter for all vocabulary' AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.ALL.PROPERTY.DEFINITION' AS PROPERTY,'DEFINITION' AS VALUE,'Store vocab Definition evs property to filter the search for all vocabulary' AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.ALL.PROPERTY.HDSYNONYM' AS PROPERTY,'FULL_SYN' AS VALUE,'Store vocab header synonym evs property to filter the search for all vocabulary' AS DESCRIPTION FROM DUAL  
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.ALL.PROPERTY.RETIRED' AS PROPERTY,'Concept_Status' AS VALUE,'Store vocab Retired Concept evs property to filter the search for all vocabulary' AS DESCRIPTION FROM DUAL  
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.ALL.PROPERTY.SEMANTIC' AS PROPERTY,'Semantic' AS VALUE,'Store vocab Semantic evs property to filter the search for all vocabulary' AS DESCRIPTION FROM DUAL  
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.ALL.SEARCHTYPE' AS PROPERTY,'NameType' AS VALUE,'Store vocab default search type to filter the search for all vocabulary' AS DESCRIPTION FROM DUAL    
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.ALL.DEFAULT_DEFINITION' AS PROPERTY,'No Value Exists' AS VALUE,'Store vocab default value for the definition when null for all vocabulary' AS DESCRIPTION FROM DUAL    
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);

/*
 -------NCI Thesaurus ------------
 */	
MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (
--VOCAB SPECIFIC ATTRIBUTES        -------NCI Thesaurus ------------
--Store vocab name for the first vocabulary
SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.1.EVSNAME' AS PROPERTY, 'NCI_Thesaurus' AS VALUE, 'Store vocab name for the first vocabulary' AS DESCRIPTION FROM DUAL 
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.1.DISPLAY' AS PROPERTY,'Thesaurus/Metathesaurus' AS VALUE,'Store vocab display name for the first vocabulary' AS DESCRIPTION FROM DUAL 
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.1.DBNAME' AS PROPERTY,'NCI Thesaurus' AS VALUE,'Store vocab database name for the first vocabulary' AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.1.VOCABCODETYPE' AS PROPERTY,'NCI_CONCEPT_CODE' AS VALUE,'Store vocab code type (alt type) for the first vocabulary' AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.1.METASOURCE' AS PROPERTY,'@EVS.VOCAB.1.METASOURCE@' AS VALUE,'Store vocab meta source for the first vocabulary' AS DESCRIPTION FROM DUAL  
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.1.USEPARENT' AS PROPERTY,'true' AS VALUE,'Store vocab to mark if used for parent search for the first vocabulary' AS DESCRIPTION FROM DUAL  
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.1.SEARCH_IN.NAME' AS PROPERTY,'Synonym' AS VALUE,'Store vocab search in name for the first vocabulary' AS DESCRIPTION FROM DUAL  
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.1.SEARCH_IN.CONCODE' AS PROPERTY,'Concept Code' AS VALUE,'Store vocab search in concode for the first vocabulary' AS DESCRIPTION FROM DUAL    
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.1.SEARCH_IN.METACODE' AS PROPERTY,'code' AS VALUE,'Store vocab search in metacode for the first vocabulary' AS DESCRIPTION FROM DUAL    
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.1.RETSEARCH' AS PROPERTY,'true' AS VALUE,'Store vocab include filter for retired concept for the first vocabulary' AS DESCRIPTION FROM DUAL    
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.1.SEARCHTYPE' AS PROPERTY,'PropType' AS VALUE,'Store vocab Search type of the name for the first vocabulary' AS DESCRIPTION FROM DUAL    
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.1.PROPERTY.NAMESEARCH' AS PROPERTY,'Synonym' AS VALUE,'Store vocab property to search name for the first vocabulary' AS DESCRIPTION FROM DUAL    
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.1.PROPERTY.NAMEDISPLAY' AS PROPERTY,'Preferred_Name' AS VALUE,'Store vocab property to display name for the first vocabulary' AS DESCRIPTION FROM DUAL   
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.1.INCLUDEMETA' AS PROPERTY,'NCI Metathesaurus' AS VALUE,'Store vocab meta name for the first vocabulary' AS DESCRIPTION FROM DUAL     
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);

/*
   -------GO-----------
--Store vocab name for the GO vocabulary           -------GO-----------
--Store vocab display name for the GO vocabulary
--Store vocab database name for the GO vocabulary //not needed if db name same as display name
--INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
--VALUES ('CURATION', 'EVS.VOCAB.2.DBNAME', 'GO',
--	   'Store vocab database name for the GO vocabulary'AS DESCRIPTION FROM DUAL 
--Store vocab code type (alt type) for the GO vocabulary
--Store vocab meta source for the GO vocabulary
--Store vocab to mark if used for parent search for the GO vocabulary
 */	   
	   
MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (		
SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.2.EVSNAME' AS PROPERTY, 'GO' AS VALUE,'Store vocab name for the GO vocabulary'AS DESCRIPTION FROM DUAL 
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.2.DISPLAY' AS PROPERTY, 'GO' AS VALUE,'Store vocab display name for the GO vocabulary' AS DESCRIPTION FROM DUAL 
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.2.VOCABCODETYPE' AS PROPERTY, 'GO_CODE' AS VALUE, 'Store vocab code type (alt type) for the GO vocabulary'AS DESCRIPTION FROM DUAL 
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.2.METASOURCE'AS PROPERTY, '@EVS.VOCAB.2.METASOURCE@'AS VALUE, 'Store vocab meta source for the GO vocabulary'AS DESCRIPTION FROM DUAL 
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.2.USEPARENT'AS PROPERTY, 'false' AS VALUE,'Store vocab to mark if used for parent search for the GO vocabulary'AS DESCRIPTION FROM DUAL 
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);

/*
  --------VA_NDFRD----------------
--Store vocab name for the VA_NDFRT vocabulary     --------VA_NDFRD----------------
--Store vocab display name for the VA_NDFRT vocabulary
--Store vocab display name for the VA_NDFRT vocabulary
--Store vocab database name for the VA_NDFRT vocabulary
--INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
--VALUES ('CURATION', 'EVS.VOCAB.3.DBNAME', 'VA_NDFRT',
--	   'Store vocab database name for the VA_NDFRT vocabulary');
--Store vocab code type (alt type) for the VA_NDFRT vocabulary
--Store vocab meta source for the VA_NDFRT vocabulary
--Store vocab to mark if used for parent search for the VA_NDFRT vocabulary
--Store vocab Definition evs property to filter the search for VA_NDFRT vocabulary
 */	   
	   
MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (		  	   
SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.3.EVSNAME' AS PROPERTY , 'VA_NDFRT' AS VALUE,'Store vocab name for the VA_NDFRT vocabulary'AS DESCRIPTION FROM DUAL 
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.3.DISPLAY' AS PROPERTY, 'VA_NDFRT' AS VALUE, 'Store vocab display name for the VA_NDFRT vocabulary'AS DESCRIPTION FROM DUAL 
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.3.VOCABCODETYPE' AS PROPERTY, 'VA_NDF_CODE' AS VALUE,'Store vocab code type (alt type) for the VA_NDFRT vocabulary'AS DESCRIPTION FROM DUAL 
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.3.METASOURCE' AS PROPERTY, '@EVS.VOCAB.3.METASOURCE@' AS VALUE,'Store vocab meta source for the VA_NDFRT vocabulary'AS DESCRIPTION FROM DUAL 
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.3.USEPARENT' AS PROPERTY, 'true' AS VALUE,'Store vocab to mark if used for parent search for the VA_NDFRT vocabulary'AS DESCRIPTION FROM DUAL 
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.3.PROPERTY.DEFINITION' AS PROPERTY, 'MeSH_Definition' AS VALUE,'Store vocab Definition evs property to filter the search for VA_NDFRT vocabulary'AS DESCRIPTION FROM DUAL 
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);

/*
  ------------LOINC-----------
--Store vocab name for the LOINC vocabulary       ------------LOINC-----------
--Store vocab display name for the LOINC vocabulary
--Store vocab database name for the LOINC vocabulary
--INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
--VALUES ('CURATION', 'EVS.VOCAB.4.DBNAME', 'LOINC',
--	   'Store vocab database name for the LOINC vocabulary');
--Store vocab code type (alt type) for the LOINC vocabulary
--Store vocab meta source for the LOINC vocabulary
--Store vocab to mark if used for parent search for the LOINC vocabulary
 */	   
	   
MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (		   
SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.4.EVSNAME' AS PROPERTY, 'LOINC'AS VALUE,'Store vocab name for the LOINC vocabulary'AS DESCRIPTION FROM DUAL 
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.4.DISPLAY'AS PROPERTY, 'LOINC'AS VALUE,'Store vocab display name for the LOINC vocabulary'AS DESCRIPTION FROM DUAL 
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.4.VOCABCODETYPE' AS PROPERTY, 'LOINC_CODE'AS VALUE,'Store vocab code type (alt type) for the LOINC vocabulary'AS DESCRIPTION FROM DUAL 
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.4.METASOURCE'AS PROPERTY, '@EVS.VOCAB.4.METASOURCE@'AS VALUE,'Store vocab meta source for the LOINC vocabulary'AS DESCRIPTION FROM DUAL 
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.4.USEPARENT'AS PROPERTY, 'false'AS VALUE,'Store vocab to mark if used for parent search for the LOINC vocabulary'AS DESCRIPTION FROM DUAL 
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);


/*
  ----------MGED---------
--Store vocab name for the MGED vocabulary         ----------MGED---------
--Store vocab display name for the MGED vocabulary
--Store vocab database name for the MGED vocabulary
--INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
--VALUES ('CURATION', 'EVS.VOCAB.5.DBNAME', 'MGED',
--	   'Store vocab database name for the MGED vocabulary');
--Store vocab code type (alt type) for the MGED vocabulary
--Store vocab meta source for the MGED vocabulary
--Store vocab to mark if used for parent search for the MGED vocabulary
 */	   
	   
MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (		   
SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.5.EVSNAME'AS PROPERTY, 'MGED_Ontology'AS VALUE,'Store vocab name for the MGED vocabulary'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.5.DISPLAY'AS PROPERTY, 'MGED'AS VALUE,'Store vocab display name for the MGED vocabulary'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.5.VOCABCODETYPE'AS PROPERTY, 'NCI_MO_CODE'AS VALUE, 'Store vocab code type (alt type) for the MGED vocabulary'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION'AS TOOL_NAME, 'EVS.VOCAB.5.METASOURCE' AS PROPERTY, '@EVS.VOCAB.5.METASOURCE@' AS VALUE,'Store vocab meta source for the MGED vocabulary'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION'AS TOOL_NAME, 'EVS.VOCAB.5.USEPARENT' AS PROPERTY, 'true' AS VALUE,'Store vocab to mark if used for parent search for the MGED vocabulary' AS DESCRIPTION FROM DUAL
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);

/*
  --------MedDRA----------
--Store vocab name for the MedDRA vocabulary          --------MedDRA----------
--Store vocab access code for the MedDRA vocabulary.
--Store vocab display name for the MedDRA vocabulary
--Store vocab database name for the MedDRA vocabulary
--INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
--VALUES ('CURATION', 'EVS.VOCAB.6.DBNAME', 'MedDRA',
--	   'Store vocab database name for the MedDRA vocabulary');
--Store vocab code type (alt type) for the MedDRA vocabulary
--Store vocab meta source for the MedDRA vocabulary
--Store vocab to mark if used for parent search for the MedDRA vocabulary
--Store vocab Search type of the name for the MedDRA vocabulary
--Store vocab property to search name for the MedDRA vocabulary
--Store vocab property to display name for the MedDRA vocabulary
 */	   
	   
MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (		   
SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.6.EVSNAME' AS PROPERTY, 'MedDRA' AS VALUE, 'Store vocab name for the MedDRA vocabulary'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.6.ACCESSREQUIRED' AS PROPERTY, '10382' AS VALUE, 'Store vocab access code for the MedDRA vocabulary' AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.6.DISPLAY' AS PROPERTY, 'MedDRA' AS VALUE,'Store vocab display name for the MedDRA vocabulary'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.6.VOCABCODETYPE' AS PROPERTY, 'MEDDRA_CODE' AS VALUE,'Store vocab code type (alt type) for the MedDRA vocabulary'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.6.METASOURCE' AS PROPERTY, '@EVS.VOCAB.6.METASOURCE@' AS VALUE,'Store vocab meta source for the MedDRA vocabulary'AS DESCRIPTION FROM DUAL
UNION SELECT'CURATION' AS TOOL_NAME, 'EVS.VOCAB.6.USEPARENT' AS PROPERTY, 'true' AS VALUE, 'Store vocab to mark if used for parent search for the MedDRA vocabulary'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.6.SEARCHTYPE' AS PROPERTY, 'PropType' AS VALUE, 'Store vocab Search type of the name for the MedDRA vocabulary'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.6.PROPERTY.NAMESEARCH' AS PROPERTY, 'Preferred_Name' AS VALUE, 'Store vocab property to search name for the MedDRA vocabulary'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION'AS TOOL_NAME, 'EVS.VOCAB.6.PROPERTY.NAMEDISPLAY' AS PROPERTY, 'Preferred_Name' AS VALUE, 'Store vocab property to display name for the MedDRA vocabulary'AS DESCRIPTION FROM DUAL
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);


/*
  --------SNOMED----------
--Store vocab name for the SNOMED vocabulary          --------SNOMED----------
--Store vocab display name for the SNOMED vocabulary
--Store vocab database name for the SNOMED vocabulary
--INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
--VALUES ('CURATION', 'EVS.VOCAB.7.DBNAME', 'SNOMED',
--	   'Store vocab database name for the SNOMED vocabulary');
--Store vocab code type (alt type) for the SNOMED vocabulary
--Store vocab meta source for the SNOMED vocabulary
--Store vocab to mark if used for parent search for the SNOMED vocabulary
--Store vocab Search type of the name for the SNOMED vocabulary
--Store vocab property to search name for the SNOMED vocabulary
--Store vocab property to display name for the SNOMED vocabulary
 */
      
MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (	   
SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.7.EVSNAME' AS PROPERTY, 'SNOMED_CT' AS VALUE, 'Store vocab name for the SNOMED vocabulary'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.6.DISPLAY' AS PROPERTY, 'SNOMED' AS VALUE, 'Store vocab display name for the SNOMED vocabulary'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.7.VOCABCODETYPE' AS PROPERTY, 'SNOMED_CODE' AS VALUE, 'Store vocab code type (alt type) for the SNOMED vocabulary'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION'AS TOOL_NAME, 'EVS.VOCAB.7.METASOURCE' AS PROPERTY, '@EVS.VOCAB.7.METASOURCE@' AS VALUE, 'Store vocab meta source for the SNOMED vocabulary'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION'AS TOOL_NAME, 'EVS.VOCAB.7.USEPARENT' AS PROPERTY, 'true' AS VALUE, 'Store vocab to mark if used for parent search for the SNOMED vocabulary'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.7.SEARCHTYPE' AS PROPERTY, 'PropType' AS VALUE,'Store vocab Search type of the name for the SNOMED vocabulary'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.7.PROPERTY.NAMESEARCH' AS PROPERTY, 'SNOMED_PREFERRED_TERM' AS VALUE,'Store vocab property to search name for the SNOMED vocabulary'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.VOCAB.7.PROPERTY.NAMEDISPLAY' AS PROPERTY, 'SNOMED_PREFERRED_TERM' AS VALUE,'Store vocab property to display name for the SNOMED vocabulary' AS DESCRIPTION FROM DUAL
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION); 

/*
    META ATTRIBUTES
    --META ATTRIBUTES
--Store meta code type with filter value for meta search
--Store meta code type with filter value (default means all others) for meta search
--Store meta code type with filter value (default means all others) for meta search; SNOMED has property without underscore
*/
	   
MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (	   
SELECT 'CURATION' AS TOOL_NAME, 'EVS.METACODETYPE.NCI_META_CUI.NCI_META_CUI' AS PROPERTY, 'CL' AS VALUE, 'Store meta code type with filter value for meta search'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.METACODETYPE.UMLS_CUI.UMLS_CUI' AS PROPERTY, 'DEFAULT' AS VALUE,'Store meta code type with filter value (default means all others) for meta search'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.METACODETYPE.UMLS CUI.UMLS_CUI' AS PROPERTY, 'DEFAULT' AS VALUE,'Store meta code type with filter value (default means all others) for meta search; SNOMED has property without underscore' AS DESCRIPTION FROM DUAL
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);

/*
    DEF SOURCE ATTRIBUTES
    --DEF SOURCE ATTRIBUTES
    --Store NCI def source to filter out the multiple definition used
--Store NCI def source to filter out the multiple definition used
--Store NCI def source to filter out the multiple definition used
--Store NCI def source to filter out the multiple definition used
*/	   
	   
MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (	   
SELECT 'CURATION' AS TOOL_NAME, 'EVS.DEFSOURCE.1' AS PROPERTY, '@EVS.DEFSOURCE.1@' AS VALUE, 'Store NCI def source to filter out the multiple definition used'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.DEFSOURCE.2' AS PROPERTY, '@EVS.DEFSOURCE.2@' AS VALUE, 'Store NCI def source to filter out the multiple definition used'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.DEFSOURCE.3' AS PROPERTY, '@EVS.DEFSOURCE.3@' AS VALUE,'Store NCI def source to filter out the multiple definition used'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.DEFSOURCE.4' AS PROPERTY, '@EVS.DEFSOURCE.4@' AS VALUE,'Store NCI def source to filter out the multiple definition used'AS DESCRIPTION FROM DUAL
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);


/*
    DSR DISPLAY NAME
    --DSR DISPLAY NAME
--Store the display name of the cadsr database
--Store NCI Thesaurus name to get the name of preferred vocabulary when getting thesarurs concept 
--Store NCI Thesaurus source to get its source code used in replacing concept with preferred vocab (Thesaurus)
*/


MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (
SELECT 'CURATION' AS TOOL_NAME, 'EVS.DSRDISPLAY' AS PROPERTY, 'caDSR' AS VALUE,'Store the display name of the cadsr database' AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.PREFERREDVOCAB' AS PROPERTY, 'NCI_Thesaurus' AS VALUE,'Store NCI Thesaurus name to get the name of preferred vocabulary when getting thesarurs concept'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EVS.PREFERREDVOCAB.SOURCE' AS PROPERTY, '@EVS.PREFERREDVOCAB.SOURCE@' AS VALUE, 'Store NCI Thesaurus source to get its source code used in replacing concept with preferred vocab (Thesaurus)'AS DESCRIPTION FROM DUAL
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);

/*
    STORE DOCUMENT TYPES USED FOR DROP DOWN LIST.
    --Store document types used for drop down list.
--Store document types used for drop down list.         --------DOCUMENT TYPES ---------
*/

MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (
SELECT 'CURATION' AS TOOL_NAME, 'EXCLUDE.DOCUMENT_TYPE.1' AS PROPERTY, 'HL7_EDCI_INSTRUMENT_MIF' AS VALUE, 'Must exist in SBR.DOCUMENT_TYPES_LOV table' AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EXCLUDE.DOCUMENT_TYPE.2' AS PROPERTY, 'HL7_GLOBAL_DEFINITION_MIF' AS VALUE, 'Must exist in SBR.DOCUMENT_TYPES_LOV table'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EXCLUDE.DOCUMENT_TYPE.3' AS PROPERTY, 'META_CONCEPT_SOURCE' AS VALUE, 'Must exist in SBR.DOCUMENT_TYPES_LOV table' AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EXCLUDE.DOCUMENT_TYPE.4' AS PROPERTY, 'Owning Document Text' AS VALUE, 'Must exist in SBR.DOCUMENT_TYPES_LOV table' AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EXCLUDE.DOCUMENT_TYPE.5' AS PROPERTY, 'Preferred Question Text' AS VALUE,'Must exist in SBR.DOCUMENT_TYPES_LOV table' AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EXCLUDE.DOCUMENT_TYPE.6' AS PROPERTY, 'Service Context Property' AS VALUE, 'Must exist in SBR.DOCUMENT_TYPES_LOV table' AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EXCLUDE.DOCUMENT_TYPE.7' AS PROPERTY, 'Standard Question Text' AS VALUE,'Must exist in SBR.DOCUMENT_TYPES_LOV table' AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EXCLUDE.DOCUMENT_TYPE.8' AS PROPERTY, 'TECHNICAL GUIDE' AS VALUE,'Must exist in SBR.DOCUMENT_TYPES_LOV table' AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EXCLUDE.DOCUMENT_TYPE.9' AS PROPERTY, 'UML Attribute' AS VALUE,'Must exist in SBR.DOCUMENT_TYPES_LOV table' AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EXCLUDE.DOCUMENT_TYPE.10' AS PROPERTY, 'UML Class' AS VALUE,'Must exist in SBR.DOCUMENT_TYPES_LOV table' AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'EXCLUDE.DOCUMENT_TYPE.11' AS PROPERTY, 'VD REFERENCE'AS VALUE,'Must exist in SBR.DOCUMENT_TYPES_LOV table' AS DESCRIPTION FROM DUAL
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);

 /*
  --Store document types used for drop down list.  --------DESIGNATION TYPE / alt types ----------
  */
       
MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (
SELECT 'CURATION'AS TOOL_NAME, 'EXCLUDE.DESIGNATION_TYPE.1' AS PROPERTY, 'USED_BY' AS VALUE, 'Must exist in SBR.DESIGNATION_TYPES_LOV table' AS DESCRIPTION FROM DUAL
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);

/*
--Store derivation types used for drop down list.           -------COMPLEX or Derivation Type -------
*/
 
MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (
SELECT 'CURATION' AS TOOL_NAME, 'INCLUDE.DERIVATION_TYPE.1' AS PROPERTY, 'CALCULATED' AS VALUE,'Must exist in SBR.COMPLEX_REP_TYPE_LOV table'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'INCLUDE.DERIVATION_TYPE.2' AS PROPERTY, 'COMPOUND' AS VALUE, 'Must exist in SBR.COMPLEX_REP_TYPE_LOV table'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'INCLUDE.DERIVATION_TYPE.3' AS PROPERTY, 'CONCATENATION' AS VALUE,'Must exist in SBR.COMPLEX_REP_TYPE_LOV table'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'INCLUDE.DERIVATION_TYPE.4' AS PROPERTY, 'Simple Concept' AS VALUE,'Must exist in SBR.COMPLEX_REP_TYPE_LOV table'AS DESCRIPTION FROM DUAL
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);

/*
--Ref doc file cache for uploading blobs from the DB to the web server to create url.	     
*/  

MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (	   
SELECT 'CURATION' AS TOOL_NAME, 'REFDOC_FILECACHE' AS PROPERTY, '/local/content/cdecurate/filecache/' AS VALUE, 'Ref doc file cache for uploading blobs from the DB to the web server to create url.'AS DESCRIPTION FROM DUAL
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);

/*
--Ref doc file url. This is the prefix url for building the file anchor tag for files uploaded to the file cache.  
*/
      
MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (
SELECT 'CURATION' AS TOOL_NAME, 'REFDOC_FILEURL' AS PROPERTY, 'http://cdecurate@TIER@.nci.nih.gov/filecache/' AS VALUE, 'Ref doc file url. This is the prefix url for building the file anchor tag for files uploaded to the file cache.'AS DESCRIPTION FROM DUAL  
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);

/*
--Store the integer concepts id for name value pair  
--Store the Ordinal Position concepts id for name value pair  
  
  */
      	   
MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (       
SELECT 'CURATION' AS TOOL_NAME, 'NVPCONCEPT.1' AS PROPERTY, 'C45255' AS VALUE, 'Store the integer concept id for name value pair'AS DESCRIPTION FROM DUAL
UNION SELECT 'CURATION' AS TOOL_NAME, 'NVPCONCEPT.7' AS PROPERTY, 'C46126' AS VALUE,'Store the Ordinal Position concept id for name value pair'AS DESCRIPTION FROM DUAL
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);

/*
--Store the RELEASED asl name to include in the filter    
*/
      
MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S
USING (
SELECT 'CURATION' AS TOOL_NAME, 'INCLUDE.ASL.FILTER.1' AS PROPERTY, 'RELEASED' AS VALUE,'Store the RELEASED asl name to include in the filter' AS DESCRIPTION FROM DUAL
)T
ON(S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY)
WHEN MATCHED THEN 
      UPDATE SET S.VALUE = S.VALUE, S.DESCRIPTION = T.DESCRIPTION
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);

--commit the inserts
COMMIT;


