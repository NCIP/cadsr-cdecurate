<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/AlternateNameWindow.jsp,v 1.3 2009-04-16 17:14:27 hegdes Exp $
    $Name: not supported by cvs2svn $
-->
<html>
	<head>
		<title>
			Alternate Names
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/FullDesignVer.css" rel="stylesheet" type="text/css">
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<%@ page import="java.util.*"%>
		<%
      Vector vAltName = (Vector)request.getAttribute("AltNameList");
      String intText = "";
      if (vAltName == null)
        intText = "Loading .....";
      else
        intText = "No Alternate Names Found. ";
      if (vAltName == null) vAltName = new Vector();
      //get the type
      String desType = (String)request.getAttribute("itemType");
      if (desType == null || desType.equals("")) 
          desType = "All Types";
      else
        desType = desType + " Type ";
        
        //get the ac name
      String acName = "";
      if (vAltName != null && vAltName.size() > 0)
      {
        ALT_NAME_Bean AltBean = (ALT_NAME_Bean)vAltName.elementAt(0);
        acName = AltBean.getAC_LONG_NAME();
        if (acName == null) acName = "-";
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
        document.alternateNameForm.acID.value = opener.document.SearchActionForm.acID.value;
     //   document.alternateNameForm.CD_ID.value = opener.document.SearchActionForm.CD_ID.value;
        document.alternateNameForm.itemType.value = opener.document.SearchActionForm.itemType.value;
        document.alternateNameForm.submit();        
      }      
    }
  }
</SCRIPT>

	</head>

	<body bgcolor="#FFFFFF" onLoad="setup();">
		<form name="alternateNameForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=getAltNames">
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
								List of Alternate Names of
								<%=desType%>
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
    for(int i=0; i<(vAltName.size()); i++)
    {
      ALT_NAME_Bean AltBean = new ALT_NAME_Bean();
      AltBean = (ALT_NAME_Bean)vAltName.elementAt(i);
      //write the AC name and the table heading for the first item
      if (i==0)
      {
%>
				<tr valign="middle">
					<th>
						No.
					</th>
					<th>
						Alternate Name
					</th>
					<th>
						Alternate Name Type
					</th>
					<th>
						Context
					</th>
					<th>
						Language
					</th>
				</tr>
				<%    } 
      String altName =  AltBean.getALTERNATE_NAME();
      if (altName == null) altName = "";
      String altType =  AltBean.getALT_TYPE_NAME();
      if (altType == null) altType = "";
      String context =  AltBean.getCONTEXT_NAME();
      if (context == null) context = "";
      String sLan = AltBean.getAC_LANGUAGE();
      if (sLan == null) sLan = "";
%>
				<tr>
					<td align=center>
						<%=i+1%>
					</td>
					<td align=left>
						<%=altName%>
					</td>
					<td align=left>
						<%=altType%>
					</td>
					<td align=left>
						<%=context%>
					</td>
					<td align=left>
						<%=sLan%>
					</td>
				</tr>
				<%
	  }
%>
			</table>
			<input type="hidden" name="acID" value="">
			<input type="hidden" name="itemType" value="">
			<input type="hidden" name="CD_ID" value="">
		</form>
	</body>
</html>
