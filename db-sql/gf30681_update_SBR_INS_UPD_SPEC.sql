-- run this as SBR user
/*
 * Fix related to issue https://gforge.nci.nih.gov/tracker/index.php?func=detail&aid=30681.
 */
create or replace PACKAGE "CG$DATA_ELEMENT_CONCEPTS_VIEW" IS

called_from_package BOOLEAN := FALSE;

--  Repository User-Defined Error Messages
DEC_PK CONSTANT VARCHAR2(240) := 'ID already exists.  Contact your DBA';
DEC_UK CONSTANT VARCHAR2(240) := 'Duplicate value for Version, Name and Context, re-enter';
DEC_OBJ_QUAL_FK CONSTANT VARCHAR2(240) := '';
DEC_OC_FK CONSTANT VARCHAR2(240) := 'Invalid Object Class, re-enter';
DEC_PROPE_FK CONSTANT VARCHAR2(240) := 'Invalid Properties, re-enter';
DEC_OCT_FK CONSTANT VARCHAR2(240) := '';
DEC_CONTE_FK CONSTANT VARCHAR2(240) := 'Invalid Context ID, re-enter';
DEC_PRO_FK CONSTANT VARCHAR2(240) := '';
DEC_CD_FK CONSTANT VARCHAR2(240) := 'Invalid Conceptual Domain, re-enter';
DEC_ASL_FK CONSTANT VARCHAR2(240) := 'Invalid Status, re-enter';
DEC_PROP_QUAL_FK CONSTANT VARCHAR2(240) := '';

--  Column default prompts. Format PSEQNO_COL
P5OC_IDSEQ CONSTANT VARCHAR2(240) := 'Oc Idseq';
P10DEC_IDSEQ CONSTANT VARCHAR2(240) := 'Data element concept idseq';
P15VERSION CONSTANT VARCHAR2(240) := 'Version';
P20PREFERRED_NAME CONSTANT VARCHAR2(240) := 'Preferred Name';
P25CONTE_IDSEQ CONSTANT VARCHAR2(240) := 'Context Idseq';
P27CD_IDSEQ CONSTANT VARCHAR2(240) := 'Conceptualdomainidseq';
P28PROPL_NAME CONSTANT VARCHAR2(240) := 'Propertylabel';
P30OCL_NAME CONSTANT VARCHAR2(240) := 'Objectclasslabel';
P40PREFERRED_DEFINITION CONSTANT VARCHAR2(240) := 'Preferred Definition';
P42ASL_NAME CONSTANT VARCHAR2(240) := 'Asv Asv Name';
P45LONG_NAME CONSTANT VARCHAR2(240) := 'Long Name';
P47LATEST_VERSION_IND CONSTANT VARCHAR2(240) := 'Latest Version Ind';
P48DELETED_IND CONSTANT VARCHAR2(240) := 'Deleted Ind';
P50DATE_CREATED CONSTANT VARCHAR2(240) := 'Date Created';
P60BEGIN_DATE CONSTANT VARCHAR2(240) := 'Begin Date';
P60CREATED_BY CONSTANT VARCHAR2(240) := 'Created By';
P65END_DATE CONSTANT VARCHAR2(240) := 'End Date';
P70DATE_MODIFIED CONSTANT VARCHAR2(240) := 'Date Modified';
P80MODIFIED_BY CONSTANT VARCHAR2(240) := 'Modified By';
P90OBJ_CLASS_QUALIFIER CONSTANT VARCHAR2(240) := 'Obj Class Qualifier';
P100PROPERTY_QUALIFIER CONSTANT VARCHAR2(240) := 'Property Qualifier';
P110CHANGE_NOTE CONSTANT VARCHAR2(240) := 'Change Note';
P120PROP_IDSEQ CONSTANT VARCHAR2(240) := 'Prop Idseq';
P130ORIGIN CONSTANT VARCHAR2(240) := 'Origin';
P140DEC_ID CONSTANT VARCHAR2(240) := 'Dec Id';
cg$row DATA_ELEMENT_CONCEPTS_VIEW%ROWTYPE;

