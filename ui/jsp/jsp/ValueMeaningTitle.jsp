<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/ValueMeaningTitle.jsp,v 1.1 2007-05-23 04:37:29 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
<%  
      //UtilService serUtil = new UtilService();
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
      	
			VMForm dispForm = (VMForm)request.getAttribute(VMForm.REQUEST_FORM_DATA); 
      String vmNameDisplay = dispForm.vmDisplayName;
      
		%>
<script Language="JavaScript">
			var actionClear = "<%=VMForm.ACT_CLEAR_VM%>";
			var elmPageAction = "<%=VMForm.ELM_PAGE_ACTION%>";
</script>
<div class="ind1">
	<input type="button" name="btnValidate" value="Validate" style="width:125" onClick="SubmitValidate('<%=VMForm.ACT_VALIDATE_VM%>')">
	&nbsp;&nbsp;
	<input type="button" name="btnClear" value="Clear" style="width:125" onClick="ClearBoxes();">
	&nbsp;&nbsp;
	<input type="button" name="btnBack" value="Back" style="width:125" onClick="SubmitValidate('<%=VMForm.ACT_BACK_PV%>');">
	&nbsp;&nbsp;
	<input type="button" name="btnAltName" value="Alt Names/Defs" style="width:150" onClick="openDesignateWindow('Alternate Names');">
	&nbsp;&nbsp;
	<img name="Message" src="Assets/WaitMessage1.gif" width="250" height="20" alt="WaitMessage" style="visibility:hidden;">
</div>
<div class="ind1">
	<font size=4>
		<b>
			Edit
			<font color="#FF0000">
				Value Meaning
			</font>
			-
		</b>
	</font>
	<font size=3>
		<%=vmNameDisplay%>
	</font>
</div>
<div class="ind1">
	<table style="width: 100%;">
		<colgroup>
			<col style="width: 10%" />
			<col style="width: 10%" />
			<col />
		</colgroup>
		<tr>
			<td id="<%=VMForm.ELM_ACT_DETAIL_TAB%>" class="<%=detailFocus%>" onclick="SubmitValidate('<%=VMForm.ELM_ACT_DETAIL_TAB%>');">
				<font size=2>
					<b>
						Details
					</b>
				</font>
			</td>
			<td id="<%=VMForm.ELM_ACT_USED_TAB%>" class="<%=usedFocus%>" onclick="SubmitValidate('<%=VMForm.ELM_ACT_USED_TAB%>');">
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
