<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>

<s:url var="pvTableUrl" action="pvJson" />
<sj:dialog id="valueMeaningDetail" title="Value Meaning"
	autoOpen="false" modal="true" height="900" width="1000"
	closeTopics="closeDialog">
</sj:dialog>
<sj:dialog id="pvEdit" title="Edit Permissible Value" autoOpen="false"
	modal="true" height="600" width="1000" closeTopics="closeDialog">
</sj:dialog>
<s:set name="withParent">${param.withParent}</s:set>
<s:set name="gridModel">${param.gridModel}</s:set>
<s:set name="gridId">${param.gridId}</s:set>
<sjg:grid id="%{#gridId}" caption="Existing Permissible Values"
	dataType="json" href="%{pvTableUrl}" gridModel="%{#gridModel}" scroll="false"
	pager="true">
	<sjg:gridColumn name="action" title="" formatter="formatEditPvLink"
		cssClass="link" sortable="false" align="center" />
	<%--doesn't work <s:if test="%{#parameters.withParent[0]=='yes'}"> --%>
	<s:if test="%{#withParent == 'yes'}">
		<sjg:gridColumn name="parentConcept" title="Parent Concept"
			sortable="true" align="center" />
	</s:if>
	<sjg:gridColumn name="value" title="Value" sortable="true"
		align="center" />
	<sjg:gridColumn name="valueMeaning.longName" sortable="true"
		title="Value Meaning" align="center" cssClass="link"
		formatter="formatVmLink" />
	<sjg:gridColumn name="origin" title="Value Origin" sortable="true"
		align="center" />
	<sjg:gridColumn name="beginDate" title="Begin Date" sortable="true"
		align="center" />
	<sjg:gridColumn name="endDate" title="End Date" sortable="true"
		align="center" />
</sjg:grid>
<br>