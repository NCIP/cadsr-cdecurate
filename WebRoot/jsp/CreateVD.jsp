<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/CreateVD.jsp,v 1.14 2009-04-21 03:47:35 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<html>
	<head>
		<title>
			Create Value Domain
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<SCRIPT LANGUAGE="JavaScript" SRC="js/AddNewListOption.js"></SCRIPT>
		<%@ page import="java.util.*"%>
		<%@ page import="java.text.*"%>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.util.*"%>
				
		<SCRIPT LANGUAGE="JavaScript" SRC="js/date.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/CreateVD.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/SelectCS_CSI.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/VDPVS.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%
			Vector vContext = (Vector) session.getAttribute("vWriteContextVD");
      Vector vContextID = (Vector) session.getAttribute("vWriteContextVD_ID");
      Vector vStatus = (Vector) session.getAttribute("vStatusVD");
      Vector vDataTypes = (Vector) session.getAttribute("vDataType");
      Vector vDataTypeDesc = (Vector) session.getAttribute("vDataTypeDesc");
      Vector vDataTypeCom = (Vector) session.getAttribute("vDataTypeComment");
      Vector vDataTypeSRef= (Vector) session.getAttribute("vDataTypeSReference");
      Vector VDataTypeAnnotation = (Vector) session.getAttribute("vDataTypeAnnotation");
      Vector vUOM = (Vector) session.getAttribute("vUOM");
      Vector vUOMFormat = (Vector) session.getAttribute("vUOMFormat");
      Vector vCD = (Vector) session.getAttribute("vCD");
      Vector vCDID = (Vector) session.getAttribute("vCD_ID");
      Vector vLanguage = (Vector) session.getAttribute("vLanguage");
      Vector vSource = (Vector) session.getAttribute("vSource");
      Vector vCS = (Vector) session.getAttribute("vCS");
      Vector vCS_ID = (Vector) session.getAttribute("vCS_ID");
      Vector vRegStatus = (Vector)session.getAttribute("vRegStatus");//GF32398
      VD_Bean m_VD = new VD_Bean();
      m_VD = (VD_Bean) session.getAttribute("m_VD");
      if (m_VD == null) m_VD = new VD_Bean();
      UtilService serUtil = new UtilService();
      String sMenuAction = (String) session.getAttribute(Session_Data.SESSION_MENU_ACTION);
      String sOriginAction = (String) session.getAttribute("originAction");
      String sButtonPressed = (String) session.getAttribute("LastMenuButtonPressed");
      String sVDIDSEQ = m_VD.getVD_VD_IDSEQ();
      if (sVDIDSEQ == null) sVDIDSEQ = "";
      String sPublicVDID = m_VD.getVD_VD_ID();
      if (sPublicVDID == null) sPublicVDID = "";
      String selPropQRow = (String) session.getAttribute("selPropQRow");
      if (selPropQRow == null) selPropQRow = "";
      String selObjQRow = (String) session.getAttribute("selObjQRow");
      if (selObjQRow == null) selObjQRow = "";
      String selRepQRow = (String) session.getAttribute("selRepQRow");
      if (selRepQRow == null) selRepQRow = "";
      String selPropRow = (String) session.getAttribute("selPropRow");
      if (selPropRow == null) selPropRow = "";
      String selObjRow = (String) session.getAttribute("selObjRow");
      if (selObjRow == null) selObjRow = "";
      String selRepRow = (String) session.getAttribute("selRepRow");
      if (selRepRow == null) selRepRow = "";
      String sContext = m_VD.getVD_CONTEXT_NAME();
      if ((sContext == null) || (sContext.equals("")))
        sContext = (String) session.getAttribute("sDefaultContext");
      if (sContext == null) sContext = "";
      String sContID = m_VD.getVD_CONTE_IDSEQ();
      if (sContID == null) sContID = "";
      String sLongName = m_VD.getVD_LONG_NAME();
      sLongName = serUtil.parsedStringDoubleQuoteJSP(sLongName); //call the function to handle doubleQuote
      if (sLongName == null) sLongName = "";
      int sLongNameCount = sLongName.length();
      String sName = m_VD.getVD_PREFERRED_NAME();
      sName = serUtil.parsedStringDoubleQuoteJSP(sName); //call the function to handle doubleQuote
      if (sName == null) sName = "";
      int sNameCount = sName.length();
      String lblUserType = "Existing Name (Editable)"; //make string for user defined label
      String sUserEnt = m_VD.getAC_USER_PREF_NAME();
      if (sUserEnt == null || sUserEnt.equals("")) lblUserType = "User Entered";
      String sObjQual = m_VD.getVD_OBJ_QUAL();
      sObjQual = serUtil.parsedStringDoubleQuoteJSP(sObjQual); //call the function to handle doubleQuote
      if (sObjQual == null) sObjQual = "";
      String sObjClass = m_VD.getVD_OBJ_CLASS();
      sObjClass = serUtil.parsedStringDoubleQuoteJSP(sObjClass); //call the function to handle doubleQuote
      if (sObjClass == null) sObjClass = "";
      String sPropQual = m_VD.getVD_PROP_QUAL();
      sPropQual = serUtil.parsedStringDoubleQuoteJSP(sPropQual); //call the function to handle doubleQuote
      if (sPropQual == null) sPropQual = "";
      String sPropClass = m_VD.getVD_PROP_CLASS();
      sPropClass = serUtil.parsedStringDoubleQuoteJSP(sPropClass); //call the function to handle doubleQuote
      if (sPropClass == null) sPropClass = "";
      String sRepTerm = ""; //use the concepts to create rep term
      String sRepTermID = m_VD.getVD_REP_IDSEQ();
      if (sRepTermID == null) sRepTermID = "";
      String sRepTermVocab = m_VD.getVD_REP_EVS_CUI_ORIGEN();
      sRepTermVocab = serUtil.parsedStringDoubleQuoteJSP(sRepTermVocab); //call the function to handle doubleQuote
      if (sRepTermVocab == null || sRepTermVocab.equals("null")) sRepTermVocab = "";
      String sRepQualVocab = m_VD.getVD_REP_QUAL_EVS_CUI_ORIGEN();
      sRepQualVocab = serUtil.parsedStringDoubleQuoteJSP(sRepQualVocab); //call the function to handle doubleQuote
      if (sRepQualVocab == null || sRepQualVocab.equals("null")) sRepQualVocab = "";
      String sRepQualID = m_VD.getVD_REP_QUAL_CONCEPT_CODE();
      if (sRepQualID == null || sRepQualID.equals("null")) sRepQualID = "";
      String sRepTerm_ID = m_VD.getVD_REP_CONCEPT_CODE();
      if (sRepTerm_ID == null || sRepTerm_ID.equals("null")) sRepTerm_ID = "";
      Vector vRepQualifierNames = m_VD.getVD_REP_QUALIFIER_NAMES();
      if (vRepQualifierNames == null) vRepQualifierNames = new Vector();
      Vector vRepQualifierCodes = m_VD.getVD_REP_QUALIFIER_CODES();
      if (vRepQualifierCodes == null) vRepQualifierCodes = new Vector();
      Vector vRepQualifierDB = m_VD.getVD_REP_QUALIFIER_DB();
      if (vRepQualifierDB == null) vRepQualifierDB = new Vector();
      String sRepCCodeDB = m_VD.getVD_REP_EVS_CUI_ORIGEN();
      String sRepCCode = m_VD.getVD_REP_CONCEPT_CODE();
      if (sRepCCodeDB == null) sRepCCodeDB = "";
      if (sRepCCode == null) sRepCCode = "";
      if (sRepTerm == null) sRepTerm = "";
      String sObjQualLN = "";
      String sObjQualLong = "";
      String sPropQualLN = "";
      String sPropQualLong = "";
      String sPropClassPN = "";
      String sObjClassPN = "";
      String sObjQualPN = "";
      String sPropQualPN = "";
      String sRepQualLN = "";
      for (int i = 0; vRepQualifierNames.size() > i; i++)
      {
        if (i == 0) sRepQualLN = (String) vRepQualifierNames.elementAt(i);
        else sRepQualLN = sRepQualLN + " " + (String) vRepQualifierNames.elementAt(i);
      }
      //add rep qual names to rep term
      if (sRepQualLN != null && !sRepQualLN.equals("") && !sRepQualLN.equals(" "))
        sRepTerm = sRepQualLN;
      //get rep primary 
      String sRepTermPrimary = m_VD.getVD_REP_NAME_PRIMARY();
      if (sRepTermPrimary == null) sRepTermPrimary = "";
      if (!sRepTermPrimary.equals("") && !sRepTermPrimary.equals(" "))
      {
        //add a space to rep term
        if (sRepTerm != null && !sRepTerm.equals("")) sRepTerm += " ";
        sRepTerm += sRepTermPrimary; //add rep term primary
      }
      sRepTerm = serUtil.parsedStringDoubleQuoteJSP(sRepTerm); //call the function to handle doubleQuote
      sRepTerm = AdministeredItemUtil.handleLongName(sRepTerm);	//GF32004
      //naming to here    
      String sPrefType = m_VD.getAC_PREF_NAME_TYPE();
      if (sPrefType == null) sPrefType = ""; //sys defaults on create page
      //put the name as system generated text by default
      if (sPrefType.equals("SYS")) sName = "(Generated by the System)";
      boolean nameChanged = m_VD.getVDNAME_CHANGED();
      String sObjDefinition = m_VD.getVD_Obj_Definition();
      if (sObjDefinition == null) sObjDefinition = "";
      String sPropDefinition = m_VD.getVD_Prop_Definition();
      if (sPropDefinition == null) sPropDefinition = "";
      String sRepDefinition = m_VD.getVD_Rep_Definition();
      if (sRepDefinition == null) sRepDefinition = "";
      String sChangeNote = m_VD.getVD_CHANGE_NOTE();
      if (sChangeNote == null) sChangeNote = "";
      String sDefinition = m_VD.getVD_PREFERRED_DEFINITION();
      if (sDefinition == null) sDefinition = "";
      String sVersion = m_VD.getVD_VERSION();
      if (sVersion == null) sVersion = "1.0";
      String sStatus = m_VD.getVD_ASL_NAME();
      if (sStatus == null) sStatus = ""; //"DRAFT NEW";
      String sConDomID = m_VD.getVD_CD_IDSEQ();
      if (sConDomID == null) sConDomID = ""; //"";
      String sConDom = m_VD.getVD_CD_NAME();
      if (sConDom == null) sConDom = ""; //"";
      String sBeginDate = m_VD.getVD_BEGIN_DATE();
      if (sBeginDate == null) sBeginDate = "";
      if (sBeginDate == "")
      {
        Date currentDate = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
        sBeginDate = formatter.format(currentDate);
      }
      String sUOML = m_VD.getVD_UOML_NAME();
      if (sUOML == null) sUOML = "";
      String sFORML = m_VD.getVD_FORML_NAME();
      if (sFORML == null) sFORML = "";
      String sLowValue = m_VD.getVD_LOW_VALUE_NUM();
      if (sLowValue == null) sLowValue = "";
      String sHighValue = m_VD.getVD_HIGH_VALUE_NUM();
      if (sHighValue == null) sHighValue = "";
      String sMaxLen = m_VD.getVD_MAX_LENGTH_NUM();
      if (sMaxLen == null) sMaxLen = "";
      String sMinLen = m_VD.getVD_MIN_LENGTH_NUM();
      if (sMinLen == null) sMinLen = "";
      String sCharSet = m_VD.getVD_CHAR_SET_NAME();
      if (sCharSet == null) sCharSet = "";
      String sDataType = m_VD.getVD_DATA_TYPE();
      if (sDataType == null) sDataType = "";
      String sTypeFlag = m_VD.getVD_TYPE_FLAG();
      if (sTypeFlag == null) sTypeFlag = "E";
      session.setAttribute("pageVDType", sTypeFlag);
      String sEndDate = m_VD.getVD_END_DATE();
      if (sEndDate == null) sEndDate = "";
      String sDecimal = m_VD.getVD_DECIMAL_PLACE();
      if (sDecimal == null) sDecimal = "";
      String sSource = m_VD.getVD_SOURCE();
      if (sSource == null) sSource = "";
      boolean bDataFound = false;
      //get the contact hashtable for the de
      Hashtable hContacts = m_VD.getAC_CONTACTS();
      if (hContacts == null) hContacts = new Hashtable();
      session.setAttribute("AllContacts", hContacts);
      //these are for value/meaning search. moved to vdpvs tab
   //   session.setAttribute("MenuAction", "searchForCreate");
   //   Vector vResult = new Vector();
   //   session.setAttribute("results", vResult);
   //   session.setAttribute("creRecsFound", "No ");
      //for altnames and ref docs
   //   session.setAttribute("dispACType", "ValueDomain");
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
      Vector vVDPVList = m_VD.getVD_PV_List();  //(Vector) session.getAttribute("VDPVList");
      if (vVDPVList == null) vVDPVList = new Vector();
      Vector vPVIDList = new Vector();
      Vector vQVList = (Vector) session.getAttribute("NonMatchVV");
      if (vQVList == null) vQVList = new Vector();
      String sPVRecs = "No ";
      int vdPVs = 0;
      if (vVDPVList.size() > 0)
      {
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
      session.setAttribute("PVAction", "");
      //cs-csi data
      Vector vSelCSList = m_VD.getAC_CS_NAME();
      if (vSelCSList == null) vSelCSList = new Vector();
      Vector vSelCSIDList = m_VD.getAC_CS_ID();
      Vector vACCSIList = m_VD.getAC_AC_CSI_VECTOR();
      Vector vACId = (Vector) session.getAttribute("vACId");
      Vector vACName = (Vector) session.getAttribute("vACName");
      //initialize the beans
      CSI_Bean thisCSI = new CSI_Bean();
      AC_CSI_Bean thisACCSI = new AC_CSI_Bean();
      int item = 1;
      String sSearchAC = (String) session.getAttribute("creSearchAC");
      String reqType = "";
      reqType = request.getParameter("reqType");
      if (reqType == null) reqType = "";
%>

		<SCRIPT LANGUAGE="JavaScript">
  var searchWindow = null;
  var evsTreeWindow = null;
  var pageOpening = "<%=sTypeFlag %>";
  var helpUrl = "<%=ToolURL.getCurationToolHelpURL(pageContext)%>";
  
  //get all the cs_csi from the bean to array.
  var csiArray = new Array();  
  var selCSIArray = new Array();  //for selected csi list
  var selACCSIArray = new Array();  //for selected AC-csi list
  var writeContArray = new Array();

  function loadCSCSI()
  {
  <%
    Vector vCSIList = (Vector)session.getAttribute("CSCSIList");
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
    //close the opener window if there is error
    if (statusMessage != null && !statusMessage.equals(""))
    {%>
        if (searchWindow && !searchWindow.closed)
            searchWindow.close();    
    <%}
    //check if the status message is too long
    Vector vStat = (Vector)session.getAttribute("vStatMsg");
    if (vStat != null && vStat.size() > 30)
    {%>
      displayStatusWindow();
    <% }
    else if (statusMessage != null && !statusMessage.equals(""))
    {%>
	       alert("<%=statusMessage%>");
    <% }
    //reset the status message to no message
    session.setAttribute(Session_Data.SESSION_STATUS_MESSAGE, "");
%>
  }

  function createOrigin()
  {
    var newOrigin = prompt('Enter a new Origin : ','')
    document.createVDForm.selSource.value = newOrigin;
    document.createVDForm.selSource.text = newOrigin;
  }
  
	function setup()
	{
	    var repTerm = document.getElementById("RepTerm");
	    repTerm.innerText = "<%=sRepTermVocab%>";
	    repTerm.textContent = "<%=sRepTermVocab%>";
	    
	    var repTermId = document.getElementById("RepTermID");
	    repTermId.innerText = "<%=sRepTerm_ID%>";
	    repTermId.textContent = "<%=sRepTerm_ID%>";
	}

	function closeDep() 
	{
	  if (searchWindow && searchWindow.open && !searchWindow.closed) 
	    searchWindow.close();
	  if(altWindow && altWindow.open && ! altWindow.closed)
	    altWindow.close();
	  if(statusWindow && statusWindow.open && !statusWindow.closed)
	      statusWindow.close();
	}
	
</SCRIPT>
	</head>

	<body onLoad="setup();">
		<form name="createVDForm" method="POST" action="../../cdecurate/NCICurationServlet?reqType=newVDfromForm">
			<!-- include the vdpvstab.jsp here -->
			<jsp:include page="VDPVSTab.jsp" flush="true" />
			<div style="margin-left: 0in; margin-right: 0in; border-left: 2px solid black; border-bottom: 2px solid black; border-right: 2px solid black; width: 100%; padding: 0.1in 0in 0.1in 0in">
				<table width="100%">
					<col width="4%">
					<col width="96%">
					<tr height="25" valign="bottom">
						<td align=right>
							<font color="#FF0000">
								* &nbsp;&nbsp;
							</font>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Select
							</font>
							Context
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<select name="selContext" size="1">
								<%bDataFound = false;
      for (int i = 0; vContext.size() > i; i++)
      {
        String sContextName = (String) vContext.elementAt(i);
        String sContextID = (String) vContextID.elementAt(i);
        //if(sContext.equals("")) sContext = sContextName;
        if (sContextName.equals(sContext)) bDataFound = true;
%>
								<option value="<%=sContextID%>" <%if(sContextName.equals(sContext)){%> selected <%}%>>
									<%=sContextName%>
								</option>
								<%}
      if (bDataFound == false)
      {%>
								<option value="" selected></option>
								<%}
      %>
							</select>
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<font color="#FF0000">
								* &nbsp;&nbsp;
							</font>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Select
							</font>
							Value Domain Type
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<select name="listVDType" size="1" style="width:22%" onChange="ToggleDisableList2();" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selVDType',helpUrl); return false">
								<option value="E" <%if(sTypeFlag.equals("E")){%> selected <%}%>>
									Enumerated
								</option>
								<option value="N" <%if(sTypeFlag.equals("N")){%> selected <%}%>>
									Non-Enumerated
								</option>
							</select>
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
						<font color="#FF0000">
								* &nbsp;&nbsp;
							</font>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Select
							</font>
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
														<% if (session.getAttribute("changedRepDefsWarning") != null) {%>
														<tr height="8">
															<td colspan=6>
																
																Warning: One or more Representation Term concepts you've selected already exist in caDSR with a different definition.
																The existing standard caDSR definition will be used, and your chosen definition will be used to create an alternate definition for this element.
																
															</td>
														</tr>
														<%} %>
														<tr>
															<td colspan="2" align="left" valign="top">
																Rep Term Long Name
															</td>
														</tr>
														<tr>
															<td colspan="5" align="left">
																<input type="text" name="txtRepTerm" value="<%=sRepTerm%>" style="width: 100%" maxlength=255 valign="top" readonly="readonly">
															</td>
														</tr>
														<tr height="8">
															<td></td>
														</tr>
														<tr valign="bottom">
															<td align="left" valign="top">
																Qualifier
																<br>
																Concepts
															</td>
															<td align="right" valign="middle">
																<font color="#FF0000">
																	<a href="javascript:SearchBuildingBlocks('RepQualifier', 'false')">
																		Search
																	</a>
																</font>
															</td>
															<td align="center" valign="middle">
																<font color="#FF0000">
																	<a href="javascript:RemoveBuildingBlocks('RepQualifier')">
																		Remove
																	</a>
																</font>
															</td>
															<td align="left" valign="top">
																Primary
																<br>
																Concept
															</td>
															<td align="right" valign="middle">
																<font color="#FF0000">
																	<a href="javascript:SearchBuildingBlocks('RepTerm', 'false')">
																		Search
																	</a>
																</font>
															</td>
															<td align="center" valign="middle">
																<font color="#FF0000">
																	<a href="javascript:RemoveBuildingBlocks('RepTerm')">
																		Remove
																	</a>
																</font>
															</td>
														</tr>
														<tr align="left">
															<td colspan="3" valign="top">
																<select name="selRepQualifier" size="2" style="width: 98%" valign="top" onClick="ShowEVSInfo('RepQualifier')" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_nameBlocks',helpUrl); return false">
																	<%if (vRepQualifierNames.size() < 1)
      {%>
																	<option value=""></option>
																	<%}
      else
      {
        %>
																	<%for (int i = 0; vRepQualifierNames.size() > i; i++)
        {
          String sQualName = (String) vRepQualifierNames.elementAt(i);
          %>
																	<option value="<%=sQualName%>" <%if(i==0){%> selected <%}%>>
																		<%=sQualName%>
																	</option>
																	<%}%>
																	<%}
      %>
																</select>
															</td>
															<td colspan="3" valign="top">
																<select name="selRepTerm" style="width: 98%" valign="top" size="1" multiple onHelp="showHelp('html/Help_CreateVD.html#createVDForm_nameBlocks',helpUrl); return false">
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
																<a href="javascript:disabled();">
																	<label id="RepQualID" for="selRepQualifier" title="" onclick="javascript:SearchBuildingBlocks('RepQualifier', 'true')"></label>
																</a>
															</td>
															<td colspan="3">
																&nbsp;&nbsp;
																<a href="javascript:disabled();">
																	<label id="RepTermID" for="selRepTerm" title="" onclick="javascript:SearchBuildingBlocks('RepTerm', 'true')"></label>
																</a>
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
				<tr height="25" valign="bottom">
						<td align=right>
							<font color="#FF0000">
								* &nbsp;&nbsp;
							</font>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Verify
							</font>
							Value Domain Long Name (* ISO Preferred Name)
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td height="24" valign="top">
							<input name="txtLongName" type="text" size="100" maxlength=255 value="<%=sLongName%>" onKeyUp="changeCountLN();" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_txtLongName',helpUrl); return false">
							&nbsp;&nbsp;
							<font color="#666666">
								<input name="txtLongNameCount" type="text" size="1" value="<%=sLongNameCount%>" readonly onHelp="showHelp('html/Help_CreateVD.html#createVDForm_txtLongName',helpUrl); return false">
								<font color="#000000">
									Character Count
								</font>
							</font>
							&nbsp;&nbsp;(Database Max = 255)
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<font color="#FF0000">
								* &nbsp;&nbsp;
							</font>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Update
							</font>
							Value Domain Short Name
						</td>
					</tr>
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
							<!--Existing Name (Editable) User Maintained-->
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td height="24" valign="top">
							<input name="txtPreferredName" type="text" size="100" maxlength=30 value="<%=sName%>" onKeyUp="changeCountPN();" <%if (sPrefType.equals("") || sPrefType.equals("SYS") || sPrefType.equals("ABBR")) {%> readonly <%}%>
								onHelp="showHelp('html/Help_CreateVD.html#createVDForm_txtPreferredName',helpUrl); return false">
							&nbsp;&nbsp;
							<input name="txtPrefNameCount" type="text" size="1" value="<%=sNameCount%>" readonly onHelp="showHelp('html/Help_CreateVD.html#createVDForm_txtPreferredName',helpUrl); return false">
							Character Count &nbsp;&nbsp;(Database Max = 30)
						</td>
					</tr>
					<tr>
						<td height="8" valign="top">
					</tr>
					<tr height="25" valign="top">
						<td align=right>
							<font color="#FF0000">
								* &nbsp;&nbsp;
							</font>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Create/Edit
							</font>
							Definition
							<br>
							(Changes to naming components will replace existing definition text.)
						</td>
					</tr>

					<tr>
						<td>
							&nbsp;
						</td>
						<td valign="top" align="left">
							<textarea name="CreateDefinition" style="width:80%" rows=6><%=sDefinition%></textarea>
							<!--  &nbsp;&nbsp; <font color="#FF0000"> <a href="javascript:OpenEVSWindow()">Search</a></font>  -->
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<font color="#FF0000">
								* &nbsp;&nbsp;
							</font>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Select
							</font>
							Conceptual Domain
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<select name="selConceptualDomain" size="1" style="width:50%" multiple onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selConceptualDomain',helpUrl); return false">
								<option value=<%=sConDomID%>>
									<%=sConDom%>
								</option>
							</select>
							&nbsp;&nbsp;
							<font color="#FF0000">
								<a href="javascript:SearchCDValue()">
									Search
								</a>
							</font>
						</td>
					</tr>
					
					<tr height="25" valign="bottom">
						<td align=right>
							<font color="#FF0000">
								* &nbsp;&nbsp;
							</font>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Select
							</font>
							Workflow Status
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<select name="selStatus" size="1" style="width:20%" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selStatus',helpUrl); return false">
								<option value="" selected="selected"></option>
								<%for (int i = 0; vStatus.size() > i; i++)
      {
        String sStatusName = (String) vStatus.elementAt(i);
        //add only draft new and retired phased out if creating new
        if (sMenuAction.equals("Questions"))
        {
          if (sStatusName.equals("DRAFT NEW") || sStatusName.equals("RETIRED PHASED OUT"))
          {
%>
								<option value="<%=sStatusName%>" <%if(sStatusName.equals(sStatus)){%> selected <%}%>>
									<%=sStatusName%>
								</option>
								<%}
        }
        else
        {
%>
								<option value="<%=sStatusName%>" <%if(sStatusName.equals(sStatus)){%> selected <%}%>>
									<%=sStatusName%>
								</option>
								<%}
      }
%>
							</select>
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<font color="#FF0000">
								* &nbsp;&nbsp;
							</font>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Enter
							</font>
							Version
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<input type="text" name="Version" value="<%=sVersion%>" size=12 maxlength=5 onHelp="showHelp('html/Help_CreateVD.html#createVDForm_Version',helpUrl); return false">
							&nbsp;&nbsp;&nbsp;
							<a href="<%=ToolURL.getCurationToolBusinessRulesURL(pageContext)%>" target="_blank">
								Business Rules
							</a>
						</td>
					</tr>
					<%-- ===========GF32398 Add Registration Status Field in UI =====START--%>
				<tr height="25" valign="bottom">
					<td align=right>
						<%=item++%>
						)
					</td>
					<td>
						<font color="#FF0000">
							Select
						</font>
						Registration Status
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td height="25" valign="top">
						<select name="selRegStatus" size="1" style="Width:50%" onHelp="#">
							<option value="" selected></option>
							<%          if (vRegStatus != null) 
            {            
              for (int i = 0; vRegStatus.size()>i; i++)
              {
                String sReg = (String)vRegStatus.elementAt(i);
%>
							<option value="<%=sReg%>">
								<%=sReg%>
							</option>
							<%
            } }
