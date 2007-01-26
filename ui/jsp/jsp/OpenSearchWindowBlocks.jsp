<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/OpenSearchWindowBlocks.jsp,v 1.7 2007-01-26 17:30:14 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to secondary window error page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate" %>
<curate:checkLogon name="Userbean" page="/jsp/ErrorPageWindow.jsp" />
<html>
<head>
<title>CDE Curation: Search</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="FullDesignArial.css" rel="stylesheet" type="text/css">
<script>
history.forward();
</script>
</head>
<body>
<table width="100%" border="2" cellpadding="0" cellspacing="0">
  <col style="width: 2.3in" />
  <col />
  <tr valign="top">
    <td class="sidebarBGColor">
      <%@ include file="SearchParametersBlocks.jsp" %>
    </td>
    <td>
      <%@ include file="SearchResultsBlocks.jsp" %>
    </td>
  </tr>
</table>
</body>
</html>
