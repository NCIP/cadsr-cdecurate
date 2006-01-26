//$Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cdecurate/RefDocAttachment.java,v 1.1 2006-01-26 15:25:12 hegdes Exp $
//$Name: not supported by cvs2svn $

package gov.nih.nci.cdecurate;

//import files
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Random;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import oracle.sql.BLOB;


/**
 * The NCICurationServlet is the main servlet for communicating between the
 * client and the server.
 * 
 * @author Dan Grandquist
 * @version 3.1
 *
 * @param req
 * @param res
 */
/*
 The CaCORE Software License, Version 3.0 Copyright 2002-2005 ScenPro, Inc. (“ScenPro”)  
 Copyright Notice.  The software subject to this notice and license includes both
 human readable source code form and machine readable, binary, object code form
 (“the CaCORE Software”).  The CaCORE Software was developed in conjunction with
 the National Cancer Institute (“NCI”) by NCI employees and employees of SCENPRO.
 To the extent government employees are authors, any rights in such works shall
 be subject to Title 17 of the United States Code, section 105.    
 This CaCORE Software License (the “License”) is between NCI and You.  “You (or “Your”)
 shall mean a person or an entity, and all other entities that control, are 
 controlled by, or are under common control with the entity.  “Control” for purposes
 of this definition means (i) the direct or indirect power to cause the direction
 or management of such entity, whether by contract or otherwise, or (ii) ownership
 of fifty percent (50%) or more of the outstanding shares, or (iii) beneficial 
 ownership of such entity.  
 This License is granted provided that You agree to the conditions described below.
 NCI grants You a non-exclusive, worldwide, perpetual, fully-paid-up, no-charge,
 irrevocable, transferable and royalty-free right and license in its rights in the
 CaCORE Software to (i) use, install, access, operate, execute, copy, modify, 
 translate, market, publicly display, publicly perform, and prepare derivative 
 works of the CaCORE Software; (ii) distribute and have distributed to and by 
 third parties the CaCORE Software and any modifications and derivative works 
 thereof; and (iii) sublicense the foregoing rights set out in (i) and (ii) to 
 third parties, including the right to license such rights to further third parties.
 For sake of clarity, and not by way of limitation, NCI shall have no right of 
 accounting or right of payment from You or Your sublicensees for the rights 
 granted under this License.  This License is granted at no charge to You.
 1.	Your redistributions of the source code for the Software must retain the above
 copyright notice, this list of conditions and the disclaimer and limitation of
 liability of Article 6, below.  Your redistributions in object code form must
 reproduce the above copyright notice, this list of conditions and the disclaimer
 of Article 6 in the documentation and/or other materials provided with the 
 distribution, if any.
 2.	Your end-user documentation included with the redistribution, if any, must 
 include the following acknowledgment: “This product includes software developed 
 by SCENPRO and the National Cancer Institute.”  If You do not include such end-user
 documentation, You shall include this acknowledgment in the Software itself, 
 wherever such third-party acknowledgments normally appear.
 3.	You may not use the names "The National Cancer Institute", "NCI" “ScenPro, Inc.”
 and "SCENPRO" to endorse or promote products derived from this Software.  
 This License does not authorize You to use any trademarks, service marks, trade names,
 logos or product names of either NCI or SCENPRO, except as required to comply with
 the terms of this License.
 4.	For sake of clarity, and not by way of limitation, You may incorporate this
 Software into Your proprietary programs and into any third party proprietary 
 programs.  However, if You incorporate the Software into third party proprietary
 programs, You agree that You are solely responsible for obtaining any permission
 from such third parties required to incorporate the Software into such third party
 proprietary programs and for informing Your sublicensees, including without 
 limitation Your end-users, of their obligation to secure any required permissions
 from such third parties before incorporating the Software into such third party
 proprietary software programs.  In the event that You fail to obtain such permissions,
 You agree to indemnify NCI for any claims against NCI by such third parties, 
 except to the extent prohibited by law, resulting from Your failure to obtain
 such permissions.
 5.	For sake of clarity, and not by way of limitation, You may add Your own 
 copyright statement to Your modifications and to the derivative works, and You 
 may provide additional or different license terms and conditions in Your sublicenses
 of modifications of the Software, or any derivative works of the Software as a 
 whole, provided Your use, reproduction, and distribution of the Work otherwise 
 complies with the conditions stated in this License.
 6.	THIS SOFTWARE IS PROVIDED "AS IS," AND ANY EXPRESSED OR IMPLIED WARRANTIES,
 (INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, 
 NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR PURPOSE) ARE DISCLAIMED.  
 IN NO EVENT SHALL THE NATIONAL CANCER INSTITUTE, SCENPRO, OR THEIR AFFILIATES 
 BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
 THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
public class RefDocAttachment {
	//String sAction;
	String msg = null;
	HttpSession session = null;
	HttpServletRequest req = null;
	HttpServletResponse res = null;
	NCICurationServlet m_servlet;
	Logger logger = Logger.getLogger(RefDocAttachment.class.getName());

	public RefDocAttachment(HttpServletRequest req, HttpServletResponse res, NCICurationServlet m_servlet) {

		session = req.getSession();
		this.req = req;
		this.res = res;
		this.m_servlet = m_servlet;
	}
/**
 *  Open the Ref Documents attachments page.
 */
