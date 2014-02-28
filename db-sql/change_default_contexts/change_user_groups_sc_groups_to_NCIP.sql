--Better be safe than sorry
--Run with SBR user
CREATE TABLE SBR.USER_ACCOUNTS_BACKUP
AS (SELECT *
    FROM SBR.USER_ACCOUNTS
);
CREATE TABLE SBR.SC_USER_ACCOUNTS_BACKUP
AS (SELECT *
    FROM SBR.SC_USER_ACCOUNTS
);
CREATE TABLE SBR.SECURITY_CONTEXTS_LOV_BACKUP
AS (SELECT *
    FROM SBR.SECURITY_CONTEXTS_LOV
);
CREATE TABLE sbr.groups_backup
AS (SELECT *
    FROM sbr.groups
);
CREATE TABLE sbr.user_groups_backup
AS (SELECT *
    FROM sbr.user_groups
);
CREATE TABLE sbr.sc_groups_backup
AS (SELECT *
    FROM sbr.sc_groups
);

--Remove old names
delete from sbr.sc_contexts where scl_name = 'caBIG_SC';
delete from sbr.SECURITY_CONTEXTS_LOV where scl_name = 'caBIG_SC';

--Update parents dependencies first
Insert into SBR.SECURITY_CONTEXTS_LOV (SCL_NAME,DESCRIPTION,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED) values ('NCIP_SC','Security Context for NCIP','SBR',to_timestamp('30-APR-04','DD-MON-RR HH.MI.SSXFF AM'),null,null);
Insert into SBR.SC_CONTEXTS (CONTE_IDSEQ,SCL_NAME,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED) values ('D9344734-8CAF-4378-E034-0003BA12F5E7','NCIP_SC','SBR',to_timestamp('14-FEB-02','DD-MON-RR HH.MI.SSXFF AM'),'SBR',to_timestamp('14-FEB-02','DD-MON-RR HH.MI.SSXFF AM'));
update SBR.SC_USER_ACCOUNTS set SCL_NAME = 'NCIP_SC' where SCL_NAME = 'caBIG_SC';
update SBR.SC_GROUPS set SCL_NAME = 'NCIP_SC' where SCL_NAME = 'caBIG_SC';
Insert into sbr.groups (GRP_NAME,DESCRIPTION,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED) values ('NCIP_CONTRIBUTOR','NCIP_CONTRIBUTOR','SBR',to_timestamp('30-APR-04','DD-MON-RR HH.MI.SSXFF AM'),null,null);
Insert into sbr.groups (GRP_NAME,DESCRIPTION,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED) values ('NCIP_MANAGER','NCIP_MANAGER','SBR',to_timestamp('30-APR-04','DD-MON-RR HH.MI.SSXFF AM'),null,null);
Insert into sbr.groups (GRP_NAME,DESCRIPTION,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED) values ('NCIP_BROWSER','NCIP_BROWSER','SBR',to_timestamp('30-APR-04','DD-MON-RR HH.MI.SSXFF AM'),null,null);
Insert into sbr.groups (GRP_NAME,DESCRIPTION,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED) values ('NCIP_FORM_BUILDER','Form Builder privileges for objects in the caBIG Context','CADSRADMIN',to_timestamp('22-AUG-05','DD-MON-RR HH.MI.SSXFF AM'),'AZIEN',to_timestamp('27-JAN-10','DD-MON-RR HH.MI.SSXFF AM'));

commit;

--Sanity check
select distinct scl_name from sbr.sc_contexts where scl_name in ('CTEP_SC','TEST_SC','NCIP_SC');
select distinct scl_name from sbr.security_contexts_lov where scl_name in ('CTEP_SC','TEST_SC','NCIP_SC');
select '1 of 2 CHECK:CONTEXT ID = '||CONTE_IDSEQ from sbr.sc_contexts where SCL_NAME = 'NCIP_SC';
select '2 of 2 CHECK:CONTEXT ID = '||CONTE_IDSEQ from SBR.CONTEXTS where NAME = 'NCIP';

--Now the rest of the children/dependants

update sbr.user_groups set grp_name = 'NCIP_FORM_BUILDER' where grp_name = 'CABIG_FORM_BUILDER';
update sbr.user_groups set grp_name = 'NCIP_BROWSER' where grp_name = 'caBIG_BROWSER';
update sbr.user_groups set grp_name = 'NCIP_CONTRIBUTOR' where grp_name = 'caBIG_CONTRIBUTOR';
update sbr.user_groups set grp_name = 'NCIP_MANAGER' where grp_name = 'caBIG_MANAGER';

update sbr.sc_groups set grp_name = 'NCIP_FORM_BUILDER' where grp_name = 'CABIG_FORM_BUILDER';
update sbr.sc_groups set grp_name = 'NCIP_BROWSER' where grp_name = 'caBIG_BROWSER';
update sbr.sc_groups set grp_name = 'NCIP_CONTRIBUTOR' where grp_name = 'caBIG_CONTRIBUTOR';
update sbr.sc_groups set grp_name = 'NCIP_MANAGER' where grp_name = 'caBIG_MANAGER';

commit;

--Take care of GUEST account
Insert into SBR.USER_GROUPS (UA_NAME,GRP_NAME,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED) values ('GUEST','NCIP_BROWSER','DWARZEL',to_timestamp('19-JUL-07','DD-MON-RR HH.MI.SSXFF AM'),'DWARZEL',to_timestamp('19-JUL-07','DD-MON-RR HH.MI.SSXFF AM'));

commit;

--More sanity check
select count(*) from sbr.user_groups 
where lower(grp_name) like '%cabig%';

select count(*) from sbr.sc_groups 
where lower(grp_name) like '%cabig%';

select count(*) from sbr.sc_contexts where lower(scl_name) like '%cabig%';

select count(*) from sbr.SECURITY_CONTEXTS_LOV where lower(scl_name) like '%cabig%';

select g.grp_name from SBR.USER_GROUPS g where ua_name = 'GUEST';

commit;
