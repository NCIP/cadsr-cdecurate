/*L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L*/

--------------------------------------------------------
--  Please run with SBREXT account
--------------------------------------------------------
--------------------------------------------------------
--  File created - Thursday-April-04-2013   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body SBREXT_SET_ROW
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SBREXT"."SBREXT_SET_ROW" AS

/*
** Private program units
*/

-- Function to return VM_IDSEQ based on a SHORT_MEANING
-- S. Alred, 10/23/2006

  FUNCTION get_vm_idseq (p_ShortMeaning IN sbr.value_meanings.vm_idseq%type)
     RETURN VARCHAR2 IS
  --
  CURSOR c_VM (p_short_meaning VARCHAR2) IS
      SELECT vm_idseq
   FROM   sbr.value_meanings
   WHERE  short_meaning = p_ShortMeaning;

  x_NoVMFound   EXCEPTION;
     v_ShortMeaning VARCHAR2(100);
 BEGIN
   OPEN c_VM(p_ShortMeaning);
     FETCH c_VM INTO v_ShortMeaning;
      IF c_VM%NOTFOUND THEN
      RAISE x_NoVMFound;
      END IF;
      CLOSE c_VM;
   RETURN v_ShortMeaning;
 EXCEPTION
     WHEN x_NoVMFOUND THEN
        Raise_Application_Error('-20100',
      'No VM IDSEQ found for '|| v_ShortMeaning);
      WHEN OTHERS THEN
       RAISE;
    END get_vm_idseq;

/******************************************************************************
   NAME:       SET_VD
   PURPOSE:    Inserts or Updates a Single Row Of Value Domain Based on either VD_IDSEQ
               or Preferred Name, Context and Version

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/18/2001  Prerna Aggarwal  1. Created this procedure
   2.0    07/24/2003  W. Ver Hoef      1. added parameter and code for origin
                                           2. added IS NOT NULL conditions on several
                parameters which are not required on
             for UPD action.
   2.1        03/19/2004  W. Ver Hoef      1. substituted UNASSIGNED with function
                                              call to get_default_asl
   2.1        03/26/2004  W. Ver Hoef      1. added R as valid option for vd type
                                              flag, and added validation on type
             flag for UPD (as it is for INSERT)
   2.3        10/23/2006  S. Alred         1. Added overloaded versions of set_vm
                                              and set_vm_condr to return new
             vm_idseq value.

******************************************************************************/


PROCEDURE SET_VD(
  P_RETURN_CODE        OUT VARCHAR2
, P_ACTION                  IN     VARCHAR2
, P_VD_VD_IDSEQ             IN OUT VARCHAR2
, P_VD_PREFERRED_NAME     IN OUT VARCHAR2
, P_VD_CONTE_IDSEQ         IN OUT VARCHAR2
, P_VD_VERSION             IN OUT NUMBER
, P_VD_PREFERRED_DEFINITION IN OUT VARCHAR2
, P_VD_CD_IDSEQ             IN OUT VARCHAR2
, P_VD_ASL_NAME             IN OUT VARCHAR2
, P_VD_LATEST_VERSION_IND   IN OUT VARCHAR2
, P_VD_DTL_NAME             IN OUT VARCHAR2
, P_VD_MAX_LENGTH_NUM       IN OUT NUMBER
, P_VD_LONG_NAME         IN OUT VARCHAR2
, P_VD_FORML_NAME          IN OUT VARCHAR2
, P_FORML_DESCRIPTION       IN OUT VARCHAR2
, P_FORML_COMMENT           IN OUT VARCHAR2
, P_VD_UOML_NAME            IN OUT VARCHAR2
, P_UOML_DESCRIPTION        IN OUT VARCHAR2
, P_UOML_COMMENT            IN OUT VARCHAR2
, P_VD_LOW_VALUE_NUM     IN OUT VARCHAR2
, P_VD_HIGH_VALUE_NUM     IN OUT VARCHAR2
, P_VD_MIN_LENGTH_NUM     IN OUT NUMBER
, P_VD_DECIMAL_PLACE      IN OUT NUMBER
, P_VD_CHAR_SET_NAME     IN OUT VARCHAR2
, P_VD_BEGIN_DATE         IN OUT VARCHAR2
, P_VD_END_DATE             IN OUT VARCHAR2
, P_VD_CHANGE_NOTE         IN OUT VARCHAR2
, P_VD_TYPE_FLAG         IN OUT VARCHAR2
, P_VD_CREATED_BY            OUT VARCHAR2
, P_VD_DATE_CREATED            OUT VARCHAR2
, P_VD_MODIFIED_BY            OUT VARCHAR2
, P_VD_DATE_MODIFIED        OUT VARCHAR2
, P_VD_DELETED_IND            OUT VARCHAR2
, P_VD_REP_IDSEQ            IN     VARCHAR2 DEFAULT NULL
, P_VD_QUALIFIER_NAME       IN     VARCHAR2 DEFAULT NULL
, P_VD_ORIGIN               IN     VARCHAR2 DEFAULT NULL) -- 24-Jul-2003, W. Ver Hoef
IS

v_version     value_domains_view.version%TYPE;
v_ac          value_domains_view.vd_idseq%TYPE;
v_asl_name    value_domains_view.asl_name%TYPE;

v_description VARCHAR2(60);
v_comments    VARCHAR2(2000);
v_begin_date  DATE := NULL;
v_end_date    DATE := NULL;
v_new_version BOOLEAN :=FALSE;

v_vd_rec    cg$value_domains_view.cg$row_type;
v_forml_rec cg$formats_lov_view.cg$row_type;
v_uoml_rec  cg$unit_of_measures_lov_view.cg$row_type;
v_vd_ind    cg$value_domains_view.cg$ind_type;
v_forml_ind cg$formats_lov_view.cg$ind_type;
v_uoml_ind  cg$unit_of_measures_lov_view.cg$ind_type;
v_count number;
v_vd_preferred_name administered_components.preferred_name%type;

BEGIN
  P_RETURN_CODE := NULL;

  IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
    P_RETURN_CODE := 'API_VD_700'; -- Invalid action
    RETURN;
  END IF;

  IF P_ACTION = 'INS' THEN              --we are inserting a record
    IF P_VD_VD_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_VD_100' ;  --for inserts the ID is generated
   RETURN;
    ELSE
      --Check to see that all mandatory parameters are either not NULL or have a default value.
   IF P_VD_PREFERRED_NAME IS NULL THEN
     P_RETURN_CODE := 'API_VD_101';  --Preferred Name cannot be null here
  RETURN;
      END IF;
   IF P_VD_CONTE_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_VD_102'; --CONTE_IDSEQ cannot be null here
  RETURN;
   END IF;
   IF P_VD_PREFERRED_DEFINITION IS NULL THEN
     P_RETURN_CODE := 'API_VD_103'; --Preferred Definition cannot be null here
  RETURN;
   END IF;
   IF P_VD_ASL_NAME IS NULL THEN
     -- 19-Mar-2004, W. Ver Hoef - substituted UNASSIGNED with function call below
     P_VD_ASL_NAME := Sbrext_Common_Routines.get_default_asl('INS'); -- 'UNASSIGNED';
   END IF;
   IF P_VD_VERSION IS NULL THEN
     P_VD_VERSION := Sbrext_Common_Routines.get_ac_version(p_vd_preferred_name,p_vd_conte_idseq,'VALUEDOMAIN','HIGHEST') + 1;
   END IF;
   IF P_VD_CD_IDSEQ IS NULL THEN
     P_VD_CD_IDSEQ := Sbrext_Common_Routines.get_cd(P_VD_CONTE_IDSEQ);
  IF P_VD_CD_IDSEQ IS NULL THEN
       P_RETURN_CODE := 'API_VD_104'; --default CD_IDSEQ not found
    RETURN;
  END IF;
   END IF;
   IF P_VD_LATEST_VERSION_IND IS NULL THEN
     P_VD_LATEST_VERSION_IND := 'No';
      END IF;
   IF P_VD_TYPE_FLAG IS NULL THEN
     P_VD_TYPE_FLAG  := 'N';
   ELSIF P_VD_TYPE_FLAG NOT IN ('E','N','R') THEN -- 26-Mar-2004, W. Ver Hoef - added R
     P_RETURN_CODE := 'API_VD_106'; --VD type flag can be ;E or N or OR only
  RETURN;
   END IF;
   IF P_VD_DTL_NAME IS NULL THEN
     P_VD_DTL_NAME := 'CHARACTER';
   END IF;
   /* Commented out on 9/4/2003 since max length should not default to 0
   IF P_VD_MAX_LENGTH_NUM IS NULL THEN
     P_VD_MAX_LENGTH_NUM := 0;
   END IF;*/
    END IF;

 if upper(P_VD_PREFERRED_NAME) <> 'SYSTEM GENERATED' then
 select count(*) into v_count
 from value_Domains
 where preferred_name = p_vd_PREFERRED_NAME
 and version = p_vd_Version
 and conte_idseq = p_vd_conte_idseq;

 if v_count <> 0 then
   P_RETURN_CODE := 'API_VD_550'; -- unique constraint violeted;
   RETURN;
 end if;
  END IF;
end if;

  IF P_ACTION = 'UPD' THEN              --we are updating a record
    IF P_VD_VD_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_VD_400' ;  --for updates the ID IS mandatory
   RETURN;
    END IF;
    SELECT asl_name
 INTO   v_asl_name
    FROM   value_domains_View
    WHERE  vd_idseq = P_VD_VD_IDSEQ;
    IF (P_VD_PREFERRED_NAME IS NOT NULL OR P_VD_CONTE_IDSEQ IS NOT NULL) AND v_asl_name = 'RELEASED'  THEN
      P_RETURN_CODE := 'API_VD_401' ;  --Preferred Name or Context Can not be updated
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(P_VD_VD_IDSEQ) THEN
      P_RETURN_CODE := 'API_VD_005'; --VD NOT found
      RETURN;
    END IF;
 -- 26-Mar-2004, W. Ver Hoef - added validation on vd_type_flag
 IF P_VD_TYPE_FLAG NOT IN ('E','N','R') THEN -- 26-Mar-2004, W. Ver Hoef - added R
   P_RETURN_CODE := 'API_VD_106'; --VD type flag can be ;E or N or OR only
   RETURN;
 END IF;
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are logically deleteing a record

    IF P_VD_VD_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_VD_400' ;  --for deletes the ID IS mandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ac_exists(P_VD_VD_IDSEQ) THEN
     P_RETURN_CODE := 'API_VD_005'; --Value Domain not found
     RETURN;
   END IF;
    END IF;

    P_VD_DELETED_IND   := 'Yes';
    P_VD_MODIFIED_BY   := 'USER';
    P_VD_DATE_MODIFIED := TO_CHAR(SYSDATE);

    v_vd_rec.vd_idseq      := P_VD_VD_IDSEQ;
    v_vd_rec.deleted_ind   := P_VD_DELETED_IND;
    v_vd_rec.modified_by   := P_VD_MODIFIED_BY;
    v_vd_rec.date_modified := TO_DATE(P_VD_DATE_MODIFIED);

    v_vd_ind.vd_idseq           := TRUE;
    v_vd_ind.preferred_name       := FALSE;
    v_vd_ind.conte_idseq       := FALSE;
    v_vd_ind.version           := FALSE;
    v_vd_ind.preferred_definition := FALSE;
    v_vd_ind.long_name           := FALSE;
    v_vd_ind.asl_name           := FALSE;
    v_vd_ind.cd_idseq           := FALSE;
    v_vd_ind.latest_version_ind   := FALSE;
    v_vd_ind.vd_type_flag       := FALSE;
    v_vd_ind.dtl_name           := FALSE;
    v_vd_ind.forml_name        := FALSE;
    v_vd_ind.uoml_name            := FALSE;
    v_vd_ind.low_Value_num       := FALSE;
    v_vd_ind.high_Value_num       := FALSE;
    v_vd_ind.min_length_num       := FALSE;
    v_vd_ind.max_length_num       := FALSE;
    v_vd_ind.decimal_place        := FALSE;
    v_vd_ind.char_set_name       := FALSE;
    v_vd_ind.begin_date           := FALSE;
    v_vd_ind.end_date           := FALSE;
    v_vd_ind.change_note       := FALSE;
    v_vd_ind.created_by           := FALSE;
    v_vd_ind.date_created       := FALSE;
    v_vd_ind.modified_by       := TRUE;
    v_vd_ind.date_modified       := TRUE;
    v_vd_ind.deleted_ind          := TRUE;
 v_vd_ind.origin               := FALSE; -- 24-Jul-2003, W. Ver Hoef

    BEGIN
      cg$value_domains_view.upd(v_vd_rec,v_vd_ind);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
dbms_output.put_line('SQLERRM = '||SQLERRM);
      P_RETURN_CODE := 'API_VD_502'; --Error deleting Value Domain
   RETURN;
    END;

  END IF;

  IF (P_VD_LATEST_VERSION_IND IS NOT NULL) THEN
    IF P_VD_LATEST_VERSION_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_VD_105'; --Version can only be 'Yes' or 'N
      RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
  IF LENGTH(P_VD_PREFERRED_NAME) > Sbrext_Column_Lengths.L_VD_PREFERRED_NAME THEN
    P_RETURN_CODE := 'API_VD_111';  --Length of preferred_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_PREFERRED_DEFINITION) > Sbrext_Column_Lengths.L_VD_PREFERRED_DEFINITION THEN
    P_RETURN_CODE := 'API_VD_113';  --Length of Preferrede Definition exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_LONG_NAME) > Sbrext_Column_Lengths.L_VD_LONG_NAME THEN
    P_RETURN_CODE := 'API_VD_114'; --Length of Long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_ASL_NAME ) > Sbrext_Column_Lengths.L_VD_ASL_NAME  THEN
    P_RETURN_CODE := 'API_VD_115'; --Length of asl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_TYPE_FLAG) > Sbrext_Column_Lengths.L_VD_VD_TYPE_FLAG THEN
    P_RETURN_CODE := 'API_VD_118'; --Length of vd_Type_flag exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_DTL_NAME) > Sbrext_Column_Lengths.L_VD_DTL_NAME     THEN
    P_RETURN_CODE := 'API_VD_119'; --Length of dtl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_FORML_NAME) > Sbrext_Column_Lengths.L_VD_FORML_NAME THEN
    P_RETURN_CODE := 'API_VD_120'; --Length of forml_name  exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_FORML_DESCRIPTION) > Sbrext_Column_Lengths.L_FORML_DESCRIPTION THEN
    P_RETURN_CODE := 'API_VD_121'; --Length of forml_description exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_FORML_COMMENT ) > Sbrext_Column_Lengths.L_FORML_COMMENTS  THEN
    P_RETURN_CODE := 'API_VD_129'; --Length of forml_comments exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_UOML_NAME) > Sbrext_Column_Lengths.L_VD_UOML_NAME THEN
    P_RETURN_CODE := 'API_VD_122'; --Length of uoml_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_UOML_DESCRIPTION ) > Sbrext_Column_Lengths.L_UOML_DESCRIPTION  THEN
    P_RETURN_CODE := 'API_VD_123'; --Length of upml_descriptionexceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_UOML_COMMENT) > Sbrext_Column_Lengths.L_UOML_COMMENTS THEN
    P_RETURN_CODE := 'API_VD_124'; --Length of upml_comments exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_LOW_VALUE_NUM ) > Sbrext_Column_Lengths.L_VD_LOW_VALUE_NUM  THEN
    P_RETURN_CODE := 'API_VD_125'; --Length of low_value_num exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_HIGH_VALUE_NUM) > Sbrext_Column_Lengths.L_VD_HIGH_VALUE_NUM THEN
    P_RETURN_CODE := 'API_VD_126'; --Length of high_value_num exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_CHAR_SET_NAME) > Sbrext_Column_Lengths.L_VD_CHAR_SET_NAME THEN
    P_RETURN_CODE := 'API_VD_127'; --Length of char_set_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_CHANGE_NOTE) > Sbrext_Column_Lengths.L_VD_CHANGE_NOTE THEN
    P_RETURN_CODE := 'API_VD_128'; --Length of change_note exceeds maximum length
    RETURN;
  END IF;

  --check to see that charachter strings are valid
  IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_VD_PREFERRED_NAME) THEN
    P_RETURN_CODE := 'API_VD_130'; -- Value Domain Preferred Name has invalid Ccharacters
    RETURN;
  END IF;
  --this block of code has been commented out because formats and unit of measures will have alpha numberic charachters
  /*IF  P_VD_FORML_NAME IS NOT NULL THEN
      IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_VD_FORML_NAME) THEN
      P_RETURN_CODE := 'API_VD_131'; -- Value Domain Format Name has invalid characters
      RETURN;
    END IF;
  END IF;

  IF P_VD_UOML_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_VD_UOML_NAME) THEN
      P_RETURN_CODE := 'API_VD_132'; -- Value Domain UOML Name has invalid characters
      RETURN;
    END IF;
  END IF;
  */
  IF NOT Sbrext_Common_Routines.valid_char(P_VD_PREFERRED_DEFINITION) THEN
    P_RETURN_CODE := 'API_VD_133'; -- Value Domain Preferred Definition has invalid characters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_VD_LONG_NAME) THEN
    P_RETURN_CODE := 'API_VD_134'; -- Value Domain Long Name has invalid characters
    RETURN;
  END IF;
  IF P_FORML_DESCRIPTION IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_FORML_DESCRIPTION) THEN
      P_RETURN_CODE := 'API_VD_135'; -- Format Description has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_FORML_COMMENT IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_FORML_COMMENT) THEN
      P_RETURN_CODE := 'API_VD_136'; -- Format Comment has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_UOML_DESCRIPTION IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_UOML_DESCRIPTION) THEN
      P_RETURN_CODE := 'API_VD_137'; -- Unit of Measure Description has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_UOML_COMMENT IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_UOML_COMMENT) THEN
      P_RETURN_CODE := 'API_VD_138'; -- Unit of Measure Comment has invalid characters
      RETURN;
    END IF;
  END IF;

  --check to see that Context, Workflow Status, Data type, Character Set, Conceptual Domain already exist in the database
  IF P_ACTION = 'INS' THEN
    -- This check should be performed only in inserts as update and delete expect null conte_idseq
    IF NOT Sbrext_Common_Routines.context_exists(P_VD_CONTE_IDSEQ) THEN
      P_RETURN_CODE := 'API_VD_200'; --Context not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_VD_CD_IDSEQ IS NOT NULL THEN -- 24-Jul-2003, W. Ver Hoef
    IF NOT Sbrext_Common_Routines.ac_exists(P_VD_CD_IDSEQ) THEN
      P_RETURN_CODE := 'API_VD_201'; --Conceptual Domain not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_VD_ASL_NAME IS NOT NULL THEN -- 24-Jul-2003, W. Ver Hoef
    IF NOT Sbrext_Common_Routines.workflow_exists(P_VD_ASL_NAME) THEN
      P_RETURN_CODE := 'API_VD_202'; --Workflow Status not found in the database
      RETURN;
    END IF;
  END IF;
  IF (P_VD_CHAR_SET_NAME IS NOT NULL AND P_VD_CHAR_SET_NAME != ' ') THEN
    IF NOT Sbrext_Common_Routines.char_set_exists(P_VD_CHAR_SET_NAME) THEN
      P_RETURN_CODE := 'API_VD_203'; --Character set not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_VD_DTL_NAME IS NOT NULL THEN -- 24-Jul-2003, W. Ver Hoef
    IF NOT Sbrext_Common_Routines.data_type_exists(P_VD_DTL_NAME) THEN
      P_RETURN_CODE := 'API_VD_204'; --DATA_TYPE NOT found in the database
      RETURN;
    END IF;
  END IF;
  IF P_VD_REP_IDSEQ IS NOT NULL AND P_VD_REP_IDSEQ != ' ' THEN
    IF NOT Sbrext_Common_Routines.ac_exists(P_VD_REP_IDSEQ )  THEN
      P_RETURN_CODE := 'API_VD_207'; --Representation term does not exist
      RETURN;
    END IF;
  END IF;
  IF P_VD_QUALIFIER_NAME IS NOT NULL AND P_VD_QUALIFIER_NAME != ' ' THEN
    IF NOT Sbrext_Common_Routines.qual_exists(P_VD_QUALIFIER_NAME )  THEN
      P_RETURN_CODE := 'API_VD_208'; --Qualifier does not exist
      RETURN;
    END IF;
  END IF;

  --check to see that begin data and end date are valid dates
  IF(P_VD_BEGIN_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_VD_BEGIN_DATE,v_begin_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_VD_600'; --begin date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_VD_END_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_VD_END_DATE,v_end_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_VD_601'; --end date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_VD_BEGIN_DATE IS NOT NULL AND P_VD_END_DATE IS NOT NULL) THEN
    IF(v_end_date < v_begin_date) THEN
      P_RETURN_CODE := 'API_VD_210'; --end date is before begin date
      RETURN;
    END IF;
  --ELSIF(P_VD_END_DATE IS NOT NULL AND P_VD_BEGIN_DATE IS NULL) THEN
    --P_RETURN_CODE := 'API_VD_211'; --begin date cannot be null when end date is null
    --RETURN;
  END IF;

  --check to see that format description  or comments are sent in without the formt name
  IF(P_VD_FORML_NAME IS NULL AND ( P_FORML_DESCRIPTION IS NOT NULL OR P_FORML_COMMENT IS NOT NULL)) THEN
    P_RETURN_CODE := 'API_VD_205'; --cannot send in format description and comments without format name
    RETURN;
  END IF;
  IF(P_VD_UOML_NAME IS NULL AND ( P_UOML_DESCRIPTION IS NOT NULL OR P_UOML_COMMENT IS NOT NULL)) THEN
    P_RETURN_CODE := 'API_VD_206'; --cannot send in UOML description and comments without UOML name
    RETURN;
  END IF;

  --check to see that Format, Unit of measure already exist in the database , ifthey do not then create them
  IF( P_VD_FORML_NAME IS NOT NULL AND P_VD_FORML_NAME != ' ' ) THEN

    IF NOT(Sbrext_Common_Routines.vd_format_exists(P_VD_FORML_NAME)) THEN
      v_forml_rec.forml_name  := P_VD_FORML_NAME;
      v_forml_rec.description := P_FORML_DESCRIPTION;
      v_forml_rec.comments    := P_FORML_COMMENT;
      v_forml_ind.forml_name  := TRUE;
      v_forml_ind.description := TRUE;
      v_forml_ind.comments    := TRUE;
      BEGIN
        cg$formats_lov_view.ins(v_forml_rec,v_forml_ind);
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_FORML_500' ;--error inserting format
      END;
    END IF;
  END IF;

  IF (P_VD_UOML_NAME IS NOT NULL AND P_VD_UOML_NAME != ' ') THEN
    IF NOT(Sbrext_Common_Routines.uoml_exists(P_VD_UOML_NAME)) THEN
      v_uoml_rec.uoml_name   := P_VD_UOML_NAME;
      v_uoml_rec.description := P_UOML_DESCRIPTION;
      v_uoml_rec.comments    := P_UOML_COMMENT;
      v_uoml_ind.uoml_name   := TRUE;
      v_uoml_ind.description := TRUE;
      v_uoml_ind.comments    := TRUE;
      BEGIN
        cg$Unit_of_measures_lov_view.ins(v_uoml_rec,v_uoml_ind);
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_UOML_500' ;--error inserting UOML
       RETURN;
      END;
    END IF;
  END IF;

  IF (P_ACTION = 'INS' ) THEN

    --check to see that  a Value Domain with the same
    --Preferred Name, Context and Version does not already exist
    IF Sbrext_Common_Routines.ac_exists(P_VD_PREFERRED_NAME,P_VD_CONTE_IDSEQ ,P_VD_VERSION,'VALUEDOMAIN') THEN
      P_RETURN_CODE := 'API_VD_300';-- Value Domain already Exists
      RETURN;
    END IF;
    --Check to see if prior versions alresdy exist
    IF Sbrext_Common_Routines.ac_version_exists(P_VD_PREFERRED_NAME,P_VD_CONTE_IDSEQ ,'VALUEDOMAIN') THEN -- we are creating a new version
      v_new_version := TRUE;
      v_ac          := Sbrext_Common_Routines.get_version_ac(P_VD_PREFERRED_NAME,P_VD_CONTE_IDSEQ,'VALUEDOMAIN');
    END IF;
 if p_vd_preferred_name = 'System Generated' then
   v_vd_preferred_name := null;
 else
   v_vd_preferred_name := p_vd_preferred_name;
 end if;
    --add code here to check for versioning
    P_VD_VD_IDSEQ      := admincomponent_crud.cmr_guid;
    P_VD_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_VD_CREATED_BY    := ADMIN_SECURITY_UTIL.effective_user;
    P_VD_DATE_MODIFIED := NULL;
    P_VD_MODIFIED_BY   := NULL;
    P_VD_DELETED_IND   := 'No';

    v_vd_rec.vd_idseq           := P_VD_VD_IDSEQ;
    v_vd_rec.preferred_name       := P_VD_PREFERRED_NAME;
    v_vd_rec.conte_idseq       := P_VD_CONTE_IDSEQ;
    v_vd_rec.version           := P_VD_VERSION;
    v_vd_rec.preferred_definition := P_VD_PREFERRED_DEFINITION;
    v_vd_rec.long_name           := P_VD_LONG_NAME;
    v_vd_rec.asl_name           := P_VD_ASL_NAME ;
    v_vd_rec.cd_idseq           := P_VD_CD_IDSEQ ;
    v_vd_rec.latest_version_ind   := P_VD_LATEST_VERSION_IND;
    v_vd_rec.vd_type_flag       := P_VD_TYPE_FLAG;
    v_vd_rec.dtl_name           := P_VD_DTL_NAME;
    v_vd_rec.forml_name        := P_VD_FORML_NAME;
    v_vd_rec.uoml_name            := P_VD_UOML_NAME;
    v_vd_rec.low_value_num       := P_VD_LOW_VALUE_NUM;
    v_vd_rec.high_value_num       := P_VD_HIGH_VALUE_NUM;
    v_vd_rec.min_length_num       := P_VD_MIN_LENGTH_NUM;
    v_vd_rec.max_length_num       := P_VD_MAX_LENGTH_NUM ;
    v_vd_rec.decimal_place        := P_VD_DECIMAL_PLACE;
    v_vd_rec.char_set_name       := P_VD_CHAR_SET_NAME;
    v_vd_rec.begin_date           := TO_DATE(P_VD_BEGIN_DATE);
    v_vd_rec.end_date           := TO_DATE(P_VD_END_DATE);
    v_vd_rec.change_note       := P_VD_CHANGE_NOTE ;
    v_vd_rec.created_by           := P_VD_CREATED_BY;
    v_vd_rec.date_created       := TO_DATE(P_VD_DATE_CREATED);
    v_vd_rec.modified_by       := P_VD_MODIFIED_BY;
    v_vd_rec.date_modified       := TO_DATE(P_VD_DATE_MODIFIED);
    v_vd_rec.deleted_ind          := P_VD_DELETED_IND;
    v_vd_rec.rep_idseq            := P_VD_REP_IDSEQ;
    v_vd_rec.qualifier_name       := P_VD_QUALIFIER_NAME;
 v_vd_rec.origin               := P_VD_ORIGIN;  -- 24-Jul-2003, W. Ver Hoef

    v_vd_ind.vd_idseq           := TRUE;
    v_vd_ind.preferred_name       := TRUE;
    v_vd_ind.conte_idseq       := TRUE;
    v_vd_ind.version           := TRUE;
    v_vd_ind.preferred_definition := TRUE;
    v_vd_ind.long_name           := TRUE;
    v_vd_ind.asl_name           := TRUE;
    v_vd_ind.cd_idseq           := TRUE;
    v_vd_ind.latest_version_ind   := TRUE;
    v_vd_ind.vd_type_flag       := TRUE;
    v_vd_ind.dtl_name           := TRUE;
    v_vd_ind.forml_name        := TRUE;
    v_vd_ind.uoml_name            := TRUE;
    v_vd_ind.low_value_num       := TRUE;
    v_vd_ind.high_value_num       := TRUE;
    v_vd_ind.min_length_num       := TRUE;
    v_vd_ind.max_length_num       := TRUE;
    v_vd_ind.decimal_place        := TRUE;
    v_vd_ind.char_set_name       := TRUE;
    v_vd_ind.begin_date           := TRUE;
    v_vd_ind.end_date           := TRUE;
    v_vd_ind.change_note       := TRUE;
    v_vd_ind.created_by           := TRUE;
    v_vd_ind.date_created       := TRUE;
    v_vd_ind.modified_by       := TRUE;
    v_vd_ind.date_modified       := TRUE;
    v_vd_ind.deleted_ind          := TRUE;
    v_vd_ind.rep_idseq            := TRUE;
    v_vd_ind.qualifier_name       := TRUE;
 v_vd_ind.origin               := TRUE; -- 24-Jul-2003, W. Ver Hoef

    BEGIN
      --meta_global_pkg.transaction_type := 'VERSION';
      cg$value_domains_view.ins(v_vd_rec,v_vd_ind);
   if p_vd_preferred_name = 'System Generated' then

     p_vd_preferred_name := sbrext_common_routines.GENERATE_VD_PREFERRED_NAME(p_vd_vd_idseq);
  update value_domains
  set preferred_name = p_vd_preferred_name
  where vd_idseq = p_vd_vd_idseq;
   end if;

      --meta_global_pkg.transaction_type := NULL;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_VD_500'; --Error inserting Value Domain
    END;

    --If LATEST_VERSION_IND is'Yes' then update so that all other versions have the indicator set to 'No'
    IF(P_VD_LATEST_VERSION_IND = 'Yes') THEN
      Sbrext_Common_Routines.set_ac_lvi(P_RETURN_CODE,P_VD_VD_IDSEQ,'VALUEDOMAIN');
      IF P_RETURN_CODE IS NOT NULL  THEN
        P_RETURN_CODE := 'API_VD_503'; -- Error updating latest_Value_ind
        RETURN;
      END IF;
    END IF;
    --create a history record with prior version
    IF v_new_version THEN
      BEGIN
        meta_config_mgmt.CREATE_AC_HISTORIES (v_ac,P_VD_VD_IDSEQ,'VERSIONED','VALUEDOMAIN');
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_VD_504'; --Error creating history
      END;
    END IF;

  END IF;

  IF (P_ACTION = 'UPD' ) THEN

    --Get the version for the P_VD_VDIDSEQ
    SELECT version
 INTO   v_version
    FROM   value_domains_view
    WHERE  vd_idseq = P_VD_VD_IDSEQ;

 IF P_VD_VERSION IS NOT NULL THEN  -- 24-JUL-2003, W. Ver Hoef
      IF v_version <> P_VD_VERSION THEN
        P_RETURN_CODE := 'API_VD_402'; -- Version can NOT be updated. It can only be created
        RETURN;
      END IF;
 END IF;

    P_VD_DATE_MODIFIED := TO_CHAR(SYSDATE);
    P_VD_MODIFIED_BY   := ADMIN_SECURITY_UTIL.effective_user;
    P_VD_DELETED_IND   := 'No';

    v_vd_rec.date_modified := P_VD_DATE_MODIFIED;
    v_vd_rec.modified_by   := P_VD_MODIFIED_BY;
    v_vd_rec.vd_idseq      := P_VD_VD_IDSEQ;
    v_vd_rec.deleted_ind   := 'No';

    v_vd_ind.date_modified := TRUE;
    v_vd_ind.modified_by   := TRUE;
    v_vd_ind.deleted_ind   := TRUE;
    v_vd_ind.vd_idseq      := TRUE;

    v_vd_ind.version       := FALSE;
    v_vd_ind.created_by    := FALSE;
    v_vd_ind.date_created  := FALSE;

    IF P_VD_PREFERRED_NAME IS NULL THEN
      v_vd_ind.preferred_name := FALSE;
    ELSE
  if p_vd_preferred_name = 'System Generated' then
    v_vd_rec.preferred_name := sbrext_common_routines.GENERATE_VD_PREFERRED_NAME(p_vd_vd_idseq);
     else
   v_vd_rec.preferred_name := P_VD_PREFERRED_NAME;
  end if;
      v_vd_ind.preferred_name := TRUE;
    END IF;

    IF P_VD_CONTE_IDSEQ IS NULL THEN
      v_vd_ind.conte_idseq := FALSE;
    ELSE
      v_vd_rec.conte_idseq := P_VD_CONTE_IDSEQ;
      v_vd_ind.conte_idseq := TRUE;
    END IF;

    IF P_VD_PREFERRED_DEFINITION IS NULL THEN
      v_vd_ind.preferred_definition:= FALSE;
    ELSE
      v_vd_rec.preferred_definition := P_VD_PREFERRED_DEFINITION;
      v_vd_ind.preferred_definition := TRUE;
    END IF;

    IF P_VD_LONG_NAME IS NULL THEN
      v_vd_ind.long_name := FALSE;
 ELSIF P_VD_LONG_NAME = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.long_name := NULL;
      v_vd_ind.long_name := TRUE;
    ELSE
      v_vd_rec.long_name := P_VD_LONG_NAME;
      v_vd_ind.long_name := TRUE;
    END IF;

    IF P_VD_ASL_NAME IS NULL THEN
      v_vd_ind.asl_name := FALSE;
    ELSE
      v_vd_rec.asl_name := P_VD_ASL_NAME;
      v_vd_ind.asl_name := TRUE;
    END IF;

    IF P_VD_CD_IDSEQ IS NULL THEN
      v_vd_ind.cd_idseq := FALSE;
    ELSE
      v_vd_rec.cd_idseq := P_VD_CD_IDSEQ;
      v_vd_ind.cd_idseq := TRUE;
    END IF;

    IF P_VD_LATEST_VERSION_IND IS NULL THEN
      v_vd_ind.latest_version_ind := FALSE;
    ELSE
      v_vd_rec.latest_version_ind := P_VD_LATEST_VERSION_IND;
      v_vd_ind.latest_version_ind := TRUE;
    END IF;

    IF P_VD_TYPE_FLAG IS NULL THEN
      v_vd_ind.vd_type_flag := FALSE;
    ELSE
      v_vd_rec.vd_type_flag := P_VD_TYPE_FLAG;
      v_vd_ind.vd_type_flag := TRUE;
    END IF;

    IF P_VD_DTL_NAME IS NULL THEN
      v_vd_ind.dtl_name := FALSE;
    ELSE
      v_vd_rec.dtl_name := P_VD_DTL_NAME;
      v_vd_ind.dtl_name := TRUE;
    END IF;

    IF P_VD_FORML_NAME IS NULL THEN
      v_vd_ind.forml_name := FALSE;
 ELSIF P_VD_FORML_NAME = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.forml_name := NULL;
      v_vd_ind.forml_name := TRUE;
    ELSE
      v_vd_rec.forml_name := P_VD_FORML_NAME;
      v_vd_ind.forml_name := TRUE;
    END IF;

    IF P_VD_UOML_NAME IS NULL THEN
      v_vd_ind.uoml_name := FALSE;
 ELSIF P_VD_UOML_NAME = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.uoml_name := NULL;
      v_vd_ind.uoml_name := TRUE;
    ELSE
      v_vd_rec.uoml_name := P_VD_UOML_NAME ;
      v_vd_ind.uoml_name := TRUE;
    END IF;

    IF P_VD_LOW_VALUE_NUM IS NULL THEN
      v_vd_ind.low_value_num := FALSE;
 ELSIF P_VD_low_value_num = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.low_value_num := NULL;
      v_vd_ind.low_value_num := TRUE;
    ELSE
      v_vd_rec.low_value_num := P_VD_LOW_VALUE_NUM;
      v_vd_ind.low_value_num := TRUE;
    END IF;

    IF P_VD_HIGH_VALUE_NUM IS NULL THEN
      v_vd_ind.high_Value_num := FALSE;
 ELSIF P_VD_high_value_num = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.high_value_num := NULL;
      v_vd_ind.high_value_num := TRUE;
    ELSE
      v_vd_rec.high_value_num := P_VD_HIGH_VALUE_NUM;
      v_vd_ind.high_value_num := TRUE;
    END IF;

    IF P_VD_MIN_LENGTH_NUM IS NULL THEN
      v_vd_ind.min_length_num := FALSE;
 ELSIF P_VD_min_length_num = -1 THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.min_length_num := NULL;
      v_vd_ind.min_length_num := TRUE;
    ELSE
      v_vd_rec.min_length_num := P_VD_MIN_LENGTH_NUM;
      v_vd_ind.min_length_num := TRUE;
    END IF;

    IF P_VD_MAX_LENGTH_NUM  IS NULL THEN
     v_vd_ind.max_length_num := FALSE;
 ELSIF P_VD_max_length_num = -1 THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.max_length_num := NULL;
      v_vd_ind.max_length_num := TRUE;
    ELSE
     v_vd_rec.max_length_num := P_VD_MAX_LENGTH_NUM ;
     v_vd_ind.max_length_num := TRUE;
    END IF;

    IF P_VD_DECIMAL_PLACE IS NULL THEN
      v_vd_ind.decimal_place := FALSE;
 ELSIF P_VD_decimal_place = -1 THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.decimal_place := NULL;
      v_vd_ind.decimal_place := TRUE;
    ELSE
      v_vd_rec.decimal_place := P_VD_DECIMAL_PLACE;
      v_vd_ind.decimal_place := TRUE;
    END IF;

    IF P_VD_CHAR_SET_NAME IS NULL THEN
      v_vd_ind.char_set_name := FALSE;
 ELSIF P_VD_char_set_name = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.char_set_name := NULL;
      v_vd_ind.char_set_name := TRUE;
    ELSE
      v_vd_rec.char_set_name := P_VD_CHAR_SET_NAME;
      v_vd_ind.char_set_name := TRUE;
    END IF;

    IF P_VD_BEGIN_DATE IS NULL THEN
      v_vd_ind.begin_date := FALSE;
 ELSIF P_VD_begin_date = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.begin_date := NULL;
      v_vd_ind.begin_date := TRUE;
    ELSE
      v_vd_rec.begin_date := TO_DATE(P_VD_BEGIN_DATE);
      v_vd_ind.begin_date := TRUE;
    END IF;

    IF P_VD_END_DATE  IS NULL THEN
      v_vd_ind.end_date := FALSE;
 ELSIF P_VD_end_date = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.end_date := NULL;
      v_vd_ind.end_date := TRUE;
    ELSE
      v_vd_rec.end_date := TO_DATE(P_VD_END_DATE);
      v_vd_ind.end_date := TRUE;
    END IF;

    IF P_VD_CHANGE_NOTE   IS NULL THEN
      v_vd_ind.change_note := FALSE;
 ELSIF P_VD_change_note = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.change_note := NULL;
      v_vd_ind.change_note := TRUE;
    ELSE
      v_vd_rec.change_note := P_VD_CHANGE_NOTE  ;
      v_vd_ind.change_note := TRUE;
    END IF;

    IF P_VD_REP_IDSEQ  IS NULL THEN
      v_vd_ind.rep_idseq := FALSE;
 ELSIF P_VD_REP_IDSEQ = ' ' THEN -- Condition added on 7/30/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.rep_idseq := NULL;
      v_vd_ind.rep_idseq := TRUE;
    ELSE
      v_vd_rec.rep_idseq := P_VD_REP_IDSEQ;
      v_vd_ind.rep_idseq := TRUE;
    END IF;

    IF P_VD_QUALIFIER_NAME   IS NULL THEN
      v_vd_ind.qualifier_name := FALSE;
 ELSIF P_VD_QUALIFIER_NAME = ' ' THEN -- Condition added on 7/30/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.qualifier_name := NULL;
      v_vd_ind.qualifier_name := TRUE;
    ELSE
      v_vd_rec.qualifier_name := P_VD_QUALIFIER_NAME  ;
      v_vd_ind.qualifier_name := TRUE;
    END IF;

    IF P_VD_ORIGIN   IS NULL THEN  -- 24-Jul-2003, W. Ver Hoef
      v_vd_ind.origin := FALSE;
 ELSIF P_VD_origin = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.origin := NULL;
      v_vd_ind.origin := TRUE;
    ELSE
      v_vd_rec.origin := P_VD_ORIGIN  ;
      v_vd_ind.origin := TRUE;
    END IF;

    BEGIN
      cg$value_domains_view.upd(v_vd_rec,v_vd_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_VD_501'; --Error updating Value Domain
    END;

    --If LATEST_VERSION_IND is'Yes' then update so that all other versions have the indicator set to 'No'
    IF(P_VD_LATEST_VERSION_IND = 'Yes') THEN
      Sbrext_Common_Routines.set_ac_lvi(P_RETURN_CODE,P_VD_VD_IDSEQ,'VALUEDOMAIN');
      IF P_RETURN_CODE IS NOT NULL  THEN
        P_RETURN_CODE := 'API_VD_503'; -- Error updating latest_Value_ind
        RETURN;
      END IF;
    END IF;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;
END SET_VD;


PROCEDURE SET_VD(
 P_RETURN_CODE          OUT    VARCHAR2
,P_VD_CON_ARRAY                        IN     VARCHAR2
, P_ACTION                     IN     VARCHAR2
, P_VD_VD_IDSEQ               IN OUT VARCHAR2
, P_VD_PREFERRED_NAME         IN OUT VARCHAR2
, P_VD_CONTE_IDSEQ           IN OUT VARCHAR2
, P_VD_VERSION               IN OUT NUMBER
, P_VD_PREFERRED_DEFINITION   IN OUT VARCHAR2
, P_VD_CD_IDSEQ               IN OUT VARCHAR2
, P_VD_ASL_NAME               IN OUT VARCHAR2
, P_VD_LATEST_VERSION_IND      IN OUT VARCHAR2
, P_VD_DTL_NAME               IN OUT VARCHAR2
, P_VD_MAX_LENGTH_NUM          IN OUT NUMBER
, P_VD_LONG_NAME              IN OUT VARCHAR2
, P_VD_FORML_NAME            IN OUT VARCHAR2
, P_FORML_DESCRIPTION         IN OUT VARCHAR2
, P_FORML_COMMENT              IN OUT VARCHAR2
, P_VD_UOML_NAME               IN OUT VARCHAR2
, P_UOML_DESCRIPTION           IN OUT VARCHAR2
, P_UOML_COMMENT               IN OUT VARCHAR2
, P_VD_LOW_VALUE_NUM          IN OUT VARCHAR2
, P_VD_HIGH_VALUE_NUM       IN OUT VARCHAR2
, P_VD_MIN_LENGTH_NUM       IN OUT NUMBER
, P_VD_DECIMAL_PLACE        IN OUT NUMBER
, P_VD_CHAR_SET_NAME          IN OUT VARCHAR2
, P_VD_BEGIN_DATE           IN OUT VARCHAR2
, P_VD_END_DATE               IN OUT VARCHAR2
, P_VD_CHANGE_NOTE           IN OUT VARCHAR2
, P_VD_TYPE_FLAG              IN OUT VARCHAR2
, P_VD_CREATED_BY           OUT VARCHAR2
, P_VD_DATE_CREATED           OUT VARCHAR2
, P_VD_MODIFIED_BY           OUT VARCHAR2
, P_VD_DATE_MODIFIED          OUT VARCHAR2
, P_VD_DELETED_IND           OUT VARCHAR2
, P_VD_CONDR_IDSEQ                 IN OUT VARCHAR2
, P_VD_REP_IDSEQ                    IN VARCHAR2 DEFAULT NULL
, P_VD_QUALIFIER_NAME               IN VARCHAR2 DEFAULT NULL
, P_VD_ORIGIN                       IN VARCHAR2 DEFAULT NULL)IS

v_version     value_domains_view.version%TYPE;
v_ac          value_domains_view.vd_idseq%TYPE;
v_asl_name    value_domains_view.asl_name%TYPE;

v_description VARCHAR2(60);
v_comments    VARCHAR2(2000);
v_begin_date  DATE := NULL;
v_end_date    DATE := NULL;
v_new_version BOOLEAN :=FALSE;

v_vd_rec    cg$value_domains_view.cg$row_type;
v_forml_rec cg$formats_lov_view.cg$row_type;
v_uoml_rec  cg$unit_of_measures_lov_view.cg$row_type;
v_vd_ind    cg$value_domains_view.cg$ind_type;
v_forml_ind cg$formats_lov_view.cg$ind_type;
v_uoml_ind  cg$unit_of_measures_lov_view.cg$ind_type;
v_count number;
v_vd_preferred_name administered_components.preferred_name%type;

BEGIN
  P_RETURN_CODE := NULL;

  IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
    P_RETURN_CODE := 'API_VD_700'; -- Invalid action
    RETURN;
  END IF;

  IF P_ACTION = 'INS' THEN              --we are inserting a record
    IF P_VD_VD_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_VD_100' ;  --for inserts the ID is generated
   RETURN;
    ELSE
      --Check to see that all mandatory parameters are either not NULL or have a default value.
   IF P_VD_PREFERRED_NAME IS NULL THEN
     P_RETURN_CODE := 'API_VD_101';  --Preferred Name cannot be null here
  RETURN;
      END IF;
   IF P_VD_CONTE_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_VD_102'; --CONTE_IDSEQ cannot be null here
  RETURN;
   END IF;
   IF P_VD_PREFERRED_DEFINITION IS NULL THEN
     P_RETURN_CODE := 'API_VD_103'; --Preferred Definition cannot be null here
  RETURN;
   END IF;
   IF P_VD_ASL_NAME IS NULL THEN
     -- 19-Mar-2004, W. Ver Hoef - substituted UNASSIGNED with function call below
     P_VD_ASL_NAME := Sbrext_Common_Routines.get_default_asl('INS'); -- 'UNASSIGNED';
   END IF;
   IF P_VD_VERSION IS NULL THEN
     P_VD_VERSION := Sbrext_Common_Routines.get_ac_version(p_vd_preferred_name,p_vd_conte_idseq,'VALUEDOMAIN','HIGHEST') + 1;
   END IF;
   IF P_VD_CD_IDSEQ IS NULL THEN
     P_VD_CD_IDSEQ := Sbrext_Common_Routines.get_cd(P_VD_CONTE_IDSEQ);
  IF P_VD_CD_IDSEQ IS NULL THEN
       P_RETURN_CODE := 'API_VD_104'; --default CD_IDSEQ not found
    RETURN;
  END IF;
   END IF;
   IF P_VD_LATEST_VERSION_IND IS NULL THEN
     P_VD_LATEST_VERSION_IND := 'No';
      END IF;
   IF P_VD_TYPE_FLAG IS NULL THEN
     P_VD_TYPE_FLAG  := 'N';
   ELSIF P_VD_TYPE_FLAG NOT IN ('E','N','R') THEN -- 26-Mar-2004, W. Ver Hoef - added R
     P_RETURN_CODE := 'API_VD_106'; --VD type flag can be ;E or N or OR only
  RETURN;
   END IF;
   IF P_VD_DTL_NAME IS NULL THEN
     P_VD_DTL_NAME := 'CHARACTER';
   END IF;
   /* Commented out on 9/4/2003 since max length should not default to 0
   IF P_VD_MAX_LENGTH_NUM IS NULL THEN
     P_VD_MAX_LENGTH_NUM := 0;
   END IF;*/
    END IF;

  if upper(P_VD_PREFERRED_NAME) <> 'SYSTEM GENERATED' then
   select count(*) into v_count
   from value_Domains
   where preferred_name = p_vd_PREFERRED_NAME
   and version = p_vd_Version
   and conte_idseq = p_vd_conte_idseq;

   if v_count <> 0 then
     P_RETURN_CODE := 'API_VD_550'; -- unique constraint violeted;
     RETURN;
   end if;
  end if;
  END IF;

  IF P_ACTION = 'UPD' THEN              --we are updating a record
    IF P_VD_VD_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_VD_400' ;  --for updates the ID IS mandatory
   RETURN;
    END IF;
    SELECT asl_name
 INTO   v_asl_name
    FROM   value_domains_View
    WHERE  vd_idseq = P_VD_VD_IDSEQ;
    IF (P_VD_PREFERRED_NAME IS NOT NULL OR P_VD_CONTE_IDSEQ IS NOT NULL) AND v_asl_name = 'RELEASED'  THEN
      P_RETURN_CODE := 'API_VD_401' ;  --Preferred Name or Context Can not be updated
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(P_VD_VD_IDSEQ) THEN
      P_RETURN_CODE := 'API_VD_005'; --VD NOT found
      RETURN;
    END IF;
 -- 26-Mar-2004, W. Ver Hoef - added validation on vd_type_flag
 IF P_VD_TYPE_FLAG NOT IN ('E','N','R') THEN -- 26-Mar-2004, W. Ver Hoef - added R
   P_RETURN_CODE := 'API_VD_106'; --VD type flag can be ;E or N or OR only
   RETURN;
 END IF;
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are logically deleteing a record

    IF P_VD_VD_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_VD_400' ;  --for deletes the ID IS mandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ac_exists(P_VD_VD_IDSEQ) THEN
     P_RETURN_CODE := 'API_VD_005'; --Value Domain not found
     RETURN;
   END IF;
    END IF;

    P_VD_DELETED_IND   := 'Yes';
    P_VD_MODIFIED_BY   := 'USER';
    P_VD_DATE_MODIFIED := TO_CHAR(SYSDATE);

    v_vd_rec.vd_idseq      := P_VD_VD_IDSEQ;
    v_vd_rec.deleted_ind   := P_VD_DELETED_IND;
    v_vd_rec.modified_by   := P_VD_MODIFIED_BY;
    v_vd_rec.date_modified := TO_DATE(P_VD_DATE_MODIFIED);

    v_vd_ind.vd_idseq           := TRUE;
    v_vd_ind.preferred_name       := FALSE;
    v_vd_ind.conte_idseq       := FALSE;
    v_vd_ind.version           := FALSE;
    v_vd_ind.preferred_definition := FALSE;
    v_vd_ind.long_name           := FALSE;
    v_vd_ind.asl_name           := FALSE;
    v_vd_ind.cd_idseq           := FALSE;
    v_vd_ind.latest_version_ind   := FALSE;
    v_vd_ind.vd_type_flag       := FALSE;
    v_vd_ind.dtl_name           := FALSE;
    v_vd_ind.forml_name        := FALSE;
    v_vd_ind.uoml_name            := FALSE;
    v_vd_ind.low_Value_num       := FALSE;
    v_vd_ind.high_Value_num       := FALSE;
    v_vd_ind.min_length_num       := FALSE;
    v_vd_ind.max_length_num       := FALSE;
    v_vd_ind.decimal_place        := FALSE;
    v_vd_ind.char_set_name       := FALSE;
    v_vd_ind.begin_date           := FALSE;
    v_vd_ind.end_date           := FALSE;
    v_vd_ind.change_note       := FALSE;
    v_vd_ind.created_by           := FALSE;
    v_vd_ind.date_created       := FALSE;
    v_vd_ind.modified_by       := TRUE;
    v_vd_ind.date_modified       := TRUE;
    v_vd_ind.deleted_ind          := TRUE;
 v_vd_ind.origin               := FALSE; -- 24-Jul-2003, W. Ver Hoef

    BEGIN
      cg$value_domains_view.upd(v_vd_rec,v_vd_ind);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
dbms_output.put_line('SQLERRM = '||SQLERRM);
      P_RETURN_CODE := 'API_VD_502'; --Error deleting Value Domain
   RETURN;
    END;

  END IF;

  IF P_VD_CON_ARRAY is not null then
    P_VD_CONDR_IDSEQ := sbrext_common_routines.SET_DERIVATION_RULE(P_VD_CON_ARRAY);
    IF P_VD_CONDR_IDSEQ = 'Concept Not Found' then
      P_RETURN_CODE := 'Concept Not Found';
   RETURN;
    END IF;
  END IF;

  IF P_VD_CONDR_IDSEQ is not null then
   if not sbrext_common_routines.CONDR_EXISTS(P_VD_CONDR_IDSEQ) then
     P_RETURN_CODE := 'API_VD_600';--concept derivation does not exist
   end if;
  END IF;

  IF (P_VD_LATEST_VERSION_IND IS NOT NULL) THEN
    IF P_VD_LATEST_VERSION_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_VD_105'; --Version can only be 'Yes' or 'N
      RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
  IF LENGTH(P_VD_PREFERRED_NAME) > Sbrext_Column_Lengths.L_VD_PREFERRED_NAME THEN
    P_RETURN_CODE := 'API_VD_111';  --Length of preferred_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_PREFERRED_DEFINITION) > Sbrext_Column_Lengths.L_VD_PREFERRED_DEFINITION THEN
    P_RETURN_CODE := 'API_VD_113';  --Length of Preferrede Definition exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_LONG_NAME) > Sbrext_Column_Lengths.L_VD_LONG_NAME THEN
    P_RETURN_CODE := 'API_VD_114'; --Length of Long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_ASL_NAME ) > Sbrext_Column_Lengths.L_VD_ASL_NAME  THEN
    P_RETURN_CODE := 'API_VD_115'; --Length of asl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_TYPE_FLAG) > Sbrext_Column_Lengths.L_VD_VD_TYPE_FLAG THEN
    P_RETURN_CODE := 'API_VD_118'; --Length of vd_Type_flag exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_DTL_NAME) > Sbrext_Column_Lengths.L_VD_DTL_NAME     THEN
    P_RETURN_CODE := 'API_VD_119'; --Length of dtl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_FORML_NAME) > Sbrext_Column_Lengths.L_VD_FORML_NAME THEN
    P_RETURN_CODE := 'API_VD_120'; --Length of forml_name  exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_FORML_DESCRIPTION) > Sbrext_Column_Lengths.L_FORML_DESCRIPTION THEN
    P_RETURN_CODE := 'API_VD_121'; --Length of forml_description exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_FORML_COMMENT ) > Sbrext_Column_Lengths.L_FORML_COMMENTS  THEN
    P_RETURN_CODE := 'API_VD_129'; --Length of forml_comments exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_UOML_NAME) > Sbrext_Column_Lengths.L_VD_UOML_NAME THEN
    P_RETURN_CODE := 'API_VD_122'; --Length of uoml_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_UOML_DESCRIPTION ) > Sbrext_Column_Lengths.L_UOML_DESCRIPTION  THEN
    P_RETURN_CODE := 'API_VD_123'; --Length of upml_descriptionexceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_UOML_COMMENT) > Sbrext_Column_Lengths.L_UOML_COMMENTS THEN
    P_RETURN_CODE := 'API_VD_124'; --Length of upml_comments exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_LOW_VALUE_NUM ) > Sbrext_Column_Lengths.L_VD_LOW_VALUE_NUM  THEN
    P_RETURN_CODE := 'API_VD_125'; --Length of low_value_num exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_HIGH_VALUE_NUM) > Sbrext_Column_Lengths.L_VD_HIGH_VALUE_NUM THEN
    P_RETURN_CODE := 'API_VD_126'; --Length of high_value_num exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_CHAR_SET_NAME) > Sbrext_Column_Lengths.L_VD_CHAR_SET_NAME THEN
    P_RETURN_CODE := 'API_VD_127'; --Length of char_set_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_CHANGE_NOTE) > Sbrext_Column_Lengths.L_VD_CHANGE_NOTE THEN
    P_RETURN_CODE := 'API_VD_128'; --Length of change_note exceeds maximum length
    RETURN;
  END IF;

  --check to see that charachter strings are valid
  IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_VD_PREFERRED_NAME) THEN
    P_RETURN_CODE := 'API_VD_130'; -- Value Domain Preferred Name has invalid Ccharacters
    RETURN;
  END IF;
  --this block of code has been commented out because formats and unit of measures will have alpha numberic charachters
  /*IF  P_VD_FORML_NAME IS NOT NULL THEN
      IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_VD_FORML_NAME) THEN
      P_RETURN_CODE := 'API_VD_131'; -- Value Domain Format Name has invalid characters
      RETURN;
    END IF;
  END IF;

  IF P_VD_UOML_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_VD_UOML_NAME) THEN
      P_RETURN_CODE := 'API_VD_132'; -- Value Domain UOML Name has invalid characters
      RETURN;
    END IF;
  END IF;
  */
  IF NOT Sbrext_Common_Routines.valid_char(P_VD_PREFERRED_DEFINITION) THEN
    P_RETURN_CODE := 'API_VD_133'; -- Value Domain Preferred Definition has invalid characters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_VD_LONG_NAME) THEN
    P_RETURN_CODE := 'API_VD_134'; -- Value Domain Long Name has invalid characters
    RETURN;
  END IF;
  IF P_FORML_DESCRIPTION IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_FORML_DESCRIPTION) THEN
      P_RETURN_CODE := 'API_VD_135'; -- Format Description has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_FORML_COMMENT IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_FORML_COMMENT) THEN
      P_RETURN_CODE := 'API_VD_136'; -- Format Comment has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_UOML_DESCRIPTION IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_UOML_DESCRIPTION) THEN
      P_RETURN_CODE := 'API_VD_137'; -- Unit of Measure Description has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_UOML_COMMENT IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_UOML_COMMENT) THEN
      P_RETURN_CODE := 'API_VD_138'; -- Unit of Measure Comment has invalid characters
      RETURN;
    END IF;
  END IF;


  --check to see that Context, Workflow Status, Data type, Character Set, Conceptual Domain already exist in the database
  IF P_ACTION = 'INS' THEN
    -- This check should be performed only in inserts as update and delete expect null conte_idseq
    IF NOT Sbrext_Common_Routines.context_exists(P_VD_CONTE_IDSEQ) THEN
      P_RETURN_CODE := 'API_VD_200'; --Context not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_VD_CD_IDSEQ IS NOT NULL THEN -- 24-Jul-2003, W. Ver Hoef
    IF NOT Sbrext_Common_Routines.ac_exists(P_VD_CD_IDSEQ) THEN
      P_RETURN_CODE := 'API_VD_201'; --Conceptual Domain not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_VD_ASL_NAME IS NOT NULL THEN -- 24-Jul-2003, W. Ver Hoef
    IF NOT Sbrext_Common_Routines.workflow_exists(P_VD_ASL_NAME) THEN
      P_RETURN_CODE := 'API_VD_202'; --Workflow Status not found in the database
      RETURN;
    END IF;
  END IF;
  IF (P_VD_CHAR_SET_NAME IS NOT NULL AND P_VD_CHAR_SET_NAME != ' ') THEN
    IF NOT Sbrext_Common_Routines.char_set_exists(P_VD_CHAR_SET_NAME) THEN
      P_RETURN_CODE := 'API_VD_203'; --Character set not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_VD_DTL_NAME IS NOT NULL THEN -- 24-Jul-2003, W. Ver Hoef
    IF NOT Sbrext_Common_Routines.data_type_exists(P_VD_DTL_NAME) THEN
      P_RETURN_CODE := 'API_VD_204'; --DATA_TYPE NOT found in the database
      RETURN;
    END IF;
  END IF;
  IF P_VD_REP_IDSEQ IS NOT NULL AND P_VD_REP_IDSEQ != ' ' THEN
    IF NOT Sbrext_Common_Routines.ac_exists(P_VD_REP_IDSEQ )  THEN
      P_RETURN_CODE := 'API_VD_207'; --Representation term does not exist
      RETURN;
    END IF;
  END IF;
  IF P_VD_QUALIFIER_NAME IS NOT NULL AND P_VD_QUALIFIER_NAME != ' ' THEN
    IF NOT Sbrext_Common_Routines.qual_exists(P_VD_QUALIFIER_NAME )  THEN
      P_RETURN_CODE := 'API_VD_208'; --Qualifier does not exist
      RETURN;
    END IF;
  END IF;

  --check to see that begin data and end date are valid dates
  IF(P_VD_BEGIN_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_VD_BEGIN_DATE,v_begin_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_VD_600'; --begin date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_VD_END_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_VD_END_DATE,v_end_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_VD_601'; --end date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_VD_BEGIN_DATE IS NOT NULL AND P_VD_END_DATE IS NOT NULL) THEN
    IF(v_end_date < v_begin_date) THEN
      P_RETURN_CODE := 'API_VD_210'; --end date is before begin date
      RETURN;
    END IF;
  --ELSIF(P_VD_END_DATE IS NOT NULL AND P_VD_BEGIN_DATE IS NULL) THEN
   -- P_RETURN_CODE := 'API_VD_211'; --begin date cannot be null when end date is null
    --RETURN;
  END IF;

  --check to see that format description  or comments are sent in without the formt name
  IF(P_VD_FORML_NAME IS NULL AND ( P_FORML_DESCRIPTION IS NOT NULL OR P_FORML_COMMENT IS NOT NULL)) THEN
    P_RETURN_CODE := 'API_VD_205'; --cannot send in format description and comments without format name
    RETURN;
  END IF;
  IF(P_VD_UOML_NAME IS NULL AND ( P_UOML_DESCRIPTION IS NOT NULL OR P_UOML_COMMENT IS NOT NULL)) THEN
    P_RETURN_CODE := 'API_VD_206'; --cannot send in UOML description and comments without UOML name
    RETURN;
  END IF;

  --check to see that Format, Unit of measure already exist in the database , ifthey do not then create them
  IF( P_VD_FORML_NAME IS NOT NULL AND P_VD_FORML_NAME != ' ' ) THEN

    IF NOT(Sbrext_Common_Routines.vd_format_exists(P_VD_FORML_NAME)) THEN
      v_forml_rec.forml_name  := P_VD_FORML_NAME;
      v_forml_rec.description := P_FORML_DESCRIPTION;
      v_forml_rec.comments    := P_FORML_COMMENT;
      v_forml_ind.forml_name  := TRUE;
      v_forml_ind.description := TRUE;
      v_forml_ind.comments    := TRUE;
      BEGIN
        cg$formats_lov_view.ins(v_forml_rec,v_forml_ind);
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_FORML_500' ;--error inserting format
      END;
    END IF;
  END IF;

  IF (P_VD_UOML_NAME IS NOT NULL AND P_VD_UOML_NAME != ' ') THEN
    IF NOT(Sbrext_Common_Routines.uoml_exists(P_VD_UOML_NAME)) THEN
      v_uoml_rec.uoml_name   := P_VD_UOML_NAME;
      v_uoml_rec.description := P_UOML_DESCRIPTION;
      v_uoml_rec.comments    := P_UOML_COMMENT;
      v_uoml_ind.uoml_name   := TRUE;
      v_uoml_ind.description := TRUE;
      v_uoml_ind.comments    := TRUE;
      BEGIN
        cg$Unit_of_measures_lov_view.ins(v_uoml_rec,v_uoml_ind);
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_UOML_500' ;--error inserting UOML
       RETURN;
      END;
    END IF;
  END IF;

  IF (P_ACTION = 'INS' ) THEN

    --check to see that  a Value Domain with the same
    --Preferred Name, Context and Version does not already exist
    IF Sbrext_Common_Routines.ac_exists(P_VD_PREFERRED_NAME,P_VD_CONTE_IDSEQ ,P_VD_VERSION,'VALUEDOMAIN') THEN
      P_RETURN_CODE := 'API_VD_300';-- Value Domain already Exists
      RETURN;
    END IF;
    --Check to see if prior versions alresdy exist
    IF Sbrext_Common_Routines.ac_version_exists(P_VD_PREFERRED_NAME,P_VD_CONTE_IDSEQ ,'VALUEDOMAIN') THEN -- we are creating a new version
      v_new_version := TRUE;
      v_ac          := Sbrext_Common_Routines.get_version_ac(P_VD_PREFERRED_NAME,P_VD_CONTE_IDSEQ,'VALUEDOMAIN');
    END IF;

 if p_vd_preferred_name = 'System Generated' then
   v_vd_preferred_name := null;
 else
   v_vd_preferred_name := p_vd_preferred_name;
 end if;
    --add code here to check for versioning
    P_VD_VD_IDSEQ      := admincomponent_crud.cmr_guid;
    P_VD_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_VD_CREATED_BY    := ADMIN_SECURITY_UTIL.effective_user;
    P_VD_DATE_MODIFIED := NULL;
    P_VD_MODIFIED_BY   := NULL;
    P_VD_DELETED_IND   := 'No';

    v_vd_rec.vd_idseq           := P_VD_VD_IDSEQ;
    v_vd_rec.preferred_name       := V_VD_PREFERRED_NAME;
    v_vd_rec.conte_idseq       := P_VD_CONTE_IDSEQ;
    v_vd_rec.version           := P_VD_VERSION;
    v_vd_rec.preferred_definition := P_VD_PREFERRED_DEFINITION;
    v_vd_rec.long_name           := P_VD_LONG_NAME;
    v_vd_rec.asl_name           := P_VD_ASL_NAME ;
    v_vd_rec.cd_idseq           := P_VD_CD_IDSEQ ;
    v_vd_rec.latest_version_ind   := P_VD_LATEST_VERSION_IND;
    v_vd_rec.vd_type_flag       := P_VD_TYPE_FLAG;
    v_vd_rec.dtl_name           := P_VD_DTL_NAME;
    v_vd_rec.forml_name        := P_VD_FORML_NAME;
    v_vd_rec.uoml_name            := P_VD_UOML_NAME;
    v_vd_rec.low_value_num       := P_VD_LOW_VALUE_NUM;
    v_vd_rec.high_value_num       := P_VD_HIGH_VALUE_NUM;
    v_vd_rec.min_length_num       := P_VD_MIN_LENGTH_NUM;
    v_vd_rec.max_length_num       := P_VD_MAX_LENGTH_NUM ;
    v_vd_rec.decimal_place        := P_VD_DECIMAL_PLACE;
    v_vd_rec.char_set_name       := P_VD_CHAR_SET_NAME;
    v_vd_rec.begin_date           := TO_DATE(P_VD_BEGIN_DATE);
    v_vd_rec.end_date           := TO_DATE(P_VD_END_DATE);
    v_vd_rec.change_note       := P_VD_CHANGE_NOTE ;
    v_vd_rec.created_by           := P_VD_CREATED_BY;
    v_vd_rec.date_created       := TO_DATE(P_VD_DATE_CREATED);
    v_vd_rec.modified_by       := P_VD_MODIFIED_BY;
    v_vd_rec.date_modified       := TO_DATE(P_VD_DATE_MODIFIED);
    v_vd_rec.deleted_ind          := P_VD_DELETED_IND;
    v_vd_rec.rep_idseq            := P_VD_REP_IDSEQ;
    v_vd_rec.qualifier_name       := P_VD_QUALIFIER_NAME;
    v_vd_rec.condr_idseq       := P_VD_CONDR_IDSEQ;
 v_vd_rec.origin               := P_VD_ORIGIN;  -- 24-Jul-2003, W. Ver Hoef

    v_vd_ind.vd_idseq           := TRUE;
    v_vd_ind.preferred_name       := TRUE;
    v_vd_ind.conte_idseq       := TRUE;
    v_vd_ind.version           := TRUE;
    v_vd_ind.preferred_definition := TRUE;
    v_vd_ind.long_name           := TRUE;
    v_vd_ind.asl_name           := TRUE;
    v_vd_ind.cd_idseq           := TRUE;
    v_vd_ind.latest_version_ind   := TRUE;
    v_vd_ind.vd_type_flag       := TRUE;
    v_vd_ind.dtl_name           := TRUE;
    v_vd_ind.forml_name        := TRUE;
    v_vd_ind.uoml_name            := TRUE;
    v_vd_ind.low_value_num       := TRUE;
    v_vd_ind.high_value_num       := TRUE;
    v_vd_ind.min_length_num       := TRUE;
    v_vd_ind.max_length_num       := TRUE;
    v_vd_ind.decimal_place        := TRUE;
    v_vd_ind.char_set_name       := TRUE;
    v_vd_ind.begin_date           := TRUE;
    v_vd_ind.end_date           := TRUE;
    v_vd_ind.change_note       := TRUE;
    v_vd_ind.created_by           := TRUE;
    v_vd_ind.date_created       := TRUE;
    v_vd_ind.modified_by       := TRUE;
    v_vd_ind.date_modified       := TRUE;
    v_vd_ind.deleted_ind          := TRUE;
    v_vd_ind.rep_idseq            := TRUE;
    v_vd_ind.qualifier_name       := TRUE;
    v_vd_ind.condr_idseq       := TRUE;
 v_vd_ind.origin               := TRUE; -- 24-Jul-2003, W. Ver Hoef

    BEGIN
      --meta_global_pkg.transaction_type := 'VERSION';

      cg$value_domains_view.ins(v_vd_rec,v_vd_ind);

   if p_vd_preferred_name = 'System Generated' then

     p_vd_preferred_name := sbrext_common_routines.GENERATE_VD_PREFERRED_NAME(p_vd_vd_idseq);
  update value_domains
  set preferred_name = p_vd_preferred_name
  where vd_idseq = p_vd_vd_idseq;
   end if;

      --meta_global_pkg.transaction_type := NULL;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_VD_500'; --Error inserting Value Domain
    END;

    --If LATEST_VERSION_IND is'Yes' then update so that all other versions have the indicator set to 'No'
    IF(P_VD_LATEST_VERSION_IND = 'Yes') THEN
      Sbrext_Common_Routines.set_ac_lvi(P_RETURN_CODE,P_VD_VD_IDSEQ,'VALUEDOMAIN');
      IF P_RETURN_CODE IS NOT NULL  THEN
        P_RETURN_CODE := 'API_VD_503'; -- Error updating latest_Value_ind
        RETURN;
      END IF;
    END IF;
    --create a history record with prior version
    IF v_new_version THEN
      BEGIN
        meta_config_mgmt.CREATE_AC_HISTORIES (v_ac,P_VD_VD_IDSEQ,'VERSIONED','VALUEDOMAIN');
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_VD_504'; --Error creating history
      END;
    END IF;

  END IF;

  IF (P_ACTION = 'UPD' ) THEN

    --Get the version for the P_VD_VDIDSEQ
    SELECT version
 INTO   v_version
    FROM   value_domains_view
    WHERE  vd_idseq = P_VD_VD_IDSEQ;

 IF P_VD_VERSION IS NOT NULL THEN  -- 24-JUL-2003, W. Ver Hoef
      IF v_version <> P_VD_VERSION THEN
        P_RETURN_CODE := 'API_VD_402'; -- Version can NOT be updated. It can only be created
        RETURN;
      END IF;
 END IF;

    P_VD_DATE_MODIFIED := TO_CHAR(SYSDATE);
    P_VD_MODIFIED_BY   := ADMIN_SECURITY_UTIL.effective_user;
    P_VD_DELETED_IND   := 'No';

    v_vd_rec.date_modified := P_VD_DATE_MODIFIED;
    v_vd_rec.modified_by   := P_VD_MODIFIED_BY;
    v_vd_rec.vd_idseq      := P_VD_VD_IDSEQ;
    v_vd_rec.deleted_ind   := 'No';

    v_vd_ind.date_modified := TRUE;
    v_vd_ind.modified_by   := TRUE;
    v_vd_ind.deleted_ind   := TRUE;
    v_vd_ind.vd_idseq      := TRUE;

    v_vd_ind.version       := FALSE;
    v_vd_ind.created_by    := FALSE;
    v_vd_ind.date_created  := FALSE;

    IF P_VD_PREFERRED_NAME IS NULL THEN
      v_vd_ind.preferred_name := FALSE;
    ELSE
  if p_vd_preferred_name = 'System Generated' then
    v_vd_rec.preferred_name := sbrext_common_routines.GENERATE_VD_PREFERRED_NAME(p_vd_vd_idseq);
     else
   v_vd_rec.preferred_name := P_VD_PREFERRED_NAME;
  end if;
      v_vd_ind.preferred_name := TRUE;
    END IF;

    IF P_VD_CONTE_IDSEQ IS NULL THEN
      v_vd_ind.conte_idseq := FALSE;
    ELSE
      v_vd_rec.conte_idseq := P_VD_CONTE_IDSEQ;
      v_vd_ind.conte_idseq := TRUE;
    END IF;

    IF P_VD_PREFERRED_DEFINITION IS NULL THEN
      v_vd_ind.preferred_definition:= FALSE;
    ELSE
      v_vd_rec.preferred_definition := P_VD_PREFERRED_DEFINITION;
      v_vd_ind.preferred_definition := TRUE;
    END IF;

    IF P_VD_LONG_NAME IS NULL THEN
      v_vd_ind.long_name := FALSE;
 ELSIF P_VD_LONG_NAME = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.long_name := NULL;
      v_vd_ind.long_name := TRUE;
    ELSE
      v_vd_rec.long_name := P_VD_LONG_NAME;
      v_vd_ind.long_name := TRUE;
    END IF;

    IF P_VD_ASL_NAME IS NULL THEN
      v_vd_ind.asl_name := FALSE;
    ELSE
      v_vd_rec.asl_name := P_VD_ASL_NAME;
      v_vd_ind.asl_name := TRUE;
    END IF;

    IF P_VD_CD_IDSEQ IS NULL THEN
      v_vd_ind.cd_idseq := FALSE;
    ELSE
      v_vd_rec.cd_idseq := P_VD_CD_IDSEQ;
      v_vd_ind.cd_idseq := TRUE;
    END IF;

    IF P_VD_LATEST_VERSION_IND IS NULL THEN
      v_vd_ind.latest_version_ind := FALSE;
    ELSE
      v_vd_rec.latest_version_ind := P_VD_LATEST_VERSION_IND;
      v_vd_ind.latest_version_ind := TRUE;
    END IF;

    IF P_VD_TYPE_FLAG IS NULL THEN
      v_vd_ind.vd_type_flag := FALSE;
    ELSE
      v_vd_rec.vd_type_flag := P_VD_TYPE_FLAG;
      v_vd_ind.vd_type_flag := TRUE;
    END IF;

    IF P_VD_DTL_NAME IS NULL THEN
      v_vd_ind.dtl_name := FALSE;
    ELSE
      v_vd_rec.dtl_name := P_VD_DTL_NAME;
      v_vd_ind.dtl_name := TRUE;
    END IF;

    IF P_VD_FORML_NAME IS NULL THEN
      v_vd_ind.forml_name := FALSE;
 ELSIF P_VD_FORML_NAME = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.forml_name := NULL;
      v_vd_ind.forml_name := TRUE;
    ELSE
      v_vd_rec.forml_name := P_VD_FORML_NAME;
      v_vd_ind.forml_name := TRUE;
    END IF;

    IF P_VD_UOML_NAME IS NULL THEN
      v_vd_ind.uoml_name := FALSE;
 ELSIF P_VD_UOML_NAME = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.uoml_name := NULL;
      v_vd_ind.uoml_name := TRUE;
    ELSE
      v_vd_rec.uoml_name := P_VD_UOML_NAME ;
      v_vd_ind.uoml_name := TRUE;
    END IF;

    IF P_VD_LOW_VALUE_NUM IS NULL THEN
      v_vd_ind.low_value_num := FALSE;
 ELSIF P_VD_low_value_num = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.low_value_num := NULL;
      v_vd_ind.low_value_num := TRUE;
    ELSE
      v_vd_rec.low_value_num := P_VD_LOW_VALUE_NUM;
      v_vd_ind.low_value_num := TRUE;
    END IF;

    IF P_VD_HIGH_VALUE_NUM IS NULL THEN
      v_vd_ind.high_Value_num := FALSE;
 ELSIF P_VD_high_value_num = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.high_value_num := NULL;
      v_vd_ind.high_value_num := TRUE;
    ELSE
      v_vd_rec.high_value_num := P_VD_HIGH_VALUE_NUM;
      v_vd_ind.high_value_num := TRUE;
    END IF;

    IF P_VD_MIN_LENGTH_NUM IS NULL THEN
      v_vd_ind.min_length_num := FALSE;
 ELSIF P_VD_min_length_num = -1 THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.min_length_num := NULL;
      v_vd_ind.min_length_num := TRUE;
    ELSE
      v_vd_rec.min_length_num := P_VD_MIN_LENGTH_NUM;
      v_vd_ind.min_length_num := TRUE;
    END IF;

    IF P_VD_MAX_LENGTH_NUM  IS NULL THEN
     v_vd_ind.max_length_num := FALSE;
 ELSIF P_VD_max_length_num = -1 THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.max_length_num := NULL;
      v_vd_ind.max_length_num := TRUE;
    ELSE
     v_vd_rec.max_length_num := P_VD_MAX_LENGTH_NUM ;
     v_vd_ind.max_length_num := TRUE;
    END IF;

    IF P_VD_DECIMAL_PLACE IS NULL THEN
      v_vd_ind.decimal_place := FALSE;
 ELSIF P_VD_decimal_place = -1 THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.decimal_place := NULL;
      v_vd_ind.decimal_place := TRUE;
    ELSE
      v_vd_rec.decimal_place := P_VD_DECIMAL_PLACE;
      v_vd_ind.decimal_place := TRUE;
    END IF;

    IF P_VD_CHAR_SET_NAME IS NULL THEN
      v_vd_ind.char_set_name := FALSE;
 ELSIF P_VD_char_set_name = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.char_set_name := NULL;
      v_vd_ind.char_set_name := TRUE;
    ELSE
      v_vd_rec.char_set_name := P_VD_CHAR_SET_NAME;
      v_vd_ind.char_set_name := TRUE;
    END IF;

    IF P_VD_BEGIN_DATE IS NULL THEN
      v_vd_ind.begin_date := FALSE;
 ELSIF P_VD_begin_date = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.begin_date := NULL;
      v_vd_ind.begin_date := TRUE;
    ELSE
      v_vd_rec.begin_date := TO_DATE(P_VD_BEGIN_DATE);
      v_vd_ind.begin_date := TRUE;
    END IF;

    IF P_VD_END_DATE  IS NULL THEN
      v_vd_ind.end_date := FALSE;
 ELSIF P_VD_end_date = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.end_date := NULL;
      v_vd_ind.end_date := TRUE;
    ELSE
      v_vd_rec.end_date := TO_DATE(P_VD_END_DATE);
      v_vd_ind.end_date := TRUE;
    END IF;

    IF P_VD_CHANGE_NOTE   IS NULL THEN
      v_vd_ind.change_note := FALSE;
 ELSIF P_VD_change_note = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.change_note := NULL;
      v_vd_ind.change_note := TRUE;
    ELSE
      v_vd_rec.change_note := P_VD_CHANGE_NOTE  ;
      v_vd_ind.change_note := TRUE;
    END IF;

    IF P_VD_REP_IDSEQ  IS NULL THEN
      v_vd_ind.rep_idseq := FALSE;
 ELSIF P_VD_REP_IDSEQ = ' ' THEN -- Condition added on 7/30/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.rep_idseq := NULL;
      v_vd_ind.rep_idseq := TRUE;
    ELSE
      v_vd_rec.rep_idseq := P_VD_REP_IDSEQ;
      v_vd_ind.rep_idseq := TRUE;
    END IF;

    IF P_VD_QUALIFIER_NAME   IS NULL THEN
      v_vd_ind.qualifier_name := FALSE;
 ELSIF P_VD_QUALIFIER_NAME = ' ' THEN -- Condition added on 7/30/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.qualifier_name := NULL;
      v_vd_ind.qualifier_name := TRUE;
    ELSE
      v_vd_rec.qualifier_name := P_VD_QUALIFIER_NAME  ;
      v_vd_ind.qualifier_name := TRUE;
    END IF;

 IF P_VD_CONDR_IDSEQ   IS NULL THEN
      v_vd_ind.condr_idseq := FALSE;
 ELSIF P_VD_CONDR_IDSEQ = ' ' THEN
   v_vd_rec.condr_idseq := NULL;
      v_vd_ind.condr_idseq := TRUE;
    ELSE
      v_vd_rec.condr_idseq := P_VD_CONDR_IDSEQ  ;
      v_vd_ind.condr_idseq := TRUE;
    END IF;

    IF P_VD_ORIGIN   IS NULL THEN  -- 24-Jul-2003, W. Ver Hoef
      v_vd_ind.origin := FALSE;
 ELSIF P_VD_origin = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.origin := NULL;
      v_vd_ind.origin := TRUE;
    ELSE
      v_vd_rec.origin := P_VD_ORIGIN  ;
      v_vd_ind.origin := TRUE;
    END IF;

    BEGIN
      cg$value_domains_view.upd(v_vd_rec,v_vd_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := sqlerrm;--'API_VD_501'; --Error updating Value Domain
    END;

    --If LATEST_VERSION_IND is'Yes' then update so that all other versions have the indicator set to 'No'
    IF(P_VD_LATEST_VERSION_IND = 'Yes') THEN
      Sbrext_Common_Routines.set_ac_lvi(P_RETURN_CODE,P_VD_VD_IDSEQ,'VALUEDOMAIN');
      IF P_RETURN_CODE IS NOT NULL  THEN
        P_RETURN_CODE := 'API_VD_503'; -- Error updating latest_Value_ind
        RETURN;
      END IF;
    END IF;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;
END SET_VD;

PROCEDURE SET_DEC(
 P_RETURN_CODE        OUT    VARCHAR2
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
,P_DEC_ORIGIN               IN     VARCHAR2 DEFAULT NULL )  IS -- 15-Jul-2003, W. Ver Hoef
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

BEGIN

  P_RETURN_CODE := NULL;

  IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
    P_RETURN_CODE := 'API_DEC_700'; -- Invalid action
    RETURN;
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
    P_DEC_MODIFIED_BY       := 'USER';
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
    P_DEC_CREATED_BY    := ADMIN_SECURITY_UTIL.effective_user;
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
    P_DEC_MODIFIED_BY   := ADMIN_SECURITY_UTIL.effective_user;
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




PROCEDURE SET_VM(
P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_VM_SHORT_MEANING         IN OUT VARCHAR2
,P_VM_DESCRIPTION         IN OUT VARCHAR2
,P_VM_COMMENTS             IN OUT VARCHAR2
,P_VM_BEGIN_DATE         IN OUT VARCHAR2
,P_VM_END_DATE             IN OUT VARCHAR2
,P_VM_CREATED_BY         OUT VARCHAR2
,P_VM_DATE_CREATED         OUT VARCHAR2
,P_VM_MODIFIED_BY         OUT VARCHAR2
,P_VM_DATE_MODIFIED         OUT VARCHAR2 )  IS
/******************************************************************************
   NAME:       SET_VM
   PURPOSE:    Inserts or Updates a Single Row Of  Value Meanings List of Value
               Based on short Meaning

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal  1. Created this procedure
   2.1        04/16/2004  W. Ver Hoef      1. corrected assignment of v_begin_date and
                                              v_end_date after calling
             sbrext_common_routines.valid_date because
             it was currently not assigning the out param;
             2. added v_vm_rec.short_meaning assignment
             which was missing

******************************************************************************/

  v_begin_date DATE := NULL;
  v_end_date DATE := NULL;

  v_vm_rec    cg$value_meanings_lov_view.cg$row_type;
  v_vm_ind    cg$value_meanings_lov_view.cg$ind_type;

BEGIN

P_RETURN_CODE := NULL;

 IF P_ACTION IS NULL THEN
   P_RETURN_CODE := 'API_VM_701'; -- NULL action
   RETURN;
 ELSIF P_ACTION NOT IN ('INS','UPD') THEN
   P_RETURN_CODE := 'API_VM_700'; -- Invalid action
   RETURN;
 END IF;


IF P_ACTION = 'INS' THEN              --we are inserting a record
     --Check to see that all mandatory parameters are either not null
  IF P_VM_SHORT_MEANING IS NULL THEN
    P_RETURN_CODE := 'API_VM_101';  --Value Meaning cannot be null here
 RETURN;
  END IF;
END IF;

IF P_ACTION = 'UPD'  THEN
  IF P_VM_SHORT_MEANING IS NULL THEN
    P_RETURN_CODE := 'API_VM_101';  --Value Meaning cannot be null here
 RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.vm_exists(p_short_meaning=>P_VM_SHORT_MEANING) THEN
   P_RETURN_CODE := 'API_VM_005'; --VM not found
   RETURN;
  END IF;
END IF;
--Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
IF LENGTH(P_VM_SHORT_MEANING) > Sbrext_Column_Lengths.L_VM_SHORT_MEANING THEN
  P_RETURN_CODE := 'API_VM_111';  --Length of SHORT_MEANING exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_VM_DESCRIPTION) > Sbrext_Column_Lengths.L_VM_DESCRIPTION THEN
  P_RETURN_CODE := 'API_VM_113';  --Length of DESCRIPTION exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_VM_COMMENTS) > Sbrext_Column_Lengths.L_VM_COMMENTS THEN
  P_RETURN_CODE := 'API_VM_114'; --Length of COMMENTS exceeds maximum length
  RETURN;
END IF;

--check to see that charachter strings are valid
IF NOT Sbrext_Common_Routines.valid_char(P_VM_SHORT_MEANING) THEN
  P_RETURN_CODE := 'API_VM_130'; -- Value Meaning Short Meaning has invalid characters
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.valid_char(P_VM_DESCRIPTION) THEN
  P_RETURN_CODE := 'API_VM_133'; -- Value Meaning Description has invalid characters
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.valid_char(P_VM_COMMENTS) THEN
  P_RETURN_CODE := 'API_VM_134'; -- Value Meaning Comment has invalid characters
  RETURN;
END IF;
  --check to see that begin data and end date are valid dates

IF(P_VM_BEGIN_DATE IS NOT NULL) THEN
  Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_VM_BEGIN_DATE,V_BEGIN_DATE);
  IF P_RETURN_CODE IS NOT NULL THEN
    P_RETURN_CODE := 'API_VM_600'; --begin date is invalid
    RETURN;
  END IF;
  -- 16-Apr-2004, W. Ver Hoef - added assignment because currently valid_date doesn't
  --                            populate v_begin_date and later references were thus null
  IF v_begin_date IS NULL THEN
    BEGIN
      v_begin_date := TO_DATE(p_vm_begin_date,'DD-MON-YYYY');
 EXCEPTION WHEN OTHERS THEN
   p_return_code := 'API_VM_600';
   RETURN;
 END;
  END IF;
END IF;

IF(P_VM_END_DATE IS NOT NULL) THEN
  Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_VM_END_DATE,V_END_DATE);
  IF P_RETURN_CODE IS NOT NULL THEN
   P_RETURN_CODE := 'API_VM_601'; --end date is invalid
   RETURN;
  END IF;
  -- 16-Apr-2004, W. Ver Hoef - added assignment because currently valid_date doesn't
  --                            populate v_begin_date and later references were thus null
  IF v_end_date IS NULL THEN
    BEGIN
      v_end_date := TO_DATE(p_vm_end_date,'DD-MON-YYYY');
 EXCEPTION WHEN OTHERS THEN
   p_return_code := 'API_VM_601';
   RETURN;
 END;
  END IF;
END IF;

IF(P_VM_BEGIN_DATE IS NOT NULL AND P_VM_END_DATE IS NOT NULL) THEN
  IF(v_end_date < v_begin_date) THEN
     P_RETURN_CODE := 'API_VM_210'; --end date is before begin date
     RETURN;
  END IF;
ELSIF(P_VM_END_DATE IS NOT NULL AND P_VM_BEGIN_DATE IS NULL) THEN
  P_RETURN_CODE := 'API_VM_211'; --begin date cannot be null when end date is null
  RETURN;
END IF;


IF (P_ACTION = 'INS' ) THEN

--check to see that Short Name Does not already Exist
  IF Sbrext_Common_Routines.vm_exists(p_short_meaning=>P_VM_SHORT_MEANING) THEN
    P_RETURN_CODE := 'API_VM_300';-- Value Meaning already exists
    RETURN;
  END IF;

  P_VM_DATE_CREATED := TO_CHAR(SYSDATE);
  P_VM_CREATED_BY := ADMIN_SECURITY_UTIL.effective_user;
  P_VM_DATE_MODIFIED := NULL;
  P_VM_MODIFIED_BY := NULL;
  P_VM_BEGIN_DATE := TO_CHAR(v_begin_date);
  P_VM_END_DATE := TO_CHAR(v_end_date);

  v_vm_rec.short_meaning := P_VM_SHORT_MEANING;
  v_vm_rec.description      := P_VM_DESCRIPTION;
  v_vm_rec.comments         := P_VM_COMMENTS;
  v_vm_rec.begin_date     := P_VM_BEGIN_DATE;
  v_vm_rec.end_date         := P_VM_END_DATE;
  v_vm_rec.created_by     := P_VM_CREATED_BY;
  v_vm_rec.date_created     := P_VM_DATE_CREATED;
  v_vm_rec.modified_by     := P_VM_MODIFIED_BY;
  v_vm_rec.date_modified := P_VM_DATE_MODIFIED;


  v_vm_ind.short_meaning   := TRUE;
  v_vm_ind.description        := TRUE;
  v_vm_ind.comments           := TRUE;
  v_vm_ind.begin_date       := TRUE;
  v_vm_ind.end_date           := TRUE;
  v_vm_ind.created_by       := TRUE;
  v_vm_ind.date_created       := TRUE;
  v_vm_ind.modified_by       := TRUE;
  v_vm_ind.date_modified   := TRUE;

  BEGIN
    cg$Value_meanings_lov_view.ins(v_vm_rec,v_vm_ind);
  EXCEPTION WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
    P_RETURN_CODE := 'API_VM_500'; --Error inserting Value Meaning
  END;

END IF;


IF (P_ACTION = 'UPD' ) THEN

  -- 16-Apr-2004, W. Ver Hoef - added v_vm_rec.short_meaning assignment which was missing
  v_vm_rec.short_meaning := P_VM_SHORT_MEANING;

  P_VM_DATE_MODIFIED := TO_CHAR(SYSDATE);
  P_VM_MODIFIED_BY := ADMIN_SECURITY_UTIL.effective_user;

  P_VM_BEGIN_DATE := TO_CHAR(v_begin_date);
  P_VM_END_DATE := TO_CHAR(v_end_date);

  v_vm_rec.date_modified := P_VM_DATE_MODIFIED;
  v_vm_rec.modified_by := P_VM_MODIFIED_BY;

  v_vm_ind.date_modified := TRUE;
  v_vm_ind.modified_by := TRUE;

  v_vm_ind.created_by := FALSE;
  v_vm_ind.date_created := FALSE;

  IF P_VM_DESCRIPTION IS NULL THEN
    v_vm_ind.description := FALSE;
  ELSE
    v_vm_rec.description := P_VM_DESCRIPTION;
    v_vm_ind.description := TRUE;
  END IF;

  IF P_VM_COMMENTS IS NULL THEN
    v_vm_ind.comments := FALSE;
  ELSE
    v_vm_rec.comments := P_VM_COMMENTS;
    v_vm_ind.comments := TRUE;
  END IF;

  IF P_VM_BEGIN_DATE IS NULL THEN
    v_vm_ind.begin_date := FALSE;
  ELSE
    v_vm_rec.begin_date := P_VM_BEGIN_DATE;
    v_vm_ind.begin_date := TRUE;
  END IF;

  IF P_VM_END_DATE IS NULL THEN
    v_vm_ind.end_date := FALSE;
  ELSE
    v_vm_rec.end_date := P_VM_END_DATE ;
    v_vm_ind.end_date := TRUE;
  END IF;

  BEGIN
    cg$Value_meanings_lov_view.upd(v_vm_rec,v_vm_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_VM_501'; --Error updating value meaning
  END;
END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;
END SET_VM;



-- overloaded version
PROCEDURE SET_VM(
  P_RETURN_CODE             OUT VARCHAR2
  ,P_ACTION                   IN VARCHAR2
  ,P_VM_SHORT_MEANING         IN OUT VARCHAR2
  ,P_VM_DESCRIPTION         IN OUT VARCHAR2
  ,P_VM_COMMENTS             IN OUT VARCHAR2
  ,P_VM_BEGIN_DATE         IN OUT VARCHAR2
  ,P_VM_END_DATE             IN OUT VARCHAR2
  ,P_VM_CREATED_BY         OUT VARCHAR2
  ,P_VM_DATE_CREATED         OUT VARCHAR2
  ,P_VM_MODIFIED_BY         OUT VARCHAR2
  ,P_VM_DATE_MODIFIED         OUT VARCHAR2
  ,P_VM_VM_IDSEQ              OUT VARCHAR2) IS
  /*
  ** Wrapper procedure for set_vm that includes vm_idseq as an
  **   additional OUT parameter.
  */
  BEGIN
  -- Call original version
  sbrext.sbrext_set_row.set_vm(p_return_code => p_return_code
                       ,p_action      => p_action
        ,p_vm_short_meaning => p_vm_short_meaning
        ,p_vm_description   => p_vm_description
        ,p_vm_comments      => p_vm_comments
        ,p_vm_begin_date    => p_vm_begin_date
        ,p_vm_end_date      => p_vm_end_date
        ,p_vm_created_by    => p_vm_created_by
        ,p_vm_date_created  => p_vm_date_created
        ,p_vm_modified_by   => p_vm_modified_by
        ,p_vm_date_modified => p_vm_date_modified);
  -- add vm_idseq
  p_vm_vm_idseq := get_vm_idseq (p_ShortMeaning => p_vm_short_meaning);
  EXCEPTION
    WHEN OTHERS THEN
     RAISE;
  END set_vm;

-- additional overloaded version: ScenPro (4/24/2007)

 PROCEDURE SET_VM(
   P_UA_NAME       IN  VARCHAR2
   ,P_RETURN_CODE             OUT VARCHAR2
  ,P_ACTION                   IN OUT VARCHAR2
  ,P_CON_ARRAY    IN VARCHAR2
  ,P_VM_IDSEQ     IN OUT VARCHAR2
  ,P_PREFERRED_NAME   IN OUT VARCHAR2
  ,P_LONG_NAME    IN OUT VARCHAR2
  ,P_PREFERRED_DEFINITION  IN OUT VARCHAR2
  ,P_CONTE_IDSEQ    IN OUT VARCHAR2
  ,P_ASL_NAME     IN OUT VARCHAR2
  ,P_VERSION     IN OUT VARCHAR2
  ,P_VM_ID     IN OUT VARCHAR2
  ,P_LATEST_VERSION_IND     IN OUT VARCHAR2
  ,P_CONDR_IDSEQ    IN OUT VARCHAR2
  ,P_DEFINITION_SOURCE  IN OUT VARCHAR2
  ,P_ORIGIN     IN OUT VARCHAR2
  ,P_CHANGE_NOTE          IN OUT VARCHAR2
  ,P_BEGIN_DATE          IN OUT VARCHAR2
  ,P_END_DATE              IN OUT VARCHAR2
  ,P_CREATED_BY          OUT VARCHAR2
  ,P_DATE_CREATED          OUT VARCHAR2
  ,P_MODIFIED_BY          OUT VARCHAR2
  ,P_DATE_MODIFIED         OUT VARCHAR2
 )  IS

 /******************************************************************************
    NAME:       SET_VM
    PURPOSE:    Inserts or Updates a Single Row Of  Value Meanings List of Value
                Based on short Meaning

 ******************************************************************************/

   v_begin_date DATE := NULL;
   v_end_date DATE := NULL;
   v_vm_idseq administered_components.ac_idseq%type;

   v_vm_rec    cg$value_meanings_view.cg$row_type;
   v_vm_ind    cg$value_meanings_view.cg$ind_type;

   v_Exists NUMBER;
   v_version number;
  v_Action varchar2(20);
 BEGIN

 P_RETURN_CODE := NULL;

 IF P_CON_ARRAY IS NOT NULL THEN

      SBREXT.SBREXT_GET_ROW.GET_VM_CONDR ( P_CON_ARRAY, P_RETURN_CODE, P_LONG_NAME, P_CONDR_IDSEQ, P_PREFERRED_DEFINITION, V_ACTION );
    --return if error was found
    IF P_RETURN_CODE IS NOT NULL THEN
       RETURN;
    END IF;
 END IF;


    IF P_ACTION IS NULL THEN
      P_RETURN_CODE := 'API_VM_701'; -- NULL action
      RETURN;
    ELSIF P_ACTION NOT IN ('INS','UPD') THEN
      P_RETURN_CODE := 'API_VM_700'; -- Invalid action
      RETURN;
    END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;


 IF P_ACTION = 'INS' THEN              --we are inserting a record
      --Check to see that all mandatory parameters are not null
   IF P_VM_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_VM_101';  --For inserts id is generated
  RETURN;
   END IF;
 END IF;

 IF P_ACTION = 'UPD'  THEN
  admin_security_util.seteffectiveuser(p_ua_name);
   IF P_VM_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_VM_102';  --Value Meaning idseq cannot be null here
  RETURN;
   END IF;
   IF NOT Sbrext_Common_Routines.vm_exists(p_vm_idseq=>P_VM_IDSEQ) THEN
  P_RETURN_CODE := 'API_VM_005'; --VM not found
  RETURN;
   END IF;
 END IF;

 --Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
 IF LENGTH(P_LONG_NAME) > Sbrext_Column_Lengths.L_VM_LONG_NAME THEN
   P_RETURN_CODE := 'API_VM_111';  --Length of SHORT_MEANING exceeds maximum length
   RETURN;
 END IF;
 IF LENGTH(P_PREFERRED_DEFINITION) > Sbrext_Column_Lengths.L_VM_PREFERRED_DEFINITION THEN
   P_RETURN_CODE := 'API_VM_113';  --Length of DESCRIPTION exceeds maximum length
   RETURN;
 END IF;
 IF LENGTH(P_CHANGE_NOTE) > Sbrext_Column_Lengths.L_VM_CHANGE_NOTE THEN
   P_RETURN_CODE := 'API_VM_114'; --Length of COMMENTS exceeds maximum length
   RETURN;
 END IF;

 --check to see that charachter strings are valid
 IF NOT Sbrext_Common_Routines.valid_char(P_LONG_NAME) THEN
   P_RETURN_CODE := 'API_VM_130'; -- Value Meaning Short Meaning has invalid characters
   RETURN;
 END IF;
 IF NOT Sbrext_Common_Routines.valid_char(P_PREFERRED_DEFINITION) THEN
   P_RETURN_CODE := 'API_VM_133'; -- Value Meaning Description has invalid characters
   RETURN;
 END IF;
 IF NOT Sbrext_Common_Routines.valid_char(P_CHANGE_NOTE) THEN
   P_RETURN_CODE := 'API_VM_134'; -- Value Meaning Comment has invalid characters
   RETURN;
 END IF;
   --check to see that begin data and end date are valid dates

 IF(P_BEGIN_DATE IS NOT NULL) THEN
   Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_BEGIN_DATE,V_BEGIN_DATE);
   IF P_RETURN_CODE IS NOT NULL THEN
     P_RETURN_CODE := 'API_VM_600'; --begin date is invalid
     RETURN;
   END IF;
   -- 16-Apr-2004, W. Ver Hoef - added assignment because currently valid_date doesn't
   --                            populate v_begin_date and later references were thus null
   IF v_begin_date IS NULL THEN
     BEGIN
       v_begin_date := TO_DATE(p_begin_date,'DD-MON-YYYY');
  EXCEPTION WHEN OTHERS THEN
    p_return_code := 'API_VM_600';
    RETURN;
  END;
   END IF;
 END IF;

 IF(P_END_DATE IS NOT NULL) THEN
   Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_END_DATE,V_END_DATE);
   IF P_RETURN_CODE IS NOT NULL THEN
    P_RETURN_CODE := 'API_VM_601'; --end date is invalid
    RETURN;
   END IF;
   -- 16-Apr-2004, W. Ver Hoef - added assignment because currently valid_date doesn't
   --                            populate v_begin_date and later references were thus null
   IF v_end_date IS NULL THEN
     BEGIN
       v_end_date := TO_DATE(p_end_date,'DD-MON-YYYY');
  EXCEPTION WHEN OTHERS THEN
    p_return_code := 'API_VM_601';
    RETURN;
  END;
   END IF;
 END IF;

 IF(P_BEGIN_DATE IS NOT NULL AND P_END_DATE IS NOT NULL) THEN
   IF(v_end_date < v_begin_date) THEN
      P_RETURN_CODE := 'API_VM_210'; --end date is before begin date
      RETURN;
   END IF;
 END IF;


 IF (P_ACTION = 'INS' ) THEN



    P_vm_idseq         := admincomponent_crud.cmr_guid;
    P_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_CREATED_BY    := P_UA_NAME;
    P_DATE_MODIFIED := NULL;
    P_MODIFIED_BY   := NULL;
    P_BEGIN_DATE    := nvl(p_begin_date,sysdate);
    v_VM_rec.vm_idseq            := P_VM_idseq;
    v_VM_rec.preferred_name    := P_PREFERRED_NAME;
    v_VM_rec.conte_idseq        := P_CONTE_IDSEQ;
    v_VM_rec.version            := P_VERSION;
    v_VM_rec.preferred_definition := P_PREFERRED_DEFINITION;
    v_VM_rec.long_name            := P_LONG_NAME;
    v_VM_rec.asl_name            := P_ASL_NAME ;
    v_VM_rec.latest_version_ind   := P_LATEST_VERSION_IND;
    v_VM_rec.begin_date        := TO_DATE(P_BEGIN_DATE);
    v_VM_rec.end_date            := TO_DATE(P_END_DATE);
    v_VM_rec.change_note        := P_CHANGE_NOTE ;
    v_VM_rec.created_by        := P_CREATED_BY;
    v_VM_rec.date_created        := TO_DATE(P_DATE_CREATED);
    v_VM_rec.modified_by        := P_MODIFIED_BY;
    v_VM_rec.date_modified        := TO_DATE(P_DATE_MODIFIED);
    v_VM_rec.deleted_ind          := 'No';
    v_VM_rec.condr_idseq             := P_CONDR_IDSEQ;
    v_VM_rec.origin               := P_ORIGIN;


    v_VM_ind.vm_idseq            := TRUE;
    v_VM_ind.preferred_name    := TRUE;
    v_VM_ind.conte_idseq        := TRUE;
    v_VM_ind.version            := TRUE;
    v_VM_ind.preferred_definition := TRUE;
    v_VM_ind.long_name            := TRUE;
    v_VM_ind.asl_name            := TRUE;
    v_VM_ind.latest_version_ind   := TRUE;
    v_VM_ind.begin_date        := TRUE;
    v_VM_ind.end_date            := TRUE;
    v_VM_ind.change_note        := TRUE;
    v_VM_ind.created_by        := TRUE;
    v_VM_ind.date_created        := TRUE;
    v_VM_ind.modified_by        := TRUE;
    v_VM_ind.date_modified        := TRUE;
    v_VM_ind.deleted_ind          := TRUE;
    v_VM_ind.condr_idseq            := TRUE;
    v_VM_ind.origin               := TRUE;

   BEGIN
     cg$Value_meanings_view.ins(v_vm_rec,v_vm_ind);
  commit;

   EXCEPTION WHEN OTHERS THEN
     dbms_output.put_line(SQLERRM);
     P_RETURN_CODE := 'API_VM_500'; --Error inserting Value Meaning
   END;

 END IF;


 IF (P_ACTION = 'UPD' ) THEN

      SELECT version INTO v_version
    FROM value_meanings_view
    WHERE vm_idseq = P_VM_IDSEQ;

    IF v_version <> P_VERSION THEN
      P_RETURN_CODE := 'API_VM_402'; -- Version can NOT be updated. It can only be created
      RETURN;
    END IF;

    P_DATE_MODIFIED := TO_CHAR(SYSDATE);
    P_MODIFIED_BY   := P_UA_NAME;

    v_VM_rec.date_modified := TO_DATE(P_DATE_MODIFIED);
    v_VM_rec.modified_by   := P_MODIFIED_BY;
    v_VM_rec.vm_idseq     := P_VM_IDSEQ;
    v_VM_rec.deleted_ind   := 'No';

    v_VM_ind.date_modified := TRUE;
    v_VM_ind.modified_by   := TRUE;
    v_VM_ind.deleted_ind   := TRUE;
    v_VM_ind.vm_idseq     := TRUE;

    v_VM_ind.version       := FALSE;
    v_VM_ind.created_by := FALSE;
    v_VM_ind.date_created := FALSE;
    v_VM_ind.vm_id      := FALSE;  -- 16-Jul-2003, W. Ver Hoef

    IF P_PREFERRED_NAME IS NULL THEN
      v_VM_ind.preferred_name := FALSE;
    ELSE
      v_VM_rec.preferred_name := P_PREFERRED_NAME;
      v_VM_ind.preferred_name := TRUE;
    END IF;

    IF P_CONTE_IDSEQ IS NULL THEN
      v_VM_ind.conte_idseq := FALSE;
    ELSE
      v_VM_rec.conte_idseq := P_CONTE_IDSEQ;
      v_VM_ind.conte_idseq := TRUE;
    END IF;

    IF P_PREFERRED_DEFINITION IS NULL THEN
      v_VM_ind.preferred_definition := FALSE;
    ELSE
      v_VM_rec.preferred_definition := P_PREFERRED_DEFINITION;
      v_VM_ind.preferred_definition := TRUE;
    END IF;

    IF P_LONG_NAME IS NULL THEN
      v_VM_ind.long_name := FALSE;
    ELSE
      v_VM_rec.long_name := P_LONG_NAME;
      v_VM_ind.long_name := TRUE;
    END IF;

    IF P_ASL_NAME IS NULL THEN
      v_VM_ind.asl_name := FALSE;
    ELSE
      v_VM_rec.asl_name := P_ASL_NAME;
      v_VM_ind.asl_name := TRUE;
    END IF;



    IF P_CONDR_IDSEQ IS NULL THEN
      v_VM_ind.condr_idseq  := FALSE;
    ELSE
      v_VM_rec.condr_idseq  := P_CONDR_IDSEQ;
      v_VM_ind.condr_idseq  := TRUE;
    END IF;

    IF P_LATEST_VERSION_IND IS NULL THEN
      v_VM_ind.latest_version_ind := FALSE;
    ELSE
      v_VM_rec.latest_version_ind := P_LATEST_VERSION_IND;
      v_VM_ind.latest_version_ind := TRUE;
    END IF;

    IF P_BEGIN_DATE IS NULL THEN
      v_VM_ind.begin_date := FALSE;
 ELSIF P_begin_date = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_VM_rec.begin_date := NULL;
      v_VM_ind.begin_date := TRUE;
    ELSE
      v_VM_rec.begin_date := TO_DATE(P_BEGIN_DATE);
      v_VM_ind.begin_date := TRUE;
    END IF;

    IF P_END_DATE  IS NULL THEN
      v_VM_ind.end_date := FALSE;
 ELSIF P_end_date = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_VM_rec.end_date := NULL;
      v_VM_ind.end_date := TRUE;
    ELSE
      v_VM_rec.end_date := TO_DATE(P_END_DATE);
      v_VM_ind.end_date := TRUE;
    END IF;

    IF P_CHANGE_NOTE   IS NULL THEN
      v_VM_ind.change_note := FALSE;
 ELSIF P_change_note = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_VM_rec.change_note := NULL;
      v_VM_ind.change_note := TRUE;
    ELSE
      v_VM_rec.change_note := P_CHANGE_NOTE  ;
      v_VM_ind.change_note := TRUE;
    END IF;


    IF P_ORIGIN   IS NULL THEN  -- 15-Jul-2003, W. Ver Hoef
      v_VM_ind.origin := FALSE;
   ELSIF P_origin = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_VM_rec.origin := NULL;
      v_VM_ind.origin := TRUE;
    ELSE
      v_VM_rec.origin := P_ORIGIN  ;
      v_VM_ind.origin := TRUE;
    END IF;
   BEGIN
     cg$Value_meanings_view.upd(v_vm_rec,v_vm_ind);
  commit;

   EXCEPTION WHEN OTHERS THEN
     P_RETURN_CODE := 'API_VM_501'; --Error updating value meaning
   END;
 END IF;
 --return all the data
 sbrext.sbrext_get_row.get_vm(P_RETURN_CODE, P_VM_IDSEQ, P_LONG_NAME, P_VERSION, P_VM_ID, P_PREFERRED_NAME, P_PREFERRED_DEFINITION, P_CONTE_IDSEQ,
      P_ASL_NAME, P_LATEST_VERSION_IND, P_CONDR_IDSEQ, P_DEFINITION_SOURCE, P_ORIGIN, P_CHANGE_NOTE, P_BEGIN_DATE, P_END_DATE,
      P_CREATED_BY, P_DATE_CREATED, P_MODIFIED_BY, P_DATE_MODIFIED);

 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     P_RETURN_CODE := 'API_VM_901';  --NULL;
   WHEN OTHERS THEN
     P_RETURN_CODE := 'API_VM_902';  --NULL;
 END SET_VM;



PROCEDURE SET_VM_CONDR(
P_vm_con_array           IN VARCHAR2
,P_RETURN_CODE             OUT VARCHAR2
,P_VM_SHORT_MEANING       IN OUT VARCHAR2
,P_VM_DESCRIPTION          OUT VARCHAR2
,P_VM_COMMENTS              OUT VARCHAR2
,P_VM_BEGIN_DATE          OUT VARCHAR2
,P_VM_END_DATE              OUT VARCHAR2
,P_VM_CREATED_BY         OUT VARCHAR2
,P_VM_DATE_CREATED         OUT VARCHAR2
,P_VM_MODIFIED_BY         OUT VARCHAR2
,P_VM_DATE_MODIFIED         OUT VARCHAR2
,P_VM_CONDR_IDSEQ           out  VARCHAR2 )  IS
/******************************************************************************
   NAME:       SET_VM
   PURPOSE:    Inserts or Updates a Single Row Of  Value Meanings List of Value
               Based on Concept

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   3.0        12/28/2004  Prerna Aggarwal  1. Created this procedure

******************************************************************************/

v_Exists NUMBER;
v_Condr_idseq con_Derivation_rules_ext.condr_idseq%type;
v_short_meaning varchar2(255);
BEGIN
/*if p_vm_short_meaning is not null then
 if not sbrext_common_routines.VM_EXISTS(p_vm_short_meaning) then
   P_RETURN_CODE := 'API_VM_005';
   RETURN;
 end if;
end if;*/

v_condr_idseq := sbrext_common_routines.SET_DERIVATION_RULE(p_vm_con_array);

IF NOT Sbrext_Common_Routines.CONDR_EXISTS(v_condr_idseq) THEN
  P_RETURN_CODE := 'API_VM_800';
  RETURN;
END IF;

  begin
   SELECT short_meaning INTO v_short_meaning
   FROM VALUE_MEANINGS_LOV
   WHERE condr_idseq = v_condr_idseq;

   SELECT  SHORT_MEANING
          ,DESCRIPTION
           ,COMMENTS
           ,BEGIN_DATE
           ,END_DATE
           ,DATE_CREATED
           ,CREATED_BY
           ,DATE_MODIFIED
           ,MODIFIED_BY
           ,CONDR_IDSEQ
     INTO  P_VM_SHORT_MEANING
          ,P_VM_DESCRIPTION
           ,P_VM_COMMENTS
           ,P_VM_BEGIN_DATE
           ,P_VM_END_DATE
           ,P_VM_DATE_CREATED
           ,P_VM_CREATED_BY
           ,P_VM_DATE_MODIFIED
           ,P_VM_MODIFIED_BY
           ,P_VM_CONDR_IDSEQ
 FROM VALUE_MEANINGS_LOV
 WHERE short_meaning = v_short_meaning;


   RETURN;

  exception when no_data_found then

      Sbrext_Common_Routines.set_vm_condr(p_condr_idseq=>v_condr_idseq
      ,p_return_code=>p_return_code
      ,p_short_meaning=>p_vm_short_meaning
      );

  END;

IF p_return_code IS NULL THEN
 SELECT  SHORT_MEANING
          ,DESCRIPTION
           ,COMMENTS
           ,BEGIN_DATE
           ,END_DATE
           ,DATE_CREATED
           ,CREATED_BY
           ,DATE_MODIFIED
           ,MODIFIED_BY
           ,CONDR_IDSEQ
     INTO  P_VM_SHORT_MEANING
          ,P_VM_DESCRIPTION
           ,P_VM_COMMENTS
           ,P_VM_BEGIN_DATE
           ,P_VM_END_DATE
           ,P_VM_DATE_CREATED
           ,P_VM_CREATED_BY
           ,P_VM_DATE_MODIFIED
           ,P_VM_MODIFIED_BY
           ,P_VM_CONDR_IDSEQ
 FROM VALUE_MEANINGS_LOV
 WHERE short_meaning = p_vm_short_meaning;
END IF;


EXCEPTION WHEN OTHERS THEN
P_RETURN_CODE := 'Error Creating Value Meaning';
END SET_VM_CONDR;


-- overloaded version return vm_idseq
PROCEDURE SET_VM_CONDR(
     P_vm_con_array               IN     VARCHAR2
    ,P_RETURN_CODE              OUT    VARCHAR2
    ,P_VM_SHORT_MEANING      IN  OUT    VARCHAR2
    ,P_VM_DESCRIPTION          OUT    VARCHAR2
    ,P_VM_COMMENTS              OUT VARCHAR2
    ,P_VM_BEGIN_DATE          OUT VARCHAR2
    ,P_VM_END_DATE              OUT VARCHAR2
    ,P_VM_CREATED_BY          OUT VARCHAR2
    ,P_VM_DATE_CREATED          OUT VARCHAR2
    ,P_VM_MODIFIED_BY          OUT VARCHAR2
    ,P_VM_DATE_MODIFIED          OUT VARCHAR2
    ,P_VM_CONDR_IDSEQ            out    VARCHAR2
    ,P_VM_VM_IDSEQ               OUT    VARCHAR2 ) IS

    v_condr_idseq  con_derivation_rules_Ext.condr_idseq%TYPE;

BEGIN
  v_condr_idseq:=sbrext_common_routines.set_derivation_rule(p_vm_con_array);
 -- call original procedure
 sbrext_common_routines.set_oc_rep_prop(p_condr_idseq =>v_condr_idseq
,p_return_code =>p_return_code
,p_conte_idseq =>null
,p_actl_name =>'VALUEMEANING'
,p_ac_idseq =>p_vm_vm_idseq
);

if p_return_code is null then

  select long_name
  ,preferred_definition
  ,change_note
  ,begin_date
  ,end_date
  ,created_by
  ,date_Created
  ,modified_by
  ,date_modified
  ,condr_idseq
  into
  P_VM_SHORT_MEANING
    ,P_VM_DESCRIPTION
    ,P_VM_COMMENTS
    ,P_VM_BEGIN_DATE
    ,P_VM_END_DATE
    ,P_VM_CREATED_BY
    ,P_VM_DATE_CREATED
    ,P_VM_MODIFIED_BY
    ,P_VM_DATE_MODIFIED
    ,P_VM_CONDR_IDSEQ
    from value_meanings
    where vm_idseq = p_vm_vm_idseq;
    end if;
 /* set_vm_condr (
     P_vm_con_array       => p_vm_con_array
    ,P_RETURN_CODE     => p_return_code
    ,P_VM_SHORT_MEANING => p_vm_short_meaning
    ,P_VM_DESCRIPTION     => p_vm_description
    ,P_VM_COMMENTS     => p_vm_comments
    ,P_VM_BEGIN_DATE     => p_vm_begin_date
    ,P_VM_END_DATE     => P_vm_end_date
    ,P_VM_CREATED_BY     => p_vm_created_by
    ,P_VM_DATE_CREATED => p_vm_date_created
    ,P_VM_MODIFIED_BY     => p_vm_modified_by
    ,P_VM_DATE_MODIFIED => p_vm_date_modified
    ,P_VM_CONDR_IDSEQ     => p_vm_condr_idseq) ;
  -- get the VM_IDSEQ
     p_vm_vm_idseq := get_vm_idseq (p_ShortMeaning => p_vm_short_meaning);*/
EXCEPTION
   WHEN OTHERS THEN
   RAISE;
END set_vm_condr;


PROCEDURE SET_PV(
P_RETURN_CODE              OUT VARCHAR2
,P_ACTION                    IN VARCHAR2
,P_PV_PV_IDSEQ              IN OUT VARCHAR2
,P_PV_VALUE              IN OUT VARCHAR2
,P_PV_SHORT_MEANING          IN OUT VARCHAR2
,P_PV_BEGIN_DATE      IN OUT VARCHAR2
,P_PV_MEANING_DESCRIPTION IN OUT VARCHAR2
,P_PV_LOW_VALUE_NUM         IN OUT NUMBER
,P_PV_HIGH_VALUE_NUM      IN OUT NUMBER
,P_PV_END_DATE              IN OUT VARCHAR2
,P_PV_CREATED_BY         OUT VARCHAR2
,P_PV_DATE_CREATED         OUT VARCHAR2
,P_PV_MODIFIED_BY         OUT VARCHAR2
,P_PV_DATE_MODIFIED         OUT VARCHAR2) IS
/******************************************************************************
   NAME:       SET_PV
   PURPOSE:    Inserts or Updates a Single Row Of Permissible Value based on either
               PV_IDSEQ or value, shoert meaning

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal      1. Created this procedure




******************************************************************************/

v_begin_date DATE := NULL;
v_end_date DATE := NULL;

v_pv_rec    cg$permissible_values_view.cg$row_type;
v_pv_ind    cg$permissible_values_view.cg$ind_type;
BEGIN
P_RETURN_CODE := NULL;

IF P_ACTION NOT IN ('INS','UPD') THEN
 P_RETURN_CODE := 'API_PV_700'; -- Invalid action
 RETURN;
END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
  IF P_PV_PV_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_PV_100' ;  --for inserts the ID IS generated
  RETURN;
  ELSE
     --Check to see that all mandatory parameters are either NOT NULL or have a default value.
  IF P_PV_VALUE IS NULL THEN
     P_RETURN_CODE := 'API_PV_101';  --Value cannot be NULL here
  RETURN;
  END IF;
  IF P_PV_SHORT_MEANING IS NULL THEN
     P_RETURN_CODE := 'API_PV_103'; --Short Meaning cannot be NULL here
  RETURN;
  END IF;
  IF P_PV_BEGIN_DATE IS NULL THEN
     P_RETURN_CODE := 'API_PV_104'; --Begin date cannot be NULL here
  RETURN;
  END IF;
  END IF;
END IF;


IF P_ACTION = 'UPD' THEN              --we are inserting a record
  IF P_PV_PV_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_PV_400' ;  --for updates the ID is mandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.pv_exists(p_pv_idseq=>P_PV_PV_IDSEQ) THEN
   P_RETURN_CODE := 'API_PV_005'; --PV not found
   RETURN;
 END IF;
  END IF;
END IF;
--Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length

IF LENGTH(P_PV_VALUE) > Sbrext_Column_Lengths.L_PV_VALUE THEN
  P_RETURN_CODE := 'API_PV_111';  --Length of Value exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_PV_SHORT_MEANING) > Sbrext_Column_Lengths.L_PV_SHORT_MEANING THEN
  P_RETURN_CODE := 'API_PV_113';  --Length of Short Meaning exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_PV_MEANING_DESCRIPTION) > Sbrext_Column_Lengths.L_PV_MEANING_DESCRIPTION THEN
  P_RETURN_CODE := 'API_PV_114'; --Length of Meaning Description exceeds maximum length
  RETURN;
END IF;

--check to see that charachter strings are valid
IF NOT Sbrext_Common_Routines.valid_char(P_PV_VALUE) THEN
  P_RETURN_CODE := 'API_PV_130'; -- Permissible Value Value has invalid characters
  RETURN;
END IF;

IF NOT Sbrext_Common_Routines.valid_char(P_PV_SHORT_MEANING) THEN
  P_RETURN_CODE := 'API_PV_133'; -- Permissible Value Short Meaning has invalid characters
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.valid_char(P_PV_MEANING_DESCRIPTION) THEN
  P_RETURN_CODE := 'API_PV_134'; -- Permissible Value  Description has invalid characters
  RETURN;
END IF;


--check to see that Short Meaning already exist in the database

IF NOT Sbrext_Common_Routines.vm_exists(p_short_meaning=>P_PV_SHORT_MEANING) THEN
    P_RETURN_CODE := 'API_PV_200'; --Short Meaning notfound in the database
 RETURN;
END IF;
--check to see that begin data and end date are valid dates

IF(P_PV_BEGIN_DATE IS NOT NULL) THEN
  Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_PV_BEGIN_DATE,v_begin_date);
  IF P_RETURN_CODE IS NOT NULL THEN
    P_RETURN_CODE := 'API_PV_600'; --begin date is invalid
    RETURN;
  END IF;
END IF;

IF(P_PV_END_DATE IS NOT NULL) THEN
  Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_PV_END_DATE,v_end_date);
  IF P_RETURN_CODE IS NOT NULL THEN
    P_RETURN_CODE := 'API_PV_601'; --end date is invalid
    RETURN;
  END IF;
END IF;

IF(P_PV_BEGIN_DATE IS NOT NULL AND P_PV_END_DATE IS NOT NULL) THEN
  IF(v_end_date < v_begin_date) THEN
     P_RETURN_CODE := 'API_PV_210'; --end date is before begin date
     RETURN;
  END IF;
END IF;




IF (P_ACTION = 'INS' ) THEN

--check to see that Value  does not already
  IF Sbrext_Common_Routines.pv_exists(p_value=>P_PV_VALUE,p_short_meaning=>P_PV_SHORT_MEANING) THEN
    p_return_code := 'API_PV_300';-- PERMISSIBLE VALUE ALREADY EXISTS
    RETURN;
  END IF;

  P_PV_PV_IDSEQ := admincomponent_crud.cmr_guid;
  P_PV_DATE_CREATED := TO_CHAR(SYSDATE);
  P_PV_CREATED_BY := ADMIN_SECURITY_UTIL.effective_user;
  P_PV_DATE_MODIFIED := NULL;
  P_PV_MODIFIED_BY := NULL;

  v_pv_rec.pv_idseq            := P_PV_PV_IDSEQ;
  v_pv_rec.value            := P_PV_VALUE;
  v_pv_rec.short_meaning       := P_PV_SHORT_MEANING;
  v_pv_rec.meaning_description := P_PV_MEANING_DESCRIPTION;
  v_pv_rec.low_value_num    := P_PV_LOW_VALUE_NUM;
  v_pv_rec.high_value_num    := P_PV_HIGH_VALUE_NUM;
  v_pv_rec.begin_date        := TO_DATE(P_PV_BEGIN_DATE);
  v_pv_rec.end_date            := TO_DATE(P_PV_END_DATE);
  v_pv_rec.created_by        := P_PV_CREATED_BY;
  v_pv_rec.date_created        := TO_DATE(P_PV_DATE_CREATED);
  v_pv_rec.modified_by        := P_PV_MODIFIED_BY;
  v_pv_rec.date_modified    := P_PV_DATE_MODIFIED;


  v_pv_ind.pv_idseq             := TRUE;
  v_pv_ind.value             := TRUE;
  v_pv_ind.short_meaning        := TRUE;
  v_pv_ind.meaning_description  := TRUE;
  v_pv_ind.low_value_num     := TRUE;
  v_pv_ind.high_value_num     := TRUE;
  v_pv_ind.begin_Date         := TRUE;
  v_pv_ind.end_date             := TRUE;
  v_pv_ind.created_by         := TRUE;
  v_pv_ind.date_created         := TRUE;
  v_pv_ind.modified_by         := TRUE;
  v_pv_ind.date_modified     := TRUE;

  BEGIN
    cg$permissible_values_view.ins(v_pv_rec,v_pv_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_PV_500'; --Error inserting Permissible Value
  END;

END IF;



IF (P_ACTION = 'UPD' ) THEN

  P_PV_DATE_MODIFIED     := TO_CHAR(SYSDATE);
  P_PV_MODIFIED_BY       := ADMIN_SECURITY_UTIL.effective_user;
  v_pv_rec.date_modified := TO_DATE(P_PV_DATE_MODIFIED);
  v_pv_rec.modified_by   := P_PV_MODIFIED_BY;
  v_pv_rec.pv_idseq      := P_PV_PV_IDSEQ;

  v_pv_ind.date_modified := TRUE;
  v_pv_ind.modified_by   := TRUE;
  v_pv_ind.pv_idseq      := TRUE;

  v_pv_ind.created_by       := FALSE;
  v_pv_ind.date_created       := FALSE;

  IF P_PV_VALUE IS NULL THEN
    v_pv_ind.value := FALSE;
  ELSE
    v_pv_rec.value := P_PV_VALUE;
    v_pv_ind.value := TRUE;
  END IF;

  IF P_PV_SHORT_MEANING IS NULL THEN
    v_pv_ind.short_meaning := FALSE;
  ELSE
    v_pv_rec.short_meaning := P_PV_SHORT_MEANING;
    v_pv_ind.short_meaning := TRUE;
  END IF;

  IF P_PV_MEANING_DESCRIPTION IS NULL THEN
    v_pv_ind.meaning_description := FALSE;
  ELSE
    v_pv_rec.meaning_description := P_PV_MEANING_DESCRIPTION;
    v_pv_ind.meaning_description := TRUE;
  END IF;

  IF P_PV_LOW_VALUE_NUM IS NULL THEN
    v_pv_ind.low_value_num := FALSE;
  ELSE
    v_pv_rec.low_value_num := P_PV_LOW_VALUE_NUM;
    v_pv_ind.low_value_num := TRUE;
  END IF;

  IF P_PV_HIGH_VALUE_NUM IS NULL THEN
    v_pv_ind.high_value_num := FALSE;
  ELSE
    v_pv_rec.high_value_num := P_PV_HIGH_VALUE_NUM;
    v_pv_ind.high_value_num := TRUE;
  END IF;

  IF P_PV_BEGIN_DATE IS NULL THEN
    v_pv_ind.begin_date := FALSE;
  ELSE
    v_pv_rec.begin_date  := TO_DATE(P_PV_BEGIN_DATE);
    v_pv_ind.begin_date  := TRUE;
  END IF;

  IF P_PV_END_DATE  IS NULL THEN
    v_pv_ind.end_date := FALSE;
  ELSE
    v_pv_rec.end_date := TO_DATE(P_PV_END_DATE) ;
    v_pv_ind.end_date := TRUE;
  END IF;

  BEGIN
    cg$permissible_values_view.upd(v_pv_rec,v_pv_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_PV_501'; --Error updating PERMISSIBLE VALUE
  END;
END IF;

EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_PV;

PROCEDURE SET_PV(
P_RETURN_CODE              OUT VARCHAR2
,P_ACTION                    IN VARCHAR2
,P_PV_PV_IDSEQ              IN OUT VARCHAR2
,P_PV_VALUE              IN OUT VARCHAR2
,P_PV_VM_IDSEQ          IN OUT VARCHAR2
,P_PV_BEGIN_DATE      IN OUT VARCHAR2
,P_PV_MEANING_DESCRIPTION IN OUT VARCHAR2
,P_PV_LOW_VALUE_NUM         IN OUT NUMBER
,P_PV_HIGH_VALUE_NUM      IN OUT NUMBER
,P_PV_END_DATE              IN OUT VARCHAR2
,P_PV_CREATED_BY         OUT VARCHAR2
,P_PV_DATE_CREATED         OUT VARCHAR2
,P_PV_MODIFIED_BY         OUT VARCHAR2
,P_PV_DATE_MODIFIED         OUT VARCHAR2) IS
/******************************************************************************
   NAME:       SET_PV
   PURPOSE:    Inserts or Updates a Single Row Of Permissible Value based on either
               PV_IDSEQ or value, shoert meaning

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal      1. Created this procedure




******************************************************************************/

v_begin_date DATE := NULL;
v_end_date DATE := NULL;

v_pv_rec    cg$permissible_values_view.cg$row_type;
v_pv_ind    cg$permissible_values_view.cg$ind_type;
BEGIN
P_RETURN_CODE := NULL;

IF P_ACTION NOT IN ('INS','UPD') THEN
 P_RETURN_CODE := 'API_PV_700'; -- Invalid action
 RETURN;
END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
  IF P_PV_PV_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_PV_100' ;  --for inserts the ID IS generated
  RETURN;
  ELSE
     --Check to see that all mandatory parameters are either NOT NULL or have a default value.
  IF P_PV_VALUE IS NULL THEN
     P_RETURN_CODE := 'API_PV_101';  --Value cannot be NULL here
  RETURN;
  END IF;
  IF P_PV_VM_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_PV_103'; --Short Meaning cannot be NULL here
  RETURN;
  END IF;
  IF P_PV_BEGIN_DATE IS NULL THEN
     P_RETURN_CODE := 'API_PV_104'; --Begin date cannot be NULL here
  RETURN;
  END IF;
  END IF;
END IF;


IF P_ACTION = 'UPD' THEN              --we are inserting a record
  IF P_PV_PV_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_PV_400' ;  --for updates the ID is mandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.pv_exists(p_pv_idseq=>P_PV_PV_IDSEQ) THEN
   P_RETURN_CODE := 'API_PV_005'; --PV not found
   RETURN;
 END IF;
  END IF;
END IF;
--Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length

IF LENGTH(P_PV_VALUE) > Sbrext_Column_Lengths.L_PV_VALUE THEN
  P_RETURN_CODE := 'API_PV_111';  --Length of Value exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_PV_VM_IDSEQ) > Sbrext_Column_Lengths.L_VM_IDSEQ THEN
  P_RETURN_CODE := 'API_PV_113';  --Length of Short Meaning exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_PV_MEANING_DESCRIPTION) > Sbrext_Column_Lengths.L_PV_MEANING_DESCRIPTION THEN
  P_RETURN_CODE := 'API_PV_114'; --Length of Meaning Description exceeds maximum length
  RETURN;
END IF;

--check to see that charachter strings are valid
IF NOT Sbrext_Common_Routines.valid_char(P_PV_VALUE) THEN
  P_RETURN_CODE := 'API_PV_130'; -- Permissible Value Value has invalid characters
  RETURN;
END IF;


IF NOT Sbrext_Common_Routines.valid_char(P_PV_MEANING_DESCRIPTION) THEN
  P_RETURN_CODE := 'API_PV_134'; -- Permissible Value  Description has invalid characters
  RETURN;
END IF;


--check to see that Short Meaning already exist in the database

IF NOT Sbrext_Common_Routines.vm_exists(p_vm_idseq=>P_PV_VM_IDSEQ) THEN
    P_RETURN_CODE := 'API_PV_200'; --Short Meaning notfound in the database
 RETURN;
END IF;
--check to see that begin data and end date are valid dates

IF(P_PV_BEGIN_DATE IS NOT NULL) THEN
  Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_PV_BEGIN_DATE,v_begin_date);
  IF P_RETURN_CODE IS NOT NULL THEN
    P_RETURN_CODE := 'API_PV_600'; --begin date is invalid
    RETURN;
  END IF;
END IF;

IF(P_PV_END_DATE IS NOT NULL) THEN
  Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_PV_END_DATE,v_end_date);
  IF P_RETURN_CODE IS NOT NULL THEN
    P_RETURN_CODE := 'API_PV_601'; --end date is invalid
    RETURN;
  END IF;
END IF;

IF(P_PV_BEGIN_DATE IS NOT NULL AND P_PV_END_DATE IS NOT NULL) THEN
  IF(v_end_date < v_begin_date) THEN
     P_RETURN_CODE := 'API_PV_210'; --end date is before begin date
     RETURN;
  END IF;
END IF;




IF (P_ACTION = 'INS' ) THEN

--check to see that Value  does not already
  IF Sbrext_Common_Routines.pv_exists(p_value=>P_PV_VALUE,p_vm_idseq=>P_PV_VM_IDSEQ) THEN
    p_return_code := 'API_PV_300';-- PERMISSIBLE VALUE ALREADY EXISTS
    RETURN;
  END IF;

  P_PV_PV_IDSEQ := admincomponent_crud.cmr_guid;
  P_PV_DATE_CREATED := TO_CHAR(SYSDATE);
  P_PV_CREATED_BY := ADMIN_SECURITY_UTIL.effective_user;
  P_PV_DATE_MODIFIED := NULL;
  P_PV_MODIFIED_BY := NULL;

  v_pv_rec.pv_idseq            := P_PV_PV_IDSEQ;
  v_pv_rec.value            := P_PV_VALUE;
  v_pv_rec.vm_idseq       := P_PV_VM_IDSEQ;
  v_pv_rec.meaning_description := P_PV_MEANING_DESCRIPTION;
  v_pv_rec.low_value_num    := P_PV_LOW_VALUE_NUM;
  v_pv_rec.high_value_num    := P_PV_HIGH_VALUE_NUM;
  v_pv_rec.begin_date        := TO_DATE(P_PV_BEGIN_DATE);
  v_pv_rec.end_date            := TO_DATE(P_PV_END_DATE);
  v_pv_rec.created_by        := P_PV_CREATED_BY;
  v_pv_rec.date_created        := TO_DATE(P_PV_DATE_CREATED);
  v_pv_rec.modified_by        := P_PV_MODIFIED_BY;
  v_pv_rec.date_modified    := P_PV_DATE_MODIFIED;


  v_pv_ind.pv_idseq             := TRUE;
  v_pv_ind.value             := TRUE;
  v_pv_ind.vm_idseq        := TRUE;
  v_pv_ind.meaning_description  := TRUE;
  v_pv_ind.low_value_num     := TRUE;
  v_pv_ind.high_value_num     := TRUE;
  v_pv_ind.begin_Date         := TRUE;
  v_pv_ind.end_date             := TRUE;
  v_pv_ind.created_by         := TRUE;
  v_pv_ind.date_created         := TRUE;
  v_pv_ind.modified_by         := TRUE;
  v_pv_ind.date_modified     := TRUE;

  BEGIN
    cg$permissible_values_view.ins(v_pv_rec,v_pv_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_PV_500'; --Error inserting Permissible Value
  END;

END IF;



IF (P_ACTION = 'UPD' ) THEN

  P_PV_DATE_MODIFIED     := TO_CHAR(SYSDATE);
  P_PV_MODIFIED_BY       := ADMIN_SECURITY_UTIL.effective_user;
  v_pv_rec.date_modified := TO_DATE(P_PV_DATE_MODIFIED);
  v_pv_rec.modified_by   := P_PV_MODIFIED_BY;
  v_pv_rec.pv_idseq      := P_PV_PV_IDSEQ;

  v_pv_ind.date_modified := TRUE;
  v_pv_ind.modified_by   := TRUE;
  v_pv_ind.pv_idseq      := TRUE;

  v_pv_ind.created_by       := FALSE;
  v_pv_ind.date_created       := FALSE;

  IF P_PV_VALUE IS NULL THEN
    v_pv_ind.value := FALSE;
  ELSE
    v_pv_rec.value := P_PV_VALUE;
    v_pv_ind.value := TRUE;
  END IF;

  IF P_PV_VM_IDSEQ IS NULL THEN
    v_pv_ind.short_meaning := FALSE;
  ELSE
    v_pv_rec.vm_idseq := P_PV_VM_IDSEQ;
    v_pv_ind.vm_idseq := TRUE;
  END IF;

  IF P_PV_MEANING_DESCRIPTION IS NULL THEN
    v_pv_ind.meaning_description := FALSE;
  ELSE
    v_pv_rec.meaning_description := P_PV_MEANING_DESCRIPTION;
    v_pv_ind.meaning_description := TRUE;
  END IF;

  IF P_PV_LOW_VALUE_NUM IS NULL THEN
    v_pv_ind.low_value_num := FALSE;
  ELSE
    v_pv_rec.low_value_num := P_PV_LOW_VALUE_NUM;
    v_pv_ind.low_value_num := TRUE;
  END IF;

  IF P_PV_HIGH_VALUE_NUM IS NULL THEN
    v_pv_ind.high_value_num := FALSE;
  ELSE
    v_pv_rec.high_value_num := P_PV_HIGH_VALUE_NUM;
    v_pv_ind.high_value_num := TRUE;
  END IF;

  IF P_PV_BEGIN_DATE IS NULL THEN
    v_pv_ind.begin_date := FALSE;
  ELSE
    v_pv_rec.begin_date  := TO_DATE(P_PV_BEGIN_DATE);
    v_pv_ind.begin_date  := TRUE;
  END IF;

  IF P_PV_END_DATE  IS NULL THEN
    v_pv_ind.end_date := FALSE;
  ELSE
    v_pv_rec.end_date := TO_DATE(P_PV_END_DATE) ;
    v_pv_ind.end_date := TRUE;
  END IF;

  BEGIN
    cg$permissible_values_view.upd(v_pv_rec,v_pv_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_PV_501'; --Error updating PERMISSIBLE VALUE
  END;
END IF;

EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_PV;

PROCEDURE  SET_VD_PVS(
 P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_VDPVS_VP_IDSEQ         IN OUT VARCHAR2
,P_VDPVS_VD_IDSEQ         IN OUT VARCHAR2
,P_VDPVS_PV_IDSEQ         IN OUT VARCHAR2
,P_VDPVS_CONTE_IDSEQ     IN OUT VARCHAR2
,P_VDPVS_DATE_CREATED        OUT VARCHAR2
,P_VDPVS_CREATED_BY            OUT VARCHAR2
,P_VDPVS_MODIFIED_BY        OUT VARCHAR2
,P_VDPVS_DATE_MODIFIED        OUT VARCHAR2
,P_VDPVS_ORIGIN       IN     VARCHAR2 DEFAULT NULL
,P_VDPVS_BEGIN_DATE      IN     VARCHAR2 DEFAULT NULL
,P_VDPVS_END_DATE              IN  VARCHAR2 DEFAULT NULL
,P_VDPVS_CON_IDSEQ  IN VARCHAR2 DEFAULT NULL) -- 24-Jul-2003, W. Ver Hoef
IS
/******************************************************************************
   NAME:       SET_VD_PVS
   PURPOSE:    Inserts or Updates a Single Row Of VD_PVS basedon either
               VP_IDSEQ or VD_IDSEQ and PV_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/25/2001  Prerna Aggarwal  1. Created this procedure
   2.0    07/24/2003  W.Ver Hoef       1. Added parameter and code for origin
   2.1.1      08/23/2004  DLadino          1. Added code to "UPDATE" a VD_PVS record
                                              sprf_2.1.1_2b
******************************************************************************/

v_vd_flag  VARCHAR2(1);

v_vp_rec  cg$vd_pvs_view.cg$row_type;
v_vp_ind  cg$vd_pvs_view.cg$ind_type;
v_vp_pk   cg$vd_pvs_view.cg$pk_type;

v_begin_date DATE := NULL;
v_end_date DATE := NULL;


BEGIN

  P_RETURN_CODE := NULL;

  IF P_ACTION NOT IN ('INS','DEL','UPD') THEN
    P_RETURN_CODE := 'API_VDPVS_700'; -- Invalid action
    RETURN;
  END IF;

  IF P_ACTION = 'INS' THEN              --we are inserting a record
    IF P_VDPVS_VP_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_VDPVS_100' ;  --for inserts the ID IS generated
   RETURN;
    ELSE
      --Check to see that all mandatory parameters are not null
   IF P_VDPVS_VD_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_VDPVS_102'; --VD_IDSEQ cannot be null here
  RETURN;
   END IF;

      IF P_VDPVS_PV_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_VDPVS_104'; --PV_IDSEQ cannot be null here
  RETURN;
   END IF;
    END IF;
  END IF;

--   2.1.1      08/23/2004  DLadino          1. Added code to "UPDATE" a VD_PVS record
--                                              sprf_2.1.1_2b
  IF P_ACTION = 'UPD' THEN              --we are updating a record
    IF P_VDPVS_VP_IDSEQ IS NULL THEN
      P_RETURN_CODE := 'API_VDPVS_105' ;  --for updates the ID is required
   RETURN;
    END IF;
    /*IF P_VDPVS_ORIGIN IS NULL THEN
      P_RETURN_CODE := 'API_VDPVS_106' ;  --for updates the origin is required
   RETURN;
    END IF;*/
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are deleting a record

    IF P_VDPVS_VP_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_VDPVS_400' ;  --for deleted the ID id mandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.vd_pvs_exists(P_VDPVS_VP_IDSEQ) THEN
     P_RETURN_CODE := 'API_VDPVS_005'; --VD_PVS NOT found
     RETURN;
   END IF;
    END IF;

    --  Added the following code 24-Aug-2004 DLadino SPRF_2.1.1_2
    IF Sbrext_Common_Routines.vd_pvs_qc_exists (P_VDPVS_VP_IDSEQ, NULL) = 'TRUE' THEN
      P_RETURN_CODE := 'API_VDPVS_006';   --VD_PVS_QC found
      RETURN;
    END IF;

    v_vp_pk.vp_idseq := P_VDPVS_VP_IDSEQ;

    SELECT ROWID
 INTO   v_vp_pk.the_rowid
    FROM   vd_pvs_view
    WHERE  vp_idseq = P_VDPVS_VP_IDSEQ;
    v_vp_pk.jn_notes := NULL;

    BEGIN
      cg$vd_pvs_view.del(v_vp_pk);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_VDPVS_501'; --Error deleting Value Domain
        P_RETURN_CODE := SQLCODE;
   RETURN;
    END;

  END IF;

  --check to see that Value Domain Aand Permissible Values and Context exist in the database
  IF NOT Sbrext_Common_Routines.ac_exists(P_VDPVS_VD_IDSEQ)  THEN
    P_RETURN_CODE := 'API_VDPVS_201'; --VALUE Domain NOT found in the database
    RETURN;
  END IF;

  IF P_VDPVS_CON_IDSEQ IS NOT NULL THEN
     IF NOT Sbrext_Common_Routines.ac_exists(P_VDPVS_CON_IDSEQ)  THEN
      P_RETURN_CODE := 'API_VDPVS_205'; --CONCEPT  NOT  found in the database
      RETURN;
    END IF;
 IF NOT Sbrext_Common_Routines.VALID_PARENT_CONCEPT(p_vdpvs_con_idseq,p_vdpvs_vd_idseq) THEN
    P_RETURN_CODE := 'API_VDPVS_206'; --concept is not a component concept for value domain
    RETURN;
 END IF;
  END IF;
  IF NOT Sbrext_Common_Routines.pv_exists(p_pv_idseq=>P_VDPVS_PV_IDSEQ)  THEN
    P_RETURN_CODE := 'API_VDPVS_202'; --PERMISSIBLE VALUE NOT found in the database
    RETURN;
  END IF;
  IF P_VDPVS_CONTE_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.context_exists(P_VDPVS_CONTE_IDSEQ) THEN
      P_RETURN_CODE := 'API_VDPVS_200'; --Context not found in the database
      RETURN;
    END IF;
  END IF;

  --check to see that begin data and end date are valid dates

IF(P_VDPVS_BEGIN_DATE IS NOT NULL) THEN
  Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_VDPVS_BEGIN_DATE,v_begin_date);
  IF P_RETURN_CODE IS NOT NULL THEN
    P_RETURN_CODE := 'API_VDPVS_600'; --begin date is invalid
    RETURN;
  END IF;
END IF;

IF(P_VDPVS_END_DATE IS NOT NULL) THEN
  Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_VDPVS_END_DATE,v_end_date);
  IF P_RETURN_CODE IS NOT NULL THEN
    P_RETURN_CODE := 'API_VDPVS_601'; --end date is invalid
    RETURN;
  END IF;
END IF;


IF(P_VDPVS_BEGIN_DATE IS NOT NULL AND P_VDPVS_END_DATE IS NOT NULL) THEN
  IF(v_end_date < v_begin_date) THEN
     P_RETURN_CODE := 'API_VDPVS_210'; --end date is before begin date
     RETURN;
  END IF;
END IF;



  IF (P_ACTION = 'INS' ) THEN
    --check to see that Value Domain Permissible Value already exist
    IF Sbrext_Common_Routines.vd_pvs_exists(P_VDPVS_VD_IDSEQ,P_VDPVS_PV_IDSEQ) THEN
      p_return_code := 'API_VDPVS_300';-- Combination Already Exist
      RETURN;
    END IF;

  --check to see if the value domain is enumerated
    BEGIN
      SELECT vd_type_flag
   INTO   v_vd_flag
      FROM   value_domains_view
      WHERE  vd_idseq = P_VDPVS_VD_IDSEQ;
      IF v_vd_flag  <> 'E' THEN
        P_RETURN_CODE := 'API_VDPVS_205'; -- valid values can not be added to non enumerated value domains
        RETURN;
      END IF;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      P_RETURN_CODE := 'API_VDPVS_201'; --VALUE Domain NOT found in the database
   RETURN;
    END;

    P_VDPVS_VP_IDSEQ      := admincomponent_crud.cmr_guid;
    P_VDPVS_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_VDPVS_CREATED_BY    := ADMIN_SECURITY_UTIL.effective_user;
    P_VDPVS_DATE_MODIFIED := NULL;
    P_VDPVS_MODIFIED_BY   := NULL;

    v_vp_rec.vp_idseq      := P_VDPVS_VP_IDSEQ;
    v_vp_rec.conte_idseq   := P_VDPVS_CONTE_IDSEQ;
    v_vp_rec.vd_idseq         := P_VDPVS_VD_IDSEQ;
    v_vp_rec.pv_idseq       := P_VDPVS_pv_IDSEQ;
    v_vp_rec.created_by      := P_VDPVS_CREATED_BY;
    v_vp_rec.date_created   := TO_DATE(P_VDPVS_DATE_CREATED);
    v_vp_rec.modified_by   := P_VDPVS_MODIFIED_BY;
    v_vp_rec.date_modified    := P_VDPVS_DATE_MODIFIED;
    v_vp_rec.con_idseq    := P_VDPVS_con_idseq;
    v_vp_rec.begin_date        := TO_DATE(P_VDPVS_BEGIN_DATE);
    v_vp_rec.end_date            := TO_DATE(P_VDPVS_END_DATE);
 v_vp_rec.origin           := P_VDPVS_ORIGIN; -- 24-Jul-2003, W. Ver Hoef

    v_vp_ind.VD_IDSEQ       := TRUE;
    v_vp_ind.CONTE_IDSEQ   := TRUE;
    v_vp_ind.VD_IDSEQ       := TRUE;
    v_vp_ind.created_by      := TRUE;
    v_vp_ind.date_created   := TRUE;
    v_vp_ind.modified_by   := TRUE;
    v_vp_ind.date_modified    := TRUE;
 v_vp_ind.origin           := TRUE;
 v_vp_ind.con_idseq           := TRUE;
    v_vp_ind.begin_date        := TRUE;
    v_vp_ind.end_date            := TRUE;-- 24-Jul-2003, W. Ver Hoef

    BEGIN
      cg$vd_pvs_view.ins(v_vp_rec,v_vp_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_VDPVS_500'; --Error inserting VD_PVS
    END;
  ELSIF (P_ACTION = 'UPD' ) THEN  --  Added 8/23/2004 sprf_2.1.1_2b

    IF P_VDPVS_ORIGIN = ' ' THEN
      v_vp_rec.origin := NULL;
      v_vp_ind.origin := TRUE;
    ELSE
      v_vp_rec.origin  := P_VDPVS_ORIGIN;
      v_vp_ind.origin := TRUE;
    END IF;

 IF P_VDPVS_BEGIN_DATE = ' ' THEN
      v_vp_rec.begin_date := NULL;
      v_vp_ind.begin_date := TRUE;
    ELSE
      v_vp_rec.begin_date  := P_VDPVS_begin_date;
      v_vp_ind.begin_date := TRUE;
    END IF;


 IF P_VDPVS_END_DATE = ' ' THEN
      v_vp_rec.end_date := NULL;
      v_vp_ind.end_date := TRUE;
    ELSE
      v_vp_rec.end_date  := P_VDPVS_end_date;
      v_vp_ind.end_date := TRUE;
    END IF;

 IF P_VDPVS_CON_IDSEQ = ' ' THEN
      v_vp_rec.con_idseq := NULL;
      v_vp_ind.con_idseq := TRUE;
    ELSE
      v_vp_rec.con_idseq  := P_VDPVS_con_idseq;
      v_vp_ind.con_idseq := TRUE;
    END IF;


    P_VDPVS_DATE_MODIFIED := TO_CHAR(SYSDATE);
    P_VDPVS_MODIFIED_BY   := ADMIN_SECURITY_UTIL.effective_user;

    v_vp_rec.vp_idseq      := P_VDPVS_VP_IDSEQ;
    v_vp_rec.date_modified := P_VDPVS_DATE_MODIFIED;
    v_vp_rec.modified_by   := P_VDPVS_MODIFIED_BY;

    v_vp_ind.date_modified := TRUE;
    v_vp_ind.modified_by   := TRUE;

    v_vp_ind.VD_IDSEQ      := FALSE;
    v_vp_ind.CONTE_IDSEQ   := FALSE;
    v_vp_ind.VP_IDSEQ      := FALSE;
    v_vp_ind.PV_IDSEQ      := FALSE;
    v_vp_ind.created_by    := FALSE;
    v_vp_ind.date_created  := FALSE;

    BEGIN
      cg$vd_pvs_view.upd(v_vp_rec,v_vp_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_VDPVS_502'; -- Error updating VD_PVS
    END;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;

END SET_VD_PVS;



PROCEDURE SET_DE(
 P_RETURN_CODE                 OUT VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_DE_DE_IDSEQ             IN OUT VARCHAR2
,P_DE_PREFERRED_NAME     IN OUT VARCHAR2
,P_DE_CONTE_IDSEQ         IN OUT VARCHAR2
,P_DE_VERSION             IN OUT NUMBER
,P_DE_PREFERRED_DEFINITION  IN OUT VARCHAR2
,P_DE_DEC_IDSEQ          IN OUT VARCHAR2
,P_DE_VD_IDSEQ             IN OUT VARCHAR2
,P_DE_ASL_NAME             IN OUT VARCHAR2
,P_DE_LATEST_VERSION_IND    IN OUT VARCHAR2
,P_DE_LONG_NAME             IN OUT VARCHAR2
,P_DE_BEGIN_DATE         IN OUT VARCHAR2
,P_DE_END_DATE             IN OUT VARCHAR2
,P_DE_CHANGE_NOTE         IN OUT VARCHAR2
,P_DE_CREATED_BY            OUT VARCHAR2
,P_DE_DATE_CREATED            OUT VARCHAR2
,P_DE_MODIFIED_BY               OUT VARCHAR2
,P_DE_DATE_MODIFIED            OUT VARCHAR2
,P_DE_DELETED_IND              OUT VARCHAR2
,p_DE_ORIGIN                IN     VARCHAR2 DEFAULT NULL)  -- 15-Jul-2003, W. Ver Hoef
IS
/******************************************************************************
   NAME:       SET_DE
   PURPOSE:    Inserts or Updates a Single Row Of Data Element  Based on either
               DE_IDSEQ or Preferred Name, Context and Version

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal  1. Created this procedure
   2.0        07/15/2003  W. Ver Hoef      1. added parameter for origin and code
                                              also for cde_id;
             2. fixed proper setting of p_de_de_idseq
                parameter.
   2.1        03/19/2004  W. Ver Hoef      1. substituted UNASSIGNED with function
                                              call to get_default_asl

******************************************************************************/

  v_version      data_elements_view.version%TYPE;
  v_ac           data_elements_view.de_idseq%TYPE;
  v_begin_date   DATE := NULL;
  v_end_date     DATE := NULL;
  v_new_Version  BOOLEAN := FALSE;
  v_asl_name     data_elements_view.asl_name%TYPE;
  v_de_idseq     VARCHAR2(36);  -- 16-Jul-2003, W. Ver Hoef - added variable

  v_de_rec       cg$data_elements_view.cg$row_type;
  v_de_ind       cg$data_elements_view.cg$ind_type;

BEGIN
  P_RETURN_CODE := NULL;
  IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
    P_RETURN_CODE := 'API_DE_700'; -- Invalid action
    RETURN;
  END IF;
  IF P_ACTION = 'INS' THEN             --we are inserting a record
    IF P_DE_DE_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_DE_100' ;  --for inserts the ID is generated
   RETURN;
    ELSE
      --Check to see that all mandatory parameters are either not NULL or have a default value.
   IF P_DE_PREFERRED_NAME IS NULL THEN
     P_RETURN_CODE := 'API_DE_101';  --Preferred Name cannot be null here
  RETURN;
   END IF;
   IF P_DE_CONTE_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_DE_102'; --CONTE_IDSEQ cannot be null here
  RETURN;
   END IF;
   IF P_DE_PREFERRED_DEFINITION IS NULL THEN
     P_RETURN_CODE := 'API_DE_103'; --Preferred Definition cannot be null here
  RETURN;
   END IF;
   IF P_DE_ASL_NAME IS NULL THEN
     -- 19-Mar-2004, W. Ver Hoef - substituted UNASSIGNED with function call below
     P_DE_ASL_NAME := Sbrext_Common_Routines.get_default_asl('INS'); -- 'UNASSIGNED';
   END IF;
   IF P_DE_VERSION IS NULL THEN
     P_DE_VERSION := Sbrext_Common_Routines.get_ac_version(P_DE_PREFERRED_NAME,P_DE_CONTE_IDSEQ,'DATAELEMENT','HIGHEST') + 1;
   END IF;
   IF P_DE_VD_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_DE_104'; --VD_IDSEQ cannot be null here
  RETURN;
   END IF;
      IF P_DE_DEC_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_DE_106'; --DEC_IDSEQ cannot be null here
  RETURN;
   END IF;
   IF P_DE_LATEST_VERSION_IND IS NULL THEN
     P_DE_LATEST_VERSION_IND := 'No';
   END IF;
    END IF;
  END IF;

  IF P_ACTION = 'UPD' THEN              --we are updating a record
    IF P_DE_DE_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_DE_400' ;  --for updates the ID IS mandatory
   RETURN;
    END IF;
    SELECT asl_name INTO v_asl_name
    FROM data_elements_view
    WHERE de_idseq = p_de_de_idseq;
    IF (P_DE_PREFERRED_NAME IS NOT NULL OR P_DE_CONTE_IDSEQ IS NOT NULL) AND v_asl_name = 'RELEASED' THEN
      P_RETURN_CODE := 'API_DE_401' ;  --Preferred Name or Context Can not be updated
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(P_DE_DE_IDSEQ) THEN
      P_RETURN_CODE := 'API_DE_005'; --DE not found
      RETURN;
    END IF;
    dbms_output.put_line(nvl(p_de_modified_by,'None'));
    admin_security_util.seteffectiveuser(p_de_modified_by);
    dbms_output.put_line(nvl(admin_security_util.g_effective_user,'NULL'));
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are logically deleteing a record

    IF P_DE_DE_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_DE_400' ;  --for deletes the ID IS mandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ac_exists(P_DE_DE_IDSEQ) THEN
     P_RETURN_CODE := 'API_DE_005'; --Data Element not found
     RETURN;
      END IF;
    END IF;

    P_DE_DELETED_IND       := 'Yes';
    P_DE_MODIFIED_BY       := 'USER';
    P_DE_DATE_MODIFIED     := TO_CHAR(SYSDATE);

    v_de_rec.de_idseq      := P_DE_DE_IDSEQ;
    v_de_rec.deleted_ind   := P_DE_DELETED_IND;
    v_de_rec.modified_by   := P_DE_MODIFIED_BY;
    v_de_rec.date_modified := TO_DATE(P_DE_DATE_MODIFIED);

    v_de_ind.de_idseq           := TRUE;
    v_de_ind.preferred_name       := FALSE;
    v_de_ind.conte_idseq       := FALSE;
    v_de_ind.version           := FALSE;
    v_de_ind.preferred_definition := FALSE;
    v_de_ind.long_name           := FALSE;
    v_de_ind.asl_name           := FALSE;
    v_de_ind.vd_idseq           := FALSE;
    v_de_ind.latest_version_ind   := FALSE;
    v_de_ind.dec_idseq            := FALSE;
    v_de_ind.begin_date           := FALSE;
    v_de_ind.end_date           := FALSE;
    v_de_ind.change_note       := FALSE;
    v_de_ind.created_by           := FALSE;
    v_de_ind.date_created       := FALSE;
    v_de_ind.modified_by       := TRUE;
    v_de_ind.date_modified       := TRUE;
    v_de_ind.deleted_ind          := TRUE;
    v_de_ind.cde_id            := FALSE; -- 15-Jul-2003, W. Ver Hoef
    v_de_ind.origin               := FALSE;
    BEGIN


      cg$data_elements_view.upd(v_de_rec,v_de_ind);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
dbms_output.put_line('SQLERRM = '||SQLERRM);
dbms_output.put_line('SQLCODE = '||SQLCODE);
      P_RETURN_CODE := 'API_DE_502'; --Error deleting Data Element
   RETURN;
    END;

  END IF;

  IF P_DE_LATEST_VERSION_IND IS NOT NULL THEN
    IF P_DE_LATEST_VERSION_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_DE_105'; --Version can only be 'Yes' or 'No'
      RETURN;
    END IF;
  END IF;
  --Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
  IF LENGTH(P_DE_PREFERRED_NAME) > Sbrext_Column_Lengths.L_DE_PREFERRED_NAME THEN
    P_RETURN_CODE := 'API_DE_111';  --Length of preferred_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_DE_PREFERRED_DEFINITION) > Sbrext_Column_Lengths.L_DE_PREFERRED_DEFINITION THEN
    P_RETURN_CODE := 'API_DE_113';  --Length of Preferred_definition exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_DE_LONG_NAME) > Sbrext_Column_Lengths.L_DE_LONG_NAME THEN
    P_RETURN_CODE := 'API_DE_114'; --Length of Long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_DE_ASL_NAME) > Sbrext_Column_Lengths.L_DE_ASL_NAME  THEN
    P_RETURN_CODE := 'API_DE_115'; --Length of asl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_DE_CHANGE_NOTE) > Sbrext_Column_Lengths.L_DE_CHANGE_NOTE THEN
    P_RETURN_CODE := 'API_DE_128'; --Length of change_note exceeds maximum length
    RETURN;
  END IF;

  --check to see that charachter strings are valid
  IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_DE_PREFERRED_NAME) THEN
    P_RETURN_CODE := 'API_DE_130'; -- Data Element Preferred Name has invalid Ccharacters
    RETURN;
  END IF;

  IF NOT Sbrext_Common_Routines.valid_char(P_DE_PREFERRED_DEFINITION) THEN
    P_RETURN_CODE := 'API_DE_133'; -- Data Element Preferred Definition has invalid characters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_DE_LONG_NAME) THEN
    P_RETURN_CODE := 'API_DE_134'; -- Data Element Long Name has invalid characters
    RETURN;
  END IF;

  --check to see that Context, Workflow Status, Data Element Concept, Value Domain already exist in the database
  IF P_DE_CONTE_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.context_exists(P_DE_CONTE_IDSEQ) THEN
      P_RETURN_CODE := 'API_DE_200'; --Context not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_DE_VD_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.ac_exists(P_DE_VD_IDSEQ)  THEN
      P_RETURN_CODE := 'API_DE_201'; --Value Domain not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_DE_ASL_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.workflow_exists(P_DE_ASL_NAME) THEN
      P_RETURN_CODE := 'API_DE_202'; --Workflow Status not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_DE_DEC_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.ac_exists(P_DE_DEC_IDSEQ) THEN
      P_RETURN_CODE := 'API_DE_203'; --DEC_IDSEQ not found in the database
      RETURN;
    END IF;
  END IF;

  --check to see that begin date and end date are valid dates
  IF(P_DE_BEGIN_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_DE_BEGIN_DATE,v_begin_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_DE_600'; --begin date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_DE_END_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_DE_END_DATE,v_end_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_DE_601'; --end date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_DE_BEGIN_DATE IS NOT NULL AND P_DE_END_DATE IS NOT NULL) THEN
    IF(v_end_date < v_begin_date) THEN
       P_RETURN_CODE := 'API_DE_210'; --end date is before begin date
       RETURN;
    END IF;
  --ELSIF(P_DE_END_DATE IS NOT NULL AND P_DE_BEGIN_DATE IS NULL) THEN
    --P_RETURN_CODE := 'API_DE_211'; --begin date cannot be null when end date is null
    --RETURN;
  END IF;

  IF (P_ACTION = 'INS' ) THEN

    -- check to see that a Data Element with the same
    -- Preferred Name, Context and Version does not already exist
    IF Sbrext_Common_Routines.ac_exists(P_DE_PREFERRED_NAME,P_DE_CONTE_IDSEQ ,P_DE_VERSION,'DATAELEMENT') THEN
      P_RETURN_CODE := 'API_DE_300';-- Data Element already Exists
      RETURN;
    END IF;
    -- Check to see if prior versions alresdy exist
    IF Sbrext_Common_Routines.ac_version_exists(P_DE_PREFERRED_NAME,P_DE_CONTE_IDSEQ ,'DATAELEMENT') THEN -- we are creating a new version
      v_new_version := TRUE;
      v_ac          := Sbrext_Common_Routines.get_version_ac(P_DE_PREFERRED_NAME,P_DE_CONTE_IDSEQ,'DATAELEMENT');
    END IF;

 -- 16-Jul-2003, W. Ver Hoef - replaced parameter P_DE_DE_IDSEQ with variable v_de_idseq
    v_de_idseq         := admincomponent_crud.cmr_guid;
    P_DE_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_DE_CREATED_BY    := ADMIN_SECURITY_UTIL.effective_user;
    P_DE_DATE_MODIFIED := NULL;
    P_DE_MODIFIED_BY   := NULL;
    P_DE_DELETED_IND   := 'No';

    v_de_rec.de_idseq             := v_de_idseq; -- 16-Jul-2003, W. Ver Hoef - replaced here too
    v_de_rec.preferred_name       := P_DE_PREFERRED_NAME;
    v_de_rec.conte_idseq          := P_DE_CONTE_IDSEQ;
    v_de_rec.version              := P_DE_VERSION;
    v_de_rec.preferred_definition := P_DE_PREFERRED_DEFINITION;
    v_de_rec.long_name            := P_DE_LONG_NAME;
    v_de_rec.asl_name             := P_DE_ASL_NAME ;
    v_de_rec.dec_idseq            := P_DE_DEC_IDSEQ;
    v_de_rec.vd_idseq             := P_DE_VD_IDSEQ ;
    v_de_rec.latest_version_ind   := P_DE_LATEST_VERSION_IND;
    v_de_rec.begin_date           := TO_DATE(P_DE_BEGIN_DATE);
    v_de_rec.end_date             := TO_DATE(P_DE_END_DATE);
    v_de_rec.change_note          := P_DE_CHANGE_NOTE ;
    v_de_rec.created_by           := P_DE_CREATED_BY;
    v_de_rec.date_created         := TO_DATE(P_DE_DATE_CREATED);
    v_de_rec.modified_by          := P_DE_MODIFIED_BY;
    v_de_rec.date_modified        := TO_DATE(P_DE_DATE_MODIFIED);
    v_de_rec.deleted_ind          := P_DE_DELETED_IND;
 v_de_rec.origin               := P_DE_ORIGIN;  -- 15-Jul-2003, W. Ver Hoef
 SELECT cde_id_seq.NEXTVAL -- When transaction_type := 'VERSION' as below,
 INTO v_de_rec.cde_id      -- BIU trigger won't properly assign a value
 FROM dual;                -- so we have to set it here.

    v_de_ind.de_idseq             := TRUE;
    v_de_ind.preferred_name       := TRUE;
    v_de_ind.conte_idseq          := TRUE;
    v_de_ind.version              := TRUE;
    v_de_ind.preferred_definition := TRUE;
    v_de_ind.long_name            := TRUE;
    v_de_ind.asl_name             := TRUE;
    v_de_ind.dec_idseq            := TRUE;
    v_de_ind.vd_idseq             := TRUE;
    v_de_ind.latest_version_ind   := TRUE;
    v_de_ind.begin_date           := TRUE;
    v_de_ind.end_date             := TRUE;
    v_de_ind.change_note          := TRUE;
    v_de_ind.created_by           := TRUE;
    v_de_ind.date_created         := TRUE;
    v_de_ind.modified_by          := TRUE;
    v_de_ind.date_modified        := TRUE;
    v_de_ind.deleted_ind          := TRUE;
 v_de_ind.cde_id               := TRUE;  -- 15-Jul-2003, W. Ver Hoef
 v_de_ind.origin               := TRUE;

    BEGIN
     -- meta_global_pkg.transaction_type := 'VERSION';
      cg$data_elements_view.ins(v_de_rec,v_de_ind);
      P_DE_DE_IDSEQ := v_de_rec.de_idseq;  -- 16-Jul-2003, W. Ver Hoef - added assignment
   meta_global_pkg.transaction_type := NULL;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_DE_500'; --Error inserting Data Element
    END;

    --If LATEST_VERSION_IND is 'Yes' then update so that all other versions have the indicator set to 'No'
    IF(P_DE_LATEST_VERSION_IND = 'Yes') THEN
      Sbrext_Common_Routines.set_ac_lvi(P_RETURN_CODE,P_DE_DE_IDSEQ,'DATAELEMENT');
      IF P_RETURN_CODE IS NOT NULL  THEN
        P_RETURN_CODE := 'API_DE_503'; -- Error updating latest_Value_ind
        RETURN;
      END IF;
    END IF;

    --create a history record with prior version
    IF v_new_version THEN
      BEGIN
        meta_config_mgmt.CREATE_AC_HISTORIES (v_ac,P_DE_DE_IDSEQ,'VERSIONED','DATAELEMENT');
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_DE_504'; --Error creating history
      END;
    END IF;

  END IF;

  IF (P_ACTION = 'UPD' ) THEN

    --Get the version for the P_DE_DECIDSEQ
    SELECT version INTO v_version
    FROM data_elements_view
    WHERE de_idseq = P_DE_DE_IDSEQ;

    IF v_version <> P_DE_VERSION THEN
      P_RETURN_CODE := 'API_DE_402'; -- Version can NOT be updated. It can only be created
      RETURN;
    END IF;

    P_DE_DATE_MODIFIED := TO_CHAR(SYSDATE);
    P_DE_MODIFIED_BY   := ADMIN_SECURITY_UTIL.effective_user;
    P_DE_DELETED_IND   := 'No';

    v_de_rec.date_modified := TO_DATE(P_DE_DATE_MODIFIED);
    v_de_rec.modified_by   := P_DE_MODIFIED_BY;
    v_de_rec.de_idseq      := P_DE_DE_IDSEQ;
    v_de_rec.deleted_ind   := 'No';

    v_de_ind.date_modified := TRUE;
    v_de_ind.modified_by   := TRUE;
    v_de_ind.deleted_ind   := TRUE;
    v_de_ind.de_idseq      := TRUE;

    v_de_ind.version       := FALSE;
    v_de_ind.created_by    := FALSE;
    v_de_ind.date_created  := FALSE;
 v_de_ind.cde_id        := FALSE;  -- 15-Jul-2003, W. Ver Hoef

    IF P_DE_PREFERRED_NAME IS NULL THEN
      v_de_ind.preferred_name := FALSE;
    ELSE
      v_de_rec.preferred_name := P_DE_PREFERRED_NAME;
      v_de_ind.preferred_name := TRUE;
    END IF;

    IF P_DE_CONTE_IDSEQ IS NULL THEN
      v_de_ind.conte_idseq := FALSE;
    ELSE
      v_de_rec.conte_idseq := P_DE_CONTE_IDSEQ;
      v_de_ind.conte_idseq := TRUE;
    END IF;

    IF P_DE_PREFERRED_DEFINITION IS NULL THEN
      v_de_ind.preferred_definition := FALSE;
    ELSE
      v_de_rec.preferred_definition := P_DE_PREFERRED_DEFINITION;
      v_de_ind.preferred_definition := TRUE;
    END IF;

    IF P_DE_LONG_NAME IS NULL THEN
      v_de_ind.long_name := FALSE;
 ELSIF P_DE_long_name = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_de_rec.long_name := NULL;
      v_de_ind.long_name := TRUE;
    ELSE
      v_de_rec.long_name := P_DE_LONG_NAME;
      v_de_ind.long_name := TRUE;
    END IF;

    IF P_DE_ASL_NAME IS NULL THEN
      v_de_ind.asl_name := FALSE;
    ELSE
      v_de_rec.asl_name := P_DE_ASL_NAME;
      v_de_ind.asl_name := TRUE;
    END IF;

    IF P_DE_DEC_IDSEQ IS NULL THEN
      v_de_ind.dec_idseq := FALSE;
    ELSE
      v_de_rec.dec_idseq := P_DE_DEC_IDSEQ;
      v_de_ind.dec_idseq := TRUE;
    END IF;

    IF P_DE_VD_IDSEQ IS NULL THEN
      v_de_ind.vd_idseq  := FALSE;
    ELSE
      v_de_rec.vd_idseq  := P_DE_VD_IDSEQ;
      v_de_ind.vd_idseq  := TRUE;
    END IF;

    IF P_DE_LATEST_VERSION_IND IS NULL THEN
      v_de_ind.latest_version_ind := FALSE;
    ELSE
      v_de_rec.latest_version_ind := P_DE_LATEST_VERSION_IND;
      v_de_ind.latest_version_ind := TRUE;
    END IF;

    IF P_DE_BEGIN_DATE IS NULL THEN
      v_de_ind.begin_date := FALSE;
 ELSIF P_DE_begin_date = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_de_rec.begin_date := NULL;
      v_de_ind.begin_date := TRUE;
    ELSE
      v_de_rec.begin_date := TO_DATE(P_DE_BEGIN_DATE);
      v_de_ind.begin_date := TRUE;
    END IF;

    IF P_DE_END_DATE  IS NULL THEN
      v_de_ind.end_date := FALSE;
 ELSIF P_DE_end_date = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_de_rec.end_date := NULL;
      v_de_ind.end_date := TRUE;
    ELSE
      v_de_rec.end_date := TO_DATE(P_DE_END_DATE);
      v_de_ind.end_date := TRUE;
    END IF;

    IF P_DE_CHANGE_NOTE   IS NULL THEN
      v_de_ind.change_note := FALSE;
 ELSIF P_DE_change_note = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_de_rec.change_note := NULL;
      v_de_ind.change_note := TRUE;
    ELSE
      v_de_rec.change_note := P_DE_CHANGE_NOTE  ;
      v_de_ind.change_note := TRUE;
    END IF;

    IF P_DE_ORIGIN   IS NULL THEN  -- 15-Jul-2003, W. Ver Hoef
      v_de_ind.origin := FALSE;
 ELSIF P_DE_origin = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_de_rec.origin := NULL;
      v_de_ind.origin := TRUE;
    ELSE
      v_de_rec.origin := P_DE_ORIGIN  ;
      v_de_ind.origin := TRUE;
    END IF;

    BEGIN
--      dbms_output.put_line(v_de_rec.preferred_Definition);
      cg$data_elements_view.upd(v_de_rec,v_de_ind);
--      null;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_DE_501'; --Error updating Data Element
    END;

    --If LATEST_VERSION_IND is'Yes' then update so that all other versions have the indicator set to 'No'
    IF(P_DE_LATEST_VERSION_IND = 'Yes') THEN
      Sbrext_Common_Routines.set_ac_lvi(P_RETURN_CODE,P_DE_DE_IDSEQ,'DATAELEMENT');
      IF P_RETURN_CODE IS NOT NULL  THEN
        P_RETURN_CODE := 'API_DE_503'; -- Error updating latest_Value_ind
        RETURN;
      END IF;
    END IF;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;
END SET_DE;


PROCEDURE SET_RD(
P_RETURN_CODE     OUT    VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_RD_RD_IDSEQ             IN OUT VARCHAR2
,P_RD_NAME                 IN OUT VARCHAR2
,P_RD_DCTL_NAME             IN OUT VARCHAR2
,P_RD_AC_IDSEQ             IN OUT VARCHAR2
,P_RD_ACH_IDSEQ             IN OUT VARCHAR2
,P_RD_AR_IDSEQ             IN OUT VARCHAR2
,P_RD_DOC_TEXT             IN OUT VARCHAR2
,P_RD_ORG_IDSEQ             IN OUT VARCHAR2
,P_RD_URL                      IN OUT VARCHAR2
,P_RD_CREATED_BY         OUT    VARCHAR2
,P_RD_DATE_CREATED         OUT    VARCHAR2
,P_RD_MODIFIED_BY         OUT    VARCHAR2
,P_RD_DATE_MODIFIED         OUT    VARCHAR2
,P_RD_LAE_NAME              IN  VARCHAR2 DEFAULT 'ENGLISH'
,P_RD_CONTE_IDSEQ              IN VARCHAR2 )  IS
/******************************************************************************
   NAME:       SET_RD
   PURPOSE:    Inserts or Updates a Single Row Of Reference Document Based on either
               RD_IDSEQ or PAC_IDSEQ, NAME

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal      1. Created this procedure




******************************************************************************/

v_rd_rec    cg$reference_documents_view.cg$row_type;
v_rd_ind    cg$reference_documents_view.cg$ind_type;
v_rd_pk     cg$reference_documents_view.cg$pk_type;
v_conte_idseq VARCHAR2(36):= p_rd_conte_idseq;
BEGIN
P_RETURN_CODE := NULL;

IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
 P_RETURN_CODE := 'API_RD_700'; -- Invalid action
 RETURN;
END IF;
IF P_ACTION = 'INS' THEN             --we are inserting a record
  IF P_RD_RD_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_RD_100' ;  --for inserts the ID is generated
  RETURN;
  ELSE
     --Check to see that all mandatory parameters are either not NULL or have a default value.
  IF P_RD_NAME IS NULL THEN
     P_RETURN_CODE := 'API_RD_101';  --Name cannot be null here
  RETURN;
  END IF;
  IF P_RD_DCTL_NAME IS NULL THEN
     P_RETURN_CODE := 'API_RD_102'; --Document Type cannot be null here
  RETURN;
  END IF;
       IF P_RD_AC_IDSEQ IS NULL AND P_RD_ACH_IDSEQ IS NULL AND P_RD_AR_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_RD_103'; --All AC_IDSEQ or ACH_IDSEQ or AR_IDSEQ  can not be null here
  RETURN;
  END IF;
  --check arc
       IF NOT Sbrext_Common_Routines.valid_arc(P_RD_AC_IDSEQ,P_RD_ACH_IDSEQ,P_RD_AR_IDSEQ) THEN
         P_RETURN_CODE := 'API_RD_210';  --Invalid arc. Only one of the arc keys of the arc can have a value.
         RETURN;
       END IF;

  END IF;
END IF;
IF P_ACTION = 'UPD' THEN              --we are updating a record
  IF P_RD_RD_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_RD_400' ;  --for updates the ID IS mandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.rd_exists(P_RD_RD_IDSEQ) THEN
   P_RETURN_CODE := 'API_RD_005'; --Reference Document not found
   RETURN;
 END IF;
  END IF;
  IF (P_RD_AC_IDSEQ IS NOT NULL OR P_RD_ACH_IDSEQ IS NOT NULL OR P_RD_AR_IDSEQ IS NOT NULL)THEN
       P_RETURN_CODE := 'API_RD_212'; -- only update of content is allowed. update of  relationship is not allowed
       RETURN;
  END IF;
 --check the arc
  IF NOT Sbrext_Common_Routines.valid_arc(P_RD_AC_IDSEQ,P_RD_ACH_IDSEQ,P_RD_AR_IDSEQ) THEN
    P_RETURN_CODE := 'API_RD_210';  --Invalid arc. Only one of the arc keys of the arc can have a value.
    RETURN;
  END IF;
END IF;
IF P_ACTION = 'DEL' THEN              --we are deleting a record
  IF P_RD_RD_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_RD_400' ;  --for deleted the ID idmandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.rd_exists(P_RD_RD_IDSEQ) THEN
   P_RETURN_CODE := 'API_RD_005'; --RD NOT found
   RETURN;
 END IF;
  END IF;
  v_rd_pk.rd_idseq := P_RD_RD_IDSEQ;

  SELECT ROWID INTO v_rd_pk.the_rowid
  FROM reference_documents_view
  WHERE rd_idseq = P_RD_RD_IDSEQ;
  --v_rd_pk.jn_notes := NULL;

  BEGIN
    cg$reference_documents_view.del(v_rd_pk);
 RETURN;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_RD_502'; --Error deleteing reference document
 RETURN;
  END;
END IF;

--Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
IF LENGTH(P_RD_NAME) > Sbrext_Column_Lengths.L_RD_NAME THEN
  P_RETURN_CODE := 'API_RD_111';  --Length of name exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_RD_DCTL_NAME) > Sbrext_Column_Lengths.L_RD_DCTL_NAME THEN
  P_RETURN_CODE := 'API_RD_112'; --Length of Document Type exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_RD_DOC_TEXT) > Sbrext_Column_Lengths.L_RD_DOC_TEXT THEN
  P_RETURN_CODE := 'API_RD_113';  --Length of document text exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_RD_URL) > Sbrext_Column_Lengths.L_RD_URL THEN
  P_RETURN_CODE := 'API_RD_114'; --Length of URL exceeds maximum length
  RETURN;
END IF;

--check to see that charachter strings are valid
IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_RD_NAME) THEN
  P_RETURN_CODE := 'API_RD_130'; -- Name has invalid characters
  RETURN;
END IF;

IF NOT Sbrext_Common_Routines.valid_char(P_RD_DOC_TEXT) THEN
  P_RETURN_CODE := 'API_RD_134'; -- Document Text has invalid characters
  RETURN;
END IF;


--check to see that foreign keys already exist in the database
IF(P_RD_AC_IDSEQ) IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.ac_exists(P_RD_AC_IDSEQ)  THEN
    P_RETURN_CODE := 'API_RD_200'; --Administered Component not found in the database
    RETURN;
  END IF;
END IF;
IF NOT Sbrext_Common_Routines.dctl_exists(P_RD_DCTL_NAME) THEN
  P_RETURN_CODE := 'API_RD_201'; --Document Type not found in the database
  RETURN;
END IF;

IF V_CONTE_IDSEQ IS NOT NULL THEN
IF NOT Sbrext_Common_Routines.CONTEXT_EXISTS(v_conte_idseq) THEN
  P_RETURN_CODE := 'API_RD_207'; --Document Type not found in the database
  RETURN;
END IF;
END IF;

IF P_RD_ACH_IDSEQ IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.ach_exists(P_RD_ACH_IDSEQ) THEN
    P_RETURN_CODE := 'API_RD_203'; --ACH not found not found in the database
    RETURN;
  END IF;
END IF;

IF P_RD_AR_IDSEQ IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.ar_exists(P_RD_AR_IDSEQ) THEN
    P_RETURN_CODE := 'API_RD_204'; --AR not found in the database
    RETURN;
  END IF;
END IF;
IF P_RD_ORG_IDSEQ IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.org_exists(P_RD_ACH_IDSEQ) THEN
    P_RETURN_CODE := 'API_RD_205'; --Organinzation not found in the database
    RETURN;
  END IF;
END IF;

IF (P_ACTION = 'INS' ) THEN

--check to see that  a Reference document with the same
--Name, AC_IDSEQ does not already exist
  IF Sbrext_Common_Routines.rd_exists(P_RD_NAME,P_RD_AC_IDSEQ) THEN
   P_RETURN_CODE := 'API_RD_300';-- Reference Document already Exists
   RETURN;
  END IF;

IF v_conte_idseq IS NULL THEN
 BEGIN
  SELECT conte_idseq INTO v_conte_idseq
  FROM administered_components
  WHERE ac_idseq = p_rd_Ac_idseq;
 EXCEPTION WHEN OTHERS THEN
   P_RETURN_CODE := 'API_RD_10'; --ac not valid
 END;
END IF;

  P_RD_RD_IDSEQ := admincomponent_crud.cmr_guid;
  P_RD_DATE_CREATED := TO_CHAR(SYSDATE);
  P_RD_CREATED_BY := ADMIN_SECURITY_UTIL.effective_user;
  P_RD_DATE_MODIFIED := NULL;
  P_RD_MODIFIED_BY := NULL;

  v_rd_rec.rd_idseq          := P_RD_RD_IDSEQ;
  v_rd_rec.name              := P_RD_NAME;
  v_rd_rec.org_idseq      := P_RD_ORG_IDSEQ;
  v_rd_rec.dctl_name      := P_RD_DCTL_NAME;
  v_rd_rec.doc_text          := P_RD_DOC_TEXT;
  v_rd_rec.ar_idseq          := P_RD_AR_IDSEQ ;
  v_rd_rec.ach_idseq       := P_RD_ACH_IDSEQ;
  v_rd_rec.ac_idseq          := P_RD_AC_IDSEQ ;
  v_rd_rec.url              := P_RD_URL ;
  v_rd_rec.lae_name              := P_RD_LAE_NAME ;
  v_rd_rec.created_by      := P_RD_CREATED_BY;
  v_rd_rec.date_created      := TO_DATE(P_RD_DATE_CREATED);
  v_rd_rec.modified_by      := P_RD_MODIFIED_BY;
  v_rd_rec.date_modified  := TO_DATE(P_RD_DATE_MODIFIED);
  v_rd_rec.conte_idseq  := v_conte_idseq;


  v_rd_ind.rd_idseq          := TRUE;
  v_rd_ind.name              := TRUE;
  v_rd_ind.org_idseq      := TRUE;
  v_rd_ind.dctl_name         := TRUE;
  v_rd_ind.doc_text          := TRUE;
  v_rd_ind.ar_idseq          := TRUE;
  v_rd_ind.ach_idseq       := TRUE;
  v_rd_ind.ac_idseq          := TRUE;
  v_rd_ind.url               := TRUE;
  v_rd_ind.lae_name          := TRUE;
  v_rd_ind.created_by      := TRUE;
  v_rd_ind.date_created      := TRUE;
  v_rd_ind.modified_by      := TRUE;
  v_rd_ind.date_modified  := TRUE;
  v_rd_ind.conte_idseq    := TRUE;

  BEGIN
    cg$reference_documents_view.ins(v_rd_rec,v_rd_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_RD_500'; --Error inserting Reference documents
 RAISE;
  END;
END IF;

IF (P_ACTION = 'UPD' ) THEN

  P_RD_DATE_MODIFIED := TO_CHAR(SYSDATE);
  P_RD_MODIFIED_BY := ADMIN_SECURITY_UTIL.effective_user;

  v_rd_rec.date_modified := TO_DATE(P_RD_DATE_MODIFIED);
  v_rd_rec.modified_by   := P_RD_MODIFIED_BY;
  v_rd_rec.rd_idseq     := P_RD_RD_IDSEQ;
  v_rd_ind.date_modified := TRUE;
  v_rd_ind.modified_by   := TRUE;
  v_rd_ind.rd_idseq     := TRUE;
  v_rd_ind.created_by       := FALSE;
  v_rd_ind.date_created   := FALSE;
  v_rd_ind.ac_idseq     := FALSE;
  v_rd_ind.ach_idseq     := FALSE;
  v_rd_ind.ar_idseq     := FALSE;

  IF P_RD_NAME IS NULL THEN
    v_rd_ind.name := FALSE;
  ELSE
    v_rd_rec.name := P_RD_NAME;
    v_rd_ind.name := TRUE;
  END IF;

  IF P_RD_ORG_IDSEQ IS NULL THEN
    v_rd_ind.org_idseq := FALSE;
  ELSIF P_RD_ORG_IDSEQ = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
    v_rd_rec.org_idseq := NULL;
    v_rd_ind.org_idseq := TRUE;
  ELSE
    v_rd_rec.org_idseq := P_RD_ORG_IDSEQ;
    v_rd_ind.org_idseq := TRUE;
  END IF;

  IF P_RD_DCTL_NAME IS NULL THEN
    v_rd_ind.dctl_name := FALSE;
  ELSE
    v_rd_rec.dctl_name := P_RD_DCTL_NAME;
    v_rd_ind.dctl_name := TRUE;
  END IF;

  IF P_RD_DOC_TEXT IS NULL THEN
    v_rd_ind.doc_text := FALSE;
  ELSIF P_RD_DOC_TEXT = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
    v_rd_rec.doc_text := NULL;
    v_rd_ind.doc_text := TRUE;
  ELSE
    v_rd_rec.doc_text := P_RD_DOC_TEXT;
    v_rd_ind.doc_text := TRUE;
  END IF;

  IF P_RD_URL   IS NULL THEN
    v_rd_ind.url := FALSE;
  ELSIF P_RD_URL = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
    v_rd_rec.url := NULL;
    v_rd_ind.url := TRUE;
  ELSE
    v_rd_rec.url := P_RD_URL  ;
    v_rd_ind.url := TRUE;
  END IF;

  IF P_RD_CONTE_IDSEQ  IS NULL THEN
    v_rd_ind.conte_idseq := FALSE;
  ELSE
    v_rd_rec.conte_idseq := P_RD_CONTE_IDSEQ  ;
    v_rd_ind.conte_idseq := TRUE;
  END IF;

  IF P_RD_LAE_NAME   IS NULL THEN
    v_rd_ind.lae_name := FALSE;
  ELSIF P_RD_lae_name = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
    v_rd_rec.lae_name := NULL;
    v_rd_ind.lae_name := TRUE;
  ELSE
    v_rd_rec.lae_name := P_RD_LAE_NAME ;
    v_rd_ind.lae_name := TRUE;
  END IF;

  BEGIN
    cg$reference_documents_view.upd(v_rd_rec,v_rd_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_RD_501'; --Error updating Reference Document
  END;
END IF;

EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       RAISE;
END SET_RD;



PROCEDURE SET_DES(
P_RETURN_CODE     OUT    VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_DES_DESIG_IDSEQ         IN OUT VARCHAR2
,P_DES_NAME                 IN OUT VARCHAR2
,P_DES_DETL_NAME         IN OUT VARCHAR2
,P_DES_AC_IDSEQ             IN OUT VARCHAR2
,P_DES_CONTE_IDSEQ         IN OUT VARCHAR2
,P_DES_LAE_NAME             IN OUT VARCHAR2
,P_DES_CREATED_BY         OUT    VARCHAR2
,P_DES_DATE_CREATED         OUT    VARCHAR2
,P_DES_MODIFIED_BY         OUT    VARCHAR2
,P_DES_DATE_MODIFIED     OUT    VARCHAR2)  IS
/******************************************************************************
   NAME:       SET_DES
   PURPOSE:    Inserts or Updates a Single Row Of Designation Based on either
               DES_IDSEQ or Name, Context, DETL_NAME  and AC_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal  1. Created this procedure
   2.0        07/16/2003  W. Ver Hoef      2. Added debug messages to test set_de
                                              in curator pkg which calls this

******************************************************************************/

v_des_rec    cg$designations_view.cg$row_type;
v_des_ind    cg$designations_view.cg$ind_type;
v_des_pk     cg$designations_view.cg$pk_type;
BEGIN

P_RETURN_CODE := NULL;
IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
  P_RETURN_CODE := 'API_DES_700'; -- Invalid action
  RETURN;
END IF;

IF P_ACTION = 'INS' THEN             --we are inserting a record
  IF P_DES_DESIG_IDSEQ IS NOT NULL THEN
    P_RETURN_CODE := 'API_DES_100' ;  --for inserts the ID is generated
 RETURN;
  ELSE
     --Check to see that all mandatory parameters are either not NULL or have a default value.
  /*IF P_DES_NAME IS NULL THEN
     P_RETURN_CODE := 'API_DES_101';  --Name cannot be null here
  RETURN;
  END IF;*/
  IF (P_DES_DETL_NAME IS NULL AND P_DES_DETL_NAME <> 'CDE_ID')  THEN
     P_RETURN_CODE := 'API_DES_102'; --Desgination Type cannot be null here
  RETURN;
  END IF;
       IF P_DES_AC_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_DES_103'; --AC_IDSEQ  can not be null here
  RETURN;
  END IF;
       IF P_DES_CONTE_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_DES_104'; --CONTE_IDSEQ  can not be null here
  RETURN;
  END IF;
  END IF;
END IF;
IF P_ACTION = 'UPD' THEN              --we are updating a record
  IF P_DES_DESIG_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_DES_400' ;  --for updates the ID IS mandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.des_exists(P_DES_DESIG_IDSEQ) THEN
   P_RETURN_CODE := 'API_DES_005'; --Desgination not found
   RETURN;
 END IF;
  END IF;
END IF;

IF P_ACTION = 'DEL' THEN              --we are deleting a record
  IF P_DES_DESIG_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_DES_400' ;  --for deleted the ID idmandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.des_exists(P_DES_DESIG_IDSEQ) THEN
   P_RETURN_CODE := 'API_DES_005'; --Designation NOT found
   RETURN;
 END IF;
  END IF;
  v_des_pk.desig_idseq := P_DES_DESIG_IDSEQ;

  SELECT ROWID INTO v_des_pk.the_rowid
  FROM designations_view
  WHERE desig_idseq = P_DES_DESIG_IDSEQ;
  v_des_pk.jn_notes := NULL;

  BEGIN
    cg$designations_view.del(v_des_pk);
 RETURN;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_DES_502'; --Error deleteing Designation
 RETURN;
  END;
END IF;

--Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
IF LENGTH(P_DES_NAME) > Sbrext_Column_Lengths.L_DES_NAME THEN
  P_RETURN_CODE := 'API_DES_111';  --Length of name exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_DES_DETL_NAME) > Sbrext_Column_Lengths.L_DES_DETL_NAME THEN
  P_RETURN_CODE := 'API_DES_112'; --Length of Designation Type exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_DES_LAE_NAME) > Sbrext_Column_Lengths.L_DES_LAE_NAME THEN
  P_RETURN_CODE := 'API_DES_113';  --Length of Language exceeds maximum length
  RETURN;
END IF;

--check to see that charachter strings are valid
-- Changed the validation to valid_name which allows names starting with numbers
IF NOT Sbrext_Common_Routines.valid_name(P_DES_NAME) THEN
  P_RETURN_CODE := 'API_DES_130'; -- Name has invalid characters
  RETURN;
END IF;

--check to see that foreign keys already exist in the database

IF NOT Sbrext_Common_Routines.ac_exists(P_DES_AC_IDSEQ)  THEN
  P_RETURN_CODE := 'API_DES_200'; --Administered Component not found in the database
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.detl_exists(P_DES_DETL_NAME) THEN
  P_RETURN_CODE := 'API_DES_201'; --Desgination Type not found in the database
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.context_exists(P_DES_CONTE_IDSEQ) THEN
  P_RETURN_CODE := 'API_DES_203'; --Context not found in the database
  RETURN;
END IF;
IF P_DES_LAE_NAME IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.lae_exists(P_DES_LAE_NAME) THEN
    P_RETURN_CODE := 'API_DES_204'; --Language not found in the database
    RETURN;
  END IF;
END IF;

IF (P_ACTION = 'INS' ) THEN

--check to see that  document with the same
--Name, AC_IDSEQ does not already exist
  IF Sbrext_Common_Routines.des_exists(P_DES_AC_IDSEQ,P_DES_NAME,P_DES_DETL_NAME,P_DES_CONTE_IDSEQ) THEN
   P_RETURN_CODE := 'API_DES_300';--Desgination already Exists
   RETURN;
  END IF;

  P_DES_DESIG_IDSEQ := admincomponent_crud.cmr_guid;
  P_DES_DATE_CREATED := TO_CHAR(SYSDATE);
  P_DES_CREATED_BY := ADMIN_SECURITY_UTIL.effective_user;
  P_DES_DATE_MODIFIED := NULL;
  P_DES_MODIFIED_BY := NULL;

  v_des_rec.desig_idseq          := P_DES_DESIG_IDSEQ;
  v_des_rec.name              := P_DES_NAME;
  v_des_rec.conte_idseq      := P_DES_CONTE_IDSEQ;
  v_des_rec.ac_idseq      := P_DES_AC_IDSEQ;
  v_des_rec.detl_name      := P_DES_DETL_NAME;
  v_des_rec.lae_name          := P_DES_LAE_NAME;
  v_des_rec.created_by      := P_DES_CREATED_BY;
  v_des_rec.date_created      := TO_DATE(P_DES_DATE_CREATED);
  v_des_rec.modified_by      := P_DES_MODIFIED_BY;
  v_des_rec.date_modified  := TO_DATE(P_DES_DATE_MODIFIED);


  v_des_ind.desig_idseq          := TRUE;
  v_des_ind.name              := TRUE;
  v_des_ind.conte_idseq      := TRUE;
  v_des_ind.ac_idseq      := TRUE;
  v_des_ind.detl_name         := TRUE;
  v_des_ind.lae_name          := TRUE;
  v_des_ind.created_by      := TRUE;
  v_des_ind.date_created      := TRUE;
  v_des_ind.modified_by      := TRUE;
  v_des_ind.date_modified  := TRUE;

  BEGIN
    cg$designations_view.ins(v_des_rec,v_des_ind);

 SELECT name INTO p_des_name
 FROM designations_view
 WHERE desig_idseq = P_DES_DESIG_IDSEQ;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_DES_500'; --Error inserting Designation
  END;
END IF;

IF (P_ACTION = 'UPD' ) THEN

  P_DES_DATE_MODIFIED := TO_CHAR(SYSDATE);
  P_DES_MODIFIED_BY := ADMIN_SECURITY_UTIL.effective_user;

  v_des_rec.date_modified := TO_DATE(P_DES_DATE_MODIFIED);
  v_des_rec.modified_by   := P_DES_MODIFIED_BY;
  v_des_rec.desig_idseq   := P_DES_DESIG_IDSEQ;
  v_des_ind.date_modified := TRUE;
  v_des_ind.modified_by   := TRUE;
  v_des_ind.desig_idseq   := TRUE;
  v_des_ind.created_by   := FALSE;
  v_des_ind.date_created  := FALSE;

  IF P_DES_NAME IS NULL THEN
    v_des_ind.name := FALSE;
  ELSE
    v_des_rec.name := P_DES_NAME;
    v_des_ind.name := TRUE;
  END IF;

  IF P_DES_CONTE_IDSEQ IS NULL THEN
    v_des_ind.conte_idseq := FALSE;
  ELSE
    v_des_rec.conte_idseq := P_DES_CONTE_IDSEQ;
    v_des_ind.conte_idseq := TRUE;
  END IF;

  IF P_DES_DETL_NAME IS NULL THEN
    v_des_ind.detl_name := FALSE;
  ELSE
    v_des_rec.detl_name := P_DES_DETL_NAME;
    v_des_ind.detl_name := TRUE;
  END IF;

  IF P_DES_LAE_NAME IS NULL THEN
    v_des_ind.lae_name := FALSE;
  ELSIF P_des_lae_name = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
    v_des_rec.lae_name := NULL;
    v_des_ind.lae_name := TRUE;
  ELSE
    v_des_rec.lae_name := P_DES_LAE_NAME;
    v_des_ind.lae_name := TRUE;
  END IF;

  IF P_DES_AC_IDSEQ IS NULL THEN
    v_des_ind.ac_idseq  := FALSE;
  ELSE
    v_des_rec.ac_idseq  := P_DES_AC_IDSEQ;
    v_des_ind.ac_idseq  := TRUE;
  END IF;

    BEGIN
    cg$designations_view.upd(v_des_rec,v_des_ind);
 SELECT name INTO p_des_name
 FROM designations_view
 WHERE desig_idseq = P_DES_DESIG_IDSEQ;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_DES_501'; --Error updating Designation
  END;
END IF;

EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_DES;



PROCEDURE  SET_CSCSI(
P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_CSCSI_CS_CSI_IDSEQ     IN OUT VARCHAR2
,P_CSCSI_CS_IDSEQ         IN OUT VARCHAR2
,P_CSCSI_LABEL            IN OUT VARCHAR2
,P_CSCSI_CSI_IDSEQ         IN OUT VARCHAR2
,P_CSCSI_P_CS_CSI_IDSEQ     IN OUT VARCHAR2
,P_CSCSI_LINK_CS_CSI_IDSEQ IN OUT VARCHAR2
,P_CSCSI_DISPLAY_ORDER     IN OUT NUMBER
,P_CSCSI_DATE_CREATED     OUT VARCHAR2
,P_CSCSI_CREATED_BY         OUT VARCHAR2
,P_CSCSI_MODIFIED_BY     OUT VARCHAR2
,P_CSCSI_DATE_MODIFIED     OUT VARCHAR2)  IS
/******************************************************************************
   NAME:       SET_CS_CSI
   PURPOSE:    Inserts or Updates a Single Row Of CS_CSI on either
               CS_CSI_IDSEQ or CS_IDSEQ, CSI_IDSEQ and P_CS_CSI_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal      1. Created this procedure




******************************************************************************/




v_cscsi_rec    cg$cs_csi_view.cg$row_type;
v_cscsi_ind    cg$cs_csi_view.cg$ind_type;
BEGIN
P_RETURN_CODE := NULL;
IF P_ACTION NOT IN ('INS') THEN
 P_RETURN_CODE := 'API_CSCSI_700'; -- Invalid action
 RETURN;
END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
  IF P_CSCSI_CS_CSI_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_CSCSI_100' ;  --for inserts the ID IS generated
  RETURN;
  ELSE
     --Check to see that all mandatory parameters are not null

  IF P_CSCSI_CS_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_CSCSI_102'; --CS_IDSEQ cannot be null here
  RETURN;
  END IF;

  IF P_CSCSI_CSI_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_CSCSI_103'; --CSI_IDSEQ cannot be null here
  RETURN;
  END IF;
       IF P_CSCSI_LABEL IS NULL THEN
     P_RETURN_CODE := 'API_CSCSI_104'; --LABEL cannot be null here
  RETURN;
  END IF;

  END IF;
END IF;



--check to see that foreign keys

IF NOT Sbrext_Common_Routines.ac_exists(P_CSCSI_CS_IDSEQ)  THEN
  P_RETURN_CODE := 'API_CSCSI_201'; --CS NOT found in the database
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.csi_exists(P_CSCSI_CSI_IDSEQ)  THEN
  P_RETURN_CODE := 'API_CSCSI_202'; --CSI NOT found in the database
  RETURN;
END IF;

IF P_CSCSI_P_CS_CSI_IDSEQ IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.cs_csi_exists(P_CSCSI_P_CS_CSI_IDSEQ) THEN
    P_RETURN_CODE := 'API_CSCSI_200'; --Parent not found in the database
    RETURN;
  END IF;
END IF;
IF P_CSCSI_LINK_CS_CSI_IDSEQ IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.cs_csi_exists(P_CSCSI_LINK_CS_CSI_IDSEQ) THEN
    P_RETURN_CODE := 'API_CSCSI_203'; --Link not found in the database
    RETURN;
  END IF;
END IF;


IF (P_ACTION = 'INS' ) THEN
--check to see that CS CSI already exists
  IF Sbrext_Common_Routines.cs_csi_exists(P_CSCSI_CS_IDSEQ,P_CSCSI_CSI_IDSEQ,P_CSCSI_P_CS_CSI_IDSEQ) THEN
    p_return_code := 'API_CSCSI_300';-- CCombination Already Exist
    RETURN;
  END IF;
  P_CSCSI_CS_CSI_IDSEQ := admincomponent_crud.cmr_guid;
  P_CSCSI_DATE_CREATED := TO_CHAR(SYSDATE);
  P_CSCSI_CREATED_BY := ADMIN_SECURITY_UTIL.effective_user;
  P_CSCSI_DATE_MODIFIED := NULL;
  P_CSCSI_MODIFIED_BY := NULL;

  v_cscsi_rec.cs_csi_idseq       := P_CSCSI_CS_CSI_IDSEQ;
  v_cscsi_rec.cs_idseq           := P_CSCSI_CS_IDSEQ ;
  v_cscsi_rec.csi_idseq          := P_CSCSI_CSI_IDSEQ ;
  v_cscsi_rec.p_cs_csi_idseq  := P_CSCSI_P_CS_CSI_IDSEQ ;
  v_cscsi_rec.link_cs_csi_idseq  := P_CSCSI_LINK_CS_CSI_IDSEQ ;
  v_cscsi_rec.label              := P_CSCSI_LABEL ;
  v_cscsi_rec.display_order      := P_CSCSI_DISPLAY_ORDER ;
  v_cscsi_rec.created_by         := P_CSCSI_CREATED_BY;
  v_cscsi_rec.date_created      := TO_DATE(P_CSCSI_DATE_CREATED);
  v_cscsi_rec.modified_by      := P_CSCSI_MODIFIED_BY;
  v_cscsi_rec.date_modified      := P_CSCSI_DATE_MODIFIED;

  v_cscsi_ind.cs_csi_idseq       := TRUE;
  v_cscsi_ind.cs_idseq          := TRUE;
  v_cscsi_ind.csi_idseq          := TRUE;
  v_cscsi_ind.p_cs_csi_idseq  := TRUE ;
  v_cscsi_ind.link_cs_csi_idseq  := TRUE ;
  v_cscsi_ind.label              := TRUE ;
  v_cscsi_ind.display_order      := TRUE ;
  v_cscsi_ind.created_by      := TRUE;
  v_cscsi_ind.date_created      := TRUE;
  v_cscsi_ind.modified_by      := TRUE;
  v_cscsi_ind.date_modified      := TRUE;

  BEGIN
    cg$cs_csi_view.ins(v_cscsi_rec,v_cscsi_ind);
  EXCEPTION WHEN OTHERS THEN
   P_RETURN_CODE := 'API_CSCSI_500'; --Error inserting CS_CSIS
  END;
END IF;

 EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_CSCSI;

PROCEDURE  SET_ACCSI(
P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_ACCSI_AC_CSI_IDSEQ     IN OUT VARCHAR2
,P_ACCSI_AC_IDSEQ         IN OUT VARCHAR2
,P_ACCSI_CS_CSI_IDSEQ     IN OUT VARCHAR2
,P_ACCSI_DATE_CREATED     OUT VARCHAR2
,P_ACCSI_CREATED_BY         OUT VARCHAR2
,P_ACCSI_MODIFIED_BY     OUT VARCHAR2
,P_ACCSI_DATE_MODIFIED     OUT VARCHAR2)  IS
/******************************************************************************
   NAME:       SET_ACCSI
   PURPOSE:    Inserts or Updates a Single Row Of AC_CSI on either
               AC_CSI_IDSEQ or CS_CSI_IDSEQ, CS_CSI_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal      1. Created this procedure




******************************************************************************/


v_ac_csi_rec  cg$ac_csi_view.cg$row_type;
v_ac_csi_ind  cg$ac_csi_view.cg$ind_type;
v_ac_csi_pk   cg$ac_csi_view.cg$pk_type;
BEGIN
P_RETURN_CODE := NULL;
IF P_ACTION NOT IN ('INS','DEL') THEN
 P_RETURN_CODE := 'API_ACCSI_700'; -- Invalid action
 RETURN;
END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
  IF P_ACCSI_AC_CSI_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_ACCSI_100' ;  --for inserts the ID IS generated
  RETURN;
  ELSE
     --Check to see that all mandatory parameters are not null

  IF P_ACCSI_AC_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_ACCSI_102'; --AC_IDSEQ is mandatory
  RETURN;
  END IF;

  IF P_ACCSI_CS_CSI_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_ACCSI_104'; --CS_CSI_IDSEQ is mandatory
  RETURN;
  END IF;
  END IF;
END IF;


IF P_ACTION = 'DEL' THEN              --we are deleting a record
  IF P_ACCSI_AC_CSI_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_ACCSI_400' ;  --for deleted the ID idmandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.ac_csi_exists(P_ACCSI_AC_CSI_IDSEQ) THEN
   P_RETURN_CODE := 'API_ACCSI_005'; --AC_CSI NOT found
   RETURN;
 END IF;
  END IF;


  v_ac_csi_pk.ac_csi_idseq := P_ACCSI_AC_CSI_IDSEQ;
  SELECT ROWID INTO v_ac_csi_pk.the_rowid
  FROM ac_csi_view
  WHERE ac_csi_idseq = P_ACCSI_AC_CSI_IDSEQ;
  v_ac_csi_pk.jn_notes := NULL;

  BEGIN
    cg$ac_csi_view.del(v_ac_csi_pk);
 RETURN;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_ACCSI_501'; --Error deleteing
 RETURN;
  END;

END IF;

--check to see that foreign keys exist in the database

IF NOT Sbrext_Common_Routines.ac_exists(P_ACCSI_AC_IDSEQ)  THEN
  P_RETURN_CODE := 'API_ACCSI_201'; --Administered Component NOT found in the database
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.cs_csi_exists(P_ACCSI_CS_CSI_IDSEQ)  THEN
  P_RETURN_CODE := 'API_ACCSI_202'; --CS_CSI NOT found in the database
  RETURN;
END IF;

IF (P_ACTION = 'INS' ) THEN
--check to see already exist
  IF Sbrext_Common_Routines.ac_csi_exists(P_ACCSI_AC_IDSEQ,P_ACCSI_CS_CSI_IDSEQ) THEN
    p_return_code := 'API_ACCSI_300';-- CCombination Already Exist
    RETURN;
  END IF;
  P_ACCSI_AC_CSI_IDSEQ := admincomponent_crud.cmr_guid;
  P_ACCSI_DATE_CREATED := TO_CHAR(SYSDATE);
  P_ACCSI_CREATED_BY := ADMIN_SECURITY_UTIL.effective_user;
  P_ACCSI_DATE_MODIFIED := NULL;
  P_ACCSI_MODIFIED_BY := NULL;

  v_ac_csi_rec.ac_csi_idseq   := P_ACCSI_AC_CSI_IDSEQ;
  v_ac_csi_rec.ac_idseq       := P_ACCSI_AC_IDSEQ ;
  v_ac_csi_rec.cs_csi_idseq       := P_ACCSI_CS_CSI_IDSEQ ;
  v_ac_csi_rec.created_by   := P_ACCSI_CREATED_BY;
  v_ac_csi_rec.date_created   := TO_DATE(P_ACCSI_DATE_CREATED);
  v_ac_csi_rec.modified_by   := P_ACCSI_MODIFIED_BY;
  v_ac_csi_rec.date_modified  := P_ACCSI_DATE_MODIFIED;

  v_ac_csi_ind.AC_IDSEQ       := TRUE;
  v_ac_csi_ind.AC_CSI_IDSEQ   := TRUE;
  v_ac_csi_ind.CS_CSI_IDSEQ       := TRUE;
  v_ac_csi_ind.created_by   := TRUE;
  v_ac_csi_ind.date_created   := TRUE;
  v_ac_csi_ind.modified_by   := TRUE;
  v_ac_csi_ind.date_modified  := TRUE;
  BEGIN
    cg$ac_csi_view.ins(v_ac_csi_rec,v_ac_csi_ind);
  EXCEPTION WHEN OTHERS THEN
   P_RETURN_CODE := 'API_ACCSI_500'; --Error inserting AC_CSI
  END;
END IF;


 EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_ACCSI;

PROCEDURE SET_SRC(
P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_SRC_SRC_NAME             IN OUT VARCHAR2
,P_SRC_DESCRIPTION         IN OUT VARCHAR2
,P_SRC_CREATED_BY         OUT VARCHAR2
,P_SRC_DATE_CREATED         OUT VARCHAR2
,P_SRC_MODIFIED_BY         OUT VARCHAR2
,P_SRC_DATE_MODIFIED     OUT VARCHAR2)  IS
/******************************************************************************
   NAME:       SET_SRC
   PURPOSE:    Inserts or Updates a Single Row Of Source List of Value
               Based on ?Name

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/31/2001  Prerna Aggarwal      1. Created this procedure




******************************************************************************/
v_src_rec    Cg$sources_View_Ext.cg$row_type;
v_src_ind    Cg$sources_View_Ext.cg$ind_type;
BEGIN
P_RETURN_CODE := NULL;
IF P_ACTION NOT IN ('INS','UPD') THEN
 P_RETURN_CODE := 'API_SRC_700'; -- Invalid action
 RETURN;
END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
     --Check to see that all mandatory parameters are either not null
  IF P_SRC_SRC_NAME IS NULL THEN
    P_RETURN_CODE := 'API_SRC_101';  --Source Name cannot be null here
 RETURN;
  END IF;
END IF;

IF P_ACTION = 'UPD'  THEN
  IF P_SRC_SRC_NAME IS NULL THEN
    P_RETURN_CODE := 'API_SRC_101';  --Source Name cannot be null here
 RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.src_exists(P_SRC_SRC_NAME) THEN
   P_RETURN_CODE := 'API_SRC_005'; --SRC not found
   RETURN;
  END IF;
END IF;
--Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
IF LENGTH(P_SRC_SRC_NAME) > Sbrext_Column_Lengths.L_SRC_SRC_NAME THEN
  P_RETURN_CODE := 'API_SRC_111';  --Length of NAME exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_SRC_DESCRIPTION) > Sbrext_Column_Lengths.L_SRC_DESCRIPTION THEN
  P_RETURN_CODE := 'API_SRC_113';  --Length of DESCRIPTION exceeds maximum length
  RETURN;
END IF;

--check to see that charachter strings are valid
IF NOT Sbrext_Common_Routines.valid_char(P_SRC_SRC_NAME) THEN
  P_RETURN_CODE := 'API_SRC_130'; -- Source Name Short Meaning has invalid characters
  RETURN;
END IF;
IF P_SRC_DESCRIPTION IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.valid_char(P_SRC_DESCRIPTION) THEN
    P_RETURN_CODE := 'API_SRC_133'; -- Source Name Description has invalid characters
    RETURN;
  END IF;
END IF;

IF (P_ACTION = 'INS' ) THEN

--check to see that Short Name Does not already Exist
  IF Sbrext_Common_Routines.src_exists(P_SRC_SRC_NAME) THEN
    P_RETURN_CODE := 'API_SRC_300';-- Source Name already exists
    RETURN;
  END IF;

  P_SRC_DATE_CREATED  := TO_CHAR(SYSDATE);
  P_SRC_CREATED_BY    := ADMIN_SECURITY_UTIL.effective_user;
  P_SRC_DATE_MODIFIED := NULL;
  P_SRC_MODIFIED_BY   := NULL;

  v_src_rec.src_name     := P_SRC_SRC_NAME;
  v_src_rec.description     := P_SRC_DESCRIPTION;
  v_src_rec.created_by     := P_SRC_CREATED_BY;
  v_src_rec.date_created := P_SRC_DATE_CREATED;
  v_src_rec.modified_by     := P_SRC_MODIFIED_BY;
  v_src_rec.date_modified := P_SRC_DATE_MODIFIED;


  v_src_ind.src_name       := TRUE;
  v_src_ind.description       := TRUE;
  v_src_ind.created_by       := TRUE;
  v_src_ind.date_created   := TRUE;
  v_src_ind.modified_by       := TRUE;
  v_src_ind.date_modified   := TRUE;

  BEGIN
    Cg$sources_View_Ext.ins(v_src_rec,v_src_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_SRC_500'; --Error inserting Source Name
  END;

END IF;


IF (P_ACTION = 'UPD' ) THEN

  P_SRC_DATE_MODIFIED := TO_CHAR(SYSDATE);
  P_SRC_MODIFIED_BY := ADMIN_SECURITY_UTIL.effective_user;
  v_src_rec.date_modified := P_SRC_DATE_MODIFIED;
  v_src_rec.modified_by := P_SRC_MODIFIED_BY;
  v_src_ind.date_modified := TRUE;
  v_src_ind.modified_by := TRUE;
  v_src_ind.created_by := FALSE;
  v_src_ind.date_created := FALSE;

  IF P_SRC_DESCRIPTION IS NULL THEN
    v_src_ind.description := FALSE;
  ELSE
    v_src_rec.description := P_SRC_DESCRIPTION;
    v_src_ind.description := TRUE;
  END IF;
  BEGIN
    Cg$sources_View_Ext.upd(v_src_rec,v_src_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_SRC_501'; --Error updating Source
  END;
END IF;

EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_SRC;


PROCEDURE SET_TS(
P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN  VARCHAR2
,P_TS_TS_IDSEQ             IN OUT VARCHAR2
,P_TS_QC_IDSEQ             IN OUT VARCHAR2
,P_TS_TSTL_NAME             IN OUT VARCHAR2
,P_TS_TS_TEXT             IN OUT VARCHAR2
,P_TS_TS_SEQ             IN OUT NUMBER
,P_TS_CREATED_BY         OUT VARCHAR2
,P_TS_DATE_CREATED         OUT VARCHAR2
,P_TS_MODIFIED_BY         OUT VARCHAR2
,P_TS_DATE_MODIFIED         OUT VARCHAR2) IS
/******************************************************************************
   NAME:       SET_TS
   PURPOSE:    Inserts or Updates a Single Row Of TEXT STRING based on                     TS_IDSEQ
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/31/2001  Prerna Aggarwal      1. Created this procedure




******************************************************************************/

v_ts_rec    Cg$text_Strings_View_Ext.cg$row_type;
v_ts_ind    Cg$text_Strings_View_Ext.cg$ind_type;
v_ts_pk     Cg$text_Strings_View_Ext.cg$pk_type;
BEGIN
P_RETURN_CODE := NULL;
IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
 P_RETURN_CODE := 'API_TS_700'; -- Invalid action
 RETURN;
END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
  IF P_TS_TS_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_TS_100' ;  --for inserts the ID IS generated
  RETURN;
  ELSE
     --Check to see that all mandatory parameters are either NOT NULL or have a default value.
  IF P_TS_QC_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_TS_101';  --QC_IDSEQ cannot be NULL here
  RETURN;
  END IF;
  IF P_TS_TSTL_NAME IS NULL THEN
     P_RETURN_CODE := 'API_TS_103'; --TSTL_NAME cannot be NULL here
  RETURN;
  END IF;
  IF P_TS_TS_TEXT IS NULL THEN
     P_RETURN_CODE := 'API_TS_104'; --Text cannot be NULL here
  RETURN;
  END IF;
       IF P_TS_TS_SEQ IS NULL THEN
     P_RETURN_CODE := 'API_TS_105'; --Sequence cannot be NULL here
  RETURN;
  END IF;

  END IF;
END IF;


IF P_ACTION = 'UPD' THEN              --we are inserting a record
  IF P_TS_TS_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_TS_400' ;  --for updates the ID is mandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.ts_exists(P_TS_TS_IDSEQ) THEN
   P_RETURN_CODE := 'API_TS_005'; --TS not found
   RETURN;
 END IF;
  END IF;
END IF;

IF P_ACTION = 'DEL' THEN              --we are deleting a record
  IF P_TS_TS_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_TS_400' ;  --for deleted the ID idmandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.ts_exists(P_TS_TS_IDSEQ) THEN
   P_RETURN_CODE := 'API_TS_005'; --TSNOT found
   RETURN;
 END IF;
  END IF;

  v_ts_pk.ts_idseq := P_TS_TS_IDSEQ;
  SELECT ROWID INTO v_ts_pk.the_rowid
  FROM text_strings_view_ext
  WHERE ts_idseq = P_TS_TS_IDSEQ;
  v_ts_pk.jn_notes := NULL;

  BEGIN
    Cg$text_Strings_View_Ext.del(v_ts_pk);
 RETURN;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_TS_502'; --Error deleteing Text String
 RETURN;
  END;

END IF;
--Check to see that all VARCHAR2 and CHAR parameters have correct length
IF LENGTH(P_TS_TSTL_NAME) > Sbrext_Column_Lengths.L_TS_TSTL_NAME THEN
  P_RETURN_CODE := 'API_TS_113';  --Length of TS Type exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_TS_TS_TEXT) > Sbrext_Column_Lengths.L_TS_TS_TEXT THEN
  P_RETURN_CODE := 'API_TS_114'; --Length of TS TExt exceeds maximum length
  RETURN;
END IF;

--check to see that charachter strings are valid
IF NOT Sbrext_Common_Routines.valid_char(P_TS_TSTL_NAME) THEN
  P_RETURN_CODE := 'API_TS_133'; -- TEXT STRING Type has invalid characters
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.valid_char(P_TS_TS_TEXT) THEN
  P_RETURN_CODE := 'API_TS_134'; -- TEXT STRING Text has invalid characters
  RETURN;
END IF;


--check to see that Foreign Keys already exist in the database

IF NOT Sbrext_Common_Routines.tstl_exists(P_TS_TSTL_NAME) THEN
    P_RETURN_CODE := 'API_TS_200'; --Text String Type not found in the database
 RETURN;
END IF;
IF NOT Sbrext_Common_Routines.ac_exists(P_TS_QC_IDSEQ) THEN
    P_RETURN_CODE := 'API_TS_201'; --Questionnaire Content not found in the database
 RETURN;
END IF;

IF (P_ACTION = 'INS' ) THEN

--check to see that Value  does not already

  P_TS_TS_IDSEQ := admincomponent_crud.cmr_guid;
  P_TS_DATE_CREATED := TO_CHAR(SYSDATE);
  P_TS_CREATED_BY := ADMIN_SECURITY_UTIL.effective_user;
  P_TS_DATE_MODIFIED := NULL;
  P_TS_MODIFIED_BY := NULL;

  v_ts_rec.ts_idseq            := P_TS_TS_IDSEQ;
  v_ts_rec.qc_idseq            := P_TS_QC_IDSEQ;
  v_ts_rec.tstl_name       := P_TS_TSTL_NAME;
  v_ts_rec.ts_text := P_TS_TS_TEXT;
  v_ts_rec.ts_seq    := P_TS_TS_SEQ;
  v_ts_rec.created_by        := P_TS_CREATED_BY;
  v_ts_rec.date_created        := TO_DATE(P_TS_DATE_CREATED);
  v_ts_rec.modified_by        := P_TS_MODIFIED_BY;
  v_ts_rec.date_modified    := P_TS_DATE_MODIFIED;


  v_ts_ind.ts_idseq             := TRUE;
  v_ts_ind.qc_idseq             := TRUE;
  v_ts_ind.tstl_name        := TRUE;
  v_ts_ind.ts_text  := TRUE;
  v_ts_ind.ts_seq     := TRUE;
  v_ts_ind.created_by         := TRUE;
  v_ts_ind.date_created         := TRUE;
  v_ts_ind.modified_by         := TRUE;
  v_ts_ind.date_modified     := TRUE;

  BEGIN
    Cg$text_Strings_View_Ext.ins(v_ts_rec,v_ts_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_TS_500'; --Error inserting TEXT STRING
  END;

END IF;



IF (P_ACTION = 'UPD' ) THEN

  P_TS_DATE_MODIFIED     := TO_CHAR(SYSDATE);
  P_TS_MODIFIED_BY       := ADMIN_SECURITY_UTIL.effective_user;
  v_ts_rec.date_modified := TO_DATE(P_TS_DATE_MODIFIED);
  v_ts_rec.modified_by   := P_TS_MODIFIED_BY;
  v_ts_rec.ts_idseq      := P_TS_TS_IDSEQ;

  v_ts_ind.date_modified := TRUE;
  v_ts_ind.modified_by   := TRUE;
  v_ts_ind.ts_idseq      := TRUE;

  v_ts_ind.created_by       := FALSE;
  v_ts_ind.date_created       := FALSE;

  IF P_TS_QC_IDSEQ IS NULL THEN
    v_ts_ind.qc_idseq := FALSE;
  ELSE
    v_ts_rec.qc_idseq := P_TS_QC_IDSEQ;
    v_ts_ind.qc_idseq := TRUE;
  END IF;

  IF P_TS_TSTL_NAME IS NULL THEN
    v_ts_ind.tstl_name := FALSE;
  ELSE
    v_ts_rec.tstl_name := P_TS_TSTL_NAME;
    v_ts_ind.tstl_name := TRUE;
  END IF;

  IF P_TS_TS_TEXT IS NULL THEN
    v_ts_ind.ts_text := FALSE;
  ELSE
    v_ts_rec.ts_text := P_TS_TS_TEXT;
    v_ts_ind.ts_text := TRUE;
  END IF;

  IF P_TS_TS_SEQ IS NULL THEN
    v_ts_ind.ts_seq := FALSE;
  ELSE
    v_ts_rec.ts_seq := P_TS_TS_SEQ;
    v_ts_ind.ts_seq := TRUE;
  END IF;


  BEGIN
    Cg$text_Strings_View_Ext.upd(v_ts_rec,v_ts_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_TS_501'; --Error updating Text String
  END;
END IF;

EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_TS;


PROCEDURE SET_ACSRC(
P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_ACSRC_ACS_IDSEQ         IN OUT VARCHAR2
,P_ACSRC_AC_IDSEQ         IN OUT VARCHAR2
,P_ACSRC_SRC_NAME           IN OUT VARCHAR2
,P_ACSRC_DATE_SUBMITTED     IN OUT VARCHAR2
,P_ACSRC_CREATED_BY         OUT VARCHAR2
,P_ACSRC_DATE_CREATED     OUT VARCHAR2
,P_ACSRC_MODIFIED_BY     OUT VARCHAR2
,P_ACSRC_DATE_MODIFIED     OUT VARCHAR2) IS
/******************************************************************************
   NAME:       SET_ACSRC
   PURPOSE:    Inserts or Updates a Single Row Of AC_SOURCES based on either
               ACS_IDSEQ or AC_IDSEQ and SRC_NAME

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/31/2001  Prerna Aggarwal      1. Created this procedure




******************************************************************************/
v_acsrc_rec    Cg$ac_Sources_View_Ext.cg$row_type;
v_acsrc_ind    Cg$ac_Sources_View_Ext.cg$ind_type;
v_acsrc_pk     Cg$ac_Sources_View_Ext.cg$pk_type;
BEGIN
P_RETURN_CODE := NULL;
IF P_ACTION NOT IN ('INS','DEL') THEN
 P_RETURN_CODE := 'API_ACSRC_700'; -- Invalid action
 RETURN;
END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
  IF P_ACSRC_ACS_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_ACSRC_100' ;  --for inserts the ID IS generated
  RETURN;
  ELSE
     --Check to see that all mandatory parameters are either NOT NULL or have a default value.
  IF P_ACSRC_AC_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_ACSRC_101';  --AC_IDSEQ cannot be NULL here
  RETURN;
  END IF;
  IF P_ACSRC_SRC_NAME IS NULL THEN
     P_RETURN_CODE := 'API_ACSRC_103'; --Source Name cannot be NULL here
  RETURN;
  END IF;
  END IF;
END IF;


IF P_ACTION = 'DEL' THEN              --we are inserting a record
  IF P_ACSRC_ACS_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_ACSRC_400' ;  --for updates the ID is mandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.acsrc_exists(P_ACSRC_ACS_IDSEQ) THEN
   P_RETURN_CODE := 'API_ACSRC_005'; --ACSRC not found
   RETURN;
 END IF;
  END IF;
  v_acsrc_pk.acs_idseq := P_ACSRC_ACS_IDSEQ;
  SELECT ROWID INTO v_acsrc_pk.the_rowid
  FROM ac_sources_view_ext
  WHERE acs_idseq = P_ACSRC_ACS_IDSEQ;
  v_acsrc_pk.jn_notes := NULL;

  BEGIN
    Cg$ac_Sources_View_Ext.del(v_acsrc_pk);
 RETURN;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_ACSRC_501'; --Error deleteing AC source
 RETURN;
  END;
END IF;
--Check to see that all VARCHAR2 and CHAR parameters have correct length
IF LENGTH(P_ACSRC_SRC_NAME) > Sbrext_Column_Lengths.L_ACSRC_SRC_NAME THEN
  P_RETURN_CODE := 'API_ACSRC_113';  --Length of Source Name exceeds maximum length
  RETURN;
END IF;

 --check to see that Source Name and ac_idseq already exist in the database

IF NOT Sbrext_Common_Routines.src_exists(P_ACSRC_SRC_NAME) THEN
    P_RETURN_CODE := 'API_ACSRC_200'; --Source Name not found in the database
 RETURN;
END IF;
IF NOT Sbrext_Common_Routines.ac_exists(P_ACSRC_AC_IDSEQ) THEN
    P_RETURN_CODE := 'API_ACSRC_201'; --AC_IDSEQ not found in the database
 RETURN;
END IF;


IF (P_ACTION = 'INS' ) THEN

--check to see that record  does not already
  IF Sbrext_Common_Routines.acsrc_exists(P_ACSRC_AC_IDSEQ,P_ACSRC_SRC_NAME) THEN
    p_return_code := 'API_ACSRC_300';--  Source AC_IDSEQ ALREADY EXISTS
    RETURN;
  END IF;

  P_ACSRC_ACS_IDSEQ := admincomponent_crud.cmr_guid;
  P_ACSRC_DATE_CREATED := TO_CHAR(SYSDATE);
  P_ACSRC_CREATED_BY := ADMIN_SECURITY_UTIL.effective_user;
  P_ACSRC_DATE_MODIFIED := NULL;
  P_ACSRC_MODIFIED_BY := NULL;

  v_acsrc_rec.acs_idseq    := P_ACSRC_ACS_IDSEQ;
  v_acsrc_rec.ac_idseq        := P_ACSRC_AC_IDSEQ;
  v_acsrc_rec.src_name         := P_ACSRC_SRC_NAME;
  v_acsrc_rec.date_submitted   :=TO_DATE(P_ACSRC_DATE_SUBMITTED);
  v_acsrc_rec.created_by    := P_ACSRC_CREATED_BY;
  v_acsrc_rec.date_created    := TO_DATE(P_ACSRC_DATE_CREATED);
  v_acsrc_rec.modified_by    := P_ACSRC_MODIFIED_BY;
  v_acsrc_rec.date_modified    := P_ACSRC_DATE_MODIFIED;


  v_acsrc_ind.acs_idseq         := TRUE;
  v_acsrc_ind.ac_idseq             := TRUE;
  v_acsrc_ind.src_name              := TRUE;
  v_acsrc_ind.date_submitted     := TRUE;
  v_acsrc_ind.created_by         := TRUE;
  v_acsrc_ind.date_created         := TRUE;
  v_acsrc_ind.modified_by         := TRUE;
  v_acsrc_ind.date_modified         := TRUE;

  BEGIN
    Cg$ac_Sources_View_Ext.ins(v_acsrc_rec,v_acsrc_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_ACSRC_500'; --Error inserting AC Source
  END;

END IF;

/*

IF (P_ACTION = 'UPD' ) THEN

  P_ACSRC_DATE_MODIFIED     := to_char(sysdate);
  P_ACSRC_MODIFIED_BY       := user;
  v_acsrc_rec.date_modified := to_date(P_ACSRC_DATE_MODIFIED);
  v_acsrc_rec.modified_by   := P_ACSRC_MODIFIED_BY;
  v_acsrc_rec.acs_idseq   := P_ACSRC_ACS_IDSEQ;

  v_acsrc_ind.date_modified := TRUE;
  v_acsrc_ind.modified_by   := TRUE;
  v_acsrc_ind.acs_idseq   := TRUE;

  v_acsrc_ind.created_by := FALSE;
  v_acsrc_ind.date_created := FALSE;

  IF P_ACSRC_AC_IDSEQ IS NULL THEN
    v_acsrc_ind.ac_idseq := FALSE;
  ELSE
    v_acsrc_rec.ac_idseq := P_ACSRC_AC_IDSEQ;
    v_acsrc_ind.ac_idseq := TRUE;
  END IF;

  IF P_ACSRC_SRC_NAME IS NULL THEN
    v_acsrc_ind.src_name := FALSE;
  ELSE
    v_acsrc_rec.src_name := P_ACSRC_SRC_NAME;
    v_acsrc_ind.src_name := TRUE;
  END IF;

  IF P_ACSRC_DATE_SUBMITTED IS NULL THEN
    v_acsrc_ind.date_submitted := FALSE;
  ELSE
    v_acsrc_rec.date_submitted  := to_date(P_ACSRC_DATE_SUBMITTED);
    v_acsrc_ind.date_submitted  := TRUE;
  END IF;

  begin
    cg$ac_sources_view_ext.upd(v_acsrc_rec,v_acsrc_ind);
  exception when others THEN
    P_RETURN_CODE := 'API_ACSRC_502'; --Error updating AC Source
  end;
END IF;*/

EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_ACSRC;

PROCEDURE SET_VPSRC(
P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_VPSRC_VPS_IDSEQ         IN OUT VARCHAR2
,P_VPSRC_VP_IDSEQ         IN OUT VARCHAR2
,P_VPSRC_SRC_NAME           IN OUT VARCHAR2
,P_VPSRC_DATE_SUBMITTED     IN OUT VARCHAR2
,P_VPSRC_CREATED_BY         OUT VARCHAR2
,P_VPSRC_DATE_CREATED     OUT VARCHAR2
,P_VPSRC_MODIFIED_BY     OUT VARCHAR2
,P_VPSRC_DATE_MODIFIED     OUT VARCHAR2) IS
/******************************************************************************
   NAME:       SET_VPSRC
   PURPOSE:    Inserts or Updates a Single Row Of VD_PVS_SOURCES based on either
               VPS_IDSEQ or VP_IDSEQ and SRC_NAME

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/31/2001  Prerna Aggarwal      1. Created this procedure




******************************************************************************/

v_vdsrc_rec    Cg$vd_Pvs_Sources_View_Ext.cg$row_type;
v_vdsrc_ind    Cg$vd_Pvs_Sources_View_Ext.cg$ind_type;
v_vpsrc_pk     Cg$vd_Pvs_Sources_View_Ext.cg$pk_type;
BEGIN
P_RETURN_CODE := NULL;
IF P_ACTION NOT IN ('INS','DEL') THEN
 P_RETURN_CODE := 'API_VDSRC_700'; -- Invalid action
 RETURN;
END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
  IF P_VPSRC_VPS_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_VPSRC_100' ;  --for inserts the ID IS generated
  RETURN;
  ELSE
     --Check to see that all mandatory parameters are either NOT NULL or have a default value.
  IF P_VPSRC_VP_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_VPSRC_101';  --VP_IDSEQ cannot be NULL here
  RETURN;
  END IF;
  IF P_VPSRC_SRC_NAME IS NULL THEN
     P_RETURN_CODE := 'API_VPSRC_103'; --Source Name cannot be NULL here
  RETURN;
  END IF;
  END IF;
END IF;


IF P_ACTION = 'DEL' THEN              --we are inserting a record
  IF P_VPSRC_VPS_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_VPSRC_400' ;  --for updates the ID is mandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.vpsrc_exists(P_VPSRC_VPS_IDSEQ) THEN
   P_RETURN_CODE := 'API_VPSRC_005'; --VPSRC not found
   RETURN;
 END IF;
  END IF;
    v_vpsrc_pk.vps_idseq := P_VPSRC_VPS_IDSEQ;
  SELECT ROWID INTO v_vpsrc_pk.the_rowid
  FROM vd_pvs_sources_view_ext
  WHERE vps_idseq = P_VPSRC_VPS_IDSEQ;
  v_vpsrc_pk.jn_notes := NULL;

  BEGIN
    Cg$vd_Pvs_Sources_View_Ext.del(v_vpsrc_pk);
 RETURN;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_VPSRC_502'; --Error deleteing VP Source
 RETURN;
  END;
END IF;
--Check to see that all VARCHAR2 and CHAR parameters have correct length
IF LENGTH(P_VPSRC_SRC_NAME) > Sbrext_Column_Lengths.L_VPSRC_SRC_NAME THEN
  P_RETURN_CODE := 'API_VPSRC_113';  --Length of Source Name exceeds maximum length
  RETURN;
END IF;

 --check to see that Source Name and VP_IDSEQ already exist in the database

IF NOT Sbrext_Common_Routines.src_exists(P_VPSRC_SRC_NAME) THEN
    P_RETURN_CODE := 'API_VPSRC_200'; --Source Name not found in the database
 RETURN;
END IF;
IF NOT Sbrext_Common_Routines.vd_pvs_exists(P_VPSRC_VP_IDSEQ) THEN
    P_RETURN_CODE := 'API_VPSRC_201'; --VP_IDSEQ not found in the database
 RETURN;
END IF;


IF (P_ACTION = 'INS' ) THEN

--check to see that record  does not already
  IF Sbrext_Common_Routines.vpsrc_exists(P_VPSRC_VP_IDSEQ,P_VPSRC_SRC_NAME) THEN
    p_return_code := 'API_VPSRC_300';--  Source VP_IDSEQ ALREADY EXISTS
    RETURN;
  END IF;

  P_VPSRC_VPS_IDSEQ := admincomponent_crud.cmr_guid;
  P_VPSRC_DATE_CREATED := TO_CHAR(SYSDATE);
  P_VPSRC_CREATED_BY := ADMIN_SECURITY_UTIL.effective_user;
  P_VPSRC_DATE_MODIFIED := NULL;
  P_VPSRC_MODIFIED_BY := NULL;

  v_vdsrc_rec.vps_idseq    := P_VPSRC_VPS_IDSEQ;
  v_vdsrc_rec.vp_idseq        := P_VPSRC_VP_IDSEQ;
  v_vdsrc_rec.src_name         := P_VPSRC_SRC_NAME;
  v_vdsrc_rec.date_submitted   :=TO_DATE(P_VPSRC_DATE_SUBMITTED);
  v_vdsrc_rec.created_by  := P_VPSRC_CREATED_BY;
  v_vdsrc_rec.date_created  := TO_DATE(P_VPSRC_DATE_CREATED);
  v_vdsrc_rec.modified_by  := P_VPSRC_MODIFIED_BY;
  v_vdsrc_rec.date_modified  := P_VPSRC_DATE_MODIFIED;


  v_vdsrc_ind.vps_idseq         := TRUE;
  v_vdsrc_ind.vp_idseq         := TRUE;
  v_vdsrc_ind.src_name          := TRUE;
  v_vdsrc_ind.date_submitted   := TRUE;
  v_vdsrc_ind.created_by   := TRUE;
  v_vdsrc_ind.date_created   := TRUE;
  v_vdsrc_ind.modified_by   := TRUE;
  v_vdsrc_ind.date_modified   := TRUE;

  BEGIN
    Cg$vd_Pvs_Sources_View_Ext.ins(v_vdsrc_rec,v_vdsrc_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_VPSRC_500'; --Error inserting Source VP_IDSEQ
  END;

END IF;


/*
IF (P_ACTION = 'UPD' ) THEN

  P_VPSRC_DATE_MODIFIED     := to_char(sysdate);
  P_VPSRC_MODIFIED_BY       := user;
  v_vdpvs_rec.date_modified := to_date(P_VPSRC_DATE_MODIFIED);
  v_vdpvs_rec.modified_by   := P_VPSRC_MODIFIED_BY;
  v_vdpvs_rec.vps_idseq     := P_VPSRC_VPS_IDSEQ;

  v_vdpvs_ind.date_modified := TRUE;
  v_vdpvs_ind.modified_by   := TRUE;
  v_vdpvs_ind.VPs_idseq     := TRUE;

  v_vdpvs_ind.created_by    := FALSE;
  v_vdpvs_ind.date_created  := FALSE;

  IF P_VPSRC_VP_IDSEQ IS NULL THEN
    v_vdpvs_ind.vp_idseq := FALSE;
  ELSE
    v_vdpvs_rec.vp_idseq := P_VPSRC_VP_IDSEQ;
    v_vdpvs_ind.vp_idseq := TRUE;
  END IF;

  IF P_VPSRC_SRC_NAME IS NULL THEN
    v_vdpvs_ind.src_name := FALSE;
  ELSE
    v_vdpvs_rec.src_name := P_VPSRC_SRC_NAME;
    v_vdpvs_ind.src_name := TRUE;
  END IF;

  IF P_VPSRC_DATE_SUBMITTED IS NULL THEN
    v_vdpvs_ind.date_submitted := FALSE;
  ELSE
    v_vdpvs_rec.date_submitted  := to_date(P_VPSRC_DATE_SUBMITTED);
    v_vdpvs_ind.date_submitted  := TRUE;
  END IF;

  begin
    cg$vd_pvs_sources_view_ext.upd(v_vdpvs_rec,v_vdpvs_ind);
  exception when others THEN
    P_RETURN_CODE := 'API_VPSRC_501'; --Error updating Source VP_IDSEQ
  end;
END IF;*/

EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_VPSRC;

PROCEDURE SET_QC(
 P_RETURN_CODE      OUT    VARCHAR2
,P_ACTION                    IN     VARCHAR2
,P_QC_QC_IDSEQ              IN OUT VARCHAR2
,P_QC_VERSION              IN OUT NUMBER
,P_QC_PREFERRED_NAME      IN OUT VARCHAR2
,P_QC_PREFERRED_DEFINITION   IN OUT VARCHAR2
,P_QC_CONTE_IDSEQ          IN OUT VARCHAR2
,P_QC_ASL_NAME              IN OUT VARCHAR2
,P_QC_QTL_NAME              IN OUT VARCHAR2
,P_QC_LONG_NAME              IN OUT VARCHAR2
,P_QC_LATEST_VERSION_IND     IN OUT VARCHAR2
,P_QC_PROTO_IDSEQ          IN OUT VARCHAR2
,P_QC_DE_IDSEQ               IN OUT VARCHAR2
,P_QC_VP_IDSEQ              IN OUT VARCHAR2
,P_QC_QC_MATCH_IDSEQ        IN OUT VARCHAR2
,P_QC_QCDL_NAME                 IN OUT VARCHAR2
,P_QC_QC_IDENTIFIER          IN OUT VARCHAR2
,P_QC_MATCH_IND              IN OUT VARCHAR2
,P_QC_NEW_QC_IND             IN OUT VARCHAR2
,P_QC_HIGHLIGHT_IND          IN OUT VARCHAR2
,P_QC_CDE_DICTIONARY_ID         IN OUT VARCHAR2
,P_QC_SYSTEM_MSGS          IN OUT VARCHAR2
,P_QC_REVIEWER_FEEDBACK_EXT     IN OUT VARCHAR2
,P_QC_REVIEWER_FEEDBACK_INT     IN OUT VARCHAR2
,P_QC_REVIEWER_FEEDBACK_ACT   IN OUT VARCHAR2
,P_QC_REVIEWED_BY            IN OUT VARCHAR2
,P_QC_REVIEWED_DATE          IN OUT VARCHAR2
,P_QC_APPROVED_BY           IN OUT VARCHAR2
,P_QC_APPROVED_DATE          IN OUT VARCHAR2
,P_QC_BEGIN_DATE             IN OUT VARCHAR2
,P_QC_END_DATE               IN OUT VARCHAR2
,P_QC_CHANGE_NOTE          IN OUT VARCHAR2
,P_QC_SUB_LONG_NAME             IN OUT VARCHAR2
,P_QC_GROUP_COMMENTS            IN OUT VARCHAR2
,P_QC_VD_IDSEQ        IN OUT VARCHAR2
,P_QC_CREATED_BY          OUT    VARCHAR2
,P_QC_DATE_CREATED          OUT    VARCHAR2
,P_QC_MODIFIED_BY          OUT    VARCHAR2
,P_QC_DATE_MODIFIED          OUT    VARCHAR2
,P_QC_DELETED_IND          OUT    VARCHAR2
,P_QC_SRC_NAME      IN     VARCHAR2 DEFAULT NULL
,P_QC_P_MOD_IDSEQ    IN     VARCHAR2 DEFAULT NULL
,P_QC_P_QST_IDSEQ    IN     VARCHAR2 DEFAULT NULL
,P_QC_P_VAL_IDSEQ    IN     VARCHAR2 DEFAULT NULL
,P_QC_DN_CRF_IDSEQ    IN     VARCHAR2 DEFAULT NULL
,P_QC_DISPALY_IND      IN     VARCHAR2 DEFAULT NULL
,P_QC_GROUP_ACTION     IN     VARCHAR2 DEFAULT NULL
,P_QC_DE_LONG_NAME     IN     VARCHAR2 DEFAULT NULL
,P_QC_VD_LONG_NAME     IN     VARCHAR2 DEFAULT NULL
,P_QC_DEC_LONG_NAME      IN     VARCHAR2 DEFAULT NULL
,P_QC_ORIGIN      IN     VARCHAR2 DEFAULT NULL -- 23-Jul-2003, W. Ver Hoef
)  IS

-- Date:  23-Jul-2003
-- Modified By:  W. Ver Hoef
-- Reason:  added parameter and code for origin; added missing assignments for v_qc_rec
--          for DEL action; added extra if smtm with condition P_QC_VERSION is not null
--          around that parameter's validation WRT existing column value when action is
--          UPD
--
-- Date:  19-Mar-2004
-- Modified By:  W. Ver Hoef
-- Reason:  substituted UNASSIGNED with function call to get_default_asl
--

v_version  quest_contents_view_ext.version%TYPE;
v_ac       quest_contents_view_ext.qc_idseq%TYPE;
v_asl_name quest_contents_view_ext.asl_name%TYPE;

v_begin_date    DATE    := NULL;
v_end_date      DATE    := NULL;
v_reviewed_date DATE    := NULL;
v_approved_date DATE    := NULL;
v_new_version   BOOLEAN := FALSE;

v_qc_rec    Cg$quest_Contents_View_Ext.cg$row_type;
v_qc_ind    Cg$quest_Contents_View_Ext.cg$ind_type;

BEGIN

  P_RETURN_CODE := NULL;

  IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
    P_RETURN_CODE := 'API_QC_700'; -- Invalid action
    RETURN;
  END IF;

  IF P_ACTION = 'INS' THEN              --we are inserting a record
    IF P_QC_QC_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_QC_100' ;  --for inserts the ID is generated
   RETURN;
    ELSE
      --Check to see that all mandatory parameters are either not NULL or have a default value.
      IF P_QC_PREFERRED_NAME IS NULL THEN
        P_RETURN_CODE := 'API_QC_101';  --Preferred Name cannot be null here
        RETURN;
      END IF;
      IF P_QC_CONTE_IDSEQ IS NULL THEN
        P_RETURN_CODE := 'API_QC_102'; --CONTE_IDSEQ cannot be null here
        RETURN;
      END IF;
      IF P_QC_PREFERRED_DEFINITION IS NULL THEN
        P_RETURN_CODE := 'API_QC_103'; --Preferred Definition cannot be null here
        RETURN;
      END IF;
      IF P_QC_ASL_NAME IS NULL THEN
     -- 19-Mar-2004, W. Ver Hoef - substituted UNASSIGNED with function call below
        P_QC_ASL_NAME := Sbrext_Common_Routines.get_default_asl('INS'); -- 'UNASSIGNED';
      END IF;
      IF P_QC_VERSION IS NULL THEN
        P_QC_VERSION := Sbrext_Common_Routines.get_ac_version(P_QC_PREFERRED_NAME, P_QC_CONTE_IDSEQ,'QUEST_CONTENT','HIGHEST') + 1;
      END IF;
      IF P_QC_LATEST_VERSION_IND IS NULL THEN
        P_QC_LATEST_VERSION_IND := 'No';
      END IF;
      IF P_QC_QTL_NAME IS NULL THEN
        P_RETURN_CODE := 'API_QC_106'; --Content type has to be given
        RETURN;
      END IF;
/*    IF (P_QC_DE_IDSEQ is null and P_QC_VP_IDSEQ is null and P_QC_QC_MATCH_IDSEQ is null) THEN
      P_RETURN_CODE := 'API_QC_213';  --All three keys cannot be null
      RETURN;
    END IF;*/
      --check the arc
      IF NOT Sbrext_Common_Routines.valid_arc(P_QC_DE_IDSEQ,P_QC_VP_IDSEQ,P_QC_QC_MATCH_IDSEQ) THEN
        P_RETURN_CODE := 'API_QC_212';  --Invalid arc. Only one of the arc keys of the arc can have a value.
        RETURN;
      END IF;
    END IF;
  END IF;

  IF P_ACTION = 'UPD' THEN              --we are updating a record
    IF P_QC_QC_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_QC_400' ;  --for updates the ID IS mandatory
   RETURN;
    END IF;
    SELECT asl_name
 INTO   v_asl_name
    FROM   quest_contents_view_ext
    WHERE  qc_idseq = p_qc_qc_idseq;
    IF (P_QC_PREFERRED_NAME IS NOT NULL OR P_QC_CONTE_IDSEQ IS NOT NULL) AND v_asl_name = 'RELEASED' THEN
      P_RETURN_CODE := 'API_QC_401' ;  --Preferred Name or Context Can not be updated
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(P_QC_QC_IDSEQ) THEN
      P_RETURN_CODE := 'API_QC_005'; --QC NOT found
      RETURN;
    END IF;
    --check the arc
    IF NOT (P_QC_DE_IDSEQ = ' ' OR P_QC_VP_IDSEQ = ' ' OR P_QC_QC_MATCH_IDSEQ = ' ') THEN
      IF NOT Sbrext_Common_Routines.valid_arc(P_QC_DE_IDSEQ,P_QC_VP_IDSEQ,P_QC_QC_MATCH_IDSEQ) THEN
        P_RETURN_CODE := 'API_QC_212';  --Invalid arc. Only one of the arc keys of the arc can have a value.
        RETURN;
      END IF;
    END IF;
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are logically deleteing a record

    P_QC_DELETED_IND   := 'Yes';
    P_QC_MODIFIED_BY   := 'USER';
    P_QC_DATE_MODIFIED := TO_CHAR(SYSDATE);

 -- 23-Jul-2003, W. Ver Hoef - added missing assignments for v_qc_rec
    v_qc_rec.qc_idseq      := P_QC_QC_IDSEQ;
    v_qc_rec.deleted_ind   := P_QC_DELETED_IND;
    v_qc_rec.modified_by   := P_QC_MODIFIED_BY;
    v_qc_rec.date_modified := TO_DATE(P_QC_DATE_MODIFIED);

    v_qc_ind.qc_idseq                   := TRUE;
    v_qc_ind.preferred_name             := FALSE;
    v_qc_ind.conte_idseq                := FALSE;
    v_qc_ind.version                    := FALSE;
    v_qc_ind.preferred_definition       := FALSE;
    v_qc_ind.long_name                  := FALSE;
    v_qc_ind.qtl_name                   := FALSE;
    v_qc_ind.asl_name                   := FALSE;
    v_qc_ind.proto_idseq                := FALSE;
    v_qc_ind.de_idseq                   := FALSE;
    v_qc_ind.vp_idseq                   := FALSE;
    v_qc_ind.qc_match_idseq             := FALSE;
    v_qc_ind.qcdl_name                  := FALSE;
    v_qc_ind.match_ind                  := FALSE;
    v_qc_ind.qc_identifier              := FALSE;
    v_qc_ind.latest_version_ind         := FALSE;
    v_qc_ind.new_qc_ind                 := FALSE;
    v_qc_ind.reviewer_feedback_action   := FALSE;
    v_qc_ind.system_msgs                := FALSE;
    v_qc_ind.reviewer_feedback_internal := FALSE;
    v_qc_ind.reviewer_feedback_external := FALSE;
    v_qc_ind.reviewed_by                := FALSE;
    v_qc_ind.reviewed_date              := FALSE;
    v_qc_ind.approved_by                := FALSE;
    v_qc_ind.approved_date              := FALSE;
    v_qc_ind.cde_dictionary_id          := FALSE;
    v_qc_ind.submitted_long_cde_name := FALSE;
    v_qc_ind.group_comments             := FALSE;
    v_qc_ind.dn_vd_idseq                := FALSE;
    v_qc_ind.src_name          := FALSE;
    v_qc_ind.p_mod_idseq       := FALSE;
    v_qc_ind.p_qst_idseq       := FALSE;
    v_qc_ind.p_val_idseq       := FALSE;
    v_qc_ind.dn_Crf_idseq      := FALSE;
    v_qc_ind.display_ind       := FALSE;
    v_qc_ind.group_action      := FALSE;
    v_qc_ind.de_long_name      := FALSE;
    v_qc_ind.vd_long_name      := FALSE;
    v_qc_ind.dec_long_name     := FALSE;
    v_qc_ind.begin_date                 := FALSE;
    v_qc_ind.end_date                   := FALSE;
    v_qc_ind.change_note                := FALSE;
    v_qc_ind.created_by                 := FALSE;
    v_qc_ind.date_created               := FALSE;
    v_qc_ind.modified_by                := TRUE;
    v_qc_ind.date_modified              := TRUE;
    v_qc_ind.deleted_ind                := TRUE;
 v_qc_ind.origin                     := FALSE; -- 23-Jul-2003, W. Ver Hoef

    BEGIN
      Cg$quest_Contents_View_Ext.upd(v_qc_rec,v_qc_ind);
      RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_QC_502'; --Error deleting Questionnaire Content
      RETURN;
    END;

  END IF;

  IF P_QC_LATEST_VERSION_IND IS NOT NULL THEN
    IF P_QC_LATEST_VERSION_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_QC_105'; --Version can only be 'Yes' or 'No'
      RETURN;
    END IF;
  END IF;
  IF P_QC_HIGHLIGHT_IND IS NOT NULL THEN
    IF P_QC_HIGHLIGHT_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_QC_107'; --Highligh Indicator can only be 'Yes' or 'No'
      RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and CHAR parameters have correct length
  IF LENGTH(P_QC_PREFERRED_NAME) > Sbrext_Column_Lengths.L_QC_PREFERRED_NAME THEN
    P_RETURN_CODE := 'API_QC_111';  --Length of preferred_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_PREFERRED_DEFINITION) > Sbrext_Column_Lengths.L_QC_PREFERRED_DEFINITION THEN
    P_RETURN_CODE := 'API_QC_112';  --Length of Preferrede Definition exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_QTL_NAME) > Sbrext_Column_Lengths.L_QC_QTL_NAME     THEN
    P_RETURN_CODE := 'API_QC_113'; --Length of QTL_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_QC_IDENTIFIER) > Sbrext_Column_Lengths.L_QC_QC_IDENTIFIER     THEN
    P_RETURN_CODE := 'API_QC_114'; --Length of QC_IDENTIFIER exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_ASL_NAME ) > Sbrext_Column_Lengths.L_QC_ASL_NAME  THEN
    P_RETURN_CODE := 'API_QC_115'; --Length of asl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_CHANGE_NOTE) > Sbrext_Column_Lengths.L_QC_CHANGE_NOTE THEN
    P_RETURN_CODE := 'API_QC_116'; --Length of change_note exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_LONG_NAME) > Sbrext_Column_Lengths.L_QC_LONG_NAME THEN
    P_RETURN_CODE := 'API_QC_117'; --Length of Long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_MATCH_IND) > Sbrext_Column_Lengths.L_QC_QC_MATCH_IND THEN
    P_RETURN_CODE := 'API_QC_118'; --Length of Match IND exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_REVIEWER_FEEDBACK_ACT ) > Sbrext_Column_Lengths.L_QC_REVIEWER_FEEDBACK_ACT  THEN
    P_RETURN_CODE := 'API_QC_119'; --Length of feedback action exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_NEW_QC_IND) > Sbrext_Column_Lengths.L_QC_NEW_QC_IND THEN
    P_RETURN_CODE := 'API_QC_120'; --Length of New QC IND exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_REVIEWER_FEEDBACK_EXT) > Sbrext_Column_Lengths.L_QC_REVIEWER_FEEDBACK_EXT THEN
    P_RETURN_CODE := 'API_QC_122'; --Length of external feedback exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_SYSTEM_MSGS ) > Sbrext_Column_Lengths.L_QC_SYSTEM_MSGS  THEN
    P_RETURN_CODE := 'API_QC_123'; --Length of approved_by exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_REVIEWER_FEEDBACK_INT) > Sbrext_Column_Lengths.L_QC_REVIEWER_FEEDBACK_INT THEN
    P_RETURN_CODE := 'API_QC_124'; --Length of internal feedback exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_REVIEWED_BY ) > Sbrext_Column_Lengths.L_QC_REVIEWED_BY  THEN
    P_RETURN_CODE := 'API_QC_125'; --Length of reviewed_by exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_APPROVED_BY ) > Sbrext_Column_Lengths.L_QC_APPROVED_BY  THEN
    P_RETURN_CODE := 'API_QC_126'; --Length of approved_by exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_SUB_LONG_NAME ) > Sbrext_Column_Lengths.L_QC_SUB_LONG_NAME  THEN
    P_RETURN_CODE := 'API_QC_127'; --Length of submitted long name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_GROUP_COMMENTS ) > Sbrext_Column_Lengths.L_QC_GROUP_COMMENTS  THEN
    P_RETURN_CODE := 'API_QC_128'; --Length of approved_by exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_DE_LONG_NAME ) > Sbrext_Column_Lengths.L_DE_LONG_NAME  THEN
    P_RETURN_CODE := 'API_QC_150'; --Length of de_lonmg_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_DEC_LONG_NAME ) > Sbrext_Column_Lengths.L_DEC_LONG_NAME  THEN
    P_RETURN_CODE := 'API_QC_151'; --Length of dec_long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_VD_LONG_NAME ) > Sbrext_Column_Lengths.L_VD_LONG_NAME  THEN
    P_RETURN_CODE := 'API_QC_152'; --Length of vd_long_name exceeds maximum length
    RETURN;
  END IF;

  --check to see that charachter strings are valid
  IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_QC_PREFERRED_NAME) THEN
    P_RETURN_CODE := 'API_QC_130'; -- Preferred Name has invalid Ccharacters
    RETURN;
  END IF;
/*IF NOT Sbrext_Common_Routines.valid_char(P_QC_PREFERRED_DEFINITION) THEN
  P_RETURN_CODE := 'API_QC_133'; -- Preferred Definition has invalid characters
  RETURN;
END IF;*/
  IF NOT Sbrext_Common_Routines.valid_char(P_QC_LONG_NAME) THEN
    P_RETURN_CODE := 'API_QC_134'; -- Value Domain Long Name has invalid characters
    RETURN;
  END IF;
  IF P_QC_REVIEWER_FEEDBACK_INT IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_QC_REVIEWER_FEEDBACK_INT) THEN
      P_RETURN_CODE := 'API_QC_135'; -- reviewer internal feedback has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_QC_REVIEWER_FEEDBACK_ACT IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_QC_REVIEWER_FEEDBACK_ACT) THEN
      P_RETURN_CODE := 'API_QC_136'; -- Reviewer action has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_QC_REVIEWER_FEEDBACK_EXT IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_QC_REVIEWER_FEEDBACK_EXT) THEN
      P_RETURN_CODE := 'API_QC_137'; -- Reviewer external feedback has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_QC_SUB_LONG_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_QC_SUB_LONG_NAME) THEN
      P_RETURN_CODE := 'API_QC_138'; -- Submitted Long Name has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_QC_GROUP_COMMENTS IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_QC_GROUP_COMMENTS) THEN
      P_RETURN_CODE := 'API_QC_139'; -- Group Comments has invalid characters
      RETURN;
    END IF;
  END IF;

  --check to see that Foreign keys already exist in the database
  IF P_QC_CONTE_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.context_exists(P_QC_CONTE_IDSEQ) THEN
      P_RETURN_CODE := 'API_QC_200'; --Context not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_QC_PROTO_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.ac_exists(P_QC_PROTO_IDSEQ)  THEN
      P_RETURN_CODE := 'API_QC_201'; --Protocol not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_QC_ASL_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.workflow_exists(P_QC_ASL_NAME) THEN
      P_RETURN_CODE := 'API_QC_202'; --Workflow Status not found in the database
      RETURN;
    END IF;
  END IF;
  --dbms_output.put_line('P_QC_VP_IDSEQ= '||P_QC_VP_IDSEQ);
  IF (P_QC_VP_IDSEQ IS NOT NULL) THEN
    -- dbms_output.put_line('p_qc_vp_idseq is not null ='||nvl(P_QC_VP_IDSEQ,'null')||
    -- 'length='||length(P_QC_VP_IDSEQ));
    IF (P_QC_VP_IDSEQ <> ' ') THEN
      IF NOT Sbrext_Common_Routines.VD_PVS_EXISTS(P_QC_VP_IDSEQ) THEN
       -- dyu 1/23/2003
        dbms_output.put_line('in api_qc_203:P_QC_VP_IDSEQ= '||P_QC_VP_IDSEQ);
        P_RETURN_CODE := 'API_QC_203'; --VP not found in the database
        RETURN;
      END IF;
    END IF;
  END IF;
  IF P_QC_QTL_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.qtl_exists(P_QC_QTL_NAME) THEN
      P_RETURN_CODE := 'API_QC_204'; --Content Type NOT found in the database
      RETURN;
    END IF;
  END IF;
  IF (P_QC_DE_IDSEQ IS NOT NULL) THEN
    IF P_QC_DE_IDSEQ <> ' ' THEN
      IF NOT Sbrext_Common_Routines.ac_exists(P_QC_DE_IDSEQ) THEN
        P_RETURN_CODE := 'API_QC_205'; --DE not found in the database
        RETURN;
      END IF;
    END IF;
  END IF;
  IF P_QC_QCDL_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.qcdl_exists(P_QC_QCDL_NAME) THEN
      P_RETURN_CODE := 'API_QC_206'; --QCDL not found in the database
      RETURN;
    END IF;
  END IF;
/*IF P_QC_REVIEWER_FEEDBACK_INT IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.rf_exists(P_QC_REVIEWER_FEEDBACK_INT,'INTERNAL COMMENTS') THEN
    P_RETURN_CODE := 'API_QC_207'; --internal comment not found in the database
    RETURN;
  END IF;
END IF;
IF P_QC_REVIEWER_FEEDBACK_EXT IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.rf_exists(P_QC_REVIEWER_FEEDBACK_EXT,'EXTERNAL COMMENTS') THEN
    P_RETURN_CODE := 'API_QC_208'; --external comment not found in the database
    RETURN;
  END IF;
END IF;*/--This has been commented out because these should not be forign keys.
  IF (P_QC_REVIEWER_FEEDBACK_ACT IS NOT NULL) THEN
    IF P_QC_REVIEWER_FEEDBACK_ACT <> ' ' THEN
      IF NOT Sbrext_Common_Routines.rf_exists(P_QC_REVIEWER_FEEDBACK_ACT,'REVIEWER ACTION') THEN
        P_RETURN_CODE := 'API_QC_209'; --reviewer action not found in the database
        RETURN;
      END IF;
    END IF;
  END IF;

  --check to see that begin data and end date are valid dates
  IF(P_QC_BEGIN_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_QC_BEGIN_DATE,v_begin_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_QC_600'; --begin date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_QC_END_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_QC_END_DATE, v_end_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_QC_601'; --end date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_QC_REVIEWED_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_QC_REVIEWED_DATE,v_reviewed_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_QC_602'; --reviewed date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_QC_APPROVED_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE, P_QC_APPROVED_DATE, v_approved_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_QC_603'; --approved date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_QC_BEGIN_DATE IS NOT NULL AND P_QC_END_DATE IS NOT NULL) THEN
    IF(v_end_date < v_begin_date) THEN
      P_RETURN_CODE := 'API_QC_210'; --end date is before begin date
      RETURN;
    END IF;
  ELSIF(P_QC_END_DATE IS NOT NULL AND P_QC_BEGIN_DATE IS NULL) THEN
    P_RETURN_CODE := 'API_QC_211'; --begin date cannot be null when end date is null
    RETURN;
  END IF;

  IF (P_ACTION = 'INS' ) THEN
    --check to see that a QC with the same
    --Preferred Name, Context and Version does not already exist
    IF Sbrext_Common_Routines.ac_exists(P_QC_PREFERRED_NAME,P_QC_CONTE_IDSEQ ,P_QC_VERSION,'QUEST_CONTENT') THEN
     P_RETURN_CODE := 'API_QC_300';-- QC already Exists
     RETURN;
    END IF;
    --Check to see if prior versions alresdy exist
    IF Sbrext_Common_Routines.ac_version_exists(P_QC_PREFERRED_NAME,P_QC_CONTE_IDSEQ ,'QUEST_CONTENT') THEN -- we are creating a new version
      v_new_version := TRUE;
      v_ac          := Sbrext_Common_Routines.get_version_ac(P_QC_PREFERRED_NAME,P_QC_CONTE_IDSEQ,'QUEST_CONTENT');
    END IF;

    P_QC_QC_IDSEQ      := admincomponent_crud.cmr_guid;
    P_QC_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_QC_CREATED_BY    := ADMIN_SECURITY_UTIL.effective_user;
    P_QC_DATE_MODIFIED := NULL;
    P_QC_MODIFIED_BY   := NULL;
    P_QC_DELETED_IND   := 'No';

    v_qc_rec.qc_idseq           := P_QC_QC_IDSEQ;
    v_qc_rec.preferred_name     := P_QC_PREFERRED_NAME;
    v_qc_rec.conte_idseq     := P_QC_CONTE_IDSEQ;
    v_qc_rec.version      := P_QC_VERSION;
    v_qc_rec.preferred_definition  := P_QC_PREFERRED_DEFINITION;
    v_qc_rec.long_name     := P_QC_LONG_NAME;
    v_qc_rec.qtl_name     := P_QC_QTL_NAME;
    v_qc_rec.asl_name     := P_QC_ASL_NAME;
    v_qc_rec.proto_idseq    := NULL;
    v_qc_rec.de_idseq     := P_QC_DE_IDSEQ;
    v_qc_rec.vp_idseq     := P_QC_VP_IDSEQ;
    v_qc_rec.qc_match_idseq    := P_QC_QC_MATCH_IDSEQ;
    v_qc_rec.qcdl_name     := P_QC_QCDL_NAME;
    v_qc_rec.match_ind     := P_QC_MATCH_IND;
    v_qc_rec.qc_identifier    := P_QC_QC_IDENTIFIER;
    v_qc_rec.latest_version_ind   := P_QC_LATEST_VERSION_IND;
    v_qc_rec.new_qc_ind     := P_QC_NEW_QC_IND;
    v_qc_rec.highlight_ind    := P_QC_HIGHLIGHT_IND;
    v_qc_rec.reviewer_feedback_external := P_QC_REVIEWER_FEEDBACK_EXT;
    v_qc_rec.system_msgs    := P_QC_SYSTEM_MSGS;
    v_qc_rec.reviewer_feedback_action   := P_QC_REVIEWER_FEEDBACK_ACT;
    v_qc_rec.reviewer_feedback_internal := P_QC_REVIEWER_FEEDBACK_INT;
    v_qc_rec.submitted_long_cde_name := P_QC_SUB_LONG_NAME;
    v_qc_rec.group_comments             := P_QC_GROUP_COMMENTS;
    v_qc_rec.dn_vd_idseq             := P_QC_VD_IDSEQ;
    v_qc_rec.src_name          := P_QC_SRC_NAME   ;
    v_qc_rec.p_mod_idseq       := P_QC_P_MOD_IDSEQ ;
    v_qc_rec.p_qst_idseq       := P_QC_P_QST_IDSEQ ;
    v_qc_rec.p_val_idseq       := P_QC_P_VAL_IDSEQ ;
    v_qc_rec.dn_Crf_idseq      := P_QC_DN_CRF_IDSEQ;
    v_qc_rec.display_ind       := P_QC_DISPALY_IND  ;
    v_qc_rec.group_action      := P_QC_GROUP_ACTION  ;
    v_qc_rec.de_long_name      := P_QC_DE_LONG_NAME  ;
    v_qc_rec.vd_long_name      := P_QC_VD_LONG_NAME  ;
    v_qc_rec.dec_long_name     := P_QC_DEC_LONG_NAME ;
    v_qc_rec.reviewed_by    := P_QC_REVIEWED_BY;
    v_qc_rec.reviewed_date    := TO_DATE(P_QC_REVIEWED_DATE);
    v_qc_rec.approved_by    := P_QC_APPROVED_BY;
    v_qc_rec.approved_date    := P_QC_APPROVED_DATE;
    v_qc_rec.cde_dictionary_id   := P_QC_CDE_DICTIONARY_ID;
    v_qc_rec.begin_date     := TO_DATE(P_QC_BEGIN_DATE);
    v_qc_rec.end_date     := TO_DATE(P_QC_END_DATE);
    v_qc_rec.change_note    := P_QC_CHANGE_NOTE;
    v_qc_rec.created_by     := P_QC_CREATED_BY;
    v_qc_rec.date_created    := TO_DATE(P_QC_DATE_cREATED);
    v_qc_rec.modified_by    := NULL;
    v_qc_rec.date_modified    := NULL;
    v_qc_rec.deleted_ind    := 'No';
 v_qc_rec.origin                     := P_QC_ORIGIN;

    v_qc_ind.qc_idseq                   := TRUE;
    v_qc_ind.preferred_name             := TRUE;
    v_qc_ind.conte_idseq                := TRUE;
    v_qc_ind.version                    := TRUE;
    v_qc_ind.preferred_definition       := TRUE;
    v_qc_ind.long_name                  := TRUE;
    v_qc_ind.qtl_name                   := TRUE;
    v_qc_ind.asl_name                   := TRUE;
    v_qc_ind.proto_idseq                := TRUE;
    v_qc_ind.de_idseq                   := TRUE;
    v_qc_ind.vp_idseq                   := TRUE;
    v_qc_ind.qc_match_idseq             := TRUE;
    v_qc_ind.qcdl_name                  := TRUE;
    v_qc_ind.match_ind                  := TRUE;
    v_qc_ind.qc_identifier              := TRUE;
    v_qc_ind.latest_version_ind         := TRUE;
    v_qc_ind.new_qc_ind                 := TRUE;
    v_qc_ind.highlight_ind              := TRUE;
    v_qc_ind.reviewer_feedback_action   := TRUE;
    v_qc_ind.system_msgs                := TRUE;
    v_qc_ind.reviewer_feedback_external := TRUE;
    v_qc_ind.reviewer_feedback_internal := TRUE;
    v_qc_ind.submitted_long_cde_name := TRUE;
    v_qc_ind.group_comments             := TRUE;
    v_qc_ind.dn_vd_idseq                := TRUE;
    v_qc_ind.src_name          := TRUE   ;
    v_qc_ind.p_mod_idseq       := TRUE ;
    v_qc_ind.p_qst_idseq       := TRUE ;
    v_qc_ind.p_val_idseq       := TRUE ;
    v_qc_ind.dn_Crf_idseq      := TRUE;
    v_qc_ind.display_ind       := TRUE;
    v_qc_ind.group_action      := TRUE;
    v_qc_ind.de_long_name      := TRUE;
    v_qc_ind.vd_long_name      := TRUE ;
    v_qc_ind.dec_long_name     := TRUE;
    v_qc_ind.reviewed_by                := TRUE;
    v_qc_ind.reviewed_date              := TRUE;
    v_qc_ind.approved_by                := TRUE;
    v_qc_ind.approved_date              := TRUE;
    v_qc_ind.cde_dictionary_id          := TRUE;
    v_qc_ind.begin_date                 := TRUE;
    v_qc_ind.end_date                   := TRUE;
    v_qc_ind.change_note                := TRUE;
    v_qc_ind.created_by                 := TRUE;
    v_qc_ind.date_created               := TRUE;
    v_qc_ind.modified_by                := TRUE;
    v_qc_ind.date_modified              := TRUE;
    v_qc_ind.deleted_ind                := TRUE;
 v_qc_ind.origin                     := TRUE;

    BEGIN
      --meta_global_pkg.transaction_type := 'VERSION';
      Cg$quest_Contents_View_Ext.ins(v_qc_rec,v_qc_ind);
   sbrext_common_routines.SET_MULTI_PROTO(P_QC_PROTO_IDSEQ,P_QC_QC_IDSEQ);
      meta_global_pkg.transaction_type := NULL;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_QC_500'; --Error inserting QC
    END;
    --If LATEST_VERSION_IND is'Yes' then update so that all other versions have the indicator set to 'No'
    IF(P_QC_LATEST_VERSION_IND = 'Yes') THEN
      Sbrext_Common_Routines.set_ac_lvi(P_RETURN_CODE,P_QC_QC_IDSEQ ,'QUEST_CONTENT');
      IF P_RETURN_CODE IS NOT NULL  THEN
        P_RETURN_CODE := 'API_QC_503'; -- Error updating latest_Value_ind
        RETURN;
      END IF;
    END IF;
    --create a history record with prior version
    IF v_new_version THEN
      BEGIN
        meta_config_mgmt.CREATE_AC_HISTORIES (v_ac,P_QC_QC_IDSEQ,'VERSIONED','QUEST_CONTENT');
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_QC_504'; --Error creating history
      END;
    END IF;

  END IF;

  IF (P_ACTION = 'UPD' ) THEN
    --Get the version for the P_QC_QCIDSEQ

    SELECT version
    INTO   v_version
    FROM   quest_contents_view_ext
    WHERE  qc_idseq = P_QC_QC_IDSEQ;

    IF P_QC_VERSION IS NOT NULL THEN -- 23-Jul-2003, W. Ver Hoef - added condition
   IF v_version <> P_QC_VERSION THEN
        P_RETURN_CODE := 'API_QC_402'; -- Version can NOT be updated. It can only be created
        RETURN;
   END IF;
    END IF;

    P_QC_DATE_MODIFIED := TO_CHAR(SYSDATE);
    P_QC_MODIFIED_BY := ADMIN_SECURITY_UTIL.effective_user;
    P_QC_DELETED_IND := 'No';

    v_qc_rec.date_modified := P_QC_DATE_MODIFIED;
    v_qc_rec.modified_by   := P_QC_MODIFIED_BY;
    v_qc_rec.qc_idseq      := P_QC_QC_IDSEQ;
    v_qc_rec.deleted_ind   := 'No';

    v_qc_ind.date_modified := TRUE;
    v_qc_ind.modified_by   := TRUE;
    v_qc_ind.deleted_ind   := TRUE;
    v_qc_ind.qc_idseq      := TRUE;

    v_qc_ind.version       := FALSE;
    v_qc_ind.created_by    := FALSE;
    v_qc_ind.date_created  := FALSE;

    IF P_QC_PREFERRED_NAME IS NULL THEN
      v_qc_ind.preferred_name := FALSE;
    ELSE
      v_qc_rec.preferred_name := P_QC_PREFERRED_NAME;
      v_qc_ind.preferred_name := TRUE;
    END IF;

    IF P_QC_CONTE_IDSEQ IS NULL THEN
      v_qc_ind.conte_idseq := FALSE;
    ELSE
      v_qc_rec.conte_idseq := P_QC_CONTE_IDSEQ;
      v_qc_ind.conte_idseq := TRUE;
    END IF;

    IF P_QC_PREFERRED_DEFINITION IS NULL THEN
      v_qc_ind.preferred_definition:= FALSE;
    ELSE
      v_qc_rec.preferred_definition := P_QC_PREFERRED_DEFINITION;
      v_qc_ind.preferred_definition := TRUE;
    END IF;

    IF P_QC_LONG_NAME IS NULL THEN
      v_qc_ind.long_name := FALSE;
    ELSE
      v_qc_rec.long_name := P_QC_LONG_NAME;
      v_qc_ind.long_name := TRUE;
    END IF;

    IF P_QC_ASL_NAME IS NULL THEN
      v_qc_ind.asl_name := FALSE;
    ELSE
      v_qc_rec.asl_name := P_QC_ASL_NAME;
      v_qc_ind.asl_name := TRUE;
    END IF;

    IF P_QC_PROTO_IDSEQ IS NULL THEN
      v_qc_ind.proto_idseq := FALSE;
    ELSE
      v_qc_rec.proto_idseq := P_QC_PROTO_IDSEQ;
      v_qc_ind.proto_idseq := TRUE;
    END IF;

    IF P_QC_LATEST_VERSION_IND IS NULL THEN
      v_qc_ind.latest_version_ind := FALSE;
    ELSE
      v_qc_rec.latest_version_ind := P_QC_LATEST_VERSION_IND;
      v_qc_ind.latest_version_ind := TRUE;
    END IF;

    IF P_QC_MATCH_IND IS NULL THEN
      v_qc_ind.match_ind := FALSE;
    ELSE
      v_qc_rec.match_ind:= P_QC_MATCH_IND;
      IF v_qc_rec.match_ind = ' ' THEN
        v_qc_rec.match_ind := NULL;
      END IF;
      v_qc_ind.match_ind := TRUE;
    END IF;

    IF P_QC_QCDL_NAME IS NULL THEN
      v_qc_ind.qcdl_name := FALSE;
    ELSE
      v_qc_rec.qcdl_name := P_QC_QCDL_NAME;
      v_qc_ind.qcdl_name := TRUE;
    END IF;

    IF P_QC_QTL_NAME IS NULL THEN
      v_qc_ind.qtl_name := FALSE;
    ELSE
      v_qc_rec.qtl_name := P_QC_QTL_NAME;
      v_qc_ind.qtl_name := TRUE;
    END IF;

    IF P_QC_APPROVED_BY IS NULL THEN
      v_qc_ind.approved_by:= FALSE;
    ELSE
      v_qc_rec.approved_by := P_QC_APPROVED_BY;
      v_qc_ind.approved_by:= TRUE;
    END IF;

    IF P_QC_REVIEWED_BY IS NULL THEN
      v_qc_ind.reviewed_by:= FALSE;
    ELSE
      v_qc_rec.reviewed_by := P_QC_REVIEWED_BY ;
      v_qc_ind.reviewed_by:= TRUE;
    END IF;

    IF P_QC_VP_IDSEQ IS NULL THEN
      v_qc_ind.vp_idseq := FALSE;
    ELSE
      v_qc_rec.vp_idseq := P_QC_VP_IDSEQ;
      IF v_qc_rec.vp_idseq = ' ' THEN
       v_qc_rec.vp_idseq := NULL;
      END IF;
      v_qc_ind.vp_idseq := TRUE;
    END IF;

    IF P_QC_QC_MATCH_IDSEQ IS NULL THEN
      v_qc_ind.qc_match_idseq := FALSE;
    ELSE
      v_qc_rec.qc_match_idseq := P_QC_QC_MATCH_IDSEQ;
      IF v_qc_rec.qc_match_idseq = ' ' THEN
     v_qc_rec.qc_match_idseq := NULL;
      END IF;
      v_qc_ind.qc_match_idseq := TRUE;
    END IF;

    IF P_QC_QC_IDENTIFIER IS NULL THEN
      v_qc_ind.qc_identifier := FALSE;
    ELSE
      v_qc_rec.qc_identifier := P_QC_QC_IDENTIFIER;
      v_qc_ind.qc_identifier := TRUE;
    END IF;

    IF P_QC_REVIEWER_FEEDBACK_INT  IS NULL THEN
      v_qc_ind.reviewer_feedback_internal:= FALSE;
    ELSE
      v_qc_rec.reviewer_feedback_internal:= P_QC_REVIEWER_FEEDBACK_INT  ;
      v_qc_ind.reviewer_feedback_internal:= TRUE;
    END IF;

    IF P_QC_SUB_LONG_NAME IS NULL THEN
      v_qc_ind.submitted_long_cde_name := FALSE;
    ELSE
      v_qc_rec.submitted_long_cde_name := P_QC_SUB_LONG_NAME;
      v_qc_ind.submitted_long_cde_name := TRUE;
    END IF;

    IF P_QC_GROUP_COMMENTS  IS NULL THEN
      v_qc_ind.group_comments:= FALSE;
    ELSE
      v_qc_rec.group_comments:= P_QC_GROUP_COMMENTS  ;
      v_qc_ind.group_comments:= TRUE;
    END IF;

    IF P_QC_VD_IDSEQ IS NULL THEN
      v_qc_ind.dn_vd_idseq := FALSE;
    ELSE
      v_qc_rec.dn_vd_idseq := P_QC_VD_IDSEQ;
      IF v_qc_rec.dn_vd_idseq = ' ' THEN
        v_qc_rec.dn_vd_idseq := NULL;
      END IF;
      v_qc_ind.dn_vd_idseq := TRUE;
    END IF;

    IF P_QC_DE_IDSEQ IS NULL THEN
      v_qc_ind.de_idseq := FALSE;
    ELSE
      v_qc_rec.de_idseq := P_QC_DE_IDSEQ;
      IF v_qc_rec.de_idseq = ' ' THEN
        v_qc_rec.de_idseq := NULL;
      END IF;
      v_qc_ind.de_idseq := TRUE;
    END IF;

    IF P_QC_NEW_QC_IND IS NULL THEN
      v_qc_ind.new_qc_ind := FALSE;
    ELSE
      v_qc_rec.new_qc_ind := P_QC_NEW_QC_IND  ;
      IF v_qc_rec.new_qc_ind = ' ' THEN
        v_qc_rec.new_qc_ind := NULL;
      END IF;
      v_qc_ind.new_qc_ind := TRUE;
    END IF;

    IF P_QC_HIGHLIGHT_IND IS NULL THEN
      v_qc_ind.highlight_ind := FALSE;
    ELSE
      v_qc_rec.highlight_ind := P_QC_HIGHLIGHT_IND  ;
      v_qc_ind.highlight_ind := TRUE;
      dbms_output.put_line('highlight_ind= '||v_qc_rec.highlight_ind);
    END IF;

    IF P_QC_SYSTEM_MSGS IS NULL THEN
      v_qc_ind.system_msgs := FALSE;
    ELSE
      v_qc_rec.system_msgs := P_QC_SYSTEM_MSGS;
      v_qc_ind.system_msgs := TRUE;
    END IF;

    IF P_QC_REVIEWER_FEEDBACK_ACT  IS NULL THEN
      v_qc_ind.reviewer_feedback_action:= FALSE;
    ELSE
      v_qc_rec.reviewer_feedback_action:=  P_QC_REVIEWER_FEEDBACK_ACT  ;
      IF v_qc_rec.reviewer_feedback_action = ' ' THEN
        v_qc_rec.reviewer_feedback_action := NULL;
      END IF;
      v_qc_ind.reviewer_feedback_action:= TRUE;
    END IF;

    IF P_QC_CDE_DICTIONARY_ID IS NULL THEN
      v_qc_ind.cde_dictionary_id:= FALSE;
    ELSE
      v_qc_rec.cde_dictionary_id:= P_QC_DE_IDSEQ;
      v_qc_ind.cde_dictionary_id:= TRUE;
    END IF;

    IF P_QC_REVIEWER_FEEDBACK_EXT IS NULL THEN
      v_qc_ind.reviewer_feedback_external := FALSE;
    ELSE
      v_qc_rec.reviewer_feedback_external := P_QC_REVIEWER_FEEDBACK_EXT;
      v_qc_ind.reviewer_feedback_external := TRUE;
    END IF;

    IF P_QC_SRC_NAME  IS NULL THEN
      v_qc_ind.src_name      := FALSE;
    ELSE
      v_qc_rec.src_name := P_QC_SRC_NAME  ;
      v_qc_ind.src_name := TRUE;
    END IF;

    IF P_QC_P_MOD_IDSEQ IS NULL THEN
      v_qc_ind.p_mod_idseq   := FALSE;
    ELSE
      v_qc_rec.p_mod_idseq   := P_QC_P_MOD_IDSEQ ;
      v_qc_ind.p_mod_idseq    := TRUE;
    END IF;

    IF  P_QC_P_QST_IDSEQ IS NULL THEN
      v_qc_ind.p_qst_idseq:= FALSE;
    ELSE
      v_qc_rec.p_qst_idseq   := P_QC_P_QST_IDSEQ ;
      v_qc_ind.p_qst_idseq := TRUE;
    END IF;

    IF P_QC_P_VAL_IDSEQ IS NULL THEN
      v_qc_ind.p_val_idseq   := FALSE;
    ELSE
       v_qc_rec.p_val_idseq   := P_QC_P_VAL_IDSEQ ;      v_qc_ind.p_val_idseq    := TRUE;
    END IF;

    IF P_QC_DN_CRF_IDSEQ IS NULL THEN
      v_qc_ind.dn_Crf_idseq  := FALSE;
    ELSE
      v_qc_rec.dn_Crf_idseq  := P_QC_DN_CRF_IDSEQ;
      v_qc_ind.dn_Crf_idseq   := TRUE;
    END IF;

    IF P_QC_DISPALY_IND  IS NULL THEN
      v_qc_ind.display_ind   := FALSE;
    ELSE
      v_qc_rec.display_ind   := P_QC_DISPALY_IND  ;
      v_qc_ind.display_ind    := TRUE;
    END IF;

    IF P_QC_GROUP_ACTION  IS NULL THEN
      v_qc_ind.group_action  := FALSE;
    ELSE
      v_qc_rec.group_action  := P_QC_GROUP_ACTION  ;
      v_qc_ind.group_action   := TRUE;
    END IF;

    IF P_QC_DE_LONG_NAME IS NULL THEN
      v_qc_ind.de_long_name  := FALSE;
    ELSE
      v_qc_rec.de_long_name  := P_QC_DE_LONG_NAME  ;
      v_qc_ind.de_long_name   := TRUE;
    END IF;

    IF P_QC_VD_LONG_NAME IS NULL THEN
      v_qc_ind.vd_long_name  := FALSE;
    ELSE
      v_qc_rec.vd_long_name  := P_QC_VD_LONG_NAME  ;
      v_qc_ind.vd_long_name   := TRUE;
    END IF;

    IF P_QC_DEC_LONG_NAME  IS NULL THEN
      v_qc_ind.dec_long_name  := FALSE;
    ELSE
      v_qc_rec.dec_long_name  := P_QC_DEC_LONG_NAME  ;
      v_qc_ind.dec_long_name   := TRUE;
    END IF;

    IF P_QC_BEGIN_DATE IS NULL THEN
      v_qc_ind.begin_date := FALSE;
    ELSE
      v_qc_rec.begin_date := TO_DATE(P_QC_BEGIN_DATE);
      v_qc_ind.begin_date := TRUE;
    END IF;

    IF P_QC_END_DATE  IS NULL THEN
      v_qc_ind.end_date := FALSE;
    ELSE
      v_qc_rec.end_date := TO_DATE(P_QC_END_DATE);
      v_qc_ind.end_date := TRUE;
    END IF;

    IF P_QC_REVIEWED_DATE IS NULL THEN
      v_qc_ind.reviewed_date := FALSE;
    ELSE
      v_qc_rec.reviewed_date := TO_DATE(P_QC_REVIEWED_DATE);
      v_qc_ind.reviewed_date := TRUE;
    END IF;

    IF P_QC_APPROVED_DATE  IS NULL THEN
      v_qc_ind.approved_date := FALSE;
    ELSE
      v_qc_rec.approved_date := TO_DATE(P_QC_APPROVED_DATE);
      v_qc_ind.approved_date := TRUE;
    END IF;

    IF P_QC_CHANGE_NOTE   IS NULL THEN
      v_qc_ind.change_note := FALSE;
    ELSE
      v_qc_rec.change_note := P_QC_CHANGE_NOTE  ;
      v_qc_ind.change_note := TRUE;
    END IF;

    IF P_QC_ORIGIN   IS NULL THEN
      v_qc_ind.origin := FALSE;
    ELSE
      v_qc_rec.origin := P_QC_ORIGIN  ;
      v_qc_ind.origin := TRUE;
    END IF;

    BEGIN
      Cg$quest_Contents_View_Ext.upd(v_qc_rec,v_qc_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_QC_501'; --Error updating QC
    END;

    --If LATEST_VERSION_IND is'Yes' then update so that all other versions have the indicator set to 'No'
    IF(P_QC_LATEST_VERSION_IND = 'Yes') THEN
      Sbrext_Common_Routines.set_ac_lvi(P_RETURN_CODE,P_QC_QC_IDSEQ,'QUEST_CONTENT');
      IF P_RETURN_CODE IS NOT NULL  THEN
        P_RETURN_CODE := 'API_QC_503'; -- Error updating latest_Value_ind
        RETURN;
      END IF;
    END IF;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    P_RETURN_CODE := 'API_QC_800';
  WHEN OTHERS THEN
    P_RETURN_CODE := 'OTHERS';
    dbms_output.put_line(SQLERRM);
END SET_QC;



PROCEDURE SET_REL(
P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_REL_TABLE             IN VARCHAR2
,P_REL_REL_IDSEQ   IN OUT VARCHAR2
,P_REL_P_IDSEQ             IN OUT VARCHAR2
,P_REL_C_IDSEQ             IN OUT VARCHAR2
,P_REL_RL_NAME       IN OUT VARCHAR2
,P_REL_DISPLAY_ORDER     IN  OUT NUMBER
,P_REL_CREATED_BY         OUT VARCHAR2
,P_REL_DATE_CREATED         OUT VARCHAR2
,P_REL_MODIFIED_BY         OUT VARCHAR2
,P_REL_DATE_MODIFIED     OUT VARCHAR2) IS

v_rel_de_rec      cg$de_recs_view.cg$row_type;
v_rel_dec_rec      cg$dec_recs_view.cg$row_type;
v_rel_vd_rec     cg$vd_recs_view.cg$row_type;
v_rel_cs_rec     cg$cs_recs_view.cg$row_type;
v_rel_csi_rec    cg$csi_recs_view.cg$row_type;
v_rel_qce_rec    Cg$qc_Recs_View_Ext.cg$row_type;
v_rel_de_ind     cg$de_recs_view.cg$ind_type;
v_rel_dec_ind    cg$dec_recs_view.cg$ind_type;
v_rel_vd_ind     cg$vd_recs_view.cg$ind_type;
v_rel_cs_ind     cg$cs_recs_view.cg$ind_type;
v_rel_csi_ind    cg$csi_recs_view.cg$ind_type;
v_rel_qce_ind    Cg$qc_Recs_View_Ext.cg$ind_type;
v_rel_de_pk      cg$de_recs_view.cg$pk_type;
v_rel_dec_pk    cg$dec_recs_view.cg$pk_type;
v_rel_vd_pk     cg$vd_recs_view.cg$pk_type;
v_rel_cs_pk     cg$cs_recs_view.cg$pk_type;
v_rel_csi_pk    cg$csi_recs_view.cg$pk_type;
v_rel_qce_pk    Cg$qc_Recs_View_Ext.cg$pk_type;
BEGIN
 p_return_code := NULL;
 --Table name must be given
 IF P_REL_TABLE IS NULL THEN
    p_return_code := 'API_REL_007'; --table name must be passed
    RETURN;
  END IF;

--dbms_output.put_line('P_REL_TABLE_007= ' ||P_REL_TABLE);


 --Table name must be valid
 IF P_REL_TABLE NOT IN ('DE_RECS', 'DEC_RECS', 'VD_RECS', 'CS_RECS', 'CSI_RECS', 'QC_RECS_EXT') THEN
    p_return_code := 'API_REL_001'; --table name must be valid
    RETURN;
 END IF;

--dbms_output.put_line('P_REL_TABLE_001= ' ||P_REL_TABLE);

-- action code must be valid
IF P_ACTION NOT IN ('INS','DEL','UPD') OR (P_ACTION = 'UPD' AND P_REL_TABLE<>'QC_RECS_EXT')  THEN
 P_RETURN_CODE := 'API_REL_700'; -- Invalid action
 RETURN;
END IF;

--dbms_output.put_line('P_ACTION_700= ' ||P_ACTION);


--IF Action = 'INS' then make sure that the mandatory columns are all there
IF (P_ACTION = 'INS') THEN
   IF P_REL_REL_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_REL_100';  --for inserts the ID is generated
  RETURN;

--dbms_output.put_line('P_REL_REL_IDSEQ_100= ' ||P_REL_REL_IDSEQ);

   ELSE


       IF (P_REL_P_IDSEQ IS NULL) THEN
         p_return_code  := 'API_REL_101'; --parent is mandatory
         RETURN;
      END IF;

--dbms_output.put_line('P_REL_P_IDSEQ_101= ' ||P_REL_P_IDSEQ);

      IF (P_REL_C_IDSEQ IS NULL) THEN
         p_return_code  := 'API_REL_102'; --child is mandatory
         RETURN;
   END IF;

--dbms_output.put_line('P_REL_C_IDSEQ_102= ' ||P_REL_C_IDSEQ);

      IF (P_REL_RL_NAME IS NULL) THEN
         p_return_code  := 'API_REL_103'; --relationship name is mandatory
         RETURN;
      END IF;

--dbms_output.put_line('P_REL_RL_NAME_103= ' ||P_REL_RL_NAME);


      IF(P_REL_TABLE = 'QC_RECS_EXT' AND P_REL_DISPLAY_ORDER IS NULL) THEN
         p_return_code  := 'API_REL_QCE_104'; --dispaly order is mandatory
         RETURN;
      END IF;

--dbms_output.put_line('P_REL_TABLE_104= ' ||P_REL_TABLE);

  END IF;
END IF;

IF P_ACTION = 'DEL' THEN              --we are deleting a record
  IF P_REL_REL_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_REL_400' ;  --for deleted the ID is mandatory
  RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.rel_exists(P_REL_TABLE,P_REL_REL_IDSEQ) THEN
      P_RETURN_CODE :=  'API_REL_005'; --Relationship not found
      RETURN;
  END IF;
--Delete the record based on the table
  IF P_REL_TABLE = 'DE_RECS' THEN

    v_rel_de_pk.de_rec_idseq := P_REL_REL_IDSEQ;

    SELECT ROWID INTO v_rel_de_pk.the_rowid
    FROM de_recs_view
    WHERE de_rec_idseq = P_REL_REL_IDSEQ;
    v_rel_de_pk.jn_notes := NULL;

    BEGIN
      cg$de_recs_view.del(v_rel_de_pk);
      RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_REL_DE_501'; --Error deleteing  DE Relationship
      RETURN;
    END;
  ELSIF P_REL_TABLE = 'DEC_RECS' THEN
    v_rel_dec_pk.dec_rec_idseq := P_REL_REL_IDSEQ;

    SELECT ROWID INTO v_rel_dec_pk.the_rowid
    FROM dec_recs_view
    WHERE dec_rec_idseq = P_REL_REL_IDSEQ;
    v_rel_dec_pk.jn_notes := NULL;

    BEGIN
      cg$dec_recs_view.del(v_rel_dec_pk);
      RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_REL_DEC_501'; --Error deleteing DEC Relationship
      RETURN;
    END;

  ELSIF P_REL_TABLE = 'VD_RECS' THEN
    v_rel_vd_pk.vd_rec_idseq := P_REL_REL_IDSEQ;

    SELECT ROWID INTO v_rel_vd_pk.the_rowid
    FROM vd_recs_view
    WHERE vd_rec_idseq = P_REL_REL_IDSEQ;
    v_rel_vd_pk.jn_notes := NULL;

    BEGIN
      cg$vd_recs_view.del(v_rel_vd_pk);
      RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_REL_VD_501'; --Error deleteing VD Relationship
      RETURN;
    END;

  ELSIF P_REL_TABLE = 'CS_RECS' THEN
    v_rel_cs_pk.cs_rec_idseq := P_REL_REL_IDSEQ;

    SELECT ROWID INTO v_rel_cs_pk.the_rowid
    FROM cs_recs_view
    WHERE cs_rec_idseq = P_REL_REL_IDSEQ;
    v_rel_cs_pk.jn_notes := NULL;

    BEGIN
      cg$cs_recs_view.del(v_rel_cs_pk);
      RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_REL_CS_501'; --Error deleteing CS Relationship
      RETURN;
    END;

  ELSIF P_REL_TABLE = 'CSI_RECS' THEN
     v_rel_csi_pk.csi_rec_idseq := P_REL_REL_IDSEQ;

    SELECT ROWID INTO v_rel_csi_pk.the_rowid
    FROM csi_recs_view
    WHERE csi_rec_idseq = P_REL_REL_IDSEQ;
    v_rel_csi_pk.jn_notes := NULL;

    BEGIN
      cg$csi_recs_view.del(v_rel_csi_pk);
      RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_REL_CSI_501'; --Error deleteing CSI Relationship
      RETURN;
    END;

  ELSIF P_REL_TABLE = 'QC_RECS_EXT' THEN
     v_rel_qce_pk.qr_idseq := P_REL_REL_IDSEQ;

    SELECT ROWID INTO v_rel_qce_pk.the_rowid
    FROM qc_recs_view_ext
    WHERE qr_idseq = P_REL_REL_IDSEQ;
    v_rel_qce_pk.jn_notes := NULL;

    BEGIN
      Cg$qc_Recs_View_Ext.del(v_rel_qce_pk);
      RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_REL_QCE_501'; --Error deleteing QCE Relationship
      RETURN;
    END;

  END IF;
END IF;

IF P_ACTION = 'UPD' AND P_REL_TABLE = 'QC_RECS_EXT' THEN              --we are updating a record
  IF P_REL_REL_IDSEQ IS  NULL THEN
    P_RETURN_CODE := 'API_REL_400' ;  --for deletingthe ID is mandatory
 RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.rel_exists(P_REL_TABLE,P_REL_REL_IDSEQ) THEN --if relationship does not exist then
    P_RETURN_CODE :=  'API_REL_005'; --REL  NOT found
    RETURN;
  END IF;
  IF P_REL_P_IDSEQ IS NOT NULL OR P_REL_C_IDSEQ IS NOT NULL THEN
    P_RETURN_CODE := 'API_REL_QCE_100';--The parent and the child can not be updated
    RETURN;
  END IF;
  IF P_REL_DISPLAY_ORDER IS NULL THEN
    P_RETURN_CODE := 'API_REL_QCE_101';--Only display order can be updated and so it must be passed
    RETURN;
  END IF;
  P_REL_DATE_MODIFIED := TO_CHAR(SYSDATE);
  P_REL_MODIFIED_BY := ADMIN_SECURITY_UTIL.effective_user;

  v_rel_qce_rec.date_modified := P_REL_DATE_MODIFIED;
  v_rel_qce_rec.modified_by   := P_REL_MODIFIED_BY;
  v_rel_qce_rec.qr_idseq      := P_REL_REL_IDSEQ;
  v_rel_qce_rec.display_order := P_REL_DISPLAY_ORDER;

  v_rel_qce_ind.date_modified := TRUE;
  v_rel_qce_ind.modified_by   := TRUE;
  v_rel_qce_ind.qr_idseq      := TRUE;
  v_rel_qce_ind.created_by   := FALSE;
  v_rel_qce_ind.date_created  := FALSE;
  v_rel_qce_ind.p_qc_idseq   := FALSE;
  v_rel_qce_ind.c_qc_idseq    := FALSE;
  v_rel_qce_ind.display_order := TRUE;
  BEGIN
    Cg$qc_Recs_View_Ext.upd(v_rel_qce_rec,v_rel_qce_ind);
 RETURN;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_REL_501'; --Error updating QCE Relationships
  END;
END IF;

--make sure that the length of the varchar field are right
IF LENGTH(P_REL_RL_NAME) > Sbrext_Column_Lengths.L_REL_RL_NAME  THEN
  P_RETURN_CODE := 'API_REL_110'; --Length of relationship name exceeds maximum length
  RETURN;
END IF;

 --Make sure that all the foreign keys exist
IF P_REL_TABLE  IN ('DE_RECS', 'DEC_RECS', 'VD_RECS', 'CS_RECS','QC_RECS_EXT') THEN
  IF NOT Sbrext_Common_Routines.valid_ac(P_REL_TABLE,P_REL_P_IDSEQ) THEN
    P_RETURN_CODE := 'API_REL_200'; -- parent does not exist;
    RETURN; --parent is invalie
  END IF;
  IF NOT Sbrext_Common_Routines.valid_ac(P_REL_TABLE,P_REL_C_IDSEQ) THEN
    P_RETURN_CODE := 'API_REL_201'; -- child does not exist;
    RETURN;
  END IF;
ELSIF P_REL_TABLE  = 'CSI_RECS' THEN
 IF NOT Sbrext_Common_Routines.csi_exists(P_REL_P_IDSEQ) THEN
   P_RETURN_CODE := 'API_REL_200'; -- parent does not exist;
   RETURN;
 END IF;
 IF NOT Sbrext_Common_Routines.csi_exists(P_REL_C_IDSEQ) THEN
   P_RETURN_CODE := 'API_REL_201'; -- child does not exist;
   RETURN;
 END IF;
END IF;

IF NOT Sbrext_Common_Routines.rl_exists(P_REL_RL_NAME) THEN
  P_RETURN_CODE := 'API_REL_202'; --relationship type does not exist
  RETURN;
END IF;


--insert or update records
IF P_ACTION = 'INS'  THEN
  --make sure that a relationship between the parent and child does not already exist\
  IF P_REL_TABLE IN ('DE_RECS','DEC_RECS','VD_RECS') THEN
    IF Sbrext_Common_Routines.rel_exists(P_REL_TABLE,P_REL_P_IDSEQ, P_REL_C_IDSEQ) THEN
     P_RETURN_CODE := 'API_REL_300';-- Relationship already Exists
     RETURN;
    END IF;
  END IF;
   P_REL_REL_IDSEQ := admincomponent_crud.cmr_guid;
   P_REL_DATE_CREATED := TO_CHAR(SYSDATE);
   P_REL_CREATED_BY := ADMIN_SECURITY_UTIL.effective_user;
   P_REL_DATE_MODIFIED := NULL;
   P_REL_MODIFIED_BY := NULL;

   IF P_REL_TABLE = 'DE_RECS' THEN
     v_rel_de_rec.de_rec_idseq     := P_REL_REL_IDSEQ;
     v_rel_de_rec.p_de_idseq     := P_REL_P_IDSEQ;
     v_rel_de_rec.c_de_idseq     := P_REL_C_IDSEQ;
     v_rel_de_rec.rl_name         := P_REL_RL_NAME;
     v_rel_de_rec.created_by     := P_REL_CREATED_BY;
     v_rel_de_rec.date_created     := TO_DATE(P_REL_DATE_CREATED);
     v_rel_de_rec.modified_by     := P_REL_MODIFIED_BY;
     v_rel_de_rec.date_modified     := TO_DATE(P_REL_DATE_MODIFIED);

     v_rel_de_ind.de_rec_idseq     := TRUE;
     v_rel_de_ind.p_de_idseq     := TRUE;
     v_rel_de_ind.c_de_idseq     := TRUE;
     v_rel_de_ind.rl_name         := TRUE;
     v_rel_de_ind.created_by     := TRUE;
     v_rel_de_ind.date_created     := TRUE;
     v_rel_de_ind.modified_by     := TRUE;
     v_rel_de_ind.date_modified     := TRUE;

     BEGIN
       cg$de_recs_view.ins(v_rel_de_rec,v_rel_de_ind);
     EXCEPTION WHEN OTHERS THEN
         P_RETURN_CODE := 'API_REL_DE_500'; --Error inserting Relationship
     END;

   ELSIF P_REL_TABLE = 'DEC_RECS' THEN
     v_rel_dec_rec.dec_rec_idseq := P_REL_REL_IDSEQ;
     v_rel_dec_rec.p_dec_idseq     := P_REL_P_IDSEQ;
     v_rel_dec_rec.c_dec_idseq     := P_REL_C_IDSEQ;
     v_rel_dec_rec.rl_name         := P_REL_RL_NAME;
     v_rel_dec_rec.created_by     := P_REL_CREATED_BY;
     v_rel_dec_rec.date_created     := TO_DATE(P_REL_DATE_CREATED);
     v_rel_dec_rec.modified_by     := P_REL_MODIFIED_BY;
     v_rel_dec_rec.date_modified := TO_DATE(P_REL_DATE_MODIFIED);

     v_rel_dec_ind.dec_rec_idseq := TRUE;
     v_rel_dec_ind.p_dec_idseq     := TRUE;
     v_rel_dec_ind.c_dec_idseq     := TRUE;
     v_rel_dec_ind.rl_name         := TRUE;
     v_rel_dec_ind.created_by     := TRUE;
     v_rel_dec_ind.date_created     := TRUE;
     v_rel_dec_ind.modified_by     := TRUE;
     v_rel_dec_ind.date_modified := TRUE;

     BEGIN
       cg$dec_recs_view.ins(v_rel_dec_rec,v_rel_dec_ind);
     EXCEPTION WHEN OTHERS THEN
       P_RETURN_CODE := 'API_REL_DEC_500'; --Error inserting Relationship
     END;
    ELSIF P_REL_TABLE = 'VD_RECS' THEN
      v_rel_vd_rec.vd_rec_idseq     := P_REL_REL_IDSEQ;
      v_rel_vd_rec.p_vd_idseq     := P_REL_P_IDSEQ;
      v_rel_vd_rec.c_vd_idseq     := P_REL_C_IDSEQ;
      v_rel_vd_rec.rl_name         := P_REL_RL_NAME;
      v_rel_vd_rec.created_by     := P_REL_CREATED_BY;
      v_rel_vd_rec.date_created     := TO_DATE(P_REL_DATE_CREATED);
      v_rel_vd_rec.modified_by     := P_REL_MODIFIED_BY;
      v_rel_vd_rec.date_modified := TO_DATE(P_REL_DATE_MODIFIED);

      v_rel_vd_ind.vd_rec_idseq     := TRUE;
      v_rel_vd_ind.p_vd_idseq     := TRUE;
      v_rel_vd_ind.c_vd_idseq     := TRUE;
      v_rel_vd_ind.rl_name         := TRUE;
      v_rel_vd_ind.created_by     := TRUE;
      v_rel_vd_ind.date_created     := TRUE;
      v_rel_vd_ind.modified_by     := TRUE;
      v_rel_vd_ind.date_modified := TRUE;

      BEGIN
        cg$vd_recs_view.ins(v_rel_vd_rec,v_rel_vd_ind);
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_REL_VD_500'; --Error inserting Relationship
     END;
   ELSIF P_REL_TABLE = 'CS_RECS' THEN
    v_rel_cs_rec.cs_rec_idseq     := P_REL_REL_IDSEQ;
     v_rel_cs_rec.p_cs_idseq     := P_REL_P_IDSEQ;
     v_rel_cs_rec.c_cs_idseq     := P_REL_C_IDSEQ;
     v_rel_cs_rec.rl_name         := P_REL_RL_NAME;
     v_rel_cs_rec.created_by     := P_REL_CREATED_BY;
     v_rel_cs_rec.date_created     := TO_DATE(P_REL_DATE_CREATED);
     v_rel_cs_rec.modified_by     := P_REL_MODIFIED_BY;
     v_rel_cs_rec.date_modified     := TO_DATE(P_REL_DATE_MODIFIED);

     v_rel_cs_ind.cs_rec_idseq     := TRUE;
     v_rel_cs_ind.p_cs_idseq     := TRUE;
     v_rel_cs_ind.c_cs_idseq     := TRUE;
     v_rel_cs_ind.rl_name         := TRUE;
     v_rel_cs_ind.created_by     := TRUE;
     v_rel_cs_ind.date_created     := TRUE;
     v_rel_cs_ind.modified_by     := TRUE;
     v_rel_cs_ind.date_modified     := TRUE;

     BEGIN
       cg$cs_recs_view.ins(v_rel_cs_rec,v_rel_cs_ind);
     EXCEPTION WHEN OTHERS THEN
       P_RETURN_CODE := 'API_REL_CS_500'; --Error inserting Relationship
     END;
   ELSIF P_REL_TABLE = 'CSI_RECS' THEN
     v_rel_csi_rec.csi_rec_idseq := P_REL_REL_IDSEQ;
     v_rel_csi_rec.p_csi_idseq     := P_REL_P_IDSEQ;
     v_rel_csi_rec.c_csi_idseq     := P_REL_C_IDSEQ;
     v_rel_csi_rec.rl_name         := P_REL_RL_NAME;
     v_rel_csi_rec.created_by     := P_REL_CREATED_BY;
     v_rel_csi_rec.date_created     := TO_DATE(P_REL_DATE_CREATED);
     v_rel_csi_rec.modified_by     := P_REL_MODIFIED_BY;
     v_rel_csi_rec.date_modified := TO_DATE(P_REL_DATE_MODIFIED);

     v_rel_csi_ind.csi_rec_idseq := TRUE;
     v_rel_csi_ind.p_csi_idseq     := TRUE;
     v_rel_csi_ind.c_csi_idseq     := TRUE;
     v_rel_csi_ind.rl_name         := TRUE;
     v_rel_csi_ind.created_by     := TRUE;
     v_rel_csi_ind.date_created     := TRUE;
     v_rel_csi_ind.modified_by     := TRUE;
     v_rel_csi_ind.date_modified := TRUE;

     BEGIN
       cg$csi_recs_view.ins(v_rel_csi_rec,v_rel_csi_ind);
     EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_REL_CSI_500'; --Error inserting Relationship
     END;

   ELSIF P_REL_TABLE = 'QC_RECS_EXT' THEN
     v_rel_qce_rec.qr_idseq         := P_REL_REL_IDSEQ;
     v_rel_qce_rec.p_qc_idseq     := P_REL_P_IDSEQ;
     v_rel_qce_rec.c_qc_idseq     := P_REL_C_IDSEQ;
     v_rel_qce_rec.rl_name         := P_REL_RL_NAME;
     v_rel_qce_rec.created_by     := P_REL_CREATED_BY;
     v_rel_qce_rec.date_created     := TO_DATE(P_REL_DATE_CREATED);
     v_rel_qce_rec.modified_by     := P_REL_MODIFIED_BY;
     v_rel_qce_rec.date_modified := TO_DATE(P_REL_DATE_MODIFIED);
  v_rel_qce_rec.display_order    := P_REL_DISPLAY_ORDER;

     v_rel_qce_ind.qr_idseq         := TRUE;
     v_rel_qce_ind.p_qc_idseq     := TRUE;
     v_rel_qce_ind.c_qc_idseq     := TRUE;
     v_rel_qce_ind.rl_name         := TRUE;
     v_rel_qce_ind.created_by     := TRUE;
     v_rel_qce_ind.date_created     := TRUE;
     v_rel_qce_ind.modified_by     := TRUE;
     v_rel_qce_ind.date_modified := TRUE;

     BEGIN
       Cg$qc_Recs_View_Ext.ins(v_rel_qce_rec,v_rel_qce_ind);
     EXCEPTION WHEN OTHERS THEN
    dbms_output.put_line('Error inserting relationship ' ||SUBSTR(SQLERRM,1,200));
       P_RETURN_CODE := 'API_REL_QCE_500'; --Error inserting Relationship
     END;

  END IF;
END IF;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
       NULL;
   WHEN OTHERS THEN
       NULL;
END SET_REL;



PROCEDURE SET_PROTO(P_RETURN_CODE      OUT    VARCHAR2,
       P_ACTION    IN    VARCHAR2,
       P_PROTO_IDSEQ           IN OUT VARCHAR2,
         P_VERSION               IN OUT NUMBER,
       P_CONTE_IDSEQ           IN OUT VARCHAR2,
       P_PREFERRED_NAME        IN OUT VARCHAR2,
       P_PREFERRED_DEFINITION  IN OUT VARCHAR2,
       P_ASL_NAME              IN OUT VARCHAR2,
       P_LONG_NAME             IN OUT VARCHAR2,
       P_LATEST_VERSION_IND    IN OUT VARCHAR2,
       P_DELETED_IND           IN OUT VARCHAR2,
       P_BEGIN_DATE            IN OUT DATE,
       P_END_DATE              IN OUT DATE,
       P_PROTOCOL_ID           IN OUT VARCHAR2,
       P_TYPE                  IN OUT VARCHAR2,
       P_PHASE                 IN OUT VARCHAR2,
       P_LEAD_ORG              IN OUT VARCHAR2,
       P_CHANGE_TYPE           IN OUT VARCHAR2,
       P_CHANGE_NUMBER         IN OUT NUMBER,
       P_REVIEWED_DATE         IN OUT DATE,
       P_REVIEWED_BY           IN OUT VARCHAR2,
       P_APPROVED_DATE         IN OUT DATE,
       P_APPROVED_BY           IN OUT VARCHAR2,
       P_DATE_CREATED          IN OUT DATE,
       P_CREATED_BY            IN OUT VARCHAR2,
       P_DATE_MODIFIED         IN OUT DATE,
       P_MODIFIED_BY           IN OUT VARCHAR2,
       P_CHANGE_NOTE           IN OUT VARCHAR2,
     P_ORIGIN                IN     VARCHAR2 DEFAULT NULL -- 23-Jul-2003, W. Ver Hoef
     )
IS
-- Date:  23-Jul-2003
-- Modified By:  W. Ver Hoef
-- Reason:  added parameter and code for origin
  v_proto_rec      Cg$protocols_View_Ext.cg$row_type;
  v_proto_ind  Cg$protocols_View_Ext.cg$ind_type;
  v_Asl_name        protocols_view_ext.asl_name%TYPE;
BEGIN
dbms_output.put_line('beginning...');
  IF P_ACTION = 'INS' THEN
dbms_output.put_line('inside if stmt...');
     p_proto_idseq:= admincomponent_crud.cmr_guid;
  IF p_date_created IS NULL THEN
      p_date_created:= TO_CHAR(SYSDATE);
  END IF;
  IF p_created_by IS NULL THEN
      p_created_by:= ADMIN_SECURITY_UTIL.effective_user;
  END IF;
     p_date_modified  := NULL;
     p_modified_by    := NULL;
dbms_output.put_line('starting rec and ind assignments...');
  v_proto_rec.proto_idseq    := p_proto_idseq;
   v_proto_rec.version    := p_version;
   v_proto_rec.conte_idseq   := p_conte_idseq;
   v_proto_rec.preferred_name   := p_preferred_name;
   v_proto_rec.preferred_definition := p_preferred_definition;
   v_proto_rec.asl_name              := p_asl_name;
   v_proto_rec.long_name             := p_long_name;
   v_proto_rec.latest_version_ind    := p_latest_version_ind;
   v_proto_rec.deleted_ind           := p_deleted_ind;
   v_proto_rec.begin_date            := p_begin_date;
   v_proto_rec.end_date              := p_end_date;
dbms_output.put_line('about to do p_protocol_id...');
   v_proto_rec.protocol_id           := p_protocol_id;
dbms_output.put_line('finished p_protocol_id...');
   v_proto_rec.TYPE                  := p_type;
   v_proto_rec.phase                 := p_phase;
   v_proto_rec.lead_org              := p_lead_org;
   v_proto_rec.change_type           := p_change_type;
   v_proto_rec.change_number         := p_change_number;
   v_proto_rec.reviewed_date         := p_reviewed_date;
   v_proto_rec.reviewed_by           := p_reviewed_by;
   v_proto_rec.approved_date         := p_approved_date;
   v_proto_rec.approved_by           := p_approved_by;
   v_proto_rec.date_created          := p_date_created;
   v_proto_rec.created_by            := p_created_by;
   v_proto_rec.date_modified         := p_date_modified;
   v_proto_rec.modified_by           := p_modified_by;
   v_proto_rec.change_note          := p_change_note;
  v_proto_rec.origin                 := p_origin;  -- 23-Jul-2003, W. Ver Hoef
dbms_output.put_line('finished rec now ind...');

  v_proto_ind.proto_idseq    := TRUE;
   v_proto_ind.version    := TRUE;
   v_proto_ind.conte_idseq   := TRUE;
   v_proto_ind.preferred_name   := TRUE;
   v_proto_ind.preferred_definition := TRUE;
   v_proto_ind.asl_name              := TRUE;
   v_proto_ind.long_name             := TRUE;
   v_proto_ind.latest_version_ind    := TRUE;
   v_proto_ind.deleted_ind           := TRUE;
   v_proto_ind.begin_date            := TRUE;
   v_proto_ind.end_date              := TRUE;
   v_proto_ind.protocol_id           := TRUE;
   v_proto_ind.TYPE                  := TRUE;
   v_proto_ind.phase                 := TRUE;
   v_proto_ind.lead_org              := TRUE;
   v_proto_ind.change_type           := TRUE;
   v_proto_ind.change_number         := TRUE;
   v_proto_ind.reviewed_date         := TRUE;
   v_proto_ind.reviewed_by           := TRUE;
   v_proto_ind.approved_date         := TRUE;
   v_proto_ind.approved_by           := TRUE;
   v_proto_ind.date_created          := TRUE;
   v_proto_ind.created_by            := TRUE;
   v_proto_ind.date_modified         := TRUE;
   v_proto_ind.modified_by           := TRUE;
   v_proto_ind.change_note          := TRUE;
  v_proto_ind.origin                 := TRUE;  -- 23-Jul-2003, W. Ver Hoef
dbms_output.put_line('finished ind about to call Cg$protocols_View_Ext.ins...');

  BEGIN
       Cg$protocols_View_Ext.ins(v_proto_rec,v_proto_ind);
     EXCEPTION WHEN OTHERS THEN
dbms_output.put_line('SQLERRN = '||SQLERRM);
dbms_output.put_line('SQLCODE = '||SQLCODE);
    dbms_output.put_line('Error inserting Protocol ' ||SUBSTR(SQLERRM,1,200));
       P_RETURN_CODE := 'API_PROTO_500'; --Error inserting Relationship
     END;
  END IF;
END;



PROCEDURE SET_CD_VMS(
P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_CDVMS_CV_IDSEQ         IN OUT VARCHAR2
,P_CDVMS_CD_IDSEQ         IN OUT VARCHAR2
,P_CDVMS_SHORT_MEANING      IN OUT VARCHAR2
,P_CDVMS_DESCRIPTION        IN OUT VARCHAR2
,P_CDVMS_DATE_CREATED     OUT VARCHAR2
,P_CDVMS_CREATED_BY         OUT VARCHAR2
,P_CDVMS_MODIFIED_BY     OUT VARCHAR2
,P_CDVMS_DATE_MODIFIED     OUT VARCHAR2)
IS

/******************************************************************************
   NAME:       SET_CD_VMS
   PURPOSE:    Inserts or Updates a Single Row Of CD_VMS basedo n either
               CD_IDSEQ or SHORT_MEANING

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/20/2002  Judy Pai      1. Created this procedure




******************************************************************************/


v_cv_rec  CG$CD_VMS_VIEW.cg$row_type;
v_cv_ind  CG$CD_VMS_VIEW.cg$ind_type;
v_cv_pk   CG$CD_VMS_VIEW.cg$pk_type;

BEGIN
P_RETURN_CODE := NULL;

IF P_ACTION NOT IN ('INS','DEL') THEN
 P_RETURN_CODE := 'API_CDVMS_700'; -- Invalid action
 RETURN;
END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
  IF P_CDVMS_CV_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_CDVMS_100' ;  --for inserts the ID IS generated
  RETURN;
  ELSE
     --Check to see that all mandatory parameters are not null

  IF P_CDVMS_CD_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_CDVMS_102'; --VD_IDSEQ cannot be null here
  RETURN;
  END IF;

  IF P_CDVMS_SHORT_MEANING IS NULL THEN
     P_RETURN_CODE := 'API_CDVMS_104'; --SHORT_MEANING cannot be null here
  RETURN;
  END IF;
  END IF;
END IF;


IF P_ACTION = 'DEL' THEN              --we are deleting a record
  IF P_CDVMS_CV_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_CDVMS_400' ;  --for deleted the ID idmandatory
  RETURN;

  END IF;
  v_cv_pk.cv_idseq := P_CDVMS_CV_IDSEQ;

  SELECT ROWID INTO v_cv_pk.the_rowid
  FROM CD_VMS_VIEW
  WHERE cv_idseq = P_CDVMS_CV_IDSEQ;
  v_cv_pk.jn_notes := NULL;

  BEGIN
    CG$CD_VMS_VIEW.del(v_cv_pk);
 RETURN;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_CDVMS_501'; --Error deleteing Value Domain
 RETURN;
  END;

END IF;

--check to see that conceptual domain and vlue_meaning

IF NOT Sbrext_Common_Routines.ac_exists(P_CDVMS_CD_IDSEQ)  THEN
  P_RETURN_CODE := 'API_CDVMS_201'; --Conceptual domain NOT found in the database
  RETURN;
END IF;

IF NOT Sbrext_Common_Routines.vm_exists(p_short_meaning=>P_CDVMS_SHORT_MEANING) THEN
  P_RETURN_CODE := 'API_CDVMS_202'; --Value meaning not found in the database
  RETURN;
END IF;

IF Sbrext_Common_Routines.cd_vm_exists(p_cd_idseq=>P_CDVMS_CD_IDSEQ,p_short_meaning=>P_CDVMS_SHORT_MEANING) THEN
  P_RETURN_CODE := 'API_CDVMS_203'; --Relationship exists for the CD and VM
  RETURN;
END IF;

IF (P_ACTION = 'INS' ) THEN


  P_CDVMS_CV_IDSEQ := admincomponent_crud.cmr_guid;
  P_CDVMS_DATE_CREATED := TO_CHAR(SYSDATE);
  P_CDVMS_CREATED_BY := ADMIN_SECURITY_UTIL.effective_user;
  P_CDVMS_DATE_MODIFIED := NULL;
  P_CDVMS_MODIFIED_BY := NULL;

  v_cv_rec.cv_idseq       := P_CDVMS_CV_IDSEQ;
  v_cv_rec.cd_idseq       := P_CDVMS_CD_IDSEQ ;
  v_cv_rec.short_meaning  := P_CDVMS_SHORT_MEANING;
  v_cv_rec.description    := P_CDVMS_DESCRIPTION;
  v_cv_rec.created_by   := P_CDVMS_CREATED_BY;
  v_cv_rec.date_created   := TO_DATE(P_CDVMS_DATE_CREATED);
  v_cv_rec.modified_by   := P_CDVMS_MODIFIED_BY;
  v_cv_rec.date_modified  := P_CDVMS_DATE_MODIFIED;

  v_cv_ind.CV_IDSEQ   := TRUE;
  v_cv_ind.CD_IDSEQ   := TRUE;
  v_cv_ind.SHORT_MEANING  := TRUE;
  v_cv_ind.description    := TRUE;
  v_cv_ind.created_by   := TRUE;
  v_cv_ind.date_created   := TRUE;
  v_cv_ind.modified_by   := TRUE;
  v_cv_ind.date_modified  := TRUE;
  BEGIN
    CG$CD_VMS_VIEW.ins(v_cv_rec,v_cv_ind);
  EXCEPTION WHEN OTHERS THEN
   P_RETURN_CODE := 'API_CDVMS_500'; --Error inserting VD_PVS
  END;
END IF;


 EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_CD_VMS;

PROCEDURE SET_CD_VMS(
P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_CDVMS_CV_IDSEQ         IN OUT VARCHAR2
,P_CDVMS_CD_IDSEQ         IN OUT VARCHAR2
,P_CDVMS_VM_IDSEQ      IN OUT VARCHAR2
,P_CDVMS_DESCRIPTION        IN OUT VARCHAR2
,P_CDVMS_DATE_CREATED     OUT VARCHAR2
,P_CDVMS_CREATED_BY         OUT VARCHAR2
,P_CDVMS_MODIFIED_BY     OUT VARCHAR2
,P_CDVMS_DATE_MODIFIED     OUT VARCHAR2)
IS

/******************************************************************************
   NAME:       SET_CD_VMS
   PURPOSE:    Inserts or Updates a Single Row Of CD_VMS basedo n either
               CD_IDSEQ or VM_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/20/2002  Judy Pai      1. Created this procedure




******************************************************************************/


v_cv_rec  CG$CD_VMS_VIEW.cg$row_type;
v_cv_ind  CG$CD_VMS_VIEW.cg$ind_type;
v_cv_pk   CG$CD_VMS_VIEW.cg$pk_type;

BEGIN
P_RETURN_CODE := NULL;

IF P_ACTION NOT IN ('INS','DEL') THEN
 P_RETURN_CODE := 'API_CDVMS_700'; -- Invalid action
 RETURN;
END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
  IF P_CDVMS_CV_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_CDVMS_100' ;  --for inserts the ID IS generated
  RETURN;
  ELSE
     --Check to see that all mandatory parameters are not null

  IF P_CDVMS_CD_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_CDVMS_102'; --VD_IDSEQ cannot be null here
  RETURN;
  END IF;

  IF P_CDVMS_VM_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_CDVMS_104'; --SHORT_MEANING cannot be null here
  RETURN;
  END IF;
  END IF;
END IF;


IF P_ACTION = 'DEL' THEN              --we are deleting a record
  IF P_CDVMS_CV_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_CDVMS_400' ;  --for deleted the ID idmandatory
  RETURN;

  END IF;
  v_cv_pk.cv_idseq := P_CDVMS_CV_IDSEQ;

  SELECT ROWID INTO v_cv_pk.the_rowid
  FROM CD_VMS_VIEW
  WHERE cv_idseq = P_CDVMS_CV_IDSEQ;
  v_cv_pk.jn_notes := NULL;

  BEGIN
    CG$CD_VMS_VIEW.del(v_cv_pk);
 RETURN;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_CDVMS_501'; --Error deleteing Value Domain
 RETURN;
  END;

END IF;

--check to see that conceptual domain and vlue_meaning

IF NOT Sbrext_Common_Routines.ac_exists(P_CDVMS_CD_IDSEQ)  THEN
  P_RETURN_CODE := 'API_CDVMS_201'; --Conceptual domain NOT found in the database
  RETURN;
END IF;

IF NOT Sbrext_Common_Routines.vm_exists(p_vm_idseq=>P_CDVMS_VM_IDSEQ) THEN
  P_RETURN_CODE := 'API_CDVMS_202'; --Value meaning not found in the database
  RETURN;
END IF;

IF Sbrext_Common_Routines.cd_vm_exists(p_cd_idseq=>P_CDVMS_CD_IDSEQ,p_vm_idseq=>P_CDVMS_VM_IDSEQ) THEN
  P_RETURN_CODE := 'API_CDVMS_203'; --Relationship exists for the CD and VM
  RETURN;
END IF;

IF (P_ACTION = 'INS' ) THEN


  P_CDVMS_CV_IDSEQ := admincomponent_crud.cmr_guid;
  P_CDVMS_DATE_CREATED := TO_CHAR(SYSDATE);
  P_CDVMS_CREATED_BY := ADMIN_SECURITY_UTIL.effective_user;
  P_CDVMS_DATE_MODIFIED := NULL;
  P_CDVMS_MODIFIED_BY := NULL;

  v_cv_rec.cv_idseq       := P_CDVMS_CV_IDSEQ;
  v_cv_rec.cd_idseq       := P_CDVMS_CD_IDSEQ ;
  v_cv_rec.vm_idseq  := P_CDVMS_VM_IDSEQ;
  v_cv_rec.description    := P_CDVMS_DESCRIPTION;
  v_cv_rec.created_by   := P_CDVMS_CREATED_BY;
  v_cv_rec.date_created   := TO_DATE(P_CDVMS_DATE_CREATED);
  v_cv_rec.modified_by   := P_CDVMS_MODIFIED_BY;
  v_cv_rec.date_modified  := P_CDVMS_DATE_MODIFIED;

  v_cv_ind.CV_IDSEQ   := TRUE;
  v_cv_ind.CD_IDSEQ   := TRUE;
  v_cv_ind.VM_IDSEQ  := TRUE;
  v_cv_ind.description    := TRUE;
  v_cv_ind.created_by   := TRUE;
  v_cv_ind.date_created   := TRUE;
  v_cv_ind.modified_by   := TRUE;
  v_cv_ind.date_modified  := TRUE;
  BEGIN
    CG$CD_VMS_VIEW.ins(v_cv_rec,v_cv_ind);
  EXCEPTION WHEN OTHERS THEN
   P_RETURN_CODE := 'API_CDVMS_500'; --Error inserting VD_PVS
  END;
END IF;


 EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_CD_VMS;

PROCEDURE SET_PROPERTY(
 P_RETURN_CODE                  OUT VARCHAR2
,P_ACTION              IN     VARCHAR2
,P_PROP_IDSEQ             IN OUT VARCHAR2
,P_PROP_PREFERRED_NAME       IN OUT VARCHAR2
,P_PROP_LONG_NAME            IN OUT VARCHAR2
,P_PROP_PREFERRED_DEFINITION IN OUT VARCHAR2
,P_PROP_CONTE_IDSEQ          IN OUT VARCHAR2
,P_PROP_VERSION          IN OUT VARCHAR2
,P_PROP_ASL_NAME         IN OUT VARCHAR2
,P_PROP_LATEST_VERSION_IND   IN OUT VARCHAR2
,P_PROP_CHANGE_NOTE       IN OUT VARCHAR2
,P_PROP_ORIGIN            IN OUT VARCHAR2
,P_PROP_DEFINITION_SOURCE    IN OUT VARCHAR2
,P_PROP_BEGIN_DATE       IN OUT VARCHAR2
,P_PROP_END_DATE             IN OUT VARCHAR2
,P_PROP_DATE_CREATED            OUT VARCHAR2
,P_PROP_CREATED_BY           OUT VARCHAR2
,P_PROP_DATE_MODIFIED           OUT VARCHAR2
,P_PROP_MODIFIED_BY             OUT VARCHAR2
,P_PROP_DELETED_IND             OUT VARCHAR2
,P_PROP_DESIG_NCI_CC_TYPE    IN     VARCHAR2
,P_PROP_DESIG_NCI_CC_VAL     IN     VARCHAR2
,P_PROP_DESIG_UMLS_CUI_TYPE  IN     VARCHAR2
,P_PROP_DESIG_UMLS_CUI_VAL   IN     VARCHAR2
,P_PROP_DESIG_TEMP_CUI_TYPE  IN     VARCHAR2
,P_PROP_DESIG_TEMP_CUI_VAL   IN     VARCHAR2
)
IS
/******************************************************************************
   NAME:       SET_PROPERTY
   PURPOSE:    Inserts or Updates a Single Row Of properties_ext based on either


   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04/02/2003  Judy Pai         1. Created this procedure
   2.0        07/23/2003  W. Ver Hoef     1. added v_prop_ind.origin := FALSE
                         for DEL action
   2.1        03/19/2004  W. Ver Hoef      1. substituted UNASSIGNED with function
                                              call to get_default_asl

******************************************************************************/


v_prop_rec  Cg$properties_View_Ext.cg$row_type;
v_prop_ind  Cg$properties_View_Ext.cg$ind_type;

v_begin_date   DATE    := NULL;
v_end_date     DATE    := NULL;
v_new_Version  BOOLEAN := FALSE;

v_version  properties_view_ext.version%TYPE;
v_asl_name properties_view_ext.asl_name%TYPE;

BEGIN

  P_RETURN_CODE := NULL;


  IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
    P_RETURN_CODE := 'API_PROP_700'; -- Invalid action
    RETURN;
  END IF;

  IF P_ACTION = 'INS' THEN              --we are inserting a record
    IF P_PROP_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_PROP_100' ;  --for inserts the ID IS generated
   RETURN;
    ELSE
      --Check to see that all mandatory parameters are not null
   IF P_PROP_PREFERRED_NAME IS NULL THEN
     P_RETURN_CODE := 'API_PROP_102'; --PREFERRED_NAME cannot be null here
  RETURN;
   END IF;
   IF P_PROP_PREFERRED_DEFINITION IS NULL THEN
     P_RETURN_CODE := 'API_PROP_104'; --PREFERRED_DEFINITION cannot be null here
  RETURN;
   END IF;
   IF P_PROP_CONTE_IDSEQ  IS NULL THEN
     P_RETURN_CODE := 'API_PROP_106';  --CONTEXT_NAME cannot be null here
  RETURN;
   END IF;
    END IF;
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are deleting a record

    IF P_PROP_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_PROP_400' ;  --for deleted the ID idmandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ac_exists(P_PROP_IDSEQ) THEN
     P_RETURN_CODE := 'API_PROP_005'; --PROPERTY not found
     RETURN;
   END IF;
    END IF;

    P_PROP_DELETED_IND   := 'Yes';
    P_PROP_MODIFIED_BY   := 'USER';
    P_PROP_DATE_MODIFIED := TO_CHAR(SYSDATE);

    v_prop_rec.prop_idseq         := P_PROP_IDSEQ;
    v_prop_rec.deleted_ind        := P_PROP_DELETED_IND;
    v_prop_rec.modified_by        := P_PROP_MODIFIED_BY;
    v_prop_rec.date_modified      := TO_DATE(P_PROP_DATE_MODIFIED);
    v_prop_rec.latest_version_ind := P_PROP_LATEST_VERSION_IND;

    v_prop_ind.prop_idseq         := TRUE;
    v_prop_ind.preferred_name     := FALSE;
    v_prop_ind.conte_idseq         := FALSE;
    v_prop_ind.version             := FALSE;
    v_prop_ind.preferred_definition := FALSE;
    v_prop_ind.long_name         := FALSE;
    v_prop_ind.asl_name             := FALSE;
    v_prop_ind.latest_version_ind   := FALSE;
    v_prop_ind.begin_date         := FALSE;
    v_prop_ind.end_date             := FALSE;
    v_prop_ind.change_note         := FALSE;
    v_prop_ind.created_by         := FALSE;
    v_prop_ind.date_created         := FALSE;
 v_prop_ind.origin               := FALSE;  -- 23-Jul-2003, W. Ver Hoef
    v_prop_ind.modified_by         := TRUE;
    v_prop_ind.date_modified     := TRUE;
    v_prop_ind.deleted_ind          := TRUE;

    BEGIN
      Cg$properties_View_Ext.upd(v_prop_rec,v_prop_ind);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_PROP_501'; --Error deleteing PROPERTY
    END;

  END IF;

  IF P_ACTION = 'UPD' THEN              --we are updating a record
    IF P_PROP_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_PROP_400' ;  --for updates the ID IS mandatory
   RETURN;
    END IF;
    SELECT asl_name
    INTO   v_asl_name
    FROM   PROPERTIES_EXT
    WHERE  prop_idseq = p_prop_idseq;
    IF (P_PROP_PREFERRED_NAME IS NOT NULL OR P_PROP_CONTE_IDSEQ IS NOT NULL) AND v_asl_name = 'RELEASED' THEN
      P_RETURN_CODE := 'API_PROP_401' ;  --Preferred Name or Context Can not be updated
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(P_PROP_IDSEQ) THEN
      P_RETURN_CODE := 'API_PROP_005'; --PROP_IDSEQ not found
      RETURN;
    END IF;
  END IF;

  IF P_PROP_LATEST_VERSION_IND IS NOT NULL THEN
    IF P_PROP_LATEST_VERSION_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_PROP_105'; --Version can only be 'Yes' or 'No'
      RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
  IF LENGTH(P_PROP_PREFERRED_NAME) > Sbrext_Column_Lengths.L_PROP_PREFERRED_NAME THEN
    P_RETURN_CODE := 'API_PROP_111';  --Length of preferred_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_PROP_PREFERRED_DEFINITION) > Sbrext_Column_Lengths.L_PROP_PREFERRED_DEFINITION THEN
    P_RETURN_CODE := 'API_PROP_113';  --Length of Preferred_definition exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_PROP_LONG_NAME) > Sbrext_Column_Lengths.L_PROP_LONG_NAME THEN
    P_RETURN_CODE := 'API_PROP_114'; --Length of Long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_PROP_ASL_NAME) > Sbrext_Column_Lengths.L_PROP_ASL_NAME  THEN
    P_RETURN_CODE := 'API_PROP_115'; --Length of asl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_PROP_CHANGE_NOTE) > Sbrext_Column_Lengths.L_PROP_CHANGE_NOTE THEN
    P_RETURN_CODE := 'API_PROP_128'; --Length of change_note exceeds maximum length
    RETURN;
  END IF;

  --check to see that charachter strings are valid
  IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_PROP_PREFERRED_NAME) THEN
    P_RETURN_CODE := 'API_PROP_130'; -- Data Element Preferred Name has invalid Ccharacters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_PROP_PREFERRED_DEFINITION) THEN
    P_RETURN_CODE := 'API_PROP_133'; -- Data Element Preferred Definition has invalid characters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_PROP_LONG_NAME) THEN
    P_RETURN_CODE := 'API_PROP_134'; -- Data Element Long Name has invalid characters
    RETURN;
  END IF;

  --check to see that Context, Workflow Status, Data Element Concept, Value Domain already exist in the database
  IF P_PROP_CONTE_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.context_exists(P_PROP_CONTE_IDSEQ) THEN
      P_RETURN_CODE := 'API_PROP_200'; --Context not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_PROP_ASL_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.workflow_exists(P_PROP_ASL_NAME) THEN
      P_RETURN_CODE := 'API_PROP_202'; --Workflow Status not found in the database
      RETURN;
    END IF;
  END IF;

  --check to see that begin data and end date are valid dates
  IF(P_PROP_BEGIN_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_PROP_BEGIN_DATE,v_begin_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_PROP_600'; --begin date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_PROP_END_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_PROP_END_DATE,v_end_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_PROP_601'; --end date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_PROP_BEGIN_DATE IS NOT NULL AND P_PROP_END_DATE IS NOT NULL) THEN
    IF(v_end_date < v_begin_date) THEN
      P_RETURN_CODE := 'API_PROP_210'; --end date is before begin date
      RETURN;
    END IF;
  ELSIF(P_PROP_END_DATE IS NOT NULL AND P_PROP_BEGIN_DATE IS NULL) THEN
    P_RETURN_CODE := 'API_PROP_211'; --begin date cannot be null when end date is null
    RETURN;
  END IF;

  IF (P_ACTION = 'INS' ) THEN

    P_PROP_IDSEQ         := admincomponent_crud.cmr_guid;
    P_PROP_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_PROP_CREATED_BY    := ADMIN_SECURITY_UTIL.effective_user;
    P_PROP_DATE_MODIFIED := NULL;
    P_PROP_MODIFIED_BY   := NULL;
    IF P_PROP_VERSION IS NULL THEN
      P_PROP_VERSION := 1;
    END IF;
    IF P_PROP_ASL_NAME IS NULL THEN
   -- 19-Mar-2004, W. Ver Hoef - substituted UNASSIGNED with function call below
      P_PROP_ASL_NAME := Sbrext_Common_Routines.get_default_asl('INS'); -- 'UNASSIGNED';
    END IF;

    v_prop_rec.prop_idseq           := P_PROP_IDSEQ;
    v_prop_rec.preferred_name       := P_PROP_PREFERRED_NAME;
    v_prop_rec.PREFERRED_DEFINITION := P_PROP_PREFERRED_DEFINITION;
    v_prop_rec.created_by         := ADMIN_SECURITY_UTIL.effective_user;
    v_prop_rec.date_created         := SYSDATE;
    v_prop_rec.modified_by         := NULL;
    v_prop_rec.date_modified        := NULL;
    v_prop_rec.long_name            := P_PROP_LONG_NAME;
    v_prop_rec.conte_idseq          := P_PROP_CONTE_IDSEQ;
    v_prop_rec.version              := P_PROP_VERSION;
    v_prop_rec.asl_name             := P_PROP_ASL_NAME;
    v_prop_rec.latest_version_ind   := 'Yes';
    v_prop_rec.change_note          := NULL;
    v_prop_rec.begin_date           := NULL;
    v_prop_rec.end_date             := NULL;
    v_prop_rec.deleted_ind          := 'No';
    v_prop_rec.definition_source    := P_PROP_DEFINITION_SOURCE;
    v_prop_rec.origin               := P_PROP_ORIGIN;
   /* v_prop_rec.DESIG_NCI_CC_TYPE    := P_PROP_DESIG_NCI_CC_TYPE ;
    v_prop_rec.DESIG_NCI_CC_VAL     := P_PROP_DESIG_NCI_CC_VAL ;
    v_prop_rec.DESIG_UMLS_CUI_TYPE  := P_PROP_DESIG_UMLS_CUI_TYPE ;
    v_prop_rec.DESIG_UMLS_CUI_VAL   := P_PROP_DESIG_UMLS_CUI_VAL ;
    v_prop_rec.DESIG_TEMP_CUI_TYPE  := P_PROP_DESIG_TEMP_CUI_TYPE ;
    v_prop_rec.DESIG_TEMP_CUI_VAL   := P_PROP_DESIG_TEMP_CUI_VAL ;*/

    v_prop_ind.prop_idseq           := TRUE;
    v_prop_ind.preferred_name       := TRUE;
    v_prop_ind.PREFERRED_DEFINITION := TRUE;
    v_prop_ind.created_by           := TRUE;
    v_prop_ind.date_created         := TRUE;
    v_prop_ind.modified_by         := TRUE;
    v_prop_ind.date_modified        := TRUE;
    v_prop_ind.long_name            := TRUE;
    v_prop_ind.conte_idseq          := TRUE;
    v_prop_ind.version              := TRUE;
    v_prop_ind.asl_name             := TRUE;
    v_prop_ind.latest_version_ind   := TRUE;
    v_prop_ind.change_note          := TRUE;
    v_prop_ind.begin_date           := TRUE;
    v_prop_ind.end_date             := TRUE;
    v_prop_ind.deleted_ind          := TRUE;
    v_prop_ind.definition_source    := TRUE;
    v_prop_ind.origin               := TRUE;
    /*v_prop_ind.DESIG_NCI_CC_TYPE    := TRUE;
    v_prop_ind.DESIG_NCI_CC_VAL     := TRUE;
    v_prop_ind.DESIG_UMLS_CUI_TYPE  := TRUE;
    v_prop_ind.DESIG_UMLS_CUI_VAL   := TRUE;
    v_prop_ind.DESIG_TEMP_CUI_TYPE  := TRUE;
    v_prop_ind.DESIG_TEMP_CUI_VAL   := TRUE;*/

    BEGIN
      Cg$properties_View_Ext.ins(v_prop_rec,v_prop_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_PROP_500'; --Error inserting PROPERTIES_VIEW_EXT
    END;

  END IF;

  IF (P_ACTION = 'UPD' ) THEN

    --Get the version for the P_PROP_IDSEQ
    SELECT version
 INTO   v_version
    FROM   properties_view_ext
    WHERE  prop_idseq = P_PROP_IDSEQ;

    IF v_version <> P_PROP_VERSION THEN
      P_RETURN_CODE := 'API_PROP_402'; -- Version can NOT be updated. It can only be created
      RETURN;
    END IF;

    P_PROP_DATE_MODIFIED := TO_CHAR(SYSDATE);
    P_PROP_MODIFIED_BY := ADMIN_SECURITY_UTIL.effective_user;
    P_PROP_DELETED_IND := 'No';

    v_prop_rec.date_modified := TO_DATE(P_PROP_DATE_MODIFIED);
    v_prop_rec.modified_by   := P_PROP_MODIFIED_BY;
    v_prop_rec.prop_idseq    := P_PROP_IDSEQ;
    v_prop_rec.deleted_ind   := 'No';

    v_prop_ind.date_modified := TRUE;
    v_prop_ind.modified_by   := TRUE;
    v_prop_ind.deleted_ind   := TRUE;
    v_prop_ind.prop_idseq    := TRUE;

    v_prop_ind.version       := FALSE;
    v_prop_ind.created_by  := FALSE;
    v_prop_ind.date_created  := FALSE;

    IF P_PROP_PREFERRED_NAME IS NULL THEN
      v_prop_ind.preferred_name := FALSE;
    ELSE
      v_prop_rec.preferred_name := P_PROP_PREFERRED_NAME;
      v_prop_ind.preferred_name := TRUE;
    END IF;

    IF P_PROP_CONTE_IDSEQ IS NULL THEN
      v_prop_ind.conte_idseq := FALSE;
    ELSE
      v_prop_rec.conte_idseq := P_PROP_CONTE_IDSEQ;
      v_prop_ind.conte_idseq := TRUE;
    END IF;

    IF P_PROP_PREFERRED_DEFINITION IS NULL THEN
      v_prop_ind.preferred_definition := FALSE; /***/
    ELSE
      v_prop_rec.preferred_definition := P_PROP_PREFERRED_DEFINITION;
      v_prop_ind.preferred_definition := TRUE;
    END IF;

    IF P_PROP_LONG_NAME IS NULL THEN
      v_prop_ind.long_name := FALSE;
    ELSE
      v_prop_rec.long_name := P_PROP_LONG_NAME;
      v_prop_ind.long_name := TRUE;
    END IF;

    IF P_PROP_ASL_NAME IS NULL THEN
      v_prop_ind.asl_name := FALSE;
    ELSE
      v_prop_rec.asl_name := P_PROP_ASL_NAME;
      v_prop_ind.asl_name := TRUE;
    END IF;

    IF P_PROP_LATEST_VERSION_IND IS NULL THEN
      v_prop_ind.latest_version_ind := FALSE;
    ELSE
      v_prop_rec.latest_version_ind := P_PROP_LATEST_VERSION_IND;
      v_prop_ind.latest_version_ind := TRUE;
    END IF;

    IF P_PROP_BEGIN_DATE IS NULL THEN
      v_prop_ind.begin_date := FALSE;
    ELSE
      v_prop_rec.begin_date := TO_DATE(P_PROP_BEGIN_DATE);
      v_prop_ind.begin_date := TRUE;
    END IF;

    IF P_PROP_END_DATE  IS NULL THEN
      v_prop_ind.end_date := FALSE;
    ELSE
      v_prop_rec.end_date := TO_DATE(P_PROP_END_DATE);
      v_prop_ind.end_date := TRUE;
    END IF;

    IF P_PROP_CHANGE_NOTE   IS NULL THEN
      v_prop_ind.change_note := FALSE;
    ELSE
      v_prop_rec.change_note := P_PROP_CHANGE_NOTE;
      v_prop_ind.change_note := TRUE;
    END IF;

    IF P_PROP_DEFINITION_SOURCE IS NULL THEN
      v_prop_ind.definition_source := FALSE;
    ELSE
      v_prop_rec.definition_source := P_PROP_DEFINITION_SOURCE;
      v_prop_ind.definition_source := TRUE;
    END IF;

    IF P_PROP_ORIGIN IS NULL THEN
      v_prop_ind.origin := FALSE;
    ELSE
      v_prop_rec.origin := P_PROP_ORIGIN;
      v_prop_ind.origin := TRUE;
    END IF;

  /*  IF P_PROP_DESIG_NCI_CC_TYPE   IS NULL THEN
      v_prop_ind.DESIG_NCI_CC_TYPE := FALSE;
    ELSE
      v_prop_rec.DESIG_NCI_CC_TYPE := P_PROP_DESIG_NCI_CC_TYPE;
      v_prop_ind.DESIG_NCI_CC_TYPE := TRUE;
    END IF;

    IF P_PROP_DESIG_NCI_CC_VAL   IS NULL THEN
      v_prop_ind.DESIG_NCI_CC_VAL := FALSE;
    ELSE
      v_prop_rec.DESIG_NCI_CC_VAL := P_PROP_DESIG_NCI_CC_VAL;
      v_prop_ind.DESIG_NCI_CC_VAL := TRUE;
    END IF;

    IF P_PROP_DESIG_UMLS_CUI_TYPE   IS NULL THEN
      v_prop_ind.DESIG_UMLS_CUI_TYPE := FALSE;
    ELSE
      v_prop_rec.DESIG_UMLS_CUI_TYPE := P_PROP_DESIG_UMLS_CUI_TYPE;
      v_prop_ind.DESIG_UMLS_CUI_TYPE := TRUE;
    END IF;

    IF P_PROP_DESIG_UMLS_CUI_VAL   IS NULL THEN
      v_prop_ind.DESIG_UMLS_CUI_VAL := FALSE;
    ELSE
      v_prop_rec.DESIG_UMLS_CUI_VAL := P_PROP_DESIG_UMLS_CUI_VAL;
      v_prop_ind.DESIG_UMLS_CUI_VAL := TRUE;
    END IF;

    IF P_PROP_DESIG_TEMP_CUI_TYPE   IS NULL THEN
      v_prop_ind.DESIG_TEMP_CUI_TYPE := FALSE;
    ELSE
      v_prop_rec.DESIG_TEMP_CUI_TYPE := P_PROP_DESIG_TEMP_CUI_TYPE;
      v_prop_ind.DESIG_TEMP_CUI_TYPE := TRUE;
    END IF;

    IF P_PROP_DESIG_TEMP_CUI_VAL   IS NULL THEN
      v_prop_ind.DESIG_TEMP_CUI_VAL := FALSE;
    ELSE
      v_prop_rec.DESIG_TEMP_CUI_VAL := P_PROP_DESIG_TEMP_CUI_VAL;
      v_prop_ind.DESIG_TEMP_CUI_VAL := TRUE;
    END IF;*/

    BEGIN
      Cg$properties_View_Ext.upd(v_prop_rec,v_prop_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_PROP_502'; --Error updating Property
    END;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;

END SET_PROPERTY;



PROCEDURE SET_OBJECT_CLASS(
 P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                  IN     VARCHAR2
,P_oc_IDSEQ                IN OUT VARCHAR2
,P_oc_PREFERRED_NAME       IN OUT VARCHAR2
,P_oc_LONG_NAME            IN OUT VARCHAR2
,P_oc_PREFERRED_DEFINITION IN OUT VARCHAR2
,P_oc_CONTE_IDSEQ          IN OUT VARCHAR2
,P_oc_VERSION              IN OUT VARCHAR2
,P_oc_ASL_NAME             IN OUT VARCHAR2
,P_oc_LATEST_VERSION_IND   IN OUT VARCHAR2
,P_oc_CHANGE_NOTE          IN OUT VARCHAR2
,P_oc_ORIGIN               IN OUT VARCHAR2
,P_oc_DEFINITION_SOURCE    IN OUT VARCHAR2
,P_oc_BEGIN_DATE           IN OUT VARCHAR2
,P_oc_END_DATE             IN OUT VARCHAR2
,P_oc_DATE_CREATED            OUT VARCHAR2
,P_oc_CREATED_BY              OUT VARCHAR2
,P_oc_DATE_MODIFIED           OUT VARCHAR2
,P_oc_MODIFIED_BY             OUT VARCHAR2
,P_oc_DELETED_IND             OUT VARCHAR2
,P_OC_DESIG_NCI_CC_TYPE    IN     VARCHAR2
,P_OC_DESIG_NCI_CC_VAL     IN     VARCHAR2
,P_OC_DESIG_UMLS_CUI_TYPE  IN     VARCHAR2
,P_OC_DESIG_UMLS_CUI_VAL   IN     VARCHAR2
,P_OC_DESIG_TEMP_CUI_TYPE  IN     VARCHAR2
,P_OC_DESIG_TEMP_CUI_VAL   IN     VARCHAR2
)
IS
/******************************************************************************
   NAME:       SET_OBJECT_CLASS
   PURPOSE:    Inserts or Updates a Single Row Of OBJECT_CLASSES_ext based on either

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04/02/2003  Judy Pai         1. Created this procedure
   2.0     07/22/2003  W. Ver Hoef     1. Added v_oc_ind.origin := FALSE for
                                              DEL action
   2.1        03/19/2004  W. Ver Hoef      1. substituted UNASSIGNED with function
                                              call to get_default_asl

******************************************************************************/

v_oc_rec       Cg$object_Classes_View_Ext.cg$row_type;
v_oc_ind       Cg$object_Classes_View_Ext.cg$ind_type;
v_version      OBJECT_CLASSES_view_ext.version%TYPE;
v_asl_name     OBJECT_CLASSES_view_ext.asl_name%TYPE;
v_begin_date   DATE    := NULL;
v_end_date     DATE    := NULL;
v_new_Version  BOOLEAN := FALSE;

BEGIN
  P_RETURN_CODE := NULL;



  IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
    P_RETURN_CODE := 'API_OC_700'; -- Invalid action
    RETURN;
  END IF;

  IF P_ACTION = 'INS' THEN              --we are inserting a record
    IF P_oc_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_OC_100' ;  --for inserts the ID IS generated
   RETURN;
    ELSE
      --Check to see that all mandatory parameters are not null

   IF P_oc_PREFERRED_NAME IS NULL THEN
     P_RETURN_CODE := 'API_OC_102'; --PREFERRED_NAME cannot be null here
  RETURN;
   END IF;

   IF P_oc_PREFERRED_DEFINITION IS NULL THEN
     P_RETURN_CODE := 'API_OC_104'; --PREFERRED_DEFINITION cannot be null here
  RETURN;
   END IF;

   IF P_oc_CONTE_IDSEQ  IS NULL THEN
     P_RETURN_CODE := 'API_OC_106';  --CONTEXT_NAME cannot be null here
  RETURN;
   END IF;
    END IF;
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are deleting a record

    IF P_oc_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_OC_400' ;  --for deleted the ID idmandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ac_exists(P_oc_IDSEQ) THEN
     P_RETURN_CODE := 'API_OC_005'; --OBJECT_CLASS not found
     RETURN;
   END IF;
    END IF;

    P_oc_DELETED_IND            := 'Yes';
    P_oc_MODIFIED_BY            := 'USER';
    P_oc_DATE_MODIFIED          := TO_CHAR(SYSDATE);

    v_oc_rec.oc_idseq           := P_oc_IDSEQ;
    v_oc_rec.deleted_ind        := P_oc_DELETED_IND;
    v_oc_rec.modified_by        := P_oc_MODIFIED_BY;
    v_oc_rec.date_modified      := TO_DATE(P_oc_DATE_MODIFIED);
    v_oc_rec.latest_version_ind := P_oc_LATEST_VERSION_IND;

    v_oc_ind.oc_idseq             := TRUE;
    v_oc_ind.preferred_name       := FALSE;
    v_oc_ind.conte_idseq          := FALSE;
    v_oc_ind.version              := FALSE;
    v_oc_ind.preferred_definition := FALSE;
    v_oc_ind.long_name            := FALSE;
    v_oc_ind.asl_name             := FALSE;
    v_oc_ind.latest_version_ind   := FALSE;
    v_oc_ind.begin_date           := FALSE;
    v_oc_ind.end_date             := FALSE;
    v_oc_ind.change_note          := FALSE;
    v_oc_ind.created_by           := FALSE;
    v_oc_ind.date_created         := FALSE;
 v_oc_ind.origin               := FALSE;  -- 22-Jul-2003, W. Ver Hoef
    v_oc_ind.modified_by          := TRUE;
    v_oc_ind.date_modified        := TRUE;
    v_oc_ind.deleted_ind          := TRUE;

    BEGIN
      Cg$object_Classes_View_Ext.upd(v_oc_rec,v_oc_ind);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
dbms_output.put_line('SQLCODE = '||SQLCODE);
dbms_output.put_line('SQLERRM = '||SQLERRM);
      P_RETURN_CODE := 'API_OC_501'; --Error deleteing OBJECT_CLASS
    END;

  END IF;

  IF P_ACTION = 'UPD' THEN              --we are updating a record
    IF P_oc_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_OC_400' ;  --for updates the ID IS mandatory
   RETURN;
    END IF;
    SELECT asl_name
 INTO v_asl_name
    FROM OBJECT_CLASSES_EXT
    WHERE oc_idseq = p_oc_idseq;
    IF ( P_oc_PREFERRED_NAME IS NOT NULL OR P_oc_CONTE_IDSEQ IS NOT NULL) AND v_asl_name = 'RELEASED' THEN
      P_RETURN_CODE := 'API_OC_401' ;  --Preferred Name or Context Can not be updated
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(P_oc_IDSEQ) THEN
      P_RETURN_CODE := 'API_OC_005'; --PROP_IDSEQ not found
      RETURN;
    END IF;
  END IF;

  IF P_oc_LATEST_VERSION_IND IS NOT NULL THEN
    IF P_oc_LATEST_VERSION_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_OC_105'; --Version can only be 'Yes' or 'No'
      RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
  IF LENGTH(P_oc_PREFERRED_NAME) > Sbrext_Column_Lengths.L_oc_PREFERRED_NAME THEN
    P_RETURN_CODE := 'API_OC_111';  --Length of preferred_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_oc_PREFERRED_DEFINITION) > Sbrext_Column_Lengths.L_oc_PREFERRED_DEFINITION THEN
    P_RETURN_CODE := 'API_OC_113';  --Length of Preferred_definition exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_oc_LONG_NAME) > Sbrext_Column_Lengths.L_oc_LONG_NAME THEN
    P_RETURN_CODE := 'API_OC_114'; --Length of Long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_oc_ASL_NAME) > Sbrext_Column_Lengths.L_oc_ASL_NAME  THEN
    P_RETURN_CODE := 'API_OC_115'; --Length of asl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_oc_CHANGE_NOTE) > Sbrext_Column_Lengths.L_oc_CHANGE_NOTE THEN
    P_RETURN_CODE := 'API_OC_128'; --Length of change_note exceeds maximum length
    RETURN;
  END IF;

  --check to see that charachter strings are valid
  IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_oc_PREFERRED_NAME) THEN
    P_RETURN_CODE := 'API_OC_130'; -- Data Element Preferred Name has invalid Ccharacters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_oc_PREFERRED_DEFINITION) THEN
    P_RETURN_CODE := 'API_OC_133'; -- Data Element Preferred Definition has invalid characters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_oc_LONG_NAME) THEN
    P_RETURN_CODE := 'API_OC_134'; -- Data Element Long Name has invalid characters
    RETURN;
  END IF;

  --check to see that Context, Workflow Status, Data Element Concept, Value Domain already exist in the database
  IF P_oc_CONTE_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.context_exists(P_oc_CONTE_IDSEQ) THEN
      P_RETURN_CODE := 'API_OC_200'; --Context not found in the database
      RETURN;
    END IF;
  END IF;

  IF P_oc_ASL_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.workflow_exists(P_oc_ASL_NAME) THEN
      P_RETURN_CODE := 'API_OC_202'; --Workflow Status not found in the database
      RETURN;
    END IF;
  END IF;

--check to see that begin data and end date are valid dates
  IF(P_oc_BEGIN_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_oc_BEGIN_DATE,v_begin_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_OC_600'; --begin date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_oc_END_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_oc_END_DATE,v_end_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_OC_601'; --end date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_oc_BEGIN_DATE IS NOT NULL AND P_oc_END_DATE IS NOT NULL) THEN
    IF(v_end_date < v_begin_date) THEN
      P_RETURN_CODE := 'API_OC_210'; --end date is before begin date
      RETURN;
    END IF;
  ELSIF(P_oc_END_DATE IS NOT NULL AND P_oc_BEGIN_DATE IS NULL) THEN
    P_RETURN_CODE := 'API_OC_211'; --begin date cannot be null when end date is null
    RETURN;
  END IF;

  IF (P_ACTION = 'INS' ) THEN

    P_oc_IDSEQ         := admincomponent_crud.cmr_guid;
    P_oc_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_oc_CREATED_BY    := ADMIN_SECURITY_UTIL.effective_user;
    P_oc_DATE_MODIFIED := NULL;
    P_oc_MODIFIED_BY   := NULL;
    IF P_oc_VERSION IS NULL THEN
      P_oc_VERSION := 1;
    END IF;
    IF P_oc_ASL_NAME IS NULL THEN
   -- 19-Mar-2004, W. Ver Hoef - substituted UNASSIGNED with function call below
      P_oc_ASL_NAME := Sbrext_Common_Routines.get_default_asl('INS'); -- 'UNASSIGNED';
    END IF;

    v_oc_rec.oc_idseq             := P_oc_IDSEQ;
    v_oc_rec.preferred_name       := P_oc_PREFERRED_NAME;
    v_oc_rec.PREFERRED_DEFINITION := P_oc_PREFERRED_DEFINITION;
    v_oc_rec.created_by           := ADMIN_SECURITY_UTIL.effective_user;
    v_oc_rec.date_created         := SYSDATE;
    v_oc_rec.modified_by          := NULL;
    v_oc_rec.date_modified        := NULL;
    v_oc_rec.long_name            := P_oc_LONG_NAME;
    v_oc_rec.conte_idseq          := P_oc_CONTE_IDSEQ;
    v_oc_rec.version              := P_oc_VERSION;
    v_oc_rec.asl_name             := P_oc_ASL_NAME;
    v_oc_rec.latest_version_ind   := 'Yes';
    v_oc_rec.change_note          := NULL;
    v_oc_rec.begin_date           := NULL;
    v_oc_rec.end_date             := NULL;
    v_oc_rec.deleted_ind          := 'No';
    v_oc_rec.definition_source    := P_OC_DEFINITION_SOURCE;
    v_oc_rec.origin               := P_OC_ORIGIN;
   /* v_oc_rec.DESIG_NCI_CC_TYPE    := P_oc_DESIG_NCI_CC_TYPE ;
    v_oc_rec.DESIG_NCI_CC_VAL     := P_oc_DESIG_NCI_CC_VAL ;
    v_oc_rec.DESIG_UMLS_CUI_TYPE  := P_oc_DESIG_UMLS_CUI_TYPE ;
    v_oc_rec.DESIG_UMLS_CUI_VAL   := P_oc_DESIG_UMLS_CUI_VAL ;
    v_oc_rec.DESIG_TEMP_CUI_TYPE  := P_oc_DESIG_TEMP_CUI_TYPE ;
    v_oc_rec.DESIG_TEMP_CUI_VAL   := P_oc_DESIG_TEMP_CUI_VAL ;*/

    v_oc_ind.oc_idseq             := TRUE;
    v_oc_ind.preferred_name       := TRUE;
    v_oc_ind.PREFERRED_DEFINITION := TRUE;
    v_oc_ind.created_by           := TRUE;
    v_oc_ind.date_created         := TRUE;
    v_oc_ind.modified_by          := TRUE;
    v_oc_ind.date_modified        := TRUE;
    v_oc_ind.long_name            := TRUE;
    v_oc_ind.conte_idseq          := TRUE;
    v_oc_ind.version              := TRUE;
    v_oc_ind.asl_name             := TRUE;
    v_oc_ind.latest_version_ind   := TRUE;
    v_oc_ind.change_note          := TRUE;
    v_oc_ind.begin_date           := TRUE;
    v_oc_ind.end_date             := TRUE;
    v_oc_ind.deleted_ind          := TRUE;
   /* v_oc_ind.DESIG_NCI_CC_TYPE    := TRUE;
    v_oc_ind.DESIG_NCI_CC_VAL     := TRUE;
    v_oc_ind.DESIG_UMLS_CUI_TYPE  := TRUE;
    v_oc_ind.DESIG_UMLS_CUI_VAL   := TRUE;
    v_oc_ind.DESIG_TEMP_CUI_TYPE  := TRUE;
    v_oc_ind.DESIG_TEMP_CUI_VAL   := TRUE;
    v_oc_ind.definition_source    := TRUE;*/
    v_oc_ind.origin               := TRUE;

    BEGIN
      Cg$object_Classes_View_Ext.ins(v_oc_rec,v_oc_ind);
    EXCEPTION WHEN OTHERS THEN
dbms_output.put_line('SQLCODE = '||SQLCODE);
dbms_output.put_line('SQLERRM = '||SQLERRM);
      P_RETURN_CODE := 'API_OC_500'; --Error inserting OBJECT_CLASSES_VIEW_EXT
    END;

  END IF;

  IF (P_ACTION = 'UPD' ) THEN

    --Get the version for the P_oc_IDSEQ
    SELECT version
 INTO v_version
    FROM OBJECT_CLASSES_view_ext
    WHERE oc_idseq = P_oc_IDSEQ;

    IF v_version <> P_oc_VERSION THEN
      P_RETURN_CODE := 'API_OC_402'; -- Version can NOT be updated. It can only be created
      RETURN;
    END IF;

    P_oc_DATE_MODIFIED := TO_CHAR(SYSDATE);
    P_oc_MODIFIED_BY   := ADMIN_SECURITY_UTIL.effective_user;
    P_oc_DELETED_IND   := 'No';

    v_oc_rec.date_modified := TO_DATE(P_oc_DATE_MODIFIED);
    v_oc_rec.modified_by   := P_oc_MODIFIED_BY;
    v_oc_rec.oc_idseq      := P_oc_IDSEQ;
    v_oc_rec.deleted_ind   := 'No';

    v_oc_ind.date_modified := TRUE;
    v_oc_ind.modified_by   := TRUE;
    v_oc_ind.deleted_ind   := TRUE;
    v_oc_ind.End_date      := TRUE;
    v_oc_ind.version       := FALSE;
    v_oc_ind.created_by    := FALSE;
    v_oc_ind.date_created  := FALSE;

    IF P_oc_PREFERRED_NAME IS NULL THEN
      v_oc_ind.preferred_name := FALSE;
    ELSE
      v_oc_rec.preferred_name := P_oc_PREFERRED_NAME;
      v_oc_ind.preferred_name := TRUE;
    END IF;

    IF P_oc_CONTE_IDSEQ IS NULL THEN
      v_oc_ind.conte_idseq := FALSE;
    ELSE
      v_oc_rec.conte_idseq := P_oc_CONTE_IDSEQ;
      v_oc_ind.conte_idseq := TRUE;
    END IF;

    IF P_oc_PREFERRED_DEFINITION IS NULL THEN
      v_oc_ind.preferred_definition := FALSE; /***/
    ELSE
      v_oc_rec.preferred_definition := P_oc_PREFERRED_DEFINITION;
      v_oc_ind.preferred_definition := TRUE;
    END IF;

    IF P_oc_LONG_NAME IS NULL THEN
      v_oc_ind.long_name := FALSE;
    ELSE
      v_oc_rec.long_name := P_oc_LONG_NAME;
      v_oc_ind.long_name := TRUE;
    END IF;

    IF P_oc_ASL_NAME IS NULL THEN
      v_oc_ind.asl_name := FALSE;
    ELSE
      v_oc_rec.asl_name := P_oc_ASL_NAME;
      v_oc_ind.asl_name := TRUE;
    END IF;

    IF P_oc_LATEST_VERSION_IND IS NULL THEN
      v_oc_ind.latest_version_ind := FALSE;
    ELSE
      v_oc_rec.latest_version_ind := P_oc_LATEST_VERSION_IND;
      v_oc_ind.latest_version_ind := TRUE;
    END IF;

    IF P_oc_BEGIN_DATE IS NULL THEN
      v_oc_ind.begin_date := FALSE;
    ELSE
      v_oc_rec.begin_date := TO_DATE(P_oc_BEGIN_DATE);
      v_oc_ind.begin_date := TRUE;
    END IF;

    IF P_oc_END_DATE  IS NULL THEN
      v_oc_ind.end_date := FALSE;
    ELSE
      v_oc_rec.end_date := TO_DATE(P_oc_END_DATE);
      v_oc_ind.end_date := TRUE;
    END IF;

    IF P_oc_CHANGE_NOTE   IS NULL THEN
      v_oc_ind.change_note := FALSE;
    ELSE
      v_oc_rec.change_note := P_oc_CHANGE_NOTE;
      v_oc_ind.change_note := TRUE;
    END IF;

    IF P_OC_DEFINITION_SOURCE IS NULL THEN
      v_oc_ind.definition_source := FALSE;
    ELSE
      v_oc_rec.definition_source := P_OC_DEFINITION_SOURCE;
      v_oc_ind.definition_source := TRUE;
    END IF;

    IF P_OC_ORIGIN IS NULL THEN
      v_oc_ind.origin := FALSE;
    ELSE
      v_oc_rec.origin := P_OC_ORIGIN;
      v_oc_ind.origin := TRUE;
    END IF;

  /*  IF P_oc_DESIG_NCI_CC_TYPE   IS NULL THEN
      v_oc_ind.DESIG_NCI_CC_TYPE := FALSE;
    ELSE
      v_oc_rec.DESIG_NCI_CC_TYPE := P_oc_DESIG_NCI_CC_TYPE;
      v_oc_ind.DESIG_NCI_CC_TYPE := TRUE;
    END IF;

    IF P_oc_DESIG_NCI_CC_VAL   IS NULL THEN
      v_oc_ind.DESIG_NCI_CC_VAL := FALSE;
    ELSE
      v_oc_rec.DESIG_NCI_CC_VAL := P_oc_DESIG_NCI_CC_VAL;
      v_oc_ind.DESIG_NCI_CC_VAL := TRUE;
    END IF;

    IF P_oc_DESIG_UMLS_CUI_TYPE   IS NULL THEN
      v_oc_ind.DESIG_UMLS_CUI_TYPE := FALSE;
    ELSE
      v_oc_rec.DESIG_UMLS_CUI_TYPE := P_oc_DESIG_UMLS_CUI_TYPE;
      v_oc_ind.DESIG_UMLS_CUI_TYPE := TRUE;
    END IF;

    IF P_oc_DESIG_UMLS_CUI_VAL   IS NULL THEN
      v_oc_ind.DESIG_UMLS_CUI_VAL := FALSE;
    ELSE
      v_oc_rec.DESIG_UMLS_CUI_VAL := P_oc_DESIG_UMLS_CUI_VAL;
      v_oc_ind.DESIG_UMLS_CUI_VAL := TRUE;
    END IF;

    IF P_oc_DESIG_TEMP_CUI_TYPE   IS NULL THEN
      v_oc_ind.DESIG_TEMP_CUI_TYPE := FALSE;
    ELSE
      v_oc_rec.DESIG_TEMP_CUI_TYPE := P_oc_DESIG_TEMP_CUI_TYPE;
      v_oc_ind.DESIG_TEMP_CUI_TYPE := TRUE;
    END IF;

    IF P_oc_DESIG_TEMP_CUI_VAL   IS NULL THEN
      v_oc_ind.DESIG_TEMP_CUI_VAL := FALSE;
    ELSE
      v_oc_rec.DESIG_TEMP_CUI_VAL := P_oc_DESIG_TEMP_CUI_VAL;
      v_oc_ind.DESIG_TEMP_CUI_VAL := TRUE;
    END IF;*/

    BEGIN
      Cg$object_Classes_View_Ext.upd(v_oc_rec,v_oc_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_OC_502'; --Error updating OBJECT_CLASS
    END;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;

END SET_OBJECT_CLASS;

PROCEDURE SET_OC_CONDR(
P_OC_con_array           IN VARCHAR2
,P_OC_CONTE_IDSEQ            IN VARCHAR2
,P_RETURN_CODE                OUT VARCHAR2
,P_OC_OC_IDSEQ                OUT VARCHAR2
,P_OC_PREFERRED_NAME        OUT VARCHAR2
,P_OC_LONG_NAME              OUT VARCHAR2
,P_OC_PREFERRED_DEFINITION    OUT VARCHAR2
,P_OC_VERSION             OUT VARCHAR2
,P_OC_ASL_NAME            OUT VARCHAR2
,P_OC_LATEST_VERSION_IND     OUT VARCHAR2
,P_OC_CHANGE_NOTE            OUT VARCHAR2
,P_OC_ORIGIN                OUT VARCHAR2
,P_OC_DEFINITION_SOURCE      OUT VARCHAR2
,P_OC_BEGIN_DATE          OUT VARCHAR2
,P_OC_END_DATE               OUT VARCHAR2
,P_OC_DATE_CREATED            OUT VARCHAR2
,P_OC_CREATED_BY         OUT VARCHAR2
,P_OC_DATE_MODIFIED           OUT VARCHAR2
,P_OC_MODIFIED_BY             OUT VARCHAR2
,P_OC_DELETED_IND             OUT VARCHAR2
,P_OC_CONDR_IDSEQ             OUT VARCHAR2
,P_OC_ID                      OUT VARCHAR2) IS

v_Exists NUMBER;
v_Condr_idseq con_Derivation_rules_ext.condr_idseq%type;
v_Conte_idseq contexts_view.conte_idseq%type;
v_oc_oc_idseq varchar2(36);
BEGIN


  begin
  select conte_idseq into v_CONTE_IDSEQ
  from contexts
  where upper(name) = 'NCIP';	--GF32649
  exception when others then
   P_RETURN_CODE := 'API_PROP_001';
   RETURN;
  end;

v_condr_idseq := sbrext_common_routines.SET_DERIVATION_RULE(p_oc_con_array);

IF NOT Sbrext_Common_Routines.CONDR_EXISTS(v_condr_idseq) THEN
P_RETURN_CODE := 'Concept Derivation Rule does not exist.';
RETURN;
END IF;

IF NOT Sbrext_Common_Routines.CONTEXT_EXISTS(v_conte_idseq) THEN
P_RETURN_CODE := 'Context does not exist.';
RETURN;
END IF;


SELECT COUNT(*) INTO v_exists
FROM OBJECT_CLASSES_EXT
WHERE conte_idseq = v_conte_idseq
AND condr_idseq = v_condr_idseq;

IF v_exists = 0 THEN

Sbrext_Common_Routines.set_oc_rep_prop(v_condr_idseq
,p_return_code
,v_conte_idseq
,'OBJECTCLASS'
,p_oc_oc_idseq
);
ELSE
 begin
    SELECT oc_idseq INTO p_oc_oc_idseq
    FROM OBJECT_CLASSES_EXT
    WHERE conte_idseq = v_conte_idseq
    AND condr_idseq = v_condr_idseq
    AND LATEST_VERSION_IND = 'Yes';
 exception when too_many_rows then

   p_return_Code := sqlerrm;
   return;
 end;
END IF;

IF p_return_code IS NULL THEN
 SELECT PREFERRED_NAME
        ,LONG_NAME
        ,PREFERRED_DEFINITION
        ,VERSION
        ,ASL_NAME
        ,LATEST_VERSION_IND
        ,CHANGE_NOTE
        ,ORIGIN
        ,DEFINITION_SOURCE
        ,BEGIN_DATE
        ,END_DATE
        ,DATE_CREATED
        ,CREATED_BY
        ,DATE_MODIFIED
       ,MODIFIED_BY
        ,DELETED_IND
  ,CONDR_IDSEQ
  ,OC_ID
     INTO
    P_OC_PREFERRED_NAME
    ,P_OC_LONG_NAME
    ,P_OC_PREFERRED_DEFINITION
    ,P_OC_VERSION
    ,P_OC_ASL_NAME
    ,P_OC_LATEST_VERSION_IND
    ,P_OC_CHANGE_NOTE
    ,P_OC_ORIGIN
    ,P_OC_DEFINITION_SOURCE
    ,P_OC_BEGIN_DATE
    ,P_OC_END_DATE
    ,P_OC_DATE_CREATED
    ,P_OC_CREATED_BY
    ,P_OC_DATE_MODIFIED
    ,P_OC_MODIFIED_BY
    ,P_OC_DELETED_IND
    ,P_OC_CONDR_IDSEQ
    ,P_OC_ID
 FROM OBJECT_CLASSES_EXT
 WHERE oc_idseq = p_oc_oc_idseq;

END IF;


EXCEPTION WHEN OTHERS THEN

 dbms_output.put_line(8);
P_RETURN_CODE := SUBSTR(sqlerrm,1,255);
END;


PROCEDURE SET_PROP_CONDR(
P_PROP_con_array           IN VARCHAR2
,P_PROP_CONTE_IDSEQ            IN VARCHAR2
,P_RETURN_CODE                OUT VARCHAR2
,P_PROP_PROP_IDSEQ                OUT VARCHAR2
,P_PROP_PREFERRED_NAME        OUT VARCHAR2
,P_PROP_LONG_NAME              OUT VARCHAR2
,P_PROP_PREFERRED_DEFINITION    OUT VARCHAR2
,P_PROP_VERSION             OUT VARCHAR2
,P_PROP_ASL_NAME            OUT VARCHAR2
,P_PROP_LATEST_VERSION_IND     OUT VARCHAR2
,P_PROP_CHANGE_NOTE            OUT VARCHAR2
,P_PROP_ORIGIN                OUT VARCHAR2
,P_PROP_DEFINITION_SOURCE      OUT VARCHAR2
,P_PROP_BEGIN_DATE          OUT VARCHAR2
,P_PROP_END_DATE               OUT VARCHAR2
,P_PROP_DATE_CREATED            OUT VARCHAR2
,P_PROP_CREATED_BY         OUT VARCHAR2
,P_PROP_DATE_MODIFIED           OUT VARCHAR2
,P_PROP_MODIFIED_BY             OUT VARCHAR2
,P_PROP_DELETED_IND             OUT VARCHAR2
,P_PROP_CONDR_IDSEQ             OUT VARCHAR2
,P_PROP_ID             OUT VARCHAR2) IS

v_Exists number;
v_Condr_idseq con_Derivation_rules_ext.condr_idseq%type;
v_Conte_idseq contexts_view.conte_idseq%type;
BEGIN


  begin
  select conte_idseq into v_CONTE_IDSEQ
  from contexts
  where upper(name) = 'NCIP';	--GF32649
  exception when others then
   P_RETURN_CODE := 'API_PROP_001';
   RETURN;
  end;
v_condr_idseq := sbrext_common_routines.SET_DERIVATION_RULE(p_prop_con_array);
dbms_output.put_line('v_condr_idseq: '||v_condr_idseq);

IF NOT Sbrext_Common_Routines.CONDR_EXISTS(v_condr_idseq) THEN
P_RETURN_CODE := 'Concept Derivation Rule does not exist.';
RETURN;
END IF;

IF NOT Sbrext_Common_Routines.CONTEXT_EXISTS(v_conte_idseq) THEN
P_RETURN_CODE := 'Context does not exist.';
RETURN;
END IF;

SELECT COUNT(*) INTO v_Exists
FROM PROPERTIES_EXT
WHERE conte_idseq = v_conte_idseq
AND condr_idseq = v_condr_idseq;

dbms_output.put_line('v_Exists: '||to_char(v_exists));

IF v_exists = 0 THEN
dbms_output.put_line('***');
dbms_output.put_line('v_condr_idseq: '||v_condr_idseq);
dbms_output.put_line('v_conte_idseq: '||v_conte_idseq);
dbms_output.put_line('***');

Sbrext_Common_Routines.set_oc_rep_prop(v_condr_idseq
,p_return_code
,v_conte_idseq
,'PROPERTY'
,p_PROP_PROP_idseq
);
  dbms_output.put_line('p return code 01: '||p_return_code);
ELSE
  begin
    SELECT prop_idseq INTO p_prop_prop_idseq
    FROM PROPERTIES_EXT
    WHERE conte_idseq = v_conte_idseq
    AND condr_idseq = v_condr_idseq
    AND LATEST_VERSION_IND = 'Yes';
 dbms_output.put_line('p_prop_prop_idseq: '||p_prop_prop_idseq);
 exception when too_many_rows then
   p_return_Code := sqlerrm;
   return;
 end;
END IF;
dbms_output.put_line('p_return_code 02: '||p_return_code);
IF p_return_code IS NULL THEN
 SELECT PREFERRED_NAME
        ,LONG_NAME
        ,PREFERRED_DEFINITION
        ,VERSION
        ,ASL_NAME
        ,LATEST_VERSION_IND
        ,CHANGE_NOTE
        ,ORIGIN
        ,DEFINITION_SOURCE
        ,BEGIN_DATE
        ,END_DATE
        ,DATE_CREATED
        ,CREATED_BY
        ,DATE_MODIFIED
        ,MODIFIED_BY
        ,DELETED_IND
  ,condr_idseq
  ,prop_id
     INTO
    P_PROP_PREFERRED_NAME
    ,P_PROP_LONG_NAME
    ,P_PROP_PREFERRED_DEFINITION
    ,P_PROP_VERSION
    ,P_PROP_ASL_NAME
    ,P_PROP_LATEST_VERSION_IND
    ,P_PROP_CHANGE_NOTE
    ,P_PROP_ORIGIN
    ,P_PROP_DEFINITION_SOURCE
    ,P_PROP_BEGIN_DATE
    ,P_PROP_END_DATE
    ,P_PROP_DATE_CREATED
    ,P_PROP_CREATED_BY
    ,P_PROP_DATE_MODIFIED
    ,P_PROP_MODIFIED_BY
    ,P_PROP_DELETED_IND
    ,P_PROP_CONDR_IDSEQ
    ,P_PROP_ID
 FROM PROPERTIES_EXT
 WHERE PROP_idseq = p_PROP_PROP_idseq;
END IF;
EXCEPTION WHEN OTHERS THEN
P_RETURN_CODE := 'Error Creating Property';

END;
PROCEDURE SET_CONCEPT(
P_RETURN_CODE              OUT VARCHAR2
,P_ACTION         IN VARCHAR2
,P_CON_IDSEQ             OUT VARCHAR2
,P_CON_PREFERRED_NAME   IN OUT VARCHAR2
,P_CON_LONG_NAME               IN OUT VARCHAR2
,P_CON_PREFERRED_DEFINITION    IN OUT VARCHAR2
,P_CON_CONTE_IDSEQ         IN OUT VARCHAR2
,P_CON_VERSION         IN OUT VARCHAR2
,P_CON_ASL_NAME        IN OUT VARCHAR2
,P_CON_LATEST_VERSION_IND   IN OUT VARCHAR2
,P_CON_CHANGE_NOTE      IN OUT VARCHAR2
,P_CON_ORIGIN   IN OUT VARCHAR2
,P_CON_DEFINITION_SOURCE      IN OUT VARCHAR2
,P_CON_EVS_SOURCE      IN OUT VARCHAR2
,P_CON_BEGIN_DATE      IN OUT VARCHAR2
,P_CON_END_DATE                IN OUT VARCHAR2
,P_CON_DATE_CREATED            OUT VARCHAR2
,P_CON_CREATED_BY       OUT VARCHAR2
,P_CON_DATE_MODIFIED           OUT VARCHAR2
,P_CON_MODIFIED_BY             OUT VARCHAR2
,P_CON_DELETED_IND             OUT VARCHAR2)
IS
/******************************************************************************
   NAME:       SET_CONCEPT
   PURPOSE:    Inserts or Updates a Single Row Of concepts_ext based on either


   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
  3.0      12/09/2004     Prerna Aggarwal       1. Created this procedure

******************************************************************************/


v_con_rec  Cg$concepts_View_Ext.cg$row_type;
v_con_ind  Cg$concepts_View_Ext.cg$ind_type;

v_begin_date   DATE    := NULL;
v_end_date     DATE    := NULL;
v_new_Version  BOOLEAN := FALSE;

v_version  concepts_view_ext.version%TYPE;
v_asl_name concepts_view_ext.asl_name%TYPE;

v_Count number;
v_conte_idseq contexts.conte_idseq%type;

BEGIN

  P_RETURN_CODE := NULL;

  IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
    P_RETURN_CODE := 'API_CON_700'; -- Invalid action
    RETURN;
  END IF;

  IF P_ACTION = 'INS' THEN              --we are inserting a record
    IF P_CON_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_CON_100' ;  --for inserts the ID IS generated
   RETURN;
    ELSE
      --Check to see that all mandatory parameters are not null
   IF P_CON_PREFERRED_NAME IS NULL THEN
     P_RETURN_CODE := 'API_CON_102'; --PREFERRED_NAME cannot be null here
  RETURN;
   END IF;
   IF P_CON_PREFERRED_DEFINITION IS NULL THEN
     P_RETURN_CODE := 'API_CON_104'; --PREFERRED_DEFINITION cannot be null here
  RETURN;
   END IF;
   begin
    select conte_idseq into p_Con_Conte_idseq
    from contexts
    where upper(name) = 'NCIP';	--GF32649
   exception when no_data_found then
     P_RETURN_CODE := 'API_CON_106';  --CONTEXT_NAME cannot be null here
  RETURN;
  end;
    END IF;
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are deleting a record

    IF P_CON_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_CON_400' ;  --for deleted the ID idmandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ac_exists(P_CON_IDSEQ) THEN
     P_RETURN_CODE := 'API_CON_005'; --PROPERTY not found
     RETURN;
   END IF;
    END IF;

    P_CON_DELETED_IND   := 'Yes';
    P_CON_MODIFIED_BY   := 'USER';
    P_CON_DATE_MODIFIED := TO_CHAR(SYSDATE);

    v_con_rec.con_idseq         := P_CON_IDSEQ;
    v_con_rec.deleted_ind        := P_CON_DELETED_IND;
    v_con_rec.modified_by        := P_CON_MODIFIED_BY;
    v_con_rec.date_modified      := TO_DATE(P_CON_DATE_MODIFIED);
    v_con_rec.latest_version_ind := P_CON_LATEST_VERSION_IND;

    v_con_ind.con_idseq         := TRUE;
    v_con_ind.preferred_name     := FALSE;
    v_con_ind.conte_idseq         := FALSE;
    v_con_ind.version             := FALSE;
    v_con_ind.preferred_definition := FALSE;
    v_con_ind.long_name         := FALSE;
    v_con_ind.asl_name             := FALSE;
    v_con_ind.latest_version_ind   := FALSE;
    v_con_ind.begin_date         := FALSE;
    v_con_ind.end_date             := FALSE;
    v_con_ind.change_note         := FALSE;
    v_con_ind.created_by         := FALSE;
    v_con_ind.date_created         := FALSE;
 v_con_ind.origin               := FALSE;  -- 23-Jul-2003, W. Ver Hoef
    v_con_ind.modified_by         := TRUE;
    v_con_ind.date_modified     := TRUE;
    v_con_ind.deleted_ind          := TRUE;

    BEGIN
      Cg$concepts_View_Ext.upd(v_con_rec,v_con_ind);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_CON_501'; --Error deleteing PROPERTY
    END;

  END IF;

  IF P_ACTION = 'UPD' THEN              --we are updating a record
    IF P_CON_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_CON_400' ;  --for updates the ID IS mandatory
   RETURN;
    END IF;
    SELECT asl_name
    INTO   v_asl_name
    FROM   CONCEPTS_EXT
    WHERE  con_idseq = p_con_idseq;
    IF (P_CON_PREFERRED_NAME IS NOT NULL OR P_CON_CONTE_IDSEQ IS NOT NULL) AND v_asl_name = 'RELEASED' THEN
      P_RETURN_CODE := 'API_CON_401' ;  --Preferred Name or Context Can not be updated
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(P_CON_IDSEQ) THEN
      P_RETURN_CODE := 'API_CON_005'; --CON_IDSEQ not found
      RETURN;
    END IF;
  END IF;

  IF P_CON_LATEST_VERSION_IND IS NOT NULL THEN
    IF P_CON_LATEST_VERSION_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_CON_105'; --Version can only be 'Yes' or 'No'
      RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
  IF LENGTH(P_CON_PREFERRED_NAME) > Sbrext_Column_Lengths.L_CON_PREFERRED_NAME THEN
    P_RETURN_CODE := 'API_CON_111';  --Length of preferred_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_CON_PREFERRED_DEFINITION) > Sbrext_Column_Lengths.L_CON_PREFERRED_DEFINITION THEN
    P_RETURN_CODE := 'API_CON_113';  --Length of Preferred_definition exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_CON_LONG_NAME) > Sbrext_Column_Lengths.L_CON_LONG_NAME THEN
    P_RETURN_CODE := 'API_CON_114'; --Length of Long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_CON_ASL_NAME) > Sbrext_Column_Lengths.L_CON_ASL_NAME  THEN
    P_RETURN_CODE := 'API_CON_115'; --Length of asl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_CON_CHANGE_NOTE) > Sbrext_Column_Lengths.L_CON_CHANGE_NOTE THEN
    P_RETURN_CODE := 'API_CON_128'; --Length of change_note exceeds maximum length
    RETURN;
  END IF;

  IF LENGTH(P_CON_ORIGIN) > sbrext_column_lengths.L_CON_ORIGIN THEN
    P_RETURN_CODE := 'API_CON_129'; --Length of origin exceeds maximum length
    RETURN;
  END IF;

  IF LENGTH(P_CON_DEFINITION_SOURCE) > sbrext_column_lengths.L_CON_ORIGIN THEN
    P_RETURN_CODE := 'API_CON_141'; --Length of definition_source exceeds maximum length
    RETURN;
  END IF;

  IF LENGTH(P_CON_EVS_SOURCE) > sbrext_column_lengths.L_CON_EVS_SOURCE THEN
    P_RETURN_CODE := 'API_CON_142'; --Length of evs_source exceeds maximum length
    RETURN;
  END IF;

  --check to see that charachter strings are valid
  IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_CON_PREFERRED_NAME) THEN
    P_RETURN_CODE := 'API_CON_130'; -- Data Element Preferred Name has invalid Ccharacters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_CON_PREFERRED_DEFINITION) THEN
    P_RETURN_CODE := 'API_CON_133'; -- Data Element Preferred Definition has invalid characters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_CON_LONG_NAME) THEN
    P_RETURN_CODE := 'API_CON_134'; -- Data Element Long Name has invalid characters
    RETURN;
  END IF;

  --check to see that Context, Workflow Status, Data Element Concept, Value Domain already exist in the database
  IF P_CON_CONTE_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.context_exists(P_CON_CONTE_IDSEQ) THEN
      P_RETURN_CODE := 'API_CON_200'; --Context not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_CON_ASL_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.workflow_exists(P_CON_ASL_NAME) THEN
      P_RETURN_CODE := 'API_CON_202'; --Workflow Status not found in the database
      RETURN;
    END IF;
  END IF;

  --check to see that begin data and end date are valid dates
  IF(P_CON_BEGIN_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_CON_BEGIN_DATE,v_begin_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_CON_600'; --begin date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_CON_END_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_CON_END_DATE,v_end_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_CON_601'; --end date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_CON_BEGIN_DATE IS NOT NULL AND P_CON_END_DATE IS NOT NULL) THEN
    IF(v_end_date < v_begin_date) THEN
      P_RETURN_CODE := 'API_CON_210'; --end date is before begin date
      RETURN;
    END IF;
  ELSIF(P_CON_END_DATE IS NOT NULL AND P_CON_BEGIN_DATE IS NULL) THEN
    P_RETURN_CODE := 'API_CON_211'; --begin date cannot be null when end date is null
    RETURN;
  END IF;

  IF (P_ACTION = 'INS' ) THEN

    P_CON_IDSEQ         := admincomponent_crud.cmr_guid;
    P_CON_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_CON_CREATED_BY    := ADMIN_SECURITY_UTIL.effective_user;
    P_CON_DATE_MODIFIED := NULL;
    P_CON_MODIFIED_BY   := NULL;
    IF P_CON_VERSION IS NULL THEN
      P_CON_VERSION := 1;
    END IF;
    IF P_CON_ASL_NAME IS NULL THEN
   -- 19-Mar-2004, W. Ver Hoef - substituted UNASSIGNED with function call below
      P_CON_ASL_NAME := Sbrext_Common_Routines.get_default_asl('INS'); -- 'UNASSIGNED';
    END IF;

 select count(*) into v_count
 from concepts_Ext
 where preferred_name = p_CON_PREFERRED_NAME
 and version = p_con_Version
 and conte_idseq = p_con_conte_idseq;

 if v_count <> 0 then
   P_RETURN_CODE := 'API_CON_550'; -- unique constraint violeted;
   RETURN;
 end if;



    v_con_rec.con_idseq           := P_CON_IDSEQ;
    v_con_rec.preferred_name       := P_CON_PREFERRED_NAME;
    v_con_rec.PREFERRED_DEFINITION := P_CON_PREFERRED_DEFINITION;
    v_con_rec.created_by         := ADMIN_SECURITY_UTIL.effective_user;
    v_con_rec.date_created         := SYSDATE;
    v_con_rec.modified_by         := NULL;
    v_con_rec.date_modified        := NULL;
    v_con_rec.long_name            := P_CON_LONG_NAME;
    v_con_rec.conte_idseq          := P_CON_CONTE_IDSEQ;
    v_con_rec.version              := P_CON_VERSION;
    v_con_rec.asl_name             := P_CON_ASL_NAME;
    v_con_rec.latest_version_ind   := 'Yes';
    v_con_rec.change_note          := NULL;
    v_con_rec.begin_date           := SYSDATE; --GF32724
    v_con_rec.end_date             := NULL;
    v_con_rec.deleted_ind          := 'No';
    v_con_rec.definition_source    := P_CON_DEFINITION_SOURCE;
    v_con_rec.origin               := P_CON_ORIGIN;
    v_con_rec.evs_Source           := P_CON_EVS_SOURCE ;

    v_con_ind.con_idseq           := TRUE;
    v_con_ind.preferred_name       := TRUE;
    v_con_ind.PREFERRED_DEFINITION := TRUE;
    v_con_ind.created_by           := TRUE;
    v_con_ind.date_created         := TRUE;
    v_con_ind.modified_by         := TRUE;
    v_con_ind.date_modified        := TRUE;
    v_con_ind.long_name            := TRUE;
    v_con_ind.conte_idseq          := TRUE;
    v_con_ind.version              := TRUE;
    v_con_ind.asl_name             := TRUE;
    v_con_ind.latest_version_ind   := TRUE;
    v_con_ind.change_note          := TRUE;
    v_con_ind.begin_date           := TRUE;
    v_con_ind.end_date             := TRUE;
    v_con_ind.deleted_ind          := TRUE;
    v_con_ind.definition_source    := TRUE;
    v_con_ind.origin               := TRUE;
    v_con_ind.evs_source    := TRUE;
    BEGIN
      Cg$concepts_View_Ext.ins(v_con_rec,v_con_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := SQLERRM; --Error inserting CONCEPTS_VIEW_EXT
    END;

  END IF;

  IF (P_ACTION = 'UPD' ) THEN

    --Get the version for the P_CON_IDSEQ
    SELECT version
 INTO   v_version
    FROM   concepts_view_ext
    WHERE  con_idseq = P_CON_IDSEQ;

    IF v_version <> P_CON_VERSION THEN
      P_RETURN_CODE := 'API_CON_402'; -- Version can NOT be updated. It can only be created
      RETURN;
    END IF;

    P_CON_DATE_MODIFIED := TO_CHAR(SYSDATE);
    P_CON_MODIFIED_BY := ADMIN_SECURITY_UTIL.effective_user;
    P_CON_DELETED_IND := 'No';

    v_con_rec.date_modified := TO_DATE(P_CON_DATE_MODIFIED);
    v_con_rec.modified_by   := P_CON_MODIFIED_BY;
    v_con_rec.con_idseq    := P_CON_IDSEQ;
    v_con_rec.deleted_ind   := 'No';

    v_con_ind.date_modified := TRUE;
    v_con_ind.modified_by   := TRUE;
    v_con_ind.deleted_ind   := TRUE;
    v_con_ind.con_idseq    := TRUE;

    v_con_ind.version       := FALSE;
    v_con_ind.created_by  := FALSE;
    v_con_ind.date_created  := FALSE;

    IF P_CON_PREFERRED_NAME IS NULL THEN
      v_con_ind.preferred_name := FALSE;
    ELSE
      v_con_rec.preferred_name := P_CON_PREFERRED_NAME;
      v_con_ind.preferred_name := TRUE;
    END IF;

    IF P_CON_CONTE_IDSEQ IS NULL THEN
      v_con_ind.conte_idseq := FALSE;
    ELSE
      v_con_rec.conte_idseq := P_CON_CONTE_IDSEQ;
      v_con_ind.conte_idseq := TRUE;
    END IF;

    IF P_CON_PREFERRED_DEFINITION IS NULL THEN
      v_con_ind.preferred_definition := FALSE; /***/
    ELSE
      v_con_rec.preferred_definition := P_CON_PREFERRED_DEFINITION;
      v_con_ind.preferred_definition := TRUE;
    END IF;

    IF P_CON_LONG_NAME IS NULL THEN
      v_con_ind.long_name := FALSE;
    ELSE
      v_con_rec.long_name := P_CON_LONG_NAME;
      v_con_ind.long_name := TRUE;
    END IF;

    IF P_CON_ASL_NAME IS NULL THEN
      v_con_ind.asl_name := FALSE;
    ELSE
      v_con_rec.asl_name := P_CON_ASL_NAME;
      v_con_ind.asl_name := TRUE;
    END IF;

    IF P_CON_LATEST_VERSION_IND IS NULL THEN
      v_con_ind.latest_version_ind := FALSE;
    ELSE
      v_con_rec.latest_version_ind := P_CON_LATEST_VERSION_IND;
      v_con_ind.latest_version_ind := TRUE;
    END IF;

    IF P_CON_BEGIN_DATE IS NULL THEN
      v_con_ind.begin_date := FALSE;
    ELSE
      v_con_rec.begin_date := TO_DATE(P_CON_BEGIN_DATE);
      v_con_ind.begin_date := TRUE;
    END IF;

    IF P_CON_END_DATE  IS NULL THEN
      v_con_ind.end_date := FALSE;
    ELSE
      v_con_rec.end_date := TO_DATE(P_CON_END_DATE);
      v_con_ind.end_date := TRUE;
    END IF;

    IF P_CON_CHANGE_NOTE   IS NULL THEN
      v_con_ind.change_note := FALSE;
    ELSE
      v_con_rec.change_note := P_CON_CHANGE_NOTE;
      v_con_ind.change_note := TRUE;
    END IF;

    IF P_CON_DEFINITION_SOURCE IS NULL THEN
      v_con_ind.definition_source := FALSE;
    ELSE
      v_con_rec.definition_source := P_CON_DEFINITION_SOURCE;
      v_con_ind.definition_source := TRUE;
    END IF;

    IF P_CON_ORIGIN IS NULL THEN
      v_con_ind.origin := FALSE;
    ELSE
      v_con_rec.origin := P_CON_ORIGIN;
      v_con_ind.origin := TRUE;
    END IF;

    IF P_CON_EVS_SOURCE   IS NULL THEN
      v_con_ind.evs_source := FALSE;
    ELSE
      v_con_rec.evs_source := P_CON_EVS_SOURCE;
      v_con_ind.evs_source := TRUE;
    END IF;
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;

END SET_CONCEPT;

PROCEDURE SET_representation(
 P_RETURN_CODE                  OUT VARCHAR2
,P_ACTION                    IN     VARCHAR2
,P_REP_IDSEQ             IN OUT VARCHAR2
,P_REP_PREFERRED_NAME        IN OUT VARCHAR2
,P_REP_LONG_NAME             IN OUT VARCHAR2
,P_REP_PREFERRED_DEFINITION  IN OUT VARCHAR2
,P_REP_CONTE_IDSEQ           IN OUT VARCHAR2
,P_REP_VERSION               IN OUT VARCHAR2
,P_REP_ASL_NAME              IN OUT VARCHAR2
,P_REP_LATEST_VERSION_IND    IN OUT VARCHAR2
,P_REP_CHANGE_NOTE           IN OUT VARCHAR2
,P_REP_ORIGIN                IN OUT VARCHAR2
,P_REP_DEFINITION_SOURCE     IN OUT VARCHAR2
,P_REP_BEGIN_DATE            IN OUT VARCHAR2
,P_REP_END_DATE              IN OUT VARCHAR2
,P_REP_DATE_CREATED             OUT VARCHAR2
,P_REP_CREATED_BY               OUT VARCHAR2
,P_REP_DATE_MODIFIED            OUT VARCHAR2
,P_REP_MODIFIED_BY              OUT VARCHAR2
,P_REP_DELETED_IND              OUT VARCHAR2
,P_REP_DESIG_NCI_CC_TYPE     IN     VARCHAR2
,P_REP_DESIG_NCI_CC_VAL      IN     VARCHAR2
,P_REP_DESIG_UMLS_CUI_TYPE   IN     VARCHAR2
,P_REP_DESIG_UMLS_CUI_VAL    IN     VARCHAR2
,P_REP_DESIG_TEMP_CUI_TYPE   IN     VARCHAR2
,P_REP_DESIG_TEMP_CUI_VAL    IN     VARCHAR2
)
IS
/******************************************************************************
   NAME:       SET_representation
   PURPOSE:    Inserts or Updates a Single Row Of reperties_ext based on either


   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04/08/2003  Prerna Aggarwal  1. Created this procedure
   2.0        07/10/2003  W. Ver Hoef      1. Edited for readability but changes
                                              required for SPRF_2.0_15 have already
             been made to sbrext_common_routines
             valid_alphanumeric and valid_char.
   2.0        07/23/2003  W. Ver Hoef      1. added v_rep_ind.origin := FALSE
                                              for DEL action
   2.1        03/19/2004  W. Ver Hoef      1. substituted UNASSIGNED with function
                                              call to get_default_asl

******************************************************************************/

v_rep_rec  Cg$representations_View_Ext.cg$row_type;
v_rep_ind  Cg$representations_View_Ext.cg$ind_type;

v_begin_date   DATE := NULL;
v_end_date     DATE := NULL;
v_new_Version  BOOLEAN := FALSE;

v_version   representations_view_ext.version%TYPE;
v_asl_name  representations_view_ext.asl_name%TYPE;

BEGIN
  P_RETURN_CODE := NULL;


  IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
    P_RETURN_CODE := 'API_REP_700'; -- Invalid action
    RETURN;
  END IF;

  IF P_ACTION = 'INS' THEN              --we are inserting a record
    IF P_REP_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_REP_100' ;  --for inserts the ID IS generated
   RETURN;
    ELSE
      --Check to see that all mandatory parameters are not null
   IF P_REP_PREFERRED_NAME IS NULL THEN
     P_RETURN_CODE := 'API_REP_102'; --PREFERRED_NAME cannot be null here
  RETURN;
   END IF;
   IF P_REP_PREFERRED_DEFINITION IS NULL THEN
     P_RETURN_CODE := 'API_REP_104'; --PREFERRED_DEFINITION cannot be null here
  RETURN;
   END IF;
   IF P_REP_CONTE_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_REP_106';  --CONTEXT_NAME cannot be null here
  RETURN;
   END IF;
    END IF;
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are deleting a record

    IF P_REP_IDSEQ IS NULL THEN
      P_RETURN_CODE := 'API_REP_400' ;  --for deleting the ID is mandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ac_exists(P_REP_IDSEQ) THEN
     P_RETURN_CODE := 'API_REP_005'; --representation not found
     RETURN;
   END IF;
    END IF;

    P_REP_DELETED_IND            := 'Yes';
    P_REP_MODIFIED_BY            := 'USER';
    P_REP_DATE_MODIFIED          := TO_CHAR(SYSDATE);

    v_rep_rec.rep_idseq          := P_REP_IDSEQ;
    v_rep_rec.deleted_ind        := P_REP_DELETED_IND;
    v_rep_rec.modified_by        := P_REP_MODIFIED_BY;
    v_rep_rec.date_modified      := TO_DATE(P_REP_DATE_MODIFIED);
    v_rep_rec.latest_version_ind := P_REP_LATEST_VERSION_IND;

    v_rep_ind.rep_idseq            := TRUE;
    v_rep_ind.preferred_name       := FALSE;
    v_rep_ind.conte_idseq          := FALSE;
    v_rep_ind.version              := FALSE;
    v_rep_ind.preferred_definition := FALSE;
    v_rep_ind.long_name            := FALSE;
    v_rep_ind.asl_name             := FALSE;
    v_rep_ind.latest_version_ind   := FALSE;
    v_rep_ind.begin_date           := FALSE;
    v_rep_ind.end_date             := FALSE;
    v_rep_ind.change_note          := FALSE;
    v_rep_ind.created_by           := FALSE;
    v_rep_ind.date_created         := FALSE;
 v_rep_ind.origin               := FALSE; -- 23-Jul-2003, W. Ver Hoef
    v_rep_ind.modified_by          := TRUE;
    v_rep_ind.date_modified        := TRUE;
    v_rep_ind.deleted_ind          := TRUE;

    BEGIN
      Cg$representations_View_Ext.upd(v_rep_rec,v_rep_ind);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
dbms_output.put_line('SQLERRM = '||SQLERRM);
      P_RETURN_CODE := 'API_REP_501'; --Error deleteing representation
    END;

  END IF;

  IF P_ACTION = 'UPD' THEN              --we are updating a record
    IF P_REP_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_REP_400' ;  --for updates the ID IS mandatory
   RETURN;
    END IF;
    SELECT asl_name
 INTO v_asl_name
    FROM representations_view_ext
    WHERE rep_idseq = p_rep_idseq;
    IF (P_REP_PREFERRED_NAME IS NOT NULL OR P_REP_CONTE_IDSEQ IS NOT NULL) AND v_Asl_name = 'RELEASED' THEN
      P_RETURN_CODE := 'API_REP_401' ;  --Preferred Name or Context Can not be updated
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(P_REP_IDSEQ) THEN
      P_RETURN_CODE := 'API_REP_005'; --rep_IDSEQ not found
      RETURN;
    END IF;
  END IF;

  IF P_REP_LATEST_VERSION_IND IS NOT NULL THEN
    IF P_REP_LATEST_VERSION_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_REP_105'; --Version can only be 'Yes' or 'No'
      RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and VARCHAR2 parameters have correct length
  IF LENGTH(P_REP_PREFERRED_NAME) > Sbrext_Column_Lengths.L_REP_PREFERRED_NAME THEN
    P_RETURN_CODE := 'API_REP_111';  --Length of preferred_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_REP_PREFERRED_DEFINITION) > Sbrext_Column_Lengths.L_REP_PREFERRED_DEFINITION THEN
    P_RETURN_CODE := 'API_REP_113';  --Length of Preferred_definition exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_REP_LONG_NAME) > Sbrext_Column_Lengths.L_REP_LONG_NAME THEN
    P_RETURN_CODE := 'API_REP_114'; --Length of Long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_REP_ASL_NAME) > Sbrext_Column_Lengths.L_REP_ASL_NAME  THEN
    P_RETURN_CODE := 'API_REP_115'; --Length of asl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_REP_CHANGE_NOTE) > Sbrext_Column_Lengths.L_REP_CHANGE_NOTE THEN
    P_RETURN_CODE := 'API_REP_128'; --Length of change_note exceeds maximum length
    RETURN;
  END IF;

  --check to see that charachter strings are valid
  IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_REP_PREFERRED_NAME) THEN
    P_RETURN_CODE := 'API_REP_130'; -- Data Element Preferred Name has invalid Ccharacters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_REP_PREFERRED_DEFINITION) THEN
    P_RETURN_CODE := 'API_REP_133'; -- Data Element Preferred Definition has invalid characters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_REP_LONG_NAME) THEN
    P_RETURN_CODE := 'API_REP_134'; -- Data Element Long Name has invalid characters
    RETURN;
  END IF;

  --check to see that Context, Workflow Status, Data Element Concept, Value Domain already exist in the database
  IF P_REP_CONTE_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.context_exists(P_REP_CONTE_IDSEQ) THEN
      P_RETURN_CODE := 'API_REP_200'; --Context not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_REP_ASL_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.workflow_exists(P_REP_ASL_NAME) THEN
      P_RETURN_CODE := 'API_REP_202'; --Workflow Status not found in the database
      RETURN;
    END IF;
  END IF;

  --check to see that begin data and end date are valid dates
  IF(P_REP_BEGIN_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_REP_BEGIN_DATE,v_begin_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_REP_600'; --begin date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_REP_END_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_REP_END_DATE,v_end_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_REP_601'; --end date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_REP_BEGIN_DATE IS NOT NULL AND P_REP_END_DATE IS NOT NULL) THEN
    IF(v_end_date < v_begin_date) THEN
      P_RETURN_CODE := 'API_REP_210'; --end date is before begin date
      RETURN;
    END IF;
  ELSIF(P_REP_END_DATE IS NOT NULL AND P_REP_BEGIN_DATE IS NULL) THEN
    P_RETURN_CODE := 'API_REP_211'; --begin date cannot be null when end date is null
    RETURN;
  END IF;

  IF (P_ACTION = 'INS' ) THEN

    P_REP_IDSEQ         := admincomponent_crud.cmr_guid;
    P_REP_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_REP_CREATED_BY    := ADMIN_SECURITY_UTIL.effective_user;
    P_REP_DATE_MODIFIED := NULL;
    P_REP_MODIFIED_BY   := NULL;

    IF P_REP_VERSION IS NULL THEN
      P_REP_VERSION := 1;
    END IF;
    IF P_REP_ASL_NAME IS NULL THEN
   -- 19-Mar-2004, W. Ver Hoef - substituted UNASSIGNED with function call below
      P_REP_ASL_NAME := Sbrext_Common_Routines.get_default_asl('INS'); -- 'UNASSIGNED';
    END IF;

    v_rep_rec.rep_idseq            := P_REP_IDSEQ;
    v_rep_rec.preferred_name       := P_REP_PREFERRED_NAME;
    v_rep_rec.PREFERRED_DEFINITION := P_REP_PREFERRED_DEFINITION;
    v_rep_rec.created_by        := ADMIN_SECURITY_UTIL.effective_user;
    v_rep_rec.date_created        := SYSDATE;
    v_rep_rec.modified_by        := NULL;
    v_rep_rec.date_modified        := NULL;
    v_rep_rec.long_name            := P_REP_LONG_NAME;
    v_rep_rec.conte_idseq          := P_REP_CONTE_IDSEQ;
    v_rep_rec.version              := P_REP_VERSION;
    v_rep_rec.asl_name             := P_REP_ASL_NAME;
    v_rep_rec.latest_version_ind   := 'Yes';
    v_rep_rec.change_note          := NULL;
    v_rep_rec.begin_date           := NULL;
    v_rep_rec.end_date             := NULL;
    v_rep_rec.deleted_ind          := 'No';
    /*v_rep_rec.DESIG_NCI_CC_TYPE    := P_rep_DESIG_NCI_CC_TYPE ;
    v_rep_rec.DESIG_NCI_CC_VAL     := P_rep_DESIG_NCI_CC_VAL ;
    v_rep_rec.DESIG_UMLS_CUI_TYPE  := P_rep_DESIG_UMLS_CUI_TYPE ;
    v_rep_rec.DESIG_UMLS_CUI_VAL   := P_rep_DESIG_UMLS_CUI_VAL ;
    v_rep_rec.DESIG_TEMP_CUI_TYPE  := P_rep_DESIG_TEMP_CUI_TYPE ;
    v_rep_rec.DESIG_TEMP_CUI_VAL   := P_rep_DESIG_TEMP_CUI_VAL ;
    v_rep_rec.definition_source    := P_REP_DEFINITION_SOURCE;*/
    v_rep_rec.origin               := P_REP_ORIGIN;

    v_rep_ind.rep_idseq            := TRUE;
    v_rep_ind.preferred_name       := TRUE;
    v_rep_ind.PREFERRED_DEFINITION := TRUE;
    v_rep_ind.created_by           := TRUE;
    v_rep_ind.date_created         := TRUE;
    v_rep_ind.modified_by          := TRUE;
    v_rep_ind.date_modified        := TRUE;
    v_rep_ind.long_name            := TRUE;
    v_rep_ind.conte_idseq          := TRUE;
    v_rep_ind.version              := TRUE;
    v_rep_ind.asl_name             := TRUE;
    v_rep_ind.latest_version_ind   := TRUE;
    v_rep_ind.change_note          := TRUE;
    v_rep_ind.begin_date           := TRUE;
    v_rep_ind.end_date             := TRUE;
    v_rep_ind.deleted_ind          := TRUE;
   /* v_rep_ind.DESIG_NCI_CC_TYPE    := TRUE;
    v_rep_ind.DESIG_NCI_CC_VAL     := TRUE;
    v_rep_ind.DESIG_UMLS_CUI_TYPE  := TRUE;
    v_rep_ind.DESIG_UMLS_CUI_VAL   := TRUE;
    v_rep_ind.DESIG_TEMP_CUI_TYPE  := TRUE;
    v_rep_ind.DESIG_TEMP_CUI_VAL   := TRUE ;
    v_rep_ind.definition_source    := TRUE;
    v_rep_ind.origin               := TRUE;*/

    BEGIN
      Cg$representations_View_Ext.ins(v_rep_rec,v_rep_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_REP_500'; --Error inserting REPRESENTATION_VIEW_EXT
    END;
  END IF;

  IF (P_ACTION = 'UPD' ) THEN

    --Get the version for the P_REP_IDSEQ
    SELECT version INTO v_version
    FROM REPRESENTATIONS_VIEW_EXT
    WHERE rep_idseq = P_REP_IDSEQ;

    IF v_version <> P_REP_VERSION THEN
      P_RETURN_CODE := 'API_REP_402'; -- Version can NOT be updated. It can only be created
      RETURN;
    END IF;

    P_REP_DATE_MODIFIED     := TO_CHAR(SYSDATE);
    P_REP_MODIFIED_BY       := ADMIN_SECURITY_UTIL.effective_user;
    P_REP_DELETED_IND       := 'No';

    v_rep_rec.date_modified := TO_DATE(P_REP_DATE_MODIFIED);
    v_rep_rec.modified_by   := P_REP_MODIFIED_BY;
    v_rep_rec.rep_idseq     := P_REP_IDSEQ;
    v_rep_rec.deleted_ind   := 'No';

    v_rep_ind.date_modified := TRUE;
    v_rep_ind.modified_by   := TRUE;
    v_rep_ind.deleted_ind   := TRUE;
    v_rep_ind.rep_idseq     := TRUE;

    v_rep_ind.version       := FALSE;
    v_rep_ind.created_by := FALSE;
    v_rep_ind.date_created := FALSE;

    IF P_REP_PREFERRED_NAME IS NULL THEN
      v_rep_ind.preferred_name := FALSE;
    ELSE
      v_rep_rec.preferred_name := P_REP_PREFERRED_NAME;
      v_rep_ind.preferred_name := TRUE;
    END IF;

    IF P_REP_CONTE_IDSEQ IS NULL THEN
      v_rep_ind.conte_idseq := FALSE;
    ELSE
      v_rep_rec.conte_idseq := P_REP_CONTE_IDSEQ;
      v_rep_ind.conte_idseq := TRUE;
    END IF;

    IF P_REP_PREFERRED_DEFINITION IS NULL THEN
      v_rep_ind.preferred_definition := FALSE; /***/
    ELSE
      v_rep_rec.preferred_definition := P_REP_PREFERRED_DEFINITION;
      v_rep_ind.preferred_definition := TRUE;
    END IF;

    IF P_REP_LONG_NAME IS NULL THEN
      v_rep_ind.long_name := FALSE;
    ELSE
      v_rep_rec.long_name := P_REP_LONG_NAME;
      v_rep_ind.long_name := TRUE;
    END IF;

    IF P_REP_ASL_NAME IS NULL THEN
      v_rep_ind.asl_name := FALSE;
    ELSE
      v_rep_rec.asl_name := P_REP_ASL_NAME;
      v_rep_ind.asl_name := TRUE;
    END IF;

    IF P_REP_LATEST_VERSION_IND IS NULL THEN
      v_rep_ind.latest_version_ind := FALSE;
    ELSE
      v_rep_rec.latest_version_ind := P_REP_LATEST_VERSION_IND;
      v_rep_ind.latest_version_ind := TRUE;
    END IF;

    IF P_REP_BEGIN_DATE IS NULL THEN
      v_rep_ind.begin_date := FALSE;
    ELSE
      v_rep_rec.begin_date := TO_DATE(P_REP_BEGIN_DATE);
      v_rep_ind.begin_date := TRUE;
    END IF;

    IF P_REP_END_DATE IS NULL THEN
      v_rep_ind.end_date := FALSE;
    ELSE
      v_rep_rec.end_date := TO_DATE(P_REP_END_DATE);
      v_rep_ind.end_date := TRUE;
    END IF;

    IF P_REP_CHANGE_NOTE IS NULL THEN
      v_rep_ind.change_note := FALSE;
    ELSE
      v_rep_rec.change_note := P_REP_CHANGE_NOTE;
      v_rep_ind.change_note := TRUE;
    END IF;

    IF P_REP_DEFINITION_SOURCE IS NULL THEN
      v_rep_ind.definition_source := FALSE;
    ELSE
      v_rep_rec.definition_source := P_REP_DEFINITION_SOURCE;
      v_rep_ind.definition_source := TRUE;
    END IF;

    IF P_REP_ORIGIN IS NULL THEN
      v_rep_ind.origin := FALSE;
    ELSE
      v_rep_rec.origin := P_REP_ORIGIN;
      v_rep_ind.origin := TRUE;
    END IF;

  /*  IF P_rep_DESIG_NCI_CC_TYPE IS NULL THEN
      v_rep_ind.DESIG_NCI_CC_TYPE := FALSE;
    ELSE
      v_rep_rec.DESIG_NCI_CC_TYPE := P_rep_DESIG_NCI_CC_TYPE;
      v_rep_ind.DESIG_NCI_CC_TYPE := TRUE;
    END IF;

    IF P_rep_DESIG_NCI_CC_VAL IS NULL THEN
      v_rep_ind.DESIG_NCI_CC_VAL := FALSE;
    ELSE
      v_rep_rec.DESIG_NCI_CC_VAL := P_rep_DESIG_NCI_CC_VAL;
      v_rep_ind.DESIG_NCI_CC_VAL := TRUE;
    END IF;

    IF P_rep_DESIG_UMLS_CUI_TYPE IS NULL THEN
      v_rep_ind.DESIG_UMLS_CUI_TYPE := FALSE;
    ELSE
      v_rep_rec.DESIG_UMLS_CUI_TYPE := P_rep_DESIG_UMLS_CUI_TYPE;
      v_rep_ind.DESIG_UMLS_CUI_TYPE := TRUE;
    END IF;

    IF P_rep_DESIG_UMLS_CUI_VAL IS NULL THEN
      v_rep_ind.DESIG_UMLS_CUI_VAL := FALSE;
    ELSE
      v_rep_rec.DESIG_UMLS_CUI_VAL := P_rep_DESIG_UMLS_CUI_VAL;
      v_rep_ind.DESIG_UMLS_CUI_VAL := TRUE;
    END IF;

    IF P_rep_DESIG_TEMP_CUI_TYPE IS NULL THEN
      v_rep_ind.DESIG_TEMP_CUI_TYPE := FALSE;
    ELSE
      v_rep_rec.DESIG_TEMP_CUI_TYPE := P_rep_DESIG_TEMP_CUI_TYPE;
      v_rep_ind.DESIG_TEMP_CUI_TYPE := TRUE;
    END IF;

    IF P_rep_DESIG_TEMP_CUI_VAL IS NULL THEN
      v_rep_ind.DESIG_TEMP_CUI_VAL := FALSE;
    ELSE
      v_rep_rec.DESIG_TEMP_CUI_VAL := P_rep_DESIG_TEMP_CUI_VAL;
      v_rep_ind.DESIG_TEMP_CUI_VAL := TRUE;
    END IF;*/

    BEGIN
      Cg$representations_View_Ext.upd(v_rep_rec,v_rep_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_REP_502'; --Error updating representation
    END;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;

END SET_representation;

PROCEDURE SET_REP_CONDR(
P_REP_con_array           IN VARCHAR2
,P_REP_CONTE_IDSEQ            IN VARCHAR2
,P_RETURN_CODE                OUT VARCHAR2
,P_REP_REP_IDSEQ                OUT VARCHAR2
,P_REP_PREFERRED_NAME        OUT VARCHAR2
,P_REP_LONG_NAME              OUT VARCHAR2
,P_REP_PREFERRED_DEFINITION    OUT VARCHAR2
,P_REP_VERSION             OUT VARCHAR2
,P_REP_ASL_NAME            OUT VARCHAR2
,P_REP_LATEST_VERSION_IND     OUT VARCHAR2
,P_REP_CHANGE_NOTE            OUT VARCHAR2
,P_REP_ORIGIN                OUT VARCHAR2
,P_REP_DEFINITION_SOURCE      OUT VARCHAR2
,P_REP_BEGIN_DATE          OUT VARCHAR2
,P_REP_END_DATE               OUT VARCHAR2
,P_REP_DATE_CREATED            OUT VARCHAR2
,P_REP_CREATED_BY         OUT VARCHAR2
,P_REP_DATE_MODIFIED           OUT VARCHAR2
,P_REP_MODIFIED_BY             OUT VARCHAR2
,P_REP_DELETED_IND             OUT VARCHAR2
,P_REP_CONDR_IDSEQ            OUT VARCHAR2
,P_REP_ID            OUT VARCHAR2) IS

v_Exists NUMBER;
v_Condr_idseq con_Derivation_rules_ext.condr_idseq%type;

v_Conte_idseq contexts_view.conte_idseq%type;
BEGIN


  begin
  select conte_idseq into v_CONTE_IDSEQ
  from contexts
  where upper(name) = 'NCIP';	--GF32649
  exception when others then
   P_RETURN_CODE := 'API_PROP_001';
   RETURN;
  end;


v_condr_idseq := sbrext_common_routines.SET_DERIVATION_RULE(p_rep_con_array);

IF NOT Sbrext_Common_Routines.CONDR_EXISTS(v_condr_idseq) THEN
P_RETURN_CODE := 'Concept Derivation Rule does not exist.';
RETURN;
END IF;

IF NOT Sbrext_Common_Routines.CONTEXT_EXISTS(v_conte_idseq) THEN
P_RETURN_CODE := 'Context does not exist.';
RETURN;
END IF;

SELECT COUNT(*) INTO v_Exists
FROM REPRESENTATIONS_EXT
WHERE conte_idseq = v_conte_idseq
AND condr_idseq = v_condr_idseq;


IF v_exists = 0 THEN
Sbrext_Common_Routines.set_oc_rep_prop(v_condr_idseq
,p_return_code
,v_conte_idseq
,'REPRESENTATION'
,p_REP_REP_idseq
);
ELSE
  begin
    SELECT rep_idseq INTO p_rep_rep_idseq
    FROM REPRESENTATIONS_EXT
    WHERE conte_idseq = v_conte_idseq
    AND condr_idseq = v_condr_idseq
    AND LATEST_VERSION_IND = 'Yes';
 exception when too_many_rows then
   p_return_Code := sqlerrm;
   return;
 end;
END IF;

IF p_return_code IS NULL THEN
 SELECT PREFERRED_NAME
        ,LONG_NAME
        ,PREFERRED_DEFINITION
        ,VERSION
        ,ASL_NAME
        ,LATEST_VERSION_IND
        ,CHANGE_NOTE
        ,ORIGIN
        ,DEFINITION_SOURCE
        ,BEGIN_DATE
        ,END_DATE
        ,DATE_CREATED
        ,CREATED_BY
        ,DATE_MODIFIED
        ,MODIFIED_BY
        ,DELETED_IND
  ,CONDR_IDSEQ
  ,REP_IDSEQ
     INTO
    P_REP_PREFERRED_NAME
    ,P_REP_LONG_NAME
    ,P_REP_PREFERRED_DEFINITION
    ,P_REP_VERSION
    ,P_REP_ASL_NAME
    ,P_REP_LATEST_VERSION_IND
    ,P_REP_CHANGE_NOTE
    ,P_REP_ORIGIN
    ,P_REP_DEFINITION_SOURCE
    ,P_REP_BEGIN_DATE
    ,P_REP_END_DATE
    ,P_REP_DATE_CREATED
    ,P_REP_CREATED_BY
    ,P_REP_DATE_MODIFIED
    ,P_REP_MODIFIED_BY
    ,P_REP_DELETED_IND
    ,P_REP_CONDR_IDSEQ
  ,P_REP_ID
 FROM REPRESENTATIONS_EXT
 WHERE REP_idseq = p_REP_REP_idseq;
END IF;


END;

PROCEDURE SET_QUAL(
P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_QUAL_qualifier_name         IN OUT VARCHAR2
,P_QUAL_DESCRIPTION         IN OUT VARCHAR2
,P_QUAL_COMMENTS             IN OUT VARCHAR2
,P_QUAL_CREATED_BY         OUT VARCHAR2
,P_QUAL_DATE_CREATED         OUT VARCHAR2
,P_QUAL_MODIFIED_BY         OUT VARCHAR2
,P_QUAL_DATE_MODIFIED         OUT VARCHAR2
,P_QUAL_CON_IDSEQ        IN VARCHAR2)  IS
/******************************************************************************
   NAME:       SET_QUAL
   PURPOSE:    Inserts or Updates a Single Row Of  Qualifier List of Value

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04/08/2003  Prerna Aggarwal      1. Created this procedure




******************************************************************************/


v_QUAL_rec    Cg$qualifier_Lov_View_Ext.cg$row_type;
v_QUAL_ind    Cg$qualifier_Lov_View_Ext.cg$ind_type;
BEGIN
P_RETURN_CODE := NULL;

IF P_ACTION NOT IN ('INS','UPD') THEN
 P_RETURN_CODE := 'API_QUAL_700'; -- Invalid action
 RETURN;
END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
     --Check to see that all mandatory parameters are either not null
  IF P_QUAL_qualifier_name IS NULL THEN
    P_RETURN_CODE := 'API_QUAL_101';  --Value Meaning cannot be null here
 RETURN;
  END IF;
END IF;

IF P_ACTION = 'UPD'  THEN
  IF P_QUAL_qualifier_name IS NULL THEN
    P_RETURN_CODE := 'API_QUAL_101';  --Value Meaning cannot be null here
 RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.QUAL_exists(P_QUAL_qualifier_name) THEN
   P_RETURN_CODE := 'API_QUAL_005'; --QUAL not found
   RETURN;
  END IF;
END IF;
--Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
IF LENGTH(P_QUAL_qualifier_name) > Sbrext_Column_Lengths.L_QUAL_qualifier_name THEN
  P_RETURN_CODE := 'API_QUAL_111';  --Length of qualifier_name exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_QUAL_DESCRIPTION) > Sbrext_Column_Lengths.L_QUAL_DESCRIPTION THEN
  P_RETURN_CODE := 'API_QUAL_113';  --Length of DESCRIPTION exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_QUAL_COMMENTS) > Sbrext_Column_Lengths.L_QUAL_COMMENTS THEN
  P_RETURN_CODE := 'API_QUAL_114'; --Length of COMMENTS exceeds maximum length
  RETURN;
END IF;


--check to see that charachter strings are valid
IF NOT Sbrext_Common_Routines.valid_char(P_QUAL_qualifier_name) THEN
  P_RETURN_CODE := 'API_QUAL_130'; -- Value Meaning Short Meaning has invalid characters
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.valid_char(P_QUAL_DESCRIPTION) THEN
  P_RETURN_CODE := 'API_QUAL_133'; -- Value Meaning Description has invalid characters
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.valid_char(P_QUAL_COMMENTS) THEN
  P_RETURN_CODE := 'API_QUAL_134'; -- Value Meaning Comment has invalid characters
  RETURN;
END IF;

IF P_QUAL_CON_IDSEQ IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.AC_EXISTS(p_qual_con_idseq) THEN
    P_RETURN_CODE := 'API_QUAL_136'; --Concept does not exist
   RETURN;
  END IF;
END IF;



IF (P_ACTION = 'INS' ) THEN

--check to see that Short Name Does not already Exist
  IF Sbrext_Common_Routines.QUAL_exists(P_QUAL_qualifier_name) THEN
    P_RETURN_CODE := 'API_QUAL_300';-- Value Meaning already exists
    RETURN;
  END IF;

  P_QUAL_DATE_CREATED := TO_CHAR(SYSDATE);
  P_QUAL_CREATED_BY := ADMIN_SECURITY_UTIL.effective_user;
  P_QUAL_DATE_MODIFIED := NULL;
  P_QUAL_MODIFIED_BY := NULL;

  v_QUAL_rec.qualifier_name := P_QUAL_qualifier_name;
  v_QUAL_rec.description      := P_QUAL_DESCRIPTION;
  v_QUAL_rec.comments         := P_QUAL_COMMENTS;

  v_QUAL_rec.created_by     := P_QUAL_CREATED_BY;
  v_QUAL_rec.date_created     := P_QUAL_DATE_CREATED;
  v_QUAL_rec.modified_by     := P_QUAL_MODIFIED_BY;
  v_QUAL_rec.date_modified := P_QUAL_DATE_MODIFIED;
  v_QUAL_rec.con_idseq := P_QUAL_CON_IDSEQ;


  v_QUAL_ind.qualifier_name   := TRUE;
  v_QUAL_ind.description        := TRUE;
  v_QUAL_ind.comments           := TRUE;
  v_QUAL_ind.created_by       := TRUE;
  v_QUAL_ind.date_created       := TRUE;
  v_QUAL_ind.modified_by       := TRUE;
  v_QUAL_ind.date_modified   := TRUE;
  v_QUAL_ind.con_idseq   := TRUE;

  BEGIN
    Cg$qualifier_Lov_View_Ext.ins(v_QUAL_rec,v_QUAL_ind);
  EXCEPTION WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
    P_RETURN_CODE := 'API_QUAL_500'; --Error inserting Value Meaning
  END;

END IF;


IF (P_ACTION = 'UPD' ) THEN

  P_QUAL_DATE_MODIFIED := TO_CHAR(SYSDATE);
  P_QUAL_MODIFIED_BY := ADMIN_SECURITY_UTIL.effective_user;


  v_QUAL_rec.date_modified := P_QUAL_DATE_MODIFIED;
  v_QUAL_rec.modified_by := P_QUAL_MODIFIED_BY;

  v_QUAL_ind.date_modified := TRUE;
  v_QUAL_ind.modified_by := TRUE;

  v_QUAL_ind.created_by := FALSE;
  v_QUAL_ind.date_created := FALSE;

  IF P_QUAL_DESCRIPTION IS NULL THEN
    v_QUAL_ind.description := FALSE;
  ELSE
    v_QUAL_rec.description := P_QUAL_DESCRIPTION;
    v_QUAL_ind.description := TRUE;
  END IF;

  IF P_QUAL_COMMENTS IS NULL THEN
    v_QUAL_ind.comments := FALSE;
  ELSE
    v_QUAL_rec.comments := P_QUAL_COMMENTS;
    v_QUAL_ind.comments := TRUE;
  END IF;

  IF P_QUAL_CON_IDSEQ IS NULL THEN
    v_QUAL_ind.con_idseq := FALSE;
  ELSE
    v_QUAL_rec.con_idseq := P_QUAL_con_idseq;
    v_QUAL_ind.con_idseq := TRUE;
  END IF;


  BEGIN
    Cg$qualifier_Lov_View_Ext.upd(v_QUAL_rec,v_QUAL_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_QUAL_501'; --Error updating value meaning
  END;
END IF;

EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_QUAL;


PROCEDURE set_cd(
  p_action                  IN     VARCHAR2
 ,p_cd_idseq                IN OUT VARCHAR2
 ,p_cd_version              IN OUT VARCHAR2
 ,p_cd_preferred_name       IN OUT VARCHAR2
 ,p_cd_conte_idseq          IN OUT VARCHAR2
 ,p_cd_long_name            IN OUT VARCHAR2
 ,p_cd_preferred_definition IN OUT VARCHAR2
 ,p_cd_dimensionality       IN OUT VARCHAR2
 ,p_cd_asl_name             IN OUT VARCHAR2
 ,p_cd_latest_version_ind   IN OUT VARCHAR2
 ,p_cd_begin_date           IN OUT DATE
 ,p_cd_end_date             IN OUT DATE
 ,p_cd_change_note          IN OUT VARCHAR2
 ,p_cd_origin               IN OUT VARCHAR2
 ,p_cd_created_by              OUT VARCHAR2
 ,p_cd_date_created            OUT VARCHAR2
 ,p_cd_modified_by             OUT VARCHAR2
 ,p_cd_date_modified           OUT VARCHAR2
 ,p_return_code                OUT VARCHAR2
  )
IS

/******************************************************************************
   NAME:       SET_CD
   PURPOSE:    Inserts or Updates a Single Row of Conceptual Domains

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03/08/2004  W. Ver Hoef      1. Created this procedure

******************************************************************************/

  v_cd_rec    cg$conceptual_domains_view.cg$row_type;
  v_cd_ind    cg$conceptual_domains_view.cg$ind_type;

BEGIN

  p_return_code := NULL;

  IF p_action NOT IN ('INS','UPD') THEN
    p_return_code := 'API_CD_100'; -- Invalid action
    RETURN;
  END IF;

  IF p_action = 'INS' THEN
    --Check to see that all mandatory parameters are not null
    IF p_cd_version IS NULL THEN
      p_return_code := 'API_CD_101';  -- parameter value cannot be null
   RETURN;
    END IF;
    IF p_cd_preferred_name IS NULL THEN
      p_return_code := 'API_CD_102';  -- parameter value cannot be null
   RETURN;
    END IF;
    IF p_cd_conte_idseq IS NULL THEN
      p_return_code := 'API_CD_103';  -- parameter value cannot be null
   RETURN;
    END IF;
    IF p_cd_preferred_definition IS NULL THEN
      p_return_code := 'API_CD_104';  -- parameter value cannot be null
   RETURN;
    END IF;
  END IF;

  IF p_action = 'UPD'  THEN
    IF p_cd_idseq IS NULL THEN
      p_return_code := 'API_CD_105';  -- PK cannot be null here
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(p_cd_idseq) THEN
   p_return_code := 'API_CD_105'; -- CD not found
   RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and CHAR parameters have correct length
  IF LENGTH(p_cd_idseq) > Sbrext_Column_Lengths.l_cd_cd_idseq THEN
    p_return_code := 'API_CD_106';
    RETURN;
  END IF;
  IF LENGTH(p_cd_preferred_name) > Sbrext_Column_Lengths.l_cd_preferred_name THEN
    p_return_code := 'API_CD_107';
    RETURN;
  END IF;
  IF LENGTH(p_cd_long_name) > Sbrext_Column_Lengths.l_cd_long_name THEN
    p_return_code := 'API_CD_108';
    RETURN;
  END IF;
  IF LENGTH(p_cd_asl_name) > Sbrext_Column_Lengths.l_cd_asl_name THEN
    p_return_code := 'API_CD_109';
    RETURN;
  END IF;
  IF LENGTH(p_cd_conte_idseq) > Sbrext_Column_Lengths.l_cd_conte_idseq THEN
    p_return_code := 'API_CD_110';
    RETURN;
  END IF;
  IF LENGTH(p_cd_preferred_definition) > Sbrext_Column_Lengths.l_cd_preferred_definition THEN
    p_return_code := 'API_CD_111';
    RETURN;
  END IF;
  IF LENGTH(p_cd_dimensionality) > Sbrext_Column_Lengths.l_cd_dimensionality THEN
    p_return_code := 'API_CD_112';
    RETURN;
  END IF;
  IF LENGTH(p_cd_latest_version_ind) > Sbrext_Column_Lengths.l_cd_latest_version_ind THEN
    p_return_code := 'API_CD_113';
    RETURN;
  END IF;
  IF LENGTH(p_cd_change_note) > Sbrext_Column_Lengths.l_cd_change_note THEN
    p_return_code := 'API_CD_114';
    RETURN;
  END IF;
  IF LENGTH(p_cd_origin) > Sbrext_Column_Lengths.l_cd_origin THEN
    p_return_code := 'API_CD_115';
    RETURN;
  END IF;

  --check to see that character strings are valid
  IF NOT Sbrext_Common_Routines.valid_char(p_cd_long_name) THEN
    p_return_code := 'API_CD_116';
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(p_cd_preferred_definition) THEN
    p_return_code := 'API_CD_117';
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(p_cd_change_note) THEN
    p_return_code := 'API_CD_118';
    RETURN;
  END IF;

  IF p_cd_conte_idseq IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.context_exists(p_cd_conte_idseq) THEN
      p_return_code := 'API_CD_122'; --Context not found in the database
      RETURN;
    END IF;
  END IF;
  IF p_cd_asl_name IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.workflow_exists(p_cd_asl_name) THEN
      p_return_code := 'API_CD_123'; --Workflow Status not found in the database
      RETURN;
    END IF;
  END IF;

  IF P_ACTION = 'INS' THEN

    --check to see that UK components do not already exist
    IF Sbrext_Common_Routines.cd_exists(p_cd_preferred_name, p_cd_version, p_cd_conte_idseq) THEN
      P_RETURN_CODE := 'API_CD_119';
      RETURN;
    END IF;

 p_cd_idseq         := admincomponent_crud.cmr_guid;
    p_cd_date_created  := TO_CHAR(SYSDATE);
    p_cd_created_by    := ADMIN_SECURITY_UTIL.effective_user;
    p_cd_date_modified := NULL;
    p_cd_modified_by   := NULL;

 v_cd_rec.cd_idseq             := p_cd_idseq;
    v_cd_rec.version              := p_cd_version;
    v_cd_rec.preferred_name       := p_cd_preferred_name;
    v_cd_rec.conte_idseq          := p_cd_conte_idseq;
    v_cd_rec.preferred_definition := p_cd_preferred_definition;
    v_cd_rec.dimensionality       := p_cd_dimensionality;
    v_cd_rec.long_name            := p_cd_long_name;
    v_cd_rec.asl_name             := p_cd_asl_name;
    v_cd_rec.latest_version_ind   := p_cd_latest_version_ind;
    v_cd_rec.change_note          := p_cd_change_note;
    v_cd_rec.origin               := p_cd_origin;
    v_cd_rec.begin_date           := p_cd_begin_date;
    v_cd_rec.end_date             := p_cd_end_date;
    v_cd_rec.date_created         := p_cd_date_created;
    v_cd_rec.created_by           := p_cd_created_by;
    v_cd_rec.date_modified        := p_cd_date_modified;
    v_cd_rec.modified_by          := p_cd_modified_by;

    v_cd_ind.cd_idseq             := TRUE;
 v_cd_ind.version              := TRUE;
    v_cd_ind.preferred_name       := TRUE;
    v_cd_ind.conte_idseq          := TRUE;
    v_cd_ind.preferred_definition := TRUE;
    v_cd_ind.dimensionality       := TRUE;
    v_cd_ind.long_name            := TRUE;
    v_cd_ind.asl_name             := TRUE;
    v_cd_ind.latest_version_ind   := TRUE;
    v_cd_ind.change_note          := TRUE;
    v_cd_ind.origin               := TRUE;
    v_cd_ind.begin_date           := TRUE;
    v_cd_ind.end_date             := TRUE;
    v_cd_ind.date_created         := TRUE;
    v_cd_ind.created_by           := TRUE;
    v_cd_ind.date_modified        := TRUE;
    v_cd_ind.modified_by          := TRUE;

    BEGIN
      cg$conceptual_domains_view.ins(v_cd_rec,v_cd_ind);
    EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      p_return_code := 'API_CD_120'; --Error inserting Conceptual Domain
    END;

  END IF;

  IF p_action = 'UPD' THEN

    p_cd_date_modified     := TO_CHAR(SYSDATE);
    p_cd_modified_by       := ADMIN_SECURITY_UTIL.effective_user;

    v_cd_rec.date_modified := p_cd_date_modified;
    v_cd_rec.modified_by   := p_cd_modified_by;

    v_cd_ind.date_modified := TRUE;
    v_cd_ind.modified_by   := TRUE;

    v_cd_ind.date_created  := FALSE;
    v_cd_ind.created_by    := FALSE;

    v_cd_rec.cd_idseq      := p_cd_idseq;

 IF p_cd_preferred_definition IS NULL THEN
      v_cd_ind.preferred_definition := FALSE;
    ELSE
      v_cd_rec.preferred_definition := p_cd_preferred_definition;
      v_cd_ind.preferred_definition := TRUE;
    END IF;

    IF p_cd_dimensionality IS NULL THEN
      v_cd_ind.dimensionality := FALSE;
    ELSE
      v_cd_rec.dimensionality := p_cd_dimensionality;
      v_cd_ind.dimensionality := TRUE;
    END IF;

    IF p_cd_long_name IS NULL THEN
      v_cd_ind.long_name := FALSE;
    ELSE
      v_cd_rec.long_name := p_cd_long_name;
      v_cd_ind.long_name := TRUE;
    END IF;

    IF p_cd_asl_name IS NULL THEN
      v_cd_ind.asl_name := FALSE;
    ELSE
      v_cd_rec.asl_name := p_cd_asl_name;
      v_cd_ind.asl_name := TRUE;
    END IF;

    IF p_cd_latest_version_ind IS NULL THEN
      v_cd_ind.latest_version_ind := FALSE;
    ELSE
      v_cd_rec.latest_version_ind := p_cd_latest_version_ind;
      v_cd_ind.latest_version_ind := TRUE;
    END IF;

    IF p_cd_change_note IS NULL THEN
      v_cd_ind.change_note := FALSE;
    ELSE
      v_cd_rec.change_note := p_cd_change_note;
      v_cd_ind.change_note := TRUE;
    END IF;

    IF p_cd_origin IS NULL THEN
      v_cd_ind.origin := FALSE;
    ELSE
      v_cd_rec.origin := p_cd_origin;
      v_cd_ind.origin := TRUE;
    END IF;

    IF p_cd_begin_date IS NULL THEN
      v_cd_ind.begin_date := FALSE;
    ELSE
      v_cd_rec.begin_date := p_cd_begin_date;
      v_cd_ind.begin_date := TRUE;
    END IF;

    IF p_cd_end_date IS NULL THEN
      v_cd_ind.end_date := FALSE;
    ELSE
      v_cd_rec.end_date := p_cd_end_date;
      v_cd_ind.end_date := TRUE;
    END IF;

    BEGIN
      cg$conceptual_domains_view.upd(v_cd_rec,v_cd_ind);
    EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      p_return_code := 'API_CD_121';
    END;
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;
END set_cd;


PROCEDURE set_complex_de(
  p_action            IN  VARCHAR2
 ,p_cdt_p_de_idseq    IN  VARCHAR2
 ,p_cdt_methods       IN  VARCHAR2
 ,p_cdt_rule          IN  VARCHAR2
 ,p_cdt_concat_char   IN  VARCHAR2
 ,p_cdt_crtl_name     IN  VARCHAR2
 ,p_cdt_created_by    OUT VARCHAR2
 ,p_cdt_date_created  OUT VARCHAR2
 ,p_cdt_modified_by   OUT VARCHAR2
 ,p_cdt_date_modified OUT VARCHAR2
 ,p_return_code       OUT VARCHAR2
 )
IS

/******************************************************************************
   NAME:       SET_COMPLEX_DE
   PURPOSE:    Inserts or Updates a Single Row of Complex_Data_Elements

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        03/16/2004  W. Ver Hoef      1. Created this procedure
   2.1        03/23/2004  W. Ver Hoef      1. Added DEL option

******************************************************************************/

  v_cdt_rec  cg$complex_data_elements_view.cg$row_type;
  v_cdt_ind  cg$complex_data_elements_view.cg$ind_type;
  v_cdt_pk   cg$complex_data_elements_view.cg$pk_type; -- 23-Mar-2004, W. Ver Hoef - added per SPRF_2.1_06

BEGIN

  p_return_code := NULL;

  IF p_action NOT IN ('INS','UPD','DEL') THEN -- 23-Mar-2004, W. Ver Hoef - added DEL option
    p_return_code := 'API_CDT_100'; -- Invalid action
    RETURN;
  END IF;

  IF p_action = 'INS' THEN
    --Check to see that all mandatory parameters are not null and are valid
    IF p_cdt_p_de_idseq IS NULL THEN
      p_return_code := 'API_CDE_101';  -- parameter value cannot be null
   RETURN;
    END IF;
    IF p_cdt_crtl_name IS NULL THEN
      p_return_code := 'API_CDT_102';  -- parameter value cannot be null
   RETURN;
    END IF;
 IF NOT Sbrext_Common_Routines.ac_exists(p_cdt_p_de_idseq) THEN
   p_return_code := 'API_CDT_103'; -- DE not found
   RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.crtl_exists(p_cdt_crtl_name) THEN
   p_return_code := 'API_CDT_104'; -- Complex Rep Type not found
   RETURN;
    END IF;
  END IF;

  IF p_action = 'UPD'  THEN
    IF p_cdt_p_de_idseq IS NULL THEN
      p_return_code := 'API_CDT_101';  -- PK cannot be null here
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.cdt_exists(p_cdt_p_de_idseq) THEN
   p_return_code := 'API_CDT_103'; -- Complex DE not found
   RETURN;
    END IF;
    IF p_cdt_crtl_name IS NOT NULL
 AND NOT Sbrext_Common_Routines.crtl_exists(p_cdt_crtl_name) THEN
   p_return_code := 'API_CDT_104'; -- Complex Rep Type not found
   RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and CHAR parameters have correct length
  IF LENGTH(p_cdt_concat_char) > Sbrext_Column_Lengths.l_cdt_concat_char THEN
    p_return_code := 'API_CDT_105';
    RETURN;
  END IF;
  IF LENGTH(p_cdt_methods) > Sbrext_Column_Lengths.l_cdt_methods THEN
    p_return_code := 'API_CDT_106';
    RETURN;
  END IF;
  IF LENGTH(p_cdt_rule) > Sbrext_Column_Lengths.l_cdt_rule THEN
    p_return_code := 'API_CDT_107';
    RETURN;
  END IF;

  --check to see that character strings are valid
  IF NOT Sbrext_Common_Routines.valid_char(p_cdt_methods) THEN
    p_return_code := 'API_CDT_110';
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(p_cdt_rule) THEN
    p_return_code := 'API_CDT_111';
    RETURN;
  END IF;

  IF p_action = 'INS' THEN

    --check to see that UK components do not already exist
    IF Sbrext_Common_Routines.cdt_exists(p_cdt_p_de_idseq) THEN
      p_return_code := 'API_CDT_120';
      RETURN;
    END IF;

 p_cdt_date_created      := TO_CHAR(SYSDATE);
    p_cdt_created_by        := ADMIN_SECURITY_UTIL.effective_user;
    p_cdt_date_modified     := NULL;
    p_cdt_modified_by       := NULL;

 v_cdt_rec.p_de_idseq    := p_cdt_p_de_idseq;
    v_cdt_rec.methods       := p_cdt_methods;
    v_cdt_rec.rule          := p_cdt_rule;
    v_cdt_rec.concat_char   := p_cdt_concat_char;
    v_cdt_rec.crtl_name     := p_cdt_crtl_name;
    v_cdt_rec.date_created  := p_cdt_date_created;
    v_cdt_rec.created_by    := p_cdt_created_by;
    v_cdt_rec.date_modified := p_cdt_date_modified;
    v_cdt_rec.modified_by   := p_cdt_modified_by;

    v_cdt_ind.p_de_idseq    := TRUE;
 v_cdt_ind.methods       := TRUE;
    v_cdt_ind.rule          := TRUE;
    v_cdt_ind.concat_char   := TRUE;
    v_cdt_ind.crtl_name     := TRUE;
    v_cdt_ind.date_created  := TRUE;
    v_cdt_ind.created_by    := TRUE;
    v_cdt_ind.date_modified := TRUE;
    v_cdt_ind.modified_by   := TRUE;

    BEGIN
      cg$complex_data_elements_view.ins(v_cdt_rec,v_cdt_ind);
    EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      p_return_code := 'API_CDT_130'; --Error inserting Complex DE
    END;

  END IF;

  IF p_action = 'UPD' THEN

    p_cdt_date_modified     := TO_CHAR(SYSDATE);
    p_cdt_modified_by       := ADMIN_SECURITY_UTIL.effective_user;

    v_cdt_rec.date_modified := p_cdt_date_modified;
    v_cdt_rec.modified_by   := p_cdt_modified_by;

    v_cdt_ind.date_modified := TRUE;
    v_cdt_ind.modified_by   := TRUE;

    v_cdt_ind.date_created  := FALSE;
    v_cdt_ind.created_by    := FALSE;

    v_cdt_rec.p_de_idseq    := p_cdt_p_de_idseq;

 IF p_cdt_methods IS NULL THEN
      v_cdt_ind.methods := FALSE;
    ELSE
      v_cdt_rec.methods := p_cdt_methods;
      v_cdt_ind.methods := TRUE;
    END IF;

    IF p_cdt_rule IS NULL THEN
      v_cdt_ind.rule := FALSE;
    ELSE
      v_cdt_rec.rule := p_cdt_rule;
      v_cdt_ind.rule := TRUE;
    END IF;

    IF p_cdt_concat_char IS NULL THEN
      v_cdt_ind.concat_char := FALSE;
    ELSE
      v_cdt_rec.concat_char := p_cdt_concat_char;
      v_cdt_ind.concat_char := TRUE;
    END IF;

    IF p_cdt_crtl_name IS NULL THEN
      v_cdt_ind.crtl_name := FALSE;
    ELSE
      v_cdt_rec.crtl_name := p_cdt_crtl_name;
      v_cdt_ind.crtl_name := TRUE;
    END IF;

    BEGIN
      cg$complex_data_elements_view.upd(v_cdt_rec,v_cdt_ind);
    EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      p_return_code := 'API_CDT_131';
    END;
  END IF;

  -- 23-Mar-2004, W. Ver Hoef - added IF stmt for DEL per SPRF_2.1_06

  IF P_ACTION = 'DEL' THEN              -- we are deleting a record

    IF p_cdt_p_de_idseq IS NULL THEN
      P_RETURN_CODE := 'API_CDT_132' ;  -- for delete the ID is mandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ac_exists(p_cdt_p_de_idseq) THEN
     P_RETURN_CODE := 'API_CDT_133'; -- Complex DE not found
     RETURN;
   END IF;
    END IF;

    v_cdt_pk.p_de_idseq := p_cdt_p_de_idseq;

    SELECT ROWID
 INTO   v_cdt_pk.the_rowid
    FROM   complex_data_elements_view
    WHERE  p_de_idseq = p_cdt_p_de_idseq;

    v_cdt_pk.jn_notes := NULL;

    BEGIN
      cg$complex_data_elements_view.del(v_cdt_pk);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
      p_return_code := 'API_CDT_134'; --Error deleting Complex DE
    END;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;
END set_complex_de;


PROCEDURE set_cde_relationship(
  p_action             IN     VARCHAR2
 ,p_cdr_idseq          IN OUT VARCHAR2
 ,p_cdr_p_de_idseq     IN OUT VARCHAR2
 ,p_cdr_c_de_idseq     IN OUT VARCHAR2
 ,p_cdr_display_order  IN OUT VARCHAR2
 ,p_cdr_created_by        OUT VARCHAR2
 ,p_cdr_date_created      OUT VARCHAR2
 ,p_cdr_modified_by       OUT VARCHAR2
 ,p_cdr_date_modified     OUT VARCHAR2
 ,p_return_code           OUT VARCHAR2
  )
IS

/******************************************************************************
   NAME:       SET_CDE_RELATIONSHIP
   PURPOSE:    Inserts or Updates a Single Row of COMPLEX_DE_RELATIONSHIPS

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        03/17/2004  W. Ver Hoef      1. Created this procedure
   2.1        03/23/2004  W. Ver Hoef      1. Added DEL option

******************************************************************************/

  v_cdr_rec  cg$complex_de_rel_view.cg$row_type;
  v_cdr_ind  cg$complex_de_rel_view.cg$ind_type;
  v_cdr_pk   cg$complex_de_rel_view.cg$pk_type; -- 23-Mar-2004, W. Ver Hoef - added per SPRF_2.1_06a

  v_count      NUMBER := 0;

BEGIN

  p_return_code := NULL;

  IF p_action NOT IN ('INS','UPD','DEL') THEN -- 23-Mar-2004, W. Ver Hoef - added DEL per SPRF_2.1_06a
    p_return_code := 'API_CDR_100'; -- Invalid action
    RETURN;
  END IF;

  IF p_action = 'INS' THEN
    --Check to see that all mandatory parameters are not null
    IF p_cdr_p_de_idseq IS NULL THEN
      p_return_code := 'API_CDR_101';  -- parameter value cannot be null
   RETURN;
    END IF;
    IF p_cdr_c_de_idseq IS NULL THEN
      p_return_code := 'API_CDR_102';  -- parameter value cannot be null
   RETURN;
    END IF;
  END IF;

  IF p_action = 'UPD'  THEN
    IF p_cdr_idseq IS NULL THEN
      p_return_code := 'API_CDR_103';  -- PK cannot be null here
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.cdr_exists(p_cdr_idseq) THEN
   p_return_code := 'API_CDR_104'; -- CD not found
   RETURN;
    END IF;
  END IF;

  --Check to see that display order parameter have correct length
  IF LENGTH(p_cdr_display_order) > 4 THEN
    p_return_code := 'API_CDR_105';
    RETURN;
  END IF;

  --check to see that display order is a valid number
  IF p_cdr_display_order IS NOT NULL THEN
    IF NOT (ASCII(SUBSTR(p_cdr_display_order,1,1)) BETWEEN 48 AND 57 AND
            ASCII(NVL(SUBSTR(p_cdr_display_order,2,1),'0')) BETWEEN 48 AND 57 AND
            ASCII(NVL(SUBSTR(p_cdr_display_order,3,1),'0')) BETWEEN 48 AND 57 AND
            ASCII(NVL(SUBSTR(p_cdr_display_order,4,1),'0')) BETWEEN 48 AND 57) THEN
      p_return_code := 'API_CDR_106';
      RETURN;
    END IF;
  END IF;

  IF p_cdr_p_de_idseq IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.cdt_exists(p_cdr_p_de_idseq) THEN
      p_return_code := 'API_CDR_107'; -- Complex DE not found in the database
      RETURN;
    END IF;
  END IF;
  IF p_cdr_c_de_idseq IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.ac_exists(p_cdr_c_de_idseq) THEN
      p_return_code := 'API_CDR_108'; -- DE not found in the database
      RETURN;
    END IF;
  END IF;

  IF P_ACTION = 'INS' THEN

    --check to see that UK components do not already exist
    BEGIN
      SELECT COUNT(1)
      INTO   v_count
      FROM   complex_de_relationships
      WHERE  p_de_idseq = p_cdr_p_de_idseq
   AND    c_de_idseq = p_cdr_c_de_idseq;
      IF(v_count >= 1) THEN
        p_return_code := 'API_CDR_109'; -- Complex DE relationship already exists
  RETURN;
      END IF;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     NULL;
    END;

 p_cdr_idseq         := admincomponent_crud.cmr_guid;
    p_cdr_date_created  := TO_CHAR(SYSDATE);
    p_cdr_created_by    := ADMIN_SECURITY_UTIL.effective_user;
    p_cdr_date_modified := NULL;
    p_cdr_modified_by   := NULL;

 v_cdr_rec.cdr_idseq      := p_cdr_idseq;
    v_cdr_rec.p_de_idseq     := p_cdr_p_de_idseq;
    v_cdr_rec.c_de_idseq     := p_cdr_c_de_idseq;
    v_cdr_rec.display_order  := p_cdr_display_order;
    v_cdr_rec.date_created   := p_cdr_date_created;
    v_cdr_rec.created_by     := p_cdr_created_by;
    v_cdr_rec.date_modified  := p_cdr_date_modified;
    v_cdr_rec.modified_by    := p_cdr_modified_by;

    v_cdr_ind.cdr_idseq      := TRUE;
 v_cdr_ind.p_de_idseq     := TRUE;
    v_cdr_ind.c_de_idseq     := TRUE;
    v_cdr_ind.display_order  := TRUE;
    v_cdr_ind.date_created   := TRUE;
    v_cdr_ind.created_by     := TRUE;
    v_cdr_ind.date_modified  := TRUE;
    v_cdr_ind.modified_by    := TRUE;

    BEGIN
      cg$complex_de_rel_view.ins(v_cdr_rec,v_cdr_ind);
    EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      p_return_code := 'API_CDR_110'; --Error inserting Complex DE Relationship
    END;

  END IF;

  IF p_action = 'UPD' THEN

    p_cdr_date_modified     := TO_CHAR(SYSDATE);
    p_cdr_modified_by       := ADMIN_SECURITY_UTIL.effective_user;

    v_cdr_rec.date_modified := p_cdr_date_modified;
    v_cdr_rec.modified_by   := p_cdr_modified_by;

    v_cdr_ind.date_modified := TRUE;
    v_cdr_ind.modified_by   := TRUE;

    v_cdr_ind.date_created  := FALSE;
    v_cdr_ind.created_by    := FALSE;

    v_cdr_rec.cdr_idseq     := p_cdr_idseq;

 IF p_cdr_p_de_idseq IS NULL THEN
      v_cdr_ind.p_de_idseq := FALSE;
    ELSE
      v_cdr_rec.p_de_idseq := p_cdr_p_de_idseq;
      v_cdr_ind.p_de_idseq := TRUE;
    END IF;

    IF p_cdr_c_de_idseq IS NULL THEN
      v_cdr_ind.c_de_idseq := FALSE;
    ELSE
      v_cdr_rec.c_de_idseq := p_cdr_c_de_idseq;
      v_cdr_ind.c_de_idseq := TRUE;
    END IF;

    IF p_cdr_display_order IS NULL THEN
      v_cdr_ind.display_order := FALSE;
    ELSE
      v_cdr_rec.display_order := TO_NUMBER(p_cdr_display_order);
      v_cdr_ind.display_order := TRUE;
    END IF;

    BEGIN
      cg$complex_de_rel_view.upd(v_cdr_rec,v_cdr_ind);
    EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      p_return_code := 'API_CDR_111'; -- error updating Complex DE Relationship
    END;

  END IF;

  -- 23-Mar-2004, W. Ver Hoef - added IF stmt for DEL per SPRF_2.1_06a

  IF p_action = 'DEL' THEN              -- we are deleting a record

    IF p_cdr_idseq IS NULL THEN
      p_return_code := 'API_CDR_112' ;  -- for delete the ID is mandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.cdr_exists(p_cdr_idseq) THEN
     p_return_code := 'API_CDR_104'; -- Complex DE not found
     RETURN;
   END IF;
    END IF;

    v_cdr_pk.cdr_idseq := p_cdr_idseq;

    SELECT ROWID
 INTO   v_cdr_pk.the_rowid
    FROM   complex_de_rel_view
    WHERE  cdr_idseq = p_cdr_idseq;

    --v_cdr_pk.jn_notes := NULL;

    BEGIN
      cg$complex_de_rel_view.del(v_cdr_pk);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
      p_return_code := 'API_CDT_113'; --Error deleting Complex DE
    END;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;
END set_cde_relationship;


PROCEDURE set_registration(
  p_action                  IN     VARCHAR2
 ,p_ar_idseq                IN OUT VARCHAR2
 ,p_ar_ac_idseq             IN OUT VARCHAR2
 ,p_ar_registration_status  IN OUT VARCHAR2
 ,p_ar_created_by              OUT VARCHAR2
 ,p_ar_date_created            OUT VARCHAR2
 ,p_ar_modified_by             OUT VARCHAR2
 ,p_ar_date_modified           OUT VARCHAR2
 ,p_return_code                OUT VARCHAR2
  )
IS

/******************************************************************************
   NAME:       SET_REGISTRATION
   PURPOSE:    Inserts or Updates a Single Row of AC_REGISTRATIONS

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        03/19/2004  W. Ver Hoef      1. Created this procedure
   2.1        03/23/2004  W. Ver Hoef      1. Added DEL option

******************************************************************************/

  v_ar_rec  cg$ac_registrations_view.cg$row_type;
  v_ar_ind  cg$ac_registrations_view.cg$ind_type;
  v_ar_pk   cg$ac_registrations_view.cg$pk_type; -- 23-Mar-2004, W. Ver Hoef - added per SPRF_2.1_03

  v_count     NUMBER := 0;

BEGIN

  p_return_code := NULL;

  IF p_action NOT IN ('INS','UPD','DEL') THEN -- 23-Mar-2004, W. Ver Hoef - added DEL per SPRF_2.1_03
    p_return_code := 'API_AR_100'; -- Invalid action
    RETURN;
  END IF;

  IF p_action = 'INS' THEN
    --Check to see that all mandatory parameters are not null
    IF p_ar_ac_idseq IS NULL THEN
      p_return_code := 'API_AR_101';  -- parameter value cannot be null
   RETURN;
    END IF;
    IF p_ar_registration_status IS NULL THEN
      p_return_code := 'API_AR_102';  -- parameter value cannot be null
   RETURN;
    END IF;
  END IF;

  IF p_action = 'UPD'  THEN
    IF p_ar_idseq IS NULL THEN
      p_return_code := 'API_AR_103';  -- PK cannot be null here
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ar_exists(p_ar_idseq) THEN
   p_return_code := 'API_AR_104'; -- AR not found
   RETURN;
    END IF;
  END IF;

  --Check to see that registration status parameter has correct length
  IF LENGTH(p_ar_registration_status) > Sbrext_Column_Lengths.l_ar_registration_status THEN
    p_return_code := 'API_AR_105';
    RETURN;
  END IF;

  IF p_ar_ac_idseq IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.ac_exists(p_ar_ac_idseq) THEN
      p_return_code := 'API_AR_106'; -- AC not found in the database
      RETURN;
    END IF;
  END IF;
  IF p_ar_registration_status IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.rsl_exists(p_ar_registration_status) THEN
      p_return_code := 'API_AR_107'; -- Registration Status not found in the database
      RETURN;
    END IF;
  END IF;

  IF P_ACTION = 'INS' THEN

    -- check to see that UK components do not already exist
 -- NOTE:  currently the SUBMITTER and ORGANIZATION part of this model are not being
 -- used for registration so we're only checking on the uniqueness of the ac_idseq.
    BEGIN
      SELECT COUNT(1)
      INTO   v_count
      FROM   ac_registrations
      WHERE  ac_idseq = p_ar_ac_idseq;
      IF(v_count >= 1) THEN
        p_return_code := 'API_AR_108'; -- AC Registration already exists
  RETURN;
      END IF;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     NULL;
    END;

 p_ar_idseq         := admincomponent_crud.cmr_guid;
    p_ar_date_created  := TO_CHAR(SYSDATE);
    p_ar_created_by    := ADMIN_SECURITY_UTIL.effective_user;
    p_ar_date_modified := NULL;
    p_ar_modified_by   := NULL;

 v_ar_rec.ar_idseq            := p_ar_idseq;
    v_ar_rec.ac_idseq            := p_ar_ac_idseq;
    v_ar_rec.registration_status := p_ar_registration_status;
    v_ar_rec.date_created        := p_ar_date_created;
    v_ar_rec.created_by          := p_ar_created_by;
    v_ar_rec.date_modified       := p_ar_date_modified;
    v_ar_rec.modified_by         := p_ar_modified_by;

    v_ar_ind.ar_idseq            := TRUE;
 v_ar_ind.ac_idseq            := TRUE;
    v_ar_ind.registration_status := TRUE;
    v_ar_ind.date_created        := TRUE;
    v_ar_ind.created_by          := TRUE;
    v_ar_ind.date_modified       := TRUE;
    v_ar_ind.modified_by         := TRUE;

    BEGIN
      cg$ac_registrations_view.ins(v_ar_rec, v_ar_ind);
    EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      p_return_code := 'API_AR_109'; --Error inserting AC Registration
    END;

  END IF;

  IF p_action = 'UPD' THEN

    p_ar_date_modified     := TO_CHAR(SYSDATE);
    p_ar_modified_by       := ADMIN_SECURITY_UTIL.effective_user;

    v_ar_rec.date_modified := p_ar_date_modified;
    v_ar_rec.modified_by   := p_ar_modified_by;

    v_ar_ind.date_modified := TRUE;
    v_ar_ind.modified_by   := TRUE;

    v_ar_ind.date_created  := FALSE;
    v_ar_ind.created_by    := FALSE;

    v_ar_rec.ar_idseq     := p_ar_idseq;

 IF p_ar_ac_idseq IS NULL THEN
      v_ar_ind.ac_idseq := FALSE;
    ELSE
      v_ar_rec.ac_idseq := p_ar_ac_idseq;
      v_ar_ind.ac_idseq := TRUE;
    END IF;

    IF p_ar_registration_status IS NULL THEN
      v_ar_ind.registration_status := FALSE;
    ELSE
      v_ar_rec.registration_status := p_ar_registration_status;
      v_ar_ind.registration_status := TRUE;
    END IF;

    BEGIN
      cg$ac_registrations_view.upd(v_ar_rec, v_ar_ind);
    EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      p_return_code := 'API_AR_110'; -- error updating AC Registration
    END;
  END IF;

  -- 23-Mar-2004, W. Ver Hoef - added IF stmt for DEL per SPRF_2.1_03

  IF p_action = 'DEL' THEN              -- we are deleting a record

    IF p_ar_idseq IS NULL THEN
      p_return_code := 'API_AR_111' ;  -- for delete the ID is mandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ar_exists(p_ar_idseq) THEN
     p_return_code := 'API_AR_104'; -- AC Registration not found
     RETURN;
   END IF;
    END IF;

    v_ar_pk.ar_idseq := p_ar_idseq;

    SELECT ROWID
 INTO   v_ar_pk.the_rowid
    FROM   ac_registrations_view
    WHERE  ar_idseq = p_ar_idseq;

    v_ar_pk.jn_notes := NULL;

    BEGIN
      cg$ac_registrations_view.del(v_ar_pk);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
      p_return_code := 'API_AR_112'; --Error deleting Complex DE
    END;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;
END set_registration;

-- SPRF_3.1_16i (TT#1001)
PROCEDURE set_contact_comm (
     p_return_code            OUT       VARCHAR2
    ,p_action                 IN        VARCHAR2
    ,p_ccomm_idseq            in  out   varchar2
    ,p_org_idseq              in  out   varchar2
    ,p_per_idseq              in  out   varchar2
    ,p_ctl_name               in  out   varchar2
    ,p_rank_order             in  out   number
    ,p_cyber_address          in  out   varchar2
    ,p_date_created           in  out   date
    ,p_created_by             in  out   varchar2
    ,p_date_modified          in  out   date
    ,p_modified_by            in  out   varchar2) IS

    /*
    ** set_contact_com: insert/update/delete a row in contact_comms_view
    ** S. Alred; 12/13/2005 -- no prior version
    */

    v_idSeq     contact_comms.ccomm_idseq%TYPE;
    r_con_comm  contact_comms_view%ROWTYPE;

  BEGIN
    p_return_code := NULL;

    IF (p_action NOT IN ('INS','UPD','DEL')) THEN
      p_return_code := 'API_CCOMM_700: No or Invalid action passed';
      RETURN;
    END IF;

    IF p_action = 'INS' THEN -- insert section
      -- check for mandatory columns
      IF (p_ctl_name IS NULL OR
          p_rank_order is NULL OR
          p_cyber_address is NULL) THEN
        p_return_code := 'API_CCOMM_100: Missing mandatory parameter(s): ';
        IF p_ctl_name is null then
          p_return_code := p_return_code || ' p_ctl_name ';
        END IF;
        IF p_rank_order is null then
          p_return_code := p_return_code || ' p_rank_order ';
        END IF;
        IF p_cyber_address is null then
          p_return_code := p_return_code || ' p_cyber_address ';
        END IF;
        RETURN;
      END IF;
      -- Validate FK references

      -- Validate ctl_name
      IF NOT sbrext_common_routines.comm_type_exists(p_ctl_name) THEN
        p_return_code := 'API_CCOMM_201: Incorrect ctl_name.';
        RETURN;
      END IF;

      -- Validate per_idseq if present
      IF p_per_idseq IS NOT NULL THEN
        IF NOT sbrext_common_routines.per_exists(p_per_idseq) THEN
          p_return_code := 'API_CCOMM_202: Incorrect per_idseq.';
          RETURN;
        END IF;
      END IF;

      -- Validate org_idseq if present
      IF p_org_idseq IS NOT NULL THEN
        IF NOT sbrext_common_routines.org_exists(p_org_idseq) THEN
          p_return_code := 'API_CCOMM_203: Incorrect org_idseq.';
          RETURN;
        END IF;
      END IF;

      -- Validate lengths of VARCHAR2 columns
      IF length(p_ctl_name) > sbrext_column_lengths.get_vc2_col_length(
                                p_owner => 'SBR'
                               ,p_tname => 'CONTACT_COMMS'
                               ,p_cname => 'CTL_NAME') THEN
        P_RETURN_CODE := 'API_CCOMM_111: ctl_name too long';
        RETURN;
      END IF;

      IF length(p_cyber_address) > sbrext_column_lengths.get_vc2_col_length(
                                p_owner => 'SBR'
                               ,p_tname => 'CONTACT_COMMS'
                               ,p_cname => 'CYBER_ADDRESS')THEN
        P_RETURN_CODE := 'API_CCOMM_113: cyber_address too long';
        RETURN;
      END IF;

      -- validate org/per arc

      IF p_per_idseq IS NOT NULL THEN
        IF p_org_idseq IS NOT NULL THEN
          p_return_code := 'API_ACC_553: Arc violation [org_idseq + per_idseq]';
        END IF;
      END IF;

      IF (p_per_idseq IS NULL AND p_org_idseq IS NULL) THEN
        p_return_code := 'API_ACC_560: Org-Per Arc violation [no values]';
      END If;

      -- check for duplicate [TBD]

      -- generate PK and assign other values
       p_ccomm_idseq  := admincomponent_crud.CMR_GUID;
       p_date_created := SYSDATE;
       p_created_by   := ADMIN_SECURITY_UTIL.effective_user;

      -- set row
      INSERT INTO contact_comms_view (
         ccomm_idseq
        ,org_idseq
        ,per_idseq
        ,ctl_name
        ,rank_order
        ,cyber_address
        ,date_created
        ,created_by)
      VALUES (
         p_ccomm_idseq
        ,p_org_idseq
        ,p_per_idseq
        ,p_ctl_name
        ,p_rank_order
        ,p_cyber_address
        ,p_date_created
        ,p_created_by);

    END IF; -- end of INS section

    IF p_action = 'UPD' THEN -- update section
      IF p_ccomm_idseq IS NULL THEN
        p_return_code := 'API_CCOMM_600: Missing primary key for update.';
        RETURN;
      END IF;

      -- load up existing values
      SELECT * INTO r_con_comm
      FROM   contact_comms_view
      WHERE  ccomm_idseq = p_ccomm_idseq;

      -- set changed values

      -- optional columns
      IF p_org_idseq IS NOT NULL THEN
        IF p_org_idseq = ' ' THEN
          r_con_comm.org_idseq := NULL;
        ELSE
          r_con_comm.org_idseq := p_org_idseq;
        END IF;
      END IF;

      IF p_per_idseq IS NOT NULL THEN
        IF p_per_idseq = ' ' THEN
          r_con_comm.per_idseq := NULL;
        ELSE
          r_con_comm.per_idseq := p_per_idseq;
        END IF;
      END IF;

      -- mandatory columns
      IF p_ctl_name IS NOT NULL THEN
        r_con_comm.ctl_name :=  p_ctl_name;
      END IF;

      IF p_rank_order IS NOT NULL THEN
        r_con_comm.rank_order := p_rank_order;
      END IF;

      IF p_cyber_address IS  NOT NULL THEN
        r_con_comm.cyber_address := p_cyber_address;
      END IF;

      -- validate org/per arc

      IF p_per_idseq IS NOT NULL THEN
        IF p_org_idseq IS NOT NULL THEN
          p_return_code := 'API_ACC_553: Arc violation [org_idseq + per_idseq]';
        END IF;
      END IF;

      IF (p_per_idseq IS NULL AND p_org_idseq IS NULL) THEN
        p_return_code := 'API_ACC_560: Org-Per Arc violation [no values]';
      END If;
      -- perform update
      p_modified_by   := ADMIN_SECURITY_UTIL.effective_user;
      p_date_modified := SYSDATE;

      UPDATE  contact_comms_view
      SET     org_idseq            = r_con_comm.org_idseq
         ,    per_idseq            = r_con_comm.per_idseq
         ,    ctl_name             = r_con_comm.ctl_name
         ,    rank_order           = r_con_comm.rank_order
         ,    cyber_address        = r_con_comm.cyber_address
         ,    date_modified        = p_date_modified
         ,    modified_by          = p_modified_by
      WHERE ccomm_idseq = p_ccomm_idseq;

    END IF; -- end of UPD section

    IF p_action = 'DEL' THEN -- delete section
      IF p_ccomm_idseq IS NULL THEN
        P_RETURN_CODE := 'API_CCOMM_800: ccom_idseq needed to delete';
        RETURN;
      END IF;
      DELETE FROM contact_comms_view
      WHERE ccomm_idseq = p_ccomm_idseq;
    END IF;

    END set_contact_comm;

-- SPRF_3.1_16j (TT#1001)
PROCEDURE set_contact_addr (
     p_return_code            OUT       VARCHAR2
    ,p_action                 IN        VARCHAR2
    ,p_caddr_idseq            in  out   varchar2
    ,p_org_idseq              in  out   varchar2
    ,p_per_idseq              in  out   varchar2
    ,p_atl_name               in  out   varchar2
    ,p_rank_order             in  out   number
    ,p_addr_line1             in  out   varchar2
    ,p_addr_line2             in  out   varchar2
    ,p_city                   in  out   varchar2
    ,p_state_prov             in  out   varchar2
    ,p_postal_code            in  out   varchar2
    ,p_country                in  out   varchar2
    ,p_date_created           in  out   date
    ,p_created_by             in  out   varchar2
    ,p_date_modified          in  out   date
    ,p_modified_by            in  out   varchar2) IS

    /*
    ** set_contact_addr: insert/update/delete a row in contact_addresses_view
    ** S. Alred; 12/14/2005 -- no prior version
    */

    v_idSeq     contact_addresses_view.caddr_idseq%TYPE;
    r_con_addr  contact_addresses_view%ROWTYPE;

  BEGIN
    p_return_code := NULL;

    IF (p_action NOT IN ('INS','UPD','DEL')) THEN
      p_return_code := 'API_CADDR_700: No or Invalid action passed';
      RETURN;
    END IF;

    IF p_action = 'INS' THEN -- insert section
      -- check for mandatory columns
      IF (p_atl_name    IS NULL OR
          p_rank_order  is NULL OR
          p_addr_line1  is NULL OR
          p_city        IS NULL OR
          p_state_prov  IS NULL OR
          p_postal_code IS NULL) THEN
        p_return_code := 'API_CADDR_100: Missing mandatory parameter(s): ';
        IF p_atl_name is null then
          p_return_code := p_return_code || ' p_atl_name ';
        END IF;
        IF p_rank_order is null then
          p_return_code := p_return_code || ' p_rank_order ';
        END IF;
        IF p_addr_line1 is null then
          p_return_code := p_return_code || ' p_addr_line1 ';
        END IF;
        IF p_city is null then
          p_return_code := p_return_code || ' p_city ';
        END IF;
        IF p_state_prov is null then
          p_return_code := p_return_code || ' p_state_prov ';
        END IF;
        IF p_postal_code is null then
          p_return_code := p_return_code || ' p_postal_code ';
        END IF;
        RETURN;
      END IF;
      -- Validate FK references

      -- Validate atl_name
      IF NOT sbrext_common_routines.addr_type_exists(p_atl_name) THEN
        p_return_code := 'API_CADDR_201: Incorrect atl_name.';
        RETURN;
      END IF;

      -- Validate per_idseq if present
      IF p_per_idseq IS NOT NULL THEN
        IF NOT sbrext_common_routines.per_exists(p_per_idseq) THEN
          p_return_code := 'API_CADDR_202: Incorrect per_idseq.';
          RETURN;
        END IF;
      END IF;

      -- Validate org_idseq if present
      IF p_org_idseq IS NOT NULL THEN
        IF NOT sbrext_common_routines.org_exists(p_org_idseq) THEN
          p_return_code := 'API_CADDR_203: Incorrect org_idseq.';
          RETURN;
        END IF;
      END IF;

      -- Validate lengths of VARCHAR2 columns
      IF length(p_atl_name) > sbrext_column_lengths.get_vc2_col_length(
                                p_owner => 'SBR'
                               ,p_tname => 'CONTACT_ADDRESSES'
                               ,p_cname => 'ATL_NAME') THEN
        P_RETURN_CODE := 'API_CADDR_111: atl_name too long';
        RETURN;
      END IF;

      IF length(p_addr_line1) > sbrext_column_lengths.get_vc2_col_length(
                                p_owner => 'SBR'
                               ,p_tname => 'CONTACT_ADDRESSES'
                               ,p_cname => 'ADDR_LINE1')THEN
        P_RETURN_CODE := 'API_CADDR_113: addr_line1 too long';
        RETURN;
      END IF;

      IF p_addr_line2 IS NOT NULL THEN
        IF length(p_addr_line2) > sbrext_column_lengths.get_vc2_col_length(
                                  p_owner => 'SBR'
                                 ,p_tname => 'CONTACT_ADDRESSES'
                                 ,p_cname => 'ADDR_LINE2')THEN
          P_RETURN_CODE := 'API_CADDR_114: addr_line2 too long';
          RETURN;
        END IF;
      END IF;

      IF length(p_city) > sbrext_column_lengths.get_vc2_col_length(
                                p_owner => 'SBR'
                               ,p_tname => 'CONTACT_ADDRESSES'
                               ,p_cname => 'CITY')THEN
        P_RETURN_CODE := 'API_CADDR_115: city too long';
        RETURN;
      END IF;

      IF length(p_state_prov) > sbrext_column_lengths.get_vc2_col_length(
                                p_owner => 'SBR'
                               ,p_tname => 'CONTACT_ADDRESSES'
                               ,p_cname => 'STATE_PROV')THEN
        P_RETURN_CODE := 'API_CADDR_116: state_prov too long';
        RETURN;
      END IF;

      IF length(p_postal_code) > sbrext_column_lengths.get_vc2_col_length(
                                p_owner => 'SBR'
                               ,p_tname => 'CONTACT_ADDRESSES'
                               ,p_cname => 'POSTAL_CODE')THEN
        P_RETURN_CODE := 'API_CADDR_117: postal_code too long';
        RETURN;
      END IF;

      IF p_country IS NOT NULL THEN
        IF length(p_country) > sbrext_column_lengths.get_vc2_col_length(
                                  p_owner => 'SBR'
                                 ,p_tname => 'CONTACT_ADDRESSES'
                                 ,p_cname => 'COUNTRY')THEN
          P_RETURN_CODE := 'API_CADDR_118: country too long';
          RETURN;
        END IF;
      END IF;

      -- validate org/per arc

      IF p_per_idseq IS NOT NULL THEN
        IF p_org_idseq IS NOT NULL THEN
          p_return_code := 'API_ACC_553: Arc violation [org_idseq + per_idseq]';
        END IF;
      END IF;

      IF (p_per_idseq IS NULL AND p_org_idseq IS NULL) THEN
        p_return_code := 'API_ACC_560: Org-Per Arc violation [no values]';
      END If;


      -- check for duplicate [TBD]

      -- generate PK and assign other values
       p_caddr_idseq  := admincomponent_crud.CMR_GUID;
       p_date_created := SYSDATE;
       p_created_by   := ADMIN_SECURITY_UTIL.effective_user;

      -- set row
      INSERT INTO contact_addresses_view (
            caddr_idseq
          ,org_idseq
          ,per_idseq
          ,atl_name
          ,rank_order
          ,addr_line1
          ,addr_line2
          ,city
          ,state_prov
          ,postal_code
          ,country
          ,date_created
          ,created_by)
      VALUES (
           p_caddr_idseq
          ,p_org_idseq
          ,p_per_idseq
          ,p_atl_name
          ,p_rank_order
          ,p_addr_line1
          ,p_addr_line2
          ,p_city
          ,p_state_prov
          ,p_postal_code
          ,p_country
          ,p_date_created
          ,p_created_by );

    END IF; -- end of INS section

    IF p_action = 'UPD' THEN -- update section
      IF p_caddr_idseq IS NULL THEN
        p_return_code := 'API_CADDR_600: Missing primary key for update.';
        RETURN;
      END IF;

      -- load up existing values
      SELECT * INTO r_con_addr
      FROM   contact_addresses_view
      WHERE  caddr_idseq = p_caddr_idseq;

      -- set changed values

      -- optional columns
      IF p_org_idseq IS NOT NULL THEN
        IF p_org_idseq = ' ' THEN
          r_con_addr.org_idseq := NULL;
        ELSE
          r_con_addr.org_idseq := p_org_idseq;
        END IF;
      END IF;

      IF p_per_idseq IS NOT NULL THEN
        IF p_per_idseq = ' ' THEN
          r_con_addr.per_idseq := NULL;
        ELSE
          r_con_addr.per_idseq := p_per_idseq;
        END IF;
      END IF;

      IF p_addr_line2 IS NOT NULL THEN
        IF p_addr_line2 = ' ' THEN
          r_con_addr.addr_line2 := NULL;
        ELSE
          r_con_addr.addr_line2 := p_addr_line2;
        END IF;
      END IF;


      IF p_country IS NOT NULL THEN
        IF p_country = ' ' THEN
          r_con_addr.country := NULL;
        ELSE
          r_con_addr.country := p_country;
        END IF;
      END IF;

      -- mandatory columns
      IF p_atl_name IS NOT NULL THEN
        r_con_addr.atl_name :=  p_atl_name;
      END IF;

      IF p_rank_order IS NOT NULL THEN
        r_con_addr.rank_order := p_rank_order;
      END IF;

      IF p_addr_line1 IS  NOT NULL THEN
        r_con_addr.addr_line1 := p_addr_line1;
      END IF;

      IF p_city IS  NOT NULL THEN
        r_con_addr.city := p_city;
      END IF;

      IF p_state_prov IS  NOT NULL THEN
        r_con_addr.state_prov := p_state_prov;
      END IF;

      IF p_postal_code IS  NOT NULL THEN
        r_con_addr.postal_code := p_postal_code;
      END IF;

      -- validate org/per arc

      IF p_per_idseq IS NOT NULL THEN
        IF p_org_idseq IS NOT NULL THEN
          p_return_code := 'API_ACC_553: Arc violation [org_idseq + per_idseq]';
        END IF;
      END IF;

      IF (p_per_idseq IS NULL AND p_org_idseq IS NULL) THEN
        p_return_code := 'API_ACC_560: Org-Per Arc violation [no values]';
      END If;

      -- perform update
      p_modified_by   := ADMIN_SECURITY_UTIL.effective_user;
      p_date_modified := SYSDATE;

      UPDATE  contact_addresses_view
      SET      ORG_IDSEQ           =  r_con_addr.ORG_IDSEQ
         ,     PER_IDSEQ           =  r_con_addr.PER_IDSEQ
         ,     ATL_NAME            =  r_con_addr.ATL_NAME
         ,     RANK_ORDER          =  r_con_addr.RANK_ORDER
         ,     ADDR_LINE1          =  r_con_addr.ADDR_LINE1
         ,     ADDR_LINE2          =  r_con_addr.ADDR_LINE2
         ,     CITY                =  r_con_addr.CITY
         ,     STATE_PROV          =  r_con_addr.STATE_PROV
         ,     POSTAL_CODE         =  r_con_addr.POSTAL_CODE
         ,     COUNTRY             =  r_con_addr.COUNTRY
         ,     DATE_MODIFIED       =  P_DATE_MODIFIED
         ,     MODIFIED_BY         =  P_MODIFIED_BY
      WHERE caddr_idseq = p_caddr_idseq;

    END IF; -- end of UPD section

    IF p_action = 'DEL' THEN -- delete section
      IF p_caddr_idseq IS NULL THEN
        P_RETURN_CODE := 'API_CADDR_800: caddr_idseq needed to delete';
        RETURN;
      END IF;
      DELETE FROM contact_addresses_view
      WHERE caddr_idseq = p_caddr_idseq;
    END IF;

    END set_contact_addr;



PROCEDURE SET_VD(
  P_UA_NAME        IN  VARCHAR2
, P_RETURN_CODE        OUT VARCHAR2
, P_ACTION                  IN     VARCHAR2
, P_VD_VD_IDSEQ             IN OUT VARCHAR2
, P_VD_PREFERRED_NAME     IN OUT VARCHAR2
, P_VD_CONTE_IDSEQ         IN OUT VARCHAR2
, P_VD_VERSION             IN OUT NUMBER
, P_VD_PREFERRED_DEFINITION IN OUT VARCHAR2
, P_VD_CD_IDSEQ             IN OUT VARCHAR2
, P_VD_ASL_NAME             IN OUT VARCHAR2
, P_VD_LATEST_VERSION_IND   IN OUT VARCHAR2
, P_VD_DTL_NAME             IN OUT VARCHAR2
, P_VD_MAX_LENGTH_NUM       IN OUT NUMBER
, P_VD_LONG_NAME         IN OUT VARCHAR2
, P_VD_FORML_NAME          IN OUT VARCHAR2
, P_FORML_DESCRIPTION       IN OUT VARCHAR2
, P_FORML_COMMENT           IN OUT VARCHAR2
, P_VD_UOML_NAME            IN OUT VARCHAR2
, P_UOML_DESCRIPTION        IN OUT VARCHAR2
, P_UOML_COMMENT            IN OUT VARCHAR2
, P_VD_LOW_VALUE_NUM     IN OUT VARCHAR2
, P_VD_HIGH_VALUE_NUM     IN OUT VARCHAR2
, P_VD_MIN_LENGTH_NUM     IN OUT NUMBER
, P_VD_DECIMAL_PLACE      IN OUT NUMBER
, P_VD_CHAR_SET_NAME     IN OUT VARCHAR2
, P_VD_BEGIN_DATE         IN OUT VARCHAR2
, P_VD_END_DATE             IN OUT VARCHAR2
, P_VD_CHANGE_NOTE         IN OUT VARCHAR2
, P_VD_TYPE_FLAG         IN OUT VARCHAR2
, P_VD_CREATED_BY            OUT VARCHAR2
, P_VD_DATE_CREATED            OUT VARCHAR2
, P_VD_MODIFIED_BY            OUT VARCHAR2
, P_VD_DATE_MODIFIED        OUT VARCHAR2
, P_VD_DELETED_IND            OUT VARCHAR2
, P_VD_REP_IDSEQ            IN     VARCHAR2 DEFAULT NULL
, P_VD_QUALIFIER_NAME       IN     VARCHAR2 DEFAULT NULL
, P_VD_ORIGIN               IN     VARCHAR2 DEFAULT NULL) -- 24-Jul-2003, W. Ver Hoef
IS

v_version     value_domains_view.version%TYPE;
v_ac          value_domains_view.vd_idseq%TYPE;
v_asl_name    value_domains_view.asl_name%TYPE;

v_description VARCHAR2(60);
v_comments    VARCHAR2(2000);
v_begin_date  DATE := NULL;
v_end_date    DATE := NULL;
v_new_version BOOLEAN :=FALSE;

v_vd_rec    cg$value_domains_view.cg$row_type;
v_forml_rec cg$formats_lov_view.cg$row_type;
v_uoml_rec  cg$unit_of_measures_lov_view.cg$row_type;
v_vd_ind    cg$value_domains_view.cg$ind_type;
v_forml_ind cg$formats_lov_view.cg$ind_type;
v_uoml_ind  cg$unit_of_measures_lov_view.cg$ind_type;
v_count number;
v_vd_preferred_name administered_components.preferred_name%type;

BEGIN
  P_RETURN_CODE := NULL;

  IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
    P_RETURN_CODE := 'API_VD_700'; -- Invalid action
    RETURN;
  END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  IF P_ACTION = 'INS' THEN              --we are inserting a record
    IF P_VD_VD_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_VD_100' ;  --for inserts the ID is generated
   RETURN;
    ELSE
      --Check to see that all mandatory parameters are either not NULL or have a default value.
   IF P_VD_PREFERRED_NAME IS NULL THEN
     P_RETURN_CODE := 'API_VD_101';  --Preferred Name cannot be null here
  RETURN;
      END IF;
   IF P_VD_CONTE_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_VD_102'; --CONTE_IDSEQ cannot be null here
  RETURN;
   END IF;
   IF P_VD_PREFERRED_DEFINITION IS NULL THEN
     P_RETURN_CODE := 'API_VD_103'; --Preferred Definition cannot be null here
  RETURN;
   END IF;
   IF P_VD_ASL_NAME IS NULL THEN
     -- 19-Mar-2004, W. Ver Hoef - substituted UNASSIGNED with function call below
     P_VD_ASL_NAME := Sbrext_Common_Routines.get_default_asl('INS'); -- 'UNASSIGNED';
   END IF;
   IF P_VD_VERSION IS NULL THEN
     P_VD_VERSION := Sbrext_Common_Routines.get_ac_version(p_vd_preferred_name,p_vd_conte_idseq,'VALUEDOMAIN','HIGHEST') + 1;
   END IF;
   IF P_VD_CD_IDSEQ IS NULL THEN
     P_VD_CD_IDSEQ := Sbrext_Common_Routines.get_cd(P_VD_CONTE_IDSEQ);
  IF P_VD_CD_IDSEQ IS NULL THEN
       P_RETURN_CODE := 'API_VD_104'; --default CD_IDSEQ not found
    RETURN;
  END IF;
   END IF;
   IF P_VD_LATEST_VERSION_IND IS NULL THEN
     P_VD_LATEST_VERSION_IND := 'No';
      END IF;
   IF P_VD_TYPE_FLAG IS NULL THEN
     P_VD_TYPE_FLAG  := 'N';
   ELSIF P_VD_TYPE_FLAG NOT IN ('E','N','R') THEN -- 26-Mar-2004, W. Ver Hoef - added R
     P_RETURN_CODE := 'API_VD_106'; --VD type flag can be ;E or N or OR only
  RETURN;
   END IF;
   IF P_VD_DTL_NAME IS NULL THEN
     P_VD_DTL_NAME := 'CHARACTER';
   END IF;
   /* Commented out on 9/4/2003 since max length should not default to 0
   IF P_VD_MAX_LENGTH_NUM IS NULL THEN
     P_VD_MAX_LENGTH_NUM := 0;
   END IF;*/
    END IF;

 if upper(P_VD_PREFERRED_NAME) <> 'SYSTEM GENERATED' then
 select count(*) into v_count
 from value_Domains
 where preferred_name = p_vd_PREFERRED_NAME
 and version = p_vd_Version
 and conte_idseq = p_vd_conte_idseq;

 if v_count <> 0 then
   P_RETURN_CODE := 'API_VD_550'; -- unique constraint violeted;
   RETURN;
 end if;
  END IF;
end if;

  IF P_ACTION = 'UPD' THEN
  admin_security_util.seteffectiveuser(p_ua_name);
    IF P_VD_VD_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_VD_400' ;  --for updates the ID IS mandatory
   RETURN;
    END IF;
    SELECT asl_name
 INTO   v_asl_name
    FROM   value_domains_View
    WHERE  vd_idseq = P_VD_VD_IDSEQ;
    IF (P_VD_PREFERRED_NAME IS NOT NULL OR P_VD_CONTE_IDSEQ IS NOT NULL) AND v_asl_name = 'RELEASED'  THEN
      P_RETURN_CODE := 'API_VD_401' ;  --Preferred Name or Context Can not be updated
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(P_VD_VD_IDSEQ) THEN
      P_RETURN_CODE := 'API_VD_005'; --VD NOT found
      RETURN;
    END IF;
 -- 26-Mar-2004, W. Ver Hoef - added validation on vd_type_flag
 IF P_VD_TYPE_FLAG NOT IN ('E','N','R') THEN -- 26-Mar-2004, W. Ver Hoef - added R
   P_RETURN_CODE := 'API_VD_106'; --VD type flag can be ;E or N or OR only
   RETURN;
 END IF;
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are logically deleteing a record

    IF P_VD_VD_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_VD_400' ;  --for deletes the ID IS mandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ac_exists(P_VD_VD_IDSEQ) THEN
     P_RETURN_CODE := 'API_VD_005'; --Value Domain not found
     RETURN;
   END IF;
    END IF;

    P_VD_DELETED_IND   := 'Yes';
    P_VD_MODIFIED_BY   :=  P_UA_NAME;                      --USER
    P_VD_DATE_MODIFIED := TO_CHAR(SYSDATE);

    v_vd_rec.vd_idseq      := P_VD_VD_IDSEQ;
    v_vd_rec.deleted_ind   := P_VD_DELETED_IND;
    v_vd_rec.modified_by   := P_VD_MODIFIED_BY;
    v_vd_rec.date_modified := TO_DATE(P_VD_DATE_MODIFIED);

    v_vd_ind.vd_idseq           := TRUE;
    v_vd_ind.preferred_name       := FALSE;
    v_vd_ind.conte_idseq       := FALSE;
    v_vd_ind.version           := FALSE;
    v_vd_ind.preferred_definition := FALSE;
    v_vd_ind.long_name           := FALSE;
    v_vd_ind.asl_name           := FALSE;
    v_vd_ind.cd_idseq           := FALSE;
    v_vd_ind.latest_version_ind   := FALSE;
    v_vd_ind.vd_type_flag       := FALSE;
    v_vd_ind.dtl_name           := FALSE;
    v_vd_ind.forml_name        := FALSE;
    v_vd_ind.uoml_name            := FALSE;
    v_vd_ind.low_Value_num       := FALSE;
    v_vd_ind.high_Value_num       := FALSE;
    v_vd_ind.min_length_num       := FALSE;
    v_vd_ind.max_length_num       := FALSE;
    v_vd_ind.decimal_place        := FALSE;
    v_vd_ind.char_set_name       := FALSE;
    v_vd_ind.begin_date           := FALSE;
    v_vd_ind.end_date           := FALSE;
    v_vd_ind.change_note       := FALSE;
    v_vd_ind.created_by           := FALSE;
    v_vd_ind.date_created       := FALSE;
    v_vd_ind.modified_by       := TRUE;
    v_vd_ind.date_modified       := TRUE;
    v_vd_ind.deleted_ind          := TRUE;
 v_vd_ind.origin               := FALSE; -- 24-Jul-2003, W. Ver Hoef

    BEGIN
      cg$value_domains_view.upd(v_vd_rec,v_vd_ind);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
dbms_output.put_line('SQLERRM = '||SQLERRM);
      P_RETURN_CODE := 'API_VD_502'; --Error deleting Value Domain
   RETURN;
    END;

  END IF;

  IF (P_VD_LATEST_VERSION_IND IS NOT NULL) THEN
    IF P_VD_LATEST_VERSION_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_VD_105'; --Version can only be 'Yes' or 'N
      RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
  IF LENGTH(P_VD_PREFERRED_NAME) > Sbrext_Column_Lengths.L_VD_PREFERRED_NAME THEN
    P_RETURN_CODE := 'API_VD_111';  --Length of preferred_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_PREFERRED_DEFINITION) > Sbrext_Column_Lengths.L_VD_PREFERRED_DEFINITION THEN
    P_RETURN_CODE := 'API_VD_113';  --Length of Preferrede Definition exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_LONG_NAME) > Sbrext_Column_Lengths.L_VD_LONG_NAME THEN
    P_RETURN_CODE := 'API_VD_114'; --Length of Long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_ASL_NAME ) > Sbrext_Column_Lengths.L_VD_ASL_NAME  THEN
    P_RETURN_CODE := 'API_VD_115'; --Length of asl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_TYPE_FLAG) > Sbrext_Column_Lengths.L_VD_VD_TYPE_FLAG THEN
    P_RETURN_CODE := 'API_VD_118'; --Length of vd_Type_flag exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_DTL_NAME) > Sbrext_Column_Lengths.L_VD_DTL_NAME     THEN
    P_RETURN_CODE := 'API_VD_119'; --Length of dtl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_FORML_NAME) > Sbrext_Column_Lengths.L_VD_FORML_NAME THEN
    P_RETURN_CODE := 'API_VD_120'; --Length of forml_name  exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_FORML_DESCRIPTION) > Sbrext_Column_Lengths.L_FORML_DESCRIPTION THEN
    P_RETURN_CODE := 'API_VD_121'; --Length of forml_description exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_FORML_COMMENT ) > Sbrext_Column_Lengths.L_FORML_COMMENTS  THEN
    P_RETURN_CODE := 'API_VD_129'; --Length of forml_comments exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_UOML_NAME) > Sbrext_Column_Lengths.L_VD_UOML_NAME THEN
    P_RETURN_CODE := 'API_VD_122'; --Length of uoml_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_UOML_DESCRIPTION ) > Sbrext_Column_Lengths.L_UOML_DESCRIPTION  THEN
    P_RETURN_CODE := 'API_VD_123'; --Length of upml_descriptionexceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_UOML_COMMENT) > Sbrext_Column_Lengths.L_UOML_COMMENTS THEN
    P_RETURN_CODE := 'API_VD_124'; --Length of upml_comments exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_LOW_VALUE_NUM ) > Sbrext_Column_Lengths.L_VD_LOW_VALUE_NUM  THEN
    P_RETURN_CODE := 'API_VD_125'; --Length of low_value_num exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_HIGH_VALUE_NUM) > Sbrext_Column_Lengths.L_VD_HIGH_VALUE_NUM THEN
    P_RETURN_CODE := 'API_VD_126'; --Length of high_value_num exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_CHAR_SET_NAME) > Sbrext_Column_Lengths.L_VD_CHAR_SET_NAME THEN
    P_RETURN_CODE := 'API_VD_127'; --Length of char_set_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_CHANGE_NOTE) > Sbrext_Column_Lengths.L_VD_CHANGE_NOTE THEN
    P_RETURN_CODE := 'API_VD_128'; --Length of change_note exceeds maximum length
    RETURN;
  END IF;

  --check to see that charachter strings are valid
  IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_VD_PREFERRED_NAME) THEN
    P_RETURN_CODE := 'API_VD_130'; -- Value Domain Preferred Name has invalid Ccharacters
    RETURN;
  END IF;
  --this block of code has been commented out because formats and unit of measures will have alpha numberic charachters
  /*IF  P_VD_FORML_NAME IS NOT NULL THEN
      IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_VD_FORML_NAME) THEN
      P_RETURN_CODE := 'API_VD_131'; -- Value Domain Format Name has invalid characters
      RETURN;
    END IF;
  END IF;

  IF P_VD_UOML_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_VD_UOML_NAME) THEN
      P_RETURN_CODE := 'API_VD_132'; -- Value Domain UOML Name has invalid characters
      RETURN;
    END IF;
  END IF;
  */
  IF NOT Sbrext_Common_Routines.valid_char(P_VD_PREFERRED_DEFINITION) THEN
    P_RETURN_CODE := 'API_VD_133'; -- Value Domain Preferred Definition has invalid characters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_VD_LONG_NAME) THEN
    P_RETURN_CODE := 'API_VD_134'; -- Value Domain Long Name has invalid characters
    RETURN;
  END IF;
  IF P_FORML_DESCRIPTION IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_FORML_DESCRIPTION) THEN
      P_RETURN_CODE := 'API_VD_135'; -- Format Description has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_FORML_COMMENT IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_FORML_COMMENT) THEN
      P_RETURN_CODE := 'API_VD_136'; -- Format Comment has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_UOML_DESCRIPTION IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_UOML_DESCRIPTION) THEN
      P_RETURN_CODE := 'API_VD_137'; -- Unit of Measure Description has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_UOML_COMMENT IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_UOML_COMMENT) THEN
      P_RETURN_CODE := 'API_VD_138'; -- Unit of Measure Comment has invalid characters
      RETURN;
    END IF;
  END IF;

  --check to see that Context, Workflow Status, Data type, Character Set, Conceptual Domain already exist in the database
  IF P_ACTION = 'INS' THEN
    -- This check should be performed only in inserts as update and delete expect null conte_idseq
    IF NOT Sbrext_Common_Routines.context_exists(P_VD_CONTE_IDSEQ) THEN
      P_RETURN_CODE := 'API_VD_200'; --Context not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_VD_CD_IDSEQ IS NOT NULL THEN -- 24-Jul-2003, W. Ver Hoef
    IF NOT Sbrext_Common_Routines.ac_exists(P_VD_CD_IDSEQ) THEN
      P_RETURN_CODE := 'API_VD_201'; --Conceptual Domain not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_VD_ASL_NAME IS NOT NULL THEN -- 24-Jul-2003, W. Ver Hoef
    IF NOT Sbrext_Common_Routines.workflow_exists(P_VD_ASL_NAME) THEN
      P_RETURN_CODE := 'API_VD_202'; --Workflow Status not found in the database
      RETURN;
    END IF;
  END IF;
  IF (P_VD_CHAR_SET_NAME IS NOT NULL AND P_VD_CHAR_SET_NAME != ' ') THEN
    IF NOT Sbrext_Common_Routines.char_set_exists(P_VD_CHAR_SET_NAME) THEN
      P_RETURN_CODE := 'API_VD_203'; --Character set not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_VD_DTL_NAME IS NOT NULL THEN -- 24-Jul-2003, W. Ver Hoef
    IF NOT Sbrext_Common_Routines.data_type_exists(P_VD_DTL_NAME) THEN
      P_RETURN_CODE := 'API_VD_204'; --DATA_TYPE NOT found in the database
      RETURN;
    END IF;
  END IF;
  IF P_VD_REP_IDSEQ IS NOT NULL AND P_VD_REP_IDSEQ != ' ' THEN
    IF NOT Sbrext_Common_Routines.ac_exists(P_VD_REP_IDSEQ )  THEN
      P_RETURN_CODE := 'API_VD_207'; --Representation term does not exist
      RETURN;
    END IF;
  END IF;
  IF P_VD_QUALIFIER_NAME IS NOT NULL AND P_VD_QUALIFIER_NAME != ' ' THEN
    IF NOT Sbrext_Common_Routines.qual_exists(P_VD_QUALIFIER_NAME )  THEN
      P_RETURN_CODE := 'API_VD_208'; --Qualifier does not exist
      RETURN;
    END IF;
  END IF;

  --check to see that begin data and end date are valid dates
  IF(P_VD_BEGIN_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_VD_BEGIN_DATE,v_begin_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_VD_600'; --begin date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_VD_END_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_VD_END_DATE,v_end_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_VD_601'; --end date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_VD_BEGIN_DATE IS NOT NULL AND P_VD_END_DATE IS NOT NULL) THEN
    IF(v_end_date < v_begin_date) THEN
      P_RETURN_CODE := 'API_VD_210'; --end date is before begin date
      RETURN;
    END IF;
  --ELSIF(P_VD_END_DATE IS NOT NULL AND P_VD_BEGIN_DATE IS NULL) THEN
    --P_RETURN_CODE := 'API_VD_211'; --begin date cannot be null when end date is null
    --RETURN;
  END IF;

  --check to see that format description  or comments are sent in without the formt name
  IF(P_VD_FORML_NAME IS NULL AND ( P_FORML_DESCRIPTION IS NOT NULL OR P_FORML_COMMENT IS NOT NULL)) THEN
    P_RETURN_CODE := 'API_VD_205'; --cannot send in format description and comments without format name
    RETURN;
  END IF;
  IF(P_VD_UOML_NAME IS NULL AND ( P_UOML_DESCRIPTION IS NOT NULL OR P_UOML_COMMENT IS NOT NULL)) THEN
    P_RETURN_CODE := 'API_VD_206'; --cannot send in UOML description and comments without UOML name
    RETURN;
  END IF;

  --check to see that Format, Unit of measure already exist in the database , ifthey do not then create them
  IF( P_VD_FORML_NAME IS NOT NULL AND P_VD_FORML_NAME != ' ' ) THEN

    IF NOT(Sbrext_Common_Routines.vd_format_exists(P_VD_FORML_NAME)) THEN
      v_forml_rec.forml_name  := P_VD_FORML_NAME;
      v_forml_rec.description := P_FORML_DESCRIPTION;
      v_forml_rec.comments    := P_FORML_COMMENT;
      v_forml_ind.forml_name  := TRUE;
      v_forml_ind.description := TRUE;
      v_forml_ind.comments    := TRUE;
      BEGIN
        cg$formats_lov_view.ins(v_forml_rec,v_forml_ind);
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_FORML_500' ;--error inserting format
      END;
    END IF;
  END IF;

  IF (P_VD_UOML_NAME IS NOT NULL AND P_VD_UOML_NAME != ' ') THEN
    IF NOT(Sbrext_Common_Routines.uoml_exists(P_VD_UOML_NAME)) THEN
      v_uoml_rec.uoml_name   := P_VD_UOML_NAME;
      v_uoml_rec.description := P_UOML_DESCRIPTION;
      v_uoml_rec.comments    := P_UOML_COMMENT;
      v_uoml_ind.uoml_name   := TRUE;
      v_uoml_ind.description := TRUE;
      v_uoml_ind.comments    := TRUE;
      BEGIN
        cg$Unit_of_measures_lov_view.ins(v_uoml_rec,v_uoml_ind);
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_UOML_500' ;--error inserting UOML
       RETURN;
      END;
    END IF;
  END IF;

  IF (P_ACTION = 'INS' ) THEN

    --check to see that  a Value Domain with the same
    --Preferred Name, Context and Version does not already exist
    IF Sbrext_Common_Routines.ac_exists(P_VD_PREFERRED_NAME,P_VD_CONTE_IDSEQ ,P_VD_VERSION,'VALUEDOMAIN') THEN
      P_RETURN_CODE := 'API_VD_300';-- Value Domain already Exists
      RETURN;
    END IF;
    --Check to see if prior versions alresdy exist
    IF Sbrext_Common_Routines.ac_version_exists(P_VD_PREFERRED_NAME,P_VD_CONTE_IDSEQ ,'VALUEDOMAIN') THEN -- we are creating a new version
      v_new_version := TRUE;
      v_ac          := Sbrext_Common_Routines.get_version_ac(P_VD_PREFERRED_NAME,P_VD_CONTE_IDSEQ,'VALUEDOMAIN');
    END IF;
 if p_vd_preferred_name = 'System Generated' then
   v_vd_preferred_name := null;
 else
   v_vd_preferred_name := p_vd_preferred_name;
 end if;
    --add code here to check for versioning
    P_VD_VD_IDSEQ      := admincomponent_crud.cmr_guid;
    P_VD_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_VD_CREATED_BY    := P_UA_NAME;   --USER
    P_VD_DATE_MODIFIED := NULL;
    P_VD_MODIFIED_BY   := NULL;
    P_VD_DELETED_IND   := 'No';

    v_vd_rec.vd_idseq           := P_VD_VD_IDSEQ;
    v_vd_rec.preferred_name       := P_VD_PREFERRED_NAME;
    v_vd_rec.conte_idseq       := P_VD_CONTE_IDSEQ;
    v_vd_rec.version           := P_VD_VERSION;
    v_vd_rec.preferred_definition := P_VD_PREFERRED_DEFINITION;
    v_vd_rec.long_name           := P_VD_LONG_NAME;
    v_vd_rec.asl_name           := P_VD_ASL_NAME ;
    v_vd_rec.cd_idseq           := P_VD_CD_IDSEQ ;
    v_vd_rec.latest_version_ind   := P_VD_LATEST_VERSION_IND;
    v_vd_rec.vd_type_flag       := P_VD_TYPE_FLAG;
    v_vd_rec.dtl_name           := P_VD_DTL_NAME;
    v_vd_rec.forml_name        := P_VD_FORML_NAME;
    v_vd_rec.uoml_name            := P_VD_UOML_NAME;
    v_vd_rec.low_value_num       := P_VD_LOW_VALUE_NUM;
    v_vd_rec.high_value_num       := P_VD_HIGH_VALUE_NUM;
    v_vd_rec.min_length_num       := P_VD_MIN_LENGTH_NUM;
    v_vd_rec.max_length_num       := P_VD_MAX_LENGTH_NUM ;
    v_vd_rec.decimal_place        := P_VD_DECIMAL_PLACE;
    v_vd_rec.char_set_name       := P_VD_CHAR_SET_NAME;
    v_vd_rec.begin_date           := TO_DATE(P_VD_BEGIN_DATE);
    v_vd_rec.end_date           := TO_DATE(P_VD_END_DATE);
    v_vd_rec.change_note       := P_VD_CHANGE_NOTE ;
    v_vd_rec.created_by           := P_VD_CREATED_BY;
    v_vd_rec.date_created       := TO_DATE(P_VD_DATE_CREATED);
    v_vd_rec.modified_by       := P_VD_MODIFIED_BY;
    v_vd_rec.date_modified       := TO_DATE(P_VD_DATE_MODIFIED);
    v_vd_rec.deleted_ind          := P_VD_DELETED_IND;
    v_vd_rec.rep_idseq            := P_VD_REP_IDSEQ;
    v_vd_rec.qualifier_name       := P_VD_QUALIFIER_NAME;
 v_vd_rec.origin               := P_VD_ORIGIN;  -- 24-Jul-2003, W. Ver Hoef

    v_vd_ind.vd_idseq           := TRUE;
    v_vd_ind.preferred_name       := TRUE;
    v_vd_ind.conte_idseq       := TRUE;
    v_vd_ind.version           := TRUE;
    v_vd_ind.preferred_definition := TRUE;
    v_vd_ind.long_name           := TRUE;
    v_vd_ind.asl_name           := TRUE;
    v_vd_ind.cd_idseq           := TRUE;
    v_vd_ind.latest_version_ind   := TRUE;
    v_vd_ind.vd_type_flag       := TRUE;
    v_vd_ind.dtl_name           := TRUE;
    v_vd_ind.forml_name        := TRUE;
    v_vd_ind.uoml_name            := TRUE;
    v_vd_ind.low_value_num       := TRUE;
    v_vd_ind.high_value_num       := TRUE;
    v_vd_ind.min_length_num       := TRUE;
    v_vd_ind.max_length_num       := TRUE;
    v_vd_ind.decimal_place        := TRUE;
    v_vd_ind.char_set_name       := TRUE;
    v_vd_ind.begin_date           := TRUE;
    v_vd_ind.end_date           := TRUE;
    v_vd_ind.change_note       := TRUE;
    v_vd_ind.created_by           := TRUE;
    v_vd_ind.date_created       := TRUE;
    v_vd_ind.modified_by       := TRUE;
    v_vd_ind.date_modified       := TRUE;
    v_vd_ind.deleted_ind          := TRUE;
    v_vd_ind.rep_idseq            := TRUE;
    v_vd_ind.qualifier_name       := TRUE;
 v_vd_ind.origin               := TRUE; -- 24-Jul-2003, W. Ver Hoef

    BEGIN
      --meta_global_pkg.transaction_type := 'VERSION';
      cg$value_domains_view.ins(v_vd_rec,v_vd_ind);
   if p_vd_preferred_name = 'System Generated' then

     p_vd_preferred_name := sbrext_common_routines.GENERATE_VD_PREFERRED_NAME(p_vd_vd_idseq);
  update value_domains
  set preferred_name = p_vd_preferred_name
  where vd_idseq = p_vd_vd_idseq;
   end if;

      --meta_global_pkg.transaction_type := NULL;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_VD_500'; --Error inserting Value Domain
    END;

    --If LATEST_VERSION_IND is'Yes' then update so that all other versions have the indicator set to 'No'
    IF(P_VD_LATEST_VERSION_IND = 'Yes') THEN
      Sbrext_Common_Routines.set_ac_lvi(P_RETURN_CODE,P_VD_VD_IDSEQ,'VALUEDOMAIN');
      IF P_RETURN_CODE IS NOT NULL  THEN
        P_RETURN_CODE := 'API_VD_503'; -- Error updating latest_Value_ind
        RETURN;
      END IF;
    END IF;
    --create a history record with prior version
    IF v_new_version THEN
      BEGIN
        meta_config_mgmt.CREATE_AC_HISTORIES (v_ac,P_VD_VD_IDSEQ,'VERSIONED','VALUEDOMAIN');
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_VD_504'; --Error creating history
      END;
    END IF;

  END IF;

  IF (P_ACTION = 'UPD' ) THEN

    --Get the version for the P_VD_VDIDSEQ
    SELECT version
 INTO   v_version
    FROM   value_domains_view
    WHERE  vd_idseq = P_VD_VD_IDSEQ;

 IF P_VD_VERSION IS NOT NULL THEN  -- 24-JUL-2003, W. Ver Hoef
      IF v_version <> P_VD_VERSION THEN
        P_RETURN_CODE := 'API_VD_402'; -- Version can NOT be updated. It can only be created
        RETURN;
      END IF;
 END IF;

    P_VD_DATE_MODIFIED := TO_CHAR(SYSDATE);
    P_VD_MODIFIED_BY   := P_UA_NAME;   --USER
    P_VD_DELETED_IND   := 'No';

    v_vd_rec.date_modified := P_VD_DATE_MODIFIED;
    v_vd_rec.modified_by   := P_VD_MODIFIED_BY;
    v_vd_rec.vd_idseq      := P_VD_VD_IDSEQ;
    v_vd_rec.deleted_ind   := 'No';

    v_vd_ind.date_modified := TRUE;
    v_vd_ind.modified_by   := TRUE;
    v_vd_ind.deleted_ind   := TRUE;
    v_vd_ind.vd_idseq      := TRUE;

    v_vd_ind.version       := FALSE;
    v_vd_ind.created_by    := FALSE;
    v_vd_ind.date_created  := FALSE;

    IF P_VD_PREFERRED_NAME IS NULL THEN
      v_vd_ind.preferred_name := FALSE;
    ELSE
  if p_vd_preferred_name = 'System Generated' then
    v_vd_rec.preferred_name := sbrext_common_routines.GENERATE_VD_PREFERRED_NAME(p_vd_vd_idseq);
     else
   v_vd_rec.preferred_name := P_VD_PREFERRED_NAME;
  end if;
      v_vd_ind.preferred_name := TRUE;
    END IF;

    IF P_VD_CONTE_IDSEQ IS NULL THEN
      v_vd_ind.conte_idseq := FALSE;
    ELSE
      v_vd_rec.conte_idseq := P_VD_CONTE_IDSEQ;
      v_vd_ind.conte_idseq := TRUE;
    END IF;

    IF P_VD_PREFERRED_DEFINITION IS NULL THEN
      v_vd_ind.preferred_definition:= FALSE;
    ELSE
      v_vd_rec.preferred_definition := P_VD_PREFERRED_DEFINITION;
      v_vd_ind.preferred_definition := TRUE;
    END IF;

    IF P_VD_LONG_NAME IS NULL THEN
      v_vd_ind.long_name := FALSE;
 ELSIF P_VD_LONG_NAME = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.long_name := NULL;
      v_vd_ind.long_name := TRUE;
    ELSE
      v_vd_rec.long_name := P_VD_LONG_NAME;
      v_vd_ind.long_name := TRUE;
    END IF;

    IF P_VD_ASL_NAME IS NULL THEN
      v_vd_ind.asl_name := FALSE;
    ELSE
      v_vd_rec.asl_name := P_VD_ASL_NAME;
      v_vd_ind.asl_name := TRUE;
    END IF;

    IF P_VD_CD_IDSEQ IS NULL THEN
      v_vd_ind.cd_idseq := FALSE;
    ELSE
      v_vd_rec.cd_idseq := P_VD_CD_IDSEQ;
      v_vd_ind.cd_idseq := TRUE;
    END IF;

    IF P_VD_LATEST_VERSION_IND IS NULL THEN
      v_vd_ind.latest_version_ind := FALSE;
    ELSE
      v_vd_rec.latest_version_ind := P_VD_LATEST_VERSION_IND;
      v_vd_ind.latest_version_ind := TRUE;
    END IF;

    IF P_VD_TYPE_FLAG IS NULL THEN
      v_vd_ind.vd_type_flag := FALSE;
    ELSE
      v_vd_rec.vd_type_flag := P_VD_TYPE_FLAG;
      v_vd_ind.vd_type_flag := TRUE;
    END IF;

    IF P_VD_DTL_NAME IS NULL THEN
      v_vd_ind.dtl_name := FALSE;
    ELSE
      v_vd_rec.dtl_name := P_VD_DTL_NAME;
      v_vd_ind.dtl_name := TRUE;
    END IF;

    IF P_VD_FORML_NAME IS NULL THEN
      v_vd_ind.forml_name := FALSE;
 ELSIF P_VD_FORML_NAME = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.forml_name := NULL;
      v_vd_ind.forml_name := TRUE;
    ELSE
      v_vd_rec.forml_name := P_VD_FORML_NAME;
      v_vd_ind.forml_name := TRUE;
    END IF;

    IF P_VD_UOML_NAME IS NULL THEN
      v_vd_ind.uoml_name := FALSE;
 ELSIF P_VD_UOML_NAME = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.uoml_name := NULL;
      v_vd_ind.uoml_name := TRUE;
    ELSE
      v_vd_rec.uoml_name := P_VD_UOML_NAME ;
      v_vd_ind.uoml_name := TRUE;
    END IF;

    IF P_VD_LOW_VALUE_NUM IS NULL THEN
      v_vd_ind.low_value_num := FALSE;
 ELSIF P_VD_low_value_num = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.low_value_num := NULL;
      v_vd_ind.low_value_num := TRUE;
    ELSE
      v_vd_rec.low_value_num := P_VD_LOW_VALUE_NUM;
      v_vd_ind.low_value_num := TRUE;
    END IF;

    IF P_VD_HIGH_VALUE_NUM IS NULL THEN
      v_vd_ind.high_Value_num := FALSE;
 ELSIF P_VD_high_value_num = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.high_value_num := NULL;
      v_vd_ind.high_value_num := TRUE;
    ELSE
      v_vd_rec.high_value_num := P_VD_HIGH_VALUE_NUM;
      v_vd_ind.high_value_num := TRUE;
    END IF;

    IF P_VD_MIN_LENGTH_NUM IS NULL THEN
      v_vd_ind.min_length_num := FALSE;
 ELSIF P_VD_min_length_num = -1 THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.min_length_num := NULL;
      v_vd_ind.min_length_num := TRUE;
    ELSE
      v_vd_rec.min_length_num := P_VD_MIN_LENGTH_NUM;
      v_vd_ind.min_length_num := TRUE;
    END IF;

    IF P_VD_MAX_LENGTH_NUM  IS NULL THEN
     v_vd_ind.max_length_num := FALSE;
 ELSIF P_VD_max_length_num = -1 THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.max_length_num := NULL;
      v_vd_ind.max_length_num := TRUE;
    ELSE
     v_vd_rec.max_length_num := P_VD_MAX_LENGTH_NUM ;
     v_vd_ind.max_length_num := TRUE;
    END IF;

    IF P_VD_DECIMAL_PLACE IS NULL THEN
      v_vd_ind.decimal_place := FALSE;
 ELSIF P_VD_decimal_place = -1 THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.decimal_place := NULL;
      v_vd_ind.decimal_place := TRUE;
    ELSE
      v_vd_rec.decimal_place := P_VD_DECIMAL_PLACE;
      v_vd_ind.decimal_place := TRUE;
    END IF;

    IF P_VD_CHAR_SET_NAME IS NULL THEN
      v_vd_ind.char_set_name := FALSE;
 ELSIF P_VD_char_set_name = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.char_set_name := NULL;
      v_vd_ind.char_set_name := TRUE;
    ELSE
      v_vd_rec.char_set_name := P_VD_CHAR_SET_NAME;
      v_vd_ind.char_set_name := TRUE;
    END IF;

    IF P_VD_BEGIN_DATE IS NULL THEN
      v_vd_ind.begin_date := FALSE;
 ELSIF P_VD_begin_date = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.begin_date := NULL;
      v_vd_ind.begin_date := TRUE;
    ELSE
      v_vd_rec.begin_date := TO_DATE(P_VD_BEGIN_DATE);
      v_vd_ind.begin_date := TRUE;
    END IF;

    IF P_VD_END_DATE  IS NULL THEN
      v_vd_ind.end_date := FALSE;
 ELSIF P_VD_end_date = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.end_date := NULL;
      v_vd_ind.end_date := TRUE;
    ELSE
      v_vd_rec.end_date := TO_DATE(P_VD_END_DATE);
      v_vd_ind.end_date := TRUE;
    END IF;

    IF P_VD_CHANGE_NOTE   IS NULL THEN
      v_vd_ind.change_note := FALSE;
 ELSIF P_VD_change_note = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.change_note := NULL;
      v_vd_ind.change_note := TRUE;
    ELSE
      v_vd_rec.change_note := P_VD_CHANGE_NOTE  ;
      v_vd_ind.change_note := TRUE;
    END IF;

    IF P_VD_REP_IDSEQ  IS NULL THEN
      v_vd_ind.rep_idseq := FALSE;
 ELSIF P_VD_REP_IDSEQ = ' ' THEN -- Condition added on 7/30/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.rep_idseq := NULL;
      v_vd_ind.rep_idseq := TRUE;
    ELSE
      v_vd_rec.rep_idseq := P_VD_REP_IDSEQ;
      v_vd_ind.rep_idseq := TRUE;
    END IF;

    IF P_VD_QUALIFIER_NAME   IS NULL THEN
      v_vd_ind.qualifier_name := FALSE;
 ELSIF P_VD_QUALIFIER_NAME = ' ' THEN -- Condition added on 7/30/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.qualifier_name := NULL;
      v_vd_ind.qualifier_name := TRUE;
    ELSE
      v_vd_rec.qualifier_name := P_VD_QUALIFIER_NAME  ;
      v_vd_ind.qualifier_name := TRUE;
    END IF;

    IF P_VD_ORIGIN   IS NULL THEN  -- 24-Jul-2003, W. Ver Hoef
      v_vd_ind.origin := FALSE;
 ELSIF P_VD_origin = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.origin := NULL;
      v_vd_ind.origin := TRUE;
    ELSE
      v_vd_rec.origin := P_VD_ORIGIN  ;
      v_vd_ind.origin := TRUE;
    END IF;

    BEGIN
      cg$value_domains_view.upd(v_vd_rec,v_vd_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_VD_501'; --Error updating Value Domain
    END;

    --If LATEST_VERSION_IND is'Yes' then update so that all other versions have the indicator set to 'No'
    IF(P_VD_LATEST_VERSION_IND = 'Yes') THEN
      Sbrext_Common_Routines.set_ac_lvi(P_RETURN_CODE,P_VD_VD_IDSEQ,'VALUEDOMAIN');
      IF P_RETURN_CODE IS NOT NULL  THEN
        P_RETURN_CODE := 'API_VD_503'; -- Error updating latest_Value_ind
        RETURN;
      END IF;
    END IF;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;
END SET_VD;


PROCEDURE SET_VD(
 P_UA_NAME          IN VARCHAR2
,P_RETURN_CODE          OUT    VARCHAR2
,P_VD_CON_ARRAY                        IN     VARCHAR2
, P_ACTION                     IN     VARCHAR2
, P_VD_VD_IDSEQ               IN OUT VARCHAR2
, P_VD_PREFERRED_NAME         IN OUT VARCHAR2
, P_VD_CONTE_IDSEQ           IN OUT VARCHAR2
, P_VD_VERSION               IN OUT NUMBER
, P_VD_PREFERRED_DEFINITION   IN OUT VARCHAR2
, P_VD_CD_IDSEQ               IN OUT VARCHAR2
, P_VD_ASL_NAME               IN OUT VARCHAR2
, P_VD_LATEST_VERSION_IND      IN OUT VARCHAR2
, P_VD_DTL_NAME               IN OUT VARCHAR2
, P_VD_MAX_LENGTH_NUM          IN OUT NUMBER
, P_VD_LONG_NAME              IN OUT VARCHAR2
, P_VD_FORML_NAME            IN OUT VARCHAR2
, P_FORML_DESCRIPTION         IN OUT VARCHAR2
, P_FORML_COMMENT              IN OUT VARCHAR2
, P_VD_UOML_NAME               IN OUT VARCHAR2
, P_UOML_DESCRIPTION           IN OUT VARCHAR2
, P_UOML_COMMENT               IN OUT VARCHAR2
, P_VD_LOW_VALUE_NUM          IN OUT VARCHAR2
, P_VD_HIGH_VALUE_NUM       IN OUT VARCHAR2
, P_VD_MIN_LENGTH_NUM       IN OUT NUMBER
, P_VD_DECIMAL_PLACE        IN OUT NUMBER
, P_VD_CHAR_SET_NAME          IN OUT VARCHAR2
, P_VD_BEGIN_DATE           IN OUT VARCHAR2
, P_VD_END_DATE               IN OUT VARCHAR2
, P_VD_CHANGE_NOTE           IN OUT VARCHAR2
, P_VD_TYPE_FLAG              IN OUT VARCHAR2
, P_VD_CREATED_BY           OUT VARCHAR2
, P_VD_DATE_CREATED           OUT VARCHAR2
, P_VD_MODIFIED_BY           OUT VARCHAR2
, P_VD_DATE_MODIFIED          OUT VARCHAR2
, P_VD_DELETED_IND           OUT VARCHAR2
, P_VD_CONDR_IDSEQ                 IN OUT VARCHAR2
, P_VD_REP_IDSEQ                    IN VARCHAR2 DEFAULT NULL
, P_VD_QUALIFIER_NAME               IN VARCHAR2 DEFAULT NULL
, P_VD_ORIGIN                       IN VARCHAR2 DEFAULT NULL)IS

v_version     value_domains_view.version%TYPE;
v_ac          value_domains_view.vd_idseq%TYPE;
v_asl_name    value_domains_view.asl_name%TYPE;

v_description VARCHAR2(60);
v_comments    VARCHAR2(2000);
v_begin_date  DATE := NULL;
v_end_date    DATE := NULL;
v_new_version BOOLEAN :=FALSE;

v_vd_rec    cg$value_domains_view.cg$row_type;
v_forml_rec cg$formats_lov_view.cg$row_type;
v_uoml_rec  cg$unit_of_measures_lov_view.cg$row_type;
v_vd_ind    cg$value_domains_view.cg$ind_type;
v_forml_ind cg$formats_lov_view.cg$ind_type;
v_uoml_ind  cg$unit_of_measures_lov_view.cg$ind_type;
v_count number;
v_vd_preferred_name administered_components.preferred_name%type;

BEGIN
  P_RETURN_CODE := NULL;

  IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
    P_RETURN_CODE := 'API_VD_700'; -- Invalid action
    RETURN;
  END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  IF P_ACTION = 'INS' THEN              --we are inserting a record
    IF P_VD_VD_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_VD_100' ;  --for inserts the ID is generated
   RETURN;
    ELSE
      --Check to see that all mandatory parameters are either not NULL or have a default value.
          IF P_VD_PREFERRED_NAME IS NULL THEN
     P_RETURN_CODE := 'API_VD_101';  --Preferred Name cannot be null here
  RETURN;
          END IF;
   IF P_VD_CONTE_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_VD_102'; --CONTE_IDSEQ cannot be null here
  RETURN;
   END IF;
   IF P_VD_PREFERRED_DEFINITION IS NULL THEN
     P_RETURN_CODE := 'API_VD_103'; --Preferred Definition cannot be null here
  RETURN;
   END IF;
   IF P_VD_ASL_NAME IS NULL THEN
     -- 19-Mar-2004, W. Ver Hoef - substituted UNASSIGNED with function call below
     P_VD_ASL_NAME := Sbrext_Common_Routines.get_default_asl('INS'); -- 'UNASSIGNED';
   END IF;
   IF P_VD_VERSION IS NULL THEN
     P_VD_VERSION := Sbrext_Common_Routines.get_ac_version(p_vd_preferred_name,p_vd_conte_idseq,'VALUEDOMAIN','HIGHEST') + 1;
   END IF;
   IF P_VD_CD_IDSEQ IS NULL THEN
     P_VD_CD_IDSEQ := Sbrext_Common_Routines.get_cd(P_VD_CONTE_IDSEQ);
  IF P_VD_CD_IDSEQ IS NULL THEN
       P_RETURN_CODE := 'API_VD_104'; --default CD_IDSEQ not found
    RETURN;
  END IF;
   END IF;
   IF P_VD_LATEST_VERSION_IND IS NULL THEN
     P_VD_LATEST_VERSION_IND := 'No';
      END IF;
   IF P_VD_TYPE_FLAG IS NULL THEN
     P_VD_TYPE_FLAG  := 'N';
   ELSIF P_VD_TYPE_FLAG NOT IN ('E','N','R') THEN -- 26-Mar-2004, W. Ver Hoef - added R
     P_RETURN_CODE := 'API_VD_106'; --VD type flag can be ;E or N or OR only
  RETURN;
   END IF;
   IF P_VD_DTL_NAME IS NULL THEN
     P_VD_DTL_NAME := 'CHARACTER';
   END IF;
   /* Commented out on 9/4/2003 since max length should not default to 0
   IF P_VD_MAX_LENGTH_NUM IS NULL THEN
     P_VD_MAX_LENGTH_NUM := 0;
   END IF;*/
    END IF;

  if upper(P_VD_PREFERRED_NAME) <> 'SYSTEM GENERATED' then
   select count(*) into v_count
   from value_Domains
   where preferred_name = p_vd_PREFERRED_NAME
   and version = p_vd_Version
   and conte_idseq = p_vd_conte_idseq;

   if v_count <> 0 then
     P_RETURN_CODE := 'API_VD_550'; -- unique constraint violeted;
     RETURN;
   end if;
  end if;
  END IF;

  IF P_ACTION = 'UPD' THEN              --we are updating a record
    admin_security_util.seteffectiveuser(p_ua_name);
    IF P_VD_VD_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_VD_400' ;  --for updates the ID IS mandatory
   RETURN;
    END IF;
    SELECT asl_name
 INTO   v_asl_name
    FROM   value_domains_View
    WHERE  vd_idseq = P_VD_VD_IDSEQ;
    IF (P_VD_PREFERRED_NAME IS NOT NULL OR P_VD_CONTE_IDSEQ IS NOT NULL) AND v_asl_name = 'RELEASED'  THEN
      P_RETURN_CODE := 'API_VD_401' ;  --Preferred Name or Context Can not be updated
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(P_VD_VD_IDSEQ) THEN
      P_RETURN_CODE := 'API_VD_005'; --VD NOT found
      RETURN;
    END IF;
 -- 26-Mar-2004, W. Ver Hoef - added validation on vd_type_flag
 IF P_VD_TYPE_FLAG NOT IN ('E','N','R') THEN -- 26-Mar-2004, W. Ver Hoef - added R
   P_RETURN_CODE := 'API_VD_106'; --VD type flag can be ;E or N or OR only
   RETURN;
 END IF;
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are logically deleteing a record

    IF P_VD_VD_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_VD_400' ;  --for deletes the ID IS mandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ac_exists(P_VD_VD_IDSEQ) THEN
     P_RETURN_CODE := 'API_VD_005'; --Value Domain not found
     RETURN;
   END IF;
    END IF;

    P_VD_DELETED_IND   := 'Yes';
    P_VD_MODIFIED_BY   :=  P_UA_NAME;  --USER;
    P_VD_DATE_MODIFIED := TO_CHAR(SYSDATE);

    v_vd_rec.vd_idseq      := P_VD_VD_IDSEQ;
    v_vd_rec.deleted_ind   := P_VD_DELETED_IND;
    v_vd_rec.modified_by   := P_VD_MODIFIED_BY;
    v_vd_rec.date_modified := TO_DATE(P_VD_DATE_MODIFIED);

    v_vd_ind.vd_idseq           := TRUE;
    v_vd_ind.preferred_name       := FALSE;
    v_vd_ind.conte_idseq       := FALSE;
    v_vd_ind.version           := FALSE;
    v_vd_ind.preferred_definition := FALSE;
    v_vd_ind.long_name           := FALSE;
    v_vd_ind.asl_name           := FALSE;
    v_vd_ind.cd_idseq           := FALSE;
    v_vd_ind.latest_version_ind   := FALSE;
    v_vd_ind.vd_type_flag       := FALSE;
    v_vd_ind.dtl_name           := FALSE;
    v_vd_ind.forml_name        := FALSE;
    v_vd_ind.uoml_name            := FALSE;
    v_vd_ind.low_Value_num       := FALSE;
    v_vd_ind.high_Value_num       := FALSE;
    v_vd_ind.min_length_num       := FALSE;
    v_vd_ind.max_length_num       := FALSE;
    v_vd_ind.decimal_place        := FALSE;
    v_vd_ind.char_set_name       := FALSE;
    v_vd_ind.begin_date           := FALSE;
    v_vd_ind.end_date           := FALSE;
    v_vd_ind.change_note       := FALSE;
    v_vd_ind.created_by           := FALSE;
    v_vd_ind.date_created       := FALSE;
    v_vd_ind.modified_by       := TRUE;
    v_vd_ind.date_modified       := TRUE;
    v_vd_ind.deleted_ind          := TRUE;
 v_vd_ind.origin               := FALSE; -- 24-Jul-2003, W. Ver Hoef

    BEGIN
      cg$value_domains_view.upd(v_vd_rec,v_vd_ind);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
dbms_output.put_line('SQLERRM = '||SQLERRM);
      P_RETURN_CODE := 'API_VD_502'; --Error deleting Value Domain
   RETURN;
    END;

  END IF;

  IF P_VD_CON_ARRAY is not null then
    P_VD_CONDR_IDSEQ := sbrext_common_routines.SET_DERIVATION_RULE(P_VD_CON_ARRAY);
    IF P_VD_CONDR_IDSEQ = 'Concept Not Found' then
      P_RETURN_CODE := 'Concept Not Found';
   RETURN;
    END IF;
  END IF;

  IF P_VD_CONDR_IDSEQ is not null then
   if not sbrext_common_routines.CONDR_EXISTS(P_VD_CONDR_IDSEQ) then
     P_RETURN_CODE := 'API_VD_600';--concept derivation does not exist
   end if;
  END IF;

  IF (P_VD_LATEST_VERSION_IND IS NOT NULL) THEN
    IF P_VD_LATEST_VERSION_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_VD_105'; --Version can only be 'Yes' or 'N
      RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
  IF LENGTH(P_VD_PREFERRED_NAME) > Sbrext_Column_Lengths.L_VD_PREFERRED_NAME THEN
    P_RETURN_CODE := 'API_VD_111';  --Length of preferred_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_PREFERRED_DEFINITION) > Sbrext_Column_Lengths.L_VD_PREFERRED_DEFINITION THEN
    P_RETURN_CODE := 'API_VD_113';  --Length of Preferrede Definition exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_LONG_NAME) > Sbrext_Column_Lengths.L_VD_LONG_NAME THEN
    P_RETURN_CODE := 'API_VD_114'; --Length of Long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_ASL_NAME ) > Sbrext_Column_Lengths.L_VD_ASL_NAME  THEN
    P_RETURN_CODE := 'API_VD_115'; --Length of asl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_TYPE_FLAG) > Sbrext_Column_Lengths.L_VD_VD_TYPE_FLAG THEN
    P_RETURN_CODE := 'API_VD_118'; --Length of vd_Type_flag exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_DTL_NAME) > Sbrext_Column_Lengths.L_VD_DTL_NAME     THEN
    P_RETURN_CODE := 'API_VD_119'; --Length of dtl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_FORML_NAME) > Sbrext_Column_Lengths.L_VD_FORML_NAME THEN
    P_RETURN_CODE := 'API_VD_120'; --Length of forml_name  exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_FORML_DESCRIPTION) > Sbrext_Column_Lengths.L_FORML_DESCRIPTION THEN
    P_RETURN_CODE := 'API_VD_121'; --Length of forml_description exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_FORML_COMMENT ) > Sbrext_Column_Lengths.L_FORML_COMMENTS  THEN
    P_RETURN_CODE := 'API_VD_129'; --Length of forml_comments exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_UOML_NAME) > Sbrext_Column_Lengths.L_VD_UOML_NAME THEN
    P_RETURN_CODE := 'API_VD_122'; --Length of uoml_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_UOML_DESCRIPTION ) > Sbrext_Column_Lengths.L_UOML_DESCRIPTION  THEN
    P_RETURN_CODE := 'API_VD_123'; --Length of upml_descriptionexceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_UOML_COMMENT) > Sbrext_Column_Lengths.L_UOML_COMMENTS THEN
    P_RETURN_CODE := 'API_VD_124'; --Length of upml_comments exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_LOW_VALUE_NUM ) > Sbrext_Column_Lengths.L_VD_LOW_VALUE_NUM  THEN
    P_RETURN_CODE := 'API_VD_125'; --Length of low_value_num exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_HIGH_VALUE_NUM) > Sbrext_Column_Lengths.L_VD_HIGH_VALUE_NUM THEN
    P_RETURN_CODE := 'API_VD_126'; --Length of high_value_num exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_CHAR_SET_NAME) > Sbrext_Column_Lengths.L_VD_CHAR_SET_NAME THEN
    P_RETURN_CODE := 'API_VD_127'; --Length of char_set_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_VD_CHANGE_NOTE) > Sbrext_Column_Lengths.L_VD_CHANGE_NOTE THEN
    P_RETURN_CODE := 'API_VD_128'; --Length of change_note exceeds maximum length
    RETURN;
  END IF;

  --check to see that charachter strings are valid
  IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_VD_PREFERRED_NAME) THEN
    P_RETURN_CODE := 'API_VD_130'; -- Value Domain Preferred Name has invalid Ccharacters
    RETURN;
  END IF;
  --this block of code has been commented out because formats and unit of measures will have alpha numberic charachters
  /*IF  P_VD_FORML_NAME IS NOT NULL THEN
      IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_VD_FORML_NAME) THEN
      P_RETURN_CODE := 'API_VD_131'; -- Value Domain Format Name has invalid characters
      RETURN;
    END IF;
  END IF;

  IF P_VD_UOML_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_VD_UOML_NAME) THEN
      P_RETURN_CODE := 'API_VD_132'; -- Value Domain UOML Name has invalid characters
      RETURN;
    END IF;
  END IF;
  */
  IF NOT Sbrext_Common_Routines.valid_char(P_VD_PREFERRED_DEFINITION) THEN
    P_RETURN_CODE := 'API_VD_133'; -- Value Domain Preferred Definition has invalid characters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_VD_LONG_NAME) THEN
    P_RETURN_CODE := 'API_VD_134'; -- Value Domain Long Name has invalid characters
    RETURN;
  END IF;
  IF P_FORML_DESCRIPTION IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_FORML_DESCRIPTION) THEN
      P_RETURN_CODE := 'API_VD_135'; -- Format Description has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_FORML_COMMENT IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_FORML_COMMENT) THEN
      P_RETURN_CODE := 'API_VD_136'; -- Format Comment has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_UOML_DESCRIPTION IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_UOML_DESCRIPTION) THEN
      P_RETURN_CODE := 'API_VD_137'; -- Unit of Measure Description has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_UOML_COMMENT IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_UOML_COMMENT) THEN
      P_RETURN_CODE := 'API_VD_138'; -- Unit of Measure Comment has invalid characters
      RETURN;
    END IF;
  END IF;


  --check to see that Context, Workflow Status, Data type, Character Set, Conceptual Domain already exist in the database
  IF P_ACTION = 'INS' THEN
    -- This check should be performed only in inserts as update and delete expect null conte_idseq
    IF NOT Sbrext_Common_Routines.context_exists(P_VD_CONTE_IDSEQ) THEN
      P_RETURN_CODE := 'API_VD_200'; --Context not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_VD_CD_IDSEQ IS NOT NULL THEN -- 24-Jul-2003, W. Ver Hoef
    IF NOT Sbrext_Common_Routines.ac_exists(P_VD_CD_IDSEQ) THEN
      P_RETURN_CODE := 'API_VD_201'; --Conceptual Domain not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_VD_ASL_NAME IS NOT NULL THEN -- 24-Jul-2003, W. Ver Hoef
    IF NOT Sbrext_Common_Routines.workflow_exists(P_VD_ASL_NAME) THEN
      P_RETURN_CODE := 'API_VD_202'; --Workflow Status not found in the database
      RETURN;
    END IF;
  END IF;
  IF (P_VD_CHAR_SET_NAME IS NOT NULL AND P_VD_CHAR_SET_NAME != ' ') THEN
    IF NOT Sbrext_Common_Routines.char_set_exists(P_VD_CHAR_SET_NAME) THEN
      P_RETURN_CODE := 'API_VD_203'; --Character set not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_VD_DTL_NAME IS NOT NULL THEN -- 24-Jul-2003, W. Ver Hoef
    IF NOT Sbrext_Common_Routines.data_type_exists(P_VD_DTL_NAME) THEN
      P_RETURN_CODE := 'API_VD_204'; --DATA_TYPE NOT found in the database
      RETURN;
    END IF;
  END IF;
  IF P_VD_REP_IDSEQ IS NOT NULL AND P_VD_REP_IDSEQ != ' ' THEN
    IF NOT Sbrext_Common_Routines.ac_exists(P_VD_REP_IDSEQ )  THEN
      P_RETURN_CODE := 'API_VD_207'; --Representation term does not exist
      RETURN;
    END IF;
  END IF;
  IF P_VD_QUALIFIER_NAME IS NOT NULL AND P_VD_QUALIFIER_NAME != ' ' THEN
    IF NOT Sbrext_Common_Routines.qual_exists(P_VD_QUALIFIER_NAME )  THEN
      P_RETURN_CODE := 'API_VD_208'; --Qualifier does not exist
      RETURN;
    END IF;
  END IF;

  --check to see that begin data and end date are valid dates
  IF(P_VD_BEGIN_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_VD_BEGIN_DATE,v_begin_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_VD_600'; --begin date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_VD_END_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_VD_END_DATE,v_end_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_VD_601'; --end date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_VD_BEGIN_DATE IS NOT NULL AND P_VD_END_DATE IS NOT NULL) THEN
    IF(v_end_date < v_begin_date) THEN
      P_RETURN_CODE := 'API_VD_210'; --end date is before begin date
      RETURN;
    END IF;
  --ELSIF(P_VD_END_DATE IS NOT NULL AND P_VD_BEGIN_DATE IS NULL) THEN
   -- P_RETURN_CODE := 'API_VD_211'; --begin date cannot be null when end date is null
    --RETURN;
  END IF;

  --check to see that format description  or comments are sent in without the formt name
  IF(P_VD_FORML_NAME IS NULL AND ( P_FORML_DESCRIPTION IS NOT NULL OR P_FORML_COMMENT IS NOT NULL)) THEN
    P_RETURN_CODE := 'API_VD_205'; --cannot send in format description and comments without format name
    RETURN;
  END IF;
  IF(P_VD_UOML_NAME IS NULL AND ( P_UOML_DESCRIPTION IS NOT NULL OR P_UOML_COMMENT IS NOT NULL)) THEN
    P_RETURN_CODE := 'API_VD_206'; --cannot send in UOML description and comments without UOML name
    RETURN;
  END IF;

  --check to see that Format, Unit of measure already exist in the database , ifthey do not then create them
  IF( P_VD_FORML_NAME IS NOT NULL AND P_VD_FORML_NAME != ' ' ) THEN

    IF NOT(Sbrext_Common_Routines.vd_format_exists(P_VD_FORML_NAME)) THEN
      v_forml_rec.forml_name  := P_VD_FORML_NAME;
      v_forml_rec.description := P_FORML_DESCRIPTION;
      v_forml_rec.comments    := P_FORML_COMMENT;
      v_forml_ind.forml_name  := TRUE;
      v_forml_ind.description := TRUE;
      v_forml_ind.comments    := TRUE;
      BEGIN
        cg$formats_lov_view.ins(v_forml_rec,v_forml_ind);
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_FORML_500' ;--error inserting format
      END;
    END IF;
  END IF;

  IF (P_VD_UOML_NAME IS NOT NULL AND P_VD_UOML_NAME != ' ') THEN
    IF NOT(Sbrext_Common_Routines.uoml_exists(P_VD_UOML_NAME)) THEN
      v_uoml_rec.uoml_name   := P_VD_UOML_NAME;
      v_uoml_rec.description := P_UOML_DESCRIPTION;
      v_uoml_rec.comments    := P_UOML_COMMENT;
      v_uoml_ind.uoml_name   := TRUE;
      v_uoml_ind.description := TRUE;
      v_uoml_ind.comments    := TRUE;
      BEGIN
        cg$Unit_of_measures_lov_view.ins(v_uoml_rec,v_uoml_ind);
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_UOML_500' ;--error inserting UOML
       RETURN;
      END;
    END IF;
  END IF;

  IF (P_ACTION = 'INS' ) THEN

    --check to see that  a Value Domain with the same
    --Preferred Name, Context and Version does not already exist
    IF Sbrext_Common_Routines.ac_exists(P_VD_PREFERRED_NAME,P_VD_CONTE_IDSEQ ,P_VD_VERSION,'VALUEDOMAIN') THEN
      P_RETURN_CODE := 'API_VD_300';-- Value Domain already Exists
      RETURN;
    END IF;
    --Check to see if prior versions alresdy exist
    IF Sbrext_Common_Routines.ac_version_exists(P_VD_PREFERRED_NAME,P_VD_CONTE_IDSEQ ,'VALUEDOMAIN') THEN -- we are creating a new version
      v_new_version := TRUE;
      v_ac          := Sbrext_Common_Routines.get_version_ac(P_VD_PREFERRED_NAME,P_VD_CONTE_IDSEQ,'VALUEDOMAIN');
    END IF;

 if p_vd_preferred_name = 'System Generated' then
   v_vd_preferred_name := null;
 else
   v_vd_preferred_name := p_vd_preferred_name;
 end if;
    --add code here to check for versioning
    P_VD_VD_IDSEQ      := admincomponent_crud.cmr_guid;
    P_VD_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_VD_CREATED_BY    := P_UA_NAME; --USER;
    P_VD_DATE_MODIFIED := NULL;
    P_VD_MODIFIED_BY   := NULL;
    P_VD_DELETED_IND   := 'No';

    v_vd_rec.vd_idseq           := P_VD_VD_IDSEQ;
    v_vd_rec.preferred_name       := V_VD_PREFERRED_NAME;
    v_vd_rec.conte_idseq       := P_VD_CONTE_IDSEQ;
    v_vd_rec.version           := P_VD_VERSION;
    v_vd_rec.preferred_definition := P_VD_PREFERRED_DEFINITION;
    v_vd_rec.long_name           := P_VD_LONG_NAME;
    v_vd_rec.asl_name           := P_VD_ASL_NAME ;
    v_vd_rec.cd_idseq           := P_VD_CD_IDSEQ ;
    v_vd_rec.latest_version_ind   := P_VD_LATEST_VERSION_IND;
    v_vd_rec.vd_type_flag       := P_VD_TYPE_FLAG;
    v_vd_rec.dtl_name           := P_VD_DTL_NAME;
    v_vd_rec.forml_name        := P_VD_FORML_NAME;
    v_vd_rec.uoml_name            := P_VD_UOML_NAME;
    v_vd_rec.low_value_num       := P_VD_LOW_VALUE_NUM;
    v_vd_rec.high_value_num       := P_VD_HIGH_VALUE_NUM;
    v_vd_rec.min_length_num       := P_VD_MIN_LENGTH_NUM;
    v_vd_rec.max_length_num       := P_VD_MAX_LENGTH_NUM ;
    v_vd_rec.decimal_place        := P_VD_DECIMAL_PLACE;
    v_vd_rec.char_set_name       := P_VD_CHAR_SET_NAME;
    v_vd_rec.begin_date           := TO_DATE(P_VD_BEGIN_DATE);
    v_vd_rec.end_date           := TO_DATE(P_VD_END_DATE);
    v_vd_rec.change_note       := P_VD_CHANGE_NOTE ;
    v_vd_rec.created_by           := P_VD_CREATED_BY;
    v_vd_rec.date_created       := TO_DATE(P_VD_DATE_CREATED);
    v_vd_rec.modified_by       := P_VD_MODIFIED_BY;
    v_vd_rec.date_modified       := TO_DATE(P_VD_DATE_MODIFIED);
    v_vd_rec.deleted_ind          := P_VD_DELETED_IND;
    v_vd_rec.rep_idseq            := P_VD_REP_IDSEQ;
    v_vd_rec.qualifier_name       := P_VD_QUALIFIER_NAME;
    v_vd_rec.condr_idseq       := P_VD_CONDR_IDSEQ;
 v_vd_rec.origin               := P_VD_ORIGIN;  -- 24-Jul-2003, W. Ver Hoef

    v_vd_ind.vd_idseq           := TRUE;
    v_vd_ind.preferred_name       := TRUE;
    v_vd_ind.conte_idseq       := TRUE;
    v_vd_ind.version           := TRUE;
    v_vd_ind.preferred_definition := TRUE;
    v_vd_ind.long_name           := TRUE;
    v_vd_ind.asl_name           := TRUE;
    v_vd_ind.cd_idseq           := TRUE;
    v_vd_ind.latest_version_ind   := TRUE;
    v_vd_ind.vd_type_flag       := TRUE;
    v_vd_ind.dtl_name           := TRUE;
    v_vd_ind.forml_name        := TRUE;
    v_vd_ind.uoml_name            := TRUE;
    v_vd_ind.low_value_num       := TRUE;
    v_vd_ind.high_value_num       := TRUE;
    v_vd_ind.min_length_num       := TRUE;
    v_vd_ind.max_length_num       := TRUE;
    v_vd_ind.decimal_place        := TRUE;
    v_vd_ind.char_set_name       := TRUE;
    v_vd_ind.begin_date           := TRUE;
    v_vd_ind.end_date           := TRUE;
    v_vd_ind.change_note       := TRUE;
    v_vd_ind.created_by           := TRUE;
    v_vd_ind.date_created       := TRUE;
    v_vd_ind.modified_by       := TRUE;
    v_vd_ind.date_modified       := TRUE;
    v_vd_ind.deleted_ind          := TRUE;
    v_vd_ind.rep_idseq            := TRUE;
    v_vd_ind.qualifier_name       := TRUE;
    v_vd_ind.condr_idseq       := TRUE;
 v_vd_ind.origin               := TRUE; -- 24-Jul-2003, W. Ver Hoef

    BEGIN
      --meta_global_pkg.transaction_type := 'VERSION';

      cg$value_domains_view.ins(v_vd_rec,v_vd_ind);

   if p_vd_preferred_name = 'System Generated' then

     p_vd_preferred_name := sbrext_common_routines.GENERATE_VD_PREFERRED_NAME(p_vd_vd_idseq);
  update value_domains
  set preferred_name = p_vd_preferred_name
  where vd_idseq = p_vd_vd_idseq;
   end if;

      --meta_global_pkg.transaction_type := NULL;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_VD_500'; --Error inserting Value Domain
    END;

    --If LATEST_VERSION_IND is'Yes' then update so that all other versions have the indicator set to 'No'
    IF(P_VD_LATEST_VERSION_IND = 'Yes') THEN
      Sbrext_Common_Routines.set_ac_lvi(P_RETURN_CODE,P_VD_VD_IDSEQ,'VALUEDOMAIN');
      IF P_RETURN_CODE IS NOT NULL  THEN
        P_RETURN_CODE := 'API_VD_503'; -- Error updating latest_Value_ind
        RETURN;
      END IF;
    END IF;
    --create a history record with prior version
    IF v_new_version THEN
      BEGIN
        meta_config_mgmt.CREATE_AC_HISTORIES (v_ac,P_VD_VD_IDSEQ,'VERSIONED','VALUEDOMAIN');
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_VD_504'; --Error creating history
      END;
    END IF;

  END IF;

  IF (P_ACTION = 'UPD' ) THEN

    --Get the version for the P_VD_VDIDSEQ
    SELECT version
 INTO   v_version
    FROM   value_domains_view
    WHERE  vd_idseq = P_VD_VD_IDSEQ;

 IF P_VD_VERSION IS NOT NULL THEN  -- 24-JUL-2003, W. Ver Hoef
      IF v_version <> P_VD_VERSION THEN
        P_RETURN_CODE := 'API_VD_402'; -- Version can NOT be updated. It can only be created
        RETURN;
      END IF;
 END IF;

    P_VD_DATE_MODIFIED := TO_CHAR(SYSDATE);
    P_VD_MODIFIED_BY   := P_UA_NAME; --USER;
    P_VD_DELETED_IND   := 'No';

    v_vd_rec.date_modified := P_VD_DATE_MODIFIED;
    v_vd_rec.modified_by   := P_VD_MODIFIED_BY;
    v_vd_rec.vd_idseq      := P_VD_VD_IDSEQ;
    v_vd_rec.deleted_ind   := 'No';

    v_vd_ind.date_modified := TRUE;
    v_vd_ind.modified_by   := TRUE;
    v_vd_ind.deleted_ind   := TRUE;
    v_vd_ind.vd_idseq      := TRUE;

    v_vd_ind.version       := FALSE;
    v_vd_ind.created_by    := FALSE;
    v_vd_ind.date_created  := FALSE;

    IF P_VD_PREFERRED_NAME IS NULL THEN
      v_vd_ind.preferred_name := FALSE;
    ELSE
  if p_vd_preferred_name = 'System Generated' then
    v_vd_rec.preferred_name := sbrext_common_routines.GENERATE_VD_PREFERRED_NAME(p_vd_vd_idseq);
     else
   v_vd_rec.preferred_name := P_VD_PREFERRED_NAME;
  end if;
      v_vd_ind.preferred_name := TRUE;
    END IF;

    IF P_VD_CONTE_IDSEQ IS NULL THEN
      v_vd_ind.conte_idseq := FALSE;
    ELSE
      v_vd_rec.conte_idseq := P_VD_CONTE_IDSEQ;
      v_vd_ind.conte_idseq := TRUE;
    END IF;

    IF P_VD_PREFERRED_DEFINITION IS NULL THEN
      v_vd_ind.preferred_definition:= FALSE;
    ELSE
      v_vd_rec.preferred_definition := P_VD_PREFERRED_DEFINITION;
      v_vd_ind.preferred_definition := TRUE;
    END IF;

    IF P_VD_LONG_NAME IS NULL THEN
      v_vd_ind.long_name := FALSE;
 ELSIF P_VD_LONG_NAME = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.long_name := NULL;
      v_vd_ind.long_name := TRUE;
    ELSE
      v_vd_rec.long_name := P_VD_LONG_NAME;
      v_vd_ind.long_name := TRUE;
    END IF;

    IF P_VD_ASL_NAME IS NULL THEN
      v_vd_ind.asl_name := FALSE;
    ELSE
      v_vd_rec.asl_name := P_VD_ASL_NAME;
      v_vd_ind.asl_name := TRUE;
    END IF;

    IF P_VD_CD_IDSEQ IS NULL THEN
      v_vd_ind.cd_idseq := FALSE;
    ELSE
      v_vd_rec.cd_idseq := P_VD_CD_IDSEQ;
      v_vd_ind.cd_idseq := TRUE;
    END IF;

    IF P_VD_LATEST_VERSION_IND IS NULL THEN
      v_vd_ind.latest_version_ind := FALSE;
    ELSE
      v_vd_rec.latest_version_ind := P_VD_LATEST_VERSION_IND;
      v_vd_ind.latest_version_ind := TRUE;
    END IF;

    IF P_VD_TYPE_FLAG IS NULL THEN
      v_vd_ind.vd_type_flag := FALSE;
    ELSE
      v_vd_rec.vd_type_flag := P_VD_TYPE_FLAG;
      v_vd_ind.vd_type_flag := TRUE;
    END IF;

    IF P_VD_DTL_NAME IS NULL THEN
      v_vd_ind.dtl_name := FALSE;
    ELSE
      v_vd_rec.dtl_name := P_VD_DTL_NAME;
      v_vd_ind.dtl_name := TRUE;
    END IF;

    IF P_VD_FORML_NAME IS NULL THEN
      v_vd_ind.forml_name := FALSE;
 ELSIF P_VD_FORML_NAME = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.forml_name := NULL;
      v_vd_ind.forml_name := TRUE;
    ELSE
      v_vd_rec.forml_name := P_VD_FORML_NAME;
      v_vd_ind.forml_name := TRUE;
    END IF;

    IF P_VD_UOML_NAME IS NULL THEN
      v_vd_ind.uoml_name := FALSE;
 ELSIF P_VD_UOML_NAME = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.uoml_name := NULL;
      v_vd_ind.uoml_name := TRUE;
    ELSE
      v_vd_rec.uoml_name := P_VD_UOML_NAME ;
      v_vd_ind.uoml_name := TRUE;
    END IF;

    IF P_VD_LOW_VALUE_NUM IS NULL THEN
      v_vd_ind.low_value_num := FALSE;
 ELSIF P_VD_low_value_num = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.low_value_num := NULL;
      v_vd_ind.low_value_num := TRUE;
    ELSE
      v_vd_rec.low_value_num := P_VD_LOW_VALUE_NUM;
      v_vd_ind.low_value_num := TRUE;
    END IF;

    IF P_VD_HIGH_VALUE_NUM IS NULL THEN
      v_vd_ind.high_Value_num := FALSE;
 ELSIF P_VD_high_value_num = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.high_value_num := NULL;
      v_vd_ind.high_value_num := TRUE;
    ELSE
      v_vd_rec.high_value_num := P_VD_HIGH_VALUE_NUM;
      v_vd_ind.high_value_num := TRUE;
    END IF;

    IF P_VD_MIN_LENGTH_NUM IS NULL THEN
      v_vd_ind.min_length_num := FALSE;
 ELSIF P_VD_min_length_num = -1 THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.min_length_num := NULL;
      v_vd_ind.min_length_num := TRUE;
    ELSE
      v_vd_rec.min_length_num := P_VD_MIN_LENGTH_NUM;
      v_vd_ind.min_length_num := TRUE;
    END IF;

    IF P_VD_MAX_LENGTH_NUM  IS NULL THEN
     v_vd_ind.max_length_num := FALSE;
 ELSIF P_VD_max_length_num = -1 THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.max_length_num := NULL;
      v_vd_ind.max_length_num := TRUE;
    ELSE
     v_vd_rec.max_length_num := P_VD_MAX_LENGTH_NUM ;
     v_vd_ind.max_length_num := TRUE;
    END IF;

    IF P_VD_DECIMAL_PLACE IS NULL THEN
      v_vd_ind.decimal_place := FALSE;
 ELSIF P_VD_decimal_place = -1 THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.decimal_place := NULL;
      v_vd_ind.decimal_place := TRUE;
    ELSE
      v_vd_rec.decimal_place := P_VD_DECIMAL_PLACE;
      v_vd_ind.decimal_place := TRUE;
    END IF;

    IF P_VD_CHAR_SET_NAME IS NULL THEN
      v_vd_ind.char_set_name := FALSE;
 ELSIF P_VD_char_set_name = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.char_set_name := NULL;
      v_vd_ind.char_set_name := TRUE;
    ELSE
      v_vd_rec.char_set_name := P_VD_CHAR_SET_NAME;
      v_vd_ind.char_set_name := TRUE;
    END IF;

    IF P_VD_BEGIN_DATE IS NULL THEN
      v_vd_ind.begin_date := FALSE;
 ELSIF P_VD_begin_date = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.begin_date := NULL;
      v_vd_ind.begin_date := TRUE;
    ELSE
      v_vd_rec.begin_date := TO_DATE(P_VD_BEGIN_DATE);
      v_vd_ind.begin_date := TRUE;
    END IF;

    IF P_VD_END_DATE  IS NULL THEN
      v_vd_ind.end_date := FALSE;
 ELSIF P_VD_end_date = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.end_date := NULL;
      v_vd_ind.end_date := TRUE;
    ELSE
      v_vd_rec.end_date := TO_DATE(P_VD_END_DATE);
      v_vd_ind.end_date := TRUE;
    END IF;

    IF P_VD_CHANGE_NOTE   IS NULL THEN
      v_vd_ind.change_note := FALSE;
 ELSIF P_VD_change_note = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.change_note := NULL;
      v_vd_ind.change_note := TRUE;
    ELSE
      v_vd_rec.change_note := P_VD_CHANGE_NOTE  ;
      v_vd_ind.change_note := TRUE;
    END IF;

    IF P_VD_REP_IDSEQ  IS NULL THEN
      v_vd_ind.rep_idseq := FALSE;
 ELSIF P_VD_REP_IDSEQ = ' ' THEN -- Condition added on 7/30/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.rep_idseq := NULL;
      v_vd_ind.rep_idseq := TRUE;
    ELSE
      v_vd_rec.rep_idseq := P_VD_REP_IDSEQ;
      v_vd_ind.rep_idseq := TRUE;
    END IF;

    IF P_VD_QUALIFIER_NAME   IS NULL THEN
      v_vd_ind.qualifier_name := FALSE;
 ELSIF P_VD_QUALIFIER_NAME = ' ' THEN -- Condition added on 7/30/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.qualifier_name := NULL;
      v_vd_ind.qualifier_name := TRUE;
    ELSE
      v_vd_rec.qualifier_name := P_VD_QUALIFIER_NAME  ;
      v_vd_ind.qualifier_name := TRUE;
    END IF;

 IF P_VD_CONDR_IDSEQ   IS NULL THEN
      v_vd_ind.condr_idseq := FALSE;
 ELSIF P_VD_CONDR_IDSEQ = ' ' THEN
   v_vd_rec.condr_idseq := NULL;
      v_vd_ind.condr_idseq := TRUE;
    ELSE
      v_vd_rec.condr_idseq := P_VD_CONDR_IDSEQ  ;
      v_vd_ind.condr_idseq := TRUE;
    END IF;

    IF P_VD_ORIGIN   IS NULL THEN  -- 24-Jul-2003, W. Ver Hoef
      v_vd_ind.origin := FALSE;
 ELSIF P_VD_origin = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_vd_rec.origin := NULL;
      v_vd_ind.origin := TRUE;
    ELSE
      v_vd_rec.origin := P_VD_ORIGIN  ;
      v_vd_ind.origin := TRUE;
    END IF;

    BEGIN
      cg$value_domains_view.upd(v_vd_rec,v_vd_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := sqlerrm;--'API_VD_501'; --Error updating Value Domain
    END;

    --If LATEST_VERSION_IND is'Yes' then update so that all other versions have the indicator set to 'No'
    IF(P_VD_LATEST_VERSION_IND = 'Yes') THEN
      Sbrext_Common_Routines.set_ac_lvi(P_RETURN_CODE,P_VD_VD_IDSEQ,'VALUEDOMAIN');
      IF P_RETURN_CODE IS NOT NULL  THEN
        P_RETURN_CODE := 'API_VD_503'; -- Error updating latest_Value_ind
        RETURN;
      END IF;
    END IF;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;
END SET_VD;

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
,P_DEC_ORIGIN               IN     VARCHAR2 DEFAULT NULL )  IS -- 15-Jul-2003, W. Ver Hoef
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


PROCEDURE SET_VM(
 P_UA_NAME      IN VARCHAR2
,P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_VM_SHORT_MEANING         IN OUT VARCHAR2
,P_VM_DESCRIPTION         IN OUT VARCHAR2
,P_VM_COMMENTS             IN OUT VARCHAR2
,P_VM_BEGIN_DATE         IN OUT VARCHAR2
,P_VM_END_DATE             IN OUT VARCHAR2
,P_VM_CREATED_BY         OUT VARCHAR2
,P_VM_DATE_CREATED         OUT VARCHAR2
,P_VM_MODIFIED_BY         OUT VARCHAR2
,P_VM_DATE_MODIFIED         OUT VARCHAR2 )  IS
/******************************************************************************
   NAME:       SET_VM
   PURPOSE:    Inserts or Updates a Single Row Of  Value Meanings List of Value
               Based on short Meaning

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal  1. Created this procedure
   2.1        04/16/2004  W. Ver Hoef      1. corrected assignment of v_begin_date and
                                              v_end_date after calling
             sbrext_common_routines.valid_date because
             it was currently not assigning the out param;
             2. added v_vm_rec.short_meaning assignment
             which was missing

******************************************************************************/

  v_begin_date DATE := NULL;
  v_end_date DATE := NULL;

  v_vm_rec    cg$value_meanings_lov_view.cg$row_type;
  v_vm_ind    cg$value_meanings_lov_view.cg$ind_type;

BEGIN

P_RETURN_CODE := NULL;

 IF P_ACTION IS NULL THEN
   P_RETURN_CODE := 'API_VM_701'; -- NULL action
   RETURN;
 ELSIF P_ACTION NOT IN ('INS','UPD') THEN
   P_RETURN_CODE := 'API_VM_700'; -- Invalid action
   RETURN;
 END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;


IF P_ACTION = 'INS' THEN              --we are inserting a record
     --Check to see that all mandatory parameters are either not null
  IF P_VM_SHORT_MEANING IS NULL THEN
    P_RETURN_CODE := 'API_VM_101';  --Value Meaning cannot be null here
 RETURN;
  END IF;
END IF;

IF P_ACTION = 'UPD'  THEN
 admin_security_util.seteffectiveuser(p_ua_name);
  IF P_VM_SHORT_MEANING IS NULL THEN
    P_RETURN_CODE := 'API_VM_101';  --Value Meaning cannot be null here
 RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.vm_exists(p_short_meaning=>P_VM_SHORT_MEANING) THEN
   P_RETURN_CODE := 'API_VM_005'; --VM not found
   RETURN;
  END IF;
END IF;
--Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
IF LENGTH(P_VM_SHORT_MEANING) > Sbrext_Column_Lengths.L_VM_SHORT_MEANING THEN
  P_RETURN_CODE := 'API_VM_111';  --Length of SHORT_MEANING exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_VM_DESCRIPTION) > Sbrext_Column_Lengths.L_VM_DESCRIPTION THEN
  P_RETURN_CODE := 'API_VM_113';  --Length of DESCRIPTION exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_VM_COMMENTS) > Sbrext_Column_Lengths.L_VM_COMMENTS THEN
  P_RETURN_CODE := 'API_VM_114'; --Length of COMMENTS exceeds maximum length
  RETURN;
END IF;

--check to see that charachter strings are valid
IF NOT Sbrext_Common_Routines.valid_char(P_VM_SHORT_MEANING) THEN
  P_RETURN_CODE := 'API_VM_130'; -- Value Meaning Short Meaning has invalid characters
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.valid_char(P_VM_DESCRIPTION) THEN
  P_RETURN_CODE := 'API_VM_133'; -- Value Meaning Description has invalid characters
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.valid_char(P_VM_COMMENTS) THEN
  P_RETURN_CODE := 'API_VM_134'; -- Value Meaning Comment has invalid characters
  RETURN;
END IF;
  --check to see that begin data and end date are valid dates

IF(P_VM_BEGIN_DATE IS NOT NULL) THEN
  Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_VM_BEGIN_DATE,V_BEGIN_DATE);
  IF P_RETURN_CODE IS NOT NULL THEN
    P_RETURN_CODE := 'API_VM_600'; --begin date is invalid
    RETURN;
  END IF;
  -- 16-Apr-2004, W. Ver Hoef - added assignment because currently valid_date doesn't
  --                            populate v_begin_date and later references were thus null
  IF v_begin_date IS NULL THEN
    BEGIN
      v_begin_date := TO_DATE(p_vm_begin_date,'DD-MON-YYYY');
 EXCEPTION WHEN OTHERS THEN
   p_return_code := 'API_VM_600';
   RETURN;
 END;
  END IF;
END IF;

IF(P_VM_END_DATE IS NOT NULL) THEN
  Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_VM_END_DATE,V_END_DATE);
  IF P_RETURN_CODE IS NOT NULL THEN
   P_RETURN_CODE := 'API_VM_601'; --end date is invalid
   RETURN;
  END IF;
  -- 16-Apr-2004, W. Ver Hoef - added assignment because currently valid_date doesn't
  --                            populate v_begin_date and later references were thus null
  IF v_end_date IS NULL THEN
    BEGIN
      v_end_date := TO_DATE(p_vm_end_date,'DD-MON-YYYY');
 EXCEPTION WHEN OTHERS THEN
   p_return_code := 'API_VM_601';
   RETURN;
 END;
  END IF;
END IF;

IF(P_VM_BEGIN_DATE IS NOT NULL AND P_VM_END_DATE IS NOT NULL) THEN
  IF(v_end_date < v_begin_date) THEN
     P_RETURN_CODE := 'API_VM_210'; --end date is before begin date
     RETURN;
  END IF;
ELSIF(P_VM_END_DATE IS NOT NULL AND P_VM_BEGIN_DATE IS NULL) THEN
  P_RETURN_CODE := 'API_VM_211'; --begin date cannot be null when end date is null
  RETURN;
END IF;


IF (P_ACTION = 'INS' ) THEN

--check to see that Short Name Does not already Exist
  IF Sbrext_Common_Routines.vm_exists(p_short_meaning=>P_VM_SHORT_MEANING) THEN
    P_RETURN_CODE := 'API_VM_300';-- Value Meaning already exists
    RETURN;
  END IF;

  P_VM_DATE_CREATED := TO_CHAR(SYSDATE);
  P_VM_CREATED_BY := P_UA_NAME;--USER;
  P_VM_DATE_MODIFIED := NULL;
  P_VM_MODIFIED_BY := NULL;
  P_VM_BEGIN_DATE := TO_CHAR(v_begin_date);
  P_VM_END_DATE := TO_CHAR(v_end_date);

  v_vm_rec.short_meaning := P_VM_SHORT_MEANING;
  v_vm_rec.description      := P_VM_DESCRIPTION;
  v_vm_rec.comments         := P_VM_COMMENTS;
  v_vm_rec.begin_date     := P_VM_BEGIN_DATE;
  v_vm_rec.end_date         := P_VM_END_DATE;
  v_vm_rec.created_by     := P_VM_CREATED_BY;
  v_vm_rec.date_created     := P_VM_DATE_CREATED;
  v_vm_rec.modified_by     := P_VM_MODIFIED_BY;
  v_vm_rec.date_modified := P_VM_DATE_MODIFIED;


  v_vm_ind.short_meaning   := TRUE;
  v_vm_ind.description        := TRUE;
  v_vm_ind.comments           := TRUE;
  v_vm_ind.begin_date       := TRUE;
  v_vm_ind.end_date           := TRUE;
  v_vm_ind.created_by       := TRUE;
  v_vm_ind.date_created       := TRUE;
  v_vm_ind.modified_by       := TRUE;
  v_vm_ind.date_modified   := TRUE;

  BEGIN
    cg$Value_meanings_lov_view.ins(v_vm_rec,v_vm_ind);
  EXCEPTION WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
    P_RETURN_CODE := 'API_VM_500'; --Error inserting Value Meaning
  END;

END IF;


IF (P_ACTION = 'UPD' ) THEN

  -- 16-Apr-2004, W. Ver Hoef - added v_vm_rec.short_meaning assignment which was missing
  v_vm_rec.short_meaning := P_VM_SHORT_MEANING;

  P_VM_DATE_MODIFIED := TO_CHAR(SYSDATE);
  P_VM_MODIFIED_BY := P_UA_NAME;--USER;

  P_VM_BEGIN_DATE := TO_CHAR(v_begin_date);
  P_VM_END_DATE := TO_CHAR(v_end_date);

  v_vm_rec.date_modified := P_VM_DATE_MODIFIED;
  v_vm_rec.modified_by := P_VM_MODIFIED_BY;

  v_vm_ind.date_modified := TRUE;
  v_vm_ind.modified_by := TRUE;

  v_vm_ind.created_by := FALSE;
  v_vm_ind.date_created := FALSE;

  IF P_VM_DESCRIPTION IS NULL THEN
    v_vm_ind.description := FALSE;
  ELSE
    v_vm_rec.description := P_VM_DESCRIPTION;
    v_vm_ind.description := TRUE;
  END IF;

  IF P_VM_COMMENTS IS NULL THEN
    v_vm_ind.comments := FALSE;
  ELSE
    v_vm_rec.comments := P_VM_COMMENTS;
    v_vm_ind.comments := TRUE;
  END IF;

  IF P_VM_BEGIN_DATE IS NULL THEN
    v_vm_ind.begin_date := FALSE;
  ELSE
    v_vm_rec.begin_date := P_VM_BEGIN_DATE;
    v_vm_ind.begin_date := TRUE;
  END IF;

  IF P_VM_END_DATE IS NULL THEN
    v_vm_ind.end_date := FALSE;
  ELSE
    v_vm_rec.end_date := P_VM_END_DATE ;
    v_vm_ind.end_date := TRUE;
  END IF;

  BEGIN
    cg$Value_meanings_lov_view.upd(v_vm_rec,v_vm_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_VM_501'; --Error updating value meaning
  END;
END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;
END SET_VM;



-- overloaded version
PROCEDURE SET_VM(
   P_UA_NAME        IN VARCHAR2
  ,P_RETURN_CODE             OUT VARCHAR2
  ,P_ACTION                   IN VARCHAR2
  ,P_VM_SHORT_MEANING         IN OUT VARCHAR2
  ,P_VM_DESCRIPTION         IN OUT VARCHAR2
  ,P_VM_COMMENTS             IN OUT VARCHAR2
  ,P_VM_BEGIN_DATE         IN OUT VARCHAR2
  ,P_VM_END_DATE             IN OUT VARCHAR2
  ,P_VM_CREATED_BY         OUT VARCHAR2
  ,P_VM_DATE_CREATED         OUT VARCHAR2
  ,P_VM_MODIFIED_BY         OUT VARCHAR2
  ,P_VM_DATE_MODIFIED         OUT VARCHAR2
  ,P_VM_VM_IDSEQ              OUT VARCHAR2) IS
  /*
  ** Wrapper procedure for set_vm that includes vm_idseq as an
  **   additional OUT parameter.
  */
  BEGIN
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  -- Call original version
  sbrext.sbrext_set_row.set_vm(p_return_code => p_return_code
                       ,p_action      => p_action
        ,p_vm_short_meaning => p_vm_short_meaning
        ,p_vm_description   => p_vm_description
        ,p_vm_comments      => p_vm_comments
        ,p_vm_begin_date    => p_vm_begin_date
        ,p_vm_end_date      => p_vm_end_date
        ,p_vm_created_by    => p_vm_created_by
        ,p_vm_date_created  => p_vm_date_created
        ,p_vm_modified_by   => p_vm_modified_by
        ,p_vm_date_modified => p_vm_date_modified);
  -- add vm_idseq
  p_vm_vm_idseq := get_vm_idseq (p_ShortMeaning => p_vm_short_meaning);
  EXCEPTION
    WHEN OTHERS THEN
     RAISE;
  END set_vm;

-- additional overloaded version: ScenPro (4/24/2007)



PROCEDURE SET_PV(
P_UA_NAME   IN VARCHAR2
,P_RETURN_CODE              OUT VARCHAR2
,P_ACTION                    IN VARCHAR2
,P_PV_PV_IDSEQ              IN OUT VARCHAR2
,P_PV_VALUE              IN OUT VARCHAR2
,P_PV_SHORT_MEANING          IN OUT VARCHAR2
,P_PV_BEGIN_DATE      IN OUT VARCHAR2
,P_PV_MEANING_DESCRIPTION IN OUT VARCHAR2
,P_PV_LOW_VALUE_NUM         IN OUT NUMBER
,P_PV_HIGH_VALUE_NUM      IN OUT NUMBER
,P_PV_END_DATE              IN OUT VARCHAR2
,P_PV_VM_IDSEQ          	IN OUT VARCHAR2
,P_PV_CREATED_BY         OUT VARCHAR2
,P_PV_DATE_CREATED         OUT VARCHAR2
,P_PV_MODIFIED_BY         OUT VARCHAR2
,P_PV_DATE_MODIFIED         OUT VARCHAR2) IS
/******************************************************************************
   NAME:       SET_PV
   PURPOSE:    Inserts or Updates a Single Row Of Permissible Value based on either
               PV_IDSEQ or value, shoert meaning

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/22/2001  Prerna Aggarwal      1. Created this procedure




******************************************************************************/

v_begin_date DATE := NULL;
v_end_date DATE := NULL;

v_pv_rec    cg$permissible_values_view.cg$row_type;
v_pv_ind    cg$permissible_values_view.cg$ind_type;
BEGIN
P_RETURN_CODE := NULL;

 IF P_ACTION NOT IN ('INS','UPD') THEN
 P_RETURN_CODE := 'API_PV_700'; -- Invalid action
 RETURN;
END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
  IF P_PV_PV_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_PV_100' ;  --for inserts the ID IS generated
  RETURN;
  ELSE
     --Check to see that all mandatory parameters are either NOT NULL or have a default value.
  IF P_PV_VALUE IS NULL THEN
     P_RETURN_CODE := 'API_PV_101';  --Value cannot be NULL here
  RETURN;
  END IF;
  IF P_PV_SHORT_MEANING IS NULL THEN
     P_RETURN_CODE := 'API_PV_103'; --Short Meaning cannot be NULL here
  RETURN;
  END IF;
  IF P_PV_BEGIN_DATE IS NULL THEN
     P_RETURN_CODE := 'API_PV_104'; --Begin date cannot be NULL here
  RETURN;
  END IF;
  END IF;
END IF;


IF P_ACTION = 'UPD' THEN              --we are inserting a record
  admin_security_util.seteffectiveuser(p_ua_name);
  IF P_PV_PV_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_PV_400' ;  --for updates the ID is mandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.pv_exists(p_pv_idseq=>P_PV_PV_IDSEQ) THEN
   P_RETURN_CODE := 'API_PV_005'; --PV not found
   RETURN;
 END IF;
  END IF;
END IF;
--Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length

IF LENGTH(P_PV_VALUE) > Sbrext_Column_Lengths.L_PV_VALUE THEN
  P_RETURN_CODE := 'API_PV_111';  --Length of Value exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_PV_SHORT_MEANING) > Sbrext_Column_Lengths.L_PV_SHORT_MEANING THEN
  P_RETURN_CODE := 'API_PV_113';  --Length of Short Meaning exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_PV_MEANING_DESCRIPTION) > Sbrext_Column_Lengths.L_PV_MEANING_DESCRIPTION THEN
  P_RETURN_CODE := 'API_PV_114'; --Length of Meaning Description exceeds maximum length
  RETURN;
END IF;

--check to see that charachter strings are valid
IF NOT Sbrext_Common_Routines.valid_char(P_PV_VALUE) THEN
  P_RETURN_CODE := 'API_PV_130'; -- Permissible Value Value has invalid characters
  RETURN;
END IF;

IF NOT Sbrext_Common_Routines.valid_char(P_PV_SHORT_MEANING) THEN
  P_RETURN_CODE := 'API_PV_133'; -- Permissible Value Short Meaning has invalid characters
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.valid_char(P_PV_MEANING_DESCRIPTION) THEN
  P_RETURN_CODE := 'API_PV_134'; -- Permissible Value  Description has invalid characters
  RETURN;
END IF;


--check to see that Short Meaning already exist in the database

IF NOT Sbrext_Common_Routines.vm_exists(p_vm_idseq=>P_PV_VM_IDSEQ) THEN
    P_RETURN_CODE := 'API_PV_200'; --Short Meaning notfound in the database
 RETURN;
END IF;
--check to see that begin data and end date are valid dates

IF(P_PV_BEGIN_DATE IS NOT NULL) THEN
  Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_PV_BEGIN_DATE,v_begin_date);
  IF P_RETURN_CODE IS NOT NULL THEN
    P_RETURN_CODE := 'API_PV_600'; --begin date is invalid
    RETURN;
  END IF;
END IF;

IF(P_PV_END_DATE IS NOT NULL) THEN
  Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_PV_END_DATE,v_end_date);
  IF P_RETURN_CODE IS NOT NULL THEN
    P_RETURN_CODE := 'API_PV_601'; --end date is invalid
    RETURN;
  END IF;
END IF;

IF(P_PV_BEGIN_DATE IS NOT NULL AND P_PV_END_DATE IS NOT NULL) THEN
  IF(v_end_date < v_begin_date) THEN
     P_RETURN_CODE := 'API_PV_210'; --end date is before begin date
     RETURN;
  END IF;
END IF;




IF (P_ACTION = 'INS' ) THEN

--check to see that Value  does not already
  IF Sbrext_Common_Routines.pv_exists(p_value=>P_PV_VALUE,p_vm_idseq=>P_PV_VM_IDSEQ) THEN
    p_return_code := 'API_PV_300';-- PERMISSIBLE VALUE ALREADY EXISTS
    RETURN;
  END IF;

  P_PV_PV_IDSEQ := admincomponent_crud.cmr_guid;
  P_PV_DATE_CREATED := TO_CHAR(SYSDATE);
  P_PV_CREATED_BY := P_UA_NAME;--USER;
  P_PV_DATE_MODIFIED := NULL;
  P_PV_MODIFIED_BY := NULL;

  v_pv_rec.pv_idseq            := P_PV_PV_IDSEQ;
  v_pv_rec.value            := P_PV_VALUE;
  v_pv_rec.short_meaning       := P_PV_SHORT_MEANING;
  v_pv_rec.vm_idseq       := P_PV_VM_IDSEQ;
  v_pv_rec.meaning_description := P_PV_MEANING_DESCRIPTION;
  v_pv_rec.low_value_num    := P_PV_LOW_VALUE_NUM;
  v_pv_rec.high_value_num    := P_PV_HIGH_VALUE_NUM;
  v_pv_rec.begin_date        := TO_DATE(P_PV_BEGIN_DATE);
  v_pv_rec.end_date            := TO_DATE(P_PV_END_DATE);
  v_pv_rec.created_by        := P_PV_CREATED_BY;
  v_pv_rec.date_created        := TO_DATE(P_PV_DATE_CREATED);
  v_pv_rec.modified_by        := P_PV_MODIFIED_BY;
  v_pv_rec.date_modified    := P_PV_DATE_MODIFIED;


  v_pv_ind.pv_idseq             := TRUE;
  v_pv_ind.value             := TRUE;
  v_pv_ind.short_meaning        := TRUE;
  v_pv_ind.vm_idseq        := TRUE;
  v_pv_ind.meaning_description  := TRUE;
  v_pv_ind.low_value_num     := TRUE;
  v_pv_ind.high_value_num     := TRUE;
  v_pv_ind.begin_Date         := TRUE;
  v_pv_ind.end_date             := TRUE;
  v_pv_ind.created_by         := TRUE;
  v_pv_ind.date_created         := TRUE;
  v_pv_ind.modified_by         := TRUE;
  v_pv_ind.date_modified     := TRUE;

  BEGIN
    cg$permissible_values_view.ins(v_pv_rec,v_pv_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE :=  'API_PV_500'; --Error inserting Permissible Value
  END;

END IF;



IF (P_ACTION = 'UPD' ) THEN

  P_PV_DATE_MODIFIED     := TO_CHAR(SYSDATE);
  P_PV_MODIFIED_BY       := P_UA_NAME;--USER;
  v_pv_rec.date_modified := TO_DATE(P_PV_DATE_MODIFIED);
  v_pv_rec.modified_by   := P_PV_MODIFIED_BY;
  v_pv_rec.pv_idseq      := P_PV_PV_IDSEQ;

  v_pv_ind.date_modified := TRUE;
  v_pv_ind.modified_by   := TRUE;
  v_pv_ind.pv_idseq      := TRUE;

  v_pv_ind.created_by       := FALSE;
  v_pv_ind.date_created       := FALSE;

  IF P_PV_VALUE IS NULL THEN
    v_pv_ind.value := FALSE;
  ELSE
    v_pv_rec.value := P_PV_VALUE;
    v_pv_ind.value := TRUE;
  END IF;

  IF P_PV_SHORT_MEANING IS NULL THEN
    v_pv_ind.short_meaning := FALSE;
  ELSE
    v_pv_rec.short_meaning := P_PV_SHORT_MEANING;
    v_pv_ind.short_meaning := TRUE;
  END IF;

    IF P_PV_VM_IDSEQ IS NULL THEN
    v_pv_ind.vm_idseq := FALSE;
  ELSE
    v_pv_rec.vm_idseq := P_PV_VM_IDSEQ;
    v_pv_ind.vm_idseq := TRUE;
  END IF;

  IF P_PV_MEANING_DESCRIPTION IS NULL THEN
    v_pv_ind.meaning_description := FALSE;
  ELSE
    v_pv_rec.meaning_description := P_PV_MEANING_DESCRIPTION;
    v_pv_ind.meaning_description := TRUE;
  END IF;

  IF P_PV_LOW_VALUE_NUM IS NULL THEN
    v_pv_ind.low_value_num := FALSE;
  ELSE
    v_pv_rec.low_value_num := P_PV_LOW_VALUE_NUM;
    v_pv_ind.low_value_num := TRUE;
  END IF;

  IF P_PV_HIGH_VALUE_NUM IS NULL THEN
    v_pv_ind.high_value_num := FALSE;
  ELSE
    v_pv_rec.high_value_num := P_PV_HIGH_VALUE_NUM;
    v_pv_ind.high_value_num := TRUE;
  END IF;

  IF P_PV_BEGIN_DATE IS NULL THEN
    v_pv_ind.begin_date := FALSE;
  ELSE
    v_pv_rec.begin_date  := TO_DATE(P_PV_BEGIN_DATE);
    v_pv_ind.begin_date  := TRUE;
  END IF;

  IF P_PV_END_DATE  IS NULL THEN
    v_pv_ind.end_date := FALSE;
  ELSE
    v_pv_rec.end_date := TO_DATE(P_PV_END_DATE) ;
    v_pv_ind.end_date := TRUE;
  END IF;

  BEGIN
    cg$permissible_values_view.upd(v_pv_rec,v_pv_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_PV_501'; --Error updating PERMISSIBLE VALUE
  END;
END IF;

EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_PV;

--GF30800 tagged; 15 parameters
PROCEDURE  SET_VD_PVS(
 P_UA_NAME      IN VARCHAR2
,P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_VDPVS_VP_IDSEQ         IN OUT VARCHAR2
,P_VDPVS_VD_IDSEQ         IN OUT VARCHAR2
,P_VDPVS_PV_IDSEQ         IN OUT VARCHAR2
,P_VDPVS_CONTE_IDSEQ     IN OUT VARCHAR2
,P_VDPVS_DATE_CREATED        OUT VARCHAR2
,P_VDPVS_CREATED_BY            OUT VARCHAR2
,P_VDPVS_MODIFIED_BY        OUT VARCHAR2
,P_VDPVS_DATE_MODIFIED        OUT VARCHAR2
,P_VDPVS_ORIGIN       IN     VARCHAR2 DEFAULT NULL
,P_VDPVS_BEGIN_DATE      IN     VARCHAR2 DEFAULT NULL
,P_VDPVS_END_DATE              IN  VARCHAR2 DEFAULT NULL
,P_VDPVS_CON_IDSEQ  IN VARCHAR2 DEFAULT NULL) -- 24-Jul-2003, W. Ver Hoef
IS
/******************************************************************************
   NAME:       SET_VD_PVS
   PURPOSE:    Inserts or Updates a Single Row Of VD_PVS basedon either
               VP_IDSEQ or VD_IDSEQ and PV_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/25/2001  Prerna Aggarwal  1. Created this procedure
   2.0    07/24/2003  W.Ver Hoef       1. Added parameter and code for origin
   2.1.1      08/23/2004  DLadino          1. Added code to "UPDATE" a VD_PVS record
                                              sprf_2.1.1_2b
******************************************************************************/

v_vd_flag  VARCHAR2(1);

v_vp_rec  cg$vd_pvs_view.cg$row_type;
v_vp_ind  cg$vd_pvs_view.cg$ind_type;
v_vp_pk   cg$vd_pvs_view.cg$pk_type;

v_begin_date DATE := NULL;
v_end_date DATE := NULL;


BEGIN

  P_RETURN_CODE := NULL;

    IF P_ACTION NOT IN ('INS','DEL','UPD') THEN
    P_RETURN_CODE := 'API_VDPVS_700'; -- Invalid action
    RETURN;
  END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  IF P_ACTION = 'INS' THEN              --we are inserting a record
    IF P_VDPVS_VP_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_VDPVS_100' ;  --for inserts the ID IS generated
   RETURN;
    ELSE
      --Check to see that all mandatory parameters are not null
   IF P_VDPVS_VD_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_VDPVS_102'; --VD_IDSEQ cannot be null here
  RETURN;
   END IF;

      IF P_VDPVS_PV_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_VDPVS_104'; --PV_IDSEQ cannot be null here
  RETURN;
   END IF;
    END IF;
  END IF;

--   2.1.1      08/23/2004  DLadino          1. Added code to "UPDATE" a VD_PVS record
--                                              sprf_2.1.1_2b
  IF P_ACTION = 'UPD' THEN              --we are updating a record
    IF P_VDPVS_VP_IDSEQ IS NULL THEN
      P_RETURN_CODE := 'API_VDPVS_105' ;  --for updates the ID is required
   RETURN;
    END IF;
    /*IF P_VDPVS_ORIGIN IS NULL THEN
      P_RETURN_CODE := 'API_VDPVS_106' ;  --for updates the origin is required
   RETURN;
    END IF;*/
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are deleting a record

    IF P_VDPVS_VP_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_VDPVS_400' ;  --for deleted the ID id mandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.vd_pvs_exists(P_VDPVS_VP_IDSEQ) THEN
     P_RETURN_CODE := 'API_VDPVS_005'; --VD_PVS NOT found
     RETURN;
   END IF;
    END IF;

    --  Added the following code 24-Aug-2004 DLadino SPRF_2.1.1_2
    --GF30800 commented out as it is no longer need to tie with the form (does not matter if it is used by the form)
--    IF Sbrext_Common_Routines.vd_pvs_qc_exists (P_VDPVS_VP_IDSEQ, NULL) = 'TRUE' THEN
--      P_RETURN_CODE := 'API_VDPVS_006';   --VD_PVS_QC found
--      RETURN;
--    END IF;

    v_vp_pk.vp_idseq := P_VDPVS_VP_IDSEQ;

    SELECT ROWID
 INTO   v_vp_pk.the_rowid
    FROM   vd_pvs_view
    WHERE  vp_idseq = P_VDPVS_VP_IDSEQ;
    v_vp_pk.jn_notes := NULL;

    BEGIN
      cg$vd_pvs_view.del(v_vp_pk);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_VDPVS_501'; --Error deleting Value Domain
        P_RETURN_CODE := SQLCODE;
   RETURN;
    END;

  END IF;

  --check to see that Value Domain Aand Permissible Values and Context exist in the database
  IF NOT Sbrext_Common_Routines.ac_exists(P_VDPVS_VD_IDSEQ)  THEN
    P_RETURN_CODE := 'API_VDPVS_201'; --VALUE Domain NOT found in the database
    RETURN;
  END IF;

  IF P_VDPVS_CON_IDSEQ IS NOT NULL THEN
     IF NOT Sbrext_Common_Routines.ac_exists(P_VDPVS_CON_IDSEQ)  THEN
      P_RETURN_CODE := 'API_VDPVS_205'; --CONCEPT  NOT  found in the database
      RETURN;
    END IF;
 IF NOT Sbrext_Common_Routines.VALID_PARENT_CONCEPT(p_vdpvs_con_idseq,p_vdpvs_vd_idseq) THEN
    P_RETURN_CODE := 'API_VDPVS_206'; --concept is not a component concept for value domain
    RETURN;
 END IF;
  END IF;
  IF NOT Sbrext_Common_Routines.pv_exists(p_pv_idseq=>P_VDPVS_PV_IDSEQ)  THEN
    P_RETURN_CODE := 'API_VDPVS_202'; --PERMISSIBLE VALUE NOT found in the database
    RETURN;
  END IF;
  IF P_VDPVS_CONTE_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.context_exists(P_VDPVS_CONTE_IDSEQ) THEN
      P_RETURN_CODE := 'API_VDPVS_200'; --Context not found in the database
      RETURN;
    END IF;
  END IF;

  --check to see that begin data and end date are valid dates

IF(P_VDPVS_BEGIN_DATE IS NOT NULL) THEN
  Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_VDPVS_BEGIN_DATE,v_begin_date);
  IF P_RETURN_CODE IS NOT NULL THEN
    P_RETURN_CODE := 'API_VDPVS_600'; --begin date is invalid
    RETURN;
  END IF;
END IF;

IF(P_VDPVS_END_DATE IS NOT NULL) THEN
  Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_VDPVS_END_DATE,v_end_date);
  IF P_RETURN_CODE IS NOT NULL THEN
    P_RETURN_CODE := 'API_VDPVS_601'; --end date is invalid
    RETURN;
  END IF;
END IF;


IF(P_VDPVS_BEGIN_DATE IS NOT NULL AND P_VDPVS_END_DATE IS NOT NULL) THEN
  IF(v_end_date < v_begin_date) THEN
     P_RETURN_CODE := 'API_VDPVS_210'; --end date is before begin date
     RETURN;
  END IF;
END IF;



  IF (P_ACTION = 'INS' ) THEN
    --check to see that Value Domain Permissible Value already exist
    IF Sbrext_Common_Routines.vd_pvs_exists(P_VDPVS_VD_IDSEQ,P_VDPVS_PV_IDSEQ) THEN
      p_return_code := 'API_VDPVS_300';-- Combination Already Exist
      RETURN;
    END IF;

  --check to see if the value domain is enumerated
    BEGIN
      SELECT vd_type_flag
   INTO   v_vd_flag
      FROM   value_domains_view
      WHERE  vd_idseq = P_VDPVS_VD_IDSEQ;
      IF v_vd_flag  <> 'E' THEN
        P_RETURN_CODE := 'API_VDPVS_205'; -- valid values can not be added to non enumerated value domains
        RETURN;
      END IF;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      P_RETURN_CODE := 'API_VDPVS_201'; --VALUE Domain NOT found in the database
   RETURN;
    END;

    P_VDPVS_VP_IDSEQ      := admincomponent_crud.cmr_guid;
    P_VDPVS_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_VDPVS_CREATED_BY    := P_UA_NAME;--USER;
    P_VDPVS_DATE_MODIFIED := NULL;
    P_VDPVS_MODIFIED_BY   := NULL;

    v_vp_rec.vp_idseq      := P_VDPVS_VP_IDSEQ;
    v_vp_rec.conte_idseq   := P_VDPVS_CONTE_IDSEQ;
    v_vp_rec.vd_idseq         := P_VDPVS_VD_IDSEQ;
    v_vp_rec.pv_idseq       := P_VDPVS_pv_IDSEQ;
    v_vp_rec.created_by      := P_VDPVS_CREATED_BY;
    v_vp_rec.date_created   := TO_DATE(P_VDPVS_DATE_CREATED);
    v_vp_rec.modified_by   := P_VDPVS_MODIFIED_BY;
    v_vp_rec.date_modified    := P_VDPVS_DATE_MODIFIED;
    v_vp_rec.con_idseq    := P_VDPVS_con_idseq;
    v_vp_rec.begin_date        := TO_DATE(P_VDPVS_BEGIN_DATE);
    v_vp_rec.end_date            := TO_DATE(P_VDPVS_END_DATE);
 v_vp_rec.origin           := P_VDPVS_ORIGIN; -- 24-Jul-2003, W. Ver Hoef

    v_vp_ind.VD_IDSEQ       := TRUE;
    v_vp_ind.CONTE_IDSEQ   := TRUE;
    v_vp_ind.VD_IDSEQ       := TRUE;
    v_vp_ind.created_by      := TRUE;
    v_vp_ind.date_created   := TRUE;
    v_vp_ind.modified_by   := TRUE;
    v_vp_ind.date_modified    := TRUE;
 v_vp_ind.origin           := TRUE;
 v_vp_ind.con_idseq           := TRUE;
    v_vp_ind.begin_date        := TRUE;
    v_vp_ind.end_date            := TRUE;-- 24-Jul-2003, W. Ver Hoef

    BEGIN
      cg$vd_pvs_view.ins(v_vp_rec,v_vp_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_VDPVS_500'; --Error inserting VD_PVS
    END;
  ELSIF (P_ACTION = 'UPD' ) THEN  --  Added 8/23/2004 sprf_2.1.1_2b
   admin_security_util.seteffectiveuser(p_ua_name);
    IF P_VDPVS_ORIGIN = ' ' THEN
      v_vp_rec.origin := NULL;
      v_vp_ind.origin := TRUE;
    ELSE
      v_vp_rec.origin  := P_VDPVS_ORIGIN;
      v_vp_ind.origin := TRUE;
    END IF;

 IF P_VDPVS_BEGIN_DATE = ' ' THEN
      v_vp_rec.begin_date := NULL;
      v_vp_ind.begin_date := TRUE;
    ELSE
      v_vp_rec.begin_date  := P_VDPVS_begin_date;
      v_vp_ind.begin_date := TRUE;
    END IF;


 IF P_VDPVS_END_DATE = ' ' THEN
      v_vp_rec.end_date := NULL;
      v_vp_ind.end_date := TRUE;
    ELSE
      v_vp_rec.end_date  := P_VDPVS_end_date;
      v_vp_ind.end_date := TRUE;
    END IF;

 IF P_VDPVS_CON_IDSEQ = ' ' THEN
      v_vp_rec.con_idseq := NULL;
      v_vp_ind.con_idseq := TRUE;
    ELSE
      v_vp_rec.con_idseq  := P_VDPVS_con_idseq;
      v_vp_ind.con_idseq := TRUE;
    END IF;


    P_VDPVS_DATE_MODIFIED := TO_CHAR(SYSDATE);
    P_VDPVS_MODIFIED_BY   := P_UA_NAME;--USER;

    v_vp_rec.vp_idseq      := P_VDPVS_VP_IDSEQ;
    v_vp_rec.date_modified := P_VDPVS_DATE_MODIFIED;
    v_vp_rec.modified_by   := P_VDPVS_MODIFIED_BY;

    v_vp_ind.date_modified := TRUE;
    v_vp_ind.modified_by   := TRUE;

    v_vp_ind.VD_IDSEQ      := FALSE;
    v_vp_ind.CONTE_IDSEQ   := FALSE;
    v_vp_ind.VP_IDSEQ      := FALSE;
    v_vp_ind.PV_IDSEQ      := FALSE;
    v_vp_ind.created_by    := FALSE;
    v_vp_ind.date_created  := FALSE;

    BEGIN
      cg$vd_pvs_view.upd(v_vp_rec,v_vp_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_VDPVS_502'; -- Error updating VD_PVS
    END;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;

END SET_VD_PVS;



PROCEDURE SET_DE(
 P_UA_NAME      IN  VARCHAR2
,P_RETURN_CODE                 OUT VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_DE_DE_IDSEQ             IN OUT VARCHAR2
,P_DE_PREFERRED_NAME     IN OUT VARCHAR2
,P_DE_CONTE_IDSEQ         IN OUT VARCHAR2
,P_DE_VERSION             IN OUT NUMBER
,P_DE_PREFERRED_DEFINITION  IN OUT VARCHAR2
,P_DE_DEC_IDSEQ          IN OUT VARCHAR2
,P_DE_VD_IDSEQ             IN OUT VARCHAR2
,P_DE_ASL_NAME             IN OUT VARCHAR2
,P_DE_LATEST_VERSION_IND    IN OUT VARCHAR2
,P_DE_LONG_NAME             IN OUT VARCHAR2
,P_DE_BEGIN_DATE         IN OUT VARCHAR2
,P_DE_END_DATE             IN OUT VARCHAR2
,P_DE_CHANGE_NOTE         IN OUT VARCHAR2
,P_DE_CREATED_BY            OUT VARCHAR2
,P_DE_DATE_CREATED            OUT VARCHAR2
,P_DE_MODIFIED_BY              OUT VARCHAR2
,P_DE_DATE_MODIFIED            OUT VARCHAR2
,P_DE_DELETED_IND              OUT VARCHAR2
,p_DE_ORIGIN                IN     VARCHAR2 DEFAULT NULL)  -- 15-Jul-2003, W. Ver Hoef
IS
/******************************************************************************
   NAME:       SET_DE
   PURPOSE:    Inserts or Updates a Single Row Of Data Element  Based on either
               DE_IDSEQ or Preferred Name, Context and Version

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal  1. Created this procedure
   2.0        07/15/2003  W. Ver Hoef      1. added parameter for origin and code
                                              also for cde_id;
             2. fixed proper setting of p_de_de_idseq
                parameter.
   2.1        03/19/2004  W. Ver Hoef      1. substituted UNASSIGNED with function
                                              call to get_default_asl

******************************************************************************/

  v_version      data_elements_view.version%TYPE;
  v_ac           data_elements_view.de_idseq%TYPE;
  v_begin_date   DATE := NULL;
  v_end_date     DATE := NULL;
  v_new_Version  BOOLEAN := FALSE;
  v_asl_name     data_elements_view.asl_name%TYPE;
  v_de_idseq     VARCHAR2(36);  -- 16-Jul-2003, W. Ver Hoef - added variable

  v_de_rec       cg$data_elements_view.cg$row_type;
  v_de_ind       cg$data_elements_view.cg$ind_type;

BEGIN
  P_RETURN_CODE := NULL;


  IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
    P_RETURN_CODE := 'API_DE_700'; -- Invalid action
    RETURN;
  END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  IF P_ACTION = 'INS' THEN             --we are inserting a record
    IF P_DE_DE_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_DE_100' ;  --for inserts the ID is generated
   RETURN;
    ELSE
      --Check to see that all mandatory parameters are either not NULL or have a default value.
   IF P_DE_PREFERRED_NAME IS NULL THEN
     P_RETURN_CODE := 'API_DE_101';  --Preferred Name cannot be null here
  RETURN;
   END IF;
   IF P_DE_CONTE_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_DE_102'; --CONTE_IDSEQ cannot be null here
  RETURN;
   END IF;
   IF P_DE_PREFERRED_DEFINITION IS NULL THEN
     P_RETURN_CODE := 'API_DE_103'; --Preferred Definition cannot be null here
  RETURN;
   END IF;
   IF P_DE_ASL_NAME IS NULL THEN
     -- 19-Mar-2004, W. Ver Hoef - substituted UNASSIGNED with function call below
     P_DE_ASL_NAME := Sbrext_Common_Routines.get_default_asl('INS'); -- 'UNASSIGNED';
   END IF;
   IF P_DE_VERSION IS NULL THEN
     P_DE_VERSION := Sbrext_Common_Routines.get_ac_version(P_DE_PREFERRED_NAME,P_DE_CONTE_IDSEQ,'DATAELEMENT','HIGHEST') + 1;
   END IF;
   IF P_DE_VD_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_DE_104'; --VD_IDSEQ cannot be null here
  RETURN;
   END IF;
      IF P_DE_DEC_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_DE_106'; --DEC_IDSEQ cannot be null here
  RETURN;
   END IF;
   IF P_DE_LATEST_VERSION_IND IS NULL THEN
     P_DE_LATEST_VERSION_IND := 'No';
   END IF;
    END IF;
  END IF;

  IF P_ACTION = 'UPD' THEN              --we are updating a record
    IF P_DE_DE_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_DE_400' ;  --for updates the ID IS mandatory
   RETURN;
    END IF;
    SELECT asl_name INTO v_asl_name
    FROM data_elements_view
    WHERE de_idseq = p_de_de_idseq;
    IF (P_DE_PREFERRED_NAME IS NOT NULL OR P_DE_CONTE_IDSEQ IS NOT NULL) AND v_asl_name = 'RELEASED' THEN
      P_RETURN_CODE := 'API_DE_401' ;  --Preferred Name or Context Can not be updated
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(P_DE_DE_IDSEQ) THEN
      P_RETURN_CODE := 'API_DE_005'; --DE not found
      RETURN;
    END IF;
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are logically deleteing a record

    IF P_DE_DE_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_DE_400' ;  --for deletes the ID IS mandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ac_exists(P_DE_DE_IDSEQ) THEN
     P_RETURN_CODE := 'API_DE_005'; --Data Element not found
     RETURN;
      END IF;
    END IF;

    P_DE_DELETED_IND       := 'Yes';
    P_DE_MODIFIED_BY       := P_UA_NAME;--USER;
    P_DE_DATE_MODIFIED     := TO_CHAR(SYSDATE);

    v_de_rec.de_idseq      := P_DE_DE_IDSEQ;
    v_de_rec.deleted_ind   := P_DE_DELETED_IND;
    v_de_rec.modified_by   := P_DE_MODIFIED_BY;
    v_de_rec.date_modified := TO_DATE(P_DE_DATE_MODIFIED);

    v_de_ind.de_idseq           := TRUE;
    v_de_ind.preferred_name       := FALSE;
    v_de_ind.conte_idseq       := FALSE;
    v_de_ind.version           := FALSE;
    v_de_ind.preferred_definition := FALSE;
    v_de_ind.long_name           := FALSE;
    v_de_ind.asl_name           := FALSE;
    v_de_ind.vd_idseq           := FALSE;
    v_de_ind.latest_version_ind   := FALSE;
    v_de_ind.dec_idseq            := FALSE;
    v_de_ind.begin_date           := FALSE;
    v_de_ind.end_date           := FALSE;
    v_de_ind.change_note       := FALSE;
    v_de_ind.created_by           := FALSE;
    v_de_ind.date_created       := FALSE;
    v_de_ind.modified_by       := TRUE;
    v_de_ind.date_modified       := TRUE;
    v_de_ind.deleted_ind          := TRUE;
 v_de_ind.cde_id            := FALSE; -- 15-Jul-2003, W. Ver Hoef
    v_de_ind.origin               := FALSE;
    BEGIN


      cg$data_elements_view.upd(v_de_rec,v_de_ind);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
dbms_output.put_line('SQLERRM = '||SQLERRM);
dbms_output.put_line('SQLCODE = '||SQLCODE);
      P_RETURN_CODE := 'API_DE_502'; --Error deleting Data Element
   RETURN;
    END;

  END IF;

  IF P_DE_LATEST_VERSION_IND IS NOT NULL THEN
    IF P_DE_LATEST_VERSION_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_DE_105'; --Version can only be 'Yes' or 'No'
      RETURN;
    END IF;
  END IF;
  --Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
  IF LENGTH(P_DE_PREFERRED_NAME) > Sbrext_Column_Lengths.L_DE_PREFERRED_NAME THEN
    P_RETURN_CODE := 'API_DE_111';  --Length of preferred_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_DE_PREFERRED_DEFINITION) > Sbrext_Column_Lengths.L_DE_PREFERRED_DEFINITION THEN
    P_RETURN_CODE := 'API_DE_113';  --Length of Preferred_definition exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_DE_LONG_NAME) > Sbrext_Column_Lengths.L_DE_LONG_NAME THEN
    P_RETURN_CODE := 'API_DE_114'; --Length of Long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_DE_ASL_NAME) > Sbrext_Column_Lengths.L_DE_ASL_NAME  THEN
    P_RETURN_CODE := 'API_DE_115'; --Length of asl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_DE_CHANGE_NOTE) > Sbrext_Column_Lengths.L_DE_CHANGE_NOTE THEN
    P_RETURN_CODE := 'API_DE_128'; --Length of change_note exceeds maximum length
    RETURN;
  END IF;

  --check to see that charachter strings are valid
  IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_DE_PREFERRED_NAME) THEN
    P_RETURN_CODE := 'API_DE_130'; -- Data Element Preferred Name has invalid Ccharacters
    RETURN;
  END IF;

  IF NOT Sbrext_Common_Routines.valid_char(P_DE_PREFERRED_DEFINITION) THEN
    P_RETURN_CODE := 'API_DE_133'; -- Data Element Preferred Definition has invalid characters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_DE_LONG_NAME) THEN
    P_RETURN_CODE := 'API_DE_134'; -- Data Element Long Name has invalid characters
    RETURN;
  END IF;

  --check to see that Context, Workflow Status, Data Element Concept, Value Domain already exist in the database
  IF P_DE_CONTE_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.context_exists(P_DE_CONTE_IDSEQ) THEN
      P_RETURN_CODE := 'API_DE_200'; --Context not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_DE_VD_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.ac_exists(P_DE_VD_IDSEQ)  THEN
      P_RETURN_CODE := 'API_DE_201'; --Value Domain not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_DE_ASL_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.workflow_exists(P_DE_ASL_NAME) THEN
      P_RETURN_CODE := 'API_DE_202'; --Workflow Status not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_DE_DEC_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.ac_exists(P_DE_DEC_IDSEQ) THEN
      P_RETURN_CODE := 'API_DE_203'; --DEC_IDSEQ not found in the database
      RETURN;
    END IF;
  END IF;

  --check to see that begin date and end date are valid dates
  IF(P_DE_BEGIN_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_DE_BEGIN_DATE,v_begin_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_DE_600'; --begin date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_DE_END_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_DE_END_DATE,v_end_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_DE_601'; --end date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_DE_BEGIN_DATE IS NOT NULL AND P_DE_END_DATE IS NOT NULL) THEN
    IF(v_end_date < v_begin_date) THEN
       P_RETURN_CODE := 'API_DE_210'; --end date is before begin date
       RETURN;
    END IF;
  --ELSIF(P_DE_END_DATE IS NOT NULL AND P_DE_BEGIN_DATE IS NULL) THEN
    --P_RETURN_CODE := 'API_DE_211'; --begin date cannot be null when end date is null
    --RETURN;
  END IF;

  IF (P_ACTION = 'INS' ) THEN

    -- check to see that a Data Element with the same
    -- Preferred Name, Context and Version does not already exist
    IF Sbrext_Common_Routines.ac_exists(P_DE_PREFERRED_NAME,P_DE_CONTE_IDSEQ ,P_DE_VERSION,'DATAELEMENT') THEN
      P_RETURN_CODE := 'API_DE_300';-- Data Element already Exists
      RETURN;
    END IF;
    -- Check to see if prior versions alresdy exist
    IF Sbrext_Common_Routines.ac_version_exists(P_DE_PREFERRED_NAME,P_DE_CONTE_IDSEQ ,'DATAELEMENT') THEN -- we are creating a new version
      v_new_version := TRUE;
      v_ac          := Sbrext_Common_Routines.get_version_ac(P_DE_PREFERRED_NAME,P_DE_CONTE_IDSEQ,'DATAELEMENT');
    END IF;

 -- 16-Jul-2003, W. Ver Hoef - replaced parameter P_DE_DE_IDSEQ with variable v_de_idseq
    v_de_idseq         := admincomponent_crud.cmr_guid;
    P_DE_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_DE_CREATED_BY    := P_UA_NAME;--USER;
    P_DE_DATE_MODIFIED := NULL;
    P_DE_MODIFIED_BY   := NULL;
    P_DE_DELETED_IND   := 'No';

    v_de_rec.de_idseq             := v_de_idseq; -- 16-Jul-2003, W. Ver Hoef - replaced here too
    v_de_rec.preferred_name       := P_DE_PREFERRED_NAME;
    v_de_rec.conte_idseq          := P_DE_CONTE_IDSEQ;
    v_de_rec.version              := P_DE_VERSION;
    v_de_rec.preferred_definition := P_DE_PREFERRED_DEFINITION;
    v_de_rec.long_name            := P_DE_LONG_NAME;
    v_de_rec.asl_name             := P_DE_ASL_NAME ;
    v_de_rec.dec_idseq            := P_DE_DEC_IDSEQ;
    v_de_rec.vd_idseq             := P_DE_VD_IDSEQ ;
    v_de_rec.latest_version_ind   := P_DE_LATEST_VERSION_IND;
    v_de_rec.begin_date           := TO_DATE(P_DE_BEGIN_DATE);
    v_de_rec.end_date             := TO_DATE(P_DE_END_DATE);
    v_de_rec.change_note          := P_DE_CHANGE_NOTE ;
    v_de_rec.created_by           := P_DE_CREATED_BY;
    v_de_rec.date_created         := TO_DATE(P_DE_DATE_CREATED);
    v_de_rec.modified_by          := P_DE_MODIFIED_BY;
    v_de_rec.date_modified        := TO_DATE(P_DE_DATE_MODIFIED);
    v_de_rec.deleted_ind          := P_DE_DELETED_IND;
 v_de_rec.origin               := P_DE_ORIGIN;  -- 15-Jul-2003, W. Ver Hoef
 SELECT cde_id_seq.NEXTVAL -- When transaction_type := 'VERSION' as below,
 INTO v_de_rec.cde_id      -- BIU trigger won't properly assign a value
 FROM dual;                -- so we have to set it here.

    v_de_ind.de_idseq             := TRUE;
    v_de_ind.preferred_name       := TRUE;
    v_de_ind.conte_idseq          := TRUE;
    v_de_ind.version              := TRUE;
    v_de_ind.preferred_definition := TRUE;
    v_de_ind.long_name            := TRUE;
    v_de_ind.asl_name             := TRUE;
    v_de_ind.dec_idseq            := TRUE;
    v_de_ind.vd_idseq             := TRUE;
    v_de_ind.latest_version_ind   := TRUE;
    v_de_ind.begin_date           := TRUE;
    v_de_ind.end_date             := TRUE;
    v_de_ind.change_note          := TRUE;
    v_de_ind.created_by           := TRUE;
    v_de_ind.date_created         := TRUE;
    v_de_ind.modified_by          := TRUE;
    v_de_ind.date_modified        := TRUE;
    v_de_ind.deleted_ind          := TRUE;
 v_de_ind.cde_id               := TRUE;  -- 15-Jul-2003, W. Ver Hoef
 v_de_ind.origin               := TRUE;

    BEGIN
     -- meta_global_pkg.transaction_type := 'VERSION';
      cg$data_elements_view.ins(v_de_rec,v_de_ind);
      P_DE_DE_IDSEQ := v_de_rec.de_idseq;  -- 16-Jul-2003, W. Ver Hoef - added assignment
   meta_global_pkg.transaction_type := NULL;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_DE_500'; --Error inserting Data Element
    END;

    --If LATEST_VERSION_IND is 'Yes' then update so that all other versions have the indicator set to 'No'
    IF(P_DE_LATEST_VERSION_IND = 'Yes') THEN
      Sbrext_Common_Routines.set_ac_lvi(P_RETURN_CODE,P_DE_DE_IDSEQ,'DATAELEMENT');
      IF P_RETURN_CODE IS NOT NULL  THEN
        P_RETURN_CODE := 'API_DE_503'; -- Error updating latest_Value_ind
        RETURN;
      END IF;
    END IF;

    --create a history record with prior version
    IF v_new_version THEN
      BEGIN
        meta_config_mgmt.CREATE_AC_HISTORIES (v_ac,P_DE_DE_IDSEQ,'VERSIONED','DATAELEMENT');
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_DE_504'; --Error creating history
      END;
    END IF;

  END IF;

  IF (P_ACTION = 'UPD' ) THEN

    --Get the version for the P_DE_DECIDSEQ
    SELECT version INTO v_version
    FROM data_elements_view
    WHERE de_idseq = P_DE_DE_IDSEQ;

    IF v_version <> P_DE_VERSION THEN
      P_RETURN_CODE := 'API_DE_402'; -- Version can NOT be updated. It can only be created
      RETURN;
    END IF;

    P_DE_DATE_MODIFIED := TO_CHAR(SYSDATE);
    P_DE_MODIFIED_BY   := P_UA_NAME;--USER;
    P_DE_DELETED_IND   := 'No';

    v_de_rec.date_modified := TO_DATE(P_DE_DATE_MODIFIED);
    v_de_rec.modified_by   := P_DE_MODIFIED_BY;
    v_de_rec.de_idseq      := P_DE_DE_IDSEQ;
    v_de_rec.deleted_ind   := 'No';

    v_de_ind.date_modified := TRUE;
    v_de_ind.modified_by   := TRUE;
    v_de_ind.deleted_ind   := TRUE;
    v_de_ind.de_idseq      := TRUE;

    v_de_ind.version       := FALSE;
    v_de_ind.created_by    := FALSE;
    v_de_ind.date_created  := FALSE;
 v_de_ind.cde_id        := FALSE;  -- 15-Jul-2003, W. Ver Hoef

    IF P_DE_PREFERRED_NAME IS NULL THEN
      v_de_ind.preferred_name := FALSE;
    ELSE
      v_de_rec.preferred_name := P_DE_PREFERRED_NAME;
      v_de_ind.preferred_name := TRUE;
    END IF;

    IF P_DE_CONTE_IDSEQ IS NULL THEN
      v_de_ind.conte_idseq := FALSE;
    ELSE
      v_de_rec.conte_idseq := P_DE_CONTE_IDSEQ;
      v_de_ind.conte_idseq := TRUE;
    END IF;

    IF P_DE_PREFERRED_DEFINITION IS NULL THEN
      v_de_ind.preferred_definition := FALSE;
    ELSE
      v_de_rec.preferred_definition := P_DE_PREFERRED_DEFINITION;
      v_de_ind.preferred_definition := TRUE;
    END IF;

    IF P_DE_LONG_NAME IS NULL THEN
      v_de_ind.long_name := FALSE;
 ELSIF P_DE_long_name = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_de_rec.long_name := NULL;
      v_de_ind.long_name := TRUE;
    ELSE
      v_de_rec.long_name := P_DE_LONG_NAME;
      v_de_ind.long_name := TRUE;
    END IF;

    IF P_DE_ASL_NAME IS NULL THEN
      v_de_ind.asl_name := FALSE;
    ELSE
      v_de_rec.asl_name := P_DE_ASL_NAME;
      v_de_ind.asl_name := TRUE;
    END IF;

    IF P_DE_DEC_IDSEQ IS NULL THEN
      v_de_ind.dec_idseq := FALSE;
    ELSE
      v_de_rec.dec_idseq := P_DE_DEC_IDSEQ;
      v_de_ind.dec_idseq := TRUE;
    END IF;

    IF P_DE_VD_IDSEQ IS NULL THEN
      v_de_ind.vd_idseq  := FALSE;
    ELSE
      v_de_rec.vd_idseq  := P_DE_VD_IDSEQ;
      v_de_ind.vd_idseq  := TRUE;
    END IF;

    IF P_DE_LATEST_VERSION_IND IS NULL THEN
      v_de_ind.latest_version_ind := FALSE;
    ELSE
      v_de_rec.latest_version_ind := P_DE_LATEST_VERSION_IND;
      v_de_ind.latest_version_ind := TRUE;
    END IF;

    IF P_DE_BEGIN_DATE IS NULL THEN
      v_de_ind.begin_date := FALSE;
 ELSIF P_DE_begin_date = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_de_rec.begin_date := NULL;
      v_de_ind.begin_date := TRUE;
    ELSE
      v_de_rec.begin_date := TO_DATE(P_DE_BEGIN_DATE);
      v_de_ind.begin_date := TRUE;
    END IF;

    IF P_DE_END_DATE  IS NULL THEN
      v_de_ind.end_date := FALSE;
 ELSIF P_DE_end_date = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_de_rec.end_date := NULL;
      v_de_ind.end_date := TRUE;
    ELSE
      v_de_rec.end_date := TO_DATE(P_DE_END_DATE);
      v_de_ind.end_date := TRUE;
    END IF;

    IF P_DE_CHANGE_NOTE   IS NULL THEN
      v_de_ind.change_note := FALSE;
 ELSIF P_DE_change_note = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_de_rec.change_note := NULL;
      v_de_ind.change_note := TRUE;
    ELSE
      v_de_rec.change_note := P_DE_CHANGE_NOTE  ;
      v_de_ind.change_note := TRUE;
    END IF;

    IF P_DE_ORIGIN   IS NULL THEN  -- 15-Jul-2003, W. Ver Hoef
      v_de_ind.origin := FALSE;
 ELSIF P_DE_origin = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
      v_de_rec.origin := NULL;
      v_de_ind.origin := TRUE;
    ELSE
      v_de_rec.origin := P_DE_ORIGIN  ;
      v_de_ind.origin := TRUE;
    END IF;

    BEGIN
--      dbms_output.put_line(v_de_rec.preferred_Definition);
      cg$data_elements_view.upd(v_de_rec,v_de_ind);
--      null;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_DE_501'; --Error updating Data Element
    END;

    --If LATEST_VERSION_IND is'Yes' then update so that all other versions have the indicator set to 'No'
    IF(P_DE_LATEST_VERSION_IND = 'Yes') THEN
      Sbrext_Common_Routines.set_ac_lvi(P_RETURN_CODE,P_DE_DE_IDSEQ,'DATAELEMENT');
      IF P_RETURN_CODE IS NOT NULL  THEN
        P_RETURN_CODE := 'API_DE_503'; -- Error updating latest_Value_ind
        RETURN;
      END IF;
    END IF;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;
END SET_DE;


PROCEDURE SET_RD(
 P_UA_NAME                  IN VARCHAR2
,P_RETURN_CODE     OUT    VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_RD_RD_IDSEQ             IN OUT VARCHAR2
,P_RD_NAME                 IN OUT VARCHAR2
,P_RD_DCTL_NAME             IN OUT VARCHAR2
,P_RD_AC_IDSEQ             IN OUT VARCHAR2
,P_RD_ACH_IDSEQ             IN OUT VARCHAR2
,P_RD_AR_IDSEQ             IN OUT VARCHAR2
,P_RD_DOC_TEXT             IN OUT VARCHAR2
,P_RD_ORG_IDSEQ             IN OUT VARCHAR2
,P_RD_URL                      IN OUT VARCHAR2
,P_RD_CREATED_BY         OUT    VARCHAR2
,P_RD_DATE_CREATED         OUT    VARCHAR2
,P_RD_MODIFIED_BY         OUT    VARCHAR2
,P_RD_DATE_MODIFIED         OUT    VARCHAR2
,P_RD_LAE_NAME              IN  VARCHAR2 DEFAULT 'ENGLISH'
,P_RD_CONTE_IDSEQ              IN VARCHAR2 )  IS
/******************************************************************************
   NAME:       SET_RD
   PURPOSE:    Inserts or Updates a Single Row Of Reference Document Based on either
               RD_IDSEQ or PAC_IDSEQ, NAME

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal      1. Created this procedure




******************************************************************************/

v_rd_rec    cg$reference_documents_view.cg$row_type;
v_rd_ind    cg$reference_documents_view.cg$ind_type;
v_rd_pk     cg$reference_documents_view.cg$pk_type;
v_conte_idseq VARCHAR2(36):= p_rd_conte_idseq;
BEGIN
P_RETURN_CODE := NULL;

 IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
 P_RETURN_CODE := 'API_RD_700'; -- Invalid action
 RETURN;
END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

IF P_ACTION = 'INS' THEN             --we are inserting a record
  IF P_RD_RD_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_RD_100' ;  --for inserts the ID is generated
  RETURN;
  ELSE
     --Check to see that all mandatory parameters are either not NULL or have a default value.
  IF P_RD_NAME IS NULL THEN
     P_RETURN_CODE := 'API_RD_101';  --Name cannot be null here
  RETURN;
  END IF;
  IF P_RD_DCTL_NAME IS NULL THEN
     P_RETURN_CODE := 'API_RD_102'; --Document Type cannot be null here
  RETURN;
  END IF;
       IF P_RD_AC_IDSEQ IS NULL AND P_RD_ACH_IDSEQ IS NULL AND P_RD_AR_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_RD_103'; --All AC_IDSEQ or ACH_IDSEQ or AR_IDSEQ  can not be null here
  RETURN;
  END IF;
  --check arc
       IF NOT Sbrext_Common_Routines.valid_arc(P_RD_AC_IDSEQ,P_RD_ACH_IDSEQ,P_RD_AR_IDSEQ) THEN
         P_RETURN_CODE := 'API_RD_210';  --Invalid arc. Only one of the arc keys of the arc can have a value.
         RETURN;
       END IF;

  END IF;
END IF;
IF P_ACTION = 'UPD' THEN              --we are updating a record
  admin_security_util.seteffectiveuser(p_ua_name);
  IF P_RD_RD_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_RD_400' ;  --for updates the ID IS mandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.rd_exists(P_RD_RD_IDSEQ) THEN
   P_RETURN_CODE := 'API_RD_005'; --Reference Document not found
   RETURN;
 END IF;
  END IF;
  IF (P_RD_AC_IDSEQ IS NOT NULL OR P_RD_ACH_IDSEQ IS NOT NULL OR P_RD_AR_IDSEQ IS NOT NULL)THEN
       P_RETURN_CODE := 'API_RD_212'; -- only update of content is allowed. update of  relationship is not allowed
       RETURN;
  END IF;
 --check the arc
  IF NOT Sbrext_Common_Routines.valid_arc(P_RD_AC_IDSEQ,P_RD_ACH_IDSEQ,P_RD_AR_IDSEQ) THEN
    P_RETURN_CODE := 'API_RD_210';  --Invalid arc. Only one of the arc keys of the arc can have a value.
    RETURN;
  END IF;
END IF;
IF P_ACTION = 'DEL' THEN              --we are deleting a record
  IF P_RD_RD_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_RD_400' ;  --for deleted the ID idmandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.rd_exists(P_RD_RD_IDSEQ) THEN
   P_RETURN_CODE := 'API_RD_005'; --RD NOT found
   RETURN;
 END IF;
  END IF;
  v_rd_pk.rd_idseq := P_RD_RD_IDSEQ;

  SELECT ROWID INTO v_rd_pk.the_rowid
  FROM reference_documents_view
  WHERE rd_idseq = P_RD_RD_IDSEQ;
  --v_rd_pk.jn_notes := NULL;

  BEGIN
    cg$reference_documents_view.del(v_rd_pk);
 RETURN;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_RD_502'; --Error deleteing reference document
 RETURN;
  END;
END IF;

--Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
IF LENGTH(P_RD_NAME) > Sbrext_Column_Lengths.L_RD_NAME THEN
  P_RETURN_CODE := 'API_RD_111';  --Length of name exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_RD_DCTL_NAME) > Sbrext_Column_Lengths.L_RD_DCTL_NAME THEN
  P_RETURN_CODE := 'API_RD_112'; --Length of Document Type exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_RD_DOC_TEXT) > Sbrext_Column_Lengths.L_RD_DOC_TEXT THEN
  P_RETURN_CODE := 'API_RD_113';  --Length of document text exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_RD_URL) > Sbrext_Column_Lengths.L_RD_URL THEN
  P_RETURN_CODE := 'API_RD_114'; --Length of URL exceeds maximum length
  RETURN;
END IF;

--check to see that charachter strings are valid
IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_RD_NAME) THEN
  P_RETURN_CODE := 'API_RD_130'; -- Name has invalid characters
  RETURN;
END IF;

IF NOT Sbrext_Common_Routines.valid_char(P_RD_DOC_TEXT) THEN
  P_RETURN_CODE := 'API_RD_134'; -- Document Text has invalid characters
  RETURN;
END IF;


--check to see that foreign keys already exist in the database
IF(P_RD_AC_IDSEQ) IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.ac_exists(P_RD_AC_IDSEQ)  THEN
    P_RETURN_CODE := 'API_RD_200'; --Administered Component not found in the database
    RETURN;
  END IF;
END IF;
IF NOT Sbrext_Common_Routines.dctl_exists(P_RD_DCTL_NAME) THEN
  P_RETURN_CODE := 'API_RD_201'; --Document Type not found in the database
  RETURN;
END IF;

IF V_CONTE_IDSEQ IS NOT NULL THEN
IF NOT Sbrext_Common_Routines.CONTEXT_EXISTS(v_conte_idseq) THEN
  P_RETURN_CODE := 'API_RD_207'; --Document Type not found in the database
  RETURN;
END IF;
END IF;

IF P_RD_ACH_IDSEQ IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.ach_exists(P_RD_ACH_IDSEQ) THEN
    P_RETURN_CODE := 'API_RD_203'; --ACH not found not found in the database
    RETURN;
  END IF;
END IF;

IF P_RD_AR_IDSEQ IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.ar_exists(P_RD_AR_IDSEQ) THEN
    P_RETURN_CODE := 'API_RD_204'; --AR not found in the database
    RETURN;
  END IF;
END IF;
IF P_RD_ORG_IDSEQ IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.org_exists(P_RD_ACH_IDSEQ) THEN
    P_RETURN_CODE := 'API_RD_205'; --Organinzation not found in the database
    RETURN;
  END IF;
END IF;

IF (P_ACTION = 'INS' ) THEN

--check to see that  a Reference document with the same
--Name, AC_IDSEQ does not already exist
  IF Sbrext_Common_Routines.rd_exists(P_RD_NAME,P_RD_AC_IDSEQ) THEN
   P_RETURN_CODE := 'API_RD_300';-- Reference Document already Exists
   RETURN;
  END IF;

IF v_conte_idseq IS NULL THEN
 BEGIN
  SELECT conte_idseq INTO v_conte_idseq
  FROM administered_components
  WHERE ac_idseq = p_rd_Ac_idseq;
 EXCEPTION WHEN OTHERS THEN
   P_RETURN_CODE := 'API_RD_10'; --ac not valid
 END;
END IF;

  P_RD_RD_IDSEQ := admincomponent_crud.cmr_guid;
  P_RD_DATE_CREATED := TO_CHAR(SYSDATE);
  P_RD_CREATED_BY := P_UA_NAME;--USER;
  P_RD_DATE_MODIFIED := NULL;
  P_RD_MODIFIED_BY := NULL;

  v_rd_rec.rd_idseq          := P_RD_RD_IDSEQ;
  v_rd_rec.name              := P_RD_NAME;
  v_rd_rec.org_idseq      := P_RD_ORG_IDSEQ;
  v_rd_rec.dctl_name      := P_RD_DCTL_NAME;
  v_rd_rec.doc_text          := P_RD_DOC_TEXT;
  v_rd_rec.ar_idseq          := P_RD_AR_IDSEQ ;
  v_rd_rec.ach_idseq       := P_RD_ACH_IDSEQ;
  v_rd_rec.ac_idseq          := P_RD_AC_IDSEQ ;
  v_rd_rec.url              := P_RD_URL ;
  v_rd_rec.lae_name              := P_RD_LAE_NAME ;
  v_rd_rec.created_by      := P_RD_CREATED_BY;
  v_rd_rec.date_created      := TO_DATE(P_RD_DATE_CREATED);
  v_rd_rec.modified_by      := P_RD_MODIFIED_BY;
  v_rd_rec.date_modified  := TO_DATE(P_RD_DATE_MODIFIED);
  v_rd_rec.conte_idseq  := v_conte_idseq;


  v_rd_ind.rd_idseq          := TRUE;
  v_rd_ind.name              := TRUE;
  v_rd_ind.org_idseq      := TRUE;
  v_rd_ind.dctl_name         := TRUE;
  v_rd_ind.doc_text          := TRUE;
  v_rd_ind.ar_idseq          := TRUE;
  v_rd_ind.ach_idseq       := TRUE;
  v_rd_ind.ac_idseq          := TRUE;
  v_rd_ind.url               := TRUE;
  v_rd_ind.lae_name          := TRUE;
  v_rd_ind.created_by      := TRUE;
  v_rd_ind.date_created      := TRUE;
  v_rd_ind.modified_by      := TRUE;
  v_rd_ind.date_modified  := TRUE;
  v_rd_ind.conte_idseq    := TRUE;

  BEGIN
    cg$reference_documents_view.ins(v_rd_rec,v_rd_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_RD_500'; --Error inserting Reference documents
 RAISE;
  END;
END IF;

IF (P_ACTION = 'UPD' ) THEN

  P_RD_DATE_MODIFIED := TO_CHAR(SYSDATE);
  P_RD_MODIFIED_BY := P_UA_NAME;--USER;

  v_rd_rec.date_modified := TO_DATE(P_RD_DATE_MODIFIED);
  v_rd_rec.modified_by   := P_RD_MODIFIED_BY;
  v_rd_rec.rd_idseq     := P_RD_RD_IDSEQ;
  v_rd_ind.date_modified := TRUE;
  v_rd_ind.modified_by   := TRUE;
  v_rd_ind.rd_idseq     := TRUE;
  v_rd_ind.created_by       := FALSE;
  v_rd_ind.date_created   := FALSE;
  v_rd_ind.ac_idseq     := FALSE;
  v_rd_ind.ach_idseq     := FALSE;
  v_rd_ind.ar_idseq     := FALSE;

  IF P_RD_NAME IS NULL THEN
    v_rd_ind.name := FALSE;
  ELSE
    v_rd_rec.name := P_RD_NAME;
    v_rd_ind.name := TRUE;
  END IF;

  IF P_RD_ORG_IDSEQ IS NULL THEN
    v_rd_ind.org_idseq := FALSE;
  ELSIF P_RD_ORG_IDSEQ = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
    v_rd_rec.org_idseq := NULL;
    v_rd_ind.org_idseq := TRUE;
  ELSE
    v_rd_rec.org_idseq := P_RD_ORG_IDSEQ;
    v_rd_ind.org_idseq := TRUE;
  END IF;

  IF P_RD_DCTL_NAME IS NULL THEN
    v_rd_ind.dctl_name := FALSE;
  ELSE
    v_rd_rec.dctl_name := P_RD_DCTL_NAME;
    v_rd_ind.dctl_name := TRUE;
  END IF;

  IF P_RD_DOC_TEXT IS NULL THEN
    v_rd_ind.doc_text := FALSE;
  ELSIF P_RD_DOC_TEXT = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
    v_rd_rec.doc_text := NULL;
    v_rd_ind.doc_text := TRUE;
  ELSE
    v_rd_rec.doc_text := P_RD_DOC_TEXT;
    v_rd_ind.doc_text := TRUE;
  END IF;

  IF P_RD_URL   IS NULL THEN
    v_rd_ind.url := FALSE;
  ELSIF P_RD_URL = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
    v_rd_rec.url := NULL;
    v_rd_ind.url := TRUE;
  ELSE
    v_rd_rec.url := P_RD_URL  ;
    v_rd_ind.url := TRUE;
  END IF;

  IF P_RD_CONTE_IDSEQ  IS NULL THEN
    v_rd_ind.conte_idseq := FALSE;
  ELSE
    v_rd_rec.conte_idseq := P_RD_CONTE_IDSEQ  ;
    v_rd_ind.conte_idseq := TRUE;
  END IF;

  IF P_RD_LAE_NAME   IS NULL THEN
    v_rd_ind.lae_name := FALSE;
  ELSIF P_RD_lae_name = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
    v_rd_rec.lae_name := NULL;
    v_rd_ind.lae_name := TRUE;
  ELSE
    v_rd_rec.lae_name := P_RD_LAE_NAME ;
    v_rd_ind.lae_name := TRUE;
  END IF;

  BEGIN
    cg$reference_documents_view.upd(v_rd_rec,v_rd_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_RD_501'; --Error updating Reference Document
  END;
END IF;

EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       RAISE;
END SET_RD;



PROCEDURE SET_DES(
 P_UA_NAME   IN VARCHAR2
,P_RETURN_CODE     OUT    VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_DES_DESIG_IDSEQ         IN OUT VARCHAR2
,P_DES_NAME                 IN OUT VARCHAR2
,P_DES_DETL_NAME         IN OUT VARCHAR2
,P_DES_AC_IDSEQ             IN OUT VARCHAR2
,P_DES_CONTE_IDSEQ         IN OUT VARCHAR2
,P_DES_LAE_NAME             IN OUT VARCHAR2
,P_DES_CREATED_BY         OUT    VARCHAR2
,P_DES_DATE_CREATED         OUT    VARCHAR2
,P_DES_MODIFIED_BY         OUT    VARCHAR2
,P_DES_DATE_MODIFIED     OUT    VARCHAR2)  IS
/******************************************************************************
   NAME:       SET_DES
   PURPOSE:    Inserts or Updates a Single Row Of Designation Based on either
               DES_IDSEQ or Name, Context, DETL_NAME  and AC_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal  1. Created this procedure
   2.0        07/16/2003  W. Ver Hoef      2. Added debug messages to test set_de
                                              in curator pkg which calls this

******************************************************************************/

v_des_rec    cg$designations_view.cg$row_type;
v_des_ind    cg$designations_view.cg$ind_type;
v_des_pk     cg$designations_view.cg$pk_type;
BEGIN

P_RETURN_CODE := NULL;


IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
  P_RETURN_CODE := 'API_DES_700'; -- Invalid action
  RETURN;
END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

IF P_ACTION = 'INS' THEN             --we are inserting a record
  IF P_DES_DESIG_IDSEQ IS NOT NULL THEN
    P_RETURN_CODE := 'API_DES_100' ;  --for inserts the ID is generated
 RETURN;
  ELSE

  IF (P_DES_DETL_NAME IS NULL AND P_DES_DETL_NAME <> 'CDE_ID')  THEN
     P_RETURN_CODE := 'API_DES_102'; --Desgination Type cannot be null here
  RETURN;
  END IF;
       IF P_DES_AC_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_DES_103'; --AC_IDSEQ  can not be null here
  RETURN;
  END IF;
       IF P_DES_CONTE_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_DES_104'; --CONTE_IDSEQ  can not be null here
  RETURN;
  END IF;
  END IF;
END IF;
IF P_ACTION = 'UPD' THEN              --we are updating a record
 admin_security_util.seteffectiveuser(p_ua_name);
  IF P_DES_DESIG_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_DES_400' ;  --for updates the ID IS mandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.des_exists(P_DES_DESIG_IDSEQ) THEN
   P_RETURN_CODE := 'API_DES_005'; --Desgination not found
   RETURN;
 END IF;
  END IF;
END IF;

IF P_ACTION = 'DEL' THEN              --we are deleting a record
  IF P_DES_DESIG_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_DES_400' ;  --for deleted the ID idmandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.des_exists(P_DES_DESIG_IDSEQ) THEN
   P_RETURN_CODE := 'API_DES_005'; --Designation NOT found
   RETURN;
 END IF;
  END IF;
  v_des_pk.desig_idseq := P_DES_DESIG_IDSEQ;

  SELECT ROWID INTO v_des_pk.the_rowid
  FROM designations_view
  WHERE desig_idseq = P_DES_DESIG_IDSEQ;
  v_des_pk.jn_notes := NULL;

  BEGIN
    cg$designations_view.del(v_des_pk);
 RETURN;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_DES_502'; --Error deleteing Designation
 RETURN;
  END;
END IF;

--Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
IF LENGTH(P_DES_NAME) > Sbrext_Column_Lengths.L_DES_NAME THEN
  P_RETURN_CODE := 'API_DES_111';  --Length of name exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_DES_DETL_NAME) > Sbrext_Column_Lengths.L_DES_DETL_NAME THEN
  P_RETURN_CODE := 'API_DES_112'; --Length of Designation Type exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_DES_LAE_NAME) > Sbrext_Column_Lengths.L_DES_LAE_NAME THEN
  P_RETURN_CODE := 'API_DES_113';  --Length of Language exceeds maximum length
  RETURN;
END IF;

--check to see that charachter strings are valid
-- Changed the validation to valid_name which allows names starting with numbers
IF NOT Sbrext_Common_Routines.valid_name(P_DES_NAME) THEN
  P_RETURN_CODE := 'API_DES_130'; -- Name has invalid characters
  RETURN;
END IF;

--check to see that foreign keys already exist in the database

IF NOT Sbrext_Common_Routines.ac_exists(P_DES_AC_IDSEQ)  THEN
  P_RETURN_CODE := 'API_DES_200'; --Administered Component not found in the database
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.detl_exists(P_DES_DETL_NAME) THEN
  P_RETURN_CODE := 'API_DES_201'; --Desgination Type not found in the database
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.context_exists(P_DES_CONTE_IDSEQ) THEN
  P_RETURN_CODE := 'API_DES_203'; --Context not found in the database
  RETURN;
END IF;
IF P_DES_LAE_NAME IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.lae_exists(P_DES_LAE_NAME) THEN
    P_RETURN_CODE := 'API_DES_204'; --Language not found in the database
    RETURN;
  END IF;
END IF;

IF (P_ACTION = 'INS' ) THEN

--check to see that  document with the same
--Name, AC_IDSEQ does not already exist
  IF Sbrext_Common_Routines.des_exists(P_DES_AC_IDSEQ,P_DES_NAME,P_DES_DETL_NAME,P_DES_CONTE_IDSEQ) THEN
   P_RETURN_CODE := 'API_DES_300';--Desgination already Exists
   RETURN;
  END IF;

  P_DES_DESIG_IDSEQ := admincomponent_crud.cmr_guid;
  P_DES_DATE_CREATED := TO_CHAR(SYSDATE);
  P_DES_CREATED_BY := P_UA_NAME;--USER;
  P_DES_DATE_MODIFIED := NULL;
  P_DES_MODIFIED_BY := NULL;

  v_des_rec.desig_idseq          := P_DES_DESIG_IDSEQ;
  v_des_rec.name              := P_DES_NAME;
  v_des_rec.conte_idseq      := P_DES_CONTE_IDSEQ;
  v_des_rec.ac_idseq      := P_DES_AC_IDSEQ;
  v_des_rec.detl_name      := P_DES_DETL_NAME;
  v_des_rec.lae_name          := P_DES_LAE_NAME;
  v_des_rec.created_by      := P_DES_CREATED_BY;
  v_des_rec.date_created      := TO_DATE(P_DES_DATE_CREATED);
  v_des_rec.modified_by      := P_DES_MODIFIED_BY;
  v_des_rec.date_modified  := TO_DATE(P_DES_DATE_MODIFIED);


  v_des_ind.desig_idseq          := TRUE;
  v_des_ind.name              := TRUE;
  v_des_ind.conte_idseq      := TRUE;
  v_des_ind.ac_idseq      := TRUE;
  v_des_ind.detl_name         := TRUE;
  v_des_ind.lae_name          := TRUE;
  v_des_ind.created_by      := TRUE;
  v_des_ind.date_created      := TRUE;
  v_des_ind.modified_by      := TRUE;
  v_des_ind.date_modified  := TRUE;

  BEGIN
    cg$designations_view.ins(v_des_rec,v_des_ind);

 SELECT name INTO p_des_name
 FROM designations_view
 WHERE desig_idseq = P_DES_DESIG_IDSEQ;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_DES_500'; --Error inserting Designation
  END;
END IF;

IF (P_ACTION = 'UPD' ) THEN

  P_DES_DATE_MODIFIED := TO_CHAR(SYSDATE);
  P_DES_MODIFIED_BY := P_UA_NAME;--USER;

  v_des_rec.date_modified := TO_DATE(P_DES_DATE_MODIFIED);
  v_des_rec.modified_by   := P_DES_MODIFIED_BY;
  v_des_rec.desig_idseq   := P_DES_DESIG_IDSEQ;
  v_des_ind.date_modified := TRUE;
  v_des_ind.modified_by   := TRUE;
  v_des_ind.desig_idseq   := TRUE;
  v_des_ind.created_by   := FALSE;
  v_des_ind.date_created  := FALSE;

  IF P_DES_NAME IS NULL THEN
    v_des_ind.name := FALSE;
  ELSE
    v_des_rec.name := P_DES_NAME;
    v_des_ind.name := TRUE;
  END IF;

  IF P_DES_CONTE_IDSEQ IS NULL THEN
    v_des_ind.conte_idseq := FALSE;
  ELSE
    v_des_rec.conte_idseq := P_DES_CONTE_IDSEQ;
    v_des_ind.conte_idseq := TRUE;
  END IF;

  IF P_DES_DETL_NAME IS NULL THEN
    v_des_ind.detl_name := FALSE;
  ELSE
    v_des_rec.detl_name := P_DES_DETL_NAME;
    v_des_ind.detl_name := TRUE;
  END IF;

  IF P_DES_LAE_NAME IS NULL THEN
    v_des_ind.lae_name := FALSE;
  ELSIF P_des_lae_name = ' ' THEN -- Condition added on 9/9/03 to allow null updates by Prerna Aggarwal
    v_des_rec.lae_name := NULL;
    v_des_ind.lae_name := TRUE;
  ELSE
    v_des_rec.lae_name := P_DES_LAE_NAME;
    v_des_ind.lae_name := TRUE;
  END IF;

  IF P_DES_AC_IDSEQ IS NULL THEN
    v_des_ind.ac_idseq  := FALSE;
  ELSE
    v_des_rec.ac_idseq  := P_DES_AC_IDSEQ;
    v_des_ind.ac_idseq  := TRUE;
  END IF;

    BEGIN
    cg$designations_view.upd(v_des_rec,v_des_ind);
 SELECT name INTO p_des_name
 FROM designations_view
 WHERE desig_idseq = P_DES_DESIG_IDSEQ;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_DES_501'; --Error updating Designation
  END;
END IF;

EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_DES;



PROCEDURE  SET_CSCSI(
 P_UA_NAME      IN VARCHAR2
,P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_CSCSI_CS_CSI_IDSEQ     IN OUT VARCHAR2
,P_CSCSI_CS_IDSEQ         IN OUT VARCHAR2
,P_CSCSI_LABEL            IN OUT VARCHAR2
,P_CSCSI_CSI_IDSEQ         IN OUT VARCHAR2
,P_CSCSI_P_CS_CSI_IDSEQ     IN OUT VARCHAR2
,P_CSCSI_LINK_CS_CSI_IDSEQ IN OUT VARCHAR2
,P_CSCSI_DISPLAY_ORDER     IN OUT NUMBER
,P_CSCSI_DATE_CREATED     OUT VARCHAR2
,P_CSCSI_CREATED_BY         OUT VARCHAR2
,P_CSCSI_MODIFIED_BY     OUT VARCHAR2
,P_CSCSI_DATE_MODIFIED     OUT VARCHAR2)  IS
/******************************************************************************
   NAME:       SET_CS_CSI
   PURPOSE:    Inserts or Updates a Single Row Of CS_CSI on either
               CS_CSI_IDSEQ or CS_IDSEQ, CSI_IDSEQ and P_CS_CSI_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal      1. Created this procedure




******************************************************************************/




v_cscsi_rec    cg$cs_csi_view.cg$row_type;
v_cscsi_ind    cg$cs_csi_view.cg$ind_type;
BEGIN
P_RETURN_CODE := NULL;

 IF P_ACTION NOT IN ('INS') THEN
 P_RETURN_CODE := 'API_CSCSI_700'; -- Invalid action
 RETURN;
END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
  IF P_CSCSI_CS_CSI_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_CSCSI_100' ;  --for inserts the ID IS generated
  RETURN;
  ELSE
     --Check to see that all mandatory parameters are not null

  IF P_CSCSI_CS_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_CSCSI_102'; --CS_IDSEQ cannot be null here
  RETURN;
  END IF;

  IF P_CSCSI_CSI_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_CSCSI_103'; --CSI_IDSEQ cannot be null here
  RETURN;
  END IF;
       IF P_CSCSI_LABEL IS NULL THEN
     P_RETURN_CODE := 'API_CSCSI_104'; --LABEL cannot be null here
  RETURN;
  END IF;

  END IF;
END IF;



--check to see that foreign keys

IF NOT Sbrext_Common_Routines.ac_exists(P_CSCSI_CS_IDSEQ)  THEN
  P_RETURN_CODE := 'API_CSCSI_201'; --CS NOT found in the database
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.csi_exists(P_CSCSI_CSI_IDSEQ)  THEN
  P_RETURN_CODE := 'API_CSCSI_202'; --CSI NOT found in the database
  RETURN;
END IF;

IF P_CSCSI_P_CS_CSI_IDSEQ IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.cs_csi_exists(P_CSCSI_P_CS_CSI_IDSEQ) THEN
    P_RETURN_CODE := 'API_CSCSI_200'; --Parent not found in the database
    RETURN;
  END IF;
END IF;
IF P_CSCSI_LINK_CS_CSI_IDSEQ IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.cs_csi_exists(P_CSCSI_LINK_CS_CSI_IDSEQ) THEN
    P_RETURN_CODE := 'API_CSCSI_203'; --Link not found in the database
    RETURN;
  END IF;
END IF;


IF (P_ACTION = 'INS' ) THEN
--check to see that CS CSI already exists
  IF Sbrext_Common_Routines.cs_csi_exists(P_CSCSI_CS_IDSEQ,P_CSCSI_CSI_IDSEQ,P_CSCSI_P_CS_CSI_IDSEQ) THEN
    p_return_code := 'API_CSCSI_300';-- CCombination Already Exist
    RETURN;
  END IF;
  P_CSCSI_CS_CSI_IDSEQ := admincomponent_crud.cmr_guid;
  P_CSCSI_DATE_CREATED := TO_CHAR(SYSDATE);
  P_CSCSI_CREATED_BY := P_UA_NAME;--USER;
  P_CSCSI_DATE_MODIFIED := NULL;
  P_CSCSI_MODIFIED_BY := NULL;

  v_cscsi_rec.cs_csi_idseq       := P_CSCSI_CS_CSI_IDSEQ;
  v_cscsi_rec.cs_idseq           := P_CSCSI_CS_IDSEQ ;
  v_cscsi_rec.csi_idseq          := P_CSCSI_CSI_IDSEQ ;
  v_cscsi_rec.p_cs_csi_idseq  := P_CSCSI_P_CS_CSI_IDSEQ ;
  v_cscsi_rec.link_cs_csi_idseq  := P_CSCSI_LINK_CS_CSI_IDSEQ ;
  v_cscsi_rec.label              := P_CSCSI_LABEL ;
  v_cscsi_rec.display_order      := P_CSCSI_DISPLAY_ORDER ;
  v_cscsi_rec.created_by         := P_CSCSI_CREATED_BY;
  v_cscsi_rec.date_created      := TO_DATE(P_CSCSI_DATE_CREATED);
  v_cscsi_rec.modified_by      := P_CSCSI_MODIFIED_BY;
  v_cscsi_rec.date_modified      := P_CSCSI_DATE_MODIFIED;

  v_cscsi_ind.cs_csi_idseq       := TRUE;
  v_cscsi_ind.cs_idseq          := TRUE;
  v_cscsi_ind.csi_idseq          := TRUE;
  v_cscsi_ind.p_cs_csi_idseq  := TRUE ;
  v_cscsi_ind.link_cs_csi_idseq  := TRUE ;
  v_cscsi_ind.label              := TRUE ;
  v_cscsi_ind.display_order      := TRUE ;
  v_cscsi_ind.created_by      := TRUE;
  v_cscsi_ind.date_created      := TRUE;
  v_cscsi_ind.modified_by      := TRUE;
  v_cscsi_ind.date_modified      := TRUE;

  BEGIN
    cg$cs_csi_view.ins(v_cscsi_rec,v_cscsi_ind);
  EXCEPTION WHEN OTHERS THEN
   P_RETURN_CODE := 'API_CSCSI_500'; --Error inserting CS_CSIS
  END;
END IF;

 EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_CSCSI;

PROCEDURE  SET_ACCSI(
 P_UA_NAME                   IN VARCHAR2
,P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_ACCSI_AC_CSI_IDSEQ     IN OUT VARCHAR2
,P_ACCSI_AC_IDSEQ         IN OUT VARCHAR2
,P_ACCSI_CS_CSI_IDSEQ     IN OUT VARCHAR2
,P_ACCSI_DATE_CREATED     OUT VARCHAR2
,P_ACCSI_CREATED_BY         OUT VARCHAR2
,P_ACCSI_MODIFIED_BY     OUT VARCHAR2
,P_ACCSI_DATE_MODIFIED     OUT VARCHAR2)  IS
/******************************************************************************
   NAME:       SET_ACCSI
   PURPOSE:    Inserts or Updates a Single Row Of AC_CSI on either
               AC_CSI_IDSEQ or CS_CSI_IDSEQ, CS_CSI_IDSEQ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/30/2001  Prerna Aggarwal      1. Created this procedure




******************************************************************************/


v_ac_csi_rec  cg$ac_csi_view.cg$row_type;
v_ac_csi_ind  cg$ac_csi_view.cg$ind_type;
v_ac_csi_pk   cg$ac_csi_view.cg$pk_type;
BEGIN
P_RETURN_CODE := NULL;


IF P_ACTION NOT IN ('INS','DEL') THEN
 P_RETURN_CODE := 'API_ACCSI_700'; -- Invalid action
 RETURN;
END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
  IF P_ACCSI_AC_CSI_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_ACCSI_100' ;  --for inserts the ID IS generated
  RETURN;
  ELSE
     --Check to see that all mandatory parameters are not null

  IF P_ACCSI_AC_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_ACCSI_102'; --AC_IDSEQ is mandatory
  RETURN;
  END IF;

  IF P_ACCSI_CS_CSI_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_ACCSI_104'; --CS_CSI_IDSEQ is mandatory
  RETURN;
  END IF;
  END IF;
END IF;


IF P_ACTION = 'DEL' THEN              --we are deleting a record
  IF P_ACCSI_AC_CSI_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_ACCSI_400' ;  --for deleted the ID idmandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.ac_csi_exists(P_ACCSI_AC_CSI_IDSEQ) THEN
   P_RETURN_CODE := 'API_ACCSI_005'; --AC_CSI NOT found
   RETURN;
 END IF;
  END IF;


  v_ac_csi_pk.ac_csi_idseq := P_ACCSI_AC_CSI_IDSEQ;
  SELECT ROWID INTO v_ac_csi_pk.the_rowid
  FROM ac_csi_view
  WHERE ac_csi_idseq = P_ACCSI_AC_CSI_IDSEQ;
  v_ac_csi_pk.jn_notes := NULL;

  BEGIN
    cg$ac_csi_view.del(v_ac_csi_pk);
 RETURN;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_ACCSI_501'; --Error deleteing
 RETURN;
  END;

END IF;

--check to see that foreign keys exist in the database

IF NOT Sbrext_Common_Routines.ac_exists(P_ACCSI_AC_IDSEQ)  THEN
  P_RETURN_CODE := 'API_ACCSI_201'; --Administered Component NOT found in the database
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.cs_csi_exists(P_ACCSI_CS_CSI_IDSEQ)  THEN
  P_RETURN_CODE := 'API_ACCSI_202'; --CS_CSI NOT found in the database
  RETURN;
END IF;

IF (P_ACTION = 'INS' ) THEN
--check to see already exist
  IF Sbrext_Common_Routines.ac_csi_exists(P_ACCSI_AC_IDSEQ,P_ACCSI_CS_CSI_IDSEQ) THEN
    p_return_code := 'API_ACCSI_300';-- CCombination Already Exist
    RETURN;
  END IF;
  P_ACCSI_AC_CSI_IDSEQ := admincomponent_crud.cmr_guid;
  P_ACCSI_DATE_CREATED := TO_CHAR(SYSDATE);
  P_ACCSI_CREATED_BY :=  P_UA_NAME ;--USER;
  P_ACCSI_DATE_MODIFIED := NULL;
  P_ACCSI_MODIFIED_BY := NULL;

  v_ac_csi_rec.ac_csi_idseq   := P_ACCSI_AC_CSI_IDSEQ;
  v_ac_csi_rec.ac_idseq       := P_ACCSI_AC_IDSEQ ;
  v_ac_csi_rec.cs_csi_idseq       := P_ACCSI_CS_CSI_IDSEQ ;
  v_ac_csi_rec.created_by   := P_ACCSI_CREATED_BY;
  v_ac_csi_rec.date_created   := TO_DATE(P_ACCSI_DATE_CREATED);
  v_ac_csi_rec.modified_by   := P_ACCSI_MODIFIED_BY;
  v_ac_csi_rec.date_modified  := P_ACCSI_DATE_MODIFIED;

  v_ac_csi_ind.AC_IDSEQ       := TRUE;
  v_ac_csi_ind.AC_CSI_IDSEQ   := TRUE;
  v_ac_csi_ind.CS_CSI_IDSEQ       := TRUE;
  v_ac_csi_ind.created_by   := TRUE;
  v_ac_csi_ind.date_created   := TRUE;
  v_ac_csi_ind.modified_by   := TRUE;
  v_ac_csi_ind.date_modified  := TRUE;
  BEGIN
    cg$ac_csi_view.ins(v_ac_csi_rec,v_ac_csi_ind);
  EXCEPTION WHEN OTHERS THEN
   P_RETURN_CODE := 'API_ACCSI_500'; --Error inserting AC_CSI
  END;
END IF;


 EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_ACCSI;

PROCEDURE SET_SRC(
 P_UA_NAME                  IN  VARCHAR2
,P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_SRC_SRC_NAME             IN OUT VARCHAR2
,P_SRC_DESCRIPTION         IN OUT VARCHAR2
,P_SRC_CREATED_BY         OUT VARCHAR2
,P_SRC_DATE_CREATED         OUT VARCHAR2
,P_SRC_MODIFIED_BY         OUT VARCHAR2
,P_SRC_DATE_MODIFIED     OUT VARCHAR2)  IS
/******************************************************************************
   NAME:       SET_SRC
   PURPOSE:    Inserts or Updates a Single Row Of Source List of Value
               Based on ?Name

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/31/2001  Prerna Aggarwal      1. Created this procedure




******************************************************************************/
v_src_rec    Cg$sources_View_Ext.cg$row_type;
v_src_ind    Cg$sources_View_Ext.cg$ind_type;
BEGIN
P_RETURN_CODE := NULL;


IF P_ACTION NOT IN ('INS','UPD') THEN
 P_RETURN_CODE := 'API_SRC_700'; -- Invalid action
 RETURN;
END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
     --Check to see that all mandatory parameters are either not null
  IF P_SRC_SRC_NAME IS NULL THEN
    P_RETURN_CODE := 'API_SRC_101';  --Source Name cannot be null here
 RETURN;
  END IF;
END IF;

IF P_ACTION = 'UPD'  THEN
admin_security_util.seteffectiveuser(p_ua_name);
  IF P_SRC_SRC_NAME IS NULL THEN
    P_RETURN_CODE := 'API_SRC_101';  --Source Name cannot be null here
 RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.src_exists(P_SRC_SRC_NAME) THEN
   P_RETURN_CODE := 'API_SRC_005'; --SRC not found
   RETURN;
  END IF;
END IF;
--Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
IF LENGTH(P_SRC_SRC_NAME) > Sbrext_Column_Lengths.L_SRC_SRC_NAME THEN
  P_RETURN_CODE := 'API_SRC_111';  --Length of NAME exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_SRC_DESCRIPTION) > Sbrext_Column_Lengths.L_SRC_DESCRIPTION THEN
  P_RETURN_CODE := 'API_SRC_113';  --Length of DESCRIPTION exceeds maximum length
  RETURN;
END IF;

--check to see that charachter strings are valid
IF NOT Sbrext_Common_Routines.valid_char(P_SRC_SRC_NAME) THEN
  P_RETURN_CODE := 'API_SRC_130'; -- Source Name Short Meaning has invalid characters
  RETURN;
END IF;
IF P_SRC_DESCRIPTION IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.valid_char(P_SRC_DESCRIPTION) THEN
    P_RETURN_CODE := 'API_SRC_133'; -- Source Name Description has invalid characters
    RETURN;
  END IF;
END IF;

IF (P_ACTION = 'INS' ) THEN

--check to see that Short Name Does not already Exist
  IF Sbrext_Common_Routines.src_exists(P_SRC_SRC_NAME) THEN
    P_RETURN_CODE := 'API_SRC_300';-- Source Name already exists
    RETURN;
  END IF;

  P_SRC_DATE_CREATED  := TO_CHAR(SYSDATE);
  P_SRC_CREATED_BY    := P_UA_NAME;--USER;
  P_SRC_DATE_MODIFIED := NULL;
  P_SRC_MODIFIED_BY   := NULL;

  v_src_rec.src_name     := P_SRC_SRC_NAME;
  v_src_rec.description     := P_SRC_DESCRIPTION;
  v_src_rec.created_by     := P_SRC_CREATED_BY;
  v_src_rec.date_created := P_SRC_DATE_CREATED;
  v_src_rec.modified_by     := P_SRC_MODIFIED_BY;
  v_src_rec.date_modified := P_SRC_DATE_MODIFIED;


  v_src_ind.src_name       := TRUE;
  v_src_ind.description       := TRUE;
  v_src_ind.created_by       := TRUE;
  v_src_ind.date_created   := TRUE;
  v_src_ind.modified_by       := TRUE;
  v_src_ind.date_modified   := TRUE;

  BEGIN
    Cg$sources_View_Ext.ins(v_src_rec,v_src_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_SRC_500'; --Error inserting Source Name
  END;

END IF;


IF (P_ACTION = 'UPD' ) THEN

  P_SRC_DATE_MODIFIED := TO_CHAR(SYSDATE);
  P_SRC_MODIFIED_BY := P_UA_NAME;--USER;
  v_src_rec.date_modified := P_SRC_DATE_MODIFIED;
  v_src_rec.modified_by := P_SRC_MODIFIED_BY;
  v_src_ind.date_modified := TRUE;
  v_src_ind.modified_by := TRUE;
  v_src_ind.created_by := FALSE;
  v_src_ind.date_created := FALSE;

  IF P_SRC_DESCRIPTION IS NULL THEN
    v_src_ind.description := FALSE;
  ELSE
    v_src_rec.description := P_SRC_DESCRIPTION;
    v_src_ind.description := TRUE;
  END IF;
  BEGIN
    Cg$sources_View_Ext.upd(v_src_rec,v_src_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_SRC_501'; --Error updating Source
  END;
END IF;

EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_SRC;


PROCEDURE SET_TS(
P_UA_NAME       IN  VARCHAR2
,P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN  VARCHAR2
,P_TS_TS_IDSEQ             IN OUT VARCHAR2
,P_TS_QC_IDSEQ             IN OUT VARCHAR2
,P_TS_TSTL_NAME             IN OUT VARCHAR2
,P_TS_TS_TEXT             IN OUT VARCHAR2
,P_TS_TS_SEQ             IN OUT NUMBER
,P_TS_CREATED_BY         OUT VARCHAR2
,P_TS_DATE_CREATED         OUT VARCHAR2
,P_TS_MODIFIED_BY         OUT VARCHAR2
,P_TS_DATE_MODIFIED         OUT VARCHAR2) IS
/******************************************************************************
   NAME:       SET_TS
   PURPOSE:    Inserts or Updates a Single Row Of TEXT STRING based on                     TS_IDSEQ
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/31/2001  Prerna Aggarwal      1. Created this procedure




******************************************************************************/

v_ts_rec    Cg$text_Strings_View_Ext.cg$row_type;
v_ts_ind    Cg$text_Strings_View_Ext.cg$ind_type;
v_ts_pk     Cg$text_Strings_View_Ext.cg$pk_type;
BEGIN
P_RETURN_CODE := NULL;


IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
 P_RETURN_CODE := 'API_TS_700'; -- Invalid action
 RETURN;
END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
  IF P_TS_TS_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_TS_100' ;  --for inserts the ID IS generated
  RETURN;
  ELSE
     --Check to see that all mandatory parameters are either NOT NULL or have a default value.
  IF P_TS_QC_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_TS_101';  --QC_IDSEQ cannot be NULL here
  RETURN;
  END IF;
  IF P_TS_TSTL_NAME IS NULL THEN
     P_RETURN_CODE := 'API_TS_103'; --TSTL_NAME cannot be NULL here
  RETURN;
  END IF;
  IF P_TS_TS_TEXT IS NULL THEN
     P_RETURN_CODE := 'API_TS_104'; --Text cannot be NULL here
  RETURN;
  END IF;
       IF P_TS_TS_SEQ IS NULL THEN
     P_RETURN_CODE := 'API_TS_105'; --Sequence cannot be NULL here
  RETURN;
  END IF;

  END IF;
END IF;


IF P_ACTION = 'UPD' THEN              --we are inserting a record
  IF P_TS_TS_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_TS_400' ;  --for updates the ID is mandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.ts_exists(P_TS_TS_IDSEQ) THEN
   P_RETURN_CODE := 'API_TS_005'; --TS not found
   RETURN;
 END IF;
  END IF;
END IF;

IF P_ACTION = 'DEL' THEN              --we are deleting a record
  IF P_TS_TS_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_TS_400' ;  --for deleted the ID idmandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.ts_exists(P_TS_TS_IDSEQ) THEN
   P_RETURN_CODE := 'API_TS_005'; --TSNOT found
   RETURN;
 END IF;
  END IF;

  v_ts_pk.ts_idseq := P_TS_TS_IDSEQ;
  SELECT ROWID INTO v_ts_pk.the_rowid
  FROM text_strings_view_ext
  WHERE ts_idseq = P_TS_TS_IDSEQ;
  v_ts_pk.jn_notes := NULL;

  BEGIN
    Cg$text_Strings_View_Ext.del(v_ts_pk);
 RETURN;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_TS_502'; --Error deleteing Text String
 RETURN;
  END;

END IF;
--Check to see that all VARCHAR2 and CHAR parameters have correct length
IF LENGTH(P_TS_TSTL_NAME) > Sbrext_Column_Lengths.L_TS_TSTL_NAME THEN
  P_RETURN_CODE := 'API_TS_113';  --Length of TS Type exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_TS_TS_TEXT) > Sbrext_Column_Lengths.L_TS_TS_TEXT THEN
  P_RETURN_CODE := 'API_TS_114'; --Length of TS TExt exceeds maximum length
  RETURN;
END IF;

--check to see that charachter strings are valid
IF NOT Sbrext_Common_Routines.valid_char(P_TS_TSTL_NAME) THEN
  P_RETURN_CODE := 'API_TS_133'; -- TEXT STRING Type has invalid characters
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.valid_char(P_TS_TS_TEXT) THEN
  P_RETURN_CODE := 'API_TS_134'; -- TEXT STRING Text has invalid characters
  RETURN;
END IF;


--check to see that Foreign Keys already exist in the database

IF NOT Sbrext_Common_Routines.tstl_exists(P_TS_TSTL_NAME) THEN
    P_RETURN_CODE := 'API_TS_200'; --Text String Type not found in the database
 RETURN;
END IF;
IF NOT Sbrext_Common_Routines.ac_exists(P_TS_QC_IDSEQ) THEN
    P_RETURN_CODE := 'API_TS_201'; --Questionnaire Content not found in the database
 RETURN;
END IF;

IF (P_ACTION = 'INS' ) THEN

--check to see that Value  does not already

  P_TS_TS_IDSEQ := admincomponent_crud.cmr_guid;
  P_TS_DATE_CREATED := TO_CHAR(SYSDATE);
  P_TS_CREATED_BY := P_UA_NAME;  --USER;
  P_TS_DATE_MODIFIED := NULL;
  P_TS_MODIFIED_BY := NULL;

  v_ts_rec.ts_idseq            := P_TS_TS_IDSEQ;
  v_ts_rec.qc_idseq            := P_TS_QC_IDSEQ;
  v_ts_rec.tstl_name       := P_TS_TSTL_NAME;
  v_ts_rec.ts_text := P_TS_TS_TEXT;
  v_ts_rec.ts_seq    := P_TS_TS_SEQ;
  v_ts_rec.created_by        := P_TS_CREATED_BY;
  v_ts_rec.date_created        := TO_DATE(P_TS_DATE_CREATED);
  v_ts_rec.modified_by        := P_TS_MODIFIED_BY;
  v_ts_rec.date_modified    := P_TS_DATE_MODIFIED;


  v_ts_ind.ts_idseq             := TRUE;
  v_ts_ind.qc_idseq             := TRUE;
  v_ts_ind.tstl_name        := TRUE;
  v_ts_ind.ts_text  := TRUE;
  v_ts_ind.ts_seq     := TRUE;
  v_ts_ind.created_by         := TRUE;
  v_ts_ind.date_created         := TRUE;
  v_ts_ind.modified_by         := TRUE;
  v_ts_ind.date_modified     := TRUE;

  BEGIN
    Cg$text_Strings_View_Ext.ins(v_ts_rec,v_ts_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_TS_500'; --Error inserting TEXT STRING
  END;

END IF;



IF (P_ACTION = 'UPD' ) THEN

  P_TS_DATE_MODIFIED     := TO_CHAR(SYSDATE);
  P_TS_MODIFIED_BY       := P_UA_NAME;  --USER;
  v_ts_rec.date_modified := TO_DATE(P_TS_DATE_MODIFIED);
  v_ts_rec.modified_by   := P_TS_MODIFIED_BY;
  v_ts_rec.ts_idseq      := P_TS_TS_IDSEQ;

  v_ts_ind.date_modified := TRUE;
  v_ts_ind.modified_by   := TRUE;
  v_ts_ind.ts_idseq      := TRUE;

  v_ts_ind.created_by       := FALSE;
  v_ts_ind.date_created       := FALSE;

  IF P_TS_QC_IDSEQ IS NULL THEN
    v_ts_ind.qc_idseq := FALSE;
  ELSE
    v_ts_rec.qc_idseq := P_TS_QC_IDSEQ;
    v_ts_ind.qc_idseq := TRUE;
  END IF;

  IF P_TS_TSTL_NAME IS NULL THEN
    v_ts_ind.tstl_name := FALSE;
  ELSE
    v_ts_rec.tstl_name := P_TS_TSTL_NAME;
    v_ts_ind.tstl_name := TRUE;
  END IF;

  IF P_TS_TS_TEXT IS NULL THEN
    v_ts_ind.ts_text := FALSE;
  ELSE
    v_ts_rec.ts_text := P_TS_TS_TEXT;
    v_ts_ind.ts_text := TRUE;
  END IF;

  IF P_TS_TS_SEQ IS NULL THEN
    v_ts_ind.ts_seq := FALSE;
  ELSE
    v_ts_rec.ts_seq := P_TS_TS_SEQ;
    v_ts_ind.ts_seq := TRUE;
  END IF;


  BEGIN
    Cg$text_Strings_View_Ext.upd(v_ts_rec,v_ts_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_TS_501'; --Error updating Text String
  END;
END IF;

EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_TS;


PROCEDURE SET_ACSRC(
P_UA_NAME       IN VARCHAR2
,P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_ACSRC_ACS_IDSEQ         IN OUT VARCHAR2
,P_ACSRC_AC_IDSEQ         IN OUT VARCHAR2
,P_ACSRC_SRC_NAME           IN OUT VARCHAR2
,P_ACSRC_DATE_SUBMITTED     IN OUT VARCHAR2
,P_ACSRC_CREATED_BY         OUT VARCHAR2
,P_ACSRC_DATE_CREATED     OUT VARCHAR2
,P_ACSRC_MODIFIED_BY     OUT VARCHAR2
,P_ACSRC_DATE_MODIFIED     OUT VARCHAR2) IS
/******************************************************************************
   NAME:       SET_ACSRC
   PURPOSE:    Inserts or Updates a Single Row Of AC_SOURCES based on either
               ACS_IDSEQ or AC_IDSEQ and SRC_NAME

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/31/2001  Prerna Aggarwal      1. Created this procedure




******************************************************************************/
v_acsrc_rec    Cg$ac_Sources_View_Ext.cg$row_type;
v_acsrc_ind    Cg$ac_Sources_View_Ext.cg$ind_type;
v_acsrc_pk     Cg$ac_Sources_View_Ext.cg$pk_type;
BEGIN
P_RETURN_CODE := NULL;

 IF P_ACTION NOT IN ('INS','DEL') THEN
 P_RETURN_CODE := 'API_ACSRC_700'; -- Invalid action
 RETURN;
END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
  IF P_ACSRC_ACS_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_ACSRC_100' ;  --for inserts the ID IS generated
  RETURN;
  ELSE
     --Check to see that all mandatory parameters are either NOT NULL or have a default value.
  IF P_ACSRC_AC_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_ACSRC_101';  --AC_IDSEQ cannot be NULL here
  RETURN;
  END IF;
  IF P_ACSRC_SRC_NAME IS NULL THEN
     P_RETURN_CODE := 'API_ACSRC_103'; --Source Name cannot be NULL here
  RETURN;
  END IF;
  END IF;
END IF;


IF P_ACTION = 'DEL' THEN              --we are inserting a record
  IF P_ACSRC_ACS_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_ACSRC_400' ;  --for updates the ID is mandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.acsrc_exists(P_ACSRC_ACS_IDSEQ) THEN
   P_RETURN_CODE := 'API_ACSRC_005'; --ACSRC not found
   RETURN;
 END IF;
  END IF;
  v_acsrc_pk.acs_idseq := P_ACSRC_ACS_IDSEQ;
  SELECT ROWID INTO v_acsrc_pk.the_rowid
  FROM ac_sources_view_ext
  WHERE acs_idseq = P_ACSRC_ACS_IDSEQ;
  v_acsrc_pk.jn_notes := NULL;

  BEGIN
    Cg$ac_Sources_View_Ext.del(v_acsrc_pk);
 RETURN;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_ACSRC_501'; --Error deleteing AC source
 RETURN;
  END;
END IF;
--Check to see that all VARCHAR2 and CHAR parameters have correct length
IF LENGTH(P_ACSRC_SRC_NAME) > Sbrext_Column_Lengths.L_ACSRC_SRC_NAME THEN
  P_RETURN_CODE := 'API_ACSRC_113';  --Length of Source Name exceeds maximum length
  RETURN;
END IF;

 --check to see that Source Name and ac_idseq already exist in the database

IF NOT Sbrext_Common_Routines.src_exists(P_ACSRC_SRC_NAME) THEN
    P_RETURN_CODE := 'API_ACSRC_200'; --Source Name not found in the database
 RETURN;
END IF;
IF NOT Sbrext_Common_Routines.ac_exists(P_ACSRC_AC_IDSEQ) THEN
    P_RETURN_CODE := 'API_ACSRC_201'; --AC_IDSEQ not found in the database
 RETURN;
END IF;


IF (P_ACTION = 'INS' ) THEN

--check to see that record  does not already
  IF Sbrext_Common_Routines.acsrc_exists(P_ACSRC_AC_IDSEQ,P_ACSRC_SRC_NAME) THEN
    p_return_code := 'API_ACSRC_300';--  Source AC_IDSEQ ALREADY EXISTS
    RETURN;
  END IF;

  P_ACSRC_ACS_IDSEQ := admincomponent_crud.cmr_guid;
  P_ACSRC_DATE_CREATED := TO_CHAR(SYSDATE);
  P_ACSRC_CREATED_BY := P_UA_NAME;  --USER;
  P_ACSRC_DATE_MODIFIED := NULL;
  P_ACSRC_MODIFIED_BY := NULL;

  v_acsrc_rec.acs_idseq    := P_ACSRC_ACS_IDSEQ;
  v_acsrc_rec.ac_idseq        := P_ACSRC_AC_IDSEQ;
  v_acsrc_rec.src_name         := P_ACSRC_SRC_NAME;
  v_acsrc_rec.date_submitted   :=TO_DATE(P_ACSRC_DATE_SUBMITTED);
  v_acsrc_rec.created_by    := P_ACSRC_CREATED_BY;
  v_acsrc_rec.date_created    := TO_DATE(P_ACSRC_DATE_CREATED);
  v_acsrc_rec.modified_by    := P_ACSRC_MODIFIED_BY;
  v_acsrc_rec.date_modified    := P_ACSRC_DATE_MODIFIED;


  v_acsrc_ind.acs_idseq         := TRUE;
  v_acsrc_ind.ac_idseq             := TRUE;
  v_acsrc_ind.src_name              := TRUE;
  v_acsrc_ind.date_submitted     := TRUE;
  v_acsrc_ind.created_by         := TRUE;
  v_acsrc_ind.date_created         := TRUE;
  v_acsrc_ind.modified_by         := TRUE;
  v_acsrc_ind.date_modified         := TRUE;

  BEGIN
    Cg$ac_Sources_View_Ext.ins(v_acsrc_rec,v_acsrc_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_ACSRC_500'; --Error inserting AC Source
  END;

END IF;

/*

IF (P_ACTION = 'UPD' ) THEN

  P_ACSRC_DATE_MODIFIED     := to_char(sysdate);
  P_ACSRC_MODIFIED_BY       := P_UA_NAME;  --USER;
  v_acsrc_rec.date_modified := to_date(P_ACSRC_DATE_MODIFIED);
  v_acsrc_rec.modified_by   := P_ACSRC_MODIFIED_BY;
  v_acsrc_rec.acs_idseq   := P_ACSRC_ACS_IDSEQ;

  v_acsrc_ind.date_modified := TRUE;
  v_acsrc_ind.modified_by   := TRUE;
  v_acsrc_ind.acs_idseq   := TRUE;

  v_acsrc_ind.created_by := FALSE;
  v_acsrc_ind.date_created := FALSE;

  IF P_ACSRC_AC_IDSEQ IS NULL THEN
    v_acsrc_ind.ac_idseq := FALSE;
  ELSE
    v_acsrc_rec.ac_idseq := P_ACSRC_AC_IDSEQ;
    v_acsrc_ind.ac_idseq := TRUE;
  END IF;

  IF P_ACSRC_SRC_NAME IS NULL THEN
    v_acsrc_ind.src_name := FALSE;
  ELSE
    v_acsrc_rec.src_name := P_ACSRC_SRC_NAME;
    v_acsrc_ind.src_name := TRUE;
  END IF;

  IF P_ACSRC_DATE_SUBMITTED IS NULL THEN
    v_acsrc_ind.date_submitted := FALSE;
  ELSE
    v_acsrc_rec.date_submitted  := to_date(P_ACSRC_DATE_SUBMITTED);
    v_acsrc_ind.date_submitted  := TRUE;
  END IF;

  begin
    cg$ac_sources_view_ext.upd(v_acsrc_rec,v_acsrc_ind);
  exception when others THEN
    P_RETURN_CODE := 'API_ACSRC_502'; --Error updating AC Source
  end;
END IF;*/

EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_ACSRC;

PROCEDURE SET_VPSRC(
P_UA_NAME       IN  VARCHAR2
,P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_VPSRC_VPS_IDSEQ         IN OUT VARCHAR2
,P_VPSRC_VP_IDSEQ         IN OUT VARCHAR2
,P_VPSRC_SRC_NAME           IN OUT VARCHAR2
,P_VPSRC_DATE_SUBMITTED     IN OUT VARCHAR2
,P_VPSRC_CREATED_BY         OUT VARCHAR2
,P_VPSRC_DATE_CREATED     OUT VARCHAR2
,P_VPSRC_MODIFIED_BY     OUT VARCHAR2
,P_VPSRC_DATE_MODIFIED     OUT VARCHAR2) IS
/******************************************************************************
   NAME:       SET_VPSRC
   PURPOSE:    Inserts or Updates a Single Row Of VD_PVS_SOURCES based on either
               VPS_IDSEQ or VP_IDSEQ and SRC_NAME

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/31/2001  Prerna Aggarwal      1. Created this procedure




******************************************************************************/

v_vdsrc_rec    Cg$vd_Pvs_Sources_View_Ext.cg$row_type;
v_vdsrc_ind    Cg$vd_Pvs_Sources_View_Ext.cg$ind_type;
v_vpsrc_pk     Cg$vd_Pvs_Sources_View_Ext.cg$pk_type;
BEGIN
P_RETURN_CODE := NULL;


IF P_ACTION NOT IN ('INS','DEL') THEN
 P_RETURN_CODE := 'API_VDSRC_700'; -- Invalid action
 RETURN;
END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
  IF P_VPSRC_VPS_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_VPSRC_100' ;  --for inserts the ID IS generated
  RETURN;
  ELSE
     --Check to see that all mandatory parameters are either NOT NULL or have a default value.
  IF P_VPSRC_VP_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_VPSRC_101';  --VP_IDSEQ cannot be NULL here
  RETURN;
  END IF;
  IF P_VPSRC_SRC_NAME IS NULL THEN
     P_RETURN_CODE := 'API_VPSRC_103'; --Source Name cannot be NULL here
  RETURN;
  END IF;
  END IF;
END IF;


IF P_ACTION = 'DEL' THEN              --we are inserting a record
  IF P_VPSRC_VPS_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_VPSRC_400' ;  --for updates the ID is mandatory
  RETURN;
  ELSE
    IF NOT Sbrext_Common_Routines.vpsrc_exists(P_VPSRC_VPS_IDSEQ) THEN
   P_RETURN_CODE := 'API_VPSRC_005'; --VPSRC not found
   RETURN;
 END IF;
  END IF;
    v_vpsrc_pk.vps_idseq := P_VPSRC_VPS_IDSEQ;
  SELECT ROWID INTO v_vpsrc_pk.the_rowid
  FROM vd_pvs_sources_view_ext
  WHERE vps_idseq = P_VPSRC_VPS_IDSEQ;
  v_vpsrc_pk.jn_notes := NULL;

  BEGIN
    Cg$vd_Pvs_Sources_View_Ext.del(v_vpsrc_pk);
 RETURN;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_VPSRC_502'; --Error deleteing VP Source
 RETURN;
  END;
END IF;
--Check to see that all VARCHAR2 and CHAR parameters have correct length
IF LENGTH(P_VPSRC_SRC_NAME) > Sbrext_Column_Lengths.L_VPSRC_SRC_NAME THEN
  P_RETURN_CODE := 'API_VPSRC_113';  --Length of Source Name exceeds maximum length
  RETURN;
END IF;

 --check to see that Source Name and VP_IDSEQ already exist in the database

IF NOT Sbrext_Common_Routines.src_exists(P_VPSRC_SRC_NAME) THEN
    P_RETURN_CODE := 'API_VPSRC_200'; --Source Name not found in the database
 RETURN;
END IF;
IF NOT Sbrext_Common_Routines.vd_pvs_exists(P_VPSRC_VP_IDSEQ) THEN
    P_RETURN_CODE := 'API_VPSRC_201'; --VP_IDSEQ not found in the database
 RETURN;
END IF;


IF (P_ACTION = 'INS' ) THEN

--check to see that record  does not already
  IF Sbrext_Common_Routines.vpsrc_exists(P_VPSRC_VP_IDSEQ,P_VPSRC_SRC_NAME) THEN
    p_return_code := 'API_VPSRC_300';--  Source VP_IDSEQ ALREADY EXISTS
    RETURN;
  END IF;

  P_VPSRC_VPS_IDSEQ := admincomponent_crud.cmr_guid;
  P_VPSRC_DATE_CREATED := TO_CHAR(SYSDATE);
  P_VPSRC_CREATED_BY := P_UA_NAME;  --USER;
  P_VPSRC_DATE_MODIFIED := NULL;
  P_VPSRC_MODIFIED_BY := NULL;

  v_vdsrc_rec.vps_idseq    := P_VPSRC_VPS_IDSEQ;
  v_vdsrc_rec.vp_idseq        := P_VPSRC_VP_IDSEQ;
  v_vdsrc_rec.src_name         := P_VPSRC_SRC_NAME;
  v_vdsrc_rec.date_submitted   :=TO_DATE(P_VPSRC_DATE_SUBMITTED);
  v_vdsrc_rec.created_by  := P_VPSRC_CREATED_BY;
  v_vdsrc_rec.date_created  := TO_DATE(P_VPSRC_DATE_CREATED);
  v_vdsrc_rec.modified_by  := P_VPSRC_MODIFIED_BY;
  v_vdsrc_rec.date_modified  := P_VPSRC_DATE_MODIFIED;


  v_vdsrc_ind.vps_idseq         := TRUE;
  v_vdsrc_ind.vp_idseq         := TRUE;
  v_vdsrc_ind.src_name          := TRUE;
  v_vdsrc_ind.date_submitted   := TRUE;
  v_vdsrc_ind.created_by   := TRUE;
  v_vdsrc_ind.date_created   := TRUE;
  v_vdsrc_ind.modified_by   := TRUE;
  v_vdsrc_ind.date_modified   := TRUE;

  BEGIN
    Cg$vd_Pvs_Sources_View_Ext.ins(v_vdsrc_rec,v_vdsrc_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_VPSRC_500'; --Error inserting Source VP_IDSEQ
  END;

END IF;


/*
IF (P_ACTION = 'UPD' ) THEN

  P_VPSRC_DATE_MODIFIED     := to_char(sysdate);
  P_VPSRC_MODIFIED_BY       := P_UA_NAME;  --USER;
  v_vdpvs_rec.date_modified := to_date(P_VPSRC_DATE_MODIFIED);
  v_vdpvs_rec.modified_by   := P_VPSRC_MODIFIED_BY;
  v_vdpvs_rec.vps_idseq     := P_VPSRC_VPS_IDSEQ;

  v_vdpvs_ind.date_modified := TRUE;
  v_vdpvs_ind.modified_by   := TRUE;
  v_vdpvs_ind.VPs_idseq     := TRUE;

  v_vdpvs_ind.created_by    := FALSE;
  v_vdpvs_ind.date_created  := FALSE;

  IF P_VPSRC_VP_IDSEQ IS NULL THEN
    v_vdpvs_ind.vp_idseq := FALSE;
  ELSE
    v_vdpvs_rec.vp_idseq := P_VPSRC_VP_IDSEQ;
    v_vdpvs_ind.vp_idseq := TRUE;
  END IF;

  IF P_VPSRC_SRC_NAME IS NULL THEN
    v_vdpvs_ind.src_name := FALSE;
  ELSE
    v_vdpvs_rec.src_name := P_VPSRC_SRC_NAME;
    v_vdpvs_ind.src_name := TRUE;
  END IF;

  IF P_VPSRC_DATE_SUBMITTED IS NULL THEN
    v_vdpvs_ind.date_submitted := FALSE;
  ELSE
    v_vdpvs_rec.date_submitted  := to_date(P_VPSRC_DATE_SUBMITTED);
    v_vdpvs_ind.date_submitted  := TRUE;
  END IF;

  begin
    cg$vd_pvs_sources_view_ext.upd(v_vdpvs_rec,v_vdpvs_ind);
  exception when others THEN
    P_RETURN_CODE := 'API_VPSRC_501'; --Error updating Source VP_IDSEQ
  end;
END IF;*/

EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_VPSRC;

PROCEDURE SET_QC(
P_UA_NAME       IN  VARCHAR2
,P_RETURN_CODE      OUT    VARCHAR2
,P_ACTION                    IN     VARCHAR2
,P_QC_QC_IDSEQ              IN OUT VARCHAR2
,P_QC_VERSION              IN OUT NUMBER
,P_QC_PREFERRED_NAME      IN OUT VARCHAR2
,P_QC_PREFERRED_DEFINITION   IN OUT VARCHAR2
,P_QC_CONTE_IDSEQ          IN OUT VARCHAR2
,P_QC_ASL_NAME              IN OUT VARCHAR2
,P_QC_QTL_NAME              IN OUT VARCHAR2
,P_QC_LONG_NAME              IN OUT VARCHAR2
,P_QC_LATEST_VERSION_IND     IN OUT VARCHAR2
,P_QC_PROTO_IDSEQ          IN OUT VARCHAR2
,P_QC_DE_IDSEQ               IN OUT VARCHAR2
,P_QC_VP_IDSEQ              IN OUT VARCHAR2
,P_QC_QC_MATCH_IDSEQ        IN OUT VARCHAR2
,P_QC_QCDL_NAME                 IN OUT VARCHAR2
,P_QC_QC_IDENTIFIER          IN OUT VARCHAR2
,P_QC_MATCH_IND              IN OUT VARCHAR2
,P_QC_NEW_QC_IND             IN OUT VARCHAR2
,P_QC_HIGHLIGHT_IND          IN OUT VARCHAR2
,P_QC_CDE_DICTIONARY_ID         IN OUT VARCHAR2
,P_QC_SYSTEM_MSGS          IN OUT VARCHAR2
,P_QC_REVIEWER_FEEDBACK_EXT     IN OUT VARCHAR2
,P_QC_REVIEWER_FEEDBACK_INT     IN OUT VARCHAR2
,P_QC_REVIEWER_FEEDBACK_ACT   IN OUT VARCHAR2
,P_QC_REVIEWED_BY            IN OUT VARCHAR2
,P_QC_REVIEWED_DATE          IN OUT VARCHAR2
,P_QC_APPROVED_BY           IN OUT VARCHAR2
,P_QC_APPROVED_DATE          IN OUT VARCHAR2
,P_QC_BEGIN_DATE             IN OUT VARCHAR2
,P_QC_END_DATE               IN OUT VARCHAR2
,P_QC_CHANGE_NOTE          IN OUT VARCHAR2
,P_QC_SUB_LONG_NAME             IN OUT VARCHAR2
,P_QC_GROUP_COMMENTS            IN OUT VARCHAR2
,P_QC_VD_IDSEQ        IN OUT VARCHAR2
,P_QC_CREATED_BY          OUT    VARCHAR2
,P_QC_DATE_CREATED          OUT    VARCHAR2
,P_QC_MODIFIED_BY          OUT    VARCHAR2
,P_QC_DATE_MODIFIED          OUT    VARCHAR2
,P_QC_DELETED_IND          OUT    VARCHAR2
,P_QC_SRC_NAME      IN     VARCHAR2 DEFAULT NULL
,P_QC_P_MOD_IDSEQ    IN     VARCHAR2 DEFAULT NULL
,P_QC_P_QST_IDSEQ    IN     VARCHAR2 DEFAULT NULL
,P_QC_P_VAL_IDSEQ    IN     VARCHAR2 DEFAULT NULL
,P_QC_DN_CRF_IDSEQ    IN     VARCHAR2 DEFAULT NULL
,P_QC_DISPALY_IND      IN     VARCHAR2 DEFAULT NULL
,P_QC_GROUP_ACTION     IN     VARCHAR2 DEFAULT NULL
,P_QC_DE_LONG_NAME     IN     VARCHAR2 DEFAULT NULL
,P_QC_VD_LONG_NAME     IN     VARCHAR2 DEFAULT NULL
,P_QC_DEC_LONG_NAME      IN     VARCHAR2 DEFAULT NULL
,P_QC_ORIGIN      IN     VARCHAR2 DEFAULT NULL -- 23-Jul-2003, W. Ver Hoef
)  IS

-- Date:  23-Jul-2003
-- Modified By:  W. Ver Hoef
-- Reason:  added parameter and code for origin; added missing assignments for v_qc_rec
--          for DEL action; added extra if smtm with condition P_QC_VERSION is not null
--          around that parameter's validation WRT existing column value when action is
--          UPD
--
-- Date:  19-Mar-2004
-- Modified By:  W. Ver Hoef
-- Reason:  substituted UNASSIGNED with function call to get_default_asl
--

v_version  quest_contents_view_ext.version%TYPE;
v_ac       quest_contents_view_ext.qc_idseq%TYPE;
v_asl_name quest_contents_view_ext.asl_name%TYPE;

v_begin_date    DATE    := NULL;
v_end_date      DATE    := NULL;
v_reviewed_date DATE    := NULL;
v_approved_date DATE    := NULL;
v_new_version   BOOLEAN := FALSE;

v_qc_rec    Cg$quest_Contents_View_Ext.cg$row_type;
v_qc_ind    Cg$quest_Contents_View_Ext.cg$ind_type;

BEGIN

  P_RETURN_CODE := NULL;

  IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
    P_RETURN_CODE := 'API_QC_700'; -- Invalid action
    RETURN;
  END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  IF P_ACTION = 'INS' THEN              --we are inserting a record
    IF P_QC_QC_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_QC_100' ;  --for inserts the ID is generated
   RETURN;
    ELSE
      --Check to see that all mandatory parameters are either not NULL or have a default value.
      IF P_QC_PREFERRED_NAME IS NULL THEN
        P_RETURN_CODE := 'API_QC_101';  --Preferred Name cannot be null here
        RETURN;
      END IF;
      IF P_QC_CONTE_IDSEQ IS NULL THEN
        P_RETURN_CODE := 'API_QC_102'; --CONTE_IDSEQ cannot be null here
        RETURN;
      END IF;
      IF P_QC_PREFERRED_DEFINITION IS NULL THEN
        P_RETURN_CODE := 'API_QC_103'; --Preferred Definition cannot be null here
        RETURN;
      END IF;
      IF P_QC_ASL_NAME IS NULL THEN
     -- 19-Mar-2004, W. Ver Hoef - substituted UNASSIGNED with function call below
        P_QC_ASL_NAME := Sbrext_Common_Routines.get_default_asl('INS'); -- 'UNASSIGNED';
      END IF;
      IF P_QC_VERSION IS NULL THEN
        P_QC_VERSION := Sbrext_Common_Routines.get_ac_version(P_QC_PREFERRED_NAME, P_QC_CONTE_IDSEQ,'QUEST_CONTENT','HIGHEST') + 1;
      END IF;
      IF P_QC_LATEST_VERSION_IND IS NULL THEN
        P_QC_LATEST_VERSION_IND := 'No';
      END IF;
      IF P_QC_QTL_NAME IS NULL THEN
        P_RETURN_CODE := 'API_QC_106'; --Content type has to be given
        RETURN;
      END IF;
/*    IF (P_QC_DE_IDSEQ is null and P_QC_VP_IDSEQ is null and P_QC_QC_MATCH_IDSEQ is null) THEN
      P_RETURN_CODE := 'API_QC_213';  --All three keys cannot be null
      RETURN;
    END IF;*/
      --check the arc
      IF NOT Sbrext_Common_Routines.valid_arc(P_QC_DE_IDSEQ,P_QC_VP_IDSEQ,P_QC_QC_MATCH_IDSEQ) THEN
        P_RETURN_CODE := 'API_QC_212';  --Invalid arc. Only one of the arc keys of the arc can have a value.
        RETURN;
      END IF;
    END IF;
  END IF;

  IF P_ACTION = 'UPD' THEN              --we are updating a record
   admin_security_util.seteffectiveuser(p_ua_name);
    IF P_QC_QC_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_QC_400' ;  --for updates the ID IS mandatory
   RETURN;
    END IF;
    SELECT asl_name
 INTO   v_asl_name
    FROM   quest_contents_view_ext
    WHERE  qc_idseq = p_qc_qc_idseq;
    IF (P_QC_PREFERRED_NAME IS NOT NULL OR P_QC_CONTE_IDSEQ IS NOT NULL) AND v_asl_name = 'RELEASED' THEN
      P_RETURN_CODE := 'API_QC_401' ;  --Preferred Name or Context Can not be updated
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(P_QC_QC_IDSEQ) THEN
      P_RETURN_CODE := 'API_QC_005'; --QC NOT found
      RETURN;
    END IF;
    --check the arc
    IF NOT (P_QC_DE_IDSEQ = ' ' OR P_QC_VP_IDSEQ = ' ' OR P_QC_QC_MATCH_IDSEQ = ' ') THEN
      IF NOT Sbrext_Common_Routines.valid_arc(P_QC_DE_IDSEQ,P_QC_VP_IDSEQ,P_QC_QC_MATCH_IDSEQ) THEN
        P_RETURN_CODE := 'API_QC_212';  --Invalid arc. Only one of the arc keys of the arc can have a value.
        RETURN;
      END IF;
    END IF;
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are logically deleteing a record

    P_QC_DELETED_IND   := 'Yes';
    P_QC_MODIFIED_BY   := P_UA_NAME;  --USER;
    P_QC_DATE_MODIFIED := TO_CHAR(SYSDATE);

 -- 23-Jul-2003, W. Ver Hoef - added missing assignments for v_qc_rec
    v_qc_rec.qc_idseq      := P_QC_QC_IDSEQ;
    v_qc_rec.deleted_ind   := P_QC_DELETED_IND;
    v_qc_rec.modified_by   := P_QC_MODIFIED_BY;
    v_qc_rec.date_modified := TO_DATE(P_QC_DATE_MODIFIED);

    v_qc_ind.qc_idseq                   := TRUE;
    v_qc_ind.preferred_name             := FALSE;
    v_qc_ind.conte_idseq                := FALSE;
    v_qc_ind.version                    := FALSE;
    v_qc_ind.preferred_definition       := FALSE;
    v_qc_ind.long_name                  := FALSE;
    v_qc_ind.qtl_name                   := FALSE;
    v_qc_ind.asl_name                   := FALSE;
    v_qc_ind.proto_idseq                := FALSE;
    v_qc_ind.de_idseq                   := FALSE;
    v_qc_ind.vp_idseq                   := FALSE;
    v_qc_ind.qc_match_idseq             := FALSE;
    v_qc_ind.qcdl_name                  := FALSE;
    v_qc_ind.match_ind                  := FALSE;
    v_qc_ind.qc_identifier              := FALSE;
    v_qc_ind.latest_version_ind         := FALSE;
    v_qc_ind.new_qc_ind                 := FALSE;
    v_qc_ind.reviewer_feedback_action   := FALSE;
    v_qc_ind.system_msgs                := FALSE;
    v_qc_ind.reviewer_feedback_internal := FALSE;
    v_qc_ind.reviewer_feedback_external := FALSE;
    v_qc_ind.reviewed_by                := FALSE;
    v_qc_ind.reviewed_date              := FALSE;
    v_qc_ind.approved_by                := FALSE;
    v_qc_ind.approved_date              := FALSE;
    v_qc_ind.cde_dictionary_id          := FALSE;
    v_qc_ind.submitted_long_cde_name := FALSE;
    v_qc_ind.group_comments             := FALSE;
    v_qc_ind.dn_vd_idseq                := FALSE;
    v_qc_ind.src_name          := FALSE;
    v_qc_ind.p_mod_idseq       := FALSE;
    v_qc_ind.p_qst_idseq       := FALSE;
    v_qc_ind.p_val_idseq       := FALSE;
    v_qc_ind.dn_Crf_idseq      := FALSE;
    v_qc_ind.display_ind       := FALSE;
    v_qc_ind.group_action      := FALSE;
    v_qc_ind.de_long_name      := FALSE;
    v_qc_ind.vd_long_name      := FALSE;
    v_qc_ind.dec_long_name     := FALSE;
    v_qc_ind.begin_date                 := FALSE;
    v_qc_ind.end_date                   := FALSE;
    v_qc_ind.change_note                := FALSE;
    v_qc_ind.created_by                 := FALSE;
    v_qc_ind.date_created               := FALSE;
    v_qc_ind.modified_by                := TRUE;
    v_qc_ind.date_modified              := TRUE;
    v_qc_ind.deleted_ind                := TRUE;
 v_qc_ind.origin                     := FALSE; -- 23-Jul-2003, W. Ver Hoef

    BEGIN
      Cg$quest_Contents_View_Ext.upd(v_qc_rec,v_qc_ind);
      RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_QC_502'; --Error deleting Questionnaire Content
      RETURN;
    END;

  END IF;

  IF P_QC_LATEST_VERSION_IND IS NOT NULL THEN
    IF P_QC_LATEST_VERSION_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_QC_105'; --Version can only be 'Yes' or 'No'
      RETURN;
    END IF;
  END IF;
  IF P_QC_HIGHLIGHT_IND IS NOT NULL THEN
    IF P_QC_HIGHLIGHT_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_QC_107'; --Highligh Indicator can only be 'Yes' or 'No'
      RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and CHAR parameters have correct length
  IF LENGTH(P_QC_PREFERRED_NAME) > Sbrext_Column_Lengths.L_QC_PREFERRED_NAME THEN
    P_RETURN_CODE := 'API_QC_111';  --Length of preferred_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_PREFERRED_DEFINITION) > Sbrext_Column_Lengths.L_QC_PREFERRED_DEFINITION THEN
    P_RETURN_CODE := 'API_QC_112';  --Length of Preferrede Definition exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_QTL_NAME) > Sbrext_Column_Lengths.L_QC_QTL_NAME     THEN
    P_RETURN_CODE := 'API_QC_113'; --Length of QTL_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_QC_IDENTIFIER) > Sbrext_Column_Lengths.L_QC_QC_IDENTIFIER     THEN
    P_RETURN_CODE := 'API_QC_114'; --Length of QC_IDENTIFIER exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_ASL_NAME ) > Sbrext_Column_Lengths.L_QC_ASL_NAME  THEN
    P_RETURN_CODE := 'API_QC_115'; --Length of asl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_CHANGE_NOTE) > Sbrext_Column_Lengths.L_QC_CHANGE_NOTE THEN
    P_RETURN_CODE := 'API_QC_116'; --Length of change_note exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_LONG_NAME) > Sbrext_Column_Lengths.L_QC_LONG_NAME THEN
    P_RETURN_CODE := 'API_QC_117'; --Length of Long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_MATCH_IND) > Sbrext_Column_Lengths.L_QC_QC_MATCH_IND THEN
    P_RETURN_CODE := 'API_QC_118'; --Length of Match IND exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_REVIEWER_FEEDBACK_ACT ) > Sbrext_Column_Lengths.L_QC_REVIEWER_FEEDBACK_ACT  THEN
    P_RETURN_CODE := 'API_QC_119'; --Length of feedback action exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_NEW_QC_IND) > Sbrext_Column_Lengths.L_QC_NEW_QC_IND THEN
    P_RETURN_CODE := 'API_QC_120'; --Length of New QC IND exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_REVIEWER_FEEDBACK_EXT) > Sbrext_Column_Lengths.L_QC_REVIEWER_FEEDBACK_EXT THEN
    P_RETURN_CODE := 'API_QC_122'; --Length of external feedback exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_SYSTEM_MSGS ) > Sbrext_Column_Lengths.L_QC_SYSTEM_MSGS  THEN
    P_RETURN_CODE := 'API_QC_123'; --Length of approved_by exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_REVIEWER_FEEDBACK_INT) > Sbrext_Column_Lengths.L_QC_REVIEWER_FEEDBACK_INT THEN
    P_RETURN_CODE := 'API_QC_124'; --Length of internal feedback exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_REVIEWED_BY ) > Sbrext_Column_Lengths.L_QC_REVIEWED_BY  THEN
    P_RETURN_CODE := 'API_QC_125'; --Length of reviewed_by exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_APPROVED_BY ) > Sbrext_Column_Lengths.L_QC_APPROVED_BY  THEN
    P_RETURN_CODE := 'API_QC_126'; --Length of approved_by exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_SUB_LONG_NAME ) > Sbrext_Column_Lengths.L_QC_SUB_LONG_NAME  THEN
    P_RETURN_CODE := 'API_QC_127'; --Length of submitted long name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_GROUP_COMMENTS ) > Sbrext_Column_Lengths.L_QC_GROUP_COMMENTS  THEN
    P_RETURN_CODE := 'API_QC_128'; --Length of approved_by exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_DE_LONG_NAME ) > Sbrext_Column_Lengths.L_DE_LONG_NAME  THEN
    P_RETURN_CODE := 'API_QC_150'; --Length of de_lonmg_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_DEC_LONG_NAME ) > Sbrext_Column_Lengths.L_DEC_LONG_NAME  THEN
    P_RETURN_CODE := 'API_QC_151'; --Length of dec_long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_QC_VD_LONG_NAME ) > Sbrext_Column_Lengths.L_VD_LONG_NAME  THEN
    P_RETURN_CODE := 'API_QC_152'; --Length of vd_long_name exceeds maximum length
    RETURN;
  END IF;

  --check to see that charachter strings are valid
  IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_QC_PREFERRED_NAME) THEN
    P_RETURN_CODE := 'API_QC_130'; -- Preferred Name has invalid Ccharacters
    RETURN;
  END IF;
/*IF NOT Sbrext_Common_Routines.valid_char(P_QC_PREFERRED_DEFINITION) THEN
  P_RETURN_CODE := 'API_QC_133'; -- Preferred Definition has invalid characters
  RETURN;
END IF;*/
  IF NOT Sbrext_Common_Routines.valid_char(P_QC_LONG_NAME) THEN
    P_RETURN_CODE := 'API_QC_134'; -- Value Domain Long Name has invalid characters
    RETURN;
  END IF;
  IF P_QC_REVIEWER_FEEDBACK_INT IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_QC_REVIEWER_FEEDBACK_INT) THEN
      P_RETURN_CODE := 'API_QC_135'; -- reviewer internal feedback has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_QC_REVIEWER_FEEDBACK_ACT IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_QC_REVIEWER_FEEDBACK_ACT) THEN
      P_RETURN_CODE := 'API_QC_136'; -- Reviewer action has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_QC_REVIEWER_FEEDBACK_EXT IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_QC_REVIEWER_FEEDBACK_EXT) THEN
      P_RETURN_CODE := 'API_QC_137'; -- Reviewer external feedback has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_QC_SUB_LONG_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_QC_SUB_LONG_NAME) THEN
      P_RETURN_CODE := 'API_QC_138'; -- Submitted Long Name has invalid characters
      RETURN;
    END IF;
  END IF;
  IF P_QC_GROUP_COMMENTS IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.valid_char(P_QC_GROUP_COMMENTS) THEN
      P_RETURN_CODE := 'API_QC_139'; -- Group Comments has invalid characters
      RETURN;
    END IF;
  END IF;

  --check to see that Foreign keys already exist in the database
  IF P_QC_CONTE_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.context_exists(P_QC_CONTE_IDSEQ) THEN
      P_RETURN_CODE := 'API_QC_200'; --Context not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_QC_PROTO_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.ac_exists(P_QC_PROTO_IDSEQ)  THEN
      P_RETURN_CODE := 'API_QC_201'; --Protocol not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_QC_ASL_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.workflow_exists(P_QC_ASL_NAME) THEN
      P_RETURN_CODE := 'API_QC_202'; --Workflow Status not found in the database
      RETURN;
    END IF;
  END IF;
  --dbms_output.put_line('P_QC_VP_IDSEQ= '||P_QC_VP_IDSEQ);
  IF (P_QC_VP_IDSEQ IS NOT NULL) THEN
    -- dbms_output.put_line('p_qc_vp_idseq is not null ='||nvl(P_QC_VP_IDSEQ,'null')||
    -- 'length='||length(P_QC_VP_IDSEQ));
    IF (P_QC_VP_IDSEQ <> ' ') THEN
      IF NOT Sbrext_Common_Routines.VD_PVS_EXISTS(P_QC_VP_IDSEQ) THEN
       -- dyu 1/23/2003
        dbms_output.put_line('in api_qc_203:P_QC_VP_IDSEQ= '||P_QC_VP_IDSEQ);
        P_RETURN_CODE := 'API_QC_203'; --VP not found in the database
        RETURN;
      END IF;
    END IF;
  END IF;
  IF P_QC_QTL_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.qtl_exists(P_QC_QTL_NAME) THEN
      P_RETURN_CODE := 'API_QC_204'; --Content Type NOT found in the database
      RETURN;
    END IF;
  END IF;
  IF (P_QC_DE_IDSEQ IS NOT NULL) THEN
    IF P_QC_DE_IDSEQ <> ' ' THEN
      IF NOT Sbrext_Common_Routines.ac_exists(P_QC_DE_IDSEQ) THEN
        P_RETURN_CODE := 'API_QC_205'; --DE not found in the database
        RETURN;
      END IF;
    END IF;
  END IF;
  IF P_QC_QCDL_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.qcdl_exists(P_QC_QCDL_NAME) THEN
      P_RETURN_CODE := 'API_QC_206'; --QCDL not found in the database
      RETURN;
    END IF;
  END IF;
/*IF P_QC_REVIEWER_FEEDBACK_INT IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.rf_exists(P_QC_REVIEWER_FEEDBACK_INT,'INTERNAL COMMENTS') THEN
    P_RETURN_CODE := 'API_QC_207'; --internal comment not found in the database
    RETURN;
  END IF;
END IF;
IF P_QC_REVIEWER_FEEDBACK_EXT IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.rf_exists(P_QC_REVIEWER_FEEDBACK_EXT,'EXTERNAL COMMENTS') THEN
    P_RETURN_CODE := 'API_QC_208'; --external comment not found in the database
    RETURN;
  END IF;
END IF;*/--This has been commented out because these should not be forign keys.
  IF (P_QC_REVIEWER_FEEDBACK_ACT IS NOT NULL) THEN
    IF P_QC_REVIEWER_FEEDBACK_ACT <> ' ' THEN
      IF NOT Sbrext_Common_Routines.rf_exists(P_QC_REVIEWER_FEEDBACK_ACT,'REVIEWER ACTION') THEN
        P_RETURN_CODE := 'API_QC_209'; --reviewer action not found in the database
        RETURN;
      END IF;
    END IF;
  END IF;

  --check to see that begin data and end date are valid dates
  IF(P_QC_BEGIN_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_QC_BEGIN_DATE,v_begin_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_QC_600'; --begin date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_QC_END_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_QC_END_DATE, v_end_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_QC_601'; --end date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_QC_REVIEWED_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_QC_REVIEWED_DATE,v_reviewed_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_QC_602'; --reviewed date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_QC_APPROVED_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE, P_QC_APPROVED_DATE, v_approved_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_QC_603'; --approved date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_QC_BEGIN_DATE IS NOT NULL AND P_QC_END_DATE IS NOT NULL) THEN
    IF(v_end_date < v_begin_date) THEN
      P_RETURN_CODE := 'API_QC_210'; --end date is before begin date
      RETURN;
    END IF;
  ELSIF(P_QC_END_DATE IS NOT NULL AND P_QC_BEGIN_DATE IS NULL) THEN
    P_RETURN_CODE := 'API_QC_211'; --begin date cannot be null when end date is null
    RETURN;
  END IF;

  IF (P_ACTION = 'INS' ) THEN
    --check to see that a QC with the same
    --Preferred Name, Context and Version does not already exist
    IF Sbrext_Common_Routines.ac_exists(P_QC_PREFERRED_NAME,P_QC_CONTE_IDSEQ ,P_QC_VERSION,'QUEST_CONTENT') THEN
     P_RETURN_CODE := 'API_QC_300';-- QC already Exists
     RETURN;
    END IF;
    --Check to see if prior versions alresdy exist
    IF Sbrext_Common_Routines.ac_version_exists(P_QC_PREFERRED_NAME,P_QC_CONTE_IDSEQ ,'QUEST_CONTENT') THEN -- we are creating a new version
      v_new_version := TRUE;
      v_ac          := Sbrext_Common_Routines.get_version_ac(P_QC_PREFERRED_NAME,P_QC_CONTE_IDSEQ,'QUEST_CONTENT');
    END IF;

    P_QC_QC_IDSEQ      := admincomponent_crud.cmr_guid;
    P_QC_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_QC_CREATED_BY    := P_UA_NAME;  --USER;
    P_QC_DATE_MODIFIED := NULL;
    P_QC_MODIFIED_BY   := NULL;
    P_QC_DELETED_IND   := 'No';

    v_qc_rec.qc_idseq           := P_QC_QC_IDSEQ;
    v_qc_rec.preferred_name     := P_QC_PREFERRED_NAME;
    v_qc_rec.conte_idseq     := P_QC_CONTE_IDSEQ;
    v_qc_rec.version      := P_QC_VERSION;
    v_qc_rec.preferred_definition  := P_QC_PREFERRED_DEFINITION;
    v_qc_rec.long_name     := P_QC_LONG_NAME;
    v_qc_rec.qtl_name     := P_QC_QTL_NAME;
    v_qc_rec.asl_name     := P_QC_ASL_NAME;
    v_qc_rec.proto_idseq    := NULL;
    v_qc_rec.de_idseq     := P_QC_DE_IDSEQ;
    v_qc_rec.vp_idseq     := P_QC_VP_IDSEQ;
    v_qc_rec.qc_match_idseq    := P_QC_QC_MATCH_IDSEQ;
    v_qc_rec.qcdl_name     := P_QC_QCDL_NAME;
    v_qc_rec.match_ind     := P_QC_MATCH_IND;
    v_qc_rec.qc_identifier    := P_QC_QC_IDENTIFIER;
    v_qc_rec.latest_version_ind   := P_QC_LATEST_VERSION_IND;
    v_qc_rec.new_qc_ind     := P_QC_NEW_QC_IND;
    v_qc_rec.highlight_ind    := P_QC_HIGHLIGHT_IND;
    v_qc_rec.reviewer_feedback_external := P_QC_REVIEWER_FEEDBACK_EXT;
    v_qc_rec.system_msgs    := P_QC_SYSTEM_MSGS;
    v_qc_rec.reviewer_feedback_action   := P_QC_REVIEWER_FEEDBACK_ACT;
    v_qc_rec.reviewer_feedback_internal := P_QC_REVIEWER_FEEDBACK_INT;
    v_qc_rec.submitted_long_cde_name := P_QC_SUB_LONG_NAME;
    v_qc_rec.group_comments             := P_QC_GROUP_COMMENTS;
    v_qc_rec.dn_vd_idseq             := P_QC_VD_IDSEQ;
    v_qc_rec.src_name          := P_QC_SRC_NAME   ;
    v_qc_rec.p_mod_idseq       := P_QC_P_MOD_IDSEQ ;
    v_qc_rec.p_qst_idseq       := P_QC_P_QST_IDSEQ ;
    v_qc_rec.p_val_idseq       := P_QC_P_VAL_IDSEQ ;
    v_qc_rec.dn_Crf_idseq      := P_QC_DN_CRF_IDSEQ;
    v_qc_rec.display_ind       := P_QC_DISPALY_IND  ;
    v_qc_rec.group_action      := P_QC_GROUP_ACTION  ;
    v_qc_rec.de_long_name      := P_QC_DE_LONG_NAME  ;
    v_qc_rec.vd_long_name      := P_QC_VD_LONG_NAME  ;
    v_qc_rec.dec_long_name     := P_QC_DEC_LONG_NAME ;
    v_qc_rec.reviewed_by    := P_QC_REVIEWED_BY;
    v_qc_rec.reviewed_date    := TO_DATE(P_QC_REVIEWED_DATE);
    v_qc_rec.approved_by    := P_QC_APPROVED_BY;
    v_qc_rec.approved_date    := P_QC_APPROVED_DATE;
    v_qc_rec.cde_dictionary_id   := P_QC_CDE_DICTIONARY_ID;
    v_qc_rec.begin_date     := TO_DATE(P_QC_BEGIN_DATE);
    v_qc_rec.end_date     := TO_DATE(P_QC_END_DATE);
    v_qc_rec.change_note    := P_QC_CHANGE_NOTE;
    v_qc_rec.created_by     := P_QC_CREATED_BY;
    v_qc_rec.date_created    := TO_DATE(P_QC_DATE_cREATED);
    v_qc_rec.modified_by    := NULL;
    v_qc_rec.date_modified    := NULL;
    v_qc_rec.deleted_ind    := 'No';
 v_qc_rec.origin                     := P_QC_ORIGIN;

    v_qc_ind.qc_idseq                   := TRUE;
    v_qc_ind.preferred_name             := TRUE;
    v_qc_ind.conte_idseq                := TRUE;
    v_qc_ind.version                    := TRUE;
    v_qc_ind.preferred_definition       := TRUE;
    v_qc_ind.long_name                  := TRUE;
    v_qc_ind.qtl_name                   := TRUE;
    v_qc_ind.asl_name                   := TRUE;
    v_qc_ind.proto_idseq                := TRUE;
    v_qc_ind.de_idseq                   := TRUE;
    v_qc_ind.vp_idseq                   := TRUE;
    v_qc_ind.qc_match_idseq             := TRUE;
    v_qc_ind.qcdl_name                  := TRUE;
    v_qc_ind.match_ind                  := TRUE;
    v_qc_ind.qc_identifier              := TRUE;
    v_qc_ind.latest_version_ind         := TRUE;
    v_qc_ind.new_qc_ind                 := TRUE;
    v_qc_ind.highlight_ind              := TRUE;
    v_qc_ind.reviewer_feedback_action   := TRUE;
    v_qc_ind.system_msgs                := TRUE;
    v_qc_ind.reviewer_feedback_external := TRUE;
    v_qc_ind.reviewer_feedback_internal := TRUE;
    v_qc_ind.submitted_long_cde_name := TRUE;
    v_qc_ind.group_comments             := TRUE;
    v_qc_ind.dn_vd_idseq                := TRUE;
    v_qc_ind.src_name          := TRUE   ;
    v_qc_ind.p_mod_idseq       := TRUE ;
    v_qc_ind.p_qst_idseq       := TRUE ;
    v_qc_ind.p_val_idseq       := TRUE ;
    v_qc_ind.dn_Crf_idseq      := TRUE;
    v_qc_ind.display_ind       := TRUE;
    v_qc_ind.group_action      := TRUE;
    v_qc_ind.de_long_name      := TRUE;
    v_qc_ind.vd_long_name      := TRUE ;
    v_qc_ind.dec_long_name     := TRUE;
    v_qc_ind.reviewed_by                := TRUE;
    v_qc_ind.reviewed_date              := TRUE;
    v_qc_ind.approved_by                := TRUE;
    v_qc_ind.approved_date              := TRUE;
    v_qc_ind.cde_dictionary_id          := TRUE;
    v_qc_ind.begin_date                 := TRUE;
    v_qc_ind.end_date                   := TRUE;
    v_qc_ind.change_note                := TRUE;
    v_qc_ind.created_by                 := TRUE;
    v_qc_ind.date_created               := TRUE;
    v_qc_ind.modified_by                := TRUE;
    v_qc_ind.date_modified              := TRUE;
    v_qc_ind.deleted_ind                := TRUE;
 v_qc_ind.origin                     := TRUE;

    BEGIN
      --meta_global_pkg.transaction_type := 'VERSION';
      Cg$quest_Contents_View_Ext.ins(v_qc_rec,v_qc_ind);
   sbrext_common_routines.SET_MULTI_PROTO(P_QC_PROTO_IDSEQ,P_QC_QC_IDSEQ);
      meta_global_pkg.transaction_type := NULL;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_QC_500'; --Error inserting QC
    END;
    --If LATEST_VERSION_IND is'Yes' then update so that all other versions have the indicator set to 'No'
    IF(P_QC_LATEST_VERSION_IND = 'Yes') THEN
      Sbrext_Common_Routines.set_ac_lvi(P_RETURN_CODE,P_QC_QC_IDSEQ ,'QUEST_CONTENT');
      IF P_RETURN_CODE IS NOT NULL  THEN
        P_RETURN_CODE := 'API_QC_503'; -- Error updating latest_Value_ind
        RETURN;
      END IF;
    END IF;
    --create a history record with prior version
    IF v_new_version THEN
      BEGIN
        meta_config_mgmt.CREATE_AC_HISTORIES (v_ac,P_QC_QC_IDSEQ,'VERSIONED','QUEST_CONTENT');
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_QC_504'; --Error creating history
      END;
    END IF;

  END IF;

  IF (P_ACTION = 'UPD' ) THEN
    --Get the version for the P_QC_QCIDSEQ

    SELECT version
    INTO   v_version
    FROM   quest_contents_view_ext
    WHERE  qc_idseq = P_QC_QC_IDSEQ;

    IF P_QC_VERSION IS NOT NULL THEN -- 23-Jul-2003, W. Ver Hoef - added condition
   IF v_version <> P_QC_VERSION THEN
        P_RETURN_CODE := 'API_QC_402'; -- Version can NOT be updated. It can only be created
        RETURN;
   END IF;
    END IF;

    P_QC_DATE_MODIFIED := TO_CHAR(SYSDATE);
    P_QC_MODIFIED_BY := P_UA_NAME;  --USER;
    P_QC_DELETED_IND := 'No';

    v_qc_rec.date_modified := P_QC_DATE_MODIFIED;
    v_qc_rec.modified_by   := P_QC_MODIFIED_BY;
    v_qc_rec.qc_idseq      := P_QC_QC_IDSEQ;
    v_qc_rec.deleted_ind   := 'No';

    v_qc_ind.date_modified := TRUE;
    v_qc_ind.modified_by   := TRUE;
    v_qc_ind.deleted_ind   := TRUE;
    v_qc_ind.qc_idseq      := TRUE;

    v_qc_ind.version       := FALSE;
    v_qc_ind.created_by    := FALSE;
    v_qc_ind.date_created  := FALSE;

    IF P_QC_PREFERRED_NAME IS NULL THEN
      v_qc_ind.preferred_name := FALSE;
    ELSE
      v_qc_rec.preferred_name := P_QC_PREFERRED_NAME;
      v_qc_ind.preferred_name := TRUE;
    END IF;

    IF P_QC_CONTE_IDSEQ IS NULL THEN
      v_qc_ind.conte_idseq := FALSE;
    ELSE
      v_qc_rec.conte_idseq := P_QC_CONTE_IDSEQ;
      v_qc_ind.conte_idseq := TRUE;
    END IF;

    IF P_QC_PREFERRED_DEFINITION IS NULL THEN
      v_qc_ind.preferred_definition:= FALSE;
    ELSE
      v_qc_rec.preferred_definition := P_QC_PREFERRED_DEFINITION;
      v_qc_ind.preferred_definition := TRUE;
    END IF;

    IF P_QC_LONG_NAME IS NULL THEN
      v_qc_ind.long_name := FALSE;
    ELSE
      v_qc_rec.long_name := P_QC_LONG_NAME;
      v_qc_ind.long_name := TRUE;
    END IF;

    IF P_QC_ASL_NAME IS NULL THEN
      v_qc_ind.asl_name := FALSE;
    ELSE
      v_qc_rec.asl_name := P_QC_ASL_NAME;
      v_qc_ind.asl_name := TRUE;
    END IF;

    IF P_QC_PROTO_IDSEQ IS NULL THEN
      v_qc_ind.proto_idseq := FALSE;
    ELSE
      v_qc_rec.proto_idseq := P_QC_PROTO_IDSEQ;
      v_qc_ind.proto_idseq := TRUE;
    END IF;

    IF P_QC_LATEST_VERSION_IND IS NULL THEN
      v_qc_ind.latest_version_ind := FALSE;
    ELSE
      v_qc_rec.latest_version_ind := P_QC_LATEST_VERSION_IND;
      v_qc_ind.latest_version_ind := TRUE;
    END IF;

    IF P_QC_MATCH_IND IS NULL THEN
      v_qc_ind.match_ind := FALSE;
    ELSE
      v_qc_rec.match_ind:= P_QC_MATCH_IND;
      IF v_qc_rec.match_ind = ' ' THEN
        v_qc_rec.match_ind := NULL;
      END IF;
      v_qc_ind.match_ind := TRUE;
    END IF;

    IF P_QC_QCDL_NAME IS NULL THEN
      v_qc_ind.qcdl_name := FALSE;
    ELSE
      v_qc_rec.qcdl_name := P_QC_QCDL_NAME;
      v_qc_ind.qcdl_name := TRUE;
    END IF;

    IF P_QC_QTL_NAME IS NULL THEN
      v_qc_ind.qtl_name := FALSE;
    ELSE
      v_qc_rec.qtl_name := P_QC_QTL_NAME;
      v_qc_ind.qtl_name := TRUE;
    END IF;

    IF P_QC_APPROVED_BY IS NULL THEN
      v_qc_ind.approved_by:= FALSE;
    ELSE
      v_qc_rec.approved_by := P_QC_APPROVED_BY;
      v_qc_ind.approved_by:= TRUE;
    END IF;

    IF P_QC_REVIEWED_BY IS NULL THEN
      v_qc_ind.reviewed_by:= FALSE;
    ELSE
      v_qc_rec.reviewed_by := P_QC_REVIEWED_BY ;
      v_qc_ind.reviewed_by:= TRUE;
    END IF;

    IF P_QC_VP_IDSEQ IS NULL THEN
      v_qc_ind.vp_idseq := FALSE;
    ELSE
      v_qc_rec.vp_idseq := P_QC_VP_IDSEQ;
      IF v_qc_rec.vp_idseq = ' ' THEN
       v_qc_rec.vp_idseq := NULL;
      END IF;
      v_qc_ind.vp_idseq := TRUE;
    END IF;

    IF P_QC_QC_MATCH_IDSEQ IS NULL THEN
      v_qc_ind.qc_match_idseq := FALSE;
    ELSE
      v_qc_rec.qc_match_idseq := P_QC_QC_MATCH_IDSEQ;
      IF v_qc_rec.qc_match_idseq = ' ' THEN
     v_qc_rec.qc_match_idseq := NULL;
      END IF;
      v_qc_ind.qc_match_idseq := TRUE;
    END IF;

    IF P_QC_QC_IDENTIFIER IS NULL THEN
      v_qc_ind.qc_identifier := FALSE;
    ELSE
      v_qc_rec.qc_identifier := P_QC_QC_IDENTIFIER;
      v_qc_ind.qc_identifier := TRUE;
    END IF;

    IF P_QC_REVIEWER_FEEDBACK_INT  IS NULL THEN
      v_qc_ind.reviewer_feedback_internal:= FALSE;
    ELSE
      v_qc_rec.reviewer_feedback_internal:= P_QC_REVIEWER_FEEDBACK_INT  ;
      v_qc_ind.reviewer_feedback_internal:= TRUE;
    END IF;

    IF P_QC_SUB_LONG_NAME IS NULL THEN
      v_qc_ind.submitted_long_cde_name := FALSE;
    ELSE
      v_qc_rec.submitted_long_cde_name := P_QC_SUB_LONG_NAME;
      v_qc_ind.submitted_long_cde_name := TRUE;
    END IF;

    IF P_QC_GROUP_COMMENTS  IS NULL THEN
      v_qc_ind.group_comments:= FALSE;
    ELSE
      v_qc_rec.group_comments:= P_QC_GROUP_COMMENTS  ;
      v_qc_ind.group_comments:= TRUE;
    END IF;

    IF P_QC_VD_IDSEQ IS NULL THEN
      v_qc_ind.dn_vd_idseq := FALSE;
    ELSE
      v_qc_rec.dn_vd_idseq := P_QC_VD_IDSEQ;
      IF v_qc_rec.dn_vd_idseq = ' ' THEN
        v_qc_rec.dn_vd_idseq := NULL;
      END IF;
      v_qc_ind.dn_vd_idseq := TRUE;
    END IF;

    IF P_QC_DE_IDSEQ IS NULL THEN
      v_qc_ind.de_idseq := FALSE;
    ELSE
      v_qc_rec.de_idseq := P_QC_DE_IDSEQ;
      IF v_qc_rec.de_idseq = ' ' THEN
        v_qc_rec.de_idseq := NULL;
      END IF;
      v_qc_ind.de_idseq := TRUE;
    END IF;

    IF P_QC_NEW_QC_IND IS NULL THEN
      v_qc_ind.new_qc_ind := FALSE;
    ELSE
      v_qc_rec.new_qc_ind := P_QC_NEW_QC_IND  ;
      IF v_qc_rec.new_qc_ind = ' ' THEN
        v_qc_rec.new_qc_ind := NULL;
      END IF;
      v_qc_ind.new_qc_ind := TRUE;
    END IF;

    IF P_QC_HIGHLIGHT_IND IS NULL THEN
      v_qc_ind.highlight_ind := FALSE;
    ELSE
      v_qc_rec.highlight_ind := P_QC_HIGHLIGHT_IND  ;
      v_qc_ind.highlight_ind := TRUE;
      dbms_output.put_line('highlight_ind= '||v_qc_rec.highlight_ind);
    END IF;

    IF P_QC_SYSTEM_MSGS IS NULL THEN
      v_qc_ind.system_msgs := FALSE;
    ELSE
      v_qc_rec.system_msgs := P_QC_SYSTEM_MSGS;
      v_qc_ind.system_msgs := TRUE;
    END IF;

    IF P_QC_REVIEWER_FEEDBACK_ACT  IS NULL THEN
      v_qc_ind.reviewer_feedback_action:= FALSE;
    ELSE
      v_qc_rec.reviewer_feedback_action:=  P_QC_REVIEWER_FEEDBACK_ACT  ;
      IF v_qc_rec.reviewer_feedback_action = ' ' THEN
        v_qc_rec.reviewer_feedback_action := NULL;
      END IF;
      v_qc_ind.reviewer_feedback_action:= TRUE;
    END IF;

    IF P_QC_CDE_DICTIONARY_ID IS NULL THEN
      v_qc_ind.cde_dictionary_id:= FALSE;
    ELSE
      v_qc_rec.cde_dictionary_id:= P_QC_DE_IDSEQ;
      v_qc_ind.cde_dictionary_id:= TRUE;
    END IF;

    IF P_QC_REVIEWER_FEEDBACK_EXT IS NULL THEN
      v_qc_ind.reviewer_feedback_external := FALSE;
    ELSE
      v_qc_rec.reviewer_feedback_external := P_QC_REVIEWER_FEEDBACK_EXT;
      v_qc_ind.reviewer_feedback_external := TRUE;
    END IF;

    IF P_QC_SRC_NAME  IS NULL THEN
      v_qc_ind.src_name      := FALSE;
    ELSE
      v_qc_rec.src_name := P_QC_SRC_NAME  ;
      v_qc_ind.src_name := TRUE;
    END IF;

    IF P_QC_P_MOD_IDSEQ IS NULL THEN
      v_qc_ind.p_mod_idseq   := FALSE;
    ELSE
      v_qc_rec.p_mod_idseq   := P_QC_P_MOD_IDSEQ ;
      v_qc_ind.p_mod_idseq    := TRUE;
    END IF;

    IF  P_QC_P_QST_IDSEQ IS NULL THEN
      v_qc_ind.p_qst_idseq:= FALSE;
    ELSE
      v_qc_rec.p_qst_idseq   := P_QC_P_QST_IDSEQ ;
      v_qc_ind.p_qst_idseq := TRUE;
    END IF;

    IF P_QC_P_VAL_IDSEQ IS NULL THEN
      v_qc_ind.p_val_idseq   := FALSE;
    ELSE
       v_qc_rec.p_val_idseq   := P_QC_P_VAL_IDSEQ ;      v_qc_ind.p_val_idseq    := TRUE;
    END IF;

    IF P_QC_DN_CRF_IDSEQ IS NULL THEN
      v_qc_ind.dn_Crf_idseq  := FALSE;
    ELSE
      v_qc_rec.dn_Crf_idseq  := P_QC_DN_CRF_IDSEQ;
      v_qc_ind.dn_Crf_idseq   := TRUE;
    END IF;

    IF P_QC_DISPALY_IND  IS NULL THEN
      v_qc_ind.display_ind   := FALSE;
    ELSE
      v_qc_rec.display_ind   := P_QC_DISPALY_IND  ;
      v_qc_ind.display_ind    := TRUE;
    END IF;

    IF P_QC_GROUP_ACTION  IS NULL THEN
      v_qc_ind.group_action  := FALSE;
    ELSE
      v_qc_rec.group_action  := P_QC_GROUP_ACTION  ;
      v_qc_ind.group_action   := TRUE;
    END IF;

    IF P_QC_DE_LONG_NAME IS NULL THEN
      v_qc_ind.de_long_name  := FALSE;
    ELSE
      v_qc_rec.de_long_name  := P_QC_DE_LONG_NAME  ;
      v_qc_ind.de_long_name   := TRUE;
    END IF;

    IF P_QC_VD_LONG_NAME IS NULL THEN
      v_qc_ind.vd_long_name  := FALSE;
    ELSE
      v_qc_rec.vd_long_name  := P_QC_VD_LONG_NAME  ;
      v_qc_ind.vd_long_name   := TRUE;
    END IF;

    IF P_QC_DEC_LONG_NAME  IS NULL THEN
      v_qc_ind.dec_long_name  := FALSE;
    ELSE
      v_qc_rec.dec_long_name  := P_QC_DEC_LONG_NAME  ;
      v_qc_ind.dec_long_name   := TRUE;
    END IF;

    IF P_QC_BEGIN_DATE IS NULL THEN
      v_qc_ind.begin_date := FALSE;
    ELSE
      v_qc_rec.begin_date := TO_DATE(P_QC_BEGIN_DATE);
      v_qc_ind.begin_date := TRUE;
    END IF;

    IF P_QC_END_DATE  IS NULL THEN
      v_qc_ind.end_date := FALSE;
    ELSE
      v_qc_rec.end_date := TO_DATE(P_QC_END_DATE);
      v_qc_ind.end_date := TRUE;
    END IF;

    IF P_QC_REVIEWED_DATE IS NULL THEN
      v_qc_ind.reviewed_date := FALSE;
    ELSE
      v_qc_rec.reviewed_date := TO_DATE(P_QC_REVIEWED_DATE);
      v_qc_ind.reviewed_date := TRUE;
    END IF;

    IF P_QC_APPROVED_DATE  IS NULL THEN
      v_qc_ind.approved_date := FALSE;
    ELSE
      v_qc_rec.approved_date := TO_DATE(P_QC_APPROVED_DATE);
      v_qc_ind.approved_date := TRUE;
    END IF;

    IF P_QC_CHANGE_NOTE   IS NULL THEN
      v_qc_ind.change_note := FALSE;
    ELSE
      v_qc_rec.change_note := P_QC_CHANGE_NOTE  ;
      v_qc_ind.change_note := TRUE;
    END IF;

    IF P_QC_ORIGIN   IS NULL THEN
      v_qc_ind.origin := FALSE;
    ELSE
      v_qc_rec.origin := P_QC_ORIGIN  ;
      v_qc_ind.origin := TRUE;
    END IF;

    BEGIN
      Cg$quest_Contents_View_Ext.upd(v_qc_rec,v_qc_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_QC_501'; --Error updating QC
    END;

    --If LATEST_VERSION_IND is'Yes' then update so that all other versions have the indicator set to 'No'
    IF(P_QC_LATEST_VERSION_IND = 'Yes') THEN
      Sbrext_Common_Routines.set_ac_lvi(P_RETURN_CODE,P_QC_QC_IDSEQ,'QUEST_CONTENT');
      IF P_RETURN_CODE IS NOT NULL  THEN
        P_RETURN_CODE := 'API_QC_503'; -- Error updating latest_Value_ind
        RETURN;
      END IF;
    END IF;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    P_RETURN_CODE := 'API_QC_800';
  WHEN OTHERS THEN
    P_RETURN_CODE := 'OTHERS';
    dbms_output.put_line(SQLERRM);
END SET_QC;



PROCEDURE SET_REL(
P_UA_NAME       IN  VARCHAR2
,P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_REL_TABLE             IN VARCHAR2
,P_REL_REL_IDSEQ   IN OUT VARCHAR2
,P_REL_P_IDSEQ             IN OUT VARCHAR2
,P_REL_C_IDSEQ             IN OUT VARCHAR2
,P_REL_RL_NAME       IN OUT VARCHAR2
,P_REL_DISPLAY_ORDER     IN  OUT NUMBER
,P_REL_CREATED_BY         OUT VARCHAR2
,P_REL_DATE_CREATED         OUT VARCHAR2
,P_REL_MODIFIED_BY         OUT VARCHAR2
,P_REL_DATE_MODIFIED     OUT VARCHAR2) IS

v_rel_de_rec      cg$de_recs_view.cg$row_type;
v_rel_dec_rec      cg$dec_recs_view.cg$row_type;
v_rel_vd_rec     cg$vd_recs_view.cg$row_type;
v_rel_cs_rec     cg$cs_recs_view.cg$row_type;
v_rel_csi_rec    cg$csi_recs_view.cg$row_type;
v_rel_qce_rec    Cg$qc_Recs_View_Ext.cg$row_type;
v_rel_de_ind     cg$de_recs_view.cg$ind_type;
v_rel_dec_ind    cg$dec_recs_view.cg$ind_type;
v_rel_vd_ind     cg$vd_recs_view.cg$ind_type;
v_rel_cs_ind     cg$cs_recs_view.cg$ind_type;
v_rel_csi_ind    cg$csi_recs_view.cg$ind_type;
v_rel_qce_ind    Cg$qc_Recs_View_Ext.cg$ind_type;
v_rel_de_pk      cg$de_recs_view.cg$pk_type;
v_rel_dec_pk    cg$dec_recs_view.cg$pk_type;
v_rel_vd_pk     cg$vd_recs_view.cg$pk_type;
v_rel_cs_pk     cg$cs_recs_view.cg$pk_type;
v_rel_csi_pk    cg$csi_recs_view.cg$pk_type;
v_rel_qce_pk    Cg$qc_Recs_View_Ext.cg$pk_type;
BEGIN
 p_return_code := NULL;

 --Table name must be given
 IF P_REL_TABLE IS NULL THEN
    p_return_code := 'API_REL_007'; --table name must be passed
    RETURN;
  END IF;

--dbms_output.put_line('P_REL_TABLE_007= ' ||P_REL_TABLE);
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;


 --Table name must be valid
 IF P_REL_TABLE NOT IN ('DE_RECS', 'DEC_RECS', 'VD_RECS', 'CS_RECS', 'CSI_RECS', 'QC_RECS_EXT') THEN
    p_return_code := 'API_REL_001'; --table name must be valid
    RETURN;
 END IF;

--dbms_output.put_line('P_REL_TABLE_001= ' ||P_REL_TABLE);

-- action code must be valid
IF P_ACTION NOT IN ('INS','DEL','UPD') OR (P_ACTION = 'UPD' AND P_REL_TABLE<>'QC_RECS_EXT')  THEN
 P_RETURN_CODE := 'API_REL_700'; -- Invalid action
 RETURN;
END IF;

--dbms_output.put_line('P_ACTION_700= ' ||P_ACTION);


--IF Action = 'INS' then make sure that the mandatory columns are all there
IF (P_ACTION = 'INS') THEN
   IF P_REL_REL_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_REL_100';  --for inserts the ID is generated
  RETURN;

--dbms_output.put_line('P_REL_REL_IDSEQ_100= ' ||P_REL_REL_IDSEQ);

   ELSE


       IF (P_REL_P_IDSEQ IS NULL) THEN
         p_return_code  := 'API_REL_101'; --parent is mandatory
         RETURN;
      END IF;

--dbms_output.put_line('P_REL_P_IDSEQ_101= ' ||P_REL_P_IDSEQ);

      IF (P_REL_C_IDSEQ IS NULL) THEN
         p_return_code  := 'API_REL_102'; --child is mandatory
         RETURN;
   END IF;

--dbms_output.put_line('P_REL_C_IDSEQ_102= ' ||P_REL_C_IDSEQ);

      IF (P_REL_RL_NAME IS NULL) THEN
         p_return_code  := 'API_REL_103'; --relationship name is mandatory
         RETURN;
      END IF;

--dbms_output.put_line('P_REL_RL_NAME_103= ' ||P_REL_RL_NAME);


      IF(P_REL_TABLE = 'QC_RECS_EXT' AND P_REL_DISPLAY_ORDER IS NULL) THEN
         p_return_code  := 'API_REL_QCE_104'; --dispaly order is mandatory
         RETURN;
      END IF;

--dbms_output.put_line('P_REL_TABLE_104= ' ||P_REL_TABLE);

  END IF;
END IF;

IF P_ACTION = 'DEL' THEN              --we are deleting a record
  IF P_REL_REL_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_REL_400' ;  --for deleted the ID is mandatory
  RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.rel_exists(P_REL_TABLE,P_REL_REL_IDSEQ) THEN
      P_RETURN_CODE :=  'API_REL_005'; --Relationship not found
      RETURN;
  END IF;
--Delete the record based on the table
  IF P_REL_TABLE = 'DE_RECS' THEN

    v_rel_de_pk.de_rec_idseq := P_REL_REL_IDSEQ;

    SELECT ROWID INTO v_rel_de_pk.the_rowid
    FROM de_recs_view
    WHERE de_rec_idseq = P_REL_REL_IDSEQ;
    v_rel_de_pk.jn_notes := NULL;

    BEGIN
      cg$de_recs_view.del(v_rel_de_pk);
      RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_REL_DE_501'; --Error deleteing  DE Relationship
      RETURN;
    END;
  ELSIF P_REL_TABLE = 'DEC_RECS' THEN
    v_rel_dec_pk.dec_rec_idseq := P_REL_REL_IDSEQ;

    SELECT ROWID INTO v_rel_dec_pk.the_rowid
    FROM dec_recs_view
    WHERE dec_rec_idseq = P_REL_REL_IDSEQ;
    v_rel_dec_pk.jn_notes := NULL;

    BEGIN
      cg$dec_recs_view.del(v_rel_dec_pk);
      RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_REL_DEC_501'; --Error deleteing DEC Relationship
      RETURN;
    END;

  ELSIF P_REL_TABLE = 'VD_RECS' THEN
    v_rel_vd_pk.vd_rec_idseq := P_REL_REL_IDSEQ;

    SELECT ROWID INTO v_rel_vd_pk.the_rowid
    FROM vd_recs_view
    WHERE vd_rec_idseq = P_REL_REL_IDSEQ;
    v_rel_vd_pk.jn_notes := NULL;

    BEGIN
      cg$vd_recs_view.del(v_rel_vd_pk);
      RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_REL_VD_501'; --Error deleteing VD Relationship
      RETURN;
    END;

  ELSIF P_REL_TABLE = 'CS_RECS' THEN
    v_rel_cs_pk.cs_rec_idseq := P_REL_REL_IDSEQ;

    SELECT ROWID INTO v_rel_cs_pk.the_rowid
    FROM cs_recs_view
    WHERE cs_rec_idseq = P_REL_REL_IDSEQ;
    v_rel_cs_pk.jn_notes := NULL;

    BEGIN
      cg$cs_recs_view.del(v_rel_cs_pk);
      RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_REL_CS_501'; --Error deleteing CS Relationship
      RETURN;
    END;

  ELSIF P_REL_TABLE = 'CSI_RECS' THEN
     v_rel_csi_pk.csi_rec_idseq := P_REL_REL_IDSEQ;

    SELECT ROWID INTO v_rel_csi_pk.the_rowid
    FROM csi_recs_view
    WHERE csi_rec_idseq = P_REL_REL_IDSEQ;
    v_rel_csi_pk.jn_notes := NULL;

    BEGIN
      cg$csi_recs_view.del(v_rel_csi_pk);
      RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_REL_CSI_501'; --Error deleteing CSI Relationship
      RETURN;
    END;

  ELSIF P_REL_TABLE = 'QC_RECS_EXT' THEN
     v_rel_qce_pk.qr_idseq := P_REL_REL_IDSEQ;

    SELECT ROWID INTO v_rel_qce_pk.the_rowid
    FROM qc_recs_view_ext
    WHERE qr_idseq = P_REL_REL_IDSEQ;
    v_rel_qce_pk.jn_notes := NULL;

    BEGIN
      Cg$qc_Recs_View_Ext.del(v_rel_qce_pk);
      RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_REL_QCE_501'; --Error deleteing QCE Relationship
      RETURN;
    END;

  END IF;
END IF;

IF P_ACTION = 'UPD' then
  admin_security_util.seteffectiveuser(p_ua_name);
END IF;
IF P_ACTION = 'UPD' AND P_REL_TABLE = 'QC_RECS_EXT' THEN              --we are updating a record
  IF P_REL_REL_IDSEQ IS  NULL THEN
    P_RETURN_CODE := 'API_REL_400' ;  --for deletingthe ID is mandatory
 RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.rel_exists(P_REL_TABLE,P_REL_REL_IDSEQ) THEN --if relationship does not exist then
    P_RETURN_CODE :=  'API_REL_005'; --REL  NOT found
    RETURN;
  END IF;
  IF P_REL_P_IDSEQ IS NOT NULL OR P_REL_C_IDSEQ IS NOT NULL THEN
    P_RETURN_CODE := 'API_REL_QCE_100';--The parent and the child can not be updated
    RETURN;
  END IF;
  IF P_REL_DISPLAY_ORDER IS NULL THEN
    P_RETURN_CODE := 'API_REL_QCE_101';--Only display order can be updated and so it must be passed
    RETURN;
  END IF;
  P_REL_DATE_MODIFIED := TO_CHAR(SYSDATE);
  P_REL_MODIFIED_BY := P_UA_NAME;  --USER;

  v_rel_qce_rec.date_modified := P_REL_DATE_MODIFIED;
  v_rel_qce_rec.modified_by   := P_REL_MODIFIED_BY;
  v_rel_qce_rec.qr_idseq      := P_REL_REL_IDSEQ;
  v_rel_qce_rec.display_order := P_REL_DISPLAY_ORDER;

  v_rel_qce_ind.date_modified := TRUE;
  v_rel_qce_ind.modified_by   := TRUE;
  v_rel_qce_ind.qr_idseq      := TRUE;
  v_rel_qce_ind.created_by   := FALSE;
  v_rel_qce_ind.date_created  := FALSE;
  v_rel_qce_ind.p_qc_idseq   := FALSE;
  v_rel_qce_ind.c_qc_idseq    := FALSE;
  v_rel_qce_ind.display_order := TRUE;
  BEGIN
    Cg$qc_Recs_View_Ext.upd(v_rel_qce_rec,v_rel_qce_ind);
 RETURN;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_REL_501'; --Error updating QCE Relationships
  END;
END IF;

--make sure that the length of the varchar field are right
IF LENGTH(P_REL_RL_NAME) > Sbrext_Column_Lengths.L_REL_RL_NAME  THEN
  P_RETURN_CODE := 'API_REL_110'; --Length of relationship name exceeds maximum length
  RETURN;
END IF;

 --Make sure that all the foreign keys exist
IF P_REL_TABLE  IN ('DE_RECS', 'DEC_RECS', 'VD_RECS', 'CS_RECS','QC_RECS_EXT') THEN
  IF NOT Sbrext_Common_Routines.valid_ac(P_REL_TABLE,P_REL_P_IDSEQ) THEN
    P_RETURN_CODE := 'API_REL_200'; -- parent does not exist;
    RETURN; --parent is invalie
  END IF;
  IF NOT Sbrext_Common_Routines.valid_ac(P_REL_TABLE,P_REL_C_IDSEQ) THEN
    P_RETURN_CODE := 'API_REL_201'; -- child does not exist;
    RETURN;
  END IF;
ELSIF P_REL_TABLE  = 'CSI_RECS' THEN
 IF NOT Sbrext_Common_Routines.csi_exists(P_REL_P_IDSEQ) THEN
   P_RETURN_CODE := 'API_REL_200'; -- parent does not exist;
   RETURN;
 END IF;
 IF NOT Sbrext_Common_Routines.csi_exists(P_REL_C_IDSEQ) THEN
   P_RETURN_CODE := 'API_REL_201'; -- child does not exist;
   RETURN;
 END IF;
END IF;

IF NOT Sbrext_Common_Routines.rl_exists(P_REL_RL_NAME) THEN
  P_RETURN_CODE := 'API_REL_202'; --relationship type does not exist
  RETURN;
END IF;


--insert or update records
IF P_ACTION = 'INS'  THEN
  --make sure that a relationship between the parent and child does not already exist\
  IF P_REL_TABLE IN ('DE_RECS','DEC_RECS','VD_RECS') THEN
    IF Sbrext_Common_Routines.rel_exists(P_REL_TABLE,P_REL_P_IDSEQ, P_REL_C_IDSEQ) THEN
     P_RETURN_CODE := 'API_REL_300';-- Relationship already Exists
     RETURN;
    END IF;
  END IF;
   P_REL_REL_IDSEQ := admincomponent_crud.cmr_guid;
   P_REL_DATE_CREATED := TO_CHAR(SYSDATE);
   P_REL_CREATED_BY := P_UA_NAME;  --USER;
   P_REL_DATE_MODIFIED := NULL;
   P_REL_MODIFIED_BY := NULL;

   IF P_REL_TABLE = 'DE_RECS' THEN
     v_rel_de_rec.de_rec_idseq     := P_REL_REL_IDSEQ;
     v_rel_de_rec.p_de_idseq     := P_REL_P_IDSEQ;
     v_rel_de_rec.c_de_idseq     := P_REL_C_IDSEQ;
     v_rel_de_rec.rl_name         := P_REL_RL_NAME;
     v_rel_de_rec.created_by     := P_REL_CREATED_BY;
     v_rel_de_rec.date_created     := TO_DATE(P_REL_DATE_CREATED);
     v_rel_de_rec.modified_by     := P_REL_MODIFIED_BY;
     v_rel_de_rec.date_modified     := TO_DATE(P_REL_DATE_MODIFIED);

     v_rel_de_ind.de_rec_idseq     := TRUE;
     v_rel_de_ind.p_de_idseq     := TRUE;
     v_rel_de_ind.c_de_idseq     := TRUE;
     v_rel_de_ind.rl_name         := TRUE;
     v_rel_de_ind.created_by     := TRUE;
     v_rel_de_ind.date_created     := TRUE;
     v_rel_de_ind.modified_by     := TRUE;
     v_rel_de_ind.date_modified     := TRUE;

     BEGIN
       cg$de_recs_view.ins(v_rel_de_rec,v_rel_de_ind);
     EXCEPTION WHEN OTHERS THEN
         P_RETURN_CODE := 'API_REL_DE_500'; --Error inserting Relationship
     END;

   ELSIF P_REL_TABLE = 'DEC_RECS' THEN
     v_rel_dec_rec.dec_rec_idseq := P_REL_REL_IDSEQ;
     v_rel_dec_rec.p_dec_idseq     := P_REL_P_IDSEQ;
     v_rel_dec_rec.c_dec_idseq     := P_REL_C_IDSEQ;
     v_rel_dec_rec.rl_name         := P_REL_RL_NAME;
     v_rel_dec_rec.created_by     := P_REL_CREATED_BY;
     v_rel_dec_rec.date_created     := TO_DATE(P_REL_DATE_CREATED);
     v_rel_dec_rec.modified_by     := P_REL_MODIFIED_BY;
     v_rel_dec_rec.date_modified := TO_DATE(P_REL_DATE_MODIFIED);

     v_rel_dec_ind.dec_rec_idseq := TRUE;
     v_rel_dec_ind.p_dec_idseq     := TRUE;
     v_rel_dec_ind.c_dec_idseq     := TRUE;
     v_rel_dec_ind.rl_name         := TRUE;
     v_rel_dec_ind.created_by     := TRUE;
     v_rel_dec_ind.date_created     := TRUE;
     v_rel_dec_ind.modified_by     := TRUE;
     v_rel_dec_ind.date_modified := TRUE;

     BEGIN
       cg$dec_recs_view.ins(v_rel_dec_rec,v_rel_dec_ind);
     EXCEPTION WHEN OTHERS THEN
       P_RETURN_CODE := 'API_REL_DEC_500'; --Error inserting Relationship
     END;
    ELSIF P_REL_TABLE = 'VD_RECS' THEN
      v_rel_vd_rec.vd_rec_idseq     := P_REL_REL_IDSEQ;
      v_rel_vd_rec.p_vd_idseq     := P_REL_P_IDSEQ;
      v_rel_vd_rec.c_vd_idseq     := P_REL_C_IDSEQ;
      v_rel_vd_rec.rl_name         := P_REL_RL_NAME;
      v_rel_vd_rec.created_by     := P_REL_CREATED_BY;
      v_rel_vd_rec.date_created     := TO_DATE(P_REL_DATE_CREATED);
      v_rel_vd_rec.modified_by     := P_REL_MODIFIED_BY;
      v_rel_vd_rec.date_modified := TO_DATE(P_REL_DATE_MODIFIED);

      v_rel_vd_ind.vd_rec_idseq     := TRUE;
      v_rel_vd_ind.p_vd_idseq     := TRUE;
      v_rel_vd_ind.c_vd_idseq     := TRUE;
      v_rel_vd_ind.rl_name         := TRUE;
      v_rel_vd_ind.created_by     := TRUE;
      v_rel_vd_ind.date_created     := TRUE;
      v_rel_vd_ind.modified_by     := TRUE;
      v_rel_vd_ind.date_modified := TRUE;

      BEGIN
        cg$vd_recs_view.ins(v_rel_vd_rec,v_rel_vd_ind);
      EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_REL_VD_500'; --Error inserting Relationship
     END;
   ELSIF P_REL_TABLE = 'CS_RECS' THEN
    v_rel_cs_rec.cs_rec_idseq     := P_REL_REL_IDSEQ;
     v_rel_cs_rec.p_cs_idseq     := P_REL_P_IDSEQ;
     v_rel_cs_rec.c_cs_idseq     := P_REL_C_IDSEQ;
     v_rel_cs_rec.rl_name         := P_REL_RL_NAME;
     v_rel_cs_rec.created_by     := P_REL_CREATED_BY;
     v_rel_cs_rec.date_created     := TO_DATE(P_REL_DATE_CREATED);
     v_rel_cs_rec.modified_by     := P_REL_MODIFIED_BY;
     v_rel_cs_rec.date_modified     := TO_DATE(P_REL_DATE_MODIFIED);

     v_rel_cs_ind.cs_rec_idseq     := TRUE;
     v_rel_cs_ind.p_cs_idseq     := TRUE;
     v_rel_cs_ind.c_cs_idseq     := TRUE;
     v_rel_cs_ind.rl_name         := TRUE;
     v_rel_cs_ind.created_by     := TRUE;
     v_rel_cs_ind.date_created     := TRUE;
     v_rel_cs_ind.modified_by     := TRUE;
     v_rel_cs_ind.date_modified     := TRUE;

     BEGIN
       cg$cs_recs_view.ins(v_rel_cs_rec,v_rel_cs_ind);
     EXCEPTION WHEN OTHERS THEN
       P_RETURN_CODE := 'API_REL_CS_500'; --Error inserting Relationship
     END;
   ELSIF P_REL_TABLE = 'CSI_RECS' THEN
     v_rel_csi_rec.csi_rec_idseq := P_REL_REL_IDSEQ;
     v_rel_csi_rec.p_csi_idseq     := P_REL_P_IDSEQ;
     v_rel_csi_rec.c_csi_idseq     := P_REL_C_IDSEQ;
     v_rel_csi_rec.rl_name         := P_REL_RL_NAME;
     v_rel_csi_rec.created_by     := P_REL_CREATED_BY;
     v_rel_csi_rec.date_created     := TO_DATE(P_REL_DATE_CREATED);
     v_rel_csi_rec.modified_by     := P_REL_MODIFIED_BY;
     v_rel_csi_rec.date_modified := TO_DATE(P_REL_DATE_MODIFIED);

     v_rel_csi_ind.csi_rec_idseq := TRUE;
     v_rel_csi_ind.p_csi_idseq     := TRUE;
     v_rel_csi_ind.c_csi_idseq     := TRUE;
     v_rel_csi_ind.rl_name         := TRUE;
     v_rel_csi_ind.created_by     := TRUE;
     v_rel_csi_ind.date_created     := TRUE;
     v_rel_csi_ind.modified_by     := TRUE;
     v_rel_csi_ind.date_modified := TRUE;

     BEGIN
       cg$csi_recs_view.ins(v_rel_csi_rec,v_rel_csi_ind);
     EXCEPTION WHEN OTHERS THEN
        P_RETURN_CODE := 'API_REL_CSI_500'; --Error inserting Relationship
     END;

   ELSIF P_REL_TABLE = 'QC_RECS_EXT' THEN
     v_rel_qce_rec.qr_idseq         := P_REL_REL_IDSEQ;
     v_rel_qce_rec.p_qc_idseq     := P_REL_P_IDSEQ;
     v_rel_qce_rec.c_qc_idseq     := P_REL_C_IDSEQ;
     v_rel_qce_rec.rl_name         := P_REL_RL_NAME;
     v_rel_qce_rec.created_by     := P_REL_CREATED_BY;
     v_rel_qce_rec.date_created     := TO_DATE(P_REL_DATE_CREATED);
     v_rel_qce_rec.modified_by     := P_REL_MODIFIED_BY;
     v_rel_qce_rec.date_modified := TO_DATE(P_REL_DATE_MODIFIED);
  v_rel_qce_rec.display_order    := P_REL_DISPLAY_ORDER;

     v_rel_qce_ind.qr_idseq         := TRUE;
     v_rel_qce_ind.p_qc_idseq     := TRUE;
     v_rel_qce_ind.c_qc_idseq     := TRUE;
     v_rel_qce_ind.rl_name         := TRUE;
     v_rel_qce_ind.created_by     := TRUE;
     v_rel_qce_ind.date_created     := TRUE;
     v_rel_qce_ind.modified_by     := TRUE;
     v_rel_qce_ind.date_modified := TRUE;

     BEGIN
       Cg$qc_Recs_View_Ext.ins(v_rel_qce_rec,v_rel_qce_ind);
     EXCEPTION WHEN OTHERS THEN
    dbms_output.put_line('Error inserting relationship ' ||SUBSTR(SQLERRM,1,200));
       P_RETURN_CODE := 'API_REL_QCE_500'; --Error inserting Relationship
     END;

  END IF;
END IF;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
       NULL;
   WHEN OTHERS THEN
       NULL;
END SET_REL;



PROCEDURE SET_PROTO(
P_UA_NAME       IN  VARCHAR2
,P_RETURN_CODE      OUT    VARCHAR2,
       P_ACTION    IN    VARCHAR2,
       P_PROTO_IDSEQ           IN OUT VARCHAR2,
         P_VERSION               IN OUT NUMBER,
       P_CONTE_IDSEQ           IN OUT VARCHAR2,
       P_PREFERRED_NAME        IN OUT VARCHAR2,
       P_PREFERRED_DEFINITION  IN OUT VARCHAR2,
       P_ASL_NAME              IN OUT VARCHAR2,
       P_LONG_NAME             IN OUT VARCHAR2,
       P_LATEST_VERSION_IND    IN OUT VARCHAR2,
       P_DELETED_IND           IN OUT VARCHAR2,
       P_BEGIN_DATE            IN OUT DATE,
       P_END_DATE              IN OUT DATE,
       P_PROTOCOL_ID           IN OUT VARCHAR2,
       P_TYPE                  IN OUT VARCHAR2,
       P_PHASE                 IN OUT VARCHAR2,
       P_LEAD_ORG              IN OUT VARCHAR2,
       P_CHANGE_TYPE           IN OUT VARCHAR2,
       P_CHANGE_NUMBER         IN OUT NUMBER,
       P_REVIEWED_DATE         IN OUT DATE,
       P_REVIEWED_BY           IN OUT VARCHAR2,
       P_APPROVED_DATE         IN OUT DATE,
       P_APPROVED_BY           IN OUT VARCHAR2,
       P_DATE_CREATED          IN OUT DATE,
       P_CREATED_BY            IN OUT VARCHAR2,
       P_DATE_MODIFIED         IN OUT DATE,
       P_MODIFIED_BY           IN OUT VARCHAR2,
       P_CHANGE_NOTE           IN OUT VARCHAR2,
     P_ORIGIN                IN     VARCHAR2 DEFAULT NULL -- 23-Jul-2003, W. Ver Hoef
     )
IS
-- Date:  23-Jul-2003
-- Modified By:  W. Ver Hoef
-- Reason:  added parameter and code for origin
  v_proto_rec      Cg$protocols_View_Ext.cg$row_type;
  v_proto_ind  Cg$protocols_View_Ext.cg$ind_type;
  v_Asl_name        protocols_view_ext.asl_name%TYPE;
BEGIN

  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

dbms_output.put_line('beginning...');
  IF P_ACTION = 'INS' THEN
dbms_output.put_line('inside if stmt...');
     p_proto_idseq:= admincomponent_crud.cmr_guid;
  IF p_date_created IS NULL THEN
      p_date_created:= TO_CHAR(SYSDATE);
  END IF;
  IF p_created_by IS NULL THEN
      p_created_by:= P_UA_NAME; --USER;
  END IF;
     p_date_modified  := NULL;
     p_modified_by    := NULL;
dbms_output.put_line('starting rec and ind assignments...');
  v_proto_rec.proto_idseq    := p_proto_idseq;
   v_proto_rec.version    := p_version;
   v_proto_rec.conte_idseq   := p_conte_idseq;
   v_proto_rec.preferred_name   := p_preferred_name;
   v_proto_rec.preferred_definition := p_preferred_definition;
   v_proto_rec.asl_name              := p_asl_name;
   v_proto_rec.long_name             := p_long_name;
   v_proto_rec.latest_version_ind    := p_latest_version_ind;
   v_proto_rec.deleted_ind           := p_deleted_ind;
   v_proto_rec.begin_date            := p_begin_date;
   v_proto_rec.end_date              := p_end_date;
dbms_output.put_line('about to do p_protocol_id...');
   v_proto_rec.protocol_id           := p_protocol_id;
dbms_output.put_line('finished p_protocol_id...');
   v_proto_rec.TYPE                  := p_type;
   v_proto_rec.phase                 := p_phase;
   v_proto_rec.lead_org              := p_lead_org;
   v_proto_rec.change_type           := p_change_type;
   v_proto_rec.change_number         := p_change_number;
   v_proto_rec.reviewed_date         := p_reviewed_date;
   v_proto_rec.reviewed_by           := p_reviewed_by;
   v_proto_rec.approved_date         := p_approved_date;
   v_proto_rec.approved_by           := p_approved_by;
   v_proto_rec.date_created          := p_date_created;
   v_proto_rec.created_by            := p_created_by;
   v_proto_rec.date_modified         := p_date_modified;
   v_proto_rec.modified_by           := p_modified_by;
   v_proto_rec.change_note          := p_change_note;
  v_proto_rec.origin                 := p_origin;  -- 23-Jul-2003, W. Ver Hoef
dbms_output.put_line('finished rec now ind...');

  v_proto_ind.proto_idseq    := TRUE;
   v_proto_ind.version    := TRUE;
   v_proto_ind.conte_idseq   := TRUE;
   v_proto_ind.preferred_name   := TRUE;
   v_proto_ind.preferred_definition := TRUE;
   v_proto_ind.asl_name              := TRUE;
   v_proto_ind.long_name             := TRUE;
   v_proto_ind.latest_version_ind    := TRUE;
   v_proto_ind.deleted_ind           := TRUE;
   v_proto_ind.begin_date            := TRUE;
   v_proto_ind.end_date              := TRUE;
   v_proto_ind.protocol_id           := TRUE;
   v_proto_ind.TYPE                  := TRUE;
   v_proto_ind.phase                 := TRUE;
   v_proto_ind.lead_org              := TRUE;
   v_proto_ind.change_type           := TRUE;
   v_proto_ind.change_number         := TRUE;
   v_proto_ind.reviewed_date         := TRUE;
   v_proto_ind.reviewed_by           := TRUE;
   v_proto_ind.approved_date         := TRUE;
   v_proto_ind.approved_by           := TRUE;
   v_proto_ind.date_created          := TRUE;
   v_proto_ind.created_by            := TRUE;
   v_proto_ind.date_modified         := TRUE;
   v_proto_ind.modified_by           := TRUE;
   v_proto_ind.change_note          := TRUE;
  v_proto_ind.origin                 := TRUE;  -- 23-Jul-2003, W. Ver Hoef
dbms_output.put_line('finished ind about to call Cg$protocols_View_Ext.ins...');

  BEGIN
       Cg$protocols_View_Ext.ins(v_proto_rec,v_proto_ind);
     EXCEPTION WHEN OTHERS THEN
dbms_output.put_line('SQLERRN = '||SQLERRM);
dbms_output.put_line('SQLCODE = '||SQLCODE);
    dbms_output.put_line('Error inserting Protocol ' ||SUBSTR(SQLERRM,1,200));
       P_RETURN_CODE := 'API_PROTO_500'; --Error inserting Relationship
     END;
  END IF;
END;



PROCEDURE SET_CD_VMS(
P_UA_NAME                   IN VARCHAR2
,P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_CDVMS_CV_IDSEQ         IN OUT VARCHAR2
,P_CDVMS_CD_IDSEQ         IN OUT VARCHAR2
,P_CDVMS_SHORT_MEANING      IN OUT VARCHAR2
,P_CDVMS_DESCRIPTION        IN OUT VARCHAR2
,P_CDVMS_VM_IDSEQ       IN OUT VARCHAR2
,P_CDVMS_DATE_CREATED     OUT VARCHAR2
,P_CDVMS_CREATED_BY         OUT VARCHAR2
,P_CDVMS_MODIFIED_BY     OUT VARCHAR2
,P_CDVMS_DATE_MODIFIED     OUT VARCHAR2)
IS

/******************************************************************************
   NAME:       SET_CD_VMS
   PURPOSE:    Inserts or Updates a Single Row Of CD_VMS basedo n either
               CD_IDSEQ or SHORT_MEANING

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/20/2002  Judy Pai      1. Created this procedure




******************************************************************************/


v_cv_rec  CG$CD_VMS_VIEW.cg$row_type;
v_cv_ind  CG$CD_VMS_VIEW.cg$ind_type;
v_cv_pk   CG$CD_VMS_VIEW.cg$pk_type;

BEGIN
P_RETURN_CODE := NULL;

IF P_ACTION NOT IN ('INS','DEL') THEN
 P_RETURN_CODE := 'API_CDVMS_700'; -- Invalid action
 RETURN;
END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
  IF P_CDVMS_CV_IDSEQ IS NOT NULL THEN
     P_RETURN_CODE := 'API_CDVMS_100' ;  --for inserts the ID IS generated
  RETURN;
  ELSE
     --Check to see that all mandatory parameters are not null

  IF P_CDVMS_CD_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_CDVMS_102'; --VD_IDSEQ cannot be null here
  RETURN;
  END IF;

  IF P_CDVMS_VM_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_CDVMS_104'; --SHORT_MEANING cannot be null here
  RETURN;
  END IF;
  END IF;
END IF;


IF P_ACTION = 'DEL' THEN              --we are deleting a record
  IF P_CDVMS_CV_IDSEQ IS  NULL THEN
     P_RETURN_CODE := 'API_CDVMS_400' ;  --for deleted the ID idmandatory
  RETURN;

  END IF;
  v_cv_pk.cv_idseq := P_CDVMS_CV_IDSEQ;

  SELECT ROWID INTO v_cv_pk.the_rowid
  FROM CD_VMS_VIEW
  WHERE cv_idseq = P_CDVMS_CV_IDSEQ;
  v_cv_pk.jn_notes := NULL;

  BEGIN
    CG$CD_VMS_VIEW.del(v_cv_pk);
 RETURN;
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_CDVMS_501'; --Error deleteing Value Domain
 RETURN;
  END;

END IF;

--check to see that conceptual domain and vlue_meaning

IF NOT Sbrext_Common_Routines.ac_exists(P_CDVMS_CD_IDSEQ)  THEN
  P_RETURN_CODE := 'API_CDVMS_201'; --Conceptual domain NOT found in the database
  RETURN;
END IF;

IF NOT Sbrext_Common_Routines.vm_exists(p_vm_idseq=>P_CDVMS_VM_IDSEQ) THEN
  P_RETURN_CODE := 'API_CDVMS_202'; --Value meaning not found in the database
  RETURN;
END IF;

IF Sbrext_Common_Routines.cd_vm_exists(p_cd_idseq=>P_CDVMS_CD_IDSEQ,p_short_meaning=>P_CDVMS_SHORT_MEANING) THEN
  P_RETURN_CODE := 'API_CDVMS_203'; --Relationship exists for the CD and VM
  RETURN;
END IF;

IF (P_ACTION = 'INS' ) THEN


  P_CDVMS_CV_IDSEQ := admincomponent_crud.cmr_guid;
  P_CDVMS_DATE_CREATED := TO_CHAR(SYSDATE);
  P_CDVMS_CREATED_BY := P_UA_NAME; --USER;
  P_CDVMS_DATE_MODIFIED := NULL;
  P_CDVMS_MODIFIED_BY := NULL;

  v_cv_rec.cv_idseq       := P_CDVMS_CV_IDSEQ;
  v_cv_rec.cd_idseq       := P_CDVMS_CD_IDSEQ ;
  v_cv_rec.short_meaning  := P_CDVMS_SHORT_MEANING;
  v_cv_rec.description    := P_CDVMS_DESCRIPTION;
  v_cv_rec.vm_idseq    := P_CDVMS_VM_IDSEQ;
  v_cv_rec.created_by   := P_CDVMS_CREATED_BY;
  v_cv_rec.date_created   := TO_DATE(P_CDVMS_DATE_CREATED);
  v_cv_rec.modified_by   := P_CDVMS_MODIFIED_BY;
  v_cv_rec.date_modified  := P_CDVMS_DATE_MODIFIED;

  v_cv_ind.CV_IDSEQ   := TRUE;
  v_cv_ind.CD_IDSEQ   := TRUE;
  v_cv_ind.SHORT_MEANING  := TRUE;
  v_cv_ind.VM_IDSEQ  := TRUE;
  v_cv_ind.description    := TRUE;
  v_cv_ind.created_by   := TRUE;
  v_cv_ind.date_created   := TRUE;
  v_cv_ind.modified_by   := TRUE;
  v_cv_ind.date_modified  := TRUE;
  BEGIN
    CG$CD_VMS_VIEW.ins(v_cv_rec,v_cv_ind);
  EXCEPTION WHEN OTHERS THEN
   P_RETURN_CODE := 'API_CDVMS_500'; --Error inserting VD_PVS
  END;
END IF;


 EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_CD_VMS;

PROCEDURE SET_PROPERTY(
P_UA_NAME       IN  VARCHAR2
,P_RETURN_CODE                  OUT VARCHAR2
,P_ACTION              IN     VARCHAR2
,P_PROP_IDSEQ             IN OUT VARCHAR2
,P_PROP_PREFERRED_NAME       IN OUT VARCHAR2
,P_PROP_LONG_NAME            IN OUT VARCHAR2
,P_PROP_PREFERRED_DEFINITION IN OUT VARCHAR2
,P_PROP_CONTE_IDSEQ          IN OUT VARCHAR2
,P_PROP_VERSION          IN OUT VARCHAR2
,P_PROP_ASL_NAME         IN OUT VARCHAR2
,P_PROP_LATEST_VERSION_IND   IN OUT VARCHAR2
,P_PROP_CHANGE_NOTE       IN OUT VARCHAR2
,P_PROP_ORIGIN            IN OUT VARCHAR2
,P_PROP_DEFINITION_SOURCE    IN OUT VARCHAR2
,P_PROP_BEGIN_DATE       IN OUT VARCHAR2
,P_PROP_END_DATE             IN OUT VARCHAR2
,P_PROP_DATE_CREATED            OUT VARCHAR2
,P_PROP_CREATED_BY           OUT VARCHAR2
,P_PROP_DATE_MODIFIED           OUT VARCHAR2
,P_PROP_MODIFIED_BY             OUT VARCHAR2
,P_PROP_DELETED_IND             OUT VARCHAR2
,P_PROP_DESIG_NCI_CC_TYPE    IN     VARCHAR2
,P_PROP_DESIG_NCI_CC_VAL     IN     VARCHAR2
,P_PROP_DESIG_UMLS_CUI_TYPE  IN     VARCHAR2
,P_PROP_DESIG_UMLS_CUI_VAL   IN     VARCHAR2
,P_PROP_DESIG_TEMP_CUI_TYPE  IN     VARCHAR2
,P_PROP_DESIG_TEMP_CUI_VAL   IN     VARCHAR2
)
IS
/******************************************************************************
   NAME:       SET_PROPERTY
   PURPOSE:    Inserts or Updates a Single Row Of properties_ext based on either


   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04/02/2003  Judy Pai         1. Created this procedure
   2.0        07/23/2003  W. Ver Hoef     1. added v_prop_ind.origin := FALSE
                         for DEL action
   2.1        03/19/2004  W. Ver Hoef      1. substituted UNASSIGNED with function
                                              call to get_default_asl

******************************************************************************/


v_prop_rec  Cg$properties_View_Ext.cg$row_type;
v_prop_ind  Cg$properties_View_Ext.cg$ind_type;

v_begin_date   DATE    := NULL;
v_end_date     DATE    := NULL;
v_new_Version  BOOLEAN := FALSE;

v_version  properties_view_ext.version%TYPE;
v_asl_name properties_view_ext.asl_name%TYPE;

BEGIN

  P_RETURN_CODE := NULL;

  IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
    P_RETURN_CODE := 'API_PROP_700'; -- Invalid action
    RETURN;
  END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  IF P_ACTION = 'INS' THEN              --we are inserting a record
    IF P_PROP_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_PROP_100' ;  --for inserts the ID IS generated
   RETURN;
    ELSE
      --Check to see that all mandatory parameters are not null
   IF P_PROP_PREFERRED_NAME IS NULL THEN
     P_RETURN_CODE := 'API_PROP_102'; --PREFERRED_NAME cannot be null here
  RETURN;
   END IF;
   IF P_PROP_PREFERRED_DEFINITION IS NULL THEN
     P_RETURN_CODE := 'API_PROP_104'; --PREFERRED_DEFINITION cannot be null here
  RETURN;
   END IF;
   IF P_PROP_CONTE_IDSEQ  IS NULL THEN
     P_RETURN_CODE := 'API_PROP_106';  --CONTEXT_NAME cannot be null here
  RETURN;
   END IF;
    END IF;
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are deleting a record

    IF P_PROP_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_PROP_400' ;  --for deleted the ID idmandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ac_exists(P_PROP_IDSEQ) THEN
     P_RETURN_CODE := 'API_PROP_005'; --PROPERTY not found
     RETURN;
   END IF;
    END IF;

    P_PROP_DELETED_IND   := 'Yes';
    P_PROP_MODIFIED_BY   := P_UA_NAME; --USER;
    P_PROP_DATE_MODIFIED := TO_CHAR(SYSDATE);

    v_prop_rec.prop_idseq         := P_PROP_IDSEQ;
    v_prop_rec.deleted_ind        := P_PROP_DELETED_IND;
    v_prop_rec.modified_by        := P_PROP_MODIFIED_BY;
    v_prop_rec.date_modified      := TO_DATE(P_PROP_DATE_MODIFIED);
    v_prop_rec.latest_version_ind := P_PROP_LATEST_VERSION_IND;

    v_prop_ind.prop_idseq         := TRUE;
    v_prop_ind.preferred_name     := FALSE;
    v_prop_ind.conte_idseq         := FALSE;
    v_prop_ind.version             := FALSE;
    v_prop_ind.preferred_definition := FALSE;
    v_prop_ind.long_name         := FALSE;
    v_prop_ind.asl_name             := FALSE;
    v_prop_ind.latest_version_ind   := FALSE;
    v_prop_ind.begin_date         := FALSE;
    v_prop_ind.end_date             := FALSE;
    v_prop_ind.change_note         := FALSE;
    v_prop_ind.created_by         := FALSE;
    v_prop_ind.date_created         := FALSE;
 v_prop_ind.origin               := FALSE;  -- 23-Jul-2003, W. Ver Hoef
    v_prop_ind.modified_by         := TRUE;
    v_prop_ind.date_modified     := TRUE;
    v_prop_ind.deleted_ind          := TRUE;

    BEGIN
      Cg$properties_View_Ext.upd(v_prop_rec,v_prop_ind);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_PROP_501'; --Error deleteing PROPERTY
    END;

  END IF;

  IF P_ACTION = 'UPD' THEN              --we are updating a record
   admin_security_util.seteffectiveuser(p_ua_name);
    IF P_PROP_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_PROP_400' ;  --for updates the ID IS mandatory
   RETURN;
    END IF;
    SELECT asl_name
    INTO   v_asl_name
    FROM   PROPERTIES_EXT
    WHERE  prop_idseq = p_prop_idseq;
    IF (P_PROP_PREFERRED_NAME IS NOT NULL OR P_PROP_CONTE_IDSEQ IS NOT NULL) AND v_asl_name = 'RELEASED' THEN
      P_RETURN_CODE := 'API_PROP_401' ;  --Preferred Name or Context Can not be updated
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(P_PROP_IDSEQ) THEN
      P_RETURN_CODE := 'API_PROP_005'; --PROP_IDSEQ not found
      RETURN;
    END IF;
  END IF;

  IF P_PROP_LATEST_VERSION_IND IS NOT NULL THEN
    IF P_PROP_LATEST_VERSION_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_PROP_105'; --Version can only be 'Yes' or 'No'
      RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
  IF LENGTH(P_PROP_PREFERRED_NAME) > Sbrext_Column_Lengths.L_PROP_PREFERRED_NAME THEN
    P_RETURN_CODE := 'API_PROP_111';  --Length of preferred_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_PROP_PREFERRED_DEFINITION) > Sbrext_Column_Lengths.L_PROP_PREFERRED_DEFINITION THEN
    P_RETURN_CODE := 'API_PROP_113';  --Length of Preferred_definition exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_PROP_LONG_NAME) > Sbrext_Column_Lengths.L_PROP_LONG_NAME THEN
    P_RETURN_CODE := 'API_PROP_114'; --Length of Long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_PROP_ASL_NAME) > Sbrext_Column_Lengths.L_PROP_ASL_NAME  THEN
    P_RETURN_CODE := 'API_PROP_115'; --Length of asl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_PROP_CHANGE_NOTE) > Sbrext_Column_Lengths.L_PROP_CHANGE_NOTE THEN
    P_RETURN_CODE := 'API_PROP_128'; --Length of change_note exceeds maximum length
    RETURN;
  END IF;

  --check to see that charachter strings are valid
  IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_PROP_PREFERRED_NAME) THEN
    P_RETURN_CODE := 'API_PROP_130'; -- Data Element Preferred Name has invalid Ccharacters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_PROP_PREFERRED_DEFINITION) THEN
    P_RETURN_CODE := 'API_PROP_133'; -- Data Element Preferred Definition has invalid characters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_PROP_LONG_NAME) THEN
    P_RETURN_CODE := 'API_PROP_134'; -- Data Element Long Name has invalid characters
    RETURN;
  END IF;

  --check to see that Context, Workflow Status, Data Element Concept, Value Domain already exist in the database
  IF P_PROP_CONTE_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.context_exists(P_PROP_CONTE_IDSEQ) THEN
      P_RETURN_CODE := 'API_PROP_200'; --Context not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_PROP_ASL_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.workflow_exists(P_PROP_ASL_NAME) THEN
      P_RETURN_CODE := 'API_PROP_202'; --Workflow Status not found in the database
      RETURN;
    END IF;
  END IF;

  --check to see that begin data and end date are valid dates
  IF(P_PROP_BEGIN_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_PROP_BEGIN_DATE,v_begin_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_PROP_600'; --begin date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_PROP_END_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_PROP_END_DATE,v_end_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_PROP_601'; --end date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_PROP_BEGIN_DATE IS NOT NULL AND P_PROP_END_DATE IS NOT NULL) THEN
    IF(v_end_date < v_begin_date) THEN
      P_RETURN_CODE := 'API_PROP_210'; --end date is before begin date
      RETURN;
    END IF;
  ELSIF(P_PROP_END_DATE IS NOT NULL AND P_PROP_BEGIN_DATE IS NULL) THEN
    P_RETURN_CODE := 'API_PROP_211'; --begin date cannot be null when end date is null
    RETURN;
  END IF;

  IF (P_ACTION = 'INS' ) THEN

    P_PROP_IDSEQ         := admincomponent_crud.cmr_guid;
    P_PROP_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_PROP_CREATED_BY    := P_UA_NAME; --USER;
    P_PROP_DATE_MODIFIED := NULL;
    P_PROP_MODIFIED_BY   := NULL;
    IF P_PROP_VERSION IS NULL THEN
      P_PROP_VERSION := 1;
    END IF;
    IF P_PROP_ASL_NAME IS NULL THEN
   -- 19-Mar-2004, W. Ver Hoef - substituted UNASSIGNED with function call below
      P_PROP_ASL_NAME := Sbrext_Common_Routines.get_default_asl('INS'); -- 'UNASSIGNED';
    END IF;

    v_prop_rec.prop_idseq           := P_PROP_IDSEQ;
    v_prop_rec.preferred_name       := P_PROP_PREFERRED_NAME;
    v_prop_rec.PREFERRED_DEFINITION := P_PROP_PREFERRED_DEFINITION;
    v_prop_rec.created_by         := P_UA_NAME; --USER;
    v_prop_rec.date_created         := SYSDATE;
    v_prop_rec.modified_by         := NULL;
    v_prop_rec.date_modified        := NULL;
    v_prop_rec.long_name            := P_PROP_LONG_NAME;
    v_prop_rec.conte_idseq          := P_PROP_CONTE_IDSEQ;
    v_prop_rec.version              := P_PROP_VERSION;
    v_prop_rec.asl_name             := P_PROP_ASL_NAME;
    v_prop_rec.latest_version_ind   := 'Yes';
    v_prop_rec.change_note          := NULL;
    v_prop_rec.begin_date           := NULL;
    v_prop_rec.end_date             := NULL;
    v_prop_rec.deleted_ind          := 'No';
    v_prop_rec.definition_source    := P_PROP_DEFINITION_SOURCE;
    v_prop_rec.origin               := P_PROP_ORIGIN;
   /* v_prop_rec.DESIG_NCI_CC_TYPE    := P_PROP_DESIG_NCI_CC_TYPE ;
    v_prop_rec.DESIG_NCI_CC_VAL     := P_PROP_DESIG_NCI_CC_VAL ;
    v_prop_rec.DESIG_UMLS_CUI_TYPE  := P_PROP_DESIG_UMLS_CUI_TYPE ;
    v_prop_rec.DESIG_UMLS_CUI_VAL   := P_PROP_DESIG_UMLS_CUI_VAL ;
    v_prop_rec.DESIG_TEMP_CUI_TYPE  := P_PROP_DESIG_TEMP_CUI_TYPE ;
    v_prop_rec.DESIG_TEMP_CUI_VAL   := P_PROP_DESIG_TEMP_CUI_VAL ;*/

    v_prop_ind.prop_idseq           := TRUE;
    v_prop_ind.preferred_name       := TRUE;
    v_prop_ind.PREFERRED_DEFINITION := TRUE;
    v_prop_ind.created_by           := TRUE;
    v_prop_ind.date_created         := TRUE;
    v_prop_ind.modified_by         := TRUE;
    v_prop_ind.date_modified        := TRUE;
    v_prop_ind.long_name            := TRUE;
    v_prop_ind.conte_idseq          := TRUE;
    v_prop_ind.version              := TRUE;
    v_prop_ind.asl_name             := TRUE;
    v_prop_ind.latest_version_ind   := TRUE;
    v_prop_ind.change_note          := TRUE;
    v_prop_ind.begin_date           := TRUE;
    v_prop_ind.end_date             := TRUE;
    v_prop_ind.deleted_ind          := TRUE;
    v_prop_ind.definition_source    := TRUE;
    v_prop_ind.origin               := TRUE;
    /*v_prop_ind.DESIG_NCI_CC_TYPE    := TRUE;
    v_prop_ind.DESIG_NCI_CC_VAL     := TRUE;
    v_prop_ind.DESIG_UMLS_CUI_TYPE  := TRUE;
    v_prop_ind.DESIG_UMLS_CUI_VAL   := TRUE;
    v_prop_ind.DESIG_TEMP_CUI_TYPE  := TRUE;
    v_prop_ind.DESIG_TEMP_CUI_VAL   := TRUE;*/

    BEGIN
      Cg$properties_View_Ext.ins(v_prop_rec,v_prop_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_PROP_500'; --Error inserting PROPERTIES_VIEW_EXT
    END;

  END IF;

  IF (P_ACTION = 'UPD' ) THEN

    --Get the version for the P_PROP_IDSEQ
    SELECT version
 INTO   v_version
    FROM   properties_view_ext
    WHERE  prop_idseq = P_PROP_IDSEQ;

    IF v_version <> P_PROP_VERSION THEN
      P_RETURN_CODE := 'API_PROP_402'; -- Version can NOT be updated. It can only be created
      RETURN;
    END IF;

    P_PROP_DATE_MODIFIED := TO_CHAR(SYSDATE);
    P_PROP_MODIFIED_BY := P_UA_NAME; --USER;
    P_PROP_DELETED_IND := 'No';

    v_prop_rec.date_modified := TO_DATE(P_PROP_DATE_MODIFIED);
    v_prop_rec.modified_by   := P_PROP_MODIFIED_BY;
    v_prop_rec.prop_idseq    := P_PROP_IDSEQ;
    v_prop_rec.deleted_ind   := 'No';

    v_prop_ind.date_modified := TRUE;
    v_prop_ind.modified_by   := TRUE;
    v_prop_ind.deleted_ind   := TRUE;
    v_prop_ind.prop_idseq    := TRUE;

    v_prop_ind.version       := FALSE;
    v_prop_ind.created_by  := FALSE;
    v_prop_ind.date_created  := FALSE;

    IF P_PROP_PREFERRED_NAME IS NULL THEN
      v_prop_ind.preferred_name := FALSE;
    ELSE
      v_prop_rec.preferred_name := P_PROP_PREFERRED_NAME;
      v_prop_ind.preferred_name := TRUE;
    END IF;

    IF P_PROP_CONTE_IDSEQ IS NULL THEN
      v_prop_ind.conte_idseq := FALSE;
    ELSE
      v_prop_rec.conte_idseq := P_PROP_CONTE_IDSEQ;
      v_prop_ind.conte_idseq := TRUE;
    END IF;

    IF P_PROP_PREFERRED_DEFINITION IS NULL THEN
      v_prop_ind.preferred_definition := FALSE; /***/
    ELSE
      v_prop_rec.preferred_definition := P_PROP_PREFERRED_DEFINITION;
      v_prop_ind.preferred_definition := TRUE;
    END IF;

    IF P_PROP_LONG_NAME IS NULL THEN
      v_prop_ind.long_name := FALSE;
    ELSE
      v_prop_rec.long_name := P_PROP_LONG_NAME;
      v_prop_ind.long_name := TRUE;
    END IF;

    IF P_PROP_ASL_NAME IS NULL THEN
      v_prop_ind.asl_name := FALSE;
    ELSE
      v_prop_rec.asl_name := P_PROP_ASL_NAME;
      v_prop_ind.asl_name := TRUE;
    END IF;

    IF P_PROP_LATEST_VERSION_IND IS NULL THEN
      v_prop_ind.latest_version_ind := FALSE;
    ELSE
      v_prop_rec.latest_version_ind := P_PROP_LATEST_VERSION_IND;
      v_prop_ind.latest_version_ind := TRUE;
    END IF;

    IF P_PROP_BEGIN_DATE IS NULL THEN
      v_prop_ind.begin_date := FALSE;
    ELSE
      v_prop_rec.begin_date := TO_DATE(P_PROP_BEGIN_DATE);
      v_prop_ind.begin_date := TRUE;
    END IF;

    IF P_PROP_END_DATE  IS NULL THEN
      v_prop_ind.end_date := FALSE;
    ELSE
      v_prop_rec.end_date := TO_DATE(P_PROP_END_DATE);
      v_prop_ind.end_date := TRUE;
    END IF;

    IF P_PROP_CHANGE_NOTE   IS NULL THEN
      v_prop_ind.change_note := FALSE;
    ELSE
      v_prop_rec.change_note := P_PROP_CHANGE_NOTE;
      v_prop_ind.change_note := TRUE;
    END IF;

    IF P_PROP_DEFINITION_SOURCE IS NULL THEN
      v_prop_ind.definition_source := FALSE;
    ELSE
      v_prop_rec.definition_source := P_PROP_DEFINITION_SOURCE;
      v_prop_ind.definition_source := TRUE;
    END IF;

    IF P_PROP_ORIGIN IS NULL THEN
      v_prop_ind.origin := FALSE;
    ELSE
      v_prop_rec.origin := P_PROP_ORIGIN;
      v_prop_ind.origin := TRUE;
    END IF;

  /*  IF P_PROP_DESIG_NCI_CC_TYPE   IS NULL THEN
      v_prop_ind.DESIG_NCI_CC_TYPE := FALSE;
    ELSE
      v_prop_rec.DESIG_NCI_CC_TYPE := P_PROP_DESIG_NCI_CC_TYPE;
      v_prop_ind.DESIG_NCI_CC_TYPE := TRUE;
    END IF;

    IF P_PROP_DESIG_NCI_CC_VAL   IS NULL THEN
      v_prop_ind.DESIG_NCI_CC_VAL := FALSE;
    ELSE
      v_prop_rec.DESIG_NCI_CC_VAL := P_PROP_DESIG_NCI_CC_VAL;
      v_prop_ind.DESIG_NCI_CC_VAL := TRUE;
    END IF;

    IF P_PROP_DESIG_UMLS_CUI_TYPE   IS NULL THEN
      v_prop_ind.DESIG_UMLS_CUI_TYPE := FALSE;
    ELSE
      v_prop_rec.DESIG_UMLS_CUI_TYPE := P_PROP_DESIG_UMLS_CUI_TYPE;
      v_prop_ind.DESIG_UMLS_CUI_TYPE := TRUE;
    END IF;

    IF P_PROP_DESIG_UMLS_CUI_VAL   IS NULL THEN
      v_prop_ind.DESIG_UMLS_CUI_VAL := FALSE;
    ELSE
      v_prop_rec.DESIG_UMLS_CUI_VAL := P_PROP_DESIG_UMLS_CUI_VAL;
      v_prop_ind.DESIG_UMLS_CUI_VAL := TRUE;
    END IF;

    IF P_PROP_DESIG_TEMP_CUI_TYPE   IS NULL THEN
      v_prop_ind.DESIG_TEMP_CUI_TYPE := FALSE;
    ELSE
      v_prop_rec.DESIG_TEMP_CUI_TYPE := P_PROP_DESIG_TEMP_CUI_TYPE;
      v_prop_ind.DESIG_TEMP_CUI_TYPE := TRUE;
    END IF;

    IF P_PROP_DESIG_TEMP_CUI_VAL   IS NULL THEN
      v_prop_ind.DESIG_TEMP_CUI_VAL := FALSE;
    ELSE
      v_prop_rec.DESIG_TEMP_CUI_VAL := P_PROP_DESIG_TEMP_CUI_VAL;
      v_prop_ind.DESIG_TEMP_CUI_VAL := TRUE;
    END IF;*/

    BEGIN
      Cg$properties_View_Ext.upd(v_prop_rec,v_prop_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_PROP_502'; --Error updating Property
    END;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;

END SET_PROPERTY;



PROCEDURE SET_OBJECT_CLASS(
P_UA_NAME       IN  VARCHAR2
,P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                  IN     VARCHAR2
,P_oc_IDSEQ                IN OUT VARCHAR2
,P_oc_PREFERRED_NAME       IN OUT VARCHAR2
,P_oc_LONG_NAME            IN OUT VARCHAR2
,P_oc_PREFERRED_DEFINITION IN OUT VARCHAR2
,P_oc_CONTE_IDSEQ          IN OUT VARCHAR2
,P_oc_VERSION              IN OUT VARCHAR2
,P_oc_ASL_NAME             IN OUT VARCHAR2
,P_oc_LATEST_VERSION_IND   IN OUT VARCHAR2
,P_oc_CHANGE_NOTE          IN OUT VARCHAR2
,P_oc_ORIGIN               IN OUT VARCHAR2
,P_oc_DEFINITION_SOURCE    IN OUT VARCHAR2
,P_oc_BEGIN_DATE           IN OUT VARCHAR2
,P_oc_END_DATE             IN OUT VARCHAR2
,P_oc_DATE_CREATED            OUT VARCHAR2
,P_oc_CREATED_BY              OUT VARCHAR2
,P_oc_DATE_MODIFIED           OUT VARCHAR2
,P_oc_MODIFIED_BY             OUT VARCHAR2
,P_oc_DELETED_IND             OUT VARCHAR2
,P_OC_DESIG_NCI_CC_TYPE    IN     VARCHAR2
,P_OC_DESIG_NCI_CC_VAL     IN     VARCHAR2
,P_OC_DESIG_UMLS_CUI_TYPE  IN     VARCHAR2
,P_OC_DESIG_UMLS_CUI_VAL   IN     VARCHAR2
,P_OC_DESIG_TEMP_CUI_TYPE  IN     VARCHAR2
,P_OC_DESIG_TEMP_CUI_VAL   IN     VARCHAR2
)
IS
/******************************************************************************
   NAME:       SET_OBJECT_CLASS
   PURPOSE:    Inserts or Updates a Single Row Of OBJECT_CLASSES_ext based on either

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04/02/2003  Judy Pai         1. Created this procedure
   2.0     07/22/2003  W. Ver Hoef     1. Added v_oc_ind.origin := FALSE for
                                              DEL action
   2.1        03/19/2004  W. Ver Hoef      1. substituted UNASSIGNED with function
                                              call to get_default_asl

******************************************************************************/

v_oc_rec       Cg$object_Classes_View_Ext.cg$row_type;
v_oc_ind       Cg$object_Classes_View_Ext.cg$ind_type;
v_version      OBJECT_CLASSES_view_ext.version%TYPE;
v_asl_name     OBJECT_CLASSES_view_ext.asl_name%TYPE;
v_begin_date   DATE    := NULL;
v_end_date     DATE    := NULL;
v_new_Version  BOOLEAN := FALSE;

BEGIN
  P_RETURN_CODE := NULL;

  IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
    P_RETURN_CODE := 'API_OC_700'; -- Invalid action
    RETURN;
  END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  IF P_ACTION = 'INS' THEN              --we are inserting a record
    IF P_oc_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_OC_100' ;  --for inserts the ID IS generated
   RETURN;
    ELSE
      --Check to see that all mandatory parameters are not null

   IF P_oc_PREFERRED_NAME IS NULL THEN
     P_RETURN_CODE := 'API_OC_102'; --PREFERRED_NAME cannot be null here
  RETURN;
   END IF;

   IF P_oc_PREFERRED_DEFINITION IS NULL THEN
     P_RETURN_CODE := 'API_OC_104'; --PREFERRED_DEFINITION cannot be null here
  RETURN;
   END IF;

   IF P_oc_CONTE_IDSEQ  IS NULL THEN
     P_RETURN_CODE := 'API_OC_106';  --CONTEXT_NAME cannot be null here
  RETURN;
   END IF;
    END IF;
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are deleting a record

    IF P_oc_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_OC_400' ;  --for deleted the ID idmandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ac_exists(P_oc_IDSEQ) THEN
     P_RETURN_CODE := 'API_OC_005'; --OBJECT_CLASS not found
     RETURN;
   END IF;
    END IF;

    P_oc_DELETED_IND            := 'Yes';
    P_oc_MODIFIED_BY            := P_UA_NAME; --USER;
    P_oc_DATE_MODIFIED          := TO_CHAR(SYSDATE);

    v_oc_rec.oc_idseq           := P_oc_IDSEQ;
    v_oc_rec.deleted_ind        := P_oc_DELETED_IND;
    v_oc_rec.modified_by        := P_oc_MODIFIED_BY;
    v_oc_rec.date_modified      := TO_DATE(P_oc_DATE_MODIFIED);
    v_oc_rec.latest_version_ind := P_oc_LATEST_VERSION_IND;

    v_oc_ind.oc_idseq             := TRUE;
    v_oc_ind.preferred_name       := FALSE;
    v_oc_ind.conte_idseq          := FALSE;
    v_oc_ind.version              := FALSE;
    v_oc_ind.preferred_definition := FALSE;
    v_oc_ind.long_name            := FALSE;
    v_oc_ind.asl_name             := FALSE;
    v_oc_ind.latest_version_ind   := FALSE;
    v_oc_ind.begin_date           := FALSE;
    v_oc_ind.end_date             := FALSE;
    v_oc_ind.change_note          := FALSE;
    v_oc_ind.created_by           := FALSE;
    v_oc_ind.date_created         := FALSE;
 v_oc_ind.origin               := FALSE;  -- 22-Jul-2003, W. Ver Hoef
    v_oc_ind.modified_by          := TRUE;
    v_oc_ind.date_modified        := TRUE;
    v_oc_ind.deleted_ind          := TRUE;

    BEGIN
      Cg$object_Classes_View_Ext.upd(v_oc_rec,v_oc_ind);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
dbms_output.put_line('SQLCODE = '||SQLCODE);
dbms_output.put_line('SQLERRM = '||SQLERRM);
      P_RETURN_CODE := 'API_OC_501'; --Error deleteing OBJECT_CLASS
    END;

  END IF;

  IF P_ACTION = 'UPD' THEN              --we are updating a record
    admin_security_util.seteffectiveuser(p_ua_name);
    IF P_OC_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_OC_400' ;  --for updates the ID IS mandatory
   RETURN;
    END IF;
    SELECT asl_name
 INTO v_asl_name
    FROM OBJECT_CLASSES_EXT
    WHERE oc_idseq = p_oc_idseq;
    IF ( P_oc_PREFERRED_NAME IS NOT NULL OR P_oc_CONTE_IDSEQ IS NOT NULL) AND v_asl_name = 'RELEASED' THEN
      P_RETURN_CODE := 'API_OC_401' ;  --Preferred Name or Context Can not be updated
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(P_oc_IDSEQ) THEN
      P_RETURN_CODE := 'API_OC_005'; --PROP_IDSEQ not found
      RETURN;
    END IF;
  END IF;

  IF P_oc_LATEST_VERSION_IND IS NOT NULL THEN
    IF P_oc_LATEST_VERSION_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_OC_105'; --Version can only be 'Yes' or 'No'
      RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
  IF LENGTH(P_oc_PREFERRED_NAME) > Sbrext_Column_Lengths.L_oc_PREFERRED_NAME THEN
    P_RETURN_CODE := 'API_OC_111';  --Length of preferred_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_oc_PREFERRED_DEFINITION) > Sbrext_Column_Lengths.L_oc_PREFERRED_DEFINITION THEN
    P_RETURN_CODE := 'API_OC_113';  --Length of Preferred_definition exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_oc_LONG_NAME) > Sbrext_Column_Lengths.L_oc_LONG_NAME THEN
    P_RETURN_CODE := 'API_OC_114'; --Length of Long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_oc_ASL_NAME) > Sbrext_Column_Lengths.L_oc_ASL_NAME  THEN
    P_RETURN_CODE := 'API_OC_115'; --Length of asl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_oc_CHANGE_NOTE) > Sbrext_Column_Lengths.L_oc_CHANGE_NOTE THEN
    P_RETURN_CODE := 'API_OC_128'; --Length of change_note exceeds maximum length
    RETURN;
  END IF;

  --check to see that charachter strings are valid
  IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_oc_PREFERRED_NAME) THEN
    P_RETURN_CODE := 'API_OC_130'; -- Data Element Preferred Name has invalid Ccharacters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_oc_PREFERRED_DEFINITION) THEN
    P_RETURN_CODE := 'API_OC_133'; -- Data Element Preferred Definition has invalid characters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_oc_LONG_NAME) THEN
    P_RETURN_CODE := 'API_OC_134'; -- Data Element Long Name has invalid characters
    RETURN;
  END IF;

  --check to see that Context, Workflow Status, Data Element Concept, Value Domain already exist in the database
  IF P_oc_CONTE_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.context_exists(P_oc_CONTE_IDSEQ) THEN
      P_RETURN_CODE := 'API_OC_200'; --Context not found in the database
      RETURN;
    END IF;
  END IF;

  IF P_oc_ASL_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.workflow_exists(P_oc_ASL_NAME) THEN
      P_RETURN_CODE := 'API_OC_202'; --Workflow Status not found in the database
      RETURN;
    END IF;
  END IF;

--check to see that begin data and end date are valid dates
  IF(P_oc_BEGIN_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_oc_BEGIN_DATE,v_begin_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_OC_600'; --begin date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_oc_END_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_oc_END_DATE,v_end_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_OC_601'; --end date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_oc_BEGIN_DATE IS NOT NULL AND P_oc_END_DATE IS NOT NULL) THEN
    IF(v_end_date < v_begin_date) THEN
      P_RETURN_CODE := 'API_OC_210'; --end date is before begin date
      RETURN;
    END IF;
  ELSIF(P_oc_END_DATE IS NOT NULL AND P_oc_BEGIN_DATE IS NULL) THEN
    P_RETURN_CODE := 'API_OC_211'; --begin date cannot be null when end date is null
    RETURN;
  END IF;

  IF (P_ACTION = 'INS' ) THEN

    P_oc_IDSEQ         := admincomponent_crud.cmr_guid;
    P_oc_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_oc_CREATED_BY    := P_UA_NAME; --USER;
    P_oc_DATE_MODIFIED := NULL;
    P_oc_MODIFIED_BY   := NULL;
    IF P_oc_VERSION IS NULL THEN
      P_oc_VERSION := 1;
    END IF;
    IF P_oc_ASL_NAME IS NULL THEN
   -- 19-Mar-2004, W. Ver Hoef - substituted UNASSIGNED with function call below
      P_oc_ASL_NAME := Sbrext_Common_Routines.get_default_asl('INS'); -- 'UNASSIGNED';
    END IF;

    v_oc_rec.oc_idseq             := P_oc_IDSEQ;
    v_oc_rec.preferred_name       := P_oc_PREFERRED_NAME;
    v_oc_rec.PREFERRED_DEFINITION := P_oc_PREFERRED_DEFINITION;
    v_oc_rec.created_by           := ADMIN_SECURITY_UTIL.effective_user;
    v_oc_rec.date_created         := SYSDATE;
    v_oc_rec.modified_by          := NULL;
    v_oc_rec.date_modified        := NULL;
    v_oc_rec.long_name            := P_oc_LONG_NAME;
    v_oc_rec.conte_idseq          := P_oc_CONTE_IDSEQ;
    v_oc_rec.version              := P_oc_VERSION;
    v_oc_rec.asl_name             := P_oc_ASL_NAME;
    v_oc_rec.latest_version_ind   := 'Yes';
    v_oc_rec.change_note          := NULL;
    v_oc_rec.begin_date           := NULL;
    v_oc_rec.end_date             := NULL;
    v_oc_rec.deleted_ind          := 'No';
    v_oc_rec.definition_source    := P_OC_DEFINITION_SOURCE;
    v_oc_rec.origin               := P_OC_ORIGIN;
   /* v_oc_rec.DESIG_NCI_CC_TYPE    := P_oc_DESIG_NCI_CC_TYPE ;
    v_oc_rec.DESIG_NCI_CC_VAL     := P_oc_DESIG_NCI_CC_VAL ;
    v_oc_rec.DESIG_UMLS_CUI_TYPE  := P_oc_DESIG_UMLS_CUI_TYPE ;
    v_oc_rec.DESIG_UMLS_CUI_VAL   := P_oc_DESIG_UMLS_CUI_VAL ;
    v_oc_rec.DESIG_TEMP_CUI_TYPE  := P_oc_DESIG_TEMP_CUI_TYPE ;
    v_oc_rec.DESIG_TEMP_CUI_VAL   := P_oc_DESIG_TEMP_CUI_VAL ;*/

    v_oc_ind.oc_idseq             := TRUE;
    v_oc_ind.preferred_name       := TRUE;
    v_oc_ind.PREFERRED_DEFINITION := TRUE;
    v_oc_ind.created_by           := TRUE;
    v_oc_ind.date_created         := TRUE;
    v_oc_ind.modified_by          := TRUE;
    v_oc_ind.date_modified        := TRUE;
    v_oc_ind.long_name            := TRUE;
    v_oc_ind.conte_idseq          := TRUE;
    v_oc_ind.version              := TRUE;
    v_oc_ind.asl_name             := TRUE;
    v_oc_ind.latest_version_ind   := TRUE;
    v_oc_ind.change_note          := TRUE;
    v_oc_ind.begin_date           := TRUE;
    v_oc_ind.end_date             := TRUE;
    v_oc_ind.deleted_ind          := TRUE;
   /* v_oc_ind.DESIG_NCI_CC_TYPE    := TRUE;
    v_oc_ind.DESIG_NCI_CC_VAL     := TRUE;
    v_oc_ind.DESIG_UMLS_CUI_TYPE  := TRUE;
    v_oc_ind.DESIG_UMLS_CUI_VAL   := TRUE;
    v_oc_ind.DESIG_TEMP_CUI_TYPE  := TRUE;
    v_oc_ind.DESIG_TEMP_CUI_VAL   := TRUE;
    v_oc_ind.definition_source    := TRUE;*/
    v_oc_ind.origin               := TRUE;

    BEGIN
      Cg$object_Classes_View_Ext.ins(v_oc_rec,v_oc_ind);
    EXCEPTION WHEN OTHERS THEN
dbms_output.put_line('SQLCODE = '||SQLCODE);
dbms_output.put_line('SQLERRM = '||SQLERRM);
      P_RETURN_CODE := 'API_OC_500'; --Error inserting OBJECT_CLASSES_VIEW_EXT
    END;

  END IF;

  IF (P_ACTION = 'UPD' ) THEN

    --Get the version for the P_oc_IDSEQ
    SELECT version
 INTO v_version
    FROM OBJECT_CLASSES_view_ext
    WHERE oc_idseq = P_oc_IDSEQ;

    IF v_version <> P_oc_VERSION THEN
      P_RETURN_CODE := 'API_OC_402'; -- Version can NOT be updated. It can only be created
      RETURN;
    END IF;

    P_oc_DATE_MODIFIED := TO_CHAR(SYSDATE);
    P_oc_MODIFIED_BY   := P_UA_NAME; --USER;
    P_oc_DELETED_IND   := 'No';

    v_oc_rec.date_modified := TO_DATE(P_oc_DATE_MODIFIED);
    v_oc_rec.modified_by   := P_oc_MODIFIED_BY;
    v_oc_rec.oc_idseq      := P_oc_IDSEQ;
    v_oc_rec.deleted_ind   := 'No';

    v_oc_ind.date_modified := TRUE;
    v_oc_ind.modified_by   := TRUE;
    v_oc_ind.deleted_ind   := TRUE;
    v_oc_ind.End_date      := TRUE;
    v_oc_ind.version       := FALSE;
    v_oc_ind.created_by    := FALSE;
    v_oc_ind.date_created  := FALSE;

    IF P_oc_PREFERRED_NAME IS NULL THEN
      v_oc_ind.preferred_name := FALSE;
    ELSE
      v_oc_rec.preferred_name := P_oc_PREFERRED_NAME;
      v_oc_ind.preferred_name := TRUE;
    END IF;

    IF P_oc_CONTE_IDSEQ IS NULL THEN
      v_oc_ind.conte_idseq := FALSE;
    ELSE
      v_oc_rec.conte_idseq := P_oc_CONTE_IDSEQ;
      v_oc_ind.conte_idseq := TRUE;
    END IF;

    IF P_oc_PREFERRED_DEFINITION IS NULL THEN
      v_oc_ind.preferred_definition := FALSE; /***/
    ELSE
      v_oc_rec.preferred_definition := P_oc_PREFERRED_DEFINITION;
      v_oc_ind.preferred_definition := TRUE;
    END IF;

    IF P_oc_LONG_NAME IS NULL THEN
      v_oc_ind.long_name := FALSE;
    ELSE
      v_oc_rec.long_name := P_oc_LONG_NAME;
      v_oc_ind.long_name := TRUE;
    END IF;

    IF P_oc_ASL_NAME IS NULL THEN
      v_oc_ind.asl_name := FALSE;
    ELSE
      v_oc_rec.asl_name := P_oc_ASL_NAME;
      v_oc_ind.asl_name := TRUE;
    END IF;

    IF P_oc_LATEST_VERSION_IND IS NULL THEN
      v_oc_ind.latest_version_ind := FALSE;
    ELSE
      v_oc_rec.latest_version_ind := P_oc_LATEST_VERSION_IND;
      v_oc_ind.latest_version_ind := TRUE;
    END IF;

    IF P_oc_BEGIN_DATE IS NULL THEN
      v_oc_ind.begin_date := FALSE;
    ELSE
      v_oc_rec.begin_date := TO_DATE(P_oc_BEGIN_DATE);
      v_oc_ind.begin_date := TRUE;
    END IF;

    IF P_oc_END_DATE  IS NULL THEN
      v_oc_ind.end_date := FALSE;
    ELSE
      v_oc_rec.end_date := TO_DATE(P_oc_END_DATE);
      v_oc_ind.end_date := TRUE;
    END IF;

    IF P_oc_CHANGE_NOTE   IS NULL THEN
      v_oc_ind.change_note := FALSE;
    ELSE
      v_oc_rec.change_note := P_oc_CHANGE_NOTE;
      v_oc_ind.change_note := TRUE;
    END IF;

    IF P_OC_DEFINITION_SOURCE IS NULL THEN
      v_oc_ind.definition_source := FALSE;
    ELSE
      v_oc_rec.definition_source := P_OC_DEFINITION_SOURCE;
      v_oc_ind.definition_source := TRUE;
    END IF;

    IF P_OC_ORIGIN IS NULL THEN
      v_oc_ind.origin := FALSE;
    ELSE
      v_oc_rec.origin := P_OC_ORIGIN;
      v_oc_ind.origin := TRUE;
    END IF;

  /*  IF P_oc_DESIG_NCI_CC_TYPE   IS NULL THEN
      v_oc_ind.DESIG_NCI_CC_TYPE := FALSE;
    ELSE
      v_oc_rec.DESIG_NCI_CC_TYPE := P_oc_DESIG_NCI_CC_TYPE;
      v_oc_ind.DESIG_NCI_CC_TYPE := TRUE;
    END IF;

    IF P_oc_DESIG_NCI_CC_VAL   IS NULL THEN
      v_oc_ind.DESIG_NCI_CC_VAL := FALSE;
    ELSE
      v_oc_rec.DESIG_NCI_CC_VAL := P_oc_DESIG_NCI_CC_VAL;
      v_oc_ind.DESIG_NCI_CC_VAL := TRUE;
    END IF;

    IF P_oc_DESIG_UMLS_CUI_TYPE   IS NULL THEN
      v_oc_ind.DESIG_UMLS_CUI_TYPE := FALSE;
    ELSE
      v_oc_rec.DESIG_UMLS_CUI_TYPE := P_oc_DESIG_UMLS_CUI_TYPE;
      v_oc_ind.DESIG_UMLS_CUI_TYPE := TRUE;
    END IF;

    IF P_oc_DESIG_UMLS_CUI_VAL   IS NULL THEN
      v_oc_ind.DESIG_UMLS_CUI_VAL := FALSE;
    ELSE
      v_oc_rec.DESIG_UMLS_CUI_VAL := P_oc_DESIG_UMLS_CUI_VAL;
      v_oc_ind.DESIG_UMLS_CUI_VAL := TRUE;
    END IF;

    IF P_oc_DESIG_TEMP_CUI_TYPE   IS NULL THEN
      v_oc_ind.DESIG_TEMP_CUI_TYPE := FALSE;
    ELSE
      v_oc_rec.DESIG_TEMP_CUI_TYPE := P_oc_DESIG_TEMP_CUI_TYPE;
      v_oc_ind.DESIG_TEMP_CUI_TYPE := TRUE;
    END IF;

    IF P_oc_DESIG_TEMP_CUI_VAL   IS NULL THEN
      v_oc_ind.DESIG_TEMP_CUI_VAL := FALSE;
    ELSE
      v_oc_rec.DESIG_TEMP_CUI_VAL := P_oc_DESIG_TEMP_CUI_VAL;
      v_oc_ind.DESIG_TEMP_CUI_VAL := TRUE;
    END IF;*/

    BEGIN
      Cg$object_Classes_View_Ext.upd(v_oc_rec,v_oc_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_OC_502'; --Error updating OBJECT_CLASS
    END;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;

END SET_OBJECT_CLASS;

PROCEDURE SET_OC_CONDR(
  P_UA_NAME        IN  VARCHAR2
 ,P_OC_con_array           IN VARCHAR2
,P_OC_CONTE_IDSEQ            IN VARCHAR2
,P_RETURN_CODE                OUT VARCHAR2
,P_OC_OC_IDSEQ                OUT VARCHAR2
,P_OC_PREFERRED_NAME        OUT VARCHAR2
,P_OC_LONG_NAME              OUT VARCHAR2
,P_OC_PREFERRED_DEFINITION    OUT VARCHAR2
,P_OC_VERSION             OUT VARCHAR2
,P_OC_ASL_NAME            OUT VARCHAR2
,P_OC_LATEST_VERSION_IND     OUT VARCHAR2
,P_OC_CHANGE_NOTE            OUT VARCHAR2
,P_OC_ORIGIN                OUT VARCHAR2
,P_OC_DEFINITION_SOURCE      OUT VARCHAR2
,P_OC_BEGIN_DATE          OUT VARCHAR2
,P_OC_END_DATE               OUT VARCHAR2
,P_OC_DATE_CREATED            OUT VARCHAR2
,P_OC_CREATED_BY         OUT VARCHAR2
,P_OC_DATE_MODIFIED           OUT VARCHAR2
,P_OC_MODIFIED_BY             OUT VARCHAR2
,P_OC_DELETED_IND             OUT VARCHAR2
,P_OC_CONDR_IDSEQ             OUT VARCHAR2
,P_OC_ID                      OUT VARCHAR2) IS

v_Exists NUMBER;
v_Condr_idseq con_Derivation_rules_ext.condr_idseq%type;
v_Conte_idseq contexts_view.conte_idseq%type;
v_oc_oc_idseq varchar2(36);
BEGIN

  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  begin
  select conte_idseq into v_CONTE_IDSEQ
  from contexts
  where upper(name) = 'NCIP';	--GF32649
  exception when others then
   P_RETURN_CODE := 'API_PROP_001';
   RETURN;
  end;

v_condr_idseq := sbrext_common_routines.SET_DERIVATION_RULE(p_oc_con_array);

IF NOT Sbrext_Common_Routines.CONDR_EXISTS(v_condr_idseq) THEN
P_RETURN_CODE := 'Concept Derivation Rule does not exist.';
RETURN;
END IF;

IF NOT Sbrext_Common_Routines.CONTEXT_EXISTS(v_conte_idseq) THEN
P_RETURN_CODE := 'Context does not exist.';
RETURN;
END IF;


SELECT COUNT(*) INTO v_exists
FROM OBJECT_CLASSES_EXT
WHERE conte_idseq = v_conte_idseq
AND condr_idseq = v_condr_idseq;

IF v_exists = 0 THEN
admin_security_util.seteffectiveuser(p_ua_name);
Sbrext_Common_Routines.set_oc_rep_prop(v_condr_idseq
,p_return_code
,v_conte_idseq
,'OBJECTCLASS'
,p_oc_oc_idseq
,p_ua_name
);
ELSE
 begin
    SELECT oc_idseq INTO p_oc_oc_idseq
    FROM OBJECT_CLASSES_EXT
    WHERE conte_idseq = v_conte_idseq
    AND condr_idseq = v_condr_idseq
    AND LATEST_VERSION_IND = 'Yes';
 exception when too_many_rows then

   p_return_Code := sqlerrm;
   return;
 end;
END IF;

IF p_return_code IS NULL THEN
 SELECT PREFERRED_NAME
        ,LONG_NAME
        ,PREFERRED_DEFINITION
        ,VERSION
        ,ASL_NAME
        ,LATEST_VERSION_IND
        ,CHANGE_NOTE
        ,ORIGIN
        ,DEFINITION_SOURCE
        ,BEGIN_DATE
        ,END_DATE
        ,DATE_CREATED
        ,CREATED_BY
        ,DATE_MODIFIED
       ,MODIFIED_BY
        ,DELETED_IND
  ,CONDR_IDSEQ
  ,OC_ID
     INTO
    P_OC_PREFERRED_NAME
    ,P_OC_LONG_NAME
    ,P_OC_PREFERRED_DEFINITION
    ,P_OC_VERSION
    ,P_OC_ASL_NAME
    ,P_OC_LATEST_VERSION_IND
    ,P_OC_CHANGE_NOTE
    ,P_OC_ORIGIN
    ,P_OC_DEFINITION_SOURCE
    ,P_OC_BEGIN_DATE
    ,P_OC_END_DATE
    ,P_OC_DATE_CREATED
    ,P_OC_CREATED_BY
    ,P_OC_DATE_MODIFIED
    ,P_OC_MODIFIED_BY
    ,P_OC_DELETED_IND
    ,P_OC_CONDR_IDSEQ
    ,P_OC_ID
 FROM OBJECT_CLASSES_EXT
 WHERE oc_idseq = p_oc_oc_idseq;

END IF;


EXCEPTION WHEN OTHERS THEN

 dbms_output.put_line(8);
P_RETURN_CODE := SUBSTR(sqlerrm,1,255);
END;


PROCEDURE SET_PROP_CONDR(
  P_UA_NAME        IN  VARCHAR2
 ,P_PROP_con_array           IN VARCHAR2
,P_PROP_CONTE_IDSEQ            IN VARCHAR2
,P_RETURN_CODE                OUT VARCHAR2
,P_PROP_PROP_IDSEQ                OUT VARCHAR2
,P_PROP_PREFERRED_NAME        OUT VARCHAR2
,P_PROP_LONG_NAME              OUT VARCHAR2
,P_PROP_PREFERRED_DEFINITION    OUT VARCHAR2
,P_PROP_VERSION             OUT VARCHAR2
,P_PROP_ASL_NAME            OUT VARCHAR2
,P_PROP_LATEST_VERSION_IND     OUT VARCHAR2
,P_PROP_CHANGE_NOTE            OUT VARCHAR2
,P_PROP_ORIGIN                OUT VARCHAR2
,P_PROP_DEFINITION_SOURCE      OUT VARCHAR2
,P_PROP_BEGIN_DATE          OUT VARCHAR2
,P_PROP_END_DATE               OUT VARCHAR2
,P_PROP_DATE_CREATED            OUT VARCHAR2
,P_PROP_CREATED_BY         OUT VARCHAR2
,P_PROP_DATE_MODIFIED           OUT VARCHAR2
,P_PROP_MODIFIED_BY             OUT VARCHAR2
,P_PROP_DELETED_IND             OUT VARCHAR2
,P_PROP_CONDR_IDSEQ             OUT VARCHAR2
,P_PROP_ID             OUT VARCHAR2) IS

v_Exists number;
v_Condr_idseq con_Derivation_rules_ext.condr_idseq%type;
v_Conte_idseq contexts_view.conte_idseq%type;
BEGIN

  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  begin
  select conte_idseq into v_CONTE_IDSEQ
  from contexts
  where upper(name) = 'NCIP';	--GF32649
  exception when others then
   P_RETURN_CODE := 'API_PROP_001';
   RETURN;
  end;
v_condr_idseq := sbrext_common_routines.SET_DERIVATION_RULE(p_prop_con_array);
dbms_output.put_line('v_condr_idseq: '||v_condr_idseq);

IF NOT Sbrext_Common_Routines.CONDR_EXISTS(v_condr_idseq) THEN
P_RETURN_CODE := 'Concept Derivation Rule does not exist.';
RETURN;
END IF;

IF NOT Sbrext_Common_Routines.CONTEXT_EXISTS(v_conte_idseq) THEN
P_RETURN_CODE := 'Context does not exist.';
RETURN;
END IF;

SELECT COUNT(*) INTO v_Exists
FROM PROPERTIES_EXT
WHERE conte_idseq = v_conte_idseq
AND condr_idseq = v_condr_idseq;

dbms_output.put_line('v_Exists: '||to_char(v_exists));

IF v_exists = 0 THEN

admin_security_util.seteffectiveuser(p_ua_name);

Sbrext_Common_Routines.set_oc_rep_prop(v_condr_idseq
,p_return_code
,v_conte_idseq
,'PROPERTY'
,p_PROP_PROP_idseq
,p_ua_name
);
  dbms_output.put_line('p return code 01: '||p_return_code);
ELSE
  begin
    SELECT prop_idseq INTO p_prop_prop_idseq
    FROM PROPERTIES_EXT
    WHERE conte_idseq = v_conte_idseq
    AND condr_idseq = v_condr_idseq
    AND LATEST_VERSION_IND = 'Yes';
 dbms_output.put_line('p_prop_prop_idseq: '||p_prop_prop_idseq);
 exception when too_many_rows then
   p_return_Code := sqlerrm;
   return;
 end;
END IF;
dbms_output.put_line('p_return_code 02: '||p_return_code);
IF p_return_code IS NULL THEN
 SELECT PREFERRED_NAME
        ,LONG_NAME
        ,PREFERRED_DEFINITION
        ,VERSION
        ,ASL_NAME
        ,LATEST_VERSION_IND
        ,CHANGE_NOTE
        ,ORIGIN
        ,DEFINITION_SOURCE
        ,BEGIN_DATE
        ,END_DATE
        ,DATE_CREATED
        ,CREATED_BY
        ,DATE_MODIFIED
        ,MODIFIED_BY
        ,DELETED_IND
  ,condr_idseq
  ,prop_id
     INTO
    P_PROP_PREFERRED_NAME
    ,P_PROP_LONG_NAME
    ,P_PROP_PREFERRED_DEFINITION
    ,P_PROP_VERSION
    ,P_PROP_ASL_NAME
    ,P_PROP_LATEST_VERSION_IND
    ,P_PROP_CHANGE_NOTE
    ,P_PROP_ORIGIN
    ,P_PROP_DEFINITION_SOURCE
    ,P_PROP_BEGIN_DATE
    ,P_PROP_END_DATE
    ,P_PROP_DATE_CREATED
    ,P_PROP_CREATED_BY
    ,P_PROP_DATE_MODIFIED
    ,P_PROP_MODIFIED_BY
    ,P_PROP_DELETED_IND
    ,P_PROP_CONDR_IDSEQ
    ,P_PROP_ID
 FROM PROPERTIES_EXT
 WHERE PROP_idseq = p_PROP_PROP_idseq;
END IF;
EXCEPTION WHEN OTHERS THEN
P_RETURN_CODE := 'Error Creating Property';

END;
PROCEDURE SET_CONCEPT(
P_UA_NAME       IN VARCHAR2
,P_RETURN_CODE              OUT VARCHAR2
,P_ACTION         IN VARCHAR2
,P_CON_IDSEQ             OUT VARCHAR2
,P_CON_PREFERRED_NAME   IN OUT VARCHAR2
,P_CON_LONG_NAME               IN OUT VARCHAR2
,P_CON_PREFERRED_DEFINITION    IN OUT VARCHAR2
,P_CON_CONTE_IDSEQ         IN OUT VARCHAR2
,P_CON_VERSION         IN OUT VARCHAR2
,P_CON_ASL_NAME        IN OUT VARCHAR2
,P_CON_LATEST_VERSION_IND   IN OUT VARCHAR2
,P_CON_CHANGE_NOTE      IN OUT VARCHAR2
,P_CON_ORIGIN   IN OUT VARCHAR2
,P_CON_DEFINITION_SOURCE      IN OUT VARCHAR2
,P_CON_EVS_SOURCE      IN OUT VARCHAR2
,P_CON_BEGIN_DATE      IN OUT VARCHAR2
,P_CON_END_DATE                IN OUT VARCHAR2
,P_CON_DATE_CREATED            OUT VARCHAR2
,P_CON_CREATED_BY       OUT VARCHAR2
,P_CON_DATE_MODIFIED           OUT VARCHAR2
,P_CON_MODIFIED_BY             OUT VARCHAR2
,P_CON_DELETED_IND             OUT VARCHAR2)
IS
/******************************************************************************
   NAME:       SET_CONCEPT
   PURPOSE:    Inserts or Updates a Single Row Of concepts_ext based on either


   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
  3.0      12/09/2004     Prerna Aggarwal       1. Created this procedure

******************************************************************************/


v_con_rec  Cg$concepts_View_Ext.cg$row_type;
v_con_ind  Cg$concepts_View_Ext.cg$ind_type;

v_begin_date   DATE    := NULL;
v_end_date     DATE    := NULL;
v_new_Version  BOOLEAN := FALSE;

v_version  concepts_view_ext.version%TYPE;
v_asl_name concepts_view_ext.asl_name%TYPE;

v_Count number;
v_conte_idseq contexts.conte_idseq%type;

BEGIN

  P_RETURN_CODE := NULL;

  IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
    P_RETURN_CODE := 'API_CON_700'; -- Invalid action
    RETURN;
  END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  IF P_ACTION = 'INS' THEN              --we are inserting a record
    IF P_CON_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_CON_100' ;  --for inserts the ID IS generated
   RETURN;
    ELSE
      --Check to see that all mandatory parameters are not null
   IF P_CON_PREFERRED_NAME IS NULL THEN
     P_RETURN_CODE := 'API_CON_102'; --PREFERRED_NAME cannot be null here
  RETURN;
   END IF;
   IF P_CON_PREFERRED_DEFINITION IS NULL THEN
     P_RETURN_CODE := 'API_CON_104'; --PREFERRED_DEFINITION cannot be null here
  RETURN;
   END IF;
   begin
    select conte_idseq into p_Con_Conte_idseq
    from contexts
    where upper(name) = 'NCIP';	--GF32649
   exception when no_data_found then
     P_RETURN_CODE := 'API_CON_106';  --CONTEXT_NAME cannot be null here
  RETURN;
  end;
    END IF;
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are deleting a record

    IF P_CON_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_CON_400' ;  --for deleted the ID idmandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ac_exists(P_CON_IDSEQ) THEN
     P_RETURN_CODE := 'API_CON_005'; --PROPERTY not found
     RETURN;
   END IF;
    END IF;

    P_CON_DELETED_IND   := 'Yes';
    P_CON_MODIFIED_BY   := P_UA_NAME; --USER;
    P_CON_DATE_MODIFIED := TO_CHAR(SYSDATE);

    v_con_rec.con_idseq         := P_CON_IDSEQ;
    v_con_rec.deleted_ind        := P_CON_DELETED_IND;
    v_con_rec.modified_by        := P_CON_MODIFIED_BY;
    v_con_rec.date_modified      := TO_DATE(P_CON_DATE_MODIFIED);
    v_con_rec.latest_version_ind := P_CON_LATEST_VERSION_IND;

    v_con_ind.con_idseq         := TRUE;
    v_con_ind.preferred_name     := FALSE;
    v_con_ind.conte_idseq         := FALSE;
    v_con_ind.version             := FALSE;
    v_con_ind.preferred_definition := FALSE;
    v_con_ind.long_name         := FALSE;
    v_con_ind.asl_name             := FALSE;
    v_con_ind.latest_version_ind   := FALSE;
    v_con_ind.begin_date         := FALSE;
    v_con_ind.end_date             := FALSE;
    v_con_ind.change_note         := FALSE;
    v_con_ind.created_by         := FALSE;
    v_con_ind.date_created         := FALSE;
 v_con_ind.origin               := FALSE;  -- 23-Jul-2003, W. Ver Hoef
    v_con_ind.modified_by         := TRUE;
    v_con_ind.date_modified     := TRUE;
    v_con_ind.deleted_ind          := TRUE;

    BEGIN
      Cg$concepts_View_Ext.upd(v_con_rec,v_con_ind);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_CON_501'; --Error deleteing PROPERTY
    END;

  END IF;

  IF P_ACTION = 'UPD' THEN              --we are updating a record
    admin_security_util.seteffectiveuser(p_ua_name);
    IF P_CON_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_CON_400' ;  --for updates the ID IS mandatory
   RETURN;
    END IF;
    SELECT asl_name
    INTO   v_asl_name
    FROM   CONCEPTS_EXT
    WHERE  con_idseq = p_con_idseq;
    IF (P_CON_PREFERRED_NAME IS NOT NULL OR P_CON_CONTE_IDSEQ IS NOT NULL) AND v_asl_name = 'RELEASED' THEN
      P_RETURN_CODE := 'API_CON_401' ;  --Preferred Name or Context Can not be updated
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(P_CON_IDSEQ) THEN
      P_RETURN_CODE := 'API_CON_005'; --CON_IDSEQ not found
      RETURN;
    END IF;
  END IF;

  IF P_CON_LATEST_VERSION_IND IS NOT NULL THEN
    IF P_CON_LATEST_VERSION_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_CON_105'; --Version can only be 'Yes' or 'No'
      RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
  IF LENGTH(P_CON_PREFERRED_NAME) > Sbrext_Column_Lengths.L_CON_PREFERRED_NAME THEN
    P_RETURN_CODE := 'API_CON_111';  --Length of preferred_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_CON_PREFERRED_DEFINITION) > Sbrext_Column_Lengths.L_CON_PREFERRED_DEFINITION THEN
    P_RETURN_CODE := 'API_CON_113';  --Length of Preferred_definition exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_CON_LONG_NAME) > Sbrext_Column_Lengths.L_CON_LONG_NAME THEN
    P_RETURN_CODE := 'API_CON_114'; --Length of Long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_CON_ASL_NAME) > Sbrext_Column_Lengths.L_CON_ASL_NAME  THEN
    P_RETURN_CODE := 'API_CON_115'; --Length of asl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_CON_CHANGE_NOTE) > Sbrext_Column_Lengths.L_CON_CHANGE_NOTE THEN
    P_RETURN_CODE := 'API_CON_128'; --Length of change_note exceeds maximum length
    RETURN;
  END IF;

  IF LENGTH(P_CON_ORIGIN) > sbrext_column_lengths.L_CON_ORIGIN THEN
    P_RETURN_CODE := 'API_CON_129'; --Length of origin exceeds maximum length
    RETURN;
  END IF;

  IF LENGTH(P_CON_DEFINITION_SOURCE) > sbrext_column_lengths.L_CON_ORIGIN THEN
    P_RETURN_CODE := 'API_CON_141'; --Length of definition_source exceeds maximum length
    RETURN;
  END IF;

  IF LENGTH(P_CON_EVS_SOURCE) > sbrext_column_lengths.L_CON_EVS_SOURCE THEN
    P_RETURN_CODE := 'API_CON_142'; --Length of evs_source exceeds maximum length
    RETURN;
  END IF;

  --check to see that charachter strings are valid
  IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_CON_PREFERRED_NAME) THEN
    P_RETURN_CODE := 'API_CON_130'; -- Data Element Preferred Name has invalid Ccharacters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_CON_PREFERRED_DEFINITION) THEN
    P_RETURN_CODE := 'API_CON_133'; -- Data Element Preferred Definition has invalid characters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_CON_LONG_NAME) THEN
    P_RETURN_CODE := 'API_CON_134'; -- Data Element Long Name has invalid characters
    RETURN;
  END IF;

  --check to see that Context, Workflow Status, Data Element Concept, Value Domain already exist in the database
  IF P_CON_CONTE_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.context_exists(P_CON_CONTE_IDSEQ) THEN
      P_RETURN_CODE := 'API_CON_200'; --Context not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_CON_ASL_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.workflow_exists(P_CON_ASL_NAME) THEN
      P_RETURN_CODE := 'API_CON_202'; --Workflow Status not found in the database
      RETURN;
    END IF;
  END IF;

  --check to see that begin data and end date are valid dates
  IF(P_CON_BEGIN_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_CON_BEGIN_DATE,v_begin_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_CON_600'; --begin date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_CON_END_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_CON_END_DATE,v_end_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_CON_601'; --end date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_CON_BEGIN_DATE IS NOT NULL AND P_CON_END_DATE IS NOT NULL) THEN
    IF(v_end_date < v_begin_date) THEN
      P_RETURN_CODE := 'API_CON_210'; --end date is before begin date
      RETURN;
    END IF;
  ELSIF(P_CON_END_DATE IS NOT NULL AND P_CON_BEGIN_DATE IS NULL) THEN
    P_RETURN_CODE := 'API_CON_211'; --begin date cannot be null when end date is null
    RETURN;
  END IF;

  IF (P_ACTION = 'INS' ) THEN

    P_CON_IDSEQ         := admincomponent_crud.cmr_guid;
    P_CON_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_CON_CREATED_BY    := P_UA_NAME; --USER;
    P_CON_DATE_MODIFIED := NULL;
    P_CON_MODIFIED_BY   := NULL;
    IF P_CON_VERSION IS NULL THEN
      P_CON_VERSION := 1;
    END IF;
    IF P_CON_ASL_NAME IS NULL THEN
   -- 19-Mar-2004, W. Ver Hoef - substituted UNASSIGNED with function call below
      P_CON_ASL_NAME := Sbrext_Common_Routines.get_default_asl('INS'); -- 'UNASSIGNED';
    END IF;

 select count(*) into v_count
 from concepts_Ext
 where preferred_name = p_CON_PREFERRED_NAME
 and version = p_con_Version
 and conte_idseq = p_con_conte_idseq;

 if v_count <> 0 then
   P_RETURN_CODE := 'API_CON_550'; -- unique constraint violeted;
   RETURN;
 end if;



    v_con_rec.con_idseq           := P_CON_IDSEQ;
    v_con_rec.preferred_name       := P_CON_PREFERRED_NAME;
    v_con_rec.PREFERRED_DEFINITION := P_CON_PREFERRED_DEFINITION;
    v_con_rec.created_by         := P_CON_CREATED_BY; --USER
    v_con_rec.date_created         := SYSDATE;
    v_con_rec.modified_by         := NULL;
    v_con_rec.date_modified        := NULL;
    v_con_rec.long_name            := P_CON_LONG_NAME;
    v_con_rec.conte_idseq          := P_CON_CONTE_IDSEQ;
    v_con_rec.version              := P_CON_VERSION;
    v_con_rec.asl_name             := P_CON_ASL_NAME;
    v_con_rec.latest_version_ind   := 'Yes';
    v_con_rec.change_note          := NULL;
    v_con_rec.begin_date           := NULL;
    v_con_rec.end_date             := NULL;
    v_con_rec.deleted_ind          := 'No';
    v_con_rec.definition_source    := P_CON_DEFINITION_SOURCE;
    v_con_rec.origin               := P_CON_ORIGIN;
    v_con_rec.evs_Source           := P_CON_EVS_SOURCE ;

    v_con_ind.con_idseq           := TRUE;
    v_con_ind.preferred_name       := TRUE;
    v_con_ind.PREFERRED_DEFINITION := TRUE;
    v_con_ind.created_by           := TRUE;
    v_con_ind.date_created         := TRUE;
    v_con_ind.modified_by         := TRUE;
    v_con_ind.date_modified        := TRUE;
    v_con_ind.long_name            := TRUE;
    v_con_ind.conte_idseq          := TRUE;
    v_con_ind.version              := TRUE;
    v_con_ind.asl_name             := TRUE;
    v_con_ind.latest_version_ind   := TRUE;
    v_con_ind.change_note          := TRUE;
    v_con_ind.begin_date           := TRUE;
    v_con_ind.end_date             := TRUE;
    v_con_ind.deleted_ind          := TRUE;
    v_con_ind.definition_source    := TRUE;
    v_con_ind.origin               := TRUE;
    v_con_ind.evs_source    := TRUE;
    BEGIN
      Cg$concepts_View_Ext.ins(v_con_rec,v_con_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := SQLERRM; --Error inserting CONCEPTS_VIEW_EXT
    END;

  END IF;

  IF (P_ACTION = 'UPD' ) THEN

    --Get the version for the P_CON_IDSEQ
    SELECT version
 INTO   v_version
    FROM   concepts_view_ext
    WHERE  con_idseq = P_CON_IDSEQ;

    IF v_version <> P_CON_VERSION THEN
      P_RETURN_CODE := 'API_CON_402'; -- Version can NOT be updated. It can only be created
      RETURN;
    END IF;

    P_CON_DATE_MODIFIED := TO_CHAR(SYSDATE);
    P_CON_MODIFIED_BY := P_UA_NAME; --USER;
    P_CON_DELETED_IND := 'No';

    v_con_rec.date_modified := TO_DATE(P_CON_DATE_MODIFIED);
    v_con_rec.modified_by   := P_CON_MODIFIED_BY;
    v_con_rec.con_idseq    := P_CON_IDSEQ;
    v_con_rec.deleted_ind   := 'No';

    v_con_ind.date_modified := TRUE;
    v_con_ind.modified_by   := TRUE;
    v_con_ind.deleted_ind   := TRUE;
    v_con_ind.con_idseq    := TRUE;

    v_con_ind.version       := FALSE;
    v_con_ind.created_by  := FALSE;
    v_con_ind.date_created  := FALSE;

    IF P_CON_PREFERRED_NAME IS NULL THEN
      v_con_ind.preferred_name := FALSE;
    ELSE
      v_con_rec.preferred_name := P_CON_PREFERRED_NAME;
      v_con_ind.preferred_name := TRUE;
    END IF;

    IF P_CON_CONTE_IDSEQ IS NULL THEN
      v_con_ind.conte_idseq := FALSE;
    ELSE
      v_con_rec.conte_idseq := P_CON_CONTE_IDSEQ;
      v_con_ind.conte_idseq := TRUE;
    END IF;

    IF P_CON_PREFERRED_DEFINITION IS NULL THEN
      v_con_ind.preferred_definition := FALSE; /***/
    ELSE
      v_con_rec.preferred_definition := P_CON_PREFERRED_DEFINITION;
      v_con_ind.preferred_definition := TRUE;
    END IF;

    IF P_CON_LONG_NAME IS NULL THEN
      v_con_ind.long_name := FALSE;
    ELSE
      v_con_rec.long_name := P_CON_LONG_NAME;
      v_con_ind.long_name := TRUE;
    END IF;

    IF P_CON_ASL_NAME IS NULL THEN
      v_con_ind.asl_name := FALSE;
    ELSE
      v_con_rec.asl_name := P_CON_ASL_NAME;
      v_con_ind.asl_name := TRUE;
    END IF;

    IF P_CON_LATEST_VERSION_IND IS NULL THEN
      v_con_ind.latest_version_ind := FALSE;
    ELSE
      v_con_rec.latest_version_ind := P_CON_LATEST_VERSION_IND;
      v_con_ind.latest_version_ind := TRUE;
    END IF;

    IF P_CON_BEGIN_DATE IS NULL THEN
      v_con_ind.begin_date := FALSE;
    ELSE
      v_con_rec.begin_date := TO_DATE(P_CON_BEGIN_DATE);
      v_con_ind.begin_date := TRUE;
    END IF;

    IF P_CON_END_DATE  IS NULL THEN
      v_con_ind.end_date := FALSE;
    ELSE
      v_con_rec.end_date := TO_DATE(P_CON_END_DATE);
      v_con_ind.end_date := TRUE;
    END IF;

    IF P_CON_CHANGE_NOTE   IS NULL THEN
      v_con_ind.change_note := FALSE;
    ELSE
      v_con_rec.change_note := P_CON_CHANGE_NOTE;
      v_con_ind.change_note := TRUE;
    END IF;

    IF P_CON_DEFINITION_SOURCE IS NULL THEN
      v_con_ind.definition_source := FALSE;
    ELSE
      v_con_rec.definition_source := P_CON_DEFINITION_SOURCE;
      v_con_ind.definition_source := TRUE;
    END IF;

    IF P_CON_ORIGIN IS NULL THEN
      v_con_ind.origin := FALSE;
    ELSE
      v_con_rec.origin := P_CON_ORIGIN;
      v_con_ind.origin := TRUE;
    END IF;

    IF P_CON_EVS_SOURCE   IS NULL THEN
      v_con_ind.evs_source := FALSE;
    ELSE
      v_con_rec.evs_source := P_CON_EVS_SOURCE;
      v_con_ind.evs_source := TRUE;
    END IF;
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;

END SET_CONCEPT;

PROCEDURE SET_representation(
P_UA_NAME       IN VARCHAR2
,P_RETURN_CODE                  OUT VARCHAR2
,P_ACTION                    IN     VARCHAR2
,P_REP_IDSEQ             IN OUT VARCHAR2
,P_REP_PREFERRED_NAME        IN OUT VARCHAR2
,P_REP_LONG_NAME             IN OUT VARCHAR2
,P_REP_PREFERRED_DEFINITION  IN OUT VARCHAR2
,P_REP_CONTE_IDSEQ           IN OUT VARCHAR2
,P_REP_VERSION               IN OUT VARCHAR2
,P_REP_ASL_NAME              IN OUT VARCHAR2
,P_REP_LATEST_VERSION_IND    IN OUT VARCHAR2
,P_REP_CHANGE_NOTE           IN OUT VARCHAR2
,P_REP_ORIGIN                IN OUT VARCHAR2
,P_REP_DEFINITION_SOURCE     IN OUT VARCHAR2
,P_REP_BEGIN_DATE            IN OUT VARCHAR2
,P_REP_END_DATE              IN OUT VARCHAR2
,P_REP_DATE_CREATED             OUT VARCHAR2
,P_REP_CREATED_BY               OUT VARCHAR2
,P_REP_DATE_MODIFIED            OUT VARCHAR2
,P_REP_MODIFIED_BY              OUT VARCHAR2
,P_REP_DELETED_IND              OUT VARCHAR2
,P_REP_DESIG_NCI_CC_TYPE     IN     VARCHAR2
,P_REP_DESIG_NCI_CC_VAL      IN     VARCHAR2
,P_REP_DESIG_UMLS_CUI_TYPE   IN     VARCHAR2
,P_REP_DESIG_UMLS_CUI_VAL    IN     VARCHAR2
,P_REP_DESIG_TEMP_CUI_TYPE   IN     VARCHAR2
,P_REP_DESIG_TEMP_CUI_VAL    IN     VARCHAR2
)
IS
/******************************************************************************
   NAME:       SET_representation
   PURPOSE:    Inserts or Updates a Single Row Of reperties_ext based on either


   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04/08/2003  Prerna Aggarwal  1. Created this procedure
   2.0        07/10/2003  W. Ver Hoef      1. Edited for readability but changes
                                              required for SPRF_2.0_15 have already
             been made to sbrext_common_routines
             valid_alphanumeric and valid_char.
   2.0        07/23/2003  W. Ver Hoef      1. added v_rep_ind.origin := FALSE
                                              for DEL action
   2.1        03/19/2004  W. Ver Hoef      1. substituted UNASSIGNED with function
                                              call to get_default_asl

******************************************************************************/

v_rep_rec  Cg$representations_View_Ext.cg$row_type;
v_rep_ind  Cg$representations_View_Ext.cg$ind_type;

v_begin_date   DATE := NULL;
v_end_date     DATE := NULL;
v_new_Version  BOOLEAN := FALSE;

v_version   representations_view_ext.version%TYPE;
v_asl_name  representations_view_ext.asl_name%TYPE;

BEGIN
  P_RETURN_CODE := NULL;

  IF P_ACTION NOT IN ('INS','UPD','DEL') THEN
    P_RETURN_CODE := 'API_REP_700'; -- Invalid action
    RETURN;
  END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  IF P_ACTION = 'INS' THEN              --we are inserting a record
    IF P_REP_IDSEQ IS NOT NULL THEN
      P_RETURN_CODE := 'API_REP_100' ;  --for inserts the ID IS generated
   RETURN;
    ELSE
      --Check to see that all mandatory parameters are not null
   IF P_REP_PREFERRED_NAME IS NULL THEN
     P_RETURN_CODE := 'API_REP_102'; --PREFERRED_NAME cannot be null here
  RETURN;
   END IF;
   IF P_REP_PREFERRED_DEFINITION IS NULL THEN
     P_RETURN_CODE := 'API_REP_104'; --PREFERRED_DEFINITION cannot be null here
  RETURN;
   END IF;
   IF P_REP_CONTE_IDSEQ IS NULL THEN
     P_RETURN_CODE := 'API_REP_106';  --CONTEXT_NAME cannot be null here
  RETURN;
   END IF;
    END IF;
  END IF;

  IF P_ACTION = 'DEL' THEN              --we are deleting a record

    IF P_REP_IDSEQ IS NULL THEN
      P_RETURN_CODE := 'API_REP_400' ;  --for deleting the ID is mandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ac_exists(P_REP_IDSEQ) THEN
     P_RETURN_CODE := 'API_REP_005'; --representation not found
     RETURN;
   END IF;
    END IF;

    P_REP_DELETED_IND            := 'Yes';
    P_REP_MODIFIED_BY            := P_UA_NAME; --USER;
    P_REP_DATE_MODIFIED          := TO_CHAR(SYSDATE);

    v_rep_rec.rep_idseq          := P_REP_IDSEQ;
    v_rep_rec.deleted_ind        := P_REP_DELETED_IND;
    v_rep_rec.modified_by        := P_REP_MODIFIED_BY;
    v_rep_rec.date_modified      := TO_DATE(P_REP_DATE_MODIFIED);
    v_rep_rec.latest_version_ind := P_REP_LATEST_VERSION_IND;

    v_rep_ind.rep_idseq            := TRUE;
    v_rep_ind.preferred_name       := FALSE;
    v_rep_ind.conte_idseq          := FALSE;
    v_rep_ind.version              := FALSE;
    v_rep_ind.preferred_definition := FALSE;
    v_rep_ind.long_name            := FALSE;
    v_rep_ind.asl_name             := FALSE;
    v_rep_ind.latest_version_ind   := FALSE;
    v_rep_ind.begin_date           := FALSE;
    v_rep_ind.end_date             := FALSE;
    v_rep_ind.change_note          := FALSE;
    v_rep_ind.created_by           := FALSE;
    v_rep_ind.date_created         := FALSE;
 v_rep_ind.origin               := FALSE; -- 23-Jul-2003, W. Ver Hoef
    v_rep_ind.modified_by          := TRUE;
    v_rep_ind.date_modified        := TRUE;
    v_rep_ind.deleted_ind          := TRUE;

    BEGIN
      Cg$representations_View_Ext.upd(v_rep_rec,v_rep_ind);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
dbms_output.put_line('SQLERRM = '||SQLERRM);
      P_RETURN_CODE := 'API_REP_501'; --Error deleteing representation
    END;

  END IF;

  IF P_ACTION = 'UPD' THEN              --we are updating a record
    admin_security_util.seteffectiveuser(p_ua_name);
    IF P_REP_IDSEQ IS  NULL THEN
      P_RETURN_CODE := 'API_REP_400' ;  --for updates the ID IS mandatory
   RETURN;
    END IF;
    SELECT asl_name
 INTO v_asl_name
    FROM representations_view_ext
    WHERE rep_idseq = p_rep_idseq;
    IF (P_REP_PREFERRED_NAME IS NOT NULL OR P_REP_CONTE_IDSEQ IS NOT NULL) AND v_Asl_name = 'RELEASED' THEN
      P_RETURN_CODE := 'API_REP_401' ;  --Preferred Name or Context Can not be updated
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(P_REP_IDSEQ) THEN
      P_RETURN_CODE := 'API_REP_005'; --rep_IDSEQ not found
      RETURN;
    END IF;
  END IF;

  IF P_REP_LATEST_VERSION_IND IS NOT NULL THEN
    IF P_REP_LATEST_VERSION_IND NOT IN ('Yes','No') THEN
      P_RETURN_CODE := 'API_REP_105'; --Version can only be 'Yes' or 'No'
      RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and VARCHAR2 parameters have correct length
  IF LENGTH(P_REP_PREFERRED_NAME) > Sbrext_Column_Lengths.L_REP_PREFERRED_NAME THEN
    P_RETURN_CODE := 'API_REP_111';  --Length of preferred_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_REP_PREFERRED_DEFINITION) > Sbrext_Column_Lengths.L_REP_PREFERRED_DEFINITION THEN
    P_RETURN_CODE := 'API_REP_113';  --Length of Preferred_definition exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_REP_LONG_NAME) > Sbrext_Column_Lengths.L_REP_LONG_NAME THEN
    P_RETURN_CODE := 'API_REP_114'; --Length of Long_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_REP_ASL_NAME) > Sbrext_Column_Lengths.L_REP_ASL_NAME  THEN
    P_RETURN_CODE := 'API_REP_115'; --Length of asl_name exceeds maximum length
    RETURN;
  END IF;
  IF LENGTH(P_REP_CHANGE_NOTE) > Sbrext_Column_Lengths.L_REP_CHANGE_NOTE THEN
    P_RETURN_CODE := 'API_REP_128'; --Length of change_note exceeds maximum length
    RETURN;
  END IF;

  --check to see that charachter strings are valid
  IF NOT Sbrext_Common_Routines.valid_alphanumeric(P_REP_PREFERRED_NAME) THEN
    P_RETURN_CODE := 'API_REP_130'; -- Data Element Preferred Name has invalid Ccharacters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_REP_PREFERRED_DEFINITION) THEN
    P_RETURN_CODE := 'API_REP_133'; -- Data Element Preferred Definition has invalid characters
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(P_REP_LONG_NAME) THEN
    P_RETURN_CODE := 'API_REP_134'; -- Data Element Long Name has invalid characters
    RETURN;
  END IF;

  --check to see that Context, Workflow Status, Data Element Concept, Value Domain already exist in the database
  IF P_REP_CONTE_IDSEQ IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.context_exists(P_REP_CONTE_IDSEQ) THEN
      P_RETURN_CODE := 'API_REP_200'; --Context not found in the database
      RETURN;
    END IF;
  END IF;
  IF P_REP_ASL_NAME IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.workflow_exists(P_REP_ASL_NAME) THEN
      P_RETURN_CODE := 'API_REP_202'; --Workflow Status not found in the database
      RETURN;
    END IF;
  END IF;

  --check to see that begin data and end date are valid dates
  IF(P_REP_BEGIN_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_REP_BEGIN_DATE,v_begin_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_REP_600'; --begin date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_REP_END_DATE IS NOT NULL) THEN
    Sbrext_Common_Routines.valid_date(P_RETURN_CODE,P_REP_END_DATE,v_end_date);
    IF P_RETURN_CODE IS NOT NULL THEN
      P_RETURN_CODE := 'API_REP_601'; --end date is invalid
      RETURN;
    END IF;
  END IF;
  IF(P_REP_BEGIN_DATE IS NOT NULL AND P_REP_END_DATE IS NOT NULL) THEN
    IF(v_end_date < v_begin_date) THEN
      P_RETURN_CODE := 'API_REP_210'; --end date is before begin date
      RETURN;
    END IF;
  ELSIF(P_REP_END_DATE IS NOT NULL AND P_REP_BEGIN_DATE IS NULL) THEN
    P_RETURN_CODE := 'API_REP_211'; --begin date cannot be null when end date is null
    RETURN;
  END IF;

  IF (P_ACTION = 'INS' ) THEN

    P_REP_IDSEQ         := admincomponent_crud.cmr_guid;
    P_REP_DATE_CREATED  := TO_CHAR(SYSDATE);
    P_REP_CREATED_BY    := P_UA_NAME; --USER;
    P_REP_DATE_MODIFIED := NULL;
    P_REP_MODIFIED_BY   := NULL;

    IF P_REP_VERSION IS NULL THEN
      P_REP_VERSION := 1;
    END IF;
    IF P_REP_ASL_NAME IS NULL THEN
   -- 19-Mar-2004, W. Ver Hoef - substituted UNASSIGNED with function call below
      P_REP_ASL_NAME := Sbrext_Common_Routines.get_default_asl('INS'); -- 'UNASSIGNED';
    END IF;

    v_rep_rec.rep_idseq            := P_REP_IDSEQ;
    v_rep_rec.preferred_name       := P_REP_PREFERRED_NAME;
    v_rep_rec.PREFERRED_DEFINITION := P_REP_PREFERRED_DEFINITION;
    v_rep_rec.created_by        :=  P_REP_CREATED_BY;
    v_rep_rec.date_created        := SYSDATE;
    v_rep_rec.modified_by        := NULL;
    v_rep_rec.date_modified        := NULL;
    v_rep_rec.long_name            := P_REP_LONG_NAME;
    v_rep_rec.conte_idseq          := P_REP_CONTE_IDSEQ;
    v_rep_rec.version              := P_REP_VERSION;
    v_rep_rec.asl_name             := P_REP_ASL_NAME;
    v_rep_rec.latest_version_ind   := 'Yes';
    v_rep_rec.change_note          := NULL;
    v_rep_rec.begin_date           := NULL;
    v_rep_rec.end_date             := NULL;
    v_rep_rec.deleted_ind          := 'No';
    /*v_rep_rec.DESIG_NCI_CC_TYPE    := P_rep_DESIG_NCI_CC_TYPE ;
    v_rep_rec.DESIG_NCI_CC_VAL     := P_rep_DESIG_NCI_CC_VAL ;
    v_rep_rec.DESIG_UMLS_CUI_TYPE  := P_rep_DESIG_UMLS_CUI_TYPE ;
    v_rep_rec.DESIG_UMLS_CUI_VAL   := P_rep_DESIG_UMLS_CUI_VAL ;
    v_rep_rec.DESIG_TEMP_CUI_TYPE  := P_rep_DESIG_TEMP_CUI_TYPE ;
    v_rep_rec.DESIG_TEMP_CUI_VAL   := P_rep_DESIG_TEMP_CUI_VAL ;
    v_rep_rec.definition_source    := P_REP_DEFINITION_SOURCE;*/
    v_rep_rec.origin               := P_REP_ORIGIN;

    v_rep_ind.rep_idseq            := TRUE;
    v_rep_ind.preferred_name       := TRUE;
    v_rep_ind.PREFERRED_DEFINITION := TRUE;
    v_rep_ind.created_by           := TRUE;
    v_rep_ind.date_created         := TRUE;
    v_rep_ind.modified_by          := TRUE;
    v_rep_ind.date_modified        := TRUE;
    v_rep_ind.long_name            := TRUE;
    v_rep_ind.conte_idseq          := TRUE;
    v_rep_ind.version              := TRUE;
    v_rep_ind.asl_name             := TRUE;
    v_rep_ind.latest_version_ind   := TRUE;
    v_rep_ind.change_note          := TRUE;
    v_rep_ind.begin_date           := TRUE;
    v_rep_ind.end_date             := TRUE;
    v_rep_ind.deleted_ind          := TRUE;
   /* v_rep_ind.DESIG_NCI_CC_TYPE    := TRUE;
    v_rep_ind.DESIG_NCI_CC_VAL     := TRUE;
    v_rep_ind.DESIG_UMLS_CUI_TYPE  := TRUE;
    v_rep_ind.DESIG_UMLS_CUI_VAL   := TRUE;
    v_rep_ind.DESIG_TEMP_CUI_TYPE  := TRUE;
    v_rep_ind.DESIG_TEMP_CUI_VAL   := TRUE ;
    v_rep_ind.definition_source    := TRUE;
    v_rep_ind.origin               := TRUE;*/

    BEGIN
      Cg$representations_View_Ext.ins(v_rep_rec,v_rep_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_REP_500'; --Error inserting REPRESENTATION_VIEW_EXT
    END;
  END IF;

  IF (P_ACTION = 'UPD' ) THEN

    --Get the version for the P_REP_IDSEQ
    SELECT version INTO v_version
    FROM REPRESENTATIONS_VIEW_EXT
    WHERE rep_idseq = P_REP_IDSEQ;

    IF v_version <> P_REP_VERSION THEN
      P_RETURN_CODE := 'API_REP_402'; -- Version can NOT be updated. It can only be created
      RETURN;
    END IF;

    P_REP_DATE_MODIFIED     := TO_CHAR(SYSDATE);
    P_REP_MODIFIED_BY       := P_UA_NAME; --USER;
    P_REP_DELETED_IND       := 'No';

    v_rep_rec.date_modified := TO_DATE(P_REP_DATE_MODIFIED);
    v_rep_rec.modified_by   := P_REP_MODIFIED_BY;
    v_rep_rec.rep_idseq     := P_REP_IDSEQ;
    v_rep_rec.deleted_ind   := 'No';

    v_rep_ind.date_modified := TRUE;
    v_rep_ind.modified_by   := TRUE;
    v_rep_ind.deleted_ind   := TRUE;
    v_rep_ind.rep_idseq     := TRUE;

    v_rep_ind.version       := FALSE;
    v_rep_ind.created_by := FALSE;
    v_rep_ind.date_created := FALSE;

    IF P_REP_PREFERRED_NAME IS NULL THEN
      v_rep_ind.preferred_name := FALSE;
    ELSE
      v_rep_rec.preferred_name := P_REP_PREFERRED_NAME;
      v_rep_ind.preferred_name := TRUE;
    END IF;

    IF P_REP_CONTE_IDSEQ IS NULL THEN
      v_rep_ind.conte_idseq := FALSE;
    ELSE
      v_rep_rec.conte_idseq := P_REP_CONTE_IDSEQ;
      v_rep_ind.conte_idseq := TRUE;
    END IF;

    IF P_REP_PREFERRED_DEFINITION IS NULL THEN
      v_rep_ind.preferred_definition := FALSE; /***/
    ELSE
      v_rep_rec.preferred_definition := P_REP_PREFERRED_DEFINITION;
      v_rep_ind.preferred_definition := TRUE;
    END IF;

    IF P_REP_LONG_NAME IS NULL THEN
      v_rep_ind.long_name := FALSE;
    ELSE
      v_rep_rec.long_name := P_REP_LONG_NAME;
      v_rep_ind.long_name := TRUE;
    END IF;

    IF P_REP_ASL_NAME IS NULL THEN
      v_rep_ind.asl_name := FALSE;
    ELSE
      v_rep_rec.asl_name := P_REP_ASL_NAME;
      v_rep_ind.asl_name := TRUE;
    END IF;

    IF P_REP_LATEST_VERSION_IND IS NULL THEN
      v_rep_ind.latest_version_ind := FALSE;
    ELSE
      v_rep_rec.latest_version_ind := P_REP_LATEST_VERSION_IND;
      v_rep_ind.latest_version_ind := TRUE;
    END IF;

    IF P_REP_BEGIN_DATE IS NULL THEN
      v_rep_ind.begin_date := FALSE;
    ELSE
      v_rep_rec.begin_date := TO_DATE(P_REP_BEGIN_DATE);
      v_rep_ind.begin_date := TRUE;
    END IF;

    IF P_REP_END_DATE IS NULL THEN
      v_rep_ind.end_date := FALSE;
    ELSE
      v_rep_rec.end_date := TO_DATE(P_REP_END_DATE);
      v_rep_ind.end_date := TRUE;
    END IF;

    IF P_REP_CHANGE_NOTE IS NULL THEN
      v_rep_ind.change_note := FALSE;
    ELSE
      v_rep_rec.change_note := P_REP_CHANGE_NOTE;
      v_rep_ind.change_note := TRUE;
    END IF;

    IF P_REP_DEFINITION_SOURCE IS NULL THEN
      v_rep_ind.definition_source := FALSE;
    ELSE
      v_rep_rec.definition_source := P_REP_DEFINITION_SOURCE;
      v_rep_ind.definition_source := TRUE;
    END IF;

    IF P_REP_ORIGIN IS NULL THEN
      v_rep_ind.origin := FALSE;
    ELSE
      v_rep_rec.origin := P_REP_ORIGIN;
      v_rep_ind.origin := TRUE;
    END IF;

  /*  IF P_rep_DESIG_NCI_CC_TYPE IS NULL THEN
      v_rep_ind.DESIG_NCI_CC_TYPE := FALSE;
    ELSE
      v_rep_rec.DESIG_NCI_CC_TYPE := P_rep_DESIG_NCI_CC_TYPE;
      v_rep_ind.DESIG_NCI_CC_TYPE := TRUE;
    END IF;

    IF P_rep_DESIG_NCI_CC_VAL IS NULL THEN
      v_rep_ind.DESIG_NCI_CC_VAL := FALSE;
    ELSE
      v_rep_rec.DESIG_NCI_CC_VAL := P_rep_DESIG_NCI_CC_VAL;
      v_rep_ind.DESIG_NCI_CC_VAL := TRUE;
    END IF;

    IF P_rep_DESIG_UMLS_CUI_TYPE IS NULL THEN
      v_rep_ind.DESIG_UMLS_CUI_TYPE := FALSE;
    ELSE
      v_rep_rec.DESIG_UMLS_CUI_TYPE := P_rep_DESIG_UMLS_CUI_TYPE;
      v_rep_ind.DESIG_UMLS_CUI_TYPE := TRUE;
    END IF;

    IF P_rep_DESIG_UMLS_CUI_VAL IS NULL THEN
      v_rep_ind.DESIG_UMLS_CUI_VAL := FALSE;
    ELSE
      v_rep_rec.DESIG_UMLS_CUI_VAL := P_rep_DESIG_UMLS_CUI_VAL;
      v_rep_ind.DESIG_UMLS_CUI_VAL := TRUE;
    END IF;

    IF P_rep_DESIG_TEMP_CUI_TYPE IS NULL THEN
      v_rep_ind.DESIG_TEMP_CUI_TYPE := FALSE;
    ELSE
      v_rep_rec.DESIG_TEMP_CUI_TYPE := P_rep_DESIG_TEMP_CUI_TYPE;
      v_rep_ind.DESIG_TEMP_CUI_TYPE := TRUE;
    END IF;

    IF P_rep_DESIG_TEMP_CUI_VAL IS NULL THEN
      v_rep_ind.DESIG_TEMP_CUI_VAL := FALSE;
    ELSE
      v_rep_rec.DESIG_TEMP_CUI_VAL := P_rep_DESIG_TEMP_CUI_VAL;
      v_rep_ind.DESIG_TEMP_CUI_VAL := TRUE;
    END IF;*/

    BEGIN
      Cg$representations_View_Ext.upd(v_rep_rec,v_rep_ind);
    EXCEPTION WHEN OTHERS THEN
      P_RETURN_CODE := 'API_REP_502'; --Error updating representation
    END;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;

END SET_representation;

PROCEDURE SET_REP_CONDR(
  P_UA_NAME        IN  VARCHAR2
 ,P_REP_con_array           IN VARCHAR2
,P_REP_CONTE_IDSEQ            IN VARCHAR2
,P_RETURN_CODE                OUT VARCHAR2
,P_REP_REP_IDSEQ                OUT VARCHAR2
,P_REP_PREFERRED_NAME        OUT VARCHAR2
,P_REP_LONG_NAME              OUT VARCHAR2
,P_REP_PREFERRED_DEFINITION    OUT VARCHAR2
,P_REP_VERSION             OUT VARCHAR2
,P_REP_ASL_NAME            OUT VARCHAR2
,P_REP_LATEST_VERSION_IND     OUT VARCHAR2
,P_REP_CHANGE_NOTE            OUT VARCHAR2
,P_REP_ORIGIN                OUT VARCHAR2
,P_REP_DEFINITION_SOURCE      OUT VARCHAR2
,P_REP_BEGIN_DATE          OUT VARCHAR2
,P_REP_END_DATE               OUT VARCHAR2
,P_REP_DATE_CREATED            OUT VARCHAR2
,P_REP_CREATED_BY         OUT VARCHAR2
,P_REP_DATE_MODIFIED           OUT VARCHAR2
,P_REP_MODIFIED_BY             OUT VARCHAR2
,P_REP_DELETED_IND             OUT VARCHAR2
,P_REP_CONDR_IDSEQ            OUT VARCHAR2
,P_REP_ID            OUT VARCHAR2) IS

v_Exists NUMBER;
v_Condr_idseq con_Derivation_rules_ext.condr_idseq%type;

v_Conte_idseq contexts_view.conte_idseq%type;
BEGIN

  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  begin
  select conte_idseq into v_CONTE_IDSEQ
  from contexts
  where upper(name) = 'NCIP';	--GF32649
  exception when others then
   P_RETURN_CODE := 'API_PROP_001';
   RETURN;
  end;


v_condr_idseq := sbrext_common_routines.SET_DERIVATION_RULE(p_rep_con_array);

IF NOT Sbrext_Common_Routines.CONDR_EXISTS(v_condr_idseq) THEN
P_RETURN_CODE := 'Concept Derivation Rule does not exist.';
RETURN;
END IF;

IF NOT Sbrext_Common_Routines.CONTEXT_EXISTS(v_conte_idseq) THEN
P_RETURN_CODE := 'Context does not exist.';
RETURN;
END IF;

SELECT COUNT(*) INTO v_Exists
FROM REPRESENTATIONS_EXT
WHERE conte_idseq = v_conte_idseq
AND condr_idseq = v_condr_idseq;


IF v_exists = 0 THEN
admin_security_util.seteffectiveuser(p_ua_name);
Sbrext_Common_Routines.set_oc_rep_prop(v_condr_idseq
,p_return_code
,v_conte_idseq
,'REPRESENTATION'
,p_REP_REP_idseq
,p_ua_name
);
ELSE
  begin
    SELECT rep_idseq INTO p_rep_rep_idseq
    FROM REPRESENTATIONS_EXT
    WHERE conte_idseq = v_conte_idseq
    AND condr_idseq = v_condr_idseq
    AND LATEST_VERSION_IND = 'Yes';
 exception when too_many_rows then
   p_return_Code := sqlerrm;
   return;
 end;
END IF;

IF p_return_code IS NULL THEN
 SELECT PREFERRED_NAME
        ,LONG_NAME
        ,PREFERRED_DEFINITION
        ,VERSION
        ,ASL_NAME
        ,LATEST_VERSION_IND
        ,CHANGE_NOTE
        ,ORIGIN
        ,DEFINITION_SOURCE
        ,BEGIN_DATE
        ,END_DATE
        ,DATE_CREATED
        ,CREATED_BY
        ,DATE_MODIFIED
        ,MODIFIED_BY
        ,DELETED_IND
  ,CONDR_IDSEQ
  ,REP_IDSEQ
     INTO
    P_REP_PREFERRED_NAME
    ,P_REP_LONG_NAME
    ,P_REP_PREFERRED_DEFINITION
    ,P_REP_VERSION
    ,P_REP_ASL_NAME
    ,P_REP_LATEST_VERSION_IND
    ,P_REP_CHANGE_NOTE
    ,P_REP_ORIGIN
    ,P_REP_DEFINITION_SOURCE
    ,P_REP_BEGIN_DATE
    ,P_REP_END_DATE
    ,P_REP_DATE_CREATED
    ,P_REP_CREATED_BY
    ,P_REP_DATE_MODIFIED
    ,P_REP_MODIFIED_BY
    ,P_REP_DELETED_IND
    ,P_REP_CONDR_IDSEQ
  ,P_REP_ID
 FROM REPRESENTATIONS_EXT
 WHERE REP_idseq = p_REP_REP_idseq;
END IF;


END;

PROCEDURE SET_QUAL(
P_UA_NAME       IN VARCHAR2
,P_RETURN_CODE             OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_QUAL_qualifier_name         IN OUT VARCHAR2
,P_QUAL_DESCRIPTION         IN OUT VARCHAR2
,P_QUAL_COMMENTS             IN OUT VARCHAR2
,P_QUAL_CREATED_BY         OUT VARCHAR2
,P_QUAL_DATE_CREATED         OUT VARCHAR2
,P_QUAL_MODIFIED_BY         OUT VARCHAR2
,P_QUAL_DATE_MODIFIED         OUT VARCHAR2
,P_QUAL_CON_IDSEQ        IN VARCHAR2)  IS
/******************************************************************************
   NAME:       SET_QUAL
   PURPOSE:    Inserts or Updates a Single Row Of  Qualifier List of Value

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04/08/2003  Prerna Aggarwal      1. Created this procedure




******************************************************************************/


v_QUAL_rec    Cg$qualifier_Lov_View_Ext.cg$row_type;
v_QUAL_ind    Cg$qualifier_Lov_View_Ext.cg$ind_type;
BEGIN
P_RETURN_CODE := NULL;


IF P_ACTION NOT IN ('INS','UPD') THEN
 P_RETURN_CODE := 'API_QUAL_700'; -- Invalid action
 RETURN;
END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

IF P_ACTION = 'INS' THEN              --we are inserting a record
     --Check to see that all mandatory parameters are either not null
  IF P_QUAL_qualifier_name IS NULL THEN
    P_RETURN_CODE := 'API_QUAL_101';  --Value Meaning cannot be null here
 RETURN;
  END IF;
END IF;

IF P_ACTION = 'UPD'  THEN
  IF P_QUAL_qualifier_name IS NULL THEN
    P_RETURN_CODE := 'API_QUAL_101';  --Value Meaning cannot be null here
 RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.QUAL_exists(P_QUAL_qualifier_name) THEN
   P_RETURN_CODE := 'API_QUAL_005'; --QUAL not found
   RETURN;
  END IF;
END IF;
--Check to see that all VARCHAR2 and  VARCHAR2 parameters have correct length
IF LENGTH(P_QUAL_qualifier_name) > Sbrext_Column_Lengths.L_QUAL_qualifier_name THEN
  P_RETURN_CODE := 'API_QUAL_111';  --Length of qualifier_name exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_QUAL_DESCRIPTION) > Sbrext_Column_Lengths.L_QUAL_DESCRIPTION THEN
  P_RETURN_CODE := 'API_QUAL_113';  --Length of DESCRIPTION exceeds maximum length
  RETURN;
END IF;
IF LENGTH(P_QUAL_COMMENTS) > Sbrext_Column_Lengths.L_QUAL_COMMENTS THEN
  P_RETURN_CODE := 'API_QUAL_114'; --Length of COMMENTS exceeds maximum length
  RETURN;
END IF;


--check to see that charachter strings are valid
IF NOT Sbrext_Common_Routines.valid_char(P_QUAL_qualifier_name) THEN
  P_RETURN_CODE := 'API_QUAL_130'; -- Value Meaning Short Meaning has invalid characters
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.valid_char(P_QUAL_DESCRIPTION) THEN
  P_RETURN_CODE := 'API_QUAL_133'; -- Value Meaning Description has invalid characters
  RETURN;
END IF;
IF NOT Sbrext_Common_Routines.valid_char(P_QUAL_COMMENTS) THEN
  P_RETURN_CODE := 'API_QUAL_134'; -- Value Meaning Comment has invalid characters
  RETURN;
END IF;

IF P_QUAL_CON_IDSEQ IS NOT NULL THEN
  IF NOT Sbrext_Common_Routines.AC_EXISTS(p_qual_con_idseq) THEN
    P_RETURN_CODE := 'API_QUAL_136'; --Concept does not exist
   RETURN;
  END IF;
END IF;



IF (P_ACTION = 'INS' ) THEN

--check to see that Short Name Does not already Exist
  IF Sbrext_Common_Routines.QUAL_exists(P_QUAL_qualifier_name) THEN
    P_RETURN_CODE := 'API_QUAL_300';-- Value Meaning already exists
    RETURN;
  END IF;

  P_QUAL_DATE_CREATED := TO_CHAR(SYSDATE);
  P_QUAL_CREATED_BY := P_UA_NAME; --USER;
  P_QUAL_DATE_MODIFIED := NULL;
  P_QUAL_MODIFIED_BY := NULL;

  v_QUAL_rec.qualifier_name := P_QUAL_qualifier_name;
  v_QUAL_rec.description      := P_QUAL_DESCRIPTION;
  v_QUAL_rec.comments         := P_QUAL_COMMENTS;

  v_QUAL_rec.created_by     := P_QUAL_CREATED_BY;
  v_QUAL_rec.date_created     := P_QUAL_DATE_CREATED;
  v_QUAL_rec.modified_by     := P_QUAL_MODIFIED_BY;
  v_QUAL_rec.date_modified := P_QUAL_DATE_MODIFIED;
  v_QUAL_rec.con_idseq := P_QUAL_CON_IDSEQ;


  v_QUAL_ind.qualifier_name   := TRUE;
  v_QUAL_ind.description        := TRUE;
  v_QUAL_ind.comments           := TRUE;
  v_QUAL_ind.created_by       := TRUE;
  v_QUAL_ind.date_created       := TRUE;
  v_QUAL_ind.modified_by       := TRUE;
  v_QUAL_ind.date_modified   := TRUE;
  v_QUAL_ind.con_idseq   := TRUE;

  BEGIN
    Cg$qualifier_Lov_View_Ext.ins(v_QUAL_rec,v_QUAL_ind);
  EXCEPTION WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
    P_RETURN_CODE := 'API_QUAL_500'; --Error inserting Value Meaning
  END;

END IF;


IF (P_ACTION = 'UPD' ) THEN

  P_QUAL_DATE_MODIFIED := TO_CHAR(SYSDATE);
  P_QUAL_MODIFIED_BY := P_UA_NAME; --USER;


  v_QUAL_rec.date_modified := P_QUAL_DATE_MODIFIED;
  v_QUAL_rec.modified_by := P_QUAL_MODIFIED_BY;

  v_QUAL_ind.date_modified := TRUE;
  v_QUAL_ind.modified_by := TRUE;

  v_QUAL_ind.created_by := FALSE;
  v_QUAL_ind.date_created := FALSE;

  IF P_QUAL_DESCRIPTION IS NULL THEN
    v_QUAL_ind.description := FALSE;
  ELSE
    v_QUAL_rec.description := P_QUAL_DESCRIPTION;
    v_QUAL_ind.description := TRUE;
  END IF;

  IF P_QUAL_COMMENTS IS NULL THEN
    v_QUAL_ind.comments := FALSE;
  ELSE
    v_QUAL_rec.comments := P_QUAL_COMMENTS;
    v_QUAL_ind.comments := TRUE;
  END IF;

  IF P_QUAL_CON_IDSEQ IS NULL THEN
    v_QUAL_ind.con_idseq := FALSE;
  ELSE
    v_QUAL_rec.con_idseq := P_QUAL_con_idseq;
    v_QUAL_ind.con_idseq := TRUE;
  END IF;


  BEGIN
    Cg$qualifier_Lov_View_Ext.upd(v_QUAL_rec,v_QUAL_ind);
  EXCEPTION WHEN OTHERS THEN
    P_RETURN_CODE := 'API_QUAL_501'; --Error updating value meaning
  END;
END IF;

EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END SET_QUAL;


PROCEDURE set_cd(
P_UA_NAME       IN VARCHAR2
, p_action                  IN     VARCHAR2
 ,p_cd_idseq                IN OUT VARCHAR2
 ,p_cd_version              IN OUT VARCHAR2
 ,p_cd_preferred_name       IN OUT VARCHAR2
 ,p_cd_conte_idseq          IN OUT VARCHAR2
 ,p_cd_long_name            IN OUT VARCHAR2
 ,p_cd_preferred_definition IN OUT VARCHAR2
 ,p_cd_dimensionality       IN OUT VARCHAR2
 ,p_cd_asl_name             IN OUT VARCHAR2
 ,p_cd_latest_version_ind   IN OUT VARCHAR2
 ,p_cd_begin_date           IN OUT DATE
 ,p_cd_end_date             IN OUT DATE
 ,p_cd_change_note          IN OUT VARCHAR2
 ,p_cd_origin               IN OUT VARCHAR2
 ,p_cd_created_by              OUT VARCHAR2
 ,p_cd_date_created            OUT VARCHAR2
 ,p_cd_modified_by             OUT VARCHAR2
 ,p_cd_date_modified           OUT VARCHAR2
 ,p_return_code                OUT VARCHAR2
  )
IS

/******************************************************************************
   NAME:       SET_CD
   PURPOSE:    Inserts or Updates a Single Row of Conceptual Domains

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03/08/2004  W. Ver Hoef      1. Created this procedure

******************************************************************************/

  v_cd_rec    cg$conceptual_domains_view.cg$row_type;
  v_cd_ind    cg$conceptual_domains_view.cg$ind_type;

BEGIN

  p_return_code := NULL;

  IF p_action NOT IN ('INS','UPD') THEN
    p_return_code := 'API_CD_100'; -- Invalid action
    RETURN;
  END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  IF p_action = 'INS' THEN
    --Check to see that all mandatory parameters are not null
    IF p_cd_version IS NULL THEN
      p_return_code := 'API_CD_101';  -- parameter value cannot be null
   RETURN;
    END IF;
    IF p_cd_preferred_name IS NULL THEN
      p_return_code := 'API_CD_102';  -- parameter value cannot be null
   RETURN;
    END IF;
    IF p_cd_conte_idseq IS NULL THEN
      p_return_code := 'API_CD_103';  -- parameter value cannot be null
   RETURN;
    END IF;
    IF p_cd_preferred_definition IS NULL THEN
      p_return_code := 'API_CD_104';  -- parameter value cannot be null
   RETURN;
    END IF;
  END IF;

  IF p_action = 'UPD'  THEN
    admin_security_util.seteffectiveuser(p_ua_name);
    IF p_cd_idseq IS NULL THEN
      p_return_code := 'API_CD_105';  -- PK cannot be null here
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ac_exists(p_cd_idseq) THEN
   p_return_code := 'API_CD_105'; -- CD not found
   RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and CHAR parameters have correct length
  IF LENGTH(p_cd_idseq) > Sbrext_Column_Lengths.l_cd_cd_idseq THEN
    p_return_code := 'API_CD_106';
    RETURN;
  END IF;
  IF LENGTH(p_cd_preferred_name) > Sbrext_Column_Lengths.l_cd_preferred_name THEN
    p_return_code := 'API_CD_107';
    RETURN;
  END IF;
  IF LENGTH(p_cd_long_name) > Sbrext_Column_Lengths.l_cd_long_name THEN
    p_return_code := 'API_CD_108';
    RETURN;
  END IF;
  IF LENGTH(p_cd_asl_name) > Sbrext_Column_Lengths.l_cd_asl_name THEN
    p_return_code := 'API_CD_109';
    RETURN;
  END IF;
  IF LENGTH(p_cd_conte_idseq) > Sbrext_Column_Lengths.l_cd_conte_idseq THEN
    p_return_code := 'API_CD_110';
    RETURN;
  END IF;
  IF LENGTH(p_cd_preferred_definition) > Sbrext_Column_Lengths.l_cd_preferred_definition THEN
    p_return_code := 'API_CD_111';
    RETURN;
  END IF;
  IF LENGTH(p_cd_dimensionality) > Sbrext_Column_Lengths.l_cd_dimensionality THEN
    p_return_code := 'API_CD_112';
    RETURN;
  END IF;
  IF LENGTH(p_cd_latest_version_ind) > Sbrext_Column_Lengths.l_cd_latest_version_ind THEN
    p_return_code := 'API_CD_113';
    RETURN;
  END IF;
  IF LENGTH(p_cd_change_note) > Sbrext_Column_Lengths.l_cd_change_note THEN
    p_return_code := 'API_CD_114';
    RETURN;
  END IF;
  IF LENGTH(p_cd_origin) > Sbrext_Column_Lengths.l_cd_origin THEN
    p_return_code := 'API_CD_115';
    RETURN;
  END IF;

  --check to see that character strings are valid
  IF NOT Sbrext_Common_Routines.valid_char(p_cd_long_name) THEN
    p_return_code := 'API_CD_116';
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(p_cd_preferred_definition) THEN
    p_return_code := 'API_CD_117';
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(p_cd_change_note) THEN
    p_return_code := 'API_CD_118';
    RETURN;
  END IF;

  IF p_cd_conte_idseq IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.context_exists(p_cd_conte_idseq) THEN
      p_return_code := 'API_CD_122'; --Context not found in the database
      RETURN;
    END IF;
  END IF;
  IF p_cd_asl_name IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.workflow_exists(p_cd_asl_name) THEN
      p_return_code := 'API_CD_123'; --Workflow Status not found in the database
      RETURN;
    END IF;
  END IF;

  IF P_ACTION = 'INS' THEN

    --check to see that UK components do not already exist
    IF Sbrext_Common_Routines.cd_exists(p_cd_preferred_name, p_cd_version, p_cd_conte_idseq) THEN
      P_RETURN_CODE := 'API_CD_119';
      RETURN;
    END IF;

 p_cd_idseq         := admincomponent_crud.cmr_guid;
    p_cd_date_created  := TO_CHAR(SYSDATE);
    p_cd_created_by    := P_UA_NAME; --USER;
    p_cd_date_modified := NULL;
    p_cd_modified_by   := NULL;

 v_cd_rec.cd_idseq             := p_cd_idseq;
    v_cd_rec.version              := p_cd_version;
    v_cd_rec.preferred_name       := p_cd_preferred_name;
    v_cd_rec.conte_idseq          := p_cd_conte_idseq;
    v_cd_rec.preferred_definition := p_cd_preferred_definition;
    v_cd_rec.dimensionality       := p_cd_dimensionality;
    v_cd_rec.long_name            := p_cd_long_name;
    v_cd_rec.asl_name             := p_cd_asl_name;
    v_cd_rec.latest_version_ind   := p_cd_latest_version_ind;
    v_cd_rec.change_note          := p_cd_change_note;
    v_cd_rec.origin               := p_cd_origin;
    v_cd_rec.begin_date           := p_cd_begin_date;
    v_cd_rec.end_date             := p_cd_end_date;
    v_cd_rec.date_created         := p_cd_date_created;
    v_cd_rec.created_by           := p_cd_created_by;
    v_cd_rec.date_modified        := p_cd_date_modified;
    v_cd_rec.modified_by          := p_cd_modified_by;

    v_cd_ind.cd_idseq             := TRUE;
 v_cd_ind.version              := TRUE;
    v_cd_ind.preferred_name       := TRUE;
    v_cd_ind.conte_idseq          := TRUE;
    v_cd_ind.preferred_definition := TRUE;
    v_cd_ind.dimensionality       := TRUE;
    v_cd_ind.long_name            := TRUE;
    v_cd_ind.asl_name             := TRUE;
    v_cd_ind.latest_version_ind   := TRUE;
    v_cd_ind.change_note          := TRUE;
    v_cd_ind.origin               := TRUE;
    v_cd_ind.begin_date           := TRUE;
    v_cd_ind.end_date             := TRUE;
    v_cd_ind.date_created         := TRUE;
    v_cd_ind.created_by           := TRUE;
    v_cd_ind.date_modified        := TRUE;
    v_cd_ind.modified_by          := TRUE;

    BEGIN
      cg$conceptual_domains_view.ins(v_cd_rec,v_cd_ind);
    EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      p_return_code := 'API_CD_120'; --Error inserting Conceptual Domain
    END;

  END IF;

  IF p_action = 'UPD' THEN

    p_cd_date_modified     := TO_CHAR(SYSDATE);
    p_cd_modified_by       := P_UA_NAME; --USER;

    v_cd_rec.date_modified := p_cd_date_modified;
    v_cd_rec.modified_by   := p_cd_modified_by;

    v_cd_ind.date_modified := TRUE;
    v_cd_ind.modified_by   := TRUE;

    v_cd_ind.date_created  := FALSE;
    v_cd_ind.created_by    := FALSE;

    v_cd_rec.cd_idseq      := p_cd_idseq;

 IF p_cd_preferred_definition IS NULL THEN
      v_cd_ind.preferred_definition := FALSE;
    ELSE
      v_cd_rec.preferred_definition := p_cd_preferred_definition;
      v_cd_ind.preferred_definition := TRUE;
    END IF;

    IF p_cd_dimensionality IS NULL THEN
      v_cd_ind.dimensionality := FALSE;
    ELSE
      v_cd_rec.dimensionality := p_cd_dimensionality;
      v_cd_ind.dimensionality := TRUE;
    END IF;

    IF p_cd_long_name IS NULL THEN
      v_cd_ind.long_name := FALSE;
    ELSE
      v_cd_rec.long_name := p_cd_long_name;
      v_cd_ind.long_name := TRUE;
    END IF;

    IF p_cd_asl_name IS NULL THEN
      v_cd_ind.asl_name := FALSE;
    ELSE
      v_cd_rec.asl_name := p_cd_asl_name;
      v_cd_ind.asl_name := TRUE;
    END IF;

    IF p_cd_latest_version_ind IS NULL THEN
      v_cd_ind.latest_version_ind := FALSE;
    ELSE
      v_cd_rec.latest_version_ind := p_cd_latest_version_ind;
      v_cd_ind.latest_version_ind := TRUE;
    END IF;

    IF p_cd_change_note IS NULL THEN
      v_cd_ind.change_note := FALSE;
    ELSE
      v_cd_rec.change_note := p_cd_change_note;
      v_cd_ind.change_note := TRUE;
    END IF;

    IF p_cd_origin IS NULL THEN
      v_cd_ind.origin := FALSE;
    ELSE
      v_cd_rec.origin := p_cd_origin;
      v_cd_ind.origin := TRUE;
    END IF;

    IF p_cd_begin_date IS NULL THEN
      v_cd_ind.begin_date := FALSE;
    ELSE
      v_cd_rec.begin_date := p_cd_begin_date;
      v_cd_ind.begin_date := TRUE;
    END IF;

    IF p_cd_end_date IS NULL THEN
      v_cd_ind.end_date := FALSE;
    ELSE
      v_cd_rec.end_date := p_cd_end_date;
      v_cd_ind.end_date := TRUE;
    END IF;

    BEGIN
      cg$conceptual_domains_view.upd(v_cd_rec,v_cd_ind);
    EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      p_return_code := 'API_CD_121';
    END;
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;
END set_cd;


PROCEDURE set_complex_de(
  P_UA_NAME       IN  VARCHAR2
 ,p_action            IN  VARCHAR2
 ,p_cdt_p_de_idseq    IN  VARCHAR2
 ,p_cdt_methods       IN  VARCHAR2
 ,p_cdt_rule          IN  VARCHAR2
 ,p_cdt_concat_char   IN  VARCHAR2
 ,p_cdt_crtl_name     IN  VARCHAR2
 ,p_cdt_created_by    OUT VARCHAR2
 ,p_cdt_date_created  OUT VARCHAR2
 ,p_cdt_modified_by   OUT VARCHAR2
 ,p_cdt_date_modified OUT VARCHAR2
 ,p_return_code       OUT VARCHAR2
 )
IS

/******************************************************************************
   NAME:       SET_COMPLEX_DE
   PURPOSE:    Inserts or Updates a Single Row of Complex_Data_Elements

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        03/16/2004  W. Ver Hoef      1. Created this procedure
   2.1        03/23/2004  W. Ver Hoef      1. Added DEL option

******************************************************************************/

  v_cdt_rec  cg$complex_data_elements_view.cg$row_type;
  v_cdt_ind  cg$complex_data_elements_view.cg$ind_type;
  v_cdt_pk   cg$complex_data_elements_view.cg$pk_type; -- 23-Mar-2004, W. Ver Hoef - added per SPRF_2.1_06

BEGIN

  p_return_code := NULL;

  IF p_action NOT IN ('INS','UPD','DEL') THEN -- 23-Mar-2004, W. Ver Hoef - added DEL option
    p_return_code := 'API_CDT_100'; -- Invalid action
    RETURN;
  END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  IF p_action = 'INS' THEN
    --Check to see that all mandatory parameters are not null and are valid
    IF p_cdt_p_de_idseq IS NULL THEN
      p_return_code := 'API_CDE_101';  -- parameter value cannot be null
   RETURN;
    END IF;
    IF p_cdt_crtl_name IS NULL THEN
      p_return_code := 'API_CDT_102';  -- parameter value cannot be null
   RETURN;
    END IF;
 IF NOT Sbrext_Common_Routines.ac_exists(p_cdt_p_de_idseq) THEN
   p_return_code := 'API_CDT_103'; -- DE not found
   RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.crtl_exists(p_cdt_crtl_name) THEN
   p_return_code := 'API_CDT_104'; -- Complex Rep Type not found
   RETURN;
    END IF;
  END IF;

  IF p_action = 'UPD'  THEN
    admin_security_util.seteffectiveuser(p_ua_name);
    IF p_cdt_p_de_idseq IS NULL THEN
      p_return_code := 'API_CDT_101';  -- PK cannot be null here
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.cdt_exists(p_cdt_p_de_idseq) THEN
   p_return_code := 'API_CDT_103'; -- Complex DE not found
   RETURN;
    END IF;
    IF p_cdt_crtl_name IS NOT NULL
 AND NOT Sbrext_Common_Routines.crtl_exists(p_cdt_crtl_name) THEN
   p_return_code := 'API_CDT_104'; -- Complex Rep Type not found
   RETURN;
    END IF;
  END IF;

  --Check to see that all VARCHAR2 and CHAR parameters have correct length
  IF LENGTH(p_cdt_concat_char) > Sbrext_Column_Lengths.l_cdt_concat_char THEN
    p_return_code := 'API_CDT_105';
    RETURN;
  END IF;
  IF LENGTH(p_cdt_methods) > Sbrext_Column_Lengths.l_cdt_methods THEN
    p_return_code := 'API_CDT_106';
    RETURN;
  END IF;
  IF LENGTH(p_cdt_rule) > Sbrext_Column_Lengths.l_cdt_rule THEN
    p_return_code := 'API_CDT_107';
    RETURN;
  END IF;

  --check to see that character strings are valid
  IF NOT Sbrext_Common_Routines.valid_char(p_cdt_methods) THEN
    p_return_code := 'API_CDT_110';
    RETURN;
  END IF;
  IF NOT Sbrext_Common_Routines.valid_char(p_cdt_rule) THEN
    p_return_code := 'API_CDT_111';
    RETURN;
  END IF;

  IF p_action = 'INS' THEN

    --check to see that UK components do not already exist
    IF Sbrext_Common_Routines.cdt_exists(p_cdt_p_de_idseq) THEN
      p_return_code := 'API_CDT_120';
      RETURN;
    END IF;

 p_cdt_date_created      := TO_CHAR(SYSDATE);
    p_cdt_created_by        := P_UA_NAME; --USER;
    p_cdt_date_modified     := NULL;
    p_cdt_modified_by       := NULL;

 v_cdt_rec.p_de_idseq    := p_cdt_p_de_idseq;
    v_cdt_rec.methods       := p_cdt_methods;
    v_cdt_rec.rule          := p_cdt_rule;
    v_cdt_rec.concat_char   := p_cdt_concat_char;
    v_cdt_rec.crtl_name     := p_cdt_crtl_name;
    v_cdt_rec.date_created  := p_cdt_date_created;
    v_cdt_rec.created_by    := p_cdt_created_by;
    v_cdt_rec.date_modified := p_cdt_date_modified;
    v_cdt_rec.modified_by   := p_cdt_modified_by;

    v_cdt_ind.p_de_idseq    := TRUE;
 v_cdt_ind.methods       := TRUE;
    v_cdt_ind.rule          := TRUE;
    v_cdt_ind.concat_char   := TRUE;
    v_cdt_ind.crtl_name     := TRUE;
    v_cdt_ind.date_created  := TRUE;
    v_cdt_ind.created_by    := TRUE;
    v_cdt_ind.date_modified := TRUE;
    v_cdt_ind.modified_by   := TRUE;

    BEGIN
      cg$complex_data_elements_view.ins(v_cdt_rec,v_cdt_ind);
    EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      p_return_code := 'API_CDT_130'; --Error inserting Complex DE
    END;

  END IF;

  IF p_action = 'UPD' THEN

    p_cdt_date_modified     := TO_CHAR(SYSDATE);
    p_cdt_modified_by       := P_UA_NAME; --USER;
    v_cdt_rec.date_modified := p_cdt_date_modified;
    v_cdt_rec.modified_by   := p_cdt_modified_by;

    v_cdt_ind.date_modified := TRUE;
    v_cdt_ind.modified_by   := TRUE;

    v_cdt_ind.date_created  := FALSE;
    v_cdt_ind.created_by    := FALSE;

    v_cdt_rec.p_de_idseq    := p_cdt_p_de_idseq;

 IF p_cdt_methods IS NULL THEN
      v_cdt_ind.methods := FALSE;
    ELSE
      v_cdt_rec.methods := p_cdt_methods;
      v_cdt_ind.methods := TRUE;
    END IF;

    IF p_cdt_rule IS NULL THEN
      v_cdt_ind.rule := FALSE;
    ELSE
      v_cdt_rec.rule := p_cdt_rule;
      v_cdt_ind.rule := TRUE;
    END IF;

    IF p_cdt_concat_char IS NULL THEN
      v_cdt_ind.concat_char := FALSE;
    ELSE
      v_cdt_rec.concat_char := p_cdt_concat_char;
      v_cdt_ind.concat_char := TRUE;
    END IF;

    IF p_cdt_crtl_name IS NULL THEN
      v_cdt_ind.crtl_name := FALSE;
    ELSE
      v_cdt_rec.crtl_name := p_cdt_crtl_name;
      v_cdt_ind.crtl_name := TRUE;
    END IF;

    BEGIN
      cg$complex_data_elements_view.upd(v_cdt_rec,v_cdt_ind);
    EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      p_return_code := 'API_CDT_131';
    END;
  END IF;

  -- 23-Mar-2004, W. Ver Hoef - added IF stmt for DEL per SPRF_2.1_06

  IF P_ACTION = 'DEL' THEN              -- we are deleting a record

    IF p_cdt_p_de_idseq IS NULL THEN
      P_RETURN_CODE := 'API_CDT_132' ;  -- for delete the ID is mandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ac_exists(p_cdt_p_de_idseq) THEN
     P_RETURN_CODE := 'API_CDT_133'; -- Complex DE not found
     RETURN;
   END IF;
    END IF;

    v_cdt_pk.p_de_idseq := p_cdt_p_de_idseq;

    SELECT ROWID
 INTO   v_cdt_pk.the_rowid
    FROM   complex_data_elements_view
    WHERE  p_de_idseq = p_cdt_p_de_idseq;

    v_cdt_pk.jn_notes := NULL;

    BEGIN
      cg$complex_data_elements_view.del(v_cdt_pk);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
      p_return_code := 'API_CDT_134'; --Error deleting Complex DE
    END;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;
END set_complex_de;


PROCEDURE set_cde_relationship(
  P_UA_NAME       IN  VARCHAR2
 ,p_action             IN     VARCHAR2
 ,p_cdr_idseq          IN OUT VARCHAR2
 ,p_cdr_p_de_idseq     IN OUT VARCHAR2
 ,p_cdr_c_de_idseq     IN OUT VARCHAR2
 ,p_cdr_display_order  IN OUT VARCHAR2
 ,p_cdr_created_by        OUT VARCHAR2
 ,p_cdr_date_created      OUT VARCHAR2
 ,p_cdr_modified_by       OUT VARCHAR2
 ,p_cdr_date_modified     OUT VARCHAR2
 ,p_return_code           OUT VARCHAR2
  )
IS

/******************************************************************************
   NAME:       SET_CDE_RELATIONSHIP
   PURPOSE:    Inserts or Updates a Single Row of COMPLEX_DE_RELATIONSHIPS

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        03/17/2004  W. Ver Hoef      1. Created this procedure
   2.1        03/23/2004  W. Ver Hoef      1. Added DEL option

******************************************************************************/

  v_cdr_rec  cg$complex_de_rel_view.cg$row_type;
  v_cdr_ind  cg$complex_de_rel_view.cg$ind_type;
  v_cdr_pk   cg$complex_de_rel_view.cg$pk_type; -- 23-Mar-2004, W. Ver Hoef - added per SPRF_2.1_06a

  v_count      NUMBER := 0;

BEGIN

  p_return_code := NULL;

  IF p_action NOT IN ('INS','UPD','DEL') THEN -- 23-Mar-2004, W. Ver Hoef - added DEL per SPRF_2.1_06a
    p_return_code := 'API_CDR_100'; -- Invalid action
    RETURN;
  END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  IF p_action = 'INS' THEN
    --Check to see that all mandatory parameters are not null
    IF p_cdr_p_de_idseq IS NULL THEN
      p_return_code := 'API_CDR_101';  -- parameter value cannot be null
   RETURN;
    END IF;
    IF p_cdr_c_de_idseq IS NULL THEN
      p_return_code := 'API_CDR_102';  -- parameter value cannot be null
   RETURN;
    END IF;
  END IF;

  IF p_action = 'UPD'  THEN
   admin_security_util.seteffectiveuser(p_ua_name);
    IF p_cdr_idseq IS NULL THEN
      p_return_code := 'API_CDR_103';  -- PK cannot be null here
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.cdr_exists(p_cdr_idseq) THEN
   p_return_code := 'API_CDR_104'; -- CD not found
   RETURN;
    END IF;
  END IF;

  --Check to see that display order parameter have correct length
  IF LENGTH(p_cdr_display_order) > 4 THEN
    p_return_code := 'API_CDR_105';
    RETURN;
  END IF;

  --check to see that display order is a valid number
  IF p_cdr_display_order IS NOT NULL THEN
    IF NOT (ASCII(SUBSTR(p_cdr_display_order,1,1)) BETWEEN 48 AND 57 AND
            ASCII(NVL(SUBSTR(p_cdr_display_order,2,1),'0')) BETWEEN 48 AND 57 AND
            ASCII(NVL(SUBSTR(p_cdr_display_order,3,1),'0')) BETWEEN 48 AND 57 AND
            ASCII(NVL(SUBSTR(p_cdr_display_order,4,1),'0')) BETWEEN 48 AND 57) THEN
      p_return_code := 'API_CDR_106';
      RETURN;
    END IF;
  END IF;

  IF p_cdr_p_de_idseq IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.cdt_exists(p_cdr_p_de_idseq) THEN
      p_return_code := 'API_CDR_107'; -- Complex DE not found in the database
      RETURN;
    END IF;
  END IF;
  IF p_cdr_c_de_idseq IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.ac_exists(p_cdr_c_de_idseq) THEN
      p_return_code := 'API_CDR_108'; -- DE not found in the database
      RETURN;
    END IF;
  END IF;

  IF P_ACTION = 'INS' THEN

    --check to see that UK components do not already exist
    BEGIN
      SELECT COUNT(1)
      INTO   v_count
      FROM   complex_de_relationships
      WHERE  p_de_idseq = p_cdr_p_de_idseq
   AND    c_de_idseq = p_cdr_c_de_idseq;
      IF(v_count >= 1) THEN
        p_return_code := 'API_CDR_109'; -- Complex DE relationship already exists
  RETURN;
      END IF;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     NULL;
    END;

 p_cdr_idseq         := admincomponent_crud.cmr_guid;
    p_cdr_date_created  := TO_CHAR(SYSDATE);
    p_cdr_created_by    := P_UA_NAME; --USER;
    p_cdr_date_modified := NULL;
    p_cdr_modified_by   := NULL;

 v_cdr_rec.cdr_idseq      := p_cdr_idseq;
    v_cdr_rec.p_de_idseq     := p_cdr_p_de_idseq;
    v_cdr_rec.c_de_idseq     := p_cdr_c_de_idseq;
    v_cdr_rec.display_order  := p_cdr_display_order;
    v_cdr_rec.date_created   := p_cdr_date_created;
    v_cdr_rec.created_by     := p_cdr_created_by;
    v_cdr_rec.date_modified  := p_cdr_date_modified;
    v_cdr_rec.modified_by    := p_cdr_modified_by;

    v_cdr_ind.cdr_idseq      := TRUE;
 v_cdr_ind.p_de_idseq     := TRUE;
    v_cdr_ind.c_de_idseq     := TRUE;
    v_cdr_ind.display_order  := TRUE;
    v_cdr_ind.date_created   := TRUE;
    v_cdr_ind.created_by     := TRUE;
    v_cdr_ind.date_modified  := TRUE;
    v_cdr_ind.modified_by    := TRUE;

    BEGIN
      cg$complex_de_rel_view.ins(v_cdr_rec,v_cdr_ind);
    EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      p_return_code := 'API_CDR_110'; --Error inserting Complex DE Relationship
    END;

  END IF;

  IF p_action = 'UPD' THEN

    p_cdr_date_modified     := TO_CHAR(SYSDATE);
    p_cdr_modified_by       := P_UA_NAME; --USER;

    v_cdr_rec.date_modified := p_cdr_date_modified;
    v_cdr_rec.modified_by   := p_cdr_modified_by;

    v_cdr_ind.date_modified := TRUE;
    v_cdr_ind.modified_by   := TRUE;

    v_cdr_ind.date_created  := FALSE;
    v_cdr_ind.created_by    := FALSE;

    v_cdr_rec.cdr_idseq     := p_cdr_idseq;

 IF p_cdr_p_de_idseq IS NULL THEN
      v_cdr_ind.p_de_idseq := FALSE;
    ELSE
      v_cdr_rec.p_de_idseq := p_cdr_p_de_idseq;
      v_cdr_ind.p_de_idseq := TRUE;
    END IF;

    IF p_cdr_c_de_idseq IS NULL THEN
      v_cdr_ind.c_de_idseq := FALSE;
    ELSE
      v_cdr_rec.c_de_idseq := p_cdr_c_de_idseq;
      v_cdr_ind.c_de_idseq := TRUE;
    END IF;

    IF p_cdr_display_order IS NULL THEN
      v_cdr_ind.display_order := FALSE;
    ELSE
      v_cdr_rec.display_order := TO_NUMBER(p_cdr_display_order);
      v_cdr_ind.display_order := TRUE;
    END IF;

    BEGIN
      cg$complex_de_rel_view.upd(v_cdr_rec,v_cdr_ind);
    EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      p_return_code := 'API_CDR_111'; -- error updating Complex DE Relationship
    END;

  END IF;

  -- 23-Mar-2004, W. Ver Hoef - added IF stmt for DEL per SPRF_2.1_06a

  IF p_action = 'DEL' THEN              -- we are deleting a record

    IF p_cdr_idseq IS NULL THEN
      p_return_code := 'API_CDR_112' ;  -- for delete the ID is mandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.cdr_exists(p_cdr_idseq) THEN
     p_return_code := 'API_CDR_104'; -- Complex DE not found
     RETURN;
   END IF;
    END IF;

    v_cdr_pk.cdr_idseq := p_cdr_idseq;

    SELECT ROWID
 INTO   v_cdr_pk.the_rowid
    FROM   complex_de_rel_view
    WHERE  cdr_idseq = p_cdr_idseq;

    --v_cdr_pk.jn_notes := NULL;

    BEGIN
      cg$complex_de_rel_view.del(v_cdr_pk);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
      p_return_code := 'API_CDT_113'; --Error deleting Complex DE
    END;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;
END set_cde_relationship;


PROCEDURE set_registration(
  P_UA_NAME       IN VARCHAR2
 ,p_action                  IN     VARCHAR2
 ,p_ar_idseq                IN OUT VARCHAR2
 ,p_ar_ac_idseq             IN OUT VARCHAR2
 ,p_ar_registration_status  IN OUT VARCHAR2
 ,p_ar_created_by              OUT VARCHAR2
 ,p_ar_date_created            OUT VARCHAR2
 ,p_ar_modified_by             OUT VARCHAR2
 ,p_ar_date_modified           OUT VARCHAR2
 ,p_return_code                OUT VARCHAR2
  )
IS

/******************************************************************************
   NAME:       SET_REGISTRATION
   PURPOSE:    Inserts or Updates a Single Row of AC_REGISTRATIONS

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        03/19/2004  W. Ver Hoef      1. Created this procedure
   2.1        03/23/2004  W. Ver Hoef      1. Added DEL option

******************************************************************************/

  v_ar_rec  cg$ac_registrations_view.cg$row_type;
  v_ar_ind  cg$ac_registrations_view.cg$ind_type;
  v_ar_pk   cg$ac_registrations_view.cg$pk_type; -- 23-Mar-2004, W. Ver Hoef - added per SPRF_2.1_03

  v_count     NUMBER := 0;

BEGIN

  p_return_code := NULL;

  IF p_action NOT IN ('INS','UPD','DEL') THEN -- 23-Mar-2004, W. Ver Hoef - added DEL per SPRF_2.1_03
    p_return_code := 'API_AR_100'; -- Invalid action
    RETURN;
  END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

  IF p_action = 'INS' THEN
    --Check to see that all mandatory parameters are not null
    IF p_ar_ac_idseq IS NULL THEN
      p_return_code := 'API_AR_101';  -- parameter value cannot be null
   RETURN;
    END IF;
    IF p_ar_registration_status IS NULL THEN
      p_return_code := 'API_AR_102';  -- parameter value cannot be null
   RETURN;
    END IF;
  END IF;

  IF p_action = 'UPD'  THEN
   admin_security_util.seteffectiveuser(p_ua_name);
    IF p_ar_idseq IS NULL THEN
      p_return_code := 'API_AR_103';  -- PK cannot be null here
      RETURN;
    END IF;
    IF NOT Sbrext_Common_Routines.ar_exists(p_ar_idseq) THEN
   p_return_code := 'API_AR_104'; -- AR not found
   RETURN;
    END IF;
  END IF;

  --Check to see that registration status parameter has correct length
  IF LENGTH(p_ar_registration_status) > Sbrext_Column_Lengths.l_ar_registration_status THEN
    p_return_code := 'API_AR_105';
    RETURN;
  END IF;

  IF p_ar_ac_idseq IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.ac_exists(p_ar_ac_idseq) THEN
      p_return_code := 'API_AR_106'; -- AC not found in the database
      RETURN;
    END IF;
  END IF;
  IF p_ar_registration_status IS NOT NULL THEN
    IF NOT Sbrext_Common_Routines.rsl_exists(p_ar_registration_status) THEN
      p_return_code := 'API_AR_107'; -- Registration Status not found in the database
      RETURN;
    END IF;
  END IF;

  IF P_ACTION = 'INS' THEN

    -- check to see that UK components do not already exist
 -- NOTE:  currently the SUBMITTER and ORGANIZATION part of this model are not being
 -- used for registration so we're only checking on the uniqueness of the ac_idseq.
    BEGIN
      SELECT COUNT(1)
      INTO   v_count
      FROM   ac_registrations
      WHERE  ac_idseq = p_ar_ac_idseq;
      IF(v_count >= 1) THEN
        p_return_code := 'API_AR_108'; -- AC Registration already exists
  RETURN;
      END IF;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     NULL;
    END;

 p_ar_idseq         := admincomponent_crud.cmr_guid;
    p_ar_date_created  := TO_CHAR(SYSDATE);
    p_ar_created_by    := P_UA_NAME; --USER;
    p_ar_date_modified := NULL;
    p_ar_modified_by   := NULL;

 v_ar_rec.ar_idseq            := p_ar_idseq;
    v_ar_rec.ac_idseq            := p_ar_ac_idseq;
    v_ar_rec.registration_status := p_ar_registration_status;
    v_ar_rec.date_created        := p_ar_date_created;
    v_ar_rec.created_by          := p_ar_created_by;
    v_ar_rec.date_modified       := p_ar_date_modified;
    v_ar_rec.modified_by         := p_ar_modified_by;

    v_ar_ind.ar_idseq            := TRUE;
 v_ar_ind.ac_idseq            := TRUE;
    v_ar_ind.registration_status := TRUE;
    v_ar_ind.date_created        := TRUE;
    v_ar_ind.created_by          := TRUE;
    v_ar_ind.date_modified       := TRUE;
    v_ar_ind.modified_by         := TRUE;

    BEGIN
      cg$ac_registrations_view.ins(v_ar_rec, v_ar_ind);
    EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      p_return_code := 'API_AR_109'; --Error inserting AC Registration
    END;

  END IF;

  IF p_action = 'UPD' THEN

    p_ar_date_modified     := TO_CHAR(SYSDATE);
    p_ar_modified_by       := P_UA_NAME; --USER;

    v_ar_rec.date_modified := p_ar_date_modified;
    v_ar_rec.modified_by   := p_ar_modified_by;

    v_ar_ind.date_modified := TRUE;
    v_ar_ind.modified_by   := TRUE;

    v_ar_ind.date_created  := FALSE;
    v_ar_ind.created_by    := FALSE;

    v_ar_rec.ar_idseq     := p_ar_idseq;

 IF p_ar_ac_idseq IS NULL THEN
      v_ar_ind.ac_idseq := FALSE;
    ELSE
      v_ar_rec.ac_idseq := p_ar_ac_idseq;
      v_ar_ind.ac_idseq := TRUE;
    END IF;

    IF p_ar_registration_status IS NULL THEN
      v_ar_ind.registration_status := FALSE;
    ELSE
      v_ar_rec.registration_status := p_ar_registration_status;
      v_ar_ind.registration_status := TRUE;
    END IF;

    BEGIN
      cg$ac_registrations_view.upd(v_ar_rec, v_ar_ind);
    EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      p_return_code := 'API_AR_110'; -- error updating AC Registration
    END;
  END IF;

  -- 23-Mar-2004, W. Ver Hoef - added IF stmt for DEL per SPRF_2.1_03

  IF p_action = 'DEL' THEN              -- we are deleting a record

    IF p_ar_idseq IS NULL THEN
      p_return_code := 'API_AR_111' ;  -- for delete the ID is mandatory
   RETURN;
    ELSE
      IF NOT Sbrext_Common_Routines.ar_exists(p_ar_idseq) THEN
     p_return_code := 'API_AR_104'; -- AC Registration not found
     RETURN;
   END IF;
    END IF;

    v_ar_pk.ar_idseq := p_ar_idseq;

    SELECT ROWID
 INTO   v_ar_pk.the_rowid
    FROM   ac_registrations_view
    WHERE  ar_idseq = p_ar_idseq;

    v_ar_pk.jn_notes := NULL;

    BEGIN
      cg$ac_registrations_view.del(v_ar_pk);
   RETURN;
    EXCEPTION WHEN OTHERS THEN
      p_return_code := 'API_AR_112'; --Error deleting Complex DE
    END;

  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    NULL;
END set_registration;

-- SPRF_3.1_16i (TT#1001)
PROCEDURE set_contact_comm (
     P_UA_NAME       IN VARCHAR2
    ,p_return_code            OUT       VARCHAR2
    ,p_action                 IN        VARCHAR2
    ,p_ccomm_idseq            in  out   varchar2
    ,p_org_idseq              in  out   varchar2
    ,p_per_idseq              in  out   varchar2
    ,p_ctl_name               in  out   varchar2
    ,p_rank_order             in  out   number
    ,p_cyber_address          in  out   varchar2
    ,p_date_created           in  out   date
    ,p_created_by             in  out   varchar2
    ,p_date_modified          in  out   date
    ,p_modified_by            in  out   varchar2) IS

    /*
    ** set_contact_com: insert/update/delete a row in contact_comms_view
    ** S. Alred; 12/13/2005 -- no prior version
    */

    v_idSeq     contact_comms.ccomm_idseq%TYPE;
    r_con_comm  contact_comms_view%ROWTYPE;

  BEGIN
    p_return_code := NULL;

   IF (p_action NOT IN ('INS','UPD','DEL')) THEN
      p_return_code := 'API_CCOMM_700: No or Invalid action passed';
      RETURN;
    END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

    IF p_action = 'INS' THEN -- insert section
      -- check for mandatory columns
      IF (p_ctl_name IS NULL OR
          p_rank_order is NULL OR
          p_cyber_address is NULL) THEN
        p_return_code := 'API_CCOMM_100: Missing mandatory parameter(s): ';
        IF p_ctl_name is null then
          p_return_code := p_return_code || ' p_ctl_name ';
        END IF;
        IF p_rank_order is null then
          p_return_code := p_return_code || ' p_rank_order ';
        END IF;
        IF p_cyber_address is null then
          p_return_code := p_return_code || ' p_cyber_address ';
        END IF;
        RETURN;
      END IF;
      -- Validate FK references

      -- Validate ctl_name
      IF NOT sbrext_common_routines.comm_type_exists(p_ctl_name) THEN
        p_return_code := 'API_CCOMM_201: Incorrect ctl_name.';
        RETURN;
      END IF;

      -- Validate per_idseq if present
      IF p_per_idseq IS NOT NULL THEN
        IF NOT sbrext_common_routines.per_exists(p_per_idseq) THEN
          p_return_code := 'API_CCOMM_202: Incorrect per_idseq.';
          RETURN;
        END IF;
      END IF;

      -- Validate org_idseq if present
      IF p_org_idseq IS NOT NULL THEN
        IF NOT sbrext_common_routines.org_exists(p_org_idseq) THEN
          p_return_code := 'API_CCOMM_203: Incorrect org_idseq.';
          RETURN;
        END IF;
      END IF;

      -- Validate lengths of VARCHAR2 columns
      IF length(p_ctl_name) > sbrext_column_lengths.get_vc2_col_length(
                                p_owner => 'SBR'
                               ,p_tname => 'CONTACT_COMMS'
                               ,p_cname => 'CTL_NAME') THEN
        P_RETURN_CODE := 'API_CCOMM_111: ctl_name too long';
        RETURN;
      END IF;

      IF length(p_cyber_address) > sbrext_column_lengths.get_vc2_col_length(
                                p_owner => 'SBR'
                               ,p_tname => 'CONTACT_COMMS'
                               ,p_cname => 'CYBER_ADDRESS')THEN
        P_RETURN_CODE := 'API_CCOMM_113: cyber_address too long';
        RETURN;
      END IF;

      -- validate org/per arc

      IF p_per_idseq IS NOT NULL THEN
        IF p_org_idseq IS NOT NULL THEN
          p_return_code := 'API_ACC_553: Arc violation [org_idseq + per_idseq]';
        END IF;
      END IF;

      IF (p_per_idseq IS NULL AND p_org_idseq IS NULL) THEN
        p_return_code := 'API_ACC_560: Org-Per Arc violation [no values]';
      END If;

      -- check for duplicate [TBD]

      -- generate PK and assign other values
       p_ccomm_idseq  := admincomponent_crud.CMR_GUID;
       p_date_created := SYSDATE;
       p_created_by   := P_UA_NAME; --USER;

      -- set row
      INSERT INTO contact_comms_view (
         ccomm_idseq
        ,org_idseq
        ,per_idseq
        ,ctl_name
        ,rank_order
        ,cyber_address
        ,date_created
        ,created_by)
      VALUES (
         p_ccomm_idseq
        ,p_org_idseq
        ,p_per_idseq
        ,p_ctl_name
        ,p_rank_order
        ,p_cyber_address
        ,p_date_created
        ,p_created_by);

    END IF; -- end of INS section

    IF p_action = 'UPD' THEN -- update section
     admin_security_util.seteffectiveuser(p_ua_name);
      IF p_ccomm_idseq IS NULL THEN
        p_return_code := 'API_CCOMM_600: Missing primary key for update.';
        RETURN;
      END IF;

      -- load up existing values
      SELECT * INTO r_con_comm
      FROM   contact_comms_view
      WHERE  ccomm_idseq = p_ccomm_idseq;

      -- set changed values

      -- optional columns
      IF p_org_idseq IS NOT NULL THEN
        IF p_org_idseq = ' ' THEN
          r_con_comm.org_idseq := NULL;
        ELSE
          r_con_comm.org_idseq := p_org_idseq;
        END IF;
      END IF;

      IF p_per_idseq IS NOT NULL THEN
        IF p_per_idseq = ' ' THEN
          r_con_comm.per_idseq := NULL;
        ELSE
          r_con_comm.per_idseq := p_per_idseq;
        END IF;
      END IF;

      -- mandatory columns
      IF p_ctl_name IS NOT NULL THEN
        r_con_comm.ctl_name :=  p_ctl_name;
      END IF;

      IF p_rank_order IS NOT NULL THEN
        r_con_comm.rank_order := p_rank_order;
      END IF;

      IF p_cyber_address IS  NOT NULL THEN
        r_con_comm.cyber_address := p_cyber_address;
      END IF;

      -- validate org/per arc

      IF p_per_idseq IS NOT NULL THEN
        IF p_org_idseq IS NOT NULL THEN
          p_return_code := 'API_ACC_553: Arc violation [org_idseq + per_idseq]';
        END IF;
      END IF;

      IF (p_per_idseq IS NULL AND p_org_idseq IS NULL) THEN
        p_return_code := 'API_ACC_560: Org-Per Arc violation [no values]';
      END If;
      -- perform update
      p_modified_by   := P_UA_NAME; --USER;
      p_date_modified := SYSDATE;

      UPDATE  contact_comms_view
      SET     org_idseq            = r_con_comm.org_idseq
         ,    per_idseq            = r_con_comm.per_idseq
         ,    ctl_name             = r_con_comm.ctl_name
         ,    rank_order           = r_con_comm.rank_order
         ,    cyber_address        = r_con_comm.cyber_address
         ,    date_modified        = p_date_modified
         ,    modified_by          = p_modified_by
      WHERE ccomm_idseq = p_ccomm_idseq;

    END IF; -- end of UPD section

    IF p_action = 'DEL' THEN -- delete section
      IF p_ccomm_idseq IS NULL THEN
        P_RETURN_CODE := 'API_CCOMM_800: ccom_idseq needed to delete';
        RETURN;
      END IF;
      DELETE FROM contact_comms_view
      WHERE ccomm_idseq = p_ccomm_idseq;
    END IF;

    END set_contact_comm;

-- SPRF_3.1_16j (TT#1001)
PROCEDURE set_contact_addr (
     P_UA_NAME       IN  VARCHAR2
    ,p_return_code            OUT       VARCHAR2
    ,p_action                 IN        VARCHAR2
    ,p_caddr_idseq            in  out   varchar2
    ,p_org_idseq              in  out   varchar2
    ,p_per_idseq              in  out   varchar2
    ,p_atl_name               in  out   varchar2
    ,p_rank_order             in  out   number
    ,p_addr_line1             in  out   varchar2
    ,p_addr_line2             in  out   varchar2
    ,p_city                   in  out   varchar2
    ,p_state_prov             in  out   varchar2
    ,p_postal_code            in  out   varchar2
    ,p_country                in  out   varchar2
    ,p_date_created           in  out   date
    ,p_created_by             in  out   varchar2
    ,p_date_modified          in  out   date
    ,p_modified_by            in  out   varchar2) IS

    /*
    ** set_contact_addr: insert/update/delete a row in contact_addresses_view
    ** S. Alred; 12/14/2005 -- no prior version
    */

    v_idSeq     contact_addresses_view.caddr_idseq%TYPE;
    r_con_addr  contact_addresses_view%ROWTYPE;

  BEGIN
    p_return_code := NULL;

   IF (p_action NOT IN ('INS','UPD','DEL')) THEN
      p_return_code := 'API_CADDR_700: No or Invalid action passed';
      RETURN;
    END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

    IF p_action = 'INS' THEN -- insert section
      -- check for mandatory columns
      IF (p_atl_name    IS NULL OR
          p_rank_order  is NULL OR
          p_addr_line1  is NULL OR
          p_city        IS NULL OR
          p_state_prov  IS NULL OR
          p_postal_code IS NULL) THEN
        p_return_code := 'API_CADDR_100: Missing mandatory parameter(s): ';
        IF p_atl_name is null then
          p_return_code := p_return_code || ' p_atl_name ';
        END IF;
        IF p_rank_order is null then
          p_return_code := p_return_code || ' p_rank_order ';
        END IF;
        IF p_addr_line1 is null then
          p_return_code := p_return_code || ' p_addr_line1 ';
        END IF;
        IF p_city is null then
          p_return_code := p_return_code || ' p_city ';
        END IF;
        IF p_state_prov is null then
          p_return_code := p_return_code || ' p_state_prov ';
        END IF;
        IF p_postal_code is null then
          p_return_code := p_return_code || ' p_postal_code ';
        END IF;
        RETURN;
      END IF;
      -- Validate FK references

      -- Validate atl_name
      IF NOT sbrext_common_routines.addr_type_exists(p_atl_name) THEN
        p_return_code := 'API_CADDR_201: Incorrect atl_name.';
        RETURN;
      END IF;

      -- Validate per_idseq if present
      IF p_per_idseq IS NOT NULL THEN
        IF NOT sbrext_common_routines.per_exists(p_per_idseq) THEN
          p_return_code := 'API_CADDR_202: Incorrect per_idseq.';
          RETURN;
        END IF;
      END IF;

      -- Validate org_idseq if present
      IF p_org_idseq IS NOT NULL THEN
        IF NOT sbrext_common_routines.org_exists(p_org_idseq) THEN
          p_return_code := 'API_CADDR_203: Incorrect org_idseq.';
          RETURN;
        END IF;
      END IF;

      -- Validate lengths of VARCHAR2 columns
      IF length(p_atl_name) > sbrext_column_lengths.get_vc2_col_length(
                                p_owner => 'SBR'
                               ,p_tname => 'CONTACT_ADDRESSES'
                               ,p_cname => 'ATL_NAME') THEN
        P_RETURN_CODE := 'API_CADDR_111: atl_name too long';
        RETURN;
      END IF;

      IF length(p_addr_line1) > sbrext_column_lengths.get_vc2_col_length(
                                p_owner => 'SBR'
                               ,p_tname => 'CONTACT_ADDRESSES'
                               ,p_cname => 'ADDR_LINE1')THEN
        P_RETURN_CODE := 'API_CADDR_113: addr_line1 too long';
        RETURN;
      END IF;

      IF p_addr_line2 IS NOT NULL THEN
        IF length(p_addr_line2) > sbrext_column_lengths.get_vc2_col_length(
                                  p_owner => 'SBR'
                                 ,p_tname => 'CONTACT_ADDRESSES'
                                 ,p_cname => 'ADDR_LINE2')THEN
          P_RETURN_CODE := 'API_CADDR_114: addr_line2 too long';
          RETURN;
        END IF;
      END IF;

      IF length(p_city) > sbrext_column_lengths.get_vc2_col_length(
                                p_owner => 'SBR'
                               ,p_tname => 'CONTACT_ADDRESSES'
                               ,p_cname => 'CITY')THEN
        P_RETURN_CODE := 'API_CADDR_115: city too long';
        RETURN;
      END IF;

      IF length(p_state_prov) > sbrext_column_lengths.get_vc2_col_length(
                                p_owner => 'SBR'
                               ,p_tname => 'CONTACT_ADDRESSES'
                               ,p_cname => 'STATE_PROV')THEN
        P_RETURN_CODE := 'API_CADDR_116: state_prov too long';
        RETURN;
      END IF;

      IF length(p_postal_code) > sbrext_column_lengths.get_vc2_col_length(
                                p_owner => 'SBR'
                               ,p_tname => 'CONTACT_ADDRESSES'
                               ,p_cname => 'POSTAL_CODE')THEN
        P_RETURN_CODE := 'API_CADDR_117: postal_code too long';
        RETURN;
      END IF;

      IF p_country IS NOT NULL THEN
        IF length(p_country) > sbrext_column_lengths.get_vc2_col_length(
                                  p_owner => 'SBR'
                                 ,p_tname => 'CONTACT_ADDRESSES'
                                 ,p_cname => 'COUNTRY')THEN
          P_RETURN_CODE := 'API_CADDR_118: country too long';
          RETURN;
        END IF;
      END IF;

      -- validate org/per arc

      IF p_per_idseq IS NOT NULL THEN
        IF p_org_idseq IS NOT NULL THEN
          p_return_code := 'API_ACC_553: Arc violation [org_idseq + per_idseq]';
        END IF;
      END IF;

      IF (p_per_idseq IS NULL AND p_org_idseq IS NULL) THEN
        p_return_code := 'API_ACC_560: Org-Per Arc violation [no values]';
      END If;


      -- check for duplicate [TBD]

      -- generate PK and assign other values
       p_caddr_idseq  := admincomponent_crud.CMR_GUID;
       p_date_created := SYSDATE;
       p_created_by   := P_UA_NAME; --USER;

      -- set row
      INSERT INTO contact_addresses_view (
            caddr_idseq
          ,org_idseq
          ,per_idseq
          ,atl_name
          ,rank_order
          ,addr_line1
          ,addr_line2
          ,city
          ,state_prov
          ,postal_code
          ,country
          ,date_created
          ,created_by)
      VALUES (
           p_caddr_idseq
          ,p_org_idseq
          ,p_per_idseq
          ,p_atl_name
          ,p_rank_order
          ,p_addr_line1
          ,p_addr_line2
          ,p_city
          ,p_state_prov
          ,p_postal_code
          ,p_country
          ,p_date_created
          ,p_created_by );

    END IF; -- end of INS section

    IF p_action = 'UPD' THEN -- update section
      admin_security_util.seteffectiveuser(p_ua_name);
      IF p_caddr_idseq IS NULL THEN
        p_return_code := 'API_CADDR_600: Missing primary key for update.';
        RETURN;
      END IF;

      -- load up existing values
      SELECT * INTO r_con_addr
      FROM   contact_addresses_view
      WHERE  caddr_idseq = p_caddr_idseq;

      -- set changed values

      -- optional columns
      IF p_org_idseq IS NOT NULL THEN
        IF p_org_idseq = ' ' THEN
          r_con_addr.org_idseq := NULL;
        ELSE
          r_con_addr.org_idseq := p_org_idseq;
        END IF;
      END IF;

      IF p_per_idseq IS NOT NULL THEN
        IF p_per_idseq = ' ' THEN
          r_con_addr.per_idseq := NULL;
        ELSE
          r_con_addr.per_idseq := p_per_idseq;
        END IF;
      END IF;

      IF p_addr_line2 IS NOT NULL THEN
        IF p_addr_line2 = ' ' THEN
          r_con_addr.addr_line2 := NULL;
        ELSE
          r_con_addr.addr_line2 := p_addr_line2;
        END IF;
      END IF;


      IF p_country IS NOT NULL THEN
        IF p_country = ' ' THEN
          r_con_addr.country := NULL;
        ELSE
          r_con_addr.country := p_country;
        END IF;
      END IF;

      -- mandatory columns
      IF p_atl_name IS NOT NULL THEN
        r_con_addr.atl_name :=  p_atl_name;
      END IF;

      IF p_rank_order IS NOT NULL THEN
        r_con_addr.rank_order := p_rank_order;
      END IF;

      IF p_addr_line1 IS  NOT NULL THEN
        r_con_addr.addr_line1 := p_addr_line1;
      END IF;

      IF p_city IS  NOT NULL THEN
        r_con_addr.city := p_city;
      END IF;

      IF p_state_prov IS  NOT NULL THEN
        r_con_addr.state_prov := p_state_prov;
      END IF;

      IF p_postal_code IS  NOT NULL THEN
        r_con_addr.postal_code := p_postal_code;
      END IF;

      -- validate org/per arc

      IF p_per_idseq IS NOT NULL THEN
        IF p_org_idseq IS NOT NULL THEN
          p_return_code := 'API_ACC_553: Arc violation [org_idseq + per_idseq]';
        END IF;
      END IF;

      IF (p_per_idseq IS NULL AND p_org_idseq IS NULL) THEN
        p_return_code := 'API_ACC_560: Org-Per Arc violation [no values]';
      END If;

      -- perform update
      p_modified_by   := P_UA_NAME; --USER;
      p_date_modified := SYSDATE;

      UPDATE  contact_addresses_view
      SET      ORG_IDSEQ           =  r_con_addr.ORG_IDSEQ
         ,     PER_IDSEQ           =  r_con_addr.PER_IDSEQ
         ,     ATL_NAME            =  r_con_addr.ATL_NAME
         ,     RANK_ORDER          =  r_con_addr.RANK_ORDER
         ,     ADDR_LINE1          =  r_con_addr.ADDR_LINE1
         ,     ADDR_LINE2          =  r_con_addr.ADDR_LINE2
         ,     CITY                =  r_con_addr.CITY
         ,     STATE_PROV          =  r_con_addr.STATE_PROV
         ,     POSTAL_CODE         =  r_con_addr.POSTAL_CODE
         ,     COUNTRY             =  r_con_addr.COUNTRY
         ,     DATE_MODIFIED       =  P_DATE_MODIFIED
         ,     MODIFIED_BY         =  P_MODIFIED_BY
      WHERE caddr_idseq = p_caddr_idseq;

    END IF; -- end of UPD section

    IF p_action = 'DEL' THEN -- delete section
      IF p_caddr_idseq IS NULL THEN
        P_RETURN_CODE := 'API_CADDR_800: caddr_idseq needed to delete';
        RETURN;
      END IF;
      DELETE FROM contact_addresses_view
      WHERE caddr_idseq = p_caddr_idseq;
    END IF;

    END set_contact_addr;

-- SPRF_3.1_16k (TT#1001)
PROCEDURE set_ac_contact (
     P_UA_NAME       IN VARCHAR2
    ,p_return_code            OUT       VARCHAR2
    ,p_action                 IN        VARCHAR2
    ,p_acc_idseq              in  out   varchar2
    ,p_org_idseq              in  out   varchar2
    ,p_per_idseq              in  out   varchar2
    ,p_ac_idseq               in  out   varchar2
    ,p_rank_order             in  out   number
    ,p_date_created           in  out   date
    ,p_created_by             in  out   varchar2
    ,p_date_modified          in  out   date
    ,p_modified_by            in  out   varchar2
    ,p_cs_csi_idseq           in  out   varchar2
    ,p_ar_idseq              in  out   varchar2
    ,p_contact_role           in  out   varchar2) IS

    /*
    ** set_ac_contact: insert/update/delete a row in ac_contacts_view
    ** S. Alred; 12/14/2005 -- no prior version
    */

    v_idSeq   ac_contacts_view.acc_idseq%TYPE;
    r_ac_con  ac_contacts_view%ROWTYPE;

  BEGIN
    p_return_code := NULL;

    IF (p_action NOT IN ('INS','UPD','DEL')) THEN
      p_return_code := 'API_ACC_700: No or Invalid action passed';
      RETURN;
    END IF;
  IF p_ua_name IS NOT NULL THEN
    admin_security_util.seteffectiveuser(p_ua_name);
  END IF;

    IF p_action = 'INS' THEN -- insert section
      --  there are no mandatory columns
      -- Validate FK references

      -- Validate ac_idseq if present
      IF p_ac_idseq IS NOT NULL THEN
        IF NOT sbrext_common_routines.ac_exists(p_ac_idseq) THEN
        p_return_code := 'API_ACC_201: Invalid ac_idseq.';
          RETURN;
        END IF;
      END IF;

      -- Validate per_idseq if present
      IF p_per_idseq IS NOT NULL THEN
        IF NOT sbrext_common_routines.per_exists(p_per_idseq) THEN
          p_return_code := 'API_ACC_202: Incorrect per_idseq.';
          RETURN;
        END IF;
      END IF;

      -- Validate csi_idseq if present
      IF p_ar_idseq IS NOT NULL THEN
        IF NOT sbrext_common_routines.ar_exists(p_ar_idseq) THEN
          p_return_code := 'API_ACC_204: Incorrect ar_idseq.';
          RETURN;
        END IF;
      END IF;

      -- Validate cs_csi_idseq if present
      IF p_cs_csi_idseq IS NOT NULL THEN
        IF NOT sbrext_common_routines.org_exists(p_cs_csi_idseq) THEN
          p_return_code := 'API_ACC_205: Incorrect cs_csi_idseq.';
          RETURN;
        END IF;
      END IF;

      -- Validate contact_role if present
      IF p_contact_role IS NOT NULL THEN
        IF NOT sbrext_common_routines.contact_role_exists(p_contact_role) THEN
          p_return_code := 'API_ACC_206: Incorrect contact_role.';
          RETURN;
        END IF;
      END IF;


      -- Validate lengths of VARCHAR2 columns
      -- ** No columns to be validated

      -- check for duplicate [TBD]

      -- validate arcs
      IF p_ac_idseq IS NOT NULL THEN
        IF p_ar_idseq IS NOT NULL THEN
          p_return_code := 'API_ACC_550: Arc violation [ac_idseq + ar_idseq]';
        ELSIF p_cs_csi_idseq IS NOT NULL THEN
          p_return_code := 'API_ACC_551: Arc violation [ac_idseq + cs_csi_idseq]';
        END IF;
      END IF;

      IF p_ar_idseq IS NOT NULL THEN
        IF p_cs_csi_idseq IS NOT NULL THEN
          p_return_code := 'API_ACC_552:Arc violation [cs_csi_idseq + ar_idseq]';
        END IF;
      END IF;

      IF (p_ar_idseq IS NULL AND p_cs_csi_idseq IS NULL AND p_ac_idseq IS NULL) THEN
        p_return_code := 'API_ACC_560:  AC-AR-CS_CSI Arc violation [no values]';
      END If;

      IF p_per_idseq IS NOT NULL THEN
        IF p_org_idseq IS NOT NULL THEN
          p_return_code := 'API_ACC_553: Arc violation [org_idseq + per_idseq]';
        END IF;
      END IF;

      IF (p_per_idseq IS NULL AND p_org_idseq IS NULL) THEN
        p_return_code := 'API_ACC_560: Org-Per Arc violation [no values]';
      END If;

      -- generate PK and assign other values
       p_acc_idseq  := admincomponent_crud.CMR_GUID;
       p_date_created := SYSDATE;
       p_created_by   := P_UA_NAME; --USER;

      -- set row
      INSERT INTO ac_contacts_view (
         acc_idseq
        ,org_idseq
        ,per_idseq
        ,ac_idseq
        ,rank_order
        ,date_created
        ,created_by
        ,cs_csi_idseq
        ,ar_idseq
        ,contact_role)
      VALUES (
         p_acc_idseq
        ,p_org_idseq
        ,p_per_idseq
        ,p_ac_idseq
        ,p_rank_order
        ,p_date_created
        ,p_created_by
        ,p_cs_csi_idseq
        ,p_ar_idseq
        ,p_contact_role );

    END IF; -- end of INS section

    IF p_action = 'UPD' THEN -- update section
    admin_security_util.seteffectiveuser(p_ua_name);
      IF p_acc_idseq IS NULL THEN
        p_return_code := 'API_ACC_600: Missing primary key for update.';
        RETURN;
      END IF;

      -- load up existing values
      SELECT * INTO r_ac_con
      FROM   ac_contacts_view
      WHERE  acc_idseq = p_acc_idseq;

      -- set changed values

      -- optional columns
      IF p_org_idseq IS NOT NULL THEN
        IF p_org_idseq = ' ' THEN
          r_ac_con.org_idseq := NULL;
        ELSE
          r_ac_con.org_idseq := p_org_idseq;
        END IF;
      END IF;

      IF p_per_idseq IS NOT NULL THEN
        IF p_per_idseq = ' ' THEN
          r_ac_con.per_idseq := NULL;
        ELSE
          r_ac_con.per_idseq := p_per_idseq;
        END IF;
      END IF;

      IF p_ac_idseq IS NOT NULL THEN
        IF p_ac_idseq = ' ' THEN
          r_ac_con.ac_idseq := NULL;
        ELSE
          r_ac_con.ac_idseq := p_ac_idseq;
        END IF;
      END IF;


      IF p_ar_idseq IS NOT NULL THEN
        IF p_ar_idseq = ' ' THEN
          r_ac_con.ar_idseq := NULL;
        ELSE
          r_ac_con.ar_idseq := p_ar_idseq;
        END IF;
      END IF;

      IF p_cs_csi_idseq IS NOT NULL THEN
        IF p_cs_csi_idseq = ' ' THEN
          r_ac_con.cs_csi_idseq := NULL;
        ELSE
          r_ac_con.cs_csi_idseq := p_cs_csi_idseq;
        END IF;
      END IF;

      -- no mandatory columns

      -- validate arcs
      IF p_ac_idseq IS NOT NULL THEN
        IF p_ar_idseq IS NOT NULL THEN
          p_return_code := 'API_ACC_550: Arc violation [ac_idseq + ar_idseq]';
        ELSIF p_cs_csi_idseq IS NOT NULL THEN
          p_return_code := 'API_ACC_551: Arc violation [ac_idseq + cs_csi_idseq]';
        END IF;
      END IF;

      IF p_ar_idseq IS NOT NULL THEN
        IF p_cs_csi_idseq IS NOT NULL THEN
          p_return_code := 'API_ACC_552:Arc violation [cs_csi_idseq + ar_idseq]';
        END IF;
      END IF;

      IF (p_ar_idseq IS NULL AND p_cs_csi_idseq IS NULL AND p_ac_idseq IS NULL) THEN
        p_return_code := 'API_ACC_560:  AC-CSI-CS_CSI Arc violation [no values]';
      END If;

      IF p_per_idseq IS NOT NULL THEN
        IF p_org_idseq IS NOT NULL THEN
          p_return_code := 'API_ACC_553: Arc violation [org_idseq + per_idseq]';
        END IF;
      END IF;

      IF (p_per_idseq IS NULL AND p_org_idseq IS NULL) THEN
        p_return_code := 'API_ACC_560: Org-Per Arc violation [no values]';
      END If;

      -- perform update
      p_modified_by   := P_UA_NAME; --USER;
      p_date_modified := SYSDATE;

      UPDATE  ac_contacts_view
      SET  org_idseq            = r_ac_con.org_idseq
      ,    per_idseq            = r_ac_con.per_idseq
      ,    ac_idseq             = r_ac_con.ac_idseq
      ,    rank_order           = r_ac_con.rank_order
      ,    date_modified        = p_date_modified
      ,    modified_by          = p_modified_by
      ,    cs_csi_idseq         = r_ac_con.cs_csi_idseq
      ,    ar_idseq            = r_ac_con.ar_idseq
      ,    contact_role         = r_ac_con.contact_role
      WHERE acc_idseq = p_acc_idseq;

    END IF; -- end of UPD section

    IF p_action = 'DEL' THEN -- delete section
      IF p_acc_idseq IS NULL THEN
        P_RETURN_CODE := 'API_ACC_800: acc_idseq needed to delete';
        RETURN;
      END IF;
      DELETE FROM ac_contacts_view
      WHERE acc_idseq = p_acc_idseq;
    END IF;

    END set_ac_contact;



END SBREXT_SET_ROW;

/

  GRANT EXECUTE ON "SBREXT"."SBREXT_SET_ROW" TO PUBLIC;
 
  GRANT EXECUTE ON "SBREXT"."SBREXT_SET_ROW" TO "CDEBROWSER";
 
  GRANT DEBUG ON "SBREXT"."SBREXT_SET_ROW" TO "CDEBROWSER";
 
  GRANT EXECUTE ON "SBREXT"."SBREXT_SET_ROW" TO "DATA_LOADER";
 
  GRANT DEBUG ON "SBREXT"."SBREXT_SET_ROW" TO "DATA_LOADER";
 
  GRANT EXECUTE ON "SBREXT"."SBREXT_SET_ROW" TO "SBR" WITH GRANT OPTION;
 
  GRANT DEBUG ON "SBREXT"."SBREXT_SET_ROW" TO "SBR" WITH GRANT OPTION;
 
  GRANT EXECUTE ON "SBREXT"."SBREXT_SET_ROW" TO "APPLICATION_USER";
 
  GRANT DEBUG ON "SBREXT"."SBREXT_SET_ROW" TO "APPLICATION_USER";
 
  GRANT EXECUTE ON "SBREXT"."SBREXT_SET_ROW" TO "DER_USER";
