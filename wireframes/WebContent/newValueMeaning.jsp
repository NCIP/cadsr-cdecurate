<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>

<sj:div cssClass="result ui-widget-content ui-corner-all">
	<s:form id="newVmForm1">
		<s:textfield name="longName" label="VM Long Name" />
		<s:textarea name="description" label="Description/Definition" rows="2"
			cols="50">
		</s:textarea>

	</s:form>
	<br>
	<s:url id="secondMatchingVmsUrl" value="secondMatchedVmsGrid.jsp" />
	<sj:dialog id="secondMatchingVmDialog" href="%{secondMatchingVmsUrl}"
		title="Matching VMs" autoOpen="false" modal="true" height="600"
		width="1000" closeTopics="closeSecondVmMatchDialog" position="right">
	</sj:dialog>

	<sj:a openDialog="secondMatchingVmDialog" button="true"
		buttonIcon="ui-icon-newwin">Save the VM</sj:a>
	<sj:a button="true" buttonIcon="ui-icon-newwin"
		onclick="hideDiv('vmDiv')">Cancel</sj:a>
</sj:div>
