<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/EditDesignateDEPage.jsp,v 1.9 2007-05-23 04:34:14 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<curate:checkLogon name="Userbean" page="/LoginE.jsp" />
<html>
	<head>
		<title>
			CDE Curation: Create Designate Data Element Attributes
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<script>
history.forward();
</script>
	</head>

	<body bgcolor="#FFFFFF" text="#000000">
		<table width="100%" border="1" cellpadding="0" cellspacing="0">
			<tr>
				<td height="81" colspan="2" valign="top">
					<table width="100%" border="2" cellpadding="0" cellspacing="0">
						<td height="95" valign="bottom">
							<%@ include file="TitleBar.jsp"%>
						</td>
					</table>
				</td>
			</tr>
			<tr>
				<td valign="top">
					<%@ include file="EditDesignateDE.jsp"%>
				</td>
			</tr>
		</table>
	</body>
</html>
