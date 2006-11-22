/* Copyright ScenPro, Inc, 2005

   $Header: /cvsshare/content/cvsroot/cdecurate/conf/dev/load_tool_options_3_2.sql,v 1.20 2006-11-22 21:12:40 hegdes Exp $
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


	   
--Store the integer concepts id for name value pair  
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'NVPCONCEPT.1', 'C45255',
	   'Store the integer concept id for name value pair');
	   
--Store the range concepts id for name value pair  
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'NVPCONCEPT.2', 'C38013',
	   'Store the range concept id for name value pair');

--Store the greater than concepts id for name value pair  
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'NVPCONCEPT.3', 'C61584',
	   'Store the greater than concept id for name value pair');

--Store the greater than or equal concepts id for name value pair  
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'NVPCONCEPT.4', 'C61583',
	   'Store the greater than or equal concept id for name value pair');

--Store the less than or equal concepts id for name value pair  
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'NVPCONCEPT.5', 'C61586',
	   'Store the less than or equal concept id for name value pair');

--Store the less than concepts id for name value pair  
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'NVPCONCEPT.6', 'C61585',
	   'Store the less than concept id for name value pair');


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

--Modify the following rows from thesaurus search

--delete include meta search property
DELETE sbrext.tool_options_view_ext
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.1.INCLUDEMETA';


--delete SEARCH_IN.METACODE  property
DELETE sbrext.tool_options_view_ext
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.1.SEARCH_IN.METACODE';

--Update display name for thesaurus
UPDATE sbrext.tool_options_view_ext
SET value = 'NCI Thesaurus'
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.1.DISPLAY';


--Store Tree Search filter for all vocabulary
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.VOCAB.ALL.TREESEARCH', 'true', 
	   'Store vocab Tree Search filter for all vocabulary');

--fix display name for snowmed
UPDATE sbrext.tool_options_view_ext
SET property = 'EVS.VOCAB.7.DISPLAY' 
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.6.DISPLAY' AND value = 'SNOMED';


--Update value of derivation property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DERIVATION_TYPE.1'
WHERE tool_name = 'CURATION' AND property = 'DERIVATION_TYPE' AND value = 'CALCULATED';

--Update value of derivation property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DERIVATION_TYPE.2'
WHERE tool_name = 'CURATION' AND property = 'DERIVATION_TYPE' AND value = 'COMPOUND';

--Update value of derivation property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DERIVATION_TYPE.3'
WHERE tool_name = 'CURATION' AND property = 'DERIVATION_TYPE' AND value = 'CONCATENATION';

--Update value of derivation property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DERIVATION_TYPE.4'
WHERE tool_name = 'CURATION' AND property = 'DERIVATION_TYPE' AND value = 'Simple Concept';

--Update value of designation type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DESIGNATION_TYPE.1'
WHERE tool_name = 'CURATION' AND property = 'DESIGNATION_TYPE' AND value = 'ABBREVIATION';

--Update value of designation type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DESIGNATION_TYPE.2'
WHERE tool_name = 'CURATION' AND property = 'DESIGNATION_TYPE' AND value = 'C3D Name';

--Update value of designation type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DESIGNATION_TYPE.3'
WHERE tool_name = 'CURATION' AND property = 'DESIGNATION_TYPE' AND value = 'C3PR Name';

--Update value of designation type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DESIGNATION_TYPE.4'
WHERE tool_name = 'CURATION' AND property = 'DESIGNATION_TYPE' AND value = 'CONTEXT NAME';

--Update value of designation type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DESIGNATION_TYPE.5'
WHERE tool_name = 'CURATION' AND property = 'DESIGNATION_TYPE' AND value = 'CRITERION_NAME';

--Update value of designation type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DESIGNATION_TYPE.6'
WHERE tool_name = 'CURATION' AND property = 'DESIGNATION_TYPE' AND value = 'Context Short Name';

--Update value of designation type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DESIGNATION_TYPE.7'
WHERE tool_name = 'CURATION' AND property = 'DESIGNATION_TYPE' AND value = 'New Designation';

--Update value of designation type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DESIGNATION_TYPE.8'
WHERE tool_name = 'CURATION' AND property = 'DESIGNATION_TYPE' AND value = 'Prior Preferred Name';

--Update value of DOCUMENT type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DOCUMENT_TYPE.1'
WHERE tool_name = 'CURATION' AND property = 'DOCUMENT_TYPE' AND value = 'Alternate Question Text';

--Update value of DOCUMENT type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DOCUMENT_TYPE.2'
WHERE tool_name = 'CURATION' AND property = 'DOCUMENT_TYPE' AND value = 'Associations';

--Update value of DOCUMENT type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DOCUMENT_TYPE.3'
WHERE tool_name = 'CURATION' AND property = 'DOCUMENT_TYPE' AND value = 'COMMENT';

--Update value of DOCUMENT type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DOCUMENT_TYPE.4'
WHERE tool_name = 'CURATION' AND property = 'DOCUMENT_TYPE' AND value = 'DATA_ELEMENT_SOURCE';

--Update value of DOCUMENT type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DOCUMENT_TYPE.5'
WHERE tool_name = 'CURATION' AND property = 'DOCUMENT_TYPE' AND value = 'DESCRIPTION';

--Update value of DOCUMENT type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DOCUMENT_TYPE.6'
WHERE tool_name = 'CURATION' AND property = 'DOCUMENT_TYPE' AND value = 'DETAIL_DESCRIPTION';

--Update value of DOCUMENT type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DOCUMENT_TYPE.7'
WHERE tool_name = 'CURATION' AND property = 'DOCUMENT_TYPE' AND value = 'EXAMPLE';

--Update value of DOCUMENT type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DOCUMENT_TYPE.8'
WHERE tool_name = 'CURATION' AND property = 'DOCUMENT_TYPE' AND value = 'HISTORIC SHORT CDE NAME';

--Update value of DOCUMENT type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DOCUMENT_TYPE.9'
WHERE tool_name = 'CURATION' AND property = 'DOCUMENT_TYPE' AND value = 'IMAGE_FILE';

--Update value of DOCUMENT type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DOCUMENT_TYPE.10'
WHERE tool_name = 'CURATION' AND property = 'DOCUMENT_TYPE' AND value = 'LABEL';

--Update value of DOCUMENT type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DOCUMENT_TYPE.11'
WHERE tool_name = 'CURATION' AND property = 'DOCUMENT_TYPE' AND value = 'NOTE';

--Update value of DOCUMENT type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DOCUMENT_TYPE.12'
WHERE tool_name = 'CURATION' AND property = 'DOCUMENT_TYPE' AND value = 'PDF';

--Update value of DOCUMENT type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DOCUMENT_TYPE.13'
WHERE tool_name = 'CURATION' AND property = 'DOCUMENT_TYPE' AND value = 'REFERENCE';

--Update value of DOCUMENT type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DOCUMENT_TYPE.14'
WHERE tool_name = 'CURATION' AND property = 'DOCUMENT_TYPE' AND value = 'Scope Document';

--Update value of DOCUMENT type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DOCUMENT_TYPE.15'
WHERE tool_name = 'CURATION' AND property = 'DOCUMENT_TYPE' AND value = 'Source';

--Update value of DOCUMENT type property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DOCUMENT_TYPE.16'
WHERE tool_name = 'CURATION' AND property = 'DOCUMENT_TYPE' AND value = 'VALID_VALUE_SOURCE';


--commit changes
commit;