--  DATA_ELEMENT_CONCEPTS_VIEW row type variable
TYPE cg$row_type IS RECORD
(OC_IDSEQ cg$row.OC_IDSEQ%TYPE
,DEC_IDSEQ cg$row.DEC_IDSEQ%TYPE
,VERSION cg$row.VERSION%TYPE
,PREFERRED_NAME cg$row.PREFERRED_NAME%TYPE
,CONTE_IDSEQ cg$row.CONTE_IDSEQ%TYPE
,CD_IDSEQ cg$row.CD_IDSEQ%TYPE
,PROPL_NAME cg$row.PROPL_NAME%TYPE
,OCL_NAME cg$row.OCL_NAME%TYPE
,PREFERRED_DEFINITION cg$row.PREFERRED_DEFINITION%TYPE
,ASL_NAME cg$row.ASL_NAME%TYPE
,LONG_NAME cg$row.LONG_NAME%TYPE
,LATEST_VERSION_IND cg$row.LATEST_VERSION_IND%TYPE
,DELETED_IND cg$row.DELETED_IND%TYPE
,DATE_CREATED cg$row.DATE_CREATED%TYPE
,BEGIN_DATE cg$row.BEGIN_DATE%TYPE
,CREATED_BY cg$row.CREATED_BY%TYPE
,END_DATE cg$row.END_DATE%TYPE
,DATE_MODIFIED cg$row.DATE_MODIFIED%TYPE
,MODIFIED_BY cg$row.MODIFIED_BY%TYPE
,OBJ_CLASS_QUALIFIER cg$row.OBJ_CLASS_QUALIFIER%TYPE
,PROPERTY_QUALIFIER cg$row.PROPERTY_QUALIFIER%TYPE
,CHANGE_NOTE cg$row.CHANGE_NOTE%TYPE
,PROP_IDSEQ cg$row.PROP_IDSEQ%TYPE
,ORIGIN cg$row.ORIGIN%TYPE
,CDR_NAME cg$row.CDR_NAME%TYPE --GF30681
,DEC_ID cg$row.DEC_ID%TYPE
,the_rowid ROWID
,JN_NOTES VARCHAR2(240));

--  DATA_ELEMENT_CONCEPTS_VIEW indicator type variable
TYPE cg$ind_type IS RECORD
(OC_IDSEQ BOOLEAN DEFAULT FALSE
,DEC_IDSEQ BOOLEAN DEFAULT FALSE
,VERSION BOOLEAN DEFAULT FALSE
,PREFERRED_NAME BOOLEAN DEFAULT FALSE
,CONTE_IDSEQ BOOLEAN DEFAULT FALSE
,CD_IDSEQ BOOLEAN DEFAULT FALSE
,PROPL_NAME BOOLEAN DEFAULT FALSE
,OCL_NAME BOOLEAN DEFAULT FALSE
,PREFERRED_DEFINITION BOOLEAN DEFAULT FALSE
,ASL_NAME BOOLEAN DEFAULT FALSE
,LONG_NAME BOOLEAN DEFAULT FALSE
,LATEST_VERSION_IND BOOLEAN DEFAULT FALSE
,DELETED_IND BOOLEAN DEFAULT FALSE
,DATE_CREATED BOOLEAN DEFAULT FALSE
,BEGIN_DATE BOOLEAN DEFAULT FALSE
,CREATED_BY BOOLEAN DEFAULT FALSE
,END_DATE BOOLEAN DEFAULT FALSE
,DATE_MODIFIED BOOLEAN DEFAULT FALSE
,MODIFIED_BY BOOLEAN DEFAULT FALSE
,OBJ_CLASS_QUALIFIER BOOLEAN DEFAULT FALSE
,PROPERTY_QUALIFIER BOOLEAN DEFAULT FALSE
,CHANGE_NOTE BOOLEAN DEFAULT FALSE
,PROP_IDSEQ BOOLEAN DEFAULT FALSE
,ORIGIN BOOLEAN DEFAULT FALSE
,CDR_NAME BOOLEAN DEFAULT FALSE --GF30681
,DEC_ID BOOLEAN DEFAULT FALSE);
cg$ind_true cg$ind_type;

