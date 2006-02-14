<html>
<head>
<title>CreateNewCDE</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*" %>
<%@ page session="true" %>
<link href="FullDesignArial.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="Assets/date-picker.js"></script>
<SCRIPT LANGUAGE="JavaScript" SRC="Assets/AddNewListOption.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="Assets/CreateDE.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="Assets/SelectCS_CSI.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../../cdecurate/Assets/HelpFunctions.js"></SCRIPT>
<%
    Vector vContext = (Vector)session.getAttribute("vWriteContextDE");
    Vector vContextID = (Vector)session.getAttribute("vWriteContextDE_ID");
    Vector vStatus = (Vector)session.getAttribute("vStatusDE");
    Vector vRegStatus = (Vector)session.getAttribute("vRegStatus");
    Vector vCS = (Vector)session.getAttribute("vCS");
    Vector vCS_ID = (Vector)session.getAttribute("vCS_ID");
   // Vector vLanguage = (Vector)session.getAttribute("vLanguage");
    Vector vSource = (Vector)session.getAttribute("vSource");
	//  int count =0;
    String sDECLongID = "";

    UtilService serUtil = new UtilService();

    String sMenuAction = (String)session.getAttribute("MenuAction");
    String sOriginAction = (String)session.getAttribute("originAction");
    String sDDEAction = (String)session.getAttribute("DDEAction");
    if (sDDEAction == null) sDDEAction = "";
    DE_Bean m_DE = new DE_Bean();
    m_DE = (DE_Bean)session.getAttribute("m_DE");
    if (m_DE == null) m_DE = new DE_Bean();

    String sDEIDSEQ = m_DE.getDE_DE_IDSEQ();
    if (sDEIDSEQ == null) sDEIDSEQ = "";

    String sContext = m_DE.getDE_CONTEXT_NAME();
    if ((sContext == null) || (sContext.equals("")))
       sContext = (String)session.getAttribute("sDefaultContext");
    if (sContext == null) sContext = "";

    String sContID = m_DE.getDE_CONTE_IDSEQ();
    if (sContID == null) sContID = "";
    String sLongName = m_DE.getDE_LONG_NAME();
    sLongName = serUtil.parsedStringDoubleQuoteJSP(sLongName);    //call the function to handle doubleQuote
    if (sLongName == null) sLongName = "";
    int sLongNameCount = sLongName.length();

    String sName = m_DE.getDE_PREFERRED_NAME();
    sName = serUtil.parsedStringDoubleQuoteJSP(sName);    //call the function to handle doubleQuote
    if (sName == null) sName = "";
    int sNameCount = sName.length();
    String lblUserType = "Existing Name (Editable)";
    String sUserEnt = m_DE.getAC_USER_PREF_NAME();
    if (sUserEnt == null || sUserEnt.equals("")) lblUserType = "User Entered";
    //String sPrefName = m_DE.getDE_PREFERRED_NAME(); //for fillDE_NAME js functionm
    String sPrefType = m_DE.getAC_PREF_NAME_TYPE();
    if (sPrefType == null) sPrefType = ""; 
    String sDefinition = m_DE.getDE_PREFERRED_DEFINITION();
    if (sDefinition == null) sDefinition = "";

    //get dec attributes
    DEC_Bean dec = m_DE.getDE_DEC_Bean();
    if (dec == null) dec = new DEC_Bean();    
    String sDECID = dec.getDEC_DEC_IDSEQ();    //m_DE.getDE_DEC_IDSEQ();
    if ((sDECID == null) || (sDECID.equals("nothing"))) sDECID = "";
    String sDEC = dec.getDEC_LONG_NAME();   //m_DE.getDE_DEC_NAME();
    if (sDEC == null) sDEC = "";
    sDEC = serUtil.parsedStringDoubleQuoteJSP(sDEC);     //call the function to handle doubleQuote

    VD_Bean vd = m_DE.getDE_VD_Bean();
    if (vd == null) vd = new VD_Bean();
    String sVDID = vd.getVD_VD_IDSEQ();  // m_DE.getDE_VD_IDSEQ();
    if ((sVDID == null) || (sVDID.equals("nothing"))) sVDID = "";
    String sVD = vd.getVD_LONG_NAME();  // m_DE.getDE_VD_NAME();
    sVD = serUtil.parsedStringDoubleQuoteJSP(sVD);    //call the function to handle doubleQuote
    if (sVD == null) sVD = "";

    boolean decvdChanged = m_DE.getDEC_VD_CHANGED();
    
    String sVersion = m_DE.getDE_VERSION();
    if (sVersion == null) sVersion = "1.0";
    String sStatus = m_DE.getDE_ASL_NAME();
    if (sStatus == null) sStatus = "";   //"DRAFT NEW";
    String sRegStatus = m_DE.getDE_REG_STATUS();
    if (sRegStatus == null) sRegStatus = "";
    String sCDEID = m_DE.getDE_MIN_CDE_ID();
    if (sCDEID == null) sCDEID = "";
    String sBeginDate = m_DE.getDE_BEGIN_DATE();
    if (sBeginDate == null) sBeginDate = "";
    if (sBeginDate == "")
    {
       Date currentDate = new Date();
       SimpleDateFormat formatter = new SimpleDateFormat ("MM/dd/yyyy");
       sBeginDate = formatter.format(currentDate);
    }
    String sDocText = m_DE.getDOC_TEXT_PREFERRED_QUESTION();
    if (sDocText == null) sDocText = "";
    String sDocTextIDSEQ = m_DE.getDOC_TEXT_PREFERRED_QUESTION_IDSEQ();
    if (sDocTextIDSEQ == null) sDocTextIDSEQ = "";
    String sChangeNote = m_DE.getDE_CHANGE_NOTE();
    if (sChangeNote == null) sChangeNote = "";
 
    String sSourceIDSEQ = m_DE.getDE_SOURCE_IDSEQ();
    if (sSourceIDSEQ == null) sSourceIDSEQ = "";
    String sSource = m_DE.getDE_SOURCE();
    if (sSource == null) sSource = "";

    //get cs-csi attributes
    Vector vSelCSList = m_DE.getAC_CS_NAME();
    if (vSelCSList == null) vSelCSList = new Vector();
    Vector vSelCSIDList = m_DE.getAC_CS_ID();
    Vector vACCSIList = m_DE.getAC_AC_CSI_VECTOR();
    Vector vACId = (Vector)session.getAttribute("vACId");
    Vector vACName = (Vector)session.getAttribute("vACName");
    //initialize the beans
    CSI_Bean thisCSI = new CSI_Bean();
    AC_CSI_Bean thisACCSI = new AC_CSI_Bean();
    
    String sEndDate = m_DE.getDE_END_DATE();
    if (sEndDate == null) sEndDate = "";
    //get the contact hashtable for the de
    Hashtable hContacts = m_DE.getAC_CONTACTS();
    if (hContacts == null) hContacts = new Hashtable();
    session.setAttribute("AllContacts", hContacts);
    //these are for DEC and VD searches.
    session.setAttribute("MenuAction", "searchForCreate");
    Vector vResult = new Vector();
    session.setAttribute("results", vResult);
    session.setAttribute("creRecsFound", "No ");
    session.setAttribute("creKeyword", "");
    //for altnames and ref docs
    session.setAttribute("dispACType", "DataElement");
    
    // for DDE
    String sSelRepType = (String)session.getAttribute("sRepType");
    String sNVType = (String)session.getAttribute("NotValidDBType");
    if (sNVType == null) sNVType = "";
    String sSelConcatChar = (String)session.getAttribute("sConcatChar");
    String sSelRule = (String)session.getAttribute("sRule");
    String sSelMethod = (String)session.getAttribute("sMethod");
    Vector vRepType = new Vector();
    Vector vDEComp = new Vector();
    Vector vDECompID = new Vector();
    Vector vDECompOrder = new Vector();
    Vector vDECompRelID = new Vector();
    //if(sOriginAction != "CreateNewDEFComp")
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
 var selectedItem = null;
 var selectedMeaning = null;
 var cscsiWindow = null;
   
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
          thisACCSI = (AC_CSI_Bean)vACCSIList.elementAt(j);  //get the ac csi bean
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
    window.status = "Create new Data Element, choose context first"
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
<form name="newCDEForm" method="POST" action="/cdecurate/NCICurationServlet?reqType=newDEfromForm">
  <table width="100%" border="0">
    <!--DWLayoutTable-->
    <col width="5%"><col width="95%">
    <tr>
      <td align="left" valign="top" colspan=2>
        <input type="button" name="btnValidate" value="Validate" style="width: 125" onClick="SubmitValidate('validate')"
				onHelp = "showHelp('Help_CreateDE.html#newCDEForm_Validation'); return false">&nbsp;&nbsp;
          &nbsp;&nbsp;
        <input type="button" name="btnClear" value="Clear" style="width: 125" onClick="ClearBoxes();">
          &nbsp;&nbsp;
        <% if (sMenuAction.equals("Questions") || sMenuAction.equals("NewDETemplate") || sMenuAction.equals("NewDEVersion") || sDDEAction.equals("CreateNewDEFComp")){%>
        <input type="button" name="btnBack" value="Back" style="width: 125" onClick="Back();"> 
          &nbsp;&nbsp;
        <% } %>
        <input type="button" name="btnAltName" value="Alternate Names" style="width:125" onClick="openDesignateWindow('Alternate Names');"
				onHelp = "showHelp('Help_Updates.html#newDECForm_altNames'); return false">
          &nbsp;&nbsp;
        <input type="button" name="btnRefDoc" value="Reference Documents" style="width:140" onClick="openDesignateWindow('Reference Documents');"
				onHelp = "showHelp('Help_Updates.html#newDECForm_refDocs'); return false">
          &nbsp;&nbsp;
        <img name="Message" src="Assets/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" style="visibility:hidden;">
      </td>
    </tr>
  </table>
  <table width="90%"  border=0>
  	<col width="4%"><col width="95%">
     <tr valign="middle"> 
      <th colspan=2 height="40"> <div align="left"> 
          <label><font size=4>Create New <font color="#FF0000">Data Element </font> 
              <%if(sDDEAction.equals("CreateNewDEFComp")){%>Component 
              <% } else if (sMenuAction.equals("NewDEVersion")) { %>Version
              <% } else if (sMenuAction.equals("NewDETemplate")) { %>Using Existing
              <% } %>
          </font></label>
        </div></th>
    </tr>
      <tr height="25" valign="middle">
        <td colspan=2><font color="#FF0000">&nbsp;&nbsp;&nbsp;* &nbsp;&nbsp;</font>Indicates Required Field</td>
      </tr>
    <tr height="25" valign="bottom"> 
      <td align=right><font color="#FF0000">* &nbsp;</font><%=item++%>)</td>
      <td><font color="#FF0000">Select </font>Context</td>
    </tr>
    <tr>
      <td><font color="#FF0000"> </font></td>
      <td> <select name="selContext" size="1"
	     onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false" >
