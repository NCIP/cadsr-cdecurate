<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/DECDetailWindow.jsp,v 1.8 2007-01-26 19:30:38 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to secondary window error page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate" %>
<curate:checkLogon name="Userbean" page="/jsp/ErrorPageWindow.jsp" />
<%@ page import= "java.util.*" %>
<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*" %>
<html>
<head>
<title>Display Data Element Concept Details</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<%
   Vector decResult = (Vector)request.getAttribute("lstDECResult");
   if (decResult == null) decResult = new Vector();
   String resLabel = (String)request.getAttribute("resultLabel");
   if (resLabel == null) resLabel = "";
   String nRecs = "No ";
   int nDECs = decResult.size();
   if (nDECs > 0) nRecs = nRecs.valueOf(nDECs);
   String pageAct = (String)request.getAttribute("pageAct");
   if (pageAct == null || pageAct.equals("")) pageAct = "firstOpen";
 //  System.out.println(nDECs + pageAct + nRecs.valueOf(nDECs));
  
%>

<SCRIPT LANGUAGE="JavaScript" type="text/JavaScript">
  function setup()
  {
    <% if (pageAct.equals("firstOpen")) { %>    
        if (opener != null && opener.document.searchResultsForm != null && opener.document.searchResultsForm.selRowID != null)
        {
          var acID = opener.document.searchResultsForm.selRowID.value;
          var acName = opener.document.searchParmsForm.listSearchFor.value;
          if (acID != null && acID != "")
          {
            document.DECDetailsForm.acID.value = acID;
            document.DECDetailsForm.acID.selected = true;
            if (acName != null && acName != "") document.DECDetailsForm.acName.value = acName;
            document.DECDetailsForm.acName.selected = true;
     // alert(document.DECDetailsForm.acID.value + " exists " + document.DECDetailsForm.acName.value);
            document.DECDetailsForm.submit(); 
          }
        }
    <% } %>
   // alert("where am I " + "<%=pageAct%>");
  }

</SCRIPT>
</head>
<body onLoad="setup();">
<form name="DECDetailsForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=showDECDetail">
<br>
  <table width="100%">
    <tr>
      <td width="80%" align="center"></td>
      <td>
        <input type="button" name="closeBtn" value="Close Window" onClick="window.close();" style="width: 97;height: 30">
          &nbsp;
      </td>
    </tr>
    <tr></tr>
    <tr>
        <td><font size="4"><b><%=resLabel%></b></font></td>
    </tr>
    <tr></tr>
    <tr>
        <td><div align="left"><%=nRecs%> Records Found</div></td>
    </tr>
 </table>
 <table width="100%" border="1" style="border-collapse: collapse" valign="top">
    <tr valign="middle">
      <th>No.</th>
      <th>Long Name</th>
      <th>Public ID</th>
      <th>Version</th>
      <th>Workflow Status</th>
      <th>Context</th>
      <th>Definition</th>
    </tr>
<%
    if (decResult != null) 
    {
		  for (int i = 0; i < decResult.size(); i++)
		  {
        DEC_Bean dec = (DEC_Bean)decResult.elementAt(i);
        String sLN = dec.getDEC_LONG_NAME();
        if (sLN == null) sLN = "";
        String sPId = dec.getDEC_DEC_ID();
        if (sPId == null) sPId = "";
        String sVer = dec.getDEC_VERSION();
        if (sVer == null) sVer = "";
        String sWF = dec.getDEC_ASL_NAME();
        if (sWF == null) sWF = "";
        String sCont = dec.getDEC_CONTEXT_NAME();
        if (sCont == null) sCont = "";
        String sDef = dec.getDEC_PREFERRED_DEFINITION();
        if (sDef == null) sDef = "";
        String sPN = dec.getDEC_PREFERRED_NAME();
        if (sPN == null) sPN = "";
%>
        <tr>
          <td><%=i+1%></td>
          <td><%=sLN%></td>
          <td><%=sPId%></td>
          <td><%=sVer%></td>
          <td><%=sWF%></td>
          <td><%=sCont%></td>
          <td><%=sDef%></td>
       </tr>
<%
      }
    }
%>
 </table>
<input type="hidden" name="acID" value="">
<input type="hidden" name="acName" value="">
</form>
</body>
</html>
