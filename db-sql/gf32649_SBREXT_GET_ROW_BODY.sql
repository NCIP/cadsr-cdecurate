--------------------------------------------------------
--  Please run with SBREXT account
--------------------------------------------------------
--------------------------------------------------------
--  File created - Thursday-April-04-2013   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body SBREXT_GET_ROW
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SBREXT"."SBREXT_GET_ROW" AS

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
      WHERE  long_name = p_ShortMeaning;

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
   NAME:       GET_VD
   PURPOSE:    Returns a row from Value_Domains based on either VD_IDSEQ (primary key)
               or Preferred Name, Context, and Version (unique key).  If Version is not
               supplied, the most recent version is returned.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/18/2001  Prerna Aggarwal     1. Created this procedure


   EXAMPLE USE:    GET_ROW. PROCEDURE GET_VD(
P_RETURN_CODE
,P_VD_VD_IDSEQ
,P_VD_PREFERRED_NAME
,P_VD_CONTE_IDSEQ
,P_VD_VERSION
,P_VD_PREFERRED_DEFINITION
,P_VD_LONG_NAME
,P_VD_ASL_NAME
,P_VD_CD_IDSEQ
,P_VD_LATEST_VERSION_IND
,P_VD_TYPE_FLAG
,P_VD_DTL_NAME
,P_VD_FORML_NAME
,P_VD_UOML_NAME
,P_VD_LOW_VALUE_NUM
,P_VD_HIGH_VALUE_NUM
,P_VD_MIN_LENGTH_NUM
,P_VD_MAX_LENGTH_NUM
,P_VD_DECIMAL_PLACE
,P_VD_CHAR_SET_NAME
,P_VD_BEGIN_DATE
,P_VD_END_DATE
,P_VD_CHANGE_NOTE
,P_VD_CREATED_BY
,P_VD_DATE_CREATED
,P_VD_MODIFIED_BY
,P_VD_DATE_MODIFIED
,P_VD_DELETED_IND);

******************************************************************************/
PROCEDURE GET_VD(
P_RETURN_CODE                OUT VARCHAR2
,P_VD_VD_IDSEQ                IN OUT VARCHAR2
,P_VD_PREFERRED_NAME        IN OUT VARCHAR2
,P_VD_CONTE_IDSEQ            IN OUT VARCHAR2
,P_VD_VERSION                IN OUT NUMBER
,P_VD_PREFERRED_DEFINITION  OUT VARCHAR2
,P_VD_LONG_NAME                OUT VARCHAR2
,P_VD_ASL_NAME                OUT VARCHAR2
,P_VD_CD_IDSEQ                OUT    VARCHAR2
,P_VD_LATEST_VERSION_IND    OUT    VARCHAR2
,P_VD_TYPE_FLAG                OUT    VARCHAR
,P_VD_DTL_NAME                OUT    VARCHAR2
,P_VD_FORML_NAME             OUT VARCHAR2
,P_VD_UOML_NAME             OUT    VARCHAR2
,P_VD_LOW_VALUE_NUM            OUT    VARCHAR2
,P_VD_HIGH_VALUE_NUM        OUT    VARCHAR2
,P_VD_MIN_LENGTH_NUM        OUT    NUMBER
,P_VD_MAX_LENGTH_NUM        OUT    NUMBER
,P_VD_DECIMAL_PLACE         OUT    NUMBER
,P_VD_CHAR_SET_NAME            OUT    VARCHAR2
,P_VD_BEGIN_DATE            OUT    VARCHAR2
,P_VD_END_DATE                OUT    VARCHAR2
,P_VD_CHANGE_NOTE            OUT    VARCHAR2
,P_VD_CREATED_BY            OUT    VARCHAR2
,P_VD_DATE_CREATED            OUT    VARCHAR2
,P_VD_MODIFIED_BY            OUT    VARCHAR2
,P_VD_DATE_MODIFIED            OUT    VARCHAR2
,P_VD_DELETED_IND            OUT    VARCHAR2)    IS



vd_rec value_domains_view%ROWTYPE;
v_version value_domains_view.version%TYPE;

BEGIN
 p_return_code := NULL;
 --At least one of the ID or Name parameters has to be provided
 IF P_VD_VD_IDSEQ IS NOT NULL THEN  --Retrieve the Value Domain by key

    BEGIN
         SELECT *
         INTO vd_rec
         FROM value_domains_view
         WHERE vd_idseq = p_vd_vd_idseq;
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
               p_return_code := 'API_VD_005';--VD not found
              RETURN;
         WHEN OTHERS THEN
               p_return_code := 'API_VD_009'; --others on select of VD
              RETURN;
    END;

    /*If P_VD_PREFERRED_NAME not null and does not match the retrieved Preferred Name
    then assign the error code */
    IF(P_VD_PREFERRED_NAME IS NOT NULL AND (P_VD_PREFERRED_NAME <> vd_rec.preferred_name)) THEN
      p_return_code := 'API_VD_002';-- Retrieved Preferred Name Does not Match with parameter
         RETURN;
    END IF;

    /*If the P_VD_CONTE_IDSEQ is not null and does not match the retrieved context, assign the error code */
    IF(P_VD_CONTE_IDSEQ IS NOT NULL AND (P_VD_CONTE_IDSEQ <> vd_rec.conte_idseq)) THEN
         p_return_code := 'API_VD_003';-- Retrieved Context does not Match with parameter
      RETURN;
    END IF;

       /*If the P_VD_VERSION is not null and does not match the retrieved Version
       then assign the error code and return*/
      IF(P_VD_VERSION IS NOT NULL AND (P_VD_VERSION <> vd_rec.version)) THEN
      p_return_code := 'API_VD_004';-- Retrieved Version Name Does not Match with parameter
      RETURN;
       END IF;

       P_VD_PREFERRED_NAME             := vd_rec.preferred_name;
    P_VD_CONTE_IDSEQ            := vd_rec.conte_idseq;
    P_VD_VERSION                 := vd_rec.version;
    P_VD_PREFERRED_DEFINITION     := vd_rec.preferred_definition;
    P_VD_LONG_NAME                := vd_rec.long_name;
    P_VD_ASL_NAME                  := vd_rec.asl_name;
    P_VD_CD_IDSEQ                  := vd_rec.cd_idseq;
    P_VD_LATEST_VERSION_IND       := vd_rec.latest_version_ind;
    P_VD_TYPE_FLAG                := vd_rec.vd_type_flag;
    P_VD_DTL_NAME                  := vd_rec.dtl_name;
    P_VD_FORML_NAME             := vd_rec.forml_name;
    P_VD_LOW_VALUE_NUM            := vd_rec.low_value_num;
    P_VD_HIGH_VALUE_NUM            := vd_rec.high_value_num;
    P_VD_MIN_LENGTH_NUM            := vd_rec.min_length_num;
    P_VD_MAX_LENGTH_NUM           := vd_rec.max_length_num;
    P_VD_DECIMAL_PLACE          := vd_rec.decimal_place;
    P_VD_CHAR_SET_NAME            := vd_rec.char_set_name;
    P_VD_BEGIN_DATE                   := vd_rec.begin_date;
    P_VD_END_DATE                := vd_rec.end_date;
    P_VD_CHANGE_NOTE            := vd_rec.change_note;
    P_VD_CREATED_BY                := vd_rec.created_by;
    P_VD_DATE_CREATED            := vd_rec.date_created;
    P_VD_MODIFIED_BY            := vd_rec.modified_by;
    P_VD_DATE_MODIFIED            := vd_rec.date_modified;
    P_VD_DELETED_IND            := vd_rec.deleted_ind;

  ELSE  --Key is not provided, retrieve by name, Version and Context
    IF(P_VD_PREFERRED_NAME IS NOT NULL AND P_VD_CONTE_IDSEQ IS NOT NULL) THEN
      IF P_VD_VERSION IS NOT NULL THEN
        v_version := P_VD_VERSION;
      ELSE
        v_version := Sbrext_Common_Routines.get_ac_version(p_vd_preferred_name, p_vd_conte_idseq, 'VALUEDOMAIN');
        IF(v_version = 0) THEN
          p_return_code := 'API_VD_005';--VD not found
          RETURN;
        END IF;
      END IF;

      /*Retrieve from Value_Domain based on Context, Preferred Name and Version*/
      BEGIN

         SELECT *
         INTO vd_rec
         FROM value_domains_view
         WHERE preferred_name = P_VD_PREFERRED_NAME
         AND conte_idseq = P_VD_CONTE_IDSEQ
         AND version = v_version;

      EXCEPTION
           WHEN NO_DATA_FOUND THEN
               --If the Value_Domain is not found assign error code and return
               p_return_code := 'API_VD_005';--Value_Domain not found
                RETURN;

         WHEN OTHERS THEN
               p_return_code := 'API_VD_009';-- Others on select from Value_Domains_View
                RETURN;
      END;

      -- Assign the data retrieved to the parameters
      P_VD_VD_IDSEQ                  := vd_rec.vd_idseq;
      P_VD_PREFERRED_NAME         := vd_rec.preferred_name;
      P_VD_CONTE_IDSEQ             := vd_rec.conte_idseq;
      P_VD_VERSION                  := vd_rec.version;
      P_VD_PREFERRED_DEFINITION  := vd_rec.preferred_definition;
      P_VD_LONG_NAME             := vd_rec.long_name;
      P_VD_ASL_NAME                  := vd_rec.asl_name;
      P_VD_CD_IDSEQ                  := vd_rec.cd_idseq;
      P_VD_LATEST_VERSION_IND    := vd_rec.latest_version_ind;
      P_VD_TYPE_FLAG             := vd_rec.vd_type_flag;
      P_VD_DTL_NAME                   := vd_rec.dtl_name;
      P_VD_FORML_NAME              := vd_rec.forml_name;
      P_VD_UOML_NAME             := vd_rec.uoml_name;
      P_VD_LOW_VALUE_NUM            := vd_rec.low_value_num;
      P_VD_HIGH_VALUE_NUM         := vd_rec.high_value_num;
      P_VD_MIN_LENGTH_NUM         := vd_rec.min_length_num;
      P_VD_MAX_LENGTH_NUM          := vd_rec.max_length_num;
      P_VD_DECIMAL_PLACE              := vd_rec.decimal_place;
      P_VD_CHAR_SET_NAME            := vd_rec.char_set_name;
      P_VD_BEGIN_DATE                := vd_rec.begin_date;
      P_VD_END_DATE                    := vd_rec.end_date;
      P_VD_CHANGE_NOTE                := vd_rec.change_note;
      P_VD_CREATED_BY                := vd_rec.created_by;
      P_VD_DATE_CREATED                := vd_rec.date_created;
      P_VD_MODIFIED_BY                := vd_rec.modified_by;
      P_VD_DATE_MODIFIED         := vd_rec.date_modified;
      P_VD_DELETED_IND             := vd_rec.deleted_ind;

  ELSE
    p_return_code := 'API_VD_001';--PK or Name and Context must be provided
    RETURN;
END IF;
END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
       NULL;
   WHEN OTHERS THEN
       NULL;
END GET_VD;

PROCEDURE GET_VD(
P_RETURN_CODE                OUT VARCHAR2
,P_VD_VD_IDSEQ                IN OUT VARCHAR2
,P_VD_PREFERRED_NAME        IN OUT VARCHAR2
,P_VD_CONTE_IDSEQ            IN OUT VARCHAR2
,P_VD_VERSION                IN OUT NUMBER
,P_VD_PREFERRED_DEFINITION  OUT VARCHAR2
,P_VD_LONG_NAME                OUT VARCHAR2
,P_VD_ASL_NAME                OUT VARCHAR2
,P_VD_CD_IDSEQ                OUT    VARCHAR2
,P_VD_LATEST_VERSION_IND    OUT    VARCHAR2
,P_VD_TYPE_FLAG                OUT    VARCHAR
,P_VD_DTL_NAME                OUT    VARCHAR2
,P_VD_FORML_NAME             OUT VARCHAR2
,P_VD_UOML_NAME             OUT    VARCHAR2
,P_VD_LOW_VALUE_NUM            OUT    VARCHAR2
,P_VD_HIGH_VALUE_NUM        OUT    VARCHAR2
,P_VD_MIN_LENGTH_NUM        OUT    NUMBER
,P_VD_MAX_LENGTH_NUM        OUT    NUMBER
,P_VD_DECIMAL_PLACE         OUT    NUMBER
,P_VD_CHAR_SET_NAME            OUT    VARCHAR2
,P_VD_BEGIN_DATE            OUT    VARCHAR2
,P_VD_END_DATE                OUT    VARCHAR2
,P_VD_CHANGE_NOTE            OUT    VARCHAR2
,P_VD_CREATED_BY            OUT    VARCHAR2
,P_VD_DATE_CREATED            OUT    VARCHAR2
,P_VD_MODIFIED_BY            OUT    VARCHAR2
,P_VD_DATE_MODIFIED            OUT    VARCHAR2
,P_VD_DELETED_IND            OUT    VARCHAR2
,P_VD_REP_IDSEQ        OUT    VARCHAR2
,P_VD_QUALIFIER            OUT    VARCHAR2
,P_VD_ORIGIN            OUT    VARCHAR2
,P_VD_CONDR_IDSEQ            OUT    VARCHAR2)    IS



vd_rec value_domains_view%ROWTYPE;
v_version value_domains_view.version%TYPE;

BEGIN
 p_return_code := NULL;
 --At least one of the ID or Name parameters has to be provided
 IF P_VD_VD_IDSEQ IS NOT NULL THEN  --Retrieve the Value Domain by key

    BEGIN
         SELECT *
         INTO vd_rec
         FROM value_domains_view
         WHERE vd_idseq = p_vd_vd_idseq;
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
               p_return_code := 'API_VD_005';--VD not found
              RETURN;
         WHEN OTHERS THEN
               p_return_code := 'API_VD_009'; --others on select of VD
              RETURN;
    END;

    /*If P_VD_PREFERRED_NAME not null and does not match the retrieved Preferred Name
    then assign the error code */
    IF(P_VD_PREFERRED_NAME IS NOT NULL AND (P_VD_PREFERRED_NAME <> vd_rec.preferred_name)) THEN
      p_return_code := 'API_VD_002';-- Retrieved Preferred Name Does not Match with parameter
         RETURN;
    END IF;

    /*If the P_VD_CONTE_IDSEQ is not null and does not match the retrieved context, assign the error code */
    IF(P_VD_CONTE_IDSEQ IS NOT NULL AND (P_VD_CONTE_IDSEQ <> vd_rec.conte_idseq)) THEN
         p_return_code := 'API_VD_003';-- Retrieved Context does not Match with parameter
      RETURN;
    END IF;

       /*If the P_VD_VERSION is not null and does not match the retrieved Version
       then assign the error code and return*/
      IF(P_VD_VERSION IS NOT NULL AND (P_VD_VERSION <> vd_rec.version)) THEN
      p_return_code := 'API_VD_004';-- Retrieved Version Name Does not Match with parameter
      RETURN;
       END IF;

       P_VD_PREFERRED_NAME             := vd_rec.preferred_name;
    P_VD_CONTE_IDSEQ            := vd_rec.conte_idseq;
    P_VD_VERSION                 := vd_rec.version;
    P_VD_PREFERRED_DEFINITION     := vd_rec.preferred_definition;
    P_VD_LONG_NAME                := vd_rec.long_name;
    P_VD_ASL_NAME                  := vd_rec.asl_name;
    P_VD_CD_IDSEQ                  := vd_rec.cd_idseq;
    P_VD_LATEST_VERSION_IND       := vd_rec.latest_version_ind;
    P_VD_TYPE_FLAG                := vd_rec.vd_type_flag;
    P_VD_DTL_NAME                  := vd_rec.dtl_name;
    P_VD_FORML_NAME             := vd_rec.forml_name;
    P_VD_LOW_VALUE_NUM            := vd_rec.low_value_num;
    P_VD_HIGH_VALUE_NUM            := vd_rec.high_value_num;
    P_VD_MIN_LENGTH_NUM            := vd_rec.min_length_num;
    P_VD_MAX_LENGTH_NUM           := vd_rec.max_length_num;
    P_VD_DECIMAL_PLACE          := vd_rec.decimal_place;
    P_VD_CHAR_SET_NAME            := vd_rec.char_set_name;
    P_VD_BEGIN_DATE                   := vd_rec.begin_date;
    P_VD_END_DATE                := vd_rec.end_date;
    P_VD_CHANGE_NOTE            := vd_rec.change_note;
    P_VD_CREATED_BY                := vd_rec.created_by;
    P_VD_DATE_CREATED            := vd_rec.date_created;
    P_VD_MODIFIED_BY            := vd_rec.modified_by;
    P_VD_DATE_MODIFIED            := vd_rec.date_modified;
    P_VD_DELETED_IND            := vd_rec.deleted_ind;
    P_VD_REP_IDSEQ            := vd_rec.rep_idseq;
    P_VD_QUALIFIER            := vd_rec.qualifier_name;
    P_VD_ORIGIN        := vd_rec.date_modified;
    P_VD_CONDR_IDSEQ            := vd_rec.deleted_ind;

  ELSE  --Key is not provided, retrieve by name, Version and Context
    IF(P_VD_PREFERRED_NAME IS NOT NULL AND P_VD_CONTE_IDSEQ IS NOT NULL) THEN
      IF P_VD_VERSION IS NOT NULL THEN
        v_version := P_VD_VERSION;
      ELSE
        v_version := Sbrext_Common_Routines.get_ac_version(p_vd_preferred_name, p_vd_conte_idseq, 'VALUEDOMAIN');
        IF(v_version = 0) THEN
          p_return_code := 'API_VD_005';--VD not found
          RETURN;
        END IF;
      END IF;

      /*Retrieve from Value_Domain based on Context, Preferred Name and Version*/
      BEGIN

         SELECT *
         INTO vd_rec
         FROM value_domains_view
         WHERE preferred_name = P_VD_PREFERRED_NAME
         AND conte_idseq = P_VD_CONTE_IDSEQ
         AND version = v_version;

      EXCEPTION
           WHEN NO_DATA_FOUND THEN
               --If the Value_Domain is not found assign error code and return
               p_return_code := 'API_VD_005';--Value_Domain not found
                RETURN;

         WHEN OTHERS THEN
               p_return_code := 'API_VD_009';-- Others on select from Value_Domains_View
                RETURN;
      END;

      -- Assign the data retrieved to the parameters
      P_VD_VD_IDSEQ                  := vd_rec.vd_idseq;
      P_VD_PREFERRED_NAME         := vd_rec.preferred_name;
      P_VD_CONTE_IDSEQ             := vd_rec.conte_idseq;
      P_VD_VERSION                  := vd_rec.version;
      P_VD_PREFERRED_DEFINITION  := vd_rec.preferred_definition;
      P_VD_LONG_NAME             := vd_rec.long_name;
      P_VD_ASL_NAME                  := vd_rec.asl_name;
      P_VD_CD_IDSEQ                  := vd_rec.cd_idseq;
      P_VD_LATEST_VERSION_IND    := vd_rec.latest_version_ind;
      P_VD_TYPE_FLAG             := vd_rec.vd_type_flag;
      P_VD_DTL_NAME                   := vd_rec.dtl_name;
      P_VD_FORML_NAME              := vd_rec.forml_name;
      P_VD_UOML_NAME             := vd_rec.uoml_name;
      P_VD_LOW_VALUE_NUM            := vd_rec.low_value_num;
      P_VD_HIGH_VALUE_NUM         := vd_rec.high_value_num;
      P_VD_MIN_LENGTH_NUM         := vd_rec.min_length_num;
      P_VD_MAX_LENGTH_NUM          := vd_rec.max_length_num;
      P_VD_DECIMAL_PLACE              := vd_rec.decimal_place;
      P_VD_CHAR_SET_NAME            := vd_rec.char_set_name;
      P_VD_BEGIN_DATE                := vd_rec.begin_date;
      P_VD_END_DATE                    := vd_rec.end_date;
      P_VD_CHANGE_NOTE                := vd_rec.change_note;
      P_VD_CREATED_BY                := vd_rec.created_by;
      P_VD_DATE_CREATED                := vd_rec.date_created;
      P_VD_MODIFIED_BY                := vd_rec.modified_by;
      P_VD_DATE_MODIFIED         := vd_rec.date_modified;
      P_VD_DELETED_IND             := vd_rec.deleted_ind;

  ELSE
    p_return_code := 'API_VD_001';--PK or Name and Context must be provided
    RETURN;
END IF;
END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
       NULL;
   WHEN OTHERS THEN
       NULL;
END GET_VD;


/******************************************************************************
   NAME:       GET_CONTEXT
   PURPOSE:    Gets a Single Row Of Context Based on either CONTE_IDSEQ
               or Name and Version

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/23/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_CONTEXT(
P_RETURN_CODE
,P_CT_CONTE_IDSEQ
,P_CT_NAME
,P_CT_VERSION
,P_CT_LL_NAME
,P_CT_PAL_NAME
,P_CT_DESCRIPTION
,P_CT_LANGUAGE
,P_CT_CREATED_BY
,P_CT_DATE_CREATED
,P_CT_MODIFIED_BY
,P_CT_DATE_MODIFIED );

******************************************************************************/


PROCEDURE GET_CONTEXT(
P_RETURN_CODE                OUT VARCHAR2
,P_CT_CONTE_IDSEQ             IN OUT VARCHAR2
,P_CT_NAME                    IN OUT VARCHAR2
,P_CT_VERSION                IN OUT NUMBER
,P_CT_LL_NAME                OUT VARCHAR2
,P_CT_PAL_NAME                OUT VARCHAR2
,P_CT_DESCRIPTION            OUT VARCHAR2
,P_CT_LANGUAGE                OUT VARCHAR2
,P_CT_CREATED_BY            OUT VARCHAR2
,P_CT_DATE_CREATED            OUT VARCHAR2
,P_CT_MODIFIED_BY            OUT VARCHAR2
,P_CT_DATE_MODIFIED            OUT VARCHAR2)    IS

ct_rec contexts_view%ROWTYPE;
v_version contexts_view.version%TYPE;


BEGIN
  p_return_code := NULL;
  --At least one of the ID or Name parameters has to be provided
  IF P_CT_CONTE_IDSEQ IS NOT NULL THEN  --Retrieve the Context by key

    BEGIN
      SELECT *
      INTO ct_rec
      FROM contexts_view
      WHERE conte_idseq = p_ct_conte_idseq;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
             p_return_code := 'API_CT_005';--Context not found
           RETURN;
      WHEN OTHERS THEN
             p_return_code := 'API_CT_009'; --Others on select from contexts_view
           RETURN;
    END;

    /*If P_CT_NAME is not null and does not match the retrieved Name, assign error code */
    IF(P_CT_NAME IS NOT NULL AND (P_CT_NAME <> ct_rec.name)) THEN
      p_return_code := 'API_CT_002';-- Retrieved Name Does not Match with parameter
      RETURN;
    END IF;

    /*If the P_CT_VERSION is not null and does not match the retrieved Version hen assign error code and exit*/
    IF(P_CT_VERSION IS NOT NULL AND (P_CT_VERSION <> ct_rec.version)) THEN
      p_return_code := 'API_CT_004';-- Retrieved Version Name Does not Match with parameter
      RETURN;
    END IF;

    P_CT_NAME                := ct_rec.name;
    P_CT_VERSION           := ct_rec.version;
    P_CT_LL_NAME            := ct_rec.ll_name;
    P_CT_PAL_NAME            := ct_rec.pal_name;
    P_CT_DESCRIPTION     := ct_rec.description;
    P_CT_LANGUAGE         := ct_rec.LANGUAGE;
    P_CT_CREATED_BY     := ct_rec.created_by;
    P_CT_DATE_CREATED     := ct_rec.date_created;
    P_CT_MODIFIED_BY     := ct_rec.modified_by;
    P_CT_DATE_MODIFIED  := ct_rec.date_modified;

  ELSE  --Key is not provided, retrieve by name, Version
   IF(P_CT_NAME IS NOT NULL) THEN
     IF P_CT_VERSION IS NOT NULL THEN
       v_version := P_CT_VERSION;
     ELSE
       v_version := Sbrext_Common_Routines.get_ct_version(p_ct_name);
       IF(v_version = 0) THEN
         p_return_code := 'API_CT_005';--Context not found
         RETURN;
       END IF;
     END IF;

     /*Retrieve Context based on Name and Version*/
     BEGIN

       SELECT *
       INTO ct_rec
       FROM contexts_view
       WHERE name = p_ct_name
       AND version = v_version;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
               p_return_code := 'API_CT_005'; --Context not found
            RETURN;
       WHEN OTHERS THEN
               p_return_code := 'API_CT_009'; --Others on select from Contexts_View
            RETURN;
     END;

     -- Assign the data retrieved to the parameters
     P_CT_CONTE_IDSEQ    := ct_rec.conte_idseq;
     P_CT_NAME                := ct_rec.name;
     P_CT_VERSION           := ct_rec.version;
     P_CT_LL_NAME            := ct_rec.ll_name;
     P_CT_PAL_NAME            := ct_rec.pal_name;
     P_CT_DESCRIPTION    := ct_rec.description;
     P_CT_LANGUAGE        := ct_rec.LANGUAGE;
     P_CT_CREATED_BY    := ct_rec.created_by;
     P_CT_DATE_CREATED    := ct_rec.date_created;
     P_CT_MODIFIED_BY    := ct_rec.modified_by;
     P_CT_DATE_MODIFIED := ct_rec.date_modified;

  ELSE
    p_return_code := 'API_CT_001';--PK or Name and Version must be passed
    RETURN;
  END IF;
