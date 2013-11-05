<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sb" uri="/struts-bootstrap-tags"%>
<sj:head jqueryui="true" jquerytheme="custom" customBasepath="themes"
	loadAtOnce="true" />
<%--<sj:head jqueryui="true" jquerytheme="smoothness" />
<sj:head jqueryui="true" jquerytheme="cupertino" /> 
<sj:head jqueryui="true" jquerytheme="redmond" loadAtOnce="true" />--%>
<title>Value Domain Wireframes</title>

<link href="styles/layout.css" rel="stylesheet" type="text/css" />
<link href="styles/custom.css" rel="stylesheet" type="text/css" />
<link href="styles/FullDesignArial.css" rel="stylesheet" type="text/css" />
<!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
<!--[if lt IE 9]>    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>    
<![endif]-->
<script type="text/javascript" src="js/showcase.js"></script>

<s:url var="pvUrl" value="editPermissibleValue.jsp" />
<s:url var="subConceptUrl" value="selectSubConceptsFromParent.jsp" />
<script type="text/javascript">
	function customizeGridNavIcons() {
		$('.ui-icon-trash').removeClass('ui-icon-trash').addClass(
				'ui-icon-minusthick');
	}
	function formatEditPvLink(cellvalue, options, rowObject) {
		//return "<a href='#' onClick='javascript:openDialog("+cellvalue+")'>"+cellvalue+"</a>";
		return "<a href='#' onClick='javascript:openPvDialog(&#34;" + cellvalue
				+ "&#34;)'>Edit</a>";

	}

	function openPvDialog(pv) {
		var pvEditUrl = '<s:property value="pvUrl"/>';
		$("#pvEdit").load(pvEditUrl).dialog("open");
	}

	function formatRemoveConceptLink(cellvalue, options, rowObject) {
		return "<a href='#'>Remove</a>";

	}

	function closeVmSearch() {
		$("#vmOptionDialog").dialog("close");
		$("#emptyVmResultDiv").hide();
		$("#vmResultDiv").show();
	}

	function showParentList() {
		$("#parentList").toggle();
	}

	function getConceptValuesLink(cellvalue, options, rowObject) {
		return "<a href='#' onClick='javascript:openSubConceptDialog(&#34;"
				+ cellvalue + "&#34;)'>Select Values</a>";
	}

	function openSubConceptDialog(parentConcept) {
		var subConceptUrl = '<s:property value="subConceptUrl"/>';
		$("#subConceptsDialog").load(subConceptUrl).dialog("open");
	}

	function cancelVmAlertButton() {
		$('#vmAlertDialog').dialog('close');
	};

	function hideDiv(divId) {
		$("#" + divId).hide();
	}

	function showDiv(divId) {
		$("#" + divId).show();
	}
</script>
</script>
</head>
<body>
	<div id="col3_content" class="clearfix">
		<s:url var="vdFormUrl" action="vdInfo" />
		<s:url var="pvDetailsUrl" value="permissibleValueDetails.jsp" />
		<sj:tabbedpanel id="vdTabsPanel">
	<%--		<sj:tab id="tab1" href="%{vdFormUrl}" label="Value Domain Details" /> --%>
			<sj:tab id="tab2" href="%{pvDetailsUrl}" label="Permissible Values" />
		</sj:tabbedpanel>
	</div>
</body>
</html>