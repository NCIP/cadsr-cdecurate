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

    String sMenuAction = (String)session.getAttribute("MenuAction");
    String sOriginAction = (String)session.getAttribute("originAction");
    if (sOriginAction == null) sOriginAction = "";
    DE_Bean m_DE = (DE_Bean)session.getAttribute("m_DE");
    if (m_DE == null) m_DE = new DE_Bean();
   // session.setAttribute("DEEditAction", "");
    String sDEIDSEQ = m_DE.getDE_DE_IDSEQ();
    if (sDEIDSEQ == null) sDEIDSEQ = "";

    String sContext = m_DE.getDE_CONTEXT_NAME();
    if (sContext == null) sContext = "";
    String sContID = m_DE.getDE_CONTE_IDSEQ();
    if (sContID == null) sContID = "";

    String sLongName = m_DE.getDE_LONG_NAME();
    sLongName = serUtil.parsedString(sLongName);    //call the function to handle doubleQuote
    if (sLongName == null) sLongName = "";
      
    String sStatus = m_DE.getDE_ASL_NAME();
    if (sStatus == null && sOriginAction.equals("BlockEditDE")) sStatus = "";
    else if (sStatus == null) sStatus = "DRAFT NEW";

    //get cs-csi attributes
    Vector vSelCSList = m_DE.getDE_CS_NAME();
    if (vSelCSList == null) vSelCSList = new Vector();
 //   System.out.println("cs jsp " + vSelCSList.size());
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
    //get reference doc attributes
    Vector vAllRefDoc = (Vector)session.getAttribute("AllRefDocList"); 
    if (vAllRefDoc == null) vAllRefDoc = new Vector();
    
    int item = 1;
        
%>

