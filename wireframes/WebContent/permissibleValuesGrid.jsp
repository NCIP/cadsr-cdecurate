<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>


<s:url var="pvTableUrl" action="pvJson" />
<sj:dialog id="newPvDialog" autoOpen="false" modal="true"
	title="permissible value dialogs" openTopics="openRemoteDialog"
	position="center" height="600" width="1000" closeTopics="closeDialog" />
<sj:dialog id="valueMeaningDetail" title="Value Meaning"
	autoOpen="false" modal="true" height="900" width="1000"
	closeTopics="closeDialog">
</sj:dialog>
<sj:dialog id="pvEditDialog" title="Edit Permissible Value"
	autoOpen="false" modal="true" height="600" width="1000"
	closeTopics="closeDialog">
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
<s:url id="createNewPvUrl" action="createNewPv" />
<s:url var="pvEditUrl" value="editPermissibleValue.jsp" />

<script type="text/javascript">
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
				+ cellvalue + "&#34;)'><font color='blue'>View</font></a>";
		var editLink = "<a href='#' onClick='javascript:openEditVmDialog(&#34;"
				+ cellvalue + "&#34;)'><font color='blue'>Edit</font></a>";
		return cellvalue + "<br><br>" + viewLink + "&nbsp;&nbsp;" + editLink;
	}

	function formatActionLink(cellvalue, options, rowObject) {
		//return "<a href='#' onClick='javascript:openDialog("+cellvalue+")'>"+cellvalue+"</a>";
		var editLink = "<a href='#' onClick='javascript:openPvEditDialog(&#34;"
				+ cellvalue
				+ "&#34;)'><img src='images/edit.gif' alt='edit PV'/></a>";
		var removeLink = "<a href='#' onClick='javascript:deletePvDialog(&#34;"
				+ cellvalue
				+ "&#34;)'><img src='images/delete_white.gif' alt='delete PV'/></a>";
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
		var id = jQuery('#existingPvTable').jqGrid('getGridParam', 'selrow');
		if (id) {
			var pv = jQuery('#existingPvTable').jqGrid('getRowData', id);
			//alert(pv.value);
		}
		var pvEditUrl = '<s:property value="pvEditUrl"/>';
		//$("#pvEditDialog").load(pvEditUrl).dialog("open");
		$("#pvEditDiv").load(pvEditUrl);

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
<sjg:grid id="%{#gridId}" caption="Existing Permissible Values"
	dataType="json" href="%{pvTableUrl}" gridModel="%{#gridModel}"
	toppager="true" pager="true" autoencode="false" navigator="true"
	navigatorEdit="false" rowList="10,15,20" rowNum="1000"
	viewrecords="true" navigatorDelete="false" navigatorAdd="false"
	navigatorSearch="false" multiselect="false" shrinkToFit="true"
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
	<%--doesn't work <s:if test="%{#parameters.withParent[0]=='yes'}"> --%>
	<%-- 
			<sjg:gridColumn name="valueMeaning" title="Value Meaning"
				sortable="false"  width="350" formatter="formatVm" />
			--%>
	<sjg:gridColumn name="" title="Actions" width="50" cssClass="link"
		formatter="formatActionLink" sortable="false" />

	<sjg:gridColumn name="value" title="PV" sortable="true" width="100" />
	<sjg:gridColumn name="valueMeaning.longName" sortable="true"
		title="PV Meaning" cssClass="link" formatter="formatVmLink"
		width="120" />
	<sjg:gridColumn name="valueMeaning.concepts"
		title="PV Meaning Concept Codes" sortable="true" align="left"
		width="210" formatter="formatConcept" />
	<sjg:gridColumn name="valueMeaning.manualDefinition"
		title="PV Meaning Description" sortable="true" align="left"
		width="250" />
	<sjg:gridColumn name="beginDate" title="PV Begin Date" sortable="true"
		width="120" />
	<sjg:gridColumn name="endDate" title="PV End Date" sortable="true"
		width="100" />
	<sjg:gridColumn name="valueMeaning.publicIdVersion"
		title="VM Public Id Version" sortable="true" width="130" />
	<sjg:gridColumn name="origin" title="PV Origin" sortable="true" />
</sjg:grid>
<br>