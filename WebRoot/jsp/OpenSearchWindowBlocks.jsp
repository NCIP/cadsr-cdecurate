<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/OpenSearchWindowBlocks.jsp,v 1.2 2007-11-01 21:14:50 chickerura Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to secondary window error page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<curate:checkLogon name="Userbean" page="/ErrorPageWindow.jsp" />
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
	<head>
	<BASE href="<%=basePath%>">
		<title>
			CDE Curation: Search
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<script>
history.forward();
</script>
	</head>
	<body>
		<table width="100%" border="2" cellpadding="0" cellspacing="0">
			<col style="width: 2.3in" />
			<col />
			<tr valign="top">
				<td class="sidebarBGColor">
					<%@ include file="SearchParametersBlocks.jsp"%>
				</td>
				<td>
					<%@ include file="SearchResultsBlocks.jsp"%>
				</td>
			</tr>
		</table>
	</body>
</html>
