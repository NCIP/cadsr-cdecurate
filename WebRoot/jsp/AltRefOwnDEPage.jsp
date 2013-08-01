<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/AltRefOwnDEPage.jsp,v 1.5 2009-04-21 03:47:36 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to secondary window error page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%>

<curate:checkLogon name="Userbean" page="/ErrorPageWindow.jsp" />
<html>
	<head>
		<title>
			Edit Designated Data Element
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<%@ page import="java.util.*"%>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
		<%@ page session="true"%>
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<SCRIPT LANGUAGE="JavaScript" SRC="js/AddNewListOption.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/SelectCS_CSI.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%
    UtilService serUtil = new UtilService();
    //load the lists
   /* Vector vContext = (Vector)session.getAttribute("vWriteContextDE");
    Vector vContextID = (Vector)session.getAttribute("vWriteContextDE_ID");
    Vector vStatus = (Vector)session.getAttribute("vStatusDE");
    Vector vCS = (Vector)session.getAttribute("vCS");
    Vector vCS_ID = (Vector)session.getAttribute("vCS_ID"); */
    Vector vAltTypes = (Vector)session.getAttribute("AltNameTypes");
    Vector vRefTypes = (Vector)session.getAttribute("RefDocTypes");
    //Vector results = (Vector)session.getAttribute("results");
    String sMenuAction = (String)session.getAttribute(Session_Data.SESSION_MENU_ACTION);
   // sMenuAction = "EditDesDE";
    //if(sMenuAction.equals("nothing"))
    //{
    //  sMenuAction = "editDE";
    //  session.setAttribute("MenuAction", "editDE");
    //}
      
    String sOriginAction = (String)session.getAttribute("originAction");
    if (sOriginAction == null) sOriginAction = "";
    DE_Bean m_DE = (DE_Bean)session.getAttribute("m_DE");
    if (m_DE == null) m_DE = new DE_Bean();
   // session.setAttribute("DEEditAction", "");
    String sDEIDSEQ = m_DE.getDE_DE_IDSEQ();
    if (sDEIDSEQ == null) sDEIDSEQ = "";

    String sContext = m_DE.getDE_CONTEXT_NAME();
  //  if (sOriginAction.equals("BlockEditDE")) sContext = "";
    if (sContext == null) sContext = "";
    String sContID = m_DE.getDE_CONTE_IDSEQ();
    if (sContID == null) sContID = "";

    String sLongName = m_DE.getDE_LONG_NAME();
    sLongName = serUtil.parsedStringDoubleQuoteJSP(sLongName);    //call the function to handle doubleQuote
    if (sLongName == null) sLongName = "";
      
  /*  String sStatus = m_DE.getDE_ASL_NAME();
    if (sStatus == null && sOriginAction.equals("BlockEditDE")) sStatus = "";
    else if (sStatus == null) sStatus = "DRAFT NEW"; */

    //get cs-csi attributes
    Vector vSelCSList = m_DE.getAC_CS_NAME();
    if (vSelCSList == null) vSelCSList = new Vector();
 //   System.out.println("cs jsp " + vSelCSList.size());
    Vector vSelCSIDList = m_DE.getAC_CS_ID();
    Vector vACCSIList = m_DE.getAC_AC_CSI_VECTOR();
    Vector vACId = (Vector)session.getAttribute("vACId");
    Vector vACName = (Vector)session.getAttribute("vACName");
    //initialize the beans
    CSI_Bean thisCSI = new CSI_Bean();
    AC_CSI_Bean thisACCSI = new AC_CSI_Bean();
//System.out.println("before alt name get ");    
    //get alternate name attributs
    Vector vAllAltName = (Vector)session.getAttribute("AllAltNameList"); 
    if (vAllAltName == null) vAllAltName = new Vector();
//System.out.println("after alt name get ");    
    //get reference doc attributes
    Vector vAllRefDoc = (Vector)session.getAttribute("AllRefDocList"); 
    if (vAllRefDoc == null) vAllRefDoc = new Vector();
//System.out.println("after ref doc list");    
    
    int item = 1;
        
%>

		<Script Language="JavaScript">
 var evsWindow2 = null;
  var selRefDocArray = new Array();  //for selected reference doc list
  var selAltNameArray = new Array();  //for selected alternate name list
  var browseWindow = null;
 var helpUrl = "<%=ToolURL.getCurationToolHelpURL(pageContext)%>";
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
        objRefDoc.ref_name = "<%=refDocBean.getDOCUMENT_NAME()%>";
        objRefDoc.ref_text = "<%=refDocBean.getDOCUMENT_TEXT()%>";
        objRefDoc.ref_URL = "<%=refDocBean.getDOCUMENT_URL()%>";
        objRefDoc.type_name = "<%=refDocBean.getDOC_TYPE_NAME()%>";
        <% //parse the string for quotation character
          String acName = refDocBean.getAC_LONG_NAME();
          acName = serUtil.parsedStringDoubleQuoteJSP(acName);%>
        objRefDoc.ac_name = "<%=acName%>";
        objRefDoc.ac_idseq = "<%=refDocBean.getAC_IDSEQ()%>";
        objRefDoc.ac_language = "<%=refDocBean.getAC_LANGUAGE()%>";
        objRefDoc.submit_action = "<%=refDocBean.getREF_SUBMIT_ACTION()%>";
        selRefDocArray[aIndex] = objRefDoc;
       // alert(selRefDocArray.length + " RefDoc " + aIndex + " : " + selRefDocArray[aIndex].alt_text);
