<%@ page errorPage="ErrorPage.jsp"%>
<%@ page session="true"%>

<!-- RefDocumentUploadPage.jsp -->
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
