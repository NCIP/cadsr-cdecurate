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
delete from sbr.sc_contexts where scl_name = 'NCIP_SC';
delete from sbr.SECURITY_CONTEXTS_LOV where scl_name = 'NCIP_SC';

--Update parents dependencies first
Insert into SBR.SECURITY_CONTEXTS_LOV (SCL_NAME,DESCRIPTION,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED) values ('caBIG_SC','Security Context for caBIG','SBR',to_timestamp('30-APR-04','DD-MON-RR HH.MI.SSXFF AM'),null,null);
Insert into SBR.SC_CONTEXTS (CONTE_IDSEQ,SCL_NAME,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED) values ('D9344734-8CAF-4378-E034-0003BA12F5E7','caBIG_SC','SBR',to_timestamp('14-FEB-02','DD-MON-RR HH.MI.SSXFF AM'),'SBR',to_timestamp('14-FEB-02','DD-MON-RR HH.MI.SSXFF AM'));
update SBR.SC_USER_ACCOUNTS set SCL_NAME = 'caBIG_SC' where SCL_NAME = 'NCIP_SC';
update SBR.SC_GROUPS set SCL_NAME = 'caBIG_SC' where SCL_NAME = 'NCIP_SC';
Insert into sbr.groups (GRP_NAME,DESCRIPTION,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED) values ('CABIG_CONTRIBUTOR','CABIG_CONTRIBUTOR','SBR',to_timestamp('30-APR-04','DD-MON-RR HH.MI.SSXFF AM'),null,null);
Insert into sbr.groups (GRP_NAME,DESCRIPTION,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED) values ('CABIG_MANAGER','CABIG_MANAGER','SBR',to_timestamp('30-APR-04','DD-MON-RR HH.MI.SSXFF AM'),null,null);
Insert into sbr.groups (GRP_NAME,DESCRIPTION,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED) values ('CABIG_BROWSER','CABIG_BROWSER','SBR',to_timestamp('30-APR-04','DD-MON-RR HH.MI.SSXFF AM'),null,null);
Insert into sbr.groups (GRP_NAME,DESCRIPTION,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED) values ('CABIG_FORM_BUILDER','Form Builder privileges for objects in the caBIG Context','CADSRADMIN',to_timestamp('22-AUG-05','DD-MON-RR HH.MI.SSXFF AM'),'AZIEN',to_timestamp('27-JAN-10','DD-MON-RR HH.MI.SSXFF AM'));

commit;

--Sanity check
select '1 of 8 CHECK:CHANGED CONTEXT BE ONE OF THE FOLLOWING RESULTS:' from dual;
select distinct scl_name from sbr.sc_contexts where scl_name in ('CTEP_SC','TEST_SC','caBIG_SC');
select distinct scl_name from sbr.security_contexts_lov where scl_name in ('CTEP_SC','TEST_SC','caBIG_SC');
select '2 of 2 CHECK:AFFECTED CONTEXT ID = '||CONTE_IDSEQ from sbr.sc_contexts where SCL_NAME = 'caBIG_SC';
select '3 of 2 CHECK:AFFECTED CONTEXT ID = '||CONTE_IDSEQ from SBR.CONTEXTS where NAME = 'caBIG';

--Now the rest of the children/dependants

update sbr.user_groups set grp_name = 'CABIG_FORM_BUILDER' where grp_name = 'NCIP_FORM_BUILDER';
update sbr.user_groups set grp_name = 'caBIG_BROWSER' where grp_name = 'NCIP_BROWSER';
update sbr.user_groups set grp_name = 'caBIG_CONTRIBUTOR' where grp_name = 'NCIP_CONTRIBUTOR';
update sbr.user_groups set grp_name = 'caBIG_MANAGER' where grp_name = 'NCIP_MANAGER';

update sbr.sc_groups set grp_name = 'CABIG_FORM_BUILDER' where grp_name = 'NCIP_FORM_BUILDER';
update sbr.sc_groups set grp_name = 'caBIG_BROWSER' where grp_name = 'NCIP_BROWSER';
update sbr.sc_groups set grp_name = 'caBIG_CONTRIBUTOR' where grp_name = 'NCIP_CONTRIBUTOR';
update sbr.sc_groups set grp_name = 'caBIG_MANAGER' where grp_name = 'NCIP_MANAGER';

commit;

--Take care of GUEST account
Insert into SBR.USER_GROUPS (UA_NAME,GRP_NAME,CREATED_BY,DATE_CREATED,MODIFIED_BY,DATE_MODIFIED) values ('GUEST','caBIG_BROWSER','DWARZEL',to_timestamp('19-JUL-07','DD-MON-RR HH.MI.SSXFF AM'),'DWARZEL',to_timestamp('19-JUL-07','DD-MON-RR HH.MI.SSXFF AM'));

commit;

--More sanity check
select '4 of 8 CHECK:COUNT SHOULD BE AROUND 200 = '||count(*) from sbr.user_groups where grp_name like '%caBIG%';

select '5 of 8 CHECK:COUNT SHOULD BE > 1 = '||count(*) from sbr.sc_groups where grp_name like '%caBIG%';

select '6 of 8 CHECK:COUNT SHOULD BE 1 = '||count(*) from sbr.sc_contexts where scl_name like '%caBIG%';

select '7 of 8 CHECK:COUNT SHOULD BE 1 = '||count(*) from sbr.SECURITY_CONTEXTS_LOV where scl_name like '%caBIG%';

select '8 of 8 CHECK:ONE OF THE FOLLOWING GROUPS SHOULD STARTS WITH THE CHANGED CONTEXT:' from dual;
select g.grp_name from SBR.USER_GROUPS g where ua_name = 'GUEST';

commit;
