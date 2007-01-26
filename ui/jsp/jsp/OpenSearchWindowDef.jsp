<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/OpenSearchWindowDef.jsp,v 1.5 2007-01-26 17:30:14 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page errorPage="ErrorPage.jsp"%>
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate" %>
<html> 
<head>
<title>CDE Curation Tool: Search Enterprise Vocabulary System</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script>
history.forward();
</script>
</head>
<curate:checkLogon name="Userbean" page="/jsp/ErrorPageWindow.jsp" />
<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <col style="width: 2.3in"/>
  <col />
  <tr valign="top">
    <td>
      <%@ include file="DefSearchParameters.jsp" %>
    </td>
    <td> 
      <%@ include file="DefSearchResults.jsp" %>
    </td>
  </tr>
</table>
</body>
</html>
