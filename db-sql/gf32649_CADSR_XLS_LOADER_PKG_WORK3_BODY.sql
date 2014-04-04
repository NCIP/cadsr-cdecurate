--------------------------------------------------------
--  Please run with SBREXT account
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body CADSR_XLS_LOADER_PKG_WORK3
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" AS

/******************************************************************************
   NAME:       caDSR_XML_LOADER_PKG. LOad DE
   PURPOSE:    To load data FROM XML staging into DE.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        9/23/2002  Prerna Aggarwal    Created thIS procedure.
*****************************************************************************
*/
PROCEDURE load_de IS

--get the valid source file for data element
CURSOR sde IS
SELECT * FROM source_data_loads
WHERE data_type = 'DE'
AND file_disposition = 'LOADED-SUCCESS';

--CURSOR to get the data elements
CURSOR de(b_sde_id in varchar2) IS
SELECT * FROM data_elements_staging
WHERE sde_id = b_sde_id;

v_vd_conte_idseq        contexts.conte_idseq%type;
v_de_conte_idseq        contexts.conte_idseq%type;
v_dec_conte_idseq       contexts.conte_idseq%type;
v_vd_idseq              value_domains.vd_idseq%type;
v_dec_idseq             data_element_Concepts.dec_idseq%type;
v_de_idseq              data_elements.de_idseq%type;
v_asl_name              ac_status_lov.asl_name%type;
v_preferred_name        data_elements.preferred_name%type;
v_preferred_definition  data_elements.preferred_Definition%type;
v_errors                number := 0;
v_err                   number := 0;
v_name                  varchar2(30);
v_count                 number;
v_error_count           number;
v_exists                boolean;
v_de_existed_ind        boolean;

BEGIN

FOR s_rec IN sde LOOP --start sde loop
  v_error_count := 0;
  --get all data elements
  FOR d_rec IN de(s_rec.id) LOOP --start de loop

    v_de_existed_ind := false;
    --check to see if context for data element exists
    v_errors := 0;
    v_de_conte_idseq := get_conte_idseq(d_rec.de_conte_preferred_name,
                                        d_rec.de_conte_version);
    IF v_de_conte_idseq is null then
      XML_LOAD_ERR_HANDLE(d_rec.id, 'Context, ' ||  d_rec.de_conte_preferred_name ||
        ', for Data Element, ' || d_rec.DE_PREFERRED_NAME ||  ', Not found');
      v_errors := v_errors + 1;
    END IF;

    --check to see if context for value domain exists
    v_vd_conte_idseq := get_conte_idseq(d_rec.vd_conte_preferred_name,
                                        d_rec.vd_conte_version);
    IF v_vd_conte_idseq is null then
      XML_LOAD_ERR_HANDLE(d_rec.id, 'Context, ' ||  d_rec.vd_conte_preferred_name ||
        ', for Value Domain, ' || d_rec.VD_PREFERRED_NAME ||  ', Not found');
      v_errors := v_errors + 1;
    END IF;
    -- dbms_output.PUT_LINE( 'v_vd_conte_idseq = ' || v_vd_conte_idseq );
    --check to see if value domain exists in admin_components table
    v_vd_idseq := get_ac_idseq(d_rec.vd_preferred_name, v_vd_conte_idseq,
                               d_rec.vd_version, 'VALUEDOMAIN');
    if v_vd_idseq is null then
      XML_LOAD_ERR_HANDLE(d_rec.id, 'Value Domain, ' ||  d_rec.vd_preferred_name ||
        ', for Data Element, ' || d_rec.DE_PREFERRED_NAME ||  ', Not found');
      -- XML_LOAD_ERR_HANDLE(d_rec.id, 'Value Domain Not found');
      v_errors := v_errors + 1;
    end if;

    --check to see if context for data element concept exists
    v_dec_conte_idseq := get_conte_idseq(d_rec.dec_conte_preferred_name,
                                         d_rec.dec_conte_version);
    IF v_dec_conte_idseq is null then
      XML_LOAD_ERR_HANDLE(d_rec.id, 'Context, ' ||  d_rec.dec_conte_preferred_name ||
        ', for Data Element Concept, ' || d_rec.DEC_PREFERRED_NAME ||  ', Not found');
      --XML_LOAD_ERR_HANDLE(d_rec.id, 'Context for Data Element Concept Not found');
      v_errors := v_errors + 1;
    END IF;

    --check to see if data element concept exists
    v_dec_idseq := get_ac_idseq(d_rec.dec_preferred_name, v_dec_conte_idseq,
                                d_rec.dec_version, 'DE_CONCEPT');
    if v_dec_idseq is null then
      XML_LOAD_ERR_HANDLE(d_rec.id, 'Data Element Concept, ' ||  d_rec.dec_preferred_name ||
        ', for Data Element, ' || d_rec.DE_PREFERRED_NAME ||  ', Not found');
       --XML_LOAD_ERR_HANDLE(d_rec.id, 'Data Element Concept Not found');
      v_errors := v_errors + 1;
    END if;

    --check to see if workflow status exists
    if not  sbrext_common_routines.WORKFLOW_EXISTS(d_rec.workflow_status) then
      XML_LOAD_ERR_HANDLE(d_rec.id, 'Workflow Status , ' ||  d_rec.workflow_status ||
        ', for Data Element, ' || d_rec.DE_PREFERRED_NAME ||  ', Not found');
      --XML_LOAD_ERR_HANDLE(d_rec.id, 'Workflow Status Not found');
      v_errors := v_errors + 1;
    END if;

    -- check to see if data element already exists
    v_de_idseq := get_ac_idseq(d_rec.de_preferred_name, v_de_conte_idseq,
                               d_rec.de_version, 'DATAELEMENT');
    IF v_de_idseq is not null then
      XML_LOAD_ERR_HANDLE(d_rec.id, 'WARNING: Data Element, ' || d_rec.DE_PREFERRED_NAME ||  ', Already Exists.');
      --XML_LOAD_ERR_HANDLE(d_rec.id, 'Data Element Already Exists');
      -- HSK do not set flag to enter designation, definition, and cs information
      -- for the data element.
      -- v_errors := v_errors + 1;
      v_de_existed_ind := true;
    END IF;

    IF v_errors = 0 then
     -- HSK if already exists in data_elements table, do not enter the de record.
     IF v_de_idseq is null then
       v_de_idseq := admincomponent_crud.cmr_guid;

       BEGIN
         insert into data_elements
           (de_idseq, version, conte_idseq, preferred_name, vd_idseq, dec_idseq,
            preferred_definition, asl_name, long_name, latest_version_ind,
            deleted_ind, date_created, begin_date, created_by, end_date,
            date_modified, modified_by, change_note, origin, cde_id, question)
         values
           (v_de_idseq
           ,d_rec.de_version
           ,v_de_conte_idseq
           ,d_rec.De_preferred_name
           ,v_vd_idseq
           ,v_dec_idseq
           ,d_rec.de_preferred_definition
           ,d_rec.workflow_status
           ,d_rec.de_long_name
           ,'Yes'
           ,'No'
           ,d_rec.date_created
           ,to_date(d_rec.begin_date,'RRRR-MM-DD')
           ,d_rec.created_by
           ,to_date(d_rec.end_date,'RRRRR-MM-DD')
           ,d_rec.date_modified
           ,d_rec.modified_by
           ,d_rec.change_note
           ,d_rec.origin
           ,d_rec.id
           ,null);
         EXCEPTION WHEN OTHERS THEN
           XML_LOAD_ERR_HANDLE(d_rec.id, sqlcode||'--'||sqlerrm||' Error Inserting Data Element ' || d_rec.De_preferred_name);
           v_errors := v_errors + 1;
         END;
        END IF;
    END IF;
    -- HSK
    -- To process multiple occurrences of COMMENT, NOTE, and EXAMPLE,
    -- these informations are loaded into the ref_docs_staging table
    -- instead of data_elements_staging table.The load_docs will not load
    -- these inforamtion since there is no comments, note, and example
    -- in the data_elements_staging table (and still return v_err = 1)

    -- regardless of DE existed or DE newluy inserted successfully
    If v_errors = 0 then
      v_name := get_name('COMMENT');
      v_err := load_docs(d_rec.id,v_de_idseq, 'COMMENT',d_rec.comments,v_name) ;
      if v_err = 1 then
        v_name := get_name('NOTE');
        v_err := load_docs(d_rec.id,v_de_idseq, 'NOTE',d_rec.admin_note,v_name) ;
        if v_err = 1 then
          v_name := get_name('EXAMPLE');
          v_err := load_docs(d_rec.id,v_de_idseq, 'EXAMPLE',d_rec.example,v_name) ;

          -- HSK handle doc, designation, definition, ac, submitter separately.
      -- if v_err = 1 then
            v_err := load_ref_docs(d_rec.id,v_de_idseq);
          --if v_err = 1 then
              v_err := load_designations(d_Rec.id,v_de_idseq);
            --if v_err = 1 then
                --v_err := load_definitions(d_Rec.id,v_de_idseq);  -- not used
              --if v_err = 1 then
                  v_err := load_ac_class(d_rec.id,v_de_idseq);
                  --dbms_output.put_line(v_err);
                --if v_err = 1 then
                    --v_err := load_acreg(d_rec.id,v_de_idseq);  -- not used
                  --if v_err = 1 then
                      begin
                        update administered_components
                        set origin = d_rec.origin,
                            unresolved_issue = d_rec.unresolved_issue
                        where ac_idseq = v_de_idseq;
                      exception when others then
                        rollback;
                        xml_load_err_handle(d_rec.id,sqlcode||'--'||sqlerrm||
                                            '  Error updating Administered Components for data element, '
                                            || d_rec.de_preferred_name);
                        --xml_load_err_handle(d_rec.id,sqlcode||'--'||sqlerrm||
                        --                   '  Error updating Administered Components');
                        v_err := 0;
                      end;
                  --end if;
                --end if;
              --end if;
            --end if;
          --end if;
        --end if;
        end if;
      end if;
    End if;
    /*
    if v_errors = 0 and v_err =1 then
      commit;
    else
      v_error_count := v_error_count +1;
      rollback;
    end if;
    */
    -- HSK update LOADED status
    --if v_errors = 0 and v_err =1 then
    if v_errors = 0 and v_de_existed_ind = false then -- new DE loaded
      update data_elements_staging
      set record_status = 'LOADED'
      where id = d_rec.id;
      commit;
    else
      v_error_count := v_error_count +1;
      rollback;
    end if;

  END LOOP; --end de_loop

  -- v_error_count for only DE load
  begin
    update source_data_loads
    set rejected_records_count = v_error_count
    where id= s_rec.id;
    commit;
  exception
    when others then
      rollback;
      xml_load_err_handle(s_rec.id,sqlcode||'--'||sqlerrm||'  Error updating Source Data Load');
  end;
END LOOP; --end sde loop

END;

----------------------------------------------------------------------------------

FUNCTION GET_NAME(P_TYPE IN VARCHAR2)
return varchar2
is
  v_name varchar2(30);
  v_seq  number;
BEGIN
  select PREF_NAME_SEQ.nextval
  into   v_seq
  from   dual;
  v_name := p_type||v_seq;
  return v_name;
END;

/*******************************************************************************
*
*  Module Name   load_ref_docs
*
*  Application   caDSR
*
*  Program Type  FUNCTION
*
* Description:
* This procedure LOAD data into REFERENCE_DOCUMENTS table
*
*
* Modification History:
*  Date                 Name                Description of Change
*--------------      -------------          ---------------------
*  23-SEP-2002           PAIJ                  Initial creation
********************************************************************************
*/
/* HSK
FUNCTION load_ref_docs(p_ac_id in varchar2, p_ac_idseq in varchar2)
RETURN NUMBER
IS
   cursor c_stg_ref is
   select * from SBREXT.REF_DOCS_STAGING
   where ac_id = p_ac_id;

   v_org_idseq  ORGANIZATIONS_VIEW.ORG_IDSEQ%TYPE;
   v_ck_dup     number(1) :=0;
BEGIN
   -- this will only run if there is a ref record in the ref_docs_staging table.
   FOR c_stg_rec in c_stg_ref LOOP
      select count(*)
      into   v_ck_dup
      from   reference_documents_view
      where  ac_idseq  = p_ac_idseq
      and    name      = c_stg_rec.name
      and    dctl_name = c_stg_rec.dctl_name;
      -- if record not exists in the table, then
      if v_ck_dup = 0 then
         --if c_stg_rec.doc_text is not null then (not checked)
         -- get org id.
         begin
            select org_idseq
            into   v_org_idseq
            from   organizations_view
            where  name = c_stg_rec.org_name;
         exception
            -- when no organization, set id as null.
            when others then
               v_org_idseq := null;
         end;
         insert into REFERENCE_DOCUMENTS_VIEW
         (RD_IDSEQ, NAME, ORG_IDSEQ, DCTL_NAME, AC_IDSEQ, ACH_IDSEQ, AR_IDSEQ,
          RDTL_NAME, DOC_TEXT, DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY,
          URL, LAE_NAME, DISPLAY_ORDER )
         values
         (ADMINCOMPONENT_CRUD.CMR_GUID,
          c_stg_rec.name,
          v_org_idseq,
          c_stg_rec.dctl_name,
          p_ac_idseq,
          null,
          null,
          null,
          c_stg_rec.doc_text,
          sysdate,
          user,
          null,
          null,
          c_stg_rec.url,
          c_stg_rec.lae_name,
          c_stg_rec.display_order);
         --end if;
       end if;
   END LOOP;
   RETURN 1;
EXCEPTION
   WHEN OTHERS THEN
      rollback;
      xml_load_err_handle(p_ac_id,sqlcode||'--'||sqlerrm||'  REF_DOCS loading error');
      RETURN 0;
END load_ref_docs;
*/
FUNCTION load_ref_docs(p_ac_id in varchar2, p_ac_idseq in varchar2)
RETURN NUMBER
IS
   cursor c_stg_ref is
   select * from SBREXT.REF_DOCS_STAGING
   where ac_id = p_ac_id;

   v_org_idseq  ORGANIZATIONS_VIEW.ORG_IDSEQ%TYPE;
   v_ck_dup     number(1) :=0;
   v_name       varchar2(30);
   v_count      number := 0;

BEGIN
   -- this will only run if there is a ref record in the ref_docs_staging table.
   FOR c_stg_rec in c_stg_ref LOOP
     if c_stg_rec.name is not null then -- handle record from cde_browser download
                                        -- which has name
      select count(*)
      into   v_ck_dup
      from   reference_documents_view
      where  ac_idseq  = p_ac_idseq
      and    name      = c_stg_rec.name
      and    dctl_name = c_stg_rec.dctl_name;
      -- if record not exists in the table, then
      if v_ck_dup = 0 then
         --if c_stg_rec.doc_text is not null then (not checked)
         -- get org id.
         begin
            select org_idseq
            into   v_org_idseq
            from   organizations_view
            where  name = c_stg_rec.org_name;
         exception
            -- when no organization, set id as null.
            when others then
               v_org_idseq := null;
         end;
         insert into REFERENCE_DOCUMENTS_VIEW
         (RD_IDSEQ, NAME, ORG_IDSEQ, DCTL_NAME, AC_IDSEQ, ACH_IDSEQ, AR_IDSEQ,
          RDTL_NAME, DOC_TEXT, DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY,
          URL, LAE_NAME, DISPLAY_ORDER )
         values
         (ADMINCOMPONENT_CRUD.CMR_GUID,
          c_stg_rec.name,
          v_org_idseq,
          c_stg_rec.dctl_name,
          p_ac_idseq,
          null,
          null,
          null,
          c_stg_rec.doc_text,
          sysdate,
          user,
          null,
          null,
          c_stg_rec.url,
          c_stg_rec.lae_name,
          c_stg_rec.display_order);
         --end if;
      else  -- refernece record exists already
        XML_LOAD_ERR_HANDLE(p_ac_id, 'Reference Document, ' || c_stg_rec.name ||  ', Already Exists.');

       end if;

     else  -- handle record from excel loader which does not have name
        -- HSK check if document text is entered alteady into the reference_documents table
        v_count := check_cmt_note_exmp (p_ac_idseq, c_stg_rec.doc_text);
        if (v_count >0 ) then
          --XML_LOAD_ERR_HANDLE(p_ac_id, p_ac_idseq || ' WARNING: doc text, "' ||c_stg_rec.doc_text ||  '", Already Exists.');
          XML_LOAD_ERR_HANDLE(p_ac_id, p_ac_idseq);
          return 1;
        end if;

         v_name := get_name(c_stg_rec.dctl_name); -- it creates type || PREF_NAME_SEQ sequence
         begin
            select org_idseq
            into   v_org_idseq
            from   organizations_view
            where  name = c_stg_rec.org_name;
         exception
            -- when no organization, set id as null.
            when others then
               v_org_idseq := null;
         end;
         insert into REFERENCE_DOCUMENTS_VIEW
         (RD_IDSEQ, NAME, ORG_IDSEQ, DCTL_NAME, AC_IDSEQ, ACH_IDSEQ, AR_IDSEQ,
          RDTL_NAME, DOC_TEXT, DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY,
          URL, LAE_NAME, DISPLAY_ORDER )
         values
         (ADMINCOMPONENT_CRUD.CMR_GUID,
          v_name,
          v_org_idseq,
          c_stg_rec.dctl_name,
          p_ac_idseq,
          null,
          null,
          null,
          c_stg_rec.doc_text,
          sysdate,
          user,
          null,
          null,
          c_stg_rec.url,
          c_stg_rec.lae_name,
          c_stg_rec.display_order);


     end if;

   END LOOP;
   -- HSK
   COMMIT;
   RETURN 1;
EXCEPTION
   WHEN OTHERS THEN
      rollback;
      xml_load_err_handle(p_ac_id,sqlcode||'--'||sqlerrm||'  REF_DOCS loading error');
      RETURN 0;
END load_ref_docs;


/*******************************************************************************
*
*  Module Name   load_designations
*
*  Application   caDSR
*
*  Program Type  FUNCTION
*
* Description:
* This procedure LOAD data into SBR.DESIGNATIONS table
*
*
* Modification History:
*  Date                 Name                Description of Change
*--------------      -------------          ---------------------
*  23-SEP-2002           PAIJ                  Initial creation
********************************************************************************
*/
FUNCTION load_designations(p_ac_id in varchar2, p_ac_idseq in varchar2)
RETURN NUMBER
IS
   cursor c_stg_desg is
   select * from SBREXT.DESIGNATIONS_STAGING
   where ac_id = p_ac_id;

   v_conte_idseq   CONTEXTS_VIEW.CONTE_IDSEQ%TYPE;
   v_ck_dup     number(1) :=0;

