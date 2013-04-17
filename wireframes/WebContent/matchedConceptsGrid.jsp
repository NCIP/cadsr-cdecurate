<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>

<s:url id="searchMatchingVmsUrl" value="matchedVmsGrid.jsp" />
<s:url id="createNewVmFromConceptUrl"
	value="newValueMeaningFromConcept.jsp" />
<sj:dialog id="matchedVmDialog" title="Associated VMs" autoOpen="false"
	modal="true" height="600" width="1000"
	closeTopics="closeSelectedVmDialog" position="right">
</sj:dialog>
<script type="text/javascript">
	function showVMs() {
		var url = '<s:property value="searchMatchingVmsUrl"/>';
		$("#matchedVmDialog").load(url).dialog("open");
		$("#vmDiv").hide();
	}
	function createNewVMFromConcept() {
		$("#vmDiv").show();
		var url = '<s:property value="createNewVmFromConceptUrl"/>';
		$("#vmDiv").load(url);
	}
</script>
<strong>Matching Concepts:</strong>
<sj:div cssClass="result ui-widget-content ui-corner-all">
	<s:url var="conceptTableUrl" action="conceptJson" />
	<sjg:grid id="searchedConceptGrid" dataType="json"
		href="%{conceptTableUrl}" gridModel="searchedConceptModel"
		scroll="true" pager="true" shrinkToFit="true" pager="true"
		autowidth="true" caption="Concept Search Results" navigator="true"
		navigatorEdit="false" navigatorAdd="false" navigatorSearch="false"
		navigatorDelete="false"
		navigatorExtraButtons="{
			seperator: { 
                        title : 'seperator'  
                }, 
			showVM : { 
	    		title : 'Show Associated VM',
	    		caption: 'Associated VM', 
	    		onclick: function(){ showVMs() }
    		},
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
<s:url id="createNewVmUrl1" value="newValueMeaning.jsp" />
<sj:a href="%{createNewVmUrl1}" button="true"
	buttonIcon="ui-icon-newwin" targets="vmDiv" onclick="showDiv('vmDiv')">Create Brand New VM</sj:a>

<sj:div id="vmDiv"></sj:div>