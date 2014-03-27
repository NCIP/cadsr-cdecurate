<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/EditACContact.jsp,v 1.6 2009-04-21 03:47:35 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to secondary window error page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<%@ page import="gov.nih.nci.cadsr.common.StringUtil"%>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
	<head>
	<BASE href="<%=basePath%>">
		<title>
			Edit Contact Information
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<%@ page import="java.util.*"%>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<%@ page session="true"%>
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<SCRIPT LANGUAGE="JavaScript" SRC="js/EditContact.js"></SCRIPT>
		<%
    UtilService serUtil = new UtilService();
    //load the lists
    int item = 1;
    int iDivHt = 0;  
    Hashtable hOrg = (Hashtable)session.getAttribute("Organizations");
    Hashtable hPer = (Hashtable)session.getAttribute("Persons");
    Hashtable hRole = (Hashtable)session.getAttribute("ContactRoles");
    Hashtable hCommType = (Hashtable)session.getAttribute("CommType");
    Hashtable hAddrType = (Hashtable)session.getAttribute("AddrType");
   // Vector vContact = new Vector();
    String contAction = StringUtil.cleanJavascriptAndHtml((String)request.getAttribute("ContAction"));
    if (contAction == null || contAction.equals(""))
      contAction = "new";
    //get the contact vector for the AC
    String selContact = "";
    AC_CONTACT_Bean accBean = (AC_CONTACT_Bean)session.getAttribute("selACContact");
    if (accBean == null) accBean = new AC_CONTACT_Bean();
    //get contact information
    String ctRank = StringUtil.cleanJavascriptAndHtml( accBean.getRANK_ORDER() );
    if (ctRank == null) ctRank = "";
    String ctPer = accBean.getPERSON_IDSEQ();
    if (ctPer == null) ctPer = "";
    String ctOrg = accBean.getORG_IDSEQ();
    if (ctOrg == null) ctOrg = "";
    String ctRole = accBean.getCONTACT_ROLE();
    if (ctRole == null) ctRole = "";
    //select the type depending on the contact type idseq
    String selType = (String)request.getAttribute("TypeSelected");
    if (selType == null) selType = "";
    if (selType.equals(""))
    {
	    if (!ctPer.equals("")) selType = "Person";
	    else if (!ctOrg.equals("")) selType = "Organize";
    }
   
    //get the communication 
    Vector vDispComm = accBean.getACC_COMM_List();
    if (vDispComm == null) vDispComm = new Vector();
    Vector vDispAddr = accBean.getACC_ADDR_List();
    if (vDispAddr == null) vDispAddr = new Vector();
    //get selected comm bean attributes for edit
    AC_COMM_Bean selComm = (AC_COMM_Bean)request.getAttribute("CommForEdit");
    if (selComm == null) selComm = new AC_COMM_Bean();
    String selComCheck = (String)request.getAttribute("CommCheckForEdit");
    if (selComCheck == null) selComCheck = "";
    //get selcted addr bean attributes for edit
    AC_ADDR_Bean selAddr = (AC_ADDR_Bean)request.getAttribute("AddrForEdit");
    if (selAddr == null) selAddr = new AC_ADDR_Bean();    
    String selAddCheck = (String)request.getAttribute("AddrCheckForEdit");
    if (selAddCheck == null) selAddCheck = "";
    //
%>

<Script Language="JavaScript" type="text/JavaScript">

  function displayStatusMessage()
  {
 <%
    String statusMessage = (String)session.getAttribute(Session_Data.SESSION_STATUS_MESSAGE);
	if (statusMessage != null && !statusMessage.equals(""))
    {%>
	       alert("<%=statusMessage%>");
    <% }
    //reset the status message to no message
    session.setAttribute(Session_Data.SESSION_STATUS_MESSAGE, "");
%>
	selCommAddrForEdit("<%=selComCheck%>", "<%=selAddCheck%>");
    //submit the opener if action is to update changes    
	submitOpener();
    window.status = "Create contact information"
  }