BEGIN
   FOR c_stg_rec in c_stg_desg LOOP

         select conte_idseq
         into   v_conte_idseq
         from   contexts_view
         where  name    = c_stg_rec.des_conte_name
         and    version = c_stg_rec.des_conte_version;

         if (v_conte_idseq is not null) then
           select count(*)
           into   v_ck_dup
           from   designations_view
           where  ac_idseq  = p_ac_idseq
           and    name      = c_stg_rec.name
           and    detl_name = c_stg_rec.detl_name
           and    conte_idseq = v_conte_idseq;
         else
           xml_load_err_handle(p_ac_id,sqlcode||'--'||sqlerrm||'  Designations context name, '||
                  c_stg_rec.des_conte_name ||' and context version ' ||
                  c_stg_rec.des_conte_version|| 'for designation, '|| c_stg_rec.name ||
                  'does not exist');
         end if;

         if v_ck_dup = 0 then -- designation record not exist
           begin
              insert into designations_view
                (DESIG_IDSEQ, AC_IDSEQ, CONTE_IDSEQ, NAME, DETL_NAME, DATE_CREATED, CREATED_BY,
                 DATE_MODIFIED, MODIFIED_BY, LAE_NAME)
              values
                (ADMINCOMPONENT_CRUD.CMR_GUID,
                 p_ac_idseq,
                 v_conte_idseq,
                 c_stg_rec.name,
                 c_stg_rec.detl_name,
                 sysdate,
                 user,
                 null,
                 null,
                 c_stg_rec.lae_name);
              commit;
            exception
              when others then
                rollback;
                xml_load_err_handle(p_ac_id,sqlcode||'--'||sqlerrm||'  Designation, '||
                  c_stg_rec.name ||
                  ', load error.');
            end;
         else
             xml_load_err_handle(p_ac_id,'  Designation, '|| c_stg_rec.name ||', already exists.');


         end if;
         COMMIT;
   END LOOP;
   -- HSK
   RETURN 1;
EXCEPTION
   WHEN OTHERS THEN
      rollback;
      xml_load_err_handle(p_ac_id,sqlcode||'--'||sqlerrm||'  Designations loading error');
      -- HSK still need to return to continue process definitions, etc
      --RETURN 0;
      RETURN 1;
END load_designations;


/*******************************************************************************
*
*  Module Name   load_definitions
*
*  Application   caDSR
*
*  Program Type  FUNCTION
*
* Description:
* This procedure LOAD data into SBR.DEFINITIONS table
*
*
* Modification History:
*  Date                 Name                Description of Change
*--------------      -------------          ---------------------
*  23-SEP-2002           PAIJ                  Initial creation
********************************************************************************
*/
FUNCTION load_definitions(p_ac_id in varchar2, p_ac_idseq in varchar2)
RETURN NUMBER
IS
   cursor c_stg_defn is
   select * from SBREXT.DEFINITIONS_STAGING
   where ac_id = p_ac_id;

   v_conte_idseq   CONTEXTS_VIEW.CONTE_IDSEQ%TYPE;
BEGIN
   FOR c_stg_rec in c_stg_defn LOOP
      begin
         select conte_idseq
         into   v_conte_idseq
         from   contexts_view
         where  name    = c_stg_rec.def_conte_name
         and    version = c_stg_rec.def_conte_version;
      exception
         when others then
            rollback;
            xml_load_err_handle(p_ac_id,sqlcode||'--'||sqlerrm||
                                '  Definitions context id error');
            RETURN 0;
      end;
      insert into definitions_view
      (DEFIN_IDSEQ, AC_IDSEQ, CONTE_IDSEQ, DEFINITION, DATE_CREATED, CREATED_BY,
       DATE_MODIFIED, MODIFIED_BY, LAE_NAME)
      values
      (ADMINCOMPONENT_CRUD.CMR_GUID,
       p_ac_idseq,
       v_conte_idseq,
       c_stg_rec.definition,
       sysdate,
       user,
       null,
       null,
       c_stg_rec.lae_name);
   END LOOP;
   -- HSK
   COMMIT;
   RETURN 1;
EXCEPTION
   WHEN OTHERS THEN
      rollback;
      xml_load_err_handle(p_ac_id,sqlcode||'--'||sqlerrm||'  Definitions loading error');
      RETURN 0;
END load_definitions;


/*******************************************************************************
*
*  Module Name   XML_LOADER_ERRORS
*
*  Application   caDSR
*
*  Program Type  FUNCTION
*
* Description:
* This procedure LOAD data into SBREXT.XML_LOADER_ERRORS table
*
*
* Modification History:
*  Date                 Name                Description of Change
*--------------      -------------          ---------------------
*  23-SEP-2002           PAIJ                  Initial creation
********************************************************************************
*/
PROCEDURE XML_LOAD_ERR_HANDLE (P_AC_ID IN VARCHAR2, P_ERROR_TEXT IN VARCHAR2)
IS
BEGIN
  -- Insert one record into the error table XML_LOADER_ERRORS
  INSERT INTO SBREXT.XML_LOADER_ERRORS
  (AC_ID, ERROR_TEXT)
  VALUES (P_AC_ID, P_ERROR_TEXT);
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000,'Error occured in XML_LOAD_ERR_HANDLE----'||SQLERRM);
END XML_LOAD_ERR_HANDLE;


/*******************************************************************************
*
*  Module Name   load_docs
*
*  Application   caDSR
*
*  Program Type  FUNCTION
*
* Description:
* This procedure LOAD exampl, comments and admin notes into REFERENCE_DOCUMENTS table
*
*
* Modification History:
*  Date                 Name                Description of Change
*--------------      -------------          ---------------------
*  25-SEP-2002           Prerna aggarwal                 Initial creation
********************************************************************************
*/
FUNCTION load_docs(p_ac_id in varchar2, p_ac_idseq in varchar2, p_dctl_name in varchar2,
                   p_doc_text in varchar2, p_name in varchar2)
RETURN NUMBER
IS
    v_count number;
BEGIN
  if (p_doc_text is not null) then
    -- HSK check if document text is entered alteady into the reference_documents table
    v_count := check_cmt_note_exmp (p_ac_idseq, p_doc_text);
    if (v_count >0 ) then
      XML_LOAD_ERR_HANDLE(p_ac_id, 'WARNING: doc text, "' ||p_doc_text ||  '", Already Exists.');
      return 1;
    end if;

    insert into REFERENCE_DOCUMENTS_VIEW
    (RD_IDSEQ, NAME, ORG_IDSEQ, DCTL_NAME, AC_IDSEQ, ACH_IDSEQ, AR_IDSEQ, RDTL_NAME,
     DOC_TEXT, DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY, URL, LAE_NAME,
     DISPLAY_ORDER)
    values
    (ADMINCOMPONENT_CRUD.CMR_GUID,
     p_name,
     null,
     p_dctl_name,
     p_ac_idseq,
     null,
     null,
     null,
     p_doc_text,
     sysdate,
     user,
     null,
     null,
     null,
     'ENGLISH',
     1);

  end if;
  RETURN 1;
EXCEPTION
    WHEN OTHERS THEN
      rollback;
      xml_load_err_handle(p_ac_id,sqlcode||'--'||sqlerrm||'  REF_DOCS loading error');
      RETURN 0;

END load_docs;


/*******************************************************************************
*
*  Module Name   check_cmt_note_exmp
*
*  Application   caDSR
*
*  Program Type  FUNCTION
*
* Description:
* This procedure checks if the document text is already in the reference_documents table.
*
*
* Modification History:
*  Date                 Name                Description of Change
*--------------      -------------          ---------------------
* 18-DEC-2003         Hyun Soon Kim         Initial creation
********************************************************************************
*/
FUNCTION check_cmt_note_exmp (p_ac_idseq in varchar2, p_doc_text in varchar2)
return number
is
  v_count number;
begin
  --dbms_output.put_line(p_de_idseq);
  --dbms_output.put_line(p_text);

  select count(ac_idseq)
  into   v_count
  from   reference_documents
  where  ac_idseq = p_ac_idseq
  and    doc_text = p_doc_text;
  return v_count;
exception
  when others then
    return 0;
end;

/*******************************************************************************
*
*  Module Name   load_acreg
*
*  Application   caDSR
*
*  Program Type  FUNCTION
*
* Description:
* This procedure LOAD exampl, comments and admin notes into AC_REGISTRATIONS table
*
*
* Modification History:
*  Date                 Name                Description of Change
*--------------      -------------          ---------------------
*  03-OCT-2002         Judy Pai                Initial creation
********************************************************************************
*/
FUNCTION load_acreg(p_ac_id in varchar2,p_ac_idseq in varchar2)
RETURN NUMBER
IS
   cursor c_stg_acreg is
   select * from SBREXT.AC_SUBMITTERS_STAGING
   where ac_id = p_ac_id;

   ac_rec       type_ac_stg;
   v_rec        ADMIN_COMPONENTS_STAGING%ROWTYPE;
   v_org_idseq  ORGANIZATIONS_VIEW.ORG_IDSEQ%TYPE;
   v_sub_idseq  submitters.sub_idseq%TYPE;

BEGIN
   -- get admin_components_staging record
   -- dbms_output.put_line('P_AC_IDSEQ='||p_ac_idseq);
   get_ac_staging(p_ac_id,ac_rec);
   fetch ac_rec into v_rec;
   FOR c_stg_rec in c_stg_acreg LOOP
      BEGIN
      -- get org_idseq
         begin
            select org_idseq into v_org_idseq
            from organizations_view
            where name = c_stg_rec.org_name;
         exception
            when others then
            rollback;
            xml_load_err_handle(p_ac_id,
              ' No ORG_IDSEQ Found for AC_SUBMITTERS_STAGING.ID = '||c_stg_rec.id);
            return 0;
         end;
         -- get sub_idseq if not exists then create it
         v_sub_idseq := get_sub_idseq(c_stg_rec.name, v_org_idseq);
         if v_sub_idseq is null then
            v_sub_idseq := ADMINCOMPONENT_CRUD.CMR_GUID;
            insert into submitters
            (SUB_IDSEQ, NAME, ORG_IDSEQ, TITLE, SUBMIT_DATE, PHONE_NUMBER, FAX_NUMBER,
             TELEX_NUMBER, MAIL_ADDRESS, ELECTRONIC_MAIL_ADDRESS, DATE_CREATED, CREATED_BY,
             DATE_MODIFIED, MODIFIED_BY)
            values
            (v_sub_idseq,
             c_stg_rec.name,
             v_org_idseq,
             c_stg_rec.title,
             null,
             c_stg_rec.phone_number,
             c_stg_rec.fax_number,
             c_stg_rec.telex_number,
             c_stg_rec.mail_address,
             c_stg_rec.electronic_mail_address,
             null,null,null,null);
         end if;
         --dbms_output.put_line('v_rec.id='||v_rec.id||' actl_name='||v_rec.actl_name);
         -- Load AC_REGISTRATIONS
         insert into ac_registrations
         (AR_IDSEQ, AC_IDSEQ, ORG_IDSEQ , SUB_IDSEQ, REGIS_IDSEQ, REGISTRATION_STATUS,
          UNRESOLVED_ISSUE, ORIGIN, LAST_CHANGE, DATA_IDENTIFIER, VERSION_IDENTIFIER,
          IRDI)
         values
         (ADMINCOMPONENT_CRUD.CMR_GUID,
          p_ac_idseq,
          v_org_idseq,
          v_sub_idseq,
          null,
          null,
          v_rec.UNRESOLVED_ISSUE,
          v_rec.ORIGIN,
          null,
          null,
          null,
          null);
      EXCEPTION
         WHEN others then
            rollback;
            xml_load_err_handle(p_ac_id,sqlcode||'--'||sqlerrm||' Insert error for AC_SUBMITTERS_STAGING.ID = '||c_stg_rec.id);
            return 0;
      END;
   END LOOP;
   -- HSK
   COMMIT;
   RETURN 1;
EXCEPTION
   WHEN OTHERS THEN
      rollback;
      xml_load_err_handle(p_ac_id,sqlcode||'--'||sqlerrm||'  AC_SUBMITTERS loading error');
      RETURN 0;
END load_acreg;



FUNCTION get_conte_idseq(p_conte_name in varchar2, p_conte_version in number)
return varchar2
is
   v_conte_idseq contexts_view.conte_idseq%type;
begin
   select conte_idseq
   into   v_conte_idseq
   from   contexts_view
   where  name    = p_conte_name
   and    version = p_conte_version;
   return v_conte_idseq;
exception
   when others then
      return null;
end;



FUNCTION get_ac_idseq(p_preferred_name in varchar2, p_conte_idseq in varchar2,
                      p_version in number, p_actl_name in varchar2)
return varchar2
is
  v_ac_idseq admin_components_view.ac_idseq%type;
begin
  

  select ac_idseq
  into   v_ac_idseq
  from   admin_components_view
  where  preferred_name = trim(p_preferred_name)
  and    conte_idseq    = p_conte_idseq
  and    version        = p_version
  and    actl_name      = trim(p_actl_name);
  return v_ac_idseq;
exception
  when others then
    return null;
end;



FUNCTION get_csi_idseq(p_csi_name in varchar2, p_csi_type in varchar2)
return varchar2
is
   v_csi_idseq  class_scheme_items_view.csi_idseq%type;
begin
   select csi_idseq
   into   v_csi_idseq
   from   class_scheme_items_view
   where  csi_name   = p_csi_name
   and    csitl_name = p_csi_type;
   return v_csi_idseq;
exception
   when others then
      return null;
end;



FUNCTION get_cs_csi_idseq(p_csi_idseq in varchar2, p_cs_idseq in varchar2)
return varchar2
is
   v_cs_csi_idseq  cs_csi_view.cs_csi_idseq%type;
begin
   select cs_csi_idseq
   into   v_cs_csi_idseq
   from   cs_csi_view
   where  csi_idseq = p_csi_idseq
   and    cs_idseq  = p_cs_idseq;
   return v_cs_csi_idseq;
exception
   when others then
      return null;
end;


/*******************************************************************************
*
*  Module Name   load_ac_class
*
*  Application   caDSR
*
*  Program Type  FUNCTION
*
* Description:
* This procedure LOAD data into SBR.AC_CSI table
*
*
* Modification History:
*  Date                 Name                Description of Change
*--------------      -------------          ---------------------
*  25-SEP-2002           PAIJ                  Initial creation
********************************************************************************
*/

FUNCTION load_ac_class(p_ac_id in varchar2, p_ac_idseq in varchar2)
return number
IS
  cursor c_stg_ac is
  select * from SBREXT.AC_CLASS_SCHEMES_STAGING
  where ac_id = p_ac_id;

  v_conte_idseq   contexts_view.conte_idseq%type;
  v_cs_idseq      classification_schemes_view.cs_idseq%type;
  v_csi_idseq     class_scheme_items_view.csi_idseq%type;
  v_cs_csi_idseq  cs_csi_view.cs_csi_idseq%type;
BEGIN
  for c_rec in c_stg_ac loop
    v_conte_idseq := get_conte_idseq(c_rec.conte_name, c_rec.conte_version);
    if v_conte_idseq is not null then
      v_cs_idseq := get_ac_idseq(c_rec.cs_preferred_name, v_conte_idseq,
                                 c_rec.cs_version,'CLASSIFICATION');
      if v_cs_idseq is not null then
        v_csi_idseq := get_csi_idseq(c_rec.csi_name, c_rec.csi_type);
        if v_csi_idseq is not null then
          v_cs_csi_idseq := get_cs_csi_idseq(v_csi_idseq, v_cs_idseq);
          if v_cs_csi_idseq is not null then
            begin
              insert into ac_csi_view
              (AC_CSI_IDSEQ, CS_CSI_IDSEQ, AC_IDSEQ, DATE_CREATED, CREATED_BY,
               DATE_MODIFIED, MODIFIED_BY)
              values
              (admincomponent_crud.cmr_guid,
               v_cs_csi_idseq,
               p_ac_idseq,
               sysdate,
               user,
               null,
               null);
               --HSK
               commit;
            exception
              when others then
                rollback;
                xml_load_err_handle(p_ac_id,sqlcode||'--'||sqlerrm||
                                    '  insert error on AC_CSI for CS '
                                    || c_rec.cs_preferred_name ||
                                    ' and CSI ' ||c_rec.csi_name );
                --RETURN 0;
            end;
          else
            rollback;
            xml_load_err_handle(p_ac_id,'LOAD_AC_CLASS - cannot find  cs_csi_idseq for CS, '||
                                  c_rec.cs_preferred_name ||
                                ', and CSI, ' ||c_rec.csi_name );
            --RETURN 0;
          end if;
        else
          rollback;
          xml_load_err_handle(p_ac_id,'LOAD_AC_CLASS - cannot find  csi_idseq for ' ||
                              ' CSI, '||c_rec.csi_name ||
                              ', and CSI Type, ' ||  c_rec.csi_type);
          --RETURN 0;
        end if;
      else
        rollback;
        xml_load_err_handle(p_ac_id,'LOAD_AC_CLASS - cannot find  cs_idseq for CS, ' ||
                            c_rec.cs_preferred_name);
        --RETURN 0;
      end if;
    else
      rollback;
      xml_load_err_handle(p_ac_id,'LOAD_AC_CLASS - cannot find  conte_idseq for '||
        ' Context, '|| c_rec.conte_name || ', and Context Version, ' ||  c_rec.conte_version ||
        ', for CS, ' || c_rec.cs_preferred_name ||
        ', and CSI, ' ||c_rec.csi_name );
      --RETURN 0;
    end if;
  end loop;
   -- HSK
   COMMIT;
  return 1;
exception
  when others then
    rollback;
    xml_load_err_handle(p_ac_id,sqlcode||'--'||sqlerrm||'  LOAD_AC_CLASS loading error');
    RETURN 0;
END;



PROCEDURE load_dec IS

--get the valid source file for data element
CURSOR sde IS
SELECT * FROM source_data_loads
WHERE data_type = 'DEC'
AND file_dISposition = 'LOADED-SUCCESS';

--CURSOR to get the data elements
CURSOR dec(b_sde_id in varchar2) IS
SELECT * FROM DATA_ELEMENT_CONCEPTS_STAGING
WHERE sde_id = b_sde_id
and NVL(record_status,'X') != 'LOADED';

v_cd_conte_idseq        contexts.conte_idseq%type;
v_dec_conte_idseq       contexts.conte_idseq%type;
v_cd_idseq              conceptual_domains.cd_idseq%type;
v_dec_idseq             data_element_Concepts.dec_idseq%type;
v_de_idseq              data_elements.de_idseq%type;
v_asl_name              ac_status_lov.asl_name%type;
v_preferred_name        data_elements.preferred_name%type;
v_preferred_definition  data_elements.preferred_Definition%type;
v_errors                number := 0;
v_err                   number := 0;
v_name                  varchar2(30);
v_count                 number := 0;
v_error_count           number;
v_Exists                number := 0;
v_oc_idseq                object_classes_ext.oc_idseq%type;
v_prop_idseq            properties_ext.PROP_IDSEQ%type;
v_oc_conte_idseq        contexts.conte_idseq%type;
v_prop_conte_idseq      contexts.conte_idseq%type;

BEGIN

