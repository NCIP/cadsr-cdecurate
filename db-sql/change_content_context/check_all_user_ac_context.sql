--Please run with account SBR

select dec.dec_id, c.name, dec.date_created, dec.change_note from sbr.data_element_concepts_view dec, sbr.contexts c
where dec.conte_idseq = c.conte_idseq
and dec.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&2')
and trunc(dec.date_created) >= to_date('&3', 'YYYY-MM-DD')
and trunc(dec.date_created) <= to_date('&4', 'YYYY-MM-DD');

select de.cde_id, c.name, de.date_created, de.change_note  from sbr.data_elements de, sbr.contexts c
where de.conte_idseq = c.conte_idseq
and de.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&2')
and trunc(de.date_created) >= to_date('&3', 'YYYY-MM-DD')
and trunc(de.date_created) <= to_date('&4', 'YYYY-MM-DD');

select vd.vd_id, c.name, vd.date_created, vd.change_note from sbr.value_domains vd, sbr.contexts c
where vd.conte_idseq = c.conte_idseq
and vd.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&2')
and trunc(vd.date_created) >= to_date('&3', 'YYYY-MM-DD')
and trunc(vd.date_created) <= to_date('&4', 'YYYY-MM-DD');

select ac.public_id, c.name, ac.date_created, ac.change_note from sbr.ADMINISTERED_COMPONENTS ac, sbr.contexts c
where ac.conte_idseq = c.conte_idseq
and ac.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = '&2')
and trunc(ac.date_created) >= to_date('&3', 'YYYY-MM-DD')
and trunc(ac.date_created) <= to_date('&4', 'YYYY-MM-DD');

exit
