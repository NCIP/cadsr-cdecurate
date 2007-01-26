/* Copyright ScenPro, Inc, 2005

   $Header: /cvsshare/content/cvsroot/cdecurate/conf/sandbox/update_load_tool_options_evs.sql,v 1.22 2007-01-26 05:20:40 hegdes Exp $
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
SET value = 'NCI2006_01C'
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.1.METASOURCE';

--Update vocab meta source for the GO vocabulary
UPDATE sbrext.tool_options_view_ext
SET value = 'GO2004_03_02'
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.2.METASOURCE';
	   
--Update vocab meta source for the VA_NDFRT vocabulary
UPDATE sbrext.tool_options_view_ext
SET value = 'NDFRT_2004_01'
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.3.METASOURCE';
	   
--Update vocab meta source for the LOINC vocabulary
UPDATE sbrext.tool_options_view_ext
SET value = 'LNC213'
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.4.METASOURCE';
	   
--Update vocab meta source for the MGED vocabulary
UPDATE sbrext.tool_options_view_ext
SET value = ''
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.5.METASOURCE';
	   
--Update vocab meta source for the MedDRA vocabulary
UPDATE sbrext.tool_options_view_ext
SET value = 'MDR-60'
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.6.METASOURCE';
	   
--Update vocab meta source for the SNOMED vocabulary
UPDATE sbrext.tool_options_view_ext
SET value = 'SNOMEDCT_2004_01_31'
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.7.METASOURCE';

	   
--DEF SOURCE ATTRIBUTES
--Update NCI def source to filter out the multiple definition used
UPDATE sbrext.tool_options_view_ext
SET value = 'NCI'
WHERE tool_name = 'CURATION' AND property = 'EVS.DEFSOURCE.1';

--Update NCI def source to filter out the multiple definition used
UPDATE sbrext.tool_options_view_ext
SET value = 'NCI-GLOSS_0601C'
WHERE tool_name = 'CURATION' AND property = 'EVS.DEFSOURCE.2';
 
 --Update NCI def source to filter out the multiple definition used
UPDATE sbrext.tool_options_view_ext
SET value = 'NCI2006_01C'
WHERE tool_name = 'CURATION' AND property = 'EVS.DEFSOURCE.3';

--Update NCI def source to filter out the multiple definition used
UPDATE sbrext.tool_options_view_ext
SET value = 'NCICB'
WHERE tool_name = 'CURATION' AND property = 'EVS.DEFSOURCE.4';


--Update NCI Thesaurus source to get its source code used in replacing concept with preferred vocab (Thesaurus)
/*UPDATE sbrext.tool_options_view_ext
SET value = 'NCI2006_01C'
WHERE tool_name = 'CURATION' AND property = 'EVS.PREFERREDVOCAB.SOURCE';*/

--commit the settings
commit;