--  DATA_ELEMENT_CONCEPTS_VIEW primary key type variable
TYPE cg$pk_type IS RECORD
(DEC_IDSEQ cg$row.DEC_IDSEQ%TYPE
,the_rowid ROWID
,JN_NOTES VARCHAR2(240));

--  PL/SQL Table Type variable for triggers
TYPE cg$table_type IS TABLE OF DATA_ELEMENT_CONCEPTS_VIEW%ROWTYPE
     INDEX BY BINARY_INTEGER;
cg$table cg$table_type;
TYPE cg$tableind_type IS TABLE OF cg$ind_type
     INDEX BY BINARY_INTEGER;
cg$tableind cg$tableind_type;
idx BINARY_INTEGER := 1;


PROCEDURE   slct(cg$sel_rec IN OUT cg$row_type);


PROCEDURE   validate_arc(cg$rec IN OUT cg$row_type);


PROCEDURE   validate_domain(cg$rec IN OUT cg$row_type,
                            cg$ind IN cg$ind_type DEFAULT cg$ind_true);


PROCEDURE   validate_foreign_keys_ins(cg$rec IN cg$row_type);


PROCEDURE validate_foreign_keys_upd( cg$rec IN cg$row_type,
                                     cg$old_rec IN cg$row_type,
                                     cg$ind IN cg$ind_type);


PROCEDURE   validate_foreign_keys_del(cg$rec IN cg$row_type);


PROCEDURE   cascade_update(cg$new_rec IN OUT cg$row_type,
                           cg$old_rec IN cg$row_type
                          );


PROCEDURE   cascade_delete(cg$old_rec IN OUT cg$row_type);


PROCEDURE   domain_cascade_delete(cg$old_rec IN OUT cg$row_type);


PROCEDURE   upd_denorm2( cg$rec IN cg$row_type,
                         cg$ind IN cg$ind_type
					        );


PROCEDURE   upd_oper_denorm2( cg$rec IN cg$row_type,
                              cg$old_rec IN cg$row_type,
                              cg$ind IN cg$ind_type,
                              operation IN VARCHAR2 DEFAULT 'UPD'
					             );


-- moved from pkg body, 21-Jul-2003, W. Ver Hoef ------------------------
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
-- end of moved section --------------------------------------------------


-- 21-Jul-2003, W. Ver Hoef - added missing spec for procedure defined in body
PROCEDURE doLobs(cg$rec IN OUT cg$row_type,
                 cg$ind IN OUT cg$ind_type);


-- moved from above validate_arc, etc. to after to ensure consistent order with pkg body ---
PROCEDURE   ins(cg$rec IN OUT cg$row_type,
                cg$ind IN OUT cg$ind_type,
                do_ins IN BOOLEAN DEFAULT TRUE
               );


PROCEDURE   upd(cg$rec IN OUT cg$row_type,
                cg$ind IN OUT cg$ind_type,
                do_upd IN BOOLEAN DEFAULT TRUE
               );


PROCEDURE   del(cg$pk  IN cg$pk_type,
                do_del IN BOOLEAN DEFAULT TRUE
               );


PROCEDURE   lck(cg$old_rec  IN cg$row_type,
                cg$old_ind  IN cg$ind_type,
                nowait_flag IN BOOLEAN DEFAULT TRUE
               );

-- end of moved from above section ---------------------------------------------------------

END cg$DATA_ELEMENT_CONCEPTS_VIEW;
/