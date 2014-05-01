-- run this as SBR user
/*
 * Fix related to issue https://gforge.nci.nih.gov/tracker/index.php?func=detail&aid=30681.
 */
create or replace PACKAGE BODY "CG$DATA_ELEMENT_CONCEPTS_VIEW" IS


-- 21-Jul-2003, W. Ver Hoef - reordered sequence of procedure definitions to be
--                            consistent with spec.

--------------------------------------------------------------------------------
-- Name:        slct
--
-- Description: Selects into the given parameter all the attributes for the row
--              given by the primary key
--
-- Parameters:  cg$sel_rec  Record of row to be selected into using its PK
--
-- Date:  21-Jul-2003
-- Modified By:  W. Ver Hoef
-- Reason:  Was getting error status returned when trying to call sbrext_set_row's
--          set_dec with DEL as the action due to the fact that the upd procedure
--          here was calling slct which was referencing data_element_concepts_view
--          rather than data_element_concepts.  The logically deleted record was
--          no longer visible through the view so the slct failed, causing the
--          set_dec to ultimately return an error.  Changed slct to use the table.
--------------------------------------------------------------------------------
PROCEDURE slct(cg$sel_rec IN OUT cg$row_type) IS
BEGIN
    IF cg$sel_rec.the_rowid is null THEN
       SELECT    OC_IDSEQ
       ,         DEC_IDSEQ
       ,         VERSION
       ,         PREFERRED_NAME
       ,         CONTE_IDSEQ
       ,         CD_IDSEQ
       ,         PROPL_NAME
       ,         OCL_NAME
       ,         PREFERRED_DEFINITION
       ,         ASL_NAME
       ,         LONG_NAME
       ,         LATEST_VERSION_IND
       ,         DELETED_IND
       ,         DATE_CREATED
       ,         BEGIN_DATE
       ,         CREATED_BY
       ,         END_DATE
       ,         DATE_MODIFIED
       ,         MODIFIED_BY
       ,         OBJ_CLASS_QUALIFIER
       ,         PROPERTY_QUALIFIER
       ,         CHANGE_NOTE
       ,         PROP_IDSEQ
       ,         ORIGIN
       ,         DEC_ID
       , rowid
       INTO      cg$sel_rec.OC_IDSEQ
       ,         cg$sel_rec.DEC_IDSEQ
       ,         cg$sel_rec.VERSION
       ,         cg$sel_rec.PREFERRED_NAME
       ,         cg$sel_rec.CONTE_IDSEQ
       ,         cg$sel_rec.CD_IDSEQ
       ,         cg$sel_rec.PROPL_NAME
       ,         cg$sel_rec.OCL_NAME
       ,         cg$sel_rec.PREFERRED_DEFINITION
       ,         cg$sel_rec.ASL_NAME
       ,         cg$sel_rec.LONG_NAME
       ,         cg$sel_rec.LATEST_VERSION_IND
       ,         cg$sel_rec.DELETED_IND
       ,         cg$sel_rec.DATE_CREATED
       ,         cg$sel_rec.BEGIN_DATE
       ,         cg$sel_rec.CREATED_BY
       ,         cg$sel_rec.END_DATE
       ,         cg$sel_rec.DATE_MODIFIED
       ,         cg$sel_rec.MODIFIED_BY
       ,         cg$sel_rec.OBJ_CLASS_QUALIFIER
       ,         cg$sel_rec.PROPERTY_QUALIFIER
       ,         cg$sel_rec.CHANGE_NOTE
       ,         cg$sel_rec.PROP_IDSEQ
       ,         cg$sel_rec.ORIGIN
       ,         cg$sel_rec.DEC_ID
       ,cg$sel_rec.the_rowid
       FROM   DATA_ELEMENT_CONCEPTS  -- 21-Jul-2003, W. Ver Hoef - stripped off "_VIEW"
       WHERE        DEC_IDSEQ = cg$sel_rec.DEC_IDSEQ;
    ELSE
       SELECT    OC_IDSEQ
       ,         DEC_IDSEQ
       ,         VERSION
       ,         PREFERRED_NAME
       ,         CONTE_IDSEQ
       ,         CD_IDSEQ
       ,         PROPL_NAME
       ,         OCL_NAME
       ,         PREFERRED_DEFINITION
       ,         ASL_NAME
       ,         LONG_NAME
       ,         LATEST_VERSION_IND
       ,         DELETED_IND
       ,         DATE_CREATED
       ,         BEGIN_DATE
       ,         CREATED_BY
       ,         END_DATE
       ,         DATE_MODIFIED
       ,         MODIFIED_BY
       ,         OBJ_CLASS_QUALIFIER
       ,         PROPERTY_QUALIFIER
       ,         CHANGE_NOTE
       ,         PROP_IDSEQ
       ,         ORIGIN
       ,         DEC_ID
       , rowid
       INTO      cg$sel_rec.OC_IDSEQ
       ,         cg$sel_rec.DEC_IDSEQ
       ,         cg$sel_rec.VERSION
       ,         cg$sel_rec.PREFERRED_NAME
       ,         cg$sel_rec.CONTE_IDSEQ
       ,         cg$sel_rec.CD_IDSEQ
       ,         cg$sel_rec.PROPL_NAME
       ,         cg$sel_rec.OCL_NAME
       ,         cg$sel_rec.PREFERRED_DEFINITION
       ,         cg$sel_rec.ASL_NAME
       ,         cg$sel_rec.LONG_NAME
       ,         cg$sel_rec.LATEST_VERSION_IND
       ,         cg$sel_rec.DELETED_IND
       ,         cg$sel_rec.DATE_CREATED
       ,         cg$sel_rec.BEGIN_DATE
       ,         cg$sel_rec.CREATED_BY
       ,         cg$sel_rec.END_DATE
       ,         cg$sel_rec.DATE_MODIFIED
       ,         cg$sel_rec.MODIFIED_BY
       ,         cg$sel_rec.OBJ_CLASS_QUALIFIER
       ,         cg$sel_rec.PROPERTY_QUALIFIER
       ,         cg$sel_rec.CHANGE_NOTE
       ,         cg$sel_rec.PROP_IDSEQ
       ,         cg$sel_rec.ORIGIN
       ,         cg$sel_rec.DEC_ID
       ,cg$sel_rec.the_rowid
       FROM   DATA_ELEMENT_CONCEPTS  -- 21-Jul-2003, W. Ver Hoef - stripped off "_VIEW"
       WHERE  rowid = cg$sel_rec.the_rowid;
    END IF;
EXCEPTION WHEN OTHERS THEN
    cg$errors.push(SQLERRM,
                   'E',
                   'ORA',
                   SQLCODE,
                   'cg$DATA_ELEMENT_CONCEPTS_VIEW.slct.others');
    cg$errors.raise_failure;
END slct;


--------------------------------------------------------------------------------
-- Name:        validate_arc
--
-- Description: Checks for adherence to arc relationship
--
-- Parameters:  cg$rec     Record of DATA_ELEMENT_CONCEPTS_VIEW current values
--------------------------------------------------------------------------------
PROCEDURE validate_arc(cg$rec IN OUT cg$row_type) IS
i NUMBER;
BEGIN
    NULL;
END validate_arc;


--------------------------------------------------------------------------------
-- Name:        validate_domain
--
-- Description: Checks against reference table for values lying in a domain
--
-- Parameters:  cg$rec     Record of DATA_ELEMENT_CONCEPTS_VIEW current values
--------------------------------------------------------------------------------
PROCEDURE validate_domain(cg$rec IN OUT cg$row_type,
                          cg$ind IN cg$ind_type DEFAULT cg$ind_true) IS
dummy NUMBER;
no_tabview EXCEPTION;
PRAGMA EXCEPTION_INIT(no_tabview, -942);
BEGIN
    NULL;
EXCEPTION
    WHEN cg$errors.cg$error THEN
        cg$errors.raise_failure;
    WHEN no_tabview THEN
        cg$errors.push(cg$errors.MsgGetText(cg$errors.API_RV_TAB_NOT_FOUND, cg$errors.APIMSG_RV_TAB_NOT_FOUND, 'CG_REF_CODES','DATA_ELEMENT_CONCEPTS_VIEW'),
                       'E',
                       'API',
                       cg$errors.API_RV_TAB_NOT_FOUND,
                       'cg$DATA_ELEMENT_CONCEPTS_VIEW.v_domain.no_reftable_found');
        cg$errors.raise_failure;
    WHEN OTHERS THEN
        cg$errors.push(SQLERRM,
                       'E',
                       'ORA',
                       SQLCODE,
                       'cg$DATA_ELEMENT_CONCEPTS_VIEW.v_domain.others');
        cg$errors.raise_failure;
END validate_domain;


--------------------------------------------------------------------------------
-- Name:        validate_foreign_keys
--
-- Description: Checks all mandatory columns are not null and raises appropriate
--              error if not satisfied
--
-- Parameters:  cg$rec Record of row to be checked
--------------------------------------------------------------------------------
PROCEDURE validate_foreign_keys_ins(cg$rec IN cg$row_type) IS
    fk_check INTEGER;
BEGIN
NULL;
END;


PROCEDURE validate_foreign_keys_upd( cg$rec IN cg$row_type,
                                     cg$old_rec IN cg$row_type,
                                     cg$ind IN cg$ind_type) IS
    fk_check INTEGER;
BEGIN
NULL;
END;


PROCEDURE validate_foreign_keys_del(cg$rec IN cg$row_type) IS
    fk_check INTEGER;
BEGIN
NULL;
END;