<%          boolean bDataFound = false;
           for (int i = 0; vContext.size()>i; i++)
           {
             String sContextName = (String)vContext.elementAt(i);
             String sContextID = (String)vContextID.elementAt(i);
             //if(sContext.equals("")) sContext = sContextName;
             if(sContextName.equals(sContext)) bDataFound = true;
%>
          <option value="<%=sContextID%>" <%if(sContextName.equals(sContext)){%>selected<%}%> ><%=sContextName%></option>
<%
           }
           if(bDataFound == false) { %>
            <option value="" selected></option>
<%         }
%>
        </select> </td>
    <tr valign="bottom" height="25">
      <td align=right><font color="#FF0000">*  &nbsp;</font><%=item++%>)</td>
      <td><font color="#FF0000">Select </font>Data Element Concept Long Name </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>
        <select name="selDEC" size="1" multiple style="width:430"
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selDEC'); return false">
            <option value="<%=sDECID%>" ><%=sDEC%></option>
        </select>
        &nbsp;&nbsp;
        <a href="javascript:SearchDECValue()"> Search</a>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <a href="javascript:CreateNewDECValue()"> Create New </a>
      </td>
    </tr>
    <tr valign="bottom"  height="25">
      <td align=right><font color="#FF0000">* &nbsp;</font><%=item++%>)</td>
      <td><font color="#FF0000">Select </font>Value Domain Long Name </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>
        <select name= "selVD" size ="1" multiple style="width:430"
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selVD'); return false">
            <option value="<%=sVDID%>" ><%=sVD%></option>
        </select>
        &nbsp;&nbsp;
        <a href="javascript:SearchVDValue()"> Search</a>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <a href="javascript:CreateNewVDValue()"> Create New</a>
      </td>
    <tr height="25" valign="bottom" >
      <td align=right><font color="#FF0000">* &nbsp;</font><%=item++%>)</td>
      <td><font color="#FF0000">Verify </font>
        <font color="#000000"> Data Element Long Name (* ISO Preferred Name)</font></td>
    </tr>
    <tr>
      <td><font color="#FF0000"> </font></td>
      <td height="24" valign="top" >
        <input name="txtLongName" type="text" value="<%=sLongName%>" size="80" maxlength=255 onKeyUp="changeCountLN();"
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_txtLongName'); return false">
        &nbsp;&nbsp;&nbsp; <font color="#666666">
        <input name="txtLongNameCount" type="text" size="1" value="<%=sLongNameCount%>" readonly >
        <font color="#000000"> Character Count</font></font>
        &nbsp;&nbsp;(Database Max = 255)
      </td>
    </tr>
    <tr height="25" valign="bottom" >
      <td align=right><font color="#FF0000">* &nbsp;</font><%=item++%>)</td>
      <td><font color="#FF0000">Update </font>Data Element Short Name</td>
    </tr>
    <tr>
    	<td>&nbsp;</td>
     	<td height="24" valign="bottom">Select Short Name Naming Standard</td>
    </tr>
    <tr>
    	<td>&nbsp;</td>
     	<td height="24" valign="top">
	      <input name="rNameConv" type="radio" value="SYS" 
	      	onclick="javascript:SubmitValidate('changeNameType');" 
	      	<%if (sPrefType.equals("SYS")) {%>checked <%}%>>System Generated &nbsp;&nbsp;&nbsp; 
        <input name="rNameConv" type="radio" value="ABBR" 
        	onclick="javascript:SubmitValidate('changeNameType');" 
        	<%if (sPrefType.equals("ABBR")) {%>checked <%}%>>Abbreviated &nbsp;&nbsp;&nbsp; 
        <input name="rNameConv" type="radio" value="USER" 
        	onclick="javascript:SubmitValidate('changeNameType');" 
        	<%if (sPrefType.equals("USER")) {%> checked <%}%>><%=lblUserType%>   <!--Existing Name (Editable)  User Maintained-->
      </td>
    </tr> 
    <tr>
      <td><font color="#FF0000"> </font></td>
      <td height="24" valign="top">
	     <input name="txtPreferredName" type="text" value="<%=sName%>" size="80" maxlength=30 onKeyUp="changeCountPN();"
           <%if (sPrefType.equals("") || sPrefType.equals("SYS") || sPrefType.equals("ABBR")) {%> readonly<%}%>
  	       onHelp = "showHelp('Help_CreateDE.html#newCDEForm_txtLongName'); return false">
          &nbsp;&nbsp;&nbsp; <font color="#666666">
        <input name="txtPrefNameCount" type="text" size="1"  value="<%=sNameCount%>" readonly>
          <font color="#000000"> Character Count</font></font>
          &nbsp;&nbsp;(Database Max = 30)
      </td>
    </tr>
    <tr><td height="8" valign="top"></tr>
    <tr height="25" valign="top">
      <td align=right><font color="#FF0000">* &nbsp;</font><%=item++%>)</td>
      <td><font color="#FF0000">Create/Edit</font> Definition<br>
        (Changes to naming components will replace existing definition text.)
      </td>
    </tr>
    <tr> 
      <td><font color="#FF0000"> </font></td>
      <td valign="top" align="left"> 
        <textarea name="CreateDefinition"  style="width:80%" rows=6
        onHelp = "showHelp('Help_CreateDE.html#newCDEForm_CreateDefinition'); return false"><%=sDefinition%></textarea>
        <!-- &nbsp;&nbsp;<a href="javascript:AccessEVS()">Search</a> -->
      </td>
    </tr>
    <tr height="25" valign="bottom"> 
      <td align=right><font color="#FF0000">* &nbsp;</font><%=item++%>)</td>
      <td><font color="#FF0000">Select </font> Workflow Status</td>
    </tr>
    <tr>
      <td><font color="#FF0000"> </font></td>
      <td height="26" valign="top" > <select name="selStatus" size="1"
        onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selStatus'); return false">
        <option value="" selected="selected"></option>
