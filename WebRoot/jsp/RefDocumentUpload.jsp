<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/RefDocumentUpload.jsp,v 1.5 2009-04-21 03:47:35 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
<%@ page import="java.util.Vector"%>
<script LANGUAGE="JavaScript" SRC="js/RefDocumentUpload.js"></SCRIPT>
<form enctype="multipart/form-data" name="RefDocumentUploadForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=RefDocumentUpload">

	<%

    session = request.getSession();
    String filename = "Document.doc";
    String dispType = (String)session.getAttribute("displayType");
    session.setAttribute("RefDocTargetFile", "");
    String Zebra = "false";

    String acType = (String)session.getAttribute("dispACType");
    if (dispType == null) dispType = "";
    

    String sACIDSEQ = "",  sVersion ="", sLongName ="", sPublic_id = ""; 
    DE_Bean m_DE = null;
    DEC_Bean m_DEC = null;
    VD_Bean m_VD = null;
    String fileName = "";


    if (acType.equals("DataElement"))
    {
      m_DE = (DE_Bean)session.getAttribute("m_DE");
      if (m_DE == null) m_DE = new DE_Bean();
      sVersion = m_DE.getDE_VERSION();
      sPublic_id = m_DE.getDE_MIN_CDE_ID();
      sLongName = m_DE.getDE_LONG_NAME();
  
    }
    else if (acType.equals("DataElementConcept"))
    {
      m_DEC = (DEC_Bean)session.getAttribute("m_DEC");
      if (m_DEC == null) m_DEC = new DEC_Bean();
      sVersion = m_DEC.getDEC_VERSION();
      sPublic_id = m_DEC.getDEC_DEC_ID();
      sLongName = m_DEC.getDEC_LONG_NAME();
    }
    else if (acType.equals("ValueDomain"))
    {
      m_VD = (VD_Bean)session.getAttribute("m_VD");
      if (m_VD == null) m_VD = new VD_Bean();
      sVersion = m_VD.getVD_VERSION();
      sPublic_id = m_VD.getVD_VD_ID();
      sLongName = m_VD.getVD_LONG_NAME();
    }
    else{
      sVersion = "...";
      sPublic_id = acType;
      sLongName = "...";
	}

%>
	<%
      Vector vRefDoc = (Vector)request.getAttribute("RefDocList");
      session.setAttribute("RefDocList", vRefDoc);
      String intText = "";
      if (vRefDoc == null)
        intText = "Loading .....";
      else
        intText = "No Reference Documents Found. ";
      if (vRefDoc == null) vRefDoc = new Vector();
      //get the type
      String refType = (String)request.getAttribute("itemType");
      if (refType == null || refType.equals("")) 
        refType = "All Types";
      else
        refType = refType + " Type ";
      //get the name
      String acName = "";
      REF_DOC_Bean refBean = new REF_DOC_Bean();      
      if (vRefDoc != null && vRefDoc.size() > 0)
      {
        refBean = (REF_DOC_Bean)vRefDoc.elementAt(0);
        acName = refBean.getAC_LONG_NAME();
        if (acName == null) acName = "";
      } 
      
      Vector vRefDocURL = (Vector)session.getAttribute("RefDocRows");

  

