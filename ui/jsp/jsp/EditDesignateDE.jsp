<html>
<head>
<title>Edit Designated Data Element</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<%@ page import="java.util.*" %>
<%@ page import="com.scenpro.NCICuration.*" %>
<%@ page session="true" %>
<link href="FullDesignArial.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="Assets/date-picker.js"></script>
<SCRIPT LANGUAGE="JavaScript" SRC="Assets/AddNewListOption.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="Assets/SelectCS_CSI.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../../cdecurate/Assets/HelpFunctions.js"></SCRIPT>
<%
    UtilService serUtil = new UtilService();
    //load the lists
    Vector vContext = (Vector)session.getAttribute("vWriteContextDE");
    Vector vContextID = (Vector)session.getAttribute("vWriteContextDE_ID");
    Vector vCS = (Vector)session.getAttribute("vCS");
    Vector vCS_ID = (Vector)session.getAttribute("vCS_ID");
    Vector vAltTypes = (Vector)session.getAttribute("AltNameTypes");
    Vector vRefTypes = (Vector)session.getAttribute("RefDocTypes");
    Vector vLanguage = (Vector)session.getAttribute("vLanguage");
    
    String sMenuAction = (String)session.getAttribute("MenuAction");
    String sOriginAction = (String)session.getAttribute("originAction");
    if (sOriginAction == null) sOriginAction = "";
    DE_Bean m_DE = (DE_Bean)session.getAttribute("m_DE");
    if (m_DE == null) m_DE = new DE_Bean();
   // session.setAttribute("DEEditAction", "");
    String sDEIDSEQ = m_DE.getDE_DE_IDSEQ();
    if (sDEIDSEQ == null) sDEIDSEQ = "";

    String sContext = (String)request.getAttribute("desContext");
    if (sContext == null) sContext = "";
    String sDesLang = (String)request.getAttribute("desLang");
    if (sDesLang == null || sDesLang.equals("")) sDesLang = "ENGLISH";
    
  /*  String sContext = m_DE.getDE_CONTEXT_NAME();
    if (sContext == null) sContext = "";
    String sContID = m_DE.getDE_CONTE_IDSEQ();
    if (sContID == null) sContID = ""; */

    String sLongName = m_DE.getDE_LONG_NAME();
    sLongName = serUtil.parsedString(sLongName);    //call the function to handle doubleQuote
    if (sLongName == null) sLongName = "";
      
    String sStatus = m_DE.getDE_ASL_NAME();
    if (sStatus == null && sOriginAction.equals("BlockEditDE")) sStatus = "";
    else if (sStatus == null) sStatus = "DRAFT NEW";

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
    //get alternate name attributs
    Vector vAllAltName = (Vector)session.getAttribute("AllAltNameList"); 
    if (vAllAltName == null) vAllAltName = new Vector();
    Vector vDispAlt = new Vector();
    for (int i =0; i<vAllAltName.size(); i++)
    {
      ALT_NAME_Bean altNameBean = (ALT_NAME_Bean)vAllAltName.elementAt(i);
      if (altNameBean == null) altNameBean = new ALT_NAME_Bean();
      String altType = altNameBean.getALT_TYPE_NAME();
      String altSubmit = altNameBean.getALT_SUBMIT_ACTION();
      String altName = altNameBean.getALTERNATE_NAME();
      String altContext = altNameBean.getCONTEXT_NAME();
      String curAlt = altType + " " + altName + " " + altContext;
      //do not count if used by, del, or alredy displayed
      if ((altType != null && altType.equals("USED_BY")) || (altSubmit != null 
        && altSubmit.equals("DEL")) || vDispAlt.contains(curAlt))
        continue;
      //do the count and chek box name
      vDispAlt.addElement(curAlt);
    }
    //get reference doc attributes
    Vector vAllRefDoc = (Vector)session.getAttribute("AllRefDocList"); 
    if (vAllRefDoc == null) vAllRefDoc = new Vector();
    Vector vDispRef = new Vector();
    for (int i =0; i<vAllRefDoc.size(); i++)
    {
      REF_DOC_Bean refDocBean = (REF_DOC_Bean)vAllRefDoc.elementAt(i);
      if (refDocBean == null) refDocBean = new REF_DOC_Bean();
      String refType = refDocBean.getDOC_TYPE_NAME();
      String refSubmit = refDocBean.getREF_SUBMIT_ACTION();
      String refName = refDocBean.getDOCUMENT_NAME();
      String refContext = refDocBean.getCONTEXT_NAME();
      String curRef = refType + " " + refName + " " + refContext;
      //do not count if used by, del, or alredy displayed
      if ((refType != null && refType.equals("USED_BY")) || (refSubmit != null 
        && refSubmit.equals("DEL")) || vDispRef.contains(curRef))
        continue;
      //do the count and chek box name
      vDispRef.addElement(curRef);
    }
    
    int item = 1;
        
