<html>
<head>
<title>Edit Value Domain</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="FullDesignArial.css" rel="stylesheet" type="text/css">
<SCRIPT LANGUAGE="JavaScript" SRC="Assets/AddNewListOption.js"></SCRIPT>
<%@ page import="com.scenpro.NCICuration.*" %>
<%@ page import="java.util.*" %>
<%@ page session="true" %>
<SCRIPT LANGUAGE="JavaScript" SRC="Assets/date-picker.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="Assets/CreateVD.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="Assets/SelectCS_CSI.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../../cdecurate/Assets/HelpFunctions.js"></SCRIPT>
<%
    String sOriginAction = (String)session.getAttribute("originAction");
    Vector vStatus = (Vector)session.getAttribute("vStatusVD");
    Vector vDataTypes = (Vector)session.getAttribute("vDataType");
    Vector vDataTypeDesc = (Vector)session.getAttribute("vDataTypeDesc");
    Vector vDataTypeCom = (Vector)session.getAttribute("vDataTypeComment");
//System.out.println("jsp before vDataTypes.size(): " + vDataTypes.size());
    if(sOriginAction.equals("BlockEditVD"))
    {
      vDataTypeDesc.add(0,"");
      vDataTypes.add(0,"");
      vDataTypeCom.add(0,"");
    }