END IF;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
       NULL;
   WHEN OTHERS THEN
       NULL;
END GET_CONTEXT;




/******************************************************************************
   NAME:       GET_CD
   PURPOSE:    Gets a Single Row Of Conceptual Domain Based on either CD_IDSEQ
               or Preferred Name, Context, and Version

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/23/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_CD(
P_RETURN_CODE
,P_CD_CD_IDSEQ
,P_CD_PREFERRED_NAME
,P_CD_CT_IDSEQ
,P_CD_VERSION
,P_CD_PREFERRED_DEFINITION
,P_CD_LONG_NAME
,P_CD_ASL_NAME
,P_CD_DIMENSIONALITY
,P_CD_LATEST_VERSION_IND
,P_CD_BEGIN_DATE
,P_CD_END_DATE
,P_CD_CHANGE_NOTE
,P_CD_CREATED_BY
,P_CD_DATE_CREATED
,P_CD_MODIFIED_BY
,P_CD_DATE_MODIFIED
,P_CD_DELETED_IND          );

******************************************************************************/

PROCEDURE GET_CD(
P_RETURN_CODE                OUT VARCHAR2
,P_CD_CD_IDSEQ                IN OUT VARCHAR2
,P_CD_PREFERRED_NAME        IN OUT VARCHAR2
,P_CD_CT_IDSEQ                IN OUT VARCHAR2
,P_CD_VERSION                IN OUT NUMBER
,P_CD_PREFERRED_DEFINITION  OUT VARCHAR2
,P_CD_LONG_NAME                OUT VARCHAR2
,P_CD_ASL_NAME                OUT VARCHAR2
,P_CD_DIMENSIONALITY        OUT    VARCHAR2
,P_CD_LATEST_VERSION_IND    OUT    VARCHAR2
,P_CD_BEGIN_DATE            OUT    VARCHAR2
,P_CD_END_DATE                OUT    VARCHAR2
,P_CD_CHANGE_NOTE            OUT VARCHAR2
,P_CD_CREATED_BY            OUT    VARCHAR2
,P_CD_DATE_CREATED            OUT    VARCHAR2
,P_CD_MODIFIED_BY            OUT    VARCHAR2
,P_CD_DATE_MODIFIED            OUT    VARCHAR2
,P_CD_DELETED_IND            OUT    VARCHAR2)    IS

cd_rec    conceptual_domains_view%ROWTYPE;
v_version conceptual_domains_view.version%TYPE;


BEGIN
  p_return_code := NULL;
  --At least one of the ID or Name parameters has to be provided
  IF P_CD_CD_IDSEQ IS NOT NULL THEN  --Retrieve the Conceptual Domain by key

    BEGIN
         SELECT *
         INTO cd_rec
         FROM conceptual_domains_view
         WHERE cd_idseq = p_cd_cd_idseq;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_return_code := 'API_CD_005'; --Conceptual Domain not found
            RETURN;
        WHEN OTHERS THEN
             p_return_code := 'API_CD_009'; --Other raised on select from Conceptual_Domains_View
             RETURN;
    END;

    /*If P_CD_PREFERRED_NAME is not null and does not match retrieved Preferred Name
       then assign the error code */
    IF(P_CD_PREFERRED_NAME IS NOT NULL AND (P_CD_PREFERRED_NAME <> cd_rec.preferred_name)) THEN
      p_return_code := 'API_CD_002';-- Retrieved Preferred Name Does not Match with parameter
      RETURN;
    END IF;

    /*If the P_CD_CT_IDSEQ is not null and does not match the retrieved Context then assign the error code and RETURN*/
    IF(P_CD_CT_IDSEQ IS NOT NULL AND (P_CD_CT_IDSEQ <> cd_rec.conte_idseq)) THEN
      p_return_code := 'API_CD_003';-- Retrieved Context does not Match with parameter
      RETURN;
    END IF;

    /*If the P_CD_VERSION is not null and does not match the retrieved Version
         then assign the error code and return*/
    IF(P_CD_VERSION IS NOT NULL AND (P_CD_VERSION <> cd_rec.version)) THEN
      p_return_code := 'API_CD_004';-- Retrieved Version Name Does not Match with parameter
      RETURN;
    END IF;

    -- Assign the data retrieved to the parameters
    P_CD_PREFERRED_NAME           := cd_rec.preferred_name;
    P_CD_CT_IDSEQ              := cd_rec.conte_idseq;
    P_CD_VERSION             := cd_rec.version;
    P_CD_PREFERRED_DEFINITION  := cd_rec.preferred_definition;
    P_CD_LONG_NAME             := cd_rec.long_name;
    P_CD_ASL_NAME             := cd_rec.asl_name;
    P_CD_DIMENSIONALITY      := cd_rec.dimensionality;
    P_CD_LATEST_VERSION_IND  := cd_rec.latest_version_ind;
    P_CD_BEGIN_DATE          := cd_rec.begin_date;
    P_CD_END_DATE             := cd_rec.end_date;
    P_CD_CHANGE_NOTE         := cd_rec.change_note;
    P_CD_CREATED_BY             := cd_rec.created_by;
    P_CD_DATE_CREATED         := cd_rec.date_created;
    P_CD_MODIFIED_BY         := cd_rec.modified_by;
    P_CD_DATE_MODIFIED         := cd_rec.date_modified;
    P_CD_DELETED_IND         := cd_rec.deleted_ind;

  ELSE  --Key is not provided, retrieve by name, Version and Context
   IF(P_CD_PREFERRED_NAME IS NOT NULL AND P_CD_CT_IDSEQ IS NOT NULL) THEN
     IF P_CD_VERSION IS NOT NULL THEN
       v_version := P_CD_VERSION;
     ELSE
       v_version := Sbrext_Common_Routines.get_ac_version(P_CD_PREFERRED_NAME, P_CD_CT_IDSEQ,'CONCEPTUALDOMAIN');
       IF(v_version = 0) THEN
         p_return_code := 'API_CD_005';--CD not found
         RETURN;
       END IF;
     END IF;
     /*Retrieve the Conceptual Domain row based on Context, Preferred Name and Version number*/

     BEGIN
       SELECT *
       INTO cd_rec
       FROM conceptual_domains_view
       WHERE preferred_name = P_CD_PREFERRED_NAME
       AND   conte_idseq = P_CD_CT_IDSEQ
       AND   version = v_version;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
               p_return_code := 'API_CD_005'; -- CD Not found
            RETURN;
       WHEN OTHERS THEN
               p_return_code := 'API_CD_009'; -- Other raised in select from Conceptual_Domains_View
            RETURN;
     END;

     -- Assign the data retrieved to the parameters
     P_CD_CD_IDSEQ                    := cd_rec.cd_idseq;
     P_CD_PREFERRED_NAME           := cd_rec.preferred_name;
     P_CD_CT_IDSEQ               := cd_rec.conte_idseq;
     P_CD_VERSION                   := cd_rec.version;
     P_CD_PREFERRED_DEFINITION  := cd_rec.preferred_definition;
     P_CD_LONG_NAME              := cd_rec.long_name;
     P_CD_ASL_NAME              := cd_rec.asl_name;
     P_CD_DIMENSIONALITY        := cd_rec.dimensionality;
     P_CD_LATEST_VERSION_IND    := cd_rec.latest_version_ind;
     P_CD_BEGIN_DATE            := cd_rec.begin_date;
     P_CD_END_DATE              := cd_rec.end_date;
     P_CD_CHANGE_NOTE              := cd_rec.change_note;
     P_CD_CREATED_BY              := cd_rec.created_by;
     P_CD_DATE_CREATED          := cd_rec.date_created;
     P_CD_MODIFIED_BY              := cd_rec.modified_by;
     P_CD_DATE_MODIFIED          := cd_rec.date_modified;
     P_CD_DELETED_IND              := cd_rec.deleted_ind;

  ELSE
    P_RETURN_CODE := 'API_CD_001';--PK or Name, Context, and Version must be passed
    RETURN;
  END IF;
END IF;

 EXCEPTION
    WHEN NO_DATA_FOUND THEN
       NULL;
    WHEN OTHERS THEN
       NULL;
END GET_CD;


/******************************************************************************
   NAME:       GET_DEC
   PURPOSE:    Gets a Single Row Of Data Element Concepts Based on either ID
               or Preferred Name, Context, and Version

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/23/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_DEC(
P_RETURN_CODE
,P_DEC_IDSEQ
,P_DEC_PREFERRED_NAME
,P_DEC_CONTE_IDSEQ
,P_DEC_VERSION
,P_DEC_PREFERRED_DEFINITION
,P_DEC_LONG_NAME
,P_DEC_ASL_NAME
,P_DEC_CD_IDSEQ
,P_DEC_LATEST_VERSION_IND
,P_DEC_PROPL_NAME
,P_DEC_OCL_NAME
,P_DEC_PROPERTY_QUALIFIER
,P_DEC_OBJ_CLASS_QUALIFIER
,P_DEC_BEGIN_DATE
,P_DEC_END_DATE
,P_DEC_CHANGE_NOTE
,P_DEC_CREATED_BY
,P_DEC_DATE_CREATED
,P_DEC_MODIFIED_BY
,P_DEC_DATE_MODIFIED
,P_DEC_DELETED_IND          );

******************************************************************************/
PROCEDURE GET_DEC(
 P_RETURN_CODE                   OUT VARCHAR2
,P_DEC_DEC_IDSEQ                  IN OUT VARCHAR2
,P_DEC_PREFERRED_NAME           IN OUT VARCHAR2
,P_DEC_CONTE_IDSEQ               IN OUT VARCHAR2
,P_DEC_VERSION                   IN OUT NUMBER
,P_DEC_PREFERRED_DEFINITION    OUT VARCHAR2
,P_DEC_LONG_NAME               OUT VARCHAR2
,P_DEC_ASL_NAME                   OUT VARCHAR2
,P_DEC_CD_IDSEQ                   OUT    VARCHAR2
,P_DEC_LATEST_VERSION_IND      OUT    VARCHAR2
,P_DEC_PROPL_NAME              OUT    VARCHAR
,P_DEC_OCL_NAME                   OUT    VARCHAR2
,P_DEC_PROPERTY_QUALIFIER         OUT  VARCHAR2
,P_DEC_OBJ_CLASS_QUALIFIER        OUT    VARCHAR2
,P_DEC_BEGIN_DATE               OUT    VARCHAR2
,P_DEC_END_DATE                   OUT    VARCHAR2
,P_DEC_CHANGE_NOTE               OUT    VARCHAR2
,P_DEC_CREATED_BY               OUT    VARCHAR2
,P_DEC_DATE_CREATED               OUT    VARCHAR2
,P_DEC_MODIFIED_BY               OUT    VARCHAR2
,P_DEC_DATE_MODIFIED            OUT    VARCHAR2
,P_DEC_DELETED_IND                OUT    VARCHAR2)    IS

dec_rec   data_element_concepts_view%ROWTYPE;
v_version data_element_concepts_view.version%TYPE;


BEGIN
  p_return_code := NULL;
  --At least one of the ID or Name parameters has to be provided
  IF P_DEC_DEC_IDSEQ IS NOT NULL THEN  --Retrieve the Data Element Concept by key
    BEGIN
      SELECT *
      INTO dec_rec
      FROM data_element_concepts_view
      WHERE dec_idseq = P_DEC_DEC_IDSEQ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
             p_return_code := 'API_DEC_005'; -- Data Element Concept not found
           RETURN;
      WHEN OTHERS THEN
             p_return_code := 'API_DEC_009'; -- Others raised in select on Data_Element_Concept_View
           RETURN;
    END;

    /*If P_DEC_PREFERRED_NAME is not null and does not match the retrieved Preferred Name
       then assign the error code */
    IF(P_DEC_PREFERRED_NAME IS NOT NULL AND (P_DEC_PREFERRED_NAME <> dec_rec.preferred_name)) THEN
      P_RETURN_CODE := 'API_DEC_002';-- Retrieved Preferred Name does not match with parameter
      RETURN;
    END IF;

    /*If the P_DEC_CONTE_IDSEQ is not null and does not match the retrieved Context then assign error code and RETURN*/
    IF(P_DEC_CONTE_IDSEQ IS NOT NULL AND (P_DEC_CONTE_IDSEQ <> dec_rec.conte_idseq)) THEN
      P_RETURN_CODE := 'API_DEC_003';-- Retrieved Context does not match with parameter
      RETURN;
    END IF;

    /*If P_DEC_VERSION is not null and does not match the retrieved Version
                then assign the error code and return*/
    IF(P_DEC_VERSION IS NOT NULL AND (P_DEC_VERSION <> dec_rec.version)) THEN
      P_RETURN_CODE := 'API_DEC_004';-- Retrieved Version Name does not match with parameter
      RETURN;
    END IF;

    P_DEC_PREFERRED_NAME     := dec_rec.preferred_name;
    P_DEC_CONTE_IDSEQ         := dec_rec.conte_idseq;
    P_DEC_VERSION             := dec_rec.version;
    P_DEC_PREFERRED_DEFINITION  := dec_rec.preferred_definition;
    P_DEC_LONG_NAME              := dec_rec.long_name;
    P_DEC_ASL_NAME              := dec_rec.asl_name;
    P_DEC_CD_IDSEQ              := dec_rec.cd_idseq;
    P_DEC_LATEST_VERSION_IND   := dec_rec.latest_version_ind;
    P_DEC_PROPL_NAME           := dec_rec.propl_name;
    P_DEC_OCL_NAME              := dec_rec.ocl_name;
    P_DEC_PROPERTY_QUALIFIER   := dec_rec.property_qualifier;
    P_DEC_OBJ_CLASS_QUALIFIER    := dec_rec.obj_class_qualifier;
    P_DEC_BEGIN_DATE            := dec_rec.begin_date;
    P_DEC_END_DATE              := dec_rec.end_date;
    P_DEC_CHANGE_NOTE              := dec_rec.change_note;
    P_DEC_CREATED_BY              := dec_rec.created_by;
    P_DEC_DATE_CREATED          := dec_rec.date_created;
    P_DEC_MODIFIED_BY            := dec_rec.modified_by;
    P_DEC_DATE_MODIFIED         := dec_rec.date_modified;
    P_DEC_DELETED_IND             := dec_rec.deleted_ind;

 ELSE  --Key is not provided, retrieve by name, Version and Context
   IF(P_DEC_PREFERRED_NAME IS NOT NULL AND P_DEC_CONTE_IDSEQ IS NOT NULL) THEN
     IF P_DEC_VERSION IS NOT NULL THEN
       v_version := P_DEC_VERSION;
     ELSE
       v_version := Sbrext_Common_Routines.get_ac_version(P_DEC_PREFERRED_NAME, P_DEC_CONTE_IDSEQ,'DE_CONCEPT');
       IF(v_version = 0) THEN
         P_RETURN_CODE := 'API_DEC_005';--DEC not found
         RETURN;
       END IF;
    END IF;

    /*Retrieve the Data Element Concept row based on Context, Preferred Name and Version number*/

    BEGIN
      SELECT *
      INTO dec_rec
      FROM data_element_concepts_view
      WHERE preferred_name = p_dec_preferred_name
      AND   conte_idseq = p_dec_conte_idseq
      AND   version = v_version;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
             p_return_code := 'API_DEC_005'; --DEC not found
           RETURN;
      WHEN OTHERS THEN
             p_return_code := 'API_DEC_009'; --others raised on select from data_element_concepts_view
           RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_DEC_DEC_IDSEQ                     := dec_rec.dec_idseq;
    P_DEC_PREFERRED_NAME     := dec_rec.preferred_name;
    P_DEC_CONTE_IDSEQ         := dec_rec.conte_idseq;
    P_DEC_VERSION             := dec_rec.version;
    P_DEC_PREFERRED_DEFINITION  := dec_rec.preferred_definition;
    P_DEC_LONG_NAME              := dec_rec.long_name;
    P_DEC_ASL_NAME              := dec_rec.asl_name;
    P_DEC_CD_IDSEQ              := dec_rec.cd_idseq;
    P_DEC_LATEST_VERSION_IND   := dec_rec.latest_version_ind;
    P_DEC_PROPL_NAME           := dec_rec.propl_name;
    P_DEC_OCL_NAME              := dec_rec.ocl_name;
    P_DEC_PROPERTY_QUALIFIER   := dec_rec.property_qualifier;
    P_DEC_OBJ_CLASS_QUALIFIER    := dec_rec.obj_class_qualifier;
    P_DEC_BEGIN_DATE            := dec_rec.begin_date;
    P_DEC_END_DATE              := dec_rec.end_date;
    P_DEC_CHANGE_NOTE              := dec_rec.change_note;
    P_DEC_CREATED_BY              := dec_rec.created_by;
    P_DEC_DATE_CREATED          := dec_rec.date_created;
    P_DEC_MODIFIED_BY            := dec_rec.modified_by;
    P_DEC_DATE_MODIFIED         := dec_rec.date_modified;
    P_DEC_DELETED_IND             := dec_rec.deleted_ind;
  ELSE
    P_RETURN_CODE := 'API_DEC_001';--PK or Preferred_Name, Conte_Idseq, and Version must be provided
    RETURN;
  END IF;
END IF;

EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END GET_DEC;

PROCEDURE GET_CON(
 P_RETURN_CODE                   OUT VARCHAR2
,P_CON_CON_IDSEQ                  IN OUT VARCHAR2
,P_CON_PREFERRED_NAME           IN OUT VARCHAR2
,P_CON_CONTE_IDSEQ                OUT VARCHAR2
,P_CON_VERSION                   IN OUT NUMBER
,P_CON_PREFERRED_DEFINITION    OUT VARCHAR2
,P_CON_LONG_NAME               OUT VARCHAR2
,P_CON_ASL_NAME                   OUT VARCHAR2
,P_CON_DEFINITION_SOURCE                   OUT    VARCHAR2
,P_CON_LATEST_VERSION_IND      OUT    VARCHAR2
,P_CON_EVS_SOURCE              OUT    VARCHAR2
,P_CON_CON_ID         OUT  VARCHAR2
,P_CON_ORIGIN        OUT    VARCHAR2
,P_CON_BEGIN_DATE               OUT    VARCHAR2
,P_CON_END_DATE                   OUT    VARCHAR2
,P_CON_CHANGE_NOTE               OUT    VARCHAR2
,P_CON_CREATED_BY               OUT    VARCHAR2
,P_CON_DATE_CREATED               OUT    VARCHAR2
,P_CON_MODIFIED_BY               OUT    VARCHAR2
,P_CON_DATE_MODIFIED            OUT    VARCHAR2
,P_CON_DELETED_IND                OUT    VARCHAR2
,P_DEFAULT_CONTE_NAME           IN VARCHAR2     /* GF32649 */
)    IS

con_rec   concepts_view_ext%ROWTYPE;
v_version concepts_view_ext.version%TYPE;
v_conte_idseq contexts_view.conte_idseq %TYPE;


BEGIN

select conte_idseq into v_conte_idseq
from contexts
where upper(name) = upper(P_DEFAULT_CONTE_NAME);        --GF32649
  p_return_code := NULL;
  --At least one of the ID or Name parameters has to be provided
  IF P_CON_CON_IDSEQ IS NOT NULL THEN  --Retrieve the Data Element Concept by key
    BEGIN
      SELECT *
      INTO con_rec
      FROM concepts_view_ext
      WHERE con_idseq = P_CON_CON_IDSEQ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
             p_return_code := 'API_CON_005'; -- Data Element Concept not found
           RETURN;
      WHEN OTHERS THEN
             p_return_code := 'API_CON_009'; -- Others raised in select on Data_Element_Concept_View
           RETURN;
    END;

    /*If P_CON_PREFERRED_NAME is not null and does not match the retrieved Preferred Name
       then assign the error code */
    IF(P_CON_PREFERRED_NAME IS NOT NULL AND (P_CON_PREFERRED_NAME <> con_rec.preferred_name)) THEN
      P_RETURN_CODE := 'API_CON_002';-- Retrieved Preferred Name does not match with parameter
      RETURN;
    END IF;

    /*If the P_CON_CONTE_IDSEQ is not null and does not match the retrieved Context then assign error code and RETURN*/
    IF(V_CONTE_IDSEQ IS NOT NULL AND (V_CONTE_IDSEQ <> con_rec.conte_idseq)) THEN
      P_RETURN_CODE := 'API_CON_003';-- Retrieved Context does not match with parameter
      RETURN;
    END IF;

    /*If P_CON_VERSION is not null and does not match the retrieved Version
                then assign the error code and return*/
    IF(P_CON_VERSION IS NOT NULL AND (P_CON_VERSION <> con_rec.version)) THEN
      P_RETURN_CODE := 'API_CON_004';-- Retrieved Version Name does not match with parameter
      RETURN;
    END IF;

    P_CON_PREFERRED_NAME     := con_rec.preferred_name;
    P_CON_CONTE_IDSEQ         := v_conte_idseq;
    P_CON_VERSION             := con_rec.version;
    P_CON_PREFERRED_DEFINITION  := con_rec.preferred_definition;
    P_CON_LONG_NAME              := con_rec.long_name;
    P_CON_ASL_NAME              := con_rec.asl_name;
    P_CON_DEFINITION_SOURCE              := con_rec.definition_source;
    P_CON_LATEST_VERSION_IND   := con_rec.latest_version_ind;
    P_CON_CON_ID           := con_rec.con_id;
    P_CON_EVS_SOURCE              := con_rec.evs_source;
    P_CON_ORIGIN   := con_rec.origin;
    P_CON_BEGIN_DATE            := con_rec.begin_date;
    P_CON_END_DATE              := con_rec.end_date;
    P_CON_CHANGE_NOTE              := con_rec.change_note;
    P_CON_CREATED_BY              := con_rec.created_by;
    P_CON_DATE_CREATED          := con_rec.date_created;
    P_CON_MODIFIED_BY            := con_rec.modified_by;
    P_CON_DATE_MODIFIED         := con_rec.date_modified;
    P_CON_DELETED_IND             := con_rec.deleted_ind;

 ELSE  --Key is not provided, retrieve by name, Version and Context
   IF(P_CON_PREFERRED_NAME IS NOT NULL AND V_CONTE_IDSEQ IS NOT NULL) THEN
     IF P_CON_VERSION IS NOT NULL THEN
       v_version := P_CON_VERSION;
     ELSE
       v_version := Sbrext_Common_Routines.get_ac_version(P_CON_PREFERRED_NAME, V_CONTE_IDSEQ,'CONCEPT');
       IF(v_version = 0) THEN
         P_RETURN_CODE := 'API_CON_005';--DEC not found
         RETURN;
       END IF;
    END IF;

    /*Retrieve the Data Element Concept row based on Context, Preferred Name and Version number*/

    BEGIN
      SELECT *
      INTO con_Rec
      FROM concepts_view_ext
      WHERE preferred_name = p_con_preferred_name
      AND   conte_idseq = v_conte_idseq
      AND   version = v_version;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
             p_return_code := 'API_CON_005'; --DEC not found
           RETURN;
      WHEN OTHERS THEN
             p_return_code := 'API_CON_009'; --others raised on select from concepts_ext_view
           RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_CON_PREFERRED_NAME     := con_rec.preferred_name;
    P_CON_CONTE_IDSEQ         := v_conte_idseq;
    P_CON_VERSION             := con_rec.version;
    P_CON_PREFERRED_DEFINITION  := con_rec.preferred_definition;
    P_CON_LONG_NAME              := con_rec.long_name;
    P_CON_ASL_NAME              := con_rec.asl_name;
    P_CON_DEFINITION_SOURCE              := con_rec.definition_source;
    P_CON_LATEST_VERSION_IND   := con_rec.latest_version_ind;
    P_CON_CON_ID           := con_rec.con_id;
    P_CON_EVS_SOURCE              := con_rec.evs_source;
    P_CON_ORIGIN   := con_rec.origin;
    P_CON_BEGIN_DATE            := con_rec.begin_date;
    P_CON_END_DATE              := con_rec.end_date;
    P_CON_CHANGE_NOTE              := con_rec.change_note;
    P_CON_CREATED_BY              := con_rec.created_by;
    P_CON_DATE_CREATED          := con_rec.date_created;
    P_CON_MODIFIED_BY            := con_rec.modified_by;
    P_CON_DATE_MODIFIED         := con_rec.date_modified;
    P_CON_DELETED_IND             := con_rec.deleted_ind;
    P_CON_CON_IDSEQ         := con_rec.con_idseq;
  ELSE
    P_RETURN_CODE := 'API_CON_001';--PK or Preferred_Name, Conte_Idseq, and Version must be provided
    RETURN;
  END IF;
END IF;

EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END GET_CON;


/******************************************************************************
   NAME:       GET_VM
   PURPOSE:    Gets a Single Row Of Value Meanings Based on Name

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/23/2001  Lisa Schick     1. Created this procedure
              05/13/2004  DLadino         2.  Modified the where condition
                                              added upper and rownum = 1
                                              Request by Sumana Hegde (Scenpro)

   EXAMPLE USE:    GET_ROW.GET_VM(
P_RETURN_CODE
,P_VM_SHORT_MEANING
,P_VM_DESCRIPTION
,P_VM_COMMENTS
,P_VM_BEGIN_DATE
,P_VM_END_DATE
,P_VM_CREATED_BY
,P_VM_DATE_CREATED
,P_VM_MODIFIED_BY
,P_VM_DATE_MODIFIED);

******************************************************************************/
PROCEDURE GET_VM(
P_RETURN_CODE                OUT VARCHAR2
,P_VM_SHORT_MEANING         IN OUT VARCHAR2
,P_VM_DESCRIPTION            OUT VARCHAR2
,P_VM_COMMENTS               OUT    VARCHAR2
,P_VM_BEGIN_DATE            OUT    VARCHAR2
,P_VM_END_DATE                OUT    VARCHAR2
,P_VM_CREATED_BY            OUT    VARCHAR2
,P_VM_DATE_CREATED            OUT    VARCHAR2
,P_VM_MODIFIED_BY            OUT    VARCHAR2
,P_VM_DATE_MODIFIED            OUT    VARCHAR2)    IS