<%   for (int i = 0; vStatus.size()>i; i++)
     {
        String sStatusName = (String)vStatus.elementAt(i);
        //add only draft new and retired phased out if creating new
        if (sMenuAction.equals("Questions"))
        {
           if (sStatusName.equals("DRAFT NEW") || sStatusName.equals("RETIRED PHASED OUT"))
           {
%>
              <option value="<%=sStatusName%>" <%if(sStatusName.equals(sStatus)){%>selected<%}%> ><%=sStatusName%></option>
<%         }
        }
        else
        {
%>
           <option value="<%=sStatusName%>" <%if(sStatusName.equals(sStatus)){%>selected<%}%> ><%=sStatusName%></option>
<%
        }
     }
%>
        </select> </td>
    </tr>
    <tr height="25" valign="bottom">
      <td align=right><font color="#FF0000">* &nbsp;</font><%=item++%>)</td>
      <td><font color="#FF0000">Enter</font> Version</td>
    </tr>
    <tr>
      <td><font color="#FF0000"> </font></td>
      <td valign="top" > <input name="Version" type="text" value="<%=sVersion%>" size="5" maxlength=5
    	  onHelp = "showHelp('Help_CreateDE.html#newCDEForm_Version'); return false">
        &nbsp;&nbsp;&nbsp;<a href="http://ncicb.nci.nih.gov/NCICB/infrastructure/cacore_overview/cadsr/business_rules" target="_blank">Business Rules</a>
      </td>
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
%>
              <option value="<%=sReg%>" <%if(sReg.equals(sRegStatus)){%>selected<%}%>><%=sReg%></option>
