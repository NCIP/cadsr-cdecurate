<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ page import="java.util.*" %>
<html>
<head>
<title>Create Value Item/Meaning</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
<%@ page import="java.text.*" %>
<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*" %>

<SCRIPT LANGUAGE="JavaScript" SRC="js/CreatePV.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="js/date.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
<Script Language="JavaScript">

function displayStatusMessage()
{
 <%
    String statusMessage = (String)session.getAttribute("statusMessage");
    if (statusMessage != null && !statusMessage.equals(""))
    {%>
	       alert("<%=statusMessage%>");
    <% }
    //reset the status message to no message
    session.setAttribute("statusMessage", "");
 %>
    window.status = "Create new Permissible Value";
}
  
function ViewConceptInTree()
{
  document.SearchActionForm.searchComp.value = "PV_ValueMeaning";
  document.SearchActionForm.openToTree.value = "true";
	document.SearchActionForm.isValidSearch.value = "false";
  if (searchWindow && !searchWindow.closed)
    searchWindow.close();
  searchWindow = window.open("jsp/OpenSearchWindowBlocks.jsp", "BlockSearch", "width=975,height=700,top=0,left=0,resizable=yes,scrollbars=yes")
}

</SCRIPT>
</head>
<body>
<form name="createPVForm" method="POST" action="../../cdecurate/NCICurationServlet?reqType=newPV">
<%
    UtilService serUtil = new UtilService();
    String sPVAction = (String)session.getAttribute("PVAction");
    if (sPVAction == null) sPVAction = "createPV";
 // System.out.println(" pv action " + sPVAction);
    Vector vSource = (Vector)session.getAttribute("vSource");
    String sMenuAction = (String)session.getAttribute("MenuAction");
    PV_Bean m_PV = (PV_Bean)session.getAttribute("m_PV");
    if (m_PV == null) m_PV = new PV_Bean();
    //get vd bean
    VD_Bean m_VD = (VD_Bean)session.getAttribute("m_VD");
    if (m_VD == null) m_VD = new VD_Bean();
 
    //make it new if no pvidseq.
    String sPVid = m_PV.getPV_PV_IDSEQ();
    if (sPVid == null) sPVid = "";
//System.out.println(sPVAction + " page pv id " + sPVid); 
    String sVV = m_PV.getQUESTION_VALUE();
    if (sVV == null) sVV = "";
    String sVVid = m_PV.getQUESTION_VALUE_IDSEQ();
    if (sVVid == null) sVVid = "";
    String sValue = m_PV.getPV_VALUE();
    sValue = serUtil.parsedStringDoubleQuoteJSP(sValue);    //call the function to handle doubleQuote
    if (sValue == null) sValue = ""; 
    String sVMMeaning = m_PV.getPV_SHORT_MEANING();
    if (sVMMeaning == null) sVMMeaning = ""; 
    if (!sVMMeaning.equals("")) sVMMeaning = sVMMeaning.trim();
    String sDescription = m_PV.getPV_MEANING_DESCRIPTION();
    if (sDescription == null) sDescription = "";

    //vm concept attributes
    EVS_Bean vmConcept = (EVS_Bean)m_PV.getVM_CONCEPT();
    if (vmConcept == null) vmConcept = new EVS_Bean();
    String sEVSname = vmConcept.getLONG_NAME();
    if (sEVSname == null) sEVSname = "";
    String sEVSid = vmConcept.getNCI_CC_VAL();
    if (sEVSid == null) sEVSid = "";
    String sEVSdb = vmConcept.getEVS_DATABASE();
    if (sEVSdb == null) sEVSdb = "";
    if (!sEVSid.equals(""))
    {
      if (sEVSdb.equals(EVSSearch.META_VALUE))  // "MetaValue")) 
         sEVSdb = vmConcept.getEVS_ORIGIN();
      sEVSid = sEVSid + ": " + sEVSdb;
    }

    String sOrigin = m_PV.getPV_VALUE_ORIGIN();
    if (sOrigin == null) sOrigin = "";

    String sBeginDate = m_PV.getPV_BEGIN_DATE();
    if (sBeginDate == null && sPVAction.equals("createPV"))
    {
       Date currentDate = new Date();
       SimpleDateFormat formatter = new SimpleDateFormat ("MM/dd/yyyy");
       sBeginDate = formatter.format(currentDate);
    }
    if (sBeginDate == null) sBeginDate = "";
    
    String sEndDate = m_PV.getPV_END_DATE();
    if (sEndDate == null) sEndDate = "";
    
    String sCDid = m_VD.getVD_CD_IDSEQ();
    if (sCDid == null) sCDid = "";
    
    //get crf value to display
    Vector vQuest = (Vector)session.getAttribute("vQuestValue");
    if (vQuest == null) vQuest = new Vector();
    Vector vQVList = (Vector)session.getAttribute("NonMatchVV");
    if (vQVList == null) vQVList = new Vector();
  //  System.out.println("pv jsp menu " + sMenuAction);
    //helps to submit searchFor Create window
    session.setAttribute("MenuAction", "searchForCreate");    
    
    boolean bDataFound = false;    
    int item = 1;
