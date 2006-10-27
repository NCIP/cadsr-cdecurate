/* Copyright ScenPro, Inc, 2005

   $Header: /cvsshare/content/cvsroot/cdecurate/conf/dev/load_tool_options_3_2.sql,v 1.1 2006-10-27 15:04:04 hegdes Exp $
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


--commit changes
commit;


