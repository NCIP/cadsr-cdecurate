<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!--
    Copyright (c) 2006 ScenPro, Inc.

    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/alternates.jsp,v 1.2 2009-04-21 03:47:35 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<%@ page import="java.util.*"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.ui.AltNamesDefsServlet"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.ui.AltNamesDefsSession"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.util.TreeNode"%>
<%@ page import="gov.nih.nci.cadsr.common.StringUtil"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<curate:checkLogon name="Userbean" page="/LoginE.jsp" />
<html>
	<head>
		<base href="<%=basePath%>">

		<title>
			Administered Component Alternate Names and Definitions
		</title>

		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="Administered,Component,Alternate,Names,Definitions">
		<meta http-equiv="description" content="Administered Component Alternate Names and Definitions">

		<link rel="stylesheet" type="text/css" href="css/alternates.css">

		<script>
        var nodeValue = "<%=TreeNode._nodeValue%>";
        var nodeName = "<%=TreeNode._nodeName%>";
        var parmIdseq = "<%=AltNamesDefsServlet._parmIdseq%>";
        var actionEditNameDef = "<%=AltNamesDefsServlet._actionEditNameDef%>";
        var actionDelNameDef = "<%=AltNamesDefsServlet._actionDelNameDef%>";
        var actionRestoreNameDef = "<%=AltNamesDefsServlet._actionRestoreNameDef%>";

        history.forward();
    </script>
		<script type="text/javascript" src="js/alternates.js"></script>
	</head>

	<body>
		<%
        String text;
    %>
		<form name="alternatesForm" method="post" action="NCICurationServlet">
			<input type="hidden" name="reqType" value="<%=AltNamesDefsServlet._reqType%>" />
			<input type="hidden" name="<%=AltNamesDefsServlet._actionTag%>" value="<%=AltNamesDefsServlet._actionViewName%>" />
			<input type="hidden" name="<%=AltNamesDefsServlet._prevActionTag%>" value="" />
			<input type="hidden" name="<%=AltNamesDefsServlet._parmIdseq%>" value="" />
			<%
            text = (String) pageContext.getRequest().getAttribute(AltNamesDefsServlet._reqSort);
        %>
			<input type="hidden" name="<%=AltNamesDefsServlet._reqSort%>" value="<%=text%>" />
			<%
            text = (String) pageContext.getRequest().getAttribute(AltNamesDefsServlet._reqIdseq);
        %>
			<input type="hidden" name="<%=AltNamesDefsServlet._reqIdseq%>" value="<%=text%>" />
			<%
            text = (String) pageContext.getRequest().getAttribute(AltNamesDefsSession._searchEVS);
        %>
			<input type="hidden" name="<%=AltNamesDefsSession._searchEVS%>" value="<%=text%>" />
			<%
            text = (String) pageContext.getRequest().getAttribute(AltNamesDefsSession._beanVMID);
        %>
			<input type="hidden" name="<%=AltNamesDefsSession._beanVMID%>" value="<%=text%>" />

			<table>
				<tr>
					<td>
						<p class="title1">
							Alternate Names & Definitions
						</p>
						<p class="note1">
							Changes are not permanent until the Administered Component is Validated and Saved.
						</p>
                        <p class="note1">
                            The Edit and Delete icons only appear for entries owned by Contexts for which the user has update privileges.
                        </p>
					</td>
					<td>
						<p id="process" class="title2">
							&nbsp;
						</p>
					</td>
				</tr>
			</table>
			<p class="title1">
				<%
            text = (String) pageContext.getRequest().getAttribute(AltNamesDefsServlet._reqTitle);
        %>
				<%=text%>
			</p>
			<p>
				<input type="button" value="Clear" onclick="doAction('<%=AltNamesDefsServlet._actionClear%>');" />
				&nbsp;
				<input type="button" value="Close" onclick="self.close();" />
			</p>
			<%
            text = (String) pageContext.getRequest().getAttribute(AltNamesDefsServlet._errors);
            if (text != null) {
        %>
			<p class="title1" style="color: red">
				<%=text%>
			</p>
			<% } %>
			<div class="tabs">
				<table>
					<colgroup>
						<col style="width: 1px" />
						<col style="width: 1px" />
						<col />
					</colgroup>
					<tr>
						<td class="taby">
							<%=AltNamesDefsServlet._tabViewName%>
						</td>
						<td class="tabx" onclick="doAction('<%=AltNamesDefsServlet._actionViewCSI%>');">
							<%=AltNamesDefsServlet._tabViewCSI%>
						</td>
						<td class="tabz">
							&nbsp;
						</td>
					</tr>
				</table>
			</div>
			<div style="margin-left: 0in; margin-right: 0in; border-left: 2px solid black; border-bottom: 2px solid black; border-right: 2px solid black; width: 100%; padding: 0.1in 0.1in 0.1in 0.1in">
				<%
                text = (String) pageContext.getRequest().getAttribute(AltNamesDefsServlet._reqSortTitle);
            %>
				<input type="button" name="btnSort" value="<%=text%>" onclick="doAction('<%=AltNamesDefsServlet._actionSort%>');">
				<input type="button" name="btnAddName" value="Add Name" onclick="doAction('<%=AltNamesDefsServlet._actionAddName%>');">
				<input type="button" name="btnAddDef" value="Add Definition" onclick="doAction('<%=AltNamesDefsServlet._actionAddDef%>');">
				<%
                text = StringUtil.cleanJavascriptAndHtml( (String) pageContext.getRequest().getAttribute(AltNamesDefsServlet._reqAttribute) );
            %>
				<%=text%>
			</div>
		</form>
	</body>
</html>
