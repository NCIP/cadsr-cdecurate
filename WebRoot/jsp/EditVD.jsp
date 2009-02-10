<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/EditVD.jsp,v 1.21 2009-02-10 20:57:56 veerlah Exp $
    $Name: not supported by cvs2svn $
-->

<html>
	<head>
		<title>
			Edit Value Domain
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<SCRIPT LANGUAGE="JavaScript" SRC="js/AddNewListOption.js"></SCRIPT>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%>
		<%@ page import="java.util.*"%>
		<%@ page session="true"%>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/date-picker.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/CreateVD.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/SelectCS_CSI.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/VDPVS.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%
			//for view only page
			String bodyPage = (String) request.getAttribute("IncludeViewPage");
			boolean isView = false;
			if (bodyPage != null && !bodyPage.equals(""))
				isView = true;

			String sOriginAction = (String) session.getAttribute("originAction");
			if (sOriginAction == null)
			   sOriginAction = "";
			Vector vStatus = (Vector) session.getAttribute("vStatusVD");
	        Vector vDataTypes = (Vector) session.getAttribute("vDataType");
			Vector vDataTypeDesc = (Vector) session.getAttribute("vDataTypeDesc");
			Vector vDataTypeCom = (Vector) session.getAttribute("vDataTypeComment");

			Vector vUOM = (Vector) session.getAttribute("vUOM");
			Vector vUOMFormat = (Vector) session.getAttribute("vUOMFormat");
	      //Vector vCD = (Vector) session.getAttribute("vCD");
		  //Vector vCDID = (Vector) session.getAttribute("vCD_ID");
		  //Vector vLanguage = (Vector) session.getAttribute("vLanguage");
			Vector vSource = (Vector) session.getAttribute("vSource");
			Vector vContext = (Vector) session.getAttribute("vWriteContextVD");
		  //Vector vContextID = (Vector) session.getAttribute("vWriteContextVD_ID");
			Vector vCS = (Vector) session.getAttribute("vCS");
			Vector vCS_ID = (Vector) session.getAttribute("vCS_ID");

			VD_Bean m_VD = new VD_Bean();
			String vdID = "";
			if (isView){
			   vdID = (String)request.getAttribute("viewVDId");
		       String viewVD = "viewVD" + vdID;
		       m_VD = (VD_Bean) session.getAttribute(viewVD);
			}else{
			   m_VD = (VD_Bean) session.getAttribute("m_VD");
			}   
			if (m_VD == null)
				m_VD = new VD_Bean();

			UtilService serUtil = new UtilService();
			String sMenuAction = (String) session.getAttribute(Session_Data.SESSION_MENU_ACTION);

			String sVDIDSEQ = m_VD.getVD_VD_IDSEQ();
			if (sVDIDSEQ == null)
				sVDIDSEQ = "";
			String sPublicVDID = m_VD.getVD_VD_ID();
			if (sPublicVDID == null)
				sPublicVDID = "";

			String selPropQRow = (String) session.getAttribute("selPropQRow");
			if (selPropQRow == null)
				selPropQRow = "";
			String selObjQRow = (String) session.getAttribute("selObjQRow");
			if (selObjQRow == null)
				selObjQRow = "";
			String selRepQRow = (String) session.getAttribute("selRepQRow");
			if (selRepQRow == null)
				selRepQRow = "";
			String selPropRow = (String) session.getAttribute("selPropRow");
			if (selPropRow == null)
				selPropRow = "";
			String selObjRow = (String) session.getAttribute("selObjRow");
			if (selObjRow == null)
				selObjRow = "";
			String selRepRow = (String) session.getAttribute("selRepRow");
			if (selRepRow == null)
				selRepRow = "";

			String sContext = m_VD.getVD_CONTEXT_NAME();
			if (sContext == null)
				sContext = "";
			String sContID = m_VD.getVD_CONTE_IDSEQ();
			if (sContID == null)
				sContID = "";
			//get the selected contexts
			Vector vSelectedContext = m_VD.getAC_SELECTED_CONTEXT_ID();

			String sObjQual = m_VD.getVD_OBJ_QUAL();
			sObjQual = serUtil.parsedStringDoubleQuoteJSP(sObjQual); //call the function to handle doubleQuote
			if (sObjQual == null)
				sObjQual = "";
			String sObjClass = m_VD.getVD_OBJ_CLASS();
			sObjClass = serUtil.parsedStringDoubleQuoteJSP(sObjClass); //call the function to handle doubleQuote
			if (sObjClass == null)
				sObjClass = "";
			String sPropQual = m_VD.getVD_PROP_QUAL();
			sPropQual = serUtil.parsedStringDoubleQuoteJSP(sPropQual); //call the function to handle doubleQuote
			if (sPropQual == null)
				sPropQual = "";
			String sPropClass = m_VD.getVD_PROP_CLASS();
			sPropClass = serUtil.parsedStringDoubleQuoteJSP(sPropClass); //call the function to handle doubleQuote
			if (sPropClass == null)
				sPropClass = "";
			String sRepTermID = m_VD.getVD_REP_IDSEQ();
			if (sRepTermID == null)
				sRepTermID = "";
			String sRepTerm = ""; //make the rep term using the concepts

			String sRepTermVocab = m_VD.getVD_REP_EVS_CUI_ORIGEN();
			if (sRepTermVocab == null || sRepTermVocab.equals("null"))
				sRepTermVocab = "";
			String sRepTerm_ID = m_VD.getVD_REP_CONCEPT_CODE();
			if (sRepTerm_ID == null || sRepTerm_ID.equals("null"))
				sRepTerm_ID = "";
			String sRepQualVocab = m_VD.getVD_REP_QUAL_EVS_CUI_ORIGEN();
			sRepQualVocab = serUtil.parsedStringDoubleQuoteJSP(sRepQualVocab); //call the function to handle doubleQuote
			if (sRepQualVocab == null || sRepQualVocab.equals("null"))
				sRepQualVocab = "";
			String sRepQualID = m_VD.getVD_REP_QUAL_CONCEPT_CODE();
			if (sRepQualID == null || sRepQualID.equals("null"))
				sRepQualID = "";

			Vector vRepQualifierNames = m_VD.getVD_REP_QUALIFIER_NAMES();
			if (vRepQualifierNames == null)
				vRepQualifierNames = new Vector();
			Vector vRepQualifierCodes = m_VD.getVD_REP_QUALIFIER_CODES();
			if (vRepQualifierCodes == null)
				vRepQualifierCodes = new Vector();
			Vector vRepQualifierDB = m_VD.getVD_REP_QUALIFIER_DB();
			if (vRepQualifierDB == null)
				vRepQualifierDB = new Vector();

			String sLongName = m_VD.getVD_LONG_NAME();
			sLongName = serUtil.parsedStringDoubleQuoteJSP(sLongName); //call the function to handle doubleQuote
			if (sLongName == null)
				sLongName = "";
			int sLongNameCount = sLongName.length();
			String sRepCCodeDB = m_VD.getVD_REP_EVS_CUI_ORIGEN();
			String sRepCCode = m_VD.getVD_REP_CONCEPT_CODE();
			String sRepTermPrimary = m_VD.getVD_REP_NAME_PRIMARY();
			if (sRepTermPrimary == null)
				sRepTermPrimary = "";
			if (sRepTermPrimary.equals("")) {
				sRepTermVocab = "";
				sRepTerm_ID = "";
			}

			String sRepQualLN = "";
			for (int i = 0; vRepQualifierNames.size() > i; i++) {
				if (i == 0)
					sRepQualLN = (String) vRepQualifierNames.elementAt(i);
				else
					sRepQualLN = sRepQualLN + " "
							+ (String) vRepQualifierNames.elementAt(i);
			}
			//add rep qual names to rep term
			if (sRepQualLN != null && !sRepQualLN.equals("")
					&& !sRepQualLN.equals(" "))
				sRepTerm = sRepQualLN;

			//get rep primary 
			if (!sRepTermPrimary.equals("") && !sRepTermPrimary.equals(" ")) {
				//add a space to rep term
				if (sRepTerm != null && !sRepTerm.equals(""))
					sRepTerm += " ";
				sRepTerm += sRepTermPrimary; //add rep term primary
			}
			sRepTerm = serUtil.parsedStringDoubleQuoteJSP(sRepTerm); //call the function to handle doubleQuote

			if (sRepCCodeDB == null)
				sRepCCodeDB = "";
			if (sRepCCode == null)
				sRepCCode = "";
			if (sRepTerm == null)
				sRepTerm = "";

			// Make Preferred Name for Obj Qual
			String sRepQualLong = "";
			for (int i = 0; vRepQualifierNames.size() > i; i++) {
				sRepQualLong = (String) vRepQualifierNames.elementAt(i);
				if (sRepQualLong == null)
					sRepQualLong = "";
			}
			boolean nameChanged = m_VD.getVDNAME_CHANGED();

			String sName = m_VD.getVD_PREFERRED_NAME();
			sName = serUtil.parsedStringDoubleQuoteJSP(sName); //call the function to handle doubleQuote
			if (sName == null)
				sName = "";
			int sNameCount = sName.length();
			String sPrefType = m_VD.getAC_PREF_NAME_TYPE();
			if (sPrefType == null)
				sPrefType = "";
			String lblUserType = "Existing Name (Editable)"; //make string for user defined label
			String sUserEnt = m_VD.getAC_USER_PREF_NAME();
			if (sUserEnt == null || sUserEnt.equals(""))
				lblUserType = "User Entered";

			String sDefinition = m_VD.getVD_PREFERRED_DEFINITION();
			if (sDefinition == null)
				sDefinition = "";
			String sObjDefinition = m_VD.getVD_Obj_Definition();
			if (sObjDefinition == null)
				sObjDefinition = "";
			String sPropDefinition = m_VD.getVD_Prop_Definition();
			if (sPropDefinition == null)
				sPropDefinition = "";
			String sRepDefinition = m_VD.getVD_Rep_Definition();
			if (sRepDefinition == null)
				sRepDefinition = "";

			String sCCode = ""; //m_VD.getVD_REF_CONCEPT_CODE();
			if (sCCode == null)
				sCCode = "";
			String sUMLS = ""; //m_VD.getVD_REF_UMLS_CUI();
			if (sUMLS == null)
				sUMLS = "";
			String sTEMP = ""; //m_VD.getVD_REF_TEMP_CUI();
			if (sTEMP == null)
				sTEMP = "";

			String sVersion = m_VD.getVD_VERSION();
			if (sVersion == null)
				sVersion = "1.0";
			String sStatus = m_VD.getVD_ASL_NAME();
			if (sStatus == null && sOriginAction.equals("BlockEditVD"))
				sStatus = "";
			else if (sStatus == null)
				sStatus = "DRAFT NEW";
			String sConDomID = m_VD.getVD_CD_IDSEQ();
			if (sConDomID == null)
				sConDomID = "";
			String sConDom = m_VD.getVD_CD_NAME();
			if (sConDom == null)
				sConDom = "";
			String sBeginDate = m_VD.getVD_BEGIN_DATE();
			if (sBeginDate == null)
				sBeginDate = "";
			String sUOML = m_VD.getVD_UOML_NAME();
			if (sUOML == null)
				sUOML = "";
			String sFORML = m_VD.getVD_FORML_NAME();
			if (sFORML == null)
				sFORML = "";
			String sLowValue = m_VD.getVD_LOW_VALUE_NUM();
			if (sLowValue == null)
				sLowValue = "";
			String sHighValue = m_VD.getVD_HIGH_VALUE_NUM();
			if (sHighValue == null)
				sHighValue = "";
			String sMaxLen = m_VD.getVD_MAX_LENGTH_NUM();
			if (sMaxLen == null)
				sMaxLen = "";

			String sMinLen = m_VD.getVD_MIN_LENGTH_NUM();
			if (sMinLen == null)
				sMinLen = "";
			String sCharSet = m_VD.getVD_CHAR_SET_NAME();
			if (sCharSet == null)
				sCharSet = "";
			String sDataType = m_VD.getVD_DATA_TYPE();
			if (sDataType == null || sOriginAction.equals("BlockEditVD"))
				sDataType = "";
			String sTypeFlag = m_VD.getVD_TYPE_FLAG();
			if (!isView) {
				if (sTypeFlag == null)
					sTypeFlag = "E";
				session.setAttribute("pageVDType", sTypeFlag);
			}
			String sEndDate = m_VD.getVD_END_DATE();
			if (sEndDate == null)
				sEndDate = "";
			String sDecimal = m_VD.getVD_DECIMAL_PLACE();
			if (sDecimal == null)
				sDecimal = "";
			String sChangeNote = m_VD.getVD_CHANGE_NOTE();
			if (sChangeNote == null)
				sChangeNote = "";

			//get parent attributes
			String sLastAction = (String) request.getAttribute("LastAction");
			if (sLastAction == null)
				sLastAction = "";
			Vector vParentNames = new Vector();
			Vector vParentCodes = new Vector();
			Vector vParentDB = new Vector();
			Vector vParentMetaSource = new Vector();
			Vector vdParent = m_VD.getReferenceConceptList(); // (Vector)session.getAttribute("VDParentConcept");
			if (vdParent == null)
				vdParent = new Vector();
			int vdCONs = 0;

			//use the pv bean to store vd-pv related attributes
			Vector vVDPVList = m_VD.getVD_PV_List(); // (Vector)session.getAttribute("VDPVList");
			if (vVDPVList == null)
				vVDPVList = new Vector();
			Vector vQVList = (Vector) session.getAttribute("NonMatchVV");
			if (vQVList == null)
				vQVList = new Vector();
			Vector vPVIDList = new Vector();
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
			if (!isView) {
				session.setAttribute("PVAction", "");
			}
			String sSource = m_VD.getVD_SOURCE();
			if (sSource == null)
				sSource = "";
			boolean bDataFound = false;
			//get the contact hashtable for the de
			Hashtable hContacts = m_VD.getAC_CONTACTS();
			if (hContacts == null)
				hContacts = new Hashtable();
			if (!isView) {
				session.setAttribute("AllContacts", hContacts);
			}
			//reset the pv bean
			//  PV_Bean m_PV = new PV_Bean();
			//  session.setAttribute("m_PV", m_PV);

			//cs-csi data
			Vector vSelCSList = m_VD.getAC_CS_NAME();
			if (vSelCSList == null)
				vSelCSList = new Vector();
			Vector vSelCSIDList = m_VD.getAC_CS_ID();
			Vector vACCSIList = m_VD.getAC_AC_CSI_VECTOR();
			Vector vACId = (Vector) session.getAttribute("vACId");
			Vector vACName = (Vector) session.getAttribute("vACName");
			//initialize the beans
			CSI_Bean thisCSI = new CSI_Bean();
			AC_CSI_Bean thisACCSI = new AC_CSI_Bean();
			int item = 1;

			String sSearchAC = (String) session.getAttribute("creSearchAC");
		    String displayErrorMessage = (String)session.getAttribute("displayErrorMessage");
		    String fromm = "view";
            if ((displayErrorMessage != null)&&(displayErrorMessage).equals("Yes")){
               fromm = "edit";
            }
		%>

		<SCRIPT LANGUAGE="JavaScript">
		 var helpUrl = "<%=ToolURL.getCurationToolHelpURL(pageContext)%>";
		
  var searchWindow = null;
  var evsTreeWindow = null;
  var pageOpening = "<%=sTypeFlag%>";
  //get all the cs_csi from the bean to array.
    
  var csiArray = new Array();  
  var selCSIArray = new Array();  //for selected csi list
  var selACCSIArray = new Array();  //for selected AC-csi list
  var writeContArray = new Array();

  function loadCSCSI()
  {
  <%
    Vector vCSIList = (Vector)session.getAttribute("CSCSIList");
    if (vCSIList != null){
    for (int i=0; i<vCSIList.size(); i++)  //loop csi vector
    {
      thisCSI = (CSI_Bean)vCSIList.elementAt(i);  //get the csi bean
   %>
      //create new csi object
      var aIndex = <%=i%>;  //get the index
      var csID = "<%=thisCSI.getCSI_CS_IDSEQ()%>";  //get cs idseq
      var csiID = "<%=thisCSI.getCSI_CSI_IDSEQ()%>";
      var cscsiID = "<%=thisCSI.getCSI_CSCSI_IDSEQ()%>";
      var p_cscsiID = "<%=thisCSI.getP_CSCSI_IDSEQ()%>";
      var disp = "<%=thisCSI.getCSI_DISPLAY_ORDER()%>";
      var label = "<%=thisCSI.getCSI_LABEL()%>";
      var csi_name = "<%=thisCSI.getCSI_NAME()%>";
      var cs_name = "<%=thisCSI.getCSI_CS_LONG_NAME()%>";
      var level = "<%=thisCSI.getCSI_LEVEL()%>";
      //create multi dimentional array with csi attributes 
      csiArray[aIndex] = new Array(csID, csiID, cscsiID, p_cscsiID, disp, label, csi_name, cs_name, level);       
    <%  }    %>
      loadSelCSCSI();  //load the existing relationship
      loadWriteContextArray();  //load the writable contexts 
     <%  }    %>  
  }

   function loadSelCSCSI()
   {
<%       
      if (vACCSIList != null)
      {      
        for (int j=0; j<vACCSIList.size(); j++)  //loop csi vector
        {
          thisACCSI = (AC_CSI_Bean)vACCSIList.elementAt(j);  //get the csi bean
          thisCSI = (CSI_Bean)thisACCSI.getCSI_BEAN();
 %>
          //create new accsi object
          var aIndex = <%=j%>;  //get the index
          var selACCSI_id = "<%=thisACCSI.getAC_CSI_IDSEQ()%>";
          var selAC_id = "<%=thisACCSI.getAC_IDSEQ()%>";
          var selAC_prefName = "<%=thisACCSI.getAC_PREFERRED_NAME()%>";
          <% //parse the string for quotation character
            String acName = thisACCSI.getAC_LONG_NAME();
            acName = serUtil.parsedStringDoubleQuote(acName);%>
          var selAC_longName = "<%=acName%>";
          var selAC_type = "<%=thisACCSI.getAC_TYPE_NAME()%>";
          //use csi bean
          var selCS_id = "<%=thisCSI.getCSI_CS_IDSEQ()%>";   //use csi bean  "<%=thisACCSI.getCS_IDSEQ()%>";  //get cs idseq
          var selCS_name = "<%=thisCSI.getCSI_CS_LONG_NAME()%>";    //use csi bean   "<%=thisACCSI.getCS_LONG_NAME()%>";          
          var selCSI_id = "<%=thisCSI.getCSI_CSI_IDSEQ()%>";    //use csi bean   //"<%=thisACCSI.getCSI_IDSEQ()%>";
          var selCSI_name = "<%=thisCSI.getCSI_NAME()%>";      //use csi bean  //"<%=thisACCSI.getCSI_NAME()%>";
          var selCSCSI_id = "<%=thisCSI.getCSI_CSCSI_IDSEQ()%>"; //use csi bean  //"<%=thisACCSI.getCSCSI_IDSEQ()%>";
          var selCSILevel = "<%=thisCSI.getCSI_LEVEL()%>";
          var selCSILabel = "<%=thisCSI.getCSI_LABEL()%>";
          var selP_CSCSIid = "<%=thisCSI.getP_CSCSI_IDSEQ()%>";
          var selCSIDisp = "<%=thisCSI.getCSI_DISPLAY_ORDER()%>";
          if (eval(selCSILevel) > 1)
             selCSI_name = getTabSpace(selCSILevel, selCSI_name);
          //store selected value in ac-csi array with accsi attributes 
          selACCSIArray[aIndex] = new Array(selCS_id, selCS_name, selCSI_id, selCSI_name, 
              selCSCSI_id, selACCSI_id, selAC_id, selAC_longName, selP_CSCSIid, 
              selCSILevel, selCSILabel, selCSIDisp);
<%      } %>   
        //call the method to fill selCSIArray
        makeSelCSIList();
<%   }   %>
   }

  //make the context array
  function loadWriteContextArray()
  {
    <% if (vContext != null) 
    {
      for (int i = 0; vContext.size()>i; i++)
      {
        String sContextName = (String)vContext.elementAt(i);
    %>
        var aIndex = <%=i%>;  //get the index
        var sContName = "<%=sContextName%>";
        writeContArray[aIndex] = new Array(sContName);
    <%}
    }   %>  
  }
  
  function displayStatusMessage()
  {
 <%
    String statusMessage = (String)session.getAttribute(Session_Data.SESSION_STATUS_MESSAGE);
    Vector vStat = (Vector)session.getAttribute("vStatMsg");
    //close the opener window if there is error
    if (statusMessage != null && !statusMessage.equals(""))
    {%>
        if (searchWindow && !searchWindow.closed)
            searchWindow.close();    
    <%}
    //check if the status message is too long
    if (vStat != null && vStat.size() > 30)
    {%>
      displayStatusWindow();
    <% }
    else if (!isView && statusMessage != null && !statusMessage.equals(""))
    {%>
	       alert("<%=statusMessage%>");
    <% }
    //reset the status message to no message
        session.setAttribute(Session_Data.SESSION_STATUS_MESSAGE, "");
   
%>
  }
 
