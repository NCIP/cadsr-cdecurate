<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<sj:div id="pvDetails">
	<s:url id="createNewPvUrl" action="createNewPv" />
	<s:url id="pvFromConceptsOption" action="createPvListFromConcepts" />
	<s:url id="pvAlert" value="permissibleValueListFromParentAlert.jsp" />

	<sj:a href="%{createNewPvUrl}" button="true"
		buttonIcon="ui-icon-newwin" targets="pvEditDiv"
		onclick="showDiv('pvEditDiv')">Create New</sj:a>
	<sj:dialog id="subConceptsDialog" autoOpen="false" modal="false"
		title="permissible value dialogs" openTopics="openRemoteDialog"
		position="center" height="600" width="1000" />
	<sj:dialog id="alertDialog" autoOpen="false" modal="true" title="alert"
		openTopics="openRemoteDialog" position="center" height="200"
		width="400" closeTopics="closeDialog" />
	<sj:a openDialog="alertDialog"
		openDialogTitle="Create a List from Parent Concept" href="%{pvAlert}"
		button="true" buttonIcon="ui-icon-newwin"
		onclick="$('#parentList').hide()">
    	Create a List from Parent Concept
   			</sj:a>
	<sj:a openDialog="pvFromConceptsDialog"
		openDialogTitle="Create New Permissible Values from Concepts"
		href="%{pvFromConceptsOption}" button="true"
		buttonIcon="ui-icon-newwin" onclick="$('#parentList').hide()">
    	Create a List from Concepts
  	</sj:a>
	<sj:div id="pvEditDiv">
	</sj:div>
	<sj:dialog id="newPvDialog" autoOpen="false" modal="true"
		title="Create New Permissible Value" openTopics="openRemoteDialog"
		position="center" height="600" width="1000" closeTopics="closeDialog" />
	<sj:dialog id="pvFromConceptsDialog" autoOpen="false" modal="false"
		title="permissible value dialogs" openTopics="openRemoteDialog"
		position="center" height="600" width="1000" />

	<sj:dialog id="valueMeaningDetail" title="Value Meaning"
		autoOpen="false" modal="true" height="900" width="1000"
		closeTopics="closeDialog">
	</sj:dialog>
	<sj:dialog id="pvEditDialog" title="Edit Permissible Value"
		autoOpen="false" modal="true" height="600" width="1000"
		closeTopics="closeDialog">
	</sj:dialog>

	<s:url var="pvEditUrl" value="editPermissibleValue.jsp" />
	<script type="text/javascript">
		function openNewPvDialog(pv) {
			var newPvUrl = '<s:property value="createNewPvUrl"/>';
			//$("#newPvDialog").load(newPvUrl).dialog("open");
			$("#onePv").load(newPvUrl);
		}
		function openPvEditDialog(pv) {
			var id = jQuery('#existingPvTable')
					.jqGrid('getGridParam', 'selrow');
			if (id) {
				var pv = jQuery('#existingPvTable').jqGrid('getRowData', id);
				//alert(pv.value);
			}
			var pvEditUrl = '<s:property value="pvEditUrl"/>';
			//$("#pvEditDialog").load(pvEditUrl).dialog("open");
			$("#pvEditDiv").load(pvEditUrl);

		}

		/*
		 function formatVm(cellvalue, options, rowObject) {
		 var vm = rowObject.valueMeaning;
		 var cols = rowObject.valueMeaning.displayColumns;
		 var conceptStr = "";
		 for ( var i = 0; i < vm.concepts.length; i++) {
		 conceptStr = getConceptDisplayString(vm.concepts[i]) + "<br>";
		 }

		 var data = [ vm.longName, vm.publicIdVersion, vm.manualDefinition,
		 conceptStr ];
		 var html = "<table class='gridtableNoBorder'>";
		 for ( var i = 0; i < cols.length - 1; i++) {
		 html += "<tr><th colspan='2'><b>" + cols[i] + "</b></th></tr>";
		 html += "<tr><th>&nbsp;&nbsp;&nbsp;</th><th>" + data[i]
		 + "<br><br></th></tr>"
		 }
		 html += "<tr><th colspan='2'><b>" + cols[i] + "</b></th></tr>";
		 html += "<tr><th>&nbsp;&nbsp;&nbsp;</th><th>" + data[i]
		 + "</th></tr></table>"
		 return html;
		 }

		 function getConceptDisplayString(concept) {
		 var data = [ concept.name, concept.evsId, concept.vocabulary,
		 concept.type ];
		 var html = "";
		 for ( var i = 0; i < data.length - 1; i++) {
		 html += data[i] + "&nbsp;&nbsp;&nbsp;";
		 }
		 html += data[i];
		 return html;
		 }

		 function getConceptDisplayString0(concept) {
		 var data = [ concept.name, concept.evsId, concept.vocabulary,
		 concept.type ];
		 var html = "<table class='gridtableNoBorder' width='100%'><tr>";
		 for ( var i = 0; i < data.length; i++) {
		 html += "<th>" + data[i] + "</th>";
		 }
		 html += "</tr></table>";
		 return html;
		 }
		 */
		function formatConcept(cellValue, options, rowObject) {
			var concepts = rowObject.valueMeaning.concepts;
			var html = "";
			for ( var i = 0; i < concepts.length - 1; i++) {
				html = concepts[i].evsId + ":";
			}
			html = concepts[i].evsId;
			return html;
		}
	</script>

	<s:url var="pvTableUrl" action="pvJson" />
	<s:url var="vmUrl" action="vmJson" />
	<sj:div id="existingPVs"
		cssClass="result ui-widget-content ui-corner-all">
		<sjg:grid id="existingPvTable" caption="Existing Permissible Values"
			dataType="json" href="%{pvTableUrl}" gridModel="pvModel" pager="true"
			autoencode="false" navigator="true" navigatorEdit="false"
			navigatorAdd="false" navigatorSearch="false" multiselect="true"
			navigatorDeleteOptions="{height:280, reloadAfterSubmit:true}"
			navigatorExtraButtons="{
    		edit : { 
	    		title : 'Edit PV', 
	    		icon: 'ui-icon-pencil', 
	    		onclick: function(){ openPvEditDialog() }
    		}
    	}">
			<sjg:gridColumn name="value" title="PV" sortable="true" width="100" />
			<%-- 
			<sjg:gridColumn name="valueMeaning" title="Value Meaning"
				sortable="false"  width="350" formatter="formatVm" />
			--%>
			<sjg:gridColumn name="valueMeaning.longName" sortable="true"
				title="PV Meaning" cssClass="link" formatter="formatVmLink"
				width="100" />
			<sjg:gridColumn name="valueMeaning.concepts"
				title="PV Meaning Concept Codes" sortable="true" align="left"
				width="180" formatter="formatConcept" />
			<sjg:gridColumn name="valueMeaning.manualDefinition"
				title="PV Meaning Description" sortable="true" align="left"
				width="220" />
			<sjg:gridColumn name="beginDate" title="PV Begin Date"
				sortable="true" width="120" />
			<sjg:gridColumn name="endDate" title="PV End Date" sortable="true"
				width="100" />
			<sjg:gridColumn name="valueMeaning.publicIdVersion"
				title="VM Public Id Version" sortable="true" width="130" />
			<sjg:gridColumn name="origin" title="PV Origin" sortable="true" />
		</sjg:grid>
	</sj:div>
</sj:div>