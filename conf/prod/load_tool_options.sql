/* Copyright ScenPro, Inc, 2005

   $Header: /cvsshare/content/cvsroot/cdecurate/conf/prod/load_tool_options.sql,v 1.44 2007-05-29 17:15:13 hebell Exp $
   $Name: not supported by cvs2svn $

   Author: Sumana Hegde

   This script loads the Tool Options table with required and optional values
   for the Curation Tool.

   Each is described briefly below. A full description of each can be found in
   the Curation Tool Installation Guide (file:distrib/doc/Installation Guide.doc). 
   These values must be reviewed and changed as needed per the local installation 
   and database instance.  If required values are missing or something is miscoded 
   or invalid appropriate error messages are displayed via the Curation Tool Login page.
*/

/* If the caDSR DEFAULT.LANGUAGE has not been loaded into the table, execute
    the following statement. The language value must first exist in the sbr.languages_lov_view
    table/view.

INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('caDSR', 'DEFAULT.LANGUAGE', 'ENGLISH', 'The default language for all caDSR tools.'); 
*/

/*
--Store evs url for all tools: need to make sure it doesn't exists already before runnning.
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('EVS', 'URL', 'http://cabio.nci.nih.gov/cacore32/http/remoteService', 
	   'Store evs url specific to EVS'); 

--Store browser url for all tools: need to make sure it doesn't exists already before runnning.
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('BROWSER', 'URL', 'http://cdebrowser.nci.nih.gov', 
	   'Store browser url cde browser'); 
*/

--first delete the existing data
DELETE FROM sbrext.tool_options_view_ext WHERE tool_name = 'CURATION';


--Store url for curation tool if needed.
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'URL', 'http://cdecurate.nci.nih.gov', 
	   'Store evs alternate url specific to curation tool if needed');
/*
--Store evs alternate url specific to curation tool if needed.
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.URL', 'http://cabio.nci.nih.gov/cacore32/http/remoteService', 
	   'Store evs alternate url specific to curation tool if needed');
*/

--Store the CSI type for UML_PACKAGE_ALIAS
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'CSI.PACKAGE.ALIAS', 'UML_PACKAGE_ALIAS',
        'The special CSI type for the UML Package Alias');

--Store the CSI type for UML_PACKAGE_name
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'CSI.PACKAGE.NAME', 'UML_PACKAGE_NAME',
        'The special CSI type for the UML Package Name');

--ALL VOCAB ATTRIBUTES
--Store vocab search-in Name for all vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.ALL.SEARCH_IN.NAME', 'Name', 
	   'Store vocab search-in Name for all vocabulary');

--Store vocab search-in Concept Code for all vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.ALL.SEARCH_IN.CONCODE', 'Concept Code', 
	   'Store vocab search-in Concept Code for all vocabulary');

--Store vocab Retired Search filter for all vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.ALL.RETSEARCH', 'false', 
	   'Store vocab Retired Search filter for all vocabulary');

--Store vocab Definition evs property to filter the search for all vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.ALL.PROPERTY.DEFINITION', 'DEFINITION', 
	   'Store vocab Definition evs property to filter the search for all vocabulary');

--Store vocab header synonym evs property to filter the search for all vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.ALL.PROPERTY.HDSYNONYM', 'FULL_SYN', 
	   'Store vocab header synonym evs property to filter the search for all vocabulary');

--Store vocab Retired Concept evs property to filter the search for all vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.ALL.PROPERTY.RETIRED', 'Concept_Status', 
	   'Store vocab Retired Concept evs property to filter the search for all vocabulary');

--Store vocab Semantic evs property to filter the search for all vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.ALL.PROPERTY.SEMANTIC', 'Semantic', 
	   'Store vocab Semantic evs property to filter the search for all vocabulary');

--Store vocab default search type to filter the search for all vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.ALL.SEARCHTYPE', 'NameType', 
	   'Store vocab default search type to filter the search for all vocabulary');

