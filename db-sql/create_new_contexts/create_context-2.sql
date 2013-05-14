set serveroutput on size 1000000

declare
--declare the variables

v_context_name varchar2(30) := 'USC/NCCC';
v_description varchar2(2000):= 'USC/Norris Comprehensive Cancer Center';
v_conte_count NUMBER;
v_sc_count NUMBER;
v_sc_conte_count NUMBER;
v_scl_name  VARCHAR2(30) := trim(SUBSTR(v_context_name,1,27))||'_SC';  --comment out upper 121002 for p_context_name
v_conte_idseq CHAR(36);


--declare procedure to create a group for the context

PROCEDURE create_group(p_group_name IN VARCHAR2
                       ,p_type IN VARCHAR2
                       ,p_scl_name IN VARCHAR2) IS
  v_scg_idseq CHAR(36);
  v_brl_name VARCHAR2(30);


  CURSOR actl IS
  SELECT actl_name
  FROM AC_TYPES_LOV_VIEW;

--this procedure inserts the groups_view

  PROCEDURE insert_group(p_group_name IN VARCHAR2) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count
    FROM GROUPS_VIEW
    WHERE grp_name = p_group_name;

    IF(v_count = 0) THEN
      INSERT INTO GROUPS_VIEW VALUES
      (p_group_name
      ,p_group_name
      ,USER
      ,SYSDATE
      ,NULL
      ,NULL);
    END IF;
  END;

-- this procedure assigns security context to the group

  PROCEDURE  create_sc_group(p_scl_name IN VARCHAR2
                 ,p_group_name IN VARCHAR2
                 ,p_scg_idseq OUT CHAR) IS
  BEGIN
    SELECT scg_idseq INTO p_scg_idseq
    FROM SC_GROUPS_VIEW
    WHERE scl_name = p_scl_name
    AND grp_name = p_group_name;

  EXCEPTION WHEN NO_DATA_FOUND THEN
    p_scg_idseq := admincomponent_crud.cmr_guid;
    INSERT INTO SC_GROUPS_VIEW VALUES(p_scg_idseq
                                ,p_scl_name
                                ,p_group_name
                                ,USER
                                ,SYSDATE
                                ,NULL
                                ,NULL);
  END;

-- this procedure assigns business roles for the security context in the group

  PROCEDURE create_grp_br(p_scg_idseq IN CHAR,
                p_brl_name IN VARCHAR2,
                p_actl_name IN VARCHAR2) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count
    FROM GRP_BUSINESS_ROLES_VIEW
    WHERE actl_name = p_actl_name
    AND brl_name = p_brl_name
    AND scg_idseq = p_scg_idseq;

    IF(v_count = 0) THEN
      INSERT INTO GRP_BUSINESS_ROLES_VIEW(GBR_IDSEQ      
                                          ,SCG_IDSEQ      
                                          ,BRL_NAME       
                                          ,ACTL_NAME      
                                          ,CREATED_BY     
                                          ,DATE_CREATED   
                                          ,MODIFIED_BY    
                                          ,DATE_MODIFIED)   VALUES
      (admincomponent_crud.cmr_guid
      ,p_scg_idseq
      ,p_brl_name
      ,p_actl_name
      ,USER
      ,SYSDATE
      ,NULL
     ,NULL);
    END IF;
  END;




BEGIN
 insert_group(p_group_name);
 create_sc_group(p_scl_name
                 ,p_group_name
                 ,v_scg_idseq);

 if p_type <> 'FORM_BUILDER' then

   v_brl_name := 'CDE '||p_type;
   FOR a_rec IN actl LOOP

    create_grp_br(v_scg_idseq,
                v_brl_name,
                a_rec.actl_name);
   END LOOP;
 else


   v_brl_name := 'CDE MANAGER';
   create_grp_br(v_scg_idseq,
                v_brl_name,
                'QUEST_CONTENT');
 end if;

END;

-- this procedure addes the context to 'ALL_BOWSER' and 'ALL_MANAGER' groups_view

