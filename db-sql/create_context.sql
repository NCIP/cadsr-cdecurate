/*L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L*/

--Please run with user SBREXT

@create_context-1.sql

@create_context-2.sql

@create_context-3.sql

select SCL_NAME, DESCRIPTION from security_contexts_lov_view where SCL_NAME in ('AECC_SC', 'USC/NCCC_SC', 'LCC_SC');