--Store vocab default value for the definition when null for all vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.ALL.DEFAULT_DEFINITION', 'No Value Exists', 
	   'Store vocab default value for the definition when null for all vocabulary');

--Store Tree Search filter for all vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.ALL.TREESEARCH', 'true', 
	   'Store vocab Tree Search filter for all vocabulary');


--VOCAB SPECIFIC ATTRIBUTES        -------NCI Thesaurus ------------
--Store vocab name for the first vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.1.EVSNAME', 'NCI_Thesaurus', 
	   'Store vocab name for the first vocabulary');

--Store vocab display name for the first vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.1.DISPLAY', 'NCI Thesaurus', 
	   'Store vocab display name for the first vocabulary');

--Store vocab database name for the first vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.1.DBNAME', 'NCI Thesaurus', 
	   'Store vocab database name for the first vocabulary');

--Store vocab code type (alt type) for the first vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.1.VOCABCODETYPE', 'NCI_CONCEPT_CODE', 
	   'Store vocab code type (alt type) for the first vocabulary');

--Store vocab meta source for the first vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.1.METASOURCE', 'NCI2007_01D', 
	   'Store vocab meta source for the first vocabulary');

--Store vocab to mark if used for parent search for the first vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.1.USEPARENT', 'true', 
	   'Store vocab to mark if used for parent search for the first vocabulary');

--Store vocab search in name for the first vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.1.SEARCH_IN.NAME', 'Synonym', 
	   'Store vocab search in name for the first vocabulary');

--Store vocab search in concode for the first vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.1.SEARCH_IN.CONCODE', 'Concept Code', 
	   'Store vocab search in concode for the first vocabulary');

--Store vocab search in metacode for the first vocabulary
--INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
--VALUES ('CURATION', 'EVS.VOCAB.1.SEARCH_IN.METACODE', 'Code', 
--	   'Store vocab search in metacode for the first vocabulary');

--Store vocab include filter for retired concept for the first vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.1.RETSEARCH', 'true', 
	   'Store vocab include filter for retired concept for the first vocabulary');

--Store vocab Search type of the name for the first vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.1.SEARCHTYPE', 'PropType', 
	   'Store vocab Search type of the name for the first vocabulary');

--Store vocab property to search name for the first vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.1.PROPERTY.NAMESEARCH', 'Synonym', 
	   'Store vocab property to search name for the first vocabulary');

--Store vocab property to display name for the first vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.1.PROPERTY.NAMEDISPLAY', 'Preferred_Name', 
	   'Store vocab property to display name for the first vocabulary');

--Store vocab meta name for the first vocabulary
--INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
--VALUES ('CURATION', 'EVS.VOCAB.1.INCLUDEMETA', 'NCI Metathesaurus', 
--	   'Store vocab meta name for the first vocabulary');
	   
	   

--Store vocab name for the GO vocabulary           -------GO-----------
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.2.EVSNAME', 'GO',
	   'Store vocab name for the GO vocabulary');

--Store vocab display name for the GO vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.2.DISPLAY', 'GO',
	   'Store vocab display name for the GO vocabulary');

--Store vocab database name for the GO vocabulary //not needed if db name same as display name
--INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
--VALUES ('CURATION', 'EVS.VOCAB.2.DBNAME', 'GO',
--	   'Store vocab database name for the GO vocabulary');

--Store vocab code type (alt type) for the GO vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.2.VOCABCODETYPE', 'GO_CODE',
	   'Store vocab code type (alt type) for the GO vocabulary');

--Store vocab meta source for the GO vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.2.METASOURCE', 'GO2006_01_20',
	   'Store vocab meta source for the GO vocabulary');

--Store vocab to mark if used for parent search for the GO vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.2.USEPARENT', 'false',
	   'Store vocab to mark if used for parent search for the GO vocabulary');

	   
	   
	   
--Store vocab name for the VA_NDFRT vocabulary     --------VA_NDFRT----------------
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.3.EVSNAME', 'VA_NDFRT',
	   'Store vocab name for the VA_NDFRT vocabulary');