%>
						</select>
					</td>
				</tr> 
				
				<%--===========GF32398 Add Registration Status Field in UI =====END --%>
					<tr height="25" valign="bottom">
						<td align=right>
							<font color="#FF0000">
								*
							</font>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Select
							</font>
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
								<col width="20%">
								<col width="20%">
								<col width="20%">
								<col width="20%">
								<tr>
									<td valign="top">
										<select name="selDataType" size="1" onChange="javascript:changeDataType();" style="width:90%" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selDataType',helpUrl); return false">
											<%for (int i = 0; vDataTypes.size() > i; i++)
      {
        String sCD = (String) vDataTypes.elementAt(i);
%>
											<option value="<%=sCD%>" <%if(sCD.equalsIgnoreCase(sDataType)){%> selected <%}%>>
												<%=sCD%>
											</option>
											<%}
%>
										</select>
									</td>
									<td valign="top" height="25">
										<b>
											Description:
										</b>
										<br>
										<label id="lblDTDesc" for="selDataType" style="width:95%" title=""></label>
									</td>
									<td valign="top" height="25">
										<b>
											Comment:
										</b>
										<br>
										<label id="lblDTComment" for="selDataType" style="width:95%" title=""></label>
									</td>
									<td valign="top" height="25">
										<b>
											Scheme-Reference:
										</b>
										<br>
										<label id="lblDTSRef" for="selDataType" style="width:95%" title=""></label>
									</td>
									<td valign="top" height="25">
										<b>
										    Annotation:
										</b>
										<br>
										<label id="lblDTAnnotation" for="selDataType" style="width:95%" title=""></label>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<!-- pv attributes -->
					<tr valign="top">
						<td align=right>
							<font color="#FF0000">
								*
							</font>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Maintain
							</font>
							<%if (sTypeFlag.equals("E")){%>
							Permissible Value
							<%} else {%>
							Referenced Value
							<%}%>
							<br>
							To view or maintain Permissible Values,
							<a href="javascript:SubmitValidate('vdpvstab');">
								click here
							</a>
							&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Enter/Select
							</font>
							Effective Begin Date
						</td>
					</tr>

					<tr>
						<td>
							&nbsp;
						</td>
						<td valign="top">
							<input type="text" name="BeginDate" value="<%=sBeginDate%>" size="12" maxlength=10 onHelp="showHelp('html/Help_CreateVD.html#createVDForm_BeginDate',helpUrl); return false">
							<img src="../../cdecurate/images/calendarbutton.gif" onclick="calendar('BeginDate', event);">
							&nbsp;&nbsp;MM/DD/YYYY
						</td>
					</tr>

					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Enter/Select
							</font>
							Effective End Date
						</td>
					</tr>

					<tr>
						<td>
							&nbsp;
						</td>
						<td valign="bottom">
							<input type="text" name="EndDate" value="<%=sEndDate%>" size="12" maxlength=10 onHelp="showHelp('html/Help_CreateVD.html#createVDForm_EndDate',helpUrl); return false">
							<img src="../../cdecurate/images/calendarbutton.gif" onclick="calendar('EndDate', event);">
							&nbsp;&nbsp;MM/DD/YYYY
						</td>
					</tr>

					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Select
							</font>
							the Unit of Measure (UOM)
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<select name="selUOM" size="1" style="width:15%" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selUOM',helpUrl); return false">
								<option value=""></option>
								<%for (int i = 0; vUOM.size() > i; i++)
      {
        String sUOM = (String) vUOM.elementAt(i);
%>
								<option value="<%=sUOM%>" <%if(sUOM.equals(sUOML)){%> selected <%}%>>
									<%=sUOM%>
								</option>
								<%}
