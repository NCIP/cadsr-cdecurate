CREATE OR REPLACE TRIGGER SBREXT."CON_BIU_ROW_ASSIGN" 
 BEFORE INSERT OR UPDATE
 ON SBREXT.CONCEPTS_EXT  REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
-- PL/SQL Block
BEGIN
  if INSERTING then
     if  :new.latest_version_ind is null then
         :new.latest_version_ind:='Yes';
     end if;
     if :new.con_idseq is null Then
        :new.con_idseq :=admincomponent_crud.cmr_guid;
     end if;
	      if :new.deleted_ind is null then
        :new.deleted_ind := 'No';
     end if;

     if :new.created_by is null Then
        :new.created_by:=admin_security_util.effective_user;
     end if;
     if :new.date_created is null Then
        :new.date_created:=sysdate;
     end if;
     if :new.begin_date is null Then --GF32724
        :new.begin_date:=sysdate;
     end if;
	 if nvl(meta_global_pkg.transaction_type,'null') <> 'VERSION' then
	   select cde_id_seq.nextval into :new.con_id
	   from dual;
	 end if;
   elsif UPDATING then
    :new.modified_by := admin_security_util.effective_user;
       :new.date_modified := sysdate;

   end if;
  
END;

/

