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
	function openNewPvDialog(pv) {
		var newPvUrl = '<s:property value="createNewPvUrl"/>';
		$("#newPvDialog").load(newPvUrl).dialog("open");
	}
	function openPvEditDialog(pv) {
		var pvEditUrl = '<s:property value="pvEditUrl"/>';
		$("#pvEditDialog").load(pvEditUrl).dialog("open");
	}
</script>
<sjg:grid id="%{#gridId}" caption="Existing Permissible Values"
	dataType="json" href="%{pvTableUrl}" gridModel="%{#gridModel}"
	pager="true" navigator="%{#showNavigator}" navigatorEdit="false"
	navigatorAdd="false" navigatorSearch="false"
	multiselect="%{#showNavigator}"
	navigatorDeleteOptions="{height:280, reloadAfterSubmit:true}"
	navigatorExtraButtons="{
			add : { 
	    		title : 'Add New PV', 
	    		icon: 'ui-icon-plus', 
	    		onclick: function(){ openNewPvDialog() }
    		},
    		edit : { 
	    		title : 'Edit PV', 
	    		icon: 'ui-icon-pencil', 
	    		onclick: function(){ openPvEditDialog() }
    		}
    	}">
	<%--doesn't work <s:if test="%{#parameters.withParent[0]=='yes'}"> --%>
	<s:if test="%{#withParent == 'yes'}">
		<sjg:gridColumn name="parentConcept" title="Parent Concept"
			sortable="true" align="center" />
	</s:if>
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
	<sjg:gridColumn name="beginDate" title="PV Begin Date" sortable="true"
		width="120" />
	<sjg:gridColumn name="endDate" title="PV End Date" sortable="true"
		width="100" />
	<sjg:gridColumn name="valueMeaning.publicIdVersion"
		title="VM Public Id Version" sortable="true" width="150" />
	<sjg:gridColumn name="origin" title="PV Origin" sortable="true" />
</sjg:grid>
<br>