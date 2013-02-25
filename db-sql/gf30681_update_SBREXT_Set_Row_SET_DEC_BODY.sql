-- run this as SBREXT user
/*
 * Fix related to issue https://gforge.nci.nih.gov/tracker/index.php?func=detail&aid=30681.
 */
CREATE OR REPLACE PACKAGE BODY DEC_ACTIONS AS  -- body
 
PROCEDURE SET_DEC(
P_UA_NAME          IN VARCHAR2
,P_RETURN_CODE        OUT    VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_DEC_DEC_IDSEQ         IN OUT VARCHAR2
,P_DEC_PREFERRED_NAME     IN OUT VARCHAR2
,P_DEC_CONTE_IDSEQ         IN OUT VARCHAR2
,P_DEC_VERSION             IN OUT NUMBER
,P_DEC_PREFERRED_DEFINITION IN OUT VARCHAR2
,P_DEC_CD_IDSEQ             IN OUT VARCHAR2
,P_DEC_ASL_NAME             IN OUT VARCHAR2
,P_DEC_LATEST_VERSION_IND   IN OUT VARCHAR2
,P_DEC_LONG_NAME         IN OUT VARCHAR2
,P_DEC_OC_IDSEQ             IN OUT VARCHAR2
,P_DEC_PROP_IDSEQ           IN OUT VARCHAR2
,P_DEC_PROPERTY_QUALIFIER IN OUT VARCHAR2
,P_DEC_OBJ_CLASS_QUALIFIER IN OUT VARCHAR2
,P_DEC_BEGIN_DATE         IN OUT VARCHAR2
,P_DEC_END_DATE             IN OUT VARCHAR2
,P_DEC_CHANGE_NOTE         IN OUT VARCHAR2
,P_DEC_CREATED_BY         OUT    VARCHAR2
,P_DEC_DATE_CREATED         OUT    VARCHAR2
,P_DEC_MODIFIED_BY         OUT    VARCHAR2
,P_DEC_DATE_MODIFIED     OUT    VARCHAR2
,P_DEC_DELETED_IND         OUT    VARCHAR2
,P_DEC_ORIGIN               IN     VARCHAR2 DEFAULT NULL 
,P_DEC_CDR_NAME               IN     VARCHAR2	--GF30681
)  IS -- 15-Jul-2003, W. Ver Hoef
/******************************************************************************
   NAME:       SET_DEC
   PURPOSE:    Inserts or Updates a Single Row Of Data Element Concept Based on either
               DEC_IDSEQ or Preferred Name, Context and Version

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal  1. Created this procedure
   2.0        07/15/2003  W. Ver Hoef      1. added parameter for origin and code
                                              also for dec_id
             2. fixed proper setting of p_dec_dec_idseq
                out parameter
             3. added "is not null" condition for
                validation of optional parameters
   2.1        03/19/2004  W. Ver Hoef      1. substituted UNASSIGNED with function
                                              call to get_default_asl

******************************************************************************/

  v_version     data_element_concepts_view.version%TYPE;
  v_ac          data_element_concepts_view.dec_idseq%TYPE;
  v_begin_date  DATE    := NULL;
  v_end_date    DATE    := NULL;
  v_new_version BOOLEAN := FALSE;
  v_dec_idseq   VARCHAR2(36);

  v_dec_rec     cg$data_element_concepts_view.cg$row_type;
  v_dec_ind     cg$data_element_concepts_view.cg$ind_type;
  v_asl_name    data_element_concepts_view.asl_name%TYPE;
  v_cdr_name    data_element_concepts_view.cdr_name%TYPE;

