<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>

<s:url id="searchMatchingVmsUrl" value="matchedVmsGrid.jsp" />
<s:url id="createNewVmFromVmUrl" value="newValueMeaningFromVm.jsp">
	<s:param name="secondVmCheck">yes</s:param>
</s:url>

<s:url id="createNewVmFromConceptUrl"
	value="newValueMeaningFromConcept.jsp">
	<s:param name="secondVmCheck">yes</s:param>
</s:url>
<sj:dialog id="secondMatchedVmDialog" title="Associated VMs"
	autoOpen="false" modal="true" height="600" width="1200"
	closeTopics="closeSecondSelectedVmDialog" position="center">
</sj:dialog>

<sj:dialog id="matchedVmDialog" title="Associated VMs" autoOpen="false"
	modal="true" height="600" width="1200"
	closeTopics="closeSelectedVmDialog" position="center">
</sj:dialog>
<s:url id="selectedVmResultUrl" action="selectedVmResult">
	<s:param name="secondVmCheck">no</s:param>
</s:url>
<script type="text/javascript">
	function selectTheVm() {
		$("#vmDiv").empty();
		$("#vmDiv").show();
		var url = '<s:property value="selectedVmResultUrl"/>';
		$("#vmDiv").load(url);
		//$(window).scrollTop($('#vmDiv').offset().top);
		$('html,body').animate({
			scrollTop : $("#vmDiv").offset().top
		}, 'slow');
	}

	function createNewVMFromVm() {
		$("#vmDiv").empty();
		$("#vmDiv").show();
		var url = '<s:property value="createNewVmFromVmUrl"/>';
		$("#vmDiv").load(url);
		$('html,body').animate({
			scrollTop : $("#vmDiv").offset().top
		}, 'slow');
	}
	function createNewVMFromConcept() {
		$("#vmDiv").empty();
		$("#vmDiv").show();
		var url = '<s:property value="createNewVmFromConceptUrl"/>';
		$("#vmDiv").load(url);
		$('html,body').animate({
			scrollTop : $("#vmDiv").offset().top
		}, 'slow');
	}
</script>
<sj:div cssClass="result ui-widget-content ui-corner-all">
	<s:url var="conceptTableUrl" action="conceptJson" />
	<sjg:grid id="searchedConceptGrid" dataType="json"
		href="%{conceptTableUrl}" gridModel="searchedConceptModel"
		scroll="true" pager="true" shrinkToFit="true" pager="true"
		autowidth="true" caption="Selected Concepts" navigator="true"
		navigatorEdit="false" navigatorAdd="false" navigatorSearch="false"
		navigatorDelete="false">
		<sjg:gridColumn name="name" title="Concept Name" sortable="true"
			width="80" />
		<sjg:gridColumn name="publicId" title="Public ID" sortable="true"
			width="80" />
		<sjg:gridColumn name="evsId" title="EVS Identifier" sortable="true" width="80"/>
		<sjg:gridColumn name="definition" title="Definition" sortable="true" width="150"/>
		<sjg:gridColumn name="type" title="Type" sortable="true" width="50"/>
		<%--
		<sjg:gridColumn name="definitionSource" title="Definition Source"
			sortable="true" />
		<sjg:gridColumn name="workflowStatus" title="Workflow Status"
			sortable="true" />
		<sjg:gridColumn name="semanticType" title="Semantic Type"
			sortable="true" />
		<sjg:gridColumn name="context" title="Context" sortable="true" />
		<sjg:gridColumn name="vocabulary" title="Vocabulary" sortable="true" />
		<sjg:gridColumn name="caDSRComponent" title="caDSR Component"
			sortable="true" /> --%>
	</sjg:grid>
</sj:div>
<sj:div cssClass="result ui-widget-content ui-corner-all">
	<s:url var="vmTableUrl" action="vmJson" />
	<sjg:grid id="matchedVmGrid" dataType="json" href="%{vmTableUrl}"
		gridModel="matchedVmModel" pager="true" pager="true" autowidth="true"
		caption="Matching VM Results" navigator="true" navigatorEdit="false"
		navigatorAdd="false" navigatorSearch="false" navigatorDelete="false"
		navigatorExtraButtons="{
			seperator: { 
                        title : 'seperator'  
                }, 
			showVM : { 
	    		title : 'Select the VM',
	    		icon: 'ui-icon-check',
	    		caption: 'Select the VM', 
	    		onclick: function(){ selectTheVm() }
    		},
    		seperator: { 
                        title : 'seperator'  
                }, 
    		newVMFromConcept : { 
	    		title : 'Create New VM from existing',
	    		icon: 'ui-icon-plus',
	    		caption: 'New VM from existing', 
	    		onclick: function(){ createNewVMFromVm() }
    		}
    	}">
		<sjg:gridColumn name="longName" title="VM Long Name" sortable="true"
			width="100" />
		<sjg:gridColumn name="publicIdVersion" title="Public ID & Version"
			sortable="true" width="50" />
		<sjg:gridColumn name="conceptCodes" title="VM Concept Codes"
			sortable="true" />
		<%--
		<sjg:gridColumn name="workflowStatus" title="Workflow Status"
			sortable="true" width="50" />
			 --%>
		<sjg:gridColumn name="manualDefinition" title="Definition"
			sortable="true" />
	</sjg:grid>
	<%--
	<br>
	<s:url id="selectedVmResultUrl" action="selectedVmResult" />
	<sj:a id="useSelectedVm" indicator="indicator2"
		href="%{selectedVmResultUrl}" targets="vmDiv"
		listenTopics="selectedVmResultDiv" button="true"
		buttonIcon="ui-icon-gear"
		onClickTopics="closeMatchedVmDialog,closeSearchConceptDialog">Use the Selected VM</sj:a>
	<s:url id="createNewVmFromVmUrl" value="newValueMeaningFromVm.jsp" />
	<sj:a id="createFromSelectedVm" indicator="indicator2"
		href="%{createNewVmFromVmUrl}" targets="vmDiv" button="true"
		buttonIcon="ui-icon-gear" onclick="showDiv('vmDiv')">Create New from the Selected VM</sj:a>
	<sj:a id="ignoreVmMatches" indicator="indicator2" button="true"
		buttonIcon="ui-icon-gear" onClickTopics="closeSelectedVmDialog">Cancel</sj:a> --%>
</sj:div>
