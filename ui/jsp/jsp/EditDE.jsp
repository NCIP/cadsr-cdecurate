<html>
<head>
<title>EditDataElement</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<%@ page import="java.util.*" %>
<%@ page import="com.scenpro.NCICuration.*" %>
<%@ page session="true" %>
<link href="FullDesignArial.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="Assets/date-picker.js"></script>
<SCRIPT LANGUAGE="JavaScript" SRC="Assets/AddNewListOption.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="Assets/CreateDE.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="Assets/SelectCS_CSI.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../../cdecurate/Assets/HelpFunctions.js"></SCRIPT>
<%
    UtilService serUtil = new UtilService();
    //load the lists
    Vector vContext = (Vector)session.getAttribute("vWriteContextDE");
    Vector vContextID = (Vector)session.getAttribute("vWriteContextDE_ID");
    Vector vStatus = (Vector)session.getAttribute("vStatusDE");
    Vector vRegStatus = (Vector)session.getAttribute("vRegStatus");
    Vector vCS = (Vector)session.getAttribute("vCS");
    Vector vCS_ID = (Vector)session.getAttribute("vCS_ID");
    Vector vLanguage = (Vector)session.getAttribute("vLanguage");
    Vector vSource = (Vector)session.getAttribute("vSource");

    Vector results = (Vector)session.getAttribute("results");
    String sMenuAction = (String)session.getAttribute("MenuAction");
    if(sMenuAction.equals("nothing"))
    {
      sMenuAction = "editDE";
      session.setAttribute("MenuAction", "editDE");
    }
      
    String sOriginAction = (String)session.getAttribute("originAction");
    if (sOriginAction == null) sOriginAction = "";
    String sDDEAction = (String)session.getAttribute("DDEAction");

    DE_Bean m_DE = (DE_Bean)session.getAttribute("m_DE");
    if (m_DE == null) m_DE = new DE_Bean();
   // session.setAttribute("DEEditAction", "");
    String sDEIDSEQ = m_DE.getDE_DE_IDSEQ();
    if (sDEIDSEQ == null) sDEIDSEQ = "";

    String sContext = m_DE.getDE_CONTEXT_NAME();
    if (sOriginAction.equals("BlockEditDE")) sContext = "";
    if (sContext == null) sContext = "";
    String sContID = m_DE.getDE_CONTE_IDSEQ();
    if (sContID == null) sContID = "";

    //get the used by contexts
    Vector vSelectedContext = m_DE.getDE_SELECTED_CONTEXT_ID();
    
    String sLongName = m_DE.getDE_LONG_NAME();
    sLongName = serUtil.parsedString(sLongName);    //call the function to handle doubleQuote
    if (sLongName == null || sOriginAction.equals("BlockEditDE")) sLongName = "";
    int sLongNameCount = sLongName.length();
    String sName = m_DE.getDE_PREFERRED_NAME();
    if (sName != null) sName = serUtil.parsedString(sName);    //call the function to handle doubleQuote
    if (sName == null || sOriginAction.equals("BlockEditDE")) sName = "";
    int sNameCount = sName.length();
    String sPrefType = m_DE.getAC_PREF_NAME_TYPE();
    if (sPrefType == null) sPrefType = ""; 
    String lblUserType = "Existing Name (Editable)";  //make string for user defined label
    String sUserEnt = m_DE.getAC_USER_PREF_NAME();
    if(sOriginAction.equals("BlockEditDE")) lblUserType = "Existing Name (Not Editable)";
    else if (sUserEnt == null || sUserEnt.equals("")) lblUserType = "User Entered";

    String sDefinition = m_DE.getDE_PREFERRED_DEFINITION();
    if (sDefinition == null) sDefinition = "";
    if(sOriginAction.equals("BlockEditDE")) sDefinition = "";
    
    //get dec attributes
    DEC_Bean dec = m_DE.getDE_DEC_Bean();
    if (dec == null) dec = new DEC_Bean();    
    String sDECID = dec.getDEC_DEC_IDSEQ();    //m_DE.getDE_DEC_IDSEQ();
    if ((sDECID == null) || (sDECID.equals("nothing"))) sDECID = "";
    String sDEC = dec.getDEC_LONG_NAME();   //m_DE.getDE_DEC_NAME();
    if (sDEC == null) sDEC = "";
    sDEC = serUtil.parsedString(sDEC);     //call the function to handle doubleQuote
    VD_Bean vd = m_DE.getDE_VD_Bean();
    if (vd == null) vd = new VD_Bean();
    String sVDID = vd.getVD_VD_IDSEQ();  // m_DE.getDE_VD_IDSEQ();
    if ((sVDID == null) || (sVDID.equals("nothing"))) sVDID = "";
    String sVD = vd.getVD_LONG_NAME();  // m_DE.getDE_VD_NAME();
    sVD = serUtil.parsedString(sVD);    //call the function to handle doubleQuote
    if (sVD == null) sVD = "";

    boolean decvdChanged = m_DE.getDEC_VD_CHANGED();