%>

	<INPUT type="button" name="btnBack" value="Back" onclick="javascript:Back();">


	<p style="font-size: 12pt; font-weight: bold">
		Reference Document Attachments for:&nbsp;
		<%=sLongName%>
		&nbsp;&nbsp;(&nbsp;
		<%=sPublic_id%>
		&nbsp;v
		<%=sVersion%>
		&nbsp;)
	</p>
	<p>
		To view an attachment, select the desired link to the right of the Reference Document.
	</p>
	<p>
		To delete an attachment, select the Delete Icon (<img src="images/delete_small.gif">) next to the desired link.
	</p>
	<table style="text-align: left ; 
	border-collapse: collapse; 
	width: 100%; 
	border-top: solid black 1px; 
	border-bottom: solid black 1px" class="sortable" ID="RefDocList">
		<colgroup>
			<col style="padding: 0.1in 0.1in 0.1in 0.1in" />
			<col style="padding: 0.1in 0.1in 0.1in 0.1in" />
			<col style="padding: 0.1in 0.1in 0.1in 0.1in" />
			<col style="padding: 0.1in 0.1in 0.1in 0.1in" />
			<col style="padding: 0.1in 0.1in 0.1in 0.1in" />
			<col style="padding: 0.1in 0.1in 0.1in 0.1in" />
			<col style="padding: 0.1in 0.1in 0.1in 0.1in" />
		</colgroup>
		<tbody style="padding: 0.1in 0.1in 0.1in 0.1in" />
			<tr>
				<th style="border-bottom: black solid 1px; font-family: Arial, Helvetica, sans-serif; font-size: 10pt;" height="30">
					<div>
						<!-- <img id="CheckGif" src="images/CheckBox.gif" border="0" alt="Select One"/> -->

					</div>
				</th>
				<th style="border-bottom: black solid 1px; font-family: Arial, Helvetica, sans-serif; font-size: 10pt;">
					Reference Document Name
				</th>
				<th style="border-bottom: black solid 1px; font-family: Arial, Helvetica, sans-serif; font-size: 10pt;">
					Reference Document Type
				</th>
				<th style="border-bottom: black solid 1px; font-family: Arial, Helvetica, sans-serif; font-size: 10pt;">
					Reference Document Text
				</th>
				<th style="border-bottom: black solid 1px; font-family: Arial, Helvetica, sans-serif; font-size: 10pt;">
					Reference Document URL
				</th>
				<th style="border-bottom: black solid 1px; font-family: Arial, Helvetica, sans-serif; font-size: 10pt;">
					Context
				</th>
				<th style="border-bottom: black solid 1px; font-family: Arial, Helvetica, sans-serif; font-size: 10pt;">
					Links
				</th>
			</tr>
			<%

    for(int i=0; i<(vRefDoc.size()); i++)
    {
      refBean = (REF_DOC_Bean)vRefDoc.elementAt(i);
      filename = (String)vRefDocURL.get(i);
      String docName =  refBean.getDOCUMENT_NAME();
      if (docName == null) docName = "";
      String docType =  refBean.getDOC_TYPE_NAME();
      if (docType == null) docType = "";
      String docText =  refBean.getDOCUMENT_TEXT();
      if (docText == null) docText = "";
      String docURL =  refBean.getDOCUMENT_URL();
      if (docURL == null) docURL = "";
      String docContext =  refBean.getCONTEXT_NAME();
      if (docContext == null) docContext = "";
      String docLink = "";
      
      if (docURL.toLowerCase().startsWith("http:") || docURL.startsWith("https:") || docURL.startsWith("file:")){
      	docLink = "";
      }
      else {
      	docLink = "http://";
      }
	if (Zebra == "true"){
      	%>
			<tr style="background-color: #f5f5dc">
				<td>
					<%;
		Zebra = "false";
      }
      else {
      	      	%>
			<tr>
				<td>
					<%;
		Zebra = "true";
      }

	%>
					<% 
	if (refBean.getIswritable()){
%>
					<input type="checkbox" name="ck<%=i%>" onclick="adjustCheckCount(this);" />
					<%
	  }
else {%>
					<input type="checkbox" name="ck<%=i%>" DISABLED />
					<%
	  }
%>
				</td>
				<td>
					<%=docName%>
				</td>
				<td>
					<%=docType%>
				</td>
				<td>
					<%=docText%>
				</td>
				<td>
					<a href="<%=docLink%><%=docURL%>" target="_blank">
						<%=docURL%>
					</a>
				</td>
				<td>
					<%=docContext%>
				</td>
				<% if (filename != ""){ %>
				<%=filename%>
				<% }
else {%>
				<td>
					&nbsp;
				</td>
				<%
	}
%>
			</tr>
			<%
	  }
%>
	</table>
	<p>
		To attach a file, select the desired Reference Document above, browse the local file and select Upload.
	</p>
	<p>
		File Name:
		<INPUT TYPE="FILE" NAME="uploadfile" onFocus="javascript:doValidateInput();" onContextMenu="return false;">
	</p>
	<p>
		Please perform a virus scan on files prior to Upload. File scans are not performed by the Curation Tool.
	</p>
	<p>
		<INPUT type="button" name="Uploadbtn" value="Upload" onclick="javascript:doUpload();" disabled>
	</p>


	<input type="hidden" name="newRefDocPageAction" value="nothing">
	<input type="hidden" name="RefDocTargetFile" value="nothing">
	<script language="javascript">
</script>
</form>