function setup()
{
    RepTerm.innerText = "<%=sRepTermVocab%>";
    RepTermID.innerText = "<%=sRepTerm_ID%>";
    var selDType = document.createVDForm.tfLowValue.value;
}

</SCRIPT>
	</head>

	<body onLoad="setup();">
		<form name="createVDForm" method="POST" action="../../cdecurate/NCICurationServlet?reqType=editVD">
		    <% if ((displayErrorMessage != null)&&(displayErrorMessage).equals("Yes")){ %>
		  	 <b><font  size="3">Not Authorized for Edits in this Context.</font></b></br></br>
	       <%}%>
			<!-- include the vdpvstab.jsp here -->
			<jsp:include page="VDPVSTab.jsp" flush="true" />
			<div style="margin-left: 0in; margin-right: 0in; border-left: 2px solid black; border-bottom: 2px solid black; border-right: 2px solid black; width: 100%; padding: 0.1in 0in 0.1in 0in">
				<table width="100%">
					<col width="4%">
					<col width="96%">
		<%
			if (sOriginAction.equals("BlockEditVD")) {
		%>
					<tr height="25" valign="bottom">
						<td align=right>
							<font color="#C0C0C0">
								<%=item++%>
								)
							</font>
						</td>
						<td>
							<font color="#C0C0C0">
								Context
							</font>
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td height="26">
							<select name="selContext" size="1" readonly>
								<option value="<%=sContID%>">
									<font color="#C0C0C0">
										<%=sContext%>
									</font>
								</option>
							</select>
						</td>
					</tr>
	  <%
	  	} else {
	  %>
				<tr height="25" valign="bottom">
					<td align=right><%if (!isView){%>
						<font color="#FF0000">
							*
							&nbsp;&nbsp;
						</font><%}%>
						<%=item++%>
						)
					</td>
					<td colspan=4>
							Context
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td height="26">
						<% if (!isView) { %>
						<select name="selContext" size="1">
							<option value="<%=sContID%>">
									<%=sContext%>
							</option>
						</select>
						<% } else { %>
							<input type="text" size="8" value="<%=sContext%>" readonly>
						<% } %>
					</td>
				</tr>
	 <%
	 	}
	 %>

					<tr height="25" valign="bottom">
						<%
							if (sOriginAction.equals("BlockEditVD")) {
						%>
						<td align="right">
							<font color="#C0C0C0">
								<%=item++%>
								)
							</font>
						</td>
						<td>
							<font color="#C0C0C0">
								Value Domain Type
							</font>
						</td>
						<%
							} else {
						%>
						<td align="right">
						   <%if (!isView){%>
							<font color="#FF0000">
								* &nbsp;&nbsp;
							</font><%}%>
							<%=item++%>
							)
						</td>
						<td>
					<%
						if (!isView) {
					%>
						<font color="#FF0000">
							Select
						</font>
					<%
						}
					%>
								Value Domain Type
						</td>
						<%
							}
						%>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<%
								if (sOriginAction.equals("BlockEditVD")) {
							%>
							<select name="listVDType" size="1" style="width: 150" onChange="ToggleDisableList2();" disabled onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selVDType',helpUrl); return false">
								<option value="<%=sTypeFlag%>">
								</option>
							</select>
							<%
								} else if (!isView) {
							%>
							<select name="listVDType" size="1" style="width: 150" onChange="ToggleDisableList2();" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selVDType',helpUrl); return false">
								<option value="E" <%if(sTypeFlag.equals("E")){%> selected <%}%>>
									Enumerated
								</option>
								<option value="N" <%if(sTypeFlag.equals("N")){%> selected <%}%>>
									Non-Enumerated
								</option>
							</select>
							<% } else { %>
							 <input type="text" size="20" value=<%if(sTypeFlag.equals("E")){%>"Enumerated"<%}else{%>"Non-Enumerated"<%}%> readonly>
						   <% } %>
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
					   <%if (!isView){%>	
						<font color="#FF0000">
								* &nbsp;&nbsp;
							</font><%}%>
							<%=item++%>
							)
						</td>
						<td>
					<%
						if (!isView) {
					%>
						<font color="#FF0000">
							Select
						</font>
					<%
						}
					%>
							Value Domain Representation
						</td>
					</tr>
					<tr valign="bottom">
						<td colspan="2">
							<table border="0" width="75%">
								<col width="3%">
								<col width="55%">
								<tr valign="top">
									<td>
										&nbsp;
									</td>
									<!-- empty column to seperate componenets -->
									<!-- represention block -->
									<td>
										<table border="1" width="100%">
											<tr valign="top">
												<td>
													<table border="0" width="99%">
														<col width="26%">
														<col width="10%">
														<col width="14%">
														<col width="26%">
														<col width="10%">
														<col width="14%">
														<tr height="30" valign="middle">
															<td colspan=4>
																Value Domain Attributes
															</td>
														</tr>
														<tr>
															<td colspan="2" align="left" valign="top">
																Rep Term Long Name
															</td>
														</tr>
														<tr>
															<td colspan="5" align="left">
																<input type="text" name="txtRepTerm" value="<%=sRepTerm%>" style="width=100%" valign="top" readonly="readonly">
															</td>
														</tr>
														<tr height="8">
															<td></td>
														</tr>
														<tr valign="bottom">
															<td align="left" valign="top">
																Qualifier	Concepts
															</td>
															<td align="right" valign="middle">
																<!-- <input type="button" name="btnSerSecOC" value="Search" style="width:95%" onClick="javascript:SearchBuildingBlocks('ObjectQualifier', 'false');">-->
																<%
																	if (!isView) {
																%>
																<font color="#FF0000">
																	<a href="javascript:SearchBuildingBlocks('RepQualifier', 'false')">
																		Search
																	</a>
																</font>
																<%
																	}
																%>
															</td>
															<td align="center" valign="middle">
																<!-- <input type="button" name="btnRmSecOC" value="Remove" style="width:90%" onClick="javascript:removeQualifier();">-->
																<%
																	if (!isView) {
																%>
																<font color="#FF0000">
																	<a href="javascript:RemoveBuildingBlocks('RepQualifier')">
																		Remove
																	</a>
																</font>
																<%
																	}
																%>
															</td>
															<td align="left" valign="top">
																Primary	Concept
															</td>
															<td align="right" valign="middle">
																<!--<input type="button" name="btnSerPriOC" value="Search" style="width:95%" onClick="javascript:SearchBuildingBlocks('ObjectClass', 'false');">-->
																<%
																	if (!isView) {
																%>
																<font color="#FF0000">
																	<a href="javascript:SearchBuildingBlocks('RepTerm', 'false')">
																		Search
																	</a>
																</font>
																<%
																	}
																%>
															</td>
															<td align="center" valign="middle">
																<!--<input type="button" name="btnRmPriOC" value="Remove" style="width:90%" onClick="">-->
																<%
																	if (!isView) {
																%>
																<font color="#FF0000">
																	<a href="javascript:RemoveBuildingBlocks('RepTerm')">
																		Remove
																	</a>
																</font>
																<%
																	}
																%>
															</td>
														</tr>
														<tr align="left">
															<td colspan="3" valign="top">
																
																<select name="selRepQualifier" size="2" style="width=98%" valign="top" onClick="ShowEVSInfo('RepQualifier')" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_nameBlocks',helpUrl); return false">
																	<%
																		if (vRepQualifierNames.size() < 1) {
																	%>
																	<option value=""></option>
																	<%
																		} else {
																		for (int i = 0; vRepQualifierNames.size() > i; i++) {
																				String sQualName = (String) vRepQualifierNames.elementAt(i);
																	%>
																	<option value="<%=sQualName%>" <%if(i==0){%> selected <%}%>>
																		<%=sQualName%>
																	</option>
																	<%
																		}	}	%>
																</select>
													</td>
															
															<td colspan="3" valign="top">
																<select name="selRepTerm" style="width=98%" valign="top" size="1" multiple onHelp="showHelp('html/Help_CreateVD.html#createVDForm_nameBlocks',helpUrl); return false">
																	<option value="<%=sRepTermPrimary%>">
																		<%=sRepTermPrimary%>
																	</option>
																</select>
																										
															</td>
														</tr>
														<tr>
															<td colspan="3">
																&nbsp;&nbsp;
																<label id="RepQual" for="selRepQualifier" title=""></label>
															</td>
															<td colspan="3">
																&nbsp;&nbsp;
																<label id="RepTerm" for="selRepTerm" title=""></label>
															</td>
														</tr>
														<tr>
															<td colspan="3">
																&nbsp;&nbsp;
																<%if (!isView){%><a href=""><%}%>
																	<label id="RepQualID" for="selRepQualifier" title="" <%if (!isView){%>onclick="javascript:SearchBuildingBlocks('RepQualifier', 'true')"<%}%>></label>
																<%if (!isView){%></a><%}%>
															</td>
															<td colspan="3">
																&nbsp;&nbsp;
																<%if (!isView){%><a href=""><%}%>
																	<label id="RepTermID" for="selRepTerm" title="" <%if (!isView){%>onclick="javascript:SearchBuildingBlocks('RepTerm', 'true')"<%}%>></label>
																<%if (!isView){%></a><%}%>
															</td>
														</tr>
														<tr height="1">
															<td></td>
														</tr>
													</table>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr height="15"></tr>
					<tr valign="bottom" height="25">
						<%
							if (sOriginAction.equals("BlockEditVD")) {
						%>
						<td align="right">
							<font color="#C0C0C0">
								<%=item++%>
								)
							</font>
						</td>
						<td>
							<font color="#C0C0C0">
								Verify Value Domain Long Name (* ISO Preferred Name)
							</font>
						</td>
						<%
							} else {
						%>
						<td align="right">
						   <%if (!isView){%>
							<font color="#FF0000">
								* &nbsp;
							</font><%}%>
							<%=item++%>
							)
						</td>
						<td>
							<%
								if (!isView) {
							%>
							<font color="#FF0000">
								Verify
							</font>
							<%
								}
							%>
							Value Domain Long Name (* ISO Preferred Name)
						</td>
						<%
							}
						%>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td height="24" valign="top">
							<input name="txtLongName" type="text" size="100" maxlength=255 value="<%=sLongName%>" onKeyUp="changeCountLN();" <%if(sOriginAction.equals("BlockEditVD") || isView){%> readonly <%}%>
								onHelp="showHelp('html/Help_CreateVD.html#createVDForm_txtLongName',helpUrl); return false">
							&nbsp;&nbsp;
							<input name="txtLongNameCount" type="text" value="<%=sLongNameCount%>" size="1" readonly onHelp="showHelp('html/Help_CreateVD.html#createVDForm_txtLongName',helpUrl); return false">
							<%
								if (sOriginAction.equals("BlockEditVD")) {
							%>
							<font color="#C0C0C0">
								Character Count &nbsp;&nbsp;(Database Max = 255)
							</font>
							<%
								} else {
							%>
							<font color="#000000">
								Character Count &nbsp;&nbsp;(Database Max = 255)
							</font>
							<%
								}
							%>

						</td>
					</tr>
					<tr valign="bottom" height="25">
						<%
							if (sOriginAction.equals("BlockEditVD")) {
						%>
						<td align=right>
							<font color="#C0C0C0">
								<%=item++%>
								)
							</font>
						</td>
						<td>
							<font color="#C0C0C0">
								Update Value Domain Short Name
							</font>
						</td>
						<%
							} else {
						%>
						<td align=right>
						   <%if (!isView){%>
							<font color="#FF0000">
								* &nbsp;
							</font><%}%>
							<%=item++%>
							)
						</td>
						<td>
						<%
							if (!isView) {
						%>
							<font color="#FF0000">
								Update
							</font>
							<%
								}
							%>
							<font color="#000000">
								Value Domain Short Name
							</font>
						</td>
						<%
							}
						%>
					</tr>
					<%
						if (!sOriginAction.equals("BlockEditVD") && !isView) {
					%>
					<tr>
						<td>
							&nbsp;
						</td>
						<td height="24" valign="bottom">
							Select Short Name Naming Standard
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td height="24" valign="top">
							<input name="rNameConv" type="radio" value="SYS" onclick="javascript:SubmitValidate('changeNameType');" <%if (sPrefType.equals("SYS")) {%> checked <%}%>>
							System Generated &nbsp;&nbsp;&nbsp;
							<input name="rNameConv" type="radio" value="ABBR" onclick="javascript:SubmitValidate('changeNameType');" <%if (sPrefType.equals("ABBR")) {%> checked <%}%>>
							Abbreviated &nbsp;&nbsp;&nbsp;
							<input name="rNameConv" type="radio" value="USER" onclick="javascript:SubmitValidate('changeNameType');" <%if (sPrefType.equals("USER")) {%> checked <%}%>>
							<%=lblUserType%>
							<!--Existing Name (Editable)  User Maintained-->
						</td>
					</tr>
					<%
						}
					%>
					<tr>
						<td>
							&nbsp;
						</td>
						<td height="24" valign="top">
							<input name="txtPreferredName" type="text" size="100" maxlength=30 value="<%=sName%>" onKeyUp="changeCountPN();" <%if(sOriginAction.equals("BlockEditVD") || sPrefType.equals("") || sPrefType.equals("SYS") || sPrefType.equals("ABBR") || isView){%> readonly
								<%}%> onHelp="showHelp('html/Help_CreateVD.html#createVDForm_txtPreferredName',helpUrl); return false">
							&nbsp;&nbsp;
							<input name="txtPrefNameCount" type="text" value="<%=sNameCount%>" size="1" readonly onHelp="showHelp('html/Help_CreateVD.html#createVDForm_txtPreferredName',helpUrl); return false">
							<%
								if (sOriginAction.equals("BlockEditVD")) {
							%>
							<font color="#C0C0C0">
								Character Count &nbsp;&nbsp;(Database Max = 30)
							</font>
							<%
								} else {
							%>
							<font color="#000000">
								Character Count &nbsp;&nbsp;(Database Max = 30)
							</font>
							<%
								}
							%>
						</td>
					</tr>

					<tr height="25" valign="bottom">
					<%
						if (sOriginAction.equals("BlockEditVD")) {
					%>
						<td align=right>
							<font color="#C0C0C0">
								<%=item++%>
								)
							</font>
						</td>
						<td>
							<font color="#C0C0C0">
								Public ID
							</font>
						</td>
					<%
						} else {
					%>
					<td align=right>
					   <%if (!isView){%>	
						<font color="#FF0000">
							*&nbsp;&nbsp;
						</font><%}%>
							<%=item++%>
							)
					</td>
					<td>
							Public ID
					</td>
					<%
						}
					%>
				</tr>
					<tr>
						<td align=right>
							&nbsp;
						</td>
						<td>
							<font color="#C0C0C0">
								<input type="text" name="CDE_IDTxt" value="<%=sPublicVDID%>" size="20" readonly onHelp="showHelp('html/Help_CreateVD.html#createVDForm_CDE_IDTxt',helpUrl); return false">
							</font>
						</td>
					</tr>
					<tr>
						<td height="8" valign="top">
					</tr>
					<tr height="25" valign="top">
						<%
							if (sOriginAction.equals("BlockEditVD")) {
						%>
						<td align=right>
							<font color="#C0C0C0">
								<%=item++%>
								)
							</font>
						</td>
						<td>
							<font color="#C0C0C0">
								Create/Search for Definition
							</font>
						</td>
						<%
							} else {
						%>
						<td align=right>
						   <%if (!isView){%>	
							<font color="#FF0000">
								* &nbsp;
							</font><%}%>
							<%=item++%>
							)
						</td>
						<td>
						<%
							if (!isView) {
						%>
							<font color="#FF0000">
								Create/Edit
							</font>
						<%
							}
						%>
							Definition
						</td>
						<%
							}
						%>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td valign="top" align="left">
							<%
								if (sOriginAction.equals("BlockEditVD") || isView) {
							%>
							<textarea name="CreateDefinition" style="width:80%" rows=6 readonly onHelp="showHelp('html/Help_CreateVD.html#createVDForm_CreateDefinition',helpUrl); return false"><%=sDefinition%></textarea>
							<!--  &nbsp;&nbsp; <font color="#C0C0C0">Search</a></font> -->
							<%
								} else {
							%>
							<textarea name="CreateDefinition" style="width:80%" rows=6 onHelp="showHelp('html/Help_CreateVD.html#createVDForm_CreateDefinition',helpUrl); return false"><%=sDefinition%></textarea>
							<!-- &nbsp;&nbsp; <font color="#FF0000"> <a href="javascript:OpenEVSWindow()">Search</a></font> -->
							<%
								}
							%>
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<%
								if (!sOriginAction.equals("BlockEditVD") && (!isView)) {
							%>
							<font color="#FF0000">
								*&nbsp;&nbsp;&nbsp;
							</font>
							<%
								}
							%>
							<%=item++%>
							)
						</td>
						<td>
						<%
							if (!isView) {
						%>
							<font color="#FF0000">
								Select
								<font color="#000000">
						<%
							}
						%>
									Conceptual Domain
								</font>
							</font>
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<% if (!isView) { %>
							<select name="selConceptualDomain" size="1" style="width:430" multiple onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selConceptualDomain',helpUrl); return false">
								<option value="<%=sConDomID%>">
									<%=sConDom%>
								</option>
							</select>
							<% } else { %>
								<input type="text" size="69" value="<%=sConDom%>"readonly>
							<% } %>
							&nbsp;&nbsp;
						<%
							if (!isView) {
						%>
							<font color="#FF0000">
								<a href="javascript:SearchCDValue()">
									Search
								</a>
							</font>
						<%
							}
						%>
						</td>
					</tr>

					<tr height="25" valign="bottom">
						<td align=right>
							<%
								if (!sOriginAction.equals("BlockEditVD") && (!isView)) {
							%>
							<font color="#FF0000">
								*&nbsp;
							</font>
							<%
								}
							%>
							<%=item++%>
							)
						</td>
						<td>
						<%
							if (!isView) {
						%>
							<font color="#FF0000">
								Select
								<font color="#000000">
						<%
							}
						%>
							Workflow Status
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
						<%
							if (!isView) {
						%>
							<select name="selStatus" size="1" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selStatus',helpUrl); return false">
								<option value="" selected="selected"></option>
								<%
									for (int i = 0; vStatus.size() > i; i++) {
											String sStatusName = (String) vStatus.elementAt(i);
								%>
								<option value="<%=sStatusName%>" <%if (sStatusName.equals(sStatus)){ %> selected <%}%>>
									<%=sStatusName%>
								</option>
								<% } %>
								</select>
								<%	} else { %>
									<input type="text" size="22" value="<%=sStatus%>" readonly>
								<% } %>
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<%
							if (sOriginAction.equals("BlockEditVD")) {
						%>
						<td align=right>
							<%=item++%>
							)
						</td>
						<td height="25" valign="bottom">
							<font color="#FF0000">
								Check
							</font>
							Box to Create New Version &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<a href="<%=ToolURL.getCurationToolBusinessRulesURL(pageContext)%>" target="_blank">
								Business Rules
							</a>
						</td>
						<%
							} else {
						%>
						<td align=right>
								<%=item++%>
								)
						</td>
						<td>
								Version
						</td>
						<%
							}
						%>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<%
							if (sOriginAction.equals("BlockEditVD")) {
						%>
						<td>
							<table width="50%">
								<col width="15%">
								<col width="10%">
								<col width="10%">
								<tr height="25">
									<!--Version check is checked only if the sVersion is either Whole or Point   -->
									<td valign="top">
										&nbsp;&nbsp;
										<input type="checkbox" name="VersionCheck" onClick="javascript:EnableChecks(checked,this);" value="ON" <% if(sVersion.equals("Whole") || sVersion.equals("Point")) { %> checked <% } %>
											onHelp="showHelp('html/Help_CreateVD.html#createVDForm_BlockVersion',helpUrl); return false">
									</td>
									<!--Point check is checked only if the sVersion is Point and disabled otherwise  -->
									<td>
										<input type="checkbox" name="PointCheck" onClick="javascript:EnableChecks(checked,this);" value="ON" <%if(sVersion.equals("Point")){%> checked <%} else {%> disabled <%}%>
											onHelp="showHelp('html/Help_CreateVD.html#createVDForm_BlockVersion',helpUrl); return false">
										&nbsp;Point Increase
									</td>
									<!--Whole check is checked only if the sVersion is Whole and disabled otherwise  -->
									<td>
										<input type="checkbox" name="WholeCheck" onClick="javascript:EnableChecks(checked,this)" value="ON" <%if(sVersion.equals("Whole")){%> checked <%} else {%> disabled <%}%>
											onHelp="showHelp('html/Help_CreateVD.html#createVDForm_BlockVersion',helpUrl); return false">
										&nbsp;Whole Increase
									</td>
								</tr>
							</table>
						</td>
						<%
							} else {
						%>
						<td valign="top">
								<input type="text" name="Version" value="<%=sVersion%>" size=5 readonly onHelp="showHelp('html/Help_CreateVD.html#createVDForm_Version',helpUrl); return false">
							&nbsp;&nbsp;&nbsp;
						   <% if (!isView){ %>
							<a href="<%=ToolURL.getCurationToolBusinessRulesURL(pageContext)%>" target="_blank">
								Business Rules
							</a>
						   <%}%>	
						</td>
						<%
							}
						%>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<%
								if (!sOriginAction.equals("BlockEditVD") && (!isView)) {
							%>
							<font color="#FF0000">
								*&nbsp;
							</font>
							<%
								}
							%>
							<%=item++%>
							)
						</td>
						<td>
						<%
							if (!isView) {
						%>
							<font color="#FF0000">
								Select
							</font>
						<%
							}
						%>
							Data Type
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<table width="90%" border="1">
								<col width="20%">
								<col width="35%">
								<col width="35%">
								<tr>
									<td valign="top">
									<%	if (!isView) { %>
										<select name="selDataType" size="1" onChange="javascript:changeDataType();" style="width:90%" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selDataType',helpUrl); return false">
											<%													
													for (int i = 0; vDataTypes.size() > i; i++) {
														String sDT = (String) vDataTypes.elementAt(i);
											%>
											<option value="<%=sDT%>"
												<%if(sDT.equalsIgnoreCase(sDataType)){%> selected <%}%>>
												<%=sDT%>
											</option>
											<% } %>
										</select>
								<%	} else { %>
								    <input type="text" size="35" value="<%=sDataType%>" readonly>
								
								<% } %>										
									</td>
									<% String sDTDesc = "", sDTComm = ""; 
										   int iDT = 0;
										   if (vDataTypes != null)
											  iDT = vDataTypes.indexOf(sDataType);
											if (iDT > 0)
											{
												if (vDataTypeDesc != null)
												  sDTDesc = (String) vDataTypeDesc.elementAt(iDT);
												if (vDataTypeCom != null)
												  sDTComm = (String) vDataTypeCom.elementAt(iDT);
												if (sDTDesc == null) sDTDesc = "";
												if (sDTComm == null) sDTComm = "";
											}
									%>
									<td valign="top" height="25">
										<b>
											Data Type Description:
										</b>
										<br>
										<label id="lblDTDesc" for="selDataType" style="width:95%" title=""><%=sDTDesc%></label>
									</td>
									<td valign="top" height="25">
										<b>
											Data Type Comment:
										</b>
										<br>
										<label id="lblDTComment" for="selDataType" style="width:95%" title=""><%=sDTComm%></label>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<%
						if (!sOriginAction.equals("BlockEditVD")) {
					%>
					<tr height="10">
						<td>
						</td>
					</tr>
					<tr valign="top">
						<td align=right>
						   <%if (!isView){%>
							<font color="#FF0000">
								*
							</font><%}%>
							<%=item++%>
							)
						</td>
						<td>
						<% if (!isView) { %>
							<font color="#FF0000">
								Maintain
							</font>
						<% } %>
							<%
								if (sTypeFlag.equals("E")) {
							%>
							Permissible Value
							<%
								} else {
							%>
							Referenced Value
							<%
								}
							%>
							<br>
							To view or maintain Permissible Values,<%if (isView){ %><a href="javascript:changeTab('PV','<%=StringEscapeUtils.escapeJavaScript(fromm)%>', '<%=vdID%>');"><%}else{%>
							<a href="javascript:SubmitValidate('vdpvstab');"><%}%>
								[click here]
							</a>
							&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
					</tr>
					<%
						}
					%>
					<tr height="15">
						<td>
						</td>
					</tr>
					<tr height="25" valign=bottom>
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
					<% if (!isView) { %>
						<font color="#FF0000">
							Enter/Select
						</font>
						<% } %>
							Effective Begin Date
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td valign="top">
							<input type="text" name="BeginDate" value="<%=sBeginDate%>" size="12" maxlength=10  <% if (isView) { %>readonly<%} %> onHelp="showHelp('html/Help_CreateVD.html#createVDForm_BeginDate',helpUrl); return false">
						<% if (!isView) { %>
							<a href="javascript:show_calendar('createVDForm.BeginDate', null, null, 'MM/DD/YYYY');">
								<img name="Calendar" src="images/calendarbutton.gif" width="22" height="22" alt="Calendar" style="vertical-align: top">
							</a>
						<% } %>
							&nbsp;&nbsp;MM/DD/YYYY
						</td>
					</tr>

					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
					<% if (!isView) { %>
						<font color="#FF0000">
							Enter/Select
						</font>
						<% } %>
							Effective End Date
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<input type="text" name="EndDate" value="<%=sEndDate%>" size="12" maxlength=10  <% if (isView) { %>readonly<%} %> onHelp="showHelp('html/Help_CreateVD.html#createVDForm_EndDate',helpUrl); return false">
						<% if (!isView) { %>
							<a href="javascript:show_calendar('createVDForm.EndDate', null, null, 'MM/DD/YYYY');">
								<img name="Calendar" src="images/calendarbutton.gif" width="22" height="22" alt="Calendar" style="vertical-align: top">
							</a>
						<% } %>
							&nbsp;&nbsp;MM/DD/YYYY
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
					<% if (!isView) { %>
						<font color="#FF0000">
							Select
						</font>
						<% } %>
							 Unit of Measure (UOM)
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
					<% if (!isView) { %>
							<select name="selUOM" size="1" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selUOM',helpUrl); return false">
								<option value="" selected></option>
								<%
									for (int i = 0; vUOM.size() > i; i++) {
										String sUOM = (String) vUOM.elementAt(i);
								%>
								<option value="<%=sUOM%>" <%if(sUOM.equals(sUOML)){%> selected <%}%>>
									<%=sUOM%>
								</option>
								<% } %>
							</select>
								<%	} else { %>
								     <input type="text" size="20" value="<%=sUOML%>" readonly>
								<% } %>
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
					<% if (!isView) { %>
						<font color="#FF0000">
							Select
						</font>
						<% } %>
							Display Format
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<% if (!isView) { %>
							<select name="selUOMFormat" size="1" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selUOMFormat',helpUrl); return false">
								<option value="" selected></option>
								<%
									for (int i = 0; vUOMFormat.size() > i; i++) {
										String sUOMF = (String) vUOMFormat.elementAt(i);
								%>
								<option value="<%=sUOMF%>" <%if(sUOMF.equals(sFORML)){%> selected <%}%>>
									<%=sUOMF%>
								</option>
								<% } %>
							</select>
							<%	} else { %>
							        <input type="text" size="20" value="<%=sFORML%>" readonly>
							<% } %>
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
					<% if (!isView) { %>
						<font color="#FF0000">
							Enter
						</font>
						<% } %>
							Minimum Length
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<input type="text" name="tfMinLength" value="<%=sMinLen%>" size="20" maxlength=8 <% if (isView) { %>readonly<%} %> onHelp="showHelp('html/Help_CreateVD.html#createVDForm_tfMinLength',helpUrl); return false">
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
					<% if (!isView) { %>
						<font color="#FF0000">
							Enter
						</font>
						<% } %>
							Maximum Length
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<input type="text" name="tfMaxLength" value="<%=sMaxLen%>" size="20" maxlength=8 <% if (isView) { %>readonly<%} %> onHelp="showHelp('html/Help_CreateVD.html#createVDForm_tfMaxLength',helpUrl); return false">
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
					<% if (!isView) { %>
						<font color="#FF0000">
							Enter
						</font>
						<% } %>
							Low Value (for number data type)
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<input type="text" name="tfLowValue" value="<%=sLowValue%>" size="20" maxlength=255 	<% if (isView) { %>readonly<%} %> 
								<% if (!sDataType.equalsIgnoreCase("NUMBER")) { %> disabled <% } %> 
								onHelp="showHelp('html/Help_CreateVD.html#createVDForm_tfLowValue',helpUrl); return false">
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
					<% if (!isView) { %>
						<font color="#FF0000">
							Enter
						</font>
						<% } %>
							High Value (for number data type)
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<input type="text" name="tfHighValue" value="<%=sHighValue%>" size="20" maxlength=255 <% if (isView) { %>readonly<%} %> 
								<% if (!sDataType.equalsIgnoreCase("NUMBER")) { %> disabled <% } %> 
								onHelp="showHelp('html/Help_CreateVD.html#createVDForm_tfHighValue',helpUrl); return false">
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
					<% if (!isView) { %>
						<font color="#FF0000">
							Enter
						</font>
						<% } %>
							Decimal Place
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<input type="text" name="tfDecimal" value="<%=sDecimal%>" size="20" maxlength=2 <% if (isView) { %>readonly<%} %> 
								onHelp="showHelp('html/Help_CreateVD.html#createVDForm_tfDecimal',helpUrl); return false">
						</td>
					</tr>
					<!-- Classification Scheme and items -->
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
					<% if (!isView) { %>
						<font color="#FF0000">
							Select
						</font>
						<% } %>
							Classification Scheme and Classification Scheme Items
						</td>
					</tr>

					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<table width=90% border=0>
								<col width="1%">
								<col width="38%">
								<col width="16%">
								<col width="38%">
								<col width="16%">
								<% if (!isView) { %>
								<tr>
									<td colspan=3 valign=top>
										<%
											if (sOriginAction.equals("BlockEditVD")) {
										%>
										<select name="selCS" size="1" style="width:97%" onChange="ChangeCS();" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_BlockselCS',helpUrl); return false">
											<%
												} else {
											%>
											<select name="selCS" size="1" style="width:97%" onChange="ChangeCS();" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selCS',helpUrl); return false">
												<%
													}
												%>
												<option value="" selected></option>
												<%if (vCS != null) 
													for (int i = 0; vCS.size() > i; i++) {
														String sCSName = (String) vCS.elementAt(i);
														String sCS_ID = "";
														if (vCS_ID != null)
														  sCS_ID = (String) vCS_ID.elementAt(i);
												%>
												<option value="<%=sCS_ID%>">
													<%=sCSName%>
												</option>
												<%
													}
												%>
											</select>
									</td>
									<td colspan=2 valign=top>
										<%
											if (sOriginAction.equals("BlockEditVD")) {
										%>
										<select name="selCSI" size="5" style="width:100%" onChange="selectCSI();" onClick="selectCSI();" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_BlockselCS',helpUrl); return false">
											<%
												} else {
											%>
											<select name="selCSI" size="5" style="width:100%" onChange="selectCSI();" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selCS',helpUrl); return false">
												<%
													}
												%>
											</select>
									</td>
								</tr>
								<%} %> 
								<tr>
									<td height="10" valign="top">
								</tr>
								
								<tr>
									<td>
										&nbsp;
									</td>
									<td>
										&nbsp;Selected Classification Schemes
									</td>
									<td>
									<%	if (!isView) {	%>
										<input type="button" name="btnRemoveCS" value="Remove Item" onClick="removeCSList();">
										<% } %>
									</td>
									<td>
										&nbsp;&nbsp;Associated Classification Scheme Items
									</td>
									<td>
										<%	if (!isView) {	%>
										<input type="button" name="btnRemoveCSI" value="Remove Item" onClick="removeCSIList();">
										<% } %>
									</td>
								</tr>
								<tr>
									<td>
										&nbsp;
									</td>
									<td colspan=2 valign=top>
										<%
											if (sOriginAction.equals("BlockEditVD")) {
										%>
										<select name="selectedCS" size="5" style="width:97%" multiple onchange="addSelectCSI(false, true, '');" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_BlockselCS',helpUrl); return false">
											<%
												} else {
											%>
											<select name="selectedCS" size="5" style="width:97%" multiple onchange="addSelectCSI(false, true, '');" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selCS',helpUrl); return false">
												<%
													}
												%>
												<%
													//store selected cs list on load 
													if (vSelCSIDList != null) {
														//           System.out.println("cs size " + vSelCSIDList.size());
														for (int i = 0; vSelCSIDList.size() > i; i++) {
															String sCS_ID = (String) vSelCSIDList.elementAt(i);
															String sCSName = "";
															if (vSelCSList != null && vSelCSList.size() > i)
																sCSName = (String) vSelCSList.elementAt(i);
															//             System.out.println("selected " + sCSName);
												%>
												<option value="<%=sCS_ID%>">
													<%=sCSName%>
												</option>
												<%
													}
													}
												%>
											</select>
									</td>
									<td colspan=2 valign=top>
										<%
											if (sOriginAction.equals("BlockEditVD")) {
										%>
										<select name="selectedCSI" size="5" style="width:100%" multiple onchange="addSelectedAC();" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_BlockselCS',helpUrl); return false">
											<%
												} else {
											%>
											<select name="selectedCSI" size="5" style="width:100%" multiple <% if (!isView) { %>onchange="addSelectedAC();" <% } %> onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selCS',helpUrl); return false">
												<%
													}
												%>
											</select>
									</td>
								</tr>
								<%
									if (sOriginAction.equals("BlockEditVD")) {
								%>
								<tr>
									<td height="12" valign="top">
								</tr>
								<tr>
									<td colspan=3>
										&nbsp;
									</td>
									<td colspan=2 valign=top>
										&nbsp;Value Domains containing selected Classification Scheme Items
									</td>
								</tr>
								<tr>
									<td colspan=3 valign=top>
										&nbsp;
									</td>
									<td colspan=2 valign=top>
										<select name="selCSIACList" size="3" style="width:100%" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_BlockselCS',helpUrl); return false">
										</select>
									</td>
								</tr>
								<%
									}
								%>
							</table>
						</td>
						<td>
							&nbsp;
						</td>
					</tr>
					<!-- contact info -->
					<%
						if (!sOriginAction.equals("BlockEditVD")) {
					%>
					<tr>
						<td height="12" valign="top">
					</tr>
					<tr>
						<td valign="top" align=right>
							<%=item++%>
							)
						</td>
						<td valign="bottom">
					<% if (!isView) { %>
						<font color="#FF0000">
							Select
						</font>
						<% } %>
							Contacts
							<br>
							<table width=50% border="0">
								<col width="40%">
								<col width="15%">
								<col width="15%">
								<col width="15%">
							<% if (!isView) { %>
								<tr>
									<td>
										&nbsp;
									</td>
									<td align="left">
										<input type="button" name="btnViewCt" value="Edit Item" style="width:100" onClick="javascript:editContact('view');" disabled>
									</td>
									<td align="left">
										<input type="button" name="btnCreateCt" value="Create New" style="width:100" onClick="javascript:editContact('new');">
									</td>
									<td align="center">
										<input type="button" name="btnRmvCt" value="Remove Item" style="width:100" onClick="javascript:editContact('remove');" disabled>
									</td>
								</tr>
							 <% } %>
								<tr>
									<td colspan=4 valign="top">
										
										<%if (!isView){%>
										<select name="selContact" size="4" style="width:100%" onchange="javascript:enableContButtons();" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContact',helpUrl); return false">
										<%}else{%><p class="inset">
											<%}
												Enumeration enum1 = hContacts.keys();
													while (enum1.hasMoreElements()) {
														String contName = (String) enum1.nextElement();
														AC_CONTACT_Bean acCont = (AC_CONTACT_Bean) hContacts
																.get(contName);
														if (acCont == null)
															acCont = new AC_CONTACT_Bean();
														String ctSubmit = acCont.getACC_SUBMIT_ACTION();
														if (ctSubmit != null && ctSubmit.equals("DEL"))
															continue;
														/*  String accID = acCont.getAC_CONTACT_IDSEQ();
														String contName = acCont.getORG_NAME();
														if (contName == null || contName.equals(""))
														  contName = acCont.getPERSON_NAME(); */
											if (!isView){%>	
											<option value="<%=contName%>">
												<%=contName%>
											</option><%}else{%><%=contName%><br>
											<%}
											}if (!isView){%></select><%}else{%><br></p><%}%>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<%
						}
					%>
					<!-- source -->
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
					<% if (!isView) { %>
						<font color="#FF0000">
							Select
						</font>
						<% } %>
							Value Domain Origin
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<% if (!isView) {	%>
							<select name="selSource" size="1" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selSource',helpUrl); return false">
								<option value=""></option>
								<%
									boolean isFound = false;
									for (int i = 0; vSource.size() > i; i++) {
										String sSor = (String) vSource.elementAt(i);
										if (sSor.equals(sSource))
											isFound = true;
								%>
								<option value="<%=sSor%>" <%if(sSor.equals(sSource)){%> selected <%}%>>
									<%=sSor%>
								</option>
							<%	} 
								//add the user entered if not found in the drop down list
								if (!isFound) {
									sSource = serUtil.parsedStringDoubleQuoteJSP(sSource); //call the function to handle doubleQuote
							%>
								<option value="<%=sSource%>" selected>
									<%=sSource%>
								</option>
								<%
									}
								%>
							</select>
							<% } else { %>
							    <input type="text" size="107" value="<%=sSource%>" readonly>
					    	<% } %>
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
					<% if (!isView) { %>
							<font color="#FF0000">
								Create
							</font>
					<% } %>
							Change Note
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<textarea name="CreateChangeNote" cols="70%" 	<% if (isView) { %> readonly <%} %> onHelp="showHelp('html/Help_CreateVD.html#createVDForm_CreateComment',helpUrl); return false" rows=2><%=sChangeNote%></textarea>
						</td>
					</tr>
					<% if (!isView) { %>
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								<a href="javascript:SubmitValidate('validate')">
									Validate
								</a>
							</font>
							the Value Domain(s)
						</td>
					</tr>
					<% } %>
				</table>
				<div style="display:none">
					<input type="hidden" name="vdIDSEQ" value="<%=sVDIDSEQ%>">
					<input type="hidden" name="CDE_IDTxt" value="<%=sPublicVDID%>">
					<input type="hidden" name="actSelect" value="">
					<input type="hidden" name="pageAction" value="nothing">
					<!--<input type="hidden" name="hiddenPValue" value="">