--------------------------------------------------------------------------------
-- Name:        cascade_update
--
-- Description: Updates all child tables affected by a change to DATA_ELEMENT_CONCEPTS_VIEW
--
-- Parameters:  cg$rec     Record of DATA_ELEMENT_CONCEPTS_VIEW current values
--              cg$old_rec Record of DATA_ELEMENT_CONCEPTS_VIEW previous values
--------------------------------------------------------------------------------
PROCEDURE cascade_update(cg$new_rec IN OUT cg$row_type,
                         cg$old_rec IN     cg$row_type) IS
BEGIN
    NULL;
END cascade_update;


--------------------------------------------------------------------------------
-- Name:        cascade_delete
--
-- Description: Delete all child tables affected by a delete to DATA_ELEMENT_CONCEPTS_VIEW
--
-- Parameters:  cg$rec     Record of DATA_ELEMENT_CONCEPTS_VIEW current values
--------------------------------------------------------------------------------
PROCEDURE cascade_delete(cg$old_rec IN OUT cg$row_type)
IS
BEGIN
    NULL;
END cascade_delete;


--------------------------------------------------------------------------------
-- Name:        domain_cascade_delete
--
-- Description: Delete all child tables affected by a delete to DATA_ELEMENT_CONCEPTS_VIEW
--
-- Parameters:  cg$rec     Record of DATA_ELEMENT_CONCEPTS_VIEW current values
--------------------------------------------------------------------------------
PROCEDURE domain_cascade_delete(cg$old_rec IN OUT cg$row_type)
IS
BEGIN
    NULL;
END domain_cascade_delete;


--------------------------------------------------------------------------------
-- Name:        upd_denorm2
--
-- Description: API procedure for simple denormalization
--
-- Parameters:  cg$rec  Record of row to be updated
--              cg$ind  Record of columns specifically set
--              do_upd  Whether we want the actual UPDATE to occur
--------------------------------------------------------------------------------
PROCEDURE upd_denorm2( cg$rec IN cg$row_type,
                       cg$ind IN cg$ind_type
                          )
IS
BEGIN
NULL;
END upd_denorm2;


--------------------------------------------------------------------------------
-- Name:        upd_oper_denorm2
--
-- Description: API procedure for operation denormalization
--
-- Parameters:  cg$rec  Record of row to be updated
--              cg$ind  Record of columns specifically set
--              do_upd  Whether we want the actual UPDATE to occur
--------------------------------------------------------------------------------
PROCEDURE upd_oper_denorm2( cg$rec IN cg$row_type,
                            cg$old_rec IN cg$row_type,
                            cg$ind IN cg$ind_type,
                            operation IN VARCHAR2 DEFAULT 'UPD'
                               )
IS
BEGIN
NULL;
END upd_oper_denorm2;


--------------------------------------------------------------------------------
-- Name:        validate_mandatory
--
-- Description: Checks all mandatory columns are not null and raises appropriate
--              error if not satisfied
--
-- Parameters:  cg$val_rec Record of row to be checked
--              loc        Place where this procedure was called for error
--                         trapping
--------------------------------------------------------------------------------
PROCEDURE validate_mandatory(cg$val_rec IN cg$row_type,
                             loc        IN VARCHAR2 DEFAULT '') IS
BEGIN
    IF (cg$val_rec.DEC_IDSEQ IS NULL) THEN
        cg$errors.push(cg$errors.MsgGetText(cg$errors.API_MAND_COLUMN_ISNULL, cg$errors.VAL_MAND, P10DEC_IDSEQ),
                       'E',
                       'API',
                       cg$errors.API_MAND_COLUMN_ISNULL,
                       loc);
    END IF;
    IF (cg$val_rec.VERSION IS NULL) THEN
        cg$errors.push(cg$errors.MsgGetText(cg$errors.API_MAND_COLUMN_ISNULL, cg$errors.VAL_MAND, P15VERSION),
                       'E',
                       'API',
                       cg$errors.API_MAND_COLUMN_ISNULL,
                       loc);
    END IF;
    IF (cg$val_rec.PREFERRED_NAME IS NULL) THEN
        cg$errors.push(cg$errors.MsgGetText(cg$errors.API_MAND_COLUMN_ISNULL, cg$errors.VAL_MAND, P20PREFERRED_NAME),
                       'E',
                       'API',
                       cg$errors.API_MAND_COLUMN_ISNULL,
                       loc);
    END IF;
    IF (cg$val_rec.CONTE_IDSEQ IS NULL) THEN
        cg$errors.push(cg$errors.MsgGetText(cg$errors.API_MAND_COLUMN_ISNULL, cg$errors.VAL_MAND, P25CONTE_IDSEQ),
                       'E',
                       'API',
                       cg$errors.API_MAND_COLUMN_ISNULL,
                       loc);
    END IF;
    IF (cg$val_rec.CD_IDSEQ IS NULL) THEN
        cg$errors.push(cg$errors.MsgGetText(cg$errors.API_MAND_COLUMN_ISNULL, cg$errors.VAL_MAND, P27CD_IDSEQ),
                       'E',
                       'API',
                       cg$errors.API_MAND_COLUMN_ISNULL,
                       loc);
    END IF;
    IF (cg$val_rec.PREFERRED_DEFINITION IS NULL) THEN
        cg$errors.push(cg$errors.MsgGetText(cg$errors.API_MAND_COLUMN_ISNULL, cg$errors.VAL_MAND, P40PREFERRED_DEFINITION),
                       'E',
                       'API',
                       cg$errors.API_MAND_COLUMN_ISNULL,
                       loc);
    END IF;
    IF (cg$val_rec.ASL_NAME IS NULL) THEN
        cg$errors.push(cg$errors.MsgGetText(cg$errors.API_MAND_COLUMN_ISNULL, cg$errors.VAL_MAND, P42ASL_NAME),
                       'E',
                       'API',
                       cg$errors.API_MAND_COLUMN_ISNULL,
                       loc);
    END IF;
    IF (cg$val_rec.DATE_CREATED IS NULL) THEN
        cg$errors.push(cg$errors.MsgGetText(cg$errors.API_MAND_COLUMN_ISNULL, cg$errors.VAL_MAND, P50DATE_CREATED),
                       'E',
                       'API',
                       cg$errors.API_MAND_COLUMN_ISNULL,
                       loc);
    END IF;
    IF (cg$val_rec.CREATED_BY IS NULL) THEN
        cg$errors.push(cg$errors.MsgGetText(cg$errors.API_MAND_COLUMN_ISNULL, cg$errors.VAL_MAND, P60CREATED_BY),
                       'E',
                       'API',
                       cg$errors.API_MAND_COLUMN_ISNULL,
                       loc);
    END IF;
    NULL;
END validate_mandatory;


--------------------------------------------------------------------------------
-- Name:        up_autogen_columns
--
-- Description: Specific autogeneration of column values and conversion to
--              uppercase
--
-- Parameters:  cg$rec    Record of row to be manipulated
--              cg$ind    Indicators for row
--              operation Procedure where this procedure was called
--------------------------------------------------------------------------------
PROCEDURE up_autogen_columns(cg$rec IN OUT cg$row_type,
                             cg$ind IN OUT cg$ind_type,
                             operation IN VARCHAR2 DEFAULT 'INS',
                             do_denorm IN BOOLEAN DEFAULT TRUE) IS
BEGIN
    IF (operation = 'INS') THEN
    cg$rec.DATE_CREATED := trunc(sysdate);
    cg$rec.DATE_CREATED := trunc(sysdate);
    --cg$rec.CREATED_BY := user;
    --cg$rec.CREATED_BY := user;
        NULL;
    ELSE
      cg$rec.DATE_MODIFIED := trunc(sysdate);
    END IF;

   -- cg$rec.MODIFIED_BY := user;
EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        cg$errors.push(SQLERRM,
                      'E',
                      'ORA',
                      SQLCODE,
                      'cg$DATA_ELEMENT_CONCEPTS_VIEW.up_autogen_columns.denorm');
        cg$errors.raise_failure;
END up_autogen_columns;


--------------------------------------------------------------------------------
-- Name:        err_msg
--
-- Description: Pushes onto stack appropriate user defined error message
--              depending on the rule violated
--
-- Parameters:  msg     Oracle error message
--              type    Type of violation e.g. check_constraint: ERR_CHECK_CON
--              loc     Place where this procedure was called for error
--                      trapping
--------------------------------------------------------------------------------
PROCEDURE err_msg(msg   IN VARCHAR2,
                  type  IN INTEGER,
                  loc   IN VARCHAR2 DEFAULT '') IS
