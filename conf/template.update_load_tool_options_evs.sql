/* Copyright ScenPro, Inc, 2005

   $Header: /cvsshare/content/cvsroot/cdecurate/conf/template.update_load_tool_options_evs.sql,v 1.1 2007-09-10 14:45:22 hebell Exp $
   $Name: not supported by cvs2svn $

   Author: Anupama Chickerur

   This script updates the Tool Options table with EVS related required and optional values
   for the Curation Tool.

   Each is described briefly below. A full description of each can be found in
   the Curation Tool Installation Guide (file:distrib/doc/Installation Guide.doc). 
   These values must be reviewed and changed as needed per the local installation 
   and database instance.  If required values are missing or something is miscoded 
   or invalid appropriate error messages are displayed via the Curation Tool Login page.
*/
--This guarantees any error will rollback the changes and exits the script so it can be trapped 
--during a build.
whenever sqlerror exit sql.sqlcode rollback;

--Update vocab meta source for the NCI Thesaurus vocabulary
UPDATE sbrext.tool_options_view_ext
SET value = '@EVS.VOCAB.1.METASOURCE@'
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.1.METASOURCE';

--Update vocab meta source for the GO vocabulary
UPDATE sbrext.tool_options_view_ext
SET value = '@EVS.VOCAB.2.METASOURCE@'
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.2.METASOURCE';
	   
--Update vocab meta source for the VA_NDFRT vocabulary
UPDATE sbrext.tool_options_view_ext
SET value = '@EVS.VOCAB.3.METASOURCE@'
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.3.METASOURCE';
	   
--Update vocab meta source for the LOINC vocabulary
UPDATE sbrext.tool_options_view_ext
SET value = '@EVS.VOCAB.4.METASOURCE@'
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.4.METASOURCE';
	   
--Update vocab meta source for the MGED vocabulary
UPDATE sbrext.tool_options_view_ext
SET value = '@EVS.VOCAB.5.METASOURCE@'
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.5.METASOURCE';
	   
--Update vocab meta source for the MedDRA vocabulary
UPDATE sbrext.tool_options_view_ext
SET value = '@EVS.VOCAB.6.METASOURCE@'
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.6.METASOURCE';
	   
--Update vocab meta source for the SNOMED vocabulary
UPDATE sbrext.tool_options_view_ext
SET value = '@EVS.VOCAB.7.METASOURCE@'
WHERE tool_name = 'CURATION' AND property = 'EVS.VOCAB.7.METASOURCE';
	   
--DEF SOURCE ATTRIBUTES

--Update NCI def source to filter out the multiple definition used
UPDATE sbrext.tool_options_view_ext
SET value = '@EVS.DEFSOURCE.1@'
WHERE tool_name = 'CURATION' AND property = 'EVS.DEFSOURCE.1';
 
--Update NCI def source to filter out the multiple definition used
UPDATE sbrext.tool_options_view_ext
SET value = '@EVS.DEFSOURCE.2@'
WHERE tool_name = 'CURATION' AND property = 'EVS.DEFSOURCE.2';
 
 --Update NCI def source to filter out the multiple definition used
UPDATE sbrext.tool_options_view_ext
SET value = '@EVS.DEFSOURCE.3@'
WHERE tool_name = 'CURATION' AND property = 'EVS.DEFSOURCE.3';

--Update NCI def source to filter out the multiple definition used
UPDATE sbrext.tool_options_view_ext
SET value = '@EVS.DEFSOURCE.4@'
WHERE tool_name = 'CURATION' AND property = 'EVS.DEFSOURCE.4';
 
--Update NCI Thesaurus source to get its source code used in replacing concept with preferred vocab (Thesaurus)
UPDATE sbrext.tool_options_view_ext
SET value = '@EVS.PREFERREDVOCAB.SOURCE@'
WHERE tool_name = 'CURATION' AND property = 'EVS.PREFERREDVOCAB.SOURCE';

--commit the settings
commit;
