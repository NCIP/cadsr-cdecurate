<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/CreateVMSearchPage.jsp,v 1.2 2007-09-19 16:59:34 hebell Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page errorPage="ErrorPage.jsp"%>
<html>
	<head>
		<title>
			CDE Curation: Create Permissible Value
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<script>
history.forward();
</script>
	</head>

	<body onHelp="showHelp('html/Help_CreateVD.html#createVMPage'); return false">
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
