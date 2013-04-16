<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<p>Some permissible values in the list are associated with a CRF,
	proceed with the deletion?</p>
<br>
<s:url var="pvDetailsWithParentUrl" action="pvDetailsWithParent" />
<sj:a id="okDeleteButton" href="%{pvDetailsWithParentUrl}" button="true"
	buttonIcon="ui-icon-newwin" targets="pvDetails" onClickTopics="closeDialog">
    	OK
</sj:a>
<sj:a id="cancelDeleteButton" href="#" button="true"
	buttonIcon="ui-icon-gear" onClickTopics="closeDialog">Cancel</sj:a>
