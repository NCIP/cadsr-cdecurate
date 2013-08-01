<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

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
	<s:param name="gridModel">editedPvModelWithEditedVm</s:param>
	<s:param name="withParent">no</s:param>
	<s:param name="gridId">editPvTableWithEditedVm</s:param>
	<s:param name="readOnly">no</s:param>
</s:include>


