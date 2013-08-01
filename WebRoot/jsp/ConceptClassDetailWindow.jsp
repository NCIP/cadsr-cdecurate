<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/ConceptClassDetailWindow.jsp,v 1.3 2009-04-16 17:14:27 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to secondary window error page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<html>
	<head>
		<title>
			Concept Class
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/FullDesignVer.css" rel="stylesheet" type="text/css">
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<%@ page import="java.util.*"%>
		<%
      Vector vConClass = (Vector)request.getAttribute("ConceptClassList");
      String intText = "";
      if (vConClass == null || vConClass.size() < 1)
        intText = "Loading .....";
      else
        intText = "No Concepts Found. ";
      if (vConClass == null) vConClass = new Vector();
        
        //get the ac name
      String acName = (String)request.getAttribute("ACName");
      if (acName == null) acName = "";
        
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
        document.conceptClassForm.acID.value = opener.document.SearchActionForm.acID.value;
        document.conceptClassForm.ac2ID.value = opener.document.SearchActionForm.ac2ID.value;
        document.conceptClassForm.acType.value = opener.document.SearchActionForm.itemType.value;
        document.conceptClassForm.acName.value = opener.document.SearchActionForm.searchComp.value;
        document.conceptClassForm.submit();        
      }      
    }
  }
</SCRIPT>

	</head>

	<body bgcolor="#FFFFFF" onLoad="setup();">
		<form name="conceptClassForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=getConClassForAC">
			<br>
			<table width="100%" border="0">
				<tr height="20" valign="top">
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
								List of Concepts for :
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
    for(int i=0; i<(vConClass.size()); i++)
    {
      EVS_Bean EVSBean = new EVS_Bean();
      EVSBean = (EVS_Bean)vConClass.elementAt(i);
      //write the AC name and the table heading for the first item
      if (i==0)
      {
%>
				<tr valign="middle">
					<th>
						No.
					</th>
					<th>
						Concept Name
					</th>
					<th>
						Public ID
					</th>
					<th>
						EVS Identifier
					</th>
					<th>
						Vocabulary
					</th>
					<th>
						Definition
					</th>
					<th>
						Definition Source
					</th>
				</tr>
				<%    } 
      String conName =  EVSBean.getLONG_NAME();
      if (conName == null) conName = "";
      String conID =  EVSBean.getID();
      if (conID == null) conID = "";
      String evsID =  EVSBean.getCONCEPT_IDENTIFIER();
      if (evsID == null) evsID = "";
      String evsVocab = EVSBean.getEVS_DATABASE();
      if (evsVocab == null) evsVocab = "";
      String conDef = EVSBean.getPREFERRED_DEFINITION();
      if (conDef == null) conDef = "";
      String conDefSrc = EVSBean.getEVS_DEF_SOURCE();
      if (conDefSrc == null) conDefSrc = "";
%>
				<tr>
					<td align=center>
						<%=i+1%>
					</td>
					<td align=left>
						<%=conName%>
					</td>
					<td align=left>
						<%=conID%>
					</td>
					<td align=left>
						<%=evsID%>
					</td>
					<td align=left>
						<%=evsVocab%>
					</td>
					<td align=left>
						<%=conDef%>
					</td>
					<td align=left>
						<%=conDefSrc%>
					</td>
				</tr>
				<%
	}
%>
			</table>
			<input type="hidden" name="acID" value="">
			<input type="hidden" name="ac2ID" value="">
			<input type="hidden" name="acType" value="">
			<input type="hidden" name="acName" value="">
		</form>
	</body>
</html>
