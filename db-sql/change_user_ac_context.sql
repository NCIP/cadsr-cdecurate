select ac.date_created, ac.actl_name, c.name, ac.created_by from SBR.ADMINISTERED_COMPONENTS ac, SBR.CONTEXTS c 
where 
ac.conte_idseq = c.conte_idseq
and ac.CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'CTEP')
and ac.actl_name in ('DATAELEMENT', 'VALUEDOMAIN', 'DE_CONCEPT');
