<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/ValidatePVPage.jsp,v 1.3 2008-07-03 21:40:58 chickerura Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to login page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%>
<curate:checkLogon name="Userbean" page="/LoginE.jsp" />
<html>
	<head>
		<title>
			CDE Curation: Validate Permissible Value
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<script>
history.forward();
 var helpUrl = "<%=ToolURL.getCurationToolHelpURL(pageContext)%>";

</script>
	</head>

	<body onHelp="showHelp('html/Help_CreateVD.html#ValidatePVPage',helpUrl); return false">
		<table width="100%" height="100%" border="2" cellpadding="0" cellspacing="0">
			<tr height="140" width="100%" valign="top">
				<td colspan=2>

					<table width="100%" cellpadding="0" cellspacing="0">
						<tr valign="center">
							<td height="95">
								<%@ include file="TitleBar.jsp"%>
							</td>
						</tr>
					</table>

				</td>
			</tr>
			<tr height="86%" valign="top">
				<td width="100%">
					<%@ include file="ValidatePV.jsp"%>
				</td>
			</tr>
		</table>
	</body>
</html>
