<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<s:include value="conceptsGrid.jsp">
	<s:param name="withParent">no</s:param>
	<s:param name="gridModel">rightLungConceptModel</s:param>
	<s:param name="gridId">rightLungConceptModel</s:param>
	<s:param name="gridCaption">VM Concepts</s:param>
	<s:param name="readOnly">no</s:param>
	<s:param name="showOrder">yes</s:param>
</s:include>