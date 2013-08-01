<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<s:div cssClass="result ui-widget-content ui-corner-all">
	<sj:div>
		<s:form id="newPvForm" action="permissibleValueAction" target="_blank">
			<s:textfield id="value" name="value" label="Value" required="true" />
			<s:url id="jsonOrigins" action="originJson" />
			<sj:select id="newPvOrigin" name="origin" label="Value Origin"
				href="%{jsonOrigins}" list="origins" autocomplete="true"
				loadMinimumCount="2" selectBoxIcon="true"
				onChangeTopics="autocompleteChange"
				onFocusTopics="autocompleteFocus"
				onSelectTopics="autocompleteSelect" size="180" />
			<sj:datepicker id="beginDate" name="beginDate" label="Begin Date"
				required="true" value="01/11/2013" />
			<sj:datepicker id="endDate" name="endDate" label="End Date" />
		</s:form>
		<br>
	</sj:div>
	<%--<s:url id="searchConceptsUrl" action="searchConcepts" /> --%>
	<s:url id="searchConceptsUrl" value="searchConceptForVm.jsp" />
	<sj:dialog id="searchConceptDialog" autoOpen="false" modal="false"
		openTopics="openRemoteDialog" position="['right', 'top']" height="600"
		width="1200" closeTopics="closeSearchConceptDialog" />
	<table>
		<tr>
			<td>Value Meaning*</td>
			<td>
				<%--
	<s:textfield id="vmSearchString" name="VM Search String"
		label="Value Meaning" width="200" required="true" /> --%> <sj:a
					openDialog="searchConceptDialog" openDialogTitle="Search Concepts"
					href="%{searchConceptsUrl}" button="true" >Search Concept
	</sj:a></td>
		</tr>
	</table>
	<%--
	<table>
		<tr>
			<td>Value Meaning*:</td>
			<td><s:textfield id="vmSearchString" name="VM Search String"
					label="vmSearchString" width="200" /></td>
			<td><sj:div id="searchVmOptions">
					<sj:a openDialog="vmOptionDialog1"
						openDialogTitle="Search Existing VM" href="%{searchVmOption1}"
						button="true">Search Concepts
					</sj:a>
					
					<sj:a openDialog="vmOptionDialog2"
						openDialogTitle="Search EVS Concept" href="%{searchVmOption2}"
						button="true" buttonIcon="ui-icon-newwin">

    	Search EVS Concept
   			</sj:a>--%>
	<%--
					<s:url var="newVmUrl" action="createNewVm" />
					<sj:a id="newVmAnchor" indicator="indicator" href="%{newVmUrl}"
						targets="selectedVmResultDiv" listenTopics="selectedVmResultDiv"
						button="true" buttonIcon="ui-icon-gear">
    	Create New VM</sj:a> 
	</sj:div>
	</td>
	</tr>
	</table>--%>
	<sj:div id="vmDiv">

	</sj:div>
	<div id="selectedVmResultDiv">
		<br>
		<%--
		<s:form id="selectVmForm" action="ValueMeaningAction" target="_blank">
			<s:textfield name="longName" label="VM Long Name" disabled="true" />
			<s:textfield name="publicIdVersion" label="Public Id & Version"
				disabled="true" />
			<s:textarea name="description" label="Description/Definition"
				disabled="true" rows="2" cols="50">
			</s:textarea>
			<tr>
				<td>Concepts:</td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td><s:url var="conceptTableUrl" action="conceptJson" /> <sjg:grid
						id="searchVmConceptTable1" dataType="json"
						href="%{conceptTableUrl}" gridModel="emptyModel" scroll="true"
						pager="true" shrinkToFit="true">
						<sjg:gridColumn name="name" title="Concept Name" sortable="true"
							align="center" />
						<sjg:gridColumn name="evsId" title="Concept ID" sortable="true"
							align="center" />
						<sjg:gridColumn name="vocabulary" title="Vocabulary"
							sortable="true" align="center" />
						<sjg:gridColumn name="type" title="Type" sortable="true"
							align="center" />
					</sjg:grid>
				</td>
			</tr>
		</s:form>
		--%>
	</div>

	<%--
	<sj:submit button="true" validate="true" value="Save the PV"
		indicator="indicator" align="right" parentTheme="simple"
		results="selectedVmResultDiv" href="%{pvTableUrl}"
		onCompleteTopics="closeDialog" />
		 --%>
</s:div>
