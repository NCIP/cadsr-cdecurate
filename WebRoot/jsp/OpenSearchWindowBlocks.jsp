<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/OpenSearchWindowBlocks.jsp,v 1.3 2008-01-23 22:40:49 hebell Exp $
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
					<%@ include file="SearchResultsBlocks.jsp"%>    <!--JR1013 this is where the box is rendered-->
				</td>
			</tr>
		</table>
	</body>
</html>