//System.out.println("jsp after vDataTypes.size(): " + vDataTypes.size());
    
    Vector vUOM = (Vector)session.getAttribute("vUOM");
    Vector vUOMFormat = (Vector)session.getAttribute("vUOMFormat");
    Vector vCD = (Vector)session.getAttribute("vCD");
    Vector vCDID = (Vector)session.getAttribute("vCD_ID");
    Vector vLanguage = (Vector)session.getAttribute("vLanguage");
    Vector vSource = (Vector)session.getAttribute("vSource");
    Vector vContext = (Vector)session.getAttribute("vWriteContextVD");
    Vector vContextID = (Vector)session.getAttribute("vWriteContextVD_ID");
    Vector vCS = (Vector)session.getAttribute("vCS");
    Vector vCS_ID = (Vector)session.getAttribute("vCS_ID");
    
    VD_Bean m_VD = new VD_Bean();
    m_VD = (VD_Bean)session.getAttribute("m_VD");
    if (m_VD == null) m_VD = new VD_Bean();
    
    UtilService serUtil = new UtilService();
    String sMenuAction = (String)session.getAttribute("MenuAction");
   

    String sVDIDSEQ = m_VD.getVD_VD_IDSEQ();
    if (sVDIDSEQ == null) sVDIDSEQ = "";
    String sPublicVDID = m_VD.getVD_VD_ID();
    if (sPublicVDID == null) sPublicVDID = "";

    String selPropQRow = (String)session.getAttribute("selPropQRow");
    if (selPropQRow == null) selPropQRow = "";
    String selObjQRow = (String)session.getAttribute("selObjQRow");
    if (selObjQRow == null) selObjQRow = "";
    String selRepQRow = (String)session.getAttribute("selRepQRow");
    if (selRepQRow == null) selRepQRow = "";
    String selPropRow = (String)session.getAttribute("selPropRow");
    if (selPropRow == null) selPropRow = "";
    String selObjRow = (String)session.getAttribute("selObjRow");
    if (selObjRow == null) selObjRow = "";
    String selRepRow = (String)session.getAttribute("selRepRow");
    if (selRepRow == null) selRepRow = "";

    String sContext = m_VD.getVD_CONTEXT_NAME();
    if (sContext == null) sContext = "";
    String sContID = m_VD.getVD_CONTE_IDSEQ();
    if (sContID == null) sContID = "";
    //get the selected contexts
    Vector vSelectedContext = m_VD.getVD_SELECTED_CONTEXT_ID();
    
    String sObjQual = m_VD.getVD_OBJ_QUAL();
    sObjQual = serUtil.parsedString(sObjQual);    //call the function to handle doubleQuote
    if (sObjQual == null) sObjQual = "";
    String sObjClass = m_VD.getVD_OBJ_CLASS();
    sObjClass = serUtil.parsedString(sObjClass);    //call the function to handle doubleQuote
    if (sObjClass == null) sObjClass = "";
    String sPropQual = m_VD.getVD_PROP_QUAL();
    sPropQual = serUtil.parsedString(sPropQual);    //call the function to handle doubleQuote
    if (sPropQual == null) sPropQual = "";
    String sPropClass = m_VD.getVD_PROP_CLASS();
    sPropClass = serUtil.parsedString(sPropClass);    //call the function to handle doubleQuote
    if (sPropClass == null) sPropClass = "";
    String sRepTermID = m_VD.getVD_REP_IDSEQ();
    if (sRepTermID == null) sRepTermID = "";
    String sRepTerm = "";   //make the rep term using the concepts
    
    String sRepTermVocab = m_VD.getVD_REP_EVS_CUI_ORIGEN();
    if (sRepTermVocab == null || sRepTermVocab.equals("null")) sRepTermVocab = "";
     String sRepTerm_ID = m_VD.getVD_REP_CONCEPT_CODE();
    if (sRepTerm_ID == null || sRepTerm_ID.equals("null")) sRepTerm_ID = "";  
    String sRepQualVocab = m_VD.getVD_REP_QUAL_EVS_CUI_ORIGEN();
    sRepQualVocab = serUtil.parsedString(sRepQualVocab);    //call the function to handle doubleQuote
    if (sRepQualVocab == null || sRepQualVocab.equals("null")) sRepQualVocab = "";
    String sRepQualID = m_VD.getVD_REP_QUAL_CONCEPT_CODE();
    if (sRepQualID == null || sRepQualID.equals("null")) sRepQualID = "";
    
    Vector vRepQualifierNames = m_VD.getVD_REP_QUALIFIER_NAMES();
    if (vRepQualifierNames == null) vRepQualifierNames = new Vector();
    Vector vRepQualifierCodes = m_VD.getVD_REP_QUALIFIER_CODES();
    if (vRepQualifierCodes == null) vRepQualifierCodes = new Vector();
    Vector vRepQualifierDB = m_VD.getVD_REP_QUALIFIER_DB();
    if (vRepQualifierDB == null) vRepQualifierDB = new Vector();
    
    String sLongName = m_VD.getVD_LONG_NAME();
    sLongName = serUtil.parsedString(sLongName);    //call the function to handle doubleQuote
    if (sLongName == null) sLongName = "";
    int sLongNameCount = sLongName.length(); 
    String sRepCCodeDB = m_VD.getVD_REP_EVS_CUI_ORIGEN();
    String sRepCCode = m_VD.getVD_REP_CONCEPT_CODE();
    String sRepTermPrimary = m_VD.getVD_REP_NAME_PRIMARY();
    if(sRepTermPrimary == null) sRepTermPrimary = "";
    if(sRepTermPrimary.equals(""))
    {
      sRepTermVocab = "";
      sRepTerm_ID = "";
    }
      
    String sRepQualLN = "";
    for (int i = 0; vRepQualifierNames.size()>i; i++)
    {
      if(i == 0)
        sRepQualLN = (String)vRepQualifierNames.elementAt(i);
      else
        sRepQualLN = sRepQualLN + " " + (String)vRepQualifierNames.elementAt(i);
    }
    //add rep qual names to rep term
    if (sRepQualLN != null && !sRepQualLN.equals("") && !sRepQualLN.equals(" "))
      sRepTerm = sRepQualLN;
      
    //get rep primary 
    if (!sRepTermPrimary.equals("") && !sRepTermPrimary.equals(" "))
    {
      //add a space to rep term
      if (sRepTerm != null && !sRepTerm.equals("")) sRepTerm += " ";
      sRepTerm += sRepTermPrimary;  //add rep term primary
    }
    sRepTerm = serUtil.parsedString(sRepTerm);    //call the function to handle doubleQuote

    if(sRepCCodeDB == null) sRepCCodeDB = "";
    if(sRepCCode == null) sRepCCode = "";
    if(sRepTerm == null) sRepTerm = "";
    
    // Make Preferred Name for Obj Qual
    String sRepQualLong = "";
    for (int i = 0; vRepQualifierNames.size()>i; i++)
    {
       sRepQualLong = (String)vRepQualifierNames.elementAt(i);
       if(sRepQualLong == null) sRepQualLong = "";
    }
    boolean nameChanged = m_VD.getVDNAME_CHANGED();
     
    String sName = m_VD.getVD_PREFERRED_NAME();
    sName = serUtil.parsedString(sName);    //call the function to handle doubleQuote
    if (sName == null) sName = "";
    int sNameCount = sName.length();
    String sPrefType = m_VD.getAC_PREF_NAME_TYPE();
    if (sPrefType == null) sPrefType = ""; 
    String lblUserType = "Existing Name (Editable)";  //make string for user defined label
    String sUserEnt = m_VD.getAC_USER_PREF_NAME();
    if (sUserEnt == null || sUserEnt.equals("")) lblUserType = "User Entered";

    String sDefinition = m_VD.getVD_PREFERRED_DEFINITION();
    if (sDefinition == null) sDefinition = "";
    String sObjDefinition = m_VD.getVD_Obj_Definition();
    if (sObjDefinition == null) sObjDefinition = "";
    String sPropDefinition = m_VD.getVD_Prop_Definition();
    if (sPropDefinition == null) sPropDefinition = "";
    String sRepDefinition = m_VD.getVD_Rep_Definition();
    if (sRepDefinition == null) sRepDefinition = "";

    String sCCode = ""; //m_VD.getVD_REF_CONCEPT_CODE();
    if (sCCode == null) sCCode = "";
    String sUMLS = ""; //m_VD.getVD_REF_UMLS_CUI();
    if (sUMLS == null) sUMLS = "";
    String sTEMP = ""; //m_VD.getVD_REF_TEMP_CUI();
    if (sTEMP == null) sTEMP = "";

    String sVersion = m_VD.getVD_VERSION();
    if (sVersion == null) sVersion = "1.0";
    String sStatus = m_VD.getVD_ASL_NAME();
    if (sStatus == null && sOriginAction.equals("BlockEditVD")) sStatus = "";
    else if (sStatus == null) sStatus = "DRAFT NEW";
    String sConDomID = m_VD.getVD_CD_IDSEQ();
    if (sConDomID == null) sConDomID = "";
    String sConDom = m_VD.getVD_CD_NAME();
    if (sConDom == null) sConDom = "";
    String sBeginDate = m_VD.getVD_BEGIN_DATE();
    if (sBeginDate == null) sBeginDate = "";
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
    if (sDataType == null && !sOriginAction.equals("BlockEditVD")) sDataType = "ALPHANUMERIC";
    if (sDataType == null) sDataType = "";
    String sTypeFlag = m_VD.getVD_TYPE_FLAG();
    if (sTypeFlag == null) sTypeFlag = "E";
    session.setAttribute("pageVDType", sTypeFlag);
    String sEndDate = m_VD.getVD_END_DATE();
    if (sEndDate == null) sEndDate = "";
    String sDecimal = m_VD.getVD_DECIMAL_PLACE();
    if (sDecimal == null) sDecimal = "";
    String sChangeNote = m_VD.getVD_CHANGE_NOTE();
    if (sChangeNote == null) sChangeNote = "";

    //get parent attributes
    String sLastAction = (String)request.getAttribute("LastAction");
    if (sLastAction == null) sLastAction = "";    
    Vector vParentNames = new Vector();
    Vector vParentCodes = new Vector();
    Vector vParentDB = new Vector();   
    Vector vParentMetaSource = new Vector();
    Vector vdParent = (Vector)session.getAttribute("VDParentConcept");
    if (vdParent == null) vdParent = new Vector();    
    int vdCONs = 0;
    
    //use the pv bean to store vd-pv related attributes
    Vector vVDPVList = (Vector)session.getAttribute("VDPVList");
    if (vVDPVList == null) vVDPVList = new Vector();
    Vector vQVList = (Vector)session.getAttribute("NonMatchVV");
    if (vQVList == null) vQVList = new Vector();
    Vector vPVIDList = new Vector();
    String sPVRecs = "No ";
    int vdPVs = 0;
    if (vVDPVList.size()>0)
    {
      //loop through the list to get no of non deleted pvs
      for (int i=0; i<vVDPVList.size(); i++)
      {
        PV_Bean pvBean = (PV_Bean)vVDPVList.elementAt(i);
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

    String sSource = m_VD.getVD_SOURCE();
    if (sSource == null) sSource = "";
    boolean bDataFound = false;

    //these are for value/meaning search.
    session.setAttribute("MenuAction", "searchForCreate");
    Vector vResult = new Vector();
    session.setAttribute("results", vResult);
    session.setAttribute("creRecsFound", "No ");

    //reset the pv bean
    PV_Bean m_PV = new PV_Bean();
    session.setAttribute("m_PV", m_PV);

    //cs-csi data
    Vector vSelCSList = m_VD.getVD_CS_NAME();
    if (vSelCSList == null) vSelCSList = new Vector();
    Vector vSelCSIDList = m_VD.getVD_CS_ID();
    Vector vACCSIList = m_VD.getVD_AC_CSI_VECTOR();
    Vector vACId = (Vector)session.getAttribute("vACId");
    Vector vACName = (Vector)session.getAttribute("vACName");
    //initialize the beans
    CSI_Bean thisCSI = new CSI_Bean();
    AC_CSI_Bean thisACCSI = new AC_CSI_Bean();
    int item = 1;
    
    String sSearchAC = (String)session.getAttribute("creSearchAC");
%>

<SCRIPT LANGUAGE="JavaScript">
  var searchWindow = null;
  var evsTreeWindow = null;
  var pageOpening = "<%=sTypeFlag %>";
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
    String statusMessage = (String)session.getAttribute("statusMessage");
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
    else if (statusMessage != null && !statusMessage.equals(""))
    {%>
	       alert("<%=statusMessage%>");
    <% }
    //reset the status message to no message
    session.setAttribute("statusMessage", "");
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
<form name="createVDForm" method="POST" action="/cdecurate/NCICurationServlet?reqType=editVD">
  <table width="100%" border="0">
    <tr>
      <td height="26" align="left" valign="top">
        <input type="button" name="btnValidate" value="Validate" style="width: 125", "height: 30" onClick="SubmitValidate('validate')"
				onHelp = "showHelp('Help_CreateVD.html#createVDForm_Validation'); return false">
          &nbsp;&nbsp;
    <!--no need for clear button in the block edit-->
        <input type="button" name="btnClear" value="Clear" style="width: 125", "height: 30" onClick="ClearBoxes();">
          &nbsp;&nbsp;
<% if (!sOriginAction.equals("NewVDFromMenu")){%>
        <input type="button" name="btnBack" value="Back" style="width: 125", "height: 30" onClick="Back();">
          &nbsp;&nbsp;
<% } %>
<%if(sOriginAction.equals("BlockEditVD")){%>
        <input type="button" name="btnDetails" value="Details" 
				onHelp = "showHelp('Help_Updates.html#createVDForm_details'); return false" style="width: 125", "height: 30" onClick="openBEDisplayWindow();">
          &nbsp;&nbsp;
<%} else {%>
        <input type="button" name="btnAltName" value="Alternate Names" 
				onHelp = "showHelp('Help_Updates.html#createVDForm_altNames'); return false" style="width: 125", "height: 30" onClick="openAltNameWindow();">
          &nbsp;&nbsp;
<%}%>
 	     <img name="Message" src="Assets/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" style="visibility:hidden;">
      </td>
    </tr>
  </table>  
    
  <table width="100%" border=0 valign="top">
    <col width="4%"><col width="96%">
    <tr valign="middle"> 
        <th colspan=2 height="40"> <div align="left"> 
       <%if(sOriginAction.equals("BlockEditVD")){%>
          <label><font size=4>Block Edit Existing <font color="#FF0000">Value Domains</font></font></label>
       <% } else {%>
          <label><font size=4>Edit Existing <font color="#FF0000">Value Domain</font></font></label>
        <% } %>
        </div></th>
    </tr>
  <%if(!sOriginAction.equals("BlockEditVD")){%>
	  <tr height="25" valign="bottom">
        <td align="left" colspan=2 height="11"><font color="#FF0000">&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;</font>Indicates Required Field</td>
      </tr> 
    <%}%>

    <tr height="25" valign="bottom">
        <td align=right><font color="#C0C0C0"><%=item++%>)</font></td>
        <td><font color="#C0C0C0">Context</font></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td height="26">
        <select name="selContext" size="1"  readonly
          onHelp = "showHelp('Help_CreateVD.html#createVDForm_selContext'); return false">
          <option value="<%=sContID%>"><font color="#C0C0C0"><%=sContext%></font></option>
        </select>
      </td>
    </tr>

    <tr height="25" valign="bottom">
      <%if(sOriginAction.equals("BlockEditVD")){%>
          <td align="right"><font color="#C0C0C0"><%=item++%>) </font></td>
          <td><font color="#C0C0C0">Value Domain Type</font></td>
      <% } else {%>
          <td align="right"><font color="#FF0000">* &nbsp;&nbsp;</font><%=item++%>) </td>
          <td><font color="#FF0000">Select</font><font color="#000000"> Value Domain Type</font></td>
      <% } %>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>
        <%if(sOriginAction.equals("BlockEditVD")){%>
          <select name="listVDType" size="1" style="width: 150" onChange="ToggleDisableList2();" disabled
            onHelp = "showHelp('Help_CreateVD.html#createVDForm_selVDType'); return false">
           </select>
        <% } else { %>
           <select name="listVDType" size="1" style="width: 150" onChange="ToggleDisableList2();"
            onHelp = "showHelp('Help_CreateVD.html#createVDForm_selVDType'); return false">
             <option value="E" <%if(sTypeFlag.equals("E")){%>selected<%}%>>Enumerated</option>
             <option value="N" <%if(sTypeFlag.equals("N")){%>selected<%}%>>Non-Enumerated</option>
            </select>
        <% } %>       
      </td>
    </tr>
  <tr height="25" valign="bottom">
      <td align=right><%=item++%>)</td>
      <td> <font color="#FF0000">Select </font>Value Domain Name Components</td>
  </tr>
  <tr height="6"><td>&nbsp;</td></tr>
  <tr valign="bottom">
    <td colspan="2">
      <table border="0" width="100%">
        <col width="3%"><col width="45%"><col width="55%">
        <tr  valign="top">
          <td>&nbsp;</td>
          <td>
            <table border="1" width="100%">
              <tr  valign="top">
                <td>
                  <table border="0" width="100%" height="100%">
                   <!-- <col width="30%"><col width="18%"><col width="30%"><col width="18%"> -->
                    <col width="24%"><col width="12%"><col width="16%"><col width="20%"><col width="12%"><col width="16%">
                    <tr height="30" valign="middle">
                        <td colspan=6>Optional Name Components (will not be saved or displayed later)</td>
                    </tr>
                    <tr height="18"></tr>
                    <tr valign="top">
                      <td align="left">Object Class</td>
                      <td align="center"><font color="#FF0000">
                        <a href="javascript:SearchBuildingBlocks('VDObjectClass', 'false')">Search</a></font>
                      </td>
                      <td align="center"><font color="#FF0000">
                        <a href="javascript:RemoveBuildingBlocks('VDObjectClass')">Remove</a></font>
                      </td>
                      <td align="left">Property</td>
                      <td align="center"><font color="#FF0000">
                        <a href="javascript:SearchBuildingBlocks('VDPropertyClass','false')">Search</a></font>
                      </td>
                      <td align="center"><font color="#FF0000">
                        <a href="javascript:RemoveBuildingBlocks('VDPropertyClass')">Remove</a></font>
                      </td>
                    </tr>
                    <tr valign="top">
                      <td colspan="3">
                        <select name="selObjectClass" style="width:98%" valign="top" size="1" multiple
                          onHelp = "showHelp('Help_CreateVD.html#createVDForm_nameBlocks'); return false">
                              <option value="<%=sObjClass%>"><%=sObjClass%></option>
                        </select>
                      </td>
                      <td colspan="3">
                         <select name="selPropertyClass" style="width:98%" valign="top" size="1" multiple
                            onHelp = "showHelp('Help_CreateVD.html#createVDForm_nameBlocks'); return false">
                                <option value="<%=sPropClass%>"><%=sPropClass%></option>
                         </select>
                      </td>
                    </tr>
                    <tr height="105"><td>&nbsp;</td></tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
          <!-- empty column to seperate componenets -->
          <!-- represention block -->
          <td>
            <table border="1" width="100%">
              <tr valign="top">
                <td>
                  <table border="0" width="99%">
                  <col width="26%"><col width="10%"><col width="14%"><col width="26%"><col width="10%"><col width="14%">
                  <tr height="30" valign="middle">
                        <td colspan=4>Value Domain Attributes</td>
                  </tr>
                  <tr><td colspan="2" align="left" valign="top">Rep Term Long Name</td></tr>
                  <tr>
                    <td colspan="5" align="left">
                      <input type="text" name="txtRepTerm" value="<%=sRepTerm%>" style="width=100%" valign="top" readonly="readonly">
                    </td>
                  </tr>
                  <tr height="8"><td></td></tr>
                  <tr valign="bottom">
                    <td align="left" valign="top">Qualifier <br> Concepts</td>
                    <td align="right" valign="middle">
                     <!-- <input type="button" name="btnSerSecOC" value="Search" style="width:95%" onClick="javascript:SearchBuildingBlocks('ObjectQualifier', 'false');">-->
                    <font color="#FF0000">  <a href="javascript:SearchBuildingBlocks('RepQualifier', 'false')">Search</a></font>
                    </td>
                    <td align="center" valign="middle">
                     <!-- <input type="button" name="btnRmSecOC" value="Remove" style="width:90%" onClick="javascript:removeQualifier();">-->
                      <font color="#FF0000"><a href="javascript:RemoveBuildingBlocks('RepQualifier')">Remove</a></font>  
                    </td>
                    <td align="left" valign="top">Primary <br>Concept</td>
                    <td align="right" valign="middle">
                      <!--<input type="button" name="btnSerPriOC" value="Search" style="width:95%" onClick="javascript:SearchBuildingBlocks('ObjectClass', 'false');">-->
                      <font color="#FF0000"><a href="javascript:SearchBuildingBlocks('RepTerm', 'false')">Search</a></font> 
                    </td>
                    <td align="center" valign="middle">
                      <!--<input type="button" name="btnRmPriOC" value="Remove" style="width:90%" onClick="">-->
                      <font color="#FF0000"><a href="javascript:RemoveBuildingBlocks('RepTerm')">Remove</a></font>  
                    </td>
                  </tr>
                  <tr align="left">
                    <td colspan="3" valign="top">
                         <select name="selRepQualifier" size ="2" style="width=98%" valign="top" onClick="ShowEVSInfo('RepQualifier')"
                          onHelp = "showHelp('Help_CreateVD.html#createVDForm_nameBlocks'); return false">
                          <%if (vRepQualifierNames.size()<1) {%>  
                            <option value=""></option>
                          <% } else { %>
                            <%for (int i = 0; vRepQualifierNames.size()>i; i++)
                              {
                                String sQualName = (String)vRepQualifierNames.elementAt(i);
                              %>
                            <option value="<%=sQualName%>" <%if(i==0){%>selected<%}%>><%=sQualName%></option>
                            <%}%>
                          <% } %>
                        </select>
                    </td>
                    <td colspan="3" valign="top">

                      <select name="selRepTerm" style="width=98%" valign="top" size="1" multiple
                        onHelp = "showHelp('Help_CreateVD.html#createVDForm_nameBlocks'); return false">
                            <option value="<%=sRepTermPrimary%>"><%=sRepTermPrimary%></option>
                      </select>
                    </td>
                  </tr>
                  <tr>
                    <td colspan="3">&nbsp;&nbsp;<label id="RepQual" for="selRepQualifier" title=""></label></td>
                    <td colspan="3">&nbsp;&nbsp;<label id="RepTerm" for="selRepTerm" title=""></label></td>
                  </tr>
                  <tr>
                    <td colspan="3">&nbsp;&nbsp;<a href=""><label id="RepQualID" for="selRepQualifier" title="" 
                        onclick="javascript:SearchBuildingBlocks('RepQualifier', 'true')"></label></a></td>
                    <td colspan="3">&nbsp;&nbsp;<a href=""><label id="RepTermID" for="selRepTerm" title=""
                        onclick="javascript:SearchBuildingBlocks('RepTerm', 'true')"></label></a></td>
                  </tr>  
                  <tr height="1"><td></td></tr>
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
      <%if(sOriginAction.equals("BlockEditVD")){%>
        <td align="right"><font color="#C0C0C0"><%=item++%>)</font></td>
        <td><font color="#C0C0C0">Verify Value Domain Long Name</font></td>
      <% } else {%>
        <td align="right"><font color="#FF0000">* &nbsp;</font><%=item++%>)</td>
        <td><font color="#FF0000">Verify  </font>Value Domain Long Name</td>
      <% } %>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td height="24" valign="top" >
        <input name="txtLongName" type="text" size="100" value="<%=sLongName%>" onKeyUp="changeCountLN();"
        <%if(sOriginAction.equals("BlockEditVD")){%>readonly<%}%>
          onHelp = "showHelp('Help_CreateVD.html#createVDForm_txtLongName'); return false">
          &nbsp;&nbsp;
        <input name="txtLongNameCount" type="text" value="<%=sLongNameCount%>"
          size="1" readonly
          onHelp = "showHelp('Help_CreateVD.html#createVDForm_txtLongName'); return false">
      <%if(sOriginAction.equals("BlockEditVD")){%>
        <font color="#C0C0C0"> Character Count  &nbsp;&nbsp;(Database Max = 255)</font>
      <% } else {%>
        <font color="#000000"> Character Count  &nbsp;&nbsp;(Database Max = 255)</font>
      <% } %>

      </td>
    </tr>
    <tr valign="bottom" height="25">
       <%if(sOriginAction.equals("BlockEditVD")){%>
        <td align=right><font color="#C0C0C0"><%=item++%>) </font></td>
        <td><font color="#C0C0C0">Update Value Domain Preferred Name </font></td>
       <% } else {%>
        <td align=right><font color="#FF0000">* &nbsp;</font><%=item++%>) </td>
        <td><font color="#FF0000">Update </font><font color="#000000">Value Domain Preferred Name </font></td>
       <% } %>
    </tr>
  <%if(!sOriginAction.equals("BlockEditVD")){%>
    <tr>
      <td>&nbsp;</td>
      <td height="24" valign="bottom">Select Preferred Name Naming Standard</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td height="24" valign="top">
        <input name="rNameConv" type="radio" value="SYS" onclick="javascript:SubmitValidate('changeNameType');" <%if (sPrefType.equals("SYS")) {%> 
          checked <%}%>>System Generated &nbsp;&nbsp;&nbsp; 
        <input name="rNameConv" type="radio" value="ABBR" onclick="javascript:SubmitValidate('changeNameType');" <%if (sPrefType.equals("ABBR")) {%> 
          checked <%}%>>Abbreviated &nbsp;&nbsp;&nbsp; 
        <input name="rNameConv" type="radio" value="USER" onclick="javascript:SubmitValidate('changeNameType');" <%if (sPrefType.equals("USER")) {%> 
          checked <%}%>><%=lblUserType%>   <!--Existing Name (Editable)  User Maintained-->
      </td>
    </tr>
  <% } %>
    <tr>
      <td>&nbsp;</td>
      <td height="24" valign="top">
         <input name="txtPreferredName" type="text" size="100" value="<%=sName%>" onKeyUp="changeCountPN();"
          <%if(sOriginAction.equals("BlockEditVD") || sPrefType.equals("") || sPrefType.equals("SYS") || sPrefType.equals("ABBR")){%>readonly<%}%>
          onHelp = "showHelp('Help_CreateVD.html#createVDForm_txtPreferredName'); return false">
          &nbsp;&nbsp;
        <input name="txtPrefNameCount" type="text"  value="<%=sNameCount%>"
          size="1" readonly
          onHelp = "showHelp('Help_CreateVD.html#createVDForm_txtPreferredName'); return false">
      <%if(sOriginAction.equals("BlockEditVD")){%>
        <font color="#C0C0C0"> Character Count   &nbsp;&nbsp;(Database Max = 30)</font>
      <% } else {%>
        <font color="#000000"> Character Count &nbsp;&nbsp;(Database Max = 30)</font>
      <% } %>
      </td>
    </tr>

    <tr height="25" valign="bottom">
      <td align=right><font color="#C0C0C0"><%=item++%>)</font></td>
      <td><font color="#C0C0C0">Public ID </font></td>
    </tr>
    <tr>
      <td align=right>&nbsp;</td>
      <td><font color="#C0C0C0"><input type="text" name="CDE_IDTxt" 
          value="<%=sPublicVDID%>" size="20" readonly 
          onHelp = "showHelp('Help_CreateVD.html#createVDForm_CDE_IDTxt'); return false"></font></td>
    </tr>
    <tr><td height="8" valign="top"></tr>
    <tr height="25" valign="top">
      <%if(sOriginAction.equals("BlockEditVD")){%>
        <td align=right><font color="#C0C0C0"><%=item++%>) </font></td>
        <td><font color="#C0C0C0">Create/Search for Definition </font></td>
      <% } else {%>
         <td align=right><font color="#FF0000">* &nbsp; </font><%=item++%>) </td>
         <td><font color="#FF0000">Create/Search</font> for Definition 
            (Changes of naming components would replace any user entered definition. 
            Please make any desired changes after selecting the naming components.)</td>
      <% } %>
    </tr>      
    <tr>
      <td>&nbsp;</td>
      <td valign="top" align="left">
        <%if(sOriginAction.equals("BlockEditVD")){%>
          <textarea name="CreateDefinition"  style="width:80%"  rows=6 readonly
            onHelp = "showHelp('Help_CreateVD.html#createVDForm_CreateDefinition'); return false"><%=sDefinition%></textarea>
          <!--  &nbsp;&nbsp; <font color="#C0C0C0">Search</a></font> -->
        <% } else {%>
          <textarea name="CreateDefinition" style="width:80%" rows=6
            onHelp = "showHelp('Help_CreateVD.html#createVDForm_CreateDefinition'); return false"><%=sDefinition%></textarea>
          <!-- &nbsp;&nbsp; <font color="#FF0000"> <a href="javascript:OpenEVSWindow()">Search</a></font> --> 
        <% } %>
      </td>
    </tr>
    <tr height="25" valign="bottom">
      <td align=right><%if(!sOriginAction.equals("BlockEditVD")){%><font color="#FF0000">*&nbsp;&nbsp;&nbsp;</font><%}%><%=item++%>) </td>
      <td><font color="#FF0000">Select <font color="#000000">Conceptual Domain </font></font> </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>
        <select name= "selConceptualDomain" size ="1" style="width:430" multiple
          onHelp = "showHelp('Help_CreateVD.html#createVDForm_selConceptualDomain'); return false">
          <option value="<%=sConDomID%>"><%=sConDom%></option>
        </select> 
        &nbsp;&nbsp;<font color="#FF0000"><a href="javascript:SearchCDValue()">Search</a></font>
      </td>
    </tr>

    <tr height="25" valign="bottom">
      <td align=right><%if(!sOriginAction.equals("BlockEditVD")){%><font color="#FF0000">*&nbsp;</font><%}%><%=item++%>) </td>
      <td><font color="#FF0000">Select</font> Workflow Status</td>
    </tr>
    <tr>
    	<td>&nbsp;</td>
   		 <td>
        <select name="selStatus" size="1"
          onHelp = "showHelp('Help_CreateVD.html#createVDForm_selStatus'); return false">
          <option value="" selected="selected"></option>
          <%
          for (int i = 0; vStatus.size()>i; i++)
          {
             String sStatusName = (String)vStatus.elementAt(i);
%>
               <option value="<%=sStatusName%>" <%if (sStatusName.equals(sStatus)){ %>selected<%}%> ><%=sStatusName%></option>
<%
          }
