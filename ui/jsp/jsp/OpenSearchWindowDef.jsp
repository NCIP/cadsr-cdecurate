<!-- EVSSearchPage.jsp -->
<%@ page errorPage="ErrorPage.jsp"%>
<%@ taglib uri="/WEB-INF/tlds/curate.tld" prefix="curate" %>
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
  <col width="22%">
  <col width="78%">
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
