<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<sj:div id="editVmDiv">
	<sj:div id="vmInfoDiv"
		cssClass="result ui-widget-content ui-corner-all">
		<s:form id="editVmForm" action="ValueMeaningAction" target="_blank">
			<s:textfield name="longName" label="VM Long Name" value="Bone" />
			<s:textfield name="publicId" label="Public Id" value="2567236"
				disabled="true" />
			<s:textfield name="version" label="Version" value="1.0" />
			<s:textarea name="description" label="Description/Definition"
				value="Connective tissue that forms the skeletal components of the body"
				rows="2" cols="50">
			</s:textarea>
			<s:url id="searchEVSConceptEditVmUrl" action="searchEVSConceptEditVm" />
			<sj:dialog id="searchEVSDialogEditVm" autoOpen="false" modal="false"
				title="vm options diaglog" openTopics="openRemoteDialog"
				position="right" height="600" width="900"
				closeTopics="closeThisDialog" />
			<tr>
				<td>Concepts:</td>
				<td><sj:a openDialog="searchEVSDialogEditVm"
						openDialogTitle="Search EVS Concept"
						href="%{searchEVSConceptEditVmUrl}" button="true"
						buttonIcon="ui-icon-newwin">
    	Search Concept
   			</sj:a></td>
			</tr>
			<tr>
				<td></td>
				<td><br> <sj:div id="editVmConceptTableDiv">
						<s:include value="conceptsGrid.jsp">
							<s:param name="withParent">no</s:param>
							<s:param name="gridModel">conceptModel</s:param>
							<s:param name="gridId">editVmConceptTable</s:param>
							<s:param name="gridCaption">VM Concepts</s:param>
							<s:param name="readOnly">no</s:param>
						</s:include>
						<br>
					</sj:div>
				</td>
			</tr>
			<tr>
				<td>Alt Names/Defs</td>
				<td><sj:a openDialog="searchEVSDialogEditVm"
						openDialogTitle="Alternate Names/Definitions" href="#" button="true"
						buttonIcon="ui-icon-newwin">
    	Edit
   			</sj:a></td>
			</tr>
			<%--
			<tr>
				<td></td>
				<td align="right"><sj:submit targets="result" button="true"
						validate="true" value="Save" indicator="indicator" align="right"
						parentTheme="simple" /></td>
			</tr>
			 --%>
		</s:form>
	</sj:div>

	<br>
	<s:url id="editVmPvTableUrl" action="editPvWithEditedVm" />
	<sj:a id="editVmButton" href="%{editVmPvTableUrl}"
		targets="existingPVs" button="true" buttonIcon="ui-icon-gear"
		onClickTopics="closeDialog">Save the VM</sj:a>
	<%--
	<sj:submit formIds="editVmForm" targets="result" button="true"
		validate="true" value="Update the VM" indicator="indicator"
		align="right" parentTheme="simple" /> --%>
	<s:url var="readVmUrl" action="vmDetails" />
	<sj:a id="readVmAnchor" href="%{readVmUrl}" targets="editVmDiv"
		button="true" buttonIcon="ui-icon-gear">
    	Cancel
    </sj:a>
</sj:div>