%>
        </select> </td>
    </tr>
    <tr height="25" valign="bottom">
      <%if(sOriginAction.equals("BlockEditVD")){%>
        <td align=right><%=item++%>)</td>
        <td height="25" valign="bottom"><font color="#FF0000">Check</font> Box to Create New Version
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://ncicb.nci.nih.gov/NCICB/core/caDSR/BusinessRules" target="_blank">Business Rules</a>
        </td>
      <% } else {%>
        <td align=right><font color="#C0C0C0"> <%=item++%>)</font></td>
        <td><font color="#C0C0C0">Version</font></td>
      <% } %>
    </tr>
    <tr>
      <td >&nbsp;</td>
        <%if(sOriginAction.equals("BlockEditVD")){ %>
          <td>
            <table width="50%">
             <col width="15%"><col width="10%"><col width="10%">
             <tr height="25"> 
                <!--Version check is checked only if the sVersion is either Whole or Point   -->
                <td valign="top">&nbsp;&nbsp;
                  <input type="checkbox" name="VersionCheck" onClick="javascript:EnableChecks(checked,this);" value="ON"
                      <% if(sVersion.equals("Whole") || sVersion.equals("Point")) { %>checked<% } %>
                      onHelp = "showHelp('Help_CreateVD.html#createVDForm_BlockVersion'); return false"></td>
                <!--Point check is checked only if the sVersion is Point and disabled otherwise  -->
                <td>
                  <input type="checkbox" name="PointCheck" onClick="javascript:EnableChecks(checked,this);" value="ON"
                      <%if(sVersion.equals("Point")){%> checked <%} else {%> disabled <%}%>
                      onHelp = "showHelp('Help_CreateVD.html#createVDForm_BlockVersion'); return false">
                      &nbsp;Point Increase</td>
                <!--Whole check is checked only if the sVersion is Whole and disabled otherwise  -->
                <td>
                  <input type="checkbox" name="WholeCheck" onClick="javascript:EnableChecks(checked,this)" value="ON"
                      <%if(sVersion.equals("Whole")){%> checked <%} else {%> disabled <%}%>
                      onHelp = "showHelp('Help_CreateVD.html#createVDForm_BlockVersion'); return false">
                      &nbsp;Whole Increase
                </td>
              </tr>
            </table> 
          </td>
        <% } else { %>
          <td valign="top"><font color="#C0C0C0">
            <input type="text" name="Version" value="<%=sVersion%>" size=5 readonly 
              onHelp = "showHelp('Help_CreateVD.html#createVDForm_Version'); return false"></font>
              &nbsp;&nbsp;&nbsp;<a href="http://ncicb.nci.nih.gov/NCICB/core/caDSR/BusinessRules" target="_blank">Business Rules</a>
          </td>
        <% } %>       
    </tr>
    <tr height="25" valign="bottom">
      <td align=right><%if(!sOriginAction.equals("BlockEditVD")){%><font color="#FF0000">*&nbsp;</font><%}%><%=item++%>) </td>
      <td><font color="#FF0000"> Select</font> Data Type </td>
    </tr>  
  <tr height="8"><td>&nbsp;</td></tr>    
  <tr>
    <td>&nbsp;</td>
    <td>
      <table width="90%" border="1">
        <col width="20%"><col width="35%"><col width="35%">
        <tr>
          <td valign="top">
            <select name= "selDataType" size ="1" onChange="javascript:changeDataType();"  style="width:90%"
              onHelp = "showHelp('Help_CreateVD.html#createVDForm_selDataType'); return false">             
