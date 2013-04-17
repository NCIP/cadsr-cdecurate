<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<sj:div id="pvDeleteAlert">
	<p>This will require removing the existing Permissible Values,
		proceed?</p>
	<br>
	<s:url var="pvFormAlertUrl"
		value="permissibleValueListFormAssociationAlert.jsp" />
	<sj:a id="okButton" href="%{pvFormAlertUrl}" button="true"
		buttonIcon="ui-icon-newwin" targets="pvDeleteAlert">
    	OK
</sj:a>
	<sj:a id="cancelButton" href="#" button="true"
		buttonIcon="ui-icon-gear" onClickTopics="closeDialog">Cancel</sj:a>
</sj:div>