</Script>
	</head>

	<body onload="setup();">
		<form name="ACContactForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=ACcontact">
			<table width="100%" border=0>
				<!--DWLayoutTable-->
				<tr>
					<td align="left" valign="top" colspan=2>
						<input type="button" name="btnUpdate" value="Update Attributes" onClick="javascript:submitForm('updContact');">
						&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="button" name="btnClose" value="Close Window" onClick="window.close();">
						&nbsp;&nbsp;&nbsp;&nbsp;
						<img name="Message" src="images/WaitMessage1.gif" width="250px" height="25" alt="WaitMessage" style="visibility:hidden;">
					</td>
				</tr>
			</table>
			<table width="98%" border=0>
				<col width="4%">
				<col width="95%">
				<tr valign="middle">
					<th colspan=2 height="40">
						<div align="left">
							<label>
								<font size=4>
									Create
									<font color="#FF0000">
										Contact
									</font>
									Attributes
								</font>
							</label>
						</div>
					</th>
				</tr>
				<tr valign="bottom" height="25">
					<td align="left" colspan=2 height="11">
						<font color="#FF0000">
							&nbsp;&nbsp;&nbsp;*&nbsp;&nbsp;&nbsp;
						</font>
						Indicates Required Field
					</td>
				</tr>

				<tr height="25" valign="bottom">
					<td align=right>
						<font color="#FF0000">
							*&nbsp;
						</font>
						<%=item++%>
						)
					</td>
					<td>
						<font color="#FF0000">
							Create
						</font>
						Contact Rank Order (maximum 3 numbers)
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td>
						<input type="text" name="rank" size="24" maxlength=3 value="<%=ctRank%>">
					</td>
				</tr>
				<!-- select the contact type -->
				<tr valign="bottom" height="25">
					<td align=right>
						<font color="#FF0000">
							*&nbsp;
						</font>
						<%=item++%>
						)
					</td>
					<td>
						<input type="radio" name="rType" value="Person" <%if(selType.equals("Person")) {%> checked <%} %> onClick="javascript:submitForm('changeType');">
						<font color="#FF0000">
							Select
						</font>
						Contact Person
					</td>
				</tr>
				<tr valign="bottom" height="25">
					<td>
						&nbsp;
					</td>
					<td>
						<input type="radio" name="rType" value="Organize" <%if(selType.equals("Organize")) {%> checked <%} %> onClick="javascript:submitForm('changeType');">
						<font color="#FF0000">
							Select
						</font>
						Contact Organization
					</td>
				</tr>
				<tr valign="bottom">
					<td>
						&nbsp;
					</td>
					<td>
						<table width="100%" border="0">
							<col width="4%">
							<col width="65%">
							<col width="30%">
							<%if(selType.equals("Person")) {%>
							<!-- start if person selected -->
							<tr height="25" valign="bottom">
								<td>
									&nbsp;
								</td>
								<td colspan=2>
									Select Person Name
								</td>
							</tr>
							<tr>
								<td>
									&nbsp;
								</td>
								<td valign="top">
									<select name="selPer" size="1" style="width:60%" onChange="javascript:contactNameChange('person');">
										<%		  if (!contAction.equals("new")) 
				  { 
		  			String sName = ctPer;
		  			if (hPer != null && hPer.containsKey(ctPer))
		  			  sName = StringUtil.cleanJavascriptAndHtml((String)hPer.get(ctPer));
		%>
										<option value="<%=ctPer%>" selected="selected">
											<%=sName%>
										</option>
										<% 		  } else { %>
										<option value="" selected="selected"></option>
										<%          if (hPer != null) 
		            {            
					  Enumeration enum1 = hPer.keys();
					  while (enum1.hasMoreElements())
					  {
					    String sID = (String)enum1.nextElement();
					    String sName = StringUtil.cleanJavascriptAndHtml((String)hPer.get(sID));
		%>
										<option value="<%=sID%>" <%if(sID.equals(ctPer)){%> selected <%}%>>
											<%=sName%>
										</option>
										<%				  
					  }
					}
				  }
		%>
									</select>
								</td>
								<td>
									&nbsp;
								</td>
							</tr>
							<%} else if (selType.equals("Organize")){%>
							<!-- start if organization selected -->
							<tr height="25" valign="bottom">
								<td>
									&nbsp;
								</td>
								<td colspan=2>
									Select Organization Name
								</td>
							</tr>
							<tr>
								<td>
									&nbsp;
								</td>
								<td>
									<!-- filter this list according to what is selected in contact type -->
									<select name="selOrg" size="1" style="width:60%" onChange="javascript:contactNameChange('organization');">
										<%		  if (!contAction.equals("new")) 
				  { 
		  			String sName = ctOrg;
		  			if (hOrg != null && hOrg.containsKey(ctOrg))
		  			  sName = (String)hOrg.get(ctOrg);
		%>
										<option value="<%=ctOrg%>" selected="selected">
											<%=sName%>
										</option>
										<% 		  } else { %>
										<option value="" selected="selected"></option>
										<%          if (hOrg != null) 
		            {            
						Enumeration enum1 = hOrg.keys();
						while (enum1.hasMoreElements())
						{
						  String sID = (String)enum1.nextElement();
						  String sName = (String)hOrg.get(sID);
		%>
										<option value="<%=sID%>" <%if(sID.equals(ctOrg)) {%> selected <%}%>>
											<%=sName%>
										</option>
										<%				  
						}
					}
				  }
		%>
									</select>
								</td>
								<td>
									&nbsp;
								</td>
							</tr>
							<%} %>
							<!-- end if person or organizaiton -->
						</table>
					</td>
				</tr>
				<!-- select the Contact Role -->
				<tr height="25">
					<td align=right>
						<%=item++%>
						)
					</td>
					<td>
						<font color="#FF0000">
							Select
						</font>
						Contact Role
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td valign="top">
						<select name="selRole" size="1" style="width:30%">
							<option value="" selected="selected"></option>
							<%          if (hRole != null) 
            {            
				Enumeration enum1 = hRole.keys();
				while (enum1.hasMoreElements())
				{
				  String sRole = (String)enum1.nextElement();
%>
							<option value="<%=sRole%>" <%if(sRole.equals(ctRole)) {%> selected <%}%>>
								<%=sRole%>
							</option>
							<%				  
				}
			}
