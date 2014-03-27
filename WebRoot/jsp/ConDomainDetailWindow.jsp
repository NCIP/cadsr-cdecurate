<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/ConDomainDetailWindow.jsp,v 1.4 2009-04-16 17:14:26 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to secondary window error page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<%@ page import="java.util.*"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
<%@ page import="gov.nih.nci.cadsr.common.StringUtil"%>
<html>
	<head>
		<title>
			Display Conceptual Domain Details
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<%
   Vector cdResult = (Vector)request.getAttribute("ConDomainList");
	String intText = "";
   String sVM = (String)request.getAttribute("VMName");
   if (sVM == null) sVM = "";
   if (cdResult == null)
	  intText = "Loading Conceptual Domains .....";
   
   if (intText.equals(""))
	  intText = "List of Conceptual Domains for Value Meaning - " + StringUtil.cleanJavascriptAndHtml(sVM) + ".";
   if (cdResult == null) cdResult = new Vector();
   
   String nRecs = "No ";
   int nCDs = cdResult.size();
   if (nCDs > 0) nRecs = nRecs.valueOf(nCDs);
  
%>

		<SCRIPT LANGUAGE="JavaScript" type="text/JavaScript">
  function setup()
  {
    if ((opener.document != null) && (opener.document.SearchActionForm != null))
    {
      if (opener.document.SearchActionForm.isValidSearch != null && opener.document.SearchActionForm.isValidSearch.value == "false")
      {
        //get ac id and doctype from the opener document and submit the form when opens first.
        opener.document.SearchActionForm.isValidSearch.value = "true";
        document.cdDetailsForm.acName.value = opener.document.SearchActionForm.searchComp.value;
        document.cdDetailsForm.submit();        
      }      
    }
  }

</SCRIPT>
	</head>
	<body onLoad="setup();">
		<form name="cdDetailsForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=showCDDetail">
			<br>
			<table width="100%">
				<tr>
					<td width="80%" align="center"></td>
					<td>
						<input type="button" name="closeBtn" value="Close Window" onClick="window.close();">
						&nbsp;
					</td>
				</tr>
				<tr></tr>
				<tr>
					<td>
						<font size="4">
							<b>
								<%=intText%>
							</b>
						</font>
					</td>
				</tr>
				<tr></tr>
				<tr>
					<td>
						<div align="left">
							<%=nRecs%>
							Records Found
						</div>
					</td>
				</tr>
			</table>
			<div class="table" style="border-style: double;">
				<table width="95%" border="0">
					<colgroup>
						<col width="10%">
						<col width="40%">
						<col width="10%">
						<col width="20%">
						<col width="10%">
						<col width="10%">
					</colgroup>
					<tbody>
						<tr style="padding-bottom: 0.05in">
						<tr valign="middle">
							<th>
								No.
							</th>
							<th>
								Long Name
							</th>
							<th>
								Public ID
							</th>
							<th>
								Version
							</th>
							<th>
								Workflow Status
							</th>
							<th>
								Context
							</th>
						</tr>
						<%
    if (cdResult != null) 
    {
		  for (int i = 0; i < cdResult.size(); i++)
		  {
        CD_Bean cd = (CD_Bean)cdResult.elementAt(i);
        String sLN = cd.getCD_LONG_NAME();
        if (sLN == null) sLN = "";
        String sPId = cd.getCD_CD_ID();
        if (sPId == null) sPId = "";
        String sVer = cd.getCD_VERSION();
        if (sVer == null) sVer = "";
        String sWF = cd.getCD_ASL_NAME();
        if (sWF == null) sWF = "";
        String sCont = cd.getCD_CONTEXT_NAME();
        if (sCont == null) sCont = "";
        String sDef = cd.getCD_PREFERRED_DEFINITION();
        if (sDef == null) sDef = "";
        String sPN = cd.getCD_PREFERRED_NAME();
        if (sPN == null) sPN = "";
%>
						<tr <% if (i%2 == 0) { %> class="rowColor" <% } %>>
							<td>
								<%=i+1%>
							</td>
							<td>
								<%=sLN%>
							</td>
							<td>
								<%=sPId%>
							</td>
							<td>
								<%=sVer%>
							</td>
							<td>
								<%=sWF%>
							</td>
							<td>
								<%=sCont%>
							</td>
						</tr>
						<tr <% if (i%2 == 0) { %> class="rowColor" <% } %>>
							<td></td>
							<td colspan="6">
								<div class="ind3">
									<b> Definition: </b>
									<br>
									<%=sDef%>
								</div>
							</td>
						</tr>
						<% } %>
					</tbody>
				</table>
			</div>
			<%
      }
 %>
<input type="hidden" name="acID" value="">
<input type="hidden" name="acName" value="">
</form>
	</body>
</html>
