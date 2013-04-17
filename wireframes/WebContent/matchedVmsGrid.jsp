<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>

<s:url id="searchMatchingVmsUrl" value="matchedVmsGrid.jsp" />
<s:url id="createNewVmFromVmUrl" value="newValueMeaningFromVm.jsp" />

<s:url id="createNewVmFromConceptUrl"
	value="newValueMeaningFromConcept.jsp" />
<sj:dialog id="secondMatchedVmDialog" title="Associated VMs"
	autoOpen="false" modal="true" height="600" width="1000"
	closeTopics="closeSecondSelectedVmDialog" position="right">
</sj:dialog>
<s:url id="searchMatchingVmsUrl" value="matchedVmsGrid.jsp" />
<s:url id="createNewVmFromConceptUrl"
	value="newValueMeaningFromConcept.jsp" />
<sj:dialog id="matchedVmDialog" title="Associated VMs" autoOpen="false"
	modal="true" height="600" width="1000"
	closeTopics="closeSelectedVmDialog" position="right">
</sj:dialog>
<s:url id="selectedVmResultUrl" action="selectedVmResult" />
<script type="text/javascript">
	function selectTheVm() {
		$("#vmDiv").show();
		var url = '<s:property value="selectedVmResultUrl"/>';
		$("#vmDiv").load(url);
	}

	function createNewVMFromVm() {
		$("#vmDiv").show();
		var url = '<s:property value="createNewVmFromVmUrl"/>';
		$("#vmDiv").load(url);
	}
	function createNewVMFromConcept() {
		$("#vmDiv").show();
		var url = '<s:property value="createNewVmFromConceptUrl"/>';
		$("#vmDiv").load(url);
	}
</script>
<sj:div cssClass="result ui-widget-content ui-corner-all">
	<s:url var="conceptTableUrl" action="conceptJson" />
	<sjg:grid id="searchedConceptGrid" dataType="json"
		href="%{conceptTableUrl}" gridModel="searchedConceptModel"
		scroll="true" pager="true" shrinkToFit="true" pager="true"
		autowidth="true" caption="Selected Concepts" navigator="true"
		navigatorEdit="false" navigatorAdd="false" navigatorSearch="false"
		navigatorDelete="false"
		navigatorExtraButtons="{
			seperator: { 
                        title : 'seperator'  
                }, 
    		newVMFromConcept : { 
	    		title : 'Create New VM from Concept',
	    		caption: 'New VM from Concept', 
	    		onclick: function(){ createNewVMFromConcept() }
    		}
    	}">
		<sjg:gridColumn name="name" title="Concept Name" sortable="true" />
		<sjg:gridColumn name="publicId" title="Public ID" sortable="true" />
		<sjg:gridColumn name="evsId" title="EVS Identifier" sortable="true" />
		<sjg:gridColumn name="definition" title="Definition" sortable="true" />
		<sjg:gridColumn name="definitionSource" title="Definition Source"
			sortable="true" />
		<sjg:gridColumn name="workflowStatus" title="Workflow Status"
			sortable="true" />
		<sjg:gridColumn name="semanticType" title="Semantic Type"
			sortable="true" />
		<sjg:gridColumn name="context" title="Context" sortable="true" />
		<sjg:gridColumn name="vocabulary" title="Vocabulary" sortable="true" />
		<sjg:gridColumn name="caDSRComponent" title="caDSR Component"
			sortable="true" />
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
	    		caption: 'Select the VM', 
	    		onclick: function(){ selectTheVm() }
    		},
    		seperator: { 
                        title : 'seperator'  
                }, 
    		newVMFromConcept : { 
	    		title : 'Create New VM from the Selected VM',
	    		caption: 'New VM from the VM', 
	    		onclick: function(){ createNewVMFromVm() }
    		}
    	}">
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

<sj:div id="vmDiv">

</sj:div>