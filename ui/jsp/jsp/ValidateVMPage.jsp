<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/ValidateVMPage.jsp,v 1.3 2007-01-25 22:39:31 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page errorPage="ErrorPage.jsp" %>
<html>
<head>
<title>CDE Curation: Validate Permissible Value</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script>
history.forward();
</script>
</head>

<body
  onHelp = "showHelp('Help_CreateVD.html#ValidateVMPage'); return false">
<table width="100%" height="100%" border="2" cellpadding="0" cellspacing="0">
  <tr height="95" width="100%" valign="top" >
    <td colspan=2>

      <table width="100%" cellpadding="0" cellspacing="0">
        <tr valign="center">
          <td><%@ include file="TitleBar.jsp" %></td>
        </tr>
      </table>

    </td>
  </tr>
  <tr height="86%" valign="top">
    <td width="100%">
      <%@ include file="ValidateVM.jsp" %>
    </td>
  </tr>
</table>
</body>
</html>