FOR s_rec IN sde LOOP --start sde loop
  --get all data elements
  --dbms_output.put_line('sde id='||s_rec.id);
  v_error_count :=0;
  FOR d_rec IN dec(s_rec.id) LOOP --start de loop
    --check to see if context for data element concept exists
    --dbms_output.put_line('d_rec.id='||d_rec.id);
    v_errors := 0;
    v_dec_conte_idseq := get_conte_idseq(d_rec.dec_conte_name, d_rec.dec_conte_version);
    IF v_dec_conte_idseq is null then
      --XML_LOAD_ERR_HANDLE(d_rec.id, 'Context for Data Element Concepts Not found');
      XML_LOAD_ERR_HANDLE(d_rec.id, 'Context, ' ||  d_rec.dec_conte_name ||
        ', for Data Element Concept, ' || d_rec.DEC_PREFERRED_NAME ||  ', Not found');
      v_errors := v_errors + 1;
    END IF;
    v_cd_conte_idseq := get_conte_idseq(d_rec.CD_CONTE_NAME, d_rec.CD_CONTE_VERSION);
    if v_cd_conte_idseq is null then
      --XML_LOAD_ERR_HANDLE(d_rec.id, 'Context for Conceptual Domain Not found');
      XML_LOAD_ERR_HANDLE(d_rec.id, 'Context, ' ||  d_rec.CD_CONTE_NAME ||
        ', for Conceptual Domains, ' || d_rec.CD_PREFERRED_NAME ||
        ', for Data Element Concept, ' || d_rec.DEC_PREFERRED_NAME ||  ', Not found');
      v_errors := v_errors + 1;
    end if;
    --check to see if conceptual domains for data_element_concepts exists
    v_cd_idseq := get_ac_idseq(d_rec.cd_preferred_name, v_cd_conte_idseq,
                               d_rec.cd_version, 'CONCEPTUALDOMAIN');
    IF v_cd_idseq is null then
      XML_LOAD_ERR_HANDLE(d_rec.id, 'Conceptual Domain '|| d_rec.cd_preferred_name ||
         ' for Data Element Concepts ' || d_rec.dec_preferred_name || ' Not found');
      v_errors := v_errors + 1;
    END IF;

    --check to see if workflow status exists
    if not  sbrext_common_routines.WORKFLOW_EXISTS(d_rec.workflow_status) then
      XML_LOAD_ERR_HANDLE(d_rec.id, 'Workflow Status, '|| d_rec.workflow_status ||
         ' for Data Element Concepts ' || d_rec.dec_preferred_name || ' Not found');
      --XML_LOAD_ERR_HANDLE(d_rec.id, 'Workflow Status Not found');
      v_errors := v_errors + 1;
    end if;

    -- check to see if data element concept already exists
    v_dec_idseq := get_ac_idseq(d_rec.dec_preferred_name,v_dec_conte_idseq,d_rec.dec_version,'DE_CONCEPT');
    IF v_dec_idseq is not null then
      --XML_LOAD_ERR_HANDLE(d_rec.id, 'Data Element Concept Already Exists');
      XML_LOAD_ERR_HANDLE(d_rec.id, 'Data Element Concept, '||d_rec.dec_preferred_name || ', Already Exists');
      v_errors := v_errors + 1;
    END IF;

    /*
    -- HSK added NULL checking
    if (d_rec.OC_CONTE_NAME is not null and d_rec.OC_CONTE_VERSION is not null) then

      v_oc_conte_idseq := get_conte_idseq(d_rec.OC_CONTE_NAME, d_rec.OC_CONTE_VERSION);
      if v_oc_conte_idseq is null then
        XML_LOAD_ERR_HANDLE(d_rec.id, 'Context for Object Class Not found');
        v_errors := v_errors + 1;
      end if;
    end if;
    dbms_output.put_line(d_rec.oc_preferred_name||v_oc_conte_idseq||d_rec.oc_version);
    if (d_rec.oc_preferred_name is not null and d_rec.oc_version is not null) then

         v_oc_idseq := get_ac_idseq(d_rec.OC_PREFERRED_NAME, v_oc_conte_idseq,
                               d_rec.OC_VERSION, 'OBJECTCLASS');

      IF v_oc_idseq is null then
        XML_LOAD_ERR_HANDLE(d_rec.id, 'Object Class for Data Element Concepts Not found');
        v_errors := v_errors + 1;
      END IF;

    end if;
    */
    if (d_rec.OC_CONTE_NAME is not null and d_rec.OC_CONTE_VERSION is not null) then

      v_oc_conte_idseq := get_conte_idseq(d_rec.OC_CONTE_NAME, d_rec.OC_CONTE_VERSION);
      if v_oc_conte_idseq is null then
        -- do generate error message,and nuliify oc information to enter record into database.
        XML_LOAD_ERR_HANDLE(d_rec.id, 'WARNING: Object Class Context '||d_rec.OC_CONTE_NAME|| ' for data element concept '|| d_rec.DEC_PREFERRED_NAME|| ' Not found');
        v_oc_idseq := null;
      end if;
    end if;
    dbms_output.put_line(d_rec.oc_preferred_name||v_oc_conte_idseq||d_rec.oc_version);
    if (d_rec.oc_preferred_name is not null and d_rec.oc_version is not null) then

         v_oc_idseq := get_ac_idseq(d_rec.OC_PREFERRED_NAME, v_oc_conte_idseq,
                               d_rec.OC_VERSION, 'OBJECTCLASS');

      IF v_oc_idseq is null then
        -- do generate error message,and nuliify oc information to enter record into database.
        XML_LOAD_ERR_HANDLE(d_rec.id, 'WARNING: Object Class '||d_rec.OC_PREFERRED_NAME|| ' for data element concept '|| d_rec.DEC_PREFERRED_NAME|| ' Not found');
        v_oc_idseq := null;
      END IF;

    end if;

    /*
    -- HSK added property validation
    if (d_rec.PROP_CONTE_NAME is not null and d_rec.PROP_CONTE_VERSION is not null) then

      v_prop_conte_idseq := get_conte_idseq(d_rec.PROP_CONTE_NAME, d_rec.PROP_CONTE_VERSION);
      if v_prop_conte_idseq is null then
        XML_LOAD_ERR_HANDLE(d_rec.id, 'Context for Property Not found');
        v_errors := v_errors + 1;
      end if;
    end if;
    dbms_output.put_line(d_rec.prop_preferred_name||v_prop_conte_idseq||d_rec.prop_version);
    if (d_rec.prop_preferred_name is not null and d_rec.prop_version is not null) then
      v_prop_idseq := get_ac_idseq(d_rec.prop_preferred_name, v_prop_conte_idseq, d_rec.prop_version,
                               'PROPERTY');
      IF v_prop_idseq is null then
        XML_LOAD_ERR_HANDLE(d_rec.id, 'Property for Data Element Concepts Not found');
        v_errors := v_errors + 1;
      END IF;
    end if;
    */
    if (d_rec.PROP_CONTE_NAME is not null and d_rec.PROP_CONTE_VERSION is not null) then

      v_prop_conte_idseq := get_conte_idseq(d_rec.PROP_CONTE_NAME, d_rec.PROP_CONTE_VERSION);
      if v_prop_conte_idseq is null then
        -- do generate error message,and nuliify prop information to enter record into database.
        XML_LOAD_ERR_HANDLE(d_rec.id, 'WARNING: Property Context '||d_rec.PROP_CONTE_NAME|| ' for data element concept '|| d_rec.DEC_PREFERRED_NAME|| ' Not found');
        v_prop_idseq := null;
      end if;
    end if;
    dbms_output.put_line(d_rec.prop_preferred_name||v_prop_conte_idseq||d_rec.prop_version);

    if (d_rec.prop_preferred_name is not null and d_rec.prop_version is not null) then
      v_prop_idseq := get_ac_idseq(d_rec.prop_preferred_name, v_prop_conte_idseq, d_rec.prop_version,
                               'PROPERTY');
      IF v_prop_idseq is null then
        -- do generate error message,and nuliify prop information to enter record into database.
        XML_LOAD_ERR_HANDLE(d_rec.id, 'WARNING: Property '||d_rec.PROP_PREFERRED_NAME|| ' for data element concept '|| d_rec.DEC_PREFERRED_NAME|| ' Not found');
        v_prop_idseq := null;
      END IF;
    end if;

    IF v_errors = 0 then
      v_dec_idseq := admincomponent_crud.cmr_guid;
      BEGIN
      -- HSK
      /*
        insert into data_element_concepts
        (dec_idseq, version, preferred_name, conte_idseq, cd_idseq, propl_name, ocl_name,
         preferred_definition, asl_name, long_name, latest_version_ind, deleted_ind,
         date_created, begin_date, created_by, end_date, date_modified, modified_by,
         obj_class_qualifier, property_qualifier, change_note, oc_idseq, prop_idseq,
         origin, dec_id)
        values
        (v_dec_idseq
        ,d_rec.dec_version
        ,d_rec.Dec_preferred_name
        ,v_dec_conte_idseq
        ,v_cd_idseq
        ,d_rec.PROP_preferred_NAME
        ,null
        ,d_rec.dec_preferred_definition
        ,d_rec.workflow_status
        ,d_rec.dec_long_name
        ,'Yes'
        ,'No'
        ,d_rec.date_created
        ,to_date(d_rec.begin_date,'RRRR-MM-DD')
        ,d_rec.created_by
        ,to_date(d_rec.end_date,'RRRR-MM-DD')
        ,null
        ,null
        ,d_rec.obj_class_qualifier
        ,d_rec.property_qualifier
        ,d_rec.admin_note
        ,v_oc_idseq
        ,null
        ,d_rec.origin
        ,d_rec.id);
       */
              insert into data_element_concepts
        (dec_idseq, version, preferred_name, conte_idseq, cd_idseq, propl_name, ocl_name,
         preferred_definition, asl_name, long_name, latest_version_ind, deleted_ind,
         date_created, begin_date, created_by, end_date, date_modified, modified_by,
         obj_class_qualifier, property_qualifier, change_note, oc_idseq, prop_idseq,
         origin, dec_id)
        values
        (v_dec_idseq
        ,d_rec.dec_version
        ,d_rec.Dec_preferred_name
        ,v_dec_conte_idseq
        ,v_cd_idseq
        --,d_rec.PROP_preferred_NAME
        --,d_rec.OC_PREFERRED_NAME
        ,null
        ,null
        ,d_rec.dec_preferred_definition
        ,d_rec.workflow_status
        ,d_rec.dec_long_name
        ,'Yes'
        ,'No'
        ,d_rec.date_created
        ,to_date(d_rec.begin_date,'RRRR-MM-DD')
        ,d_rec.created_by
        ,to_date(d_rec.end_date,'RRRR-MM-DD')
        ,null
        ,null
        ,d_rec.obj_class_qualifier
        ,d_rec.property_qualifier
        ,d_rec.admin_note
        ,v_oc_idseq
        ,v_prop_idseq
        ,d_rec.origin
        ,d_rec.id);

      EXCEPTION WHEN OTHERS THEN
        XML_LOAD_ERR_HANDLE(d_rec.id, sqlcode||'--'||sqlerrm||
                            ' Error Inserting Data Element Concepts ' || d_rec.Dec_preferred_name );
        v_errors := v_errors + 1;
      END;
    END IF;
    If v_errors = 0 then
      v_name := get_name('COMMENT');
      v_err := load_docs(d_rec.id,v_dec_idseq, 'COMMENT',d_rec.comments,v_name) ;
      if v_err = 1 then
        v_name := get_name('NOTE');
        v_err := load_docs(d_rec.id,v_dec_idseq, 'NOTE',d_rec.admin_note,v_name) ;
        if v_err = 1 then
          v_name := get_name('EXAMPLE');
          v_err := load_docs(d_rec.id,v_dec_idseq, 'EXAMPLE',d_rec.example,v_name) ;
          if v_err = 1 then
            v_err := load_ref_docs(d_rec.id,v_dec_idseq);
            if v_err = 1 then
              v_err := load_designations(d_Rec.id,v_dec_idseq);
              if v_err = 1 then
                v_err := load_definitions(d_Rec.id,v_dec_idseq);
                if v_err = 1 then
                  -- HSK only call this for DE loading
                  -- v_err := load_ac_class(d_rec.id,v_dec_idseq);
                  --dbms_output.put_line(v_err);
                  if v_err = 1 then
                    v_err := load_acreg(d_rec.id,v_dec_idseq);
                    if v_err = 1 then
                      begin
                        update administered_components
                        set origin = d_rec.origin,
                        unresolved_issue = d_rec.unresolved_issue
                        where ac_idseq = v_dec_idseq;
                      exception when others then
                        rollback;
                        xml_load_err_handle(d_rec.id,sqlcode||'--'||sqlerrm||
                                            '  Error updating Administered Components');
                        v_err := 0;
                      end;
                    end if;
                  end if;
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    End if;

    if v_errors = 0 and v_err =1 then
      update data_element_concepts_staging
      set record_status = 'LOADED'
      where id = d_rec.id;
      commit;
    else
      v_error_count := v_error_count +1;
      rollback;
    end if;

  END LOOP; --end dec_loop
  begin
    update source_data_loads
    set rejected_records_count = v_error_count
    where id= s_rec.id;
    commit;
  exception
    when others then
      rollback;
      xml_load_err_handle(s_rec.id,sqlcode||'--'||sqlerrm||'  Error updating Source Data Load');
  end;
END LOOP; --end sde loop

-- Load DEC Relationship
load_dec_recs;
END;


PROCEDURE load_dec_recs
is
   cursor dec is
   select dr.ID,dr.DEC_ID,dr.REL_DEC_VERSION,dr.REL_DEC_PREFERRED_NAME,
          dr.REL_DEC_CONTE_NAME,dr.REL_DEC_CONTE_VERSION,dr.REL_NAME,dr.DATE_CREATED,
          dr.CREATED_BY,dr.RECORD_STATUS,
          de.DEC_CONTE_NAME,de.DEC_CONTE_VERSION,
          de.DEC_PREFERRED_NAME, de.DEC_VERSION, de.ID de_id
   from dec_relationships dr, data_element_concepts_staging de
   where dr.DEC_ID = de.ID
   and   de.sde_id in (select id
                       from source_data_loads
                       where  data_type = 'DEC'
                       AND    file_dISposition = 'LOADED-SUCCESS')
   and   nvl(de.RECORD_STATUS,'X') = 'LOADED'
   and   nvl(dr.RECORD_STATUS,'X') != 'LOADED';

   v_dec_idseq      data_element_concepts_view.dec_idseq%TYPE;
   v_c_dec_idseq    data_element_concepts_view.dec_idseq%TYPE;
   v_conte_idseq    contexts.CONTE_IDSEQ%type;
   v_c_conte_idseq  contexts.CONTE_IDSEQ%type;
   v_errors         number;
begin
   for c_rec in dec loop
      v_errors := 0;
      -- Check if context idseq exists
      v_conte_idseq := get_conte_idseq(c_rec.dec_conte_name,c_rec.dec_conte_version);
      if v_conte_idseq is null then
         XML_LOAD_ERR_HANDLE(c_rec.de_id,
            'Context for Data Element Concept RECS Not found - DEC_RELATIONSHIP ID='||
            c_rec.id);
         v_errors := v_errors + 1;
      end if;
      -- Get the real dec_idseq
      v_dec_idseq := get_ac_idseq(c_rec.dec_preferred_name, v_conte_idseq,
                                  c_rec.dec_version, 'DE_CONCEPT');
      if v_dec_idseq is null then
         XML_LOAD_ERR_HANDLE(c_rec.de_id,
            'Data Element Concept for Data Element Concept RECS Not found - DEC_RELATIONSHIP ID='||
            c_rec.id);
         v_errors := v_errors + 1;
      end if;
      -- Check if children context idseq exists
      v_c_conte_idseq := get_conte_idseq(c_rec.rel_dec_conte_name,
                                         c_rec.rel_dec_conte_version);
      if v_c_conte_idseq is null then
         XML_LOAD_ERR_HANDLE(c_rec.de_id,
            'Context for Data Element Concept RECS Not found - DEC_RELATIONSHIP ID='||
            c_rec.id);
         v_errors := v_errors + 1;
      else
         -- Get the real children dec_idseq
         v_c_dec_idseq := get_ac_idseq(c_rec.rel_dec_preferred_name, v_c_conte_idseq,
                                       c_rec.rel_dec_version, 'DE_CONCEPT');
         if v_c_dec_idseq is null then
            XML_LOAD_ERR_HANDLE(c_rec.de_id,
               'Data Element Concept for Data Element Concept Children RECS Not found - DEC_RELATIONSHIP ID='||
               c_rec.id);
            v_errors := v_errors + 1;
         end if;
      end if;
      -- Check if rl_name exists
      if not get_rl_name(c_rec.rel_name) then
         XML_LOAD_ERR_HANDLE(c_rec.de_id,
            'Relationship Name for Data Element Concept RECS Not found -  DEC_RELATIONSHIP ID='||
             c_rec.id);
         v_errors := v_errors + 1;
      end if;
      if v_errors = 0 then
         BEGIN
           insert into dec_recs
           (DEC_REC_IDSEQ, P_DEC_IDSEQ, C_DEC_IDSEQ, RL_NAME, DATE_CREATED, CREATED_BY,
            DATE_MODIFIED, MODIFIED_BY)
           values
           (admincomponent_crud.cmr_guid,
            v_dec_idseq,
            v_c_dec_idseq,
            c_rec.rel_name,
            c_rec.date_created,
            c_rec.created_by,
            null,
            null);
         EXCEPTION WHEN OTHERS THEN
            rollback;
            XML_LOAD_ERR_HANDLE(c_rec.de_id,
               sqlcode||'--'||sqlerrm||' Error Inserting Dec Relationship record - DEC_RELATIONSHIP ID= '||
               c_rec.id);
            v_errors := v_errors + 1;
         END;
      end if;
      if v_errors = 0 then
         begin
            update dec_relationships
            set record_status ='LOADED'
            where id = c_rec.id;
         exception
            when others then
               rollback;
               XML_LOAD_ERR_HANDLE(c_rec.de_id,
                  'Error Updating Dec Relationship record - DEC_RELATIONSHIP ID='||
                  c_rec.id);
         end;
         commit;
      end if;
   end loop;
exception
  when others then
     rollback;
end;



FUNCTION get_rl_name(p_rl_name in varchar2)
return boolean
is
  v_rl_name relationships_lov.RL_NAME%TYPE;
begin
  select rl_name
  into   v_rl_name
  from   relationships_lov
  where  rl_name = p_rl_name;
  return true;
exception
  when others then
    return false;
end;



PROCEDURE get_ac_staging(p_ac_id IN VARCHAR2, p_ac_cursor OUT type_ac_stg)
IS
BEGIN
  IF p_ac_cursor%ISOPEN THEN
    CLOSE p_ac_cursor;
  END IF;
  OPEN p_ac_cursor FOR
    SELECT *
    FROM   ADMIN_COMPONENTS_STAGING
    WHERE  id = p_ac_id;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;



FUNCTION get_sub_idseq(p_name in varchar2, p_org_idseq in varchar2)
return varchar2
IS
   v_sub_idseq   submitters.SUB_IDSEQ%type;