<%
            } }
%>
        </select>
      </td>
    </tr>
    <tr height="25" valign="bottom">
      <td align=right><font color="#FF0000">*</font><%=item++%>)</td>
      <td> <font color="#FF0000">Enter/Select </font>Effective Begin Date</td>
    </tr>
    <tr> 
      <td><font color="#FF0000"> </font></td>
      <td height="25" valign="top" > <input type="text" name="BeginDate" value="<%=sBeginDate%>" size="12" maxlength=10
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_BeginDate'); return false"> 
        <a href="javascript:show_calendar('newCDEForm.BeginDate', null, null, 'MM/DD/YYYY');"> 
        <img name="Calendar" src="Assets/calendarbutton.gif" width="22" height="22" alt="Calendar" style="vertical-align: top", "background-color: #FF0000">
        </a>&nbsp;&nbsp;MM/DD/YYYY </td>
    </tr>
    <tr height="25" valign="bottom">
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
    
    <tr height="25" valign="bottom">
      <td align=right><%=item++%>)</td>
      <td><font color="#FF0000">Create</font> Preferred Question Text</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td height="35" valign="top">
        <textarea name="CreateDocumentText" cols="89"
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_CreateDocumentText'); return false" rows="2"><%=sDocText%></textarea>
      </td>
    </tr>
    <tr height="30" valign="bottom">
      <td align=right><%=item++%>)</td>
      <td><font color="#FF0000">Select </font>Classification Schemes and Classification Scheme Items</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>
        <table width=80% border="0">
          <col width="1%"><col width="25%"><col width="10%"> <col width="25%"><col width="10%">
          <tr>
            <td height="30" valign="top" colspan=3>
              <select name="selCS" size ="1" style="width:95%" valign="top" onChange="ChangeCS()"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selCS'); return false">
                <option value="" selected></option>
  <%            for (int i = 0; vCS.size()>i; i++)
                {
                   String sCSName = (String)vCS.elementAt(i);
                   String sCS_ID = (String)vCS_ID.elementAt(i);
  %>
                  <option value="<%=sCS_ID%>"><%=sCSName%></option>
  <%            }  %>
              </select> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            </td>
            <td height="30" valign="top" colspan=2>
              <select name="selCSI" size="5" style="width:95%" onChange="selectCSI();"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selCS'); return false"> <!-- onChange="AddItemsToLists();"> -->
              </select>
            </td>
          </tr>
          <tr><td height="12" valign="top"></tr>    
          <tr>
            <td>&nbsp;</td>
            <td align="left">Selected Classification Schemes</td>
            <td align=left><input type="button" name="btnRemoveCS" value="Remove Item" style="width: 85", "height: 9" onClick="removeCSList();"></td>
            <td align="left">Associated Classification Scheme Items</td>
            <td align=left><input type="button" name="btnRemoveCSI" value="Remove Item" style="width: 85", "height: 9" onClick="removeCSIList();"></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan=2>
                <select name="selectedCS" size="5" style="width:98%" multiple onchange="addSelectCSI(false, true, '');"
                  onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selCS'); return false">
