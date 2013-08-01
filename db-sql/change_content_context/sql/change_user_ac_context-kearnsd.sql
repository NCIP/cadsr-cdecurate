/*L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L*/

--Please run with account SBR
update sbr.data_element_concepts dec
set 
dec.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'SWOG'),
dec.change_note = dec.change_note || ' Moved content from CTEP to SWOG'
--dec.change_note = 'Moved content from CTEP to SWOG'
where 
dec.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'CTEP')
and (upper(dec.created_by) = 'kearnsd' or lower(dec.created_by) = 'kearnsd')
and trunc(dec.date_created) >= to_date('2011-12-01', 'YYYY-MM-DD')
and trunc(dec.date_created) <= to_date('2013-06-28', 'YYYY-MM-DD');

update sbr.data_elements de
set 
de.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'SWOG'),
de.change_note = de.change_note || ' Moved content from CTEP to SWOG'
--de.change_note = 'Moved content from CTEP to SWOG'
where 
de.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'CTEP')
and (upper(de.created_by) = 'kearnsd' or lower(de.created_by) = 'kearnsd')
and trunc(de.date_created) >= to_date('2011-12-01', 'YYYY-MM-DD')
and trunc(de.date_created) <= to_date('2013-06-28', 'YYYY-MM-DD');

update sbr.value_domains vd
set 
vd.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'SWOG'),
vd.change_note = vd.change_note || ' Moved content from CTEP to SWOG'
--vd.change_note = 'Moved content from CTEP to SWOG'
where 
vd.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'CTEP')
and (upper(vd.created_by) = 'kearnsd' or lower(vd.created_by) = 'kearnsd')
and trunc(vd.date_created) >= to_date('2011-12-01', 'YYYY-MM-DD')
and trunc(vd.date_created) <= to_date('2013-06-28', 'YYYY-MM-DD');

update SBR.ADMINISTERED_COMPONENTS ac 
set 
ac.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'SWOG'),
ac.change_note = ac.change_note || ' Moved content from CTEP to SWOG'
--ac.change_note = 'Moved content from CTEP to SWOG'
where ac.public_id in (
select 
--ac.date_created, ac.actl_name, 
ac.public_id
--, c.name, ac.created_by 
from SBR.ADMINISTERED_COMPONENTS ac, SBR.CONTEXTS c 
where 
ac.conte_idseq = c.conte_idseq
and ac.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'CTEP')
and ac.actl_name in ('DATAELEMENT', 'VALUEDOMAIN', 'DE_CONCEPT')
and (upper(ac.created_by) = 'kearnsd' or lower(ac.created_by) = 'kearnsd')
and trunc(ac.date_created) >= to_date('2011-12-01', 'YYYY-MM-DD')
and trunc(ac.date_created) <= to_date('2013-06-28', 'YYYY-MM-DD')
);


