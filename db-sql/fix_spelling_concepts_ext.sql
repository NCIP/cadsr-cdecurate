/*L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L*/

update sbrext.concepts_ext
set long_name=replace(long_name, 'Symnptom', 'Symptom')
where con_id=3698694;