create or replace PACKAGE BODY "CG$VD_PVS_VIEW" IS
PROCEDURE   validate_mandatory(cg$val_rec IN cg$row_type,
                               loc        IN VARCHAR2 DEFAULT '');
PROCEDURE   up_autogen_columns(cg$rec    IN OUT cg$row_type,
                               cg$ind    IN OUT cg$ind_type,
                               operation IN VARCHAR2 DEFAULT 'INS',
                               do_denorm IN BOOLEAN DEFAULT TRUE);
PROCEDURE   err_msg(msg  IN VARCHAR2,
                    type IN INTEGER,
                    loc  IN VARCHAR2 DEFAULT '');
PROCEDURE   uk_key_updateable(uk IN VARCHAR2);
PROCEDURE   fk_key_transferable(fk IN VARCHAR2);
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
    cg$rec.CREATED_BY := user;
    cg$rec.CREATED_BY := user;
        NULL;
    ELSE
NULL;
    END IF;
    cg$rec.DATE_MODIFIED := trunc(sysdate);
    cg$rec.MODIFIED_BY := user;
EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        cg$errors.push(SQLERRM,
                      'E',
                      'ORA',
                      SQLCODE,
                      'cg$VD_PVS_VIEW.up_autogen_columns.denorm');
        cg$errors.raise_failure;
END up_autogen_columns;
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
    IF (cg$val_rec.VP_IDSEQ IS NULL) THEN
        cg$errors.push(cg$errors.MsgGetText(cg$errors.API_MAND_COLUMN_ISNULL, cg$errors.VAL_MAND, P10VP_IDSEQ),
                       'E',
                       'API',
                       cg$errors.API_MAND_COLUMN_ISNULL,
                       loc);
    END IF;
    IF (cg$val_rec.VD_IDSEQ IS NULL) THEN
        cg$errors.push(cg$errors.MsgGetText(cg$errors.API_MAND_COLUMN_ISNULL, cg$errors.VAL_MAND, P20VD_IDSEQ),
                       'E',
                       'API',
                       cg$errors.API_MAND_COLUMN_ISNULL,
                       loc);
    END IF;
    IF (cg$val_rec.PV_IDSEQ IS NULL) THEN
        cg$errors.push(cg$errors.MsgGetText(cg$errors.API_MAND_COLUMN_ISNULL, cg$errors.VAL_MAND, P25PV_IDSEQ),
                       'E',
                       'API',
                       cg$errors.API_MAND_COLUMN_ISNULL,
                       loc);
    END IF;
    IF (cg$val_rec.DATE_CREATED IS NULL) THEN
        cg$errors.push(cg$errors.MsgGetText(cg$errors.API_MAND_COLUMN_ISNULL, cg$errors.VAL_MAND, P30DATE_CREATED),
                       'E',
                       'API',
                       cg$errors.API_MAND_COLUMN_ISNULL,
                       loc);
    END IF;
    IF (cg$val_rec.CREATED_BY IS NULL) THEN
        cg$errors.push(cg$errors.MsgGetText(cg$errors.API_MAND_COLUMN_ISNULL, cg$errors.VAL_MAND, P40CREATED_BY),
                       'E',
                       'API',
                       cg$errors.API_MAND_COLUMN_ISNULL,
                       loc);
    END IF;
    NULL;
END validate_mandatory;
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
-- Name:        slct
--
-- Description: Selects into the given parameter all the attributes for the row
--              given by the primary key
--
-- Parameters:  cg$sel_rec  Record of row to be selected into using its PK
--------------------------------------------------------------------------------
PROCEDURE slct(cg$sel_rec IN OUT cg$row_type) IS
BEGIN
    IF cg$sel_rec.the_rowid is null THEN
       SELECT    CON_IDSEQ
       ,         VP_IDSEQ
       ,         VD_IDSEQ
       ,         PV_IDSEQ
       ,         CONTE_IDSEQ
       ,         DATE_CREATED
       ,         CREATED_BY
       ,         DATE_MODIFIED
       ,         MODIFIED_BY
       ,         ORIGIN
       ,         BEGIN_DATE
       ,         END_DATE
       , rowid
       INTO      cg$sel_rec.CON_IDSEQ
       ,         cg$sel_rec.VP_IDSEQ
       ,         cg$sel_rec.VD_IDSEQ
       ,         cg$sel_rec.PV_IDSEQ
       ,         cg$sel_rec.CONTE_IDSEQ
       ,         cg$sel_rec.DATE_CREATED
       ,         cg$sel_rec.CREATED_BY
       ,         cg$sel_rec.DATE_MODIFIED
       ,         cg$sel_rec.MODIFIED_BY
       ,         cg$sel_rec.ORIGIN
       ,         cg$sel_rec.BEGIN_DATE
       ,         cg$sel_rec.END_DATE
       ,cg$sel_rec.the_rowid
       FROM   VD_PVS_VIEW
       WHERE        VP_IDSEQ = cg$sel_rec.VP_IDSEQ;
    ELSE
       SELECT    CON_IDSEQ
       ,         VP_IDSEQ
       ,         VD_IDSEQ
       ,         PV_IDSEQ
       ,         CONTE_IDSEQ
       ,         DATE_CREATED
       ,         CREATED_BY
       ,         DATE_MODIFIED
       ,         MODIFIED_BY
       ,         ORIGIN
       ,         BEGIN_DATE
       ,         END_DATE
       , rowid
       INTO      cg$sel_rec.CON_IDSEQ
       ,         cg$sel_rec.VP_IDSEQ
       ,         cg$sel_rec.VD_IDSEQ
       ,         cg$sel_rec.PV_IDSEQ
       ,         cg$sel_rec.CONTE_IDSEQ
       ,         cg$sel_rec.DATE_CREATED
       ,         cg$sel_rec.CREATED_BY
       ,         cg$sel_rec.DATE_MODIFIED
       ,         cg$sel_rec.MODIFIED_BY
       ,         cg$sel_rec.ORIGIN
       ,         cg$sel_rec.BEGIN_DATE
       ,         cg$sel_rec.END_DATE
       ,cg$sel_rec.the_rowid
       FROM   VD_PVS_VIEW
       WHERE  rowid = cg$sel_rec.the_rowid;
    END IF;