con_name VARCHAR2(240);
BEGIN
    con_name := cg$errors.parse_constraint(msg, type);
    IF (con_name = 'DEC_PK') THEN
        cg$errors.push(nvl(DEC_PK
                  ,cg$errors.MsgGetText(cg$errors.API_PK_CON_VIOLATED
                                     ,cg$errors.APIMSG_PK_VIOLAT
                                     ,'DEC_PK'
                                     ,'DATA_ELEMENT_CONCEPTS_VIEW')),
                       'E',
                       'API',
                       cg$errors.API_PK_CON_VIOLATED,
                       loc);
    ELSIF (con_name = 'DEC_UK') THEN
        cg$errors.push(nvl(DEC_UK
                  ,cg$errors.MsgGetText(cg$errors.API_UQ_CON_VIOLATED
                                     ,cg$errors.APIMSG_UK_VIOLAT
                                     ,'DEC_UK'
                                     ,'DATA_ELEMENT_CONCEPTS_VIEW')),
                       'E',
                       'API',
                       cg$errors.API_UQ_CON_VIOLATED,
                       loc);
    ELSIF (con_name = 'DEC_OBJ_QUAL_FK') THEN
        cg$errors.push(nvl(DEC_OBJ_QUAL_FK
                      ,cg$errors.MsgGetText(cg$errors.API_FK_CON_VIOLATED
                                     ,cg$errors.APIMSG_FK_VIOLAT
                                     ,'DEC_OBJ_QUAL_FK'
                                     ,'DATA_ELEMENT_CONCEPTS_VIEW')),
                       'E',
                       'API',
                       cg$errors.API_FK_CON_VIOLATED,
                       loc);
    ELSIF (con_name = 'DEC_OC_FK') THEN
        cg$errors.push(nvl(DEC_OC_FK
                      ,cg$errors.MsgGetText(cg$errors.API_FK_CON_VIOLATED
                                     ,cg$errors.APIMSG_FK_VIOLAT
                                     ,'DEC_OC_FK'
                                     ,'DATA_ELEMENT_CONCEPTS_VIEW')),
                       'E',
                       'API',
                       cg$errors.API_FK_CON_VIOLATED,
                       loc);
    ELSIF (con_name = 'DEC_PROPE_FK') THEN
        cg$errors.push(nvl(DEC_PROPE_FK
                      ,cg$errors.MsgGetText(cg$errors.API_FK_CON_VIOLATED
                                     ,cg$errors.APIMSG_FK_VIOLAT
                                     ,'DEC_PROPE_FK'
                                     ,'DATA_ELEMENT_CONCEPTS_VIEW')),
                       'E',
                       'API',
                       cg$errors.API_FK_CON_VIOLATED,
                       loc);
    ELSIF (con_name = 'DEC_OCT_FK') THEN
        cg$errors.push(nvl(DEC_OCT_FK
                      ,cg$errors.MsgGetText(cg$errors.API_FK_CON_VIOLATED
                                     ,cg$errors.APIMSG_FK_VIOLAT
                                     ,'DEC_OCT_FK'
                                     ,'DATA_ELEMENT_CONCEPTS_VIEW')),
                       'E',
                       'API',
                       cg$errors.API_FK_CON_VIOLATED,
                       loc);
    ELSIF (con_name = 'DEC_CONTE_FK') THEN
        cg$errors.push(nvl(DEC_CONTE_FK
                      ,cg$errors.MsgGetText(cg$errors.API_FK_CON_VIOLATED
                                     ,cg$errors.APIMSG_FK_VIOLAT
                                     ,'DEC_CONTE_FK'
                                     ,'DATA_ELEMENT_CONCEPTS_VIEW')),
                       'E',
                       'API',
                       cg$errors.API_FK_CON_VIOLATED,
                       loc);
    ELSIF (con_name = 'DEC_PRO_FK') THEN
        cg$errors.push(nvl(DEC_PRO_FK
                      ,cg$errors.MsgGetText(cg$errors.API_FK_CON_VIOLATED
                                     ,cg$errors.APIMSG_FK_VIOLAT
                                     ,'DEC_PRO_FK'
                                     ,'DATA_ELEMENT_CONCEPTS_VIEW')),
                       'E',
                       'API',
                       cg$errors.API_FK_CON_VIOLATED,
                       loc);
    ELSIF (con_name = 'DEC_CD_FK') THEN
        cg$errors.push(nvl(DEC_CD_FK
                      ,cg$errors.MsgGetText(cg$errors.API_FK_CON_VIOLATED
                                     ,cg$errors.APIMSG_FK_VIOLAT
                                     ,'DEC_CD_FK'
                                     ,'DATA_ELEMENT_CONCEPTS_VIEW')),
                       'E',
                       'API',
                       cg$errors.API_FK_CON_VIOLATED,
                       loc);
    ELSIF (con_name = 'DEC_ASL_FK') THEN
        cg$errors.push(nvl(DEC_ASL_FK
                      ,cg$errors.MsgGetText(cg$errors.API_FK_CON_VIOLATED
                                     ,cg$errors.APIMSG_FK_VIOLAT
                                     ,'DEC_ASL_FK'
                                     ,'DATA_ELEMENT_CONCEPTS_VIEW')),
                       'E',
                       'API',
                       cg$errors.API_FK_CON_VIOLATED,
                       loc);
    ELSIF (con_name = 'DEC_PROP_QUAL_FK') THEN
        cg$errors.push(nvl(DEC_PROP_QUAL_FK
                      ,cg$errors.MsgGetText(cg$errors.API_FK_CON_VIOLATED
                                     ,cg$errors.APIMSG_FK_VIOLAT
                                     ,'DEC_PROP_QUAL_FK'
                                     ,'DATA_ELEMENT_CONCEPTS_VIEW')),
                       'E',
                       'API',
                       cg$errors.API_FK_CON_VIOLATED,
                       loc);
    ELSE
        cg$errors.push(SQLERRM,
                       'E',
                       'ORA',
                       SQLCODE,
                       loc);
    END IF;
END err_msg;


--------------------------------------------------------------------------------
-- Name:        uk_key_updateable
--
-- Description: Raise appropriate error when unique key updated
--
-- Parameters:  none
--------------------------------------------------------------------------------
PROCEDURE uk_key_updateable(uk IN VARCHAR2) IS
BEGIN
    cg$errors.push(cg$errors.MsgGetText(cg$errors.API_UNIQUE_KEY_UPDATE, cg$errors.ERR_UK_UPDATE, uk),
                   'E',
                   'API',
                   cg$errors.API_UNIQUE_KEY_UPDATE,
                   'cg$err.uk_key_updateable');
                   cg$errors.raise_failure;
END uk_key_updateable;


--------------------------------------------------------------------------------
-- Name:        fk_key_transferable
--
-- Description: Raise appropriate error when foreign key updated
--
-- Parameters:  none
--------------------------------------------------------------------------------
PROCEDURE fk_key_transferable(fk IN VARCHAR2) IS
BEGIN
    cg$errors.push(cg$errors.MsgGetText(cg$errors.API_FOREIGN_KEY_TRANS, cg$errors.ERR_FK_TRANS, fk),
                   'E',
                   'API',
                   cg$errors.API_FOREIGN_KEY_TRANS,
                   'cg$err.fk_key_transferable');
    cg$errors.raise_failure;
END fk_key_transferable;


--------------------------------------------------------------------------------
-- Name:        doLobs
--
-- Description: This function is updating lob columns
--
-- Parameters:  cg$rec  Record of row to be inserted
--              cg$ind  Record of columns specifically set
--------------------------------------------------------------------------------
PROCEDURE doLobs(cg$rec IN OUT cg$row_type,
                 cg$ind IN OUT cg$ind_type) IS
BEGIN
   NULL;
END doLobs;


--------------------------------------------------------------------------------
-- Name:        ins
--
-- Description: API insert procedure
--
-- Parameters:  cg$rec  Record of row to be inserted
--              cg$ind  Record of columns specifically set
--              do_ins  Whether we want the actual INSERT to occur
--------------------------------------------------------------------------------
PROCEDURE ins(cg$rec IN OUT cg$row_type,
              cg$ind IN OUT cg$ind_type,
              do_ins IN BOOLEAN DEFAULT TRUE) IS
cg$tmp_rec cg$row_type;
--  Constant default values
D15_VERSION CONSTANT DATA_ELEMENT_CONCEPTS_VIEW.VERSION%TYPE := 1.0;
BEGIN
--  Application_logic Pre-Insert <<Start>>
--  Application_logic Pre-Insert << End >>
--  Defaulted
    IF NOT (cg$ind.VERSION) THEN cg$rec.VERSION := D15_VERSION; END IF;