<%
              for (int i = 0; vDataTypes.size()>i; i++)
              {
                 String sCD = (String)vDataTypes.elementAt(i);
%>
              <option value="<%=sCD%>" <%if(sCD.equalsIgnoreCase(sDataType)){%>selected<%}%> ><%=sCD%></option>
<%
              }
%>
            </select>
          </td>
          <td valign="top" height="25">Data Type Description:<br><label id="lblDTDesc" for="selDataType" style="width:95%" title=""></label></td>
          <td valign="top" height="25">Data Type Comment:<br><label id="lblDTComment" for="selDataType" style="width:95%" title=""></label></td>
        </tr> 
      </table>
    </td>
  </tr>
<%if (!sOriginAction.equals("BlockEditVD")) {%>
    <tr height="15"><td> </td></tr>
    <tr>
      <td colspan="2">
        <table width="85%" border="0" align="left" cellspacing="0" cellpadding="0">
          <col width="3%"><col width="30%"><col width="4%"><col width="4%"><col width="32%">
          <tr align=left> 
            <td align=right><%if (sTypeFlag.equals("E")){%><font color="#FF0000">* </font><%}%><%=item++%>)</td>
            <td align=left><font color="#FF0000">Create </font> 
              <% if (sTypeFlag.equals("E")) { %>Permissible Value
              <% } else { %>Referenced Value<% } %>
            </td>    
            <td colspan="2">&nbsp;</td>
            <td><img name="Message2" src="Assets/WaitMessageSmall.gif" width="130" height="26" alt="WaitMessage" style="visibility:hidden;">
          </tr>
        </table>
      </td>
    </tr>  
   <tr>
    <td>&nbsp;</td>
    <td>&nbsp;&nbsp;
      <table width="70%" border="0">
        <col width="50%"><col width="15%"><col width="15%"><col width="15%">
        <tr>
          <td>
            <% if(sTypeFlag.equals("E")){%>Select Parent Concept to Constrain Permissible Values
            <%}else{%>Select Non-enumerated Value Domain Reference Concept<%}%>          
          </td>
          <td align="left">
              <input type="button" name="btnSelectValues" style="width:90" value="Select Values" disabled onClick="selectValues()">
          </td>
          <td align="center">
            <input type="button" name="btnRemoveConcept" style="width:100%" value="Remove Parent" disabled onClick="javascript:removeParent();">
          </td>
          <td>&nbsp;</td>
        </tr>  
        <tr valign="top">
          <td colspan=3>
            <select name="listParentConcept" size ="4" style="width:100%" onclick="javascript:selectParent();"
              onHelp = "showHelp('Help_CreateVD.html#createVDForm_selConceptualDomain'); return false">
              <%if (vdParent != null) 
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
                  String pCode = eBean.getNCI_CC_VAL();  //code
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
              %>
                <option value="<%=pDB%>" <%if(sLastAction.equals("parSelected") && i == vdParent.size()-1){%>selected<%}%>><%=sParListString%></option> 
              <%  }
              } 
              %>
            </select> 
          </td>
          <td align="center">
            <!-- do not allow to pick parent if pvs exist but no parent   -->
            <%// if (!(vdCONs < 1 && vdPVs > 0)) { %>
              <a href="javascript:doPVAction('createParent');">Search Parent</a>
            <%// } %>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr><td>&nbsp; </td></tr>