%>
  <table width="90%" border="0">
  <col width="3%"><col width="50%"><col width="25%">
    <tr>
      <td colspan="6" align="left" valign="top">
        <input type="button" name="btnValidate" value="Validate" onClick="SubmitValidate('validate');"
				onHelp = "showHelp('html/Help_CreateVD.html#createPVForm_Validation',helpUrl); return false">
          &nbsp;&nbsp;
        <input type="button" name="btnClear" value="Clear" onClick="clearBoxes();">
          &nbsp;&nbsp;
        <input type="button" name="btnBack" value="Back" onClick="Back();">
          &nbsp;&nbsp;
	     <img name="Message" src="images/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" style="visibility:hidden;">
      </td>
    </tr>
    <tr>
      <th colspan=3 height="40"> <div align="left">
       <label><font size=4>
          <!-- label for block edit, single edit, or create new pvs -->
          <%if (sPVAction.equals("editPV") && sPVid.equals("")) { %> Block Edit Selected <% } 
            else if (sPVAction.equals("editPV")) { %> Edit Selected <% }  
            else { %> Create New <% } %> 
            <font color="#FF0000">Permissible Value<%if (sPVAction.equals("editPV") && sPVid.equals("")) { %>s<%}%>
            </font></font></label></div>
      </th>
    </tr>
    <tr height="25" valign="middle">
      <td colspan=3><font color="#FF0000">&nbsp;&nbsp;*&nbsp;&nbsp;&nbsp;</font>Indicates Required Field</td>
    </tr>
    <% if (vQuest.size() > 0 && sMenuAction.equals("Questions") && !(sPVAction.equals("editPV") && sPVid.equals(""))) { %>    
        <tr height="25" valign="bottom">
          <td align=right><font color="#FF0000">* &nbsp;</font> <%=item++%>)</td>
          <td colspan=2><font color="#FF0000">Select</font> Valid Value from CRF Question</td>
        </tr>
        <tr border-style="border-bottom-width: 100">
          <td> &nbsp; </td>
          <td valign="bottom"  colspan=2>
            <select name="selValidValue" size=1 style="width:150"
              onHelp = "showHelp('html/Help_CreateVD.html#createPVForm_CreateValue',helpUrl); return false">
              <option value="" selected></option>
<%            if (sVV.equals(""))
              {
                for (int i = 0; vQuest.size()>i; i++)
                {
                  Quest_Value_Bean qvBean = (Quest_Value_Bean)vQuest.elementAt(i);
                  String sQValue = qvBean.getQUESTION_VALUE();
                  String sQVid = qvBean.getQUESTION_VALUE_IDSEQ();
                  if (vQVList.contains(sQValue)) {
%>
                  <option value="<%=sQVid%>" <%if(sQVid.equals(sVVid)){%>selected <%}%>><%=sQValue%></option>
<%
                  }
                }
              }
              else
              {
%>
                  <option value="<%=sVVid%>" selected><%=sVV%></option>
<%
              }
%>                
            </select>
          </td>
        </tr>
