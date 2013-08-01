<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/ValidateDEPage.jsp,v 1.3 2008-07-03 21:40:21 chickerura Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to login page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%>
<curate:checkLogon name="Userbean" page="/LoginE.jsp" />
<!-- ValidateDEPage.jsp -->
<html>
	<head>
		<title>
			CDE Curation: Validate Data Element
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<script>
history.forward();
 var helpUrl = "<%=ToolURL.getCurationToolHelpURL(pageContext)%>";

</script>
		<%@ page import="java.util.*"%>
	</head>

	<body onHelp="showHelp('html/Help_CreateDE.html#ValidateDEPage',helpUrl); return false">
		<table width="100%" border="1" cellpadding="0" cellspacing="0">
			<tr>
				<td height="81" colspan="2" valign="top">

					<table width="100%" border="2" cellpadding="0" cellspacing="0">
						<td height="95" valign="bottom">
							<%@ include file="TitleBar.jsp"%>
						</td>
					</table width="100%" border="2" cellpadding="0" cellspacing="0">

				</td>
			</tr>
			<tr>
				<td width="100%" valign="top">
					<%@ include file="ValidateDE.jsp"%>
				</td>
			</tr>
		</table>
	</body>
</html>
