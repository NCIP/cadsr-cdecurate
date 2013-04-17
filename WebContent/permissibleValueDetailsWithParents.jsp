<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<sj:dialog id="pvListFromParentDialog" autoOpen="false" modal="false"
	title="permissible value dialogs" openTopics="openRemoteDialog"
	position="right" height="600" width="1100"
	closeTopics="closeThisDialog" />
<s:url id="createPvFromParentUrl" action="createPvListFromParent" />

<sj:a id="searchParentButton" openDialog="pvListFromParentDialog"
	openDialogTitle="Search Parent Concepts"
	href="%{createPvFromParentUrl}" button="true"
	buttonIcon="ui-icon-newwin">
    	Search Parent Concept to Constrain
</sj:a>
<sj:div id="parentTable">
</sj:div>

<sj:div id="pvModelFromParentDiv"
	cssClass="result ui-widget-content ui-corner-all">
	<br>
	<s:include value="permissibleValuesGrid.jsp">
		<s:param name="gridModel">emptyModel</s:param>
		<s:param name="withParent">yes</s:param>
		<s:param name="gridId">emptyModelDiv</s:param>
		<s:param name="readOnly">yes</s:param>
	</s:include>
</sj:div>