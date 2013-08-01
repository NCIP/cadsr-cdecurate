<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/EditDEC.jsp,v 1.33 2009-04-23 18:06:53 veerlah Exp $
    $Name: not supported by cvs2svn $
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>
			Edit DataElementConcept
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<%@ page import="java.util.*"%>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.util.*"%>
		<%@ page session="true"%>
		<script language="JavaScript" src="js/date.js"></script>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/AddNewListOption.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/CreateDEC.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/SelectCS_CSI.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<%
		
		//for view only page
	    String bodyPage = (String) request.getAttribute("IncludeViewPage");
	    boolean isView = false;
	    if (bodyPage != null && !bodyPage.equals(""))
		  isView = true;
    
		Vector vContext = null;
        Vector vStatus = null;
        Vector vSource = null;
        Vector vCS = null;
        Vector vCS_ID = null;
        Vector vRegStatus = null;//GF32398
        if (!isView){
            vContext = (Vector)session.getAttribute("vWriteContextDEC");
            //Vector vContextID = (Vector)session.getAttribute("vWriteContextDEC_ID");
            vStatus = (Vector)session.getAttribute("vStatusDEC");
            //Vector vCD = (Vector)session.getAttribute("vCD");
            //Vector vCDID = (Vector)session.getAttribute("vCD_ID");
            //Vector vLanguage = (Vector)session.getAttribute("vLanguage");
            vSource = (Vector)session.getAttribute("vSource");
            vCS = (Vector)session.getAttribute("vCS");
            vCS_ID = (Vector)session.getAttribute("vCS_ID");
            vRegStatus = (Vector) session.getAttribute("vRegStatus");//GF32398
        }
    
    UtilService serUtil = new UtilService();
    String sMenuAction = (String)session.getAttribute(Session_Data.SESSION_MENU_ACTION);
    if (!isView) {
		if (sMenuAction.equals("nothing")) {
			sMenuAction = "editDEC";
		    session.setAttribute(Session_Data.SESSION_MENU_ACTION, "editDEC");
		}
	}
    String sOriginAction = (String)session.getAttribute("originAction");
    if (sOriginAction == null) sOriginAction="";
 
    DEC_Bean m_DEC = new DEC_Bean();
    String decID = "";
    if (isView){
	   decID = (String)request.getAttribute("viewDECId");
	   String viewDEC = "viewDEC" + decID;
	   m_DEC = (DEC_Bean) session.getAttribute(viewDEC);
	}else{
       m_DEC = (DEC_Bean)session.getAttribute("m_DEC");
    }  
    if (m_DEC == null) m_DEC = new DEC_Bean();
    
     String sDECIDSEQ = m_DEC.getDEC_DEC_IDSEQ();
    if (sDECIDSEQ == null) sDECIDSEQ = "";
    String sPublicDECID = m_DEC.getDEC_DEC_ID();
    if (sPublicDECID == null) sPublicDECID = "";
  
    Vector vOCQualifierNames = m_DEC.getDEC_OC_QUALIFIER_NAMES();
    if (vOCQualifierNames == null) vOCQualifierNames = new Vector();