EXCEPTION WHEN OTHERS THEN
    cg$errors.push(SQLERRM,
                   'E',
                   'ORA',
                   SQLCODE,
                   'cg$VD_PVS_VIEW.slct.others');
    cg$errors.raise_failure;
END slct;
--------------------------------------------------------------------------------
-- Name:        cascade_update
--
-- Description: Updates all child tables affected by a change to VD_PVS_VIEW
--
-- Parameters:  cg$rec     Record of VD_PVS_VIEW current values
--              cg$old_rec Record of VD_PVS_VIEW previous values
--------------------------------------------------------------------------------
PROCEDURE cascade_update(cg$new_rec IN OUT cg$row_type,
                         cg$old_rec IN     cg$row_type) IS
BEGIN
    NULL;
END cascade_update;
--------------------------------------------------------------------------------
-- Name:        cascade_delete
--
-- Description: Delete all child tables affected by a delete to VD_PVS_VIEW
--
-- Parameters:  cg$rec     Record of VD_PVS_VIEW current values
--------------------------------------------------------------------------------
PROCEDURE cascade_delete(cg$old_rec IN OUT cg$row_type)
IS
BEGIN
    NULL;
END cascade_delete;
--------------------------------------------------------------------------------
-- Name:        domain_cascade_delete
--
-- Description: Delete all child tables affected by a delete to VD_PVS_VIEW
--
-- Parameters:  cg$rec     Record of VD_PVS_VIEW current values
--------------------------------------------------------------------------------
PROCEDURE domain_cascade_delete(cg$old_rec IN OUT cg$row_type)
IS
BEGIN
    NULL;
END domain_cascade_delete;
--------------------------------------------------------------------------------
-- Name:        validate_arc
--
-- Description: Checks for adherence to arc relationship
--
-- Parameters:  cg$rec     Record of VD_PVS_VIEW current values
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
-- Parameters:  cg$rec     Record of VD_PVS_VIEW current values
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
        cg$errors.push(cg$errors.MsgGetText(cg$errors.API_RV_TAB_NOT_FOUND, cg$errors.APIMSG_RV_TAB_NOT_FOUND, 'CG_REF_CODES','VD_PVS_VIEW'),
                       'E',
                       'API',
                       cg$errors.API_RV_TAB_NOT_FOUND,
                       'cg$VD_PVS_VIEW.v_domain.no_reftable_found');
        cg$errors.raise_failure;
    WHEN OTHERS THEN
        cg$errors.push(SQLERRM,
                       'E',
                       'ORA',
                       SQLCODE,
                       'cg$VD_PVS_VIEW.v_domain.others');
        cg$errors.raise_failure;
