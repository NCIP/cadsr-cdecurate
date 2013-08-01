<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/CreateVM.jsp,v 1.6 2009-04-21 03:47:35 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page import="java.util.*"%>
<html>
	<head>
		<title>
			Create Value Item/Meaning
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<%@ page import="java.text.*"%>
		<%@ page import="java.util.*"%>
		<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/date.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/CreateVM.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%
    String sVMBack = (String)session.getAttribute("VMBack");
    
    //System.out.println("CreateVM sVMBack: " + sVMBack);
    if(sVMBack == null) sVMBack = "";
    session.setAttribute("VMBack", "");
    
    String sSearched = (String)session.getAttribute("EVSSearched");
    if(sSearched == null) sSearched = "";
  //  System.out.println("CreateVM sSearched: " + sSearched);
    String sMenuAction = (String)session.getAttribute(Session_Data.SESSION_MENU_ACTION);
  //  System.out.println("menu create vm jsp " + sMenuAction);
    session.setAttribute(Session_Data.SESSION_MENU_ACTION, "searchForCreate");
    session.setAttribute("creSearchAC", "CreateVM_EVSValueMeaning");
%>
		<Script Language="JavaScript">
   var helpUrl = "<%=ToolURL.getCurationToolHelpURL(pageContext)%>";
  
  function AccessEVS()
  {
    if (evsWindow && !evsWindow.closed)
       evsWindow.focus();
    else
    {
      // document.SearchActionForm.searchEVS.value = "EVSValueMeaning";
       document.SearchActionForm.isValidSearch.value = "false";
       document.SearchActionForm.searchComp.value = "CreateVM_EVSValueMeaning";
       evsWindow = window.open("jsp/OpenSearchWindowBlocks.jsp", "EVSWindow", "width=950,height=700,top=0,left=0,resizable=yes,scrollbars=yes");    
    }
  }

function displayStatusMessage()
  {
 <%
    String statusMessage = (String)session.getAttribute(Session_Data.SESSION_STATUS_MESSAGE);
    if (statusMessage != null && !statusMessage.equals(""))
    {%>
	       alert("<%=statusMessage%>");
    <% }
    //reset the status message to no message
    session.setAttribute(Session_Data.SESSION_STATUS_MESSAGE, "");
%>
    window.status = "Create a new Value Meaning"
  }

</SCRIPT>

	</head>
	<body onLoad="JavaScript:currentDate();">
		<form name="SearchActionForm" method="post" action="">
			<input type="hidden" name="searchComp" value="">
			<input type="hidden" name="isValidSearch" value="true">
			<input type="hidden" name="searchEVS" value="ValueMeaning">
		</form>
		<form name="createVMForm" method="POST" action="../../cdecurate/NCICurationServlet?reqType=newVM">
			<%  
    VM_Bean m_VM = new VM_Bean();
    m_VM = (VM_Bean)session.getAttribute("m_VM");
    if (m_VM == null) m_VM = new VM_Bean();
    VD_Bean m_VD = new VD_Bean();
    m_VD = (VD_Bean)session.getAttribute("m_VD");
    if (m_VD == null) m_VD = new VD_Bean();
    Vector vShortMeanings = (Vector)session.getAttribute("vPVM"); 
    Vector vCD = (Vector)session.getAttribute("vCD");
    Vector vCDID = (Vector)session.getAttribute("vCD_ID"); 
   // String sCDCont = m_VD.getv
    String sBeginDate = m_VM.getVM_BEGIN_DATE();
    if (sBeginDate == null)
    {
       Date currentDate = new Date();
       SimpleDateFormat formatter = new SimpleDateFormat ("MM/dd/yyyy");
       sBeginDate = formatter.format(currentDate);
    }
    String sEndDate = m_VM.getVM_END_DATE();
    if (sEndDate == null) sEndDate = "";
    String sConDomID = m_VD.getVD_CD_IDSEQ();
    if (sConDomID == null) sConDomID = "";
    String sConDom = m_VD.getVD_CD_NAME();
    if (sConDom == null) sConDom = "";
    //String sDescription = m_VM.getVM_DESCRIPTION();
    String sDescription = m_VM.getVM_PREFERRED_DEFINITION();
    if (sDescription == null) sDescription = ""; 
  //  String sShortMeanings = m_VM.getVM_SHORT_MEANING();
    String sShortMeanings = m_VM.getVM_LONG_NAME();
    if (sShortMeanings == null) sShortMeanings = "";
