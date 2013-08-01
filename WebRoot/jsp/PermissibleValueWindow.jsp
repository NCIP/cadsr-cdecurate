<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/PermissibleValueWindow.jsp,v 1.4 2009-04-16 17:14:27 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to secondary window error page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<html>
	<head>
		<title>
			Permissible Values
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
      
      Vector vPermValue = (Vector)request.getAttribute("PermValueList");
      String intText = "";
      if (vPermValue == null)
        intText = "Loading .....";
      else
        intText = "No Permissible Values Found.";      
      if (vPermValue == null) vPermValue = new Vector();
      if (acName.equals("") && vPermValue != null && vPermValue.size() > 0)
          acName = "-";
      
      PV_Bean pvBean = new PV_Bean();      
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
        document.permissibleValueForm.acID.value = opener.document.SearchActionForm.acID.value;
        //is the ac name for this
        document.permissibleValueForm.itemType.value = opener.document.SearchActionForm.itemType.value;
        document.permissibleValueForm.submit();        
      }      
    }
  }
</SCRIPT>
	</head>

	<body bgcolor="#FFFFFF" onLoad="setup();">
		<form name="permissibleValueForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=getPermValue">
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
								List of Permissible Values for :
							</b>
						</font>
						<%=acName%>
					</td>
					<%    } %>
				</tr>
			</table>
			<table width="100%" border="1" style="border-collapse: collapse">
				<col width=3%>
				<col width=20%>
				<col width=20%>
				<col width=25%>
				<col width=15%>
				<col width=15%>
				<!-- <col width=3%><col width=14%><col width=14%><col width=14%><col width=14%><col width=14%><col width=14%><col width=14%> -->
				<%
    for(int i=0; i<(vPermValue.size()); i++)
    {
      pvBean = (PV_Bean)vPermValue.elementAt(i);
      //write the AC name and the table heading for the first item
      if (i==0)
      {
%>
				<tr valign="middle">
					<th>
						No.
					</th>
					<th>
						Value
					</th>
					<th>
						Value Meaning
					</th>
					<th>
						Value Meaning Description
					</th>
					<th>
						Value Meaning Concept
					</th>
					<th>
						Parent Concept
					</th>
					<th>
						Value Origin
					</th>
					<th>
						Value Begin Date
					</th>
					<th>
						Value End Date
					</th>
				</tr>
				<%    } 
      String sValue =  pvBean.getPV_VALUE();
      if (sValue == null) sValue = "";
      VM_Bean vm = pvBean.getPV_VM();
     // String sMeaning = vm.getVM_SHORT_MEANING();
      String sMeaning = vm.getVM_LONG_NAME();  
      if (sMeaning == null) sMeaning = "";
      //String sDescription = vm.getVM_DESCRIPTION();
      String sDescription = vm.getVM_PREFERRED_DEFINITION(); 
      if (sDescription == null) sDescription = "";
      String sConcept = "";
      Vector vmCon = vm.getVM_CONCEPT_LIST(); //cannot type cast the vector in jsp
      for (int j=0; j<vmCon.size(); j++)
      {
      	EVS_Bean con = (EVS_Bean)vmCon.elementAt(j);
      	if (con == null) con = new EVS_Bean();
      	String conID = con.getCONCEPT_IDENTIFIER();
      	String conDB = con.getEVS_DATABASE();
      	if (!conID.equals(""))
      	{
      		if (!sConcept.equals("")) sConcept += "; ";
      		sConcept += conID + "  " + conDB;
      	}
      }
      String sParent = "";
      EVS_Bean parConcept = (EVS_Bean)pvBean.getPARENT_CONCEPT();
      if (parConcept == null) parConcept = new EVS_Bean();
      String evsDB = (String) parConcept.getEVS_DATABASE();
      String evsID = (String) parConcept.getCONCEPT_IDENTIFIER();
      if (evsID != null && !evsID.equals("")) 
      	sParent = evsID + "\n" + evsDB;
      String sOrigin =  pvBean.getPV_VALUE_ORIGIN();
      if (sOrigin == null) sOrigin = "";
      String sBD = pvBean.getPV_BEGIN_DATE();
      String sED = pvBean.getPV_END_DATE();
%>
				<tr>
					<td align=center>
						<%=i+1%>
					</td>
					<td align=left>
						<%=sValue%>
					</td>
					<td align=left>
						<%=sMeaning%>
					</td>
					<td align=left>
						<%=sDescription%>
					</td>
					<td align=left>
						<%=sConcept%>
					</td>
					<td align=left>
						<%=sParent%>
					</td>
					<td align=left>
						<%=sOrigin%>
					</td>
					<td align=left>
						<%=sBD%>
					</td>
					<td align=left>
						<%=sED%>
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
