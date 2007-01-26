<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/EVSSearchPage.jsp,v 1.6 2007-01-26 20:17:44 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<html> 
<head>
<title>CDE Curation Tool: Search Enterprise Vocabulary System</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script>
history.forward();
</script>
</head>

<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <col style="width: 2.3in"/>
  <col /> 
  <tr valign="top">
    <td>
      <%@ include file="EVSSearchParameters.jsp" %>
    </td>
    <td> 
      <%@ include file="EVSSearchResults.jsp" %>
    </td>
  </tr>
</table>
</body>
</html>