//System.out.println("editdec jsp vOCQualifierNames.size(): " + vOCQualifierNames.size());
    Vector vOCQualifierCodes = m_DEC.getDEC_OC_QUALIFIER_CODES();
    if (vOCQualifierCodes == null) vOCQualifierCodes = new Vector();
    Vector vOCQualifierDB = m_DEC.getDEC_OC_QUALIFIER_DB();
    if (vOCQualifierDB == null) vOCQualifierDB = new Vector();
    
    Vector vPropQualifierNames = m_DEC.getDEC_PROP_QUALIFIER_NAMES();
    if (vPropQualifierNames == null) vPropQualifierNames = new Vector();
    Vector vPropQualifierCodes = m_DEC.getDEC_PROP_QUALIFIER_CODES();
    if (vPropQualifierCodes == null) vPropQualifierCodes = new Vector();
    Vector vPropQualifierDB = m_DEC.getDEC_PROP_QUALIFIER_DB();
    if (vPropQualifierDB == null) vPropQualifierDB = new Vector(); 
    
    String sOCCCodeDB = m_DEC.getDEC_OC_EVS_CUI_ORIGEN();
    String sOCCCode = m_DEC.getDEC_OC_CONCEPT_CODE();
    String sPCCCodeDB = m_DEC.getDEC_PROP_EVS_CUI_ORIGEN();
    String sPCCCode = m_DEC.getDEC_PROP_CONCEPT_CODE();
    String sObjClass = m_DEC.getDEC_OCL_NAME();
    String sPropClass = m_DEC.getDEC_PROPL_NAME();
    String sObjClassPrimary = m_DEC.getDEC_OCL_NAME_PRIMARY();
    String sPropClassPrimary = m_DEC.getDEC_PROPL_NAME_PRIMARY();
    String sRegStatus = m_DEC.getDEC_REG_STATUS();//GF32398
	if (sRegStatus == null)//GF32398
		sRegStatus = "";//GF32398
    String sRegStatusIDSEQ = m_DEC.getDEC_REG_STATUS_IDSEQ();//GF32398
	if (sRegStatusIDSEQ == null)//GF32398
		sRegStatusIDSEQ = "";//GF32398
    if(sObjClass == null) sObjClass = "";
    if(sPropClass == null) sPropClass = "";
     
    if(sObjClassPrimary == null) sObjClassPrimary = "";
    if(sPropClassPrimary == null) sPropClassPrimary = "";
 
    String evsConceptUrl = ToolURL.getEVSBrowserConceptUrl(pageContext);
    String objectClassUrl = null;
    String propClassUrl = null;
    
    if ((sOCCCodeDB != null) && (sOCCCode != null) && evsConceptUrl != null){
        objectClassUrl = evsConceptUrl.replace("$VOCAB$",sOCCCodeDB);
        objectClassUrl = objectClassUrl.replace("$CODE$",sOCCCode);
    }
    if ((sPCCCodeDB != null) && (sPCCCode != null) &&  evsConceptUrl != null){
        propClassUrl = evsConceptUrl.replace("$VOCAB$",sPCCCodeDB);
        propClassUrl = propClassUrl.replace("$CODE$",sPCCCode);
    }
    
    if(sOCCCodeDB == null) sOCCCodeDB = "";
    if(sOCCCode == null) sOCCCode = "";
    if(sPCCCodeDB == null) sPCCCodeDB = "";
    if(sPCCCode == null) sPCCCode = "";
    
    String sLongName = "";
    String sName = "";
    
    String sObjQualLN = "";
    String sObjQualLong = "";
    String sPropQualLN = "";
    String sPropQualLong = "";

    sObjClass = serUtil.parsedStringDoubleQuoteJSP(sObjClass);    //call the function to handle doubleQuote
    sObjClass = AdministeredItemUtil.handleLongName(sObjClass);	//GF32004
    sPropClass = serUtil.parsedStringDoubleQuoteJSP(sPropClass);    //call the function to handle doubleQuote
    sPropClass = AdministeredItemUtil.handleLongName(sPropClass);	//GF32004
    
    boolean nameTypeChange = false;
    String sNewOC = (String)session.getAttribute("newObjectClass");
    if (sNewOC == null) sNewOC = "";
    if(sNewOC.equals("true")) nameTypeChange = true;
    String sNewProp = (String)session.getAttribute("newProperty");
    if (sNewProp == null) sNewProp = "";
    if(sNewProp.equals("true")) nameTypeChange = true;
    String sRemoveOCBlock = (String)session.getAttribute("RemoveOCBlock");
    if (sRemoveOCBlock == null) sRemoveOCBlock = "";
    if(sRemoveOCBlock.equals("true")) nameTypeChange = true;
    String sRemovePropBlock = (String)session.getAttribute("RemovePropBlock");
    if (sRemovePropBlock == null) sRemovePropBlock = "";
    if(sRemovePropBlock.equals("true")) nameTypeChange = true;
    String sOCFont = "#000000", sPropFont = "#000000"; //black color
    if(sOriginAction.equals("BlockEditDEC") && (sNewOC.equals("true") || sRemoveOCBlock.equals("true")) && !sObjClass.equals(""))
      sPropFont = "#C0C0C0";  // property is grey color and not editable
    if(sOriginAction.equals("BlockEditDEC") && (sNewProp.equals("true") || sRemovePropBlock.equals("true")) && !sPropClass.equals(""))
      sOCFont = "#C0C0C0"; //object is grey color and not editable
    // javascript is handling the name change before it gets here
    sLongName = m_DEC.getDEC_LONG_NAME();
    sLongName = serUtil.parsedStringDoubleQuoteJSP(sLongName);    //call the function to handle doubleQuote
    if (sLongName == null) sLongName = "";
    int sLongNameCount = sLongName.length();
    sName = m_DEC.getDEC_PREFERRED_NAME();
    sName = serUtil.parsedStringDoubleQuoteJSP(sName);    //call the function to handle doubleQuote
    if (sName == null) sName = "";
    if(sOriginAction.equals("BlockEditDEC")) sName = "";
    int sNameCount = sName.length();  
    String sPrefType = m_DEC.getAC_PREF_NAME_TYPE();
    if (sPrefType == null) sPrefType = ""; 
    String lblUserType = "Existing Name (Editable)";  //make string for user defined label
    String sUserEnt = m_DEC.getAC_USER_PREF_NAME();
    if(sOriginAction.equals("BlockEditDEC")) lblUserType = "Existing Name (Not Editable)";
    else if (sUserEnt == null || sUserEnt.equals("")) lblUserType = "User Entered";
     
    String sContext = m_DEC.getDEC_CONTEXT_NAME();
    if (sContext == null) sContext = "";
    String sContID = m_DEC.getDEC_CONTE_IDSEQ();
    if (sContID == null) sContID = "";
    //get the selected contexts
    Vector vSelectedContext = m_DEC.getAC_SELECTED_CONTEXT_ID();
    
    String sDefinition = m_DEC.getDEC_PREFERRED_DEFINITION();
    if (sDefinition == null) sDefinition = "";

    String sVersion = m_DEC.getDEC_VERSION();
    if (sVersion == null) sVersion = "1.0";
    String sConDomID = m_DEC.getDEC_CD_IDSEQ();
    if (sConDomID == null) sConDomID = "";
    String sConDom = m_DEC.getDEC_CD_NAME();
    if (sConDom == null) sConDom = "";
    String sStatus = m_DEC.getDEC_ASL_NAME();
    if (sStatus == null && sOriginAction.equals("BlockEditDEC")) sStatus = "";
    else if (sStatus == null) sStatus = "DRAFT NEW";
    String sBeginDate = m_DEC.getDEC_BEGIN_DATE();
    if (sBeginDate == null) sBeginDate = "";

    String sSource = m_DEC.getDEC_SOURCE();
    if (sSource == null) sSource = "";
    
    String sChangeNote = m_DEC.getDEC_CHANGE_NOTE();
    if (sChangeNote == null) sChangeNote = "";
   
    Vector vSelCSList = m_DEC.getAC_CS_NAME();
    if (vSelCSList == null) vSelCSList = new Vector();
 //   System.out.println("cs jsp " + vSelCSList.size());
    Vector vSelCSIDList = m_DEC.getAC_CS_ID();
    Vector vACCSIList = m_DEC.getAC_AC_CSI_VECTOR();
    Vector vACId = (Vector)session.getAttribute("vACId");
    Vector vACName = (Vector)session.getAttribute("vACName");
    //initialize the beans
    CSI_Bean thisCSI = new CSI_Bean();
    AC_CSI_Bean thisACCSI = new AC_CSI_Bean();

    String sEndDate = m_DEC.getDEC_END_DATE();
    if (sEndDate == null) sEndDate = "";
    int longNameCount = 0;
    boolean bDataFound = false;
    //get the contact hashtable for the de
    Hashtable hContacts = m_DEC.getAC_CONTACTS();
    if (hContacts == null) hContacts = new Hashtable();
    if (!isView) {
    session.setAttribute("AllContacts", hContacts);

     //these are for DEC and VD searches.
    session.setAttribute(Session_Data.SESSION_MENU_ACTION, "searchForCreate");
    Vector vResult = new Vector();
    session.setAttribute("results", vResult);
    session.setAttribute("creRecsFound", "No ");
    //for altnames and ref docs
    session.setAttribute("dispACType", "DataElementConcept");
    }
    session.setAttribute("parentAC", "DEC");
    int item = 1;
    String vdNameDisplay = "";
    if (!sLongName.equals(""))
      	       vdNameDisplay = " - " + sLongName + "  [" + sPublicDECID + "v" + sVersion + "]";
