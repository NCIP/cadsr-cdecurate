<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>

<sj:div id="pvSelectFromParentDiv"
	cssClass="result ui-widget-content ui-corner-all">
	<sj:dialog id="pvListFromParentDialog" autoOpen="false" modal="false"
		title="permissible value dialogs" openTopics="openRemoteDialog"
		position="right" height="600" width="1000" />
	<s:url id="createPvFromParentUrl" action="createPvListFromParent" />

	<sj:a id="searchParentButton" openDialog="pvListFromParentDialog"
		openDialogTitle="Search Parent Concepts"
		href="%{createPvFromParentUrl}" button="true"
		buttonIcon="ui-icon-newwin">
    	Search Parent Concept to Constrain
</sj:a>
	<br>
	<br>
	<sj:div id="parentTable"
		cssClass="result ui-widget-content ui-corner-all">
	</sj:div>
</sj:div>