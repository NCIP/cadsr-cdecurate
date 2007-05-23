<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/CreateDEPage.jsp,v 1.9 2007-05-23 04:32:34 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<curate:checkLogon name="Userbean" page="/LoginE.jsp" />
<html>
	<head>
		<title>
			CDE Curation: Create Data Element
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<script>
history.forward();
</script>
	</head>

	<body bgcolor="#FFFFFF" text="#000000">
		<table width="100%" border="1" cellpadding="0" cellspacing="0">
			<tr>
				<td height=95 valign="top" colspan="2">
					<%@ include file="TitleBar.jsp"%>
				</td>
			</tr>
			<tr>
				<td height=90% valign="top" colspan="2">
					<%@ include file="CreateDE.jsp"%>
				</td>
			</tr>
		</table>

	</body>
</html>