//System.out.println("jsap " + decvdChanged);
    String sVersion = m_DE.getDE_VERSION();
    if (sVersion == null) 
      sVersion = "1.0";
      
    String sStatus = m_DE.getDE_ASL_NAME();
    if (sStatus == null && sOriginAction.equals("BlockEditDE")) sStatus = "";
    else if (sStatus == null) sStatus = "DRAFT NEW";
    String sRegStatus = m_DE.getDE_REG_STATUS();
    if (sRegStatus == null) sRegStatus = "";
    String sRegStatusIDSEQ = m_DE.getDE_REG_STATUS_IDSEQ();
    if (sRegStatusIDSEQ == null) sRegStatusIDSEQ = "";
    
    String sCDEID = m_DE.getDE_MIN_CDE_ID();
    if (sCDEID == null) sCDEID = "";
    if(sOriginAction.equals("BlockEditDE")) sCDEID = "";
    String sBeginDate = m_DE.getDE_BEGIN_DATE();
    if (sBeginDate == null) sBeginDate = "";
    String sDocText = m_DE.getDOC_TEXT_LONG_NAME();
    if (sDocText == null) sDocText = "";
    String sDocTextIDSEQ = m_DE.getDOC_TEXT_LONG_NAME_IDSEQ();
    if (sDocTextIDSEQ == null) sDocTextIDSEQ = "";
    String sSourceIDSEQ = m_DE.getDE_SOURCE_IDSEQ();
    if (sSourceIDSEQ == null) sSourceIDSEQ = "";
    String sSource = m_DE.getDE_SOURCE();
    if (sSource == null) sSource = "";
    String sChangeNote = m_DE.getDE_CHANGE_NOTE();
    if (sChangeNote == null) sChangeNote = "";

    //get cs-csi attributes
    Vector vSelCSList = m_DE.getDE_CS_NAME();
    if (vSelCSList == null) vSelCSList = new Vector();
    Vector vSelCSIDList = m_DE.getDE_CS_ID();
    Vector vACCSIList = m_DE.getDE_AC_CSI_VECTOR();
    Vector vACId = (Vector)session.getAttribute("vACId");
    Vector vACName = (Vector)session.getAttribute("vACName");
    //initialize the beans
    CSI_Bean thisCSI = new CSI_Bean();
    AC_CSI_Bean thisACCSI = new AC_CSI_Bean();

    String sEndDate = m_DE.getDE_END_DATE();
    if (sEndDate == null) sEndDate = "";

    //these are for DEC and VD searches.
    session.setAttribute("MenuAction", "searchForCreate");
    Vector vResult = new Vector();
    session.setAttribute("results", vResult);
    session.setAttribute("creRecsFound", "No ");
    session.setAttribute("creKeyword", "");

    // for DDE
    String sSelRepType = (String)session.getAttribute("sRepType");
    String sSelConcatChar = (String)session.getAttribute("sConcatChar");
    String sSelRule = (String)session.getAttribute("sRule");
    String sSelMethod = (String)session.getAttribute("sMethod");
    Vector vRepType = new Vector();
    Vector vDEComp = new Vector();
    Vector vDECompID = new Vector();
    Vector vDECompOrder = new Vector();
    Vector vDECompRelID = new Vector();
    if(sDDEAction != "CreateNewDEFComp")
    {
        vRepType = (Vector)session.getAttribute("vRepType");
        vDEComp = (Vector)session.getAttribute("vDEComp");
        vDECompID = (Vector)session.getAttribute("vDECompID");
        vDECompOrder = (Vector)session.getAttribute("vDECompOrder");
        vDECompRelID = (Vector)session.getAttribute("vDECompRelID");
    }

    String sDEID = "";
    String sDECompOrder = "";
    if(vDECompOrder.size() > 0)
        sDECompOrder = (String)vDECompOrder.elementAt(0);

    int item = 1;
        
%>

<Script Language="JavaScript">
 var evsWindow2 = null;
  //get all the cs_csi from the bean to array.
  var csiArray = new Array();  
  var selCSIArray = new Array();  //for selected csi list
  var selACCSIArray = new Array();  //for selected AC-csi list
  var writeContArray = new Array();
  
  function loadCSCSI()
  {
    //call function to initiate form objects
    createObject("document.newCDEForm");
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
    window.status = "Edit the Existing Data Element, choose context first"
  }

</Script>
</head>

<body onUnload="closeDep();">
<form name="FormNewDEC" method="post" action="/cdecurate/NCICurationServlet?reqType=createNewDEC"></form>
<form name="FormNewVD" method="post" action="/cdecurate/NCICurationServlet?reqType=createNewVD"></form>
<form name="SearchActionForm" method="post" action="">
<input type="hidden" name="searchComp" value="">
<input type="hidden" name="searchEVS" value="DataElement">
<input type="hidden" name="isValidSearch" value="true">
<input type="hidden" name="acID" value="<%=sDEIDSEQ%>">
<input type="hidden" name="itemType" value="">
</form>
<form name="newCDEForm" method="POST" action="/cdecurate/NCICurationServlet?reqType=editDE">
  <table width="100%" border=0>
    <!--DWLayoutTable-->
    <tr>
      <td align="left" valign="top" colspan=2>
        <input type="button" name="btnValidate" value="Validate" style="width: 125" onClick="SubmitValidate('validate')"
				onHelp = "showHelp('Help_CreateDE.html#newCDEForm_Validation'); return false">
          &nbsp;&nbsp;
    <!--no need for clear button in the block edit-->