END validate_domain;
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
    IF (con_name = 'VP_PK') THEN
        cg$errors.push(nvl(VP_PK
                  ,cg$errors.MsgGetText(cg$errors.API_PK_CON_VIOLATED
                                     ,cg$errors.APIMSG_PK_VIOLAT
                                     ,'VP_PK'
                                     ,'VD_PVS_VIEW')),
                       'E',
                       'API',
                       cg$errors.API_PK_CON_VIOLATED,
                       loc);
    ELSIF (con_name = 'VP_UK') THEN
        cg$errors.push(nvl(VP_UK
                  ,cg$errors.MsgGetText(cg$errors.API_UQ_CON_VIOLATED
                                     ,cg$errors.APIMSG_UK_VIOLAT
                                     ,'VP_UK'
                                     ,'VD_PVS_VIEW')),
                       'E',
                       'API',
                       cg$errors.API_UQ_CON_VIOLATED,
                       loc);
    ELSIF (con_name = 'VP_CONTE_FK') THEN
        cg$errors.push(nvl(VP_CONTE_FK
                      ,cg$errors.MsgGetText(cg$errors.API_FK_CON_VIOLATED
                                     ,cg$errors.APIMSG_FK_VIOLAT
                                     ,'VP_CONTE_FK'
                                     ,'VD_PVS_VIEW')),
                       'E',
                       'API',
                       cg$errors.API_FK_CON_VIOLATED,
                       loc);
    ELSIF (con_name = 'VP_CET_FK') THEN
        cg$errors.push(nvl(VP_CET_FK
                      ,cg$errors.MsgGetText(cg$errors.API_FK_CON_VIOLATED
                                     ,cg$errors.APIMSG_FK_VIOLAT
                                     ,'VP_CET_FK'
                                     ,'VD_PVS_VIEW')),
                       'E',
                       'API',
                       cg$errors.API_FK_CON_VIOLATED,
                       loc);
    ELSIF (con_name = 'VP_VD_FK') THEN
        cg$errors.push(nvl(VP_VD_FK
                      ,cg$errors.MsgGetText(cg$errors.API_FK_CON_VIOLATED
                                     ,cg$errors.APIMSG_FK_VIOLAT
                                     ,'VP_VD_FK'
                                     ,'VD_PVS_VIEW')),
                       'E',
                       'API',
                       cg$errors.API_FK_CON_VIOLATED,
                       loc);
    ELSIF (con_name = 'VP_PV_FK') THEN
        cg$errors.push(nvl(VP_PV_FK
                      ,cg$errors.MsgGetText(cg$errors.API_FK_CON_VIOLATED
                                     ,cg$errors.APIMSG_FK_VIOLAT
                                     ,'VP_PV_FK'
                                     ,'VD_PVS_VIEW')),
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
BEGIN
--  Application_logic Pre-Insert <<Start>>
--  Application_logic Pre-Insert << End >>
--  Defaulted
--  Auto-generated and uppercased columns
 --   up_autogen_columns(cg$rec, cg$ind, 'INS', do_ins);
    called_from_package := TRUE;
    IF (do_ins) THEN
        validate_foreign_keys_ins(cg$rec);
        validate_arc(cg$rec);
        validate_domain(cg$rec);
        INSERT INTO VD_PVS_VIEW
            (CON_IDSEQ
            ,VP_IDSEQ
            ,VD_IDSEQ
            ,PV_IDSEQ
            ,CONTE_IDSEQ
            ,DATE_CREATED
            ,CREATED_BY
            ,DATE_MODIFIED
            ,MODIFIED_BY
            ,ORIGIN
            ,BEGIN_DATE
            ,END_DATE)
        VALUES
            (cg$rec.CON_IDSEQ
            ,cg$rec.VP_IDSEQ
            ,cg$rec.VD_IDSEQ
            ,cg$rec.PV_IDSEQ
            ,cg$rec.CONTE_IDSEQ
            ,cg$rec.DATE_CREATED
            ,cg$rec.CREATED_BY
            ,cg$rec.DATE_MODIFIED
            ,cg$rec.MODIFIED_BY
            ,cg$rec.ORIGIN
            ,cg$rec.BEGIN_DATE
            ,cg$rec.END_DATE
);
        doLobs(cg$rec, cg$ind);
        slct(cg$rec);
        upd_oper_denorm2(cg$rec, cg$tmp_rec, cg$ind, 'INS');
    END IF;
    called_from_package := FALSE;
    IF NOT (do_ins) THEN
        cg$table(idx).CON_IDSEQ := cg$rec.CON_IDSEQ;
        cg$tableind(idx).CON_IDSEQ := cg$ind.CON_IDSEQ;
        cg$table(idx).VP_IDSEQ := cg$rec.VP_IDSEQ;
        cg$tableind(idx).VP_IDSEQ := cg$ind.VP_IDSEQ;
        cg$table(idx).VD_IDSEQ := cg$rec.VD_IDSEQ;
        cg$tableind(idx).VD_IDSEQ := cg$ind.VD_IDSEQ;
        cg$table(idx).PV_IDSEQ := cg$rec.PV_IDSEQ;
        cg$tableind(idx).PV_IDSEQ := cg$ind.PV_IDSEQ;
        cg$table(idx).CONTE_IDSEQ := cg$rec.CONTE_IDSEQ;
        cg$tableind(idx).CONTE_IDSEQ := cg$ind.CONTE_IDSEQ;
        cg$table(idx).DATE_CREATED := cg$rec.DATE_CREATED;
        cg$tableind(idx).DATE_CREATED := cg$ind.DATE_CREATED;
        cg$table(idx).CREATED_BY := cg$rec.CREATED_BY;
        cg$tableind(idx).CREATED_BY := cg$ind.CREATED_BY;
        cg$table(idx).DATE_MODIFIED := cg$rec.DATE_MODIFIED;
        cg$tableind(idx).DATE_MODIFIED := cg$ind.DATE_MODIFIED;
        cg$table(idx).MODIFIED_BY := cg$rec.MODIFIED_BY;
        cg$tableind(idx).MODIFIED_BY := cg$ind.MODIFIED_BY;
        cg$table(idx).ORIGIN := cg$rec.ORIGIN;
        cg$tableind(idx).ORIGIN := cg$ind.ORIGIN;
        cg$table(idx).BEGIN_DATE := cg$rec.BEGIN_DATE;
        cg$tableind(idx).BEGIN_DATE := cg$ind.BEGIN_DATE;
        cg$table(idx).END_DATE := cg$rec.END_DATE;
        cg$tableind(idx).END_DATE := cg$ind.END_DATE;
        idx := idx + 1;
    END IF;
--  Application logic Post-Insert <<Start>>
--  Application logic Post-Insert << End >>
EXCEPTION
    WHEN cg$errors.cg$error THEN
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN cg$errors.mandatory_missing THEN
        validate_mandatory(cg$rec, 'cg$VD_PVS_VIEW.ins.mandatory_missing');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN cg$errors.check_violation THEN
        err_msg(SQLERRM, cg$errors.ERR_CHECK_CON, 'cg$VD_PVS_VIEW.ins.check_violation');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN cg$errors.fk_violation THEN
        err_msg(SQLERRM, cg$errors.ERR_FOREIGN_KEY, 'cg$VD_PVS_VIEW.ins.fk_violation');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN cg$errors.uk_violation THEN
        err_msg(SQLERRM, cg$errors.ERR_UNIQUE_KEY, 'cg$VD_PVS_VIEW.ins.uk_violation');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN OTHERS THEN
        cg$errors.push(SQLERRM,
                       'E',
                       'ORA',
                       SQLCODE,
                       'cg$VD_PVS_VIEW.ins.others');
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
    cg$upd_rec.VP_IDSEQ := cg$rec.VP_IDSEQ;
    cg$old_rec.VP_IDSEQ := cg$rec.VP_IDSEQ;
    cg$upd_rec.the_rowid := cg$rec.the_rowid;
    cg$old_rec.the_rowid := cg$rec.the_rowid;
    IF (do_upd) THEN
        slct(cg$upd_rec);
    --  Check updates to Primary Key VP_PK allowed
        IF (cg$ind.VP_IDSEQ AND cg$rec.VP_IDSEQ != cg$upd_rec.VP_IDSEQ) THEN
            uk_key_updateable('VP_PK');
        END IF;
        IF NOT (cg$ind.CON_IDSEQ) THEN
            cg$rec.CON_IDSEQ := cg$upd_rec.CON_IDSEQ;
        END IF;
        IF NOT (cg$ind.VP_IDSEQ) THEN
            cg$rec.VP_IDSEQ := cg$upd_rec.VP_IDSEQ;
        END IF;
        IF NOT (cg$ind.VD_IDSEQ) THEN
            cg$rec.VD_IDSEQ := cg$upd_rec.VD_IDSEQ;
        END IF;
        IF NOT (cg$ind.PV_IDSEQ) THEN
            cg$rec.PV_IDSEQ := cg$upd_rec.PV_IDSEQ;
        END IF;
        IF NOT (cg$ind.CONTE_IDSEQ) THEN
            cg$rec.CONTE_IDSEQ := cg$upd_rec.CONTE_IDSEQ;
        END IF;
        IF NOT (cg$ind.DATE_CREATED) THEN
            cg$rec.DATE_CREATED := cg$upd_rec.DATE_CREATED;
        END IF;
        IF NOT (cg$ind.CREATED_BY) THEN
            cg$rec.CREATED_BY := cg$upd_rec.CREATED_BY;
        END IF;
        IF NOT (cg$ind.DATE_MODIFIED) THEN
            cg$rec.DATE_MODIFIED := cg$upd_rec.DATE_MODIFIED;
        END IF;
        IF NOT (cg$ind.MODIFIED_BY) THEN
            cg$rec.MODIFIED_BY := cg$upd_rec.MODIFIED_BY;
        END IF;
        IF NOT (cg$ind.ORIGIN) THEN
            cg$rec.ORIGIN := cg$upd_rec.ORIGIN;
        END IF;
        IF NOT (cg$ind.BEGIN_DATE) THEN
            cg$rec.BEGIN_DATE := cg$upd_rec.BEGIN_DATE;
        END IF;
        IF NOT (cg$ind.END_DATE) THEN
            cg$rec.END_DATE := cg$upd_rec.END_DATE;
        END IF;
    ELSE
       -- Perform checks if called from a trigger
       -- Indicators are only set on changed values
       null;
    --  Check updates to Primary Key VP_PK allowed
        IF (cg$ind.VP_IDSEQ ) THEN
            uk_key_updateable('VP_PK'); END IF;
    END IF;
--  Auto-generated and uppercased columns
 --   up_autogen_columns(cg$rec, cg$ind, 'UPD', do_upd);
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
            UPDATE VD_PVS_VIEW
            SET
              CON_IDSEQ = cg$rec.CON_IDSEQ
              ,VD_IDSEQ = cg$rec.VD_IDSEQ
              ,PV_IDSEQ = cg$rec.PV_IDSEQ
              ,CONTE_IDSEQ = cg$rec.CONTE_IDSEQ
              ,DATE_CREATED = cg$rec.DATE_CREATED
              ,CREATED_BY = cg$rec.CREATED_BY
              ,DATE_MODIFIED = cg$rec.DATE_MODIFIED
              ,MODIFIED_BY = cg$rec.MODIFIED_BY
              ,ORIGIN = cg$rec.ORIGIN
              ,BEGIN_DATE = cg$rec.BEGIN_DATE
              ,END_DATE = cg$rec.END_DATE
        WHERE  VP_IDSEQ = cg$rec.VP_IDSEQ;
               null;
            ELSE
            UPDATE VD_PVS_VIEW
            SET
              CON_IDSEQ = cg$rec.CON_IDSEQ
              ,VD_IDSEQ = cg$rec.VD_IDSEQ
              ,PV_IDSEQ = cg$rec.PV_IDSEQ
              ,CONTE_IDSEQ = cg$rec.CONTE_IDSEQ
              ,DATE_CREATED = cg$rec.DATE_CREATED
              ,CREATED_BY = cg$rec.CREATED_BY
              ,DATE_MODIFIED = cg$rec.DATE_MODIFIED
              ,MODIFIED_BY = cg$rec.MODIFIED_BY
              ,ORIGIN = cg$rec.ORIGIN
              ,BEGIN_DATE = cg$rec.BEGIN_DATE
              ,END_DATE = cg$rec.END_DATE
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
        cg$table(idx).CON_IDSEQ := cg$rec.CON_IDSEQ;
        cg$tableind(idx).CON_IDSEQ := cg$ind.CON_IDSEQ;
        cg$table(idx).VP_IDSEQ := cg$rec.VP_IDSEQ;
        cg$tableind(idx).VP_IDSEQ := cg$ind.VP_IDSEQ;
        cg$table(idx).VD_IDSEQ := cg$rec.VD_IDSEQ;
        cg$tableind(idx).VD_IDSEQ := cg$ind.VD_IDSEQ;
        cg$table(idx).PV_IDSEQ := cg$rec.PV_IDSEQ;
        cg$tableind(idx).PV_IDSEQ := cg$ind.PV_IDSEQ;
        cg$table(idx).CONTE_IDSEQ := cg$rec.CONTE_IDSEQ;
        cg$tableind(idx).CONTE_IDSEQ := cg$ind.CONTE_IDSEQ;
        cg$table(idx).DATE_CREATED := cg$rec.DATE_CREATED;
        cg$tableind(idx).DATE_CREATED := cg$ind.DATE_CREATED;
        cg$table(idx).CREATED_BY := cg$rec.CREATED_BY;
        cg$tableind(idx).CREATED_BY := cg$ind.CREATED_BY;
        cg$table(idx).DATE_MODIFIED := cg$rec.DATE_MODIFIED;
        cg$tableind(idx).DATE_MODIFIED := cg$ind.DATE_MODIFIED;
        cg$table(idx).MODIFIED_BY := cg$rec.MODIFIED_BY;
        cg$tableind(idx).MODIFIED_BY := cg$ind.MODIFIED_BY;
        cg$table(idx).ORIGIN := cg$rec.ORIGIN;
        cg$tableind(idx).ORIGIN := cg$ind.ORIGIN;
        cg$table(idx).BEGIN_DATE := cg$rec.BEGIN_DATE;
        cg$tableind(idx).BEGIN_DATE := cg$ind.BEGIN_DATE;
        cg$table(idx).END_DATE := cg$rec.END_DATE;
        cg$tableind(idx).END_DATE := cg$ind.END_DATE;
        idx := idx + 1;
    END IF;
--  Application_logic Post-Update <<Start>>
--  Application_logic Post-Update << End >>

EXCEPTION
    WHEN cg$errors.cg$error THEN
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN cg$errors.upd_mandatory_null THEN
        validate_mandatory(cg$rec, 'cg$VD_PVS_VIEW.upd.upd_mandatory_null');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN cg$errors.check_violation THEN
        err_msg(SQLERRM, cg$errors.ERR_CHECK_CON, 'cg$VD_PVS_VIEW.upd.check_violation');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN cg$errors.fk_violation THEN
        err_msg(SQLERRM, cg$errors.ERR_FOREIGN_KEY, 'cg$VD_PVS_VIEW.upd.fk_violation');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN cg$errors.uk_violation THEN
        err_msg(SQLERRM, cg$errors.ERR_UNIQUE_KEY, 'cg$VD_PVS_VIEW.upd.uk_violation');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN OTHERS THEN
        cg$errors.push(SQLERRM,
                       'E',
                       'ORA',
                       SQLCODE,
                       'cg$VD_PVS_VIEW.upd.others');
        called_from_package := FALSE;
        cg$errors.raise_failure;
END upd;
--------------------------------------------------------------------------------
-- Name:        upd_denorm
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
-- Name:        upd_oper_denorm
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
-- Name:        del
--
-- Description: API delete procedure
--
-- Parameters:  cg$pk  Primary key record of row to be deleted
--------------------------------------------------------------------------------
PROCEDURE del(cg$pk IN cg$pk_type,
              do_del IN BOOLEAN DEFAULT TRUE) IS
BEGIN
  dbms_output.put_line('SBR.CG$VD_PVS_VIEW.del entered (GF30800 1) ...');

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
           cg$rec.VP_IDSEQ := cg$pk.VP_IDSEQ;
           slct(cg$rec);
  dbms_output.put_line('SBR.CG$VD_PVS_VIEW.del (GF30800) validating foreign key ...');
           validate_foreign_keys_del(cg$rec);
  dbms_output.put_line('SBR.CG$VD_PVS_VIEW.del (GF30800) cascade deleting domain ...');
           domain_cascade_delete(cg$rec);
  /*
         begin - GF30800 delete based on VP_IDSEQ instead of rowid!!!
  */
--            IF cg$pk.the_rowid is null THEN
  dbms_output.put_line('SBR.CG$VD_PVS_VIEW.del (GF30800) 1.1 deleting cg$pk.VP_IDSEQ [' ||cg$pk.VP_IDSEQ||'] from SBR.VD_PVS_VIEW');
              DELETE VD_PVS_VIEW
              WHERE                    VP_IDSEQ = cg$pk.VP_IDSEQ;
--            ELSE
  dbms_output.put_line('SBR.CG$VD_PVS_VIEW.del (GF30800) 1.2 deleting cg$pk.the_rowid [' ||cg$pk.the_rowid||'] from SBR.VD_PVS_VIEW');
--               DELETE VD_PVS_VIEW
--               WHERE  rowid = cg$pk.the_rowid;
--            END IF;
  /*
         end - GF30800 delete based on VP_IDSEQ instead of rowid!!!
  */
  dbms_output.put_line('SBR.CG$VD_PVS_VIEW.del (GF30800) 2');
           upd_oper_denorm2(cg$rec, cg$old_rec, cg$ind, 'DEL');
  dbms_output.put_line('SBR.CG$VD_PVS_VIEW.del (GF30800) cascade deletig domain 2 ...');
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
        err_msg(SQLERRM, cg$errors.ERR_DELETE_RESTRICT, 'cg$VD_PVS_VIEW.del.delete_restrict');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN no_data_found THEN
        cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_DEL, cg$errors.ROW_DEL),
                       'E',
                       'ORA',
                       SQLCODE,
                       'cg$VD_PVS_VIEW.del.no_data_found');
        called_from_package := FALSE;
        cg$errors.raise_failure;
    WHEN OTHERS THEN
        cg$errors.push(SQLERRM,
                       'E',
                       'ORA',
                       SQLCODE,
                       'cg$VD_PVS_VIEW.del.others');
        called_from_package := FALSE;
        cg$errors.raise_failure;
        
    dbms_output.put_line('SBR.CG$VD_PVS_VIEW.del (GF30800) done');

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
               SELECT       CON_IDSEQ
               ,            VP_IDSEQ
               ,            VD_IDSEQ
               ,            PV_IDSEQ
               ,            CONTE_IDSEQ
               ,            DATE_CREATED
               ,            CREATED_BY
               ,            DATE_MODIFIED
               ,            MODIFIED_BY
               ,            ORIGIN
               ,            BEGIN_DATE
               ,            END_DATE
               INTO         cg$tmp_rec.CON_IDSEQ
               ,            cg$tmp_rec.VP_IDSEQ
               ,            cg$tmp_rec.VD_IDSEQ
               ,            cg$tmp_rec.PV_IDSEQ
               ,            cg$tmp_rec.CONTE_IDSEQ
               ,            cg$tmp_rec.DATE_CREATED
               ,            cg$tmp_rec.CREATED_BY
               ,            cg$tmp_rec.DATE_MODIFIED
               ,            cg$tmp_rec.MODIFIED_BY
               ,            cg$tmp_rec.ORIGIN
               ,            cg$tmp_rec.BEGIN_DATE
               ,            cg$tmp_rec.END_DATE
               FROM      VD_PVS_VIEW
               WHERE              VP_IDSEQ = cg$old_rec.VP_IDSEQ
               FOR UPDATE NOWAIT;
            ELSE
               SELECT       CON_IDSEQ
               ,            VP_IDSEQ
               ,            VD_IDSEQ
               ,            PV_IDSEQ
               ,            CONTE_IDSEQ
               ,            DATE_CREATED
               ,            CREATED_BY
               ,            DATE_MODIFIED
               ,            MODIFIED_BY
               ,            ORIGIN
               ,            BEGIN_DATE
               ,            END_DATE
               INTO         cg$tmp_rec.CON_IDSEQ
               ,            cg$tmp_rec.VP_IDSEQ
               ,            cg$tmp_rec.VD_IDSEQ
               ,            cg$tmp_rec.PV_IDSEQ
               ,            cg$tmp_rec.CONTE_IDSEQ
               ,            cg$tmp_rec.DATE_CREATED
               ,            cg$tmp_rec.CREATED_BY
               ,            cg$tmp_rec.DATE_MODIFIED
               ,            cg$tmp_rec.MODIFIED_BY
               ,            cg$tmp_rec.ORIGIN
               ,            cg$tmp_rec.BEGIN_DATE
               ,            cg$tmp_rec.END_DATE
               FROM      VD_PVS_VIEW
               WHERE rowid = cg$old_rec.the_rowid
               FOR UPDATE NOWAIT;
            END IF;
        ELSE
            IF cg$old_rec.the_rowid is null THEN
               SELECT       CON_IDSEQ
               ,            VP_IDSEQ
               ,            VD_IDSEQ
               ,            PV_IDSEQ
               ,            CONTE_IDSEQ
               ,            DATE_CREATED
               ,            CREATED_BY
               ,            DATE_MODIFIED
               ,            MODIFIED_BY
               ,            ORIGIN
               ,            BEGIN_DATE
               ,            END_DATE
               INTO         cg$tmp_rec.CON_IDSEQ
               ,            cg$tmp_rec.VP_IDSEQ
               ,            cg$tmp_rec.VD_IDSEQ
               ,            cg$tmp_rec.PV_IDSEQ
               ,            cg$tmp_rec.CONTE_IDSEQ
               ,            cg$tmp_rec.DATE_CREATED
               ,            cg$tmp_rec.CREATED_BY
               ,            cg$tmp_rec.DATE_MODIFIED
               ,            cg$tmp_rec.MODIFIED_BY
               ,            cg$tmp_rec.ORIGIN
               ,            cg$tmp_rec.BEGIN_DATE
               ,            cg$tmp_rec.END_DATE
               FROM      VD_PVS_VIEW
               WHERE              VP_IDSEQ = cg$old_rec.VP_IDSEQ
               FOR UPDATE;
            ELSE
               SELECT       CON_IDSEQ
               ,            VP_IDSEQ
               ,            VD_IDSEQ
               ,            PV_IDSEQ
               ,            CONTE_IDSEQ
               ,            DATE_CREATED
               ,            CREATED_BY
               ,            DATE_MODIFIED
               ,            MODIFIED_BY
               ,            ORIGIN
               ,            BEGIN_DATE
               ,            END_DATE
               INTO         cg$tmp_rec.CON_IDSEQ
               ,            cg$tmp_rec.VP_IDSEQ
               ,            cg$tmp_rec.VD_IDSEQ
               ,            cg$tmp_rec.PV_IDSEQ
               ,            cg$tmp_rec.CONTE_IDSEQ
               ,            cg$tmp_rec.DATE_CREATED
               ,            cg$tmp_rec.CREATED_BY
               ,            cg$tmp_rec.DATE_MODIFIED
               ,            cg$tmp_rec.MODIFIED_BY
               ,            cg$tmp_rec.ORIGIN
               ,            cg$tmp_rec.BEGIN_DATE
               ,            cg$tmp_rec.END_DATE
               FROM      VD_PVS_VIEW
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
                           'cg$VD_PVS_VIEW.lck.resource_busy');
            cg$errors.raise_failure;
        WHEN no_data_found THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_DEL, cg$errors.ROW_DEL),
                           'E',
                           'ORA',
                           SQLCODE,
                           'cg$VD_PVS_VIEW.lck.no_data_found');
            cg$errors.raise_failure;
        WHEN OTHERS THEN
            cg$errors.push(SQLERRM,
                           'E',
                           'ORA',
                           SQLCODE,
                           'cg$VD_PVS_VIEW.lck.others');
            cg$errors.raise_failure;
    END;
