<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>

<sj:dialog id="pvDialog" autoOpen="false" modal="false"
	title="New Permissible Value" openTopics="openRemoteDialog"
	position="center" height="400" width="600" />

<s:url id="pvOption1" value="newPermissibleValue.jsp" />
<s:url id="pvOption2" action="newPermissibleValueFromParentConcept.jsp" />
<s:url id="pvOption3" action="newPermissibleValueFromConcept.jsp" />

<sj:accordion id="accordionCPV" collapsible="true">
	<sj:accordionItem title="Create Permissible Values">
		<sj:div id="newPVs">
			<sj:a openDialog="pvDialog" href="%{pvOption1}" button="true"
				buttonIcon="ui-icon-newwin">
    	Create a New One
    		</sj:a>
			<sj:a openDialog="pvDialog" href="%{pvOption2}" button="true"
				buttonIcon="ui-icon-newwin">
    	Create a List from Parent Concept
   			</sj:a>
			<sj:a openDialog="pvDialog" href="%{pvOption3}" button="true"
				buttonIcon="ui-icon-newwin">
    	Create a List from Concepts
  			</sj:a>
		</sj:div>
	</sj:accordionItem>
</sj:accordion>
<sj:accordion id="accordionEPV" collapsible="true">
	<sj:accordionItem title="Existing Permissible Values">
		<sj:div id="existingPVs">
			<s:url var="pvUrl" action="pvJson" />
			<sjg:grid id="pvTable" caption="Existing Permissible Values"
				dataType="json" href="%{pvUrl}" gridModel="pvModel" rowNum="15"
				scroll="false">
				<sjg:gridColumn name="value" index="value" title="Value" />
				<sjg:gridColumn name="origin" index="origin" title="Origin" />
				<sjg:gridColumn name="beginDate" index="beginDate"
					title="Begin Date" />
				<sjg:gridColumn name="endDate" index="endDate" title="End Date" />
				<s:url var="vmUrl" action="vmJson" />
				<sjg:grid id="vmTable" caption="value meaning" dataType="json"
					subGridUrl="%{vmUrl}" gridModel="vmModel" rowNum="-1"
					footerrow="false" userDataOnFooter="false">
					<sjg:gridColumn name="longName" index="longName"
						title="VM Long Name" />
					<sjg:gridColumn name="publicId" index="publicId" title="Public ID" />
					<sjg:gridColumn name="version" index="version" title="Version" />
					<sjg:gridColumn name="manualDefinition" index="manualDefinition"
						title="Definition" />
				</sjg:grid>
			</sjg:grid>
		</sj:div>
	</sj:accordionItem>
</sj:accordion>
<%--
<s:url id="editVm" value="editValueMeaning.jsp" />
<sj:accordion id="accordionEVM" collapsible="true" autoHeight="true"
	active="false" href="editVm">
	<sj:accordionItem title="Edit Value Meanings">
		edit value meaning placeholder
	</sj:accordionItem>
</sj:accordion>
<br>
<br>
 --%>