vm_rec value_meanings_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --The ID must be provided
  IF P_VM_SHORT_MEANING IS NOT NULL THEN  --Retrieve the value_meaning_lov by key

    BEGIN
      SELECT *
      INTO vm_rec
      FROM value_meanings_view
      WHERE upper(long_name) = upper(p_vm_short_meaning) and rownum = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_VM_005'; -- VM not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_VM_009'; -- Other raised on select from value_meanings_lov_view
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_VM_SHORT_MEANING  := vm_rec.long_name;
    P_VM_DESCRIPTION    := vm_rec.preferred_definition;
    P_VM_COMMENTS       := vm_rec.change_note;
    P_VM_BEGIN_DATE        := vm_rec.begin_date;
    P_VM_END_DATE        := vm_rec.end_date;
    P_VM_CREATED_BY        := vm_rec.created_by;
    P_VM_DATE_CREATED    := vm_rec.date_created;
    P_VM_MODIFIED_BY    := vm_rec.modified_by;
    P_VM_DATE_MODIFIED    := vm_rec.date_modified;
    --P_VM_VM_IDSEQ        := vm_rec.vm_idseq;

  ELSE
    P_RETURN_CODE := 'API_VM_001';--PK must be provided (short meaning)
END IF;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;

END GET_VM;
-- overloaded procedure to return vm_idseq
-- wrapper procedure for preceding procedure

 PROCEDURE GET_VM(
  P_RETURN_CODE                OUT VARCHAR2
 ,P_VM_SHORT_MEANING        IN OUT VARCHAR2
 ,P_VM_DESCRIPTION            OUT VARCHAR2
 ,P_VM_COMMENTS               OUT    VARCHAR2
 ,P_VM_BEGIN_DATE            OUT    VARCHAR2
 ,P_VM_END_DATE                OUT    VARCHAR2
 ,P_VM_CREATED_BY            OUT    VARCHAR2
 ,P_VM_DATE_CREATED            OUT    VARCHAR2
 ,P_VM_MODIFIED_BY            OUT    VARCHAR2
 ,P_VM_DATE_MODIFIED        OUT    VARCHAR2
 ,P_VM_CONDR_IDSEQ            OUT    VARCHAR2
 ,P_VM_VM_IDSEQ             OUT VARCHAR2) IS

vm_rec value_meanings_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --The ID must be provided
  IF P_VM_SHORT_MEANING IS NOT NULL THEN  --Retrieve the value_meaning_lov by key

    BEGIN
      SELECT *
      INTO vm_rec
      FROM value_meanings_view
      WHERE upper(long_name) = upper(p_vm_short_meaning) and rownum = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_VM_005'; -- VM not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_VM_009'; -- Other raised on select from value_meanings_lov_view
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_VM_SHORT_MEANING  := vm_rec.long_name;
    P_VM_DESCRIPTION    := vm_rec.preferred_definition;
    P_VM_COMMENTS       := vm_rec.change_note;
    P_VM_BEGIN_DATE        := vm_rec.begin_date;
    P_VM_END_DATE        := vm_rec.end_date;
    P_VM_CREATED_BY        := vm_rec.created_by;
    P_VM_DATE_CREATED    := vm_rec.date_created;
    P_VM_MODIFIED_BY    := vm_rec.modified_by;
    P_VM_DATE_MODIFIED    := vm_rec.date_modified;
    P_VM_VM_IDSEQ        := vm_rec.vm_idseq;

  ELSE
    P_RETURN_CODE := 'API_VM_001';--PK must be provided (short meaning)
END IF;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
 END GET_VM;



/******************************************************************************
   NAME:       GET_VM
   PURPOSE:    Gets a Single Row Of Value Meanings Based on Name

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/23/2001  Lisa Schick     1. Created this procedure
              05/13/2004  DLadino         2.  Modified the where condition
                                              added upper and rownum = 1

   EXAMPLE USE:    GET_ROW.GET_VM(
P_RETURN_CODE
,P_VM_SHORT_MEANING
,P_VM_DESCRIPTION
,P_VM_COMMENTS
,P_VM_BEGIN_DATE
,P_VM_END_DATE
,P_VM_CREATED_BY
,P_VM_DATE_CREATED
,P_VM_MODIFIED_BY
,P_VM_DATE_MODIFIED);

******************************************************************************/
PROCEDURE GET_VM(
P_RETURN_CODE                OUT VARCHAR2
,P_VM_SHORT_MEANING         IN OUT VARCHAR2
,P_VM_DESCRIPTION            OUT VARCHAR2
,P_VM_COMMENTS               OUT    VARCHAR2
,P_VM_BEGIN_DATE            OUT    VARCHAR2
,P_VM_END_DATE                OUT    VARCHAR2
,P_VM_CREATED_BY            OUT    VARCHAR2
,P_VM_DATE_CREATED            OUT    VARCHAR2
,P_VM_MODIFIED_BY            OUT    VARCHAR2
,P_VM_DATE_MODIFIED            OUT    VARCHAR2
,P_VM_CONDR_IDSEQ            OUT    VARCHAR2)    IS

vm_rec value_meanings_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --The ID must be provided
  IF P_VM_SHORT_MEANING IS NOT NULL THEN  --Retrieve the value_meaning_lov by key

    BEGIN
      SELECT *
      INTO vm_rec
      FROM value_meanings_view
      WHERE upper(long_name) = upper(p_vm_short_meaning) and rownum = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_VM_005'; -- VM not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_VM_009'; -- Other raised on select from value_meanings_lov_view
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_VM_SHORT_MEANING  := vm_rec.long_name;
    P_VM_DESCRIPTION    := vm_rec.preferred_definition;
    P_VM_COMMENTS       := vm_rec.change_note;
    P_VM_BEGIN_DATE        := vm_rec.begin_date;
    P_VM_END_DATE        := vm_rec.end_date;
    P_VM_CREATED_BY        := vm_rec.created_by;
    P_VM_DATE_CREATED    := vm_rec.date_created;
    P_VM_MODIFIED_BY    := vm_rec.modified_by;
    P_VM_DATE_MODIFIED    := vm_rec.date_modified;
    P_VM_CONDR_IDSEQ    := vm_rec.CONDR_IDSEQ;

  ELSE
    P_RETURN_CODE := 'API_VM_001';--PK must be provided (short meaning)
END IF;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;

END GET_VM;

-- Version from ScenPro, 4/24/2007


  PROCEDURE GET_VM(
     P_RETURN_CODE                OUT VARCHAR2
    ,P_VM_IDSEQ                    IN OUT VARCHAR2
    ,P_LONG_NAME                 IN OUT VARCHAR2
    ,P_VERSION                    IN OUT VARCHAR2
    ,P_VM_ID                    IN OUT VARCHAR2
    ,P_PREFERRED_NAME            OUT VARCHAR2
    ,P_PREFERRED_DEFINITION        OUT VARCHAR2
    ,P_CONTE_IDSEQ                OUT VARCHAR2
    ,P_ASL_NAME                    OUT VARCHAR2
    ,P_LATEST_VERSION_IND        OUT VARCHAR2
    ,P_CONDR_IDSEQ                OUT VARCHAR2
    ,P_DEFINITION_SOURCE        OUT VARCHAR2
    ,P_ORIGIN                    OUT VARCHAR2
    ,P_CHANGE_NOTE                OUT VARCHAR2
    ,P_BEGIN_DATE                OUT VARCHAR2
    ,P_END_DATE                    OUT VARCHAR2
    ,P_CREATED_BY                OUT    VARCHAR2
    ,P_DATE_CREATED                OUT    VARCHAR2
    ,P_MODIFIED_BY                OUT    VARCHAR2
    ,P_DATE_MODIFIED            OUT    VARCHAR2
    )    IS

    vm_rec value_meanings_view%ROWTYPE;
    BEGIN

      p_return_code := NULL;
      --The ID must be provided


     IF P_VM_IDSEQ IS NOT NULL THEN  --Retrieve the value_meaning_lov by key

        BEGIN
          SELECT *
          INTO vm_rec
          FROM value_meanings_view
          WHERE vm_idseq = P_VM_IDSEQ;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            p_return_code := 'API_VM_105'; -- VM not found
            RETURN;
          WHEN OTHERS THEN
            p_return_code := 'API_VM_109'; -- Other raised on select from value_meanings_lov_view
            RETURN;
        END;

      ELSIF P_LONG_NAME IS NOT NULL THEN  --Retrieve the value_meaning_lov by key

        BEGIN
          SELECT *
          INTO vm_rec
          FROM value_meanings_view
          WHERE vm_idseq = P_VM_IDSEQ;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            p_return_code := 'API_VM_001'; -- VM not found
            RETURN;
          WHEN OTHERS THEN
            p_return_code := 'API_VM_009'; -- Other raised on select from value_meanings_lov_view
            RETURN;
        END;

      ELSIF P_VM_ID IS NOT NULL AND P_VERSION IS NOT NULL THEN  --Retrieve the value_meaning_lov by key

        BEGIN
          SELECT *
          INTO vm_rec
          FROM value_meanings_view
          WHERE vm_id = P_VM_ID
          AND version = P_VERSION;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            p_return_code := 'API_VM_205'; -- VM not found
            RETURN;
          WHEN OTHERS THEN
            p_return_code := 'API_VM_209'; -- Other raised on select from value_meanings_lov_view
            RETURN;
        END;

      ELSE
        P_RETURN_CODE := 'API_VM_001';--PK must be provided (short meaning)
    END IF;

      P_VM_IDSEQ    := vm_rec.vm_idseq;
     P_PREFERRED_NAME := vm_rec.preferred_name;
     P_LONG_NAME := vm_rec.long_name;
     P_PREFERRED_DEFINITION := vm_rec.preferred_definition;
     P_CONTE_IDSEQ := vm_rec.conte_idseq;
     P_ASL_NAME := vm_rec.asl_name;
     P_VERSION := vm_rec.version;
     P_VM_ID := vm_rec.vm_id;
     P_LATEST_VERSION_IND := vm_rec.latest_version_ind;
     P_CONDR_IDSEQ := vm_rec.condr_idseq;
     P_DEFINITION_SOURCE := vm_rec.definition_source;
     P_ORIGIN := vm_rec.origin;
     P_CHANGE_NOTE :=  vm_rec.change_note;
     P_BEGIN_DATE := vm_rec.begin_date;
     P_END_DATE := vm_rec.end_date;
     P_CREATED_BY := vm_rec.created_by;
     P_DATE_CREATED := vm_rec.date_created;
     P_MODIFIED_BY := vm_rec.modified_by;
     P_DATE_MODIFIED := vm_rec.date_modified;

    EXCEPTION
         WHEN NO_DATA_FOUND THEN
           P_RETURN_CODE := 'API_VM_905';  --NULL;
         WHEN OTHERS THEN
               dbms_output.put_line(sqlerrm);
           P_RETURN_CODE := 'API_VM_906';  -- NULL;

  END GET_VM;

 -- From ScenPro, 4/24/2007

    PROCEDURE get_vm_condr(
              p_con_array IN VARCHAR2
              ,p_return_code OUT VARCHAR2
              ,p_long_name IN OUT VARCHAR2
              ,p_condr_idseq OUT VARCHAR2
              ,p_preferred_definition OUT VARCHAR2
              ,p_action OUT VARCHAR2
              )  IS

        v_long_name VARCHAR2(2000);
        v_description VARCHAR2(4000);
        v_name VARCHAR2(255);
        v_crtl_name VARCHAR2(50);
        v_count number;

      CURSOR con(p_con_idseq IN VARCHAR2) IS
        SELECT * FROM CONCEPTS_EXT
        WHERE con_idseq = p_con_idseq;

      CURSOR comp_con IS
        SELECT * FROM COMPONENT_CONCEPTS_EXT
        WHERE condr_idseq = p_condr_idseq
        ORDER BY display_order desc;

    BEGIN

       IF P_CON_ARRAY IS NULL THEN
             RETURN;
       END IF;

       p_condr_idseq := sbrext_common_routines.SET_DERIVATION_RULE(P_CON_ARRAY);

       IF NOT Sbrext_Common_Routines.CONDR_EXISTS(p_condr_idseq) THEN
          P_RETURN_CODE := 'API_VM_800';
          RETURN;
       END IF;

      SELECT name
      ,      crtl_name
      INTO   v_name
      ,      v_crtl_name
      FROM CON_DERIVATION_RULES_EXT
      WHERE condr_idseq = p_condr_idseq;

      FOR m_rec IN comp_con LOOP
          FOR c_rec IN con(m_rec.con_idseq) LOOP

            --add the concept_value to the long name
            IF m_rec.concept_value is not null then
              c_rec.long_name := c_rec.long_name ||'::'||m_rec.concept_value;
              c_rec.preferred_definition := c_rec.preferred_definition||'::'||m_rec.concept_value;
            END IF;

              IF v_long_name IS NULL THEN
                 v_long_name := c_rec.long_name;
              ELSE
                 v_long_name := v_long_name||' '||c_rec.long_name;
              END IF;

              IF v_description IS NULL THEN
                  v_description := c_rec.preferred_definition;
                ELSE
                  v_description := v_description||': '||c_rec.preferred_definition;
              END IF;

           END LOOP;
      END LOOP;

      p_preferred_definition := SUBSTR(v_description,1,2000);

      --change name only if null
      if(p_long_name is null) then
        p_long_name := SUBSTR(v_long_name,1,255);
      end if;

      --reset the action
    /*  select count(*) into v_count
      from value_meanings_view
      where long_name = p_long_name;

      if v_count = 1 then
        p_action := 'UPD';
      else
        p_action := 'INS';
      end if;*/

    EXCEPTION WHEN OTHERS THEN
      p_return_code := 'Error getting con derivation rules';
      RETURN;
    END get_vm_condr;


/******************************************************************************
   NAME:       GET_PV
   PURPOSE:    Gets a Single Row Of Permissible Values Based on ID or Value and Short Meaning

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_PV(
P_RETURN_CODE
,P_PV_IDSEQ
,P_PV_VALUE
,P_PV_SHORT_MEANING
,P_PV_MEANING_DESCRIPTION
,P_PV_HIGH_VALUE_NUM
,P_PV_LOW_VALUE_NUM
,P_PV_BEGIN_DATE
,P_PV_END_DATE
,P_PV_CREATED_BY
,P_PV_DATE_CREATED
,P_PV_MODIFIED_BY
,P_PV_DATE_MODIFIED );

******************************************************************************/
/*PROCEDURE GET_PV(
P_RETURN_CODE                 OUT VARCHAR2
,P_PV_PV_IDSEQ              IN OUT VARCHAR2
,P_PV_VALUE                 IN OUT VARCHAR2
,P_PV_SHORT_MEANING         IN OUT VARCHAR2
,P_PV_MEANING_DESCRIPTION   OUT VARCHAR2
,P_PV_HIGH_VALUE_NUM        OUT NUMBER
,P_PV_LOW_VALUE_NUM            OUT NUMBER
,P_PV_BEGIN_DATE            OUT VARCHAR2
,P_PV_END_DATE              OUT VARCHAR2
,P_PV_CREATED_BY            OUT VARCHAR2
,P_PV_DATE_CREATED          OUT VARCHAR2
,P_PV_MODIFIED_BY           OUT VARCHAR2
,P_PV_DATE_MODIFIED         OUT VARCHAR2) IS

pv_rec permissible_values_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --At least one of the ID or Name parameters has to be provided
  IF P_PV_PV_IDSEQ IS NOT NULL THEN  --Retrieve the Permissible Value by key

    BEGIN
      SELECT *
      INTO pv_rec
      FROM permissible_values_view
      WHERE pv_idseq = P_PV_PV_IDSEQ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_PV_005'; -- Permissible Value not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_PV_009'; -- Other raised on select from Permissible_Values_View
        RETURN;
    END;

    If P_PV_VALUE is not null and does not match the retrieved Value then assign error code
    IF(P_PV_VALUE IS NOT NULL AND (P_PV_VALUE <> pv_rec.value)) THEN
      p_return_code := 'API_PV_002';-- Retrieved Value Does not Match with parameter
      RETURN;
    END IF;

    --/*If P_PV_SHORT_MEANING is not null and does not match retrieved short meaning, assign error code and RETURN
    IF(P_PV_SHORT_MEANING IS NOT NULL AND (P_PV_SHORT_MEANING<> pv_rec.short_meaning)) THEN
      p_return_code := 'API_PV_003';-- Retrieved short meaning does not Match with parameter
      RETURN;
    END IF;

    P_PV_VALUE                := pv_rec.value;
    P_PV_SHORT_MEANING         := pv_rec.short_meaning;
    P_PV_MEANING_DESCRIPTION  := pv_rec.meaning_description;
    P_PV_HIGH_VALUE_NUM       := pv_rec.high_value_num;
    P_PV_LOW_VALUE_NUM        := pv_rec.low_value_num;
    P_PV_BEGIN_DATE           := pv_rec.begin_date;
    P_PV_END_DATE             := pv_rec.end_date;
    P_PV_CREATED_BY           := pv_rec.created_by;
    P_PV_DATE_CREATED         := pv_rec.date_created;
    P_PV_MODIFIED_BY          := pv_rec.modified_by;
    P_PV_DATE_MODIFIED          := pv_rec.date_modified;

  ELSE  --Key is not provided, retrieve by value and short meaning
    IF(P_PV_VALUE IS NOT NULL AND P_PV_SHORT_MEANING IS NOT NULL) THEN
    --/*Retrieve the Permissible Value row based on Value and Short Meaning
      BEGIN
        SELECT *
        INTO pv_rec
        FROM permissible_values_view
        WHERE value = P_PV_VALUE
        AND short_meaning = P_PV_SHORT_MEANING;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_return_code := 'API_PV_005'; -- Permissible Value not found
          RETURN;
        WHEN OTHERS THEN
          p_return_code := 'API_PV_009'; -- Other raised on select from Permissible_Values_View
          RETURN;
      END;

      -- Assign the data retrieved to the parameters
      P_PV_PV_IDSEQ                  := pv_rec.pv_idseq;
      P_PV_VALUE                := pv_rec.value;
      P_PV_SHORT_MEANING          := pv_rec.short_meaning;
      P_PV_MEANING_DESCRIPTION := pv_rec.meaning_description;
      P_PV_HIGH_VALUE_NUM      := pv_rec.high_value_num;
      P_PV_LOW_VALUE_NUM       := pv_rec.low_value_num;
      P_PV_BEGIN_DATE          := pv_rec.begin_date;
      P_PV_END_DATE            := pv_rec.end_date;
      P_PV_CREATED_BY          := pv_rec.created_by;
      P_PV_DATE_CREATED        := pv_rec.date_created;
      P_PV_MODIFIED_BY         := pv_rec.modified_by;
      P_PV_DATE_MODIFIED       := pv_rec.date_modified;

  ELSE
    p_return_code := 'API_PV_001';--PK must be provided
    RETURN;
  END IF;
END IF;

 EXCEPTION
 WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END GET_PV;
*/
--overloaded
PROCEDURE GET_PV(
P_RETURN_CODE                 OUT VARCHAR2
,P_PV_PV_IDSEQ              IN OUT VARCHAR2
,P_PV_VALUE                 IN OUT VARCHAR2
,P_PV_VM_IDSEQ         IN OUT VARCHAR2
,P_PV_MEANING_DESCRIPTION   OUT VARCHAR2
,P_PV_HIGH_VALUE_NUM        OUT NUMBER
,P_PV_LOW_VALUE_NUM            OUT NUMBER
,P_PV_BEGIN_DATE            OUT VARCHAR2
,P_PV_END_DATE              OUT VARCHAR2
,P_PV_CREATED_BY            OUT VARCHAR2
,P_PV_DATE_CREATED          OUT VARCHAR2
,P_PV_MODIFIED_BY           OUT VARCHAR2
,P_PV_DATE_MODIFIED         OUT VARCHAR2) IS

pv_rec permissible_values_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --At least one of the ID or Name parameters has to be provided
  IF P_PV_PV_IDSEQ IS NOT NULL THEN  --Retrieve the Permissible Value by key

    BEGIN
      SELECT *
      INTO pv_rec
      FROM permissible_values_view
      WHERE pv_idseq = P_PV_PV_IDSEQ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_PV_005'; -- Permissible Value not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_PV_009'; -- Other raised on select from Permissible_Values_View
        RETURN;
    END;

    /*If P_PV_VALUE is not null and does not match the retrieved Value then assign error code */
    IF(P_PV_VALUE IS NOT NULL AND (P_PV_VALUE <> pv_rec.value)) THEN
      p_return_code := 'API_PV_002';-- Retrieved Value Does not Match with parameter
      RETURN;
    END IF;

    /*If P_PV_SHORT_MEANING is not null and does not match retrieved short meaning, assign error code and RETURN*/
    IF(P_PV_VM_IDSEQ IS NOT NULL AND (P_PV_VM_IDSEQ<> pv_rec.short_meaning)) THEN
      p_return_code := 'API_PV_003';-- Retrieved short meaning does not Match with parameter
      RETURN;
    END IF;

    P_PV_VALUE                := pv_rec.value;
    P_PV_VM_IDSEQ        := pv_rec.vm_idseq;
    P_PV_MEANING_DESCRIPTION  := pv_rec.meaning_description;
    P_PV_HIGH_VALUE_NUM       := pv_rec.high_value_num;
    P_PV_LOW_VALUE_NUM        := pv_rec.low_value_num;
    P_PV_BEGIN_DATE           := pv_rec.begin_date;
    P_PV_END_DATE             := pv_rec.end_date;
    P_PV_CREATED_BY           := pv_rec.created_by;
    P_PV_DATE_CREATED         := pv_rec.date_created;
    P_PV_MODIFIED_BY          := pv_rec.modified_by;
    P_PV_DATE_MODIFIED          := pv_rec.date_modified;

  ELSE  --Key is not provided, retrieve by value and short meaning
    IF(P_PV_VALUE IS NOT NULL AND P_PV_VM_IDSEQ IS NOT NULL) THEN
    /*Retrieve the Permissible Value row based on Value and Short Meaning*/
      BEGIN
        SELECT *
        INTO pv_rec
        FROM permissible_values_view
        WHERE value = P_PV_VALUE
        AND vm_idseq = P_PV_VM_IDSEQ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_return_code := 'API_PV_005'; -- Permissible Value not found
          RETURN;
        WHEN OTHERS THEN
          p_return_code := 'API_PV_009'; -- Other raised on select from Permissible_Values_View
          RETURN;
      END;

      -- Assign the data retrieved to the parameters
      P_PV_PV_IDSEQ                  := pv_rec.pv_idseq;
      P_PV_VALUE                := pv_rec.value;
      P_PV_VM_IDSEQ          := pv_rec.vm_idseq;
      P_PV_MEANING_DESCRIPTION := pv_rec.meaning_description;
      P_PV_HIGH_VALUE_NUM      := pv_rec.high_value_num;
      P_PV_LOW_VALUE_NUM       := pv_rec.low_value_num;
      P_PV_BEGIN_DATE          := pv_rec.begin_date;
      P_PV_END_DATE            := pv_rec.end_date;
      P_PV_CREATED_BY          := pv_rec.created_by;
      P_PV_DATE_CREATED        := pv_rec.date_created;
      P_PV_MODIFIED_BY         := pv_rec.modified_by;
      P_PV_DATE_MODIFIED       := pv_rec.date_modified;

  ELSE
    p_return_code := 'API_PV_001';--PK must be provided
    RETURN;
  END IF;
END IF;

 EXCEPTION
 WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END GET_PV;


/******************************************************************************
   NAME:       GET_VD_PVS
   PURPOSE:    Gets a Permissible Value/Value Domain relationship Based on ID or Value Domain Id and Permissible Value Id

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_VD_PVS
P_RETURN_CODE
,P_VP_VP_IDSEQ
,P_VP_VD_IDSEQ
,P_VP_PV_PV_IDSEQ
,P_VP_CONTE_IDSEQ
,P_VP_CREATED_BY
,P_VP_DATE_CREATED
,P_VP_MODIFIED_BY
,P_VP_DATE_MODIFIED);

******************************************************************************/
PROCEDURE GET_VD_PVS(
P_RETURN_CODE                  OUT VARCHAR2
,P_VP_VP_IDSEQ                   IN OUT VARCHAR2
,P_VP_VD_IDSEQ                   IN OUT VARCHAR2
,P_VP_PV_IDSEQ                   IN OUT VARCHAR2
,P_VP_CONTE_IDSEQ                OUT VARCHAR2
,P_VP_CREATED_BY                 OUT VARCHAR2
,P_VP_DATE_CREATED               OUT VARCHAR2
,P_VP_MODIFIED_BY                 OUT VARCHAR2
,P_VP_DATE_MODIFIED                OUT VARCHAR2) IS