<%//if(!sOriginAction.equals("BlockEditDE")){%>
        <input type="button" name="btnClear" value="Clear" style="width: 125" onClick="ClearBoxes();">
          &nbsp;&nbsp;
<%//}%>
        <input type="button" name="btnBack" value="Back" style="width: 125" onClick="Back();">
          &nbsp;&nbsp;
<%if(sOriginAction.equals("BlockEditDE")){%>
        <input type="button" name="btnDetails" value="Details" style="width: 125" onClick="openBEDisplayWindow();"
				onHelp = "showHelp('Help_Updates.html#newCDEForm_details'); return false">
          &nbsp;&nbsp;
<%} else {%>
        <input type="button" name="btnAltName" value="Alternate Names" style="width: 125" onClick="openAltNameWindow();"
				onHelp = "showHelp('Help_Updates.html#newCDEForm_altNames'); return false">
          &nbsp;&nbsp;
<%}%>
		  <img name="Message" src="Assets/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" style="visibility:hidden;">
      </td>
    </tr>
  </table>
  <table width="900" border=0>
    <col width="4%"><col width="95%">
  	<tr valign="middle"> 
      <th colspan=2 height="40"> <div align="left"> 
        <% if (sOriginAction.equals("BlockEditDE")){%>
          <label><font size=4>Block Edit Existing <font color="#FF0000">Data Elements</font>
          </font></label>
       <% } else {%>
          <label><font size=4>Edit Existing <font color="#FF0000">Data Element</font>
          </font></label>
        <% } %>
        </div></th>
    </tr>
    
  <% if (!sOriginAction.equals("BlockEditDE")){%>
    <tr valign="bottom" height="25">
      <td align="left" colspan=2 height="11"><font color="#FF0000">&nbsp;&nbsp;&nbsp;*&nbsp;&nbsp;&nbsp;</font>Indicates Required Field</td>
    </tr>
  <%}%>
    
    <tr height="25" valign="bottom">
        <td align=right><font color="#C0C0C0"><%=item++%>)</font></td>
        <td colspan=4><font color="#C0C0C0">Context</font></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td height="26">
        <select name="selContext" size="1"  readonly
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false">
          <option value="<%=sContID%>"><font color="#C0C0C0"><%=sContext%></font></option>
        </select>
      </td>
    </tr>
    <tr valign="bottom" height="25">
      <!-- add the hyperlink do not allow update if alredy vd selected in the block edit-->
      <% if (sOriginAction.equals("BlockEditDE") && sVDID != null && !sVDID.equals("")){%>
        <td align=right><font color="#C0C0C0"><%=item++%>)</font></td>
        <td><font color="#C0C0C0">Select Data Element Concept Long Name</font></td>
      <%} else {%>
        <td align=right><font color="#FF0000"><% if(!sOriginAction.equals("BlockEditDE")){%>*<%}%>&nbsp;&nbsp;</font><%=item++%>)</td>
        <td><font color="#FF0000">Select </font>Data Element Concept Long Name</td>
      <%}%>
    </tr>  
    
    <tr>
      <td>&nbsp;</td>
      <td>   	      
        <select name="selDEC" size="1" multiple style="width:430"
            onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selDEC'); return false">
           <option value="<%=sDECID%>"><%=sDEC%></option>
        </select>
        <!-- add the hyperlink do not allow search if alredy vd selected in the block edit-->
        <% if(!(sOriginAction.equals("BlockEditDE") && sVDID != null && !sVDID.equals(""))){%>
          &nbsp;&nbsp;<a href="javascript:SearchDECValue();">Search</a>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <%}%>
        <%if(!sOriginAction.equals("BlockEditDE")){%>
          <a href="javascript:EditDECValue();">Edit DEC</a>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <a href="javascript:CreateNewDECValue();">Create New DEC</a>
        <% }%>
      </td>
    </tr>
    <tr valign="bottom" height="25">
      <!-- add the hyperlink do not allow update if alredy dec selected in the block edit-->
      <% if(sOriginAction.equals("BlockEditDE") && sDECID != null && !sDECID.equals("")){%>
        <td align=right><font color="#C0C0C0"><%=item++%>)</font></td>
        <td><font color="#C0C0C0">Select Value Domain Long Name</font></td>
      <%} else {%>
        <td align=right><font color="#FF0000"><% if(!sOriginAction.equals("BlockEditDE")){%>*<%}%>&nbsp;&nbsp;</font><%=item++%>)</td>
        <td><font color="#FF0000">Select </font>Value Domain Long Name</td>
      <%}%>
    </tr>  
    <tr>
      <td>&nbsp;</td>
      <td>   	
      	<select name= "selVD" size ="1" multiple style="width:430"
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selVD'); return false">
          <option value="<%=sVDID%>"><%=sVD%></option>
        </select>
        <!-- add the hyperlink do not allow search if alredy dec selected in the block edit-->
        <% if(!(sOriginAction.equals("BlockEditDE") && sDECID != null && !sDECID.equals(""))){%>
            &nbsp;&nbsp;<a href="javascript:SearchVDValue()">Search</a>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <%}%>
        <%if(!sOriginAction.equals("BlockEditDE")){%>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <a href="javascript:EditVDValue()">Edit VD</a>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <a href="javascript:CreateNewVDValue()">Create New VD</a> 
        <%}%>
      </td>
    </tr>
  	<tr valign="bottom" height="25">
      <%if(sOriginAction.equals("BlockEditDE")){%>
        <td align=right><font color="#C0C0C0"><%=item++%>)</font></td>
        <td><font color="#C0C0C0">Verify Data Element Long Name</font></td>
      <% } else {%>
        <td align=right><font color="#FF0000">*&nbsp;&nbsp;</font><%=item++%>)</td>
        <td><font color="#FF0000">Verify</font> Data Element Long Name</td>
      <% } %>
    </tr>
    <tr> 
      <td><font color="#FF0000"> </font></td>
      <td height="24" valign="top" >
   	   <input name="txtLongName" type="text" size="80" value="<%=sLongName%>" onKeyUp="changeCountLN();"
        <%if(sOriginAction.equals("BlockEditDE")){%>readonly<%}%>
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_txtLongName'); return false">
          &nbsp;&nbsp;&nbsp; 
       <input name="txtLongNameCount" type="text" size="1" value="<%=sLongNameCount%>" readonly
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_txtLongName'); return false">
          <%if(sOriginAction.equals("BlockEditDE")){%>
            <font color="#C0C0C0"> Character Count &nbsp;&nbsp;(Database Max = 255)</font>
          <% } else {%>
            <font color="#000000"> Character Count &nbsp;&nbsp;(Database Max = 255)</font>
          <% } %>
      </td>
    </tr>
    <tr valign="bottom" height="25">
      <%if(sOriginAction.equals("BlockEditDE")){%>
        <td align=right><font color="#C0C0C0"><%=item++%>)</font></td>
        <td><font color="#C0C0C0">Update Data Element Preferred Name</font></td>
      <% } else {%>
        <td align=right><font color="#FF0000">*&nbsp;&nbsp;</font><%=item++%>)</td>
        <td><font color="#FF0000">Update</font><font color="#000000"> Data Element Preferred Name</font></td>
      <% } %>
    </tr>
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
    <tr>
    	<td>&nbsp;</td>
     	<td height="24" valign="top" >
	      <input name="txtPreferredName" type="text" size="80" value="<%=sName%>" onKeyUp="changeCountPN();"
          <% if (sOriginAction.equals("BlockEditDE") || sPrefType.equals("") || sPrefType.equals("SYS") || sPrefType.equals("ABBR")){ %>readonly<%}%>
	        onHelp = "showHelp('Help_CreateDE.html#newCDEForm_txtPreferredName'); return false">
          &nbsp;&nbsp;&nbsp; 
        <input name="txtPrefNameCount" type="text" size="1" value="<%=sNameCount%>" readonly
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_txtPreferredName'); return false">
          <%if(sOriginAction.equals("BlockEditDE")){%>
                <font color="#C0C0C0"> Character Count &nbsp;&nbsp;(Database Max = 30)</font>
          <% } else {%>
                <font color="#000000"> Character Count &nbsp;&nbsp;(Database Max = 30)</font>
          <% } %>
      </td>
    </tr>

    <tr height="25" valign="bottom">
      <td align=right><font color="#C0C0C0"><%=item++%>)</font></td>
      <td colspan=4><font color="#C0C0C0">Public ID </font></td>
    </tr>
    <tr>
      <td align=right>&nbsp;</td>
      <td colspan=4><font color="#C0C0C0"><input type="text" name="CDE_IDTxt" 
          value="<%=sCDEID%>" size="20" readonly 
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_CDE_IDTxt'); return false"></font></td>
    </tr>

    <tr><td height="8" valign="top"></tr>
    <tr height="25" valign="top">
      <%if(sOriginAction.equals("BlockEditDE")){%>
        <td align=right><font color="#C0C0C0"><%=item++%>)</font></td>
        <td><font color="#C0C0C0">Create/Edit Definition</font></td>
      <% } else {%>
        <td align=right><font color="#FF0000">*&nbsp;&nbsp;</font><%=item++%>)</td>
        <td><font color="#FF0000">Create/Edit</font> Definition<br>
          (Changes to naming components will replace existing definition text.)
        </td>
      <% } %>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td valign="top" align="left">
        <%if(sOriginAction.equals("BlockEditDE")){%>
          <textarea name="CreateDefinition" style="width:80%" rows=6 readonly
            onHelp = "showHelp('Help_CreateDE.html#newCDEForm_CreateDefinition'); return false"><%=sDefinition%></textarea>
        <!--  &nbsp;&nbsp;<font color="#C0C0C0">Search</a></font>  -->
        <% } else {%>
          <textarea name="CreateDefinition" style="width:80%" rows=6
            onHelp = "showHelp('Help_CreateDE.html#newCDEForm_CreateDefinition'); return false"><%=sDefinition%></textarea>
           <!--   &nbsp;&nbsp;<a href="javascript:AccessEVS()">Search</a></font> -->
        <% } %>
      </td>
    </tr>

    <tr valign="bottom" height="25">
      <td align=right><%if(!sOriginAction.equals("BlockEditDE")){%><font color="#FF0000">*&nbsp;&nbsp;</font><%}%><%=item++%>)</td>
      <td><font color="#FF0000">Select</font> Workflow Status</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td height="26" valign="top">
        <select name="selStatus" size="1"
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selStatus'); return false">
          <option value="" selected="selected"></option>
