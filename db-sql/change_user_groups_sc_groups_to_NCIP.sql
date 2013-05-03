--Run with SBR user
CREATE TABLE sbr.user_groups_backup
AS (SELECT *
    FROM sbr.user_groups
);

CREATE TABLE sbr.sc_groups_backup
AS (SELECT *
    FROM sbr.sc_groups
);

update sbr.user_groups set grp_name = 'NCIP_MANAGER'
where grp_name = 'caBIG_MANAGER'

--commit;

select count(*) from sbr.user_groups 
where lower(grp_name) like '%cabig%';

select count(*) from sbr.sc_groups 
where lower(grp_name) like '%cabig%';