<%                  //store selected cs list on load 
                  if (vSelCSIDList != null) 
                  {
                    for (int i = 0; vSelCSIDList.size()>i; i++)
                    {
                      String sCS_ID = (String)vSelCSIDList.elementAt(i);
                      String sCSName = "";
                      if (vSelCSList != null && vSelCSList.size() > i)
                         sCSName = (String)vSelCSList.elementAt(i);
%>
                      <option value="<%=sCS_ID%>"><%=sCSName%></option>
<%                  }
                  }   %>
                </select>
            </td>
            <td colspan=2>
                <select name="selectedCSI" size="5" style="width:100%" multiple onchange="addSelectedAC();"
                    onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selCS'); return false">
                </select>
            </td>
          </tr>
        </table>
      </td>
    </tr>
 <!-- contact info -->
    <tr><td height="20" valign="top"></tr>    
  	<tr>
	  <td valign="top" align=right><%=item++%>)</td>
	  <td valign="bottom"><font color="#FF0000">Select </font>Contacts
      <br>
        <table width=50% border="0">
          <col width="40%"><col width="15%"> <col width="15%"><col width="15%">
		  <tr>
		    <td>&nbsp;</td>
            <td align="left"><input type="button" name="btnViewCt" value="Edit Item" 
            	style="width:100" onClick="javascript:editContact('view');" disabled></td>
            <td align="left"><input type="button" name="btnCreateCt" value="Create New" 
            	style="width:100" onClick="javascript:editContact('new');"></td>
            <td align="center"><input type="button" name="btnRmvCt" value="Remove Item" 
            	style="width:100" onClick="javascript:editContact('remove');" disabled></td>
		  </tr>
		  <tr> 
	      	<td colspan=4 valign="top">
	          <select name="selContact" size="4"  style="width:100%" onchange="javascript:enableContButtons();" 
	          	onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContact'); return false">