-- Optional Columns
    IF (cg$old_ind.CON_IDSEQ) THEN
        IF (cg$tmp_rec.CON_IDSEQ IS NOT NULL
        AND cg$old_rec.CON_IDSEQ IS NOT NULL) THEN
            IF (cg$tmp_rec.CON_IDSEQ != cg$old_rec.CON_IDSEQ) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P5CON_IDSEQ
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.CON_IDSEQ IS NOT NULL
        OR cg$old_rec.CON_IDSEQ IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P5CON_IDSEQ
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.CONTE_IDSEQ) THEN
        IF (cg$tmp_rec.CONTE_IDSEQ IS NOT NULL
        AND cg$old_rec.CONTE_IDSEQ IS NOT NULL) THEN
            IF (cg$tmp_rec.CONTE_IDSEQ != cg$old_rec.CONTE_IDSEQ) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P27CONTE_IDSEQ
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.CONTE_IDSEQ IS NOT NULL
        OR cg$old_rec.CONTE_IDSEQ IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P27CONTE_IDSEQ
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.DATE_MODIFIED) THEN
        IF (cg$tmp_rec.DATE_MODIFIED IS NOT NULL
        AND cg$old_rec.DATE_MODIFIED IS NOT NULL) THEN
            IF (cg$tmp_rec.DATE_MODIFIED != cg$old_rec.DATE_MODIFIED) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P50DATE_MODIFIED
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.DATE_MODIFIED IS NOT NULL
        OR cg$old_rec.DATE_MODIFIED IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P50DATE_MODIFIED
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.MODIFIED_BY) THEN
        IF (cg$tmp_rec.MODIFIED_BY IS NOT NULL
        AND cg$old_rec.MODIFIED_BY IS NOT NULL) THEN
            IF (cg$tmp_rec.MODIFIED_BY != cg$old_rec.MODIFIED_BY) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P60MODIFIED_BY
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.MODIFIED_BY IS NOT NULL
        OR cg$old_rec.MODIFIED_BY IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P60MODIFIED_BY
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.ORIGIN) THEN
        IF (cg$tmp_rec.ORIGIN IS NOT NULL
        AND cg$old_rec.ORIGIN IS NOT NULL) THEN
            IF (cg$tmp_rec.ORIGIN != cg$old_rec.ORIGIN) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P70ORIGIN
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.ORIGIN IS NOT NULL
        OR cg$old_rec.ORIGIN IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P70ORIGIN
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.BEGIN_DATE) THEN
        IF (cg$tmp_rec.BEGIN_DATE IS NOT NULL
        AND cg$old_rec.BEGIN_DATE IS NOT NULL) THEN
            IF (cg$tmp_rec.BEGIN_DATE != cg$old_rec.BEGIN_DATE) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P80BEGIN_DATE
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.BEGIN_DATE IS NOT NULL
        OR cg$old_rec.BEGIN_DATE IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P80BEGIN_DATE
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.END_DATE) THEN
        IF (cg$tmp_rec.END_DATE IS NOT NULL
        AND cg$old_rec.END_DATE IS NOT NULL) THEN
            IF (cg$tmp_rec.END_DATE != cg$old_rec.END_DATE) THEN
                cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P90END_DATE
                    ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
                any_modified := TRUE;
            END IF;
        ELSIF (cg$tmp_rec.END_DATE IS NOT NULL
        OR cg$old_rec.END_DATE IS NOT NULL) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P90END_DATE
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
-- Mandatory Columns
    IF (cg$old_ind.VP_IDSEQ) THEN
        IF (cg$tmp_rec.VP_IDSEQ != cg$old_rec.VP_IDSEQ) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P10VP_IDSEQ
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.VD_IDSEQ) THEN
        IF (cg$tmp_rec.VD_IDSEQ != cg$old_rec.VD_IDSEQ) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P20VD_IDSEQ
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.PV_IDSEQ) THEN
        IF (cg$tmp_rec.PV_IDSEQ != cg$old_rec.PV_IDSEQ) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P25PV_IDSEQ
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.DATE_CREATED) THEN
        IF (cg$tmp_rec.DATE_CREATED != cg$old_rec.DATE_CREATED) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P30DATE_CREATED
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
            any_modified := TRUE;
        END IF;
    END IF;
    IF (cg$old_ind.CREATED_BY) THEN
        IF (cg$tmp_rec.CREATED_BY != cg$old_rec.CREATED_BY) THEN
            cg$errors.push(cg$errors.MsgGetText(cg$errors.API_ROW_MOD, cg$errors.ROW_MOD, P40CREATED_BY
                ),'E', 'API', CG$ERRORS.API_MODIFIED, 'cg$VD_PVS_VIEW.lck');
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
      cg$ind_true.CON_IDSEQ := TRUE;
      cg$ind_true.VP_IDSEQ := TRUE;
      cg$ind_true.VD_IDSEQ := TRUE;
      cg$ind_true.PV_IDSEQ := TRUE;
      cg$ind_true.CONTE_IDSEQ := TRUE;
      cg$ind_true.DATE_CREATED := TRUE;
      cg$ind_true.CREATED_BY := TRUE;
      cg$ind_true.DATE_MODIFIED := TRUE;
      cg$ind_true.MODIFIED_BY := TRUE;
      cg$ind_true.ORIGIN := TRUE;
      cg$ind_true.BEGIN_DATE := TRUE;
      cg$ind_true.END_DATE := TRUE;

END cg$VD_PVS_VIEW;