//System.out.println("before vmconcept");
    EVS_Bean eBean = (EVS_Bean)m_VM.getVM_CONCEPT();
    if (eBean == null) eBean = new EVS_Bean();
  //  String sEVS = "";
//System.out.println(eBean.getCONCEPT_IDENTIFIER() + " : " + eBean.getTEMP_CUI_VAL() + " : " + eBean.getUMLS_CUI_VAL());
    String sEVS = eBean.getCONCEPT_IDENTIFIER();
    if (sEVS == null) sEVS = "";
    if (!sEVS.equals(""))
    {
      String evsVocab = eBean.getEVS_DATABASE();
      if (evsVocab.equals(EVSSearch.META_VALUE))  // "MetaValue")) 
         evsVocab = eBean.getEVS_ORIGIN();
      sEVS = sEVS + ": " + evsVocab;
    }
//System.out.println(" evs " + sEVS);
    String sComments = m_VM.getVM_CHANGE_NOTE();
    if (sComments == null) sComments = "";
    boolean bDataFound = false;    
    
  /*  EVS_Bean vmConcept = (EVS_Bean)m_VM.getVM_CONCEPT();
    if (vmConcept == null) vmConcept = new EVS_Bean();
    String sEVSname = vmConcept.getLONG_NAME();
    if (sEVSname == null) sEVSname = "";
    String sEVSid = vmConcept.getCONCEPT_IDENTIFIER();
    if (sEVSid == null) sEVSid = "";
    String sEVSdb = vmConcept.getEVS_DATABASE();
    if (sEVSdb == null) sEVSdb = ""; */
