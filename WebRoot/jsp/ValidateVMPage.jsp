<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/ValidateVMPage.jsp,v 1.3 2008-07-03 21:42:43 chickerura Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page errorPage="ErrorPage.jsp"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%>

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

	<body onHelp="showHelp('html/Help_CreateVD.html#ValidateVMPage',helpUrl); return false">
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
					<%@ include file="ValidateVM.jsp"%>
				</td>
			</tr>
		</table>
	</body>
</html>
