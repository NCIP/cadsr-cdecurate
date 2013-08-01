<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/DerivedDEWindow.jsp,v 1.4 2009-04-16 17:14:26 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to secondary window error page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>

<html>
	<head>
		<title>
			Derived DE
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/FullDesignVer.css" rel="stylesheet" type="text/css">
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<%@ page import="java.util.*"%>
		<%
      String acName = (String)request.getAttribute("ACName");
//      if (acName == null) acName = "";
      String intText = "";
      if (acName == null)
        intText = "Loading .....";
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
        document.derivedDEForm.acID.value = opener.document.SearchActionForm.acID.value;
        document.derivedDEForm.acName.value = opener.document.SearchActionForm.searchComp.value;
        document.derivedDEForm.itemType.value = opener.document.SearchActionForm.itemType.value;
        document.derivedDEForm.submit();        
      }      
    }
  }
</SCRIPT>
	</head>

	<body onLoad="setup();">
		<form name="derivedDEForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=getDDEDetails">
			<br>
			<table width="100%" border="0">
				<tr height="20" valign="top">
					<!-- Close Window button   -->
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
			<table width="100%" border="0" style="border-collapse: collapse">
				<col width="2%">
				<col width="98%">
				<%  if (acName == null)  { %>
				<tr>
					<td colspan="2">
						<font size="4">
							<b>
								<%=intText%>
							</b>
						</font>
					</td>
				</tr>
				<%  } else {  %>
				<tr>
					<td colspan="2">
						<font size="4">
							<b>
								Derived Data Element Derivation Rules and Components for :
							</b>
						</font>
						<%=acName%>
					</td>
				</tr>
				<%    Vector vDDEs = (Vector)request.getAttribute("AllDerivedDE");
	  String ddeType = "parent";
	  if (vDDEs != null && vDDEs.size() > 0)
	    ddeType = "component";
	  else
	  {
	    //add the session DDE to vector to handle the single or multiple
	    vDDEs = new Vector();
		DDE_Bean pdde = (DDE_Bean)session.getAttribute("DerivedDE");
		vDDEs.addElement(pdde);
	  }
	  if (vDDEs == null) vDDEs = new Vector();
	  for (int k=0; k<vDDEs.size(); k++)
	  {
	    DDE_Bean dde = (DDE_Bean)vDDEs.elementAt(k);
        if (dde == null) dde = new DDE_Bean();
        String pNo = "";
        String sName = dde.getDE_NAME();
        if (sName == null) sName = "";
        if (ddeType.equals("parent"))
          sName = "<b>" + sName + "</b>";
        else
          pNo = String.valueOf(k+1) + ")";  
        String sID = dde.getDE_ID();
        if (sID == null) sID = "";
        String sVer = dde.getDE_VERSION();
        if (sVer == null) sVer = "";
   	    String sType = dde.getCRTL_NAME();  
        if (sType == null) sType = "";
   	    String sRule = dde.getRULE();   
        if (sRule == null) sRule = "";
   	    String sMethod = dde.getMETHOD();    
        if (sMethod == null) sMethod = "";
   	    String sChar = dde.getCONCAT_CHAR();  
        if (sChar == null) sChar = "";
   	    Vector vComps = (Vector)dde.getDE_COMP_List();
    %>
				<tr valign="top">
					<td>
						&nbsp;
						<%=pNo%>
					</td>
					<td>
						<table width="100%" border=1 style="border-collapse: collapse">
							<col width=45%>
							<col width=6%>
							<col width=4%>
							<col width=12%>
							<col width=12%>
							<col width=12%>
							<col width=6%>
							<tr valign="middle">
								<th align="center">
									<b>
										Long Name
									</b>
								</th>
								<th align="center">
									<b>
										Public ID
									</b>
								</th>
								<th align="center">
									<b>
										Version
									</b>
								</th>
								<th align="center">
									<b>
										Derivation
										<br>
										Type
									</b>
								</th>
								<th align="center">
									<b>
										Rule
									</b>
								</th>
								<th align="center">
									<b>
										Method
									</b>
								</th>
								<th align="center">
									<b>
										Concat
										<br>
										Char
									</b>
								</th>
							</tr>
							<tr>
								<td align="left" valign="top">
									<%=sName%>
								</td>
								<td align="center" valign="top">
									<%=sID%>
								</td>
								<td align="center" valign="top">
									<%=sVer%>
								</td>
								<td align="left" valign="top">
									<%=sType%>
								</td>
								<td align="left" valign="top">
									<%=sRule%>
								</td>
								<td align="left" valign="top">
									<%=sMethod%>
								</td>
								<td align="center" valign="top">
									<%=sChar%>
								</td>
							</tr>
							<tr>
								<td colspan="7">
									<br>
									<% 		     if (vComps != null && vComps.size()>0) 
		     {   %>
									<font size="4">
										<b>
											Components
										</b>
									</font>
									<br>
									<%	
	          int iDivHt = 40;
	          if (vComps.size() >2) iDivHt = 160;
	          else if (vComps.size() >0) iDivHt = ((40 * vComps.size()) + 20);
%>
									<div id="Layer1" style="position:relative; z-index:1; overflow:auto; width:100%; height:<%=iDivHt%>;">
										<table width="80%" border=1 style="border-collapse: collapse">
											<col width=4%>
											<col width=45%>
											<col width=20%>
											<col width=10%>
											<col width=15%>
											<tr>
												<th align="center">
													<b>
														No.
													</b>
												</th>
												<th align="center">
													<b>
														Long Name
													</b>
												</th>
												<th align="center">
													<b>
														Public ID
													</b>
												</th>
												<th align="center">
													<b>
														Version
													</b>
												</th>
												<th align="center">
													<b>
														Display Order
													</b>
												</th>
											</tr>
											<% for (int i =0; i<vComps.size(); i++)
	     	     	{
	     	     	  DE_COMP_Bean deComp = (DE_COMP_Bean)vComps.elementAt(i);
	     	     	  if (deComp == null) deComp = new DE_COMP_Bean();
	     	     	  String cNo = String.valueOf(i+1);
	     	     	  String cName = deComp.getCOMP_NAME();
	     	     	  if (cName == null) cName = "";
	     	     	  if (ddeType.equals("component") && cName.equals(acName))
	     	     	    cName = "<b>" + cName + "</b>";
	     	     	  String cID = deComp.getPUBLIC_ID();
	     	     	  if (cID == null) cID = "";
	     	     	  String cVer = deComp.getVERSION();
	     	     	  if (cVer == null) cVer = "";
	     	     	  String cOrd = deComp.getDISPLAY_ORDER();	
	     	     	  if (cOrd == null) cOrd = "";
	     	    %>
											<tr>
												<td align="center">
													<%=cNo%>
												</td>
												<td align="left">
													<%=cName%>
												</td>
												<td align="center">
													<%=cID%>
												</td>
												<td align="center">
													<%=cVer%>
												</td>
												<td align="center">
													<%=cOrd%>
												</td>
											</tr>
											<%  }  //end for vcomp%>
										</table>
									</div>
									<% } else { //end if vcomp%>
									<font size="4">
										<b>
											No Derived Components
										</b>
									</font>
									<br>
									<% } %>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="25">
					<td></td>
				</tr>
				<%   }  //end dde bean vector
   } //end if else data after referesh %>
			</table>

			<input type="hidden" name="acID" value="">
			<input type="hidden" name="acName" value="">
			<input type="hidden" name="itemType" value="">
		</form>
	</body>
</html>