<%          for (int i = 0; vStatus.size()>i; i++)
          {
             String sStatusName = (String)vStatus.elementAt(i);
             //add only draft new and retired phased out if creating new
             if (sMenuAction.equals("Questions"))
             {
                if (sStatusName.equals("DRAFT NEW") || sStatusName.equals("RETIRED PHASED OUT") && !sOriginAction.equals("BlockEditDEC"))
                {
%>
                   <option value="<%=sStatusName%>" <%if(sStatusName.equals(sStatus)){%>selected<%}%> ><%=sStatusName%></option>
<%              }
             }
             else
             {
%>
                  <option value="<%=sStatusName%>" <%if(sStatusName.equals(sStatus)){%>selected<%}%> ><%=sStatusName%></option>
<%
             }
          }
%>
        </select>
      </td>
    </tr>

    <tr height="25" valign="bottom">
      <% if (sOriginAction.equals("BlockEditDE")){%>
        <td align=right><%=item++%>)</td>
        <td height="25" valign="bottom">Check Box to Create New Version
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://ncicb.nci.nih.gov/NCICB/core/caDSR/BusinessRules" target="_blank">Business Rules</a>
        </td>
      <% } else {%>
        <td align=right><font color="#C0C0C0"><%=item++%>)</font></td>
        <td colspan=4><font color="#C0C0C0">Version</font></td>
      <% } %>
    </tr>
    <tr>
      <td>&nbsp;</td>
        <%if(sOriginAction.equals("BlockEditDE")){ %>
          <td>
            <table width="60%">
              <col width="20%"><col width="13%"><col width="13%">
              <tr height="25"> 
                <!--Version check is checked only if the sVersion is either Whole or Point   -->
                <td valign="top">&nbsp;&nbsp;
                  <input type="checkbox" name="VersionCheck" onClick="javascript:EnableChecks(checked,this);" value="ON"
                      <%if(sVersion.equals("Whole") || sVersion.equals("Point")) {%>checked<%}%>
											onHelp = "showHelp('Help_CreateDE.html#createCDEForm_BlockVersion'); return false"></td>
                <!--Point check is checked only if the sVersion is Point and disabled otherwise  -->
                <td>
                  <input type="checkbox" name="PointCheck" onClick="javascript:EnableChecks(checked,this);" value="ON"
                      <%if(sVersion.equals("Point")){%> checked <%} else {%> disabled <%}%>
											onHelp = "showHelp('Help_CreateDE.html#createCDEForm_BlockVersion'); return false">
                      &nbsp;Point Increase</td>
                <!--Whole check is checked only if the sVersion is Whole and disabled otherwise  -->
                <td colspan=2>
                  <input type="checkbox" name="WholeCheck" onClick="javascript:EnableChecks(checked,this)" value="ON"
                      <%if(sVersion.equals("Whole")){%> checked <%} else {%> disabled <%}%>
											onHelp = "showHelp('Help_CreateDE.html#createCDEForm_BlockVersion'); return false">
                      &nbsp;Whole Increase
                </td>
              </tr>
            </table> 
          </td>
        <% } else { %>
          <td valign="top" colspan=4><font color="#C0C0C0">
            <input type="text" name="Version" value="<%=sVersion%>" size=5 readonly 
              onHelp = "showHelp('Help_CreateDE.html#newCDEForm_Version'); return false"></font>
              &nbsp;&nbsp;&nbsp;<a href="http://ncicb.nci.nih.gov/NCICB/core/caDSR/BusinessRules" target="_blank">Business Rules</a>
          </td>
        <% } %>       
    </tr>
    <tr height="25" valign="bottom"> 
      <td align=right><%=item++%>)</td>
      <td> <font color="#FF0000"> Select</font> Registration Status</td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td height="25" valign="top"> 
        <select name="selRegStatus" size="1" style="Width:50%"
            onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selRegStatus'); return false">
            <option value="" selected></option>