vp_rec  vd_pvs_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --At least one of the ID or Name parameters has to be provided
  IF P_VP_VP_IDSEQ IS NOT NULL THEN  --Retrieve the PV_VD RELATIONSHIP by key

    BEGIN
      SELECT *
      INTO vp_rec
      FROM vd_pvs_view
      WHERE vp_idseq = p_vp_vp_idseq;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_VP_005'; -- PV_VD RELATIOSHIP not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_VP_009'; --Other raised on select from vd_pvs_view
        RETURN;
    END;

    /*If the P_VP_VD_IDSEQ is not null and does not match the retrieved Value assign error code */
    IF(P_VP_VD_IDSEQ IS NOT NULL AND (P_VP_VD_IDSEQ <> vp_rec.vd_idseq)) THEN
         p_return_code := 'API_VP_002';-- Retrieved  Value Domain ID Does not Match with parameter
         RETURN;
    END IF;

    /*If the P_VP_PV_PV_IDSEQ is not null and does not match retrieved short meaning, assign error code and RETURN*/
    IF(P_VP_PV_IDSEQ IS NOT NULL AND (P_VP_PV_IDSEQ <> vp_rec.pv_idseq)) THEN
      P_RETURN_CODE := 'API_VP_003';-- Retrieved Permissible Value ID does not Match with parameter
      RETURN;
    END IF;

    -- Assign the data retrieved to the parameters
    P_VP_VD_IDSEQ       := vp_rec.vd_idseq;
    P_VP_PV_IDSEQ       := vp_rec.pv_idseq;
    P_VP_CONTE_IDSEQ    := vp_rec.conte_idseq;
    P_VP_CREATED_BY     := vp_rec.created_by;
    P_VP_DATE_CREATED   := vp_rec.date_created;
    P_VP_MODIFIED_BY     := vp_rec.modified_by;
    P_VP_DATE_MODIFIED  := vp_rec.date_modified;

  ELSE  --Key is not provided, retrieve VD ID and PV ID
    IF(P_VP_VD_IDSEQ IS NOT NULL AND P_VP_PV_IDSEQ IS NOT NULL) THEN
    /*Retrieve the PV_VD RELATIONSHIP row based on the two ids*/
    BEGIN
      SELECT *
      INTO VP_REC
      FROM vd_pvs_view
      WHERE vd_idseq = P_VP_VD_IDSEQ
      AND pv_idseq = P_VP_PV_IDSEQ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_VP_005'; -- PV_VD RELATIOSHIP not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_VP_009'; --Other raised on select from vd_pvs_view
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_VP_VP_IDSEQ           := vp_rec.vp_idseq;
    P_VP_VD_IDSEQ       := vp_rec.vd_idseq;
    P_VP_PV_IDSEQ       := vp_rec.pv_idseq;
    P_VP_CONTE_IDSEQ    := vp_rec.conte_idseq;
    P_VP_CREATED_BY     := vp_rec.created_by;
    P_VP_DATE_CREATED      := vp_rec.date_created;
    P_VP_MODIFIED_BY     := vp_rec.modified_by;
    P_VP_DATE_MODIFIED  := vp_rec.date_modified;

  ELSE
    p_return_code := 'API_VP_001';--PK or VD_IDSEQ and PV_IDSEQ must be passed
    RETURN;
  END IF;
END IF;

 EXCEPTION    WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;
END GET_VD_PVS;


/******************************************************************************
   NAME:       GET_DE
   PURPOSE:    Gets a Data Element based on ID or on Preferred Name, Context and Version

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_DE(
P_RETURN_CODE
,P_DE_IDSEQ
,P_DE_PREFERRED_NAME
,P_DE_CONTE_IDSEQ
,P_DE_VERSION
,P_DE_PREFERRED_DEFINITION
,P_DE_LONG_NAME
,P_DE_ASL_NAME
,P_DE_DEC_IDSEQ
,P_DE_VD_IDSEQ
,P_DE_LATEST_VERSION_IND
,P_DE_BEGIN_DATE
,P_DE_END_DATE
,P_DE_CHANGE_NOTE
,P_DE_CREATED_BY
,P_DE_DATE_CREATED
,P_DE_MODIFIED_BY
,P_DE_DATE_MODIFIED
,P_DE_DELETED_IND);

******************************************************************************/
PROCEDURE GET_DE(
P_RETURN_CODE                  OUT VARCHAR2
,P_DE_DE_IDSEQ              IN OUT VARCHAR2
,P_DE_PREFERRED_NAME        IN OUT VARCHAR2
,P_DE_CONTE_IDSEQ           IN OUT VARCHAR2
,P_DE_VERSION                IN OUT VARCHAR2
,P_DE_PREFERRED_DEFINITION     OUT VARCHAR2
,P_DE_LONG_NAME              OUT VARCHAR2
,P_DE_ASL_NAME              OUT VARCHAR2
,P_DE_DEC_IDSEQ             OUT VARCHAR2
,P_DE_VD_IDSEQ                 OUT VARCHAR2
,P_DE_LATEST_VERSION_IND      OUT VARCHAR2
,P_DE_BEGIN_DATE             OUT VARCHAR2
,P_DE_END_DATE              OUT VARCHAR2
,P_DE_CHANGE_NOTE             OUT VARCHAR2
,P_DE_CREATED_BY              OUT VARCHAR2
,P_DE_DATE_CREATED            OUT VARCHAR2
,P_DE_MODIFIED_BY             OUT VARCHAR2
,P_DE_DATE_MODIFIED          OUT VARCHAR2
,P_DE_DELETED_IND            OUT VARCHAR2) IS

de_rec    data_elements_view%ROWTYPE;
v_version data_elements_view.version%TYPE;

BEGIN
  p_return_code := NULL;
  --At least one of the ID or Name parameters has to be provided
  IF P_DE_DE_IDSEQ IS NOT NULL THEN  --Retrieve the Data Element by key

    BEGIN
      SELECT *
      INTO de_rec
      FROM data_elements_view
      WHERE de_idseq = P_DE_DE_IDSEQ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
             p_return_code := 'API_DE_005'; --Data Element not found
           RETURN;
      WHEN OTHERS THEN
           p_return_code := 'API_DE_009'; -- Other raised in select from Data_Elements_View
           RETURN;
    END;

    /*If  P_DE_PREFERRED_NAME is not null and does not match the retrieved Preferred Name
       then assign the error code */
    IF(P_DE_PREFERRED_NAME IS NOT NULL AND (P_DE_PREFERRED_NAME <> de_rec.preferred_name)) THEN
      p_return_code := 'API_DE_002';-- Retrieved Preferred Name does not match with parameter
      RETURN;
    END IF;

    /*If P_DE_CONTE_IDSEQ is not null and does not match the retrieved Context assign error code and RETURN*/
    IF(P_DE_CONTE_IDSEQ IS NOT NULL AND (P_DE_CONTE_IDSEQ <> de_rec.conte_idseq)) THEN
      p_return_code := 'API_DE_003';-- Retrieved Context does not Match with parameter
      RETURN;
    END IF;

    /*If P_DE_VERSION is not null and does not match retrieved Version assign error code and return*/
    IF(P_DE_VERSION IS NOT NULL AND (P_DE_VERSION <> de_rec.version)) THEN
      p_return_code := 'API_DE_004';-- Retrieved Version does not match with parameter
      RETURN;
    END IF;

    -- Assign the data retrieved to the parameters

    P_DE_PREFERRED_NAME            := de_rec.preferred_name;
    P_DE_CONTE_IDSEQ            := de_rec.conte_idseq;
    P_DE_VERSION                := de_rec.version;
    P_DE_PREFERRED_DEFINITION     := de_rec.preferred_definition;
    P_DE_LONG_NAME              := de_rec.long_name;
    P_DE_ASL_NAME                  := de_rec.asl_name;
    P_DE_DEC_IDSEQ                 := de_rec.dec_idseq;
    P_DE_VD_IDSEQ                 := de_rec.vd_idseq;
    P_DE_LATEST_VERSION_IND      := de_rec.latest_version_ind;
    P_DE_BEGIN_DATE             := de_rec.begin_date;
    P_DE_END_DATE                  := de_rec.end_date;
    P_DE_CHANGE_NOTE             := de_rec.change_note;
    P_DE_CREATED_BY              := de_rec.created_by;
    P_DE_DATE_CREATED            := de_rec.date_created;
    P_DE_MODIFIED_BY             := de_rec.modified_by;
    P_DE_DATE_MODIFIED          := de_rec.date_modified;
    P_DE_DELETED_IND            := de_rec.deleted_ind;

  ELSE  --Key is not provided, retrieve by name, Version and Context
    IF(P_DE_PREFERRED_NAME IS NOT NULL AND P_DE_CONTE_IDSEQ IS NOT NULL) THEN
      IF P_DE_VERSION IS NOT NULL THEN
        v_version := P_DE_VERSION;
        ELSE
          v_version := Sbrext_Common_Routines.get_ac_version(P_DE_PREFERRED_NAME, P_DE_CONTE_IDSEQ, 'DATAELEMENT');
           IF(v_version = 0) THEN
            p_return_code := 'API_DE_005';--DE not found
            RETURN;
      END IF;
    END IF;

    /*Retrieve the Data Element row based on Context, Preferred Name and Version number*/
    BEGIN
      SELECT *
      INTO de_rec
      FROM data_elements_view
      WHERE preferred_name = p_de_preferred_name
      AND conte_idseq = p_de_conte_idseq
      AND version = v_version;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_DE_005'; -- Data Element not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_DE_009'; -- Other raised on select from data_elements_view
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_DE_DE_IDSEQ                       := de_rec.de_idseq;
    P_DE_PREFERRED_NAME         := de_rec.preferred_name;
    P_DE_CONTE_IDSEQ          := de_rec.conte_idseq;
    P_DE_VERSION                 := de_rec.version;
    P_DE_PREFERRED_DEFINITION := de_rec.preferred_definition;
    P_DE_LONG_NAME               := de_rec.long_name;
    P_DE_ASL_NAME               := de_rec.asl_name;
    P_DE_DEC_IDSEQ              := de_rec.dec_idseq;
    P_DE_VD_IDSEQ              := de_rec.vd_idseq;
    P_DE_LATEST_VERSION_IND   := de_rec.latest_version_ind;
    P_DE_BEGIN_DATE              := de_rec.begin_date;
    P_DE_END_DATE               := de_rec.end_date;
    P_DE_CHANGE_NOTE          := de_rec.change_note;
    P_DE_CREATED_BY           := de_rec.created_by;
    P_DE_DATE_CREATED         := de_rec.date_created;
    P_DE_MODIFIED_BY          := de_rec.modified_by;
    P_DE_DATE_MODIFIED           := de_rec.date_modified;
    P_DE_DELETED_IND             := de_rec.deleted_ind;
  ELSE
    p_return_code := 'API_DE_001';--PK or name, conte_idseq, and version must be passed
    RETURN;
  END IF;
END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
       NULL;
  WHEN OTHERS THEN
       NULL;
END GET_DE;

/******************************************************************************
   NAME:       GET_ASL
   PURPOSE:    Gets a workflow status based on name.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_ASL(
P_RETURN_CODE
,P_ASL_NAME
,P_ASL_DESCRIPTION
,P_ASL_COMMENTS
,P_ASL_CREATED_BY
,P_ASL_DATE_CREATED
,P_ASL_MODIFIED_BY
,P_ASL_DATE_MODIFIED);

******************************************************************************/
PROCEDURE GET_ASL(
P_RETURN_CODE                OUT VARCHAR2
,P_ASL_ASL_NAME                IN OUT VARCHAR2
,P_ASL_DESCRIPTION            OUT VARCHAR2
,P_ASL_COMMENTS               OUT    VARCHAR2
,P_ASL_CREATED_BY            OUT    VARCHAR2
,P_ASL_DATE_CREATED            OUT    VARCHAR2
,P_ASL_MODIFIED_BY            OUT    VARCHAR2
,P_ASL_DATE_MODIFIED        OUT    VARCHAR2) IS

asl_rec ac_status_lov_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --The ID must be provided
  IF P_ASL_ASL_NAME IS NOT NULL THEN  --Retrieve the ac_status_lov row by key

    BEGIN
      SELECT *
      INTO asl_rec
      FROM ac_status_lov_view
      WHERE asl_name = P_ASL_ASL_NAME;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_ASL_005'; -- ac_status_lov_view row not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_ASL_009'; -- Other raised on select from ac_status_lov_view
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_ASL_ASL_NAME           := asl_rec.asl_name;
    P_ASL_DESCRIPTION  := asl_rec.description;
    P_ASL_COMMENTS     := asl_rec.comments;
    P_ASL_CREATED_BY   := asl_rec.created_by;
    P_ASL_DATE_CREATED    := asl_rec.date_created;
    P_ASL_MODIFIED_BY    := asl_rec.modified_by;
    P_ASL_DATE_MODIFIED    := asl_rec.date_modified;

  ELSE
    P_RETURN_CODE := 'API_ASL_001';--PK must be provided (name)
    RETURN;
END IF;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;

END GET_ASL;

/******************************************************************************
   NAME:       GET_CS
   PURPOSE:    Gets a Classification Scheme based on ID or on Preferred Name, Context, and Version

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_CS(
P_RETURN_CODE
, P_CS_IDSEQ
, P_CS_PREFERRED_NAME
, P_CS_CONTE_IDSEQ
, P_CS_VERSION
, P_CS_PREFERRED_DEFINITION
, P_CS_LONG_NAME
, P_CS_ASL_NAME
, P_CS_LATEST_VERSION_IND
, P_CS_CSTL_NAME
, P_CS_CMSL_NAME
, P_CS_LABEL_TYPE_FLAG
, P_CS_BEGIN_DATE
, P_CS_END_DATE
, P_CS_CHANGE_NOTE
, P_CS_CREATED_BY
, P_CS_DATE_CREATED
, P_CS_MODIFIED_BY
, P_CS_DATE_MODIFIED
, P_CS_DELETED_IND);

******************************************************************************/
PROCEDURE GET_CS(
P_RETURN_CODE                     OUT VARCHAR2
, P_CS_CS_IDSEQ                  IN OUT VARCHAR2
, P_CS_PREFERRED_NAME             IN OUT VARCHAR2
, P_CS_CONTE_IDSEQ              IN OUT VARCHAR2
, P_CS_VERSION                    IN OUT NUMBER
, P_CS_PREFERRED_DEFINITION        OUT VARCHAR2
, P_CS_LONG_NAME                  OUT VARCHAR2
, P_CS_ASL_NAME                  OUT VARCHAR2
, P_CS_LATEST_VERSION_IND        OUT VARCHAR2
, P_CS_CSTL_NAME                 OUT VARCHAR2
, P_CS_CMSL_NAME                OUT VARCHAR2
, P_CS_LABEL_TYPE_FLAG            OUT VARCHAR2
, P_CS_BEGIN_DATE                OUT VARCHAR2
, P_CS_END_DATE                    OUT VARCHAR2
, P_CS_CHANGE_NOTE                OUT VARCHAR2
, P_CS_CREATED_BY                OUT VARCHAR2
, P_CS_DATE_CREATED                OUT VARCHAR2
, P_CS_MODIFIED_BY                OUT VARCHAR2
, P_CS_DATE_MODIFIED            OUT VARCHAR2
, P_CS_DELETED_IND                OUT VARCHAR2) IS

cs_rec    classification_schemes_view%ROWTYPE;
v_version classification_schemes_view.version%TYPE;

BEGIN
  p_return_code := NULL;
  --At least one of the ID or Name parameters has to be provided
  IF P_CS_CS_IDSEQ IS NOT NULL THEN  --Retrieve the Classification_Scheme by key

    BEGIN
      SELECT *
      INTO cs_rec
      FROM classification_schemes_view
      WHERE cs_idseq = P_CS_CS_IDSEQ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
             p_return_code := 'API_CS_005'; --Classification Scheme not found
           RETURN;
      WHEN OTHERS THEN
           p_return_code := 'API_CS_009'; -- Other raised in select from Classification_Schemes_View
           RETURN;
    END;

    /*If  P_CS_PREFERRED_NAME is not null and does not match the retrieved Preferred Name
       then assign the error code */
    IF(P_CS_PREFERRED_NAME IS NOT NULL AND (P_CS_PREFERRED_NAME <> cs_rec.preferred_name)) THEN
      p_return_code := 'API_CS_002';-- Retrieved Preferred Name does not match with parameter
      RETURN;
    END IF;

    /*If P_CS_CONTE_IDSEQ is not null and does not match the retrieved Context assign error code and RETURN*/
    IF(P_CS_CONTE_IDSEQ IS NOT NULL AND (P_CS_CONTE_IDSEQ <> cs_rec.conte_idseq)) THEN
      p_return_code := 'API_CS_003';-- Retrieved Context does not Match with parameter
      RETURN;
    END IF;

    /*If P_CS_VERSION is not null and does not match retrieved Version assign error code and return*/
    IF(P_CS_VERSION IS NOT NULL AND (P_CS_VERSION <> cs_rec.version)) THEN
      p_return_code := 'API_CS_004';-- Retrieved Version does not match with parameter
      RETURN;
    END IF;

    -- Assign the data retrieved to the parameters

    P_CS_CS_IDSEQ                  := cs_rec.cs_idseq;
    P_CS_PREFERRED_NAME            := cs_rec.preferred_name;
    P_CS_CONTE_IDSEQ            := cs_rec.conte_idseq;
    P_CS_VERSION                := cs_rec.version;
    P_CS_PREFERRED_DEFINITION    := cs_rec.preferred_definition;
    P_CS_LONG_NAME                := cs_rec.long_name;
    P_CS_ASL_NAME                 := cs_rec.asl_name;
    P_CS_LATEST_VERSION_IND        := cs_rec.latest_version_ind;
    P_CS_CSTL_NAME                := cs_rec.cstl_name;
    P_CS_CMSL_NAME                := cs_rec.cmsl_name;
    P_CS_LABEL_TYPE_FLAG        := cs_rec.label_type_flag;
    P_CS_BEGIN_DATE                := cs_rec.begin_date;
    P_CS_END_DATE                := cs_rec.end_date;
    P_CS_CHANGE_NOTE            := cs_rec.change_note;
    P_CS_CREATED_BY                := cs_rec.created_by;
    P_CS_DATE_CREATED            := cs_rec.date_created;
    P_CS_MODIFIED_BY            := cs_rec.modified_by;
    P_CS_DATE_MODIFIED            := cs_rec.date_modified;
    P_CS_DELETED_IND            := cs_rec.deleted_ind;

  ELSE  --Key is not provided, retrieve by name, Version and Context
    IF(P_CS_PREFERRED_NAME IS NOT NULL AND P_CS_CONTE_IDSEQ IS NOT NULL) THEN
      IF P_CS_VERSION IS NOT NULL THEN
        v_version := P_CS_VERSION;
        ELSE
          v_version := Sbrext_Common_Routines.get_ac_version(P_CS_PREFERRED_NAME, P_CS_CONTE_IDSEQ, 'CLASSIFICATION');
           IF(v_version = 0) THEN
            p_return_code := 'API_CS_005';--Classification Scheme not found
            RETURN;
      END IF;
    END IF;

    /*Retrieve the Classification Scheme row based on Context, Preferred Name and Version number*/
    BEGIN
      SELECT *
      INTO cs_rec
      FROM classification_schemes_view
      WHERE preferred_name = p_cs_preferred_name
      AND conte_idseq = p_cs_conte_idseq
      AND version = v_version;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_CS_005'; -- Classification Scheme not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_CS_009'; -- Other raised on select from classification_schemes_view
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_CS_CS_IDSEQ                  := cs_rec.cs_idseq;
    P_CS_PREFERRED_NAME            := cs_rec.preferred_name;
    P_CS_CONTE_IDSEQ            := cs_rec.conte_idseq;
    P_CS_VERSION                := cs_rec.version;
    P_CS_PREFERRED_DEFINITION    := cs_rec.preferred_definition;
    P_CS_LONG_NAME                := cs_rec.long_name;
    P_CS_ASL_NAME                 := cs_rec.asl_name;
    P_CS_LATEST_VERSION_IND        := cs_rec.latest_version_ind;
    P_CS_CSTL_NAME                := cs_rec.cstl_name;
    P_CS_CMSL_NAME                := cs_rec.cmsl_name;
    P_CS_LABEL_TYPE_FLAG        := cs_rec.label_type_flag;
    P_CS_BEGIN_DATE                := cs_rec.begin_date;
    P_CS_END_DATE                := cs_rec.end_date;
    P_CS_CHANGE_NOTE            := cs_rec.change_note;
    P_CS_CREATED_BY                := cs_rec.created_by;
    P_CS_DATE_CREATED            := cs_rec.date_created;
    P_CS_MODIFIED_BY            := cs_rec.modified_by;
    P_CS_DATE_MODIFIED            := cs_rec.date_modified;
    P_CS_DELETED_IND            := cs_rec.deleted_ind;

  ELSE
    p_return_code := 'API_CS_001';--PK or name, conte_idseq, and version must be passed
    RETURN;
  END IF;
END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
       NULL;
  WHEN OTHERS THEN
       NULL;
END GET_CS;

/******************************************************************************
   NAME:       GET_CSI
   PURPOSE:    Gets Class Scheme Items based on ID or on CSI Name and CSITL Name or ID.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_CSI(
P_RETURN_CODE
,P_CSI_CSI_IDSEQ
,P_CSI_NAME
,P_CSI_CSITL_NAME
,P_CSI_DESCRIPTION
,P_CSI_COMMENTS
,P_CSI_CREATED_BY
,P_CSI_DATE_CREATED
,P_CSI_MODIFIED_BY
,P_CSI_DATE_MODIFIED);

******************************************************************************/
PROCEDURE GET_CSI(
P_RETURN_CODE                      OUT VARCHAR2
,P_CSI_CSI_IDSEQ                IN OUT VARCHAR2
,P_CSI_NAME                       IN OUT VARCHAR2
,P_CSI_CSITL_NAME                 IN OUT VARCHAR2
,P_CSI_DESCRIPTION                OUT VARCHAR2
,P_CSI_COMMENTS                 OUT VARCHAR2
,P_CSI_CREATED_BY                OUT VARCHAR2
,P_CSI_DATE_CREATED               OUT VARCHAR2
,P_CSI_MODIFIED_BY               OUT VARCHAR2
,P_CSI_DATE_MODIFIED            OUT VARCHAR2) IS

csi_rec    class_scheme_items_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --At least one of the ID or Name parameters has to be provided
  IF P_CSI_CSI_IDSEQ IS NOT NULL THEN  --Retrieve the Class_Scheme_Items by key

    BEGIN
      SELECT *
      INTO csi_rec
      FROM class_scheme_items_view
      WHERE csi_idseq = p_csi_csi_idseq;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
             p_return_code := 'API_CSI_005'; --Class scheme item not found
           RETURN;
      WHEN OTHERS THEN
           p_return_code := 'API_CSI_009'; -- Other raised in select from class_scheme_items_view
           RETURN;
    END;

    /*If  P_CSI_NAME  is not null and does not match the retrieved Preferred Name
       then assign the error code */
    IF(P_CSI_NAME  IS NOT NULL AND (P_CSI_NAME  <> csi_rec.csi_name)) THEN
      p_return_code := 'API_CSI_002';-- Retrieved CSI_Name does not match with parameter
      RETURN;
    END IF;

    /*If P_CSI_CSITL_NAME is not null and does not match the retrieved Context assign error code and RETURN*/
    IF(P_CSI_CSITL_NAME IS NOT NULL AND (P_CSI_CSITL_NAME <> csi_rec.csitl_name)) THEN
      p_return_code := 'API_CSI_003';-- Retrieved Context does not Match with parameter
      RETURN;
    END IF;

    -- Assign the data retrieved to the parameters
    P_CSI_CSI_IDSEQ       := csi_rec.csi_idseq;
    P_CSI_NAME           := csi_rec.csi_name;
    P_CSI_CSITL_NAME   := csi_rec.csitl_name;
    P_CSI_DESCRIPTION  := csi_rec.description;
    P_CSI_COMMENTS       := csi_rec.comments;
    P_CSI_CREATED_BY   := csi_rec.created_by;
    P_CSI_DATE_CREATED := csi_rec.date_created;
    P_CSI_MODIFIED_BY  := csi_rec.modiFied_by;
    P_CSI_DATE_MODIFIED := csi_rec.date_modified;

  ELSE  --Key is not provided, retrieve by csi_name and csitl_name
    IF(P_CSI_NAME IS NOT NULL AND P_CSI_CSITL_NAME IS NOT NULL) THEN
    /*Retrieve the Class Scheme items row based on csi_name and csitl_name*/
    BEGIN
      SELECT *
      INTO csi_rec
      FROM class_scheme_items_view
      WHERE csi_name = p_csi_name
      AND csitl_name = p_csi_csitl_name;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_CSI_005'; -- Class scheme itemsnot found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_CSI_009'; -- Other raised on select from class_scheme_items_view
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_CSI_CSI_IDSEQ       := csi_rec.csi_idseq;
    P_CSI_NAME           := csi_rec.csi_name;
    P_CSI_CSITL_NAME   := csi_rec.csitl_name;
    P_CSI_DESCRIPTION  := csi_rec.description;
    P_CSI_COMMENTS       := csi_rec.comments;
    P_CSI_CREATED_BY   := csi_rec.created_by;
    P_CSI_DATE_CREATED := csi_rec.date_created;
    P_CSI_MODIFIED_BY  := csi_rec.modified_by;
    P_CSI_DATE_MODIFIED := csi_rec.date_modified;

  ELSE
    p_return_code := 'API_CSI_001';--PK or csi_name and csitl_name must be passed
    RETURN;
  END IF;
END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
       NULL;
  WHEN OTHERS THEN
       NULL;
END GET_CSI;