<input type="hidden" name="VMOrigin" value="ValueDomain">-->
					<input type="hidden" name="selObjectClassText" value="<%=sObjClass%>">
					<input type="hidden" name="selPropertyClassText" value="<%=sPropClass%>">
					<input type="hidden" name="selObjectQualifierText" value="<%=sObjQual%>">
					<input type="hidden" name="selPropertyQualifierText" value="<%=sPropQual%>">
					<input type="hidden" name="selRepTermText" value="<%=sRepTerm%>">
					<input type="hidden" name="selObjectClassLN" value="<%=sObjClass%>">
					<input type="hidden" name="selPropertyClassLN" value="<%=sPropClass%>">
					<input type="hidden" name="selObjectQualifierLN" value="<%=sObjQual%>">
					<input type="hidden" name="selPropertyQualifierLN" value="<%=sPropQual%>">
					<input type="hidden" name="selRepTermLN" value="<%=sRepTerm%>">
					<input type="hidden" name="selRepTermID" value="<%=sRepTermID%>">
					<input type="hidden" name="selRepQualifierLN" value="">
					<input type="hidden" name="selRepQualifierText" value="">
					<%
						if (sOriginAction.equals("BlockEditVD")) {
					%>
					<input type="hidden" name="selConceptualDomainText" value="">
					<input type="hidden" name="VDAction" value="BlockEdit">
					<input type="hidden" name="selContextText" value="<%=sContext%>">
					<%
						} else {
					%>
					<input type="hidden" name="selConceptualDomainText" value="<%=sConDom%>">
					<input type="hidden" name="selContextText" value="<%=sContext%>">
					<input type="hidden" name="VDAction" value="EditVD">
					<%
						}
					%>
					<%if (sMenuAction != null) %>
					  <input type="hidden" name="MenuAction" value="<%=sMenuAction%>">
					<input type="hidden" name="valueCount" value="0">
					<input type="hidden" name="selObjRow" value="<%=selObjRow%>">
					<input type="hidden" name="selPropRow" value="<%=selPropRow%>">
					<input type="hidden" name="selRepRow" value="<%=selRepRow%>">
					<input type="hidden" name="selObjQRow" value="<%=selObjQRow%>">
					<input type="hidden" name="selPropQRow" value="<%=selPropQRow%>">
					<input type="hidden" name="selRepQRow" value="<%=selRepQRow%>">
					<input type="hidden" name="PropDefinition" value="<%=sPropDefinition%>">
					<input type="hidden" name="ObjDefinition" value="<%=sObjDefinition%>">
					<input type="hidden" name="RepDefinition" value="<%=sRepDefinition%>">
					<input type="hidden" name="openToTree" value="">
					<input type="hidden" name="RepQualID" value="<%=sRepQualID%>">
					<input type="hidden" name="RepQualVocab" value="<%=sRepQualVocab%>">
					<input type="hidden" name="RepTerm_ID" value="<%=sRepTerm_ID%>">
					<input type="hidden" name="RepTermVocab" value="<%=sRepTermVocab%>">
					<input type="hidden" name="sCompBlocks" value="">
					<input type="hidden" name="nvpConcept" value="">

					<input type="hidden" name="RepQualCCode" value="">
					<input type="hidden" name="RepQualCCodeDB" value="">
					<input type="hidden" name="RepCCode" value="<%=sRepCCode%>">
					<input type="hidden" name="RepCCodeDB" value="<%=sRepCCodeDB%>">
					<input type="hidden" name="nameTypeChange" value="<%=nameChanged%>">

					<select name="selCSCSIHidden" size="1" style="visibility:hidden;" multiple></select>
					<select name="selACCSIHidden" size="1" style="visibility:hidden;" multiple></select>
					<select name="selCSNAMEHidden" size="1" style="visibility:hidden;" multiple></select>
					<!-- store the selected ACs in the hidden field to use it for cscsi -->
					<select name="selACHidden" size="1" style="visibility:hidden;width:100;" multiple>
						<%
							if (vACId != null) {
								for (int i = 0; vACId.size() > i; i++) {
									String sAC_ID = (String) vACId.elementAt(i);
									String sACName = "";
									if (vACName != null && vACName.size() > i)
										sACName = (String) vACName.elementAt(i);
									//    System.out.println("selected " + sACName);
						%>
						<option value="<%=sAC_ID%>">
							<%=sACName%>
						</option>
						<%
							}
							}
						%>
					</select>
					<select name="vRepQualifierCodes" size="1" style="visibility:hidden;width:100;" multiple>
						<%
							if (vRepQualifierCodes != null) {
								for (int i = 0; vRepQualifierCodes.size() > i; i++) {
									String sRepQualifierCode = (String) vRepQualifierCodes
											.elementAt(i);
						%>
						<option value="<%=sRepQualifierCode%>">
							<%=sRepQualifierCode%>
						</option>
						<%
							}
							}
						%>
					</select>
					<select name="vRepQualifierDB" size="1" style="visibility:hidden;width:100;" multiple>
						<%
							if (vRepQualifierDB != null) {
								for (int i = 0; vRepQualifierDB.size() > i; i++) {
									String sRepQualifierDB = (String) vRepQualifierDB
											.elementAt(i);
						%>
						<option value="<%=sRepQualifierDB%>">
							<%=sRepQualifierDB%>
						</option>
						<%
							}
							}
						%>
					</select>
					<!-- store datatype description to use later -->
					<select name="datatypeDesc" size="1" style="visibility:hidden;width:100;" multiple>
						<%
							if (vDataTypes != null) {
								//System.out.println("datatypeDesc vDataTypes.size(): " + vDataTypes.size());
								for (int i = 0; vDataTypes.size() > i; i++) {
									String sDType = (String) vDataTypes.elementAt(i);
								//	String sDTDesc = "", sDTComm = "";
									if ((vDataTypeDesc != null)&&(i < vDataTypeDesc.size()))
										sDTDesc = (String) vDataTypeDesc.elementAt(i);
									if (sDTDesc == null || sDTDesc.equals(""))
										sDTDesc = sDType;
									if ((vDataTypeCom != null) && (i < vDataTypeCom.size()))
										sDTComm = (String) vDataTypeCom.elementAt(i);
									if (sDTComm == null)
										sDTComm = "";
						%>
						<option value="<%=sDTDesc%>">
							<%=sDTComm%>
						</option>
						<%
							}
							}
						%>
					</select>

					<!-- stores the selected rows to get the bean from the search results -->
					<select name="hiddenSelRow" size="1" style="visibility:hidden;width:100" multiple></select>
				</div>
				<script language="javascript">
//call function to initiate form objects
createObject("document.createVDForm");
displayStatusMessage();
loadCSCSI();
//ShowEVSInfo('RepQualifier');
//changeDataType();
</script>
		</form>
		<!--  remvoed the searchactionform from here and put it on vdpvstab.jsp -->
		<div style="display:none">
			<form name="SearchActionForm" method="post" action="">
				<input type="hidden" name="searchComp" value="<%=sSearchAC%>">
				<input type="hidden" name="searchEVS" value="ValueDomain">
				<input type="hidden" name="isValidSearch" value="true">
				<input type="hidden" name="CDVDcontext" value="">
				<input type="hidden" name="SelContext" value="">
				<input type="hidden" name="acID" value="<%=sVDIDSEQ%>">
				<input type="hidden" name="CD_ID" value="<%=sConDomID%>">
				<input type="hidden" name="itemType" value="">
			</form>
		</div>

	</body>
</html>
