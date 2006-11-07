/* Copyright ScenPro, Inc, 2005

   $Header: /cvsshare/content/cvsroot/cdecurate/conf/dev/load_tool_options_3_2.sql,v 1.10 2006-11-07 16:39:04 hegdes Exp $
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

--Update value of derivation property to include order number
UPDATE sbrext.tool_options_view_ext
SET property = 'DERIVATION_TYPE.1'
WHERE tool_name = 'CURATION' AND property = 'DERIVATION_TYPE' AND value = 'CALCULATED';



--commit changes
commit;


