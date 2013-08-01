/*L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L*/

update sbrext.quest_contents_ext qc
set preferred_definition=replace(preferred_definition, 'Aminostransferase', 'Aminotransferase'),
long_name=replace(long_name, 'Aminostransferase', 'Aminotransferase')
where exists (
select distinct qc.vp_idseq
from sbr.vd_pvs vdpv, sbr.permissible_values pv, sbr.value_domains vd
where vd.vd_id=2182809
and vd.VD_IDSEQ=VDPV.VD_IDSEQ
and PV.PV_IDSEQ=VDPV.PV_IDSEQ
and pv.value ='Alanine Aminostransferase (ALT or SGPT), Serum'
and VDPV.VP_IDSEQ=qc.VP_IDSEQ
);

update sbrext.quest_contents_ext qc
set preferred_definition=replace(preferred_definition, '19F', '19A'),
long_name=replace(long_name, '19F', '19A')
where exists (
select distinct qc.vp_idseq
from sbr.vd_pvs vdpv, sbr.permissible_values pv, sbr.value_domains vd
where vd.vd_id=2182809
and vd.VD_IDSEQ=VDPV.VD_IDSEQ
and PV.PV_IDSEQ=VDPV.PV_IDSEQ
and pv.value ='Anti-Pneumococcal Antibody Serotype 19F (57) Post-Vaccination, Serum'
and VDPV.VP_IDSEQ=qc.VP_IDSEQ
);
                 
update sbr.permissible_values pv
set value=replace(value, 'Aminostransferase', 'Aminotransferase'),
short_meaning=replace(short_meaning, 'Aminostransferase', 'Aminotransferase'),
meaning_description=replace(meaning_description, 'Aminostransferase', 'Aminotransferase')
where exists (
select distinct pv.pv_idseq
from sbr.value_domains vd, sbr.vd_pvs vdpv
where vd.vd_id=2182809
and vd.VD_IDSEQ=VDPV.VD_IDSEQ
and PV.PV_IDSEQ=VDPV.PV_IDSEQ
and pv.value ='Alanine Aminostransferase (ALT or SGPT), Serum'
);

update sbr.permissible_values pv
set value=replace(value, '19F', '19A'),
short_meaning=replace(short_meaning, '19F', '19A'),
meaning_description=replace(meaning_description, '19F', '19A')
where exists (
select distinct pv.pv_idseq
from sbr.value_domains vd, sbr.vd_pvs vdpv
where vd.vd_id=2182809
and vd.VD_IDSEQ=VDPV.VD_IDSEQ
and PV.PV_IDSEQ=VDPV.PV_IDSEQ
and pv.value ='Anti-Pneumococcal Antibody Serotype 19F (57) Post-Vaccination, Serum'
);