%>
						</select>
					</td>
				</tr>

				<!-- communication attributes -->
				<tr valign="bottom" height="30">
					<td align=right>
						<%=item++%>
						)
					</td>
					<td>
						<font color="#FF0000">
							Create
						</font>
						Contact Communication Attributes
					</td>
				</tr>
				<tr>
					<td align="left">
						&nbsp;
					</td>
					<td>
						<table width="80%" border="0">
							<col width="60%">
							<col width="40%">
							<tr valign="bottom" height="25">
								<td colspan=2>
									Select Communication Type
								</td>
							</tr>
							<tr valign="middle">
								<td colspan=2>
									<select name="selCommType" size="1" style="width:40%">
										<option value="" selected></option>
										<%          	if (hCommType != null) 
	            {            
					Enumeration enum1 = hCommType.keys();
					while (enum1.hasMoreElements())
					{
					  String sID = (String)enum1.nextElement();
					  String selCT = selComm.getCTL_NAME();
					  if (selCT == null) selCT = "";
%>
										<option value="<%=sID%>" <%if(sID.equals(selCT)) {%> selected <%}%>>
											<%=sID%>
										</option>
										<%				  
					}
				}
%>
									</select>
								</td>
							</tr>
							<tr height="25" valign="bottom">
								<td colspan=2>
									Create Call Order (maximum 3 numbers)
								</td>
							</tr>
							<tr>
								<td colspan=2>
									<% String selCO = selComm.getRANK_ORDER();
	      			if (selCO == null) selCO = "";	%>
									<input type="text" name="comOrder" size="24" maxlength=3 value="<%=selCO%>">
								</td>
							</tr>
							<tr height="25" valign="bottom">
								<td colspan=2>
									Create Communication Information (maximum 255 characters)
								</td>
							</tr>
							<tr>
								<td colspan=2>
									<% String selCC = selComm.getCYBER_ADDR();
	      			if (selCC == null) selCC = "";	%>
									<input type="text" name="comCyber" size="70" maxlength=255 value="<%=selCC%>">
								</td>
							</tr>
							<tr height="30" valign="middle">
								<td align="left">
									<input type="button" name="btnAddComm" value="Add Selection" onClick="javascript:editCommune('add');">
								</td>
								<td>
									&nbsp;
								</td>
							</tr>
							<tr>
								<td height="12" valign="top">
							</tr>
							<tr>
								<td align="left">
									Selected Communication Attributes
								</td>
								<td align="left">
									<input type="button" name="btnUpdComm" value="Edit Item" onClick="javascript:editCommune('edit');" disabled>
									&nbsp;&nbsp;&nbsp;
									<input type="button" name="btnRemComm" value="Remove Item" onClick="javascript:editCommune('remove');" disabled>
									&nbsp;&nbsp;&nbsp;
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<table width="98%" border="1">
										<tr>
											<td>
												<table width="99%" border="0">
													<col width="2%">
													<col width="28%">
													<col width="15%">
													<col width="60%">
													<tr valign="middle">
														<th>
															<%if (vDispComm.size() > 0){%>
															<img id="altCheckGif" src="images/CheckBox.gif" border="0">
															<% } %>
														</th>
														<th align="center">
															<b>
																Communication Type
															</b>
														</th>
														<th align="center">
															<b>
																Call Order
															</b>
														</th>
														<th align="center">
															<b>
																Communication Information
															</b>
														</th>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<%
                    iDivHt = 30;
                    if (vDispComm.size() > 4) iDivHt = 150;
                    else if (vDispComm.size() > 0) iDivHt = ((30 * vDispComm.size()) + 10);
        %>
												<div id="Layer1" style="position:relative; z-index:1; overflow:auto; width:100%; height:<%=iDivHt%>;">
													<table width="100%" border="1">
														<col width="2%">
														<col width="28%">
														<col width="15%">
														<col width="60%">
														<%						if (vDispComm.size() > 0) 
						{ 
  						  int ckCount = 0;
			              for (int i=0; i<vDispComm.size(); i++)
			              {
  						  	AC_COMM_Bean commB = (AC_COMM_Bean)vDispComm.elementAt(i);
  						  	String cSubmit = commB.getCOMM_SUBMIT_ACTION();
  						  	if (cSubmit != null && cSubmit.equals("DEL"))
  						  	  continue;
  						  	String cType = commB.getCTL_NAME();
  						  	if (cType == null) cType = "";
  						  	String cOrd = commB.getRANK_ORDER();
  						  	if (cOrd == null) cOrd = "";
  						  	String cAdd = commB.getCYBER_ADDR();
  						  	if (cAdd == null) cAdd = "";
                          	String ckName = "com"+i;  //   ckCount;
                          	ckCount += 1;  //increase the count by one                          
%>
														<tr>
															<td align="right" valign="top">
																<input type="checkbox" name="<%=ckName%>" size="5" onClick="javascript:enableCommButtons(checked);">
															</td>
															<td valign="top">
																<%=cType%>
															</td>
															<td valign="top">
																<%=cOrd%>
															</td>
															<td valign="top">
																<%=cAdd%>
															</td>
														</tr>
														<%          			  }
                      	} else {
%>
														<tr>
															<td align="right" valign="top">
																<input type="checkbox" name="" size="5">
															</td>
															<td valign="top"></td>
															<td valign="top"></td>
															<td valign="top"></td>
														</tr>
														<%					  	}  %>
													</table>
												</div>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<!-- addressess -->
				<tr valign="bottom" height="40">
					<td align=right>
						<%=item++%>
						)
					</td>
					<td>
						<font color="#FF0000">
							Create
						</font>
						Contact Address Attributes
					</td>
				</tr>
				<tr>
					<td align="left">
						&nbsp;
					</td>
					<td>
						<table width="100%" border="0">
							<col width="55%">
							<col width="45%">
							<tr valign="bottom" height="25">
								<td colspan="2">
									Select Address Type
								</td>
							</tr>
							<tr valign="middle">
								<td colspan="2">
									<select name="selAddrType" size="1" style="width:30%">
										<option value="" selected="selected"></option>
										<%          	if (hAddrType != null) 
	            {            
					Enumeration enum1 = hAddrType.keys();
					while (enum1.hasMoreElements())
					{
					  String sID = (String)enum1.nextElement();
					  String selAT = selAddr.getATL_NAME();
					  if (selAT == null) selAT = "";
%>
										<option value="<%=sID%>" <%if(sID.equals(selAT)){%> selected <%}%>>
											<%=sID%>
										</option>
										<%				  
					}
				}
