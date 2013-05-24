--Please run with account SBR
--Backing up first
/*
CREATE TABLE SBR.AC_BACKUP1
AS (SELECT *
    FROM SBR.ADMINISTERED_COMPONENTS
);

select count(*) from SBR.AC_BACKUP1;
*/

update sbr.data_element_concepts dec
set dec.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&2')
where 
dec.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&1')
and (upper(dec.created_by) = '&5' or lower(dec.created_by) = '&5')
and trunc(dec.date_created) >= to_date('&3', 'YYYY-MM-DD')
and trunc(dec.date_created) <= to_date('&4', 'YYYY-MM-DD');

update sbr.data_elements de
set de.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&2')
where 
de.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&1')
and (upper(de.created_by) = '&5' or lower(de.created_by) = '&5')
and trunc(de.date_created) >= to_date('&3', 'YYYY-MM-DD')
and trunc(de.date_created) <= to_date('&4', 'YYYY-MM-DD');

update sbr.value_domains vd
set vd.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&2')
where 
vd.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&1')
and (upper(vd.created_by) = '&5' or lower(vd.created_by) = '&5')
and trunc(vd.date_created) >= to_date('&3', 'YYYY-MM-DD')
and trunc(vd.date_created) <= to_date('&4', 'YYYY-MM-DD');

update SBR.ADMINISTERED_COMPONENTS ac 
set ac.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&2')
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
