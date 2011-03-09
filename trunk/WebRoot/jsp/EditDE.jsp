<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/EditDE.jsp,v 1.25 2009-04-21 19:07:10 veerlah Exp $
    $Name: not supported by cvs2svn $
-->

<html>
	<head>
		<title>
			EditDataElement
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<%@ page import="java.util.*"%>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%>
		<%@ page session="true"%>
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<script language="JavaScript" src="js/date.js"></script>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/AddNewListOption.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/CreateDE.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/SelectCS_CSI.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%
			UtilService serUtil = new UtilService();

			//for view only page
			String bodyPage = (String) request.getAttribute("IncludeViewPage");
			boolean isView = false;
			if (bodyPage != null && !bodyPage.equals(""))
				isView = true;

			Vector vContext = null;
		    Vector vStatus = null;
		    Vector vRegStatus = null;
		    Vector vCS = null;
		    Vector vCS_ID = null;
		    Vector vSource = null;
		    boolean inForm = false;
			if(!isView){
			   //load the lists
			    vContext = (Vector) session.getAttribute("vWriteContextDE");
			    vStatus = (Vector) session.getAttribute("vStatusDE");
			    vRegStatus = (Vector) session.getAttribute("vRegStatus");
			    vCS = (Vector) session.getAttribute("vCS");
			    vCS_ID = (Vector) session.getAttribute("vCS_ID");
			    vSource = (Vector) session.getAttribute("vSource");
	        }
			Vector results = (Vector) session.getAttribute("results");
			String sMenuAction = (String) session.getAttribute(Session_Data.SESSION_MENU_ACTION);
			if (!isView) {
				if (sMenuAction.equals("nothing")) {
					sMenuAction = "editDE";
					session.setAttribute(Session_Data.SESSION_MENU_ACTION, "editDE");
				}
			}

			String sOriginAction = (String) session.getAttribute("originAction");
			if (sOriginAction == null)
				sOriginAction = "";
			String sDDEAction = (String) session.getAttribute("DDEAction");
            DE_Bean m_DE = new DE_Bean();
            String deID = ""; 
			if (isView){
	            deID = (String)request.getAttribute("viewDEId");
	            String viewDE = "viewDE" + deID;
	            m_DE = (DE_Bean) session.getAttribute(viewDE);
	        }else{
                m_DE = (DE_Bean)session.getAttribute("m_DE");
            }  
			if (m_DE == null)
				m_DE = new DE_Bean();
			// session.setAttribute("DEEditAction", "");
			String sDEIDSEQ = m_DE.getDE_DE_IDSEQ();
			if (sDEIDSEQ == null)
				sDEIDSEQ = "";
			inForm = m_DE.getDE_IN_FORM();

			String sContext = m_DE.getDE_CONTEXT_NAME();
			if (sOriginAction.equals("BlockEditDE"))
				sContext = "";
			if (sContext == null)
				sContext = "";
			String sContID = m_DE.getDE_CONTE_IDSEQ();
			if (sContID == null)
				sContID = "";

			String sLongName = m_DE.getDE_LONG_NAME();
			sLongName = serUtil.parsedStringDoubleQuoteJSP(sLongName); //call the function to handle doubleQuote
			if (sLongName == null || sOriginAction.equals("BlockEditDE"))
				sLongName = "";
			int sLongNameCount = sLongName.length();
			String sName = m_DE.getDE_PREFERRED_NAME();
			if (sName != null)
				sName = serUtil.parsedStringDoubleQuoteJSP(sName); //call the function to handle doubleQuote
			if (sName == null || sOriginAction.equals("BlockEditDE"))
				sName = "";
			int sNameCount = sName.length();
			String sPrefType = m_DE.getAC_PREF_NAME_TYPE();
			if (sPrefType == null)
				sPrefType = "";
			String lblUserType = "Existing Name (Editable)"; //make string for user defined label
			String sUserEnt = m_DE.getAC_USER_PREF_NAME();
			if (sOriginAction.equals("BlockEditDE"))
				lblUserType = "Existing Name (Not Editable)";
			else if (sUserEnt == null || sUserEnt.equals(""))
				lblUserType = "User Entered";

			String sDefinition = m_DE.getDE_PREFERRED_DEFINITION();
			if (sDefinition == null)
				sDefinition = "";
			if (sOriginAction.equals("BlockEditDE"))
				sDefinition = "";

			//get dec attributes
			DEC_Bean dec = m_DE.getDE_DEC_Bean();
			if (dec == null)
				dec = new DEC_Bean();
			String sDECID = dec.getDEC_DEC_IDSEQ(); //m_DE.getDE_DEC_IDSEQ();
			if ((sDECID == null) || (sDECID.equals("nothing")))
				sDECID = "";
			String sDEC = dec.getDEC_LONG_NAME(); //m_DE.getDE_DEC_NAME();
			if (sDEC == null)
				sDEC = "";
			sDEC = serUtil.parsedStringDoubleQuoteJSP(sDEC); //call the function to handle doubleQuote
			VD_Bean vd = m_DE.getDE_VD_Bean();
			if (vd == null)
				vd = new VD_Bean();
			String sVDID = vd.getVD_VD_IDSEQ(); // m_DE.getDE_VD_IDSEQ();
			if ((sVDID == null) || (sVDID.equals("nothing")))
				sVDID = "";
			String sVD = vd.getVD_LONG_NAME(); // m_DE.getDE_VD_NAME();
			sVD = serUtil.parsedStringDoubleQuoteJSP(sVD); //call the function to handle doubleQuote
			if (sVD == null)
				sVD = "";

			boolean decvdChanged = m_DE.getDEC_VD_CHANGED();
			//System.out.println("jsap " + decvdChanged);
			String sVersion = m_DE.getDE_VERSION();
			if (sVersion == null)
				sVersion = "1.0";

			String sStatus = m_DE.getDE_ASL_NAME();
			if (sStatus == null && sOriginAction.equals("BlockEditDE"))
				sStatus = "";
			else if (sStatus == null)
				sStatus = "DRAFT NEW";
			String sRegStatus = m_DE.getDE_REG_STATUS();
			if (sRegStatus == null)
				sRegStatus = "";
			String sRegStatusIDSEQ = m_DE.getDE_REG_STATUS_IDSEQ();
			if (sRegStatusIDSEQ == null)
				sRegStatusIDSEQ = "";

			String sCDEID = m_DE.getDE_MIN_CDE_ID();
			if (sCDEID == null)
				sCDEID = "";
			if (sOriginAction.equals("BlockEditDE"))
				sCDEID = "";
			String sBeginDate = m_DE.getDE_BEGIN_DATE();
			if (sBeginDate == null)
				sBeginDate = "";
			String sDocText = m_DE.getDOC_TEXT_PREFERRED_QUESTION();
			if (sDocText == null)
				sDocText = "";
			String sDocTextIDSEQ = m_DE.getDOC_TEXT_PREFERRED_QUESTION_IDSEQ();
			if (sDocTextIDSEQ == null)
				sDocTextIDSEQ = "";
			String sSourceIDSEQ = m_DE.getDE_SOURCE_IDSEQ();
			if (sSourceIDSEQ == null)
				sSourceIDSEQ = "";
			String sSource = m_DE.getDE_SOURCE();
			if (sSource == null)
				sSource = "";
			String sChangeNote = m_DE.getDE_CHANGE_NOTE();
			if (sChangeNote == null)
				sChangeNote = "";

			//get cs-csi attributes
			Vector vSelCSList = m_DE.getAC_CS_NAME();
			if (vSelCSList == null)
				vSelCSList = new Vector();
			Vector vSelCSIDList = m_DE.getAC_CS_ID();
			Vector vACCSIList = m_DE.getAC_AC_CSI_VECTOR();
			Vector vACId = (Vector) session.getAttribute("vACId");
			Vector vACName = (Vector) session.getAttribute("vACName");
			//initialize the beans
			CSI_Bean thisCSI = new CSI_Bean();
			AC_CSI_Bean thisACCSI = new AC_CSI_Bean();

			String sEndDate = m_DE.getDE_END_DATE();
			if (sEndDate == null)
				sEndDate = "";
			//get the contact hashtable for the de
			Hashtable hContacts = m_DE.getAC_CONTACTS();
			if (hContacts == null)
				hContacts = new Hashtable();
			if (!isView) {
			session.setAttribute("AllContacts", hContacts);

			//these are for DEC and VD searches.
			session.setAttribute(Session_Data.SESSION_MENU_ACTION,
					"searchForCreate");
			Vector vResult = new Vector();
			session.setAttribute("results", vResult);
			session.setAttribute("creRecsFound", "No ");
			session.setAttribute("creKeyword", "");

			//for altnames and ref docs
			session.setAttribute("dispACType", "DataElement");
			}
			// for DDE
			String sSelRepType = (String) session.getAttribute("sRepType");
			if (sSelRepType == null) sSelRepType = "";
			String sNVType = (String) session.getAttribute("NotValidDBType");
			if (sNVType == null)
				sNVType = "";
			String sSelConcatChar = (String) session.getAttribute("sConcatChar");
			if (sSelConcatChar == null)
				sSelConcatChar = "";
			String sSelRule = (String) session.getAttribute("sRule");
			if (sSelRule == null)
				sSelRule = "";
			String sSelMethod = (String) session.getAttribute("sMethod");
			if (sSelMethod == null)
				sSelMethod = "";
			Vector vRepType = new Vector();
			Vector vDEComp = new Vector();
			Vector vDECompID = new Vector();
			Vector vDECompOrder = new Vector();
			Vector vDECompRelID = new Vector();
			if ((sDDEAction != null) && (sDDEAction != "CreateNewDEFComp")) {
				vRepType = (Vector) session.getAttribute("vRepType");
				vDEComp = (Vector) session.getAttribute("vDEComp");
				if (vDEComp == null)
				  vDEComp = new Vector();
				vDECompID = (Vector) session.getAttribute("vDECompID");
				if (vDECompID == null)
				   vDECompID = new Vector();
				vDECompOrder = (Vector) session.getAttribute("vDECompOrder");
				if (vDECompOrder == null)
				   vDECompOrder = new Vector();
			    vDECompRelID = (Vector) session.getAttribute("vDECompRelID");
			    if (vDECompRelID == null)
			       vDECompRelID = new Vector(); 
			}
            String sDEID = "";
			String sDECompOrder = "";
			if ((vDECompOrder != null) && (vDECompOrder.size() > 0))
				sDECompOrder = (String) vDECompOrder.elementAt(0);

			int item = 1;
			String vdNameDisplay = "";
            if (!sLongName.equals(""))
      	       vdNameDisplay = " - " + sLongName + "  [" + sCDEID + "v" + sVersion + "]";
		%>

		<Script Language="JavaScript">
 var evsWindow2 = null;
  var helpUrl = "<%=ToolURL.getCurationToolHelpURL(pageContext)%>";
  
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
     if ((vCSIList != null)){
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
    <%  }  } %>
      loadSelCSCSI();  //load the existing relationship
      loadWriteContextArray();  //load the writable contexts 
  }

   function loadSelCSCSI()
   {
<%    
      if ((vACCSIList != null))
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
    <% if ((vContext != null) && (!isView))
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
    window.status = "Edit the Existing Data Element, choose context first"
  }

