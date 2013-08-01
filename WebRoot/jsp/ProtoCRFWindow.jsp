<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/ProtoCRFWindow.jsp,v 1.3 2009-04-21 03:47:34 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to secondary window error page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<html>
	<head>
		<title>
			Protocols and CRFs
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/FullDesignVer.css" rel="stylesheet" type="text/css">
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<%@ page import="java.util.*"%>
		<%
      //get the ac name
      String acName = (String)request.getAttribute("ACName");
      if (acName == null) acName = "";
      
      Vector vProtoCRF = (Vector)request.getAttribute("ProtoCRFList");
      String intText = "";
      if (vProtoCRF == null)
        intText = "Loading .....";
      else
        intText = "No Protocol and CRF Name is Found.";      
      if (vProtoCRF == null) vProtoCRF = new Vector();
      if (acName.equals("") && vProtoCRF != null && vProtoCRF.size() > 0)
          acName = "-";
      
      Quest_Bean questBean = new Quest_Bean();      
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
        document.protoCRFform.acID.value = opener.document.SearchActionForm.acID.value;
        //is the ac name for this
        document.protoCRFform.itemType.value = opener.document.SearchActionForm.itemType.value;
        document.protoCRFform.submit();        
      }      
    }
  }
</SCRIPT>
	</head>

	<body bgcolor="#FFFFFF" onLoad="setup();">
		<form name="protoCRFform" method="post" action="../../cdecurate/NCICurationServlet?reqType=getProtoCRF">
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
								List of Protocols and CRFs used by :
							</b>
						</font>
						<%=acName%>
					</td>
					<%    } %>
				</tr>
			</table>
			<table width="100%" border="1" style="border-collapse: collapse">
				<col width=5%>
				<col width=30%>
				<col width=30%>
				<col width=35%>
				<!--<col width=15%><col width=15%>-->
				<%
    for(int i=0; i<(vProtoCRF.size()); i++)
    {
      questBean = (Quest_Bean)vProtoCRF.elementAt(i);
      //write the AC name and the table heading for the first item
      if (i==0)
      {
%>
				<tr valign="middle">
					<th>
						No.
					</th>
					<th>
						Protocol ID
					</th>
					<th>
						Protocol Name
					</th>
					<th>
						CRF Name
					</th>
					<!--<th>CRF Context</th>
          <th>CRF Workflow Status</th> -->
				</tr>
				<%    } 
      String sProtoID =  questBean.getPROTOCOL_ID();
      if (sProtoID == null) sProtoID = "";
      String sProtoName =  questBean.getPROTOCOL_NAME();
      if (sProtoName == null) sProtoName = "";
      String sCRFName =  questBean.getCRF_NAME();
      if (sCRFName == null) sCRFName = "";
      String sCRFContext =  questBean.getCONTEXT_NAME();
      if (sCRFContext == null) sCRFContext = "";
      String sCRFASL =  questBean.getASL_NAME();
      if (sCRFASL == null) sCRFASL = "";
%>
				<tr>
					<td align=center>
						<%=i+1%>
					</td>
					<td align=left>
						<%=sProtoID%>
					</td>
					<td align=left>
						<%=sProtoName%>
					</td>
					<td align=left>
						<%=sCRFName%>
					</td>
					<!--   <td align=left><%=sCRFContext%></td>
          <td align=left><%=sCRFASL%></td>  -->
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