<%          if (vRegStatus != null) 
            {            
              for (int i = 0; vRegStatus.size()>i; i++)
              {
                String sReg = (String)vRegStatus.elementAt(i);
                boolean isOK = true;
             //   if(sOriginAction.equals("BlockEditDE") && (sReg.equalsIgnoreCase("Candidate") || sReg.equalsIgnoreCase("Standard")))
             //     isOK = false;
                if (isOK) {
%>
              <option value="<%=sReg%>" <%if(sReg.equals(sRegStatus)){%>selected<%}%>><%=sReg%></option>
<%
            } } }
%>
        </select>
      </td>
    </tr>
    <tr valign="bottom" height="25">
      <td align=right><%if(!sOriginAction.equals("BlockEditDE")){%><font color="#FF0000">*</font><%}%><%=item++%>)</td>
      <td><font color="#FF0000">Enter/Select</font> Effective Begin Date</td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td height="25" valign="top"><input type="text" name="BeginDate" value="<%=sBeginDate%>" size="12" maxlength=10
        onHelp = "showHelp('Help_CreateDE.html#newCDEForm_BeginDate'); return false"> 
        <a href="javascript:show_calendar('newCDEForm.BeginDate', null, null, 'MM/DD/YYYY');">
        <img name="Calendar" src="Assets/calendarbutton.gif" width="20" height="20" alt="Calendar" style="vertical-align: top; background-color: #FF0000"> 
        </a>&nbsp;&nbsp;MM/DD/YYYY </td>
    </tr>

    <tr valign="bottom" height="25">
      <td align=right><%=item++%>)</td>
      <td><font color="#FF0000">Enter/Select</font> Effective End Date</td>    
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td height="25" valign="top" > 
        <input type="text" name="EndDate" value="<%=sEndDate%>" size="12" maxlength=10
        onHelp = "showHelp('Help_CreateDE.html#newCDEForm_EndDate'); return false" size="20"> 
          <a href="javascript:show_calendar('newCDEForm.EndDate', null, null, 'MM/DD/YYYY');" > 
          <img name="Calendar" src="Assets/calendarbutton.gif" width="22" height="22" alt="Calendar" style="vertical-align: top", "background-color: #FF0000"> 
          </a>&nbsp;&nbsp;MM/DD/YYYY </td>
    </tr>
    <tr valign="bottom" height="25">
        <td align=right><%=item++%>)</td>
        <td><font color="#FF0000">Create</font> Document Text</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td valign="top"> 
        <textarea name="CreateDocumentText" cols="89"
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_CreateDocumentText'); return false" rows=2><%=sDocText%></textarea>
      </td>
    </tr> 
        <!-- Classification Scheme and items -->          
    <tr valign="bottom" height="25">
      <td align=right><%=item++%>)</td>
      <td><font color="#FF0000">Select </font>Classification Scheme and Classification Scheme Items</td>
    </tr>        
    <tr>
      <td>&nbsp;</td>
      <td>
        <table width=100% border="0">
          <col width="1%"><col width="30%"><col width="15%"> <col width="30%"><col width="15%">    
          <tr>
             <td height="30" valign="top" colspan=3>
              <%if (sOriginAction.equals("BlockEditDE")){%>
							<select name="selCS" size="1" style="width:95%" onChange="ChangeCS();"
                  onHelp = "showHelp('Help_CreateDE.html#newCDEForm_BlockselCS'); return false">
								<% } else { %>
							<select name="selCS" size="1" style="width:95%" onChange="ChangeCS();"
                  onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selCS'); return false">
							<% } %>
                  <option value="" selected></option>
