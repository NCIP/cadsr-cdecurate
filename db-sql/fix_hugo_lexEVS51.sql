/*L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L*/

update sbrext.tool_options_ext
set value='HUGO Gene Nomenclature Committee'
where property='EVS.VOCAB.10.EVSNAME';

update sbrext.tool_options_ext
set value='HGNC'
where property='EVS.VOCAB.10.DISPLAY';

update sbrext.tool_options_ext
set property='EVS.VOCAB.09.DISPLAY'
where value='HGNC';

update sbrext.tool_options_ext
set property='EVS.VOCAB.09.EVSNAME'
where value='HUGO Gene Nomenclature Committee';

update sbrext.tool_options_ext
set property='EVS.VOCAB.09.VOCABCODETYPE'
where value='HUGO_CODE';

update sbrext.tool_options_ext
set property='EVS.VOCAB.10.DISPLAY'
where value='HL7';

update sbrext.tool_options_ext
set property='EVS.VOCAB.10.EVSNAME'
where value='HL7 Reference Information Model';

update sbrext.tool_options_ext
set property='EVS.VOCAB.10.VOCABCODETYPE'
where value='HL7_CODE';

update sbrext.tool_options_ext
set property='EVS.VOCAB.08.DISPLAY'
where value='HGNC';

update sbrext.tool_options_ext
set property='EVS.VOCAB.08.EVSNAME'
where value='HUGO Gene Nomenclature Committee';

update sbrext.tool_options_ext
set property='EVS.VOCAB.08.VOCABCODETYPE'
where value='HUGO_CODE';

commit;
