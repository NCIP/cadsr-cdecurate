<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<sj:div id="pvDetails">
	Test Selected Conceptual Domain:&nbsp;<s:property
		value="#session.m_VD.VD_CD_NAME" />
	<br>
	<br>
	<s:url id="createNewPvUrl" action="createNewPv" />
	<s:url id="pvFromConceptsOption" action="createPvListFromConcepts" />
	<s:url id="pvAlert" value="permissibleValueListFromParentAlert.jsp" />

	<sj:dialog id="newPvDialog" autoOpen="false" modal="true" height="600"
		width="1000" position="[70, 200]" title="Create a New PV" />
	<sj:a id="createNewPvUrl" href="%{createNewPvUrl}" button="true"
		openDialog="newPvDialog">Create New</sj:a>
	<sj:dialog id="subConceptsDialog" autoOpen="false" modal="false"
		title="permissible value dialogs" openTopics="openRemoteDialog"
		position="center" height="600" width="1000" />
	<sj:dialog id="alertDialog" autoOpen="false" modal="true" title="alert"
		openTopics="openRemoteDialog" position="center" height="200"
		width="400" closeTopics="closeDialog" />

	<sj:a id="pvAlertUrl" openDialog="alertDialog"
		openDialogTitle="Create a List from Parent Concept" href="%{pvAlert}"
		button="true" onclick="$('#parentList').hide()">
    	Create a List from Parent Concept
   			</sj:a>
	<sj:a id="pvFromConceptsUrl" openDialog="pvFromConceptsDialog"
		openDialogTitle="Create New Permissible Values from Concepts"
		href="%{pvFromConceptsOption}" button="true"
		onclick="$('#parentList').hide()">
    	Create a List from Concepts
  	</sj:a>

	<sj:dialog id="pvFromConceptsDialog" autoOpen="false" modal="false"
		title="permissible value dialogs" openTopics="openRemoteDialog"
		position="center" height="600" width="1000" />

	<sj:dialog id="valueMeaningDetail" title="Value Meaning"
		autoOpen="false" draggable="true" modal="true" height="900" width="1000"
		position="['center', 'top']" closeTopics="closeDialog">
	</sj:dialog>
	<sj:dialog id="pvEditDialog" title="Edit PV" autoOpen="false" draggable="true"
		modal="true" height="600" width="1000" closeTopics="closeDialog"
		position="[100, 250]">
	</sj:dialog>
	<s:url var="vmUrl" action="vmDetails" />
	<%--<s:url var="pvEditUrl" action="editPv" /> --%>
	<s:url var="pvEditUrl" value="editPermissibleValue.jsp" />
	<s:url var="editVmUrl" action="editVm" />

	<script>
		/*
		$(document).ready(
				function() {
					$.subscribe('loadButtons', function(event, data) {
						$("#existingPvTable").jqGrid('navButtonAdd',
								"#existingPvTable_pager", {
									caption : "",
									title : "Delete All PVs",
									buttonicon : "ui-icon-closethick",
									onClickButton : function() {
										alert("button pressed");
									}
								});

					});

				});
		 */

		function formatVmLink(cellvalue, options, rowObject) {
			//return "<a href='#' onClick='javascript:openDialog("+cellvalue+")'>"+cellvalue+"</a>";
			var viewLink = "<a href='#' onClick='javascript:openVmDialog(&#34;"
					+ cellvalue
					+ "&#34;)'><span class='gridLink'>View</span></a>";
			var editLink = "<a href='#' onClick='javascript:openEditVmDialog(&#34;"
					+ cellvalue
					+ "&#34;)'><span class='gridLink'>Edit</span></a>";
			return cellvalue + "<br><br>" + viewLink + "&nbsp;&nbsp;"
					+ editLink;
		}

		function formatActionLink(cellvalue, options, rowObject) {
			//return "<a href='#' onClick='javascript:openDialog("+cellvalue+")'>"+cellvalue+"</a>";
			var editLink = "<a href='#' onClick='javascript:openPvEditDialog(&#34;"
					+ cellvalue
					+ "&#34;)'><img src='images/edit.gif' alt='edit PV' title='Edit Permissible Value'/></a>";
			var removeLink = "<a href='#' onClick='javascript:deletePvDialog(&#34;"
					+ cellvalue
					+ "&#34;)'><img src='images/delete_white.gif' alt='delete PV' title='Delete Permissible Value'/></a>";
			return editLink + "&nbsp;&nbsp;&nbsp;" + removeLink;
		}

		function openVmDialog(vm) {
			var valueMeaningDetailUrl = '<s:property value="vmUrl"/>';
			$("#valueMeaningDetail").load(valueMeaningDetailUrl).dialog("open");
		}

		function openEditVmDialog(vm) {
			var url = '<s:property value="editVmUrl"/>';
			$("#valueMeaningDetail").load(url).dialog("open");
		}

		function openNewPvDialog(pv) {
			var newPvUrl = '<s:property value="createNewPvUrl"/>';
			//$("#newPvDialog").load(newPvUrl).dialog("open");
			$("#onePv").load(newPvUrl);
		}
		function openPvEditDialog(pv) {
		/*	
			var id = jQuery('#existingPvTable')
					.jqGrid('getGridParam', 'selrow');
			if (id) {
				var pv = jQuery('#existingPvTable').jqGrid('getRowData', id);
				alert(id);
			}
     		var pvEditUrl = '<s:property value="pvEditUrl"/>'
					+ "?oper=edit&rowInd=" + id;
			alert(pvEditUrl);*/
			var pvEditUrl = '<s:property value="pvEditUrl"/>';
			//$("#pvEditDialog").load(pvEditUrl).dialog("open");
			$("#pvEditDialog").load(pvEditUrl).dialog("open");

		}

		function formatConcept(cellValue, options, rowObject) {
			var concepts = rowObject.valueMeaning.concepts;
			var html = "";
			if (concepts.length > 0) {
				for ( var i = 0; i < concepts.length - 1; i++) {
					html = concepts[i].evsId + ":";
				}
				html = concepts[i].evsId;
			}
			return html;
		}
	</script>
	<script type="text/javascript">
		$.subscribe('customizeGrid', function(event, data) {
			$("#existingPvTable_toppager option[value=10000]").text('All');
			$("#existingPvTable_pager option[value=10000]").text('All');
			$(".ui-jqgrid-sortable").css('white-space', 'normal');
			$(".ui-jqgrid-sortable").css('height', 'auto');

			/*
			$("#existingPvTable_pager .ui-pg-selbox").append(
					'<option role="option" value="10000">All</option>');
			$("#existingPvTable_toppager .ui-pg-selbox").append(
					'<option role="option" value="10000">All</option>');
						var rowCount = $("#existingPvTable").jqGrid(
								'getGridParam', 'reccount');
						alert(rowCount);
						$("#existingPvTable").jqGrid('setGridParam', {
							toppager : true,
							rowNum : 700,
							rowList : [ 5, 10, 20, 50, 1000, 5000 ],
							loadComplete : function() {
								$("#pager option[value=5000]").text('All');
							}
						}).trigger("reloadGrid");
						
									$("#existingPvTable").jqGrid('setGridParam', {
				emptyrecords : "Nothing to display"
			}).trigger("reloadGrid");
					
			 */

		});
	</script>
	<sj:div id="pvEditDiv">
	</sj:div>
	<s:url var="pvTableUrl" action="pvJson" />
	<s:url var="vmUrl" action="vmJson" />
	<sj:div id="existingPVs"
		cssClass="result ui-widget-content ui-corner-all">
		<sjg:grid id="existingPvTable" caption="Existing Permissible Values"
			onGridCompleteTopics="customizeGrid" loadonce="false" dataType="json"
			href="%{pvTableUrl}" gridModel="pvModel" pager="true" toppager="true"
			autoencode="false" navigator="true" navigatorEdit="false"
			rowList="20, 100, 10000" viewrecords="true" navigatorDelete="false"
			navigatorAdd="false" navigatorSearch="false" multiselect="false"
			shrinkToFit="true"
			navigatorExtraButtons="{
			seperator: { 
                        title : 'seperator'  
                }, 
			deleteAll : { 
	    		title : 'Delete All PVs',
	    		icon: 'ui-icon-closethick',
	    		caption: 'Delete All PVs', 
	    		onclick: function(){ selectTheVm() }
    		}
    		}">
			<sjg:gridColumn name="value" title="Actions" width="50"
				cssClass="link" formatter="formatActionLink" sortable="false" />
			<sjg:gridColumn name="value" index="value" title="PV" sortable="true" />
			<sjg:gridColumn name="valueMeaning.longName" index="vmLongName"
				sortable="true" title="PV Meaning" cssClass="link"
				formatter="formatVmLink" />
			<sjg:gridColumn name="valueMeaning.concepts" index="concepts"
				title="PV Meaning Concept Codes" sortable="true" align="left"
				formatter="formatConcept" width="100"/>
			<sjg:gridColumn name="valueMeaning.manualDefinition" width="250"
				title="PV Meaning Description" sortable="false" align="left" />
			<sjg:gridColumn name="beginDate" index="beginDate"
				title="PV Begin Date" sortable="true" sorttype="date" />
			<sjg:gridColumn name="endDate" index="endDate" title="PV End Date"
				sortable="true" />
			<sjg:gridColumn name="valueMeaning.publicIdVersion" index="vmId" width="100"
				title="VM Public Id Version" sortable="true" />
			<sjg:gridColumn name="origin" index="origin" title="PV Origin"
				sortable="true" />
		</sjg:grid>
	</sj:div>

</sj:div>