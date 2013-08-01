<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/RefDocumentUploadPage.jsp,v 1.2 2009-04-15 21:25:11 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page errorPage="ErrorPage.jsp"%>
<%@ page session="true"%>

<html>
	<head>
		<title>
			CDE Curation: Reference Document Attachments
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<script>
history.forward();
</script>
		<script type="text/javascript" src="js/sorttable.js"></script>

		<LINK href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<link href="css/style.css" rel="stylesheet" type="text/css">
	</head>

	<body>

		<table width="100%" border="1" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<%@ include file="TitleBar.jsp"%>
				</td>

			</tr>
			<tr>
				<td>
					<%@ include file="RefDocumentUpload.jsp"%>
				</td>
			</tr>
		</table>
	</body>
</html>
