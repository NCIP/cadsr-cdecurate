<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>

<s:include value="conceptsGrid.jsp">
	<s:param name="withParent">yes</s:param>
	<s:param name="gridModel">parentConceptModel</s:param>
	<s:param name="gridId">parentConceptTableDiv</s:param>
	<s:param name="gridCaption">Parent Concepts</s:param>
	<s:param name="readOnly">no</s:param>
</s:include>
<br>
<br>