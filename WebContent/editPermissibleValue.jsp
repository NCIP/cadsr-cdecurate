<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<s:div cssClass="result ui-widget-content ui-corner-all">
	<s:form id="editPvForm" action="permissibleValueAction" target="_blank">
		<s:textfield id="value" name="value" label="Value" required="true"
			value="Bone" />
		<s:url id="jsonOrigins" action="originJson" />
		<sj:select id="origin" name="origin" label="Value Origin"
			href="%{jsonOrigins}" list="origins" autocomplete="true"
			loadMinimumCount="2" selectBoxIcon="true"
			onChangeTopics="autocompleteChange" onFocusTopics="autocompleteFocus"
			onSelectTopics="autocompleteSelect" size="180" />
		<sj:datepicker id="beginDate" name="beginDate" maxDate="-1d"
			label="Begin Date" required="true" value="02/11/2012" />
		<sj:datepicker id="endDate" name="endDate" maxDate="-1d"
			label="End Date" />
		<s:url id="changeVmOptions1" action="searchExistingVmEditPv" />
		<s:url id="changeVmOptions2" action="searchEVSConceptEditPv" />
		<sj:dialog id="changeVmOptionDialog" autoOpen="false" modal="true"
			title="vm options diaglog" openTopics="openRemoteDialog"
			position="right" height="600" width="1000"
			closeTopics="closeThisDialog" />
		<table>
			<tr>
				<td>Value Meaning:</td>
				<td><sj:div id="changeVmOptions">
						<sj:a openDialog="changeVmOptionDialog"
							openDialogTitle="Search Existing VM" href="%{changeVmOptions1}"
							button="true" buttonIcon="ui-icon-newwin">
    	Change By Searching Existing VM
    		</sj:a>
						<sj:a openDialog="changeVmOptionDialog"
							openDialogTitle="Search EVS Concept" href="%{changeVmOptions2}"
							button="true" buttonIcon="ui-icon-newwin">
    	Change By Searching EVS Concept
   			</sj:a>
					</sj:div></td>
			</tr>
		</table>
		<sj:div id="vmDiv" cssClass="result ui-widget-content ui-corner-all">
			<s:form id="changeVmForm" action="ValueMeaningAction" target="_blank">
				<s:textfield name="longName" label="VM Long Name" value="Bone"
					disabled="true" />
				<s:textfield name="publicIdVersion" label="Public Id & Version"
					value="2567236v1.0" disabled="true" />
				<s:textarea name="description" label="Description/Definition"
					value="Connective tissue that forms the skeletal components of the body"
					disabled="true" rows="2" cols="50">
				</s:textarea>
				<s:include value="conceptsGrid.jsp">
					<s:param name="withParent">no</s:param>
					<s:param name="gridModel">conceptModel</s:param>
					<s:param name="gridId">origVmConceptTable</s:param>
					<s:param name="gridCaption">VM Concepts</s:param>
					<s:param name="readOnly">yes</s:param>
				</s:include>
			</s:form>
		</sj:div>
		<br>
		<table>
			<tr>
				<td><s:url id="pvTableUrl" action="editPv" /> <sj:a
						id="editPvButton" href="%{pvTableUrl}" targets="existingPVs"
						listenTopics="existingPVs" button="true" buttonIcon="ui-icon-gear"
						onCompleteTopics="closeDialog">Save the PV</sj:a> <%--
				<sj:submit targets="result" button="true" validate="true"
						value="Update" indicator="indicator" align="right"
						parentTheme="simple" /> --%>
				</td>
				<td><sj:submit targets="result" button="true" validate="true"
						value="Delete the PV" indicator="indicator" align="right"
						parentTheme="simple" />
				</td>
			</tr>
		</table>
	</s:form>
	<img id="indicator" src="images/indicator.gif" alt="Loading..."
		style="display: none" />
</s:div>