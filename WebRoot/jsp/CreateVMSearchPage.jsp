<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/CreateVMSearchPage.jsp,v 1.3 2008-07-03 21:27:37 chickerura Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page errorPage="ErrorPage.jsp"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%>

<html>
	<head>
		<title>
			CDE Curation: Create Permissible Value
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<script>
history.forward();
 var helpUrl = "<%=ToolURL.getCurationToolHelpURL(pageContext)%>";

</script>
	</head>

	<body onHelp="showHelp('html/Help_CreateVD.html#createVMPage',helpUrl); return false">
		<table width="100%" border="1" cellpadding="0" cellspacing="0">
			<tr>
				<td width="100%" valign="top">
					<%@ include file="CreateVM.jsp"%>
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
		<script language="JavaScript"> defaultStatus = "Create new Permissible Value"; </script>
		<%
    }
%>
	</body>
</html>
