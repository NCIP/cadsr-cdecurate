<%@ page errorPage="ErrorPage.jsp" %>
<!-- ValidateDEPage.jsp -->
<html>
<head>
<title>CDE Curation: Validate Data Element</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script>
history.forward();
</script>
<%@ page import="java.util.*" %>
</head>

<body
  onHelp = "showHelp('Help_CreateDE.html#ValidateDEPage'); return false">
<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
    <td height="81" colspan="2" valign="top">

      <table width="100%" border="2" cellpadding="0" cellspacing="0">
        <td height="95" valign="bottom">
          <%@ include file="TitleBar.jsp" %>
        </td>
      </table width="100%" border="2" cellpadding="0" cellspacing="0">

    </td>
  </tr>
  <tr>
    <td width="100%" valign="top">
      <%@ include file="ValidateDE.jsp" %>
    </td>
  </tr>
</table>
</body>
</html>