--  Auto-generated and uppercased columns
    up_autogen_columns(cg$rec, cg$ind, 'INS', do_ins);
    called_from_package := TRUE;
    IF (do_ins) THEN
        validate_foreign_keys_ins(cg$rec);
        validate_arc(cg$rec);
        validate_domain(cg$rec);
        INSERT INTO DATA_ELEMENT_CONCEPTS_VIEW
            (OC_IDSEQ
            ,DEC_IDSEQ
            ,VERSION
            ,PREFERRED_NAME
            ,CONTE_IDSEQ
            ,CD_IDSEQ
            ,PROPL_NAME
            ,OCL_NAME
            ,PREFERRED_DEFINITION
            ,ASL_NAME
            ,LONG_NAME
            ,LATEST_VERSION_IND
            ,DELETED_IND
            ,DATE_CREATED
            ,BEGIN_DATE
            ,CREATED_BY
            ,END_DATE
            ,DATE_MODIFIED
            ,MODIFIED_BY
            ,OBJ_CLASS_QUALIFIER
            ,PROPERTY_QUALIFIER
            ,CHANGE_NOTE
            ,PROP_IDSEQ
            ,ORIGIN
            ,CDR_NAME	--GF30681
            ,DEC_ID)
        VALUES
            (cg$rec.OC_IDSEQ
            ,cg$rec.DEC_IDSEQ
            ,cg$rec.VERSION
            ,cg$rec.PREFERRED_NAME
            ,cg$rec.CONTE_IDSEQ
            ,cg$rec.CD_IDSEQ
            ,cg$rec.PROPL_NAME
            ,cg$rec.OCL_NAME
            ,cg$rec.PREFERRED_DEFINITION
            ,cg$rec.ASL_NAME
            ,cg$rec.LONG_NAME
            ,cg$rec.LATEST_VERSION_IND
            ,cg$rec.DELETED_IND
            ,cg$rec.DATE_CREATED
            ,cg$rec.BEGIN_DATE
            ,cg$rec.CREATED_BY
            ,cg$rec.END_DATE
            ,cg$rec.DATE_MODIFIED
            ,cg$rec.MODIFIED_BY
            ,cg$rec.OBJ_CLASS_QUALIFIER
            ,cg$rec.PROPERTY_QUALIFIER
            ,cg$rec.CHANGE_NOTE
            ,cg$rec.PROP_IDSEQ
            ,cg$rec.ORIGIN
            ,cg$rec.CDR_NAME		--GF30681
            ,cg$rec.DEC_ID
);
        doLobs(cg$rec, cg$ind);
        slct(cg$rec);
        upd_oper_denorm2(cg$rec, cg$tmp_rec, cg$ind, 'INS');
    END IF;
    called_from_package := FALSE;
    IF NOT (do_ins) THEN
        cg$table(idx).OC_IDSEQ := cg$rec.OC_IDSEQ;
        cg$tableind(idx).OC_IDSEQ := cg$ind.OC_IDSEQ;
        cg$table(idx).DEC_IDSEQ := cg$rec.DEC_IDSEQ;
        cg$tableind(idx).DEC_IDSEQ := cg$ind.DEC_IDSEQ;
        cg$table(idx).VERSION := cg$rec.VERSION;
        cg$tableind(idx).VERSION := cg$ind.VERSION;
        cg$table(idx).PREFERRED_NAME := cg$rec.PREFERRED_NAME;
        cg$tableind(idx).PREFERRED_NAME := cg$ind.PREFERRED_NAME;
        cg$table(idx).CONTE_IDSEQ := cg$rec.CONTE_IDSEQ;
        cg$tableind(idx).CONTE_IDSEQ := cg$ind.CONTE_IDSEQ;
        cg$table(idx).CD_IDSEQ := cg$rec.CD_IDSEQ;
        cg$tableind(idx).CD_IDSEQ := cg$ind.CD_IDSEQ;
        cg$table(idx).PROPL_NAME := cg$rec.PROPL_NAME;
        cg$tableind(idx).PROPL_NAME := cg$ind.PROPL_NAME;
        cg$table(idx).OCL_NAME := cg$rec.OCL_NAME;
        cg$tableind(idx).OCL_NAME := cg$ind.OCL_NAME;
        cg$table(idx).PREFERRED_DEFINITION := cg$rec.PREFERRED_DEFINITION;
        cg$tableind(idx).PREFERRED_DEFINITION := cg$ind.PREFERRED_DEFINITION;
        cg$table(idx).ASL_NAME := cg$rec.ASL_NAME;
        cg$tableind(idx).ASL_NAME := cg$ind.ASL_NAME;
        cg$table(idx).LONG_NAME := cg$rec.LONG_NAME;
        cg$tableind(idx).LONG_NAME := cg$ind.LONG_NAME;
        cg$table(idx).LATEST_VERSION_IND := cg$rec.LATEST_VERSION_IND;
        cg$tableind(idx).LATEST_VERSION_IND := cg$ind.LATEST_VERSION_IND;
        cg$table(idx).DELETED_IND := cg$rec.DELETED_IND;
        cg$tableind(idx).DELETED_IND := cg$ind.DELETED_IND;
        cg$table(idx).DATE_CREATED := cg$rec.DATE_CREATED;
        cg$tableind(idx).DATE_CREATED := cg$ind.DATE_CREATED;
        cg$table(idx).BEGIN_DATE := cg$rec.BEGIN_DATE;
        cg$tableind(idx).BEGIN_DATE := cg$ind.BEGIN_DATE;
        cg$table(idx).CREATED_BY := cg$rec.CREATED_BY;
        cg$tableind(idx).CREATED_BY := cg$ind.CREATED_BY;
        cg$table(idx).END_DATE := cg$rec.END_DATE;
        cg$tableind(idx).END_DATE := cg$ind.END_DATE;
        cg$table(idx).DATE_MODIFIED := cg$rec.DATE_MODIFIED;
        cg$tableind(idx).DATE_MODIFIED := cg$ind.DATE_MODIFIED;
        cg$table(idx).MODIFIED_BY := cg$rec.MODIFIED_BY;
        cg$tableind(idx).MODIFIED_BY := cg$ind.MODIFIED_BY;
        cg$table(idx).OBJ_CLASS_QUALIFIER := cg$rec.OBJ_CLASS_QUALIFIER;
        cg$tableind(idx).OBJ_CLASS_QUALIFIER := cg$ind.OBJ_CLASS_QUALIFIER;
        cg$table(idx).PROPERTY_QUALIFIER := cg$rec.PROPERTY_QUALIFIER;
        cg$tableind(idx).PROPERTY_QUALIFIER := cg$ind.PROPERTY_QUALIFIER;
        cg$table(idx).CHANGE_NOTE := cg$rec.CHANGE_NOTE;
        cg$tableind(idx).CHANGE_NOTE := cg$ind.CHANGE_NOTE;
        cg$table(idx).PROP_IDSEQ := cg$rec.PROP_IDSEQ;
        cg$tableind(idx).PROP_IDSEQ := cg$ind.PROP_IDSEQ;
        cg$table(idx).ORIGIN := cg$rec.ORIGIN;
        cg$tableind(idx).ORIGIN := cg$ind.ORIGIN;
		cg$table(idx).CDR_NAME := cg$rec.CDR_NAME; ----GF30681
        cg$tableind(idx).CDR_NAME := cg$ind.CDR_NAME; --GF30681
        cg$table(idx).DEC_ID := cg$rec.DEC_ID;
        cg$tableind(idx).DEC_ID := cg$ind.DEC_ID;
        idx := idx + 1;
    END IF;
