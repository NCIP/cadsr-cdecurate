/* Copyright ScenPro, Inc, 2005

   $Header: /cvsshare/content/cvsroot/cdecurate/conf/qa/update_load_tool_options_evs.sql,v 1.8 2006-11-01 20:41:39 hegdes Exp $
   $Name: not supported by cvs2svn $

   Author: Sumana Hegde

   This script updates the Tool Options table with EVS related required and optional values
   for the Curation Tool.

   Each is described briefly below. A full description of each can be found in
   the Curation Tool Installation Guide (file:distrib/doc/Installation Guide.doc). 
   These values must be reviewed and changed as needed per the local installation 
   and database instance.  If required values are missing or something is miscoded 
   or invalid appropriate error messages are displayed via the Curation Tool Login page.
*/

--Update vocab meta source for the NCI Thesaurus vocabulary
UPDATE sbrext.tool_options_view_ext
SET value = 'NCI2006_03D'
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.1.METASOURCE';
	   
--Update vocab meta source for the LOINC vocabulary
UPDATE sbrext.tool_options_view_ext
SET value = 'LNC215'
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.4.METASOURCE';
	   	   
--Update vocab meta source for the SNOMED vocabulary
UPDATE sbrext.tool_options_view_ext
SET value = 'SNOMEDCT_2005_07_31'
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.7.METASOURCE';

	   
--DEF SOURCE ATTRIBUTES
--Update NCI def source to filter out the multiple definition used
UPDATE sbrext.tool_options_view_ext
SET value = 'NCI'
WHERE tool_name = 'CURATION' AND property = 'EVS.DEFSOURCE.1';

--Update NCI def source to filter out the multiple definition used
UPDATE sbrext.tool_options_view_ext
SET value = 'NCI-GLOSS'
WHERE tool_name = 'CURATION' AND property = 'EVS.DEFSOURCE.2';
 
 --Update NCI def source to filter out the multiple definition used
UPDATE sbrext.tool_options_view_ext
SET value = 'NCICB'
WHERE tool_name = 'CURATION' AND property = 'EVS.DEFSOURCE.3';

--Update NCI def source to filter out the multiple definition used
UPDATE sbrext.tool_options_view_ext
SET value = 'NCI2006_03D'
WHERE tool_name = 'CURATION' AND property = 'EVS.DEFSOURCE.4';


--Update NCI Thesaurus source to get its source code used in replacing concept with preferred vocab (Thesaurus)
UPDATE sbrext.tool_options_view_ext
SET value = 'NCI2006_03D'
WHERE tool_name = 'CURATION' AND property = 'EVS.PREFERREDVOCAB.SOURCE';

--commit the settings
commit;