%>
							</select>
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Select
							</font>
							Display Format
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<select name="selUOMFormat" size="1" style="width:15%" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selUOMFormat',helpUrl); return false">
								<option value=""></option>
								<%for (int i = 0; vUOMFormat.size() > i; i++)
      {
        String sUOMF = (String) vUOMFormat.elementAt(i);
%>
								<option value="<%=sUOMF%>" <%if(sUOMF.equals(sFORML)){%> selected <%}%>>
									<%=sUOMF%>
								</option>
								<%}
%>
							</select>
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Enter
							</font>
							Minimum Length
						</td>
					</tr>

					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<input type="text" name="tfMinLength" value="<%=sMinLen%>" size="20" maxlength=8 onHelp="showHelp('html/Help_CreateVD.html#createVDForm_tfMinLength',helpUrl); return false">
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Enter
							</font>
							Maximum Length
						</td>
					</tr>

					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<input type="text" name="tfMaxLength" value="<%=sMaxLen%>" size="20" maxlength=8 onHelp="showHelp('html/Help_CreateVD.html#createVDForm_tfMaxLength',helpUrl); return false">
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Enter
							</font>
							Low Value (for number data type)
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<input type="text" name="tfLowValue" value="<%=sLowValue%>" size="20" maxlength=255 <% if (!sDataType.equalsIgnoreCase("NUMBER")) { %> disabled <% } %> onHelp="showHelp('html/Help_CreateVD.html#createVDForm_tfLowValue',helpUrl); return false">
						</td>
					</tr>
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Enter
							</font>
							High Value (for number data type)
						</td>
					</tr>

					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<input type="text" name="tfHighValue" value="<%=sHighValue%>" size="20" maxlength=255 <% if (!sDataType.equalsIgnoreCase("NUMBER")) { %> disabled <% } %> onHelp="showHelp('html/Help_CreateVD.html#createVDForm_tfHighValue',helpUrl); return false">
						</td>
					</tr>

					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Enter
							</font>
							Decimal Place
						</td>
					</tr>

					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<input type="text" name="tfDecimal" value="<%=sDecimal%>" size="20" maxlength=2 onHelp="showHelp('html/Help_CreateVD.html#createVDForm_tfDecimal',helpUrl); return false">
						</td>

					</tr>
					<!-- Classification Scheme and items -->
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Select
							</font>
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
								<tr>
									<td colspan="3" valign=top>
										<select name="selCS" size="1" style="width:97%" onChange="ChangeCS();" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selCS',helpUrl); return false">
											<option value="" selected></option>
											<%for (int i = 0; vCS.size() > i; i++)
      {
        String sCSName = (String) vCS.elementAt(i);
        String sCS_ID = (String) vCS_ID.elementAt(i);
%>
											<option value="<%=sCS_ID%>">
												<%=sCSName%>
											</option>
											<%}
      %>
										</select>
									</td>
									<td colspan="2" valign=top>
										<select name="selCSI" size="5" style="width:100%" onChange="selectCSI();" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selCS',helpUrl); return false">
										</select>
									</td>
								</tr>
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
										<input type="button" name="btnRemoveCS" value="Remove Item" onClick="removeCSList();">
									</td>
									<td>
										&nbsp;&nbsp;Associated Classification Scheme Items
									</td>
									<td>
										<input type="button" name="btnRemoveCSI" value="Remove Item" onClick="removeCSIList();">
									</td>
								</tr>
								<tr>
									<td>
										&nbsp;
									</td>
									<td colspan=2 valign=top>
										<select name="selectedCS" size="5" style="width:97%" multiple onchange="addSelectCSI(false, true, '');" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selCS',helpUrl); return false">
											<%//store selected cs list on load 
      if (vSelCSIDList != null)
      {
        //       System.out.println("cs size " + vSelCSIDList.size());
        for (int i = 0; vSelCSIDList.size() > i; i++)
        {
          String sCS_ID = (String) vSelCSIDList.elementAt(i);
          String sCSName = "";
          if (vSelCSList != null && vSelCSList.size() > i)
            sCSName = (String) vSelCSList.elementAt(i);
          //          System.out.println("selected " + sCSName);
          %>
											<option value="<%=sCS_ID%>">
												<%=sCSName%>
											</option>
											<%}
      }
      %>
										</select>
									</td>
									<td colspan=2 valign=top>
										<select name="selectedCSI" size="5" style="width:100%" multiple onchange="addSelectedAC();" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selCS',helpUrl); return false">
										</select>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<!-- contact info -->
					<tr>
						<td height="12" valign="top">
					</tr>
					<tr>
						<td valign="top" align=right>
							<%=item++%>
							)
						</td>
						<td valign="bottom">
							<font color="#FF0000">
								Select
							</font>
							Contacts
							<br>
							<table width=50% border="0">
								<col width="40%">
								<col width="15%">
								<col width="15%">
								<col width="15%">
								<tr>
									<td>
										&nbsp;
									</td>
									<td align="left">
										<input type="button" name="btnViewCt" value="Edit Item" onClick="javascript:editContact('view');" disabled>
									</td>
									<td align="left">
										<input type="button" name="btnCreateCt" value="Create New" onClick="javascript:editContact('new');">
									</td>
									<td align="center">
										<input type="button" name="btnRmvCt" value="Remove Item" onClick="javascript:editContact('remove');" disabled>
									</td>
								</tr>
								<tr>
									<td colspan=4 valign="top">
										<select name="selContact" size="4" style="width:100%" onchange="javascript:enableContButtons();" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContact',helpUrl); return false">
											<%		Enumeration enum1 = hContacts.keys();
      while (enum1.hasMoreElements())
      {
        String contName = (String) enum1.nextElement();
        AC_CONTACT_Bean acCont = (AC_CONTACT_Bean) hContacts.get(contName);
        if (acCont == null) acCont = new AC_CONTACT_Bean();
        String ctSubmit = acCont.getACC_SUBMIT_ACTION();
        if (ctSubmit != null && ctSubmit.equals("DEL")) continue;
        /*  String accID = acCont.getAC_CONTACT_IDSEQ();
         String contName = acCont.getORG_NAME();
         if (contName == null || contName.equals(""))
         contName = acCont.getPERSON_NAME(); */
%>
											<option value="<%=contName%>">
												<%=contName%>
											</option>
											<%}
