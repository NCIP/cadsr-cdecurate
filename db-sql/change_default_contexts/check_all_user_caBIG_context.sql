--Please run with account SBR

select count(*) from sbr.data_element_concepts_view dec, sbr.contexts c
-- select dec.dec_id, c.name, dec.date_created, dec.change_note from sbr.data_element_concepts_view dec, sbr.contexts c
where dec.conte_idseq = c.conte_idseq
and dec.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'caBIG');

select count(*) from sbr.data_elements de, sbr.contexts c
-- select de.cde_id, c.name, de.date_created, de.change_note from sbr.data_elements de, sbr.contexts c
where de.conte_idseq = c.conte_idseq
and de.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'caBIG');

select count(*) from sbr.value_domains vd, sbr.contexts c
-- select vd.vd_id, c.name, vd.date_created, vd.change_note from sbr.value_domains vd, sbr.contexts c
where vd.conte_idseq = c.conte_idseq
and vd.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'caBIG');

select count(*) from SBR.VALUE_MEANINGS vm, sbr.contexts c
-- select vm.vm_id, c.name, vm.date_created, vm.change_note from SBR.VALUE_MEANINGS vm, sbr.contexts c
where vm.conte_idseq = c.conte_idseq
and vm.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'caBIG');

select count(*) from sbr.ADMINISTERED_COMPONENTS ac, sbr.contexts c
-- select ac.public_id, c.name, ac.date_created, ac.change_note from sbr.ADMINISTERED_COMPONENTS ac, sbr.contexts c
where ac.conte_idseq = c.conte_idseq
and ac.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'caBIG');