public void doOpen (){
	// TODO: Cut and paste code from servlet
	
	GetACService getAC = new GetACService(req, res, m_servlet);
	Vector<TOOL_OPTION_Bean> vList = new Vector<TOOL_OPTION_Bean>();
    vList= getAC.getToolOptionData("CURATION","REFDOC_FILECACHE","");
    String RefDocFileCache = vList.get(0).getVALUE();
    vList = getAC.getToolOptionData("CURATION","REFDOC_FILEURL","");
    String RefDocFileUrl = vList.get(0).getVALUE();
	
	//	 Be sure something was selected by the user.
    Vector vSRows = (Vector)session.getAttribute("vSelRows");
    if (vSRows == null || vSRows.size() == 0)
    {
        msg = "No items were selected from the Search Results.";
    }
    
    else{
  	GetACSearch getACSearch = new GetACSearch(req, res, m_servlet);
  	String sACSearch = (String)session.getAttribute("searchAC");
		
		getACSearch.getSelRowToUploadRefDoc(req, res, "");
		
		if (sACSearch.equals("DataElement")|| sACSearch.equals("DataElementConcept") || sACSearch.equals("ValueDomain")){
			session.setAttribute("dispACType", sACSearch);
			
			String dispType = (String)session.getAttribute("displayType");
		    if (dispType == null) dispType = "";

		    REF_DOC_Bean refBean = new REF_DOC_Bean(); 
		    Connection con = null;
		    
		    // Get number of items
		    Vector vRefDoc = (Vector)req.getAttribute("RefDocList");
		    
		    if (vRefDoc == null){		    	
		    	vRefDoc = (Vector)session.getAttribute("RefDocList");
		    	req.setAttribute("RefDocList", vRefDoc);
		    }
 
		    // has ref docs
		    if (vRefDoc != null){

		    	Vector vRefDocRows = new Vector();
		    	Vector vRefDocDocs = new Vector();
		    	
		    	for(int i=0; i<(vRefDoc.size()); i++)
			      {
		    		
		    		//	Get AC_IDSEQ from the m_DE bean
		    		refBean = (REF_DOC_Bean)vRefDoc.elementAt(i);
			    	
	  			    // get RD_IDSEQ from REFERENCE_DOCUMENTS using AC_IDSEQ
			    	String str = refBean.getREF_DOC_IDSEQ();

			    	vRefDocRows.addElement(i);
  
					//get users contexts ids
					String RDContextID = "";
					String docContext =  refBean.getCONTEXT_NAME();
					String docContextID =  refBean.getCONTE_IDSEQ();
				    Vector vContextID = (Vector)session.getAttribute("vWriteContextDE_ID");
				    
				    // check vs Ref doc context ID
					if (vContextID != null) 
				    {
					  refBean.setIswritable(false);
				      for (int ndx = 0; vContextID.size()>ndx; ndx++)
				      {
				    	RDContextID = (String)vContextID.elementAt(ndx);
				        if (docContextID.equals(RDContextID))
				        {
				        	refBean.setIswritable(true);
				        }
				      }
				    }
			    	
			    	// SQL to get the results
	        		con = m_servlet.connectDB(req, res);
	                String select = "select NAME , blob_content from sbr.reference_blobs_view where rd_idseq = ?";
					
	                // make plsql call 
	                try {
						PreparedStatement pstmt = con.prepareStatement(select);
						pstmt.setString(1 , str);
						ResultSet rs = pstmt.executeQuery();
						int j = 0;
						String Doclist = "<td>";
						
						while ( rs.next()){
							
							// iterate counter
							j++;

							// Build HTML text for table
							String fileName = rs.getString(1);
							String fileName2[] = fileName.split("/");
							String fileDirectory = "";
							if (docContext == null) docContext = "";	

							//  if the ref doc is in a writable context add the delete X
							if (refBean.getIswritable())	{
							Doclist = Doclist + "<span onclick=\"onDocDelete('" 
											  + fileName + "' , '" 
											  + fileName2[1] 
											  + "' )\"; style=\" font-family: Webdings; cursor: pointer; font-size: 12pt; font-weight: bold\">&#114;</span>"
											  + "&nbsp;&nbsp;"
											  + "<a href=\""
											  + RefDocFileUrl 
											  + fileName 
											  + "\" target=\"_blank\">"
											  + fileName2[1]
											  + "<a><br>";
							
							// else no X
							}
							else{
								Doclist = Doclist + "&nbsp;&nbsp;&nbsp;&nbsp;"
								  + "<a href=\""
								  + RefDocFileUrl 
								  + fileName 
								  + "\" target=\"_blank\">"
								  + fileName
								  + "<a><br>";
							}
							
							// Extract file to file system
							BLOB bRefBlob = (BLOB)rs.getBlob(2);
							InputStream is = bRefBlob.getBinaryStream();
							
							try {
								
								String strArray[] = fileName.split("/");
								if (strArray.length > 1){
									fileName = strArray[1];
									fileDirectory = strArray[0];
									File fileLocation = new File(RefDocFileCache + fileDirectory);
									if (!fileLocation.isDirectory()){
										if (!fileLocation.mkdir()) {
											logger.fatal("Can not create directory: " + RefDocFileCache + fileDirectory);
											fileDirectory = "";
										}
										else
										{
											fileDirectory = fileDirectory + "/";
										}
									}
									else {
										fileDirectory = fileDirectory + "/";
									}
								}
								
								// Sentinel report directory
								OutputStream os = new FileOutputStream(RefDocFileCache + fileDirectory + fileName);

								final int BUFSIZ = 4096;
								byte inbuf[]= new byte [BUFSIZ];
								int bytesRead;
								
									while ((bytesRead = is.read(inbuf, 0, BUFSIZ)) != -1){
										os.write(inbuf, 0, bytesRead);
									}
								os.close();
								os = null;
							} catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							try {
								is.close();
								is = null;
							} catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						} //end of while
						Doclist = Doclist + "</td>";
						
						vRefDocDocs.addElement(Doclist);
						
		  			    session.setAttribute("RefDocRows", vRefDocDocs);
						rs.close();
						pstmt.close();              
						con.close();
						
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
			    	
			      }//end of for
		    	m_servlet.ForwardJSP(req, res, "/RefDocumentUploadPage.jsp");
		    	
		    }
		    else{
		        //no ref docs
		    	m_servlet.ForwardJSP(req, res, "/RefDocumentUploadPage.jsp");
		    }

		}
		else 
		{
			msg = "The selected items are not supported for the document upload feature.";
		}
    }
	
}


/**
 * 
 */
public void doFileUpload (){
	
	GetACService getAC = new GetACService(req, res, m_servlet);
	Connection con = null;
	REF_DOC_Bean refBean = new REF_DOC_Bean(); 
	HttpSession session = req.getSession();
	FileInputStream is;
	OutputStream os;

    // Get number of items
    Vector vRefDoc = (Vector)session.getAttribute("RefDocList");
	
	// get option table data
	Vector<TOOL_OPTION_Bean> vList = new Vector<TOOL_OPTION_Bean>();
    vList = getAC.getToolOptionData("CURATION","REFDOC_FILECACHE","");
    String RefDocFileCache = vList.get(0).getVALUE();
	
	RefDocMultipartForm refDocFormdata = new RefDocMultipartForm();
	refDocFormdata.parse(req, RefDocFileCache);
	
	String writeObjSQL = "INSERT INTO sbr.reference_blobs_view( " +
    "RD_IDSEQ, " +
    "NAME, " +
    "MIME_TYPE, " +
    "DOC_SIZE, " +
    "DAD_CHARSET, " +
    "CONTENT_TYPE, BLOB_CONTENT) " +
    "VALUES (?, ?, ?, ?, ?, ?, empty_blob()) ";
	
	con = m_servlet.connectDB(req, res);
	
	try {
		
		con.setAutoCommit(false);
		Vector<String> selectedRefDocs = refDocFormdata.getSelectedRefDocs();
		
		int jInt = selectedRefDocs.size(); 
		
		for (int ndx=0; ndx < jInt; ndx++){
			
			try {
				String str = selectedRefDocs.elementAt(ndx);
				int refDocIndex = Integer.valueOf(str);
				//refDocIndex = refDocIndex - 1;
				
				PreparedStatement pstmt = con.prepareStatement(writeObjSQL);
				
				if (vRefDoc != null){
				refBean = (REF_DOC_Bean)vRefDoc.elementAt(refDocIndex);
				str = refBean.getREF_DOC_IDSEQ();
				}

				//	set RD_IDSEQ
				pstmt.setString(1, str );
				//	set NAME
				String dbfileName = "F" + (new Random()).nextInt() + "/" + refDocFormdata.getFileName(); 
				pstmt.setString(2, dbfileName );
				//	set MIME_TYPE
				pstmt.setString(3, refDocFormdata.getMimeType() );
				//	set DOC_SIZE
				pstmt.setString(4, Integer.toString(refDocFormdata.getFileSize()) );
				//	set DAD_CHARSET
				pstmt.setString(5, refDocFormdata.getCharSet() );
				//	set CONTENT_TYPE
				pstmt.setString(6, refDocFormdata.getContentType() );
				
				
				//	get BLOB_CONTENT
				pstmt.execute();
				
				// open a file inputstream for the loacal file
				String fileLocator = RefDocFileCache + refDocFormdata.getFileName();
				
				
				is = new FileInputStream( fileLocator );

				
				//upload blob
				String UpdateObjSQL = "select blob_content from sbr.reference_blobs_view where name = ? for update";
				pstmt = con.prepareStatement(UpdateObjSQL);
				
				pstmt.setString(1, dbfileName);
				ResultSet rs = pstmt.executeQuery();
				rs.next();

				BLOB blob = (BLOB)rs.getBlob("blob_content");

				os = blob.getBinaryOutputStream();
				// os = blob.setBinaryStream(0); //get the output stream from the Blob to insert it

				//	Read the file by chuncks and insert them in the Blob. The chunk size come from the blob
				byte[] chunk = new byte[blob.getChunkSize()];
				int i=-1;
				while((i = is.read(chunk))!=-1)
				{
				os.write(chunk,0,i); //Write the chunk
								}

				is.close();
				os.close();
				pstmt.close();
				rs.close();
				con.commit();
			} catch (NumberFormatException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		con.close();
		
	} catch (SQLException e) {
		logger.fatal(e.toString());
	}
	doOpen();
}
/**
 *  Return the the results page and display the results.
 *
 */
public void doBack (){
	Vector vResult = new Vector();
	GetACSearch serAC = new GetACSearch(req, res, m_servlet);
	String sACSearch = (String)session.getAttribute("searchAC");
	if (sACSearch.equals("DataElement"))
	    serAC.getDEResult(req, res, vResult, "");
	  else if (sACSearch.equals("DataElementConcept"))
	  	serAC.getDECResult(req, res, vResult, "");
	  else if (sACSearch.equals("ValueDomain"))
	  	serAC.getVDResult(req, res, vResult, "");
	session.setAttribute("results", vResult);
	session.setAttribute("statusMessage", msg); 
	m_servlet.ForwardJSP(req, res, "/SearchResultsPage.jsp");
	 
	}


public void doDeleteAttachment (){
	Connection con = null;
	String fileName = (String)req.getParameter("RefDocTargetFile");
	String DelObjSQL = "delete from sbr.REFERENCE_BLOBS_VIEW where NAME = ?";
	con = m_servlet.connectDB(req, res);
	try {
		PreparedStatement pstmt = con.prepareStatement(DelObjSQL);
		pstmt.setString(1, fileName);
		pstmt.execute();
		pstmt.close();
		con.close();
	} catch (SQLException e) {
		logger.fatal(e.toString());
		msg = "Reference Document Attachment: Unable to delete the Attachment from the database.";
	}
	doOpen();
	}
} // End of Class
