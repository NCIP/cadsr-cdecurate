<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>

<sj:div cssClass="result ui-widget-content ui-corner-all">
	<s:url var="vmTableUrl" action="vmJson" />
	<sjg:grid id="secondMatchedVmGrid" dataType="json" href="%{vmTableUrl}"
		gridModel="secondMatchedVmModel" pager="true" pager="true" autowidth="true"
		caption="Matching VM Results" navigator="true" navigatorEdit="false"
		navigatorAdd="false" navigatorSearch="false" navigatorDelete="false">
		<sjg:gridColumn name="longName" title="VM Long Name" sortable="true" />
		<sjg:gridColumn name="publicId" title="Public ID" sortable="true"
			width="50" />
		<sjg:gridColumn name="version" title="Version" sortable="true"
			width="50" />
		<sjg:gridColumn name="workflowStatus" title="Workflow Status"
			sortable="true" width="50" />
		<sjg:gridColumn name="conceptCodes" title="EVS Identifier"
			sortable="true" />
	</sjg:grid>
	<br>
	<s:url id="selectedVmResultUrl" action="selectedVmResult" />
	<sj:a id="useSelectedVm2" indicator="indicator2"
		href="%{selectedVmResultUrl}" targets="selectedVmResultDiv"
		listenTopics="selectedVmResultDiv" button="true"
		buttonIcon="ui-icon-gear"
		onClickTopics="closeSecondVmMatchDialog,closeSearchedConceptDialog"
		onclick="hideDiv('vmDiv')">Use the Selected VM</sj:a>
	<sj:a id="ignoreVmMatches2" indicator="indicator2"
		href="%{selectedVmResultUrl}" targets="selectedVmResultDiv"
		listenTopics="selectedVmResultDiv" button="true"
		buttonIcon="ui-icon-gear"
		onClickTopics="closeSecondVmMatchDialog,closeSearchedConceptDialog">Ignore Matches and Continue to Save VM</sj:a>
</sj:div>