<%	
				Enumeration enum1 = hContacts.keys();
				while (enum1.hasMoreElements())
				{
				  String contName = (String)enum1.nextElement();
				  AC_CONTACT_Bean acCont = (AC_CONTACT_Bean)hContacts.get(contName);				  
				  if (acCont == null) acCont = new AC_CONTACT_Bean();
				  String ctSubmit = acCont.getACC_SUBMIT_ACTION();
				  if (ctSubmit != null && ctSubmit.equals("DEL"))
				    continue;
				  /*  String accID = acCont.getAC_CONTACT_IDSEQ();
				  String contName = acCont.getORG_NAME();
				  if (contName == null || contName.equals(""))
				    contName = acCont.getPERSON_NAME(); */
%>
				  <option value="<%=contName%>"><%=contName%></option>
<%				  
				}
%>	          	
	          </select>
	      	</td>
		  </tr>
		</table>
	  </td>
	</tr>
<!-- origin -->
    <tr height="25" valign="bottom">
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
<%           }   %>
        </select>
      </td>
    </tr>

    <tr> </tr>
    <tr height="25" valign="bottom">
      <td align=right><%=item++%>)</td>
      <td><font color="#FF0000">Create</font> Change Note</td>
    </tr>

    <tr>
      <td>&nbsp;</td>
      <td height="35" valign="top">
        <textarea name="CreateChangeNote" cols="69"
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_CreateComment'); return false" rows="2"><%=sChangeNote%></textarea>
      </td>
    </tr>
    <tr><td height="14" valign="top"></tr>    
    <tr height="20" valign="bottom">
      <td align=right><%=item++%>)</td>
      <td><font color="#FF0000"> <a href="javascript:SubmitValidate('validate')">Validate</a></font>
        the New Data Element </td>
    </tr>
  </table>
  <hr>  
