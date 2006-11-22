/* Copyright ScenPro, Inc, 2005

   $Header: /cvsshare/content/cvsroot/cdecurate/conf/prod/load_tool_options_3_1_0_1.sql,v 1.22 2006-11-22 21:12:40 hegdes Exp $
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


	   
--Store NCI Thesaurus name to get the name of preferred vocabulary when getting thesarurs concept 
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.PREFERREDVOCAB', 'NCI_Thesaurus',
	   'Store NCI Thesaurus name to get the name of preferred vocabulary when getting thesarurs concept');
	   
--Store NCI Thesaurus source to get its source code used in replacing concept with preferred vocab (Thesaurus)
INSERT INTO sbrext.tool_options_view_ext (tool_name, property, value, description)
VALUES ('CURATION', 'EVS.PREFERREDVOCAB.SOURCE', 'NCI2006_01C',
	   'Store NCI Thesaurus source to get its source code used in replacing concept with preferred vocab (Thesaurus)');


--commit changes
commit;