<Script Language="JavaScript">
 var evsWindow2 = null;
  //get all the cs_csi from the bean to array.
  var csiArray = new Array();  
  var selCSIArray = new Array();  //for selected csi list
  var selACCSIArray = new Array();  //for selected AC-csi list
  var writeContArray = new Array();
  var selRefDocArray = new Array();  //for selected reference doc list
  var selAltNameArray = new Array();  //for selected alternate name list
  var browseWindow = null;
  
  function loadCSCSI()
  {
  <%
    Vector vCSIList = (Vector)session.getAttribute("CSCSIList");
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
         // System.out.println("jsp " + thisCSI.getCSI_NAME() + " : " + thisACCSI.getAC_LONG_NAME());
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

  //store reference documents in the array
  function loadRefDocArray()
  {
<%  if (vAllRefDoc != null)
    {
      for (int i=0; i<vAllRefDoc.size(); i++)
      {
        REF_DOC_Bean refDocBean = (REF_DOC_Bean)vAllRefDoc.elementAt(i);
        if (refDocBean == null) refDocBean = new REF_DOC_Bean();
        //System.out.println(i + " RefDoc : " + refDocBean.getDOCUMENT_TEXT());
%>
        var aIndex = <%=i%>;  //get the index
        var objRefDoc = new refDocs();
        objRefDoc.idseq = "<%=refDocBean.getREF_DOC_IDSEQ()%>";
        objRefDoc.conte_name = "<%=refDocBean.getCONTEXT_NAME()%>";
        objRefDoc.conte_id = "<%=refDocBean.getCONTE_IDSEQ()%>";
        <% //parse the string for quotation character
          String docName = refDocBean.getDOCUMENT_NAME();
          docName = serUtil.removeNewLineChar(docName);
          docName = serUtil.parsedStringDoubleQuote(docName);%>
        objRefDoc.ref_name = "<%=docName%>";
        <% //parse the string for quotation character
          String docText = refDocBean.getDOCUMENT_TEXT();
          docText = serUtil.removeNewLineChar(docText);
          docText = serUtil.parsedStringDoubleQuote(docText);%>
        objRefDoc.ref_text = "<%=docText%>";
        <% //parse the string for quotation character
          String docURL = refDocBean.getDOCUMENT_URL();
          docURL = serUtil.removeNewLineChar(docURL);
          docURL = serUtil.parsedStringDoubleQuote(docURL);%>
        objRefDoc.ref_URL = "<%=docURL%>";
        objRefDoc.type_name = "<%=refDocBean.getDOC_TYPE_NAME()%>";
        <% //parse the string for quotation character
          String acName = refDocBean.getAC_LONG_NAME();
          acName = serUtil.parsedStringDoubleQuote(acName);%>
        objRefDoc.ac_name = "<%=acName%>";
        objRefDoc.ac_idseq = "<%=refDocBean.getAC_IDSEQ()%>";
        objRefDoc.ac_language = "<%=refDocBean.getAC_LANGUAGE()%>";
        objRefDoc.submit_action = "<%=refDocBean.getREF_SUBMIT_ACTION()%>";
        selRefDocArray[aIndex] = objRefDoc;
<%    }
    }
%>
    refreshRefDocSelect();  //fill the select fields
  }
  //store alternate names in the array
  function loadAltNameArray()
  {
<%  if (vAllAltName != null)
    {
      for (int i=0; i<vAllAltName.size(); i++)
      {
        ALT_NAME_Bean altNameBean = (ALT_NAME_Bean)vAllAltName.elementAt(i);
        if (altNameBean == null) altNameBean = new ALT_NAME_Bean();
        //System.out.println(i + " alt before : " + altNameBean.getALT_TYPE_NAME());
        String altType = altNameBean.getALT_TYPE_NAME();
        if (altType != null && altType.equals("USED_BY"))
          continue;
        //System.out.println(i + " alt after : " + altNameBean.getALT_TYPE_NAME());          
%>
          var aIndex = <%=i%>;  //get the index
          var objAltName = new altNames();
          objAltName.idseq = "<%=altNameBean.getALT_NAME_IDSEQ()%>";
          objAltName.conte_name = "<%=altNameBean.getCONTEXT_NAME()%>";
          objAltName.conte_id = "<%=altNameBean.getCONTE_IDSEQ()%>";
          <% //parse the string for quotation character
            String altName = altNameBean.getALTERNATE_NAME();
            altName = serUtil.removeNewLineChar(altName);
            altName = serUtil.parsedStringDoubleQuote(altName);%>
          objAltName.alt_name = "<%=altName%>";
          objAltName.type_name = "<%=altNameBean.getALT_TYPE_NAME()%>";
          <% //parse the string for quotation character
            String acName = altNameBean.getAC_LONG_NAME();
            acName = serUtil.parsedStringDoubleQuote(acName);%>
          objAltName.ac_name = "<%=acName%>";
          objAltName.ac_idseq = "<%=altNameBean.getAC_IDSEQ()%>";
          objAltName.ac_language = "<%=altNameBean.getAC_LANGUAGE()%>";
          objAltName.submit_action = "<%=altNameBean.getALT_SUBMIT_ACTION()%>";
          selAltNameArray[aIndex] = objAltName;
         // alert(selAltNameArray.length + " alt name " + aIndex + " : " + selAltNameArray[aIndex].alt_name);
<%    
      }
    }
%>
    refreshAltNameSelect();  //fill the select fields
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
  <table width="900" border=0>
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
            <option value="<%=sContextID%>" <%if(sContextName.equals(sContext)){%>selected<%}%> ><%=sContextName%></option>
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
    <!-- alternate Names -->
  	<tr valign="bottom" height="40">
        <td align=right><%=item++%>)</td>
        <td><font color="#FF0000">Create </font>Alternate Name Attributes</td>
    </tr>
    <tr>
      <td align="left">&nbsp;</td>
      <td>
        <table width="70%" border="0">
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
            <td align="left">Selected Alternate Name Type</td>
            <td align="left">&nbsp;Alternate Name </td>
            <td align="right"><input  type="button" name="btnRemAltName" value="Remove Item" 
                style="width:85,height:9" onClick="removeAltName();">&nbsp;&nbsp;&nbsp;</td>
          </tr>
          <tr>
            <td align="left">
              <select name="selAltNameType" size="4" style="width:99%" onclick="javascript:selectedAltList('altType');"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false">
              </select>  
            </td>
            <td align="left" colspan="2">
              <select name="selAltNameText" size="4" style="width:100%" onclick="javascript:selectedAltList('altText');"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false">
              </select> 
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
        <table width="90%" border="0">
          <col width="50%"><col width="25%"><col width="25%">
          <tr valign="bottom" height="25">
            <td colspan="3">Select Reference Document Type</td>
          </tr>
          <tr valign="middle">
            <td colspan="3">
              <select name="selRefType" size="1"  style="width:75%"
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
              <td colspan="3">Create Reference Document Name (maximum 30 characters)</td>
          </tr>
          <tr valign="middle">
            <td colspan="3">
              <input name="txtRefName" type="text" value = "" style="width:90%"   
                onkeydown="javascript:textCounter('txtRefName', 30);"
                onkeyup="javascript:textCounter('txtRefName', 30);"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false">
            </td>
          </tr>
          <tr valign="bottom" height="25">
              <td colspan="3">Create Reference Document Text (maximum 4000 characters)</td>
          </tr>
          <tr valign="middle">
            <td colspan="3">
              <textarea name="txtRefText"  style="width:90%" rows=2  
                onkeydown="javascript:textCounter('txtRefText', 4000);"
                onkeyup="javascript:textCounter('txtRefText', 4000);"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false"></textarea>
            </td>
          </tr>
          <tr valign="bottom" height="25">
              <td colspan="2">Create Reference Document URL (maximum 240 characters)</td>
              <td><a href="javascript:uploadDocument();">Upload Document</a></td>
          </tr>
          <tr valign="middle">
            <td colspan="3">
              <input name="txtRefURL" type="text" value="" style="width:90%" 
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
            <td align="left">Selected Reference Document Type</td>
            <td align="left">&nbsp;Reference Document Name</td>
            <td align="center"><input  type="button" name="btnRemRefDoc" value="Remove Item" style="width:100" onClick="removeRefDoc();"></td>
          </tr>
          <tr>
            <td align="left">
              <select name="selRefDocType" size="4" style="width:100%" onclick="javascript:selectedRefList('refType');"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false">
              </select>  
            </td>
            <td align="left" colspan="2">
              <select name="selRefDocName" size="4" style="width:95%" onclick="javascript:selectedRefList('refName');"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false">
              </select> 
            </td>
          </tr>
          <tr>
            <td align="left">Reference Document Text</td>
            <td align="left" colspan="2">Reference Document URL</td>
          </tr>
          <tr>
            <td align="left">
              <select name="selRefDocText" size="4" style="width:100%" onclick="javascript:selectedRefList('refText');"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false">
              </select>  
            </td>
            <td align="left" colspan="2">
              <select name="selRefDocURL" size="4" style="width:95%" onclick="javascript:selectedRefList('refURL');"
                onHelp = "showHelp('Help_CreateDE.html#newCDEForm_selContext'); return false">
              </select> 
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
  //    System.out.println("selected " + sACName);
%>
      <option value="<%=sAC_ID%>" selected><%=sACName%></option>
<%  }
  }   %>