<% if (sMenuAction.equals("Questions") && vQVList.size() > 0) { %>   <!-- when questions -->
  <tr height="25" valign="bottom">
    <td>&nbsp;</td>
    <td>List of un-matched Valid Values</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>    
      <select name= "selValidValue" size ="3" style="width:20%" onclick="javascript:disableSelect();" 
      onHelp = "showHelp('Help_CreateVD.html#createVDForm_selValidValue'); return false">
<%
        for (int i = 0; vQVList.size()>i; i++)
        {
          String sVV = (String)vQVList.elementAt(i);
%>
            <option value="<%=sVV%>"><%=sVV%></option>
<%
        }
%>
      </select> 
    </td>
  </tr>
<% } %>  <!-- end question -->
  <!---enumerated -->
<% if (sTypeFlag.equals("E")) { %> 
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;&nbsp;
      <table width="100%" border="0">
        <col width="12%"><col width="14%"><col width="14%"><col width="60%"><!--<col width="74%">-->
        <tr>
            <!-- value is Create Value when no value is selected, Edit Value(s) when one or more values selected 
          <td align="left"><input type="button" name="btnEditPV" value="Edit Value(s)" style="width: 95" disabled onClick="javascript:doPVAction('editPV');"></td>-->
          <td align="left"><input type="button" name="btnCreatePV" value="Create Value" style="width: 95" 
              onClick="javascript:doPVAction('createPV');" <%if (vdCONs>0) {%> disabled <%}%> > 
          </td>
          <%if (vdCONs > 0) { %>
            <td align="left"><input type="button" name="btnRemovePV" value="Remove Value(s)" style="width: 125" disabled onClick="javascript:doPVAction('removePV');"></td>
            <td> &nbsp; </td> 
          <% } else { %> 
            <td align="left"><input type="button" name="btnSelectPV" value="Search Value(s)" style="width: 110" onClick="javascript:doPVAction('createPVMultiple');"></td>
            <td align="left"><input type="button" name="btnRemovePV" value="Remove Value(s)" style="width: 125" disabled onClick="javascript:doPVAction('removePV');"></td>
          <% } %>
          <td align="right"><%=sPVRecs%> Records </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
      <table width="100%" border="1">
        <tr>
          <td>
            <table width="99%" border="0">
            <% if (vdCONs > 1 && sMenuAction.equals("Questions")) { %>
              <col width="2%"><col width="10%"><col width="14%"><col width="17%"><col width="15%">
              <col width="12%"><col width="8%"><col width="10%"><col width="8%"><col width="7%">
            <% } else if (sMenuAction.equals("Questions")) { %>
              <col width="2%"><col width="10%"><col width="15%"><col width="18%"><col width="14%">
              <col width="14%"><col width="12%"><col width="9%"><col width="8%">
            <% } else if (vdCONs > 1) { %>
              <col width="2%"><col width="15%"><col width="18%"><col width="14%"><col width="14%">
              <col width="10%"><col width="12%"><col width="9%"><col width="8%">
            <% } else { %>
              <col width="2%"><col width="15%"><col width="18%"><col width="24%">
              <col width="13%"><col width="12%"><col width="9%"><col width="8%">
            <% } %>
              <tr height="33" valign="middle">
                <th><%if (vdPVs >0){%>
                    <a href="javascript:selectAllPV('fromPage');">
                    <img id="CheckGif" src="../../cdecurate/Assets/CheckBox.gif" border="0" alt="Select All"></a>
                  <% } %>
                </th>
                <% if (sMenuAction.equals("Questions")) { %><th align="center"><a href="javascript:sortPV('ValidValue');">Valid Value</a></th><% } %>
                <th align="center"><a href="javascript:sortPV('value');">Permissible Value</a></th>
                <th align="center"><a href="javascript:sortPV('meaning');">Value Meaning</a></th>
                <th align="center"><a href="javascript:sortPV('MeanDesc');">Value Meaning Description</a></th>
                <th align="center"><a href="javascript:sortPV('VMConcept');">EVS Concept Code</a></th>       
                <% if (vdCONs >1) { %><th align="center"><a href="javascript:sortPV('ParConcept');">Parent Concept Code</a></th><% } %>
                <th align="center"><a href="javascript:sortPV('Origin');">Value Origin</a></th>       
                <th align="center"><a href="javascript:sortPV('BeginDate');">Begin Date</a></th>       
                <th align="center"><a href="javascript:sortPV('EndDate');">End Date</a></th>       
             </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>
<% 
            int iDivHt = 40;
            if (vdPVs >2) iDivHt = 180;
            else if (vdPVs >0) iDivHt = ((90 * vdPVs) + 10);
%>
            <div id="Layer1" style="position:relative; z-index:1; overflow:auto; width:100%; height:<%=iDivHt%>;">
            <table width="100%" border="1">
            <% if (vdCONs > 1 && sMenuAction.equals("Questions")) { %>
              <col width="2%"><col width="10%"><col width="14%"><col width="17%"><col width="15%">
              <col width="12%"><col width="8%"><col width="10%"><col width="8%"><col width="6%">
            <% } else if (sMenuAction.equals("Questions")) { %>
              <col width="2%"><col width="10%"><col width="15%"><col width="18%"><col width="14%">
              <col width="14%"><col width="12%"><col width="9%"><col width="7%">
            <% } else if (vdCONs > 1) { %>
              <col width="2%"><col width="15%"><col width="18%"><col width="14%"><col width="14%">
              <col width="10%"><col width="12%"><col width="9%"><col width="7%">
            <% } else { %>
              <col width="1%"><col width="15%"><col width="18%"><col width="24%">
              <col width="14%"><col width="12%"><col width="7%"><col width="7%">
            <% } %>
<%  
              if (vdPVs > 0 && vVDPVList != null && vVDPVList.size()> 0)
              {
                int ckCount = 0;
                for (int i=0; i<vVDPVList.size(); i++)
                {
                  PV_Bean pvBean = (PV_Bean)vVDPVList.elementAt(i);
                  if (pvBean == null) pvBean = new PV_Bean();
                  // display only if not deleted
                  if (pvBean.getVP_SUBMIT_ACTION() != null && pvBean.getVP_SUBMIT_ACTION().equals("DEL"))
                      continue;
                      
                  String ckName = ("ck" + ckCount); 
                  ckCount += 1;
                  boolean pvChecked = pvBean.getPV_CHECKED();
                  String sVValue = (String)pvBean.getQUESTION_VALUE();
                  if (sVValue == null) sVValue = "";
                  String sPVVal = (String)pvBean.getPV_VALUE();
                  if (sPVVal == null) sPVVal = "";
                  String sPVid = (String)pvBean.getPV_PV_IDSEQ();
                  if (sPVid == null || sPVid.equals("")) sPVid = "EVS_" + sPVVal;
                  vPVIDList.addElement(sPVid);  //add the ones on the page
                  String sPVMean = (String)pvBean.getPV_SHORT_MEANING();
                  if (sPVMean == null) sPVMean = "";
                  String sPVDesc = (String)pvBean.getPV_MEANING_DESCRIPTION();
                  if (sPVDesc == null) sPVDesc = "";
                  String sPVOrigin = (String)pvBean.getPV_VALUE_ORIGIN();
                  if (sPVOrigin == null) sPVOrigin = "";
                  EVS_Bean vmConcept = (EVS_Bean)pvBean.getVM_CONCEPT();
                  if (vmConcept == null) vmConcept = new EVS_Bean();
                  String evsDB = (String)vmConcept.getEVS_DATABASE();
                  if (evsDB == null) evsDB = "";
                  String evsID = (String)vmConcept.getNCI_CC_VAL();
                  String sEvsId = "";
                  if (evsID != null && !evsID.equals(""))
                    sEvsId = evsID + "\n" + evsDB;
                    
                  String sParId = "";
                  EVS_Bean parConcept = (EVS_Bean)pvBean.getPARENT_CONCEPT();
                  if (parConcept == null) parConcept = new EVS_Bean();
                  evsDB = (String)parConcept.getEVS_DATABASE();
                  if (evsDB == null) evsDB = "";
                  evsID = (String)parConcept.getNCI_CC_VAL();
                  if (evsID != null && !evsID.equals(""))
                    sParId = evsID + "\n" + evsDB;
                  
                  String sPVBegDate = (String)pvBean.getPV_BEGIN_DATE();
                  if (sPVBegDate == null) sPVBegDate = "";
                  String sPVEndDate = (String)pvBean.getPV_END_DATE();
                  if (sPVEndDate == null) sPVEndDate = "";
    %>
                  <tr style="height:90;">
                    <td align="right" valign="top"><input type="checkbox" name="<%=ckName%>" 
                      onClick="javascript:doPVCheckAction(checked,this,'fromPage');"  size="5"></td>
                    <% if (sMenuAction.equals("Questions")) { %><td valign="top"><%=sVValue%></td><% } %>
                    <td valign="top"><%=sPVVal%></td>
                    <td valign="top"><%=sPVMean%></td>
                    <td valign="top"><%=sPVDesc%></td>
                    <td valign="top"><%=sEvsId%></td>
                    <% if (vdCONs >1) { %><td valign="top"><%=sParId%></td><% } %>
                    <td valign="top"><%=sPVOrigin%></td>
                    <td valign="top"><%=sPVBegDate%></td>
                    <td valign="top"><%=sPVEndDate%></td>
                  </tr>  
    <%          }
              } else {
    %>
                  <tr>
                    <td align="right">&nbsp;</td>
                    <% if (sMenuAction.equals("Questions")) { %><td valign="top">&nbsp;</td><% } %>
                    <td valign="top">&nbsp;</td>
                    <td valign="top">&nbsp;</td>
                    <td valign="top">&nbsp;</td>
                    <% if (vdCONs >1) { %><td valign="top">&nbsp;</td><% } %>
                    <td valign="top">&nbsp;</td>
                    <td valign="top">&nbsp;</td>
                    <td valign="top">&nbsp;</td>
                    <td valign="top">&nbsp;</td>
                  </tr>  
    <%          }  %>
            </table>
            </div>
          </td>
        </tr>
      </table>
    </td>
  </tr>
<%  }  %>    <!-- end enumerated -->
<%  }  %>
  <tr height="25" valign=bottom>
      <td align=right><%if(!sOriginAction.equals("BlockEditVD")){%><font color="#FF0000">*&nbsp;</font><%}%><%=item++%>) </td>
      <td><font color="#FF0000">Enter/Select</font> Effective Begin Date</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top" >
        <input type="text" name="BeginDate" value="<%=sBeginDate%>" size="12" maxlength=10
         onHelp = "showHelp('Help_CreateVD.html#createVDForm_BeginDate'); return false">
        <a href="javascript:show_calendar('createVDForm.BeginDate', null, null, 'MM/DD/YYYY');" >
        <img name="Calendar" src="Assets/calendarbutton.gif" width="22" height="22" alt="Calendar" style="vertical-align: top">
        </a>&nbsp;&nbsp;MM/DD/YYYY
    </td>
  </tr>

  <tr height="25" valign="bottom">
      <td align=right><%=item++%>) </td>
      <td><font color="#FF0000">Enter/Select</font> Effective End Date</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
      <td>
        <input type="text" name="EndDate" value="<%=sEndDate%>" size="12" maxlength=10
          onHelp = "showHelp('Help_CreateVD.html#createVDForm_EndDate'); return false">
        <a href="javascript:show_calendar('createVDForm.EndDate', null, null, 'MM/DD/YYYY');">
        <img name="Calendar" src="Assets/calendarbutton.gif" width="22" height="22" alt="Calendar" style="vertical-align: top">
        </a>&nbsp;&nbsp;MM/DD/YYYY</td>
  </tr>
    <tr height="25" valign="bottom">
      <td align=right><%=item++%>)</td>
      <td><font color="#FF0000">Select</font> the Unit of Measure (UOM) </td>
    </tr>
    <tr>
    	<td>&nbsp;</td>
    	<td >
        <select name= "selUOM" size ="1"
          onHelp = "showHelp('Help_CreateVD.html#createVDForm_selUOM'); return false">
          <option value="" selected></option>
