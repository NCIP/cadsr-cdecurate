--Please run with account SBR
--Backing up first
CREATE TABLE SBR.DEC_BACKUP1
AS (SELECT *
    FROM sbr.data_element_concepts
);

select count(*) from SBR.DEC_BACKUP1;

CREATE TABLE SBR.DE_BACKUP1
AS (SELECT *
    FROM sbr.data_elements
);

select count(*) from SBR.DE_BACKUP1;

CREATE TABLE SBR.VD_BACKUP1
AS (SELECT *
    FROM sbr.value_domains
);

select count(*) from SBR.VD_BACKUP1;

CREATE TABLE SBR.AC_BACKUP1
AS (SELECT *
    FROM SBR.ADMINISTERED_COMPONENTS
);

select count(*) from SBR.AC_BACKUP1;

----Now starting the real work
update sbr.data_element_concepts dec
set 
dec.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&2'),
dec.change_note = dec.change_note || ' &6'
--dec.change_note = '&6'
where 
dec.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&1')
and (upper(dec.created_by) = '&5' or lower(dec.created_by) = '&5')
and trunc(dec.date_created) >= to_date('&3', 'YYYY-MM-DD')
and trunc(dec.date_created) <= to_date('&4', 'YYYY-MM-DD');

update sbr.data_elements de
set 
de.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&2'),
de.change_note = de.change_note || ' &6'
--de.change_note = '&6'
where 
de.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&1')
and (upper(de.created_by) = '&5' or lower(de.created_by) = '&5')
and trunc(de.date_created) >= to_date('&3', 'YYYY-MM-DD')
and trunc(de.date_created) <= to_date('&4', 'YYYY-MM-DD');

update sbr.value_domains vd
set 
vd.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&2'),
vd.change_note = vd.change_note || ' &6'
--vd.change_note = '&6'
where 
vd.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&1')
and (upper(vd.created_by) = '&5' or lower(vd.created_by) = '&5')
and trunc(vd.date_created) >= to_date('&3', 'YYYY-MM-DD')
and trunc(vd.date_created) <= to_date('&4', 'YYYY-MM-DD');

update SBR.ADMINISTERED_COMPONENTS ac 
set 
ac.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&2'),
ac.change_note = ac.change_note || ' &6'
--ac.change_note = '&6'
where ac.public_id in (
select 
--ac.date_created, ac.actl_name, 
ac.public_id
--, c.name, ac.created_by 
from SBR.ADMINISTERED_COMPONENTS ac, SBR.CONTEXTS c 
where 
ac.conte_idseq = c.conte_idseq
and ac.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&1')
and ac.actl_name in ('DATAELEMENT', 'VALUEDOMAIN', 'DE_CONCEPT')
and (upper(ac.created_by) = '&5' or lower(ac.created_by) = '&5')
and trunc(ac.date_created) >= to_date('&3', 'YYYY-MM-DD')
and trunc(ac.date_created) <= to_date('&4', 'YYYY-MM-DD')
);

exit