--  Application logic Post-Insert <<Start>>
--  Application logic Post-Insert << End >>
EXCEPTION
    WHEN cg$errors.cg$error THEN
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN cg$errors.mandatory_missing THEN
        validate_mandatory(cg$rec, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.ins.mandatory_missing');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN cg$errors.check_violation THEN
        err_msg(SQLERRM, cg$errors.ERR_CHECK_CON, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.ins.check_violation');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN cg$errors.fk_violation THEN
        err_msg(SQLERRM, cg$errors.ERR_FOREIGN_KEY, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.ins.fk_violation');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN cg$errors.uk_violation THEN
        err_msg(SQLERRM, cg$errors.ERR_UNIQUE_KEY, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.ins.uk_violation');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN OTHERS THEN
        cg$errors.push(SQLERRM,
                       'E',
                       'ORA',
                       SQLCODE,
                       'cg$DATA_ELEMENT_CONCEPTS_VIEW.ins.others');
        called_from_package := FALSE;
        cg$errors.raise_failure;
END ins;


--------------------------------------------------------------------------------
-- Name:        upd
--
-- Description: API update procedure
--
-- Parameters:  cg$rec  Record of row to be updated
--              cg$ind  Record of columns specifically set
--              do_upd  Whether we want the actual UPDATE to occur
--------------------------------------------------------------------------------
PROCEDURE upd(cg$rec IN OUT cg$row_type,
              cg$ind IN OUT cg$ind_type,
              do_upd IN BOOLEAN DEFAULT TRUE) IS
cg$upd_rec cg$row_type;
cg$old_rec cg$row_type;
RECORD_LOGGED BOOLEAN := FALSE;
BEGIN
--  Application_logic Pre-Update <<Start>>
--  Application_logic Pre-Update << End >>
    cg$upd_rec.DEC_IDSEQ := cg$rec.DEC_IDSEQ;
    cg$old_rec.DEC_IDSEQ := cg$rec.DEC_IDSEQ;
    cg$upd_rec.the_rowid := cg$rec.the_rowid;
    cg$old_rec.the_rowid := cg$rec.the_rowid;
    IF (do_upd) THEN
        slct(cg$upd_rec);
    --  Check updates to Primary Key DEC_PK allowed
        IF (cg$ind.DEC_IDSEQ AND cg$rec.DEC_IDSEQ != cg$upd_rec.DEC_IDSEQ) THEN
            uk_key_updateable('DEC_PK');
        END IF;
        IF NOT (cg$ind.OC_IDSEQ) THEN
            cg$rec.OC_IDSEQ := cg$upd_rec.OC_IDSEQ;
        END IF;
        IF NOT (cg$ind.DEC_IDSEQ) THEN
            cg$rec.DEC_IDSEQ := cg$upd_rec.DEC_IDSEQ;
        END IF;
        IF NOT (cg$ind.VERSION) THEN
            cg$rec.VERSION := cg$upd_rec.VERSION;
        END IF;
        IF NOT (cg$ind.PREFERRED_NAME) THEN
            cg$rec.PREFERRED_NAME := cg$upd_rec.PREFERRED_NAME;
        END IF;
        IF NOT (cg$ind.CONTE_IDSEQ) THEN
            cg$rec.CONTE_IDSEQ := cg$upd_rec.CONTE_IDSEQ;
        END IF;
        IF NOT (cg$ind.CD_IDSEQ) THEN
            cg$rec.CD_IDSEQ := cg$upd_rec.CD_IDSEQ;
        END IF;
        IF NOT (cg$ind.PROPL_NAME) THEN
            cg$rec.PROPL_NAME := cg$upd_rec.PROPL_NAME;
        END IF;
        IF NOT (cg$ind.OCL_NAME) THEN
            cg$rec.OCL_NAME := cg$upd_rec.OCL_NAME;
        END IF;
        IF NOT (cg$ind.PREFERRED_DEFINITION) THEN
            cg$rec.PREFERRED_DEFINITION := cg$upd_rec.PREFERRED_DEFINITION;
        END IF;
        IF NOT (cg$ind.ASL_NAME) THEN
            cg$rec.ASL_NAME := cg$upd_rec.ASL_NAME;
        END IF;
        IF NOT (cg$ind.LONG_NAME) THEN
            cg$rec.LONG_NAME := cg$upd_rec.LONG_NAME;
        END IF;
        IF NOT (cg$ind.LATEST_VERSION_IND) THEN
            cg$rec.LATEST_VERSION_IND := cg$upd_rec.LATEST_VERSION_IND;
        END IF;
        IF NOT (cg$ind.DELETED_IND) THEN
            cg$rec.DELETED_IND := cg$upd_rec.DELETED_IND;
        END IF;
        IF NOT (cg$ind.DATE_CREATED) THEN
            cg$rec.DATE_CREATED := cg$upd_rec.DATE_CREATED;
        END IF;
        IF NOT (cg$ind.BEGIN_DATE) THEN
            cg$rec.BEGIN_DATE := cg$upd_rec.BEGIN_DATE;
        END IF;
        IF NOT (cg$ind.CREATED_BY) THEN
            cg$rec.CREATED_BY := cg$upd_rec.CREATED_BY;
        END IF;
        IF NOT (cg$ind.END_DATE) THEN
            cg$rec.END_DATE := cg$upd_rec.END_DATE;
        END IF;
        IF NOT (cg$ind.DATE_MODIFIED) THEN
            cg$rec.DATE_MODIFIED := cg$upd_rec.DATE_MODIFIED;
        END IF;
        IF NOT (cg$ind.MODIFIED_BY) THEN
            cg$rec.MODIFIED_BY := cg$upd_rec.MODIFIED_BY;
        END IF;
        IF NOT (cg$ind.OBJ_CLASS_QUALIFIER) THEN
            cg$rec.OBJ_CLASS_QUALIFIER := cg$upd_rec.OBJ_CLASS_QUALIFIER;
        END IF;
        IF NOT (cg$ind.PROPERTY_QUALIFIER) THEN
            cg$rec.PROPERTY_QUALIFIER := cg$upd_rec.PROPERTY_QUALIFIER;
        END IF;
        IF NOT (cg$ind.CHANGE_NOTE) THEN
            cg$rec.CHANGE_NOTE := cg$upd_rec.CHANGE_NOTE;
        END IF;
        IF NOT (cg$ind.PROP_IDSEQ) THEN
            cg$rec.PROP_IDSEQ := cg$upd_rec.PROP_IDSEQ;
        END IF;
        IF NOT (cg$ind.ORIGIN) THEN
            cg$rec.ORIGIN := cg$upd_rec.ORIGIN;
        END IF;
        IF NOT (cg$ind.DEC_ID) THEN
            cg$rec.DEC_ID := cg$upd_rec.DEC_ID;
        END IF;
    ELSE
       -- Perform checks if called from a trigger
       -- Indicators are only set on changed values
       null;
    --  Check updates to Primary Key DEC_PK allowed
        IF (cg$ind.DEC_IDSEQ ) THEN
            uk_key_updateable('DEC_PK');
        END IF;
    END IF;
--  Auto-generated and uppercased columns
    up_autogen_columns(cg$rec, cg$ind, 'UPD', do_upd);
--  Now do update if updateable columns exist
    IF (do_upd) THEN
        DECLARE
            old_called BOOLEAN;
        BEGIN
            old_called := called_from_package;
            called_from_package := TRUE;
            validate_foreign_keys_upd(cg$rec, cg$old_rec, cg$ind);
            validate_arc(cg$rec);
            validate_domain(cg$rec, cg$ind);
            slct(cg$old_rec);
            IF cg$rec.the_rowid is null THEN
            UPDATE DATA_ELEMENT_CONCEPTS_VIEW
            SET
              OC_IDSEQ = cg$rec.OC_IDSEQ
              ,VERSION = cg$rec.VERSION
              ,PREFERRED_NAME = cg$rec.PREFERRED_NAME
              ,CONTE_IDSEQ = cg$rec.CONTE_IDSEQ
              ,CD_IDSEQ = cg$rec.CD_IDSEQ
              ,PROPL_NAME = cg$rec.PROPL_NAME
              ,OCL_NAME = cg$rec.OCL_NAME
              ,PREFERRED_DEFINITION = cg$rec.PREFERRED_DEFINITION
              ,ASL_NAME = cg$rec.ASL_NAME
              ,LONG_NAME = cg$rec.LONG_NAME
              ,LATEST_VERSION_IND = cg$rec.LATEST_VERSION_IND
              ,DELETED_IND = cg$rec.DELETED_IND
              ,DATE_CREATED = cg$rec.DATE_CREATED
              ,BEGIN_DATE = cg$rec.BEGIN_DATE
              ,CREATED_BY = cg$rec.CREATED_BY
              ,END_DATE = cg$rec.END_DATE
              ,DATE_MODIFIED = cg$rec.DATE_MODIFIED
              ,MODIFIED_BY = cg$rec.MODIFIED_BY
              ,OBJ_CLASS_QUALIFIER = cg$rec.OBJ_CLASS_QUALIFIER
              ,PROPERTY_QUALIFIER = cg$rec.PROPERTY_QUALIFIER
              ,CHANGE_NOTE = cg$rec.CHANGE_NOTE
              ,PROP_IDSEQ = cg$rec.PROP_IDSEQ
              ,ORIGIN = cg$rec.ORIGIN
              ,DEC_ID = cg$rec.DEC_ID
              WHERE  DEC_IDSEQ = cg$rec.DEC_IDSEQ;
               null;
            ELSE
            UPDATE DATA_ELEMENT_CONCEPTS_VIEW
            SET
              OC_IDSEQ = cg$rec.OC_IDSEQ
              ,VERSION = cg$rec.VERSION
              ,PREFERRED_NAME = cg$rec.PREFERRED_NAME
              ,CONTE_IDSEQ = cg$rec.CONTE_IDSEQ
              ,CD_IDSEQ = cg$rec.CD_IDSEQ
              ,PROPL_NAME = cg$rec.PROPL_NAME
              ,OCL_NAME = cg$rec.OCL_NAME
              ,PREFERRED_DEFINITION = cg$rec.PREFERRED_DEFINITION
              ,ASL_NAME = cg$rec.ASL_NAME
              ,LONG_NAME = cg$rec.LONG_NAME
              ,LATEST_VERSION_IND = cg$rec.LATEST_VERSION_IND
              ,DELETED_IND = cg$rec.DELETED_IND
              ,DATE_CREATED = cg$rec.DATE_CREATED
              ,BEGIN_DATE = cg$rec.BEGIN_DATE
              ,CREATED_BY = cg$rec.CREATED_BY
              ,END_DATE = cg$rec.END_DATE
              ,DATE_MODIFIED = cg$rec.DATE_MODIFIED
              ,MODIFIED_BY = cg$rec.MODIFIED_BY
              ,OBJ_CLASS_QUALIFIER = cg$rec.OBJ_CLASS_QUALIFIER
              ,PROPERTY_QUALIFIER = cg$rec.PROPERTY_QUALIFIER
              ,CHANGE_NOTE = cg$rec.CHANGE_NOTE
              ,PROP_IDSEQ = cg$rec.PROP_IDSEQ
              ,ORIGIN = cg$rec.ORIGIN
              ,DEC_ID = cg$rec.DEC_ID
        WHERE rowid = cg$rec.the_rowid;
               null;
            END IF;
            slct(cg$rec);
            upd_denorm2(cg$rec, cg$ind);
            upd_oper_denorm2(cg$rec, cg$old_rec, cg$ind, 'UPD');
            cascade_update(cg$rec, cg$old_rec);
            called_from_package := old_called;
        END;
    END IF;
    IF NOT (do_upd) THEN
        cg$table(idx).OC_IDSEQ := cg$rec.OC_IDSEQ;
        cg$tableind(idx).OC_IDSEQ := cg$ind.OC_IDSEQ;
        cg$table(idx).DEC_IDSEQ := cg$rec.DEC_IDSEQ;
        cg$tableind(idx).DEC_IDSEQ := cg$ind.DEC_IDSEQ;
        cg$table(idx).VERSION := cg$rec.VERSION;
        cg$tableind(idx).VERSION := cg$ind.VERSION;
        cg$table(idx).PREFERRED_NAME := cg$rec.PREFERRED_NAME;
        cg$tableind(idx).PREFERRED_NAME := cg$ind.PREFERRED_NAME;
        cg$table(idx).CONTE_IDSEQ := cg$rec.CONTE_IDSEQ;
        cg$tableind(idx).CONTE_IDSEQ := cg$ind.CONTE_IDSEQ;
        cg$table(idx).CD_IDSEQ := cg$rec.CD_IDSEQ;
        cg$tableind(idx).CD_IDSEQ := cg$ind.CD_IDSEQ;
        cg$table(idx).PROPL_NAME := cg$rec.PROPL_NAME;
        cg$tableind(idx).PROPL_NAME := cg$ind.PROPL_NAME;
        cg$table(idx).OCL_NAME := cg$rec.OCL_NAME;
        cg$tableind(idx).OCL_NAME := cg$ind.OCL_NAME;
        cg$table(idx).PREFERRED_DEFINITION := cg$rec.PREFERRED_DEFINITION;
        cg$tableind(idx).PREFERRED_DEFINITION := cg$ind.PREFERRED_DEFINITION;
        cg$table(idx).ASL_NAME := cg$rec.ASL_NAME;
        cg$tableind(idx).ASL_NAME := cg$ind.ASL_NAME;
        cg$table(idx).LONG_NAME := cg$rec.LONG_NAME;
        cg$tableind(idx).LONG_NAME := cg$ind.LONG_NAME;
        cg$table(idx).LATEST_VERSION_IND := cg$rec.LATEST_VERSION_IND;
        cg$tableind(idx).LATEST_VERSION_IND := cg$ind.LATEST_VERSION_IND;
        cg$table(idx).DELETED_IND := cg$rec.DELETED_IND;
        cg$tableind(idx).DELETED_IND := cg$ind.DELETED_IND;
        cg$table(idx).DATE_CREATED := cg$rec.DATE_CREATED;
        cg$tableind(idx).DATE_CREATED := cg$ind.DATE_CREATED;
        cg$table(idx).BEGIN_DATE := cg$rec.BEGIN_DATE;
        cg$tableind(idx).BEGIN_DATE := cg$ind.BEGIN_DATE;
        cg$table(idx).CREATED_BY := cg$rec.CREATED_BY;
        cg$tableind(idx).CREATED_BY := cg$ind.CREATED_BY;
        cg$table(idx).END_DATE := cg$rec.END_DATE;
        cg$tableind(idx).END_DATE := cg$ind.END_DATE;
        cg$table(idx).DATE_MODIFIED := cg$rec.DATE_MODIFIED;
        cg$tableind(idx).DATE_MODIFIED := cg$ind.DATE_MODIFIED;
        cg$table(idx).MODIFIED_BY := cg$rec.MODIFIED_BY;
        cg$tableind(idx).MODIFIED_BY := cg$ind.MODIFIED_BY;
        cg$table(idx).OBJ_CLASS_QUALIFIER := cg$rec.OBJ_CLASS_QUALIFIER;
        cg$tableind(idx).OBJ_CLASS_QUALIFIER := cg$ind.OBJ_CLASS_QUALIFIER;
        cg$table(idx).PROPERTY_QUALIFIER := cg$rec.PROPERTY_QUALIFIER;
        cg$tableind(idx).PROPERTY_QUALIFIER := cg$ind.PROPERTY_QUALIFIER;
        cg$table(idx).CHANGE_NOTE := cg$rec.CHANGE_NOTE;
        cg$tableind(idx).CHANGE_NOTE := cg$ind.CHANGE_NOTE;
        cg$table(idx).PROP_IDSEQ := cg$rec.PROP_IDSEQ;
        cg$tableind(idx).PROP_IDSEQ := cg$ind.PROP_IDSEQ;
        cg$table(idx).ORIGIN := cg$rec.ORIGIN;
        cg$tableind(idx).ORIGIN := cg$ind.ORIGIN;
        cg$table(idx).DEC_ID := cg$rec.DEC_ID;
        cg$tableind(idx).DEC_ID := cg$ind.DEC_ID;
        idx := idx + 1;
    END IF;
--  Application_logic Post-Update <<Start>>
--  Application_logic Post-Update << End >>

EXCEPTION
    WHEN cg$errors.cg$error THEN
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN cg$errors.upd_mandatory_null THEN
        validate_mandatory(cg$rec, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.upd.upd_mandatory_null');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN cg$errors.check_violation THEN
        err_msg(SQLERRM, cg$errors.ERR_CHECK_CON, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.upd.check_violation');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN cg$errors.fk_violation THEN
        err_msg(SQLERRM, cg$errors.ERR_FOREIGN_KEY, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.upd.fk_violation');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN cg$errors.uk_violation THEN
        err_msg(SQLERRM, cg$errors.ERR_UNIQUE_KEY, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.upd.uk_violation');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN OTHERS THEN
        cg$errors.push(SQLERRM,
                       'E',
                       'ORA',
                       SQLCODE,
                       'cg$DATA_ELEMENT_CONCEPTS_VIEW.upd.others');
        called_from_package := FALSE;
        cg$errors.raise_failure;
END upd;


--------------------------------------------------------------------------------
-- Name:        del
--
-- Description: API delete procedure
--
-- Parameters:  cg$pk  Primary key record of row to be deleted
--------------------------------------------------------------------------------
PROCEDURE del(cg$pk IN cg$pk_type,
              do_del IN BOOLEAN DEFAULT TRUE) IS
BEGIN
--  Application_logic Pre-Delete <<Start>>
--  Application_logic Pre-Delete << End >>
--  Delete the record
    called_from_package := TRUE;
    IF (do_del) THEN
        DECLARE
           cg$rec cg$row_type;
           cg$old_rec cg$row_type;
           cg$ind cg$ind_type;
        BEGIN
           cg$rec.DEC_IDSEQ := cg$pk.DEC_IDSEQ;
           slct(cg$rec);
           validate_foreign_keys_del(cg$rec);
           domain_cascade_delete(cg$rec);
           IF cg$pk.the_rowid is null THEN
              DELETE DATA_ELEMENT_CONCEPTS_VIEW
              WHERE                    DEC_IDSEQ = cg$pk.DEC_IDSEQ;
           ELSE
              DELETE DATA_ELEMENT_CONCEPTS_VIEW
              WHERE  rowid = cg$pk.the_rowid;
           END IF;
           upd_oper_denorm2(cg$rec, cg$old_rec, cg$ind, 'DEL');
           cascade_delete(cg$rec);
        END;
    END IF;
    called_from_package := FALSE;
--  Application_logic Post-Delete <<Start>>
--  Application_logic Post-Delete << End >>
EXCEPTION
    WHEN cg$errors.cg$error THEN
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN cg$errors.delete_restrict THEN
        err_msg(SQLERRM, cg$errors.ERR_DELETE_RESTRICT, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.del.delete_restrict');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN no_data_found THEN
        cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_DEL, cg$errors.ROW_DEL),
                       'E',
                       'ORA',
                       SQLCODE,
                       'cg$DATA_ELEMENT_CONCEPTS_VIEW.del.no_data_found');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN OTHERS THEN
        cg$errors.push(SQLERRM,
                       'E',
                       'ORA',
                       SQLCODE,
                       'cg$DATA_ELEMENT_CONCEPTS_VIEW.del.others');
        called_from_package := FALSE;
        cg$errors.raise_failure;
END del;


--------------------------------------------------------------------------------
-- Name:        lck
--
-- Description: API lock procedure
--
-- Parameters:  cg$old_rec  Calling apps view of record of row to be locked
--              cg$old_ind  Record of columns to raise error if modified
--              nowait_flag TRUE lock with NOWAIT, FALSE don't fail if busy
--------------------------------------------------------------------------------
PROCEDURE lck(cg$old_rec IN cg$row_type,
              cg$old_ind IN cg$ind_type,
              nowait_flag IN BOOLEAN DEFAULT TRUE) IS
cg$tmp_rec cg$row_type;
any_modified BOOLEAN := FALSE;
BEGIN
--  Application_logic Pre-Lock <<Start>>
--  Application_logic Pre-Lock << End >>
--  Do the row lock
    BEGIN
        IF (nowait_flag) THEN
            IF cg$old_rec.the_rowid is null THEN
               SELECT       OC_IDSEQ
               ,            DEC_IDSEQ
               ,            VERSION
               ,            PREFERRED_NAME
               ,            CONTE_IDSEQ
               ,            CD_IDSEQ
               ,            PROPL_NAME
               ,            OCL_NAME
               ,            PREFERRED_DEFINITION
               ,            ASL_NAME
               ,            LONG_NAME
               ,            LATEST_VERSION_IND
               ,            DELETED_IND
               ,            DATE_CREATED
               ,            BEGIN_DATE
               ,            CREATED_BY
               ,            END_DATE
               ,            DATE_MODIFIED
               ,            MODIFIED_BY
               ,            OBJ_CLASS_QUALIFIER
               ,            PROPERTY_QUALIFIER
               ,            CHANGE_NOTE
               ,            PROP_IDSEQ
               ,            ORIGIN
               ,            DEC_ID
               INTO         cg$tmp_rec.OC_IDSEQ
               ,            cg$tmp_rec.DEC_IDSEQ
               ,            cg$tmp_rec.VERSION
               ,            cg$tmp_rec.PREFERRED_NAME
               ,            cg$tmp_rec.CONTE_IDSEQ
               ,            cg$tmp_rec.CD_IDSEQ
               ,            cg$tmp_rec.PROPL_NAME
               ,            cg$tmp_rec.OCL_NAME
               ,            cg$tmp_rec.PREFERRED_DEFINITION
               ,            cg$tmp_rec.ASL_NAME
               ,            cg$tmp_rec.LONG_NAME
               ,            cg$tmp_rec.LATEST_VERSION_IND
               ,            cg$tmp_rec.DELETED_IND
               ,            cg$tmp_rec.DATE_CREATED
               ,            cg$tmp_rec.BEGIN_DATE
               ,            cg$tmp_rec.CREATED_BY
               ,            cg$tmp_rec.END_DATE
               ,            cg$tmp_rec.DATE_MODIFIED
               ,            cg$tmp_rec.MODIFIED_BY
               ,            cg$tmp_rec.OBJ_CLASS_QUALIFIER
               ,            cg$tmp_rec.PROPERTY_QUALIFIER
               ,            cg$tmp_rec.CHANGE_NOTE
               ,            cg$tmp_rec.PROP_IDSEQ
               ,            cg$tmp_rec.ORIGIN
               ,            cg$tmp_rec.DEC_ID
               FROM      DATA_ELEMENT_CONCEPTS_VIEW
               WHERE              DEC_IDSEQ = cg$old_rec.DEC_IDSEQ
               FOR UPDATE NOWAIT;
            ELSE
               SELECT       OC_IDSEQ
               ,            DEC_IDSEQ
               ,            VERSION
               ,            PREFERRED_NAME
               ,            CONTE_IDSEQ
               ,            CD_IDSEQ
               ,            PROPL_NAME
               ,            OCL_NAME
               ,            PREFERRED_DEFINITION
               ,            ASL_NAME
               ,            LONG_NAME
               ,            LATEST_VERSION_IND
               ,            DELETED_IND
               ,            DATE_CREATED
               ,            BEGIN_DATE
               ,            CREATED_BY
               ,            END_DATE
               ,            DATE_MODIFIED
               ,            MODIFIED_BY
               ,            OBJ_CLASS_QUALIFIER
               ,            PROPERTY_QUALIFIER
               ,            CHANGE_NOTE
               ,            PROP_IDSEQ
               ,            ORIGIN
               ,            DEC_ID
               INTO         cg$tmp_rec.OC_IDSEQ
               ,            cg$tmp_rec.DEC_IDSEQ
               ,            cg$tmp_rec.VERSION
               ,            cg$tmp_rec.PREFERRED_NAME
               ,            cg$tmp_rec.CONTE_IDSEQ
               ,            cg$tmp_rec.CD_IDSEQ
               ,            cg$tmp_rec.PROPL_NAME
               ,            cg$tmp_rec.OCL_NAME
               ,            cg$tmp_rec.PREFERRED_DEFINITION
               ,            cg$tmp_rec.ASL_NAME
               ,            cg$tmp_rec.LONG_NAME
               ,            cg$tmp_rec.LATEST_VERSION_IND
               ,            cg$tmp_rec.DELETED_IND
               ,            cg$tmp_rec.DATE_CREATED
               ,            cg$tmp_rec.BEGIN_DATE
               ,            cg$tmp_rec.CREATED_BY
               ,            cg$tmp_rec.END_DATE
               ,            cg$tmp_rec.DATE_MODIFIED
               ,            cg$tmp_rec.MODIFIED_BY
               ,            cg$tmp_rec.OBJ_CLASS_QUALIFIER
               ,            cg$tmp_rec.PROPERTY_QUALIFIER
               ,            cg$tmp_rec.CHANGE_NOTE
               ,            cg$tmp_rec.PROP_IDSEQ
               ,            cg$tmp_rec.ORIGIN
               ,            cg$tmp_rec.DEC_ID
               FROM      DATA_ELEMENT_CONCEPTS_VIEW
               WHERE rowid = cg$old_rec.the_rowid
               FOR UPDATE NOWAIT;
            END IF;
        ELSE
            IF cg$old_rec.the_rowid is null THEN
               SELECT       OC_IDSEQ
               ,            DEC_IDSEQ
               ,            VERSION
               ,            PREFERRED_NAME
               ,            CONTE_IDSEQ
               ,            CD_IDSEQ
               ,            PROPL_NAME
               ,            OCL_NAME
               ,            PREFERRED_DEFINITION
               ,            ASL_NAME
               ,            LONG_NAME
               ,            LATEST_VERSION_IND
               ,            DELETED_IND
               ,            DATE_CREATED
               ,            BEGIN_DATE
               ,            CREATED_BY
               ,            END_DATE
               ,            DATE_MODIFIED
               ,            MODIFIED_BY
               ,            OBJ_CLASS_QUALIFIER
               ,            PROPERTY_QUALIFIER
               ,            CHANGE_NOTE
               ,            PROP_IDSEQ
               ,            ORIGIN
               ,            DEC_ID
               INTO         cg$tmp_rec.OC_IDSEQ
               ,            cg$tmp_rec.DEC_IDSEQ
               ,            cg$tmp_rec.VERSION
               ,            cg$tmp_rec.PREFERRED_NAME
               ,            cg$tmp_rec.CONTE_IDSEQ
               ,            cg$tmp_rec.CD_IDSEQ
               ,            cg$tmp_rec.PROPL_NAME
               ,            cg$tmp_rec.OCL_NAME
               ,            cg$tmp_rec.PREFERRED_DEFINITION
               ,            cg$tmp_rec.ASL_NAME
               ,            cg$tmp_rec.LONG_NAME
               ,            cg$tmp_rec.LATEST_VERSION_IND
               ,            cg$tmp_rec.DELETED_IND
               ,            cg$tmp_rec.DATE_CREATED
               ,            cg$tmp_rec.BEGIN_DATE
               ,            cg$tmp_rec.CREATED_BY
               ,            cg$tmp_rec.END_DATE
               ,            cg$tmp_rec.DATE_MODIFIED
               ,            cg$tmp_rec.MODIFIED_BY
               ,            cg$tmp_rec.OBJ_CLASS_QUALIFIER
               ,            cg$tmp_rec.PROPERTY_QUALIFIER
               ,            cg$tmp_rec.CHANGE_NOTE
               ,            cg$tmp_rec.PROP_IDSEQ
               ,            cg$tmp_rec.ORIGIN
               ,            cg$tmp_rec.DEC_ID
               FROM      DATA_ELEMENT_CONCEPTS_VIEW
               WHERE              DEC_IDSEQ = cg$old_rec.DEC_IDSEQ
               FOR UPDATE;
            ELSE
               SELECT       OC_IDSEQ
               ,            DEC_IDSEQ
               ,            VERSION
               ,            PREFERRED_NAME
               ,            CONTE_IDSEQ
               ,            CD_IDSEQ
               ,            PROPL_NAME
               ,            OCL_NAME
               ,            PREFERRED_DEFINITION
               ,            ASL_NAME
               ,            LONG_NAME
               ,            LATEST_VERSION_IND
               ,            DELETED_IND
               ,            DATE_CREATED
               ,            BEGIN_DATE
               ,            CREATED_BY
               ,            END_DATE
               ,            DATE_MODIFIED
               ,            MODIFIED_BY
               ,            OBJ_CLASS_QUALIFIER
               ,            PROPERTY_QUALIFIER
               ,            CHANGE_NOTE
               ,            PROP_IDSEQ
               ,            ORIGIN
               ,            DEC_ID
               INTO         cg$tmp_rec.OC_IDSEQ
               ,            cg$tmp_rec.DEC_IDSEQ
               ,            cg$tmp_rec.VERSION
               ,            cg$tmp_rec.PREFERRED_NAME
               ,            cg$tmp_rec.CONTE_IDSEQ
               ,            cg$tmp_rec.CD_IDSEQ
               ,            cg$tmp_rec.PROPL_NAME
               ,            cg$tmp_rec.OCL_NAME
               ,            cg$tmp_rec.PREFERRED_DEFINITION
               ,            cg$tmp_rec.ASL_NAME
               ,            cg$tmp_rec.LONG_NAME
               ,            cg$tmp_rec.LATEST_VERSION_IND
               ,            cg$tmp_rec.DELETED_IND
               ,            cg$tmp_rec.DATE_CREATED
               ,            cg$tmp_rec.BEGIN_DATE
               ,            cg$tmp_rec.CREATED_BY
               ,            cg$tmp_rec.END_DATE
               ,            cg$tmp_rec.DATE_MODIFIED
               ,            cg$tmp_rec.MODIFIED_BY
               ,            cg$tmp_rec.OBJ_CLASS_QUALIFIER
               ,            cg$tmp_rec.PROPERTY_QUALIFIER
               ,            cg$tmp_rec.CHANGE_NOTE
               ,            cg$tmp_rec.PROP_IDSEQ
               ,            cg$tmp_rec.ORIGIN
               ,            cg$tmp_rec.DEC_ID
               FROM      DATA_ELEMENT_CONCEPTS_VIEW
               WHERE rowid = cg$old_rec.the_rowid
               FOR UPDATE;
            END IF;
        END IF;
    EXCEPTION
        WHEN cg$errors.cg$error THEN
            cg$errors.raise_failure;
        WHEN cg$errors.resource_busy THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_LCK, cg$errors.ROW_LCK),
                           'E',
                           'ORA',
                           SQLCODE,
                           'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck.resource_busy');
            cg$errors.raise_failure;
        WHEN no_data_found THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_DEL, cg$errors.ROW_DEL),
                           'E',
                           'ORA',
                           SQLCODE,
                           'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck.no_data_found');
            cg$errors.raise_failure;
        WHEN OTHERS THEN
            cg$errors.push(SQLERRM,
                           'E',
                           'ORA',
                           SQLCODE,
                           'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck.others');
            cg$errors.raise_failure;
    END;
-- Optional Columns
    IF (cg$old_ind.OC_IDSEQ) THEN
        IF (cg$tmp_rec.OC_IDSEQ IS NOT NULL
        AND cg$old_rec.OC_IDSEQ IS NOT NULL) THEN
            IF (cg$tmp_rec.OC_IDSEQ != cg$old_rec.OC_IDSEQ) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P5OC_IDSEQ
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.OC_IDSEQ IS NOT NULL
        OR cg$old_rec.OC_IDSEQ IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P5OC_IDSEQ
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.PROPL_NAME) THEN
        IF (cg$tmp_rec.PROPL_NAME IS NOT NULL
        AND cg$old_rec.PROPL_NAME IS NOT NULL) THEN
            IF (cg$tmp_rec.PROPL_NAME != cg$old_rec.PROPL_NAME) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P28PROPL_NAME
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.PROPL_NAME IS NOT NULL
        OR cg$old_rec.PROPL_NAME IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P28PROPL_NAME
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.OCL_NAME) THEN
        IF (cg$tmp_rec.OCL_NAME IS NOT NULL
        AND cg$old_rec.OCL_NAME IS NOT NULL) THEN
            IF (cg$tmp_rec.OCL_NAME != cg$old_rec.OCL_NAME) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P30OCL_NAME
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.OCL_NAME IS NOT NULL
        OR cg$old_rec.OCL_NAME IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P30OCL_NAME
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.LONG_NAME) THEN
        IF (cg$tmp_rec.LONG_NAME IS NOT NULL
        AND cg$old_rec.LONG_NAME IS NOT NULL) THEN
            IF (cg$tmp_rec.LONG_NAME != cg$old_rec.LONG_NAME) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P45LONG_NAME
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.LONG_NAME IS NOT NULL
        OR cg$old_rec.LONG_NAME IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P45LONG_NAME
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.LATEST_VERSION_IND) THEN
        IF (cg$tmp_rec.LATEST_VERSION_IND IS NOT NULL
        AND cg$old_rec.LATEST_VERSION_IND IS NOT NULL) THEN
            IF (cg$tmp_rec.LATEST_VERSION_IND != cg$old_rec.LATEST_VERSION_IND) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P47LATEST_VERSION_IND
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.LATEST_VERSION_IND IS NOT NULL
        OR cg$old_rec.LATEST_VERSION_IND IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P47LATEST_VERSION_IND
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.DELETED_IND) THEN
        IF (cg$tmp_rec.DELETED_IND IS NOT NULL
        AND cg$old_rec.DELETED_IND IS NOT NULL) THEN
            IF (cg$tmp_rec.DELETED_IND != cg$old_rec.DELETED_IND) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P48DELETED_IND
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.DELETED_IND IS NOT NULL
        OR cg$old_rec.DELETED_IND IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P48DELETED_IND
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.BEGIN_DATE) THEN
        IF (cg$tmp_rec.BEGIN_DATE IS NOT NULL
        AND cg$old_rec.BEGIN_DATE IS NOT NULL) THEN
            IF (cg$tmp_rec.BEGIN_DATE != cg$old_rec.BEGIN_DATE) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P60BEGIN_DATE
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.BEGIN_DATE IS NOT NULL
        OR cg$old_rec.BEGIN_DATE IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P60BEGIN_DATE
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.END_DATE) THEN
        IF (cg$tmp_rec.END_DATE IS NOT NULL
        AND cg$old_rec.END_DATE IS NOT NULL) THEN
            IF (cg$tmp_rec.END_DATE != cg$old_rec.END_DATE) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P65END_DATE
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.END_DATE IS NOT NULL
        OR cg$old_rec.END_DATE IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P65END_DATE
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.DATE_MODIFIED) THEN
        IF (cg$tmp_rec.DATE_MODIFIED IS NOT NULL
        AND cg$old_rec.DATE_MODIFIED IS NOT NULL) THEN
            IF (cg$tmp_rec.DATE_MODIFIED != cg$old_rec.DATE_MODIFIED) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P70DATE_MODIFIED
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.DATE_MODIFIED IS NOT NULL
        OR cg$old_rec.DATE_MODIFIED IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P70DATE_MODIFIED
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.MODIFIED_BY) THEN
        IF (cg$tmp_rec.MODIFIED_BY IS NOT NULL
        AND cg$old_rec.MODIFIED_BY IS NOT NULL) THEN
            IF (cg$tmp_rec.MODIFIED_BY != cg$old_rec.MODIFIED_BY) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P80MODIFIED_BY
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.MODIFIED_BY IS NOT NULL
        OR cg$old_rec.MODIFIED_BY IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P80MODIFIED_BY
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.OBJ_CLASS_QUALIFIER) THEN
        IF (cg$tmp_rec.OBJ_CLASS_QUALIFIER IS NOT NULL
        AND cg$old_rec.OBJ_CLASS_QUALIFIER IS NOT NULL) THEN
            IF (cg$tmp_rec.OBJ_CLASS_QUALIFIER != cg$old_rec.OBJ_CLASS_QUALIFIER) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P90OBJ_CLASS_QUALIFIER
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.OBJ_CLASS_QUALIFIER IS NOT NULL
        OR cg$old_rec.OBJ_CLASS_QUALIFIER IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P90OBJ_CLASS_QUALIFIER
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.PROPERTY_QUALIFIER) THEN
        IF (cg$tmp_rec.PROPERTY_QUALIFIER IS NOT NULL
        AND cg$old_rec.PROPERTY_QUALIFIER IS NOT NULL) THEN
            IF (cg$tmp_rec.PROPERTY_QUALIFIER != cg$old_rec.PROPERTY_QUALIFIER) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P100PROPERTY_QUALIFIER
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.PROPERTY_QUALIFIER IS NOT NULL
        OR cg$old_rec.PROPERTY_QUALIFIER IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P100PROPERTY_QUALIFIER
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.CHANGE_NOTE) THEN
        IF (cg$tmp_rec.CHANGE_NOTE IS NOT NULL
        AND cg$old_rec.CHANGE_NOTE IS NOT NULL) THEN
            IF (cg$tmp_rec.CHANGE_NOTE != cg$old_rec.CHANGE_NOTE) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P110CHANGE_NOTE
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.CHANGE_NOTE IS NOT NULL
        OR cg$old_rec.CHANGE_NOTE IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P110CHANGE_NOTE
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.PROP_IDSEQ) THEN
        IF (cg$tmp_rec.PROP_IDSEQ IS NOT NULL
        AND cg$old_rec.PROP_IDSEQ IS NOT NULL) THEN
            IF (cg$tmp_rec.PROP_IDSEQ != cg$old_rec.PROP_IDSEQ) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P120PROP_IDSEQ
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.PROP_IDSEQ IS NOT NULL
        OR cg$old_rec.PROP_IDSEQ IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P120PROP_IDSEQ
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.ORIGIN) THEN
        IF (cg$tmp_rec.ORIGIN IS NOT NULL
        AND cg$old_rec.ORIGIN IS NOT NULL) THEN
            IF (cg$tmp_rec.ORIGIN != cg$old_rec.ORIGIN) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P130ORIGIN
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.ORIGIN IS NOT NULL
        OR cg$old_rec.ORIGIN IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P130ORIGIN
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.DEC_ID) THEN
        IF (cg$tmp_rec.DEC_ID IS NOT NULL
        AND cg$old_rec.DEC_ID IS NOT NULL) THEN
            IF (cg$tmp_rec.DEC_ID != cg$old_rec.DEC_ID) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P140DEC_ID
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.DEC_ID IS NOT NULL
        OR cg$old_rec.DEC_ID IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P140DEC_ID
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
-- Mandatory Columns
    IF (cg$old_ind.DEC_IDSEQ) THEN
        IF (cg$tmp_rec.DEC_IDSEQ != cg$old_rec.DEC_IDSEQ) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P10DEC_IDSEQ
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.VERSION) THEN
        IF (cg$tmp_rec.VERSION != cg$old_rec.VERSION) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P15VERSION
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.PREFERRED_NAME) THEN
        IF (cg$tmp_rec.PREFERRED_NAME != cg$old_rec.PREFERRED_NAME) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P20PREFERRED_NAME
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.CONTE_IDSEQ) THEN
        IF (cg$tmp_rec.CONTE_IDSEQ != cg$old_rec.CONTE_IDSEQ) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P25CONTE_IDSEQ
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.CD_IDSEQ) THEN
        IF (cg$tmp_rec.CD_IDSEQ != cg$old_rec.CD_IDSEQ) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P27CD_IDSEQ
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.PREFERRED_DEFINITION) THEN
        IF (cg$tmp_rec.PREFERRED_DEFINITION != cg$old_rec.PREFERRED_DEFINITION) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P40PREFERRED_DEFINITION
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.ASL_NAME) THEN
        IF (cg$tmp_rec.ASL_NAME != cg$old_rec.ASL_NAME) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P42ASL_NAME
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.DATE_CREATED) THEN
        IF (cg$tmp_rec.DATE_CREATED != cg$old_rec.DATE_CREATED) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P50DATE_CREATED
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.CREATED_BY) THEN
        IF (cg$tmp_rec.CREATED_BY != cg$old_rec.CREATED_BY) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P60CREATED_BY
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$DATA_ELEMENT_CONCEPTS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (any_modified) THEN
        cg$errors.raise_failure;
    END IF;
