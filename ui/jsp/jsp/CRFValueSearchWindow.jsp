<!-- OpenSearchWindow.jsp -->
<%@ page errorPage="ErrorPage.jsp" %>
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate" %>
<html>
<head>
<title>CDE Curation: Search</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script>
history.forward();
</script>
<%
//System.out.println("in SearchResultsPage.jsp!!");
String sMenuAction5 = (String)session.getAttribute("MenuAction");
String sSelAC5 = "";
String sSearchAC5 = "";

 if (sMenuAction5.equals("searchForCreate"))
  {
    sSearchAC5 = (String)session.getAttribute("creSearchAC");
    sSelAC5 = (String)session.getAttribute("creSearchAC");
  }
  else
  {
    sSearchAC5 = (String)session.getAttribute("searchAC");
    sSelAC5 = (String)session.getAttribute("searchAC");
  }
  String sBackFromGetAssociated2 =  (String)session.getAttribute("backFromGetAssociated");
  if (sBackFromGetAssociated2 == null) sBackFromGetAssociated2 = "";
  String sSecondBackFromGetAssociated2 =  (String)session.getAttribute("SecondBackFromGetAssociated");
  if (sSecondBackFromGetAssociated2 == null) sSecondBackFromGetAssociated2 = "";

  if (sBackFromGetAssociated2.equals("backFromGetAssociated"))
  {
      Stack sSearchACStack = (Stack)session.getAttribute("sSearchACStack");
      if(sSearchACStack != null && sSearchACStack.size()>0 && sSecondBackFromGetAssociated2.equals(""))
      {
        sSearchAC5 = (String)sSearchACStack.pop();
        sSelAC5 = sSearchAC5;
       
      }
      if(sSearchACStack != null && sSearchACStack.size()>0)
      {
        sSearchAC5 = (String)sSearchACStack.pop();
        sSelAC5 = sSearchAC5;
        // do not lose the very first search result
        if(sSearchACStack.size()==0) sSearchACStack.push(sSelAC5);
        session.setAttribute("sSearchACStack", sSearchACStack);
      }
    session.setAttribute("searchAC", sSearchAC5);
    }
%>
</head>
<curate:checkLogon name="Userbean" page="/index.htm" />
<body bgcolor="#FFFFFF" text="#000000">
<table width="100%" border="2" cellpadding="0" cellspacing="0">
<col width="21%">
<col width="79%">
  <tr valign="top">
    <td bgcolor="#E2CAA2">
      <%@ include file="SearchParameters.jsp" %>
    </td>
    <td>
      <%@ include file="CRFValueResults.jsp" %>
    </td>
  </tr>

</table>
</body>
</html>
