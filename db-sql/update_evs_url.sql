/* COPYRIGHT SCENPRO, INC, 2007

   $Header: /cvsshare/content/cvsroot/cdecurate/db-sql/update_evs_url.sql,v 1.3 2009-04-20 12:49:22 hebell Exp $
   $Name: not supported by cvs2svn $
*/

--This guarantees any error will rollback the changes and exits the script so it can be trapped 
--during a build.
whenever sqlerror exit sql.sqlcode rollback;

MERGE INTO SBREXT.TOOL_OPTIONS_VIEW_EXT S USING (

--Store evs  url specific to curation tool if needed. 

SELECT 'EVS' AS TOOL_NAME, 'URL' AS PROPERTY, 'http://lexevsapi.nci.nih.gov/lexevsapi42' AS VALUE, 'Store evs alternate url specific to curation tool if needed' AS DESCRIPTION FROM DUAL
UNION
SELECT 'CURATION' AS TOOL_NAME, 'EVS.URL' AS PROPERTY, 'http://lexevsapi.nci.nih.gov/lexevsapi42' AS VALUE, 'Store evs alternate url specific to curation tool if needed' AS DESCRIPTION FROM DUAL
)T 
ON (S.TOOL_NAME = T.TOOL_NAME AND S.PROPERTY = T.PROPERTY) 
WHEN MATCHED THEN 
 UPDATE SET S.DESCRIPTION = T.DESCRIPTION 
WHEN NOT MATCHED THEN INSERT (TOOL_NAME, PROPERTY, VALUE, DESCRIPTION) VALUES (T.TOOL_NAME, T.PROPERTY, T.VALUE, T.DESCRIPTION);

--commit the updates 
COMMIT;
