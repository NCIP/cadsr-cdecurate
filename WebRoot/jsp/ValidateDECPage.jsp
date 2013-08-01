<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/ValidateDECPage.jsp,v 1.3 2008-07-03 21:39:43 chickerura Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to login page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%>
<curate:checkLogon name="Userbean" page="/LoginE.jsp" />
<html>
	<head>
		<title>
			CDE Curation: Validate Data Element Concept
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<script>
history.forward();
 var helpUrl = "<%=ToolURL.getCurationToolHelpURL(pageContext)%>";

</script>
	</head>

	<body bgcolor="#FFFFFF" text="#000000" onHelp="showHelp('html/Help_CreateDEC.html#ValidateDECPage',helpUrl); return false">
		<table width="100%" height="100%" border="2" cellpadding="0" cellspacing="0">
			<tr height="95" width="100%" valign="top">
				<td colspan=2>

					<table width="100%" cellpadding="0" cellspacing="0">
						<tr valign="center">
							<td>
								<%@ include file="TitleBar.jsp"%>
							</td>
						</tr>
					</table>

				</td>
			</tr>
			<tr height="86%" valign="top">
				<td width="100%">
					<%@ include file="ValidateDEC.jsp"%>
				</td>
			</tr>
		</table>
	</body>
</html>