BEGIN

  P_RETURN_CODE := NULL;

  IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
    P_RETURN_CODE := 'API_DEC_700'; -- Invalid action
    RETURN;
  END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  IF P_ACTION = 'INS' THEN             --we are inserting a record
    IF P_DEC_DEC_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_DEC_100' ;  --for inserts the ID is generated
      RETURN;
    ELSE
      --Check to see that all mandatory parameters are either not NULL or have a default value.
   IF P_DEC_PREFERRED_NAME IS NULL THEN
     P_RETURN_CODE := 'API_DEC_101';  --Preferred Name cannot be null here
  RETURN;
      END IF;
   IF P_DEC_CONTE_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_DEC_102'; --CONTE_IDSEQ cannot be null here
  RETURN;
   END IF;
   IF P_DEC_PREFERRED_DEFINITION IS NULL THEN
     P_RETURN_CODE := 'API_DEC_103'; --Preferred Definition cannot be null here
  RETURN;
   END IF;
   IF P_DEC_ASL_NAME IS NULL THEN
     -- 19-Mar-2004, W. Ver Hoef - substituted UNASSIGNED with the function call below
     P_DEC_ASL_NAME := Sbrext_Common_Routines.get_default_asl('INS'); -- 'UNASSIGNED';
   END IF;
   IF P_DEC_VERSION IS NULL THEN
     P_DEC_VERSION := Sbrext_Common_Routines.get_ac_version(P_DEC_PREFERRED_NAME,P_DEC_CONTE_IDSEQ,'DE_CONCEPT','HIGHEST') + 1;
   END IF;
   IF P_DEC_CD_IDSEQ IS NULL THEN
     P_DEC_CD_IDSEQ := Sbrext_Common_Routines.get_cd(P_DEC_CONTE_IDSEQ);
  IF P_DEC_CD_IDSEQ IS NULL THEN
       P_RETURN_CODE := 'API_DEC_104'; --default CD_IDSEQ not found
    RETURN;
  END IF;
   END IF;
   IF P_DEC_LATEST_VERSION_IND IS NULL THEN
     P_DEC_LATEST_VERSION_IND := 'No';
   END IF;
    END IF;
  END IF;

  IF P_ACTION = 'UPD' THEN              --we are updating a record
   admin_security_util.seteffectiveuser(p_ua_name);
    IF P_DEC_DEC_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_DEC_400' ;  --for updates the ID IS mandatory
   RETURN;
    END IF;
    SELECT asl_name INTO v_asl_name
    FROM data_element_concepts_view
    WHERE dec_idseq = p_dec_dec_idseq;
    IF (P_DEC_PREFERRED_NAME IS NOT NULL OR P_DEC_CONTE_IDSEQ IS NOT NULL )AND v_asl_name = 'RELEASED' THEN
      P_RETURN_CODE := 'API_DEC_401' ;  --Preferred Name or Context Can not be updated
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(P_DEC_DEC_IDSEQ) THEN
      P_RETURN_CODE := 'API_DEC_005'; --DEC  not ound
      RETURN;
    END IF;
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are logically deleteing a record
    IF P_DEC_DEC_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_DEC_400' ;  --for deletes the ID IS mandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ac_exists(P_DEC_DEC_IDSEQ) THEN
     P_RETURN_CODE := 'API_DEC_005'; --Data Element Concepts not found
     RETURN;
      END IF;
    END IF;
    P_DEC_DELETED_IND       := 'Yes';
    P_DEC_MODIFIED_BY       := P_UA_NAME; --USER;
    P_DEC_DATE_MODIFIED     := TO_CHAR(SYSDATE);
    v_dec_rec.dec_idseq     := P_DEC_DEC_IDSEQ;
    v_dec_rec.deleted_ind   := P_DEC_DELETED_IND;
    v_dec_rec.modified_by   := P_DEC_MODIFIED_BY;
    v_dec_rec.date_modified := TO_DATE(P_DEC_DATE_MODIFIED);

    v_dec_ind.dec_idseq            := TRUE;
    v_dec_ind.preferred_name    := FALSE;
    v_dec_ind.conte_idseq        := FALSE;
    v_dec_ind.version            := FALSE;
    v_dec_ind.preferred_definition := FALSE;
    v_dec_ind.long_name            := FALSE;
    v_dec_ind.asl_name            := FALSE;
    v_dec_ind.cd_idseq            := FALSE;
    v_dec_ind.latest_version_ind   := FALSE;
    v_dec_ind.propl_name         := FALSE;
    v_dec_ind.ocl_name             := FALSE;
    v_dec_ind.property_qualifier   := FALSE;
    v_dec_ind.obj_class_qualifier  := FALSE;
    v_dec_ind.begin_date        := FALSE;
    v_dec_ind.end_date            := FALSE;
    v_dec_ind.change_note        := FALSE;
    v_dec_ind.created_by        := FALSE;
    v_dec_ind.date_created        := FALSE;
    v_dec_ind.oc_idseq             := FALSE;
    v_dec_ind.prop_idseq           := FALSE;
    v_dec_ind.modified_by        := TRUE;
    v_dec_ind.date_modified        := TRUE;
    v_dec_ind.deleted_ind          := TRUE;
 v_dec_ind.dec_id               := FALSE;  -- 15-Jul-2003, W. Ver Hoef
 v_dec_ind.origin               := FALSE;
 v_dec_ind.cdr_name               := FALSE; -- GF30681
    BEGIN
      cg$data_element_concepts_view.upd(v_dec_rec,v_dec_ind);
      RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_DEC_502'; --Error deleting Data Element Concepts
   RETURN;
    END;

  END IF;

  IF P_DEC_LATEST_VERSION_IND IS NOT NULL THEN
    IF P_DEC_LATEST_VERSION_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_DEC_105'; --Version can only be 'Yes' or 'No'
      RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
  IF LENGTH(P_DEC_PREFERRED_NAME) > Sbrext_Column_Lengths.L_DEC_PREFERRED_NAME THEN
    P_RETURN_CODE := 'API_DEC_111';  --Length of preferred_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_DEC_PREFERRED_DEFINITION) > Sbrext_Column_Lengths.L_DEC_PREFERRED_DEFINITION THEN
    P_RETURN_CODE := 'API_DEC_113';  --Length of Preferred_definition exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_DEC_LONG_NAME) > Sbrext_Column_Lengths.L_DEC_LONG_NAME THEN
    P_RETURN_CODE := 'API_DEC_114'; --Length of Long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_DEC_ASL_NAME) > Sbrext_Column_Lengths.L_DEC_ASL_NAME  THEN
    P_RETURN_CODE := 'API_DEC_115'; --Length of asl_name exceeds maximum length
    RETURN;
  END IF;

  /*IF LENGTH(P_DEC_OCL_NAME) > Sbrext_Column_Lengths.L_DEC_OCL_NAME THEN
    P_RETURN_CODE := 'API_DEC_118';  --Length of Object Class exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_DEC_PROPL_NAME) > Sbrext_Column_Lengths.L_DEC_PROPL_NAME THEN
    P_RETURN_CODE := 'API_DEC_119';  --Length of Property exceeds maximum length
    RETURN;
  END IF;*/
  IF LENGTH(P_DEC_PROPERTY_QUALIFIER) > Sbrext_Column_Lengths.L_DEC_PROPERTY_QUALIFIER THEN
    P_RETURN_CODE := 'API_DEC_120';  --Length of Property qualifier exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_DEC_OBJ_CLASS_QUALIFIER) > Sbrext_Column_Lengths.L_DEC_OBJ_CLASS_QUALIFIER THEN
    P_RETURN_CODE := 'API_DEC_121';  --Length of Object Class qualifier exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_DEC_CHANGE_NOTE) > Sbrext_Column_Lengths.L_DEC_CHANGE_NOTE THEN
    P_RETURN_CODE := 'API_DEC_128'; --Length of change_note exceeds maximum length
    RETURN;
  END IF;

  --check to see that charachter strings are valid
  IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_DEC_PREFERRED_NAME)
  AND P_DEC_PREFERRED_NAME IS NOT NULL THEN
    P_RETURN_CODE := 'API_DEC_130'; -- Data Element Concepts Preferred Name has invalid Ccharacters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_DEC_PREFERRED_DEFINITION)
  AND P_DEC_PREFERRED_DEFINITION IS NOT NULL THEN
    P_RETURN_CODE := 'API_DEC_133'; -- Data Element Concepts Preferred Definition has invalid characters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_DEC_LONG_NAME)
  AND P_DEC_LONG_NAME IS NOT NULL THEN
    P_RETURN_CODE := 'API_DEC_134'; -- Data Element Concepts Long Name has invalid characters
    RETURN;
  END IF;

  --check to see that Context, Workflow Status, Proberty, Object Class, Conceptual Domain already exist in the database
  IF NOT Sbrext_Common_Routines.context_exists(P_DEC_CONTE_IDSEQ) THEN
    IF P_DEC_CONTE_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_DEC_200'; --Context not found in the database
      RETURN;
 END IF;
  END IF;
  IF NOT Sbrext_Common_Routines.ac_exists(P_DEC_CD_IDSEQ) THEN
    IF P_DEC_CD_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_DEC_201'; --Conceptual Domain not found in the database
      RETURN;
 END IF;
  END IF;
  IF NOT Sbrext_Common_Routines.workflow_exists(P_DEC_ASL_NAME) THEN
    IF P_DEC_ASL_NAME IS NOT NULL THEN
      P_RETURN_CODE := 'API_DEC_202'; --Workflow Status not found in the database
      RETURN;
 END IF;
  END IF;
  IF P_DEC_PROP_IDSEQ IS NOT NULL AND P_DEC_PROP_IDSEQ != ' ' THEN
    IF NOT Sbrext_Common_Routines.ac_exists(P_DEC_PROP_IDSEQ) THEN
      P_RETURN_CODE := 'API_DEC_203'; --Proprty not found in the database
      RETURN;
 END IF;
  END IF;
  IF P_DEC_OC_IDSEQ IS NOT NULL  AND  P_DEC_OC_IDSEQ != ' ' THEN
    IF NOT Sbrext_Common_Routines.ac_exists(P_DEC_OC_IDSEQ) THEN
      P_RETURN_CODE := 'API_DEC_204'; --Object Class not found in the database
      RETURN;
 END IF;
  END IF;

  IF P_DEC_PROPERTY_QUALIFIER IS NOT NULL AND P_DEC_PROPERTY_QUALIFIER != ' ' THEN
    IF NOT Sbrext_Common_Routines.qual_exists(P_DEC_PROPERTY_QUALIFIER )  THEN
      P_RETURN_CODE := 'API_DEC_208'; -- Qualifier does not exist
      RETURN;
    END IF;
  END IF;

  IF P_DEC_OBJ_CLASS_QUALIFIER IS NOT NULL AND P_DEC_OBJ_CLASS_QUALIFIER != ' ' THEN
    IF NOT Sbrext_Common_Routines.qual_exists(P_DEC_OBJ_CLASS_QUALIFIER )  THEN
      P_RETURN_CODE := 'API_DEC_208'; --Qualifier does not exist
      RETURN;
    END IF;
  END IF;

  --check to see that begin data and end date are valid dates
  IF(P_DEC_BEGIN_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_DEC_BEGIN_DATE,v_begin_date);
    IF P_RETURN_CODE IS NOT NULL THEN
     P_RETURN_CODE := 'API_DEC_600'; --begin date is invalid
     RETURN;
    END IF;
  END IF;
  IF(P_DEC_END_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_DEC_END_DATE,v_end_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_DEC_601'; --end date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_DEC_BEGIN_DATE IS NOT NULL AND P_DEC_END_DATE IS NOT NULL) THEN
    IF(v_end_date < v_begin_date) THEN
       P_RETURN_CODE := 'API_DEC_210'; --end date is before begin date
       RETURN;
    END IF;
  --ELSIF(P_DEC_END_DATE IS NOT NULL AND P_DEC_BEGIN_DATE IS NULL) THEN
   -- P_RETURN_CODE := 'API_DEC_211'; --begin date cannot be null when end date is null
   -- RETURN;
  END IF;

  IF (P_ACTION = 'INS' ) THEN

    --check to see that  a Data Element Concepts with the same
    --Preferred Name, Context and Version does not already exist
    IF Sbrext_Common_Routines.ac_exists(P_DEC_PREFERRED_NAME,P_DEC_CONTE_IDSEQ ,P_DEC_VERSION,'DE_CONCEPT') THEN
      P_RETURN_CODE := 'API_DEC_300';-- Data Element Concepts already Exists
      RETURN;
    END IF;
    --Check to see if prior versions alresdy exist
    IF Sbrext_Common_Routines.ac_version_exists(P_DEC_PREFERRED_NAME,P_DEC_CONTE_IDSEQ ,'DE_CONCEPT') THEN -- we are creating a new version
      v_new_version := TRUE;
      v_ac          := Sbrext_Common_Routines.get_version_ac(P_DEC_PREFERRED_NAME,P_DEC_CONTE_IDSEQ,'DE_CONCEPT');
    END IF;

 -- 16-Jul-2003, W. Ver Hoef - replace parameter p_dec_dec_idseq with v_dec_idseq varible
    v_dec_idseq         := admincomponent_crud.cmr_guid;
    P_DEC_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_DEC_CREATED_BY    := P_UA_NAME; --USER;
    P_DEC_DATE_MODIFIED := NULL;
    P_DEC_MODIFIED_BY   := NULL;
    P_DEC_DELETED_IND   := 'No';

    v_dec_rec.dec_idseq            := v_dec_idseq; -- 16-Jul-2003, W. Ver Hoef - replaced here too
    v_dec_rec.preferred_name    := P_DEC_PREFERRED_NAME;
    v_dec_rec.conte_idseq        := P_DEC_CONTE_IDSEQ;
    v_dec_rec.version            := P_DEC_VERSION;
    v_dec_rec.preferred_definition := P_DEC_PREFERRED_DEFINITION;
    v_dec_rec.long_name            := P_DEC_LONG_NAME;
    v_dec_rec.asl_name            := P_DEC_ASL_NAME ;
    --v_dec_rec.propl_name           := P_DEC_PROPL_NAME;
    --v_dec_rec.ocl_name             := P_DEC_OCL_NAME;
    v_dec_rec.property_qualifier   := P_DEC_PROPERTY_QUALIFIER;
    v_dec_rec.obj_class_qualifier  := P_DEC_OBJ_CLASS_QUALIFIER;
    v_dec_rec.cd_idseq            := P_DEC_CD_IDSEQ ;
    v_dec_rec.latest_version_ind   := P_DEC_LATEST_VERSION_IND;
    v_dec_rec.begin_date        := TO_DATE(P_DEC_BEGIN_DATE);
    v_dec_rec.end_date            := TO_DATE(P_DEC_END_DATE);
    v_dec_rec.change_note        := P_DEC_CHANGE_NOTE ;
    v_dec_rec.created_by        := P_DEC_CREATED_BY;
    v_dec_rec.date_created        := TO_DATE(P_DEC_DATE_CREATED);
    v_dec_rec.modified_by        := P_DEC_MODIFIED_BY;
    v_dec_rec.date_modified        := TO_DATE(P_DEC_DATE_MODIFIED);
    v_dec_rec.deleted_ind          := P_DEC_DELETED_IND;
    v_dec_rec.oc_idseq             := P_DEC_OC_IDSEQ;
    v_dec_rec.prop_idseq           := P_DEC_PROP_IDSEQ;
 v_dec_rec.origin               := P_DEC_ORIGIN;  -- 15-Jul-2003, W. Ver Hoef
 v_dec_rec.cdr_name               := P_DEC_CDR_NAME;  --GF30681
 SELECT cde_id_seq.NEXTVAL -- When transaction_type := 'VERSION' as below,
 INTO v_dec_rec.dec_id     -- BIU trigger won't properly assign a value
 FROM dual;                -- so we have to set it here.

    v_dec_ind.dec_idseq            := TRUE;
    v_dec_ind.preferred_name    := TRUE;
    v_dec_ind.conte_idseq        := TRUE;
    v_dec_ind.version            := TRUE;
    v_dec_ind.preferred_definition := TRUE;
    v_dec_ind.long_name            := TRUE;
    v_dec_ind.asl_name            := TRUE;
    v_dec_ind.propl_name         := FALSE;
    v_dec_ind.ocl_name             := FALSE;
    v_dec_ind.property_qualifier   := TRUE;
    v_dec_ind.obj_class_qualifier  := TRUE;
    v_dec_ind.cd_idseq            := TRUE;
    v_dec_ind.latest_version_ind   := TRUE;
    v_dec_ind.begin_date        := TRUE;
    v_dec_ind.end_date            := TRUE;
    v_dec_ind.change_note        := TRUE;
    v_dec_ind.created_by        := TRUE;
    v_dec_ind.date_created        := TRUE;
    v_dec_ind.modified_by        := TRUE;
    v_dec_ind.date_modified        := TRUE;
    v_dec_ind.deleted_ind          := TRUE;
    v_dec_ind.oc_idseq             := TRUE;
    v_dec_ind.prop_idseq           := TRUE;
 v_dec_ind.dec_id               := TRUE;  -- 15-Jul-2003, W. Ver Hoef
 v_dec_ind.origin               := TRUE;
 v_dec_ind.cdr_name               := TRUE; --GF30681

    BEGIN
      --meta_global_pkg.transaction_type := 'VERSION';
      cg$data_element_concepts_view.ins(v_dec_rec,v_dec_ind);
   P_DEC_DEC_IDSEQ := v_dec_idseq;  -- 16-Jul-2003, W. Ver Hoef - added assignment
      meta_global_pkg.transaction_type := NULL;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_DEC_500'; --Error inserting Data Element Concepts
    END;

    --If LATEST_VERSION_IND is'Yes' then update so that all other versions have the indicator set to 'No'
    IF(P_DEC_LATEST_VERSION_IND = 'Yes') THEN
      Sbrext_Common_Routines.set_ac_lvi(P_RETURN_CODE,P_DEC_DEC_IDSEQ,'DE_CONCEPT');
      IF P_RETURN_CODE IS NOT NULL  THEN
        P_RETURN_CODE := 'API_DEC_503'; -- Error updating latest_Value_ind
        RETURN;
      END IF;
    END IF;

    --create a history record with prior version
    IF v_new_version THEN
      BEGIN
        meta_config_mgmt.CREATE_AC_HISTORIES (v_ac,P_DEC_DEC_IDSEQ,'VERSIONED','DE_CONCEPT');
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_DEC_504'; --Error creating history
      END;
    END IF;

  END IF;

  IF (P_ACTION = 'UPD' ) THEN
    --Get the version for the P_DEC_DECIDSEQ
    SELECT version INTO v_version
    FROM data_element_concepts_view
    WHERE dec_idseq = P_DEC_DEC_IDSEQ;

    IF v_version <> P_DEC_VERSION THEN
      P_RETURN_CODE := 'API_DEC_402'; -- Version can NOT be updated. It can only be created
      RETURN;
    END IF;

    P_DEC_DATE_MODIFIED := TO_CHAR(SYSDATE);
    P_DEC_MODIFIED_BY   := P_UA_NAME;--USER;
    P_DEC_DELETED_IND   := 'No';

    v_dec_rec.date_modified := TO_DATE(P_DEC_DATE_MODIFIED);
    v_dec_rec.modified_by   := P_DEC_MODIFIED_BY;
    v_dec_rec.dec_idseq     := P_DEC_DEC_IDSEQ;
    v_dec_rec.deleted_ind   := 'No';

    v_dec_ind.date_modified := TRUE;
    v_dec_ind.modified_by   := TRUE;
    v_dec_ind.deleted_ind   := TRUE;
    v_dec_ind.dec_idseq     := TRUE;

    v_dec_ind.version       := FALSE;
    v_dec_ind.created_by := FALSE;
    v_dec_ind.date_created := FALSE;
    v_dec_ind.dec_id      := FALSE;  -- 16-Jul-2003, W. Ver Hoef

    IF P_DEC_PREFERRED_NAME IS NULL THEN
      v_dec_ind.preferred_name := FALSE;
    ELSE
      v_dec_rec.preferred_name := P_DEC_PREFERRED_NAME;
      v_dec_ind.preferred_name := TRUE;
    END IF;

    IF P_DEC_CONTE_IDSEQ IS NULL THEN
      v_dec_ind.conte_idseq := FALSE;
    ELSE
      v_dec_rec.conte_idseq := P_DEC_CONTE_IDSEQ;
      v_dec_ind.conte_idseq := TRUE;
    END IF;

    IF P_DEC_PREFERRED_DEFINITION IS NULL THEN
      v_dec_ind.preferred_definition := FALSE;
    ELSE
      v_dec_rec.preferred_definition := P_DEC_PREFERRED_DEFINITION;
      v_dec_ind.preferred_definition := TRUE;
    END IF;

    IF P_DEC_LONG_NAME IS NULL THEN
      v_dec_ind.long_name := FALSE;
 ELSIF P_dec_long_name = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_dec_rec.long_name := NULL;
      v_dec_ind.long_name := TRUE;
    ELSE
      v_dec_rec.long_name := P_DEC_LONG_NAME;
      v_dec_ind.long_name := TRUE;
    END IF;

    IF P_DEC_ASL_NAME IS NULL THEN
      v_dec_ind.asl_name := FALSE;
    ELSE
      v_dec_rec.asl_name := P_DEC_ASL_NAME;
      v_dec_ind.asl_name := TRUE;
    END IF;

   /* IF P_DEC_PROPL_NAME IS NULL THEN
      v_dec_ind.propl_name := FALSE;
    ELSE
      v_dec_rec.propl_name := P_DEC_PROPL_NAME;
      v_dec_ind.propl_name := TRUE;
    END IF;

    IF P_DEC_OCL_NAME IS NULL THEN
      v_dec_ind.ocl_name := FALSE;
    ELSE
      v_dec_rec.ocl_name := P_DEC_OCL_NAME;
      v_dec_ind.ocl_name := TRUE;
    END IF;
    */
    IF P_DEC_PROPERTY_QUALIFIER IS NULL THEN
      v_dec_ind.property_qualifier := FALSE;
 ELSIF P_DEC_PROPERTY_QUALIFIER = ' ' THEN -- Condition added on 7/30/03 to allow null updates by Prerna Aggarwal
      v_dec_rec.property_qualifier := NULL;
      v_dec_ind.property_qualifier := TRUE;
    ELSE
      v_dec_rec.property_qualifier := P_DEC_PROPERTY_QUALIFIER;
      v_dec_ind.property_qualifier := TRUE;
    END IF;

    IF P_DEC_OBJ_CLASS_QUALIFIER IS NULL THEN
      v_dec_ind.obj_class_qualifier := FALSE;
 ELSIF P_DEC_OBJ_CLASS_QUALIFIER = ' ' THEN -- Condition added on 7/30/03 to allow null updates by Prerna Aggarwal
      v_dec_rec.obj_class_qualifier := NULL;
      v_dec_ind.obj_class_qualifier := TRUE;
    ELSE
      v_dec_rec.obj_class_qualifier := P_DEC_OBJ_CLASS_QUALIFIER;
      v_dec_ind.obj_class_qualifier := TRUE;
    END IF;

    IF P_DEC_CD_IDSEQ IS NULL THEN
      v_dec_ind.cd_idseq  := FALSE;
    ELSE
      v_dec_rec.cd_idseq  := P_DEC_CD_IDSEQ;
      v_dec_ind.cd_idseq  := TRUE;
    END IF;

    IF P_DEC_LATEST_VERSION_IND IS NULL THEN
      v_dec_ind.latest_version_ind := FALSE;
    ELSE
      v_dec_rec.latest_version_ind := P_DEC_LATEST_VERSION_IND;
      v_dec_ind.latest_version_ind := TRUE;
    END IF;

    IF P_DEC_BEGIN_DATE IS NULL THEN
      v_dec_ind.begin_date := FALSE;
 ELSIF P_DEC_begin_date = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_dec_rec.begin_date := NULL;
      v_dec_ind.begin_date := TRUE;
    ELSE
      v_dec_rec.begin_date := TO_DATE(P_DEC_BEGIN_DATE);
      v_dec_ind.begin_date := TRUE;
    END IF;

    IF P_DEC_END_DATE  IS NULL THEN
      v_dec_ind.end_date := FALSE;
 ELSIF P_DEC_end_date = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_dec_rec.end_date := NULL;
      v_dec_ind.end_date := TRUE;
    ELSE
      v_dec_rec.end_date := TO_DATE(P_DEC_END_DATE);
      v_dec_ind.end_date := TRUE;
    END IF;

    IF P_DEC_CHANGE_NOTE   IS NULL THEN
      v_dec_ind.change_note := FALSE;
 ELSIF P_DEC_change_note = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_dec_rec.change_note := NULL;
      v_dec_ind.change_note := TRUE;
    ELSE
      v_dec_rec.change_note := P_DEC_CHANGE_NOTE  ;
      v_dec_ind.change_note := TRUE;
    END IF;

    IF P_DEC_OC_IDSEQ   IS NULL THEN
      v_dec_ind.oc_idseq := FALSE;
 ELSIF P_DEC_OC_IDSEQ = ' ' THEN -- Condition added on 7/30/03 to allow null updates by Prerna Aggarwal
      v_dec_rec.oc_idseq := NULL;
      v_dec_ind.oc_idseq := TRUE;
    ELSE
      v_dec_rec.oc_idseq := P_DEC_OC_IDSEQ  ;
      v_dec_ind.oc_idseq := TRUE;
    END IF;

    IF P_DEC_PROP_IDSEQ   IS NULL THEN
      v_dec_ind.prop_idseq := FALSE;
 ELSIF P_DEC_PROP_IDSEQ = ' ' THEN -- Condition added on 7/30/03 to allow null updates by Prerna Aggarwal
      v_dec_rec.prop_idseq := NULL;
      v_dec_ind.prop_idseq := TRUE;
    ELSE
      v_dec_rec.prop_idseq := P_DEC_PROP_IDSEQ  ;
      v_dec_ind.prop_idseq := TRUE;
    END IF;

    IF P_DEC_ORIGIN   IS NULL THEN  -- 15-Jul-2003, W. Ver Hoef
      v_dec_ind.origin := FALSE;
 ELSIF P_DEC_origin = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_dec_rec.origin := NULL;
      v_dec_ind.origin := TRUE;
    ELSE
      v_dec_rec.origin := P_DEC_ORIGIN  ;
      v_dec_ind.origin := TRUE;
    END IF;

    BEGIN
      cg$data_element_concepts_view.upd(v_dec_rec,v_dec_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_DEC_501'; --Error updating Data Element Concepts
    END;

    --If LATEST_VERSION_IND is'Yes' then update so that all other versions have the indicator set to 'No'
    IF(P_DEC_LATEST_VERSION_IND = 'Yes') THEN
      Sbrext_Common_Routines.set_ac_lvi(P_RETURN_CODE,P_DEC_DEC_IDSEQ,'DE_CONCEPT');
      IF P_RETURN_CODE IS NOT NULL  THEN
        P_RETURN_CODE := 'API_DEC_503'; -- Error updating latest_Value_ind
        RETURN;
      END IF;
    END IF;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    P_RETURN_CODE := 'NO_DATA_FOUND';
    NULL;
  WHEN OTHERS THEN
    P_RETURN_CODE := 'OTHERS';
    NULL;
END SET_DEC;
END DEC_ACTIONS;
/
  GRANT EXECUTE ON "SBREXT"."DEC_ACTIONS" TO PUBLIC;
/ 
  GRANT EXECUTE ON "SBREXT"."DEC_ACTIONS" TO "CDEBROWSER";
/ 
  GRANT DEBUG ON "SBREXT"."DEC_ACTIONS" TO "CDEBROWSER";
/ 
  GRANT EXECUTE ON "SBREXT"."DEC_ACTIONS" TO "DATA_LOADER";
/
  GRANT DEBUG ON "SBREXT"."DEC_ACTIONS" TO "DATA_LOADER";
/ 
  GRANT EXECUTE ON "SBREXT"."DEC_ACTIONS" TO "SBR" WITH GRANT OPTION;
/ 
  GRANT DEBUG ON "SBREXT"."DEC_ACTIONS" TO "SBR" WITH GRANT OPTION;
/ 
  GRANT EXECUTE ON "SBREXT"."DEC_ACTIONS" TO "APPLICATION_USER";
/ 
  GRANT DEBUG ON "SBREXT"."DEC_ACTIONS" TO "APPLICATION_USER";
/ 
  GRANT EXECUTE ON "SBREXT"."DEC_ACTIONS" TO "DER_USER";
/