<%
          for (int i = 0; vUOM.size()>i; i++)
          {
             String sUOM = (String)vUOM.elementAt(i);
%>
             <option value="<%=sUOM%>" <%if(sUOM.equals(sUOML)){%>selected<%}%>><%=sUOM%></option>
<%
          }
%>
        </select>
      </td>
     </tr>
    <tr height="25" valign="bottom">
      <td align=right><%=item++%>) </td>
      <td><font color="#FF0000"> Select</font> Display Format </td>
    </tr>
    <tr>
     <td>&nbsp;</td>
    	<td >
        <select name= "selUOMFormat" size ="1"
          onHelp = "showHelp('Help_CreateVD.html#createVDForm_selUOMFormat'); return false">
          <option value="" selected></option>
<%        for (int i = 0; vUOMFormat.size()>i; i++)
          {
             String sUOMF = (String)vUOMFormat.elementAt(i);
%>
             <option value="<%=sUOMF%>" <%if(sUOMF.equals(sFORML)){%>selected<%}%>><%=sUOMF%></option>
<%
          }
%>
        </select>
      </td>
    </tr>
    <tr height="25" valign="bottom">
      <td align=right><%=item++%>) </td>
      <td><font color="#FF0000"> Enter</font> Minimum Length </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    	<td >
        <input type="text" name="tfMinLength" value="<%=sMinLen%>"
          onHelp = "showHelp('Help_CreateVD.html#createVDForm_tfMinLength'); return false" size="20" maxlength=8 >
      </td>
    </tr>
    <tr height="25" valign="bottom">
      <td align=right><%=item++%>) </td>
      <td><font color="#FF0000"> Enter</font> Maximum Length </td>
    </tr>
    <tr>
     <td>&nbsp;</td>
    	<td >
        <input type="text" name="tfMaxLength" value="<%=sMaxLen%>"
          onHelp = "showHelp('Help_CreateVD.html#createVDForm_tfMaxLength'); return false" size="20" maxlength=8>
      </td>
    </tr>
    <tr height="25" valign="bottom">
      <td align=right><%=item++%>) </td>
      <td><font color="#FF0000"> Enter</font> Low Value (for number data type) </td>
    </tr>
    <tr>
     <td>&nbsp;</td>
    	<td >
        <input type="text" name="tfLowValue" value="<%=sLowValue%>"
          <% if (!sDataType.equalsIgnoreCase("NUMBER")) { %> disabled <% } %>
          onHelp = "showHelp('Help_CreateVD.html#createVDForm_tfLowValue'); return false" size="20">
      </td>
    </tr>
    <tr height="25" valign="bottom">
      <td align=right><%=item++%>) </td>
      <td><font color="#FF0000"> Enter</font> High Value (for number data type)</td>
    </tr>
    <tr>
    <td>&nbsp;</td>
    	<td >
        <input type="text" name="tfHighValue" value="<%=sHighValue%>" 
          <% if (!sDataType.equalsIgnoreCase("NUMBER")) { %> disabled <% } %>
          onHelp = "showHelp('Help_CreateVD.html#createVDForm_tfHighValue'); return false" size="20">
      </td>
    </tr>
    <tr height="25" valign="bottom">
      <td align=right><%=item++%>) </td>
      <td><font color="#FF0000"> Enter</font> Decimal Place</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td >
        <input type="text" name="tfDecimal" value="<%=sDecimal%>"
          onHelp = "showHelp('Help_CreateVD.html#createVDForm_tfDecimal'); return false" size="20" maxlength=2>
      </td>
    </tr>
      <!-- Classification Scheme and items -->
     <tr height="25" valign="bottom">
        <td align=right><%=item++%>) </td>
        <td><font color="#FF0000">Select </font>Classification Scheme and Classification Scheme Items</td>
      </tr>
      
   <tr>
     <td>&nbsp;</td>
      <td>
        <table width=90% border=0>
          <col width="1%"><col width="38%"><col width="16%"> <col width="38%"><col width="16%">
          <tr>
            <td colspan=3 valign=top>
                <%if (sOriginAction.equals("BlockEditVD")){%>
              	 <select name="selCS" size="1" style="width:97%" onChange="ChangeCS();"
                  onHelp = "showHelp('Help_CreateVD.html#createVDForm_BlockselCS'); return false">
                <% } else { %>
									<select name="selCS" size="1" style="width:97%" onChange="ChangeCS();"
                  onHelp = "showHelp('Help_CreateVD.html#createVDForm_selCS'); return false">
                <% } %>
                    <option value="" selected></option>
                  <% for (int i = 0; vCS.size()>i; i++)
                      {
                         String sCSName = (String)vCS.elementAt(i);
                         String sCS_ID = (String)vCS_ID.elementAt(i);
                  %>
                        <option value="<%=sCS_ID%>"><%=sCSName%></option>
                  <%  }     %>
              </select>
            </td>
            <td colspan=2 valign=top>
              <%if (sOriginAction.equals("BlockEditVD")){%>
									<select name="selCSI" size="5" style="width:100%" onChange="selectCSI();" onClick="selectCSI();"
                  	 onHelp = "showHelp('Help_CreateVD.html#createVDForm_BlockselCS'); return false">
              <% } else { %>
             			<select name="selCSI" size="5" style="width:100%" onChange="selectCSI();"
                 		onHelp = "showHelp('Help_CreateVD.html#createVDForm_selCS'); return false">
              <% } %>
             			</select>
            </td>
          </tr>
          <tr><td height="10" valign="top"></tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;Selected Classification Schemes</td>
            <td><input type="button" name="btnRemoveCS" value="Remove Item" style="width: 85", "height: 9" onClick="removeCSList();"></td>
            <td>&nbsp;&nbsp;Associated Classification Scheme Items</td>
            <td><input type="button" name="btnRemoveCSI" value="Remove Item" style="width: 85", "height: 9" onClick="removeCSIList();"></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan=2 valign=top>
              <%if (sOriginAction.equals("BlockEditVD")){%>
                 <select name="selectedCS" size="5" style="width:97%" multiple onchange="addSelectCSI(false, true, '');"
                  onHelp = "showHelp('Help_CreateVD.html#createVDForm_BlockselCS'); return false">
              <% } else { %>
                 <select name="selectedCS" size="5" style="width:97%" multiple onchange="addSelectCSI(false, true, '');"
                  onHelp = "showHelp('Help_CreateVD.html#createVDForm_selCS'); return false">
              <% } %>