--Store vocab display name for the VA_NDFRT vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.3.DISPLAY', 'VA_NDFRT',
	   'Store vocab display name for the VA_NDFRT vocabulary');

--Store vocab database name for the VA_NDFRT vocabulary
--INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
--VALUES ('CURATION', 'EVS.VOCAB.3.DBNAME', 'VA_NDFRT',
--	   'Store vocab database name for the VA_NDFRT vocabulary');

--Store vocab code type (alt type) for the VA_NDFRT vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.3.VOCABCODETYPE', 'VA_NDF_CODE',
	   'Store vocab code type (alt type) for the VA_NDFRT vocabulary');

--Store vocab meta source for the VA_NDFRT vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.3.METASOURCE', 'NDFRT_2004_01',
	   'Store vocab meta source for the VA_NDFRT vocabulary');

--Store vocab to mark if used for parent search for the VA_NDFRT vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.3.USEPARENT', 'true',
	   'Store vocab to mark if used for parent search for the VA_NDFRT vocabulary');

--Store vocab Definition evs property to filter the search for VA_NDFRT vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.3.PROPERTY.DEFINITION', 'MeSH_Definition',
	   'Store vocab Definition evs property to filter the search for VA_NDFRT vocabulary');

	   
	   
--Store vocab name for the LOINC vocabulary       ------------LOINC-----------
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.4.EVSNAME', 'LOINC',
	   'Store vocab name for the LOINC vocabulary');

--Store vocab display name for the LOINC vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.4.DISPLAY', 'LOINC',
	   'Store vocab display name for the LOINC vocabulary');

--Store vocab database name for the LOINC vocabulary
--INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
--VALUES ('CURATION', 'EVS.VOCAB.4.DBNAME', 'LOINC',
--	   'Store vocab database name for the LOINC vocabulary');

--Store vocab code type (alt type) for the LOINC vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.4.VOCABCODETYPE', 'LOINC_CODE',
	   'Store vocab code type (alt type) for the LOINC vocabulary');

--Store vocab meta source for the LOINC vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.4.METASOURCE', 'LNC216',
	   'Store vocab meta source for the LOINC vocabulary');

--Store vocab to mark if used for parent search for the LOINC vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.4.USEPARENT', 'false',
	   'Store vocab to mark if used for parent search for the LOINC vocabulary');

	   
	   
--Store vocab name for the MGED vocabulary         ----------MGED---------
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.5.EVSNAME', 'MGED_Ontology',
	   'Store vocab name for the MGED vocabulary');

--Store vocab display name for the MGED vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.5.DISPLAY', 'MGED',
	   'Store vocab display name for the MGED vocabulary');

--Store vocab database name for the MGED vocabulary
--INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
--VALUES ('CURATION', 'EVS.VOCAB.5.DBNAME', 'MGED',
--	   'Store vocab database name for the MGED vocabulary');

--Store vocab code type (alt type) for the MGED vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.5.VOCABCODETYPE', 'NCI_MO_CODE',
	   'Store vocab code type (alt type) for the MGED vocabulary');

--Store vocab meta source for the MGED vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.5.METASOURCE', '',
	   'Store vocab meta source for the MGED vocabulary');

--Store vocab to mark if used for parent search for the MGED vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.5.USEPARENT', 'true',
	   'Store vocab to mark if used for parent search for the MGED vocabulary');

	   
	   
	   
--Store vocab name for the MedDRA vocabulary          --------MedDRA----------
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.6.EVSNAME', 'MedDRA',
	   'Store vocab name for the MedDRA vocabulary');

--Store vocab access code for the MedDRA vocabulary.
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.6.ACCESSREQUIRED', '10382',
       'Store vocab access code for the MedDRA vocabulary');

--Store vocab display name for the MedDRA vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.6.DISPLAY', 'MedDRA',
	   'Store vocab display name for the MedDRA vocabulary');

--Store vocab database name for the MedDRA vocabulary
--INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
--VALUES ('CURATION', 'EVS.VOCAB.6.DBNAME', 'MedDRA',
--	   'Store vocab database name for the MedDRA vocabulary');

