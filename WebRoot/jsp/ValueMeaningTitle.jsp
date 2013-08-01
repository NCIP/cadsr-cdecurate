<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/ValueMeaningTitle.jsp,v 1.16 2009-04-21 19:08:14 veerlah Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%  
     //for view only page
	  String bodyPage = (String) request.getAttribute("IncludeViewPage");
	  boolean isView = false;
      if (bodyPage != null && !bodyPage.equals(""))
			isView = true;
      //UtilService serUtil = new UtilService();
      Session_Data sData = (Session_Data) session.getAttribute(Session_Data.CURATION_SESSION_ATTR);
      String userName = (String) session.getAttribute("Username");
      String disabled = "";
      boolean isSuperUser = false;
      if (userName != null){
        isSuperUser = sData.UsrBean.isSuperuser();
      }
      disabled = (isSuperUser) ? "" : "disabled";
      String sMenuAction = (String)session.getAttribute(Session_Data.SESSION_MENU_ACTION);
      String detailFocus = "TABX";
      String usedFocus = "TABX";
      String sTabFocus = (String)session.getAttribute(VMForm.SESSION_VM_TAB_FOCUS);
      
      if (sTabFocus == null || sTabFocus.equals(""))
      	sTabFocus = VMForm.ELM_ACT_DETAIL_TAB;
      if (sTabFocus.equals(VMForm.ELM_ACT_DETAIL_TAB))
      	detailFocus = "TABY";
      else
      	usedFocus = "TABY";
      String retPage = (String) session.getAttribute(VMForm.SESSION_RET_PAGE);	
      if(!isView){
        if(retPage.equals("backToPV"))
           retPage = VMForm.ACT_BACK_PV;
        else
           retPage = VMForm.ACT_BACK_SEARCH;
        //System.out.println("retPAge"+retPage);
      }  
	 VMForm dispForm = (VMForm)request.getAttribute(VMForm.REQUEST_FORM_DATA); 
	 String id = dispForm.getVMBean().getVM_IDSEQ();
      String vmNameDisplay = dispForm.vmDisplayName;
        String oldVer = (String)session.getAttribute("prevVMVersion");
   			String oldLN = (String)session.getAttribute("prevVMLN");
   			String oldWS = (String)session.getAttribute("prevVMWS");
   			String oldCN = (String)session.getAttribute("prevVMCN");
   	 String displayErrorMessagee = (String)session.getAttribute("displayErrorMessage");
     String fromm = "view";
    if ((displayErrorMessagee != null)&&(displayErrorMessagee).equals("Yes")){
       fromm = "edit";
    }		
		%>
   <script Language="JavaScript">
			var actionClear = "<%=VMForm.ACT_CLEAR_VM%>";
			var elmPageAction = "<%=VMForm.ELM_PAGE_ACTION%>";
	function BackFromEditVM(){
	 SubmitValidate('<%=retPage%>');
	}		
 </script>
<div class="ind1">
     
   <% if(!isView){ %>	
	<input type="button" name="btnValidate" value="Validate" onClick="SubmitValidate('<%=VMForm.ACT_VALIDATE_VM%>')" <%=disabled%>>
	&nbsp;&nbsp;
	<input type="button" name="btnClear" value="Clear" onClick="ClearBoxes();">
	&nbsp;&nbsp;
	<input type="button" name="btnBack" value="Back" onClick="SubmitValidate('<%=retPage%>');">
	&nbsp;&nbsp;
   <% } %>	
	<input type="button" name="btnAltName" value="Alt Names/Defs" <% if (isView) { %>
					onClick="openAltNameViewWindow();"
				<% } else { %>
					onClick="openDesignateWindow('Alternate Names');" 
				<% } %> >
	&nbsp;&nbsp;
	<%	if((displayErrorMessagee != null)&&(displayErrorMessagee).equals("Yes")){	%>
		<input type="button" name="btnBack" value="Back" <%if (isView){%>onClick="SubmitValidate('<%=VMForm.ACT_BACK_SEARCH%>');" <%}else{%>onClick="SubmitValidate('<%=retPage%>');"<%}%>>
		&nbsp;&nbsp;
	<% }else if (isView) {%>
	 <input type="button" id="btnClose" value="Close" onClick="window.close();">
	 &nbsp;&nbsp;
   <% } session.setAttribute("displayErrorMessage", "No");%> 	
	<img name="Message" src="images/WaitMessage1.gif" width="250px" height="20px" alt="WaitMessage" style="visibility:hidden;">
</div>
<div class="ind1">
	<b>
	<font size=4>
	      <% if(isView){ %>	
			  View Value Meaning -
		   <%}else{%> 
		     Edit Existing
			 <font color="#FF0000">
				Value Meaning
			 </font>
			-
		   <%}%>
    </font>
	<font size=3>
		<%=vmNameDisplay%>
	</font>
	</b>
</div>
<div class="ind1">
	<table style="width: 100%;">
		<colgroup>
			<col style="width: 10%" />
			<col style="width: 10%" />
			<col />
		</colgroup>
		<tr>
			<td id="<%=VMForm.ELM_ACT_DETAIL_TAB%>" class="<%=detailFocus%>" <% if (isView) { %>onclick="viewVMChangeTab('detailsTab','<%=id%>','<%=StringEscapeUtils.escapeJavaScript(fromm)%>');"<% } else { %>onclick="SubmitValidate('<%=VMForm.ELM_ACT_DETAIL_TAB%>');" <%}%>>
				<font size=2>
					<b>
						Details
					</b>
				</font>
			</td>
			<td id="<%=VMForm.ELM_ACT_USED_TAB%>" class="<%=usedFocus%>" <% if (isView) { %>onclick="viewVMChangeTab('whereUsedTab','<%=id%>','<%=StringEscapeUtils.escapeJavaScript(fromm)%>');"<% } else { %>onclick="SubmitValidate('<%=VMForm.ELM_ACT_USED_TAB%>');" <%}%>>
				<font size=2>
					<b>
						Where Used
					</b>
				</font>
			</td>
			<td style="border-bottom: 2px solid black" align="left" valign="middle">
			</td>
		</tr>
	</table>
</div>
<div style="display:none">
	<input type="hidden" name="<%=VMForm.ELM_PAGE_ACTION%>" value="<%=VMForm.ACT_PAGE_DEFAULT%>">
	<input type="hidden" name="<%=VMForm.ELM_MENU_ACTION%>" value="<%=sMenuAction%>">
	<input type="hidden" name="<%=VMForm.ELM_OPEN_TO_TREE%>" value="">
	<input type="hidden" name="<%=VMForm.ELM_SEL_CON_ROW%>" value="">
</div>