<%                  for (int i = 0; vCS.size()>i; i++)
                  {
                    String sCSName = (String)vCS.elementAt(i);
                    String sCS_ID = (String)vCS_ID.elementAt(i);
%>
                    <option value="<%=sCS_ID%>"><%=sCSName%></option>
<%                  }     %>
              </select> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            </td>
            <td height="30" valign="top" colspan=2>
						<%if (sOriginAction.equals("BlockEditDE")){%>
              <select name="selCSI" size="5" style="width:100%" onChange="selectCSI();" onClick="selectCSI();"
                  onHelp = "showHelp('Help_CreateDE.html#newCDEForm_BlockselCS'); return false">
						<% } else { %>
						   <select name="selCSI" size="5" style="width:100%" onChange="selectCSI();"
                  onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selCS'); return false">
						<% } %>
              </select>
            </td>
          </tr>
          <tr><td height="12" valign="top"></tr>
          <tr>
            <td>&nbsp;</td>
            <td align="left">Selected Classification Schemes</td>
            <td align="left"><input type="button" name="btnRemoveCS" value="Remove Item" style="width: 85" onClick="removeCSList();"></td>
            <td align="left">Associated Classification Scheme Items</td>
            <td align="left"><input type="button" name="btnRemoveCSI" value="Remove Item" style="width: 85" onClick="removeCSIList();"></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan=2>
						<%if (sOriginAction.equals("BlockEditDE")){%>
              <select name="selectedCS" size="5" style="width:98%" multiple onchange="addSelectCSI(false, true, '');"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_BlockselCS'); return false">
						<% } else { %>
							 <select name="selectedCS" size="5" style="width:98%" multiple onchange="addSelectCSI(false, true, '');"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selCS'); return false">
						<% } %>
<%                  //store selected cs list on load 
                if (vSelCSIDList != null) 
                {
            //      System.out.println("cs size " + vSelCSIDList.size());
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
            <td colspan=2>
						<%if (sOriginAction.equals("BlockEditDE")){%>
              <select name="selectedCSI" size="5" style="width:100%" multiple onchange="addSelectedAC();"
                   onHelp = "showHelp('Help_CreateDE.html#newCDEForm_BlockselCS'); return false">
									<% } else { %>
									<select name="selectedCSI" size="5" style="width:100%" multiple onchange="addSelectedAC();"
											 onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selCS'); return false">
									<% } %>
	              </select>
            </td>
          </tr>
<%if (sOriginAction.equals("BlockEditDE")){%>
          <tr><td height="12" valign="top"></tr>    
          <tr>
            <td colspan=3>&nbsp;</td>
            <td colspan=2 valign=top>&nbsp;Data Elements containing selected Classification Scheme Items</td>
          </tr>
          <tr>
            <td colspan=3 valign=top>&nbsp;</td>
            <td colspan=2 valign=top>
              <select name="selCSIACList" size="3" style="width:100%"
                  onHelp = "showHelp('Help_CreateDE.html#newCDEForm_BlockselCS'); return false">
              </select>
            </td>
          </tr>
<%}%>
        </table>
      </td>
    </tr>
<!-- origin -->
   	<tr valign="bottom" height="25">
          <td align=right><%=item++%>)</td>
          <td><font color="#FF0000">Select </font>Data Element Origin</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>
        <select name="selSource" size="1"
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selSource'); return false">
          <option value=""></option>
