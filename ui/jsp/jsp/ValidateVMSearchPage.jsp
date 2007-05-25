<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/ValidateVMSearchPage.jsp,v 1.9 2007-05-25 05:03:27 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page errorPage="ErrorPage.jsp"%>
<html>
	<head>
		<title>
			CDE Curation: Validate Permissible Value
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<SCRIPT LANGUAGE="JavaScript" SRC="../../cdecurate/Assets/HelpFunctions.js"></SCRIPT>
		<script>
history.forward();
</script>
	</head>

	<body bgcolor="#FFFFFF" text="#000000" onHelp="showHelp('Help.htm#ValidatePMPage'); return false">
		<table width="100%" height="100%" border="2" cellpadding="0" cellspacing="0">
			<tr height="86%" valign="top">
				<td width="100%">
					<%@ include file="ValidateVM.jsp"%>
				</td>
			</tr>
		</table>
	</body>
</html>
