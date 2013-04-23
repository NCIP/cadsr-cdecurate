<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">
<html>

<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
<%@ page language="java" import="java.util.*"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.database.Alternates"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<sj:head jqueryui="true" jquerytheme="custom" customBasepath="themes"
	loadAtOnce="false" />
<link href="styles/layout.css" rel="stylesheet" type="text/css" />
<link href="styles/custom.css" rel="stylesheet" type="text/css" />
<link href="css/FullDesignArial-VD.css" rel="stylesheet" type="text/css">

<script type="text/javascript" src="js/showcase.js"></script>
<SCRIPT LANGUAGE="JavaScript" SRC="js/PermissibleValues.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="js/VDPVS.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="js/date.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>

<title>Permissible Value</title>
<%
	String sMenuAction = (String) session
			.getAttribute(Session_Data.SESSION_MENU_ACTION);
	String sSearchAC = (String) session.getAttribute("creSearchAC");
	String vocab = (String) session.getAttribute("preferredVocab");
	if (vocab == null)
		vocab = "";

	//for view only page
	String bodyPage = (String) request.getAttribute("IncludeViewPage");
	boolean isView = false;
	if (bodyPage != null && !bodyPage.equals(""))
		isView = true;

	VD_Bean m_VD = new VD_Bean();
	String vdId = "";
	if (isView) {
		vdId = (String) request.getAttribute("viewVDId");
		String viewVD = "viewVD" + vdId;
		m_VD = (VD_Bean) session.getAttribute(viewVD);
	} else {
		m_VD = (VD_Bean) session.getAttribute("m_VD");
	}
	if (m_VD == null)
		m_VD = new VD_Bean();
	UtilService util = new UtilService();
	String sVDIDSEQ = m_VD.getVD_VD_IDSEQ();
	if (sVDIDSEQ == null)
		sVDIDSEQ = "";
	String sConDomID = m_VD.getVD_CD_IDSEQ();
	if (sConDomID == null)
		sConDomID = ""; //"";
	String sConDom = m_VD.getVD_CD_NAME();
	if (sConDom == null)
		sConDom = ""; //"";
	String sTypeFlag = m_VD.getVD_TYPE_FLAG();
	if (!isView) {
		if (sTypeFlag == null)
			sTypeFlag = "E";
		session.setAttribute("pageVDType", sTypeFlag);
	}
	//get parent attributes
	String sLastAction = (String) request.getAttribute("LastAction");
	if (sLastAction == null)
		sLastAction = "";
	Vector vParentNames = new Vector();
	Vector vParentCodes = new Vector();
	Vector vParentDB = new Vector();
	Vector vParentMetaSource = new Vector();
	Vector vdParent = m_VD.getReferenceConceptList(); // (Vector) session.getAttribute("VDParentConcept");
	if (vdParent == null)
		vdParent = new Vector();
	int vdCONs = 0;
	//reset the pv bean
	PV_Bean m_PV = new PV_Bean();
	session.setAttribute("m_PV", m_PV);
	String sVDType = (String) session.getAttribute("VDType");
	if (sVDType == null)
		sVDType = "";
	//use the pv bean to store vd-pv related attributes
	Vector vVDPVList = m_VD.getVD_PV_List(); // (Vector) session.getAttribute("VDPVList");
	if (vVDPVList == null)
		vVDPVList = new Vector();
	boolean[] editingDisabled = new boolean[vVDPVList.size()];
	Vector vPVIDList = new Vector();
	Vector vQuest = (Vector) session.getAttribute("vQuestValue");
	if (vQuest == null)
		vQuest = new Vector();
	Vector vQVList = (Vector) session.getAttribute("NonMatchVV");
	if (vQVList == null)
		vQVList = new Vector();
	String sPVRecs = "No ";
	int vdPVs = 0;
	if (vVDPVList.size() > 0) {
		//loop through the list to get no of non deleted pvs
		for (int i = 0; i < vVDPVList.size(); i++) {
			PV_Bean pvBean = (PV_Bean) vVDPVList.elementAt(i);
			if (pvBean == null)
				pvBean = new PV_Bean();
			String sSubmit = pvBean.getVP_SUBMIT_ACTION();
			//go to next item if deleted
			if (sSubmit != null && sSubmit.equals("DEL"))
				continue;
			vdPVs += 1;
		}
		//add pvrecords if exists.
		if (vdPVs > 0) {
			Integer iPVRecs = new Integer(vdPVs);
			sPVRecs = iPVRecs.toString();
		}
	}
	//get new pv attributes
	PV_Bean newPV = (PV_Bean) session.getAttribute("NewPV");
	if (newPV == null)
		newPV = new PV_Bean();
	VM_Bean newVM = (VM_Bean) newPV.getPV_VM();
	if (newVM == null)
		newVM = new VM_Bean();
	Vector newVMCon = newVM.getVM_CONCEPT_LIST();
	if (newVMCon == null)
		newVMCon = new Vector();
	String newPVorg = newPV.getPV_VALUE_ORIGIN();
	if (newPVorg.equals(""))
		newPVorg = "Search";
	String newPVed = newPV.getPV_END_DATE();
	if (newPVed.equals(""))
		newPVed = "MM/DD/YYYY";
	String newVV = newPV.getQUESTION_VALUE();
	if (newVV == null)
		newVV = "";
	String newVVid = newPV.getQUESTION_VALUE_IDSEQ();
	if (newVVid == null)
		newVVid = "";

	String pgAction = (String) request
			.getAttribute("refreshPageAction");
	if (pgAction == null)
		pgAction = "";
	String elmFocus = (String) request.getAttribute("focusElement");
	if (elmFocus == null)
		elmFocus = "";
	if (!isView) {
		session.setAttribute("PVAction", "");
	}
	//moved to vdpvs tab
	session.setAttribute(VMForm.SESSION_SELECT_VM, new VM_Bean()); //should clear when refreshed
	Vector vEMsg = (Vector) session.getAttribute("VMEditMsg");
	if (vEMsg == null)
		vEMsg = new Vector();
	String sErrAC = (String) request.getAttribute("ErrMsgAC");
	boolean conceptMatch = false;
	for (int k = 0; k < vEMsg.size(); k++) {
		VM_Bean vBean = (VM_Bean) vEMsg.elementAt(k);
		if (vBean.getVM_COMMENT_FLAG().equals("Concept matches.")) {
			conceptMatch = true;
			break;
		}
	}
	if (sErrAC == null)
		sErrAC = "";
	String vmMatch = (String) request.getAttribute("vmNameMatch");
	if (vmMatch == null)
		vmMatch = "false";
	Integer editPV = (Integer) request.getAttribute("editPVInd");
	String sEditPV = "";
	if (editPV != null)
		sEditPV = editPV.toString();
	if (sEditPV.equals("-1"))
		sEditPV = "pvNew";
	else if (!sEditPV.equals(""))
		sEditPV = "pv" + sEditPV;
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
         <%String statusMessage = (String) session
					.getAttribute(Session_Data.SESSION_STATUS_MESSAGE);
			Vector vStat = (Vector) session.getAttribute("vStatMsg");
			//if (vStat != null)
			//System.out.println("pv status " + statusMessage + " vector " + vStat.size());
			//check if the status message is too long
			if (vStat != null && vStat.size() > 20) {%>
				      	displayStatusWindow();
				    <%} else if (!isView && statusMessage != null
					&& !statusMessage.equals("")) {%>
					  	alert("<%=statusMessage%>");
					  <%}
			session.setAttribute(Session_Data.SESSION_STATUS_MESSAGE, "");%>        
        }
		</SCRIPT>