<%  } %>
    <tr height="25" valign="bottom">
      <%if (sPVAction.equals("createPV") || (sPVAction.equals("editPV") && sValue != null && !sValue.equals(""))) { %> 
        <td align=right><font color="#FF0000"><%if (!sPVAction.equals("editPV")) { %>*<% } %> &nbsp;</font> <%=item++%>)</td>
        <td colspan=2><font color="#FF0000">Create</font> New Value</td>
      <% } else { %>        
          <td align=right><font color="#C0C0C0"><%=item++%>)</font></td>
          <td colspan=2><font color="#C0C0C0">Create New Value</font></td>
      <% } %>
    </tr>
    <tr>
      <td> &nbsp; </td>
      <td valign="bottom"  colspan=2>
       <%if (sPVAction.equals("createPV") || (sPVAction.equals("editPV") && sValue != null && !sValue.equals(""))) { %> 
        <input type="text" name="txtPermValue" style="width:50%" size="20" maxlength=255 value="<%=sValue%>" 
          onHelp = "showHelp('html/Help_CreateVD.html#createPVForm_CreateValue',helpUrl); return false">
       <% } else { %>
        <input type="text" name="txtPermValue" size="20" maxlength=255 style="width:50%; color:#696969" value="<%=sValue%>" readonly
          onHelp = "showHelp('html/Help_CreateVD.html#createPVForm_CreateValue',helpUrl); return false">
       <% } %>
     </td>
    </tr>
    <tr height="25" valign="bottom">
      <%if (sPVAction.equals("createPV")) { %> 
        <td align=right><font color="#FF0000">* &nbsp;</font> <%=item++%>)</td>
        <td colspan=2><font color="#FF0000">Select or Create </font>Value Meaning</td>
      <% } else { %>
        <td align=right><font color="#C0C0C0"><%=item++%>)</font></td>
        <td colspan=2><font color="#C0C0C0">Select or Create New Value Meaning</font></td>
      <% } %>
    </tr>
    <tr>
      <td> &nbsp; </td>
      <td  align="left">
        <textarea name="selShortMeanings" cols="100%" style="color:#696969" readonly
          onHelp = "showHelp('html/Help_CreateVD.html#createVMForm_CreateVM',helpUrl); return false" rows="2"><%=sVMMeaning%></textarea>
      </td>
      <td align="left">
      <%if (!sPVAction.equals("editPV")) { %>
          <font color="#FF0000"> <a href="javascript:searchVM()">Select / Create New</a></font>  
      <% } %>
      </td>
    </tr>
    <tr height="25" valign="bottom">
      <td align=right><font color="#C0C0C0"><%=item++%>)</font></td>
      <td colspan=2><font color="#C0C0C0">Display Value Meaning Description</font></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
	    <td  valign="top" align="left"  colspan=2> 
        <textarea name="CreateDescription" rows="4" style="color:#696969; width:80%" readonly
            onHelp = "showHelp('html/Help_CreateVD.html#createPVForm_CreateValue',helpUrl); return false"><%=sDescription%></textarea>
      </td>
	  </tr>
    <tr height="25" valign="bottom">
      <td align=right><font color="#C0C0C0"><%=item++%>)</font></td>
      <td colspan=2><font color="#C0C0C0">Display VM Concept Code</font></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
	    <td valign="top" align="left" colspan=2> 
        <input type="text" name="EVSConceptID" size="25"  value="<%=sEVSid%>" style="color:#696969" readonly
            onHelp = "showHelp('html/Help_CreateVD.html#createPVForm_CreateValue',helpUrl); return false">
        &nbsp;&nbsp;&nbsp;
      </td>
	  </tr>

    <tr height="25" valign="bottom">
      <td align=right>&nbsp; <%=item++%>) </td>
      <td colspan="2"> <font color="#FF0000">Select </font>Permissible Value Origin</td>
    </tr>     
    <tr>
      <td>&nbsp;</td>
      <td height="24"  valign="top" colspan="2">
        <select name="selPVSource" size="1"
              onHelp = "showHelp('html/Help_CreateVD.html#createVDForm_ValueOrigin',helpUrl); return false">
            <option value="" selected></option>
