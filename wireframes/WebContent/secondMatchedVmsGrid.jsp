<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<sj:div cssClass="result ui-widget-content ui-corner-all">
	<s:url var="vmTableUrl" action="vmJson" />
	<sjg:grid id="secondMatchedVmGrid" dataType="json" href="%{vmTableUrl}"
		gridModel="secondMatchedVmModel" pager="true" pager="true"
		autowidth="true" caption="Matching VM Results" navigator="true"
		navigatorEdit="false" navigatorAdd="false" navigatorSearch="false"
		navigatorDelete="false">
		<sjg:gridColumn name="longName" title="VM Long Name" sortable="true"
			width="80" />
		<sjg:gridColumn name="publicIdVersion" title="Public ID & Version"
			sortable="true" width="120" />
		<sjg:gridColumn name="conceptCodes" title="VM Concept Codes"
			sortable="true" width="120" />
		<sjg:gridColumn name="manualDefinition" title="VM Description"
			sortable="true" width="200" />
		<sjg:gridColumn name="alternateNames" title="Alternate Names"
			sortable="true"/>
		<sjg:gridColumn name="reason" title="Reason" sortable="true"
			width="50" />
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
		onClickTopics="closeSecondVmMatchDialog,closeSearchedConceptDialog">Ignore Matches and Save</sj:a>
</sj:div>