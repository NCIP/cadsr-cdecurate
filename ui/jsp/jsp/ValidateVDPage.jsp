<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/ValidateVDPage.jsp,v 1.4 2007-01-25 22:39:31 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to login page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate" %>
<curate:checkLogon name="Userbean" page="/LoginE.jsp" />
<!-- ValidateVDPage.jsp -->
<html>
<head>
<title>CDE Curation: Validate Value Domain</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script>
history.forward();
</script>
</head>

<body
  onHelp = "showHelp('Help_CreateVD.html#ValidateVDPage'); return false">
<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
    <td height="95" colspan="2" valign="top">

      <table width="100%" cellpadding="0" cellspacing="0">
        <tr valign="center">
          <td><%@ include file="TitleBar.jsp" %></td>
        </tr>
      </table>

    </td>
  </tr>
  <tr>
    <td width="100%" valign="top">
      <%@ include file="ValidateVD.jsp" %>
    </td>
  </tr>
</table>
</body>
</html>