<%if(!sDDEAction.equalsIgnoreCase("CreateNewDEFComp")) {%>

  <!--********************************************************************************************************************-->
  <!--if not for create new from DDE or not for Block edit  -->
  <table width="800" border="0" name="DDETable">
  	<col width="4%"><col width="30%"><col width="15%"> <col width="30%">
    <!--<col width="4%"> <col width="95%">-->
    <tr>
      <th height="40" colspan=4> 
       <legend align=top><div align="left"> 
          <label><font size=4>Derived Data Element Derivation Rules and Components</font></label>
        </div> </legend></th>
    </tr>
    <tr> </tr>
    <tr height="25" valign="middle">
        <td colspan =4><font color="#FF0000">&nbsp;&nbsp;&nbsp;* &nbsp;</font>Indicates Required Fields for Derived Data Elements</td>
    </tr>
    <tr height="25" valign="bottom"> 
      <td align=right><font color="#FF0000">*</font><%=item++%>)</td>
      <td colspan=3><font color="#FF0000">Select</font> Derivation Type</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td height="26" valign="top" colspan=3 > 
        <select name="selRepType" size="1" onChange="javascript:changeRepType('change')"
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selRepType'); return false">
          <option value="" selected></option>
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
      <td align=right><font color="#FF0000">*</font><%=item++%>)</td>
      <td colspan=3><font color="#FF0000">Create</font> Rule</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td height="35" valign="top" colspan=3>
        <textarea name="DDERule" cols="69"
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_DDERule'); return false" rows="2"><%=sSelRule%></textarea>
      </td>
    </tr>
    <tr height="25" valign="bottom">
      <td align=right><%=item++%>)</td>
      <td colspan=3><font color="#FF0000">Create </font> Methods </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td height="35" valign="top" colspan=3>
        <textarea name="DDEMethod" cols="69"
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_DDEMethod'); return false" rows="2"><%=sSelMethod%></textarea>
      </td>
    </tr>
    <tr height="25" valign="bottom">
      <td align=right><%=item++%>)</td>
      <td colspan=3><font color="#FF0000">Enter</font> Concatenation Character </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td valign="top" colspan=3 > <input name="DDEConcatChar" type="text" value="<%=sSelConcatChar%>" size="5" maxlength=1
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_DDEConcatChar'); return false"></td>
    </tr>
    
  <!--<table width=70% border="0">
          <col width="5%"><col width="45%"><col width="18%"> <col width="30%">-->
	<tr height="25" valign="bottom">
      <td align=right><%=item++%>)</td>
      <td><font color="#FF0000">Search/Create </font>Data Element Components </td>
      <td align=left><a href="javascript:SearchDEValue()">Search</a> For</td>
      <td align=left><a href="javascript:CreateNewDEValue()">Create</a> New</td>
    </tr>
    <tr height ="25" valign="top">
    	<td colspan=2>
    	<td align=left>Data Element </td>
    	<td align=left>Data Element</td>
    </tr>	
    	
    <tr><td height="14" valign="top"></tr>
          <tr height="30" valign="top">
            <td align=right><%=item++%>)</td>
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
            <td>&nbsp;</td>
            <td>&nbsp;&nbsp;&nbsp;Selected Data Elements Components</td>
            <td align=left><input type="button" name="btnClearList1" value="Remove Item" style="width: 85", "height: 9" onClick="removeDEComp();"></td>
            <td>Display Order</td>
           </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan=2 valign=top>&nbsp;&nbsp;&nbsp;
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
              </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
            <td colspan=1 valign=top>
              <select name= "selOrderList" size ="3" style="width:120" onChange="javascript:selectODEComp();"
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
         <tr><td height="14" valign="top"></tr>    
    <tr height="20" valign="bottom">
      <td align=right><%=item++%>)</td>
      <td colspan=3><font color="#FF0000"> <a href="javascript:SubmitValidate('validate')">Validate</a></font>
        the New Data Element </td>
    </tr> 
        <!--</table>-->
    
  </table> 
<%}%>

<input type="hidden" name="newCDEPageAction" value="nothing">
<input type="hidden" name="DEAction" value="NewDE">
<input type="hidden" name="deIDSEQ" value="<%=sDEIDSEQ%>">
<input type="hidden" name="decIDSEQ" value="<%=sDECLongID%>">
<input type="hidden" name="sourceIDSEQ" value="">
<input type="hidden" name="doctextIDSEQ" value="">
<input type="hidden" name="CDE_IDTxt" value="<%=sCDEID%>">
<input type="hidden" name="selDECText" value="<%=sDEC%>">
<input type="hidden" name="selVDText" value="<%=sVD%>">
<input type="hidden" name="nameTypeChange" value="<%=decvdChanged%>">
<input type="hidden" name="MenuAction" value="<%=sMenuAction%>">
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
%>
      <option value="<%=sAC_ID%>"><%=sACName%></option>
<%  }
  }   %>
</select>

 <!-- for DDE -->
<input type="hidden" name="NotValidDBType" value="<%=sNVType%>">
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
loadCSCSI();
changeCountPN();
changeCountLN();
//changeRepType('init');
</script>
</form>
</body>
</html>