BEGIN
   select sub_idseq
   into   v_sub_idseq
   from   submitters
   where  name=p_name
   and    org_idseq = p_org_idseq;
   return v_sub_idseq;
exception
   when others then
      return null;
END;



FUNCTION get_rep_idseq(p_rep_preferred_name in varchar2, p_conte_idseq in varchar2,
                       p_rep_version in number)
return varchar2
is
   v_rep_idseq REPRESENTATIONS_EXT.rep_idseq%type;
begin
   select rep_idseq
   into   v_rep_idseq
   from   REPRESENTATIONS_EXT
   where  preferred_name = p_rep_preferred_name
   and    conte_idseq    = p_conte_idseq
   and    version        = p_rep_version;
   return v_rep_idseq;
exception
   when others then
      return null;
end;



PROCEDURE load_vd is

   --get the valid source file for data element
   CURSOR sde IS
   SELECT * FROM source_data_loads
   WHERE data_type        = 'VD'
   AND   file_dISposition = 'LOADED-SUCCESS';

   --get the value_domains records
   cursor c_vd(b_sde_id in varchar2) is
   select * from value_domains_staging
   where sde_id                  = b_sde_id
   and   NVL(record_status,'X') != 'LOADED'
   order by sde_id;

   v_errors           number :=0;
   v_err              number :=0;
   v_name             varchar2(30);
   v_conte_idseq      contexts.conte_idseq%TYPE;
   v_dtl_name         datatypes_lov.dtl_name%TYPE;
   v_cd_idseq         conceptual_domains.cd_idseq%TYPE;
   v_char_set_name    character_set_lov.char_set_name%TYPE;
   v_forml_name       formats_lov.FORML_NAME%TYPE;
   v_uoml_name        unit_of_measures_lov.UOML_NAME%TYPE;
   v_vd_idseq         value_domains.VD_IDSEQ%TYPE;
   v_error_count      number :=0;
   v_rep_conte_idseq  representations_ext.rep_idseq%TYPE;
   v_rep_idseq        representations_ext.rep_idseq%TYPE;
   -- HSK
   v_cd_conte_idseq   contexts.conte_idseq%TYPE;

BEGIN
  FOR s_rec IN sde LOOP
     v_error_count :=0;
     for vd_rec in c_vd(s_rec.id) loop
        v_errors :=0;
          -- Check if context idseq exists
        v_conte_idseq := get_conte_idseq(vd_rec.VD_CONTE_NAME, vd_rec.VD_CONTE_VERSION);
           if v_conte_idseq is null then
           --XML_LOAD_ERR_HANDLE(vd_rec.id, 'Context for value domains not found ');
           XML_LOAD_ERR_HANDLE(vd_rec.id, 'Context, '|| vd_rec.VD_CONTE_NAME|| ', for value domains, ' || vd_rec.vd_preferred_name || ', not found ');
           v_errors := v_errors + 1;
        end if;
        /*
        -- Check if representation's context idseq exists
        -- HSK added condtion for checking null
        if (vd_rec.REP_CONTE_NAME is not null and vd_rec.REP_CONTE_VERSION is not null) then
          v_rep_conte_idseq := get_conte_idseq(vd_rec.REP_CONTE_NAME,
                                             vd_rec.REP_CONTE_VERSION);
             if v_rep_conte_idseq is null then
            XML_LOAD_ERR_HANDLE(vd_rec.id, 'Representation''s Context for value domains not found ');
            v_errors := v_errors + 1;
          end if;
        end if;

        -- HSK added condtion for checking null
        if (v_rep_conte_idseq is not null and vd_rec.REP_PREFERRED_NAME is not null and
            vd_rec.REP_VERSION is not null) then
          -- Check if representation idseq exists. HSK
          v_rep_idseq := get_ac_idseq(vd_rec.REP_PREFERRED_NAME, v_rep_conte_idseq,
                                     vd_rec.REP_VERSION, 'REPRESENTATION');
          if v_rep_idseq is null then
            XML_LOAD_ERR_HANDLE(vd_rec.id, 'Representation for value domains not found ');
            v_errors := v_errors + 1;
          end if;
        end if;
        */

        -- Check if representation's context idseq exists
        -- HSK added condtion for checking null
        if (vd_rec.REP_CONTE_NAME is not null and vd_rec.REP_CONTE_VERSION is not null) then
          v_rep_conte_idseq := get_conte_idseq(vd_rec.REP_CONTE_NAME,
                                             vd_rec.REP_CONTE_VERSION);
             if v_rep_conte_idseq is null then
            -- do generate error message,and nuliify rep information to enter record into database.
            XML_LOAD_ERR_HANDLE(vd_rec.id, 'WARNING: Representation''s Context ' ||vd_rec.REP_CONTE_NAME|| ' for value domains ' ||vd_rec.VD_PREFERRED_NAME || ' not found');
            v_rep_idseq := null;
          end if;
        end if;

        -- HSK added condtion for checking null
        if (v_rep_conte_idseq is not null and vd_rec.REP_PREFERRED_NAME is not null and
            vd_rec.REP_VERSION is not null) then
          v_rep_idseq := get_ac_idseq(vd_rec.REP_PREFERRED_NAME, v_rep_conte_idseq,
                                     vd_rec.REP_VERSION, 'REPRESENTATION');
          if v_rep_idseq is null then
            -- do generate error message,and nuliify rep information to enter record into database.
            XML_LOAD_ERR_HANDLE(vd_rec.id, 'WARNING: Representation ' || vd_rec.REP_PREFERRED_NAME ||
                                ' for value domains ' ||vd_rec.VD_PREFERRED_NAME || ' not found ');
            v_rep_idseq := null;
          end if;
        end if;

        -- Check if dtl_name exists
        v_dtl_name := get_dtl_name(vd_rec.dtl_name, vd_rec.data_type_description,
                                   vd_rec.data_type_comments);
        if v_dtl_name is null then
              --XML_LOAD_ERR_HANDLE(vd_rec.id, 'DataTypes for value domains not found ');
              XML_LOAD_ERR_HANDLE(vd_rec.id, 'DataTypes, ' ||vd_rec.dtl_name ||
             ', for value domains, ' ||vd_rec.VD_PREFERRED_NAME ||  ', not found ');
           v_errors := v_errors + 1;
        end if;

        --check to see if conceptual domains  exists
        -- HSK  fixed bug. It was sending vd's context id (v_conte_idseq)
        v_cd_conte_idseq := get_conte_idseq(vd_rec.VD_CD_CONTE_NAME, vd_rec.VD_CD_CONTE_VERSION);

        v_cd_idseq := get_ac_idseq(vd_rec.vd_cd_preferred_name, v_cd_conte_idseq,
                                  vd_rec.vd_cd_version, 'CONCEPTUALDOMAIN');
        IF v_cd_idseq is null then
           --XML_LOAD_ERR_HANDLE(vd_rec.id, 'Conceptual Domain for value domains Not found ');
           XML_LOAD_ERR_HANDLE(vd_rec.id, 'Conceptual Domain, '|| vd_rec.vd_cd_preferred_name|| ', for value domains, '
             ||vd_rec.vd_preferred_name || ', Not found ');
           v_errors := v_errors + 1;
        END IF;

        --Check to see if Workflow status exists
        if not  sbrext_common_routines.WORKFLOW_EXISTS(vd_rec.VD_WORKFLOW_STATUS) then
           --XML_LOAD_ERR_HANDLE(vd_rec.id, 'Workflow Status Not found');
           XML_LOAD_ERR_HANDLE(vd_rec.id, 'Workflow Status, ' || vd_rec.VD_WORKFLOW_STATUS||
           ' for Value Domain, '|| vd_rec.vd_preferred_name|| ', Not found');
        v_errors := v_errors + 1;
      end if;

      -- Check if char_set_name exists
      v_char_set_name := get_char_set_name(vd_rec.CHAR_SET_NAME,
                                           vd_rec.char_set_description);

/* may be null
      if v_char_set_name is null then
           XML_LOAD_ERR_HANDLE
        (vd_rec.id
       ,'Char Set Name for value domains not found '
        );
        v_errors := v_errors + 1;
      end if;
*/

      -- Check if FORML_NAME exists
      v_forml_name := get_forml_name(vd_rec.FORML_NAME, vd_rec.format_description,
                                     vd_rec.format_comments);

/* may be null
      if v_forml_name is null then
           XML_LOAD_ERR_HANDLE
        (vd_rec.id
       ,'Format Name for value domains not found '
        );
        v_errors := v_errors + 1;
      end if;
*/

      -- Check if UOML exists
      v_uoml_name := get_uoml_name(vd_rec.UOML_NAME, vd_rec.uoml_precision,
                                   vd_rec.uoml_description, vd_rec.uoml_comments);

/* may be null
       if v_uoml_name is null then
           XML_LOAD_ERR_HANDLE
        (vd_rec.id
       ,'UOML for value domains not found '
        );
        v_errors := v_errors + 1;
      end if;
*/

      -- check to see if value domains already exists
      if vd_rec.vd_preferred_name is not null then
      v_vd_idseq := get_ac_idseq(vd_rec.VD_PREFERRED_NAME,v_conte_idseq,vd_rec.VD_VERSION,'VALUEDOMAIN');
      else
       begin
        select vd_idseq
        into v_vd_idseq
        from value_domains
        where long_name = vd_rec.VD_LONG_NAME
        and conte_idseq = v_conte_idseq
        and version = vd_rec.vd_version;
       exception when no_data_found then
        v_vd_idseq := null;
       when others then
        XML_LOAD_ERR_HANDLE(vd_rec.id, 'existing VD, ' || vd_rec.VD_LONG_NAME||
           ' for Value Domain, '|| vd_rec.vd_long_name|| ', Others');
        v_errors := v_errors + 1;
       end;
      end if;
        
      IF v_vd_idseq is not null then
         --XML_LOAD_ERR_HANDLE(vd_rec.id, 'Value Domains Already Exists');
         XML_LOAD_ERR_HANDLE(vd_rec.id, 'Value Domains, ' ||vd_rec.VD_PREFERRED_NAME || ', Already Exists');
         v_errors := v_errors + 1;
      END IF;

      if v_errors = 0 then
         BEGIN
            v_vd_idseq := admincomponent_crud.cmr_guid;
            insert into value_domains
            (VD_IDSEQ, VERSION, PREFERRED_NAME, CONTE_IDSEQ, PREFERRED_DEFINITION,
             DTL_NAME, BEGIN_DATE, CD_IDSEQ, END_DATE, VD_TYPE_FLAG, ASL_NAME,
             CHANGE_NOTE, UOML_NAME, LONG_NAME, FORML_NAME, MAX_LENGTH_NUM,
             MIN_LENGTH_NUM, DECIMAL_PLACE, LATEST_VERSION_IND, DELETED_IND,
             DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY, CHAR_SET_NAME,
             HIGH_VALUE_NUM, LOW_VALUE_NUM, rep_idseq, qualifier_name, origin,
             vd_id)
            values
               (v_vd_idseq,
             vd_rec.VD_VERSION,
             vd_rec.VD_PREFERRED_NAME,
             v_conte_idseq,
             vd_rec.VD_PREFERRED_DEFINITION,
             v_dtl_name,
             to_date(vd_rec.BEGIN_DATE,'RRRR-MM-DD'),
             v_cd_idseq,
             to_date(vd_rec.END_DATE,'RRRR-MM-DD'),
             trim(vd_rec.VD_TYPE_FLAG),
             vd_rec.VD_WORKFLOW_STATUS,
             null,
             v_uoml_name,
             vd_rec.vd_long_name,
             v_forml_name,
             vd_rec.MAX_LENGTH_NUM,
             vd_rec.MIN_LENGTH_NUM,
             vd_rec.DECIMAL_PLACE,
             'Yes',
             'No',
             vd_rec.date_created,
             vd_rec.created_by,
             null,
             null,
             v_char_set_name,
             vd_rec.HIGH_VALUE_NUM,
             vd_rec.LOW_VALUE_NUM,
             v_rep_idseq,
             vd_rec.rep_qualifier,
             vd_rec.origin,
             vd_rec.id);

         -- dbms_output.put_line('after insert value domains');
         EXCEPTION
            WHEN OTHERS THEN
               XML_LOAD_ERR_HANDLE(vd_rec.id, sqlcode||'--'||sqlerrm||' Error Inserting Value Domains Records ' ||vd_rec.VD_PREFERRED_NAME );
               dbms_output.put_line(vd_rec.id || '::' ||sqlcode||'--'||sqlerrm||' Error Inserting Value Domains Records ' ||vd_rec.VD_PREFERRED_NAME );
               v_errors := v_errors + 1;
         END;
      end if;

      If v_errors = 0 then
         v_name := get_name('COMMENT');
         v_err := load_docs(vd_rec.id,v_vd_idseq, 'COMMENT',vd_rec.comments,v_name) ;
         if v_err = 1 then
            v_name := get_name('NOTE');
            v_err := load_docs(vd_rec.id,v_vd_idseq, 'NOTE',vd_rec.admin_note,v_name) ;
            if v_err = 1 then
               v_name := get_name('EXAMPLE');
               v_err := load_docs(vd_rec.id,v_vd_idseq, 'EXAMPLE',vd_rec.example,v_name) ;

/*    //HSK do not call load_perm_val after entering a VD reocrd.
    // Call it independently.
               if v_err = 1 then
                  v_err := load_ref_docs(vd_rec.id,v_vd_idseq);
                  if v_err = 1 then
                     v_err := load_designations(vd_Rec.id,v_vd_idseq);
                     if v_err = 1 then
                        v_err := load_definitions(vd_Rec.id,v_vd_idseq);
                        if v_err = 1 then
                           v_err := load_ac_class(vd_rec.id,v_vd_idseq);
                           --dbms_output.put_line(v_err);
                           if v_err = 1 then
                              v_err := load_acreg(vd_rec.id,v_vd_idseq);
                              if v_err = 1 then

                                 -- HSK call load_perm_val if VD type is enumerated.
                                 -- When not enumerated, there is no short meaning to insert
                                 if vd_rec.vd_type_flag = 'E' then
                                   -- HSK added addtional parameters
                                   --v_err := load_perm_val(vd_rec.id,v_vd_idseq,v_conte_idseq);
                                   v_err := load_perm_val(v_vd_idseq,v_conte_idseq,
                                            vd_rec.VD_CONTE_NAME, vd_rec.VD_CONTE_VERSION,
                                            vd_rec.VD_VERSION, vd_rec.VD_PREFERRED_NAME);
                                 end if;
*/
                                 if v_err = 1 then
                                    begin
                                       update administered_components
                                       set origin           = vd_rec.origin,
                                           unresolved_issue = vd_rec.unresolved_issue
                                       where ac_idseq = v_vd_idseq;
                                       -- dbms_output.put_line('after update ac');
                                    exception when others then
                                       rollback;
                                       xml_load_err_handle(vd_rec.id,sqlcode||'--'||sqlerrm
                                         ||'  Error updating Administered Components');
                                       v_err := 0;
                                    end;
                                 end if;
/*
                              end if;
                           end if;
                        end if;
                     end if;
                  end if;
               end if;
*/
            end if;
         end if;
      End if;

--dbms_output.put_line('after load children record v_error='||v_errors||' v_err='||v_err);
      if v_errors = 0 and v_err =1 then
         update value_domains_staging
         set record_status = 'LOADED'
         where id = vd_rec.id;
         commit;
      else
         v_error_count := v_error_count +1;
         rollback;
      end if;

   end loop;

   begin
      update source_data_loads
      set rejected_records_count = v_error_count
      where id= s_rec.id;
      commit;
   exception
      when others then
         rollback;
         xml_load_err_handle(s_rec.id,sqlcode||'--'||sqlerrm||
                             '  Error updating Source Data Load');
   end;

end loop;

EXCEPTION
   WHEN OTHERS THEN
      rollback;
END;



FUNCTION get_dtl_name(p_name in varchar2, p_description in varchar2,
                      p_comments in varchar2)
return varchar2
is
   v_dtl_name  datatypes_lov.dtl_name%type;
BEGIN
   begin
      select dtl_name
      into   v_dtl_name
      from   datatypes_lov
      where  dtl_name = p_name;
      return v_dtl_name;
   exception
      when no_data_found then
         insert into datatypes_lov
         (DTL_NAME, DESCRIPTION, COMMENTS, CREATED_BY, DATE_CREATED,
          DATE_MODIFIED, MODIFIED_BY)
         values
         (p_name, p_description, p_comments, user, sysdate, null, null);
         return p_name;
   end;
EXCEPTION
   WHEN OTHERS THEN
      return null;
END;



FUNCTION get_char_set_name(p_name in varchar2, p_description in varchar2)
return varchar2
is
  v_char_set_name  character_set_lov.CHAR_SET_NAME%TYPE;
BEGIN
  begin
    select CHAR_SET_NAME
    into   v_char_set_name
    from   character_set_lov
    where  char_set_name = p_name;
    return v_char_set_name;
  exception
    when no_data_found then
      if p_name is not null then
        insert into character_set_lov
        (CHAR_SET_NAME, DESCRIPTION, DATE_CREATED, DATE_MODIFIED, MODIFIED_BY, CREATED_BY)
        values
        (p_name, p_description, sysdate, null, null, user);
      end if;
      return p_name;
  end;
EXCEPTION
  WHEN OTHERS THEN
    return null;
END;



FUNCTION get_forml_name(p_name in varchar2, p_description in varchar2,
                        p_comments in varchar2)
return varchar2
is
  v_forml_name formats_lov.FORML_NAME%TYPE;
BEGIN
  begin
    SELECT FORML_NAME
    into   v_forml_name
    from   formats_lov
    where  forml_name = p_name;
    return v_forml_name;
  exception
    when no_data_found then
      if p_name is not null then
        insert into formats_lov
        (FORML_NAME, DESCRIPTION, COMMENTS, CREATED_BY, DATE_CREATED,
         DATE_MODIFIED, MODIFIED_BY)
        values
        (p_name, p_description, p_comments, user, sysdate, null, null);
     end if;
     return p_name;
  end;
EXCEPTION
  WHEN OTHERS THEN
    return null;
END;



FUNCTION get_uoml_name(p_name in varchar2, p_precision in varchar2,
                       p_description in varchar2, p_comments in varchar2)
return varchar2
is
   v_uoml_name  UNIT_OF_MEASURES_LOV.UOML_NAME%TYPE;
BEGIN
   begin
      select UOML_NAME
      into   v_uoml_name
      from   UNIT_OF_MEASURES_LOV
      where  uoml_name=p_name;
      return v_uoml_name;
   exception
      when no_data_found then
         if p_name is not null then
            insert into unit_of_measures_lov
            (UOML_NAME, PRECISION, DESCRIPTION, COMMENTS, CREATED_BY, DATE_CREATED,
             modified_by, DATE_MODIFIED)
            values
            (p_name, p_precision, p_description, p_comments, user, sysdate, null, null);
         end if;
         return p_name;
   end;
EXCEPTION
   WHEN OTHERS THEN
      return null;
END;