</Script>

<script>

 var newwindow;
function openUsedWindowVM(idseq, type)
{
var newUrl = "../../cdecurate/NCICurationServlet?reqType=showUsedBy";
newUrl = newUrl + "&idseq=" +idseq+"&type="+type;

	newwindow=window.open(newUrl,"UsedByForms","height=400,width=500");
	if (window.focus) {newwindow.focus()}


}
</script>
	</head>

	<body onLoad = "hideCloseButton(<%=isView%>);" onUnload="closeDep();">
		<form name="FormNewDEC" method="post" action="../../cdecurate/NCICurationServlet?reqType=createNewDEC"></form>
		<form name="FormNewVD" method="post" action="../../cdecurate/NCICurationServlet?reqType=createNewVD"></form>
		<form name="SearchActionForm" method="post" action="">
			<input type="hidden" name="searchComp" value="">
			<input type="hidden" name="searchEVS" value="DataElement">
			<input type="hidden" name="isValidSearch" value="true">
			<input type="hidden" name="acID" value="<%=sDEIDSEQ%>">
			<input type="hidden" name="itemType" value="">
		</form>
		<form name="newCDEForm" method="POST" action="../../cdecurate/NCICurationServlet?reqType=editDE">
		  <%String displayErrorMessage = (String)session.getAttribute("displayErrorMessage");
		    if ((displayErrorMessage != null)&&(displayErrorMessage).equals("Yes")){ %>
		  	 <b><font  size="3">Not Authorized for Edits in this Context.</font></b></br></br>
	       <%}%>
			<table width="100%" border=0>
				<!--DWLayoutTable-->
				<tr>
					<td align="left" valign="top" colspan=2>
						<%	if (!isView) { %>
						<input type="button" name="btnValidate" value="Validate" onClick="SubmitValidate('validate')" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_Validation',helpUrl); return false">
						&nbsp;&nbsp;
						<input type="button" name="btnClear" value="Clear" onClick="ClearBoxes();">
						&nbsp;&nbsp;
						<input type="button" name="btnBack" value="Back" onClick="Back();">
						&nbsp;&nbsp;
						<%
							if (sOriginAction.equals("BlockEditDE")) {
						%>
						<input type="button" name="btnDetails" value="Details" onClick="openBEDisplayWindow();" onHelp="showHelp('html/Help_Updates.html#newCDEForm_details',helpUrl); return false">
						&nbsp;&nbsp;
						<%
							} }
						%>
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
			<table width="98%" border=0>
				<col width="4%">
				<col width="95%">
				<tr valign="middle">
					<th colspan=2 height="40">
						<div align="left">
							<label>
								<font size=4>
							<%if (isView){%>
							   View Data Element
							<%}else{ %>
								<%
									if (sOriginAction.equals("BlockEditDE")) {
								%>
									Block Edit Existing
									<font color="#FF0000">
										Data Elements
									</font>
								<%
									} else {
								%>
									Edit Existing
									<font color="#FF0000">
										Data Element
									</font>
								<%
									}
								%>
									
							 <%}%>		
								</font>
								
							   <font size=3>
						         <%=vdNameDisplay%>
					           </font>	
						           <%if (inForm){%>
									<br>
									<font size=4 color="#FF0000">Note:</font>
									<font size=4> Data Element is used in a form. <a href="javascript:openUsedWindowVM('<%=sDEIDSEQ%>','DE');">View Usage</a></font>
									<%}%>	
							</label>
						</div>
					</th>
				</tr>

				<%
					if (!sOriginAction.equals("BlockEditDE") && !isView) {
				%>
				<tr valign="bottom" height="25">
					<td align="left" colspan=2 height="11">
						<font color="#FF0000">
							&nbsp;&nbsp;&nbsp;*&nbsp;&nbsp;&nbsp;
						</font>
						Indicates Required Field
					</td>
				</tr>
				<%
					}
				%>

		<%	if (sOriginAction.equals("BlockEditDE")) {	%>
				<tr height="25" valign="bottom">
					<td align=right>
						<font color="#C0C0C0">
							<%=item++%>
							)
						</font>
					</td>
					<td colspan=4>
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
						<select name="selContext" size="1" readonly onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContext',helpUrl); return false">
							<option value="<%=sContID%>">
								<font color="#C0C0C0">
									<%=sContext%>
								</font>
							</option>
						</select>
					</td>
				</tr>
	  <% } else { %>
				<tr height="25" valign="bottom">
					<td align=right>
					   <%if (!isView){%>
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
					   <%if (!isView){%>
						<select name="selContext" size="1" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContext',helpUrl); return false">
							<option value="<%=sContID%>">
									<%=sContext%>
							</option>
						</select><%}else{%>
						<input type="text" size="8" value="<%=sContext%>" readonly>
				      <%}%>
					</td>
				</tr>
	 <%	}	%>
				<tr valign="bottom" height="25">
					<!-- add the hyperlink do not allow update if alredy vd selected in the block edit-->
					<%
						if (sOriginAction.equals("BlockEditDE") && sVDID != null
								&& !sVDID.equals("")) {
					%>
					<td align=right>
						<font color="#C0C0C0">
							<%=item++%>
							)
						</font>
					</td>
					<td>
						<font color="#C0C0C0">
							Select Data Element Concept Long Name
						</font>
					</td>
					<%
						} else {
					%>
					<td align=right>
						<font color="#FF0000">
							<%
								if (!sOriginAction.equals("BlockEditDE") && (!isView)) {
							%>
							*
							<%
								}
							%>
							&nbsp;&nbsp;
						</font>
						<%=item++%>
						)
					</td>
					<td>
					<% if (!isView) { %>
						<font color="#FF0000">
							Select
						</font>
					<% } %>
						Data Element Concept Long Name
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
					   <%if (!isView){%>	
						<select name="selDEC" size="1" multiple style="width:430" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selDEC',helpUrl); return false">
							<option value="<%=sDECID%>">
								<%=sDEC%>
							</option>
						</select><%}else{%><input type="hidden" name="viewDECId" value="<%=sDECID%>">
						   <input type="text" size="68" value="<%=sDEC%>" readonly>
						<%}%>
						<!-- add the hyperlink do not allow search if alredy vd selected in the block edit-->
						<!--  no lins for view only page -->
						<%
							if (!isView) {
							if (!(sOriginAction.equals("BlockEditDE") && sVDID != null && !sVDID
										.equals(""))) {
						%>
						&nbsp;&nbsp;
						<a href="javascript:SearchDECValue();">
							Search
						</a>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<%
							}
						%>
						<%
							if (!sOriginAction.equals("BlockEditDE")) {
						%>
						<a href="javascript:EditDECValue();">
							Edit DEC
						</a>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="javascript:CreateNewDECValue();">
							Create New DEC
						</a>
						<%	}}else{ %>
						&nbsp;&nbsp;
						<a href="javascript:viewDEC();">
							View DEC
						</a>
						<%}%>
					</td>
				</tr>
				<tr valign="bottom" height="25">
					<!-- add the hyperlink do not allow update if alredy dec selected in the block edit-->
					<%
						if (sOriginAction.equals("BlockEditDE") && sDECID != null
								&& !sDECID.equals("")) {
					%>
					<td align=right>
						<font color="#C0C0C0">
							<%=item++%>
							)
						</font>
					</td>
					<td>
						<font color="#C0C0C0">
							Select Value Domain Long Name
						</font>
					</td>
					<%
						} else {
					%>
					<td align=right>
						<font color="#FF0000">
							<%
								if (!sOriginAction.equals("BlockEditDE") && (!isView)) {
							%>
							*
							<%
								}
							%>
							&nbsp;&nbsp;
						</font>
						<%=item++%>
						)
					</td>
					<td>
					<% if (!isView) { %>
						<font color="#FF0000">
							Select
						</font>
						<% } %>
						Value Domain Long Name
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
					   <%if (!isView){%>	
						<select name="selVD" size="1" multiple style="width:430" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selVD',helpUrl); return false">
							<option value="<%=sVDID%>">
								<%=sVD%>
							</option>
						</select><%}else{%> <input type="hidden" name="viewVDId" value="<%=sVDID%>">
											<input type="text" size="68" value="<%=sVD%>" readonly><%}%>
						<!-- add the hyperlink do not allow search if alredy dec selected in the block edit-->
						<!--  no lins for view only page -->
						<%
							if (!isView) {
							if (!(sOriginAction.equals("BlockEditDE") && sDECID != null && !sDECID
										.equals(""))) {
						%>
						&nbsp;&nbsp;
						<a href="javascript:SearchVDValue()">
							Search
						</a>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<%
							}
						%>
						<%
							if (!sOriginAction.equals("BlockEditDE")) {
						%>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="javascript:EditVDValue()">
							Edit VD
						</a>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="javascript:CreateNewVDValue()">
							Create New VD
						</a>
						<%	}}else{ %>
						&nbsp;&nbsp;
						<a href="javascript:viewVD();">
							View VD
						</a>
						<%}%>
					</td>
				</tr>
				<tr valign="bottom" height="25">
					<%
						if (sOriginAction.equals("BlockEditDE")) {
					%>
					<td align=right>
						<font color="#C0C0C0">
							<%=item++%>
							)
						</font>
					</td>
					<td>
						<font color="#C0C0C0">
							Verify Data Element Long Name (* ISO Preferred Name)
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
					<% if (!isView) { %>
						<font color="#FF0000">
							Verify
						</font>
						<% } %>
						Data Element Long Name (* ISO Preferred Name)
					</td>
					<%
						}
					%>
				</tr>
				<tr>
					<td>
					</td>
					<td height="24" valign="top">
						<input name="txtLongName" type="text" size="80" maxlength=255 value="<%=sLongName%>" onKeyUp="changeCountLN();" <%if(sOriginAction.equals("BlockEditDE") || isView){%> readonly <%}%> onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_txtLongName',helpUrl); return false">
						&nbsp;&nbsp;&nbsp;
						<input name="txtLongNameCount" type="text" size="1" value="<%=sLongNameCount%>" readonly onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_txtLongName',helpUrl); return false">
						<%
							if (sOriginAction.equals("BlockEditDE")) {
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
						if (sOriginAction.equals("BlockEditDE")) {
					%>
					<td align=right>
						<font color="#C0C0C0">
							<%=item++%>
							)
						</font>
					</td>
					<td>
						<font color="#C0C0C0">
							Update Data Element Short Name
						</font>
					</td>
					<%
						} else {
					%>
					<td align=right>
						<%if (!isView){%><font color="#FF0000">
							*&nbsp;&nbsp;
						</font><%}%>
						<%=item++%>
						)
					</td>
					<td>
					<% if (!isView) { %>
						<font color="#FF0000">
							Update
						</font>
						<% } %>
						<font color="#000000">
							Data Element Short Name
						</font>
					</td>
					<%
						}
					%>
				</tr>
				<%
					if (!isView) {
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
						<input name="txtPreferredName" type="text" size="80" maxlength=30 value="<%=sName%>" onKeyUp="changeCountPN();" 
							<% if (sOriginAction.equals("BlockEditDE") || sPrefType.equals("") || sPrefType.equals("SYS") || sPrefType.equals("ABBR") || isView){ %> readonly
							<%}%> onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_txtPreferredName',helpUrl); return false">
						&nbsp;&nbsp;&nbsp;
						<input name="txtPrefNameCount" type="text" size="1" value="<%=sNameCount%>" readonly onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_txtPreferredName',helpUrl); return false">
						<%
							if (sOriginAction.equals("BlockEditDE")) {
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
						if (sOriginAction.equals("BlockEditDE")) {
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
					<% } %>
				</tr>
				<tr>
					<td align=right>
						&nbsp;
					</td>
					<td colspan=4>
							<input type="text" name="CDE_IDTxt" value="<%=sCDEID%>" size="20" readonly onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_CDE_IDTxt',helpUrl); return false">
					</td>
				</tr>

				<tr>
					<td height="8" valign="top">
				</tr>
				<tr height="25" valign="top">
					<%
						if (sOriginAction.equals("BlockEditDE")) {
					%>
					<td align=right>
						<font color="#C0C0C0">
							<%=item++%>
							)
						</font>
					</td>
					<td>
						<font color="#C0C0C0">
							Create/Edit Definition
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
					<% if (!isView) { %>
						<font color="#FF0000">
							Create/Edit
						</font>
						Definition
						<br>
						(Changes to naming components will replace existing definition text.)
						<% } else { %>
							Definition
						<% } %>
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
							if (sOriginAction.equals("BlockEditDE") || isView) {
						%>
						<textarea name="CreateDefinition" style="width:80%" rows=6 readonly onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_CreateDefinition',helpUrl); return false"><%=sDefinition%></textarea>
						<%
							} else {
						%>
						<textarea name="CreateDefinition" style="width:80%" rows=6 onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_CreateDefinition',helpUrl); return false"><%=sDefinition%></textarea>
						<% } %>
					</td>
				</tr>

				<tr valign="bottom" height="25">
					<td align=right>
						<%
							if (!sOriginAction.equals("BlockEditDE") && (!isView)) {
						%>
						<font color="#FF0000">
							*&nbsp;&nbsp;
						</font>
						<%
							}
						%>
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
					<td height="26" valign="top">
					  <%String sStatusName = "";%> 
					   <%	if (!isView) {%>		
						
						<select name="selStatus" size="1" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selStatus',helpUrl); return false">
							<option value="" selected="selected"></option>
							<%
								for (int i = 0; vStatus.size() > i; i++) {
									 sStatusName = (String) vStatus.elementAt(i);
									//add only draft new and retired phased out if creating new
									if ((sMenuAction != null) && (sMenuAction.equals("Questions"))) {
										if (sStatusName.equals("DRAFT NEW")
												|| sStatusName.equals("RETIRED PHASED OUT")
												&& !sOriginAction.equals("BlockEditDEC")) {
							%>
							<option value="<%=sStatusName%>" <%if(sStatusName.equals(sStatus)){%> selected <%}%>>
								<%=sStatusName%>
							</option>
							<%
								}
									} else {
							%>
							<option value="<%=sStatusName%>" <%if(sStatusName.equals(sStatus)){%> selected <%}%>>
								<%=sStatusName%>
							</option>
							<%	}	}	%>
						</select><%}else{%><input type="text" size="22" value="<%=sStatus%>" readonly><%}%>
					</td>
				</tr>

				<tr height="25" valign="bottom">
					<%
						if (sOriginAction.equals("BlockEditDE")) {
					%>
					<td align=right>
						<%=item++%>
						)
					</td>
					<td height="25" valign="bottom">
						Check Box to Create New Version &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="<%=ToolURL.getCurationToolBusinessRulesURL(pageContext)%>" target="_blank">
							Business Rules
						</a>
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
					<td colspan=4>
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
						if (sOriginAction.equals("BlockEditDE")) {
					%>
					<td>
						<table width="60%">
							<col width="20%">
							<col width="13%">
							<col width="13%">
							<tr height="25">
								<!--Version check is checked only if the sVersion is either Whole or Point   -->
								<td valign="top">
									&nbsp;&nbsp;
									<input type="checkbox" name="VersionCheck" onClick="javascript:EnableChecks(checked,this);" value="ON" <%if(sVersion.equals("Whole") || sVersion.equals("Point")) {%> checked <%}%>
										onHelp="showHelp('html/Help_CreateDE.html#createCDEForm_BlockVersion',helpUrl); return false">
								</td>
								<!--Point check is checked only if the sVersion is Point and disabled otherwise  -->
								<td>
									<input type="checkbox" name="PointCheck" onClick="javascript:EnableChecks(checked,this);" value="ON" <%if(sVersion.equals("Point")){%> checked <%} else {%> disabled <%}%>
										onHelp="showHelp('html/Help_CreateDE.html#createCDEForm_BlockVersion',helpUrl); return false">
									&nbsp;Point Increase
								</td>
								<!--Whole check is checked only if the sVersion is Whole and disabled otherwise  -->
								<td colspan=2>
									<input type="checkbox" name="WholeCheck" onClick="javascript:EnableChecks(checked,this)" value="ON" <%if(sVersion.equals("Whole")){%> checked <%} else {%> disabled <%}%>
										onHelp="showHelp('html/Help_CreateDE.html#createCDEForm_BlockVersion',helpUrl); return false">
									&nbsp;Whole Increase
								</td>
							</tr>
						</table>
					</td>
					<%
						} else {
					%>
					<td valign="top" colspan=4>
							<input type="text" name="Version" value="<%=sVersion%>" size=5 readonly onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_Version',helpUrl); return false">
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
				<tr valign="bottom" height="25">
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
					<td height="25" valign="top">
						<input type="text" name="BeginDate" value="<%=sBeginDate%>" size="12" maxlength=10 <% if (isView) { %>readonly<%} %> onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_BeginDate',helpUrl); return false">
						<% if (!isView) { %>
						<img src="../../cdecurate/images/calendarbutton.gif" onclick="calendar('BeginDate', event);">
						<% } %>
						&nbsp;&nbsp;MM/DD/YYYY
					</td>
				</tr>

				<tr valign="bottom" height="25">
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
						<input type="text" name="EndDate" value="<%=sEndDate%>" size="12" maxlength=10 <% if (isView) { %>readonly<%} %> onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_EndDate',helpUrl); return false">
						<% if (!isView) { %>
						<img src="../../cdecurate/images/calendarbutton.gif" onclick="calendar('EndDate', event);">
						<% }  %>
						&nbsp;&nbsp;MM/DD/YYYY
					</td>
				</tr>
				<tr valign="bottom" height="25">
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
						Preferred Question Text
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td valign="top">
						<textarea name="CreateDocumentText" cols="89" <% if (isView) { %>readonly<%} %> onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_CreateDocumentText',helpUrl); return false" rows=2><%=sDocText%></textarea>
					</td>
				</tr>
				<!-- Classification Scheme and items -->
				<tr valign="bottom" height="25">
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
						<table width=100% border="0">
							<col width="1%">
							<col width="30%">
							<col width="15%">
							<col width="30%">
							<col width="15%">
							<%	if (!isView) {	%>
							<tr>
								<td height="30" valign="top" colspan=3>
									<%
										if (sOriginAction.equals("BlockEditDE")) {
									%>
									<select name="selCS" size="1" style="width:95%" onChange="ChangeCS();" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_BlockselCS',helpUrl); return false">
										<%
											} else {
										%>
										<select name="selCS" size="1" style="width:95%" onChange="ChangeCS();" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selCS',helpUrl); return false">
											<%
												}
											%>
											<option value="" selected></option>
											<%
												for (int i = 0; vCS.size() > i; i++) {
													String sCSName = (String) vCS.elementAt(i);
													String sCS_ID = (String) vCS_ID.elementAt(i);
											%>
											<option value="<%=sCS_ID%>">
												<%=sCSName%>
											</option>
											<%
												}
											%>
										</select>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
								</td>
								<td height="30" valign="top" colspan=2>
									<%
										if (sOriginAction.equals("BlockEditDE")) {
									%>
									<select name="selCSI" size="5" style="width:100%" onChange="selectCSI();" onClick="selectCSI();" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_BlockselCS',helpUrl); return false">
										<%
											} else {
										%>
										<select name="selCSI" size="5" style="width:100%" onChange="selectCSI();" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selCS',helpUrl); return false">
											<%
												}
											%>
										</select>
								</td>
							</tr>
							<% } %>
							<tr>
								<td height="12" valign="top">
							</tr>
							<tr>
								<td>
									&nbsp;
								</td>
								<td align="left">
									Selected Classification Schemes
								</td>
								<td align="left">
								<%	if (!isView) {	%>
									<input type="button" name="btnRemoveCS" value="Remove Item" onClick="removeCSList();">
								<% } %>								
								</td>
								<td align="left">
									Associated Classification Scheme Items
								</td>
								<td align="left">
								<%	if (!isView) {	%>
									<input type="button" name="btnRemoveCSI" value="Remove Item" onClick="removeCSIList();">
								<% } %>
								</td>
							</tr>
							<tr>
								<td>
									&nbsp;
								</td>
								<td colspan=2>
										<select name="selectedCS" size="5" style="width:98%" multiple onchange="addSelectCSI(false, true, '');" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selCS',helpUrl); return false">
											<%
												//store selected cs list on load 
												if (vSelCSIDList != null) {
													//      System.out.println("cs size " + vSelCSIDList.size());
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
								<td colspan=2>
										<select name="selectedCSI" size="5" style="width:100%" multiple <% if (!isView) { %>onchange="addSelectedAC();" <% } %>
											onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selCS',helpUrl); return false">
										</select>
								</td>
							</tr>
							<%
								if (sOriginAction.equals("BlockEditDE")) {
							%>
							<tr>
								<td height="12" valign="top">
							</tr>
							<tr>
								<td colspan=3>
									&nbsp;
								</td>
								<td colspan=2 valign=top>
									&nbsp;Data Elements containing selected Classification Scheme Items
								</td>
							</tr>
							<tr>
								<td colspan=3 valign=top>
									&nbsp;
								</td>
								<td colspan=2 valign=top>
									<select name="selCSIACList" size="3" style="width:100%" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_BlockselCS',helpUrl); return false">
									</select>
								</td>
							</tr>
							<%
								}
							%>
						</table>
					</td>
				</tr>
				<!-- contact info -->
				<%
					if (!sOriginAction.equals("BlockEditDE")) {
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
						<table width=40% border="0">
							<col width="50%">
							<col width="15%">
							<col width="15%">
							<col width="15%">
						  <% if (!isView) { %>
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
					    <%} %>
							<tr>
								<td colspan=4 valign="top">
								  								  
								  <%if (!isView){%>	
									<select name="selContact" size="4" style="width:100%" onchange="javascript:enableContButtons();" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContact',helpUrl); return false">
									<%}else{%><p class="inset">	
									<%}    Enumeration enum1 = hContacts.keys();
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
										</option><%}else{%><%=contName%><br><%}}
										
									if (!isView){%></select><%}else{%><br></p><%}%>
									
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<%
					}
				%>
				<!-- origin -->
				<tr valign="bottom" height="25">
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
						Data Element Origin
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
				<tr valign="bottom" height="25">
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
					<td valign="top">
						<textarea name="CreateChangeNote" cols="90%" rows=2 <% if (isView) { %>readonly<%} %> 
						onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_CreateComment',helpUrl); return false"><%=sChangeNote%></textarea>
					</td>
				</tr>
			<%	if (!isView) {	%>
				<tr valign="bottom" height="25">
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
						the Data Element(s)
					</td>
				</tr>
			<% } %>
			</table>
			<%
				if (!sOriginAction.equalsIgnoreCase("BlockEditDE")) {
			%>
			<hr>
			<!-- if not for create new from DDE or not for Block edit -->
			<table width="95%" border=0 name="DDETable">
				<col width=4%>
				<col width=45%>
				<col width=18%>
				<col width=30%>
				<!--<col width="4%"> <col width="95%">-->
				<tr>
					<th height="40" colspan=4>
								<label>
									<font size=4>
										Derived Data Element Derivation Rules and Components
									</font>
								</label>
					</th>
				</tr>
				<%if (!isView){%>	
				<tr height="25" valign="bottom">
					<td align=left colspan=4>
					   	<font color="#FF0000">
							&nbsp;*&nbsp;
						</font>
						Indicates Required Fields for Derived Data Elements
					</td>
				</tr><%}%>
				<tr height="25" valign="bottom">
					<td align=right>
					   <%if (!isView){%>
						<font color="#FF0000">
							*
						</font><%}%>	
						 <%=item++%>
						)
					</td>
					<td colspan=3>
					<% if (!isView) { %>
						<font color="#FF0000">
							Select
						</font>
						<% } %>
						Derivation Type
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td height="26" valign="top" colspan=3>
					  <% if (!isView) { %>	
						<select name="selRepType" size="1" onChange="javascript:changeRepType('change')" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selRepType',helpUrl); return false">
							
							<option value="" selected></option>
							<%
								for (int i = 0; vRepType.size() > i; i++) {
										String sRepType = (String) vRepType.elementAt(i);
							%>
							<option value="<%=sRepType%>" <%if(sRepType.equals(sSelRepType)){%> selected <%}%>>
								<%=sRepType%>
							</option>
							<%
								} 
							%>
												
						</select><%} else {  %><input type="text" size="17" value="<%=sSelRepType%>"readonly><%=sSelRepType%></option>
							<%}%>	
					</td>
				</tr>
				<tr height="25" valign="bottom">
					<td align=right>
					   <%if (!isView){%>	
						<font color="#FF0000">
							*
						</font><%}%>
						<%=item++%>
						)
					</td>
					<td colspan=3>
					<% if (!isView) { %>
						<font color="#FF0000">
							Create
						</font>
						<% } %>
						Rule
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td height="35" valign="top" colspan=3>
						<textarea name="DDERule" cols="69" <% if (isView) { %>readonly<%} %>  onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_DDERule',helpUrl); return false" rows=2><%=sSelRule%></textarea>
					</td>
				</tr>
				<tr height="25" valign="bottom">
					<td align=right>
						<%=item++%>
						)
					</td>
					<td colspan=3>
					<% if (!isView) { %>
						<font color="#FF0000">
							Create
						</font>
						<% } %>
						Methods
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td height="35" valign="top" colspan=3>
						<textarea name="DDEMethod" cols="69" <% if (isView) { %>readonly<%} %> onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_DDEMethod',helpUrl); return false" rows=2><%=sSelMethod%></textarea>
					</td>
				</tr>
				<tr height="25" valign="bottom">
					<td align=right>
						<%=item++%>
						)
					</td>
					<td colspan=3>
					<% if (!isView) { %>
						<font color="#FF0000">
							Enter
						</font>
						<% } %>
						Concatenation Character
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td valign="top" colspan=3>
						<input name="DDEConcatChar" type="text" value="<%=sSelConcatChar%>" size="5" maxlength=1 <% if (isView) { %>readonly<%} %> 
							onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_DDEConcatChar',helpUrl); return false">
					</td>
				</tr>
				<% if (!isView) { %>				
				<tr height="25" valign="bottom">
					<td align=right>
						<%=item++%>
						)
					</td>
					<td align=left>
						<font color="#FF0000">
							Search/Create
						</font>
						Data Element Components
					</td>
					<td align=left>
						<a href="javascript:SearchDEValue()">
							Search
						</a>
						For
					</td>
					<td align=left>
						<a href="javascript:CreateNewDEValue()">
							Create
						</a>
						New
					</td>
				</tr>
				<tr height="25" valign="top">
					<td colspan=2></td>
					<td align=left>
						Data Element
					</td>
					<td align=left>
						Data Element
					</td>
				</tr>
				<tr>
					<td height="14" valign="top">
				</tr>
				<tr height="30" valign="top">
					<td align=right>
						<%=item++%>
						)
					</td>
					<td align=left colspan=2>
						<font color="#FF0000">
							Select
						</font>
						Data Element Components
						<br>
						<select name="selDEComp" size="1" style="width:95%" valign="top" onChange="javascript:showDECompOrder()" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selDEComp',helpUrl); return false">
							<%
								for (int i = 0; vDEComp.size() > i; i++) {
										String sDEName = (String) vDEComp.elementAt(i);
										String sDE_ID = (String) vDECompID.elementAt(i);
							%>
							<option value="<%=sDE_ID%>" <%if(sDE_ID.equals(sDEID)){%> selected <%}%>>
								<%=sDEName%>
							</option>
							<%
								}
							%>
						</select>
					</td>
					<td valign="bottom">
						<font color="#FF0000">
							Enter
						</font>
						Display Order
						<br>
						<input name="txtDECompOrder" type="text" value="<%=sDECompOrder%>" size="20" maxlength=4 onKeyUp="changeOrder();" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_txtDECompOrder',helpUrl); return false">
						&nbsp;&nbsp;
					</td>
				</tr>
				<%} %>						
				<tr>
					<td height="14" valign="top">
				</tr>
				<tr>
					<td align=right><% if (isView) { %><%=item++%>
						)<%} %></td>
					<td>
						&nbsp;&nbsp;&nbsp;Selected Data Elements Components
					</td>
					<td align=left>
						<% if (!isView) { %>
						<input type="button" name="btnClearList1" value="Remove Item" onClick="removeDEComp();" width="85" height="9">
						<%} %>
					</td>
					<td>
						Display Order
					</td>
				</tr>
				<tr>
					<td></td>
					<td colspan=2 valign=top>
						&nbsp;&nbsp;
						<select name="selOrderedDEComp" size="3" style="width: 95%" onChange="javascript:selectOList();" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selOrderedDEComp',helpUrl); return false">
							<%
								for (int i = 0; vDEComp.size() > i; i++) {
										String sDEName = (String) vDEComp.elementAt(i);
										String sDE_ID = (String) vDECompID.elementAt(i);
							%>
							<option value="<%=sDE_ID%>" <%if(sDE_ID.equals(sDEID)){%> selected <%}%>>
								<%=sDEName%>
							</option>
							<%
								}
							%>
						</select>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td colspan=1 valign="top">
						<select name="selOrderList" size="3" style="width:130" onChange="javascript:selectODEComp();" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selOrderList',helpUrl); return false">
							<%
								for (int i = 0; vDECompOrder.size() > i; i++) {
										String sOrderName = (String) vDECompOrder.elementAt(i);
										String sRelationID = (String) vDECompRelID.elementAt(i);
							%>
							<option value="<%=sRelationID%>" <%if(sOrderName.equals(sDECompOrder)){%> selected <%}%>>
								<%=sOrderName%>
							</option>
							<%
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<td height="14" valign="top">
				</tr>
				<% if (!isView) { %>
				<tr height="20" valign="bottom">
					<td align=right>
						<%=item++%>
						)
					</td>
					<td colspan=3>
						<font color="#FF0000">
							<a href="javascript:SubmitValidate('validate')">
								Validate
							</a>
						</font>
						the Data Element
					</td>
				</tr>
				<%} %>
			</table>
			<%
				}
			%>
			<input type="hidden" name="pageAction" value="nothing">
			<%
				if (sOriginAction.equals("BlockEditDE")) {
			%>
			<input type="hidden" name="DEAction" value="BlockEdit">
			<%
				} else {
			%>
			<input type="hidden" name="DEAction" value="EditDE">
			<%
				}
			%>
			<input type="hidden" name="deIDSEQ" value="<%=sDEIDSEQ%>">
			<!-- source, language, doctext ids from des/rd tables  -->
			<input type="hidden" name="sourceIDSEQ" value="<%=sSourceIDSEQ%>">
			<input type="hidden" name="doctextIDSEQ" value="<%=sDocTextIDSEQ%>">
			<input type="hidden" name="regStatusIDSEQ" value="<%=sRegStatusIDSEQ%>">
			<input type="hidden" name="selDECText" value="<%=sDEC%>">
			<input type="hidden" name="selVDText" value="<%=sVD%>">
			<input type="hidden" name="nameTypeChange" value="<%=decvdChanged%>">
			<%if (sMenuAction != null){ %>
			  <input type="hidden" name="MenuAction" value="<%=sMenuAction%>">
			<%}%>  
			<select name="hiddenSelCSI" style="visibility:hidden;"></select>
			<!-- stores the selected rows to get the bean from the search results -->
			<select name="hiddenSelRow" size="1" style="visibility:hidden;width:160" multiple></select>
			<input type="hidden" name="acSearch" value="">
			<select name="selCSCSIHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selACCSIHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selCSNAMEHidden" size="1" style="visibility:hidden;" multiple></select>
			<!-- store the selected ACs in the hidden field to use it for cscsi 
