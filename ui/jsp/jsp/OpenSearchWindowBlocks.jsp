<!-- OpenSearchWindowBlocks.jsp -->
<%@ page errorPage="ErrorPage.jsp" %>
<%@ taglib uri="/WEB-INF/tlds/curate.tld" prefix="curate" %>
<html>
<head>
<title>CDE Curation: Search</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="FullDesignArial.css" rel="stylesheet" type="text/css">
<script>
history.forward();
</script>
</head>
<curate:checkLogon name="Userbean" page="/jsp/ErrorPageWindow.jsp" />
<body>
<table width="100%" border="2" cellpadding="0" cellspacing="0">
  <col width="21%">
  <col width="79%">
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
