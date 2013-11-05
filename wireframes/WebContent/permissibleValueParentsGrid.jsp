<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>

<sj:div id="parentConceptGrid"
	cssClass="result ui-widget-content ui-corner-all">
	<s:include value="conceptsGrid2.jsp">
		<s:param name="withParent">yes</s:param>
		<s:param name="gridModel">parentConceptModel</s:param>
		<s:param name="gridId">parentConceptTableDiv</s:param>
		<s:param name="gridCaption">Parent Concepts</s:param>
		<s:param name="readOnly">no</s:param>
	</s:include>
</sj:div>