This is refilled with ac id from ac-csi to use it for block edit-->
			<select name="selACHidden" size="1" style="visibility:hidden;" multiple>
				<%
					if (vACId != null) {
						for (int i = 0; vACId.size() > i; i++) {
							String sAC_ID = (String) vACId.elementAt(i);
							String sACName = "";
							if (vACName != null && vACName.size() > i)
								sACName = (String) vACName.elementAt(i);
							//    System.out.println("selected " + sACName);
				%>
				<option value="<%=sAC_ID%>" selected>
					<%=sACName%>
				</option>
				<%
					}
					}
				%>
			</select>

			<!-- for DDE -->
			<input type="hidden" name="NotValidDBType" value="<%=sNVType%>">
			<input type="hidden" name="DECompCountHidden" value="<%=vDEComp.size()%>">
			<select name="selDECompHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selDECompIDHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selDECompOrderHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selDECompRelIDHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selDECompDeleteHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selDECompDelNameHidden" size="1" style="visibility:hidden;" multiple></select>
			<%
				if ((sDDEAction != null) && (sDDEAction.equals("CreateNewDEFComp")))
					sOriginAction = sDDEAction;
			%>
			<input type="hidden" name="originActionHidden" value="<%=sOriginAction%>">

			<script language="javascript">
displayStatusMessage();
changeCountPN();
changeCountLN();
loadCSCSI();
//changeRepType('init');
</script>
		</form>
	</body>
</html>
