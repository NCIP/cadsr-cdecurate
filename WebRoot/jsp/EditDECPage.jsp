<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/EditDECPage.jsp,v 1.1 2007-09-10 16:16:48 hebell Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to login page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<curate:checkLogon name="Userbean" page="/LoginE.jsp" />
<!-- EditDECPage.jsp -->
<html>
	<head>
		<title>
			CDE Curation: Edit Data Element Concept
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<script>
		history.forward();
		</script>
        <!-- GF32723 load Dojo -->
        <%--<script src="//ajax.googleapis.com/ajax/libs/dojo/1.8.5/dojo/dojo.js" data-dojo-config="async: true"></script>--%>
        <script src="js/dojo/dojo/dojo.js" data-dojo-config="async: true"></script>
        <script>
        <%--require(["dojo"], function(dojo){--%>
        <%--dojo.ready(function(){--%>
        window.console && console.log("CreateDEC.jsp DOJO version used = [" + dojo.version.toString() + "]");
        <%--});--%>
        <%--});--%>
        </script>
        <%@ page import="gov.nih.nci.cadsr.cdecurate.tool.Session_Data"%>
	</head>

	<body bgcolor="#FFFFFF" text="#000000">
		<table width="100%" border="1" cellpadding="0" cellspacing="0">
			<tr>
				<td height="81" valign="top" colspan="2">

					<table width="100%" border="1" cellpadding="0" cellspacing="0">
						<tr>
							<td height="95" valign="top">
								<%@ include file="TitleBar.jsp"%>
							</td>
						</tr>
					</table width="100%" border="1" cellpadding="0" cellspacing="0">
				</td>

			</tr>
			<tr>
				<td width="100%" valign="top">
					<%@ include file="EditDEC.jsp"%>
				</td>
			</tr>
		</table>
		<%
    String statMsg = (String)request.getAttribute(Session_Data.SESSION_STATUS_MESSAGE);
    if(statMsg != null)
    {
%>
		<script language="JavaScript"> defaultStatus = "<%=statMsg%>"; </script>
		<%
    }
    else
    {
%>
		<script language="JavaScript"> defaultStatus = "Create new Data Element Concept"; </script>
		<%
    }
%>
	</body>
</html>