%>
										</select>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<!-- vd origin -->
					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Select
							</font>
							Value Domain Origin
						</td>
					</tr>

					<tr>
						<td>
							&nbsp;
						</td>
						<td height="25" valign="top">
							<select name="selSource" size="1" onHelp="showHelp('html/Help_CreateVD.html#createVDForm_selSource',helpUrl); return false">
								<option value=""></option>
								<%boolean isFound = false;
      for (int i = 0; vSource.size() > i; i++)
      {
        String sSor = (String) vSource.elementAt(i);
        if (sSor.equals(sSource)) isFound = true;
%>
								<option value="<%=sSor%>" <%if(sSor.equals(sSource)){%> selected <%}%>>
									<%=sSor%>
								</option>
								<%}
      //add the user entered if not found in the drop down list
      if (!isFound)
      {
        sSource = serUtil.parsedStringDoubleQuoteJSP(sSource); //call the function to handle doubleQuote
        %>
								<option value="<%=sSource%>" selected>
									<%=sSource%>
								</option>
								<%}
      %>
							</select>
							<!--  &nbsp;&nbsp;<font color="#FF0000"> <a href="javascript:createOrigin();">Create New</a></font>      -->
						</td>
					</tr>

					<tr height="25" valign="bottom">
						<td align=right>
							<%=item++%>
							)
						</td>
						<td>
							<font color="#FF0000">
								Create
							</font>
							Change Note
						</td>
					</tr>

					<tr>
						<td>
							&nbsp;
						</td>
						<td height="35" valign="top">
							<textarea name="CreateChangeNote" cols="69" rows="2"><%=sChangeNote%></textarea>
						</td>
					</tr>
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
							the New Value Domain
						</td>
					</tr>
				</table>
			</div>
			<div style="display:none">
				<input type="hidden" name="actSelect" value="">
				<input type="hidden" name="VDAction" value="NewVD">
				<input type="hidden" name="vdIDSEQ" value="<%=sVDIDSEQ%>">
				<input type="hidden" name="CDE_IDTxt" value="<%=sPublicVDID%>">
				<input type="hidden" name="pageAction" value="nothing">
				<!--<input type="hidden" name="hiddenPValue" value="">
