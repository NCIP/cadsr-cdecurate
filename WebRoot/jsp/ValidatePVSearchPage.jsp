<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/ValidatePVSearchPage.jsp,v 1.2 2007-09-19 16:59:35 hebell Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page errorPage="ErrorPage.jsp"%>
<html>
	<head>
		<title>
			CDE Curation: Validate Permissible Value
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<script>
history.forward();
</script>
	</head>

	<body bgcolor="#FFFFFF" text="#000000" onHelp="showHelp('html/Help.htm#ValidatePVPage'); return false">
		<table width="100%" height="100%" border="2" cellpadding="0" cellspacing="0">
			<tr height="86%" valign="top">
				<td width="100%">
					<%@ include file="ValidatePV.jsp"%>
				</td>
			</tr>
		</table>
	</body>
</html>