<%           for (int i = 0; vSource.size()>i; i++)
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
    <tr valign="bottom" height="25">
        <td align=right><%=item++%>)</td>
        <td><font color="#FF0000">Create</font> Comment/Change Note</td>
    </tr>
    
    <tr>
      <td>&nbsp;</td>
      <td valign="top">
        <textarea name="CreateChangeNote" cols="69" rows=2
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_CreateComment'); return false"><%=sChangeNote%></textarea>
      </td>
    </tr>
    
    <tr valign="bottom" height="25">
      <td align=right><%=item++%>)</td>
      <td><font color="#FF0000"> <a href="javascript:SubmitValidate('validate')">Validate</a></font>
        the Data Element(s) </td>
    </tr>
  </table> 
<%if(!sOriginAction.equalsIgnoreCase("BlockEditDE")) {%>
  <hr>
  <!-- if not for create new from DDE or not for Block edit -->
  <table width="800" border=0 name="DDETable">
  	<col width=4%><col width=45%><col width=18%><col width=30%>
   <!--<col width="4%"> <col width="95%">-->
    <tr>
      <th height="40" colspan=4> 
       <legend align=top><div align="left"> 
          <label><font size=4>Derived Data Element Derivation Rules and Components</font></label>
        </div> </legend></th>
    </tr>
    <tr height="25" valign="bottom">
    	<td align=left colspan=4><font color="#FF0000">&nbsp;*&nbsp;</font>Indicates Required Fields for Derived Data Elements</td>
    </tr>
    <tr height="25" valign="bottom"> 
      <td align=right><font color="#FF0000">* </font><%=item++%>)</td>
      <td colspan=3><font color="#FF0000">Select</font> Representation Type</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td height="26" valign="top" colspan=3> 
        <select name="selRepType" size="1" onChange="javascript:changeRepType('change')"
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selRepType'); return false">
<%        for (int i = 0; vRepType.size()>i; i++)
          {
            String sRepType = (String)vRepType.elementAt(i);
%>
            <option value="<%=sRepType%>" <%if(sRepType.equals(sSelRepType)){%>selected<%}%> ><%=sRepType%></option>
<%        } %>
        </select> 
      </td>
    </tr>
    <tr height="25" valign="bottom">
      <td align=right><font color="#FF0000">* </font><%=item++%>)</td>
      <td colspan=3><font color="#FF0000">Create</font> Rule</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td height="35" valign="top" colspan=3>
        <textarea name="DDERule" cols="69"
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_DDERule'); return false" rows=2><%=sSelRule%></textarea>
      </td>
    </tr>
    <tr height="25" valign="bottom">
      <td align=right><%=item++%>)</td>
      <td colspan=3><font color="#FF0000">Create </font> Methods</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td height="35" valign="top" colspan=3>
        <textarea name="DDEMethod" cols="69" disabled
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_DDEMethod'); return false" rows=2><%=sSelMethod%></textarea>
      </td>
    </tr>
    <tr height="25" valign="bottom">
      <td align=right><%=item++%>)</td>
      <td colspan=3><font color="#FF0000">Enter</font> Concatenation Character</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td valign="top" colspan=3> <input name="DDEConcatChar" type="text" value="<%=sSelConcatChar%>" size="5" maxlength=1
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_DDEConcatChar'); return false" disabled></td>
    </tr>
    <tr height="25" valign="bottom">
      <td align=right><%=item++%>)</td>
      <td align=left><font color="#FF0000">Search/Create </font>Data Element Components</td>
      <td align=left><a href="javascript:SearchDEValue()">Search</a> For</td> 
      <td align=left><a href="javascript:CreateNewDEValue()">Create</a> New</td> 
    </tr>
    <tr height="25" valign="top">
	  <td colspan=2></td>
	  <td align=left> Data Element</td>
	  <td align=left> Data Element</td>
	</tr>
    <tr><td height="14" valign="top"></tr>
    <!--<tr>
      <td colspan=2 align=left>-->
        <!--<table width=70% border=0>
          <col width=5%><col width=45%><col width=18%><col width=30%>-->
           <tr height="30" valign="top">
            <td align=right><%=item++%>) </td>
            <td align=left colspan=2><font color="#FF0000">Select </font>Data Element Components<br>
              <select name="selDEComp" size ="1" style="width:95%" valign="top" onChange="javascript:showDECompOrder()"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selDEComp'); return false">
  <%            for (int i = 0; vDEComp.size()>i; i++)
                {
                     String sDEName = (String)vDEComp.elementAt(i);
                     String sDE_ID = (String)vDECompID.elementAt(i);
  %>
                  <option value="<%=sDE_ID%>" <%if(sDE_ID.equals(sDEID)){%>selected<%}%>><%=sDEName%></option>
  <%            }  %>
              </select>
            </td>
            <td valign="bottom"><font color="#FF0000">Enter </font> Display Order<br>
              <input name="txtDECompOrder" type="text" value="<%=sDECompOrder%>" size="20" maxlength=4 onKeyUp="changeOrder();"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_txtDECompOrder'); return false">&nbsp;&nbsp;
            </td>
          </tr>
          <tr><td height="14" valign="top"></tr>    
          <tr>
            <td></td>
            <td>&nbsp;&nbsp;&nbsp;Selected Data Elements Components</td>
            <td align=left><input type="button" name="btnClearList1" value="Remove Item" style="width: 85", "height: 9" onClick="removeDEComp();"></td>
            <td>Display Order</td>
           </tr>
          <tr>
            <td></td>
            <td colspan=2 valign=top>&nbsp;&nbsp;
              <select name= "selOrderedDEComp" size="3"  style="width: 95%"  onChange="javascript:selectOList();"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selOrderedDEComp'); return false">
