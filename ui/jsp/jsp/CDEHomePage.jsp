<%@ page errorPage="ErrorPage.jsp" %>
<html>
<head>
<title>CDE Curation: Search</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script>
history.forward();
</script>
<%
// System.out.println("in CDEHomePage.jsp!!");
String sMenuAction3 = (String)session.getAttribute("MenuAction");
String sSelAC3 = "";
String sSearchAC3 = "";
Vector vACAttr2 = new Vector();

 if (sMenuAction3.equals("searchForCreate"))
  {
    sSearchAC3 = (String)session.getAttribute("creSearchAC");
    sSelAC3 = (String)session.getAttribute("creSearchAC");
    vACAttr2 = (Vector)session.getAttribute("creAttributeList");
  }
  else
  {
    sSearchAC3 = (String)session.getAttribute("searchAC");
    sSelAC3 = (String)session.getAttribute("searchAC");
    vACAttr2 = (Vector)session.getAttribute("serAttributeList");
  }
  String sBackFromGetAssociated2 =  (String)session.getAttribute("backFromGetAssociated");
  if (sBackFromGetAssociated2 == null) sBackFromGetAssociated2 = "";
  String sSecondBackFromGetAssociated2 =  (String)session.getAttribute("SecondBackFromGetAssociated");
  if (sSecondBackFromGetAssociated2 == null) sSecondBackFromGetAssociated2 = "";
//System.out.println("CDE sBackFromGetAssociated2: " + sBackFromGetAssociated2);

  if (sBackFromGetAssociated2.equals("backFromGetAssociated"))
  {
  //  System.out.println("SParam.jsp enter setResVec");
      Stack sSearchACStack = (Stack)session.getAttribute("sSearchACStack");
      if(sSearchACStack != null && sSearchACStack.size()>0 && sSecondBackFromGetAssociated2.equals(""))
      {
        sSearchAC3 = (String)sSearchACStack.pop();
        sSelAC3 = sSearchAC3;
      }
      if(sSearchACStack != null && sSearchACStack.size()>0)
      {
        sSearchAC3 = (String)sSearchACStack.pop();
        sSelAC3 = sSearchAC3;
        session.setAttribute("sSearchACStack", sSearchACStack);
        sSearchACStack.push(sSearchAC3);
      }
    session.setAttribute("searchAC", sSearchAC3);
System.out.println("CDEHomePage sSearchAC3: " + sSearchAC3);
      Stack vAttributeListStack = (Stack)session.getAttribute("vAttributeListStack");
//System.out.println("CDE vAttributeListStack: " + vAttributeListStack);
      if (vAttributeListStack != null && vAttributeListStack.size()>0 && sSecondBackFromGetAssociated2.equals(""))
      {
        vACAttr2 = (Vector)vAttributeListStack.pop();
      }
      if (vAttributeListStack != null && vAttributeListStack.size()>0)
      {
        vACAttr2 = (Vector)vAttributeListStack.pop();
        // do not lose the very first search result
      //  if(vAttributeListStack.size()==0) 
      //  {
          vAttributeListStack.push(vACAttr2);
      //  }
        session.setAttribute("vAttributeListStack", vAttributeListStack);
        session.setAttribute("serAttributeList", vACAttr2);
    } 
  }
%>
</head>

<body>
  <table width="100%" border="1" cellpadding="0" cellspacing="0">
    <col width="20%">
    <col width="80%">
    <tr height="95" valign="top">
      <td colspan=2><%@ include file="TitleBar.jsp" %></td>
    </tr>
    <tr valign="top">
      <td bgcolor="#E2CAA2">
        <%@ include file="SearchParameters.jsp" %>
      </td>
      <td>
        <%@ include file="SearchResults.jsp" %>
      </td>
    </tr>
  </table>
<%
    String statMsg = (String)request.getAttribute("statusMessage");
    if(statMsg != null)
    {
%>
        <script language="JavaScript"> defaultStatus = "<%=statMsg%>"; </script>
<%
    }
    else
    {
%>
        <script language="JavaScript"> defaultStatus = "Welcome to Common Data Element Curation Tool"; </script>
<%
    }
%>
</body>
</html>