//System.out.println("vm jsp sEVSname: " + sEVSname + " sEVSid: " + sEVSid);
%>
			<input type="hidden" name="pageAction" value="nothing">
			<table width="100%" border="0">
				<col width="4%">
				<col width="95%">
				<tr>
					<td colspan="6" align="left" valign="top">
						<input type="button" name="btnValidate" value="Validate" onClick="SubmitValidate('validate');" onHelp="showHelp('html/Help_CreateVD.html#createVMForm_Validation',helpUrl); return false">
						&nbsp;&nbsp;
						<input type="button" name="btnClear" value="Clear" onClick="clearBoxes();">
						&nbsp;&nbsp;
						<input type="button" name="btnBack" value="Back" onClick="Back();">
						&nbsp;&nbsp;
						<img name="Message" src="images/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" style="visibility:hidden;">
					</td>
				</tr>
				<tr>
					<th colspan=2 height="40">
						<div align="left">
							<label>
								<font size=4>
									Create New
									<font color="#FF0000">
										Value Meaning
									</font>
								</font>
							</label>
						</div>
					</th>
				</tr>
				<tr height="25" valign="middle">
					<td colspan=2>
						<font color="#FF0000">
							&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;&nbsp;
						</font>
						Indicates Required Field
					</td>
				</tr>
				<tr height="25" valign="bottom">
					<td align=right>
						<font color="#C0C0C0">
							1)
						</font>
					</td>
					<td>
						<font color="#C0C0C0">
							Conceptual Domain
						</font>
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td>
						<select name="selConceptualDomain" size="1" onHelp="showHelp('html/Help_CreateVD.html#createVMForm_CreateVM',helpUrl); return false">
							<option value="<%=sConDomID%>" selected>
								<%=sConDom%>
							</option>
						</select>
					</td>
				</tr>
				<tr height="25" valign="bottom">
					<td align=right>
						<font color="#FF0000">
							* &nbsp;
						</font>
						2)
					</td>
					<td>
						<font color="#FF0000">
							Create
						</font>
						Value Meaning
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td>
						<textarea name="selShortMeanings" cols="65" rows="2" <%if(sEVS != null && !sEVS.equals("")) {%> disabled <% } %>><%=sShortMeanings%></textarea>
						&nbsp;&nbsp;
						<font color="#FF0000">
							<a href="javascript:AccessEVS()">
								Search EVS
							</a>
						</font>
						&nbsp;&nbsp;
						<font color="#FF0000">
							<a href="javascript:ClearMeaning()">
								Clear
							</a>
						</font>
					</td>
				</tr>
				<tr height="25" valign="bottom">
					<td align=right>
						3)
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
						<input type="text" name="BeginDate" size="12" maxlength=10 value="<%=sBeginDate%>" onHelp="showHelp('html/Help_CreateVD.html#createVMForm_BeginDate',helpUrl); return false">
							<img name="Calendar" src="images/calendarbutton.gif" alt="Calendar" onclick="calendar('BeginDate', event);">
						<font size="2">
							&nbsp;&nbsp;MM/DD/YYYY
						</font>
					</td>
				</tr>
				<tr height="25" valign="bottom">
					<td align=right>
						&nbsp 4)
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
					<td valign="top">
						<input type="text" name="EndDate" size="12" maxlength=10 value="<%=sEndDate%>" onHelp="showHelp('html/Help_CreateVD.html#createVMForm_EndDate',helpUrl); return false">
							<img name="Calendar" src="images/calendarbutton.gif" alt="Calendar" onclick="calendar('EndDate', event);">
						<font size="2">
							&nbsp;&nbsp;MM/DD/YYYY
						</font>
					</td>
				</tr>

				<tr height="25" valign="bottom">
					<td align=right>
						&nbsp 5)
					</td>
					<td>
						<font color="#FF0000">
							Verify
							<font color="#000000">
								Description
							</font>
						</font>
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td valign="top" align="left">
						<textarea name="CreateDescription" style="width:80%" rows=4 <%if(sEVS != null && !sEVS.equals("")) {%> disabled <% } %> onHelp="showHelp('html/Help_CreateVD.html#createVMForm_CreateVM',helpUrl); return false"><%=sDescription%></textarea>
						&nbsp;&nbsp;
						<font color="#FF0000">
							<a href="javascript:ClearMeaning()">
								Clear
							</a>
						</font>
					</td>
				</tr>
				<tr height="25" valign="bottom">
					<td align=right>
						&nbsp 6)
					</td>
					<td colspan=2>
						<font color="#FF0000">
							Display
						</font>
						Concept Code
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td valign="top" align="left" colspan=2>
						<input type="text" name="EVSConceptID" size="60" value="<%=sEVS%>" style="color:#696969" readonly onHelp="showHelp('html/Help_CreateVD.html#createPVForm_CreateValue',helpUrl); return false">
					</td>
				</tr>

				<tr height="25" valign="bottom">
					<td align=right>
						&nbsp 7)
					</td>
					<td>
						<font color="#FF0000">
							Create
							<font color="#000000">
								Comments
							</font>
						</font>
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td valign="top" align="left">
						<textarea name="taComments" cols="70" onHelp="showHelp('html/Help_CreateVD.html#createVMForm_CreateVM',helpUrl); return false" rows="2"><%=sComments%></textarea>
					</td>
				</tr>
				<tr height="25" valign="bottom">
					<td align=right>
						&nbsp 8)
					</td>
					<td>
						<font color="#FF0000">
							<A HREF="javascript:SubmitValidate('validate')">
								Validate
							</A>
						</font>
						Value Meaning
					</td>
				</tr>
			</table>
			<!-- Optional Values -->
			<input type="hidden" name="MenuAction" value="<%=sMenuAction%>">
			<input type="hidden" name="selConceptualDomainText" value="<%=sConDom%>">
			<input type="hidden" name="hiddenEVSSearch" value="<%=sSearched%>">
			<input type="hidden" name="hiddenSelRow" value="">
			<script language="javascript">
					displayStatusMessage();
			</script>
		</form>
	</body>
</html>