%>


		<Script Language="JavaScript">
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
    if ((vCSIList != null) && (vACCSIList != null)){   
    for (int i=0; i<vCSIList.size(); i++)  //loop csi vector
    {
      thisCSI = (CSI_Bean)vCSIList.elementAt(i);  //get the csi bean
      //System.out.println(thisCSI.getCSI_CS_IDSEQ() + " : " + thisCSI.getCSI_LABEL());
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
    <%  }   } %>
      loadSelCSCSI();  //load the existing relationship
      loadWriteContextArray();  //load the writable contexts
    
  }

   function loadSelCSCSI()
   {
<%    //Vector vACCSIList = (Vector)request.getAttribute("vACCSIList");
      if (vACCSIList != null)
      {      
        for (int j=0; j<vACCSIList.size(); j++)  //loop csi vector
        {
          thisACCSI = (AC_CSI_Bean)vACCSIList.elementAt(j);  //get the csi bean
          thisCSI = (CSI_Bean)thisACCSI.getCSI_BEAN();
         // System.out.println("jsp " + thisCSI.getCSI_NAME() + " : " + thisACCSI.getAC_LONG_NAME());
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
    <% if ((vContext != null)&&(!isView)) 
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

 function setup(){
     var oc = document.getElementById("ObjClass");
     oc.innerText = "<%=sOCCCodeDB%>";
     oc.textContent = "<%=sOCCCodeDB%>";
     
     var ocId = document.getElementById("ObjClassID");   
     ocId.innerText = "<%=sOCCCode%>";
     ocId.textContent = "<%=sOCCCode%>";
     
     var prop = document.getElementById("PropClass"); 
     prop.innerText = "<%=sPCCCodeDB%>";
     prop.textContent  = "<%=sPCCCodeDB%>";
      
     var propId = document.getElementById("PropClassID"); 
     propId.innerText = "<%=sPCCCode%>"; 
     propId.textContent = "<%=sPCCCode%>"; 
 }
 
 function openEVSConceptsWindow(text){
  var conceptUrl = "<%=evsConceptUrl%>";
  var vocab = "";
  var code = "";
  if (text == "ObjectQualifier"){
     vocab = ObjQual.innerText;
     vocab = ObjQual.textContent;
     code = ObjQualID.innerText; 
     code = ObjQualID.textContent;
  }else if(text == "PropertyQualifier"){
     vocab = PropQual.innerText;
     vocab = PropQual.textContent;
     code = PropQualID.innerText;
     code = PropQualID.textContent;
  }
  conceptUrl = conceptUrl.replace("$VOCAB$",vocab);
  conceptUrl = conceptUrl.replace("$CODE$",code);
  window.open(conceptUrl,'','');
}
</Script>
	</head>
	<body onLoad="setup();hideCloseButton(<%=isView%>);" onUnload="closeDep();">

		<form name="SearchActionForm" method="post" action="">
			<input type="hidden" name="searchComp" value="">
			<input type="hidden" name="searchEVS" value="DataElementConcept">
			<input type="hidden" name="isValidSearch" value="true">
			<input type="hidden" name="SelContext" value="">
			<input type="hidden" name="acID" value="<%=sDECIDSEQ%>">
			<input type="hidden" name="itemType" value="">
		</form>
		<form name=newDECForm method="POST" action="../../cdecurate/NCICurationServlet?reqType=editDEC">
		    <%String displayErrorMessage = (String)session.getAttribute("displayErrorMessage");
		    if ((displayErrorMessage != null)&&(displayErrorMessage).equals("Yes")){ %>
		  	 <b><font  size="3">Not Authorized for Edits in this Context.</font></b></br></br>
	       <%}%>
			<table border="0">
				<tr>
					<td height="26" align="left" valign="top">
						<%	if (!isView) { %>
						<input type="button" name="btnValidate" value="Validate"  onClick="SubmitValidate('validate');" onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_Validation',helpUrl); return false">
						&nbsp;&nbsp;
						<input type="button" name="btnClear" value="Clear" onClick="ClearBoxes();">
						&nbsp;&nbsp;
						<% if (!sOriginAction.equals("NewDECFromMenu") && !sOriginAction.equals("")){%>
						<input type="button" name="btnBack" value="Back" onClick="Back();">
						&nbsp;&nbsp;
						<% } %>
						<%if(sOriginAction.equals("BlockEditDEC")){%>
						<input type="button" name="btnDetails" value="Details" onClick="openBEDisplayWindow();" onHelp="showHelp('html/Help_Updates.html#newDECForm_details',helpUrl); return false">
						&nbsp;&nbsp;
						<%}}%>
						<input type="button" name="btnAltName" value="Alt Names/Defs" 
						<% if (isView) { %>
								onClick="openAltNameViewWindow();"
						<% } else { %>
						     onClick="openDesignateWindow('Alternate Names');" 
						 <% } %>   
						onHelp="showHelp('html/Help_Updates.html#newDECForm_altNames',helpUrl); return false">
						&nbsp;&nbsp;
						<input type="button" name="btnRefDoc" value="Reference Documents" 
						<% if (isView) { %>
								onClick="openRefDocViewWindow();"
						<% } else { %>
						        onClick="openDesignateWindow('Reference Documents');" 
						 <% } %>        
						onHelp="showHelp('html/Help_Updates.html#newDECForm_refDocs',helpUrl); return false">
						&nbsp;&nbsp;
						
						<%	if((displayErrorMessage != null)&&(displayErrorMessage).equals("Yes")){	%>
							<input type="button" value="Back" onClick="Back();">
							&nbsp;&nbsp;
						<% }else if (isView) {	%>
							<input type="button" id="btnClose" value="Close" onClick="window.close();">
							&nbsp;&nbsp;
						<% }session.setAttribute("displayErrorMessage", "No"); %>
						<img name="Message" src="images/WaitMessage1.gif" width="250px" height="25px" alt="WaitMessage" style="visibility:hidden;">
					</td>
				</tr>
			</table>
			<table width="98%" border="0">
				<col width="4%">
				<col width="90%">
				<tr>
					<th colspan=2 height="40" align=left>
						<font size=4>
						<%if (isView){%>
							  View Data Element Concept
						<%}else{ %>
							<%if(sOriginAction.equals("BlockEditDEC")){%>
							    Block Edit Existing
							    <font color="#FF0000">
								     Data Element Concepts
							     </font>
							 
							<% } else {%>
							     Edit Existing
							      <font color="#FF0000">
								     Data Element Concept
							     </font>
							<% } %>         
						<% } %>	
						</font>
						
						<font size=3>
						    <%=vdNameDisplay%>
					    </font>
					</th>
				</tr>

				<%if(!sOriginAction.equals("BlockEditDEC") && (!isView)){%>
				<tr valign="bottom" height="25">
					<td align="left" colspan=2 height="11">
						<font color="#FF0000">
							&nbsp;*&nbsp;&nbsp;&nbsp;
						</font>
						Indicates Required Field
					</td>
				</tr>
				<%}%>

				<tr height="25" valign="bottom">
					<td align=right>
						<%if (!isView){%><font color="#C0C0C0"><%}%>
							<%=item++%>
							)
						<%if (!isView){%></font><%}%>
					</td>
					<td>
					   <%if (!isView){%><font color="#C0C0C0"><%}%>
							Context
						<%if (!isView){%></font><%}%>
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td valign="top">
					   <%if (!isView){%>	
						<select name="selContext" size="1" readonly onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_selContext'); return false">
							<option value="<%=sContID%>">
								<font color="#C0C0C0">
									<%=sContext%>
								</font>
							</option>
						</select><%}else{%>
						<input type="text" size="8" value="<%=sContext%>" readonly>
					  <%}%>
					</td>
				</tr>
				<tr height="25" valign="bottom">
					<td align=right>
						<%=item++%>
						)
					</td>
					<!-- label to allow changing only one.  Grey out the other one if changed.-->
					<td>
					<% if (!isView) { %>
						<font color="#FF0000">
							Select
						</font>
				     <% } %>		
						Data Element Concept Name Components
						<%if(sOriginAction.equals("BlockEditDEC")){%>
						(You may change either Object Class or Property. Click Clear button to restore to the original.)
						<%}%>
					</td>
				</tr>
				<tr valign="bottom">
					<td></td>
					<td>
						<table border="1" width="100%">
							<col width="50%">
							<col width="50%">
							<tr>
								<td>
									<table border="0" width="99%">
										<col width="20%">
										<col width="15%">
										<col width="14%">
										<col width="26%">
										<col width="10%">
										<col width="14%">
										<tr height="8">
											<td></td>
										</tr>
										
										<% if (session.getAttribute("changedOCDefsWarning") != null) {%>
										<tr height="8">
											<td colspan=6>
												<font color="<%=sOCFont%>">
												Warning: One or more Object Class concepts you've selected already exist in caDSR with a different definition.
												The existing standard caDSR definition will be used, and your chosen definition will be used to create an alternate definition for this element.
												</font>
											</td>
										</tr>
										<%} %>
										<tr>
											<td colspan="1" align="left">
												<font color="<%=sOCFont%>">
													Object Class
													<br>
													Long Name
												</font>
											</td>
											<td colspan="5" align="left">
												<input type="text" name="txtObjClass" value="<%=sObjClass%>" style="width: 95%" valign="top" readonly="readonly">
											</td>
										</tr>
										<tr height="8">
											<td></td>
										</tr>
										<tr valign="bottom">
											<td align="left" valign="top">
												<font color="<%=sOCFont%>">
													Qualifier
													<br>
													Concepts
												</font>
											</td>
											<% if (!isView){ %>
											<td align="center" valign="middle">
											  <%if (sOCFont.equals("#000000")) {%>
												<font color="#FF0000">
													<a href="javascript:SearchBuildingBlocks('ObjectQualifier', 'false')">
														Search
													</a>
												</font>
												<%}%>
											</td>
											
											<td align="center" valign="middle">
												<%if (sOCFont.equals("#000000")) {%>
												<font color="#FF0000">
													<a href="javascript:RemoveBuildingBlocks('ObjectQualifier')">
														Remove
													</a>
												</font>
												<%}%>
											</td>
										    <% }else{%>	<td></td><td></td><%}%>
											<td align="left" valign="top">
												<font color="<%=sOCFont%>">
													Primary
													<br>
													Concept
												</font>
											</td>
										   <% if (!isView){ %>	
											<td align="center" valign="middle">
												<%if (sOCFont.equals("#000000")) {%>
												<font color="#FF0000">
													<a href="javascript:SearchBuildingBlocks('ObjectClass', 'false')">
														Search
													</a>
												</font>
												<%}%>
											</td>
											<td align="center" valign="middle">
												<%if (sOCFont.equals("#000000")) {%>
												<font color="#FF0000">
													<a href="javascript:RemoveBuildingBlocks('ObjectClass')">
														Remove
													</a>
												</font>
												<%}%>
											</td>
										   <% } %>	
										</tr>
										<tr align="left">
											<td colspan="3" valign="top">
											 
											  
												<select name="selObjectQualifier" size="2" style="width: 98%" valign="top" onClick="ShowEVSInfo('ObjectQualifier')" onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_nameBlocks'); return false">
													<%if (vOCQualifierNames.size()<1) {%>
													<option value=""></option>
													<% } else { %>
													  <%for (int i = 0; vOCQualifierNames.size()>i; i++){
                                                          String   sQualName = (String)vOCQualifierNames.elementAt(i); %>
													    <option value="<%=sQualName%>" <%if(i==0){%> selected <%}%>>
														    <%=sQualName%>
													    </option>
													  <%}%>
													<%}%>
												</select>
											</td>
											<td colspan="3" valign="top">
											  	
												<select name="selObjectClass" style="width: 98%" valign="top" size="1" multiple onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_nameBlocks'); return false">
													<option value="<%=sObjClassPrimary%>">
														<%=sObjClassPrimary%>
													</option>
												</select>
											</td>
										</tr>
										<tr>
											<td colspan="3">
												&nbsp;&nbsp;
												<label id="ObjQual" for="selObjectQualifier" title=""></label>
											</td>
											<td colspan="3">
												&nbsp;&nbsp;
												<label id="ObjClass" for="selObjectClass" title=""></label>
											</td>
										</tr>
										<tr>
											<td colspan="3">
												&nbsp;&nbsp;
												<a href="javascript:disabled();">
													<label id="ObjQualID" for="selObjectQualifier" title="" <%if (!isView){%>onclick="javascript:SearchBuildingBlocks('ObjectQualifier', 'true')"<%}else{%>onclick="javascript:openEVSConceptsWindow('ObjectQualifier');"<% }%>/>
												</a>
											</td>
											<td colspan="3">
												&nbsp;&nbsp;
												<%if (!isView){%><a href="javascript:disabled();"><%}else{ if(objectClassUrl != null){%><a href="javascript:disabled();"><%}}%>
													<label id="ObjClassID" for="selObjectClass" title="" <%if (!isView){%>onclick="javascript:SearchBuildingBlocks('ObjectClass', 'true')"<%}else{ if(objectClassUrl != null){%>onclick="window.open('<%=objectClassUrl%>','','')"<%}}%>/>
												<%if (!isView){%></a><%}else{ if(objectClassUrl != null){%></a><%}}%>
											</td>
										</tr>
										<tr height="6">
											<td></td>
										</tr>
									</table>
								</td>
								<td>
									<table border="0" width="100%">
										<col width="20%">
										<col width="15%">
										<col width="14%">
										<col width="26%">
										<col width="10%">
										<col width="14%">
										<tr height="8">
											<td></td>
										</tr>
										<% if (session.getAttribute("changedPropDefsWarning") != null) {%>
										<tr height="8">
											<td colspan=6>
												<font color="<%=sPropFont%>">
												Warning: One or more Property concepts you've selected already exist in caDSR with a different definition.
												The existing standard caDSR definition will be used, and your chosen definition will be used to create an alternate definition for this element.
												</font>
											</td>
										</tr>
										<%} %>
										<tr>
											<td colspan="1">
												<font color="<%=sPropFont%>">
													Property
													<br>
													Long Name
												</font>
											</td>
											<td colspan="5" align="left">
												<input type="text" name="txtPropClass" value="<%=sPropClass%>" style="width: 95%" valign="top" readonly="readonly">
											</td>
										</tr>
										<tr height="6">
											<td></td>
										</tr>
										<tr valign="bottom">
											<td align="left" valign="top">
												<font color="<%=sPropFont%>">
													Qualifier
													<br>
													Concepts
												</font>
											</td>
										   <% if (!isView){ %>	
											<td align="center" valign="middle">
												<%if (sPropFont.equals("#000000")) {%>
												<font color="#FF0000">
													<a href="javascript:SearchBuildingBlocks('PropertyQualifier', 'false')">
														Search
													</a>
												</font>
												<%}%>
											</td>
											<td align="center" valign="middle">
												<%if (sPropFont.equals("#000000")) {%>
												<font color="#FF0000">
													<a href="javascript:RemoveBuildingBlocks('PropertyQualifier')">
														Remove
													</a>
												</font>
												<%}%>
											</td>
											<% }else{%>	<td></td><td></td><%}%>
											<td align="left" valign="top">
												<font color="<%=sPropFont%>">
													Primary
													<br>
													Concept
												</font>
											</td>
										   <% if (!isView){ %>	
											<td align="center" valign="middle">
												<%if (sPropFont.equals("#000000")) {%>
												<font color="#FF0000">
													<a href="javascript:SearchBuildingBlocks('PropertyClass', 'false')">
														Search
													</a>
												</font>
												<%}%>
											</td>
											<td align="center" valign="middle">
												<%if (sPropFont.equals("#000000")) {%>
												<font color="#FF0000">
													<a href="javascript:RemoveBuildingBlocks('Property')">
														Remove
													</a>
												</font>
												<%}%>
											</td>
										   <%}%>	
										</tr>

										<tr align="left">
											<td colspan="3" valign="top">
												
												<select name="selPropertyQualifier" size="2" style="width: 98%" valign="top" onClick="ShowEVSInfo('PropertyQualifier')" onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_nameBlocks'); return false">
													<%if (vPropQualifierNames.size()<1) {%>
													<option value=""></option>
													<% } else { %>
													  <%											     
													     for (int i = 0; vPropQualifierNames.size()>i; i++){ 
                                                          String sQualName = (String)vPropQualifierNames.elementAt(i);%>
													      <option value="<%=sQualName%>" <% if(i==0){%> selected <%}%>>
														     <%=sQualName%>
													      </option>
													  <%}%>
													<%}%>
												</select>
											</td>
											<td colspan="3" valign="top">
											  
												<select name="selPropertyClass" style="width: 98%" valign="top" size="1" multiple onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_nameBlocks'); return false">
													<option value="<%=sPropClassPrimary%>">
														<%=sPropClassPrimary%>
													</option>
												</select>
											</td>
										</tr>
										<tr>
											<td colspan="3">
												&nbsp;&nbsp;
												<label id="PropQual" for="selPropertyQualifier" title=""></label>
											</td>
											<td colspan="3">
												&nbsp;&nbsp;
												<label id="PropClass" for="selPropertyClass" title=""></label>
											</td>
										</tr>
										<tr>
											<td colspan="3">
												&nbsp;&nbsp;
												<a href="javascript:disabled();">
													<label id="PropQualID" for="selPropertyQualifier" title="" <%if (!isView){%>onclick="javascript:SearchBuildingBlocks('PropertyQualifier', 'true')"<%}else{%>onclick="javascript:openEVSConceptsWindow('PropertyQualifier');"<% }%>/>
												</a>
											</td>
											<td colspan="3">
												&nbsp;&nbsp;
												<%if (!isView){%><a href="javascript:disabled();"><%}else{ if(propClassUrl != null){%><a href="javascript:disabled();"><%}}%>
													<label id="PropClassID" for="selPropertyClass" title="" <%if (!isView){%>onclick="javascript:SearchBuildingBlocks('PropertyClass', 'true')"<%}else{ if(propClassUrl != null){%>onclick="window.open('<%=propClassUrl%>','','')"><%}}%>/>
												<%if (!isView){%></a><%}else{ if(propClassUrl != null){%></a><%}}%>
											</td>
										</tr>
										<tr height="6">
											<td></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="25" valign="bottom">
					<%if(sOriginAction.equals("BlockEditDEC")){%>
					<td align=right>
						<font color="#C0C0C0">
							<%=item++%>
							)
						</font>
					</td>
					<td>
						<font color="#C0C0C0">
							Verify Data Element Concept Long Name (* ISO Preferred Name)
						</font>
					</td>
					<% } else {%>
					<td align=right>
					   <%if (!isView){%>
						<font color="#FF0000">
							*&nbsp;&nbsp;
						</font><%}%>
						<%=item++%>
						)
					</td>
					<td>
					  <% if (!isView) { %>
						<font color="#FF0000">
							Verify
						</font>
					  <%}%>	
						Data Element Concept Long Name (* ISO Preferred Name)
					</td>
					<% } %>
				</tr>

				<tr valign="top">
					<td>
						&nbsp;
					</td>
					<td height="24" valign="top">
						<input name="txtLongName" type="text" size="80" maxlength=255 value="<%=sLongName%>" onKeyUp="changeCountLN();" <%if(sOriginAction.equals("BlockEditDEC") || isView ){%> readonly <%}%> onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_txtLongName'); return false">
						&nbsp;&nbsp;&nbsp;
						<input name="txtLongNameCount" type="text" size="1" readonly onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_txtLongName'); return false">
						<%if(sOriginAction.equals("BlockEditDEC")){%>
						<font color="#C0C0C0">
							Character Count &nbsp;&nbsp;(Database Max = 255)
						</font>
						<% } else {%>
						<font color="#000000">
							Character Count &nbsp;&nbsp;(Database Max = 255)
						</font>
						<% } %>
					</td>
				</tr>
				<tr height="25" valign="bottom">
					<td align=right>
						<%if(!sOriginAction.equals("BlockEditDEC") && (!isView)){%>
						<font color="#FF0000">
							*&nbsp;&nbsp;
						</font>
						<%}%>
						<%=item++%>
						)
					</td>
					<td>
					  <% if (!isView) { %>	
						<font color="#FF0000">
							Update
						</font>
					  <%}%>	
						<font color="#000000">
							Data Element Concept Short Name
						</font>
					</td>
				</tr>
				<% if (!isView) { %>	
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
						<!--Existing Name <%/*if(sOriginAction.equals("BlockEditDEC")){*/%>(Not Editable)<% /*} else { */%>(Editable)<% /*} */%>  -->
					</td>
				</tr><%}%>	
				<tr>
					<td>
						&nbsp;
					</td>
					<td valign="top">
						<input name="txtPreferredName" type="text" size="80" maxlength=30 value="<%=sName%>" onKeyUp="changeCountPN();" <%if(sOriginAction.equals("BlockEditDEC") || sPrefType.equals("") || sPrefType.equals("SYS") || sPrefType.equals("ABBR")){%> readonly
							<%}%> onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_txtPreferredName'); return false">
						&nbsp;&nbsp;&nbsp;
						<input name="txtPrefNameCount" type="text" size="1" value="<%=sNameCount%>" readonly onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_txtPreferredName'); return false">
						<% if(sOriginAction.equals("BlockEditDEC")){%>
						<font color="#C0C0C0">
							Character Count &nbsp;&nbsp;(Database Max = 30)
						</font>
						<% } else {%>
						<font color="#000000">
							Character Count &nbsp;&nbsp;(Database Max = 30)
						</font>
						<% } %>
					</td>
				</tr>

				<tr height="25" valign="bottom">
					<td align=right>
						<%if (!isView){%><font color="#C0C0C0"><%}%>
							<%=item++%>
							)
						<%if (!isView){%></font><%}%>
					</td>
					<td>
						<%if (!isView){%><font color="#C0C0C0"><%}%>
							Public ID
						<%if (!isView){%></font><%}%>
					</td>
				</tr>
				<tr>
					<td align=right>
						&nbsp;
					</td>
					<td>
						<font color="#C0C0C0">
							<input type="text" name="CDE_IDTxt" value="<%=sPublicDECID%>" size="20" readonly onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_EditDEC'); return false">
						</font>
					</td>
				</tr>

				<tr>
					<td height="8" valign="top">
				</tr>
				<tr height="25" valign="top">
					<%if(sOriginAction.equals("BlockEditDEC")){%>
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
					<% } else { %>
					<td align=right>
					    <%if (!isView){%>	
						<font color="#FF0000">
							*&nbsp;&nbsp;
						</font><%}%>
						<%=item++%>
						)
					</td>
					<td>
					  <% if (!isView) { %>	
						<font color="#FF0000">
							Create/Edit
						</font>
					  <% } %>	
						Definition
					</td>
					<% }%>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td valign="top" align="left">
						<%if(sOriginAction.equals("BlockEditDEC") || isView){%>
						<textarea name="CreateDefinition" style="width:80%" rows=6 readonly onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_CreateDefinition'); return false"><%=sDefinition%></textarea>
						<% } else { %>
						<textarea name="CreateDefinition" style="width:80%" rows=6 onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_CreateDefinition'); return false"><%=sDefinition%></textarea>
						<% }%>
					</td>
				</tr>
				<tr height="25" valign="bottom">
					<td align=right>
						<%if(!sOriginAction.equals("BlockEditDEC") && (!isView)){%>
						<font color="#FF0000">
							*&nbsp;&nbsp;
						</font>
						<%}%>
						<%=item++%>
						)
					</td>
					<td>
					   <% if (!isView) { %>	
						<font color="#FF0000">
							Select
						</font>
					   <%}%>	
						Conceptual Domain
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td>
					   <% if (!isView) { %>		
						<select name="selConceptualDomain" size="1" style="width:430" multiple onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_selConceptualDomain'); return false">
							<option value=<%=sConDomID%>>
								<%=sConDom%>
							</option>
						</select><%}else{%>
						  <input type="text" size="69" value="<%=sConDom%>"readonly>
						<%}%>
						&nbsp;&nbsp;
					   <% if (!isView){ %>	
						<font color="#FF0000">
							<a href="javascript:SearchCDValue()">
								Search
							</a>
						</font>
				      <% } %>		
					</td>
				</tr>
				
				<tr height="25" valign="bottom">
					<td align=right>
						<%if(!sOriginAction.equals("BlockEditDEC") && (!isView)){%>
						<font color="#FF0000">
							*&nbsp;&nbsp;
						</font>
						<%}%>
						<%=item++%>
						)
					</td>
					<td>
					   <% if (!isView) { %>	 
						<font color="#FF0000">
							Select
						</font>
					   <% } %>	
						Workflow Status
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td valign="top">
					  <%if (!isView) {	%>	
						<select name="selStatus" size="1" onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_selStatus'); return false">
							<option value="" selected="selected"></option>
							<% for (int i = 0; vStatus.size()>i; i++){
                                    String sStatusName = (String)vStatus.elementAt(i);
                                    //add only draft new and retired phased out if creating new
                                    if ((sMenuAction != null) && (sMenuAction.equals("Questions"))){
                                        if (sStatusName.equals("DRAFT NEW") || sStatusName.equals("RETIRED PHASED OUT") && !sOriginAction.equals("BlockEditDEC")){
%>                   						<option value="<%=sStatusName%>" <%if(sStatusName.equals(sStatus)){%> selected <%}%>>
								                <%=sStatusName%>
							                </option>
							       <%   }
                                    }else{%>
							         <option value="<%=sStatusName%>" <%if(sStatusName.equals(sStatus)){%> selected <%}%>>
								        <%=sStatusName%>
							        </option>
						          <%} 
						       }%>
						</select><%}else{%><input type="text" size="22" value="<%=sStatus%>" readonly> <%}%>
					</td>
				</tr>
				<tr height="25" valign="bottom">
					<%if(sOriginAction.equals("BlockEditDEC")){%>
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
					<% } else {%>
					<td align=right>
						<%if (!isView){%><font color="#C0C0C0"><%}%>
							<%=item++%>
							)
						<%if (!isView){%></font><%}%>
					</td>
					<td>
						<%if (!isView){%><font color="#C0C0C0"><%}%>
							Version
						<%if (!isView){%></font><%}%>
					</td>
					<% } %>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<%if(sOriginAction.equals("BlockEditDEC")){ %>
					<!--Version check is checked only if the sVersion is either Whole or Point   -->
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
										onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_BlockVersion'); return false">
								</td>
								<!--Point check is checked only if the sVersion is Point and disabled otherwise  -->
								<td>
									<input type="checkbox" name="PointCheck" onClick="javascript:EnableChecks(checked,this);" value="ON" <%if(sVersion.equals("Point")){%> checked <%} else {%> disabled <%}%>
										onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_BlockVersion'); return false">
									&nbsp;Point Increase
								</td>
								<!--Whole check is checked only if the sVersion is Whole and disabled otherwise  -->
								<td>
									<input type="checkbox" name="WholeCheck" onClick="javascript:EnableChecks(checked,this)" value="ON" <%if(sVersion.equals("Whole")){%> checked <%} else {%> disabled <%}%>
										onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_BlockVersion'); return false">
									&nbsp;Whole Increase
								</td>
							</tr>
						</table>
					</td>
					<% } else { %>
					<td valign="top">
						<font color="#C0C0C0">
							<input type="text" name="Version" value="<%=sVersion%>" size=5 readonly onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_Version'); return false">
						</font>
						&nbsp;&nbsp;&nbsp;
					   <% if (!isView){ %>
						<a href="<%=ToolURL.getCurationToolBusinessRulesURL(pageContext)%>" target="_blank">
							Business Rules
						</a>
					   <%}%>	
					</td>
					<% } %>
				</tr>
				<%-- ===========GF32398 Add Registration Status Field in UI =====START--%>
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
						Registration Status
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td height="25" valign="top">
						<%	if (!isView) {	%>
						<select name="selRegStatus" size="1" style="Width: 50%"
							onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selRegStatus',helpUrl); return false">
						
							<option value="" selected></option>
							<%	if (vRegStatus != null) {
										for (int i = 0; vRegStatus.size() > i; i++) {
											String sReg = (String) vRegStatus.elementAt(i);
											boolean isOK = true;
											if (isOK) {	%>
											<option value="<%=sReg%>" <%if(sReg.equals(sRegStatus)){%>selected <%}%>><%=sReg%></option>
										<%	}	}	} %>
						
						</select><%}else{%><input type="text" size="100" value="<%=sRegStatus%>" readonly><%}%>
					</td>
				</tr>
				
				<%--===========GF32398 Add Registration Status Field in UI =====END --%>
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
						Effective Begin Date
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td valign="top">
						<input type="text" name="BeginDate" value="<%=sBeginDate%>" size=12 maxlength=10 <% if (isView) { %>readonly<%} %> onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_BeginDate'); return false">
						<font color="#0099FF" size="3"></font>
						<% if (!isView) { %>
						<img src="../../cdecurate/images/calendarbutton.gif" onclick="calendar('BeginDate', event);"> <% } %>
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
					<td height="25" valign="top">
						<input type="text" name="EndDate" value="<%=sEndDate%>" size=12 maxlength=10 <% if (isView) { %>readonly<%} %> onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_EndDate'); return false">
						<font color="#0099FF" size="3"></font>
						<% if (!isView) { %>
						<img src="../../cdecurate/images/calendarbutton.gif" onclick="calendar('EndDate', event);"><% } %>
						&nbsp;&nbsp;MM/DD/YYYY
					</td>
				</tr>
				<!-- Classification Scheme and items -->
				<tr height="30" valign="bottom">
					<td align=right>
						<%=item++%>
						)
					</td>
					<td>
					   <% if (!isView) { %>	
						<font color="#FF0000">
							Select
						</font>
				      <%}%>
						Classification Schemes and Classification Scheme Items
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td align=left>
						<table border=0 width=90%>
							<col width="2%">
							<col width="32%">
							<col width="12%">
							<col width="32%">
							<col width="12%">
						   <%	if (!isView) {	%>	
							<tr>
								<td colspan=3 valign=top>
									<%if (sOriginAction.equals("BlockEditDEC")){%>
									<select name="selCS" size="1" style="width:95%" onChange="ChangeCS();" onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_BlockselCS'); return false">
										<option value="" selected></option>
										<% } else { %>
										<select name="selCS" size="1" style="width:95%" onChange="ChangeCS();" onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_selCS'); return false">
											<option value="" selected></option>
											<% } %>

											<%                  for (int i = 0; vCS.size()>i; i++)
                  {
                    String sCSName = (String)vCS.elementAt(i);
                    String sCS_ID = (String)vCS_ID.elementAt(i);
%>
											<option value="<%=sCS_ID%>">
												<%=sCSName%>
											</option>
											<%                  }     %>
										</select>
								</td>
								<td colspan=2 valign=top>
									<%if (sOriginAction.equals("BlockEditDEC")){%>
									<select name="selCSI" size="5" style="width:100%" onChange="selectCSI();" onClick="selectCSI();" onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_BlockselCS'); return false">
										<% } else { %>
										<select name="selCSI" size="5" style="width:100%" onChange="selectCSI();" onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_selCS'); return false">
											<% } %>
										</select>
								</td>
							</tr>
						  <% } %>	
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
									<%if (sOriginAction.equals("BlockEditDEC")){%>
									<select name="selectedCS" size="5" style="width:98%" multiple onchange="addSelectCSI(false, true, '');" onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_BlockselCS'); return false">
										<% } else { %>
										<select name="selectedCS" size="5" style="width:98%" multiple onchange="addSelectCSI(false, true, '');" onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_selCS'); return false">
											<% } %>
											<%                  //store selected cs list on load 
                if (vSelCSIDList != null) 
                {
           //       System.out.println("cs size " + vSelCSIDList.size());
                  for (int i = 0; vSelCSIDList.size()>i; i++)
                  {
                    String sCS_ID = (String)vSelCSIDList.elementAt(i);
                    String sCSName = "";
                    if (vSelCSList != null && vSelCSList.size() > i)
                       sCSName = (String)vSelCSList.elementAt(i);
          //          System.out.println("selected " + sCSName);
%>
											<option value="<%=sCS_ID%>">
												<%=sCSName%>
											</option>
											<%                  }
                }   %>
										</select>
								</td>
								<td colspan=2 valign=top>
									<%if (sOriginAction.equals("BlockEditDEC")){%>
									<select name="selectedCSI" size="5" style="width:100%" multiple onchange="addSelectedAC();" onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_BlockselCS'); return false">
										<% } else { %>
										<select name="selectedCSI" size="5" style="width:100%" multiple <% if (!isView) { %>onchange="addSelectedAC();" <% } %>onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_selCS'); return false">
											<% } %>
										</select>
								</td>
							</tr>
							<%if (sOriginAction.equals("BlockEditDEC")){%>
							<tr>
								<td height="12" valign="top">
							</tr>
							<tr>
								<td colspan=3>
									&nbsp;
								</td>
								<td colspan=2 valign=top>
									&nbsp;Data Element Concepts containing selected Classification Scheme Items
								</td>
							</tr>
							<tr>
								<td colspan=3 valign=top>
									&nbsp;
								</td>
								<td colspan=2 valign=top>
									<select name="selCSIACList" size="3" style="width:100%" onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_BlockselCS'); return false">
									</select>
								</td>
							</tr>
							<%}%>
						</table>
					</td>
				</tr>
				<!-- contact info -->
				<%if (!sOriginAction.equals("BlockEditDEC")){%>
				<tr>
					<td height="12" valign="top"></td>
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
									<input type="button" name="btnViewCt" value="Edit Item"  onClick="javascript:editContact('view');" disabled>
								</td>
						    	<td align="left">
									<input type="button" name="btnCreateCt" value="Create New" onClick="javascript:editContact('new');">
								</td>
								<td align="center">
									<input type="button" name="btnRmvCt" value="Remove Item" onClick="javascript:editContact('remove');" disabled>
								</td>
							</tr>
						   <% } %>	
							<tr>
								<td colspan=4 valign="top">
									<%if (!isView){%>	
									<select name="selContact" size="4" style="width:100%" onchange="javascript:enableContButtons();" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContact'); return false">
									<%}else{%><p class="inset">	
										<%}
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
      if (!isView){%>	
										<option value="<%=contName%>">
											<%=contName%>
										</option><%}else{%><%=contName%><br><%}
										}if (!isView){%></select><%}else{%><br></p><%}%>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<%}%>
				<!-- origin -->
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
						Data Element Concept Origin
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td>
						<%if (!isView){%>
						<select name="selSource" size="1" style="width:70%" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selSource',helpUrl); return false">
						<%		
							boolean isFound = false;
							%>
							<option value=""></option>
							<%
								for (int i = 0; vSource.size() > i; i++) {
									String sSor = (String) vSource.elementAt(i);
									if (sSor.equals(sSource))
										isFound = true;
							%>
							<option value="<%=sSor%>" <%if(sSor.equals(sSource)){%> selected <%}%>>
								<%=sSor%>
							</option>
							<%
								 }
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
						</select><%}else{%><input type="text" size="143" value="<%=sSource%>" readonly><%}%>
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
					<td height="35" valign="top">
						<textarea name="CreateChangeNote" cols="69" rows=2 <% if (isView) { %>readonly<%} %>  onHelp="showHelp('html/Help_CreateDEC.html#newDECForm_CreateComment',helpUrl); return false"><%=sChangeNote%></textarea>
					</td>

				</tr>
				<%	if (!isView) {	%>
				<tr height="25" valign="bottom">
					<td align=right>
						<%=item++%>
						)
					</td>
					<td>
						<font color="#FF0000">
							<A HREF="javascript:SubmitValidate('validate')">
								Validate
							</A>
						</font>
						the Data Element Concept(s)
					</td>
				</tr>
				<% } %>
			</table>

			<input type="hidden" name="pageAction" value="nothing">
			<input type="hidden" name="decIDSEQ" value="<%=sDECIDSEQ%>">
			<input type="hidden" name="regStatusIDSEQ" value="<%=sRegStatusIDSEQ%>"> <!-- GF32398 -->
			<input type="hidden" name="openToTree" value="">
			<input type="hidden" name="OCQualCCode" value="">
			<input type="hidden" name="OCQualCCodeDB" value="">
			<input type="hidden" name="OCCCode" value="<%=sOCCCode%>">
			<input type="hidden" name="OCCCodeDB" value="<%=sOCCCodeDB%>">
			<input type="hidden" name="PCQualCCode" value="">
			<input type="hidden" name="PCQualCCodeDB" value="">
			<input type="hidden" name="PCCCode" value="<%=sPCCCode%>">
			<input type="hidden" name="PCCCodeDB" value="<%=sPCCCodeDB%>">

			<input type="hidden" name="selObjectClassText" value="<%=sObjClass%>">
			<input type="hidden" name="selPropertyClassText" value="<%=sPropClass%>">
			<input type="hidden" name="selObjectClassLN" value="<%=sObjClass%>">
			<input type="hidden" name="selPropertyClassLN" value="<%=sPropClass%>">
			<input type="hidden" name="selObjectQualifierLN" value="<%=sObjQualLN%>">
			<input type="hidden" name="selPropertyQualifierLN" value="<%=sPropQualLN%>">
			<input type="hidden" name="selObjectQualifierPN" value="">
			<input type="hidden" name="selPropertyQualifierPN" value="">
			<input type="hidden" name="selObjectClassID" value="">
			<input type="hidden" name="selPropertyClassID" value="">

			<%if(sOriginAction.equals("BlockEditDEC")){%>
			<input type="hidden" name="selConceptualDomainText" value="">
			<input type="hidden" name="DECAction" value="BlockEdit">
			<% } else {%>
			<input type="hidden" name="selConceptualDomainText" value="<%=sConDom%>">
			<input type="hidden" name="DECAction" value="EditDEC">
			<% } %>
			<% if (sMenuAction != null){ %>
			<input type="hidden" name="MenuAction" value="<%=sMenuAction%>"><%}%>

			<input type="hidden" name="selObjRow" value="">
			<input type="hidden" name="selPropRow" value="">
			<input type="hidden" name="selObjQRow" value="">
			<input type="hidden" name="selPropQRow" value="">

			<input type="hidden" name="selCompBlockRow" value="">
			<input type="hidden" name="sCompBlocks" id="sCompBlocks" value="">
			<input type="hidden" name="nvpConcept" id="nvpConcept" value="">
			<!-- oc and prop change status -->
			<input type="hidden" name="nameTypeChange" value="<%=nameTypeChange%>">

			<input type="hidden" name="PropDefinition" value="">
			<input type="hidden" name="ObjDefinition" value="">
			<select name="selCSCSIHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selACCSIHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selCSNAMEHidden" size="1" style="visibility:hidden;" multiple></select>
			<!-- store the selected ACs in the hidden field to use it for cscsi 