--Store vocab code type (alt type) for the MedDRA vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.6.VOCABCODETYPE', 'MEDDRA_CODE',
	   'Store vocab code type (alt type) for the MedDRA vocabulary');

--Store vocab meta source for the MedDRA vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.6.METASOURCE', 'MDR90',
	   'Store vocab meta source for the MedDRA vocabulary');

--Store vocab to mark if used for parent search for the MedDRA vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.6.USEPARENT', 'true',
	   'Store vocab to mark if used for parent search for the MedDRA vocabulary');

--Store vocab Search type of the name for the MedDRA vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.6.SEARCHTYPE', 'PropType',
	   'Store vocab Search type of the name for the MedDRA vocabulary');

--Store vocab property to search name for the MedDRA vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.6.PROPERTY.NAMESEARCH', 'Preferred_Name',
	   'Store vocab property to search name for the MedDRA vocabulary');

--Store vocab property to display name for the MedDRA vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.6.PROPERTY.NAMEDISPLAY', 'Preferred_Name',
	   'Store vocab property to display name for the MedDRA vocabulary');

	   
	   
--Store vocab name for the SNOMED vocabulary          --------SNOMED----------
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.7.EVSNAME', 'SNOMED_CT',
	   'Store vocab name for the SNOMED vocabulary');

--Store vocab display name for the SNOMED vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.7.DISPLAY', 'SNOMED',
	   'Store vocab display name for the SNOMED vocabulary');

--Store vocab database name for the SNOMED vocabulary
--INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
--VALUES ('CURATION', 'EVS.VOCAB.7.DBNAME', 'SNOMED',
--	   'Store vocab database name for the SNOMED vocabulary');

--Store vocab code type (alt type) for the SNOMED vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.7.VOCABCODETYPE', 'SNOMED_CODE',
	   'Store vocab code type (alt type) for the SNOMED vocabulary');

--Store vocab meta source for the SNOMED vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.7.METASOURCE', 'SNOMEDCT_2006_01_31',
	   'Store vocab meta source for the SNOMED vocabulary');

--Store vocab to mark if used for parent search for the SNOMED vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.7.USEPARENT', 'true',
	   'Store vocab to mark if used for parent search for the SNOMED vocabulary');

--Store vocab Search type of the name for the SNOMED vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.7.SEARCHTYPE', 'PropType',
	   'Store vocab Search type of the name for the SNOMED vocabulary');

--Store vocab property to search name for the SNOMED vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.7.PROPERTY.NAMESEARCH', 'SNOMED_PREFERRED_TERM',
	   'Store vocab property to search name for the SNOMED vocabulary');

--Store vocab property to display name for the SNOMED vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.7.PROPERTY.NAMEDISPLAY', 'SNOMED_PREFERRED_TERM',
	   'Store vocab property to display name for the SNOMED vocabulary');


--Store vocab name for the NCI Metathesaurus vocabulary           -------NCI Metathesaurus-----------
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.8.EVSNAME', 'NCI Metathesaurus',
	   'Store vocab name for the NCI Metathesaurus vocabulary');

--Store vocab display name for the NCI Metathesaurus vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.8.DISPLAY', 'NCI Metathesaurus',
	   'Store vocab display name for the NCI Metathesaurus vocabulary');

--Store vocab to mark if used for parent search for the NCI Metathesaurus vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.8.USEPARENT', 'true',
	   'Store vocab to mark if used for parent search for the NCI Metathesaurus vocabulary');

--Store vocab meta name for the NCI Metathesaurus vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.8.INCLUDEMETA', 'NCI Metathesaurus', 
	   'Store vocab meta name for the NCI Metathesaurus vocabulary');

--Store vocab search in name for the NCI Metathesaurus vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.8.SEARCH_IN.NAME', 'Name', 
	   'Store vocab search in name for the NCI Metathesaurus vocabulary');