</select>
<input type="hidden" name="originActionHidden" value="<%=sOriginAction%>">
<!-- alternate name attributes -->
<select name="selAltIDHidden" size ="1" style="visibility:hidden;"  multiple></select>
<select name="selAltNameHidden" size ="1" style="visibility:hidden;"  multiple></select>
<select name="selAltTypeHidden" size ="1" style="visibility:hidden;"  multiple></select>
<select name="selAltACHidden" size="1" style="visibility:hidden;"  multiple></select>
<select name="selAltContIDHidden" size="1" style="visibility:hidden;"  multiple></select>
<select name="selAltContHidden" size="1" style="visibility:hidden;"  multiple></select>
<select name="selAltActHidden" size="1" style="visibility:hidden;"  multiple></select>
<!-- Refernece Documents attributes -->
<select name="selRefIDHidden" size ="1" style="visibility:hidden;"  multiple></select>
<select name="selRefNameHidden" size ="1" style="visibility:hidden;"  multiple></select>
<select name="selRefTypeHidden" size ="1" style="visibility:hidden;"  multiple></select>
<select name="selRefTextHidden" size="1" style="visibility:hidden;"  multiple></select>
<select name="selRefURLHidden" size="1" style="visibility:hidden;"  multiple></select>
<select name="selRefACHidden" size="1" style="visibility:hidden;"  multiple></select>
<select name="selRefContIDHidden" size="1" style="visibility:hidden;"  multiple></select>
<select name="selRefActHidden" size="1" style="visibility:hidden;"  multiple></select>

<script language = "javascript">
//call function to initiate form objects
createObject("document.designateDEForm");
displayStatusMessage();
loadCSCSI();
loadAltNameArray();
loadRefDocArray();
</script>
</form>
</body>
</html>