%>
									</select>
								</td>
							</tr>
							<tr valign="bottom" height="25">
								<td colspan="2">
									Create Primary Order (maximum 3 numbers)
								</td>
							</tr>
							<tr valign="middle">
								<td colspan="2">
									<% String selAO = selAddr.getRANK_ORDER();
				if (selAO == null) selAO = ""; %>
									<input name="txtPrimOrder" type="text" value="<%=selAO%>" size="24" maxlength=3>
								</td>
							</tr>
							<tr valign="bottom" height="25">
								<td colspan="2">
									Create Address Line 1 (maximum 80 characters)
								</td>
							</tr>
							<tr valign="middle">
								<td colspan="2">
									<% String selA1 = selAddr.getADDR_LINE1();
				if (selA1 == null) selA1 = ""; %>
									<input name="txtAddr1" type="text" value="<%=selA1%>" style="width:50%" maxlength=80>
								</td>
							</tr>
							<tr valign="bottom" height="25">
								<td colspan="2">
									Create Address Line 2 (maximum 80 characters)
								</td>
							</tr>
							<tr valign="middle">
								<td colspan="2">
									<% String selA2 = selAddr.getADDR_LINE2();
				if (selA2 == null) selA2 = ""; %>
									<input name="txtAddr2" type="text" value="<%=selA2%>" style="width:50%" maxlength=80>
								</td>
							</tr>
							<tr valign="bottom" height="25">
								<td>
									Create City (maximum 30 characters)
								</td>
								<td></td>
							</tr>
							<tr valign="middle">
								<td colspan="2">
									<% String selACT = selAddr.getCITY();
				if (selACT == null) selACT = ""; %>
									<input name="txtCity" type="text" value="<%=selACT%>" style="width:50%" maxlength=30>
									&nbsp;&nbsp;
								</td>
							</tr>
							<tr valign="bottom" height="25">
								<td>
									Create State/Province (maximum 30 characters)
								</td>
								<td></td>
							</tr>
							<tr valign="middle">
								<td colspan="2">
									<% String selAS = selAddr.getSTATE_PROV();
				if (selAS == null) selAS = ""; %>
									<input name="txtState" type="text" value="<%=selAS%>" style="width:50%" maxlength=30>
									&nbsp;&nbsp;
								</td>
							</tr>
							<tr valign="bottom" height="25">
								<td>
									Create Country (maximum 30 characters)
								</td>
								<td></td>
							</tr>
							<tr valign="middle">
								<td colspan="2">
									<% String selACN = selAddr.getCOUNTRY();
				if (selACN == null) selACN = ""; %>
									<input name="txtCntry" type="text" value="<%=selACN%>" style="width:50%" maxlength=30>
									&nbsp;&nbsp;
								</td>
							</tr>
							<tr valign="bottom" height="25">
								<td>
									Create Postal Code (maximum 10 characters)
								</td>
								<td></td>
							</tr>
							<tr valign="middle">
								<td colspan="2">
									<% String selAP = selAddr.getPOSTAL_CODE();
				if (selAP == null) selAP = ""; %>
									<input name="txtPost" type="text" value="<%=selAP%>" style="width:30%" maxlength=10>
									&nbsp;&nbsp;
								</td>
							</tr>
							<tr height="30" valign="middle">
								<td align="left" colspan="3">
									<input type="button" name="btnAddAddr" value="Add Selection" onClick="javascript:editAddress('add');">
								</td>
							</tr>
							<tr>
								<td height="12" valign="top">
							</tr>
							<tr>
								<td>
									Selected Address Attributes
								</td>
								<td align="right">
									<input type="button" name="btnUpdAddr" value="Edit Item" onClick="javascript:editAddress('edit');" disabled>
									&nbsp;&nbsp;&nbsp;
									<input type="button" name="btnRemAddr" value="Remove Item" onClick="javascript:editAddress('remove');" disabled>
									&nbsp;&nbsp;&nbsp;
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<table width="100%" border="1">
										<tr>
											<td>
												<table width="99%" border="0">
													<col width="2%">
													<col width="16%">
													<col width="8%">
													<col width="25%">
													<col width="14%">
													<col width="14%">
													<col width="10%">
													<col width="12%">
													<tr valign="middle">
														<th>
															<%if (vDispAddr.size() > 0){%>
															<img id="refCheckGif" src="images/CheckBox.gif" border="0">
															<% } %>
														</th>
														<th align="center">
															<b>
																Address
																<br>
																Type
															</b>
														</th>
														<th align="center">
															<b>
																Primary
																<br>
																Order
															</b>
														</th>
														<th align="center">
															<b>
																Address
															</b>
														</th>
														<th align="center">
															<b>
																City
															</b>
														</th>
														<th align="center">
															<b>
																State/
																<br>
																Province
															</b>
														</th>
														<th align="center">
															<b>
																Country
															</b>
														</th>
														<th align="center">
															<b>
																Postal
																<br>
																Code
															</b>
														</th>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<%
                    iDivHt = 30;
                    if (vDispAddr.size() > 4) iDivHt = 150;
                    else if (vDispAddr.size() > 0) iDivHt = ((30 * vDispAddr.size()) + 10);
        %>
												<div id="Layer2" style="position:relative; z-index:1; overflow:auto; width:100%; height:<%=iDivHt%>;">
													<table width="100%" border="1">
														<col width="2%">
														<col width="16%">
														<col width="8%">
														<col width="25%">
														<col width="14%">
														<col width="14%">
														<col width="10%">
														<col width="10%">
														<%						if (vDispAddr.size() > 0) 
						{ 
  						  int ckCount = 0;
			              for (int i=0; i<vDispAddr.size(); i++)
			              {
  						  	AC_ADDR_Bean addrB = (AC_ADDR_Bean)vDispAddr.elementAt(i);
  						  	String aSubmit = addrB.getADDR_SUBMIT_ACTION();
  						  	if (aSubmit != null && aSubmit.equals("DEL"))
  						  	  continue;
  						  	String aType = addrB.getATL_NAME();
  						  	if (aType == null) aType = "";
  						  	String aOrd = addrB.getRANK_ORDER();
  						  	if (aOrd == null) aOrd = "";
  						  	String aAdd = addrB.getADDR_LINE1();
  						  	if (aAdd == null) aAdd = "";
  						  	String aAdd2 = addrB.getADDR_LINE2();
  						  	if (aAdd2 != null && !aAdd2.equals(""))
  						  	  aAdd += "<br>" + aAdd2;
  						  	String aCity = addrB.getCITY();
  						  	if (aCity == null) aCity = "";
  						  	String aState = addrB.getSTATE_PROV();
  						  	if (aState == null) aState = "";
  						  	String aCntry = addrB.getCOUNTRY();
  						  	if (aCntry == null) aCntry = "";
  						  	String aZip = addrB.getPOSTAL_CODE();
  						  	if (aZip == null) aZip = "";
                          	String ckName = "addr"+i;  // ckCount;
                          	ckCount += 1;  //increase the count by one                          
%>
														<tr>
															<td align="right" valign="top">
																<input type="checkbox" name="<%=ckName%>" size="5" onClick="javascript:enableAddrButtons(checked);">
															</td>
															<td valign="top">
																<%=aType%>
															</td>
															<td valign="top">
																<%=aOrd%>
															</td>
															<td valign="top">
																<%=aAdd%>
															</td>
															<td valign="top">
																<%=aCity%>
															</td>
															<td valign="top">
																<%=aState%>
															</td>
															<td valign="top">
																<%=aCntry%>
															</td>
															<td valign="top">
																<%=aZip%>
															</td>
														</tr>
														<%          			  }
                      	} else {
%>
														<tr>
															<td valign="top">
																<input type="checkbox" name="" size="5">
															</td>
															<td valign="top"></td>
															<td valign="top"></td>
															<td valign="top"></td>
															<td valign="top"></td>
															<td valign="top"></td>
															<td valign="top"></td>
															<td valign="top"></td>
														</tr>
														<%					  	}  %>
													</table>
												</div>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<input type="hidden" name="pageAction" value="">
			<input type="hidden" name="contAction" value="<%=contAction%>">
			<input type="hidden" name="selContact" value="<%=selContact%>">
			<script language="javascript">
displayStatusMessage();
</script>

		</form>
	</body>
</html>
