<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<p>This PV/VM has been associated with a CRF. Any edits will put the
	form out of sync. Are you sure you want to edit?</p>
<br>
<s:url id="changeVmOptions1" action="searchExistingVmEditPv" />
<sj:dialog id="changeVmOptionDialog" autoOpen="false" modal="false"
	title="vm options diaglog" openTopics="openRemoteDialog"
	position="right" height="600" width="900" />
<sj:a id="okReplaceVmButton" openDialog="changeVmOptionDialog"
	openDialogTitle="Search Existing VM" href="%{changeVmOptions1}"
	button="true" buttonIcon="ui-icon-newwin"
	onClickTopics="closeVmAlertDialog">OK</sj:a>
<sj:a id="cancelReplaceButton" href="#" button="true"
	buttonIcon="ui-icon-gear" onClickTopics="closeVmAlertDialog">Cancel</sj:a>