<%                  //store selected cs list on load 
                  if (vSelCSIDList != null) 
                  {
         //           System.out.println("cs size " + vSelCSIDList.size());
                    for (int i = 0; vSelCSIDList.size()>i; i++)
                    {
                      String sCS_ID = (String)vSelCSIDList.elementAt(i);
                      String sCSName = "";
                      if (vSelCSList != null && vSelCSList.size() > i)
                         sCSName = (String)vSelCSList.elementAt(i);
         //             System.out.println("selected " + sCSName);
%>
                      <option value="<%=sCS_ID%>"><%=sCSName%></option>
<%                  }
                  }   %>
              </select>
            </td>
            <td colspan=2 valign=top>
                <%if (sOriginAction.equals("BlockEditVD")){%>
              			 <select name="selectedCSI" size="5" style="width:100%" multiple onchange="addSelectedAC();"
                  onHelp = "showHelp('Help_CreateVD.html#createVDForm_BlockselCS'); return false">
                <% } else { %>
										 <select name="selectedCSI" size="5" style="width:100%" multiple onchange="addSelectedAC();"
                  	 onHelp = "showHelp('Help_CreateVD.html#createVDForm_selCS'); return false">
                <% } %>
              </select>
            </td>
          </tr>
          <%if (sOriginAction.equals("BlockEditVD")){%>
          <tr><td height="12" valign="top"></tr>    
          <tr>
            <td colspan=3>&nbsp;</td>
            <td colspan=2 valign=top>&nbsp;Value Domains containing selected Classification Scheme Items</td>
          </tr>
          <tr>
            <td colspan=3 valign=top>&nbsp;</td>
            <td colspan=2 valign=top>
              <select name="selCSIACList" size="3" style="width:100%"
                  onHelp = "showHelp('Help_CreateVD.html#createVDForm_BlockselCS'); return false">
              </select>
            </td>
          </tr>
          <%}%>
        </table>
      </td>
      <td>&nbsp;</td>
    </tr>
 <!-- source -->
     <tr height="25" valign="bottom">
     	<td align=right><%=item++%>) </td>
     	<td><font color="#FF0000">Select </font>Value Domain Origin</td></tr>
     <tr>
       <td>&nbsp;</td>
       <td>
        <select name="selSource" size="1"
          onHelp = "showHelp('Help_CreateVD.html#createVDForm_selSource'); return false">
          <option value=""></option>
<%         for (int i = 0; vSource.size()>i; i++)
           {
              String sSor = (String)vSource.elementAt(i);
%>
              <option value="<%=sSor%>" <%if(sSor.equals(sSource)){%>selected<%}%> ><%=sSor%></option>
<%
           }
