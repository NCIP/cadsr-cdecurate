<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/ValueMeaningDetail.jsp,v 1.11 2008-03-25 17:41:09 chickerura Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<html>
	<head>
		<title>
			Value Meaning
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/date-picker.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/ValueMeaningEdit.js"></SCRIPT>
		<%  
			//get the focus element
		  String elmFocus = (String)request.getAttribute(VMForm.REQUEST_FOCUS_ELEMENT);
		  if (elmFocus == null) elmFocus = "";
			VMForm thisForm = (VMForm)request.getAttribute(VMForm.REQUEST_FORM_DATA);
			//Session_Data sData = (Session_Data)thisForm.getCurationServlet().sessionData; 
			boolean conExist = thisForm.conceptExist;
			Vector vmCon = thisForm.vmConcepts;
			Vector cdResult = (Vector)request.getAttribute("ConDomainList");
			 Vector vStatus = (Vector)session.getAttribute("vStatusVM");
			 Vector vRegStatus = (Vector)session.getAttribute("vRegStatus");
			 session.setAttribute("prevVMVersion",thisForm.getVMBean().getVM_VERSION());
			 String sVM = (String)request.getAttribute("VMName");
			 String vocab = (String)session.getAttribute("preferredVocab");
		%>

		<Script Language="JavaScript">
		var actionDelete = "<%=VMForm.ACT_CON_DELETE%>";
		var actionAppend = "<%=VMForm.ACT_CON_APPEND%>";
		var elmSelectRow = "<%=VMForm.ELM_SEL_CON_ROW%>";
		var elmNVP = "<%=VMForm.ELM_NVP_ORDER%>";
		
    function checkNameLen(cobj, mlen)
    {
        if (cobj.value.length > mlen)
        {
            alert("You have exceeded the maximum length of this field. Please edit and reduce the text to less than " + mlen + " characters.");
            cobj.focus();
        }
    }
    
    function displayStatus()
    {
     <%
			  String statusMessage = (String)session.getAttribute(Session_Data.SESSION_STATUS_MESSAGE);
			 // System.out.println("status " + statusMessage);
			  if (statusMessage != null && !statusMessage.equals(""))
			  {
			%>
			  	alert("<%=statusMessage%>");
			<%
				}
			  session.setAttribute(Session_Data.SESSION_STATUS_MESSAGE, "");
			%>        
    }
	</SCRIPT>
	</head>
	<body onload="javascript:setFocusTo('<%=elmFocus%>');displayStatus();">
		<table width="99%" border=1>
			<tr>
				<td height="95" valign="top" width="100%">
					<jsp:include page="<%=VMForm.JSP_TITLE_BAR%>" flush="true" />
				</td>
			</tr>
			<tr>
				<td>
					<form name="VMDetail" method="POST" action="../../cdecurate/NCICurationServlet?reqType=<%=VMForm.ELM_FORM_REQ_DETAIL%>">
						<jsp:include page="<%=VMForm.JSP_VM_TITLE%>" flush="true" />
						<div class="tabbody" style="width: 100%">
							<div class="ind2">
								<b>
									<%=VMForm.ELM_LBL_NAME%>
								</b>
							</div>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="<%=VMForm.ELM_LBL_NAME%>" value="<%=thisForm.longName%>"/>
							<div class="ind2">
								<b>
									Public ID
								</b>
							</div>
							<div class="readonlybox" style="width: 40%;">
								<%=thisForm.getVMBean().getVM_ID()%>
							</div>
							<br>
							<% String sVersion = thisForm.getVMBean().getVM_VERSION();
							    System.out.println("version"+sVersion);
    							if (sVersion == null) sVersion = "1.0"; %>
							<div class="ind2">
								<b>
									Enter Version
								</b>
							</div>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="Version" type="text" value="<%=sVersion%>" size="5" maxlength=5>
							&nbsp;&nbsp;&nbsp;
							<a href="http://ncicb.nci.nih.gov/NCICB/infrastructure/cacore_overview/cadsr/business_rules" target="_blank">
							Business Rules
						</a><br>
						<div class="ind2">
								<b>
									WorkFlow Status
								</b>
							</div>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select name="selStatus" size="1">
							<option value="" selected="selected"></option>
							<% if(vStatus!=null){  
							   for (int i = 0; vStatus.size()>i; i++)
     							{
        						String sStatusName = (String)vStatus.elementAt(i); 
        						String sStatus = thisForm.getVMBean().getASL_NAME();
    							if (sStatus == null) sStatus = "";  
    							%>
								<option value="<%=sStatusName%>" <%if(sStatusName.equals(sStatus)){%> selected <%}%>>
								<%=sStatusName%>
								</option>
								<%
        }}
     %>
							</select>
							<div class="ind2">
								<b>
									<%=thisForm.descriptionLabel%>
								</b>
							</div>
							<div class="ind3">
								<textarea name="<%=VMForm.ELM_DEFINITION%>" rows="4" style="width:95%"><%=thisForm.description%></textarea>
							</div>
							<%if (conExist) { %>
							<div class="ind2">
								<b>
									<%=VMForm.ELM_LBL_SYS_DESC%>
								</b>
							</div>
							<div class="readonlybox" style="width: 90%;">
								<%=thisForm.systemDescription%>
							</div>
							<% } %>
							<div class="ind2">
								<b>
									<%=VMForm.ELM_LBL_CH_NOTE%>
								</b>
							</div>
							<div class="ind3">
								<textarea name="<%=VMForm.ELM_CHANGE_NOTE%>" rows="3" style="width:80%"><%=thisForm.changeNote%></textarea>
							</div>
							<hr>
							<div id="<%=VMForm.ELM_LABEL_CON%>" class="ind2" style="display:inline">
								<b>
									Concepts
								</b>
							</div>
							<div class="ind3" style="display:inline">
								<a title="Search" href="javascript:searchConcepts('<%=vocab%>');">
									Search
								</a>
							</div>
							<%if (conExist) { %>
							<div class="ind3" align="right" style="display:inline">
								<input style="width:80px" onclick="javascript:deleteConcept('-99', 'allConcepts');" type="button" value="Delete All" name="btnDeleteAll">
							</div>
							<div class="table">
								<b>
									<%=VMForm.ELM_LBL_CON_SUM%>
									:
								</b>
								<%=thisForm.conceptSummary%>
							</div>
							<div class="table">
								<table width="95%" border="0">
									<colgroup>
										<col width="5%">
										<col width="40%">
										<col width="10%">
										<col width="20%">
										<col width="10%">
									</colgroup>
									<tbody>
										<tr style="padding-bottom:0.05in">
											<th>
												Action
											</th>
											<th>
												<%=VMForm.ELM_LBL_CON_NAME%>
											</th>
											<th>
												<%=VMForm.ELM_LBL_CON_ID%>
											</th>
											<th>
												Vocabulary
											</th>
											<th>
												Type
											</th>
										</tr>
										<% for (int i=0; i<vmCon.size(); i++) 
                	{
                		EVS_Bean cBean = (EVS_Bean)vmCon.elementAt(i);  
								%>
										<tr <% if (i%2 == 0) { %> class="rowColor" <% } %>>
											<td>
												<a href="javascript:deleteConcept('<%=i%>', '<%=cBean.getLONG_NAME()%>');" title="Remove Item">
													<img src="images/delete_white.gif" border="0" alt="Remove Item">
												</a>
												<% if (i != 0) { %>
												<a href="javascript:moveConcept('<%=i%>', '<%=VMForm.ACT_CON_MOVEUP%>');" title="Move Up">
													<img src="images/upArrow.gif" border="0" alt="Move Up">
												</a>
												<% } %>
												<% if (i != vmCon.size()-1) { %>
												<a href="javascript:moveConcept('<%=i%>', '<%=VMForm.ACT_CON_MOVEDOWN%>');" title="Move Down">
													<img src="images/downArrow.gif" border="0" alt="Move Down">
												</a>
												<% } %>
											</td>
											<td>
												<%=cBean.getLONG_NAME()%>
											</td>
											<td>
												<%=cBean.getCONCEPT_IDENTIFIER()%>
											</td>
											<td>
												<%=cBean.getEVS_DATABASE()%>
											</td>
											<td>
												<%=cBean.getPRIMARY_FLAG()%>
											</td>
										</tr>
										<tr <% if (i%2 == 0) { %> class="rowColor" <% } %>>
											<td></td>
											<td colspan="4">
												<div class="ind3">
													<b>
														Description:
													</b>
													<br>
													<%=cBean.getPREFERRED_DEFINITION()%>
												</div>
											</td>
										</tr>
										<% } %>
									</tbody>
								</table>
							</div>
							<% } %>
							<br>
							<hr>
							<div id="<%=VMForm.ELM_LABEL_CONDOMAIN%>" class="ind2" style="display:inline">
								<b>
									Conceptual Domain(s)
								</b>
							</div>
							<% if (cdResult != null) 
   										 {%>
								<div class="table">
								<b>
									<%=VMForm.ELM_LBL_CONDOMAIN_SUM%>
									:
								</b>
								<%=sVM%>
							</div>
							<div class="table">
								<table width="95%" border="0">
									<colgroup>
									   <col width="2%">
										<col width="38%">
										<col width="10%">
										<col width="20%">
										<col width="10%">
										<col width="10%">
									</colgroup>
									<tbody>
										<tr style="padding-bottom:0.05in">
										<tr valign="middle">
										   <th>
										   
										   </th>
										   <th>
												<%=VMForm.ELM_LBL_CONDOMAIN_NAME%>
											</th>
											<th>
												<%=VMForm.ELM_LBL_CONDOMAIN_ID%>
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
										  for (int i = 0; i < cdResult.size(); i++)
										  {
       										 CD_Bean cd = (CD_Bean)cdResult.elementAt(i);
								%>
										<tr <% if (i%2 == 0) { %> class="rowColor" <% } %>>
											<td>
												
											</td>
											<td>
												<%=cd.getCD_LONG_NAME()%>
											</td>
											<td>
												<%= cd.getCD_CD_ID()%>
											</td>
											<td>
												<%=cd.getCD_VERSION()%>
											</td>
											<td>
												<%=cd.getCD_ASL_NAME()%>
											</td>
											<td>
												<%=cd.getCD_CONTEXT_NAME()%>
											</td>
										</tr>
										<tr <% if (i%2 == 0) { %> class="rowColor" <% } %>>
											<td></td>
											<td colspan="5">
												<div class="ind3">
													<b>
														Definition:
													</b>
													<br>
													<%=cd.getCD_PREFERRED_DEFINITION()%>
												</div>
											</td>
										</tr>
										<% } %>
									</tbody>
								</table>
							</div>
							<% } %>
							<br>
						</div>
						<input type="hidden" name="<%=VMForm.ELM_NVP_ORDER%>" value="<%=vmCon.size()%>">						
					</form>
					<div style="display:none">
						<form name="SearchActionForm" method="post" action="">
							<input type="hidden" name="searchComp" value="">
							<input type="hidden" name="searchEVS" value="<%=VMForm.ELM_FORM_SEARCH_EVS%>">
							<input type="hidden" name="isValidSearch" value="true">
							<input type="hidden" name="CDVDcontext" value="">
							<input type="hidden" name="SelContext" value="">
							<input type="hidden" name="acID" value="">
							<input type="hidden" name="CD_ID" value="">
							<input type="hidden" name="itemType" value="">
							<input type="hidden" name="SelCDid" value="">
						</form>
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>
