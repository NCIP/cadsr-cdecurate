<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>

<s:url var="pvTableUrl" action="pvJson" />
<sj:dialog id="valueMeaningDetail" title="Value Meaning Details"
	autoOpen="false" modal="true" height="900" width="1000">
</sj:dialog>
<sj:dialog id="pvEdit" title="Edit Permissible Value" autoOpen="false"
	modal="true" height="600" width="1000">
</sj:dialog>
<s:include value="permissibleValuesGrid.jsp">
	<s:param name="gridModel">pvModelFromParent</s:param>
	<s:param name="withParent">yes</s:param>
	<s:param name="gridId">pvModelWithParentDiv</s:param>
	<s:param name="readOnly">no</s:param>
</s:include>