%>
        </select>
      </td>
    </tr>
    <tr height="25" valign="bottom">
      <td align=right ><%=item++%>) </td>
      <td><font color="#FF0000"> Create</font> Comment/Change Note </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td >
        <textarea name="CreateChangeNote" cols="69"
          onHelp = "showHelp('Help_CreateVD.html#createVDForm_CreateComment'); return false" rows=2><%=sChangeNote%></textarea>
      </td>
    </tr>
    <tr height="25" valign="bottom">
      <td align=right><%=item++%>) </td>
      <td><font color="#FF0000"> <a href="javascript:SubmitValidate('validate')">Validate</a></font>
        the Value Domain(s)</td>
    </tr>
  </table>
  <table width="50">
<input type="hidden" name="vdIDSEQ" value="<%=sVDIDSEQ%>">
<input type="hidden" name="CDE_IDTxt" value="<%=sPublicVDID%>">
<input type="hidden" name="actSelect" value="">
<input type="hidden" name="newCDEPageAction" value="nothing">
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
<%if(sOriginAction.equals("BlockEditVD")){%>
<input type="hidden" name="selConceptualDomainText" value="">
<input type="hidden" name="VDAction" value="BlockEdit">
<input type="hidden" name="selContextText" value="<%=sContext%>">
<% } else {%>
<input type="hidden" name="selConceptualDomainText" value="<%=sConDom%>">
<input type="hidden" name="selContextText" value="<%=sContext%>">
<input type="hidden" name="VDAction" value="EditVD">
<% } %>
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
<input type="hidden" name="selectedParentConceptName" value="">
<input type="hidden" name="selectedParentConceptCode" value="">
<input type="hidden" name="selectedParentConceptDB" value="">
<input type="hidden" name="selectedParentConceptMetaSource" value="">
<input type="hidden" name="sCompBlocks" value="">

<input type="hidden" name="RepQualCCode" value="">
<input type="hidden" name="RepQualCCodeDB" value="">
<input type="hidden" name="RepCCode" value="<%=sRepCCode%>">
<input type="hidden" name="RepCCodeDB" value="<%=sRepCCodeDB%>">
<input type="hidden" name="nameTypeChange" value="<%=nameChanged%>">

<input type="hidden" name="pvSortColumn" value="">
<select size="1" name="hiddenPVID" style="visibility:hidden;width:160" multiple>
<%if (vPVIDList != null) 
  {
    for (int i = 0; vPVIDList.size()>i; i++)
    {
      String sPV_ID = (String)vPVIDList.elementAt(i);
  //System.out.println("pvid " + sPV_ID);
%>
      <option value="<%=sPV_ID%>" selected="selected"><%=sPV_ID%></option>
<%  }
  }   %>
</select>
<select name= "selCSCSIHidden" size ="1" style="visibility:hidden;"  multiple></select>
<select name= "selACCSIHidden" size ="1" style="visibility:hidden;"  multiple></select>
<select name= "selCSNAMEHidden" size="1" style="visibility:hidden;"  multiple></select>
<!-- store the selected ACs in the hidden field to use it for cscsi -->
<select name= "selACHidden" size="1" style="visibility:hidden;width:100;" multiple>
<%if (vACId != null) 
  {
    for (int i = 0; vACId.size()>i; i++)
    {
      String sAC_ID = (String)vACId.elementAt(i);
      String sACName = "";
      if (vACName != null && vACName.size() > i)
         sACName = (String)vACName.elementAt(i);
  //    System.out.println("selected " + sACName);
%>
      <option value="<%=sAC_ID%>"><%=sACName%></option>
<%  }
  }   %>
</select>

<!-- stores selected VMs from EVS before submitting -->
<select name= "selVMConCode" size ="1" style="visibility:hidden;width:160"  multiple></select>
<select name= "selVMConName" size ="1" style="visibility:hidden;width:160"  multiple></select>
<select name= "selVMConDef" size="1" style="visibility:hidden;width:160"  multiple></select>
<select name= "selVMConDefSource" size="1" style="visibility:hidden;width:160"  multiple></select>
<select name= "selVMConOrigin" size="1" style="visibility:hidden;width:160"  multiple></select>

<input type="hidden" name="hiddenParentName" value="">
<input type="hidden" name="hiddenParentCode" value="">
<input type="hidden" name="hiddenParentDB" value="">
<input type="hidden" name="hiddenParentListString" value="">
<select name= "ParentNames" size ="1" style="visibility:hidden;width:100;"  multiple>
<%if (vParentNames != null) 
  {
    for (int i = 0; vParentNames.size()>i; i++)
    {
      String sParentName = (String)vParentNames.elementAt(i);
%>
      <option value="<%=sParentName%>"><%=sParentName%></option>
<%  }
  }   
%>
</select>
<select name= "ParentCodes" size ="1" style="visibility:hidden;width:100;"  multiple>
<%if (vParentCodes != null) 
  {
    for (int i = 0; vParentCodes.size()>i; i++)
    {
      String sParentCode = (String)vParentCodes.elementAt(i);
%>
      <option value="<%=sParentCode%>"><%=sParentCode%></option>
<%  }
  }   
%>
</select>
<select name= "ParentMetaSource" size="1" style="visibility:hidden;width:100;"  multiple>
<%if (vParentDB != null) 
  {
    for (int i = 0; vParentMetaSource.size()>i; i++)
    {
      String sParentMetaSource = (String)vParentMetaSource.elementAt(i);
%>
      <option value="<%=sParentMetaSource%>"><%=sParentMetaSource%></option>
<%  }
  }   
%>
</select>
<select name= "ParentDB" size="1" style="visibility:hidden;width:100;"  multiple>
<%if (vParentDB != null) 
  {
    for (int i = 0; vParentDB.size()>i; i++)
    {
      String sParentDB = (String)vParentDB.elementAt(i);
%>
      <option value="<%=sParentDB%>"><%=sParentDB%></option>
<%  }
  }   
%>
</select>
<select name= "vRepQualifierCodes" size ="1" style="visibility:hidden;width:100;"  multiple>
<%if (vRepQualifierCodes != null) 
  {
    for (int i = 0; vRepQualifierCodes.size()>i; i++)
    {
      String sRepQualifierCode = (String)vRepQualifierCodes.elementAt(i);
%>
      <option value="<%=sRepQualifierCode%>"><%=sRepQualifierCode%></option>
<%  }
  }   
%>
</select>
<select name= "vRepQualifierDB" size="1" style="visibility:hidden;width:100;"  multiple>
<%if (vRepQualifierDB != null) 
  {
    for (int i = 0; vRepQualifierDB.size()>i; i++)
    {
      String sRepQualifierDB = (String)vRepQualifierDB.elementAt(i);
%>
      <option value="<%=sRepQualifierDB%>"><%=sRepQualifierDB%></option>
<%  }
  }   
%>
</select>
<!-- store datatype description to use later -->
<select name= "datatypeDesc" size ="1" style="visibility:hidden;width:100;"  multiple>
<%if (vDataTypes != null) 
  {
//System.out.println("datatypeDesc vDataTypes.size(): " + vDataTypes.size());
    for (int i = 0; vDataTypes.size()>i; i++)
    {
      String sDType = (String)vDataTypes.elementAt(i);
      String sDTDesc = "", sDTComm = "";
      if (i < vDataTypeDesc.size())
        sDTDesc = (String)vDataTypeDesc.elementAt(i);
      if (sDTDesc == null || sDTDesc.equals("")) sDTDesc = sDType;
      if (i < vDataTypeCom.size())
        sDTComm = (String)vDataTypeCom.elementAt(i);
      if (sDTComm == null) sDTComm = "";
%>
      <option value="<%=sDTDesc%>"><%=sDTComm%></option>
<%  }
  }   
%>
</select>

<!-- stores the selected rows to get the bean from the search results -->
<select name= "hiddenSelRow" size="1" style="visibility:hidden;width:100"  multiple></select>
</table>
<script language = "javascript">
//call function to initiate form objects
createObject("document.createVDForm");
displayStatusMessage();
loadCSCSI();
selectParent();   //do the parent select action if the parent was selected.
ShowEVSInfo('RepQualifier');
changeDataType();
</script>
</form>
<form name="SearchActionForm" method="post" action="">
<input type="hidden" name="searchComp" value="<%=sSearchAC%>">
<input type="hidden" name="searchEVS" value="ValueDomain">
<input type="hidden" name="isValidSearch" value="true">
<input type="hidden" name="CDVDcontext" value="">
<input type="hidden" name="SelContext" value="">
<input type="hidden" name="acID" value="<%=sVDIDSEQ%>">
<input type="hidden" name="itemType" value="">
</form>
</body>
</html>