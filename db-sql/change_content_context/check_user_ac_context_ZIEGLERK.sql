/*L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L*/

--Please run with account SBR

select 'DEC ' || count(*) 
--dec.dec_id, c.name, dec.date_created, dec.change_note 
from sbr.data_element_concepts_view dec, sbr.contexts c
where dec.conte_idseq = c.conte_idseq
and dec.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'CTEP')
and (upper(dec.created_by) = 'ZIEGLERK' or lower(dec.created_by) = 'ZIEGLERK')
and trunc(dec.date_created) >= to_date('2012-01-01', 'YYYY-MM-DD')
and trunc(dec.date_created) <= to_date('2013-10-22', 'YYYY-MM-DD');

select 'CDE ' || count(*) 
--de.cde_id, c.name, de.date_created, de.change_note 
from sbr.data_elements de, sbr.contexts c
where de.conte_idseq = c.conte_idseq
and de.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'CTEP')
and (upper(de.created_by) = 'ZIEGLERK' or lower(de.created_by) = 'ZIEGLERK')
and trunc(de.date_created) >= to_date('2012-01-01', 'YYYY-MM-DD')
and trunc(de.date_created) <= to_date('2013-10-22', 'YYYY-MM-DD');

select 'VD ' || count(*)
--vd.vd_id, c.name, vd.date_created, vd.change_note 
from sbr.value_domains vd, sbr.contexts c
where vd.conte_idseq = c.conte_idseq
and vd.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'CTEP')
and (upper(vd.created_by) = 'ZIEGLERK' or lower(vd.created_by) = 'ZIEGLERK')
and trunc(vd.date_created) >= to_date('2012-01-01', 'YYYY-MM-DD')
and trunc(vd.date_created) <= to_date('2013-10-22', 'YYYY-MM-DD');

select 'ALL ' || count(*)
--ac.public_id, c.name, ac.date_created, ac.change_note 
from sbr.ADMINISTERED_COMPONENTS ac, sbr.contexts c
where ac.conte_idseq = c.conte_idseq
and ac.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'CTEP')
and (upper(ac.created_by) = 'ZIEGLERK' or lower(ac.created_by) = 'ZIEGLERK')
and trunc(ac.date_created) >= to_date('2012-01-01', 'YYYY-MM-DD')
and trunc(ac.date_created) <= to_date('2013-10-22', 'YYYY-MM-DD');