/*
-- HSK added additional parameters.
-- FUNCTION load_perm_val(p_vd_id in varchar2, p_vd_idseq in varchar2,
--                       p_conte_idseq in varchar2)

FUNCTION load_perm_val(p_vd_idseq in varchar2, p_conte_idseq in varchar2,
                        P_VD_CONTE_NAME in varchar2, P_VD_CONTE_VERSION in varchar2,
                       P_VD_VERSION in varchar2, P_VD_PREFERRED_NAME in varchar2)


RETURN NUMBER
is
   v_begin_date date;

   --cursor c_pval is
   --select * from permissible_values_staging
   --where vd_id = p_vd_id;

   cursor c_pval is
   select * from permissible_values_staging
   where VD_PREFERRED_NAME = P_VD_PREFERRED_NAME and VD_VERSION = P_VD_VERSION and
         VD_CONTEXT_NAME = P_VD_CONTE_NAME and VD_CONTEXT_VERSION = P_VD_CONTE_VERSION;

   v_value_meaning  value_meanings_lov.SHORT_MEANING%type;
   v_pv_idseq       permissible_values.PV_IDSEQ%type;

BEGIN
  for c_rec in c_pval loop
    -- HSK added for checking null short meaning. If null  no need to enter data into VV table.
    if c_rec.short_meaning is not null then

      v_value_meaning := get_value_meaning(c_rec.short_meaning, c_rec.begin_date,
                                           c_rec.end_date);
      if v_value_meaning is not null then
         --check to see if permissible_vlaue exists
         v_pv_idseq := get_pv(c_rec.value, c_rec.short_meaning);
         if v_pv_idseq is null then
            v_pv_idseq := admincomponent_crud.cmr_guid;
            begin
               -- HSK added setting default value for begin_date
               if c_rec.begin_date is null then
                 v_begin_date := sysdate;
               else
                 v_begin_date := to_date(c_rec.begin_date,'RRRR-MM-DD');
               end if;

               insert into permissible_values
               (PV_IDSEQ, VALUE, SHORT_MEANING, MEANING_DESCRIPTION, BEGIN_DATE, END_DATE,
                HIGH_VALUE_NUM, LOW_VALUE_NUM, DATE_CREATED, CREATED_BY, DATE_MODIFIED,
                MODIFIED_BY)
               values
               (v_pv_idseq,
                c_rec.value,
                c_rec.short_meaning,
                c_rec.meaning_description,
                v_begin_date,
                to_date(c_rec.end_date,'RRRR-MM-DD'),
                c_rec.high_value_num,
                c_rec.low_value_num,
                sysdate,
                user,
                null,
                null);
            exception
               when others then
                  rollback;
                  --xml_load_err_handle(p_vd_id,sqlcode||'--'||sqlerrm||
                  xml_load_err_handle(p_vd_idseq,sqlcode||'--'||sqlerrm||
                                      '  insert error on permissible_values.' || c_rec.value);
                  RETURN 0;
            end;
         end if;
         begin
            insert into vd_pvs
            (VP_IDSEQ, VD_IDSEQ, PV_IDSEQ, CONTE_IDSEQ, DATE_CREATED, CREATED_BY,
             DATE_MODIFIED, MODIFIED_BY, origin)
            values
            (admincomponent_crud.cmr_guid,
             p_vd_idseq,
             v_pv_idseq,
             p_conte_idseq,
             sysdate,
             user,
             null,
             null,
             c_rec.origin);
         exception
            when others then
               rollback;
               --xml_load_err_handle(p_vd_id,sqlcode||'--'||sqlerrm||
               xml_load_err_handle(p_vd_idseq,sqlcode||'--'||sqlerrm||
                                   '  insert error on vd_pvs.');
               RETURN 0;
         end;
      end if;
     end if;   -- enidng short_meaning not null condition
   end loop;
   return 1;
EXCEPTION
   WHEN OTHERS THEN
      rollback;
      --xml_load_err_handle(p_vd_id,sqlcode||'--'||sqlerrm||' Error in LOAD_VD procedure ');
      xml_load_err_handle(p_vd_idseq,sqlcode||'--'||sqlerrm||' Error in LOAD_VD procedure ');
      RETURN 0;
END;

*/

