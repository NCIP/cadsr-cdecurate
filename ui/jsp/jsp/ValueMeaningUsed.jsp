<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/ValueMeaningUsed.jsp,v 1.6 2007-06-12 20:27:24 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<html>
	<head>
		<title>
			Value Meaning Edits
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="jsp/FullDesignArial.css" rel="stylesheet" type="text/css">
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<SCRIPT LANGUAGE="JavaScript" SRC="Assets/date-picker.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="Assets/ValueMeaningEdit.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="../../cdecurate/Assets/HelpFunctions.js"></SCRIPT>
		<%  
			//get the focus element
		  String elmFocus = (String)request.getAttribute(VMForm.REQUEST_FOCUS_ELEMENT);
		  if (elmFocus == null) elmFocus = "";
			VMForm thisForm = (VMForm)request.getAttribute(VMForm.REQUEST_FORM_DATA); 

			Vector vDE = thisForm.vmDEs;
			if (vDE == null) vDE = new Vector();
			String deFilter = thisForm.filteredDE;
			String deSort = thisForm.sortedDE;
			
			Vector vVD = thisForm.vmVDs;
			if (vVD == null) vVD = new Vector();
			String vdFilter = thisForm.filteredVD;
			String vdSort = thisForm.sortedVD;
			
			Vector vCRF = thisForm.vmCRFs;
			if (vCRF == null) vCRF = new Vector(); 	
			String crfFilter = thisForm.filteredCRF;
			String crfSort = thisForm.sortedCRF;

			String sortImgLink = "<img src=\"Assets/sort.gif\" border=\"0\">";
		%>
		<Script Language="JavaScript">
				var elmACType = "<%=VMForm.ELM_AC_TYPE%>";
				var elmFieldType = "<%=VMForm.ELM_FIELD_TYPE%>";
				var actionSort = "<%=VMForm.ACT_SORT_AC%>";
				var actionFilter = "<%=VMForm.ACT_FILTER_AC%>";
				var showAllValue = "<%=VMForm.ELM_LBL_SHOW_ALL%>";
				
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
				//  System.out.println("status " + statusMessage);
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
	<body onload="javascript:setFocusTo('<%=elmFocus%>');">
		<table id="startTop" width="99%" border=1>
			<tr>
				<td>
					<jsp:include page="<%=VMForm.JSP_TITLE_BAR%>" flush="true" />
				</td>
			</tr>
			<tr>
				<td>
					<form name="VMUse" method="POST" action="/cdecurate/NCICurationServlet?reqType=<%=VMForm.ELM_FORM_REQ_USED%>">
						<jsp:include page="<%=VMForm.JSP_VM_TITLE%>" flush="true" />
						<div class="tabbody" style="width: 99%">
							<div class="ind2">
								<b>
									Associated
									<a href="javascript:setFocusTo('<%=VMForm.ELM_CRF_NAME%>');">
										<%=VMForm.ELM_CRF_NAME%>
									</a>
									,
									<a href="javascript:setFocusTo('<%=VMForm.ELM_VD_NAME%>');">
										<%=VMForm.ELM_VD_NAME%>
									</a>
									,
									<a href="javascript:setFocusTo('<%=VMForm.ELM_DE_NAME%>');">
										<%=VMForm.ELM_DE_NAME%>
									</a>
								</b>
							</div>
							<div class="ind2">
								All associated items are displayed by default. Click the "Show Released Only" button to display items with a Workflow Status of RELEASED only.
							</div>
							<hr id="<%=VMForm.ELM_CRF_NAME%>">							
							<!--Forms/Templates-->
							<div class="ind2" style="display:inline;">  <!--  width:49%;"> -->
								<b>
									<%=VMForm.ELM_CRF_NAME%>:
								</b>
								<%=vCRF.size()%> Found 
							</div>
							<% if (vCRF.size() > 0 || crfFilter.equals(VMForm.ELM_LBL_SHOW_ALL)) { %> 
								<div class="ind2" style="display:inline;">  <!--  text-align:right; width:49%;"> -->
									<input style="width: 160px" onclick="javascript:showReleased('<%=VMForm.ELM_CRF_NAME%>', '<%=crfFilter%>');" type="button" value="<%=crfFilter%>" name="btnshowRELCRF">
								</div>
							<% } %>
							<% if (vCRF.size() > 0) { %> 
								<div class="table">
									<table width="100%" border="0">
										<colgroup>
											<col width="20%">
											<col width="9%">
											<col width="7%">
											<col width="12%">
											<col width="8%">
											<col width="6%">
											<col width="10%">
											<col width="18%">
											<col width="10%">
										</colgroup>
										<tbody>
											<tr>
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_LONG_NAME%>" href="javascript:sort('<%=VMForm.ELM_CRF_NAME%>','<%=CommonACBean.COLUMN_LONG_NAME%>');">
														<%=CommonACBean.COLUMN_LONG_NAME%>
														<%if (crfSort.equals(CommonACBean.COLUMN_LONG_NAME)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_PUBLIC_ID%>" href="javascript:sort('<%=VMForm.ELM_CRF_NAME%>','<%=CommonACBean.COLUMN_PUBLIC_ID%>');">
														<%=CommonACBean.COLUMN_PUBLIC_ID%>
														<%if (crfSort.equals(CommonACBean.COLUMN_PUBLIC_ID)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_VERSION%>" href="javascript:sort('<%=VMForm.ELM_CRF_NAME%>','<%=CommonACBean.COLUMN_VERSION%>');">
														<%=CommonACBean.COLUMN_VERSION%>
														<%if (crfSort.equals(CommonACBean.COLUMN_VERSION)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_STATUS%>" href="javascript:sort('<%=VMForm.ELM_CRF_NAME%>','<%=CommonACBean.COLUMN_STATUS%>');">
														<%=CommonACBean.COLUMN_STATUS%>
														<%if (crfSort.equals(CommonACBean.COLUMN_STATUS)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_CONTEXT%>" href="javascript:sort('<%=VMForm.ELM_CRF_NAME%>','<%=CommonACBean.COLUMN_CONTEXT%>');">
														<%=CommonACBean.COLUMN_CONTEXT%>
														<%if (crfSort.equals(CommonACBean.COLUMN_CONTEXT)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_TYPE%>" href="javascript:sort('<%=VMForm.ELM_CRF_NAME%>','<%=CommonACBean.COLUMN_TYPE%>');">
														<%=CommonACBean.COLUMN_TYPE%>
														<%if (crfSort.equals(CommonACBean.COLUMN_TYPE)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_CATEGORY%>" href="javascript:sort('<%=VMForm.ELM_CRF_NAME%>','<%=CommonACBean.COLUMN_CATEGORY%>');">
														<%=CommonACBean.COLUMN_CATEGORY%>
														<%if (crfSort.equals(CommonACBean.COLUMN_CATEGORY)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_PROTO_NAME%>" href="javascript:sort('<%=VMForm.ELM_CRF_NAME%>','<%=CommonACBean.COLUMN_PROTO_NAME%>');">
														<%=CommonACBean.COLUMN_PROTO_NAME%>
														<%if (crfSort.equals(CommonACBean.COLUMN_PROTO_NAME)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_PROTO_ID%>" href="javascript:sort('<%=VMForm.ELM_CRF_NAME%>','<%=CommonACBean.COLUMN_PROTO_ID%>');">
														<%=CommonACBean.COLUMN_PROTO_ID%>
														<%if (crfSort.equals(CommonACBean.COLUMN_PROTO_ID)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
											</tr>
											<% for (int i =0; i<vCRF.size(); i++) 
							              	{
							              		CommonACBean crfBean = (CommonACBean)vCRF.elementAt(i);                  
											%>
											<tr <% if(i%2 == 0) { %> class="rowColor" <% } %>>
												<td>
													<%=crfBean.getLongName()%>
												</td>
												<td>
													<%=crfBean.getPublicID()%>
												</td>
												<td>
													<%=crfBean.getVersion()%>
												</td>
												<td>
													<%=crfBean.getWorkflowStatus()%>
												</td>
												<td>
													<%=crfBean.getContext()%>
												</td>
												<td>
													<%=crfBean.getType()%>
												</td>
												<td>
													<%=crfBean.getCategory()%>
												</td>
												<td>
													<%=crfBean.getProtoName()%>
												</td>
												<td>
													<%=crfBean.getProtoID()%>
												</td>
											</tr>
											<% } %>
										</tbody>
									</table>
								</div>
							<% } %>
							<hr id="<%=VMForm.ELM_VD_NAME%>">
							<div align="right">
								 <a href="javascript:setFocusTo('startTop');"><img src="Assets/returntotop.gif" border="0" alt="Return to Top"> Return to Top</a>
							</div>
							
							<!--Value Domain-->
							<div class="ind2" style="display:inline;">  <!--  width:49%;"> -->
								<b>
									<%=VMForm.ELM_VD_NAME%>:
								</b>
								<%=vVD.size()%> Found 
							</div>
							<% if (vVD.size() > 0 || vdFilter.equals(VMForm.ELM_LBL_SHOW_ALL)) { %> 
								<div class="ind2" style="display:inline;">  <!--  width:49%; text-align:right;">  -->
									<input style="width: 160px" onclick="javascript:showReleased('<%=VMForm.ELM_VD_NAME%>', '<%=vdFilter%>');" type="button" value="<%=vdFilter%>" name="btnshowRELVD">
								</div>
							<% } %>
							<% if (vVD.size() > 0) { %> 
								<div class="table">
									<table width="100%" border="0">
										<colgroup>
											<col width="40%">
											<col width="10%">
											<col width="10%">
											<col width="20%">
											<col width="20%">
										</colgroup>
										<tbody>
											<tr>
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_LONG_NAME%>" href="javascript:sort('<%=VMForm.ELM_VD_NAME%>','<%=CommonACBean.COLUMN_LONG_NAME%>');">
														<%=CommonACBean.COLUMN_LONG_NAME%>
														<%if (vdSort.equals(CommonACBean.COLUMN_LONG_NAME)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_PUBLIC_ID%>" href="javascript:sort('<%=VMForm.ELM_VD_NAME%>','<%=CommonACBean.COLUMN_PUBLIC_ID%>');">
														<%=CommonACBean.COLUMN_PUBLIC_ID%>
														<%if (vdSort.equals(CommonACBean.COLUMN_PUBLIC_ID)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_VERSION%>" href="javascript:sort('<%=VMForm.ELM_VD_NAME%>','<%=CommonACBean.COLUMN_VERSION%>');">
														<%=CommonACBean.COLUMN_VERSION%>
														<%if (vdSort.equals(CommonACBean.COLUMN_VERSION)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_STATUS%>" href="javascript:sort('<%=VMForm.ELM_VD_NAME%>','<%=CommonACBean.COLUMN_STATUS%>');">
														<%=CommonACBean.COLUMN_STATUS%>
														<%if (vdSort.equals(CommonACBean.COLUMN_STATUS)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_CONTEXT%>" href="javascript:sort('<%=VMForm.ELM_VD_NAME%>','<%=CommonACBean.COLUMN_CONTEXT%>');">
														<%=CommonACBean.COLUMN_CONTEXT%>
														<%if (vdSort.equals(CommonACBean.COLUMN_CONTEXT)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
											</tr>
											<% for (int i =0; i<vVD.size(); i++) 
					            {
					              CommonACBean vdBean = (CommonACBean)vVD.elementAt(i);                  
											%>
											<tr <% if (i%2 == 0) { %> class="rowColor" <% } %>>
												<td>
													<%=vdBean.getLongName()%>
												</td>
												<td>
													<%=vdBean.getPublicID()%>
												</td>
												<td>
													<%=vdBean.getVersion()%>
												</td>
												<td>
													<%=vdBean.getWorkflowStatus()%>
												</td>
												<td>
													<%=vdBean.getContext()%>
												</td>
											</tr>
											<tr <% if (i%2 == 0) { %> class="rowColor" <% } %>>
												<td colspan="5">
													<div class="ind3">
														<b>
															Definition:
														</b>
														<br>
															<%=vdBean.getDefinition()%>
													</div>
												</td>
											</tr>
											<% } %>
										</tbody>
									</table>
								</div>
							<% } %>
							<hr id="<%=VMForm.ELM_DE_NAME%>">
							<div align="right">
								 <a href="javascript:setFocusTo('startTop');"><img src="Assets/returntotop.gif" border="0" alt="Return to Top"> Return to Top</a>
							</div>
							<div class="ind2" style="display:inline;"> <!--  width:49%;">  -->
								<b>
									<%=VMForm.ELM_DE_NAME%>:
								</b>
								<%=vDE.size()%> Found 
							</div>
							<% if (vDE.size() > 0 || deFilter.equals(VMForm.ELM_LBL_SHOW_ALL)) { %>
								<div class="ind2" style="display:inline;">  <!-- text-align:right; width:49%;"> -->
									<input style="width: 160px" onclick="javascript:showReleased('<%=VMForm.ELM_DE_NAME%>', '<%=deFilter%>');" type="button" value="<%=deFilter%>" name="btnshowRELDE">
								</div>
							<% } %>
							<% if (vDE.size() > 0) { %> 
								<div class="table">
									<table width="100%" border="0">
										<colgroup>
											<col width="40%">
											<col width="10%">
											<col width="10%">
											<col width="20%">
											<col width="20%">
										</colgroup>
										<tbody>
											<tr style="padding-bottom:0.05in">
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_LONG_NAME%>" href="javascript:sort('<%=VMForm.ELM_DE_NAME%>','<%=CommonACBean.COLUMN_LONG_NAME%>');">
														<%=CommonACBean.COLUMN_LONG_NAME%>
														<%if (deSort.equals(CommonACBean.COLUMN_LONG_NAME)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_PUBLIC_ID%>" href="javascript:sort('<%=VMForm.ELM_DE_NAME%>','<%=CommonACBean.COLUMN_PUBLIC_ID%>');">
														<%=CommonACBean.COLUMN_PUBLIC_ID%>
														<%if (deSort.equals(CommonACBean.COLUMN_PUBLIC_ID)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_VERSION%>" href="javascript:sort('<%=VMForm.ELM_DE_NAME%>','<%=CommonACBean.COLUMN_VERSION%>');">
														<%=CommonACBean.COLUMN_VERSION%>
														<%if (deSort.equals(CommonACBean.COLUMN_VERSION)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_STATUS%>" href="javascript:sort('<%=VMForm.ELM_DE_NAME%>','<%=CommonACBean.COLUMN_STATUS%>');">
														<%=CommonACBean.COLUMN_STATUS%>
														<%if (deSort.equals(CommonACBean.COLUMN_STATUS)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
												<th>
													<a title="Sort by <%=CommonACBean.COLUMN_CONTEXT%>" href="javascript:sort('<%=VMForm.ELM_DE_NAME%>','<%=CommonACBean.COLUMN_CONTEXT%>');">
														<%=CommonACBean.COLUMN_CONTEXT%>
														<%if (deSort.equals(CommonACBean.COLUMN_CONTEXT)) { %> <%=sortImgLink%> <% } %>
													</a>
												</th>
											</tr>
											<% for (int i =0; i<vDE.size(); i++) 
					              			{
					              				CommonACBean deBean = (CommonACBean)vDE.elementAt(i);
											%>
											<tr <% if(i%2 == 0) { %> class="rowColor" <% } %>>
												<td>
													<%=deBean.getLongName()%>
												</td>
												<td>
													<a title="View Detail" href="javascript:openBrowserWindow('<%=deBean.getBrowserURL()%>');"> 
														<%=deBean.getPublicID()%> 
													</a>
												</td>
												<td>
													<%=deBean.getVersion()%>
												</td>
												<td>
													<%=deBean.getWorkflowStatus()%>
												</td>
												<td>
													<%=deBean.getContext()%>
												</td>
											</tr>
											<tr <% if(i%2 == 0) { %> class="rowColor" <% } %>>
												<td colspan="5">
													<div class="ind3">
														<b>
															Definition:
														</b>
														<br>
															<%=deBean.getDefinition()%>
													</div>
												</td>
											</tr>
											<% } %>
										</tbody>
									</table>
								</div>
							<% } %>
							<hr>
							<div align="right">
								 <a href="javascript:setFocusTo('startTop');"><img src="Assets/returntotop.gif" border="0" alt="Return to Top"> Return to Top</a>
							</div>
						</div>
						<div style="display:none">
							<input type="hidden" name="<%=VMForm.ELM_AC_TYPE%>" value="">
							<input type="hidden" name="<%=VMForm.ELM_FIELD_TYPE%>" value="">
						</div>
					</form>
					<div style="display:none">
						<form name="SearchActionForm" method="post" action="">
							<input type="hidden" name="searchComp" value="">
							<input type="hidden" name="searchEVS" value="ValueMeaningEdit">
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