/******************************************************************************
   NAME:       GET_CSCSI
   PURPOSE:    Gets Class Scheme Item, Class Scheme relationship information based
                  on relationship ID or Classification Scheme and Class Scheme Item and Parent.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_CS_CSI(
P_RETURN_CODE
,P_CS_CSI_IDSEQ
,P_CSCSI_CS_IDSEQ
,P_CSCSI_CSI_IDSEQ
,P_CSCSI_P_CS_CSI_IDSEQ
,P_CSCSI_LINK_CS_CSI_IDSEQ
,P_CSCSI_LABEL
,P_CSCSI_DISPLAY_ORDER
,P_CSCSI_CREATED_BY
,P_CSCSI_DATE_CREATED
,P_CSCSI_MODIFIED_BY
,P_CSCSI_DATE_MODIFIED);

******************************************************************************/
PROCEDURE GET_CS_CSI(
P_RETURN_CODE                     OUT VARCHAR2
,P_CSCSI_CS_CSI_IDSEQ            IN OUT VARCHAR2
,P_CSCSI_CS_IDSEQ                  IN OUT VARCHAR2
,P_CSCSI_CSI_IDSEQ                IN OUT VARCHAR2
,P_CSCSI_P_CS_CSI_IDSEQ            IN OUT VARCHAR2
,P_CSCSI_LINK_CS_CSI_IDSEQ        OUT VARCHAR2
,P_CSCSI_LABEL                    OUT VARCHAR2
,P_CSCSI_DISPLAY_ORDER            OUT NUMBER
,P_CSCSI_CREATED_BY                OUT VARCHAR2
,P_CSCSI_DATE_CREATED            OUT VARCHAR2
,P_CSCSI_MODIFIED_BY            OUT VARCHAR2
,P_CSCSI_DATE_MODIFIED            OUT VARCHAR2) IS

cs_csi_rec    cs_csi_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --At least one of the ID or Name parameters has to be provided
  IF P_CSCSI_CS_CSI_IDSEQ IS NOT NULL THEN  --Retrieve the relationship by key

    BEGIN
      SELECT *
      INTO cs_csi_rec
      FROM cs_csi_view
      WHERE cs_csi_idseq = P_CSCSI_CS_CSI_IDSEQ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
             p_return_code := 'API_CSCSI_005'; --Relationship not found
           RETURN;
      WHEN OTHERS THEN
           p_return_code := 'API_CSCSI_009'; -- Other raised in select from CS_CSI_VIEW
           RETURN;
    END;

    /*If P_CSCSI_CS_IDSEQ is not null and does not match the retrieved ID then assign the error code */
    IF(P_CSCSI_CS_IDSEQ  IS NOT NULL AND (P_CSCSI_CS_IDSEQ  <> cs_csi_rec.cs_idseq)) THEN
      p_return_code := 'API_CSCSI_002';-- Retrieved cs_idseq does not match with parameter
      RETURN;
    END IF;

    /*If P_CSCSI_CSI_IDSEQ is not null and does not match the retrieved ID assign error code and RETURN*/
    IF(P_CSCSI_CSI_IDSEQ  IS NOT NULL AND (P_CSCSI_CSI_IDSEQ  <> cs_csi_rec.csi_idseq)) THEN
      p_return_code := 'API_CSCSI_003';-- Retrieved ID does not Match with parameter
      RETURN;
    END IF;

    /*If P_CSCSI_P_CSCSI_CS_CSI_IDSEQ    is not null and does not match the retrieved ID assign error code and RETURN*/
    IF(P_CSCSI_P_CS_CSI_IDSEQ IS NOT NULL AND (P_CSCSI_P_CS_CSI_IDSEQ <> cs_csi_rec.P_CS_CSI_IDSEQ)) THEN
      p_return_code := 'API_CSCSI_004';-- Retrieved ID does not Match with parameter
      RETURN;
    END IF;

    -- Assign the data retrieved to the parameters
    P_CSCSI_CS_CSI_IDSEQ                    := cs_csi_rec.cs_csi_idseq;
    P_CSCSI_CS_IDSEQ             := cs_csi_rec.cs_idseq;
    P_CSCSI_CSI_IDSEQ             := cs_csi_rec.csi_idseq;
    P_CSCSI_P_CS_CSI_IDSEQ         := cs_csi_rec.p_cs_csi_idseq;
    P_CSCSI_LINK_CS_CSI_IDSEQ     := cs_csi_rec.link_cs_csi_idseq;
    P_CSCSI_LABEL                 := cs_csi_rec.label;
    P_CSCSI_DISPLAY_ORDER         := cs_csi_rec.display_order;
    P_CSCSI_CREATED_BY             := cs_csi_rec.created_by;
    P_CSCSI_DATE_CREATED         := cs_csi_rec.date_created;
    P_CSCSI_MODIFIED_BY             :=    cs_csi_rec.modified_by;
    P_CSCSI_DATE_MODIFIED         := cs_csi_rec.date_modified;

  ELSE  --Key is not provided, retrieve by unique key (3 ids)
    IF(P_CSCSI_CS_IDSEQ IS NOT NULL AND P_CSCSI_CSI_IDSEQ IS NOT NULL AND P_CSCSI_P_CS_CSI_IDSEQ IS NOT NULL) THEN
      /*Retrieve the relationship row based on id's*/
      BEGIN
        SELECT *
        INTO cs_csi_rec
        FROM cs_csi_view
        WHERE cs_idseq = p_cscsi_cs_idseq
        AND csi_idseq = p_cscsi_csi_idseq
        AND P_CSCSI_CS_CSI_IDSEQ = P_CSCSI_P_CS_CSI_IDSEQ;

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
              p_return_code := 'API_CSCSI_005'; --Relationship not found
           RETURN;
        WHEN OTHERS THEN
           p_return_code := 'API_CSCSI_009'; -- Other raised in select from CS_CSI_VIEW
           RETURN;
      END;

      -- Assign the data retrieved to the parameters
      P_CSCSI_CS_CSI_IDSEQ                := cs_csi_rec.cs_csi_idseq;
      P_CSCSI_CS_IDSEQ             := cs_csi_rec.cs_idseq;
      P_CSCSI_CSI_IDSEQ             := cs_csi_rec.csi_idseq;
      P_CSCSI_P_CS_CSI_IDSEQ     := cs_csi_rec.p_cs_csi_idseq;
      P_CSCSI_LINK_CS_CSI_IDSEQ     := cs_csi_rec.link_cs_csi_idseq;
      P_CSCSI_LABEL                 := cs_csi_rec.label;
      P_CSCSI_DISPLAY_ORDER         := cs_csi_rec.display_order;
      P_CSCSI_CREATED_BY         := cs_csi_rec.created_by;
      P_CSCSI_DATE_CREATED         := cs_csi_rec.date_created;
      P_CSCSI_MODIFIED_BY         :=    cs_csi_rec.modified_by;
      P_CSCSI_DATE_MODIFIED         := cs_csi_rec.date_modified;

  ELSE

    IF(P_CSCSI_CS_IDSEQ IS NULL OR P_CSCSI_CSI_IDSEQ IS NULL OR P_CSCSI_P_CS_CSI_IDSEQ IS NULL) THEN
      p_return_code := 'API_CSCSI_006'; --PK or complete UK must be passed
      RETURN;
    END IF;

    p_return_code := 'API_CSCSI_001';--PK or UK must be passed
    RETURN;
  END IF;
END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
       NULL;
  WHEN OTHERS THEN
       NULL;
END GET_CS_CSI;

/******************************************************************************
   NAME:       GET_AC_CSI
   PURPOSE:    Gets Administered Component, CS_CSI Relationship information based on ID
                  or CS_CSI and Administered Component and Parent.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_AC_CSI(
P_RETURN_CODE
,P_ACCSI_AC_CSI_IDSEQ
,P_ACCSI_CS_CSI_IDSEQ
,P_ACCSI_AC_IDSEQ
,P_ACCSI_CREATED_BY
,P_ACCSI_DATE_CREATED
,P_ACCSI_MODIFIED_BY
,P_ACCSI_DATE_MODIFIED);

******************************************************************************/
PROCEDURE GET_AC_CSI(
P_RETURN_CODE              OUT VARCHAR2
,P_ACCSI_AC_CSI_IDSEQ      IN OUT VARCHAR2
,P_ACCSI_CS_CSI_IDSEQ      IN OUT VARCHAR2
,P_ACCSI_AC_IDSEQ           IN OUT VARCHAR2
,P_ACCSI_CREATED_BY        OUT VARCHAR2
,P_ACCSI_DATE_CREATED      OUT VARCHAR2
,P_ACCSI_MODIFIED_BY       OUT VARCHAR2
,P_ACCSI_DATE_MODIFIED     OUT VARCHAR2) IS

ac_csi_rec    ac_csi_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --At least one of the ID or Name parameters has to be provided
  IF P_ACCSI_AC_CSI_IDSEQ IS NOT NULL THEN  --Retrieve the relationship by key

    BEGIN
      SELECT *
      INTO ac_csi_rec
      FROM ac_csi_view
      WHERE ac_csi_idseq = p_accsi_ac_csi_idseq;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
             p_return_code := 'API_ACCSI_005'; --Relationship not found
           RETURN;
      WHEN OTHERS THEN
           p_return_code := 'API_ACCSI_009'; -- Other raised in select from AC_CSI_VIEW
           RETURN;
    END;

    /*If P_ACCSI_CS_CSI_IDSEQ is not null and does not match the retrieved ID then assign the error code */
    IF(P_ACCSI_CS_CSI_IDSEQ  IS NOT NULL AND (P_ACCSI_CS_CSI_IDSEQ  <> ac_csi_rec.cs_csi_idseq)) THEN
      p_return_code := 'API_ACCSI_002';-- Retrieved cs_csi_idseq does not match with parameter
      RETURN;
    END IF;

    /*If P_ACCSI_AC_IDSEQ is not null and does not match the retrieved ID assign error code and RETURN*/
    IF(P_ACCSI_AC_IDSEQ  IS NOT NULL AND (P_ACCSI_AC_IDSEQ  <> ac_csi_rec.ac_idseq)) THEN
      p_return_code := 'API_ACCSI_003';-- Retrieved ID does not Match with parameter
      RETURN;
    END IF;

    -- Assign the data retrieved to the parameters
    P_ACCSI_AC_CSI_IDSEQ         := ac_csi_rec.ac_csi_idseq;
    P_ACCSI_CS_CSI_IDSEQ           := ac_csi_rec.cs_csi_idseq;
    P_ACCSI_AC_IDSEQ               := ac_csi_rec.ac_idseq;
    P_ACCSI_CREATED_BY             := ac_csi_rec.created_by;
    P_ACCSI_DATE_CREATED           := ac_csi_rec.date_created;
    P_ACCSI_MODIFIED_BY            := ac_csi_rec.modified_by;
    P_ACCSI_DATE_MODIFIED         := ac_csi_rec.date_modified;

  ELSE  --Key is not provided, retrieve by unique key (2ids)
    IF(P_ACCSI_CS_CSI_IDSEQ IS NOT NULL AND P_ACCSI_AC_IDSEQ IS NOT NULL) THEN
      /*Retrieve the relationship row based on id's*/
      BEGIN
        SELECT *
        INTO ac_csi_rec
        FROM ac_csi_view
        WHERE cs_csi_idseq = p_accsi_cs_csi_idseq
        AND ac_idseq = p_accsi_ac_idseq;

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
              p_return_code := 'API_ACCSI_005'; --Relationship not found
           RETURN;
        WHEN OTHERS THEN
           p_return_code := 'API_ACCSI_009'; -- Other raised in select from AC_CSI_VIEW
           RETURN;
      END;

    -- Assign the data retrieved to the parameters
    P_ACCSI_AC_CSI_IDSEQ         := ac_csi_rec.ac_csi_idseq;
    P_ACCSI_CS_CSI_IDSEQ           := ac_csi_rec.cs_csi_idseq;
    P_ACCSI_AC_IDSEQ               := ac_csi_rec.ac_idseq;
    P_ACCSI_CREATED_BY             := ac_csi_rec.created_by;
    P_ACCSI_DATE_CREATED           := ac_csi_rec.date_created;
    P_ACCSI_MODIFIED_BY            := ac_csi_rec.modified_by;
    P_ACCSI_DATE_MODIFIED         := ac_csi_rec.date_modified;

  ELSE

    IF(P_ACCSI_CS_CSI_IDSEQ IS NULL OR P_ACCSI_AC_IDSEQ IS NULL ) THEN
      p_return_code := 'API_ACCSI_006'; --PK or complete UK must be passed
      RETURN;
    END IF;

    p_return_code := 'API_ACCSI_001';--PK or UK must be passed
    RETURN;
  END IF;
END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
       NULL;
  WHEN OTHERS THEN
       NULL;
END GET_AC_CSI;

/******************************************************************************
   NAME:       GET_FORML
   PURPOSE:    Retrieves a format based on name.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_FORML(
P_RETURN_CODE
,P_FORML_NAME
,P_FORML_DESCRIPTION
,P_FROML_COMMENTS
,P_FORML_CREATED_BY
,P_FORML_DATE_CREATED
,P_FORML_MODIFIED_BY
,P_FORML_DATE_MODIFIED);

******************************************************************************/
PROCEDURE GET_FORML(
P_RETURN_CODE                OUT VARCHAR2
,P_FORML_FORML_NAME            IN OUT VARCHAR2
,P_FORML_DESCRIPTION        OUT VARCHAR2
,P_FORML_COMMENTS           OUT    VARCHAR2
,P_FORML_CREATED_BY            OUT    VARCHAR2
,P_FORML_DATE_CREATED        OUT    VARCHAR2
,P_FORML_MODIFIED_BY        OUT    VARCHAR2
,P_FORML_DATE_MODIFIED        OUT    VARCHAR2) IS

forml_rec formats_lov_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --The ID must be provided
  IF P_FORML_FORML_NAME IS NOT NULL THEN  --Retrieve the formats_lov row by key

    BEGIN
      SELECT *
      INTO forml_rec
      FROM formats_lov_view
      WHERE forml_name = P_FORML_FORML_NAME;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_FORML_005'; -- formats_lov_view row not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_FORML_009'; -- Other raised on select from formats_lov_view
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_FORML_FORML_NAME         := forml_rec.forml_name;
    P_FORML_DESCRIPTION  := forml_rec.description;
    P_FORML_COMMENTS     := forml_rec.comments;
    P_FORML_CREATED_BY   := forml_rec.created_by;
    P_FORML_DATE_CREATED := forml_rec.date_created;
    P_FORML_MODIFIED_BY     := forml_rec.modified_by;
    P_FORML_DATE_MODIFIED    := forml_rec.date_modified;

  ELSE
    P_RETURN_CODE := 'API_FORML_001';--PK must be provided (name)
    RETURN;
END IF;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;

END GET_FORML;

/******************************************************************************
   NAME:       GET_UOML
   PURPOSE:    Retrieves a unit of measure lov row by name.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_UOML(
P_RETURN_CODE
,P_UOML_NAME
,P_UOML_DESCRIPTION
,P_UOML_COMMENTS
,P_UOML_CREATED_BY
,P_UOML_DATE_CREATED
,P_UOML_MODIFIED_BY
,P_UOML_DATE_MODIFIED);

******************************************************************************/
PROCEDURE GET_UOML(
P_RETURN_CODE            OUT VARCHAR2
,P_UOML_UOML_NAME        IN OUT VARCHAR2
,P_UOML_DESCRIPTION        OUT VARCHAR2
,P_UOML_COMMENTS           OUT    VARCHAR2
,P_UOML_CREATED_BY        OUT    VARCHAR2
,P_UOML_DATE_CREATED    OUT    VARCHAR2
,P_UOML_MODIFIED_BY        OUT    VARCHAR2
,P_UOML_DATE_MODIFIED    OUT    VARCHAR2) IS

uoml_rec unit_of_measures_lov_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --The ID must be provided
  IF P_UOML_UOML_NAME IS NOT NULL THEN  --Retrieve the unit_of_measures_lov row by key

    BEGIN
      SELECT *
      INTO uoml_rec
      FROM unit_of_measures_lov_view
      WHERE uoml_name = P_UOML_UOML_NAME;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_UOML_005'; -- unit_of_measures_lov_view row not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_UOML_009'; -- Other raised on select from unit_of_measures_lov_view
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_UOML_UOML_NAME           := uoml_rec.uoml_name;
    P_UOML_DESCRIPTION  := uoml_rec.description;
    P_UOML_COMMENTS     := uoml_rec.comments;
    P_UOML_CREATED_BY   := uoml_rec.created_by;
    P_UOML_DATE_CREATED := uoml_rec.date_created;
    P_UOML_MODIFIED_BY     := uoml_rec.modified_by;
    P_UOML_DATE_MODIFIED := uoml_rec.date_modified;

  ELSE
    P_RETURN_CODE := 'API_UOML_001';--PK must be provided (name)
    RETURN;
END IF;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;

END GET_UOML;

/******************************************************************************
   NAME:       GET_QCDL
   PURPOSE:    Retrieves a QC Display row by name.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/04/2001  Prerna Aggarwal     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_QCDL(
P_RETURN_CODE
,P_QCDL_NAME
,P_QCDL_DESCRIPTION
,P_QCDL_COMMENTS
,P_QCDL_CREATED_BY
,P_QCDL_DATE_CREATED
,P_QCDL_MODIFIED_BY
,P_QCDL_DATE_MODIFIED);

******************************************************************************/
PROCEDURE GET_QCDL(
P_RETURN_CODE            OUT VARCHAR2
,P_QCDL_QCDL_NAME        IN OUT VARCHAR2
,P_QCDL_DESCRIPTION        OUT VARCHAR2
,P_QCDL_COMMENTS           OUT    VARCHAR2
,P_QCDL_CREATED_BY        OUT    VARCHAR2
,P_QCDL_DATE_CREATED    OUT    VARCHAR2
,P_QCDL_MODIFIED_BY        OUT    VARCHAR2
,P_QCDL_DATE_MODIFIED    OUT    VARCHAR2) IS

qcdl_rec qc_display_lov_view_ext%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --The ID must be provided
  IF P_QCDL_QCDL_NAME IS NOT NULL THEN  --Retrieve the qc_display_lov row by key

    BEGIN
      SELECT *
      INTO qcdl_rec
      FROM qc_display_lov_view_ext
      WHERE QCDl_name = P_QCDL_QCDL_NAME;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_QCDL_005'; -- qc_display_lov_view_ext row not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_QCDL_009'; -- Other raised on select from qc_display_lov_view_ext
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_QCDL_QCDL_NAME    := qcdl_rec.QCDl_name;
    P_QCDL_DESCRIPTION  := qcdl_rec.description;
    P_QCDL_CREATED_BY   := qcdl_rec.created_by;
    P_QCDL_DATE_CREATED := qcdl_rec.date_created;
    P_QCDL_MODIFIED_BY  := qcdl_rec.modified_by;
    P_QCDL_DATE_MODIFIED := qcdl_rec.date_modified;

  ELSE
    P_RETURN_CODE := 'API_QCDL_001';--PK must be provided (name)
    RETURN;
END IF;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;

END GET_QCDL;


/******************************************************************************
   NAME:       GET_DTL
   PURPOSE:    Retrieves a datatype lov row by name.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_DTL(
P_RETURN_CODE
,P_DTL_NAME
,P_DTL_DESCRIPTION
,P_DTL_COMMENTS);

******************************************************************************/
PROCEDURE GET_DTL(
P_RETURN_CODE                OUT VARCHAR2
,P_DTL_DTL_NAME            IN OUT VARCHAR2
,P_DTL_DESCRIPTION            OUT VARCHAR2
,P_DTL_COMMENTS               OUT    VARCHAR2) IS

dtl_rec datatypes_lov_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --The ID must be provided
  IF P_DTL_DTL_NAME IS NOT NULL THEN  --Retrieve the datatypes_lov row by key

    BEGIN
      SELECT *
      INTO dtl_rec
      FROM datatypes_lov_view
      WHERE dtl_name = P_DTL_DTL_NAME;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_DTL_005'; -- datatypes_lov_view row not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_DTL_009'; -- Other raised on select from datatypes_lov_view
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_DTL_DTL_NAME           := dtl_rec.dtl_name;
    P_DTL_DESCRIPTION  := dtl_rec.description;
    P_DTL_COMMENTS     := dtl_rec.comments;

  ELSE
    P_RETURN_CODE := 'API_DTL_001';--PK must be provided (name)
    RETURN;
END IF;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;

END GET_DTL;

/******************************************************************************
   NAME:       GET_CHAR_SET
   PURPOSE:    Retrieves a character_set_lov row by name.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_CHAR_SET(
P_RETURN_CODE
,P_CHAR_SET_NAME
,P_CHAR_SET_DESCRIPTION
,P_CHAR_SET_COMMENTS
,P_CHAR_SET_CREATED_BY
,P_CHAR_SETL_DATE_CREATED
,P_CHAR_SET_MODIFIED_BY
,P_CHAR_SET_DATE_MODIFIED);

******************************************************************************/
PROCEDURE GET_CHAR_SET(
P_RETURN_CODE                OUT VARCHAR2
,P_CHAR_SET_CHAR_SET_NAME    IN OUT VARCHAR2
,P_CHAR_SET_DESCRIPTION        OUT VARCHAR2
,P_CHAR_SET_CREATED_BY        OUT    VARCHAR2
,P_CHAR_SET_DATE_CREATED    OUT    VARCHAR2
,P_CHAR_SET_MODIFIED_BY        OUT    VARCHAR2
,P_CHAR_SET_DATE_MODIFIED    OUT    VARCHAR2) IS

char_set_rec character_set_lov_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --The ID must be provided
  IF P_CHAR_SET_CHAR_SET_NAME IS NOT NULL THEN  --Retrieve the character_set_lov row by key

    BEGIN
      SELECT *
      INTO char_set_rec
      FROM character_set_lov_view
      WHERE char_set_name = P_CHAR_SET_CHAR_SET_NAME;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_CHARSET_005'; -- character_set_lov_view row not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_CHARSET_009'; -- Other raised on select from character_set_lov_view
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_CHAR_SET_CHAR_SET_NAME           := char_set_rec.char_set_name;
    P_CHAR_SET_DESCRIPTION  := char_set_rec.description;
    P_CHAR_SET_CREATED_BY   := char_set_rec.created_by;
    P_CHAR_SET_DATE_CREATED := char_set_rec.date_created;
    P_CHAR_SET_MODIFIED_BY     := char_set_rec.modified_by;
    P_CHAR_SET_DATE_MODIFIED := char_set_rec.date_modified;

  ELSE
    P_RETURN_CODE := 'API_CHARSET_001';--PK must be provided (name)
    RETURN;
END IF;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;

END GET_CHAR_SET;

/******************************************************************************
   NAME:       GET_DCTL
   PURPOSE:    Retrieves a document_type_lov row by name.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_DCTL(
P_RETURN_CODE
,P_DCTL_NAME
,P_DCTL_DESCRIPTION
,P_DCTL_COMMENTS
,P_DCTL_CREATED_BY
,P_DCTL_DATE_CREATED
,P_DCTL_MODIFIED_BY
,P_DCTL_DATE_MODIFIED);

******************************************************************************/
PROCEDURE GET_DCTL(
P_RETURN_CODE                OUT VARCHAR2
,P_DCTL_DCTL_NAME        IN OUT VARCHAR2
,P_DCTL_DESCRIPTION            OUT VARCHAR2
,P_DCTL_COMMENTS               OUT    VARCHAR2
,P_DCTL_CREATED_BY            OUT    VARCHAR2
,P_DCTL_DATE_CREATED        OUT    VARCHAR2
,P_DCTL_MODIFIED_BY            OUT    VARCHAR2
,P_DCTL_DATE_MODIFIED        OUT    VARCHAR2) IS

dctl_rec document_types_lov_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --The ID must be provided
  IF P_DCTL_DCTL_NAME IS NOT NULL THEN  --Retrieve the _lov row by key

    BEGIN
      SELECT *
      INTO dctl_rec
      FROM document_types_lov_view
      WHERE dctl_name = P_DCTL_DCTL_NAME;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_DCTL_005'; -- document_types_lov_view row not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_DCTL_009'; -- Other raised on select from document_types_lov_view
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_DCTL_DCTL_NAME           := dctl_rec.dctl_name;
    P_DCTL_DESCRIPTION  := dctl_rec.description;
    P_DCTL_COMMENTS     := dctl_rec.comments;
    P_DCTL_CREATED_BY   := dctl_rec.created_by;
    P_DCTL_DATE_CREATED := dctl_rec.date_created;
    P_DCTL_MODIFIED_BY     := dctl_rec.modified_by;
    P_DCTL_DATE_MODIFIED := dctl_rec.date_modified;

  ELSE
    P_RETURN_CODE := 'API_DCTL_001';--PK must be provided (name)
    RETURN;
END IF;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;

END GET_DCTL;


/******************************************************************************
   NAME:       GET_DETL
   PURPOSE:    Retrieves a document_type_lov row by name.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_DETL(
P_RETURN_CODE
,P_DETL_NAME
,P_DETL_DESCRIPTION
,P_DETL_COMMENTS
,P_DETL_CREATED_BY
,P_DETL_DATE_CREATED
,P_DETL_MODIFIED_BY
,P_DETL_DATE_MODIFIED);

******************************************************************************/
PROCEDURE GET_DETL(
P_RETURN_CODE                OUT VARCHAR2
,P_DETL_DETL_NAME            IN OUT VARCHAR2
,P_DETL_DESCRIPTION            OUT VARCHAR2
,P_DETL_COMMENTS               OUT    VARCHAR2
,P_DETL_CREATED_BY            OUT    VARCHAR2
,P_DETL_DATE_CREATED        OUT    VARCHAR2
,P_DETL_MODIFIED_BY            OUT    VARCHAR2
,P_DETL_DATE_MODIFIED        OUT    VARCHAR2) IS

