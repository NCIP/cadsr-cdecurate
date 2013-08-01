<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/ReferenceDocumentWindow.jsp,v 1.3 2009-04-16 17:14:27 hegdes Exp $
    $Name: not supported by cvs2svn $
-->
<html>
	<head>
		<title>
			Reference Documents
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/FullDesignVer.css" rel="stylesheet" type="text/css">
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<%@ page import="java.util.*"%>
		<%
      Vector vRefDoc = (Vector)request.getAttribute("RefDocList");
      String intText = "";
      if (vRefDoc == null)
        intText = "Loading .....";
      else
        intText = "No Reference Documents Found. ";
      if (vRefDoc == null) vRefDoc = new Vector();
      //get the type
      String refType = (String)request.getAttribute("itemType");
      if (refType == null || refType.equals("")) 
        refType = "All Types";
      else
        refType = refType + " Type ";
      //get the name
      String acName = "";
      REF_DOC_Bean refBean = new REF_DOC_Bean();      
      if (vRefDoc != null && vRefDoc.size() > 0)
      {
        refBean = (REF_DOC_Bean)vRefDoc.elementAt(0);
        acName = refBean.getAC_LONG_NAME();
        if (acName == null) acName = "";
      } 
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
        document.referenceDocForm.acID.value = opener.document.SearchActionForm.acID.value;
        document.referenceDocForm.itemType.value = opener.document.SearchActionForm.itemType.value;
        document.referenceDocForm.submit();        
      }      
    }
  }
</SCRIPT>
	</head>

	<body bgcolor="#FFFFFF" onLoad="setup();">
		<form name="referenceDocForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=getRefDocument">
			<br>
			<table width="100%" border="0">
				<tr height="20" valign="top">
					<!-- makes Create New  button to create new    -->
					<td align="right">
						<input type="button" name="closeBtn" value="Close Window" onClick="javascript:window.close();">
						&nbsp;&nbsp;
					</td>
					<td>
						&nbsp;
					</td>
				</tr>
			</table>
			<br>
			<table width="100%" border="0">
				<tr>
					<%    if (acName.equals(""))  { %>
					<td>
						<font size="4">
							<b>
								<%=intText%>
							</b>
						</font>
					</td>
					<%    } else {    %>
					<td>
						<font size="4">
							<b>
								List of Reference Document Text of
								<%=refType%>
								for :
							</b>
						</font>
						<%=acName%>
					</td>
					<%    } %>
				</tr>
			</table>
			<table width="100%" border="1" style="border-collapse: collapse">
				<col width=5%>
				<col width=25%>
				<col width=15%>
				<col width=15%>
				<col width=15%>
				<%
    for(int i=0; i<(vRefDoc.size()); i++)
    {
      refBean = (REF_DOC_Bean)vRefDoc.elementAt(i);
      //write the AC name and the table heading for the first item
      if (i==0)
      {
%>
				<tr valign="middle">
					<th>
						No.
					</th>
					<th>
						Document Name
					</th>
					<th>
						Document Type
					</th>
					<th>
						Document Text
					</th>
					<th>
						Document URL
					</th>
					<th>
						Context
					</th>
					<th>
						Language
					</th>
				</tr>
				<%    } 
      String docName =  refBean.getDOCUMENT_NAME();
      if (docName == null) docName = "";
      String docType =  refBean.getDOC_TYPE_NAME();
      if (docType == null) docType = "";
      String docText =  refBean.getDOCUMENT_TEXT();
      if (docText == null) docText = "";
      String docURL =  refBean.getDOCUMENT_URL();
      if (docURL == null) docURL = "";
      String sContext =  refBean.getCONTEXT_NAME();
      if (sContext == null) sContext = "";
      String sLang =  refBean.getAC_LANGUAGE();
      if (sLang == null) sLang = "";
%>
				<tr>
					<td align=center>
						<%=i+1%>
					</td>
					<td align=left>
						<%=docName%>
					</td>
					<td align=left>
						<%=docType%>
					</td>
					<td align=left>
						<%=docText%>
					</td>
					<td align=left>
						<%=docURL%>
					</td>
					<td align=left>
						<%=sContext%>
					</td>
					<td align=left>
						<%=sLang%>
					</td>
				</tr>
				<%
	  }
%>
			</table>
			<input type="hidden" name="acID" value="">
			<input type="hidden" name="itemType" value="">
		</form>
	</body>
</html>
