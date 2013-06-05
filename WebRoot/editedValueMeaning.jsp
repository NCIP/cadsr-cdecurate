<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>


<s:form id="editVmForm" action="ValueMeaningAction" target="_blank">
	<s:textfield name="longName" label="VM Long Name" value="Leg Bone" />
	<s:textfield name="publicId" label="Public Id" value="2567236"
		disabled="true" />
	<s:textfield name="version" label="Version" value="1.0" />
	<s:textarea name="description" label="Description/Definition"
		value="Commonly used to refer to the whole lower limb but technically only the part between the knee and ankle.: Connective tissue that forms the skeletal components of the body"
		rows="4" cols="80">
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
		<td colspan="2"><br> <s:include value="conceptsGrid.jsp">
				<s:param name="withParent">no</s:param>
				<s:param name="gridModel">editVmConceptModel</s:param>
				<s:param name="gridId">editVmConceptTable</s:param>
				<s:param name="gridCaption">VM Concepts</s:param>
				<s:param name="readOnly">no</s:param>
				<s:param name="showOrder">yes</s:param>
			</s:include><br>
		</td>
	</tr>
	<tr>
		<td>Alt Names/Defs</td>
		<td><sj:a openDialog="searchEVSDialogEditVm"
				openDialogTitle="Alternate Names/Definitions" href="#" button="true"
				buttonIcon="ui-icon-newwin">
    	Edit
   			</sj:a>
		</td>
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




