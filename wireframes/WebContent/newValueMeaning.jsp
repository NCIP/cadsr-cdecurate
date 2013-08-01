<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<sj:div id="newVmDiv">
	<sj:div cssClass="result ui-widget-content ui-corner-all">
		<div
			class="ui-dialog-titlebar ui-widget-header ui-corner-all ui-helper-clearfix">
			<span id="ui-dialog-title-alertDialog" class="ui-dialog-title">Create
				a New VM</span>
		</div>
		<br>
		<s:form id="newVmForm1">
			<s:textfield name="longName" label="VM Long Name" />
			<s:textarea name="description" label="Description/Definition"
				rows="2" cols="50">
			</s:textarea>
		</s:form>
		<br>
		<table width="100%">
			<tr>
				<td>Concepts:</td>
				<td><sj:a openDialog="searchConceptForVm2"
						openDialogTitle="Search EVS Concept"
						href="%{searchConceptForVm2Url}" button="true"
						buttonIcon="ui-icon-newwin">
    	Search New Concept
   			</sj:a>
				</td>
			</tr>
			<tr>
				<td></td>
				<td><br> <sj:div>
						<s:include value="conceptsGrid.jsp">
							<s:param name="withParent">no</s:param>
							<s:param name="gridModel">emptyConceptModel</s:param>
							<s:param name="gridId">newVmConceptGrid</s:param>
							<s:param name="gridCaption">VM Concepts</s:param>
							<s:param name="readOnly">yes</s:param>
						</s:include>
					</sj:div><br></td>
			</tr>
			<tr>
				<s:url id="secondMatchingVmsUrl" value="secondMatchedVmsGrid.jsp" />
				<sj:dialog id="secondMatchingVmDialog"
					href="%{secondMatchingVmsUrl}" title="Matching VMs"
					autoOpen="false" modal="true" height="600" width="1200"
					closeTopics="closeSecondVmMatchDialog" position="center">
				</sj:dialog>
				<td colspan="2" align="right">
					<%--<sj:a
					openDialog="secondMatchingVmDialog" button="true"
					buttonIcon="ui-icon-newwin">Create</sj:a> --%> <%--
		<s:url id="selectedVmResultUrl" action="selectedVmResult" />
		<sj:a id="useSelectedVm" indicator="indicator2"
			href="%{selectedVmResultUrl}" targets="selectedVmResultDiv"
			button="true" buttonIcon="ui-icon-gear"
			onClickTopics="closeSearchedConceptDialog" onclick="hideDiv('vmDiv')">Save the VM</sj:a>--%>
					<sj:a id="cancelNewVm" onclick="hideDiv('newVmDiv')" button="true"
						buttonIcon="ui-icon-gear">
    	Cancel
    </sj:a>
				</td>
			</tr>
		</table>
	</sj:div>
	<s:url id="secondMatchingVmsUrl" value="secondMatchedVmsGrid.jsp" />
	<sj:dialog id="secondMatchingVmDialog" href="%{secondMatchingVmsUrl}"
		title="Matching VMs" autoOpen="false" modal="true" height="600"
		width="1200" closeTopics="closeSecondVmMatchDialog" position="center">
	</sj:dialog>
	<img id="indicator" src="images/indicator.gif" alt="Loading..."
		style="display: none" />
	<s:url id="addPvUrl" action="addPv" />
	<sj:a openDialog="secondMatchingVmDialog" button="true"
		buttonIcon="ui-icon-newwin">Save the PV</sj:a>
	<sj:a id="cancelAddPvButton" onclick="hideDiv('pvEditDiv')"
		button="true" buttonIcon="ui-icon-gear">
    	Cancel
    </sj:a>
</sj:div>