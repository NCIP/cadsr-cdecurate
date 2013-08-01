/*L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L*/

--Please keep the following queries. They are generally difficult to create or
--require significantly huge effort to be found in the PL/SQL codes

--GF30798
select preferred_name from SBREXT.CONCEPTS_VIEW_EXT
where preferred_name like '%61009%'

select 
long_name
from SBREXT.CONCEPTS_VIEW_EXT 
group by long_name
having count(*) = 1



--GF32667
--------------------------------------------------------
--  select query for DEC
--------------------------------------------------------
   SELECT
      dec.DEC_ID,
		  dec.asl_name dec_wk_flow_status, 
		  acr.registration_status dec_registration_status, 
		  oc.asl_name oc_wk_flow_status, 
		  prop.asl_name prop_wk_flow_status 
   FROM sbr.data_element_concepts dec,
        sbr.ac_registrations acr,
        object_classes_ext oc,
        properties_ext prop
   WHERE 
   --dec.DEC_ID = '2013600' and --DEC Public ID
   dec.dec_idseq = acr.ac_idseq(+)
   AND dec.oc_idseq = oc.oc_idseq(+)
   AND dec.prop_idseq = prop.prop_idseq(+)
   and dec.asl_name is not null
   and acr.registration_status is not null
   and oc.asl_name is not null;

--------------------------------------------------------
--  select query for CDE
--------------------------------------------------------

SELECT
      de.CDE_ID,
      dec.asl_name dec_wk_flow_status, 
		  acr.registration_status dec_registration_status, 
		  oc.asl_name oc_wk_flow_status, 
		  prop.asl_name prop_wk_flow_status, 
		  vd.asl_name vd_wk_flow_status, 
		  acr.registration_status vd_registration_status
   FROM sbr.data_elements de,
        sbr.data_element_concepts dec,
        sbr.value_domains vd,
        sbr.ac_registrations acr,
        object_classes_ext oc,
        properties_ext prop
   WHERE 
     --de.CDE_ID = '2006892' and --CDE/DE Public ID
		 de.dec_idseq = dec.dec_idseq
     AND de.vd_idseq = vd.vd_idseq
     AND de.de_idseq = acr.ac_idseq(+)
     AND dec.oc_idseq = oc.oc_idseq(+)
     AND dec.prop_idseq = prop.prop_idseq(+)
   and dec.asl_name is not null
   and acr.registration_status is not null
   and oc.asl_name is not null
	 and prop.asl_name is not null
   and vd.asl_name is not null
   and acr.registration_status is not null;

--------------------------------------------------------
--  select query for VD
--------------------------------------------------------

SELECT 
		  vd.asl_name vd_wk_flow_status, 
		  acr.registration_status vd_registration_status
          
   FROM sbr.value_domains vd,
        sbr.ac_registrations acr 
   WHERE vd.VD_ID = '2019029' --VD Public ID
         AND vd.vd_idseq = acr.ac_idseq(+);
