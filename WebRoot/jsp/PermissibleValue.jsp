<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/PermissibleValue.jsp,v 1.37 2009-04-21 19:08:14 veerlah Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page language="java" import="java.util.*"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.database.Alternates" %>
<%@ page import="gov.nih.nci.cadsr.common.Constants" %>
<html>
	<head>
		<title>
			Permissible Value
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
        <!-- GF7680 load Dojo -->
        <%--<script src="//ajax.googleapis.com/ajax/libs/dojo/1.8.5/dojo/dojo.js" data-dojo-config="async: true"></script>--%>
        <script src="js/dojo/dojo/dojo.js" data-dojo-config="async: true"></script>
        <script>
        <%--require(["dojo"], function(dojo){--%>
        <%--dojo.ready(function(){--%>
        window.console && console.log("CreateDEC.jsp DOJO version used = [" + dojo.version.toString() + "]");
        <%--});--%>
        <%--});--%>
        </script>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/PermissibleValues.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/VDPVS.js"></SCRIPT>
        <SCRIPT LANGUAGE="JavaScript" SRC="js/date.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%  
      String sMenuAction = (String) session.getAttribute(Session_Data.SESSION_MENU_ACTION);
      String sSearchAC = (String) session.getAttribute("creSearchAC");
      String vocab= (String)session.getAttribute("preferredVocab");
      if (vocab == null) vocab = "";
      
      //for view only page
	  String bodyPage = (String) request.getAttribute("IncludeViewPage");
	  boolean isView = false;
	  if (bodyPage != null && !bodyPage.equals(""))
		isView = true;
      	
      VD_Bean m_VD = new VD_Bean();
      String vdId = "";
      if (isView){
		  vdId = (String)request.getAttribute("viewVDId");
		  String viewVD = "viewVD" + vdId;
		  m_VD = (VD_Bean) session.getAttribute(viewVD);
	  }else{
		   m_VD = (VD_Bean) session.getAttribute("m_VD");
      }   
      if (m_VD == null) m_VD = new VD_Bean();
      UtilService util = new UtilService();
      String sVDIDSEQ = m_VD.getVD_VD_IDSEQ();
      if (sVDIDSEQ == null) sVDIDSEQ = "";
      String sConDomID = m_VD.getVD_CD_IDSEQ();
      if (sConDomID == null) sConDomID = ""; //"";
      String sConDom = m_VD.getVD_CD_NAME();
      if (sConDom == null) sConDom = ""; //"";
      String sTypeFlag = m_VD.getVD_TYPE_FLAG();
      if (!isView) {
				if (sTypeFlag == null)
					sTypeFlag = "E";
				session.setAttribute("pageVDType", sTypeFlag);
	  }
      //get parent attributes
      String sLastAction = (String) request.getAttribute("LastAction");
      if (sLastAction == null) sLastAction = "";
      Vector vParentNames = new Vector();
      Vector vParentCodes = new Vector();
      Vector vParentDB = new Vector();
      Vector vParentMetaSource = new Vector();
      Vector vdParent = m_VD.getReferenceConceptList();  // (Vector) session.getAttribute("VDParentConcept");
      if (vdParent == null) vdParent = new Vector();
      int vdCONs = 0;
      //reset the pv bean
      PV_Bean m_PV = new PV_Bean();
      session.setAttribute("m_PV", m_PV);
      String sVDType = (String) session.getAttribute("VDType");
      if (sVDType == null) sVDType = "";
      //use the pv bean to store vd-pv related attributes
      Vector vVDPVList = m_VD.getVD_PV_List();  // (Vector) session.getAttribute("VDPVList");
      if (vVDPVList == null) vVDPVList = new Vector();
      boolean[] editingDisabled = new boolean[vVDPVList.size()];
      Vector vPVIDList = new Vector();
	    Vector vQuest = (Vector)session.getAttribute("vQuestValue");
	    if (vQuest == null) vQuest = new Vector();
      Vector vQVList = (Vector) session.getAttribute("NonMatchVV");
      if (vQVList == null) vQVList = new Vector();
      String sPVRecs = "No ";
      int vdPVs = 0;
      if (vVDPVList.size() > 0){
        //loop through the list to get no of non deleted pvs
        for (int i = 0; i < vVDPVList.size(); i++)
        {
          PV_Bean pvBean = (PV_Bean) vVDPVList.elementAt(i);
          if (pvBean == null) pvBean = new PV_Bean();
          String sSubmit = pvBean.getVP_SUBMIT_ACTION();
          //go to next item if deleted
          if (sSubmit != null && sSubmit.equals("DEL")) continue;
          vdPVs += 1;
        }
        //add pvrecords if exists.
        if (vdPVs > 0)
        {
          Integer iPVRecs = new Integer(vdPVs);
          sPVRecs = iPVRecs.toString();
        }
      }
      //get new pv attributes
      PV_Bean newPV = (PV_Bean)session.getAttribute("NewPV");
      if (newPV == null) newPV = new PV_Bean();
      VM_Bean newVM = (VM_Bean)newPV.getPV_VM();
      if (newVM == null) newVM = new VM_Bean();
      Vector newVMCon = newVM.getVM_CONCEPT_LIST();
      if (newVMCon == null) newVMCon = new Vector();
      String newPVorg = newPV.getPV_VALUE_ORIGIN();
      if (newPVorg.equals("")) newPVorg = "Search";
      String newPVed = newPV.getPV_END_DATE();
      if (newPVed.equals("")) newPVed = "MM/DD/YYYY";      
	    String newVV = newPV.getQUESTION_VALUE();
	    if (newVV == null) newVV = "";
	    String newVVid = newPV.getQUESTION_VALUE_IDSEQ();
	    if (newVVid == null) newVVid = "";
      
      String pgAction = (String)request.getAttribute("refreshPageAction");
      if (pgAction == null) pgAction = "";
      String elmFocus = (String)request.getAttribute("focusElement");
      if (elmFocus == null) elmFocus = "";
      if (!isView) {
				session.setAttribute("PVAction", "");
	  }
      //moved to vdpvs tab
      session.setAttribute(VMForm.SESSION_SELECT_VM, new VM_Bean());  //should clear when refreshed
      Vector vEMsg = (Vector)session.getAttribute("VMEditMsg");
      if (vEMsg == null) vEMsg = new Vector();
      String sErrAC = (String)request.getAttribute("ErrMsgAC");
      boolean conceptMatch=false;
      for (int k=0; k<vEMsg.size(); k++)
	  { 
		VM_Bean vBean = (VM_Bean)vEMsg.elementAt(k);
		if (vBean.getVM_COMMENT_FLAG().equals("Concept matches."))
		{
		  conceptMatch = true;
		  break;
		}
	  }	
      if (sErrAC == null) sErrAC = "";
      String vmMatch = (String)request.getAttribute("vmNameMatch");
      if (vmMatch == null) vmMatch = "false";
      Integer editPV = (Integer)request.getAttribute("editPVInd");
      String sEditPV = "";
      if (editPV != null) sEditPV = editPV.toString();
      if (sEditPV.equals("-1")) sEditPV = "pvNew";
      else if (!sEditPV.equals("")) sEditPV = "pv"+sEditPV;
    //  String editValue = (String)request.getAttribute("editPVValue");
    //  if (editValue == null) editValue = "";
