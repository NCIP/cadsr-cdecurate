<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>

<s:include value="conceptsGrid.jsp">
	<s:param name="withParent">no</s:param>
	<s:param name="gridModel">editVmConceptModel</s:param>
	<s:param name="gridId">editVmConceptTable</s:param>
	<s:param name="gridCaption">VM Concepts</s:param>
	<s:param name="readOnly">no</s:param>
</s:include>