%>

<Script Language="JavaScript">
 var evsWindow2 = null;
  //get all the cs_csi from the bean to array.
  var csiArray = new Array();  
  var selCSIArray = new Array();  //for selected csi list
  var selACCSIArray = new Array();  //for selected AC-csi list
  var writeContArray = new Array();
//  var selRefDocArray = new Array();  //for selected reference doc list
//  var selAltNameArray = new Array();  //for selected alternate name list
  var browseWindow = null;
  
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
<%    //Vector vACCSIList = (Vector)request.getAttribute("vACCSIList");
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
            acName = serUtil.parsedStringDoubleQuote(acName); %>
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
          //alert("laoding " + selCSI_name);
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
    window.status = "Edit the Designated Data Element, choose context first"
  }

  //back button
  function Back()
  {
		document.designateDEForm.Message.style.visibility="visible";
    document.designateDEForm.newCDEPageAction.value = "backToSearch";
    document.designateDEForm.submit();
  }
  function ClearBoxes()
  {
		document.designateDEForm.Message.style.visibility="visible";
    document.designateDEForm.newCDEPageAction.value = "clearBoxes";
    document.designateDEForm.submit();
  }
  
</Script>
</head>

<body>
<form name="designateDEForm" method="post" action="/cdecurate/NCICurationServlet?reqType=designateDE">
  <table width="100%" border=0>
    <!--DWLayoutTable-->
    <tr>
      <td align="left" valign="top" colspan=2>
        <input type="button" name="btnUpdate" value="Update Used By Attributes" style="width:170" 
              onClick="javascript:submitDesignate('create');"
              onHelp = "showHelp('Help_CreateDE.html#newCDEForm_Validation'); return false">
          &nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" name="btnRemove" value="Remove Used By Attributes" style="width:175" 
              onClick="javascript:submitDesignate('remove');"
              onHelp = "showHelp('Help_CreateDE.html#newCDEForm_Validation'); return false">
          &nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" name="btnClear" value="Clear" onClick="javascript:ClearBoxes();">
          &nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" name="btnBack" value="Back" onClick="javascript:Back();">
          &nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" name="btnDetails" value="Details" onClick="javascript:openBEDisplayWindow();"
				onHelp = "showHelp('Help_Updates.html#newCDEForm_details'); return false">
          &nbsp;&nbsp;
		  <img name="Message" src="Assets/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" style="visibility:hidden;">
      </td>
    </tr>
  </table>
  <table width="98%" border=0>
    <col width="4%"><col width="95%">
  	<tr valign="middle"> 
      <th colspan=2 height="40"> <div align="left"> 
       <% if (sMenuAction.equals("EditDesDE") && sOriginAction.equals("BlockEditDE")){%>
          <label><font size=4>Block Designate <font color="#FF0000">Data Elements</font>
          </font></label>
       <% } else if (sMenuAction.equals("EditDesDE")){%>
          <label><font size=4>Designate<font color="#FF0000"> Data Element</font>
          </font></label>
        <% } %>
        </div></th>
    </tr>
    
    <tr valign="bottom" height="25">
      <td align="left" colspan=2 height="11"><font color="#FF0000">&nbsp;&nbsp;&nbsp;*&nbsp;&nbsp;&nbsp;</font>Indicates Required Field</td>
    </tr>
    
    <tr height="25" valign="bottom">
        <td align=right><font color="#FF0000">*&nbsp;</font><%=item++%>)</td>
        <td><font color="#FF0000">Designate </font>in Context</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td height="26">
        <select name="selContext" size="1"
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false">
          <option value="" selected="selected"></option>
<%         for (int i = 0; vContext.size()>i; i++)
           {
             String sContextName = (String)vContext.elementAt(i);
             String sContextID = (String)vContextID.elementAt(i);
%>
            <option value="<%=sContextID%>" <% if(sContextID.equals(sContext)){%>selected<%}%> ><%=sContextName%></option>
<%
           }