--Store vocab search in concode for the NCI Metathesaurus vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.8.SEARCH_IN.CONCODE', 'Concept Code', 
	   'Store vocab search in concode for the NCI Metathesaurus vocabulary');

--Store vocab search in metacode for the NCI Metathesaurus vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.8.SEARCH_IN.METACODE', 'Code', 
	   'Store vocab search in metacode for the first vocabulary');

--Store Tree Search filter as false for meta vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.8.TREESEARCH', 'false', 
	   'Store vocab Tree Search filter as false for meta vocabulary');

	   
	   
--META ATTRIBUTES
--Store meta code type with filter value for meta search
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.METACODETYPE.NCI_META_CUI.NCI_META_CUI', 'CL',
	   'Store meta code type with filter value for meta search');

--Store meta code type with filter value (default means all others) for meta search
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.METACODETYPE.UMLS_CUI.UMLS_CUI', 'DEFAULT',
	   'Store meta code type with filter value (default means all others) for meta search');

--Store meta code type with filter value (default means all others) for meta search; SNOMED has property without underscore
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.METACODETYPE.UMLS CUI.UMLS_CUI', 'DEFAULT',
	   'Store meta code type with filter value (default means all others) for meta search; SNOMED has property without underscore');

	   
	   
--DEF SOURCE ATTRIBUTES
--Store NCI def source to filter out the multiple definition used
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.DEFSOURCE.1', 'NCI',
	   'Store NCI def source to filter out the multiple definition used');

--Store NCI def source to filter out the multiple definition used
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.DEFSOURCE.2', 'NCI-GLOSS_0701D',
	   'Store NCI def source to filter out the multiple definition used');

--Store NCI def source to filter out the multiple definition used
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.DEFSOURCE.3', 'NCI2007_01D',
	   'Store NCI def source to filter out the multiple definition used');

--Store NCI def source to filter out the multiple definition used
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.DEFSOURCE.4', 'NCICB',
	   'Store NCI def source to filter out the multiple definition used');

--DSR DISPLAY NAME
--Store the display name of the cadsr database
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.DSRDISPLAY', 'caDSR',
	   'Store the display name of the cadsr database');
	   
--Store NCI Thesaurus name to get the name of preferred vocabulary when getting thesarurs concept 
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.PREFERREDVOCAB', 'NCI_Thesaurus',
	   'Store NCI Thesaurus name to get the name of preferred vocabulary when getting thesarurs concept');
	   
--Store NCI Thesaurus source to get its source code used in replacing concept with preferred vocab (Thesaurus)
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.PREFERREDVOCAB.SOURCE', 'NCI2007_01D',
	   'Store NCI Thesaurus source to get its source code used in replacing concept with preferred vocab (Thesaurus)');

	   


--Store document types used for drop down list.
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EXCLUDE.DOCUMENT_TYPE.1', 'HL7_EDCI_INSTRUMENT_MIF', 
       'Must exist in SBR.DOCUMENT_TYPES_LOV table');

--Store document types used for drop down list.         --------DOCUMENT TYPES ---------
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EXCLUDE.DOCUMENT_TYPE.2', 'HL7_GLOBAL_DEFINITION_MIF', 
       'Must exist in SBR.DOCUMENT_TYPES_LOV table');

--Store document types used for drop down list.
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EXCLUDE.DOCUMENT_TYPE.3', 'META_CONCEPT_SOURCE', 
       'Must exist in SBR.DOCUMENT_TYPES_LOV table');

--Store document types used for drop down list.
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EXCLUDE.DOCUMENT_TYPE.4', 'Owning Document Text', 
       'Must exist in SBR.DOCUMENT_TYPES_LOV table');

--Store document types used for drop down list.
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EXCLUDE.DOCUMENT_TYPE.5', 'Preferred Question Text', 
       'Must exist in SBR.DOCUMENT_TYPES_LOV table');

--Store document types used for drop down list.
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EXCLUDE.DOCUMENT_TYPE.6', 'Service Context Property', 
       'Must exist in SBR.DOCUMENT_TYPES_LOV table');

