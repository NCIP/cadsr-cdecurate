/* Copyright ScenPro, Inc, 2005

   $Header: /cvsshare/content/cvsroot/cdecurate/conf/osi/update_tool_options_url.sql,v 1.29 2007-01-26 05:20:40 hegdes Exp $
   $Name: not supported by cvs2svn $

   Author: Sumana Hegde

   This script updates the Tool Options table with required and optional values of 
   the URL related for the Curation Tool. Please run load_tool_options.sql (without url values) 
   before running this script.

   Each is described briefly below. A full description of each can be found in
   the Curation Tool Installation Guide (file:../doc/Installation Guide.doc). 
   These values must be reviewed and changed as needed per the local installation 
   and database instance.  If required values are missing or something is miscoded 
   or invalid appropriate error messages are displayed via the Curation Tool Login page.
*/


--Store evs url for all tools: need to make sure it doesn't exists already before runnning.
UPDATE sbrext.tool_options_view_ext 
SET value = 'http://cabio.nci.nih.gov/cacore31/http/remoteService'
WHERE tool_name = 'EVS' AND property = 'URL'; 

--Store browser url for all tools: need to make sure it doesn't exists already before runnning.
UPDATE sbrext.tool_options_view_ext 
SET value = 'http://cdebrowser.company.com'
WHERE tool_name = 'BROWSER' AND property = 'URL'; 

--Store url for curation tool if needed.
UPDATE sbrext.tool_options_view_ext 
SET value = 'http://cdecurate.company.com'
WHERE tool_name = 'CURATION' AND property = 'URL'; 

--Store evs alternate url specific to curation tool if needed.
UPDATE sbrext.tool_options_view_ext 
SET value = 'http://cabio.nci.nih.gov/cacore31/http/remoteService'
WHERE tool_name = 'CURATION' AND property = 'EVS.URL'; 

--Ref doc file url. This is the prefix url for building the file anchor tag for files uploaded to the file cache.	   
UPDATE sbrext.tool_options_view_ext 
SET value = 'http://cdecurate.company.com/filecache/'
WHERE tool_name = 'CURATION' AND property = 'REFDOC_FILEURL'; 
  

--commit the updates
commit;
