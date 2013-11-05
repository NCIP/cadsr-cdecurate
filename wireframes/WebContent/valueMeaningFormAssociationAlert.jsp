<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<p>This PV/VM has been associated with a CRF. Any edits will put the
	form out of sync. Are you sure you want to edit?</p>
<br>

<s:url id="changeVmUrl" value="changeValueMeaningFromVm.jsp"/>
<sj:a id="okReplaceVmButton" href="%{changeVmUrl}"
	button="true" buttonIcon="ui-icon-newwin"
	onClickTopics="closeVmAlertDialog" targets="vmDiv">OK</sj:a>
<sj:a id="cancelReplaceButton" href="#" button="true"
	buttonIcon="ui-icon-gear" onClickTopics="closeVmAlertDialog">Cancel</sj:a>