--Store document types used for drop down list.
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EXCLUDE.DOCUMENT_TYPE.7', 'Standard Question Text', 
       'Must exist in SBR.DOCUMENT_TYPES_LOV table');

--Store document types used for drop down list.
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EXCLUDE.DOCUMENT_TYPE.8', 'TECHNICAL GUIDE', 
       'Must exist in SBR.DOCUMENT_TYPES_LOV table');

--Store document types used for drop down list.
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EXCLUDE.DOCUMENT_TYPE.9', 'UML Attribute', 
       'Must exist in SBR.DOCUMENT_TYPES_LOV table');

--Store document types used for drop down list.
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EXCLUDE.DOCUMENT_TYPE.10', 'UML Class', 
       'Must exist in SBR.DOCUMENT_TYPES_LOV table');

--Store document types used for drop down list.
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EXCLUDE.DOCUMENT_TYPE.11', 'VD REFERENCE', 
       'Must exist in SBR.DOCUMENT_TYPES_LOV table');

	   
	   
	   

--Store document types used for drop down list.  --------DESIGNATION TYPE / alt types ----------
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EXCLUDE.DESIGNATION_TYPE.1', 'USED_BY', 
	   'Must exist in SBR.DESIGNATION_TYPES_LOV table');


	   
	   

--Store derivation types used for drop down list.           -------COMPLEX or Derivation Type -------
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'INCLUDE.DERIVATION_TYPE.1', 'CALCULATED', 
	   'Must exist in SBR.COMPLEX_REP_TYPE_LOV table');

--Store derivation types used for drop down list.     
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'INCLUDE.DERIVATION_TYPE.2', 'COMPOUND', 
	   'Must exist in SBR.COMPLEX_REP_TYPE_LOV table');

--Store derivation types used for drop down list.
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'INCLUDE.DERIVATION_TYPE.3', 'CONCATENATION', 
	   'Must exist in SBR.COMPLEX_REP_TYPE_LOV table');

--Store derivation types used for drop down list.
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'INCLUDE.DERIVATION_TYPE.4', 'Simple Concept', 
	   'Must exist in SBR.COMPLEX_REP_TYPE_LOV table');

	   
--Ref doc file cache for uploading blobs from the DB to the web server to create url.	   
insert into sbrext.tool_options_view_ext (tool_name, property, value, description)
values ('CURATION', 'REFDOC_FILECACHE', '/local/content/cdecurate/filecache/',
'Ref doc file cache for uploading blobs from the DB to the web server to create url.');


--Ref doc file url. This is the prefix url for building the file anchor tag for files uploaded to the file cache.
insert into sbrext.tool_options_view_ext (tool_name, property, value, description)
values ('CURATION', 'REFDOC_FILEURL', 'http://cdecurate.nci.nih.gov/filecache/',
'Ref doc file url. This is the prefix url for building the file anchor tag for files uploaded to the file cache.');  


	   
--Store the integer concepts id for name value pair  
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'NVPCONCEPT.1', 'C45255',
	   'Store the integer concept id for name value pair');
	   

--Store the Ordinal Position concepts id for name value pair  
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'NVPCONCEPT.7', 'C46126',
	   'Store the Ordinal Position concept id for name value pair');

--Store the RELEASED asl name to include in the filter  
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'INCLUDE.ASL.FILTER.1', 'RELEASED',
	   'Store the RELEASED asl name to include in the filter');


merge into sbrext.tool_options_view_ext s
using (
select 'EVS' as tool_name, 'NEWTERM.URL' as property, 'http://ncimeta.nci.nih.gov/MetaServlet/FormalizationFailedServlet' as value, 'The EVS URL to suggest a new term in a vocabulary.' as description from dual) t
on (s.tool_name = t.tool_name and s.property = t.property)
when matched then update set s.value = t.value, s.description = t.description
when not matched then insert (tool_name, property, value, description) values (t.tool_name, t.property, t.value, t.description);


--commit changes
commit;