--
-- HSK Modified to call load_perm_val independently (not from load_vd after loading a VD record
-- Also changed it from function to procedure
-- permissible_values_staging table does not have sde_id and record_status fields yet.

PROCEDURE load_perm_val IS
   /*
   --get the valid source file for permissible values
   CURSOR sde IS
   SELECT * FROM source_data_loads
   WHERE data_type        = 'VV'
   AND   file_dISposition = 'LOADED-SUCCESS';
   */

   --get the valid value records
   --cursor c_pval(b_sde_id in varchar2) is
   cursor c_pval is
   select * from permissible_values_staging;


   v_begin_date date;
   v_value_meaning     value_meanings_lov.SHORT_MEANING%type;
   v_pv_idseq          permissible_values.PV_IDSEQ%type;
   v_vd_conte_idseq    contexts.conte_idseq%type;
   v_vd_idseq          value_domains.vd_idseq%type;
   v_errors            number := 0;
   vv_fake_ac_id       number := -999;

BEGIN
dbms_output.put_line('Here');
  for c_rec in c_pval loop

    -- HSK added for checking null short meaning. If null, no need to enter data into VV table.
    if c_rec.short_meaning is not null then
     v_errors := 0;
        --check to see if context for value domain exists
        v_vd_conte_idseq := get_conte_idseq(c_rec.vd_context_name,
                                            c_rec.vd_context_version);
        IF v_vd_conte_idseq is null then
          XML_LOAD_ERR_HANDLE(vv_fake_ac_id , 'Context, ' ||  c_rec.vd_context_name ||
            ', for Value Domain, ' || c_rec.VD_LONG_NAME ||
            ', for Valid Value, ' || c_rec.VALUE ||  ', Not found');
          v_errors := v_errors + 1;
        END IF;
        -- dbms_output.PUT_LINE( 'v_vd_conte_idseq = ' || v_vd_conte_idseq );

        --check to see if value domain exists in admin_components table
       
       begin
        select vd_idseq
        into v_vd_idseq
        from value_domains
        where long_name = c_rec.VD_LONG_NAME
        and conte_idseq = v_vd_conte_idseq
        and version = c_rec.vd_version;
       exception when no_data_found then
        v_vd_idseq := null;
       when others then
        XML_LOAD_ERR_HANDLE(c_rec.id, 'existing VD, ' || c_rec.VD_LONG_NAME||
           ' for Value Domain, '|| c_rec.vd_long_name|| ', Others');
        v_errors := v_errors + 1;
       end;
        if v_vd_idseq is null then
          XML_LOAD_ERR_HANDLE(vv_fake_ac_id , 'Value Domain, ' ||  c_rec.vd_long_name ||
            ', for Valid Value, ' || c_rec.value ||  ', Not found');
          v_errors := v_errors + 1;
        end if;
        
        

        if v_errors = 0 then

        
          -- look into value_meanings_lov. If not exists there, insert it.
          v_value_meaning := get_value_meaning(c_rec.short_meaning, c_rec.begin_date,
                                               c_rec.end_date,c_rec.con_Array);
          if v_value_meaning is not null then

             --check to see if permissible_vlaue exists in PERMISSIBLE_VALUES table
             v_pv_idseq := get_pv(c_rec.value, c_rec.short_meaning);
             if v_pv_idseq is null then
                v_pv_idseq := admincomponent_crud.cmr_guid;
                begin
                   -- HSK added setting default value for begin_date
                   if c_rec.begin_date is null then
                     v_begin_date := sysdate;
                   else
                     v_begin_date := to_date(c_rec.begin_date,'RRRR-MM-DD');
                   end if;

                   insert into permissible_values
                   (PV_IDSEQ, VALUE, SHORT_MEANING, MEANING_DESCRIPTION, BEGIN_DATE, END_DATE,
                    HIGH_VALUE_NUM, LOW_VALUE_NUM, DATE_CREATED, CREATED_BY, DATE_MODIFIED,
                    MODIFIED_BY)
                   values
                   (v_pv_idseq,
                    c_rec.value,
                    c_rec.short_meaning,
                    c_rec.meaning_description,
                    v_begin_date,
                    to_date(c_rec.end_date,'RRRR-MM-DD'),
                    c_rec.high_value_num,
                    c_rec.low_value_num,
                    sysdate,
                    user,
                    null,
                    null);
                    
                    exception
                   when others then
                      --rollback;
                      --xml_load_err_handle(p_vd_id,sqlcode||'--'||sqlerrm||
                      xml_load_err_handle(vv_fake_ac_id, sqlcode||'--'||sqlerrm||
                                          '  insert error on permissible_values.' || c_rec.value);
                end;
              end if;
                    -- Now connect vv to vd
                    begin
                        insert into vd_pvs
                        (VP_IDSEQ, VD_IDSEQ, PV_IDSEQ, CONTE_IDSEQ, DATE_CREATED, CREATED_BY,
                         DATE_MODIFIED, MODIFIED_BY, origin)
                        values
                        (admincomponent_crud.cmr_guid,
                         v_vd_idseq,
                         v_pv_idseq,
                         v_vd_conte_idseq,
                         sysdate,
                         user,
                         null,
                         null,
                         c_rec.origin);
                       --commit;     -- commiting for one record
                    exception
                        when others then
                           --rollback;
                           xml_load_err_handle(vv_fake_ac_id, sqlcode||'--'||sqlerrm||
                                               '  insert error on vd_pvs for' || c_rec.value);
                    end;

                

            /* else
               XML_LOAD_ERR_HANDLE(vv_fake_ac_id, 'WARNING: Valid Value, ' || c_rec.value||  ', Already Exists.');
             end if; -- if v_pv_idseq is null*/


          end if; -- end if v_value_meaning is not null

       end if;   -- ending x_errors = 0
     end if;     -- enidng short_meaning not null condition

   end loop;
/*
EXCEPTION
   WHEN OTHERS THEN
      rollback;
      xml_load_err_handle(v_pv_idseq,sqlcode||'--'||sqlerrm||' Error in LOAD_VV procedure ');
*/
END;



FUNCTION get_value_meaning(p_short_meaning in varchar2, p_begin_date in varchar2,
                           p_end_date in varchar2,p_con_array in varchar2)
return varchar2
is
   v_short_meaning value_meanings_lov.SHORT_MEANING%type;
   v_condr_idseq varchar2(36);
   v_vm_condr_idseq varchar2(36) := null;
   v_con_Array varchar2(500) := null;
BEGIN  

v_con_array := get_con_array(p_con_array);    
 if v_con_array is not null  and v_con_array != 'Error' then
  v_condr_idseq := sbrext_common_routines.SET_DERIVATION_RULE(v_con_array);
 end if;
   begin
   

      select short_meaning,condr_idseq
      into   v_short_meaning,v_vm_condr_idseq
      from   value_meanings_lov
      where  short_meaning = p_short_meaning;
      
      if v_condr_idseq is not null and v_vm_condr_idseq is null then
        update value_meanings_lov
        set condr_idseq = v_condr_idseq
        where short_meaning = p_short_meaning;
      end if;
      
      
      return v_short_meaning;
   exception
      when no_data_found then
         insert into value_meanings_lov
         (SHORT_MEANING, DESCRIPTION, COMMENTS, BEGIN_DATE, END_DATE,
          DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY,condr_idseq)
         values
         (p_short_meaning,
          p_short_meaning,
          null,
          to_date(p_begin_date,'RRRR-MM-DD'),
          to_date(p_end_date,'RRRR-MM-DD'),
          sysdate,
          user,
          null,
          null,
          v_condr_idseq);
      return p_short_meaning;
   end;
EXCEPTION
   WHEN OTHERS THEN
      return null;
END;



FUNCTION get_pv(p_value in varchar2, p_short_meaning varchar2)
return varchar2
is
   v_pv_idseq  PERMISSIBLE_VALUES.PV_IDSEQ%type;
BEGIN
   select pv_idseq
   into   v_pv_idseq
   from   PERMISSIBLE_VALUES
   where  value         = p_value
   and    short_meaning = p_short_meaning;
   return v_pv_idseq;
exception
   when others then
      return null;
END;



PROCEDURE load_cd IS

--get the valid source file for conceptual domains
CURSOR sde IS
SELECT * FROM source_data_loads
WHERE data_type = 'CD'
AND file_dISposition = 'LOADED-SUCCESS';

--CURSOR to get the conceptual domains
CURSOR cd(b_sde_id in varchar2) IS
SELECT * FROM CONCEPTUAL_DOMAINS_STAGING
WHERE sde_id = b_sde_id
and NVL(record_status,'X') != 'LOADED';

v_cd_conte_idseq   contexts.conte_idseq%type;
v_dec_conte_idseq  contexts.conte_idseq%type;
v_cd_idseq         conceptual_domains.cd_idseq%type;
v_de_idseq         data_elements.de_idseq%type;
v_asl_name         ac_status_lov.asl_name%type;
v_errors           number := 0;
v_err              number := 0;
v_name             varchar2(30);
v_count            number := 0;
v_error_count      number;

BEGIN

FOR s_rec IN sde LOOP --start sde loop
  --get all conceptual domain staging record
  v_error_count :=0;
  FOR d_rec IN cd(s_rec.id) LOOP --start de loop
    v_errors := 0;
    --check to see if context for data element concept exists

    v_cd_conte_idseq := get_conte_idseq(d_rec.CD_CONTE_NAME, d_rec.CD_CONTE_VERSION);
    if v_cd_conte_idseq is null then
      --XML_LOAD_ERR_HANDLE(d_rec.id, 'Context for Conceptual Domain Not found');
      XML_LOAD_ERR_HANDLE(d_rec.id, 'Context, '||d_rec.CD_CONTE_NAME ||
        ', for Conceptual Domain, ' || d_rec.cd_preferred_name||', Not found');
      v_errors := v_errors + 1;
    end if;

    --check to see if workflow status exists
    if not  sbrext_common_routines.WORKFLOW_EXISTS(d_rec.CD_WORKFLOW_STATUS) then
      --XML_LOAD_ERR_HANDLE(d_rec.id, 'Workflow Status Not found');
      XML_LOAD_ERR_HANDLE(d_rec.id, 'Workflow Status, ' || d_rec.CD_WORKFLOW_STATUS|| ', Not found');
      v_errors := v_errors + 1;
    end if;

    -- check to see if conceptual domains already exists
    v_cd_idseq := get_ac_idseq(d_rec.CD_PREFERRED_NAME, v_cd_conte_idseq, d_rec.CD_VERSION,
                               'CONCEPTUALDOMAIN');
    IF v_cd_idseq is not null then
      --XML_LOAD_ERR_HANDLE(d_rec.id, 'Conceptual Domains Already Exists');
      XML_LOAD_ERR_HANDLE(d_rec.id, 'Conceptual Domains, ' ||d_rec.CD_PREFERRED_NAME || ', Already Exists');
      v_errors := v_errors + 1;
    END IF;

    IF v_errors = 0 then
      v_cd_idseq := admincomponent_crud.cmr_guid;
      BEGIN
        insert into conceptual_domains
        (cd_idseq, version, preferred_name, conte_idseq, preferred_definition,
         dimensionality, long_name, asl_name, date_created, latest_version_ind,
         deleted_ind, created_by, date_modified, modified_by, begin_date, end_date,
         change_note, origin, cd_id)
        values
        (v_cd_idseq
        ,d_rec.cd_version
        ,d_rec.cd_preferred_name
        ,v_cd_conte_idseq
        ,d_rec.CD_PREFERRED_DEFINITION
        ,d_rec.DIMENSIONALITY
        ,d_rec.CD_LONG_NAME
        ,d_rec.CD_WORKFLOW_STATUS
        ,d_rec.date_created
        ,'Yes'
        ,'No'
        ,d_rec.created_by
        ,null
        ,null
        ,to_date(d_rec.begin_date,'RRRR-MM-DD')
        ,to_date(d_rec.end_date,'RRRR-MM-DD')
        ,d_rec.ADMIN_NOTE
        ,d_rec.origin
        ,d_rec.id);
      EXCEPTION WHEN OTHERS THEN
        XML_LOAD_ERR_HANDLE(d_rec.id, sqlcode||'--'||sqlerrm||
                            ' Error Inserting Conceptual Domains ' || d_rec.cd_preferred_name);
        v_errors := v_errors + 1;
      END;
    END IF;
  If v_errors = 0 then
    v_name := get_name('COMMENT');
    v_err := load_docs(d_rec.id,v_cd_idseq, 'COMMENT',d_rec.comments,v_name) ;
    if v_err = 1 then
      v_name := get_name('NOTE');
      v_err := load_docs(d_rec.id,v_cd_idseq, 'NOTE',d_rec.admin_note,v_name) ;
        if v_err = 1 then
          v_name := get_name('EXAMPLE');
          v_err := load_docs(d_rec.id,v_cd_idseq, 'EXAMPLE',d_rec.example,v_name) ;
          if v_err = 1 then
            v_err := load_ref_docs(d_rec.id,v_cd_idseq);
            if v_err = 1 then
              v_err := load_designations(d_Rec.id,v_cd_idseq);
              if v_err = 1 then
                v_err := load_definitions(d_Rec.id,v_cd_idseq);
                if v_err = 1 then
                  -- HSK only call this for DE loading
                  -- v_err := load_ac_class(d_rec.id,v_cd_idseq);
                  --dbms_output.put_line(v_err);
                  if v_err = 1 then
                    v_err := load_acreg(d_rec.id,v_cd_idseq);
                    if v_err = 1 then
                      begin
                        update administered_components
                        set origin = d_rec.origin,
                            unresolved_issue = d_rec.unresolved_issue
                        where ac_idseq = v_cd_idseq;
                      exception when others then
                        rollback;
                        xml_load_err_handle(d_rec.id,sqlcode||'--'||sqlerrm||
                                            '  Error updating Administered Components');
                        v_err := 0;
                      end;
                    end if;
                  end if;
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    End if;

    if v_errors = 0 and v_err =1 then
      update conceptual_domains_staging
      set record_status = 'LOADED'
      where id = d_rec.id;
      commit;
    else
      v_error_count := v_error_count +1;
      rollback;
    end if;

  END LOOP; --end dec_loop

  begin
    update source_data_loads
    set rejected_records_count = v_error_count
    where id = s_rec.id;
    commit;
  exception
    when others then
      rollback;
      xml_load_err_handle(s_rec.id,sqlcode||'--'||sqlerrm||
                          '  Error updating Source Data Load');
  end;

END LOOP; --end sde loop

END;



PROCEDURE load_decr is

--get the valid source file for dec recs
CURSOR sde IS
    SELECT * FROM source_data_loads
    WHERE data_type = 'DECR'
    AND   file_dISposition = 'LOADED-SUCCESS';

--CURSOR to get the dec recs
CURSOR dec(b_sde_id in varchar2) IS
    SELECT * FROM dec_staging
    WHERE sde_id = b_sde_id
    and   NVL(record_status,'X') != 'LOADED';

CURSOR decr(b_dcs_id in number) IS
    SELECT * FROM decr_staging
    where dcs_id = b_dcs_id
    and   NVL(record_status,'X') != 'LOADED';

v_errors           number := 0;
v_err              number := 0;
v_error_count      number;
v_dec_conte_idseq  contexts.CONTE_IDSEQ%TYPE;
v_dec_idseq        data_element_concepts.DEC_IDSEQ%TYPE;
v_decr_conte_idseq contexts.CONTE_IDSEQ%TYPE;
v_decr_idseq       data_element_concepts.DEC_IDSEQ%TYPE;
v_partial_load     boolean :=false;

BEGIN
  FOR s_rec IN sde LOOP --start sde loop
  --get all conceptual domain staging record
    v_error_count :=0;
    FOR d_rec IN dec(s_rec.id) LOOP --start dec loop
      v_errors := 0;
      v_partial_load := false;
      v_dec_conte_idseq := get_conte_idseq(d_rec.dec_conte_name, d_rec.dec_conte_version);
      if v_dec_conte_idseq is null then
        XML_LOAD_ERR_HANDLE(d_rec.id, 'Context for Data Element Concepts Not found');
        v_errors := v_errors + 1;
      end if;
      v_dec_idseq := get_ac_idseq(d_rec.dec_preferred_name, v_dec_conte_idseq,
                                  d_rec.dec_version, 'DE_CONCEPT');
      if v_dec_idseq is null then
        XML_LOAD_ERR_HANDLE(d_rec.id, 'Data Element Concepts Not found');
        v_errors := v_errors + 1;
      end if;
      if v_errors = 0 then
        FOR decr_rec in decr(d_rec.id) LOOP
          v_err := 0;
          v_decr_conte_idseq := get_conte_idseq(decr_rec.dec_conte_name,
                                                decr_rec.dec_conte_version);
          if v_decr_conte_idseq is null then
            XML_LOAD_ERR_HANDLE(d_rec.id, 'Context for DECR Not found');
            v_err := v_err + 1;
          end if;
          v_decr_idseq := get_ac_idseq(decr_rec.dec_preferred_name, v_decr_conte_idseq,
                                       decr_rec.dec_version, 'DE_CONCEPT');
          if v_decr_idseq is null then
            XML_LOAD_ERR_HANDLE(d_rec.id, 'Data Element Concepts DECR Not found');
            v_err := v_err + 1;
          end if;
          if not get_rl_name(decr_rec.rel_name) then
            XML_LOAD_ERR_HANDLE(d_rec.id, 'Relationship name for DECR Not found');
            v_err := v_err + 1;
          end if;
          -- Check if the relationship exists
          if get_dec_rel(v_dec_idseq, v_decr_idseq) then
            XML_LOAD_ERR_HANDLE(d_rec.id, 'DEC relationship exists');
            v_err := v_err + 1;
          end if;
          if v_err = 0 then
            begin
              insert into dec_recs
              (DEC_REC_IDSEQ, P_DEC_IDSEQ, C_DEC_IDSEQ, RL_NAME, DATE_CREATED,
               CREATED_BY, DATE_MODIFIED, MODIFIED_BY)
              values
              (admincomponent_crud.cmr_guid,
               v_dec_idseq,
               v_decr_idseq,
               decr_rec.rel_name,
               sysdate,
               user,
               null,
               null);
              update decr_staging
              set record_status ='LOADED'
              where id = decr_rec.id;
              commit;
            exception
              when others then
                   v_partial_load := true;
                rollback;
                XML_LOAD_ERR_HANDLE(d_rec.id, sqlcode||'--'||sqlerrm||
                                    ' Error Inserting DEC_RECS');
             end;
          else
            v_partial_load := true;
          end if;
        END LOOP;  --decr_rec loop
        begin
          if not v_partial_load then
            update dec_staging
            set record_status = 'LOADED'
            where id = d_rec.id;
          else
            update dec_staging
            set record_status = 'PARTIAL-LOADED'
            where id = d_rec.id;
          end if;
          commit;
        exception
          when others then
            rollback;
            xml_load_err_handle(d_rec.id, sqlcode||'--'||sqlerrm||
                                '  Error updating DEC_STAGING');
        end;
      else
        v_error_count := v_error_count +1;
      end if;

    END LOOP;  --d_rec loop
    begin
      update source_data_loads
      set rejected_records_count = v_error_count
      where id= s_rec.id;
      commit;
    exception
      when others then
        rollback;
        xml_load_err_handle(s_rec.id, sqlcode||'--'||sqlerrm||
                            '  Error updating Source Data Load');
    end;
  END LOOP;     --s_rec loop

END;



FUNCTION get_dec_rel(p_d_idseq in varchar2, p_decr_idseq in varchar2)
return boolean
is
   v_count number(1) :=0;
begin
   select count(*)
   into   v_count
   from   dec_recs
   where  p_dec_idseq = p_d_idseq
   and    c_dec_idseq = p_decr_idseq;
   if v_count > 0 then
      return true;
   else
      return false;
   end if;
exception
   when others then
      return false;
end;


--
-- Delete duplicate rdoc text records (leave the first one) in
-- the reference_documents table. Duplicate  doc text records were created
-- because CSV files were run many times. Now the problem is fixe and
-- no duplicate record for example, admin notes, and comments are entered
-- even though CSV DE files are run multiple times.
--
PROCEDURE delete_dup_doc
IS

v_rec_count   number;
temp_count    number;

CURSOR doc_dup IS
SELECT rtrim(ltrim(error_text)) ac_idseq FROM xml_loader_errors
WHERE error_text like '%CC%';

--CURSOR to get the data elements
CURSOR rd(v_ac_idseq in varchar2) IS
SELECT rd_idseq FROM reference_documents
WHERE ac_idseq = v_ac_idseq;

BEGIN

FOR doc_dup_rec IN doc_dup LOOP           --loop through the error records
  v_rec_count := 1;

  --get all reference documents for the ac_idseq (de_idseq)
  FOR rd_rec IN rd(doc_dup_rec.ac_idseq) LOOP
    if (v_rec_count != 1) then
      delete from reference_documents where rd_idseq = rd_rec.rd_idseq;
    end if;
    v_rec_count := v_rec_count + 1;

  end loop;
  dbms_output.PUT_LINE( 'dup record count for ' || doc_dup_rec.ac_idseq|| ' is ' || v_rec_count);

end loop;

END delete_dup_doc;


PROCEDURE clean_staging_tables(p_datatype IN VARCHAR2)
IS
BEGIN
   DELETE FROM ac_class_schemes_staging
   WHERE ac_id IN (SELECT id FROM admin_components_staging WHERE actl_name = p_datatype);

   DELETE FROM ref_docs_staging
   WHERE ac_id IN (SELECT id FROM admin_components_staging WHERE actl_name = p_datatype);

   DELETE FROM definitions_staging
   WHERE ac_id IN (SELECT id FROM admin_components_staging WHERE actl_name = p_datatype);

   DELETE FROM designations_staging
   WHERE ac_id IN (SELECT id FROM admin_components_staging WHERE actl_name = p_datatype);

   DELETE FROM ac_submitters_staging
   WHERE ac_id IN (SELECT id FROM admin_components_staging WHERE actl_name = p_datatype);

   DELETE FROM xml_loader_errors
   WHERE ac_id IN (SELECT id FROM admin_components_staging WHERE actl_name = p_datatype);

   DELETE FROM admin_components_staging
   WHERE actl_name = p_datatype;

   IF p_datatype = 'DATAELEMENT' THEN
      DELETE FROM data_elements_staging;
      -- HSK
      --DELETE FROM source_data_loads
      --WHERE data_type = 'DE';
      DELETE FROM source_data_loads
      WHERE data_type = 'DE' and upper(substr(file_name, length(file_name)-2, 3))= 'CSV';
   ELSIF p_datatype = 'DE_CONCEPT' THEN
      DELETE FROM dec_relationships;
      DELETE FROM data_element_concepts_staging;
      DELETE FROM source_data_loads
      WHERE data_type = 'DEC' and upper(substr(file_name, length(file_name)-2, 3))= 'CSV';
   ELSIF p_datatype = 'VALUEDOMAIN' THEN
        DELETE FROM permissible_values_staging;
      DELETE FROM value_domains_staging;
      DELETE FROM source_data_loads
      WHERE (data_type = 'VD' or data_type = 'VV' ) and upper(substr(file_name, length(file_name)-2, 3))= 'CSV';
   ELSIF p_datatype = 'CONCEPTUALDOMAIN' THEN
        DELETE FROM conceptual_domains_staging;
      DELETE FROM source_data_loads
      WHERE data_type = 'CD'  and upper(substr(file_name, length(file_name)-2, 3))= 'CSV';
   ELSIF p_datatype = 'DECREL' THEN
        DELETE FROM decr_staging;
      DELETE FROM dec_staging;
      DELETE FROM source_data_loads
      WHERE data_type = 'DECR'  and upper(substr(file_name, length(file_name)-2, 3))= 'CSV';
   ELSIF p_datatype = 'OBJECTCLASS' THEN
        DELETE FROM object_classes_staging;
      DELETE FROM source_data_loads
      WHERE data_type = 'OC'  and upper(substr(file_name, length(file_name)-2, 3))= 'CSV';
   ELSIF p_datatype = 'PROPERTY' THEN
        DELETE FROM properties_staging;
      DELETE FROM source_data_loads
      WHERE data_type = 'PT'  and upper(substr(file_name, length(file_name)-2, 3))= 'CSV';
   ELSIF p_datatype = 'CLASSIFICATION' THEN
        DELETE FROM class_scheme_items_staging;
        DELETE FROM class_schemes_staging;
      DELETE FROM source_data_loads
      WHERE (data_type = 'CS' or data_type = 'CSI' ) and upper(substr(file_name, length(file_name)-2, 3))= 'CSV';
   ELSIF p_datatype = 'CSIREL' THEN
        DELETE FROM csir_staging;
      DELETE FROM csi_staging;
      DELETE FROM source_data_loads
      WHERE data_type = 'CSIR' and upper(substr(file_name, length(file_name)-2, 3))= 'CSV';
   ELSIF p_datatype = 'REPRESENTATION' THEN
        DELETE FROM representations_staging;
      DELETE FROM source_data_loads
      WHERE data_type = 'REP' and upper(substr(file_name, length(file_name)-2, 3))= 'CSV';
   ELSIF p_datatype = 'CONCEPT' THEN
        DELETE FROM concepts_staging;
      DELETE FROM source_data_loads
      WHERE data_type = 'CON' and upper(substr(file_name, length(file_name)-2, 3))= 'CSV';
   END IF;

   DELETE FROM xml_loader_errors;
   COMMIT;
END;



PROCEDURE load_oc IS

--get the valid source file for data element
CURSOR sde IS
SELECT * FROM source_data_loads
WHERE data_type = 'OC'
AND   file_dISposition = 'LOADED-SUCCESS';

--CURSOR to get the object_classes
CURSOR dec(b_sde_id in varchar2) IS
SELECT * FROM OBJECT_CLASSES_STAGING
WHERE sde_id = b_sde_id
and   NVL(record_status,'X') != 'LOADED';

v_oc_conte_idseq        contexts.conte_idseq%type;
v_asl_name              ac_status_lov.asl_name%type;
v_preferred_name        object_classes_ext.preferred_name%type;
v_preferred_definition  object_classes_ext.preferred_Definition%type;
v_errors                number := 0;
v_err                   number := 0;
v_name                  varchar2(30);
v_count                 number := 0;
v_error_count           number;
v_Exists                number := 0;
v_oc_idseq                object_classes_ext.oc_idseq%type;

BEGIN

FOR s_rec IN sde LOOP --start sde loop
  --get all object class load
  --dbms_output.put_line('sde id='||s_rec.id);
  v_error_count :=0;
  FOR oc_rec IN dec(s_rec.id) LOOP --start de loop
    --check to see if context for object classes exists
    --dbms_output.put_line('d_rec.id='||d_rec.id);
    v_errors := 0;
    v_oc_conte_idseq := get_conte_idseq(oc_rec.oc_conte_name,oc_rec.oc_conte_version);
    IF v_oc_conte_idseq is null then
      --XML_LOAD_ERR_HANDLE(oc_rec.id, 'Context for Object Classes Not found');
      XML_LOAD_ERR_HANDLE(oc_rec.id, 'Context, ' ||oc_rec.oc_conte_name || ',  for Object Classes, ' ||oc_rec.oc_preferred_name || ', Not found');
      v_errors := v_errors + 1;
    END IF;

    --check to see if workflow status exists
    if not  sbrext_common_routines.WORKFLOW_EXISTS(oc_rec.oc_workflow_status) then
      --XML_LOAD_ERR_HANDLE(oc_rec.id, 'Workflow Status Not found');
      XML_LOAD_ERR_HANDLE(oc_rec.id, 'Workflow Status, ' || oc_rec.oc_workflow_status||
        ', Object, ' ||oc_rec.oc_preferred_name|| ', Not found');
      v_errors := v_errors + 1;
    end if;

       v_oc_idseq := get_ac_idseq(oc_rec.OC_PREFERRED_NAME, v_oc_conte_idseq,
                               oc_rec.OC_VERSION, 'OBJECTCLASS');

    IF v_oc_idseq is not null then
      --XML_LOAD_ERR_HANDLE(oc_rec.id, 'Object Class already exists');
      XML_LOAD_ERR_HANDLE(oc_rec.id, 'Object Class, ' || oc_rec.OC_PREFERRED_NAME|| ', already exists');
      v_errors := v_errors + 1;
    END IF;

    IF v_errors = 0 then
      v_oc_idseq := admincomponent_crud.cmr_guid;
      BEGIN
        insert into object_classes_ext
        (OC_IDSEQ, PREFERRED_NAME, LONG_NAME, PREFERRED_DEFINITION, CONTE_IDSEQ,
         VERSION, ASL_NAME, LATEST_VERSION_IND, CHANGE_NOTE, BEGIN_DATE, END_DATE,
         DATE_CREATED, CREATED_BY, DELETED_IND, DATE_MODIFIED, MODIFIED_BY,
         definition_source, origin, oc_id)
        values
        (v_oc_idseq
        ,oc_rec.OC_PREFERRED_NAME
        ,oc_rec.OC_LONG_NAME
        ,oc_rec.OC_PREFERRED_DEFINITION
        ,v_oc_conte_idseq
        ,oc_rec.OC_VERSION
        ,oc_rec.oc_workflow_status
        ,'Yes'
        ,null
        ,to_date(oc_rec.begin_date,'RRRR-MM-DD')
        ,to_date(oc_rec.end_date,'RRRR-MM-DD')
        ,oc_rec.date_created
        ,oc_rec.created_by
        ,'No'
        ,null
        ,null
        ,null
        ,oc_rec.origin
        ,oc_rec.id);
      EXCEPTION WHEN OTHERS THEN
        XML_LOAD_ERR_HANDLE(oc_rec.id, sqlcode||'--'||sqlerrm||
          ' Error Inserting Object Classes ' ||oc_rec.OC_PREFERRED_NAME );
        v_errors := v_errors + 1;
      END;
    END IF;
    /*
    If v_errors = 0 then
      v_name := get_name('COMMENT');
      v_err := load_docs(oc_rec.id,v_oc_idseq, 'COMMENT',oc_rec.comments,v_name) ;
      if v_err = 1 then
        v_name := get_name('NOTE');
        v_err := load_docs(oc_rec.id,v_oc_idseq, 'NOTE',oc_rec.admin_note,v_name) ;
        if v_err = 1 then
          v_name := get_name('EXAMPLE');
          v_err := load_docs(oc_rec.id,v_oc_idseq, 'EXAMPLE',oc_rec.example,v_name) ;
          if v_err = 1 then
            v_err := load_ref_docs(oc_rec.id,v_oc_idseq);
            if v_err = 1 then
    */
              v_err := load_designations(oc_Rec.id,v_oc_idseq);
    /*
              if v_err = 1 then
                v_err := load_definitions(oc_Rec.id,v_oc_idseq);
                if v_err = 1 then
                  -- HSK only call this for DE loading
                  -- v_err := load_ac_class(oc_rec.id,v_oc_idseq);
                  --dbms_output.put_line(v_err);
                  if v_err = 1 then
                    v_err := load_acreg(oc_rec.id,v_oc_idseq);
    */
                    if v_err = 1 then
                      begin
                        update administered_components
                        set origin = oc_rec.origin,
                            unresolved_issue = oc_rec.unresolved_issue
                        where ac_idseq = v_oc_idseq;
                      exception when others then
                        rollback;
                        xml_load_err_handle(oc_rec.id, sqlcode||'--'||sqlerrm||
                                            '  Error updating Administered Components');
                        v_err := 0;
                      end;
                    end if;
    /*
                  end if;
                end if;
              end if;
    */
    /*
            end if;
          end if;
        end if;
      end if;
    End if;
    */
    if v_errors = 0 and v_err =1 then
      update object_classes_staging
      set record_status = 'LOADED'
      where id = oc_rec.id;
      commit;
    else
      v_error_count := v_error_count +1;
      rollback;
    end if;

  END LOOP; --end dec_loop

  begin
    update source_data_loads
    set rejected_records_count = v_error_count
    where id= s_rec.id;
    commit;
  exception
    when others then
      rollback;
      xml_load_err_handle(s_rec.id, sqlcode||'--'||sqlerrm||
                          '  Error updating Source Data Load');
  end;
END LOOP; --end sde loop

END;



PROCEDURE load_pt IS

--get the valid source file for PROPERTIES
CURSOR sde IS
SELECT * FROM source_data_loads
WHERE data_type = 'PT'
AND file_dISposition = 'LOADED-SUCCESS';

--CURSOR to get the properties
CURSOR dec(b_sde_id in varchar2) IS
SELECT * FROM PROPERTIES_STAGING
WHERE sde_id = b_sde_id
and NVL(record_status,'X') != 'LOADED';

v_prop_conte_idseq      contexts.conte_idseq%type;
v_asl_name              ac_status_lov.asl_name%type;
v_preferred_name        properties_ext.preferred_name%type;
v_preferred_definition  properties_ext.preferred_Definition%type;
v_errors                number := 0;
v_err                   number := 0;
v_name                  varchar2(30);
v_count                 number := 0;
v_error_count           number;
v_Exists                number := 0;
v_prop_idseq            properties_ext.PROP_IDSEQ%type;

BEGIN

FOR s_rec IN sde LOOP --start sde loop
  --get all properties load
  --dbms_output.put_line('sde id='||s_rec.id);
  v_error_count :=0;
  FOR prop_rec IN dec(s_rec.id) LOOP --start de loop
    --check to see if context for properties exists
    --dbms_output.put_line('d_rec.id='||d_rec.id);
    v_errors := 0;
    v_prop_conte_idseq := get_conte_idseq(prop_rec.PT_CONTE_NAME,prop_rec.PT_CONTE_VERSION);
    IF v_prop_conte_idseq is null then
      --XML_LOAD_ERR_HANDLE(prop_rec.id, 'Context for Properties Not found');
      XML_LOAD_ERR_HANDLE(prop_rec.id, 'Context, ' || prop_rec.PT_CONTE_NAME||
      ', for Properties, ' ||prop_rec.PT_PREFERRED_NAME || ', Not found');
      v_errors := v_errors + 1;
    END IF;

    --check to see if workflow status exists
    if not  sbrext_common_routines.WORKFLOW_EXISTS(prop_rec.PT_WORKFLOW_STATUS) then
      --XML_LOAD_ERR_HANDLE(prop_rec.id, 'Workflow Status Not found');
      XML_LOAD_ERR_HANDLE(prop_rec.id, 'Workflow Status, ' ||prop_rec.PT_WORKFLOW_STATUS || ', Not found');
      v_errors := v_errors + 1;
    end if;

       v_prop_idseq := get_ac_idseq(prop_rec.PT_PREFERRED_NAME, v_prop_conte_idseq,
                                 prop_rec.PT_VERSION, 'PROPERTY');

    IF v_prop_idseq is not null then
      --XML_LOAD_ERR_HANDLE(prop_rec.id, 'Properties already exists');
      XML_LOAD_ERR_HANDLE(prop_rec.id, 'Properties, ' || prop_rec.PT_PREFERRED_NAME|| ', already exists');
      v_errors := v_errors + 1;
    END IF;

    IF v_errors = 0 then
      v_prop_idseq := admincomponent_crud.cmr_guid;
      BEGIN
        insert into properties_ext
        (PROP_IDSEQ, PREFERRED_NAME, LONG_NAME, PREFERRED_DEFINITION, CONTE_IDSEQ,
         VERSION, ASL_NAME, LATEST_VERSION_IND, CHANGE_NOTE, BEGIN_DATE, END_DATE,
         DATE_CREATED, CREATED_BY, DELETED_IND, DATE_MODIFIED, MODIFIED_BY,
         origin, definition_source, prop_id)
        values
        (v_prop_idseq
        ,prop_rec.PT_PREFERRED_NAME
        ,prop_rec.PT_LONG_NAME
        ,prop_rec.PT_PREFERRED_DEFINITION
        ,v_prop_conte_idseq
        ,prop_rec.PT_VERSION
        ,prop_rec.PT_WORKFLOW_STATUS
        ,'Yes'
        ,null
        ,to_date(prop_rec.begin_date,'RRRR-MM-DD')
        ,to_date(prop_rec.end_date,'RRRR-MM-DD')
        ,prop_rec.date_created
        ,prop_rec.created_by
        ,'No'
        ,null
        ,null
        ,prop_rec.origin
        ,null
        ,prop_rec.id);
      EXCEPTION WHEN OTHERS THEN
        XML_LOAD_ERR_HANDLE(prop_rec.id, sqlcode||'--'||sqlerrm||
                            ' Error Inserting Properties_ext ' ||prop_rec.PT_PREFERRED_NAME);
        v_errors := v_errors + 1;
      END;
    END IF;
    /*
    If v_errors = 0 then
      v_name := get_name('COMMENT');
      v_err := load_docs(prop_rec.id,v_prop_idseq, 'COMMENT',prop_rec.comments,v_name) ;
      if v_err = 1 then
        v_name := get_name('NOTE');
        v_err := load_docs(prop_rec.id,v_prop_idseq, 'NOTE',prop_rec.admin_note,v_name) ;
        if v_err = 1 then
          v_name := get_name('EXAMPLE');
          v_err := load_docs(prop_rec.id,v_prop_idseq, 'EXAMPLE',prop_rec.example,v_name) ;
          if v_err = 1 then
            v_err := load_ref_docs(prop_rec.id,v_prop_idseq);
            if v_err = 1 then
    */
              v_err := load_designations(prop_Rec.id,v_prop_idseq);
    /*
              if v_err = 1 then
                v_err := load_definitions(prop_Rec.id,v_prop_idseq);
                if v_err = 1 then
                  -- HSK only call this for DE loading
                  -- v_err := load_ac_class(prop_rec.id,v_prop_idseq);
                  --dbms_output.put_line(v_err);
                  if v_err = 1 then
                    v_err := load_acreg(prop_rec.id,v_prop_idseq);
    */
                    if v_err = 1 then
                      begin
                        update administered_components
                        set origin = prop_rec.origin,
                        unresolved_issue = prop_rec.unresolved_issue
                        where ac_idseq = v_prop_idseq;
                      exception when others then
                        rollback;
                        xml_load_err_handle(prop_rec.id,sqlcode||'--'||sqlerrm||'  Error updating Administered Components');
                        v_err := 0;
                      end;
                    end if;
    /*
                  end if;
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    End if;
    */
    if v_errors = 0 and v_err =1 then
      update PROPERTIES_STAGING
      set record_status = 'LOADED'
      where id = prop_rec.id;
      commit;
    else
      v_error_count := v_error_count +1;
      rollback;
    end if;

  END LOOP; --end prop_loop

  begin
    update source_data_loads
    set rejected_records_count = v_error_count
    where id= s_rec.id;
    commit;
  exception
    when others then
      rollback;
      xml_load_err_handle(s_rec.id, sqlcode||'--'||sqlerrm||
                          '  Error updating Source Data Load');
  end;

END LOOP; --end sde loop

END;



PROCEDURE load_cs IS

--get the valid source file for classification schemes
CURSOR sde IS
SELECT * FROM source_data_loads
WHERE data_type = 'CS'
AND   file_dISposition = 'LOADED-SUCCESS';

--CURSOR to get the classification schemes
CURSOR dec(b_sde_id in varchar2) IS
SELECT * FROM CLASS_SCHEMES_STAGING
WHERE sde_id = b_sde_id
and   NVL(record_status,'X') != 'LOADED';

-- HSK use names instead of ID since CS and CSI are loaded into the staging table separately.
-- CURSOR csi(b_cs_id in number) IS
--S ELECT * FROM CLASS_SCHEME_ITEMS_STAGING
-- WHERE CS_ID = b_cs_id;

CURSOR csi(B_CS_PREFERRED_NAME in varchar2, B_CS_VERSION in number,
           B_CS_CONTE_NAME in varchar2, B_CS_CONTE_VERSION in number) IS
SELECT * FROM CLASS_SCHEME_ITEMS_STAGING
WHERE CS_PREFERRED_NAME = B_CS_PREFERRED_NAME
AND   CS_VERSION = B_CS_VERSION
AND   CS_CONTE_NAME = B_CS_CONTE_NAME
AND   CS_CONTE_VERSION = B_CS_CONTE_VERSION;

v_cs_conte_idseq        contexts.conte_idseq%type;
v_asl_name              ac_status_lov.asl_name%type;
v_preferred_name        classification_schemes.preferred_name%type;
v_preferred_definition  classification_schemes.preferred_Definition%type;
v_errors                number := 0;
v_err                   number := 0;
v_name                  varchar2(30);
v_count                 number := 0;
v_error_count           number;
v_Exists                number := 0;
v_cs_idseq                classification_schemes.cs_idseq%type;
v_partial_load          boolean := false;
v_err_csi               number :=0;
v_csi_idseq             class_scheme_items.csi_idseq%type;
v_csi_exists            number :=0;

BEGIN

FOR s_rec IN sde LOOP --start sde loop
  --get all classification schemes
  --dbms_output.put_line('sde id='||s_rec.id);
  v_error_count :=0;
  FOR d_rec IN dec(s_rec.id) LOOP --start de loop
    --check to see if context for calssification scheme exists
    --dbms_output.put_line('d_rec.id='||d_rec.id);
    v_errors := 0;
    v_Exists :=0;
    v_cs_conte_idseq := get_conte_idseq(d_rec.CS_CONTE_NAME, d_rec.CS_CONTE_VERSION);
    if v_cs_conte_idseq is null then
      --XML_LOAD_ERR_HANDLE(d_rec.id, 'Context for Classification scheme Not found');
      XML_LOAD_ERR_HANDLE(d_rec.id, 'Context, ' || d_rec.CS_CONTE_NAME|| ', for Classification scheme, '
      || d_rec.CS_PREFERRED_NAME|| ', Not found');
      v_errors := v_errors + 1;
    end if;
    --check to see if classification schemes exists
    v_cs_idseq := get_ac_idseq(d_rec.cs_preferred_name, v_cs_conte_idseq,
                               d_rec.cs_version, 'CLASSIFICATION');

    IF v_cs_idseq is not null then
      --XML_LOAD_ERR_HANDLE(d_rec.id, 'Classification schemes Alreay Exists');
      XML_LOAD_ERR_HANDLE(d_rec.id, 'Classification schemes,'|| d_rec.cs_preferred_name|| ', Alreay Exists');
      v_errors := v_errors + 1;
      v_Exists :=1;
    END IF;
    if get_cs_types(d_rec.CSTL_NAME) is null then
       --XML_LOAD_ERR_HANDLE(d_rec.id, 'CS Types not found');
       XML_LOAD_ERR_HANDLE(d_rec.id, 'CS Types, ' || d_rec.CSTL_NAME||
       'for classification, ' || d_rec.cs_preferred_name|| ', not found');
       v_errors := v_errors + 1;
    END IF;

    --check to see if workflow status exists
    if not  sbrext_common_routines.WORKFLOW_EXISTS(d_rec.cs_workflow_status) then
      --XML_LOAD_ERR_HANDLE(d_rec.id, 'Workflow Status Not found');
      XML_LOAD_ERR_HANDLE(d_rec.id, 'Workflow Status, ' || d_rec.cs_workflow_status|| ', Not found');
      v_errors := v_errors + 1;
    end if;

    IF v_errors = 0 then
      v_cs_idseq := admincomponent_crud.cmr_guid;
      BEGIN
        insert into classification_schemes
        (CS_IDSEQ, VERSION, PREFERRED_NAME, PREFERRED_DEFINITION, CONTE_IDSEQ,
         ASL_NAME, CSTL_NAME, LABEL_TYPE_FLAG, CMSL_NAME, LONG_NAME, LATEST_VERSION_IND,
         DELETED_IND, BEGIN_DATE, END_DATE, CHANGE_NOTE, DATE_CREATED, CREATED_BY,
         DATE_MODIFIED, MODIFIED_BY, origin, cs_id)
        values
        (v_cs_idseq
        ,d_rec.CS_VERSION
        ,d_rec.cs_preferred_name
        ,d_rec.CS_PREFERRED_DEFINITION
        ,v_cs_conte_idseq
        ,d_rec.cs_workflow_status
        ,d_rec.CSTL_NAME
        ,d_rec.LABEL_TYPE_FLAG
        ,d_rec.CMSL_NAME
        ,d_rec.CS_LONG_NAME
        ,'Yes'
        ,'No'
        ,to_date(d_rec.begin_date,'RRRR-MM-DD')
        ,to_date(d_rec.end_date,'RRRR-MM-DD')
        ,d_rec.ADMIN_NOTE
        ,d_rec.date_created
        ,d_rec.created_by
        ,null
        ,null
        ,d_rec.origin
        ,d_rec.id);
      EXCEPTION WHEN OTHERS THEN
        XML_LOAD_ERR_HANDLE(d_rec.id, sqlcode||'--'||sqlerrm||
                            ' Error Inserting Classification Schemes ' || d_rec.cs_preferred_name);
        v_errors := v_errors + 1;
      END;
    END IF;
    If v_errors = 0 then
      v_name := get_name('COMMENT');
      v_err := load_docs(d_rec.id,v_cs_idseq, 'COMMENT',d_rec.comments,v_name) ;
      if v_err = 1 then
        v_name := get_name('NOTE');
        v_err := load_docs(d_rec.id,v_cs_idseq, 'NOTE',d_rec.admin_note,v_name) ;
        if v_err = 1 then
          v_name := get_name('EXAMPLE');
          v_err := load_docs(d_rec.id,v_cs_idseq, 'EXAMPLE',d_rec.example,v_name) ;
          if v_err = 1 then
            v_err := load_ref_docs(d_rec.id,v_cs_idseq);
            if v_err = 1 then
              v_err := load_designations(d_Rec.id,v_cs_idseq);
              if v_err = 1 then
                v_err := load_definitions(d_Rec.id,v_cs_idseq);
                if v_err = 1 then
                  -- HSK only call this for DE loading
                  -- v_err := load_ac_class(d_rec.id,v_cs_idseq);
                  --dbms_output.put_line(v_err);
                  if v_err = 1 then
                    v_err := load_acreg(d_rec.id,v_cs_idseq);
                    if v_err = 1 then
                      begin
                        update administered_components
                        set origin = d_rec.origin,
                            unresolved_issue = d_rec.unresolved_issue
                        where ac_idseq = v_cs_idseq;
                      exception when others then
                        rollback;
                        xml_load_err_handle(d_rec.id, sqlcode||'--'||sqlerrm||
                                            '  Error updating Administered Components');
                        v_err := 0;
                      end;
                    end if;
                  end if;
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    End if;

    if (v_errors = 0 and v_err =1 and v_exists =0) or (v_exists =1)  then
      update CLASS_SCHEMES_STAGING
      set record_status = 'LOADED'
      where id = d_rec.id;
      commit;
      -- load class_scheme_items and cs_csi
      v_partial_load := false;

      -- HSK names instead of id to find cs' children records in csi staging table
      --for d_csi in csi(d_rec.id) loop
      for d_csi in csi(d_rec.CS_PREFERRED_NAME, d_rec.CS_VERSION, d_rec.CS_CONTE_NAME, d_rec.CS_CONTE_VERSION) loop
        v_err_csi :=0;
        v_csi_exists :=0;
        BEGIN
          if get_csi_types(d_csi.CSITL_NAME) is null then
            --XML_LOAD_ERR_HANDLE(d_rec.id, 'CSI Types Not found');
            XML_LOAD_ERR_HANDLE(d_rec.id, 'CSI Types, ' ||d_csi.CSITL_NAME ||
            ', for CSI,' ||d_csi.csi_name || ', Not found');
            v_err_csi := v_err_csi + 1;
          end if;
          if cs_item_exists(d_csi.CSI_NAME,d_csi.CSITL_NAME) then
            --XML_LOAD_ERR_HANDLE(d_rec.id, 'Class Scheme Items Already exists');
            XML_LOAD_ERR_HANDLE(d_rec.id, 'Class Scheme Items, ' ||d_csi.CSI_NAME || ', Already exists');
            v_err_csi := v_err_csi + 1;
            v_csi_exists :=1;
          end if;
          if v_err_csi =0 then
            v_csi_idseq := admincomponent_crud.cmr_guid;
            begin
              insert into class_scheme_items
              (CSI_IDSEQ, CSI_NAME, CSITL_NAME, DESCRIPTION, COMMENTS,
                DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY)
              values
              (v_csi_idseq,
               d_csi.csi_name,
               d_csi.csitl_name,
               d_csi.DESCRIPTION,
               d_csi.COMMENTS,
               d_csi.DATE_CREATED,
               d_csi.CREATED_BY,
               null,
               null);
            exception
              when others then
                v_partial_load := true;
                rollback;

                xml_load_err_handle(d_rec.id, sqlcode||'--'||sqlerrm
                                ||'  Error inserting CSI, ' || d_csi.csi_name ||
                                ' for CS, ' ||d_rec.CS_PREFERRED_NAME || ', and CSI, ' || d_csi.csi_name);
            end;
            begin
              insert into cs_csi
              (CS_CSI_IDSEQ, CS_IDSEQ, CSI_IDSEQ, P_CS_CSI_IDSEQ, LINK_CS_CSI_IDSEQ,
               LABEL, DISPLAY_ORDER, DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY)
              values
              (admincomponent_crud.cmr_guid,
               v_cs_idseq,
               v_csi_idseq,
               null,
               null,
               d_csi.LABEL,
               d_csi.DISPLAY_ORDER,
               d_csi.DATE_CREATED,
               d_csi.CREATED_BY,
               null,
               null);
            exception
              when others then
                v_partial_load := true;
                rollback;
                xml_load_err_handle(d_rec.id, sqlcode||'--'||sqlerrm
                                ||'  Error insert CS CSI');
            end;
            update CLASS_SCHEME_ITEMS_STAGING
            set record_status = 'LOADED'
            where id = d_csi.id;
            commit;
          else
            v_partial_load := true;
            if v_csi_exists = 1 then
                 update CLASS_SCHEME_ITEMS_STAGING
              set record_status = 'EXISTS IN DB'
              where id = d_csi.id;
              commit;
            end if;
          end if;
        END;
      end loop;
      if v_partial_load then
        update CLASS_SCHEMES_STAGING
        set record_status = 'PARTIAL-LOADED'
        where id = d_rec.id;
        commit;
      end if;
    else
      v_error_count := v_error_count +1;
      rollback;
    end if;

  END LOOP; --end dec_loop

  begin
    update source_data_loads
    set rejected_records_count = v_error_count
    where id= s_rec.id;
    commit;
  exception
    when others then
      rollback;
      xml_load_err_handle(s_rec.id, sqlcode||'--'||sqlerrm||
                          '  Error updating Source Data Load');
  end;

  END LOOP; --end sde loop

END;



FUNCTION get_cs_types(p_cstl_name in varchar2)
return varchar2
IS
   v_cstl_name cs_types_lov.CSTL_NAME%type;
begin
   select cstl_name
   into   v_cstl_name
   from   cs_types_lov
   where  cstl_name= p_cstl_name;
   return v_cstl_name;
exception
   when others then
      return null;
end;



FUNCTION get_csi_types(p_cstl_name in varchar2)
return varchar2
IS
   v_cstl_name csi_types_lov.CSITL_NAME%type;
begin
   select csitl_name
   into   v_cstl_name
   from   csi_types_lov
   where  csitl_name = p_cstl_name;
   return v_cstl_name;
exception
   when others then
      return null;
end;



FUNCTION cs_item_exists(p_csi_name in varchar2, p_csitl_name in varchar2)
return boolean
IS
   v_count number :=0;
begin
   select count(*)
   into   v_count
   from   class_scheme_items
   where  csi_name = p_csi_name
   and    csitl_name = p_csitl_name;
   if v_count > 0 then
      return true;
   else
      return false;
   end if;
exception
   when others then
      return false;
end;


PROCEDURE load_csir is

--get the valid source file for csir recs
CURSOR sde IS
    SELECT * FROM source_data_loads
    WHERE data_type = 'CSIR'
    AND   file_dISposition = 'LOADED-SUCCESS';

--CURSOR to get the csir recs
CURSOR dec(b_sde_id in varchar2) IS
    SELECT * FROM csi_staging
    WHERE sde_id = b_sde_id
    and   NVL(record_status,'X') != 'LOADED';


CURSOR decr(b_dcs_id in number) IS
    SELECT * FROM csir_staging
    where cst_id = b_dcs_id
    and   NVL(record_status,'X') != 'LOADED';

v_errors            number := 0;
v_err               number := 0;
v_error_count       number;
v_csi_idseq         class_scheme_items.csi_idseq%TYPE;
v_csir_idseq        class_scheme_items.csi_idseq%type;
v_decr_conte_idseq  contexts.CONTE_IDSEQ%TYPE;
v_decr_idseq        data_element_concepts.DEC_IDSEQ%TYPE;
v_partial_load      boolean :=false;

BEGIN
  FOR s_rec IN sde LOOP --start sde loop
  --get all csi staging record
    v_error_count :=0;
    FOR d_rec IN dec(s_rec.id) LOOP --start dec loop
      v_errors := 0;
      v_partial_load := false;

      v_csi_idseq := get_csi_idseq(d_rec.csi_name,d_rec.csitl_name);
      if v_csi_idseq is null then
        if get_csi_types(d_rec.CSITL_NAME) is null then
          XML_LOAD_ERR_HANDLE(d_rec.id, 'CSI Types Not found');
          v_errors := v_errors + 1;
        end if;
        if v_errors = 0 then
          begin
            v_csi_idseq := admincomponent_crud.cmr_guid;
            insert into class_scheme_items
            (CSI_IDSEQ, CSI_NAME, CSITL_NAME, DESCRIPTION, COMMENTS,
              DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY)
            values
            (v_csi_idseq,
             d_rec.csi_name,
             d_rec.csitl_name,
             null,
             null,
             d_rec.DATE_CREATED,
             d_rec.CREATED_BY,
             null,
             null);
            commit;
          exception
            when others then
              v_errors := v_errors+1;
              rollback;
              XML_LOAD_ERR_HANDLE(d_rec.id, 'Error for inserting Class Scheme Items');
          end;
        end if;
      end if;

      if v_errors = 0 then
        FOR decr_rec in decr(d_rec.id) LOOP
          v_err := 0;
           v_csir_idseq := get_csi_idseq(decr_rec.csi_name,decr_rec.csitl_name);
          if v_csir_idseq is null then
            -- not found then created class_scheme_items
            if get_csi_types(decr_rec.CSITL_NAME) is null then
              XML_LOAD_ERR_HANDLE(d_rec.id, 'CSIR Types Not found');
              v_err := v_err + 1;
            end if;
            if v_err = 0 then
              begin
                v_csir_idseq := admincomponent_crud.cmr_guid;
                insert into class_scheme_items
                (CSI_IDSEQ, CSI_NAME, CSITL_NAME, DESCRIPTION, COMMENTS,
                  DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY)
                values
                (v_csir_idseq,
                 decr_rec.csi_name,
                 decr_rec.csitl_name,
                 decr_rec.description,
                 decr_rec.comments,
                 decr_rec.DATE_CREATED,
                 decr_rec.CREATED_BY,
                 null,
                 null);
                exception
                when others then
                  v_err := v_err+1;
                  rollback;
                  XML_LOAD_ERR_HANDLE(d_rec.id, 'Error for inserting Child Class Scheme Items');
              end;
            end if;
          end if;
          if not get_rl_name(decr_rec.rel_name) then
            XML_LOAD_ERR_HANDLE(d_rec.id, 'Relationship name for CSIR Not found');
            v_err := v_err + 1;
          end if;
          -- Check if the relationship exists
          if get_csi_rel(v_csi_idseq,v_csir_idseq) then
            XML_LOAD_ERR_HANDLE(d_rec.id, 'CSI relationship exists');
            v_err := v_err + 1;
          end if;
          if v_err = 0 then
            begin
              insert into csi_recs
              (CSI_REC_IDSEQ, P_CSI_IDSEQ, C_CSI_IDSEQ, RL_NAME,
               DATE_CREATED, CREATED_BY, DATE_MODIFIED, MODIFIED_BY)
              values
              (admincomponent_crud.cmr_guid,
               v_csi_idseq,
               v_csir_idseq,
               decr_rec.rel_name,
               sysdate,
               user,
               null,
               null);
              update csir_staging
              set record_status ='LOADED'
              where id = decr_rec.id;
              commit;
            exception
              when others then
                   v_partial_load := true;
                rollback;
                XML_LOAD_ERR_HANDLE(d_rec.id, sqlcode||'--'||sqlerrm||
                                    ' Error Inserting CSIR_RECS');
             end;
          else
            v_partial_load := true;
          end if;
        END LOOP;  --decr_rec loop
        begin
          if not v_partial_load then
            update csi_staging
            set record_status = 'LOADED'
            where id = d_rec.id;
          else
            update csi_staging
            set record_status = 'PARTIAL-LOADED'
            where id = d_rec.id;
          end if;
          commit;
        exception
          when others then
          rollback;
          xml_load_err_handle(d_rec.id, sqlcode||'--'||sqlerrm||
                              '  Error updating CSI_STAGING');
        end;
      else
        v_error_count := v_error_count +1;
      end if;

    END LOOP;  --d_rec loop

    begin
      update source_data_loads
      set rejected_records_count = v_error_count
      where id= s_rec.id;
      commit;
    exception
      when others then
         rollback;
         xml_load_err_handle(s_rec.id,sqlcode||'--'||sqlerrm||'  Error updating Source Data Load');
    end;

  END LOOP;     --s_rec loop

END;



FUNCTION get_csi_rel(p_d_idseq in varchar2, p_csi_idseq in varchar2)
return boolean
is
   v_count number(1) :=0;
begin
   select count(*)
   into   v_count
   from   csi_recs
   where  p_csi_idseq = p_d_idseq
   and    c_csi_idseq = p_csi_idseq;
   if v_count > 0 then
      return true;
   else
      return false;
   end if;
exception
   when others then
      return false;
end;



PROCEDURE load_rep IS

--get the valid source file for data element
CURSOR sde IS
SELECT * FROM source_data_loads
WHERE data_type = 'REP'
AND   file_disposition = 'LOADED-SUCCESS';

--CURSOR to get the object_classes
CURSOR rep(b_sde_id in varchar2) IS
SELECT * FROM REPRESENTATIONS_STAGING
WHERE sde_id = b_sde_id
and   NVL(record_status,'X') != 'LOADED';

v_rep_conte_idseq       contexts.conte_idseq%type;
v_asl_name              ac_status_lov.asl_name%type;
v_preferred_name        representations_ext.preferred_name%type;
v_preferred_definition  representations_ext.preferred_definition%type;
v_errors                number := 0;
v_err                   number := 0;
v_name                  varchar2(30);
v_count                 number := 0;
v_error_count           number;
v_exists                number := 0;
v_rep_idseq                representations_ext.rep_idseq%type;

BEGIN

FOR s_rec IN sde LOOP --start sde loop
  --get all object class load
  --dbms_output.put_line('sde id='||s_rec.id);
  v_error_count :=0;
  FOR rep_rec IN rep(s_rec.id) LOOP --start rep loop
    --check to see if context for representations exists
    --dbms_output.put_line('d_rec.id='||d_rec.id);
    v_errors := 0;
    v_rep_conte_idseq := get_conte_idseq(rep_rec.rep_conte_name,rep_rec.rep_conte_version);
    IF v_rep_conte_idseq is null then
      XML_LOAD_ERR_HANDLE(rep_rec.id, 'Context for Representations Not found');
      v_errors := v_errors + 1;
    END IF;

    --check to see if workflow status exists
    if not  sbrext_common_routines.WORKFLOW_EXISTS(rep_rec.rep_workflow_status) then
      --XML_LOAD_ERR_HANDLE(rep_rec.id, 'Workflow Status Not found');
      XML_LOAD_ERR_HANDLE(rep_rec.id, 'Workflow Status, ' ||rep_rec.rep_workflow_status ||
        'for Representation, ' ||rep_rec.rep_preferred_name || ',  Not found');
      v_errors := v_errors + 1;
    end if;

       v_rep_idseq := get_ac_idseq(rep_rec.REP_PREFERRED_NAME, v_REP_conte_idseq,
                                rep_rec.REP_VERSION, 'REPRESENTATION');

    IF v_rep_idseq is not null then
      --XML_LOAD_ERR_HANDLE(rep_rec.id, 'Representation already exists');
      XML_LOAD_ERR_HANDLE(rep_rec.id, 'Representation, ' ||rep_rec.REP_PREFERRED_NAME || ', already exists');
      v_errors := v_errors + 1;
    END IF;

    IF v_errors = 0 then
      v_rep_idseq := admincomponent_crud.cmr_guid;
      BEGIN
        insert into representations_ext
        (REP_IDSEQ, PREFERRED_NAME, LONG_NAME, PREFERRED_DEFINITION, CONTE_IDSEQ,
         VERSION, ASL_NAME, LATEST_VERSION_IND, CHANGE_NOTE, BEGIN_DATE, END_DATE,
         DATE_CREATED, CREATED_BY, DELETED_IND, DATE_MODIFIED, MODIFIED_BY,
         definition_source, origin, rep_id)
        values
        (v_rep_idseq
        ,rep_rec.REP_PREFERRED_NAME
        ,rep_rec.REP_LONG_NAME
        ,rep_rec.REP_PREFERRED_DEFINITION
        ,v_rep_conte_idseq
        ,rep_rec.REP_VERSION
        ,rep_rec.rep_workflow_status
        ,'Yes'
        ,null
        ,to_date(rep_rec.begin_date,'RRRR-MM-DD')
        ,to_date(rep_rec.end_date,'RRRR-MM-DD')
        ,rep_rec.date_created
        ,rep_rec.created_by
        ,'No'
        ,null
        ,null
        ,null
        ,rep_rec.origin
        ,rep_rec.id);
      EXCEPTION WHEN OTHERS THEN
        XML_LOAD_ERR_HANDLE(rep_rec.id, sqlcode||'--'||sqlerrm||
          ' Error Inserting Representations ' || rep_rec.REP_PREFERRED_NAME);
        v_errors := v_errors + 1;
      END;
    END IF;
    /*
    If v_errors = 0 then
      v_name := get_name('COMMENT');
      v_err := load_docs(rep_rec.id,v_rep_idseq, 'COMMENT',rep_rec.comments,v_name) ;
      if v_err = 1 then
        v_name := get_name('NOTE');
        v_err := load_docs(rep_rec.id,v_rep_idseq, 'NOTE',rep_rec.admin_note,v_name) ;
        if v_err = 1 then
          v_name := get_name('EXAMPLE');
          v_err := load_docs(rep_rec.id,v_rep_idseq, 'EXAMPLE',rep_rec.example,v_name) ;
          if v_err = 1 then
            v_err := load_ref_docs(rep_rec.id,v_rep_idseq);
            if v_err = 1 then
    */
              v_err := load_designations(rep_Rec.id,v_rep_idseq);
    /*
              if v_err = 1 then
                v_err := load_definitions(rep_Rec.id,v_rep_idseq);
                if v_err = 1 then
                  -- HSK only call this for DE loading
                  -- v_err := load_ac_class(rep_rec.id,v_rep_idseq);
                  --dbms_output.put_line(v_err);
                  if v_err = 1 then
                    v_err := load_acreg(rep_rec.id,v_rep_idseq);
    */
                    if v_err = 1 then
                      begin
                        update administered_components
                        set origin           = rep_rec.origin,
                            unresolved_issue = rep_rec.unresolved_issue
                        where ac_idseq = v_rep_idseq;
                      exception when others then
                        rollback;
                        xml_load_err_handle(rep_rec.id, sqlcode||'--'||sqlerrm||
                                            '  Error updating Administered Components');
                        v_err := 0;
                      end;
                    end if;
    /*
                  end if;
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    End if;
    */
    if v_errors = 0 and v_err = 1 then
      update representations_staging
      set record_status = 'LOADED'
      where id = rep_rec.id;
      commit;
    else
      v_error_count := v_error_count +1;
      rollback;
    end if;

  END LOOP; --end dec_loop

  begin
    update source_data_loads
    set rejected_records_count = v_error_count
    where id = s_rec.id;
    commit;
  exception
    when others then
      rollback;
      xml_load_err_handle(s_rec.id, sqlcode||'--'||sqlerrm||
                          '  Error updating Source Data Load');
  end;
END LOOP; --end sde loop

END;

/******************************************************************************
   NAME:       caDSR_XLS_LOADER_PKG. LOad CON
   PURPOSE:    To load data FROM XLS staging into DE.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/17/2005 Prerna Aggarwal    Created thIS procedure.
*****************************************************************************
*/
PROCEDURE load_con IS

--get the valid source file for Concept
CURSOR sde IS
SELECT * FROM source_data_loads
WHERE data_type = 'CON'
AND file_disposition = 'LOADED-SUCCESS';

--CURSOR to get the Concepts
CURSOR con(b_sde_id in varchar2) IS
SELECT * FROM concepts_staging
WHERE sde_id = b_sde_id;


v_con_conte_idseq        contexts.conte_idseq%type;
v_con_idseq             concepts_ext.con_idseq%type;
v_asl_name              ac_status_lov.asl_name%type;
v_preferred_name        concepts_ext.preferred_name%type;
v_preferred_definition  concepts_ext.preferred_Definition%type;
v_errors                number := 0;
v_err                   number := 0;
v_name                  varchar2(30);
v_count                 number;
v_error_count           number;
v_exists                boolean;
v_con_existed_ind        boolean;

BEGIN

FOR s_rec IN sde LOOP --start sde loop
  v_error_count := 0;
  --get all Concepts
  FOR c_rec IN con(s_rec.id) LOOP --start de loop

    v_con_existed_ind := false;
    --check to see if context for Concept exists
    v_errors := 0;
    v_con_conte_idseq := get_conte_idseq(nvl(c_rec.con_conte_name,'NCIP'),
                                        nvl(c_rec.con_conte_version,1.0));    --GF32649 changed caBIG to NCIP
    IF v_con_conte_idseq is null then
      XML_LOAD_ERR_HANDLE(c_rec.id, 'Context, ' ||  c_rec.con_conte_name ||
        ', for Concept, ' || c_rec.CON_PREFERRED_NAME ||  ', Not found');
      v_errors := v_errors + 1;
    END IF;

 

    --check to see if workflow status exists
    if not  sbrext_common_routines.WORKFLOW_EXISTS(nvl(c_rec.con_workflow_status,'RELEASED')) then
      XML_LOAD_ERR_HANDLE(c_rec.id, 'Workflow Status , ' ||  c_rec.con_workflow_status ||
        ', for Concept, ' || c_rec.CON_PREFERRED_NAME ||  ', Not found');
      v_errors := v_errors + 1;
    END if;

    -- check to see if Concept already exists
      v_con_idseq := get_ac_idseq(c_rec.con_preferred_name, v_con_conte_idseq,
                               nvl(c_rec.con_version,1), 'CONCEPT');
    IF v_con_idseq is not null then
      XML_LOAD_ERR_HANDLE(c_rec.id, 'WARNING: Concept, ' || c_rec.con_PREFERRED_NAME ||  ', Already Exists.');
      v_con_existed_ind := true;
    END IF;

    IF v_errors = 0 then
     -- HSK if already exists in concepts_ext table, do not enter the de record.
     IF v_con_idseq is null then
       v_con_idseq := admincomponent_crud.cmr_guid;

       BEGIN
       dbms_output.put_line(c_Rec.con_preferred_name);
         insert into concepts_ext
           (con_idseq, version, conte_idseq, preferred_name,
            preferred_definition, asl_name, long_name, latest_version_ind,
            deleted_ind, date_created, begin_date, created_by, end_date,
             origin, definition_Source,evs_source,change_note)
         values
           (v_con_idseq
           ,nvl(c_rec.con_version,1.0)
           ,v_con_conte_idseq
           ,c_rec.con_preferred_name
           ,nvl(c_rec.con_preferred_definition, 'No value exists.')
           ,nvl(c_rec.con_workflow_status,'RELEASED')
           ,c_rec.con_long_name
           ,'Yes'
           ,'No'
           ,c_rec.date_created
           ,to_date(c_rec.begin_date,'RRRR-MM-DD')
           ,c_rec.created_by
           ,to_date(c_rec.end_date,'RRRRR-MM-DD')
           ,c_rec.origin
           ,c_rec.con_Definition_Source
           ,c_rec.con_evs_source,c_rec.change_note);
           dbms_output.put_line(c_Rec.con_preferred_name||'loaded');
         EXCEPTION WHEN OTHERS THEN
           XML_LOAD_ERR_HANDLE(c_rec.id, sqlcode||'--'||sqlerrm||' Error Inserting Concept ' || c_rec.con_preferred_name);
           v_errors := v_errors + 1;
         END;
        END IF;
    END IF;
    -- HSK
    -- To process multiple occurrences of COMMENT, NOTE, and EXAMPLE,
    -- these informations are loaded into the ref_docs_staging table
    -- instead of concepts_ext_staging table.The load_docs will not load
    -- these inforamtion since there is no comments, note, and example
    -- in the concepts_ext_staging table (and still return v_err = 1)

    -- regardless of DE existed or DE newluy inserted successfully
 
    -- HSK update LOADED status
    --if v_errors = 0 and v_err =1 then
    if v_errors = 0 and v_con_existed_ind = false then -- new DE loaded
      update concepts_staging
      set record_status = 'LOADED'
      where id = c_rec.id;
      commit;
    else
      v_error_count := v_error_count +1;
      rollback;
    end if;

  END LOOP; --end con_loop

  -- v_error_count for only DE load
  begin
    update source_data_loads
    set rejected_records_count = v_error_count
    where id= s_rec.id;
    commit;
  exception
    when others then
      rollback;
      xml_load_err_handle(s_rec.id,sqlcode||'--'||sqlerrm||'  Error updating Source Data Load');
  end;
END LOOP; --end sde loop

END;

FUNCTION get_con_array(p_con_array in varchar2) return varchar2 is
v_con_Array varchar2(500):= null;
i number := 1;
v_con_String varchar2(500) := p_con_array;
v_con_idseq char(36);
v_con varchar2(30);
begin


 WHILE (i != 0 AND v_con_string IS NOT NULL) LOOP
      i := INSTR(v_con_string ,',');

      IF i = 0 THEN
        v_con := TRIM(v_con_string);
      ELSE
        v_con := TRIM(SUBSTR(v_con_string,1,i-1));
      END IF;
      v_con_string := SUBSTR(v_con_string,i+1);
      
      begin
      
    

      SELECT con_idseq INTO v_con_idseq
      FROM CONCEPTS_EXT
      WHERE deleted_ind = 'No'
      AND preferred_name = v_con;
      
      if v_con_Array is null then
        v_con_array := v_con_idseq;
      else 
        v_con_array := v_con_array||','||v_con_idseq;
      end if;
      
      exception when others then
       return 'Error';
      end;
     

    END LOOP;
    
    return v_Con_Array;
end;

END caDSR_XLS_LOADER_PKG_WORK3;

/

  GRANT EXECUTE ON "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" TO "CDEBROWSER";
 
  GRANT DEBUG ON "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" TO "CDEBROWSER";
 
  GRANT EXECUTE ON "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" TO "DATA_LOADER";
 
  GRANT DEBUG ON "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" TO "DATA_LOADER";
 
  GRANT EXECUTE ON "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" TO "SBR" WITH GRANT OPTION;
 
  GRANT DEBUG ON "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" TO "SBR" WITH GRANT OPTION;
 
  GRANT EXECUTE ON "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" TO "APPLICATION_USER";
 
  GRANT DEBUG ON "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" TO "APPLICATION_USER";
 
  GRANT EXECUTE ON "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" TO "DER_USER";