</head>

<body onload="onLoad('<%=elmFocus%>');hideCloseButton(<%=isView%>);">
	<table width="100%" border="2" cellpadding="0" cellspacing="0">
		<%
			if (!isView) {
		%>
		<tr>
			<td height="95" valign="top"><%@ include file="TitleBar.jsp"%>
			</td>
		</tr>
		<%
			}
		%>
		<tr>
			<td width="100%" valign="top">
				<form name="PVForm" method="POST"
					action="../../cdecurate/NCICurationServlet?reqType=pvEdits">
					<%
						String displayErrorMessage = (String) session
								.getAttribute("displayErrorMessage");
						if ((displayErrorMessage != null)
								&& (displayErrorMessage).equals("Yes")) {
					%>
					<b><font size="3">Not Authorized for Edits in this
							Context.</font> </b></br> </br>
					<%
						}
					%>
					<jsp:include page="VDPVSTab.jsp" flush="true" />
					<div
						style="margin-left: 0in; margin-right: 0in; border-left: 2px solid black; border-bottom: 2px solid black; border-right: 2px solid black; width: 100%; padding: 0.1in 0in 0.1in 0in">
						<s:url var="pvDetailsUrl" value="permissibleValueDetails.jsp" />
						<sj:div href="%{pvDetailsUrl}" />
					</div>
					<div style="display:none;">
						<input type="hidden" name="hideDatePick"
							oncalendar="appendDate(this.value);"> <input
							type="hidden" name="pageAction" value="nothing"> <input
							type="hidden" name="editPVInd" value="<%=sEditPV%>">
						<!-- keep this if there was error -->
						<input type="hidden" name="currentPVInd" value=""> <input
							type="hidden" name="currentElmID" value=""> <input
							type="hidden" name="currentPVViewType" value=""> <input
							type="hidden" name="currentOrg" value=""> <input
							type="hidden" name="currentBD" value=""> <input
							type="hidden" name="currentED" value=""> <input
							type="hidden" name="currentVM" value=""> <select
							name="PVViewTypes" size="1" style="visibility:hidden;width:100;"
							multiple>
							<%
								for (int i = 0; vVDPVList.size() > i; i++) {
									PV_Bean pvBean = (PV_Bean) vVDPVList.elementAt(i);
									String viewType = "expand";
									if (pvBean != null && pvBean.getPV_VIEW_TYPE() != null)
										viewType = (String) pvBean.getPV_VIEW_TYPE();
							%>
							<option value="<%=viewType%>" selected>
								<%=viewType%>
							</option>
							<%
								}
							%>
						</select> <input type="hidden" name="hiddenParentName" value=""> <input
							type="hidden" name="hiddenParentCode" value=""> <input
							type="hidden" name="hiddenParentDB" value=""> <input
							type="hidden" name="hiddenParentListString" value=""> <select
							name="ParentNames" size="1" style="visibility:hidden;width:100;"
							multiple>
							<%
								if (vParentNames != null) {
									for (int i = 0; vParentNames.size() > i; i++) {
										String sParentName = (String) vParentNames.elementAt(i);
										String sParNameJsp = util
												.parsedStringDoubleQuoteJSP(sParentName);
							%>
							<option value="<%=sParNameJsp%>">
								<%=sParentName%>
							</option>
							<%
								}
								}
							%>
						</select> <select name="ParentCodes" size="1"
							style="visibility:hidden;width:100;" multiple>
							<%
								if (vParentCodes != null) {
									for (int i = 0; vParentCodes.size() > i; i++) {
										String sParentCode = (String) vParentCodes.elementAt(i);
							%>
							<option value="<%=sParentCode%>">
								<%=sParentCode%>
							</option>
							<%
								}
								}
							%>
						</select> <select name="ParentDB" size="1"
							style="visibility:hidden;width:100;" multiple>
							<%
								if (vParentDB != null) {
									for (int i = 0; vParentDB.size() > i; i++) {
										String sParentDB = (String) vParentDB.elementAt(i);
							%>
							<option value="<%=sParentDB%>">
								<%=sParentDB%>
							</option>
							<%
								}
								}
							%>
						</select> <select name="ParentMetaSource" size="1"
							style="visibility:hidden;width:100;" multiple>
							<%
								if (vParentDB != null) {
									for (int i = 0; vParentMetaSource.size() > i; i++) {
										String sParentMetaSource = (String) vParentMetaSource
												.elementAt(i);
							%>
							<option value="<%=sParentMetaSource%>">
								<%=sParentMetaSource%>
							</option>
							<%
								}
								}
							%>
						</select> <input type="hidden" name="selectedParentConceptName" value="">
						<input type="hidden" name="selectedParentConceptCode" value="">
						<input type="hidden" name="selectedParentConceptDB" value="">
						<input type="hidden" name="selectedParentConceptMetaSource"
							value="">
						<%
							if (sMenuAction != null)
						%>
						<input type="hidden" name="MenuAction" value="<%=sMenuAction%>">
						<input type="hidden" name="pvSortColumn" value=""> <input
							type="hidden" name="openToTree" value=""> <input
							type="hidden" name="actSelect" value=""> <input
							type="hidden" name="listVDType" value="<%=sTypeFlag%>">
						<!-- stores the selected rows to get the bean from the search results -->
						<select name="hiddenSelRow" size="1"
							style="visibility:hidden;width:160" multiple></select>
						<!-- use both name and id -->
						<select id="hiddenConVM" name="hiddenConVM" size="1"
							style="visibility:hidden;width:160" multiple></select> <input
							type="hidden" name="acSearch" value="">
					</div>
				</form>
			</td>
		</tr>
	</table>
	<div style="display:none">
		<form name="SearchActionForm" method="post" action="">
			<%
				if (sSearchAC != null)
			%>
			<input type="hidden" name="searchComp" value="<%=sSearchAC%>">
			<input type="hidden" name="searchEVS" value="ValueDomain"> <input
				type="hidden" name="isValidSearch" value="true"> <input
				type="hidden" name="CDVDcontext" value=""> <input
				type="hidden" name="SelContext" value=""> <input
				type="hidden" name="acID" value="<%=sVDIDSEQ%>"> <input
				type="hidden" name="CD_ID" value="<%=sConDomID%>"> <input
				type="hidden" name="itemType" value=""> <input type="hidden"
				name="SelCDid" value="<%=sConDomID%>">
		</form>
	</div>
	<script language="javascript">
//put the pv in edit mode after cancel the duplicate to make sure that user completes the action
<%if (pgAction.equals("restore") || pgAction.equals("openNewPV")) {%>
    var objs = document.getElementsByName("editPVInd");
	<%if (!sEditPV.equals("") && !sEditPV.equals("pvNew")) {%>
		objs[0].value = "";
		view(<%=sEditPV%>View, <%=sEditPV%>ImgEdit, <%=sEditPV%>ImgSave, 'edit', '<%=sEditPV%>');
	<%}%>
	objs[0].value = "<%=sEditPV%>";
<%}%>
</script>
</body>
</html>