<%    }
    }
%>
    //refreshRefDocSelect();  //fill the select fields
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
          objAltName.alt_name = "<%=altNameBean.getALTERNATE_NAME()%>";
          objAltName.type_name = "<%=altNameBean.getALT_TYPE_NAME()%>";
          <% //parse the string for quotation character
            String acName = altNameBean.getAC_LONG_NAME();
            acName = serUtil.parsedStringDoubleQuoteJSP(acName);%>
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
//alert("in load");
    //refreshAltNameSelect();  //fill the select fields
  }
  function ClearBoxes()
  {
  //  alert("clear boxes");
    document.designateDEForm.pageAction.value = "clearBoxes";
    document.designateDEForm.submit();
  }
  
  function submitAltRefDE()
  {
    alert("what shall I do? ");
  }
  
</Script>
	</head>

	<body>
		<form name="designateDEForm" method="POST" action="../../cdecurate/NCICurationServlet?reqType=AltRefOwnDE">
			<table width="100%" border=0>
				<!--DWLayoutTable-->
				<tr>
					<td align="left" valign="top" colspan=2>
						<input type="button" name="btnUpdate" value="Update Attributes" onClick="javascript:submitAltRefDE();" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_Validation',helpUrl); return false">
						&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="button" name="btnClear" value="Clear" onClick="ClearBoxes();">
						&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="button" name="btnClose" value="Close Window" onClick="window.close();">
						&nbsp;&nbsp;&nbsp;&nbsp;
						<img name="Message" src="images/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" style="visibility:hidden;">
					</td>
				</tr>
			</table>
			<table width="900" border=0>
				<col width="4%">
				<col width="95%">
				<tr valign="middle">
					<th colspan=2 height="40">
						<div align="left">
							<label>
								<font size=4>
									Create
									<font color="#FF0000">
										Alternate Names or Reference Docuemnts
									</font>
								</font>
							</label>
						</div>
					</th>
				</tr>
				<!-- alternate Names -->
				<tr valign="bottom" height="40">
					<td align=right>
						<%=item++%>
						)
					</td>
					<td>
						<font color="#FF0000">
							Add
						</font>
						Alternate Name Attributes
					</td>
				</tr>
				<tr>
					<td align="left">
						&nbsp;
					</td>
					<td>
						<table width="70%" border="0">
							<col width="33%">
							<col width="33%">
							<col width="33%">
							<tr valign="bottom" height="25">
								<td colspan="3">
									Select Alternate Name Type
								</td>
							</tr>
							<tr valign="middle">
								<td colspan="3">
									<select name="selAltType" size="1" style="width:80%" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContext',helpUrl); return false">
										<option value="" selected></option>
										<%if (vAltTypes != null) 
                  {
                    for (int i=0; i<vAltTypes.size(); i++) 
                    {
                      String sType = (String)vAltTypes.elementAt(i);
                      if(!sType.equals("USED_BY"))
                      {
                %>
										<option value="<%=sType%>">
											<%=sType%>
										</option>
										<%  
                      }
                    }
                  }
                %>
									</select>
								</td>
							</tr>
							<tr valign="bottom" height="25">
								<td colspan="3">
									Create Alternate Name (maximum 255 characters)
								</td>
							</tr>
							<tr valign="middle">
								<td colspan="3">
									<textarea name="txtAltName" style="width:80%" rows=2 onkeydown="javascript:textCounter('txtAltName', 255);" onkeyup="javascript:textCounter('txtAltName', 255);" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContext',helpUrl); return false"></textarea>
								</td>
							</tr>
							<tr height="30" valign="middle">
								<td align="left">
									<input type="button" name="btnAddAltName" value="Add Selection" onClick="addAltName();">
								</td>
								<td colspan="2">
									&nbsp;
								</td>
							</tr>
							<tr>
								<td height="12" valign="top">
							</tr>
							<tr>
								<td align="left">
									Selected Alternate Name Type
								</td>
								<td align="left">
									&nbsp;Alternate Name
								</td>
								<td align="right">
									<input type="button" name="btnRemAltName" value="Remove Item"  onClick="removeAltName();">
									&nbsp;&nbsp;&nbsp;
								</td>
							</tr>
							<tr>
								<td align="left">
									<select name="selAltNameType" size="4" style="width:99%" onclick="javascript:selectedAltList('altType');" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContext',helpUrl); return false">
									</select>
								</td>
								<td align="left" colspan="2">
									<select name="selAltNameText" size="4" style="width:100%" onclick="javascript:selectedAltList('altText');" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContext',helpUrl); return false">
									</select>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<!-- Reference Documents -->
				<tr valign="bottom" height="40">
					<td align=right>
						<%=item++%>
						)
					</td>
					<td>
						<font color="#FF0000">
							Add
						</font>
						Reference Document Attributes
					</td>
				</tr>
				<tr>
					<td align="left">
						&nbsp;
					</td>
					<td>
						<table width="90%" border="0">
							<col width="50%">
							<col width="25%">
							<col width="25%">
							<tr valign="bottom" height="25">
								<td colspan="3">
									Select Reference Document Type
								</td>
							</tr>
							<tr valign="middle">
								<td colspan="3">
									<select name="selRefType" size="1" style="width:75%" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContext',helpUrl); return false">
										<option value="" selected="selected"></option>
										<%if (vRefTypes != null) 
                  {
                    for (int i=0; i<vRefTypes.size(); i++) 
                    {
                      String sType = (String)vRefTypes.elementAt(i);
                %>
										<option value="<%=sType%>">
											<%=sType%>
										</option>
										<%  }
                  }
                %>
									</select>
								</td>
							</tr>
							<tr valign="bottom" height="25">
								<td colspan="3">
									Create Reference Document Name (maximum 30 characters)
								</td>
							</tr>
							<tr valign="middle">
								<td colspan="3">
									<textarea name="txtRefName" style="width:90%" rows=2 onkeydown="javascript:textCounter('txtRefName', 30);" onkeyup="javascript:textCounter('txtRefName', 30);" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContext',helpUrl); return false"></textarea>
								</td>
							</tr>
							<tr valign="bottom" height="25">
								<td colspan="3">
									Create Reference Document Text (maximum 4000 characters)
								</td>
							</tr>
							<tr valign="middle">
								<td colspan="3">
									<textarea name="txtRefText" style="width:90%" rows=2 onkeydown="javascript:textCounter('txtRefText', 4000);" onkeyup="javascript:textCounter('txtRefText', 4000);" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContext',helpUrl); return false"></textarea>
								</td>
							</tr>
							<tr valign="bottom" height="25">
								<td colspan="2">
									Create Reference Document URL (maximum 240 characters)
								</td>
								<td>
									<a href="javascript:uploadDocument();">
										Upload Document
									</a>
								</td>
							</tr>
							<tr valign="middle">
								<td colspan="3">
									<input name="txtRefURL" type="text" value="" style="width:90%" onkeydown="javascript:textCounter('txtRefURL', 240);" onkeyup="javascript:textCounter('txtRefURL', 240);" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContext',helpUrl); return false">
									&nbsp;&nbsp;
									<a href="javascript:openBrowse();">
										Browse
									</a>
								</td>
							</tr>
							<tr height="30" valign="middle">
								<td align="left" colspan="3">
									<input type="button" name="btnAddRefDoc" value="Add Selection" onClick="addRefDoc();">
								</td>
							</tr>
							<tr>
								<td height="12" valign="top">
							</tr>
							<tr>
								<td align="left">
									Selected Reference Document Type
								</td>
								<td align="left">
									&nbsp;Reference Document Name
								</td>
								<td align="center">
									<input type="button" name="btnRemRefDoc" value="Remove Item" onClick="removeRefDoc();">
								</td>
							</tr>
							<tr>
								<td align="left">
									<select name="selRefDocType" size="4" style="width:100%" onclick="javascript:selectedRefList('refType');" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContext',helpUrl); return false">
									</select>
								</td>
								<td align="left" colspan="2">
									<select name="selRefDocName" size="4" style="width:95%" onclick="javascript:selectedRefList('refName');" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContext',helpUrl); return false">
									</select>
								</td>
							</tr>
							<tr>
								<td align="left">
									Reference Document Text
								</td>
								<td align="left" colspan="2">
									Reference Document URL
								</td>
							</tr>
							<tr>
								<td align="left">
									<select name="selRefDocText" size="4" style="width:100%" onclick="javascript:selectedRefList('refText');" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContext',helpUrl); return false">
									</select>
								</td>
								<td align="left" colspan="2">
									<select name="selRefDocURL" size="4" style="width:95%" onclick="javascript:selectedRefList('refURL');" onHelp="showHelp('html/Help_CreateDE.html#newCDEForm_selContext',helpUrl); return false">
									</select>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<!-- alternate name attributes -->
			<select name="selAltIDHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selAltNameHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selAltTypeHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selAltACHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selAltContIDHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selAltContHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selAltActHidden" size="1" style="visibility:hidden;" multiple></select>
			<!-- Refernece Documents attributes -->
			<select name="selRefIDHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selRefNameHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selRefTypeHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selRefTextHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selRefURLHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selRefACHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selRefContIDHidden" size="1" style="visibility:hidden;" multiple></select>
			<select name="selRefActHidden" size="1" style="visibility:hidden;" multiple></select>

			<script language="javascript">
//call function to initiate form objects
loadAltNameArray();
loadRefDocArray();
</script>
		</form>
	</body>
</html>