This is refilled with ac id from ac-csi to use it for block edit-->
			<select name="selACHidden" size="1" style="visibility:hidden;width:100;" multiple>
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
				<option value="<%=sAC_ID%>">
					<%=sACName%>
				</option>
				<%  }
  }   %>
			</select>
			<select name="vOCQualifierCodes" size="1" style="visibility:hidden;width:100;" multiple>
				<%if (vOCQualifierCodes != null) 
  {
    for (int i = 0; vOCQualifierCodes.size()>i; i++)
    {
      String sOCQualifierCode = (String)vOCQualifierCodes.elementAt(i);
%>
				<option value="<%=sOCQualifierCode%>">
					<%=sOCQualifierCode%>
				</option>
				<%  }
  }   
%>
			</select>
			<select name="vOCQualifierDB" size="1" style="visibility:hidden;width:100;" multiple>
				<%if (vOCQualifierDB != null) 
  {
    for (int i = 0; vOCQualifierDB.size()>i; i++)
    {
      String sOCQualifierDB = (String)vOCQualifierDB.elementAt(i);
%>
				<option value="<%=sOCQualifierDB%>">
					<%=sOCQualifierDB%>
				</option>
				<%  }
  }   
%>
			</select>
			<select name="vPropQualifierCodes" size="1" style="visibility:hidden;width:100;" multiple>
				<%if (vOCQualifierCodes != null) 
  {
    for (int i = 0; vPropQualifierCodes.size()>i; i++)
    {
      String sPropQualifierCode = (String)vPropQualifierCodes.elementAt(i);
%>
				<option value="<%=sPropQualifierCode%>">
					<%=sPropQualifierCode%>
				</option>
				<%  }
  }   
%>
			</select>
			<select name="vPropQualifierDB" size="1" style="visibility:hidden;width:100;" multiple>
				<%if (vOCQualifierDB != null) 
  {
    for (int i = 0; vPropQualifierDB.size()>i; i++)
    {
      String sPropQualifierDB = (String)vPropQualifierDB.elementAt(i);
%>
				<option value="<%=sPropQualifierDB%>">
					<%=sPropQualifierDB%>
				</option>
				<%}
  }   
%>
			</select>
			<script language="javascript">
createObject("document.newDECForm");  //call function to initiate form objects
displayStatusMessage();
changeCountLN();
changeCountPN();
loadCSCSI();
ShowEVSInfo('ObjectQualifier');
ShowEVSInfo('PropertyQualifier');
</script>
		</form>
	</body>
</html>