PROCEDURE add_all(p_scl_name in varchar2,p_type in varchar2) is

  CURSOR actl IS
  SELECT actl_name
  FROM AC_TYPES_LOV_VIEW;

  v_scg_idseq  char(36);
  v_grp_name varchar2(30) := 'ALL_'||p_type;
  v_role_name varchar2(30) := 'CDE '||p_type;

  PROCEDURE  create_sc_group(p_scl_name IN VARCHAR2
                 ,p_group_name IN VARCHAR2
                 ,p_scg_idseq OUT CHAR) IS
  BEGIN
    SELECT scg_idseq INTO p_scg_idseq
    FROM SC_GROUPS_VIEW
    WHERE scl_name = p_scl_name
    AND grp_name = p_group_name;

  EXCEPTION WHEN NO_DATA_FOUND THEN
    p_scg_idseq := admincomponent_crud.cmr_guid;
    INSERT INTO SC_GROUPS_VIEW VALUES(p_scg_idseq
                                ,p_scl_name
                                ,p_group_name
                                ,USER
                                ,SYSDATE
                                ,NULL
                                ,NULL);
  END;

  PROCEDURE create_grp_br(p_scg_idseq IN CHAR,
                p_brl_name IN VARCHAR2,
                p_actl_name IN VARCHAR2) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count
    FROM GRP_BUSINESS_ROLES_VIEW
    WHERE actl_name = p_actl_name
    AND brl_name = p_brl_name
    AND scg_idseq = p_scg_idseq;

    IF(v_count = 0) THEN
      INSERT INTO GRP_BUSINESS_ROLES_VIEW(GBR_IDSEQ      
                                          ,SCG_IDSEQ      
                                          ,BRL_NAME       
                                          ,ACTL_NAME      
                                          ,CREATED_BY     
                                          ,DATE_CREATED   
                                          ,MODIFIED_BY    
                                          ,DATE_MODIFIED) VALUES
      (admincomponent_crud.cmr_guid
      ,p_scg_idseq
      ,p_brl_name
      ,p_actl_name
      ,USER
      ,SYSDATE
      ,NULL
     ,NULL);
    END IF;
  END;


begin

 create_sc_group(p_scl_name
                 ,v_grp_name
                 ,v_scg_idseq);

 FOR a_rec IN actl LOOP

  create_grp_br(v_scg_idseq,
                v_role_name,  
                a_rec.actl_name);
 END LOOP;

end;

BEGIN

--check to see if context already exists
dbms_output.put_line(1);
SELECT COUNT(*) INTO v_conte_count
FROM contexts_view
WHERE name = v_context_name;

IF v_conte_count = 0 THEN
  --insert into context
     v_conte_idseq := admincomponent_crud.cmr_guid;
     INSERT INTO contexts_view VALUES
      (  v_conte_idseq
        ,v_context_name
        ,'UNASSIGNED'
        ,'UNASSIGNED'
        ,v_description
        ,'ENGLISH'
        ,1
        ,USER
        ,SYSDATE
        ,NULL
        ,NULL);
ELSE
 SELECT conte_idseq INTO v_conte_idseq
 FROM contexts_view
 WHERE name = v_context_name;
END IF;

-- check to see if security context for context already exists
SELECT COUNT(*) INTO v_sc_count
FROM security_contexts_lov_view
WHERE scl_name = v_scl_name;

IF v_sc_count = 0 THEN

  -- insert the security context
     INSERT INTO security_contexts_lov_view VALUES
      (v_scl_name
       ,'Security Context for '||v_context_name
       ,USER
       ,SYSDATE
       ,NULL
       ,NULL  );
END IF;

--link the context with the security context
 -- check to see if the link already exists
SELECT COUNT(*) INTO v_sc_conte_count
FROM SC_CONTEXTS_VIEW
WHERE conte_idseq = v_conte_idseq;

--if the link does not exist create the link
IF v_sc_conte_count = 0 THEN
   INSERT INTO SC_CONTEXTS_VIEW VALUES
     ( v_conte_idseq
       ,v_scl_name
       ,USER
       ,SYSDATE
       ,NULL
       ,NULL);
END IF;

-- create the manager group

create_group(SUBSTR(trim(REPLACE(v_context_name,' ','_')),1,12)||'_MANAGER'
                       ,'MANAGER'
                       ,v_scl_name);

-- create the browser group

create_group(SUBSTR(trim(REPLACE(v_context_name,' ','_')),1,12)||'_BROWSER'
                       ,'BROWSER'
                       ,v_scl_name);

-- create the form builder group

create_group(SUBSTR(trim(REPLACE(v_context_name,' ','_')),1,7)||'_FORM_BUILDER'
                       ,'FORM_BUILDER'
                       ,v_scl_name);

--assign the context to all_Browser and all_manager group

add_all(v_scl_name,'BROWSER');
add_all(v_scl_name,'MANAGER');

END create_context;

/


commit;


