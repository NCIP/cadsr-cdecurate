--Please run with account SBR

select ac.public_id, c.name, ac.date_created, ac.change_note from sbr.ADMINISTERED_COMPONENTS ac, sbr.contexts c
where ac.conte_idseq = c.conte_idseq
and ac.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'CTEP')
and (upper(ac.created_by) = 'KEARNSD' or lower(ac.created_by) = 'KEARNSD')
and trunc(ac.date_created) >= to_date('2001-12-01', 'YYYY-MM-DD')
and trunc(ac.date_created) <= to_date('2013-06-21', 'YYYY-MM-DD');

select ac.public_id, c.name, ac.date_created, ac.change_note from sbr.ADMINISTERED_COMPONENTS ac, sbr.contexts c
where ac.conte_idseq = c.conte_idseq
and ac.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'CTEP')
and (upper(ac.created_by) = 'KEARNSD' or lower(ac.created_by) = 'SMITHA')
and trunc(ac.date_created) >= to_date('2001-12-01', 'YYYY-MM-DD')
and trunc(ac.date_created) <= to_date('2013-06-21', 'YYYY-MM-DD');

select ac.public_id, c.name, ac.date_created, ac.change_note from sbr.ADMINISTERED_COMPONENTS ac, sbr.contexts c
where ac.conte_idseq = c.conte_idseq
and ac.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'CTEP')
and (upper(ac.created_by) = 'KEARNSD' or lower(ac.created_by) = 'SCOTTM')
and trunc(ac.date_created) >= to_date('2001-12-01', 'YYYY-MM-DD')
and trunc(ac.date_created) <= to_date('2013-06-21', 'YYYY-MM-DD');
