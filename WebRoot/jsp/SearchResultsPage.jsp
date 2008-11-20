<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/SearchResultsPage.jsp,v 1.3 2008-11-20 18:02:27 veerlah Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to lgoin page if error occurs -->
<%@page errorPage="ErrorPage.jsp"%>
<%@taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<title>CDE Curation: Search</title>
		<link href="css/style.css" rel="stylesheet" type="text/css">
        <script language="javascript" src="js/SearchParameters.js"></script>
        <script language="javascript" src="js/SearchResults.js"></script>
        <script language="JavaScript" src="js/menu.js"></script>
        <script language="JavaScript" src="js/header.js"></script>
        <script language="javascript" type="text/javascript">
           history.forward();
        </script>
</head>
<curate:sessionAttributes/>
	<body onload="loaded('menuDefs'); enableDisableButtons();" onclick="menuHide();" onkeyup="if (event.keyCode == 27) menuHide();">
		<curate:header displayUser = "true"/>
		<jsp:include  page = "menuDefs.jsp" />
		<jsp:include  page = "Results.jsp" />
		<curate:footer/>
	</body>
</html>