--  Application_logic Post-Lock <<Start>>
--  Application_logic Post-Lock << End >>
END lck;


BEGIN
      cg$ind_true.OC_IDSEQ := TRUE;
      cg$ind_true.DEC_IDSEQ := TRUE;
      cg$ind_true.VERSION := TRUE;
      cg$ind_true.PREFERRED_NAME := TRUE;
      cg$ind_true.CONTE_IDSEQ := TRUE;
      cg$ind_true.CD_IDSEQ := TRUE;
      cg$ind_true.PROPL_NAME := TRUE;
      cg$ind_true.OCL_NAME := TRUE;
      cg$ind_true.PREFERRED_DEFINITION := TRUE;
      cg$ind_true.ASL_NAME := TRUE;
      cg$ind_true.LONG_NAME := TRUE;
      cg$ind_true.LATEST_VERSION_IND := TRUE;
      cg$ind_true.DELETED_IND := TRUE;
      cg$ind_true.DATE_CREATED := TRUE;
      cg$ind_true.BEGIN_DATE := TRUE;
      cg$ind_true.CREATED_BY := TRUE;
      cg$ind_true.END_DATE := TRUE;
      cg$ind_true.DATE_MODIFIED := TRUE;
      cg$ind_true.MODIFIED_BY := TRUE;
      cg$ind_true.OBJ_CLASS_QUALIFIER := TRUE;
      cg$ind_true.PROPERTY_QUALIFIER := TRUE;
      cg$ind_true.CHANGE_NOTE := TRUE;
      cg$ind_true.PROP_IDSEQ := TRUE;
      cg$ind_true.ORIGIN := TRUE;
      cg$ind_true.DEC_ID := TRUE;

END cg$DATA_ELEMENT_CONCEPTS_VIEW;
/
