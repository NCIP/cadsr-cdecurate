<!-- OpenSearchWindow.jsp -->
<%@ page errorPage="ErrorPageWindow.jsp"%>
<%@ taglib uri="/WEB-INF/tlds/curate.tld" prefix="curate" %>
<html>
<head>
<title>CDE Curation: Search</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script>
history.forward();
</script>
<%
  String sMenuAction2 = (String)session.getAttribute("MenuAction");
  String sSelAC2 = "";
  String sSearchAC2 = "";
  Vector vACAttr2 = new Vector();

 if (sMenuAction2.equals("searchForCreate"))
  {
    sSearchAC2 = (String)session.getAttribute("creSearchAC");
    sSelAC2 = (String)session.getAttribute("creSearchAC");
    vACAttr2 = (Vector)session.getAttribute("creAttributeList");
  }
  else
  {
    sSearchAC2 = (String)session.getAttribute("searchAC");
    sSelAC2 = (String)session.getAttribute("searchAC");
    vACAttr2 = (Vector)session.getAttribute("serAttributeList");
  }
  String sBackFromGetAssociated2 =  (String)session.getAttribute("backFromGetAssociated");
  if (sBackFromGetAssociated2 == null) sBackFromGetAssociated2 = "";
  String sSecondBackFromGetAssociated2 =  (String)session.getAttribute("SecondBackFromGetAssociated");
  if (sSecondBackFromGetAssociated2 == null) sSecondBackFromGetAssociated2 = "";
//System.out.println("OpenSearchWindow vACAttr2: " + vACAttr2);
//System.out.println("OpenSearchWindow sSearchAC2: " + sSearchAC2);
  if (sBackFromGetAssociated2.equals("backFromGetAssociated"))
  {
      Stack sSearchACStack = (Stack)session.getAttribute("sSearchACStack");
      if(sSearchACStack != null && sSearchACStack.size()>0 && sSecondBackFromGetAssociated2.equals(""))
      {
        sSearchAC2 = (String)sSearchACStack.pop();
        sSelAC2 = sSearchAC2;
      }
      if(sSearchACStack != null && sSearchACStack.size()>0)
      {
        sSearchAC2 = (String)sSearchACStack.pop();
        sSelAC2 = sSearchAC2;
        // do not lose the very first search result
        if(sSearchACStack.size()==0) sSearchACStack.push(sSelAC2);
        session.setAttribute("sSearchACStack", sSearchACStack);
      }
      session.setAttribute("searchAC", sSearchAC2);

      Stack vAttributeListStack = (Stack)session.getAttribute("vAttributeListStack");
//System.out.println("OpenSearch vAttributeListStack: " + vAttributeListStack);
      if (vAttributeListStack != null && vAttributeListStack.size()>0 && sSecondBackFromGetAssociated2.equals(""))
      {
        vACAttr2 = (Vector)vAttributeListStack.pop();
      }
      if (vAttributeListStack != null && vAttributeListStack.size()>0)
      {
        vACAttr2 = (Vector)vAttributeListStack.pop();
        // do not lose the very first search result
        if(vAttributeListStack.size()==0) 
        {
          vAttributeListStack.push(vACAttr2);
        }
        session.setAttribute("vAttributeListStack", vAttributeListStack);
        session.setAttribute("serAttributeList", vACAttr2);
      }
    }
//System.out.println("done OpenSearchWindow.jsp!!");
%>
</head>
<curate:checkLogon name="Userbean" page="/jsp/ErrorPageWindow.jsp" />

<body>
<table width="100%" border="2" cellpadding="0" cellspacing="0">
  <col width="21%">
  <col width="79%">
  <tr valign="top">
    <td class="sidebarBGColor">
      <%@ include file="SearchParameters.jsp" %>
    </td>
    <td>
      <%@ include file="SearchResults.jsp" %>
    </td>
  </tr>
</table>
</body>
</html>