detl_rec designation_types_lov_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --The ID must be provided
  IF P_DETL_DETL_NAME IS NOT NULL THEN  --Retrieve the designation_types_lov row by key

    BEGIN
      SELECT *
      INTO detl_rec
      FROM designation_types_lov_view
      WHERE detl_name = P_DETL_DETL_NAME;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_DETL_005'; -- designation_types_lov_view row not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_DETL_009'; -- Other raised on select from designation_types_lov_view
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_DETL_DETL_NAME           := detl_rec.detl_name;
    P_DETL_DESCRIPTION  := detl_rec.description;
    P_DETL_COMMENTS     := detl_rec.comments;
    P_DETL_CREATED_BY   := detl_rec.created_by;
    P_DETL_DATE_CREATED := detl_rec.date_created;
    P_DETL_MODIFIED_BY     := detl_rec.modified_by;
    P_DETL_DATE_MODIFIED := detl_rec.date_modified;

  ELSE
    P_RETURN_CODE := 'API_DETL_001';--PK must be provided (name)
    RETURN;
END IF;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;

END GET_DETL;

/******************************************************************************
   NAME:       GET_RL
   PURPOSE:    Retrieves a relationship_type_lov row by name.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_RL(
P_RETURN_CODE
,P_RL_NAME
,P_RL_DESCRIPTION
,P_RL_COMMENTS
,P_RL_CREATED_BY
,P_RL_DATE_CREATED
,P_RL_MODIFIED_BY
,P_RL_DATE_MODIFIED);

******************************************************************************/
PROCEDURE GET_RL(
P_RETURN_CODE            OUT VARCHAR2
,P_RL_RL_NAME                IN OUT VARCHAR2
,P_RL_DESCRIPTION        OUT VARCHAR2
,P_RL_COMMENTS           OUT    VARCHAR2
,P_RL_CREATED_BY        OUT    VARCHAR2
,P_RL_DATE_CREATED        OUT    VARCHAR2
,P_RL_MODIFIED_BY        OUT    VARCHAR2
,P_RL_DATE_MODIFIED    OUT    VARCHAR2) IS

rl_rec relationships_lov_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --The ID must be provided
  IF p_rl_rl_name IS NOT NULL THEN  --Retrieve the relationships_lov row by key

    BEGIN
      SELECT *
      INTO rl_rec
      FROM relationships_lov_view
      WHERE rl_name = P_RL_RL_NAME;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_RL_005'; -- relationships_lov_view row not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_RL_009'; -- Other raised on select from relationships_lov_view
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_RL_RL_NAME           := rl_rec.rl_name;
    P_RL_DESCRIPTION  := rl_rec.description;
    P_RL_COMMENTS     := rl_rec.comments;
    P_RL_CREATED_BY   := rl_rec.created_by;
    P_RL_DATE_CREATED := rl_rec.date_created;
    P_RL_MODIFIED_BY     := rl_rec.modified_by;
    P_RL_DATE_MODIFIED := rl_rec.date_modified;

  ELSE
    P_RETURN_CODE := 'API_RL_001';--PK must be provided (name)
    RETURN;
END IF;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;

END GET_RL;

/******************************************************************************
   NAME:       GET_RD
   PURPOSE:    Retrieves a Reference_Document row by name or ID

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/29/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_RD(
P_RETURN_CODE
,P_RD_IDSEQ
,P_RD_NAME
,P_RD_AC_IDSEQ
,P_RD_DCTL_NAME
,P_RD_ACH_IDSEQ
,P_RD_ORG_IDSEQ
,P_RD_AR_IDSEQ
,P_RD_RDTL_NAME
,P_RD_DOC_TEXT
,P_RD_URL
,P_RD_CREATED_BY
,P_RD_DATE_CREATED
,P_RD_MODIFIED_BY
,P_RD_DATE_MODIFIED);

******************************************************************************/
PROCEDURE GET_RD(
P_RETURN_CODE            OUT VARCHAR2
,P_RD_RD_IDSEQ            IN OUT VARCHAR2
,P_RD_NAME                IN OUT VARCHAR2
,P_RD_DCTL_NAME            OUT VARCHAR2
,P_RD_AC_IDSEQ            OUT VARCHAR2
,P_RD_ACH_IDSEQ            OUT VARCHAR2
,P_RD_AR_IDSEQ            OUT VARCHAR2
,P_RD_ORG_IDSEQ            OUT VARCHAR2
,P_RD_RDTL_NAME            OUT VARCHAR2
,P_RD_DOC_TEXT            OUT VARCHAR2
,P_RD_URL                OUT VARCHAR2
,P_RD_CREATED_BY        OUT    VARCHAR2
,P_RD_DATE_CREATED        OUT    VARCHAR2
,P_RD_MODIFIED_BY        OUT    VARCHAR2
,P_RD_DATE_MODIFIED        OUT    VARCHAR2) IS

rd_rec    reference_documents_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --At least one of the ID or Name parameters has to be provided
  IF P_RD_RD_IDSEQ IS NOT NULL THEN  --Retrieve the relationship by key

    BEGIN
      SELECT *
      INTO rd_rec
      FROM reference_documents_view
      WHERE rd_idseq = P_RD_RD_IDSEQ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
             p_return_code := 'API_RD_005'; --Reference Document not found
           RETURN;
      WHEN OTHERS THEN
           p_return_code := 'API_RD_009'; -- Other raised in select from reference_documents_view
           RETURN;
    END;

    /*If P_RD_NAME is not null and does not match the retrieved name then assign the error code */
    IF(P_RD_NAME IS NOT NULL AND (P_RD_NAME  <> rd_rec.name)) THEN
      p_return_code := 'API_RD_002';-- Retrieved name does not match with parameter
      RETURN;
    END IF;

    -- Assign the data retrieved to the parameters
    P_RD_RD_IDSEQ           := rd_rec.rd_idseq;
    P_RD_NAME           := rd_rec.name;
    P_RD_AC_IDSEQ      := rd_rec.ac_idseq;
    P_RD_DCTL_NAME     := rd_rec.dctl_name;
    P_RD_ACH_IDSEQ     := rd_rec.ach_idseq;
    P_RD_ORG_IDSEQ     := rd_rec.org_idseq;
    P_RD_AR_IDSEQ     := rd_rec.ar_idseq;
    P_RD_RDTL_NAME     := rd_rec.rdtl_name;
    P_RD_DOC_TEXT     := rd_rec.doc_text;
    P_RD_URL         := rd_rec.url;
    P_RD_CREATED_BY     := rd_rec.created_by;
    P_RD_DATE_CREATED    := rd_rec.date_created;
    P_RD_MODIFIED_BY    := rd_rec.modified_by;
    P_RD_DATE_MODIFIED    := rd_rec.date_modified;

  ELSE  --Key is not provided, retrieve by name
    IF(P_RD_NAME IS NOT NULL) THEN
      /*Retrieve the relationship row based on id's*/
      BEGIN
        SELECT *
        INTO rd_rec
        FROM reference_documents_view
        WHERE name = p_rd_name;

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
              p_return_code := 'API_RD_005'; --reference_document not found
           RETURN;
        WHEN OTHERS THEN
           p_return_code := 'API_RD_009'; -- Other raised in select from reference_documents_view
           RETURN;
      END;

    -- Assign the data retrieved to the parameters
    P_RD_RD_IDSEQ           := rd_rec.rd_idseq;
    P_RD_NAME           := rd_rec.name;
    P_RD_AC_IDSEQ      := rd_rec.ac_idseq;
    P_RD_DCTL_NAME     := rd_rec.dctl_name;
    P_RD_ACH_IDSEQ     := rd_rec.ach_idseq;
    P_RD_ORG_IDSEQ     := rd_rec.org_idseq;
    P_RD_AR_IDSEQ     := rd_rec.ar_idseq;
    P_RD_RDTL_NAME     := rd_rec.rdtl_name;
    P_RD_DOC_TEXT     := rd_rec.doc_text;
    P_RD_URL         := rd_rec.url;
    P_RD_CREATED_BY     := rd_rec.created_by;
    P_RD_DATE_CREATED    := rd_rec.date_created;
    P_RD_MODIFIED_BY    := rd_rec.modified_by;
    P_RD_DATE_MODIFIED    := rd_rec.date_modified;

  ELSE

    p_return_code := 'API_RD_001';--PK or UK must be passed
    RETURN;
  END IF;
END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
       NULL;
  WHEN OTHERS THEN
       NULL;
END GET_RD;


/******************************************************************************
   NAME:       GET_DES
   PURPOSE:    Retrieves Designation information row by name or ID

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/29/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_DES(
P_RETURN_CODE
,P_DES_IDSEQ
,P_DES_AC_IDSEQ
,P_DES_NAME
,P_DES_DETL_NAME
,P_DES_CONTE_IDSEQ
,P_DES_URL
,P_LAE_NAME
,P_DES_CREATED_BY
,P_DES_DATE_CREATED
,P_DES_MODIFIED_BY
,P_DES_DATE_MODIFIED);

******************************************************************************/
PROCEDURE GET_DES(
P_RETURN_CODE              OUT VARCHAR2
,P_DES_DESIG_IDSEQ        IN OUT VARCHAR2
,P_DES_AC_IDSEQ               IN OUT VARCHAR2
,P_DES_NAME                IN OUT VARCHAR2
,P_DES_DETL_NAME        IN OUT VARCHAR2
,P_DES_CONTE_IDSEQ        IN OUT VARCHAR2
,P_DES_LAE_NAME            OUT VARCHAR2
,P_DES_CREATED_BY        OUT    VARCHAR2
,P_DES_DATE_CREATED        OUT    VARCHAR2
,P_DES_MODIFIED_BY        OUT    VARCHAR2
,P_DES_DATE_MODIFIED    OUT    VARCHAR2) IS

des_rec    designations_view%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --At least one of the ID or Name parameters has to be provided
  IF P_DES_DESIG_IDSEQ IS NOT NULL THEN  --Retrieve the relationship by key

    BEGIN
      SELECT *
      INTO des_rec
      FROM designations_view
      WHERE desig_idseq = P_DES_DESIG_IDSEQ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
             p_return_code := 'API_DES_005'; --Designations not found
           RETURN;
      WHEN OTHERS THEN
           p_return_code := 'API_DES_009'; -- Other raised in select from designations_view
           RETURN;
    END;

    /*If P_DES_NAME is not null and does not match the retrieved name then assign the error code */
    IF(P_DES_NAME IS NOT NULL AND (P_DES_NAME  <> des_rec.name)) THEN
      p_return_code := 'API_DES_002';-- Retrieved name does not match with parameter
      RETURN;
    END IF;

    /*If P_DES_AC_IDSEQ is not null and does not match the retrieved ID then assign the error code */
    IF(P_DES_AC_IDSEQ IS NOT NULL AND (P_DES_AC_IDSEQ  <> des_rec.ac_idseq)) THEN
      p_return_code := 'API_DES_003';-- Retrieved administered component id does not match with parameter
      RETURN;
    END IF;

    /*If P_DES_DETL_NAMEis not null and does not match the retrieved designation type then assign the error code */
    IF(P_DES_DETL_NAME IS NOT NULL AND (P_DES_DETL_NAME  <> des_rec.detl_name)) THEN
      p_return_code := 'API_DES_004';-- Retrieved designation type does not match with parameter
      RETURN;
    END IF;

        /*If P_DES_CONTE_IDSEQ is not null and does not match the retrieved context then assign the error code */
    IF(P_DES_CONTE_IDSEQ IS NOT NULL AND (P_DES_CONTE_IDSEQ <> des_rec.conte_idseq)) THEN
      p_return_code := 'API_DES_010';-- Retrieved context type does not match with parameter
      RETURN;
    END IF;

    -- Assign the data retrieved to the parameters
    P_DES_DESIG_IDSEQ             := des_rec.desig_idseq;
    P_DES_AC_IDSEQ       := des_rec.ac_idseq;
    P_DES_NAME           := des_rec.name;
    P_DES_DETL_NAME       := des_rec.detl_name;
    P_DES_CONTE_IDSEQ  := des_rec.conte_idseq;
    P_DES_LAE_NAME      := des_rec.lae_name;
    P_DES_CREATED_BY   := des_rec.created_by;
    P_DES_DATE_CREATED := des_rec.date_created;
    P_DES_MODIFIED_BY  := des_rec.modified_by;
    P_DES_DATE_MODIFIED := des_rec.date_modified;

  ELSE
    IF (P_DES_AC_IDSEQ IS NOT NULL AND P_DES_NAME IS NOT NULL AND P_DES_DETL_NAME IS NOT NULL AND P_DES_CONTE_IDSEQ IS NOT NULL) THEN
        /*Retrieve the relationship row based on id's*/
      BEGIN
        SELECT *
        INTO des_rec
        FROM designations_view
        WHERE ac_idseq = P_DES_AC_IDSEQ
        AND name = P_DES_NAME
        AND detl_name = P_DES_DETL_NAME
        AND conte_idseq = P_DES_CONTE_IDSEQ;

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
              p_return_code := 'API_DES_005'; --designation not found
           RETURN;
        WHEN OTHERS THEN
           p_return_code := 'API_DES_009'; -- Other raised in select from designations_view
           RETURN;
      END;

      -- Assign the data retrieved to the parameters
      P_DES_DESIG_IDSEQ             := des_rec.desig_idseq;
      P_DES_AC_IDSEQ       := des_rec.ac_idseq;
      P_DES_NAME           := des_rec.name;
      P_DES_DETL_NAME       := des_rec.detl_name;
      P_DES_CONTE_IDSEQ  := des_rec.conte_idseq;
      P_DES_LAE_NAME       := des_rec.lae_name;
      P_DES_CREATED_BY   := des_rec.created_by;
      P_DES_DATE_CREATED := des_rec.date_created;
      P_DES_MODIFIED_BY  := des_rec.modified_by;
      P_DES_DATE_MODIFIED := des_rec.date_modified;
    --END IF;

  ELSE

   --Key is not provided, retrieve by UK
    IF(P_DES_AC_IDSEQ IS NULL OR P_DES_NAME IS NULL OR P_DES_DETL_NAME IS NULL OR P_DES_CONTE_IDSEQ IS NULL) THEN
      p_return_code := 'API_DES_006'; --PK or complete UK must be passed
      RETURN;
   END IF;
  END IF;
END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
       NULL;
  WHEN OTHERS THEN
       NULL;
END GET_DES;

/******************************************************************************
   NAME:       GET_QC
   PURPOSE:    Retrieves Questionnair Content by ID or Preferred Name, Context, and Version.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/29/2001  Lisa Schick     1. Created this procedure
   1.0        12/19/2001  Prerna Aggarwal 2. Changed it to accomodate changes in the quest_contetns_table
   1.0        02/06/2002  Prerna Aggarwal 2. Changed it to add highlight indicator


   EXAMPLE USE:    PROCEDURE GET_QC(
P_RETURN_CODE             Out Varchar2
,P_QC_QC_IDSEQ            In OUT VARCHAR2
,P_QC_PREFERRED_NAME        In Out Varchar2
,P_QC_CONTE_IDSEQ        In OUT VARCHAR2
,P_QC_VERSION            In Out Number
,P_QC_PREFERRED_DEFINITION    Out Varchar2
,P_QC_LONG_NAME             Out Varchar2
,P_QC_QTL_NAME            Out Varchar2
,P_QC_ASL_NAME            Out Varchar2
,P_QC_PROTO_IDSEQ        OUT VARCHAR2
,P_QC_DE_IDSEQ            OUT VARCHAR2
,P_QC_VP_IDSEQ            OUT VARCHAR2
,P_QC_QC_MATCH_IDSEQ        OUT VARCHAR2
,P_QC_MATCH_IND            Out Varchar2
,P_QC_QC_IDENTIFIER        Out Varchar2
,p_QCDL_NAME                    out Varchar2
,P_QC_LASTEST_VERSION_IND    Out Varchar2
,P_QC_NEW_QC_IND        Out Varchar2
,P_QC_HIGHLIGHT_IND            OUT VARCHAR2
,P_QC_SYSTEM_MSGS        Out Varchar2
,P_QC_REVIEWER_FEEDBACK_EXT    Out Varchar2
,P_QC_REVIEWER_FEEDBACK_ACT       Out Varchar2
,P_QC_REVIEWER_FEEDBACK_INT    Out Varchar2
,P_QC_REVIEWED_BY        Out Varchar2
,P_QC_REVIEWED_DATE        Out Varchar2
,P_QC_APPROVED_BY        Out Varchar2
,P_QC_APPROVED_DATE        Out Varchar2
,P_QC_CDE_DICTIONARY_ID        Out Number
,P_QC_BEGIN_DATE        Out Varchar2
,P_QC_END_DATE            Out Varchar2
,P_QC_CHANGE_NOTE        Out Varchar2

,P_QC_CREATED_BY        Out Varchar2
,P_QC_DATE_CREATED        Out Varchar2
,P_QC_MODIFIED_BY        Out Varchar2
,P_QC_DATE_MODIFIED        Out Varchar2
,P_QC_DELETED_IND        Out Varchar2);

******************************************************************************/
PROCEDURE GET_QC(
P_RETURN_CODE                 OUT VARCHAR2
,P_QC_QC_IDSEQ                IN OUT VARCHAR2
,P_QC_PREFERRED_NAME        IN OUT VARCHAR2
,P_QC_CONTE_IDSEQ            IN OUT VARCHAR2
,P_QC_VERSION                IN OUT NUMBER
,P_QC_PREFERRED_DEFINITION    OUT VARCHAR2
,P_QC_LONG_NAME                 OUT VARCHAR2
,P_QC_QTL_NAME                OUT VARCHAR2
,P_QC_ASL_NAME                OUT VARCHAR2
,P_QC_PROTO_IDSEQ            OUT VARCHAR2
,P_QC_DE_IDSEQ                OUT VARCHAR2
,P_QC_VP_IDSEQ                OUT VARCHAR2
,P_QC_QC_MATCH_IDSEQ        OUT VARCHAR2
,P_QC_MATCH_IND                OUT VARCHAR2
,P_QC_QC_IDENTIFIER            OUT VARCHAR2
,P_QC_QCDL_NAME             OUT VARCHAR2
,P_QC_LASTEST_VERSION_IND    OUT VARCHAR2
,P_QC_NEW_QC_IND            OUT VARCHAR2
,P_QC_HIGHLIGHT_IND            OUT VARCHAR2
,P_QC_SYSTEM_MSGS            OUT VARCHAR2
,P_QC_REVIEWER_FEEDBACK_EXT    OUT VARCHAR2
,P_QC_REVIEWER_FEEDBACK_ACT OUT VARCHAR2
,P_QC_REVIEWER_FEEDBACK_INT    OUT VARCHAR2
,P_QC_REVIEWED_BY            OUT VARCHAR2
,P_QC_REVIEWED_DATE            OUT VARCHAR2
,P_QC_APPROVED_BY            OUT VARCHAR2
,P_QC_APPROVED_DATE            OUT VARCHAR2
,P_QC_CDE_DICTIONARY_ID        OUT NUMBER
,P_QC_BEGIN_DATE            OUT VARCHAR2
,P_QC_END_DATE                OUT VARCHAR2
,P_QC_CHANGE_NOTE            OUT VARCHAR2
,P_QC_SUB_LONG_NAME            OUT VARCHAR2
,P_QC_GROUP_COMMENTS        OUT VARCHAR2
,P_QC_CREATED_BY            OUT VARCHAR2
,P_QC_DATE_CREATED            OUT VARCHAR2
,P_QC_MODIFIED_BY            OUT VARCHAR2
,P_QC_DATE_MODIFIED            OUT VARCHAR2
,P_QC_DELETED_IND            OUT VARCHAR2) IS

qc_rec    quest_contents_view_ext%ROWTYPE;
v_version quest_contents_view_ext.version%TYPE;


BEGIN
  p_return_code := NULL;
  --At least one of the ID or Name parameters has to be provided
  IF P_QC_QC_IDSEQ IS NOT NULL THEN  --Retrieve the Questionnaire Content by key

    BEGIN
         SELECT *
         INTO qc_rec
         FROM quest_contents_view_ext
         WHERE qc_idseq = P_QC_QC_IDSEQ;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_return_code := 'API_QC_005'; --Questionnaire Content not found
            RETURN;
        WHEN OTHERS THEN
             p_return_code := 'API_QC_009'; --Other raised on select from quest_contents_view_ext
             RETURN;
    END;

    /*If P_QC_PREFERRED_NAME is not null and does not match retrieved Preferred Name
       then assign the error code */
    IF(P_QC_PREFERRED_NAME IS NOT NULL AND (P_QC_PREFERRED_NAME <> qc_rec.preferred_name)) THEN
      p_return_code := 'API_QC_002';-- Retrieved Preferred Name Does not Match with parameter
      RETURN;
    END IF;

    /*If the P_QC_CONTE_IDSEQ is not null and does not match the retrieved Context then assign the error code and RETURN*/
    IF(P_QC_CONTE_IDSEQ IS NOT NULL AND (P_QC_CONTE_IDSEQ <> qc_rec.conte_idseq)) THEN
      p_return_code := 'API_QC_003';-- Retrieved Context does not Match with parameter
      RETURN;
    END IF;

    /*If the P_QC_VERSION is not null and does not match the retrieved Version
         then assign the error code and return*/
    IF(P_QC_VERSION IS NOT NULL AND (P_QC_VERSION <> qc_rec.version)) THEN
      p_return_code := 'API_QC_004';-- Retrieved Version Name Does not Match with parameter
      RETURN;
    END IF;

    -- Assign the data retrieved to the parameters
    P_QC_QC_IDSEQ                         := qc_rec.qc_idseq;
    P_QC_PREFERRED_NAME            := qc_rec.preferred_name;
    P_QC_CONTE_IDSEQ            := qc_rec.conte_idseq;
    P_QC_VERSION                := qc_rec.version;
    P_QC_PREFERRED_DEFINITION    := qc_rec.preferred_definition;
    P_QC_LONG_NAME                := qc_rec.long_name;
    P_QC_QTL_NAME                := qc_rec.qtl_name;
    P_QC_ASL_NAME                := qc_rec.asl_name;
    --P_QC_PROTO_IDSEQ            := qc_rec.proto_idseq;
    P_QC_DE_IDSEQ                := qc_rec.de_idseq;
    P_QC_VP_IDSEQ                := qc_rec.vp_idseq;
    P_QC_QC_MATCH_IDSEQ            := qc_rec.qc_match_idseq;
    P_QC_MATCH_IND                := qc_rec.match_ind;
    P_QC_QC_IDENTIFIER            := qc_rec.qc_identifier;
    P_QC_QCDL_NAME                := qc_rec.qcdl_name;
    P_QC_LASTEST_VERSION_IND    := qc_rec.latest_version_ind;
    P_QC_NEW_QC_IND                := qc_rec.new_qc_ind;
    P_QC_REVIEWER_FEEDBACK_EXT    := qc_rec.reviewer_feedback_external;
    P_QC_SYSTEM_MSGS            := qc_rec.system_msgs;
    P_QC_REVIEWER_FEEDBACK_INT  := qc_rec.reviewer_feedback_internal;
    P_QC_REVIEWER_FEEDBACK_ACT    := qc_rec.reviewer_feedback_action;
    P_QC_HIGHLIGHT_IND             := qc_rec.highlight_ind;
    P_QC_SUB_LONG_NAME             := qc_rec.submitted_long_cde_name;
    P_QC_GROUP_COMMENTS            := qc_rec.group_comments;
    P_QC_REVIEWED_BY               := qc_rec.reviewed_by;
    P_QC_REVIEWED_DATE               := qc_rec.reviewed_date;
    P_QC_APPROVED_BY               := qc_rec.approved_by;
    P_QC_APPROVED_DATE               := qc_rec.approved_date;
    P_QC_CDE_DICTIONARY_ID           := qc_rec.cde_dictionary_id;
    P_QC_BEGIN_DATE                   := qc_rec.begin_date;
    P_QC_END_DATE                   := qc_rec.end_date;
    P_QC_CHANGE_NOTE               := qc_rec.change_note;
    P_QC_CREATED_BY                   := qc_rec.created_by;
    P_QC_DATE_CREATED               := qc_rec.date_created;
    P_QC_MODIFIED_BY               := qc_rec.modified_by;
    P_QC_DATE_MODIFIED               := qc_rec.date_modified;
    P_QC_DELETED_IND               := qc_rec.deleted_ind;

    P_QC_PROTO_IDSEQ := sbrext_common_routines.SET_PROTO_ARRAY(p_qc_qc_idseq);

  ELSE  --Key is not provided, retrieve by name, Version and Context
   IF(P_QC_PREFERRED_NAME IS NOT NULL AND P_QC_CONTE_IDSEQ IS NOT NULL) THEN
     IF P_QC_VERSION IS NOT NULL THEN
       v_version := P_QC_VERSION;
     ELSE
       v_version := Sbrext_Common_Routines.get_ac_version(P_QC_PREFERRED_NAME, P_QC_CONTE_IDSEQ,'QUEST_CONTENT');
       IF(v_version = 0) THEN
         p_return_code := 'API_QC_005';--Questionnaire Content not found
         RETURN;
       END IF;
     END IF;

     /*Retrieve the Questionnaire Content row based on Context, Preferred Name and Version number*/
     BEGIN
       SELECT *
       INTO qc_rec
       FROM quest_contents_view_ext
       WHERE preferred_name = P_QC_PREFERRED_NAME
       AND   conte_idseq = P_QC_CONTE_IDSEQ
       AND   version = v_version;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
               p_return_code := 'API_QC_005'; -- Questionnaire Content Not found
            RETURN;
       WHEN OTHERS THEN
               p_return_code := 'API_QC_009'; -- Other raised in select from Quest_content_view_Ext
            RETURN;
     END;

     -- Assign the data retrieved to the parameters
    P_QC_QC_IDSEQ                         := qc_rec.qc_idseq;
    P_QC_PREFERRED_NAME            := qc_rec.preferred_name;
    P_QC_CONTE_IDSEQ            := qc_rec.conte_idseq;
    P_QC_VERSION                := qc_rec.version;
    P_QC_PREFERRED_DEFINITION    := qc_rec.preferred_definition;
    P_QC_LONG_NAME                := qc_rec.long_name;
    P_QC_QTL_NAME                := qc_rec.qtl_name;
    P_QC_ASL_NAME                := qc_rec.asl_name;
    P_QC_PROTO_IDSEQ            := qc_rec.proto_idseq;
    P_QC_DE_IDSEQ                := qc_rec.de_idseq;
    P_QC_VP_IDSEQ                := qc_rec.vp_idseq;
    P_QC_QC_MATCH_IDSEQ         := qc_rec.qc_match_idseq;
    P_QC_MATCH_IND                := qc_rec.match_ind;
    P_QC_QC_IDENTIFIER            := qc_rec.qc_identifier;
    P_QC_QCDL_NAME                := qc_rec.qcdl_name;
    P_QC_LASTEST_VERSION_IND    := qc_rec.latest_version_ind;
    P_QC_NEW_QC_IND                := qc_rec.new_qc_ind;
    P_QC_REVIEWER_FEEDBACK_EXT    := qc_rec.reviewer_feedback_external;
    P_QC_SYSTEM_MSGS            := qc_rec.system_msgs;
    P_QC_REVIEWER_FEEDBACK_INT  := qc_rec.reviewer_feedback_internal;
    P_QC_REVIEWER_FEEDBACK_ACT    := qc_rec.reviewer_feedback_action;
    P_QC_HIGHLIGHT_IND             := qc_rec.highlight_ind;
    P_QC_SUB_LONG_NAME             := qc_rec.submitted_long_cde_name;
    P_QC_GROUP_COMMENTS            := qc_rec.group_comments;
    P_QC_REVIEWED_BY               := qc_rec.reviewed_by;
    P_QC_REVIEWED_DATE               := qc_rec.reviewed_date;
    P_QC_APPROVED_BY               := qc_rec.approved_by;
    P_QC_APPROVED_DATE               := qc_rec.approved_date;
    P_QC_CDE_DICTIONARY_ID           := qc_rec.cde_dictionary_id;
    P_QC_BEGIN_DATE                   := qc_rec.begin_date;
    P_QC_END_DATE                   := qc_rec.end_date;
    P_QC_CHANGE_NOTE               := qc_rec.change_note;
    P_QC_CREATED_BY                   := qc_rec.created_by;
    P_QC_DATE_CREATED               := qc_rec.date_created;
    P_QC_MODIFIED_BY               := qc_rec.modified_by;
    P_QC_DATE_MODIFIED               := qc_rec.date_modified;
    P_QC_DELETED_IND               := qc_rec.deleted_ind;

  ELSE
    P_RETURN_CODE := 'API_QC_001';--PK or Name, Context, and Version must be passed
    RETURN;
  END IF;