<input type="hidden" name="VMOrigin" value="ValueDomain"> -->
				<input type="hidden" name="selObjectClassText" value="<%=sObjClass%>">
				<input type="hidden" name="selPropertyClassText" value="<%=sPropClass%>">
				<input type="hidden" name="selObjectQualifierText" value="<%=sObjQual%>">
				<input type="hidden" name="selPropertyQualifierText" value="<%=sPropQual%>">
				<input type="hidden" name="selObjectClassLN" value="<%=sObjClass%>">
				<input type="hidden" name="selPropertyClassLN" value="<%=sPropClass%>">
				<input type="hidden" name="selObjectQualifierLN" value="<%=sObjQual%>">
				<input type="hidden" name="selPropertyQualifierLN" value="<%=sPropQual%>">
				<input type="hidden" name="selRepTermLN" value="<%=sRepTerm%>">
				<input type="hidden" name="selRepQualifierLN" value="">
				<input type="hidden" name="selRepTermText" value="<%=sRepTerm%>">
				<input type="hidden" name="selRepTermID" value="<%=sRepTermID%>">
				<input type="hidden" name="selRepQualifierText" value="">
				<input type="hidden" name="selConceptualDomainText" value="<%=sConDom%>">
				<input type="hidden" name="selContextText" value="<%=sContext%>">
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
				<input type="hidden" name="sCompBlocks" id="sCompBlocks" value="">
				<input type="hidden" name="nvpConcept" id="nvpConcept" value="">

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
					<%if (vACId != null)
      {
        for (int i = 0; vACId.size() > i; i++)
        {
          String sAC_ID = (String) vACId.elementAt(i);
          String sACName = "";
          if (vACName != null && vACName.size() > i) sACName = (String) vACName.elementAt(i);
          //     System.out.println("selected " + sACName);
          %>
					<option value="<%=sAC_ID%>">
						<%=sACName%>
					</option>
					<%}
      }
      %>
				</select>
				<select name="vRepQualifierCodes" size="1" style="visibility:hidden;width:100;" multiple>
					<%if (vRepQualifierCodes != null)
      {
        for (int i = 0; vRepQualifierCodes.size() > i; i++)
        {
          String sRepQualifierCode = (String) vRepQualifierCodes.elementAt(i);
%>
					<option value="<%=sRepQualifierCode%>">
						<%=sRepQualifierCode%>
					</option>
					<%}
      }
      %>
				</select>
				<select name="vRepQualifierDB" size="1" style="visibility:hidden;width:100;" multiple>
					<%if (vRepQualifierDB != null)
      {
        for (int i = 0; vRepQualifierDB.size() > i; i++)
        {
          String sRepQualifierDB = (String) vRepQualifierDB.elementAt(i);
%>
					<option value="<%=sRepQualifierDB%>">
						<%=sRepQualifierDB%>
					</option>
					<%}
      }
      %>
				</select>
				<!-- store datatype description to use later -->
				<select name="datatypeDesc" size="1" style="visibility:hidden;width:100;" multiple>
					<%if (vDataTypes != null)
      {
        for (int i = 0; vDataTypes.size() > i; i++)
        {
          String sDType = (String) vDataTypes.elementAt(i);
          String sDTDesc = "", sDTComm = "";
          if (i < vDataTypeDesc.size()) sDTDesc = (String) vDataTypeDesc.elementAt(i);
          if (sDTDesc == null || sDTDesc.equals("")) sDTDesc = sDType;
          if (i < vDataTypeCom.size()) sDTComm = (String) vDataTypeCom.elementAt(i);
          if (sDTComm == null) sDTComm = "";
%>
					<option value="<%=sDTDesc%>">
						<%=sDTComm%>
					</option>
					<%}
      }
      %>
				</select>
				
				<!-- store datatype scheme-ref and annotation to use later -->
				<select name="datatypeSRef" size="1" style="visibility:hidden;width:100;" multiple>
					<%if (vDataTypes != null)
      {
        for (int i = 0; vDataTypes.size() > i; i++)
        {
          String sDType = (String) vDataTypes.elementAt(i);
          String sDTSRef = "", sDTAnnotation = "";
          if (i < vDataTypeSRef.size()) sDTSRef = (String) vDataTypeSRef.elementAt(i);
          if (sDTSRef == null) sDTSRef = "";
          if (i <VDataTypeAnnotation.size()) sDTAnnotation = (String) VDataTypeAnnotation.elementAt(i);
          if (sDTAnnotation == null) sDTAnnotation = "";
%>
					<option value="<%=sDTSRef%>">
						<%=sDTAnnotation%>
					</option>
					<%}
      }
      %>
				</select>

				<!-- stores the selected rows to get the bean from the search results -->
				<select name="hiddenSelRow" size="1" style="visibility:hidden;width:160" multiple></select>
				<input type="hidden" name="acSearch" value="">
			</div>
			<script language="javascript">
//call function to initiate form objects
createObject("document.createVDForm");
displayStatusMessage();
changeCountLN();
changeCountPN();
loadCSCSI();
ShowEVSInfo('RepQualifier');
changeDataType();
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