//System.out.println(sEditPV + " jsp " + sErrAC + " action " + pgAction + " focus " + elmFocus);		
		%>
		<Script Language="JavaScript">
        function calendarSetup(eid, evnt, indicator)
        {
            selectDate(eid,indicator);  //'pvNew');
            //trim the innerHtml value and paste it to hideDatePick field
            document.PVForm.hideDatePick.value = document.getElementById(eid).innerHTML.replace(/^\s+|\s+$/g,"");
            calendar('hideDatePick', evnt);
        }
        
        function checkNameLen(cobj, mlen)
        {
            if (cobj.value.length > mlen)
            {
                alert("You have exceeded the maximum length of this field. Please edit and reduce the text to less than " + mlen + " characters.");
                cobj.focus();
            }
        }
        var newwindow;
        function openUsedWindowVM(idseq, type)
		{
        	var newUrl = '../../cdecurate/NCICurationServlet?reqType=showUsedBy';
        	newUrl = newUrl + '&idseq=' +idseq+'&type='+type;

			newwindow=window.open(newUrl,'Used By Forms','height=400,width=600,toolbar=no,scrollbars=yes,menubar=no');
			if (window.focus) {newwindow.focus()}
        	
        	
		}
        function displayStatus()
        { 
         <%
					  String statusMessage = (String)session.getAttribute(Session_Data.SESSION_STATUS_MESSAGE);
    				Vector vStat = (Vector)session.getAttribute("vStatMsg");
    				//if (vStat != null)
					  	//System.out.println("pv status " + statusMessage + " vector " + vStat.size());
				    //check if the status message is too long
				    if (vStat != null && vStat.size() > 20)
				    {%>
				      	displayStatusWindow();
				    <%}
				    else if (!isView && statusMessage != null && !statusMessage.equals(""))
					  {%>
					  	alert("<%=statusMessage%>");
					  <%}
					  session.setAttribute(Session_Data.SESSION_STATUS_MESSAGE, "");
					%>        
        }
		</SCRIPT>
	</head>

	<body  onload="onLoad('<%=elmFocus%>');hideCloseButton(<%=isView%>);">
		<table width="100%" border="2" cellpadding="0" cellspacing="0">
			<% if (!isView) { %>
			<tr>
				<td height="95" valign="top">
					<%@ include file="TitleBar.jsp"%>
				</td>
			</tr>
			<% } %>
			<tr>
				<td width="100%" valign="top">
					<form name="PVForm" method="POST" action="../../cdecurate/NCICurationServlet?reqType=pvEdits">
					    <% String displayErrorMessage = (String)session.getAttribute("displayErrorMessage");
		                  if ((displayErrorMessage != null)&&(displayErrorMessage).equals("Yes")){ %>
		  	                <b><font  size="3">Not Authorized for Edits in this Context.</font></b><br><br>
	                    <%}%>
						<jsp:include page="VDPVSTab.jsp" flush="true" />
						<div style="margin-left: 0in; margin-right: 0in; border-left: 2px solid black; border-bottom: 2px solid black; border-right: 2px solid black; width: 100%; padding: 0.1in 0in 0.1in 0in">
							<table border="0" width="100%">
								<col>
								<col>
								<tr height="25" valign="bottom">
									<td align="right">
										&nbsp;&nbsp;&nbsp;
									</td>
									<td>
										<font color="#000000">
											Selected Conceptual Domain
										</font>
									</td>
								</tr>
								<tr>
									<td>
										&nbsp;
									</td>
									
									<td><%if (!isView){ %>
										<select name="selConceptualDomain" size="1" style="width:430" multiple>
											<option value="<%=sConDomID%>">
												<%=sConDom%>
											</option>
										</select><%}else{%>
										   <input type="text" size="67" value="<%=sConDom%>" readonly>
										<%}%>
									</td>
								</tr>
								<tr height="20">
									<td></td>
								</tr>
						
								<tr>
									<td align=right>
										<%if (sTypeFlag.equals("E")){%>
										<font color="#FF0000">
											* &nbsp;&nbsp;
										</font>
										<%}%>
									</td>
									<td align=left>
									  <% if (!isView) { %>	
										<font color="#FF0000">
											Create
										</font>
										<% if (sTypeFlag.equals("E")) { %>
										Permissible Value
										<% } else { %>
										Referenced Value
										<% } %>
									  <%} else {%>	
										<% if (sTypeFlag.equals("E")) { %>
										Permissible Values
										<% } else { %>
										Referenced Values
										<% } %>
									 <% } %>	
									</td>
								</tr>
							
								<tr>
									<td>
										&nbsp;
									</td>
									<td>
										&nbsp;&nbsp;
										<table width="70%" border="0">
											<col width="50%">
											<col width="15%">
											<col width="15%">
											<col width="15%">
											<tr>
												<td>
													<% if(sTypeFlag.equals("E")){%>
													<% if (!isView) { %>Select<%}%> Parent Concept to Constrain Permissible Values
													<%}else{%>
													<% if (!isView) { %>Select<%}%>  Non-enumerated Value Domain Reference Concept
													<%}%>
												</td>
											  <% if (!isView) { %>		
												<td align="left">
													<input type="button" name="btnSelectValues" value="Select Values" disabled onClick="javascript:selectValues('<%=vocab%>');">
												</td>
												<td align="center">
													<input type="button" name="btnRemoveConcept" value="Remove Parent" disabled onClick="javascript:removeParent();">
												</td>
												<td>
													&nbsp;
												</td>
											  <% } %>	
											</tr>
											<tr valign="top">
												<td colspan=3>
												 	<%if (!isView){%><select name="listParentConcept" size="2" style="width:100%" onclick="javascript:selectParent();">
												<%}else{%><p class="inset">	
												<%}if (vdParent != null) 
			              {
			                for (int i = 0; vdParent.size()>i; i++)
			                {
			                  EVS_Bean eBean = (EVS_Bean)vdParent.elementAt(i);
			                  if (eBean == null) eBean = new EVS_Bean();
			                  String parSubmit = eBean.getCON_AC_SUBMIT_ACTION();
			                  //go to next one if marked as deleted
			                  if (parSubmit != null && parSubmit.equals("DEL"))
			                    continue;
			                  //add the parent info
			                  String pCode = eBean.getCONCEPT_IDENTIFIER();  //code
			                  vParentCodes.addElement(pCode);
			                  String pName = eBean.getLONG_NAME();   //name
			                  vParentNames.addElement(pName);
			                  String pDB = eBean.getEVS_DATABASE();   //db
			                  if (pDB == null) pDB = "";
			                  vParentDB.addElement(pDB);         
			                  String sMetaSource = "";
			                  if(eBean.getEVS_DATABASE() != null && eBean.getEVS_DATABASE().equals("NCI Metathesaurus"))
			                  {
			                    sMetaSource = eBean.getEVS_CONCEPT_SOURCE();   //db
			                    vParentMetaSource.addElement(sMetaSource);
			                  }
			                  else
			                  {
			                    sMetaSource = "";
			                    vParentMetaSource.addElement(sMetaSource);
			                  }
			                  if (sMetaSource.equals("")) sMetaSource = "All Sources";
			                  String sParListString = "";  //pName + "        " + pCode + "        " + pDB + " : Concept Source UMD2003";
			                  if(eBean.getEVS_DATABASE() != null && eBean.getEVS_DATABASE().equals("NCI Metathesaurus"))
			                    sParListString = pName + "        " + pCode + "        " + pDB + " : Concept Source " + sMetaSource;
			                  else
			                    sParListString = pName + "        " + pCode + "        " + pDB;
			                  
			                  if (pDB.equals("Non_EVS")) sParListString = pName + "        " + pDB;
			                  else pDB = "EVS";                  
			                  vdCONs += 1;
			
			                  //keep the last parent selected if page's last action was selecting a parent
			              if (!isView){%>
														<option value="<%=pDB%>" <%if(sLastAction.equals("parSelected") && i == vdParent.size()-1){%> selected <%}%>>
															<%=sParListString%>
														</option><%}else{%><%=sParListString%><br><%}%>
														<%  }
			              } 
			              %>
													
										<%if (!isView){%></select><%}else{%><br></p><%}%>
												</td>
											  <% if (!isView) { %>	
												<td align="center">
													<!-- do not allow to pick parent if pvs exist but no parent   -->
													<% //if (!(vdCONs < 1 && vdPVs > 0)) { %>
													<a href="javascript:createParent('<%=vocab%>');">
														Search Parent
													</a>
													<% //} %>
												</td>
											 <% } %>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										&nbsp;
									</td>
								</tr>
								<% if ((sMenuAction != null) && sMenuAction.equals("Questions") && vQVList.size() > 0) { %>
								<!-- when questions -->
								<tr height="25" valign="bottom">
									<td>
										&nbsp;
									</td>
									<td>
										List of un-matched Valid Values
									</td>
								</tr>
								<tr>
									<td>
										&nbsp;
									</td>
									<td>
										<select name="selValidValue" size="3" style="width:20%" onclick="javascript:disableSelect();">
											<%
			        for (int i = 0; vQVList.size()>i; i++)
			        {
			          String sVV = (String)vQVList.elementAt(i);
			          String sVVjsp = util.parsedStringDoubleQuoteJSP(sVV);
			%>
											<option value="<%=sVVjsp%>">
												<%=sVV%>
											</option>
											<%
			        }
			%>
										</select>
									</td>
								</tr>
								<% } %>
								<!-- end question -->
								<tr>
									<td>
										&nbsp;
									</td>
								</tr>
								<%if (sTypeFlag.equals("E")){ %>
								<% if (!isView) { %>
								<tr>
									<td>
										&nbsp;
									</td>
									<td align="left">
										&nbsp;&nbsp;&nbsp;
										<!-- enable the create link if parents don't exist or non evs parents selected -->
										<div id="divpvcreate_disable" style="display:<% if (vdCONs > 0){%> block <%} else {%> none <%} %>">
											Create a list of Permissible Values from EVS Concepts
											<b>
												[unavailable]
											</b>
											<br />
											<hr />
											Create a Permissible Value
											<b>
												[unavailable]
											</b>
											<br />
										</div>
										<div id="divpvcreate_enable" style="display:<% if (vdCONs > 0){%> none <%} else {%> block <%} %>">
											Create list of Permissible Values from EVS Concepts
											<a href="javascript:createMultipleValues('<%=vocab%>');">
												<b>
													[click here]
												</b>
											</a>
											&nbsp;&nbsp;&nbsp;&nbsp;
											<img name="Message2" src="images/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" style="visibility:hidden;">
											<br />
											<hr />
											Create a Permissible Value
											<a href="javascript:SubmitValidate('openCreateNew');">
												<b>
													[click here]
												</b>
											</a>
											<br />
										</div>
									</td>
								</tr>
                                <% } %>
								<%if (pgAction.equals("openNewPV")) { %>
								<tr>
									<td>
										&nbsp;
									</td>
									<td align="left">
										&nbsp;&nbsp;&nbsp;
										
										<div id="divpvnew" style="border: 1px solid grey; overflow:auto">
											<br>
											&nbsp;&nbsp;&nbsp;
											<b>
												Create New Permissible Value
											</b>
											&nbsp;&nbsp;&nbsp;
											<input type="button" name="btnCreateNew" value="Save" <% if (vEMsg.size() > 0 && sEditPV.equals("pvNew")) { %> disabled <%}%> onclick="javascript:AddNewPV('addNewPV');">
											&nbsp;&nbsp;&nbsp;
											<input type="button" name="btnCancelNew" value="Cancel" onclick="javascript:CancelNewPV();" />
											<br>
											<table width="99%" border="1" cellpadding="15" style="border-collapse: collapse;">
												<%if ((sMenuAction != null) && sMenuAction.equals("Questions") && vQVList.size() > 0){%>
												<col width="10%">
												<% } %>
												<col width="20%">
												<col width="45%">
												<col width="15%">
												<col width="9%">
												<col width="9%">
												<tr height="30" valign="middle">
													<%if ( (sMenuAction != null) && (sMenuAction.equals("Questions") && vQVList.size() > 0) ){%>
													<th align="left">
														Valid Value
													</th>
													<% } %>
													<th align="left">
														&nbsp;&nbsp;&nbsp;Permissible Value
													</th>
													<th align="left">
														Value Meaning
														<div id="pvNewVMLblEdit" style="display: <%if (vEMsg.size() > 0) { %>none<%} else {%>inline<% } %>">
															<span style="padding-left: 0.3in">
																<a href="javascript:searchVM();">
																	Search
																</a>
															</span>
														</div>
													</th>
													<th align="left">
														Value Origin
													</th>
													<th align="left">
														Begin Date
													</th>
													<th align="left">
														End Date
													</th>
												</tr>
												<tr>
													<%if ( (sMenuAction != null) && (sMenuAction.equals("Questions")) ){%>
													<td valign="top">
														&nbsp;&nbsp;
														<select name="selValidValue" size=1 style="width:150" onchange="javascript:getORsetEdited('pvNew', 'pv');">
															<option value="" selected></option>
															<%            for (int j = 0; vQuest.size()>j; j++)
				              {
				                  Quest_Value_Bean qvBean = (Quest_Value_Bean)vQuest.elementAt(j);
				                  String sQValue = qvBean.getQUESTION_VALUE();
				                  String sQVid = qvBean.getQUESTION_VALUE_IDSEQ();
				                  if (vQVList.contains(sQValue)) //not assigned yet
				                  {
				%>
															<option value="<%=sQVid%>">
																<%=sQValue%>
															</option>
															<%
				                  }
				                  else if (sQVid.equals(newVVid)) { 
				 %>
															<option value="<%=newVVid%>" selected>
																<%=newVV%>
															</option>
															<%								}
				              }
				%>
														</select>
													</td>
													<% } %>
													<%  
											String newPVjsp = util.parsedStringDoubleQuoteJSP(newPV.getPV_VALUE());
											//String newVMjsp = util.parsedStringDoubleQuoteJSP(newVM.getVM_SHORT_MEANING());
											String newVMjsp = util.parsedStringDoubleQuoteJSP(newVM.getVM_LONG_NAME());
									%>
													<td valign="top">
														&nbsp;&nbsp;
														<input type="text" name="pvNewValue" style="width:90%" size="20" maxlength="255" value="<%=newPVjsp%>" onkeyup="javascript:getORsetEdited('pvNew', 'pv');">
													</td>
													<td valign="top">
														<table width="98%" border="0">
															<col width="1px">
															<col>
															<col width="4px">
															<tr>
																<td colspan="3">
																	<b>
																		VM Long Name
																	</b>
																</td>
															</tr>
															<tr>
																<td>
																	&nbsp;&nbsp;
																</td>
																<td>
																	<div id="pvNewVMView" style="display: <%if (newVMCon.size() > 0) { %>block<%} else {%>none<% } %>">
																		<%=newVM.getVM_LONG_NAME()%>
																	</div>
																	<div id="pvNewVMEdit" style="display: <%if (newVMCon.size() > 0) { %>none<%} else {%>block<% } %>">
																		<textarea name="pvNewVM" style="width: 90%" rows="2" onblur="javascript:checkNameLen(this, 255);" onkeyup="javascript:getORsetEdited('pvNew', 'pv');"><%=newVMjsp%></textarea>
																	</div>
																</td>
																<td>
																	&nbsp;
																</td>
															</tr>
															<tr>
																<td colspan="3">
																	<br>
																	<b>
																		Description/Definition
																	</b>
																</td>
															</tr>
															<tr>
																<td>
																	&nbsp;&nbsp;
																</td>
																<td align="left" colspan="2">
																	<div id="pvNewVMDView" style="display: <%if (newVMCon.size() > 0) { %>block<%} else {%>none<% } %>">
																		<%=newVM.getVM_PREFERRED_DEFINITION().trim()%>
																	</div>
																	<div id="pvNewVMDEdit" style="display: <%if (newVMCon.size() > 0) { %>none<%} else {%>block<% } %>">
																		<!-- javascript:disableSearch('pvNew'); -->
																		 <textarea name="pvNewVMD" style="width: 98%" rows="4" style="width: 100%" onkeyup="javascript:getORsetEdited('pvNew', 'pv');"><%=newVM.getVM_PREFERRED_DEFINITION().trim()%></textarea>																</div>
																</td>
															</tr>
															<tr>
																<td colspan="3">
																	<br>
																	<b>
																		Concepts
																		<span style="padding-left: 0.3in">
																			<a href="javascript:selectConcept('newCon','pvNew','<%=vocab%>');">
																				Search
																			</a>
																		</span>
																	</b>
																</td>
															</tr>
															<tr>
																<td>
																	&nbsp;&nbsp;
																</td>
																<td valign="top" align="left" colspan="2">
																	<div style="border: 1px solid grey;">
																		<table id="pvNewTBL" width="90%" border="0">
																			<% 
															if (newVMCon.size() > 0)
															{
																for (int k = 0; k<newVMCon.size(); k++)
																{
																	EVS_Bean newcon = (EVS_Bean)newVMCon.elementAt(k);
																	if (newcon == null) break;
																	String newConName = newcon.getLONG_NAME();
																	String newConID = newcon.getCONCEPT_IDENTIFIER();
																	String newConVocab = newcon.getEVS_DATABASE();
																	String newConDesc = newcon.getPREFERRED_DEFINITION();
																	String trCount = "pvNewtr" + k;																					
																	String conType = "";																					
																	if (k == newVMCon.size()-1)
																		conType = "Primary";
																	else
																		conType = "Qualifier";
																//	if (k == newVMCon.size()-1)
																//		trCount = "pvNewprimary";
															%>
																			<tr id="<%=trCount%>">
																				<td valign="top" nowrap="nowrap">
																					<div id="pvNewCon<%=k%>" style="display:none">
																						<a href="javascript:deleteConcept('<%=trCount%>', 'pvNew');" title="Remove Item">
																							<img src="images/delete_small.gif" border="0" alt="Remove">
																						</a>
																						&nbsp;&nbsp;
																					</div>
																				</td>
																				<td valign="top" nowrap="nowrap">
																					<%=newConName%>
																					&nbsp;&nbsp;&nbsp;&nbsp;
																				</td>
																				<td valign="top" nowrap="nowrap">
																					<%=newConID%>
																					&nbsp;&nbsp;&nbsp;&nbsp;
																				</td>
																				<td valign="top" nowrap="nowrap">
																					<%=newConVocab%>
																					&nbsp;&nbsp;&nbsp;&nbsp;
																				</td>
																				<td valign="top" nowrap="nowrap">
																					<%=conType%>
																					&nbsp;&nbsp;&nbsp;&nbsp;
																				</td>
																				<td valign="top" nowrap="nowrap" style="visibility:hidden">
																					<div style="display:none;">
																						<%=newConDesc%>
																					</div>
																				</td>
																			</tr>
																			<% } } else { %>
																			<tr>
																				<td>
																					&nbsp;&nbsp;
																				</td>
																			</tr>
																			<% } %>
																		</table>
																	</div>
																	<br>
																</td>
															</tr>
															<tr>
																<td>
																	&nbsp;&nbsp;
																</td>
															</tr>
														</table>
														<% if (vEMsg.size() > 0 && sEditPV.equals("pvNew")) { %>
														<hr>
														<table width="100%" cellpadding="0.05in,0.05in,0.05in,0.05in" border="1">
															<col /></col>
															<tr>
																<td colspan=2 valign="top">
																	<table cellpadding="0.1in,0.1in,0.1in,0.1in">
																		<tr>
																			<td>
																				<input type="button" id="btnUseSelect" value="Link Concept" disabled onClick="javascript:AddNewPV('addNewPV');">
																			</td>
																			<td>
																				&nbsp;&nbsp;
																				<!-- <input type="checkbox" name="saveAlt"/>  -->
																			</td>
																			<td>
																				<input type="button" id="btnContinue" value="Create" 
																					onClick="javascript:ContinueDuplicateVM('continueVM');" <% if (conceptMatch) { %>disabled <% } %>>
																			</td>
																			<td>
																				&nbsp;&nbsp;
																				<!-- Save the current Name and Description as Alternate Name and Definition <br>  -->
																			</td>
																			<td>
																				<input type="button" id="btnCancelUS" value="Cancel" onClick="javascript:confirmRM('<%=sEditPV%>', 'restore', 'restore');">
																			</td>
																		</tr>
																	</table>
																</td>
															</tr>
															<tr>
																<td colspan=2>
																	<% if (vmMatch.equals("true")) { %>
																		The Value Meaning matches the name of another Value Meaning. Please (1) select from the list below and press the Use Selection button, (2) press the Create button to create a new Value Meaning as it appears above or (3) press Cancel to change the Value Meaning properties above then press Save again
																	<% } else { %>
																		The Value Meaning you are creating matches the definition or concepts of an existing Value Meaning.
																		You may select an existing Value Meaning and click 'Link Concept', 
																		'Cancel' to edit the Value Meaning, or 'Create' to create a new Value Meaning.
																	<% } %>
																	<br>
																</td>
															</tr>
															</table>
															<div style="height:350px;width:100%;overflow:auto">
															<table width="100%" cellpadding="0.05in,0.05in,0.05in,0.05in" border="0">
														
															<% 
															for (int k=0; k<vEMsg.size(); k++)
															{ 
																	VM_Bean vB = (VM_Bean)vEMsg.elementAt(k);
																	Vector vBCon = vB.getVM_CONCEPT_LIST();
																	Alternates[] alternate = vB.getVM_ALT_LIST();
																	String rVM = "erVM"+k;
																	String idVer ="[System Assigned after Value Domain Submission]";
																	if(vB.getVM_ID()!=null && vB.getVM_VERSION()!=null) 
																	 idVer =vB.getVM_ID()+"v"+ vB.getVM_VERSION();
																	
																	 
														 %>
															<tr>
															  	
																<td valign="top">
																	<input name="rUse" type="radio" alt="Select to use" value="<%=rVM%>" onclick="javascript:enableUSE();">
																</td>
																<td>
																	<dl>
																		<dt>
																			VM Long Name:
																		<dd>
																			<%=vB.getVM_LONG_NAME()%>
																		<dt>
																			Public Id & Version:
																		<dd>
																			<%=idVer%>
																		<dt>
																			VM Description:
																		<dd>
																		 <%=vB.getVM_PREFERRED_DEFINITION()%>
																			<dt>
																			VM Concepts:
																			<% if (vBCon != null && vBCon.size() > 0) { 
																	for (int p =0; p<vBCon.size(); p++) {
																	EVS_Bean eB = (EVS_Bean)vBCon.elementAt(p);
														  %>
																		<dd>
																			<%=eB.getLONG_NAME()%>
																			&nbsp;&nbsp;
																			<%=eB.getCONCEPT_IDENTIFIER()%>
																			&nbsp;&nbsp;
																			<%=eB.getEVS_DATABASE()%>
																			<% }  } else { %>
																		<dd>	
																			None.
																			<% } %>
																		<dt>
																			Alt Names:
																			<% if (alternate != null && alternate.length > 0){  
																	              for (int j=0;j<alternate.length;j++){
           															        %>
																		<dd>
																		    <%if(alternate[j].getInstance()==Alternates._INSTANCENAME){ %>
																		    
																		    <%=alternate[j].getName()%> <%}}} else {%>
																		    <dd>	
																			None.
																			<% } %>
																		<dt>
																			Reason:
																		<dd>
																			<%=vB.getVM_COMMENT_FLAG()%>
																	</dl>
																</td>
															</tr>
															<% } %>
														</table></div>
														<%} %>
													</td>
													<td id="newOrg" valign="top">
														<a href="javascript:selectOrigin('newOrg','pvNew');">
															<%=newPVorg%>
														</a>
													</td>
													<td valign="top">
														<span id="newBD"><%=newPV.getPV_BEGIN_DATE()%></span><br><img src="../../cdecurate/images/calendarbutton.gif" onclick="calendarSetup('newBD', event, 'pvNew');">
													</td>
													<td valign="top">
														<span id="newED"><%=newPVed%></span><br><img src="../../cdecurate/images/calendarbutton.gif" onclick="calendarSetup('newED', event, 'pvNew');">
													</td>
												</tr>
											</table>
										</div>
									</td>
								</tr>
								<% } %>
								<tr>
									<td>
										&nbsp;
									</td>
								</tr>
								<tr>
									<td>
										&nbsp;
									</td>
									<td align="left">
										&nbsp;										
										<div style="display:inline">
											<b><%=sPVRecs%></b>  Records &nbsp;&nbsp;&nbsp;&nbsp;
										</div> 
										<% if ((vVDPVList.size() > 0) && (!isView)){ %>
											<div class="ind3" align="right" style="display:inline">
												<input onclick="javascript:confirmRM('All', 'remove', 'all Permissible Values');" type="button" value="Delete All" name="btnDeleteAll">
											</div>
										<% } %>
									</td>
								</tr>
								<tr>
									<td>
										&nbsp;
									</td>
								</tr>
					
								<tr>
									<td>
										&nbsp;
									</td>
									<td>
										<table width="100%" border="1">
											<tr>
												<td>
													<table width="99%" border="0">
														<%if (vdCONs > 0 && (sMenuAction != null) && sMenuAction.equals("Questions")){%>
														<col width="5%">
														<col width="7%">
														<col width="11%">
														<col width="35%">
														<col width="10%">
														<col width="10%">
														<col width="8%">
														<col width="7%">
														<%} else if ( (sMenuAction != null) && (sMenuAction.equals("Questions"))){%>
														<col width="5%">
														<col width="7%">
														<col width="11%">
														<col width="35%">
														<col width="10%">
														<col width="8%">
														<col width="7%">
														<%} else if (vdCONs > 0) {%>
														<col width="5%">
														<col width="11%">
														<col width="35%">
														<col width="10%">
														<col width="10%">
														<col width="8%">
														<col width="7%">
														<%} else {%>
														<col width="5%">
														<col width="11%">
														<col width="35%">
														<col width="10%">
														<col width="8%">
														<col width="7%">
														<%}%>
														<tr valign="top">
															<th>
																Actions
															</th>
															<%if (( (sMenuAction != null) && sMenuAction.equals("Questions"))){%>
															<th align="center">
																<a href="javascript:sortPV('ValidValue');">
																	Valid Value
																</a>
															</th>
															<%} %>
															<th align="center">
																<% if (!isView) { %><a href="javascript:sortPV('value');"><%}else {%><a href="javascript:viewPVSort('value','<%=vdId%>');"><%}%>
																	Permissible Value
																</a>
															</th>
															<th align="center">
																<% if (!isView) { %><a href="javascript:sortPV('meaning');"><%}else {%><a href="javascript:viewPVSort('meaning','<%=vdId%>');"><%}%>
																	Value Meaning
																</a>
															</th>
															<%if (vdCONs > 0){%>
															<th align="center">
																<% if (!isView) { %><a href="javascript:sortPV('ParConcept');"><%}else {%><a href="javascript:viewPVSort('ParConcept','<%=vdId%>');"><%}%>
																	Parent Concept
																</a>
															</th>
															<%}%>
															<th align="center">
																<% if (!isView) { %><a href="javascript:sortPV('Origin');"><%}else {%><a href="javascript:viewPVSort('Origin','<%=vdId%>');"><%}%>
																	Value Origin
																</a>
															</th>
															<th align="center">
																<% if (!isView) { %><a href="javascript:sortPV('BeginDate');"><%}else {%><a href="javascript:viewPVSort('BeginDate','<%=vdId%>');"><%}%>
																	Begin Date
																</a>
															</th>
															<th align="center">
																<% if (!isView) { %><a href="javascript:sortPV('EndDate');"><%}else {%><a href="javascript:viewPVSort('EndDate','<%=vdId%>');"><%}%>
																	End Date
																</a>
															</th>
														</tr>
														<tr valign="top">
															<td align="center">
																<div id="imgCloseAll" style="display: inline">
																	<a <%if (vVDPVList != null && vVDPVList.size() > 1){%> href="javascript:viewAll('expandAll');" <%}%>>
																		<img src="images/folderClosed.gif" border="0" alt="Expand All">
																	</a>
																</div>
																<div id="imgOpenAll" style="display: none">
																	<a <%if (vVDPVList != null && vVDPVList.size() > 1){%> href="javascript:viewAll('collapseAll');" <%}%>>
																		<img src="images/folderOpen.gif" border="0" alt="Collapse All">
																	</a>
																</div>
															</td>
															<%if ( (sMenuAction != null) && (sMenuAction.equals("Questions"))){%>
															<td align="center">
															</td>
															<%} %>
															<td align="center">
															</td>
															<td align="center">
															</td>
															<%if (vdCONs > 0){%>
															<td align="center">
															</td>
															<%} %>
														  <% if (!isView) { %> 
															<td align="center">
																<a <%if (vVDPVList != null && vVDPVList.size() > 1){%> href="javascript:selectOrigin('allOrigin', 'all');" <%}%>>
																	<img src="images/block_edit.gif" border="0" alt="Change All Origin">
																</a>
															</td>
															<td align="center">
															    <img src="images/block_edit.gif" border="0" alt="Change All Begin Date"
                                                                <%if (vVDPVList != null && vVDPVList.size() > 1){%>onclick="selectDate('allBeginDate', 'all');calendar('hideDatePick', event);"<%}%> >
															</td>
															<td align="center">
																<img src="images/block_edit.gif" border="0" alt="Change All End Date"
                                                                <%if (vVDPVList != null && vVDPVList.size() > 1){%>onclick="selectDate('allEndDate', 'all');calendar('hideDatePick', event);"<%}%> >
															</td>
														  <%}%>	
														</tr>
													</table>
												</td>
											</tr>
											<tr>
												<td>
													<div id="Layer1" style="position:relative; overflow:auto; height:480;">
														<table border="1" style="border-collapse: collapse; width: 100%" cellpadding="0.1in, 0.05in, 0.1in, 0.05in">
															<%if (vdCONs > 0 && (sMenuAction != null) &&  sMenuAction.equals("Questions")){%>
															<col width="5%">
															<col width="7%">
															<col width="11%">
															<col width="35%">
															<col width="10%">
															<col width="10%">
															<col width="8%">
															<col width="7%">
															<%} else if ( (sMenuAction != null) && (sMenuAction.equals("Questions"))){%>
															<col width="5%">
															<col width="7%">
															<col width="11%">
															<col width="35%">
															<col width="10%">
															<col width="8%">
															<col width="7%">
															<%} else if (vdCONs > 0) {%>
															<col width="5%">
															<col width="11%">
															<col width="35%">
															<col width="10%">
															<col width="10%">
															<col width="8%">
															<col width="7%">
															<%} else {%>
															<col width="5%">
															<col width="11%">
															<col width="35%">
															<col width="10%">
															<col width="8%">
															<col width="7%">
															<%}%>
															<%
										if (vdPVs > 0 && vVDPVList != null && vVDPVList.size() > 0)
						        {
						          int ckCount = 0;
						         
						          for (int i = 0; i < vVDPVList.size(); i++)
						          {
						            PV_Bean pvBean = (PV_Bean) vVDPVList.elementAt(i);
						            if (pvBean == null) pvBean = new PV_Bean();
						            // display only if not deleted
						        //    if (pvBean.getVP_SUBMIT_ACTION() != null && pvBean.getVP_SUBMIT_ACTION().equals("DEL"))
						        //      continue;
						           // String ckName = ("ck" + ckCount);
						            String pvCount = "pv" + ckCount;
						            ckCount += 1;
						        //    boolean pvChecked = pvBean.getPV_CHECKED();
						            String sVValue = (String) pvBean.getQUESTION_VALUE();
						            if (sVValue == null) sVValue = "";
						            String sVVid = (String) pvBean.getQUESTION_VALUE_IDSEQ();
						            if (sVVid == null) sVVid = "";
						            String sPVVal = (String) pvBean.getPV_VALUE();
						            if (sPVVal == null) sPVVal = "";
						            String sPVValJsp = util.parsedStringDoubleQuoteJSP(sPVVal);
						            String sPVValJ = util.parsedStringSingleQuote(sPVValJsp);
						         //   if (sEditPV.equals(pvCount)) sPVVal = editValue;
						            String sPVid = (String) pvBean.getPV_PV_IDSEQ();
						            if (sPVid == null || sPVid.equals("")) sPVid = "EVS_" + sPVVal;
						            vPVIDList.addElement(sPVid); //add the ones on the page
						            VM_Bean vm = pvBean.getPV_VM();
						         //   if (vEMsg.size() > 0 && sEditPV.equals(pvCount))
						         //   	vm = (VM_Bean)request.getAttribute("ErrVM");
						            //String sPVMean = (String)vm.getVM_SHORT_MEANING();  // pvBean.getPV_SHORT_MEANING();
						            String sPVMean = (String)vm.getVM_LONG_NAME();  // pvBean.getPV_SHORT_MEANING();
						            if (sPVMean == null) sPVMean = "";
						            String sPVMeanJsp = util.parsedStringDoubleQuoteJSP(sPVMean);
						            //String sPVDesc = (String)vm.getVM_DESCRIPTION();  // pvBean.getPV_MEANING_DESCRIPTION();
						              String sPVDesc = (String)vm.getVM_PREFERRED_DEFINITION();  // pvBean.getPV_MEANING_DESCRIPTION();
						            if (sPVDesc == null) sPVDesc = "";
						            Vector vmCon = vm.getVM_CONCEPT_LIST();
						            String submit = vm.getVM_SUBMIT_ACTION();
						            String sParId = "";
						            EVS_Bean parConcept = (EVS_Bean) pvBean.getPARENT_CONCEPT();
						            if (parConcept == null) parConcept = new EVS_Bean();
						            String evsDB = (String) parConcept.getEVS_DATABASE();
						            if (evsDB == null) evsDB = "";
						            String evsID = (String) parConcept.getCONCEPT_IDENTIFIER();
						            if (evsID != null && !evsID.equals("")) sParId = evsID + "\n" + evsDB;
						            String sPVOrigin = (String) pvBean.getPV_VALUE_ORIGIN();
						            if (sPVOrigin == null || sPVOrigin.equals("")) sPVOrigin = "";
						            String sPVBegDate = (String) pvBean.getPV_BEGIN_DATE();
						            if (sPVBegDate == null || sPVBegDate.equals("")) sPVBegDate = "";
						            String sPVEndDate = (String) pvBean.getPV_END_DATE();
						            if (sPVEndDate == null || sPVEndDate.equals("")) sPVEndDate = "";
						            String viewType = (String)pvBean.getPV_VIEW_TYPE();
						            if (viewType.equals("")) viewType = "expand";
						    		boolean inForm = pvBean.getPV_IN_FORM();
						    		String sVDPVSIDseq = pvBean.getPV_VDPVS_IDSEQ();
						    		
						            //get the pvvm combination to use it later
						        //    String sPVVM = sPVVal.toLowerCase() + sPVMean.toLowerCase();
						        //    sPVVM = sPVVM.replace(" ", "");  //remove spaces
						      //   System.out.println(pvCount + " jsp " + vmCon.size() + " value " + sPVVal + " viewType " + viewType);
						            //TODO - figure out this later; cannot use the type cast for vectors in jsp
						           // Vector<EVS_Bean> vmCon = vm.getVM_CONCEPT_LIST();
						            		
						            String dispStyle = "inline"; //GF33140 display by default
						            Boolean vdUsedInForm = (Boolean)session.getAttribute(Constants.VD_USED_IN_FORM);  //GF7680
									String workflowStatus = (String)session.getAttribute("selStatus");
									String crfWorkflowStatus = pvBean.getCRF_WORKFLOW();    //GF7680
						            /*
									if(workflowStatus != null && workflowStatus.equals(Constants.WORKFLOW_STATUS_RELEASED) || inForm) {
										dispStyle = "none";		
									}
									*/
						            %>
															<tr id="<%=pvCount%>">
																<td align="center" valign="top">
																	<div id="<%=pvCount%>ImgClose" style="display: <%if (viewType.equals("collapse")) {%>inline <% } else { %> none <% } %>">
																		<a href="javascript:view('<%=pvCount%>View', '<%=pvCount%>ImgClose', '<%=pvCount%>ImgOpen', 'view', '<%=pvCount%>', '<%=workflowStatus%>','<%=vdUsedInForm%>','<%=inForm%>','<%=crfWorkflowStatus%>');"><img src="images/folderClosed.gif" border="0" alt="Expand"></a>
																	</div>
																	<div id="<%=pvCount%>ImgOpen" style="display: <%if (viewType.equals("expand")) {%>inline <% } else { %> none <% } %>">
																		<a href="javascript:view('<%=pvCount%>View', '<%=pvCount%>ImgOpen', '<%=pvCount%>ImgClose', 'view', '<%=pvCount%>', '<%=workflowStatus%>','<%=vdUsedInForm%>','<%=inForm%>','<%=crfWorkflowStatus%>');"><img src="images/folderOpen.gif" border="0" alt="Collapse"></a>
																	</div>
																 <%if (!isView){ %>	
																	<div id="<%=pvCount%>ImgEdit" style="display: <%=dispStyle%>">
																		<%
																		System.out.println("PermissibleValues.jsp vdWs [" + workflowStatus + "] vdUsedInForm [" + vdUsedInForm + "] pvUsedInForm [" + inForm + "] crfWs [" + crfWorkflowStatus + "]");
																		if (inForm) {%> <a href="javascript:view('<%=pvCount%>View', '<%=pvCount%>ImgEdit', '<%=pvCount%>ImgSave', 'edit', '<%=pvCount%>', '<%=workflowStatus%>','<%=vdUsedInForm%>','<%=inForm%>','<%=crfWorkflowStatus%>');" onclick="return confirm('This element is used in a form. Any edits will put the form out of sync. Are you sure you want to edit?');"><img src="images/edit.gif" border="0" alt="Edit" style="display: <%=dispStyle%>"></a>
																		<% } else { %> <a href="javascript:view('<%=pvCount%>View', '<%=pvCount%>ImgEdit', '<%=pvCount%>ImgSave', 'edit', '<%=pvCount%>', '<%=workflowStatus%>','<%=vdUsedInForm%>','<%=inForm%>','<%=crfWorkflowStatus%>');"><img src="images/edit.gif" border="0" alt="Edit" style="display: <%=dispStyle%>"></a>
																		<% } %>
																		
																	</div>
																	<div id="<%=pvCount%>ImgSave" style="display: <%=dispStyle%>">
																		<a id="<%=pvCount%>ImgSaveLink" href="javascript:view('<%=pvCount%>View', '<%=pvCount%>ImgSave', '<%=pvCount%>ImgEdit', 'save', '<%=pvCount%>', '<%=workflowStatus%>','<%=vdUsedInForm%>','<%=inForm%>','<%=crfWorkflowStatus%>');"><img src="images/save.gif" border="0" alt="Save"></a>
																	</div>
																	<div id="<%=pvCount%>ImgDelete" style="display: <%=dispStyle%>">
																	 <a href="javascript:confirmRM('<%=pvCount%>', 'remove', 'the Permissible Value : <%=sPVValJ%>');"><img src="images/delete.gif" border="0" alt="Remove" style="display: <%=dispStyle%>"></a>
																	</div>
																	<div id="<%=pvCount%>ImgRestore" style="display: none">
																		<a href="javascript:confirmRM('<%=pvCount%>', 'restore', 'restore');"><img src="images/restore.gif" border="0" alt="Restore"></a>
																	</div>
																  <% } %>	
																</td>
																<%if ( (sMenuAction != null) && (sMenuAction.equals("Questions"))){%>
																<td valign="top">
																	<div id="<%=pvCount%>ValidView" style="display: block">
																		<%=sVValue%>
																	</div>
																	<!--  allow to change valid value only if pv is new -->
																	<%if (sPVid.contains("EVS_")){%>
																	<div id="<%=pvCount%>ValidEdit" style="display: none">
																		&nbsp;&nbsp;
																		<select name="<%=pvCount%>selValidValue" size=1 style="width:150" onchange="javascript:getORsetEdited('<%=pvCount%>', 'pv');">
																			<option value="" selected></option>
																			<%            for (int j = 0; vQuest.size()>j; j++)
										              {
										                  Quest_Value_Bean qvBean = (Quest_Value_Bean)vQuest.elementAt(j);
										                  String sQValue = qvBean.getQUESTION_VALUE();
										                  String sQVid = qvBean.getQUESTION_VALUE_IDSEQ();
										                  if (vQVList.contains(sQValue)) //not assigned yet
										                  {
										%>
																			<option value="<%=sQVid%>">
																				<%=sQValue%>
																			</option>
																			<%
										                  }
										                  else if (sQVid.equals(sVVid)) 
										                  { 
										 %>
																			<option value="<%=sVVid%>" selected>
																				<%=sVValue%>
																			</option>
																			<%								
																			}
										              }
										%>
																		</select>
																	</div>
																	<%}%>
																</td>
																<%}%>
																<td valign="top">
																	<div id="<%=pvCount%>ValueView" style="display: block">
																		<%=sPVVal%>
																	</div>
																	<div id="<%=pvCount%>ValueEdit" style="display: none">
																		&nbsp;&nbsp;
                                                                        <!-- GF7680 pvname only --><input type="text" id="txtpvonly<%=pvCount%>" name="txt<%=pvCount%>Value" maxlength="255" width="98%" onkeyup="javascript:getORsetEdited('<%=pvCount%>', 'pv');" value="<%=sPVValJsp%>">
																	</div>
																</td>
																<td valign="top">
																	<div style="display:inline">
																	<b>VM Long Name:</b>
																	</div>
																	<% //if (vmCon.size() < 1) { %>
																	<div id="<%=pvCount%>VMEdit" style="display: none; width:90%">
																		&nbsp;&nbsp;
																		<textarea name="txt<%=pvCount%>Mean" style="width: 100%" rows="2" onblur="javascript:checkNameLen(this, 255);" onkeyup="javascript:getORsetEdited('<%=pvCount%>', 'vm');"><%=sPVMeanJsp%></textarea>
																	</div>
																	<% //} %>
																	<%if (!isView){ %>
																	<div id="<%=pvCount%>VMAltView" style="display: inline; text-align:right">
																		<span style="padding-left:0.3in; padding-right:0.1in; text-align:right">
																			<a href="javascript:openDesignateWindowVM('Alternate Names', <%=i%>);" >
																				Alt Names/Defs
																			</a>
																		</span>
																	</div>
																	<div id="<%=pvCount%>VMEditLink" style="display: inline; text-align:right">
																	  	<span style="padding-left:0.3in; padding-right:0.1in; text-align:right">
																			<% if (submit != null && (submit.length()==0 || submit.equals("INS"))) { %>
																				  [Edit VM]
																			<% } else { %>
																				 
																					<% if (inForm) {%> <a href="javascript:openEditVMWindow('<%=pvCount%>');" onclick="return confirm('This element is used in a form. Any edits will put the form out of sync. Are you sure you want to edit?');">
																					<% } else { %> <a href="javascript:openEditVMWindow('<%=pvCount%>');">
																					<% } %>
																					Edit VM
																				</a>
																			<% } %>
																		</span>
																	</div>
																	<% if (inForm){%>
																	<div id="<%=pvCount%>PVVMInForm" style="display: inline; text-align:right">
																		<span style="padding-left:0.3in; padding-right:0.1in; text-align:right">
																			<a href="javascript:openUsedWindowVM('<%=sVDPVSIDseq%>','PV');" >
																				Used by Forms
																			</a>
																		</span>
																	</div>
																	
																	<%} %>
																   <% } else{%>
																     <div id="<%=pvCount%>VMViewLink" style="display: inline; text-align:right">
																	  	<span style="padding-left:0.3in; padding-right:0.1in; text-align:right">
																	    		<a href="javascript:openViewVMWindow('<%=pvCount%>','<%=vdId%>');">
																					View VM
																				</a>
																	
																		</span>
																	</div>
																   <% } %>	
																	<br>
																	<div id="<%=pvCount%>VMView" style="display: <%if (viewType.equals("expand")) {%>block <% } else { %> none <% } %>">
																		&nbsp;&nbsp;&nbsp;&nbsp;<%=sPVMean%>
																	<br>
																	<br>	
																	</div>
																	<div id="<%=pvCount%>View" style="display: <%if (viewType.equals("expand")) {%>block <% } else { %> none <% } %>">
																		<table width="100%">
																		<tr>
																				<td colspan="2">
																					<b>
																						Public Id & Version
																					</b>
																				</td>
																			</tr>
																			<tr>
																				<td>
																					&nbsp;&nbsp;
																				</td>
																				<td>
																				<%//System.out.println("Submit" +submit); 
																				 if (submit != null &&(submit.length()==0 || submit.equals("INS"))) { %>
																				  [System Assigned after Value Domain Submission]
																			<% } else { %>
																					<%= vm.getVM_ID()+"v"+ vm.getVM_VERSION()%>
																				
																			<% } %>
																				<br><br>
																				</td>
																			</tr>
																			<tr>
																				<td colspan="2">
																					<b>
																						Description/Definition
																					</b>
																				</td>
																			</tr>
																			<tr>
																				<td>
																					&nbsp;&nbsp;
																				</td>
																				<td>
																					<div id="<%=pvCount%>VMDView" style="display: block">
																						<%=sPVDesc%>
																					</div>
																					<% //if (vmCon.size() < 1) { %>
																					<div id="<%=pvCount%>VMDEdit" style="display: none"><textarea name="txt<%=pvCount%>Def" rows="4" style="width: 100%" onkeyup="javascript:getORsetEdited('<%=pvCount%>', 'vmd');"><%=sPVDesc%></textarea></div>
																					<% //} %>
																					<br>
																				</td>
																			</tr>
																			<tr>
																				<td id="<%=pvCount%>ConLbl" colspan="2">
																					<b>
																						Concepts
																					</b>
																					<div id="<%=pvCount%>ConLink" style="display: none; padding-left: 0.3in">
																						<a href="javascript:selectConcept('<%=pvCount%>ConLink','<%=pvCount%>');">
																							Search
																						</a>
																					</div>	
																				</td>
																			</tr>
																			<tr>
																				<td>
																					&nbsp;&nbsp;
																				</td>
																				<td valign="top">
																					<div id="<%=pvCount%>Con" style="display:block; border:1px;">
																						<table id="<%=pvCount%>TBL" style="width: 98%; border: 0px">
																							<% 
																		// System.out.println("jsp vm " + vmCon.size());
																			if (vmCon.size() > 0) 
																			{
																				for (int k = 0; k<vmCon.size(); k++)
																				{
																					EVS_Bean con = (EVS_Bean)vmCon.elementAt(k);
																					if (con == null) break;
																					String conName = con.getLONG_NAME();
																					String conID = con.getCONCEPT_IDENTIFIER();
																					String conVocab = con.getEVS_DATABASE();
																					String conDesc = con.getPREFERRED_DEFINITION();
																					String trCount = pvCount + "tr" + k;
																					String isParPrim = "";																				
																					String conType = "";																					
																					if (k == vmCon.size()-1)
																						conType = "Primary";
																					else
																						conType = "Qualifier";
																					if (conType.equals("Primary"))
																						isParPrim = sParId;
																					
																	//	System.out.println(trCount + " jsp " + conName + conID + conVocab + conDesc);
																			%>
																							<tr id="<%=trCount%>">
																								<td valign="top" nowrap="nowrap">
																									<div id="<%=pvCount%>Con<%=k%>" style="display:none">
																										<a href="javascript:deleteConcept('<%=trCount%>', '<%=pvCount%>');" title="Remove Item">
																											<img src="images/delete_small.gif" border="0" alt="Remove">
																										</a>
																										&nbsp;&nbsp;
																									</div>
																								</td>
																								<td valign="top" nowrap="nowrap">
																									<%=conName%>
																								</td>
																								<td valign="top" nowrap="nowrap">
																									&nbsp;&nbsp;&nbsp;&nbsp;
																									<%=conID%>
																									&nbsp;&nbsp;&nbsp;&nbsp;
																								</td>
																								<td valign="top">
																									<!--  nowrap="nowrap"> -->
																									<%=conVocab%>
																									&nbsp;&nbsp;&nbsp;&nbsp;
																								</td>
																								<td valign="top" nowrap="nowrap">
																									<%=conType%>
																									&nbsp;&nbsp;&nbsp;&nbsp;
																								</td>
																								<td valign="top" nowrap="nowrap" style="visibility:hidden" width="0.1px">&quot;
																									<div style="display:none; width:0.1px">
																										<%=conDesc%>
																									</div>
																								</td>
																							</tr>
																							<% } } else { %>
																							<tr>
																								<td height="2px">
																									&nbsp;&nbsp;
																								</td>
																							</tr>
																							<% } %>
																						</table>
																					</div>
																				</td>
																			</tr>
																			<tr>
																				<td height="2px">
																					&nbsp;&nbsp;
																				</td>
																			</tr>
																		</table>
																	</div>
																	<% if (vEMsg.size() > 0 && sEditPV.equals(pvCount)) { %>
																	<hr>
																	<table width="100%" cellpadding="0.05in,0.05in,0.05in,0.05in" border="1">
																		<col /></col>
																		<tr>
																			<td colspan=2 valign="top">
																				<table cellpadding="0.1in,0.1in,0.1in,0.1in">
																					<tr>
																						<td>
																							<%--<input type="button" id="btnUseSelect" value="Use Selection" disabled onClick="javascript:view('<%=sEditPV%>View', '<%=sEditPV%>ImgSave', '<%=sEditPV%>ImgEdit', 'save', '<%=sEditPV%>');">--%>
    <input type="button" id="btnUseSelect1" value="Use Selection" disabled onClick="javascript:view('<%=sEditPV%>View', '<%=sEditPV%>ImgSave', '<%=sEditPV%>ImgEdit', 'save', '<%=sEditPV%>', '<%=workflowStatus%>','<%=vdUsedInForm%>','<%=inForm%>','<%=crfWorkflowStatus%>');">   <!-- GF7680 appended 4 parameters -->
																						</td>
																						<td>
																							&nbsp;&nbsp;
																							<!-- <input type="checkbox" name="saveAlt"/>  -->
																						</td>
																						<td>
																							<input type="button" id="btnContinue"  value="Create" <% if (conceptMatch) { %>disabled <% } %>
																								onClick="javascript:ContinueDuplicateVM('continueVM');">
																						</td>
																						<td>
																							&nbsp;&nbsp;
																							<!-- Save the current Name and Description as Alternate Name and Definition <br>  -->
																						</td>
																						<td align="right">
																							<input type="button" id="btnCancelUS" value="Cancel" onClick="javascript:confirmRM('<%=sEditPV%>', 'restore', 'restore');">
																						</td>
																					</tr>
																				</table>
																			</td>
																		</tr>
																		<tr>
																			<td colspan=2>
																				<% if (vmMatch.equals("true")) { %>
The Value Meaning matches the name of an existing Value Meaning. You may either select one of the existing Value Meanings from the list below and click Use Selection OR click Cancel to change the Value Meaning.
																				<% } else { %>
																					The Value Meaning you are creating matches the definition or concepts of an existing Value Meaning.
																					You may select an existing Value Meaning and click 'Use Selection', 
																					'Cancel' to edit the Value Meaning, or 'Continue' to create a new Value Meaning with the same definition or concepts.
																				<% } %>
																				<br>
																			</td>
																		</tr></table>
																	<div style="height:350px;width:100%;overflow:auto">
																	<table width="100%" cellpadding="0.05in,0.05in,0.05in,0.05in" border="0">
																	<% 
															for (int k=0; k<vEMsg.size(); k++)
															{ 
																	VM_Bean vB = (VM_Bean)vEMsg.elementAt(k);
																	String vmIdandVer ="";
																	if(vB.getVM_ID()==null || vB.getVM_VERSION()==null)
																	  vmIdandVer ="[System Assigned after Value Domain Submission]";
																	else
																	 vmIdandVer=vB.getVM_ID()+"v"+ vB.getVM_VERSION();
																	Vector vBCon = vB.getVM_CONCEPT_LIST();
																	String rVM = "erVM"+k;
														 %>
																		<tr>
																			<td valign="top">
																				<input name="rUse" type="radio" alt="Select to use" value="<%=rVM%>" onclick="javascript:enableUSE();">
																			</td>
																			<td>
																				<dl>
																					<dt>
																						VM Long Name:
																					<dd>
																					<%=vB.getVM_LONG_NAME()%>
																					<dt>
																						Public Id & Version:
																					<dd>
																					
																					<%=vmIdandVer%>
																					
																				   <dt>
																						VM Description:
																					<dd>
																						<%=vB.getVM_PREFERRED_DEFINITION()%>
																					<dt>
																						VM Concepts:
																						<% if (vBCon.size() > 0) { 
																				for (int p =0; p<vBCon.size(); p++) {
																				EVS_Bean eB = (EVS_Bean)vBCon.elementAt(p);
																	  %>
																					<dd>
																						<%=eB.getLONG_NAME()%>
																						&nbsp;&nbsp;
																						<%=eB.getCONCEPT_IDENTIFIER()%>
																						&nbsp;&nbsp;
																						<%=eB.getEVS_DATABASE()%>
																						<% }  } else { %>
																						None.
																						<% } %>
																					<dt>
																						Reason:
																					<dd>
																						<%=vB.getVM_COMMENT_FLAG()%>
																				</dl>
																			</td>
																		</tr>
																		<% } %>
																	</table></div>
																	<%} %>
																</td>
																<%if (vdCONs > 0){%>
																<td id="<%=pvCount%>Par" valign="top">
																	<%=sParId%>
																</td>
																<% } %>
																<td id="<%=pvCount%>Org" valign="top">
																	<%=sPVOrigin%>
																</td>
																<td id="<%=pvCount%>BD" valign="top">
																	<%=sPVBegDate%>
																</td>
																<td id="<%=pvCount%>ED" valign="top">
																	<%=sPVEndDate%>
																</td>
															</tr>
															<%	} %>
															<!--  end for -->
															<%	} %>
															<!-- end if -->
														</table>
													</div>
												</td>
											</tr>
											<% } %>
											<!-- end enumerated -->
										</table>
									</td>
								</tr>
							</table>
						</div>
						<div style="display:none;">
                            <input type="hidden" name="hideDatePick" oncalendar="appendDate(this.value);">
							<input type="hidden" name="pageAction" value="nothing">									
							<input type="hidden" name="editPVInd" value="<%=sEditPV%>">
							<!-- keep this if there was error -->
							<input type="hidden" name="currentPVInd" value="">
							<input type="hidden" name="currentElmID" value="">
							<input type="hidden" name="currentPVViewType" value="">
							<input type="hidden" name="currentOrg" value="">
							<input type="hidden" name="currentBD" value="">
							<input type="hidden" name="currentED" value="">
							<input type="hidden" name="currentVM" value="">
							<select name="PVViewTypes" size="1" style="visibility:hidden;width:100;" multiple>
								<%for (int i = 0; vVDPVList.size() > i; i++)
							    {
							      PV_Bean pvBean = (PV_Bean)vVDPVList.elementAt(i);
							      String viewType = "expand";
							      if (pvBean != null && pvBean.getPV_VIEW_TYPE() != null)
							        viewType = (String)pvBean.getPV_VIEW_TYPE();
								%>
								<option value="<%=viewType%>" selected>
									<%=viewType%>
								</option>
								<% }%>
							</select>
							<input type="hidden" name="hiddenParentName" value="">
							<input type="hidden" name="hiddenParentCode" value="">
							<input type="hidden" name="hiddenParentDB" value="">
							<input type="hidden" name="hiddenParentListString" value="">
							<select name="ParentNames" size="1" style="visibility:hidden;width:100;" multiple>
								<%if (vParentNames != null)
		      {
		        for (int i = 0; vParentNames.size() > i; i++)
		        {
		          String sParentName = (String) vParentNames.elementAt(i);
		          String sParNameJsp = util.parsedStringDoubleQuoteJSP(sParentName);
		%>
								<option value="<%=sParNameJsp%>">
									<%=sParentName%>
								</option>
								<%}
		      }
		      %>
							</select>
							<select name="ParentCodes" size="1" style="visibility:hidden;width:100;" multiple>
								<%if (vParentCodes != null)
		      {
		        for (int i = 0; vParentCodes.size() > i; i++)
		        {
		          String sParentCode = (String) vParentCodes.elementAt(i);
		%>
								<option value="<%=sParentCode%>">
									<%=sParentCode%>
								</option>
								<%}
		      }
		      %>
							</select>
							<select name="ParentDB" size="1" style="visibility:hidden;width:100;" multiple>
								<%if (vParentDB != null)
		      {
		        for (int i = 0; vParentDB.size() > i; i++)
		        {
		          String sParentDB = (String) vParentDB.elementAt(i);
		%>
								<option value="<%=sParentDB%>">
									<%=sParentDB%>
								</option>
								<%}
		      }
		      %>
							</select>
							<select name="ParentMetaSource" size="1" style="visibility:hidden;width:100;" multiple>
								<%if (vParentDB != null)
		      {
		        for (int i = 0; vParentMetaSource.size() > i; i++)
		        {
		          String sParentMetaSource = (String) vParentMetaSource.elementAt(i);
		%>
								<option value="<%=sParentMetaSource%>">
									<%=sParentMetaSource%>
								</option>
								<%}
		      }
		      %>
							</select>
							<input type="hidden" name="selectedParentConceptName" value="">
							<input type="hidden" name="selectedParentConceptCode" value="">
							<input type="hidden" name="selectedParentConceptDB" value="">
							<input type="hidden" name="selectedParentConceptMetaSource" value="">
                            <%if (sMenuAction != null) %> 
							  <input type="hidden" name="MenuAction" value="<%=sMenuAction%>">
							<input type="hidden" name="pvSortColumn" value="">
							<input type="hidden" name="openToTree" value="">
							<input type="hidden" name="actSelect" value="">
							<input type="hidden" name="listVDType" value="<%=sTypeFlag%>">
							<!-- stores the selected rows to get the bean from the search results -->
							<select name="hiddenSelRow" size="1" style="visibility:hidden;width:160" multiple></select>
							<!-- use both name and id -->
							<select id="hiddenConVM" name="hiddenConVM" size="100" style="visibility:hidden;width:160" multiple></select>
							<input type="hidden" name="acSearch" value="">
						</div>
					</form>
				</td>
			</tr>
		</table>
		<div style="display:none">
			<form name="SearchActionForm" method="post" action="">
			   <%if (sSearchAC != null) %>
				<input type="hidden" name="searchComp" value="<%=sSearchAC%>">
				<input type="hidden" name="searchEVS" value="ValueDomain">
				<input type="hidden" name="isValidSearch" value="true">
				<input type="hidden" name="CDVDcontext" value="">
				<input type="hidden" name="SelContext" value="">
				<input type="hidden" name="acID" value="<%=sVDIDSEQ%>">
				<input type="hidden" name="CD_ID" value="<%=sConDomID%>">
				<input type="hidden" name="itemType" value="">
				<input type="hidden" name="SelCDid" value="<%=sConDomID%>">
			</form>
		</div>
<script language="javascript">
//put the pv in edit mode after cancel the duplicate to make sure that user completes the action
<% if (pgAction.equals("restore") || pgAction.equals("openNewPV")) { %>
    var objs = document.getElementsByName("editPVInd");
	<% if (!sEditPV.equals("") && !sEditPV.equals("pvNew")) { %>
		objs[0].value = "";
		view(<%=sEditPV%>View, <%=sEditPV%>ImgEdit, <%=sEditPV%>ImgSave, 'edit', '<%=sEditPV%>');
	<% } %>
	objs[0].value = "<%=sEditPV%>";
<% } %>
</script>
	</body>
</html>