END IF;

 EXCEPTION
    WHEN NO_DATA_FOUND THEN
       NULL;
    WHEN OTHERS THEN
       NULL;
END GET_QC;

/******************************************************************************
   NAME:       GET_SOURCE
   PURPOSE:    Retrieves a SOURCE information by name.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_SOURCE(
P_RETURN_CODE
,P_SRC_NAME
,P_SRC_DESCRIPTION
,P_SRC_CREATED_BY
,P_SRC_DATE_CREATED
,P_SRC_MODIFIED_BY
,P_SRC_DATE_MODIFIED    );
******************************************************************************/
PROCEDURE GET_SOURCE(
P_RETURN_CODE                OUT VARCHAR2
,P_SRC_SRC_NAME                IN OUT VARCHAR2
,P_SRC_DESCRIPTION            OUT VARCHAR2
,P_SRC_CREATED_BY            OUT    VARCHAR2
,P_SRC_DATE_CREATED            OUT    VARCHAR2
,P_SRC_MODIFIED_BY            OUT    VARCHAR2
,P_SRC_DATE_MODIFIED        OUT    VARCHAR2) IS

src_rec sources_view_ext%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --The ID must be provided
  IF P_SRC_SRC_NAME IS NOT NULL THEN  --Retrieve the source row by key

    BEGIN
      SELECT *
      INTO src_rec
      FROM sources_view_ext
      WHERE src_name = P_SRC_SRC_NAME;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_SRC_005'; -- sources_view_ext row not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_SRC_009'; -- Other raised on select from sources_view_ext
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_SRC_SRC_NAME           := src_rec.src_name;
    P_SRC_DESCRIPTION  := src_rec.description;
    P_SRC_CREATED_BY   := src_rec.created_by;
    P_SRC_DATE_CREATED := src_rec.date_created;
    P_SRC_MODIFIED_BY     := src_rec.modified_by;
    P_SRC_DATE_MODIFIED := src_rec.date_modified;

  ELSE
    P_RETURN_CODE := 'API_SRC_001';--PK must be provided (name)
    RETURN;
END IF;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;

END GET_SOURCE;

/******************************************************************************
   NAME:       GET_QTL
   PURPOSE:    Retrieves a QC Type by name.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_QTL(
P_RETURN_CODE
,P_QTL_NAME
,P_QTL_DESCRIPTION
,P_QTL_CREATED_BY
,P_QTL_DATE_CREATED
,P_QTL_MODIFIED_BY
,P_QTL_DATE_MODIFIED    );
******************************************************************************/
PROCEDURE GET_QTL(
P_RETURN_CODE                OUT VARCHAR2
,P_QTL_QTL_NAME                IN OUT VARCHAR2
,P_QTL_DESCRIPTION            OUT VARCHAR2
,P_QTL_CREATED_BY            OUT    VARCHAR2
,P_QTL_DATE_CREATED            OUT    VARCHAR2
,P_QTL_MODIFIED_BY            OUT    VARCHAR2
,P_QTL_DATE_MODIFIED        OUT    VARCHAR2) IS

qtl_rec qc_type_lov_view_ext%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --The ID must be provided
  IF P_QTL_QTL_NAME IS NOT NULL THEN  --Retrieve the source row by key

    BEGIN
      SELECT *
      INTO qtl_rec
      FROM qc_type_lov_view_ext
      WHERE qtl_name = P_QTL_QTL_NAME;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_QTL_005'; -- qc_type_lov_view_ext row not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_QTL_009'; -- Other raised on select from qc_type_lov_view_ext
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_QTL_QTL_NAME           := qtl_rec.qtl_name;
    P_QTL_DESCRIPTION  := qtl_rec.description;
    P_QTL_CREATED_BY   := qtl_rec.created_by;
    P_QTL_DATE_CREATED := qtl_rec.date_created;
    P_QTL_MODIFIED_BY     := qtl_rec.modified_by;
    P_QTL_DATE_MODIFIED := qtl_rec.date_modified;

  ELSE
    P_RETURN_CODE := 'API_QTL_001';--PK must be provided (name)
    RETURN;
END IF;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;

END GET_QTL;

/******************************************************************************
   NAME:       GET_TSTL
   PURPOSE:    Retrieves a Text String Type by name.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_TSTL(
P_RETURN_CODE
,P_TSTL_NAME
,P_TSTL_DESCRIPTION
,P_TSTL_CREATED_BY
,P_TSTL_DATE_CREATED
,P_TSTL_MODIFIED_BY
,P_TSTL_DATE_MODIFIED    );
******************************************************************************/
PROCEDURE GET_TSTL(
P_RETURN_CODE                OUT VARCHAR2
,P_TSTL_TSTL_NAME            IN OUT VARCHAR2
,P_TSTL_DESCRIPTION            OUT VARCHAR2
,P_TSTL_CREATED_BY            OUT    VARCHAR2
,P_TSTL_DATE_CREATED        OUT    VARCHAR2
,P_TSTL_MODIFIED_BY            OUT    VARCHAR2
,P_TSTL_DATE_MODIFIED        OUT    VARCHAR2) IS

tstl_rec ts_type_lov_view_ext%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --The ID must be provided
  IF P_TSTL_TSTL_NAME IS NOT NULL THEN  --Retrieve the source row by key

    BEGIN
      SELECT *
      INTO tstl_rec
      FROM ts_type_lov_view_ext
      WHERE tstl_name = P_TSTL_TSTL_NAME;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_TSTL_005'; -- ts_type_lov_view_ext row not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_TSTL_009'; -- Other raised on select from ts_type_lov_view_ext
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_TSTL_TSTL_NAME           := tstl_rec.tstl_name;
    P_TSTL_DESCRIPTION  := tstl_rec.description;
    P_TSTL_CREATED_BY   := tstl_rec.created_by;
    P_TSTL_DATE_CREATED := tstl_rec.date_created;
    P_TSTL_MODIFIED_BY     := tstl_rec.modified_by;
    P_TSTL_DATE_MODIFIED := tstl_rec.date_modified;

  ELSE
    P_RETURN_CODE := 'API_TSTL_001';--PK must be provided (name)
    RETURN;
END IF;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;

END GET_TSTL;

/******************************************************************************
   NAME:       GET_TS
   PURPOSE:    Retrieves a Text String based on ID.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_TS(
P_RETURN_CODE
,P_TS_TS_IDSEQ
,P_TS_QC_IDSEQ
,P_TS_TSTL_NAME
,P_TS_TS_TEXT
,P_TS_TS_SEQ
,P_TS_CREATED_BY
,P_TS_DATE_CREATED
,P_TS_MODIFIED_BY
,P_TS_DATE_MODIFIED);
******************************************************************************/
PROCEDURE GET_TS(
P_RETURN_CODE                OUT VARCHAR2
,P_TS_TS_IDSEQ                IN OUT VARCHAR2
,P_TS_QC_IDSEQ                OUT VARCHAR2
,P_TS_TSTL_NAME                OUT VARCHAR2
,P_TS_TS_TEXT                OUT VARCHAR2
,P_TS_TS_SEQ                OUT NUMBER
,P_TS_CREATED_BY            OUT    VARCHAR2
,P_TS_DATE_CREATED        OUT    VARCHAR2
,P_TS_MODIFIED_BY            OUT    VARCHAR2
,P_TS_DATE_MODIFIED        OUT    VARCHAR2) IS

ts_rec text_strings_view_ext%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --The ID must be provided
  IF p_ts_ts_idseq IS NOT NULL THEN  --Retrieve the source row by key

    BEGIN
      SELECT *
      INTO ts_rec
      FROM text_strings_view_ext
      WHERE ts_idseq = p_ts_ts_idseq;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_TS_005'; -- text_strings_view_ext row not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_TS_009'; -- Other raised on select from text_strings_view_ext
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_TS_TS_IDSEQ         := ts_rec.ts_idseq;
    P_TS_QC_IDSEQ          := ts_rec.qc_idseq;
    P_TS_TSTL_NAME          := ts_rec.tstl_name;
    P_TS_TS_TEXT          := ts_rec.ts_text;
    P_TS_TS_SEQ          := ts_rec.ts_seq;
    P_TS_CREATED_BY        := ts_rec.created_by;
    P_TS_DATE_CREATED      := ts_rec.date_created;
    P_TS_MODIFIED_BY     := ts_rec.modified_by;
    P_TS_DATE_MODIFIED      := ts_rec.date_modified;

  ELSE
    P_RETURN_CODE := 'API_TS_001';--PK must be provided (name)
    RETURN;
END IF;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;

END GET_TS;

/******************************************************************************
   NAME:       GET_AC_SRC
   PURPOSE:    Retrieves the Source, Administered Component relationship based on ID
                  or Administered Component ID and Source Name.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_AC_SRC(
P_RETURN_CODE
,P_ACSRC_AC_SRC_IDSEQ
,P_ACSRC_AC_IDSEQ
,P_ACSRC_SRC_NAME
,P_ACSRC_DATE_SUBMITTED
,P_ACSRC_CREATED_BY
,P_ACSRC_DATE_CREATED
,P_ACSRC_MODIFIED_BY
,P_ACSRC_DATE_MODIFIED       );
******************************************************************************/
PROCEDURE GET_AC_SRC(
P_RETURN_CODE              OUT VARCHAR2
,P_ACSRC_ACS_IDSEQ    IN OUT VARCHAR2
,P_ACSRC_AC_IDSEQ        IN OUT VARCHAR2
,P_ACSRC_SRC_NAME        IN OUT VARCHAR2
,P_ACSRC_DATE_SUBMITTED       OUT VARCHAR2
,P_ACSRC_CREATED_BY           OUT VARCHAR2
,P_ACSRC_DATE_CREATED       OUT VARCHAR2
,P_ACSRC_MODIFIED_BY       OUT VARCHAR2
,P_ACSRC_DATE_MODIFIED       OUT VARCHAR2) IS

acsrc_rec    ac_sources_view_ext%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --At least one of the ID or Name parameters has to be provided
  IF P_ACSRC_ACS_IDSEQ IS NOT NULL THEN  --Retrieve the Source, AC relationship by key

    BEGIN
         SELECT *
         INTO acsrc_rec
         FROM ac_sources_view_ext
         WHERE acs_idseq = P_ACSRC_ACS_IDSEQ;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_return_code := 'API_ACSRC_005'; --Source, AC relationship not found
            RETURN;
        WHEN OTHERS THEN
             p_return_code := 'API_ACSRC_009'; --Other raised on select from ac_sources_view_ext
             RETURN;
    END;

    /*If P_ACSRC_AC_IDSEQ is not null and does not match retrieved id
       then assign the error code */
    IF(P_ACSRC_AC_IDSEQ IS NOT NULL AND (P_ACSRC_AC_IDSEQ <> acsrc_rec.ac_idseq)) THEN
      p_return_code := 'API_ACSRC_002';-- Retrieved AC ID Does not Match with parameter
      RETURN;
    END IF;

    /*If the P_ACSRC_SRC_NAME is not null and does not match the retrieved source then assign the error code and RETURN*/
    IF(P_ACSRC_SRC_NAME IS NOT NULL AND (P_ACSRC_SRC_NAME <> acsrc_rec.src_name)) THEN
      p_return_code := 'API_QC_003';-- Retrieved Context does not Match with parameter
      RETURN;
    END IF;

    -- Assign the data retrieved to the parameters
    P_ACSRC_ACS_IDSEQ    := acsrc_rec.acs_idseq;
    P_ACSRC_AC_IDSEQ        := acsrc_rec.ac_idseq;
    P_ACSRC_SRC_NAME        := acsrc_rec.src_name;
    P_ACSRC_DATE_SUBMITTED    := acsrc_rec.date_submitted;
    P_ACSRC_CREATED_BY        := acsrc_rec.created_by;
    P_ACSRC_DATE_CREATED    := acsrc_rec.date_created;
    P_ACSRC_MODIFIED_BY           := acsrc_rec.modified_by;
    P_ACSRC_DATE_MODIFIED    := acsrc_rec.date_modified;

        --Key is not provided, retrieve by Source and AC ID
  ELSIF (P_ACSRC_AC_IDSEQ IS NULL OR P_ACSRC_SRC_NAME IS NULL ) THEN
     p_return_code := 'API_ACSRC_001'; --PK and Source and AC ID and source must be provided
     RETURN;
  ELSE
     /*Retrieve the relationship by Source and AC ID*/
     BEGIN
       SELECT *
       INTO acsrc_rec
       FROM ac_sources_view_ext
       WHERE ac_idseq = P_ACSRC_AC_IDSEQ
       AND   src_name = P_ACSRC_SRC_NAME;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
               p_return_code := 'API_ACSRC_005'; -- Source, AC relationship Not found
            RETURN;
       WHEN OTHERS THEN
               p_return_code := 'API_ACSRC_009'; -- Other raised in select from ac_sources_view_ext
            RETURN;
     END;

    -- Assign the data retrieved to the parameters
    P_ACSRC_ACS_IDSEQ    := acsrc_rec.acs_idseq;
    P_ACSRC_AC_IDSEQ        := acsrc_rec.ac_idseq;
    P_ACSRC_SRC_NAME        := acsrc_rec.src_name;
    P_ACSRC_DATE_SUBMITTED    := acsrc_rec.date_submitted;
    P_ACSRC_CREATED_BY        := acsrc_rec.created_by;
    P_ACSRC_DATE_CREATED    := acsrc_rec.date_created;
    P_ACSRC_MODIFIED_BY           := acsrc_rec.modified_by;
    P_ACSRC_DATE_MODIFIED    := acsrc_rec.date_modified;

  END IF;
--END IF;

 EXCEPTION
    WHEN NO_DATA_FOUND THEN
       NULL;
    WHEN OTHERS THEN
       NULL;
END GET_AC_SRC;


PROCEDURE GET_REL(
P_RETURN_CODE                OUT VARCHAR2
,P_REL_TABLE                IN VARCHAR2
,P_REL_REL_IDSEQ        IN OUT VARCHAR2
,P_REL_P_IDSEQ                IN OUT VARCHAR2
,P_REL_C_IDSEQ                IN OUT VARCHAR2
,P_REL_RL_NAME            IN OUT VARCHAR2
,P_REL_DISPLAY_ORDER           OUT NUMBER
,P_REL_CREATED_BY            OUT    VARCHAR2
,P_REL_DATE_CREATED            OUT    VARCHAR2
,P_REL_MODIFIED_BY            OUT    VARCHAR2
,P_REL_DATE_MODIFIED            OUT    VARCHAR2)    IS

v_rel_de_rec   de_recs_view%ROWTYPE;
v_rel_dec_rec  dec_recs_view%ROWTYPE;
v_rel_vd_rec   vd_recs_view%ROWTYPE;
v_rel_vdpv_rec vd_pv_recs_view%ROWTYPE;
v_rel_cs_rec   cs_recs_view%ROWTYPE;
v_rel_csi_rec  csi_recs_view%ROWTYPE;
v_rel_qce_rec  qc_recs_view_ext%ROWTYPE;