<%         
		   boolean isFound = false;
		   for (int i = 0; vSource.size()>i; i++)
           {
              String sSor = (String)vSource.elementAt(i);
              if(sSor.equals(sOrigin)) isFound = true;
%>
              <option value="<%=sSor%>" <%if(sSor.equals(sOrigin)){%>selected<%}%> ><%=sSor%></option>
<%         }
		   //add the user entered if not found in the drop down list
		   if (!isFound) 
		   {  
		   	  sOrigin = serUtil.parsedStringDoubleQuoteJSP(sOrigin);     //call the function to handle doubleQuote
%>
           		<option value="<%=sOrigin%>" selected><%=sOrigin%></option>
<%		   } %>
        </select>
      </td>
    </tr> 
	
    <tr height="25" valign="bottom">
      <td align=right><font color="#FF0000"> <%if (!sPVAction.equals("editPV")) { %>*<%}%> &nbsp;</font> <%=item++%>) </td>
      <td colspan=2><font color="#FF0000">Enter/Select</font> Effective Begin Date</td>
    </tr>
    <tr>
      <td> &nbsp; </td>
      <td valign="top"  colspan=2>
        <input type="text" name="BeginDate" size="12" maxlength=10 value="<%=sBeginDate%>"
          onHelp = "showHelp('html/Help_CreateVD.html#createPVForm_BeginDate',helpUrl); return false">
        <img name="Calendar" src="images/calendarbutton.gif" alt="Calendar" onclick="calendar('BeginDate', event);">
        <font size="2">&nbsp;&nbsp;MM/DD/YYYY</font>
      </td>
    </tr>

    <tr height="25" valign="bottom">
      <td align=right>&nbsp; <%=item++%>) </td>
      <td colspan=2><font color="#FF0000">Enter/Select</font> Effective End Date</td>
    </tr>
    <tr>
      <td> &nbsp; </td>
      <td valign="top"  colspan=2>
        <input type="text" name="EndDate" size="12" maxlength=10 value="<%=sEndDate%>"
          onHelp = "showHelp('html/Help_CreateVD.html#createPVForm_EndDate',helpUrl); return false">
        <img name="Calendar" src="images/calendarbutton.gif" alt="Calendar" onclick="calendar('EndDate', event);">
        <font size="2">&nbsp;&nbsp;MM/DD/YYYY</font>
      </td>
    </tr>
    <tr height="25" valign="bottom">
      <td align=right>&nbsp; <%=item++%>) </td>
      <td colspan=2><font color="#FF0000"> <A HREF="javascript:SubmitValidate('validate')">
          Validate</A></font> Permissible Value</td>
    </tr>
    <!-- leave some space -->
    <tr height="75"><td>&nbsp;</td></tr>
  </table>

<script language = "javascript">
displayStatusMessage();
</script>
<input type="hidden" name="newCDEPageAction" value="nothing">
<input type="hidden" name="MenuAction" value="<%=sMenuAction%>">
<input type="hidden" name="VMOrigin" value="Permissible">
<input type="hidden" name="VMEvsDB" value="">
<input type="hidden" name="pvID" value="<%=sPVid%>">
<input type="hidden" name="txValidValue" value="">
<input type="hidden" name="PVAction" value="<%=sPVAction%>">
</form>

<form name="SearchActionForm" method="post" action="">
  <input type="hidden" name="searchComp" value="ValueMeaning">
  <input type="hidden" name="searchEVS" value="PermissibleValue">
  <input type="hidden" name="isValidSearch" value="false">
  <input type="hidden" name="SelCDid" value="<%=sCDid%>">
   <input type="hidden" name="sCCodeDB" value="<%=sEVSdb%>">
  <input type="hidden" name="sCCode" value="<%=sEVSid%>">
  <input type="hidden" name="sCCodeName" value="<%=sEVSname%>">
  <input type="hidden" name="openToTree" value=""> 
  <input type="hidden" name="sConteIdseq" value="">
</form>
<form name="FormVM" method="post" action="../../cdecurate/NCICurationServlet?reqType=createVM">
  <input type="hidden" name="hiddenPValue" value="">
  <input type="hidden" name="VMOrigin" value="Permissible">
</form>
</body>
</html>