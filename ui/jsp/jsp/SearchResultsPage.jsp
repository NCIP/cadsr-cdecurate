<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/SearchResultsPage.jsp,v 1.9 2007-05-23 04:36:04 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to lgoin page if error occurs -->
<%@ page errorPage="ErrorPage.jsp"%>
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<curate:checkLogon name="Userbean" page="/LoginE.jsp" />
<html>
	<head>
		<title>
			CDE Curation: Search
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<script>
history.forward();
</script>
		<%
//System.out.println("in SearchResultsPage.jsp!!");
String sMenuAction4 = (String)session.getAttribute(Session_Data.SESSION_MENU_ACTION);
String sSelAC4 = "";
String sSearchAC4 = "";
Vector vACAttr4 = new Vector();
Vector vSelAttr4 = new Vector();

 if (sMenuAction4.equals("searchForCreate"))
  {
    sSearchAC4 = (String)session.getAttribute("creSearchAC");
    sSelAC4 = (String)session.getAttribute("creSearchAC");
    vACAttr4 = (Vector)session.getAttribute("creAttributeList");
  }
  else
  {
    sSearchAC4 = (String)session.getAttribute("searchAC");
//System.out.println("in SearchResultsPage1  sSearchAC4: " + sSearchAC4);
    sSelAC4 = (String)session.getAttribute("searchAC");
    vACAttr4 = (Vector)session.getAttribute("serAttributeList");
  }
  String sBackFromGetAssociated2 =  (String)session.getAttribute("backFromGetAssociated");
  if (sBackFromGetAssociated2 == null) sBackFromGetAssociated2 = "";
  String sSecondBackFromGetAssociated2 =  (String)session.getAttribute("SecondBackFromGetAssociated");
  if (sSecondBackFromGetAssociated2 == null) 
    sSecondBackFromGetAssociated2 = "";
  if (sBackFromGetAssociated2.equals("backFromGetAssociated"))
  {
      Stack sSearchACStack = (Stack)session.getAttribute("sSearchACStack");
      if(sSearchACStack != null && sSearchACStack.size()>0) // && sSecondBackFromGetAssociated2.equals(""))
      {
        sSearchAC4 = (String)sSearchACStack.pop();
        sSelAC4 = sSearchAC4;
      } 
      if(sSearchACStack != null && sSearchACStack.size()>0)
      {
        sSearchAC4 = (String)sSearchACStack.pop();
        sSelAC4 = sSearchAC4;
        // do not lose the very first search result
     //   if(sSearchACStack.size()==0) 
     //   {
//System.out.println("in SearchResultsPage2  sSearchAC4: " + sSearchAC4 + " sSearchACStack.size before push: " + sSearchACStack.size());
          sSearchACStack.push(sSelAC4);
          session.setAttribute("sSearchACStack", sSearchACStack);
          session.setAttribute("searchAC", sSelAC4);
      //  }
      }
      session.setAttribute("searchAC", sSearchAC4);
      Stack vCompAttrStack = (Stack)session.getAttribute("vCompAttrStack");
      if (vCompAttrStack != null && vCompAttrStack.size()>0) // && sSecondBackFromGetAssociated2.equals(""))
      {
        vSelAttr4 = (Vector)vCompAttrStack.pop();
      } 
      if (vCompAttrStack != null && vCompAttrStack.size()>0)
      {
        vSelAttr4 = (Vector)vCompAttrStack.pop();
        // do not lose the very first search result
    //    if(vCompAttrStack.size()==0) 
     //   {
          vCompAttrStack.push(vSelAttr4);
     //   }
        session.setAttribute("vCompAttrStack", vCompAttrStack);
        session.setAttribute("selectedAttr", vSelAttr4);
      }
     Stack vAttributeListStack = (Stack)session.getAttribute("vAttributeListStack");
      if (vAttributeListStack != null && vAttributeListStack.size()>0) // && sSecondBackFromGetAssociated2.equals(""))
      {
        vACAttr4 = (Vector)vAttributeListStack.pop();
      } 
      if (vAttributeListStack != null && vAttributeListStack.size()>0)
      {
        vACAttr4 = (Vector)vAttributeListStack.pop();
        // do not lose the very first search result
      //  if(vAttributeListStack.size()==0) 
     //   {
          vAttributeListStack.push(vACAttr4);
     //   }
        session.setAttribute("vAttributeListStack", vAttributeListStack);
        session.setAttribute("serAttributeList", vACAttr4);
//System.out.println("SRP vAttributeListStack.size: " + vAttributeListStack.size());
      }
    }
%>
	</head>

	<body>
		<table border="2" style="width: 100%">
			<col style="width: 2.3in" />
			<col />
			<tr valign="top">
				<td colspan=2 valign="top" height="95">
					<%@ include file="TitleBar.jsp"%>
				</td>
			</tr>
			<tr valign="top">
				<td class="sidebarBGColor">
					<%@ include file="SearchParameters.jsp"%>
				</td>
				<td>
					<%@ include file="SearchResults.jsp"%>
				</td>
			</tr>
		</table>
	</body>
</html>
