<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/RefDocumentUploadPage.jsp,v 1.8 2007-05-23 04:35:34 hegdes Exp $
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
		<script type="text/javascript" src="Assets/sorttable.js"></script>

		<LINK href="FullDesignArial.css" rel="stylesheet" type="text/css">
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
