<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/ValidatePVPage.jsp,v 1.6 2007-01-26 19:30:38 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to login page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate" %>
<curate:checkLogon name="Userbean" page="/LoginE.jsp" />
<html>
<head>
<title>CDE Curation: Validate Permissible Value</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script>
history.forward();
</script>
</head>

<body
  onHelp = "showHelp('Help_CreateVD.html#ValidatePVPage'); return false">
<table width="100%" height="100%" border="2" cellpadding="0" cellspacing="0">
  <tr height="140" width="100%" valign="top" >
    <td colspan=2>

      <table width="100%" cellpadding="0" cellspacing="0">
        <tr valign="center">
          <td height="95"><%@ include file="TitleBar.jsp" %></td>
        </tr>
      </table>

    </td>
  </tr>
  <tr height="86%" valign="top">
    <td width="100%">
      <%@ include file="ValidatePV.jsp" %>
    </td>
  </tr>
</table>
</body>
</html>
