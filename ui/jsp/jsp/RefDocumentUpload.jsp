<%@ page import="gov.nih.nci.cdecurate.*"%>
<%@ page import= "java.util.Vector" %>
<SCRIPT LANGUAGE="JavaScript" SRC="Assets/RefDocumentUpload.js"></SCRIPT>
<FORM ENCTYPE="multipart/form-data"
 name="RefDocumentUploadForm" method="post" action="/cdecurate/NCICurationServlet?reqType=RefDocumentUpload">

<%
    
    session = request.getSession();
    String filename = "Document.doc";
    String dispType = (String)session.getAttribute("displayType");
    session.setAttribute("RefDocTargetFile", "");

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


<p style="font-size: 12pt; font-weight: bold">Reference Document Attachments for:&nbsp;
	<%=sLongName%>&nbsp;&nbsp;(&nbsp;<%=sPublic_id%>&nbsp;v<%=sVersion%>&nbsp;)
</p>
<p>To view an attachment, select the desired link to the right of the Reference Document.  Although everyone is 
encouraged to scan files for viruses prior to Upload, it is not required and file scans are not performed by the 
Admin or Curation Tools.</p>
<p>To delete an attachment, select the Delete Icon (
<span style="font-family: Webdings; font-size: 12pt; font-weight: bold">&#114;</span>
) next to the desired link.</p>
<table 
	style="text-align: left ; 
	border-collapse: collapse; 
	width: 100%; 
	border-top: solid black 1px; 
	border-bottom: solid black 1px" 
	class="sortable" 
	ID="RefDocList">
<colgroup>
<col style="padding: 0.1in 0.1in 0.1in 0.1in"/>
<col style="padding: 0.1in 0.1in 0.1in 0.1in"/>
<col style="padding: 0.1in 0.1in 0.1in 0.1in"/>
<col style="padding: 0.1in 0.1in 0.1in 0.1in"/>
<col style="padding: 0.1in 0.1in 0.1in 0.1in"/>
<col style="padding: 0.1in 0.1in 0.1in 0.1in"/>
<col style="padding: 0.1in 0.1in 0.1in 0.1in"/>
</colgroup>
<tbody style="padding: 0.1in 0.1in 0.1in 0.1in"/>
	<tr>
	<th style="border-bottom: black solid 1px font-family: Arial, Helvetica, sans-serif; font-size: 12px;" height="30">
	<div>	
	<!-- <img id="CheckGif" src="../../cdecurate/Assets/CheckBox.gif" border="0" alt="Select One"/> -->
	
	</div>
	</th>
	<th style="border-bottom: black solid 1px font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Reference Document Name</th>
	<th style="border-bottom: black solid 1px font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Reference Document Type</th>
	<th style="border-bottom: black solid 1px font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Reference Document Text</th>
	<th style="border-bottom: black solid 1px font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Reference Document URL</th>
	<th style="border-bottom: black solid 1px font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Context</th>
	<th style="border-bottom: black solid 1px font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Links</th>
	</tr>
	<%

    for(int i=0; i<(vRefDoc.size()); i++)
    {
      refBean = (REF_DOC_Bean)vRefDoc.elementAt(i);
      filename = (String)vRefDocURL.get(i);
      //write the AC name and the table heading for the first item
      if (i==0)
      {
%>
    <tr>
	<td></td>
	</tr>
<%    } 
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
	
%> 
	<tr>
	<td>
<% 
	if (refBean.getIswritable()){
%>	
	<input type="checkbox" name="ck<%=i%>"/>
<%
	  }
else {%>
	<input type="checkbox" name="ck<%=i%>" DISABLED/>
<%
	  }
%>
	</td>
	<td><%=docName%></td>
	<td><%=docType%></td>
	<td><%=docText%></td>
	<td><a href="<%=docLink%><%=docURL%>" target="_blank"><%=docURL%></a></td>
	<td><%=docContext%></td>
<% if (filename != ""){ %>
	<%=filename%>
	<% }
else {%>
<td>&nbsp;</td>
<%
	}
%>	
	</tr>
<%
	  }
%>
</table>
<p>To attach a file, select the desired Reference Document above, enter or browse the local file, including the path, and select Upload. 
</p>
<p>File Name: <INPUT TYPE=FILE NAME="uploadfile"></p>
<p>Please perform a virus scan on files prior to Upload. File scans are not performed by the Curation Tool.</p>
<p><INPUT type="button" name="Uploadbtn" value="Upload" onclick="javascript:doUpload();"></p>


<input type="hidden" name="newRefDocPageAction" value="nothing">
<input type="hidden" name="RefDocTargetFile" value="nothing">
<script language = "javascript">
</script>
</form>