%>
        </select>
      </td>
    </tr>
  	<tr valign="bottom" height="25">
        <td align=right><font color="#C0C0C0"><%=item++%>)</font></td>
        <td><font color="#C0C0C0">Verify Data Element Long Name</font></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td height="24" valign="top">
        <select name="dispLongName" size="4"  style="width:80%" multiple
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false">
          <%if (vACId != null) 
            {
              if (vACId.size() > 1) sOriginAction = "BlockEditDE";
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
      </td>
    </tr>
    <!-- select the language -->
  	<tr valign="bottom" height="40">
        <td align=right><%=item++%>)</td>
        <td><font color="#FF0000">Select </font>Language</td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td height="24" valign="top">
        <select name="dispLanguage" size="1"  style="width:50%"
          onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false">
          <%if (vLanguage != null) 
            {
              for (int i = 0; vLanguage.size()>i; i++)
              {
                String sLang = (String)vLanguage.elementAt(i);
                if (sLang == null) sLang = "";
          %>
                <option value="<%=sLang%>" <%if(sLang.equals(sDesLang)){%>selected<%}%>><%=sLang%></option>
          <%  }
            }   %>
        </select>
      </td>
    </tr>
    
    <!-- alternate Names -->
  	<tr valign="bottom" height="40">
        <td align=right><%=item++%>)</td>
        <td><font color="#FF0000">Create </font>Alternate Name Attributes</td>
    </tr>
    <tr>
      <td align="left">&nbsp;</td>
      <td>
        <table width="90%" border="0">
          <col width="33%"><col width="33%"><col width="33%">
          <tr valign="bottom" height="25">
              <td colspan="3">Select Alternate Name Type</td>
          </tr>
          <tr valign="middle">
            <td colspan="3">
              <select name="selAltType" size="1"  style="width:80%"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false">
                <option value="" selected></option>
                <%if (vAltTypes != null) 
                  {
                    for (int i=0; i<vAltTypes.size(); i++) 
                    {
                      String sType = (String)vAltTypes.elementAt(i);
                      if(!sType.equals("USED_BY"))
                      {
                %>                
                      <option value="<%=sType%>"><%=sType%></option>
                <%  
                      }
                    }
                  }
                %>
              </select>
            </td>
          </tr>
          <tr valign="bottom" height="25">
              <td colspan="3">Create Alternate Name (maximum 255 characters)</td>
          </tr>
          <tr valign="middle">
            <td colspan="3">
              <textarea name="txtAltName" style="width:80%" rows=2 
                onkeydown="javascript:textCounter('txtAltName', 255);"
                onkeyup="javascript:textCounter('txtAltName', 255);"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false"></textarea>
            </td>
          </tr>
          <tr height="30" valign="middle">
            <td align="left"><input type="button" name="btnAddAltName" value="Add Selection" style="width:100" onClick="addAltName();"></td>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr><td height="12" valign="top"></tr>    
          <tr>
            <td colspan="2" align="left">Selected Alternate Name Attributes</td>
            <td align="right"><input  type="button" name="btnRemAltName" value="Remove Item" 
                style="width:85,height:9" onClick="removeAltName();" disabled>&nbsp;&nbsp;&nbsp;</td>
          </tr>
          <tr>
            <td colspan="3">
              <table width="100%" border="1">
                <tr>
                  <td>
                    <table width="99%" border="0">
                      <col width="2%"><col width="28%"><col width="45%"><col width="13%"><col width="15%">
                      <tr valign="middle">
                        <th><%if (vDispAlt.size() > 0){%>
                            <img id="altCheckGif" src="../../cdecurate/Assets/CheckBox.gif" border="0"> 
                          <% } %>
                        </th>
                        <th align="center"><b>Alternate Name Type</b></th>
                        <th align="center"><b>Alternate Name</b></th>
                        <th align="center"><b>Context</b></th>
                        <th align="center"><b>Language</b></th>       
                     <!--   <th align="center"><a href="javascript:sortAlt('type');">Alternate Name Type</a></th>
                        <th align="center"><a href="javascript:sortAlt('name');">Alternate Name</a></th>
                        <th align="center"><a href="javascript:sortAlt('context');">Context</a></th>
                        <th align="center"><a href="javascript:sortAlt('lang');">Language</a></th>   -->    
                     </tr>
                    </table>
                  </td>
                </tr>
                <tr>   
                  <td>
        <%
                    int iDivHt = 30;
                    if (vDispAlt.size() > 4) iDivHt = 150;
                    else if (vDispAlt.size() > 0) iDivHt = ((30 * vDispAlt.size()) + 10);
        %>
                    <div id="Layer1" style="position:relative; z-index:1; overflow:auto; width:100%; height:<%=iDivHt%>;">
                    <table width="100%" border="1">
                      <col width="2%"><col width="28%"><col width="42%"><col width="15%"><col width="10%">
        <%  
                      if (vAllAltName.size()> 0)
                      {
                        int ckCount = 0;
                        Vector dispAltAttr = new Vector();
                        for (int i=0; i<vAllAltName.size(); i++)
                        {
                          ALT_NAME_Bean altNameBean = (ALT_NAME_Bean)vAllAltName.elementAt(i);
                          if (altNameBean == null) altNameBean = new ALT_NAME_Bean();

                          String altType = altNameBean.getALT_TYPE_NAME();
                          String altSubmit = altNameBean.getALT_SUBMIT_ACTION();
                          if ((altType != null && altType.equals("USED_BY")) || (altSubmit != null && altSubmit.equals("DEL")))
                            continue;
                          //get other alt attributes
                          String altIdseq = altNameBean.getALT_NAME_IDSEQ();
                          String altContext = altNameBean.getCONTEXT_NAME();
                         //parse the string for quotation character
                          String altName = altNameBean.getALTERNATE_NAME();
                          altName = serUtil.removeNewLineChar(altName);
                          altName = serUtil.parsedStringDoubleQuote(altName);
                         //parse the string for quotation character
                          String acName = altNameBean.getAC_LONG_NAME();
                          acName = serUtil.parsedStringDoubleQuote(acName);
                          String altLang = altNameBean.getAC_LANGUAGE();
                          if (altLang == null) altLang = "";
                          //check if the combination is already displayed
                          String curAltAttr = altType + " " + altName + " " + altContext;
                          if (dispAltAttr.contains(curAltAttr)) continue;
                          //do the count and chek box name
                          dispAltAttr.addElement(curAltAttr);
                          String ckName = "ACK"+ ckCount;
                          ckCount += 1;  //increase the count by one                          
            %>
                          <tr>
                            <td align="right" valign="top"><input type="checkbox" name="<%=ckName%>" 
                                size="5" onClick="javascript:enableAltNames(checked);"></td>
                            <td valign="top"><%=altType%></td>
                            <td valign="top"><%=altName%></td>
                            <td valign="top"><%=altContext%></td>
                            <td valign="top"><%=altLang%></td>
                          </tr>  
            <%          }
                      } else {
            %>
                          <tr>
                            <td align="right">&nbsp;</td>
                            <td valign="top">&nbsp;</td>
                            <td valign="top">&nbsp;</td>
                            <td valign="top">&nbsp;</td>
                            <td valign="top">&nbsp;</td>
                          </tr>  
            <%         }  %>
                    </table>
                    </div>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <!-- Reference Documents -->
  	<tr valign="bottom" height="40">
      <td align=right><%=item++%>)</td>
      <td><font color="#FF0000">Create </font>Reference Document Attributes</td>
    </tr>
    <tr>
      <td align="left">&nbsp;</td>
      <td>
        <table width="100%" border="0">
          <col width="55%"><col width="45%">
          <tr valign="bottom" height="25">
            <td colspan="2">Select Reference Document Type</td>
          </tr>
          <tr valign="middle">
            <td colspan="2">
              <select name="selRefType" size="1"  style="width:60%"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false">
                <option value="" selected="selected"></option>
                <%if (vRefTypes != null) 
                  {
                    for (int i=0; i<vRefTypes.size(); i++) 
                    {
                      String sType = (String)vRefTypes.elementAt(i);
                %>                
                      <option value="<%=sType%>"><%=sType%></option>
                <%  }
                  }
                %>
              </select>
            </td>
          </tr>
          <tr valign="bottom" height="25">
              <td colspan="2">Create Reference Document Name (maximum 30 characters)</td>
          </tr>
          <tr valign="middle">
            <td colspan="2">
              <input name="txtRefName" type="text" value = "" style="width:70%"   
                onkeydown="javascript:textCounter('txtRefName', 30);"
                onkeyup="javascript:textCounter('txtRefName', 30);"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false">
            </td>
          </tr>
          <tr valign="bottom" height="25">
              <td colspan="2">Create Reference Document Text (maximum 4000 characters)</td>
          </tr>
          <tr valign="middle">
            <td colspan="2">
              <textarea name="txtRefText"  style="width:70%" rows=2  
                onkeydown="javascript:textCounter('txtRefText', 4000);"
                onkeyup="javascript:textCounter('txtRefText', 4000);"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false"></textarea>
            </td>
          </tr>
          <tr valign="bottom" height="25">
              <td>Create Reference Document URL (maximum 240 characters)</td>
              <td><a href="javascript:uploadDocument();">Upload Document</a></td>
          </tr>
          <tr valign="middle">
            <td colspan="2">
              <input name="txtRefURL" type="text" value="" style="width:70%" 
                onkeydown="javascript:textCounter('txtRefURL', 240);"
                onkeyup="javascript:textCounter('txtRefURL', 240);"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false">
              &nbsp;&nbsp;<a href="javascript:openBrowse();">Browse</a>
            </td>
          </tr>
          <tr height="30" valign="middle">
            <td align="left" colspan="3"><input type="button" name="btnAddRefDoc" value="Add Selection" style="width:100" onClick="addRefDoc();"></td>
          </tr>
          <tr><td height="12" valign="top"></tr>    
          <tr>
            <td>Selected Reference Document Attributes</td>
            <td align="right"><input  type="button" name="btnRemRefDoc" value="Remove Item" 
                    style="width:100" onClick="removeRefDoc();" disabled>&nbsp;&nbsp;&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2">
              <table width="100%" border="1">
                <tr>
                  <td>
                    <table width="99%" border="0">
                      <col width="2%"><col width="20%"><col width="18%"><col width="25%"><col width="19%"><col width="8%"><col width="10%">
                      <tr valign="middle">
                        <th><%if (vDispRef.size() > 0){%>
                            <img id="refCheckGif" src="../../cdecurate/Assets/CheckBox.gif" border="0"> 
                          <% } %>
                        </th>
                        <th align="center"><b>Reference Document <br>Type</b></th>
                        <th align="center"><b>Reference Document <br>Name</b></th>
                        <th align="center"><b>Reference Document <br>Text</b></th>
                        <th align="center"><b>Reference Document <br>URL</b></th>
                        <th align="center"><b>Context</b></th>
                        <th align="center"><b>Language</b></th>       
                     <!--   <th align="center"><a href="javascript:sortRef('type');">Reference Document Type</a></th>
                        <th align="center"><a href="javascript:sortRef('name');">Reference Document Name</a></th>
                        <th align="center"><a href="javascript:sortRef('text');">Reference Document Text</a></th>
                        <th align="center"><a href="javascript:sortRef('url');">Reference Document URL</a></th>
                        <th align="center"><a href="javascript:sortRef('context');">Context</a></th>
                        <th align="center"><a href="javascript:sortRef('lang');">Language</a></th>    -->   
                     </tr>
                    </table>
                  </td>
                </tr>
                <tr>   
                  <td>
        <%
                    iDivHt = 30;
                    if (vDispRef.size() > 4) iDivHt = 150;
                    else if (vDispRef.size() > 0) iDivHt = ((30 * vDispRef.size()) + 10);
        %>
                    <div id="Layer2" style="position:relative; z-index:1; overflow:auto; width:100%; height:<%=iDivHt%>;">
                    <table width="100%" border="1">
                      <col width="2%"><col width="18%"><col width="18%"><col width="25%"><col width="18%"><col width="8%"><col width="8%">
        <%  
                      if (vAllRefDoc.size()> 0)
                      {
                        int ckCount = 0;
                        Vector dispRefAttr = new Vector();
                        for (int i=0; i<vAllRefDoc.size(); i++)
                        {
                          REF_DOC_Bean refDocBean = (REF_DOC_Bean)vAllRefDoc.elementAt(i);
                          if (refDocBean == null) refDocBean = new REF_DOC_Bean();
                          String refDocType = refDocBean.getDOC_TYPE_NAME();
                          String refDocSubmit = refDocBean.getREF_SUBMIT_ACTION();
                          if (refDocSubmit != null && refDocSubmit.equals("DEL"))
                            continue;

                          String refDocIdseq = refDocBean.getREF_DOC_IDSEQ();
                          String refDocContext = refDocBean.getCONTEXT_NAME();
                         //parse the string for quotation character
                          String refDocName = refDocBean.getDOCUMENT_NAME();
                          refDocName = serUtil.removeNewLineChar(refDocName);
                          refDocName = serUtil.parsedStringDoubleQuote(refDocName);
                         //parse the string for quotation character
                          String refDocText = refDocBean.getDOCUMENT_TEXT();
                          refDocText = serUtil.removeNewLineChar(refDocText);
                          refDocText = serUtil.parsedStringDoubleQuote(refDocText);
                         //parse the string for quotation character
                          String refDocURL = refDocBean.getDOCUMENT_URL();
                          refDocURL = serUtil.removeNewLineChar(refDocURL);
                          refDocURL = serUtil.parsedStringDoubleQuote(refDocURL);
                         //parse the string for quotation character
                          String acName = refDocBean.getAC_LONG_NAME();
                          acName = serUtil.parsedStringDoubleQuote(acName);
                          String refDocLang = refDocBean.getAC_LANGUAGE();
                          if (refDocLang == null) refDocLang = "";
                          //check if the combination is already displayed
                          String curRefAttr = refDocType + " " + refDocName + " " + refDocContext;
                          if (dispRefAttr.contains(curRefAttr)) continue;
                          //do the count and chek box name
                          dispRefAttr.addElement(curRefAttr);
                          String ckName = "RCK"+ ckCount;
                          ckCount += 1;  //increase the count by one
            %>
                          <tr>
                            <td valign="top"><input type="checkbox" name="<%=ckName%>" 
                                  size="5" onClick="javascript:enableRefDocs(checked);"></td>
                            <td valign="top"><%=refDocType%></td>
                            <td valign="top"><%=refDocName%></td>
                            <td valign="top"><%=refDocText%></td>
                            <td valign="top"><%=refDocURL%></td>
                            <td valign="top"><%=refDocContext%></td>
                            <td valign="top"><%=refDocLang%></td>
                          </tr>  
            <%          }
                      } else {
            %>
                          <tr>
                            <td align="right">&nbsp;</td>
                            <td valign="top">&nbsp;</td>
                            <td valign="top">&nbsp;</td>
                            <td valign="top">&nbsp;</td>
                            <td valign="top">&nbsp;</td>
                            <td valign="top">&nbsp;</td>
                            <td valign="top">&nbsp;</td>
                          </tr>  
            <%         }  %>
                    </table>
                    </div>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
        <!-- Classification Scheme and items -->          
        
    <tr valign="bottom" height="40">
      <td align=right><%=item++%>)</td>
      <td><font color="#FF0000">Select </font>Classification Scheme and Classification Scheme Items</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>
        <table width=90% border="0">
          <col width="1%"><col width="32%"><col width="15%"> <col width="35%"><col width="10%">    
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
            <td align="left"><input type="button" name="btnRemoveCS" value="Remove Item" style="width:100" onClick="removeCSList();"></td>
            <td align="left">Associated Classification Scheme Items</td>
            <td align="center"><input type="button" name="btnRemoveCSI" value="Remove Item" style="width:100" onClick="removeCSIList();"></td>
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
  </table> 
<input type="hidden" name="newCDEPageAction" value="nothing">
<%if(sOriginAction.equals("BlockEditDE")){%>
<input type="hidden" name="DEAction" value="BlockEdit">
<% } else {%>
<input type="hidden" name="DEAction" value="EditDE">
<% } %>
<input type="hidden" name="deIDSEQ" value="<%=sDEIDSEQ%>">
<input type="hidden" name="txtLongName" value="<%=sLongName%>">
<!-- source, language, doctext ids from des/rd tables  -->
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
      <option value="<%=sAC_ID%>" selected><%=sACName%></option>
<%  }
  }   %>
</select>
<input type="hidden" name="originActionHidden" value="<%=sOriginAction%>">
<input type="hidden" name="contextName" value="">
<input type="hidden" name="sortColumn" value="">

<script language = "javascript">
//call function to initiate form objects
createObject("document.designateDEForm");
displayStatusMessage();
loadCSCSI();
//loadAltNameArray();
//loadRefDocArray();
</script>
</form>
</body>
</html>