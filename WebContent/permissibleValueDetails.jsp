<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>

<sj:div id="pvDetails">
	<sj:dialog id="createNewPvDialog" autoOpen="false" modal="true"
		title="permissible value dialogs" openTopics="openRemoteDialog"
		position="center" height="600" width="1000" closeTopics="closeDialog" />

	<sj:dialog id="pvFromConceptsDialog" autoOpen="false" modal="false"
		title="permissible value dialogs" openTopics="openRemoteDialog"
		position="center" height="600" width="1000" />

	<sj:dialog id="subConceptsDialog" autoOpen="false" modal="false"
		title="permissible value dialogs" openTopics="openRemoteDialog"
		position="center" height="600" width="1000" />


	<sj:dialog id="alertDialog" autoOpen="false" modal="true" title="alert"
		openTopics="openRemoteDialog" position="center" height="200"
		width="400" closeTopics="closeDialog" />

	<s:url id="createNewPvOption" action="createNewPv" />
	<s:url id="pvAlert" value="permissibleValueListFromParentAlert.jsp" />
	<s:url id="pvFromConceptsOption" action="createPvListFromConcepts" />

	<sj:div id="newPvOptions" onDisableTopics="disablePvOptions">
		<sj:a openDialog="createNewPvDialog"
			openDialogTitle="Create a New Permissible Value"
			href="%{createNewPvOption}" button="true" buttonIcon="ui-icon-newwin"
			onclick="$('#parentList').hide()">
    	Create a New One
    		</sj:a>
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
	</sj:div>
	<br>
	<sj:div id="existingPVs">
		<s:include value="permissibleValuesGrid.jsp">
			<s:param name="gridModel">pvModel</s:param>
			<s:param name="withParent">no</s:param>
			<s:param name="gridId">pvModelDiv</s:param>
			<s:param name="readOnly">no</s:param>
		</s:include>
	</sj:div>
</sj:div>
