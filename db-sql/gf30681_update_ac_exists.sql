-- run this as SBREXT user
/*
 * Fix related to issue https://gforge.nci.nih.gov/tracker/index.php?func=detail&aid=30681.
 */
CREATE OR REPLACE FUNCTION AC_EXISTS(P_PREFERRED_NAME IN VARCHAR2
                  ,P_CONTE_IDSEQ IN CHAR
                  ,P_VERSION IN NUMBER
                  ,P_ACTL_NAME IN VARCHAR2)RETURN  BOOLEAN IS
/******************************************************************************
   NAME:       AC_EXISTS
   PURPOSE:    Check to see if administered component exists based on preferred name context and version

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal     1. Created this function
   1.1        1/22/2013   JT                  2. Remove check on context

******************************************************************************/
v_count  NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM ADMIN_COMPONENTS_VIEW
WHERE preferred_name = P_PREFERRED_NAME
--  AND conte_idseq= P_CONTE_IDSEQ
AND version = P_VERSION
AND actl_name = P_ACTL_NAME
AND deleted_ind = 'No';

IF(v_count = 1) THEN
  RETURN  TRUE;
ELSE
  RETURN  FALSE;
END IF;
END AC_EXISTS;
/