<%              for (int i = 0; vDEComp.size()>i; i++)
                {
                   String sDEName = (String)vDEComp.elementAt(i);
                   String sDE_ID = (String)vDECompID.elementAt(i);
%>
                  <option value="<%=sDE_ID%>" <%if(sDE_ID.equals(sDEID)){%>selected<%}%>><%=sDEName%></option>
<%
                }
%>
              </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            </td>
            <td colspan=1 valign="top">
              <select name= "selOrderList" size ="3" style="width:130" onChange="javascript:selectODEComp();"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selOrderList'); return false" >
<%              for (int i = 0; vDECompOrder.size()>i; i++)
                {
                   String sOrderName = (String)vDECompOrder.elementAt(i);
                   String sRelationID = (String)vDECompRelID.elementAt(i);
%>
                  <option value="<%=sRelationID%>" <%if(sOrderName.equals(sDECompOrder)){%>selected<%}%>><%=sOrderName%></option>
<%
                }
%>
              </select> 
            </td>
          </tr>
        <!--</table>-->
      </td>
    </tr>
    <tr><td height="14" valign="top"></tr>    
    <tr height="20" valign="bottom">
      <td align=right><%=item++%>)</td>
      <td colspan=3><font color="#FF0000"> <a href="javascript:SubmitValidate('validate')">Validate</a></font>
        the Data Element </td>
    </tr>
  </table> 
<%}%>
<input type="hidden" name="newCDEPageAction" value="nothing">
<%if(sOriginAction.equals("BlockEditDE")){%>
<input type="hidden" name="DEAction" value="BlockEdit">
<% } else {%>
<input type="hidden" name="DEAction" value="EditDE">
<% } %>
<input type="hidden" name="deIDSEQ" value="<%=sDEIDSEQ%>">
<!-- source, language, doctext ids from des/rd tables  -->
<input type="hidden" name="sourceIDSEQ" value="<%=sSourceIDSEQ%>">
<input type="hidden" name="doctextIDSEQ" value="<%=sDocTextIDSEQ%>">
<input type="hidden" name="regStatusIDSEQ" value="<%=sRegStatusIDSEQ%>">
<input type="hidden" name="selDECText" value="<%=sDEC%>">
<input type="hidden" name="selVDText" value="<%=sVD%>">
<input type="hidden" name="nameTypeChange" value="<%=decvdChanged%>">
<input type="hidden" name="MenuAction" value="<%=sMenuAction%>">
<select name="hiddenSelCSI" style="visibility:hidden;"></select>
<!-- stores the selected rows to get the bean from the search results -->
<select name= "hiddenSelRow" size="1" style="visibility:hidden;width:160"  multiple></select>
<input type="hidden" name="acSearch" value="">
<select name= "selCSCSIHidden" size ="1" style="visibility:hidden;"  multiple></select>
<select name= "selACCSIHidden" size ="1" style="visibility:hidden;"  multiple></select>
<select name= "selCSNAMEHidden" size="1" style="visibility:hidden;"  multiple></select>
<!-- store the selected ACs in the hidden field to use it for cscsi 
This is refilled with ac id from ac-csi to use it for block edit-->
<select name= "selACHidden" size="1" style="visibility:hidden;" multiple>
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
      <option value="<%=sAC_ID%>" selected><%=sACName%></option>
<%  }
  }   %>
</select>

 <!-- for DDE -->
<input type="hidden" name="DECompCountHidden" value="<%=vDEComp.size()%>">
<select name= "selDECompHidden" size ="1" style="visibility:hidden;"  multiple></select>
<select name= "selDECompIDHidden" size ="1" style="visibility:hidden;"  multiple></select>
<select name= "selDECompOrderHidden" size ="1" style="visibility:hidden;"  multiple></select>
<select name= "selDECompRelIDHidden" size ="1" style="visibility:hidden;"  multiple></select>
<select name= "selDECompDeleteHidden" size ="1" style="visibility:hidden;"  multiple></select>
<select name= "selDECompDelNameHidden" size ="1" style="visibility:hidden;"  multiple></select>
<% if (sDDEAction.equals("CreateNewDEFComp")) sOriginAction = sDDEAction; %>
<input type="hidden" name="originActionHidden" value="<%=sOriginAction%>">

<script language = "javascript">
displayStatusMessage();
changeCountPN();
changeCountLN();
loadCSCSI();
changeRepType('init');
</script>
</form>
</body>
</html>