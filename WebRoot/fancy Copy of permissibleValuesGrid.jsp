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
<s:set name="readOnly">${param.readOnly}</s:set>
<s:if test="%{#readOnly == 'yes'}">
	<s:set name="showNavigator">false</s:set>
</s:if>
<s:else>
	<s:set name="showNavigator">true</s:set>
</s:else>

<script type="text/javascript">
$.subscribe('completegrid', function(event, data) {
        var records = $('#gridtable').getGridParam('records');
            if(records < 1) {
                $('#gridcontainer').html('<span>none</span>');
            }
});
</script>

<sjg:grid id="%{#gridId}" caption="Existing Permissible Values"
	dataType="json" href="%{pvTableUrl}" gridModel="%{#gridModel}"
	pager="true" navigator="%{#showNavigator}" navigatorSearch="false"
	multiselect="%{#showNavigator}" navigatorAdd="%{#showNavigator}"
	navigatorAddOptions="{width:900, height:500, reloadAfterSubmit:true}"
	navigatorEdit="%{#showNavigator}"
	navigatorEditOptions="{width:900, height:500, reloadAfterSubmit:true}"
	navigatorDelete="true"
	navigatorDeleteOptions="{reloadAfterSubmit:true}"
	onSelectRowTopics="">
	<%--doesn't work <s:if test="%{#parameters.withParent[0]=='yes'}"> --%>
	<s:if test="%{#withParent == 'yes'}">
		<sjg:gridColumn name="parentConcept" title="Parent Concept"
			sortable="true" align="center" />
	</s:if>
	<sjg:gridColumn name="value" title="Value" sortable="true"
		align="center" width="100" />
	<sjg:gridColumn name="valueMeaning.longName" sortable="true"
		title="Value Meaning" align="center" cssClass="link"
		formatter="formatVmLink" width="150" />
	<sjg:gridColumn name="valueMeaning.publicIdVersion"
		title="VM Public ID Version" sortable="true" align="center"
		width="120" />
	<sjg:gridColumn name="valueMeaning.manualDefinition"
		title="VM Description/Definition" sortable="true" align="left"
		width="250" />
	<sjg:gridColumn name="valueMeaning.conceptStr" title="VM Concepts"
		sortable="true" align="left" width="200" />
	<sjg:gridColumn name="origin" title="Value Origin" sortable="true"
		align="center" />
	<sjg:gridColumn name="beginDate" title="Begin Date" sortable="true"
		align="center" width="100"/>
	<sjg:gridColumn name="endDate" title="End Date" sortable="true"
		align="center" width="100" />
</sjg:grid>
<br>