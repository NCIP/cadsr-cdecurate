<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/ValueMeaningTitle.jsp,v 1.7 2009-01-19 20:19:32 veerlah Exp $
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
      String disabled = null;
      if(!isView){
       disabled = (sData.UsrBean.isSuperuser()) ? "" : "disabled";
      } 
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
        System.out.println("retPAge"+retPage);
      }  
	 VMForm dispForm = (VMForm)request.getAttribute(VMForm.REQUEST_FORM_DATA); 
      String vmNameDisplay = dispForm.vmDisplayName;
        String oldVer = (String)session.getAttribute("prevVMVersion");
   			String oldLN = (String)session.getAttribute("prevVMLN");
   			String oldWS = (String)session.getAttribute("prevVMWS");
   			String oldCN = (String)session.getAttribute("prevVMCN");
		%>
   <script Language="JavaScript">
			var actionClear = "<%=VMForm.ACT_CLEAR_VM%>";
			var elmPageAction = "<%=VMForm.ELM_PAGE_ACTION%>";
 </script>
<div class="ind1">
   <% if(!isView){ %>	
	<input type="button" name="btnValidate" value="Validate" style="width:125" onClick="SubmitValidate('<%=VMForm.ACT_VALIDATE_VM%>')" <%=disabled%>>
	&nbsp;&nbsp;
	<input type="button" name="btnClear" value="Clear" style="width:125" onClick="ClearBoxes();">
	&nbsp;&nbsp;
	<input type="button" name="btnBack" value="Back" style="width:125" onClick="SubmitValidate('<%=retPage%>');">
	&nbsp;&nbsp;
   <% } %>	
	<input type="button" name="btnAltName" value="Alt Names/Defs" style="width:150" <% if (isView) { %>
					onClick="openAltNameViewWindow();"
				<% } else { %>
					onClick="openDesignateWindow('Alternate Names');" 
				<% } %> >
	&nbsp;&nbsp;
   <%if (isView) {%>
	 <input type="button" name="btnClose" value="Close" style="width: 125" onClick="window.close();">
	 &nbsp;&nbsp;
   <% } %> 	
	<img name="Message" src="images/WaitMessage1.gif" width="250" height="20" alt="WaitMessage" style="visibility:hidden;">
</div>
<div class="ind1">
	<b>
	<font size=4>
	      <% if(isView){ %>	
			  View [<font color="#FF0000">Value Meaning</font>] -
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
			<td id="<%=VMForm.ELM_ACT_DETAIL_TAB%>" class="<%=detailFocus%>" <% if (isView) { %>onclick="viewVMChangeTab('detailsTab');"<% } else { %>onclick="SubmitValidate('<%=VMForm.ELM_ACT_DETAIL_TAB%>');" <%}%>>
				<font size=2>
					<b>
						Details
					</b>
				</font>
			</td>
			<td id="<%=VMForm.ELM_ACT_USED_TAB%>" class="<%=usedFocus%>" <% if (isView) { %>onclick="viewVMChangeTab('whereUsedTab');"<% } else { %>onclick="SubmitValidate('<%=VMForm.ELM_ACT_USED_TAB%>');" <%}%>>
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