BEGIN
 p_return_code := NULL;
 --Table name must be supplied
 IF P_REL_TABLE IS NULL THEN
    p_return_code := 'API_REL_007'; --table name must be passed
    RETURN;
 END IF;

 --Table name must be valid
 IF P_REL_TABLE NOT IN ('DE_RECS', 'DEC_RECS', 'VD_RECS', 'CS_RECS','CSI_RECS', 'QC_RECS_EXT') THEN
    p_return_code := 'API_REL_001'; --table name must be valid
    RETURN;
 END IF;

  IF P_REL_TABLE = 'DE_RECS' THEN

   IF P_REL_REL_IDSEQ IS NOT NULL THEN

     BEGIN
        SELECT *
    INTO v_rel_de_rec
        FROM de_recs_view
        WHERE de_rec_idseq = P_REL_REL_IDSEQ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
      p_return_code := 'API_REL_DE_005'; --relationship not found
      RETURN;
        WHEN OTHERS THEN
      p_return_code := 'API_REL_DE_009'; --other raised on select
        RETURN;
      END;

      /*If P_REL_P_IDSEQ not null and does not match the retrieved ID, then assign the error code */
      IF (P_REL_P_IDSEQ IS NOT NULL AND (P_REL_P_IDSEQ <> v_rel_de_rec.P_DE_IDSEQ)) THEN
        p_return_code := 'API_REL_DE_002';  --Retrieved Parent Id does not match parameter
       RETURN;
      END IF;

      /*If the P_REL_C_IDSEQ is not null and does not match the ID, assign the error code */
      IF(P_REL_C_IDSEQ IS NOT NULL AND (P_REL_C_IDSEQ <> v_rel_de_rec.c_de_idseq)) THEN
         p_return_code := 'API_REL_DE_003';-- Retrieved child Id does not match parameter
      RETURN;
      END IF;

      /*If the P_REL_RL_NAME is not null and does not match the Name, assign the error code and return*/
      IF(P_REL_RL_NAME IS NOT NULL AND (P_REL_RL_NAME <> v_rel_de_rec.rl_name)) THEN
        p_return_code := 'API_REL_DE_004';-- Retrieved name does not match with parameter
        RETURN;
      END IF;
    ELSE
      IF (P_REL_P_IDSEQ IS NULL OR P_REL_C_IDSEQ IS NULL OR P_REL_RL_NAME IS NULL  ) THEN
        p_return_code := 'API_REL_DE_006'; --PK or complete UK must be passed
        RETURN;
      END IF;

      BEGIN
        SELECT *
    INTO v_rel_de_rec
        FROM de_recs_view
        WHERE P_DE_IDSEQ = P_REL_P_IDSEQ
    AND c_de_idseq = P_REL_C_IDSEQ
      AND rl_name = P_REL_RL_NAME;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
      p_return_code := 'API_REL_DE_005'; --relationship not found
      RETURN;
        WHEN OTHERS THEN
      p_return_code := 'API_REL_DE_009'; --other raised on select
        RETURN;
      END;
    END IF;

    P_REL_REL_IDSEQ    := v_rel_de_rec.de_rec_idseq;
    P_REL_P_IDSEQ    := v_rel_de_rec.P_DE_IDSEQ;
    P_REL_C_IDSEQ         := v_rel_de_rec.c_de_idseq;
    P_REL_RL_NAME    := v_rel_de_rec.rl_name;
    P_REL_CREATED_BY        := v_rel_de_rec.created_by;
    P_REL_DATE_CREATED        := v_rel_de_rec.date_created;
    P_REL_MODIFIED_BY        := v_rel_de_rec.modified_by;
    P_REL_DATE_MODIFIED        := v_rel_de_rec.date_modified;

  ELSIF P_REL_TABLE = 'DEC_RECS' THEN

    IF P_REL_REL_IDSEQ IS NOT NULL THEN

     BEGIN
        SELECT *
    INTO v_rel_dec_rec
        FROM dec_recs_view
        WHERE dec_rec_idseq = P_REL_REL_IDSEQ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
      p_return_code := 'API_REL_DEC_005'; --relationship not found
      RETURN;
        WHEN OTHERS THEN
      p_return_code := 'API_REL_DEC_009'; --other raised on select
        RETURN;
      END;

      /*If P_REL_P_IDSEQ not null and does not match the retrieved ID, then assign the error code */
      IF (P_REL_P_IDSEQ IS NOT NULL AND (P_REL_P_IDSEQ <> v_rel_dec_rec.P_DEC_IDSEQ)) THEN
        p_return_code := 'API_REL_DEC_002';  --Retrieved Parent Id does not match parameter
       RETURN;
      END IF;

      /*If the P_REL_C_IDSEQ is not null and does not match the ID, assign the error code */
      IF(P_REL_C_IDSEQ IS NOT NULL AND (P_REL_C_IDSEQ <> v_rel_dec_rec.c_dec_idseq)) THEN
         p_return_code := 'API_REL_DEC_003';-- Retrieved child Id does not match parameter
      RETURN;
      END IF;

      /*If the P_REL_RL_NAME is not null and does not match the Name, assign the error code and return*/
      IF(P_REL_RL_NAME IS NOT NULL AND (P_REL_RL_NAME <> v_rel_dec_rec.rl_name)) THEN
        p_return_code := 'API_REL_DEC_004';-- Retrieved name does not match with parameter
        RETURN;
      END IF;
    ELSE
      IF (P_REL_P_IDSEQ IS NULL OR P_REL_C_IDSEQ IS NULL OR P_REL_RL_NAME IS NULL) THEN
        p_return_code := 'API_REL_DEC_006'; --PK or complete UK must be passed
        RETURN;
      END IF;

      BEGIN
        SELECT *
    INTO v_rel_dec_rec
        FROM dec_recs_view
        WHERE P_DEC_IDSEQ = P_REL_P_IDSEQ
    AND c_dec_idseq = P_REL_C_IDSEQ
      AND rl_name = P_REL_RL_NAME;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
      p_return_code := 'API_REL_DEC_005'; --relationship not found
      RETURN;
        WHEN OTHERS THEN
      p_return_code := 'API_REL_DEC_009'; --other raised on select
        RETURN;
      END;
    END IF;

    P_REL_REL_IDSEQ    := v_rel_dec_rec.dec_rec_idseq;
    P_REL_P_IDSEQ    := v_rel_dec_rec.P_DEC_IDSEQ;
    P_REL_C_IDSEQ         := v_rel_dec_rec.c_dec_idseq;
    P_REL_RL_NAME    := v_rel_dec_rec.rl_name;
    P_REL_CREATED_BY        := v_rel_dec_rec.created_by;
    P_REL_DATE_CREATED        := v_rel_dec_rec.date_created;
    P_REL_MODIFIED_BY        := v_rel_dec_rec.modified_by;
    P_REL_DATE_MODIFIED        := v_rel_dec_rec.date_modified;

  ELSIF P_REL_TABLE = 'VD_RECS' THEN
    IF P_REL_REL_IDSEQ IS NOT NULL THEN

     BEGIN
        SELECT *
    INTO v_rel_vd_rec
        FROM vd_recs_view
        WHERE vd_rec_idseq = P_REL_REL_IDSEQ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
      p_return_code := 'API_REL_VD_005'; --relationship not found
      RETURN;
        WHEN OTHERS THEN
      p_return_code := 'API_REL_VD_009'; --other raised on select
        RETURN;
      END;

      /*If P_REL_P_IDSEQ not null and does not match the retrieved ID, then assign the error code */
      IF (P_REL_P_IDSEQ IS NOT NULL AND (P_REL_P_IDSEQ <> v_rel_vd_rec.p_vd_idseq)) THEN
        p_return_code := 'API_REL_VD_002';  --Retrieved Parent Id does not match parameter
       RETURN;
      END IF;

      /*If the P_REL_C_IDSEQ is not null and does not match the ID, assign the error code */
      IF(P_REL_C_IDSEQ IS NOT NULL AND (P_REL_C_IDSEQ <> v_rel_vd_rec.c_vd_idseq)) THEN
         p_return_code := 'API_REL_VD_003';-- Retrieved child Id does not match parameter
      RETURN;
      END IF;

      /*If the P_REL_RL_NAME is not null and does not match the Name, assign the error code and return*/
      IF(P_REL_RL_NAME IS NOT NULL AND (P_REL_RL_NAME <> v_rel_vd_rec.rl_name)) THEN
        p_return_code := 'API_REL_VD_004';-- Retrieved name does not match with parameter
        RETURN;
      END IF;
    ELSE
       IF (P_REL_P_IDSEQ IS NULL OR P_REL_C_IDSEQ IS NULL OR P_REL_RL_NAME IS NULL) THEN
        p_return_code := 'API_REL_VD_006'; --PK or complete UK must be passed
        RETURN;
      END IF;

      BEGIN
        SELECT *
    INTO v_rel_vd_rec
        FROM vd_recs_view
        WHERE p_vd_idseq = P_REL_P_IDSEQ
    AND c_vd_idseq = P_REL_C_IDSEQ
      AND rl_name = P_REL_RL_NAME;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
      p_return_code := 'API_REL_VD_005'; --relationship not found
      RETURN;
        WHEN OTHERS THEN
      p_return_code := 'API_REL_VD_009'; --other raised on select
        RETURN;
      END;
    END IF;

    P_REL_REL_IDSEQ    := v_rel_vd_rec.vd_rec_idseq;
    P_REL_P_IDSEQ    := v_rel_vd_rec.p_vd_idseq;
    P_REL_C_IDSEQ         := v_rel_vd_rec.c_vd_idseq;
    P_REL_RL_NAME    := v_rel_vd_rec.rl_name;
    P_REL_CREATED_BY        := v_rel_vd_rec.created_by;
    P_REL_DATE_CREATED        := v_rel_vd_rec.date_created;
    P_REL_MODIFIED_BY        := v_rel_vd_rec.modified_by;
    P_REL_DATE_MODIFIED        := v_rel_vd_rec.date_modified;


  ELSIF P_REL_TABLE = 'CS_RECS' THEN
    IF P_REL_REL_IDSEQ IS NOT NULL THEN

     BEGIN
        SELECT *
    INTO v_rel_cs_rec
        FROM cs_recs_view
        WHERE cs_rec_idseq = P_REL_REL_IDSEQ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
      p_return_code := 'API_REL_CS_005'; --relationship not found
      RETURN;
        WHEN OTHERS THEN
      p_return_code := 'API_REL_CS_009'; --other raised on select
        RETURN;
      END;

      /*If P_REL_P_IDSEQ not null and does not match the retrieved ID, then assign the error code */
      IF (P_REL_P_IDSEQ IS NOT NULL AND (P_REL_P_IDSEQ <> v_rel_cs_rec.P_CS_IDSEQ)) THEN
        p_return_code := 'API_REL_CS_002';  --Retrieved Parent Id does not match parameter
       RETURN;
      END IF;

      /*If the P_REL_C_IDSEQ is not null and does not match the ID, assign the error code */
      IF(P_REL_C_IDSEQ IS NOT NULL AND (P_REL_C_IDSEQ <> v_rel_cs_rec.c_cs_idseq)) THEN
         p_return_code := 'API_REL_CS_003';-- Retrieved child Id does not match parameter
      RETURN;
      END IF;

      /*If the P_REL_RL_NAME is not null and does not match the Name, assign the error code and return*/
      IF(P_REL_RL_NAME IS NOT NULL AND (P_REL_RL_NAME <> v_rel_cs_rec.rl_name)) THEN
        p_return_code := 'API_REL_CS_004';-- Retrieved name does not match with parameter
        RETURN;
      END IF;
    ELSE
      IF (P_REL_P_IDSEQ IS NULL OR P_REL_C_IDSEQ IS NULL OR P_REL_RL_NAME IS NULL) THEN
        p_return_code := 'API_REL_CS_006'; --PK or complete UK must be passed
        RETURN;
      END IF;


      BEGIN
        SELECT *
    INTO v_rel_cs_rec
        FROM cs_recs_view
        WHERE P_CS_IDSEQ = P_REL_P_IDSEQ
    AND c_cs_idseq = P_REL_C_IDSEQ
      AND rl_name = P_REL_RL_NAME;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
      p_return_code := 'API_REL_CS_005'; --relationship not found
      RETURN;
        WHEN OTHERS THEN
      p_return_code := 'API_REL_CS_009'; --other raised on select
        RETURN;
      END;
    END IF;

    P_REL_REL_IDSEQ    := v_rel_cs_rec.cs_rec_idseq;
    P_REL_P_IDSEQ    := v_rel_cs_rec.p_cs_idseq;
    P_REL_C_IDSEQ         := v_rel_cs_rec.c_cs_idseq;
    P_REL_RL_NAME    := v_rel_cs_rec.rl_name;
    P_REL_CREATED_BY        := v_rel_cs_rec.created_by;
    P_REL_DATE_CREATED        := v_rel_cs_rec.date_created;
    P_REL_MODIFIED_BY        := v_rel_cs_rec.modified_by;
    P_REL_DATE_MODIFIED        := v_rel_cs_rec.date_modified;

  ELSIF P_REL_TABLE = 'CSI_RECS' THEN
    IF P_REL_REL_IDSEQ IS NOT NULL THEN

     BEGIN
        SELECT *
    INTO v_rel_csi_rec
        FROM csi_recs_view
        WHERE csi_rec_idseq = P_REL_REL_IDSEQ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
      p_return_code := 'API_REL_CSI_005'; --relationship not found
      RETURN;
        WHEN OTHERS THEN
      p_return_code := 'API_REL_CSI_009'; --other raised on select
        RETURN;
      END;

      /*If P_REL_P_IDSEQ not null and does not match the retrieved ID, then assign the error code */
      IF (P_REL_P_IDSEQ IS NOT NULL AND (P_REL_P_IDSEQ <> v_rel_csi_rec.p_csi_idseq)) THEN
        p_return_code := 'API_REL_CSI_002';  --Retrieved Parent Id does not match parameter
       RETURN;
      END IF;

      /*If the P_REL_C_IDSEQ is not null and does not match the ID, assign the error code */
      IF(P_REL_C_IDSEQ IS NOT NULL AND (P_REL_C_IDSEQ <> v_rel_csi_rec.c_csi_idseq)) THEN
         p_return_code := 'API_REL_CSI_003';-- Retrieved child Id does not match parameter
      RETURN;
      END IF;

      /*If the P_REL_RL_NAME is not null and does not match the Name, assign the error code and return*/
      IF(P_REL_RL_NAME IS NOT NULL AND (P_REL_RL_NAME <> v_rel_csi_rec.rl_name)) THEN
        p_return_code := 'API_REL_CSI_004';-- Retrieved name does not match with parameter
        RETURN;
      END IF;
    ELSE
       IF (P_REL_P_IDSEQ IS NULL OR P_REL_C_IDSEQ IS NULL OR P_REL_RL_NAME IS NULL) THEN
        p_return_code := 'API_REL_CSI_006'; --PK or complete UK must be passed
        RETURN;
      END IF;


      BEGIN
        SELECT *
    INTO v_rel_csi_rec
        FROM csi_recs_view
        WHERE p_csi_idseq = P_REL_P_IDSEQ
    AND c_csi_idseq = P_REL_C_IDSEQ
      AND rl_name = P_REL_RL_NAME;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
      p_return_code := 'API_REL_CSI_005'; --relationship not found
      RETURN;
        WHEN OTHERS THEN
      p_return_code := 'API_REL_CSI_009'; --other raised on select
        RETURN;
      END;
    END IF;

    P_REL_REL_IDSEQ    := v_rel_csi_rec.csi_rec_idseq;
    P_REL_P_IDSEQ    := v_rel_csi_rec.p_csi_idseq;
    P_REL_C_IDSEQ         := v_rel_csi_rec.c_csi_idseq;
    P_REL_RL_NAME    := v_rel_csi_rec.rl_name;
    P_REL_CREATED_BY        := v_rel_csi_rec.created_by;
    P_REL_DATE_CREATED        := v_rel_csi_rec.date_created;
    P_REL_MODIFIED_BY        := v_rel_csi_rec.modified_by;
    P_REL_DATE_MODIFIED        := v_rel_csi_rec.date_modified;

  ELSIF P_REL_TABLE = 'qc_recs_view_ext' THEN
    IF P_REL_REL_IDSEQ IS NOT NULL THEN

     BEGIN
        SELECT *
    INTO v_rel_qce_rec
        FROM qc_recs_view_ext
        WHERE qr_idseq = P_REL_REL_IDSEQ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
      p_return_code := 'API_REL_QCE_005'; --relationship not found
      RETURN;
        WHEN OTHERS THEN
      p_return_code := 'API_REL_QCE_009'; --other raised on select
        RETURN;
      END;

      /*If P_REL_P_IDSEQ not null and does not match the retrieved ID, then assign the error code */
      IF (P_REL_P_IDSEQ IS NOT NULL AND (P_REL_P_IDSEQ <> v_rel_qce_rec.P_QC_IDSEQ)) THEN
        p_return_code := 'API_REL_QCE_002';  --Retrieved Parent Id does not match parameter
       RETURN;
      END IF;

      /*If the P_REL_C_IDSEQ is not null and does not match the ID, assign the error code */
      IF(P_REL_C_IDSEQ IS NOT NULL AND (P_REL_C_IDSEQ <> v_rel_qce_rec.c_qc_idseq)) THEN
         p_return_code := 'API_REL_QCE_003';-- Retrieved child Id does not match parameter
      RETURN;
      END IF;

      /*If the P_REL_RL_NAME is not null and does not match the Name, assign the error code and return*/
      IF(P_REL_RL_NAME IS NOT NULL AND (P_REL_RL_NAME <> v_rel_qce_rec.rl_name)) THEN
        p_return_code := 'API_REL_QCE_004';-- Retrieved name does not match with parameter
        RETURN;
      END IF;
    ELSE
       IF (P_REL_P_IDSEQ IS NULL OR P_REL_C_IDSEQ IS NULL OR P_REL_RL_NAME IS NULL)THEN
        p_return_code := 'API_REL_QCE_006'; --PK or complete UK must be passed
        RETURN;
      END IF;

      BEGIN
        SELECT *
    INTO v_rel_qce_rec
        FROM qc_recs_view_ext
        WHERE P_QC_IDSEQ = P_REL_P_IDSEQ
    AND c_qc_idseq = P_REL_C_IDSEQ
      AND rl_name = P_REL_RL_NAME;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
      p_return_code := 'API_REL_QCE_005'; --relationship not found
      RETURN;
        WHEN OTHERS THEN
      p_return_code := 'API_REL_QCE_009'; --other raised on select
        RETURN;
      END;
    END IF;

    P_REL_REL_IDSEQ    := v_rel_qce_rec.qr_idseq;
    P_REL_P_IDSEQ    := v_rel_qce_rec.P_QC_IDSEQ;
    P_REL_C_IDSEQ         := v_rel_qce_rec.c_qc_idseq;
    P_REL_RL_NAME    := v_rel_qce_rec.rl_name;
    P_REL_DISPLAY_ORDER := v_rel_qce_rec.display_order;
    P_REL_CREATED_BY        := v_rel_qce_rec.created_by;
    P_REL_DATE_CREATED        := v_rel_qce_rec.date_created;
    P_REL_MODIFIED_BY        := v_rel_qce_rec.modified_by;
    P_REL_DATE_MODIFIED        := v_rel_qce_rec.date_modified;

  END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
       NULL;
   WHEN OTHERS THEN
       NULL;
END GET_REL;


/******************************************************************************
   NAME:       GET_PROTOCOL
   PURPOSE:    Retrieves a Protocol by ID

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/24/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_PROTOCOL(
P_RETURN_CODE                 Out Varchar2
, P_PROTO_IDSEQ                In OUT VARCHAR2
, P_PROTO_PREFERRED_NAME        In Out Varchar2
, P_PROTO_CONTE_IDSEQ              In OUT VARCHAR2
, P_PROTO_VERSION            In Out Number
, P_PROTO_PREFERRED_DEFINITION           Out Varchar2
, P_PROTO_LONG_NAME            Out Varchar2
, P_PROTO_ASL_NAME            Out Varchar2
, P_PROTO_LASTEST_VERSION_IND           Out Varchar2
, P_PROTO_PROTOCOL_ID            Out Varchar2
, P_PROTO_PHASE                 Out Varchar2
, P_PROTO_LEAD_ORG            Out Varchar2
, P_PROTO_CHANGE_TYPE            Out Varchar2
, P_PROTO_CHANGE_NUMBER            Out Number
, P_PROTO_REVIEWED_BY            Out Varchar2
, P_PROTO_REVIEWED_DATE            Out Varchar2
, P_PROTO_APPROVED_BY            Out Varchar2
, P_PROTO_APPROVED_DATE            Out Varchar2
, P_PROTO_BEGIN_DATE            Out Varchar2
, P_PROTO_END_DATE            Out Varchar2
, P_PROTO_CHANGE_NOTE            Out Varchar2
, P_PROTO_CREATED_BY            Out Varchar2
, P_PROTO_DATE_CREATED            Out Varchar2
, P_PROTO_MODIFIED_BY            Out Varchar2
, P_PROTO_DATE_MODIFIED            Out Varchar2
, P_PROTO_DELETED_IND            Out Varchar2);
******************************************************************************/
PROCEDURE GET_PROTOCOL(
P_RETURN_CODE                     OUT VARCHAR2
, P_PROTO_PROTO_IDSEQ            IN OUT VARCHAR2
, P_PROTO_PREFERRED_NAME        IN OUT VARCHAR2
, P_PROTO_CONTE_IDSEQ              IN OUT VARCHAR2
, P_PROTO_VERSION                IN OUT NUMBER
, P_PROTO_PREFERRED_DEFINITION    OUT VARCHAR2
, P_PROTO_LONG_NAME                OUT VARCHAR2
, P_PROTO_ASL_NAME                OUT VARCHAR2
, P_PROTO_LATEST_VERSION_IND    OUT VARCHAR2
, P_PROTO_PROTOCOL_ID            OUT VARCHAR2
, P_PROTO_TYPE                    OUT VARCHAR2
, P_PROTO_PHASE                     OUT VARCHAR2
, P_PROTO_LEAD_ORG                OUT VARCHAR2
, P_PROTO_CHANGE_TYPE            OUT VARCHAR2
, P_PROTO_CHANGE_NUMBER            OUT NUMBER
, P_PROTO_REVIEWED_BY            OUT VARCHAR2
, P_PROTO_REVIEWED_DATE            OUT VARCHAR2
, P_PROTO_APPROVED_BY            OUT VARCHAR2
, P_PROTO_APPROVED_DATE            OUT VARCHAR2
, P_PROTO_BEGIN_DATE            OUT VARCHAR2
, P_PROTO_END_DATE                OUT VARCHAR2
, P_PROTO_CHANGE_NOTE            OUT VARCHAR2
, P_PROTO_CREATED_BY            OUT VARCHAR2
, P_PROTO_DATE_CREATED            OUT VARCHAR2
, P_PROTO_MODIFIED_BY            OUT VARCHAR2
, P_PROTO_DATE_MODIFIED            OUT VARCHAR2
, P_PROTO_DELETED_IND            OUT VARCHAR2) IS

proto_rec protocols_view_ext%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --The ID must be provided
  IF P_PROTO_PROTO_IDSEQ IS NOT NULL THEN  --Retrieve the source row by key

    BEGIN
      SELECT *
      INTO proto_rec
      FROM protocols_view_ext
      WHERE proto_idseq = P_PROTO_PROTO_IDSEQ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_return_code := 'API_PROTO_005'; -- protocols_view_ext row not found
        RETURN;
      WHEN OTHERS THEN
        p_return_code := 'API_PROTO_009'; -- Other raised on select from protocols_view_ext
        RETURN;
    END;

    -- Assign the data retrieved to the parameters
    P_PROTO_PROTO_IDSEQ                := proto_rec.proto_idseq;
    P_PROTO_VERSION             := proto_rec.version;
    P_PROTO_PREFERRED_NAME    := proto_rec.preferred_name;
    P_PROTO_CONTE_IDSEQ        := proto_rec.conte_idseq;
    P_PROTO_PREFERRED_DEFINITION  := proto_rec.preferred_definition;
    P_PROTO_ASL_NAME               := proto_rec.asl_name;
    P_PROTO_LONG_NAME               := proto_rec.long_name;
    P_PROTO_LATEST_VERSION_IND       := proto_rec.latest_version_ind;
    P_PROTO_DELETED_IND           := proto_rec.deleted_ind;
    P_PROTO_BEGIN_DATE               := proto_rec.begin_date;
    P_PROTO_END_DATE               := proto_rec.end_date;
    P_PROTO_PROTOCOL_ID           := proto_rec.protocol_id;
    P_PROTO_TYPE                   := proto_rec.TYPE;
    P_PROTO_PHASE                   := proto_rec.phase;
    P_PROTO_LEAD_ORG               := proto_rec.lead_org;
    P_PROTO_CHANGE_TYPE           := proto_rec.change_type;
    P_PROTO_CHANGE_NUMBER           := proto_rec.change_number;
    P_PROTO_REVIEWED_DATE           := proto_rec.reviewed_date;
    P_PROTO_REVIEWED_BY           := proto_rec.reviewed_by;
    P_PROTO_APPROVED_DATE           := proto_rec.approved_date;
    P_PROTO_APPROVED_BY           := proto_rec.approved_by;
    P_PROTO_CREATED_BY               := proto_rec.created_by;
    P_PROTO_DATE_CREATED              := proto_rec.date_created;
    P_PROTO_MODIFIED_BY            := proto_rec.modified_by;
    P_PROTO_DATE_MODIFIED              := proto_rec.date_modified;
    P_PROTO_CHANGE_NOTE           := proto_rec.change_note;

  ELSE
    P_RETURN_CODE := 'API_PROTO_001';--PK must be provided (name)
    RETURN;
END IF;

 EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;

END GET_PROTOCOL;



/******************************************************************************
   NAME:       GET_VP_SRC
   PURPOSE:    Retrieves the Value Domain/Permissible Value relationship based on ID
                  or Value Domain ID and Source Name.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/2/2001  Lisa Schick     1. Created this procedure


   EXAMPLE USE:    GET_ROW.GET_VP_SRC(
P_RETURN_CODE              Out Varchar2
,P_VPSRC_VPS_IDSEQ    In OUT VARCHAR2
,P_VPSRC_VP_IDSEQ        In OUT VARCHAR2
,P_VPSRC_SRC_NAME        In Out Varchar2
,P_VPSRC_DATE_SUBMITTED       Out Varchar2
,P_VPSRC_CREATED_BY           Out Varchar2
,P_VPSRC_DATE_CREATED       Out Varchar2
,P_VPSRC_MODIFIED_BY       Out Varchar2
,P_VPSRC_DATE_MODIFIED       Out Varchar2)
******************************************************************************/
PROCEDURE GET_VP_SRC(
P_RETURN_CODE              OUT VARCHAR2
,P_VPSRC_VPS_IDSEQ    IN OUT VARCHAR2
,P_VPSRC_VP_IDSEQ        IN OUT VARCHAR2
,P_VPSRC_SRC_NAME        IN OUT VARCHAR2
,P_VPSRC_DATE_SUBMITTED       OUT VARCHAR2
,P_VPSRC_CREATED_BY           OUT VARCHAR2
,P_VPSRC_DATE_CREATED       OUT VARCHAR2
,P_VPSRC_MODIFIED_BY       OUT VARCHAR2
,P_VPSRC_DATE_MODIFIED       OUT VARCHAR2) IS

vpsrc_rec    vd_pvs_sources_view_ext%ROWTYPE;

BEGIN
  p_return_code := NULL;
  --At least one of the ID or Name parameters has to be provided
  IF P_VPSRC_VPS_IDSEQ IS NOT NULL THEN  --Retrieve the relationship by key

    BEGIN
         SELECT *
         INTO vpsrc_rec
         FROM vd_pvs_sources_view_ext
         WHERE vps_idseq = p_vpsrc_vps_idseq;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_return_code := 'API_VPSRC_005'; --Srelationship not found
            RETURN;
        WHEN OTHERS THEN
             p_return_code := 'API_VPSRC_009'; --Other raised on select from Vd_pvs_sources_view_ext
             RETURN;
    END;

    /*If P_VPSRC_VP_IDSEQ is not null and does not match retrieved id
       then assign the error code */
    IF(P_VPSRC_VP_IDSEQ IS NOT NULL AND (P_VPSRC_VP_IDSEQ <> vpsrc_rec.vp_idseq)) THEN
      p_return_code := 'API_VPSRC_002';-- Retrieved ID Does not Match with parameter
      RETURN;
    END IF;

    /*If the P_VPSRC_SRC_NAME is not null and does not match the retrieved source then assign the error code and RETURN*/
    IF(P_VPSRC_SRC_NAME IS NOT NULL AND (P_VPSRC_SRC_NAME <> vpsrc_rec.src_name)) THEN
      p_return_code := 'API_VPSRC_003';-- Retrieved name does not match with parameter
      RETURN;
    END IF;

    -- Assign the data retrieved to the parameters
    P_VPSRC_VPS_IDSEQ               := vpsrc_rec.vps_idseq;
    P_VPSRC_VP_IDSEQ             := vpsrc_rec.vp_idseq;
    P_VPSRC_SRC_NAME             := vpsrc_rec.src_name;
    P_VPSRC_DATE_SUBMITTED         := vpsrc_rec.date_submitted;
    P_VPSRC_CREATED_BY             := vpsrc_rec.created_by;
    P_VPSRC_DATE_CREATED         := vpsrc_rec.date_created;
    P_VPSRC_MODIFIED_BY             := vpsrc_rec.modified_by;
    P_VPSRC_DATE_MODIFIED         := vpsrc_rec.date_modified;

        --Key is not provided
  ELSIF (P_VPSRC_VP_IDSEQ IS NULL) THEN
     p_return_code := 'API_VPSRC_001'; --neither PK or UK provided, return error

  ELSIF (P_VPSRC_SRC_NAME IS NULL) THEN
      p_return_code := 'API_VPSRC_001'; -- neither PK or UK provided, return error
      RETURN;
  ELSE
     /*Retrieve the relationship */
     BEGIN
       SELECT *
       INTO vpsrc_rec
       FROM vd_pvs_sources_view_ext
       WHERE vp_idseq = P_VPSRC_VP_IDSEQ
       AND   src_name = P_VPSRC_SRC_NAME;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
               p_return_code := 'API_VPSRC_005'; -- Relationship Not found
            RETURN;
       WHEN OTHERS THEN
               p_return_code := 'API_VPSRC_009'; -- Other raised in select from vd_pvs_sources_view_ext
            RETURN;
     END;

    -- Assign the data retrieved to the parameters
    P_VPSRC_VPS_IDSEQ               := vpsrc_rec.vps_idseq;
    P_VPSRC_VP_IDSEQ             := vpsrc_rec.vp_idseq;
    P_VPSRC_SRC_NAME             := vpsrc_rec.src_name;
    P_VPSRC_DATE_SUBMITTED         := vpsrc_rec.date_submitted;
    P_VPSRC_CREATED_BY             := vpsrc_rec.created_by;
    P_VPSRC_DATE_CREATED         := vpsrc_rec.date_created;
    P_VPSRC_MODIFIED_BY             := vpsrc_rec.modified_by;
    P_VPSRC_DATE_MODIFIED         := vpsrc_rec.date_modified;

  END IF;

 EXCEPTION
    WHEN NO_DATA_FOUND THEN
       NULL;
    WHEN OTHERS THEN
       NULL;
END GET_VP_SRC;

END Sbrext_Get_Row;

/

  GRANT EXECUTE ON "SBREXT"."SBREXT_GET_ROW" TO "CDEBROWSER";
 
  GRANT DEBUG ON "SBREXT"."SBREXT_GET_ROW" TO "CDEBROWSER";
 
  GRANT EXECUTE ON "SBREXT"."SBREXT_GET_ROW" TO "DATA_LOADER";
 
  GRANT DEBUG ON "SBREXT"."SBREXT_GET_ROW" TO "DATA_LOADER";
 
  GRANT EXECUTE ON "SBREXT"."SBREXT_GET_ROW" TO "SBR" WITH GRANT OPTION;
 
  GRANT DEBUG ON "SBREXT"."SBREXT_GET_ROW" TO "SBR" WITH GRANT OPTION;
 
  GRANT EXECUTE ON "SBREXT"."SBREXT_GET_ROW" TO "APPLICATION_USER";
 
  GRANT DEBUG ON "SBREXT"."SBREXT_GET_ROW" TO "APPLICATION_USER";
 
  GRANT EXECUTE ON "SBREXT"."SBREXT_GET_ROW" TO "DER_USER";
  
