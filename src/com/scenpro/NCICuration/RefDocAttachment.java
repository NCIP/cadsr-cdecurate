//$Header: /cvsshare/content/cvsroot/cdecurate/src/com/scenpro/NCICuration/RefDocAttachment.java,v 1.1 2006-01-16 21:35:36 hegdes Exp $
//$Name: not supported by cvs2svn $

package com.scenpro.NCICuration;

//import files
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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

	public RefDocAttachment(HttpServletRequest req, HttpServletResponse res, NCICurationServlet m_servlet) {

		session = req.getSession();
		this.req = req;
		this.res = res;
		this.m_servlet = m_servlet;
	}
/**
 * 
 */
public void doOpen (){
	// TODO: Cut and paste code from servlet
	
	GetACService getAC = new GetACService(req, res, m_servlet);
	Vector<TOOL_OPTION_Bean> vList = new Vector<TOOL_OPTION_Bean>();
    vList = getAC.getToolOptionData("CURATION","REFDOC_FILECACHE","");
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
			    	// SQL to get the results
	        		con = m_servlet.connectDB(req, res);
	                String select = "select NAME , blob_content from sbr.reference_blobs_view where rd_idseq = ?";
	                
			    	
	                // make plsql call 
	                try {
						PreparedStatement pstmt = con.prepareStatement(select);
						pstmt.setString(1 , str);
						ResultSet rs = pstmt.executeQuery();
						int j = 0;
						String Doclist = "";
						
						while ( rs.next()){
							
							// iterate counter
							j++;
							
							
							// Build HTML text for table
							String fileName = rs.getString(1);
							Doclist = Doclist + "<span style=\"font-family: Webdings; font-size: 12pt; font-weight: bold\">&#114;</span>"
											  + "&nbsp;&nbsp;"
											  + "<a href=\""
											  + RefDocFileUrl 
											  + fileName 
											  + "\" target=\"_blank\">"
											  + fileName
											  + "<a><br>";
							
							// Extract file to file system
							BLOB bRefBlob = (BLOB)rs.getBlob(2);
							InputStream is = bRefBlob.getBinaryStream();
							
							try {
								
								String strArray[] = fileName.split("/");
								if (strArray.length > 1){
									fileName = strArray[1];
								}
								
								// Sentinel report directory
								OutputStream os = new FileOutputStream(RefDocFileCache + fileName);

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
	
	String fileName = req.getParameter("uploadfile");
	System.out.println(fileName);
	byte buff[] = new byte[200];
	
	try {
		ServletInputStream in = req.getInputStream();
		in.read(buff);
		in.close();
	} catch (IOException e1) {
		// TODO Auto-generated catch block
		e1.printStackTrace();
	}
		
//	try {
//		FileInputStream is = new FileInputStream(fileName);
//		
//		String writeObjSQL    = "BEGIN " +
//        "INSERT INTO sbr.reference_blobs_view(RD_IDSEQ, " +
//        "NAME, " +
//        "MIME_TYPE, " +
//        "DOC_SIZE, DAD_CHARSET, " +
//        "CONTENT_TYPE, BLOB_CONTENT) " +
//        "VALUES (?, ?, ?, ?, 'ascii', 'BLOB', empty_blob()) " +
//        "RETURN BLOB_CONTENT INTO ?; " +
//        "END;";
//		
//		// get rd_idseq
//		
//		// figure mime type
//		
//		// set name with rand number
//		
//		// insert into the refblob table
//		
//		// get blob obj statment.getblab(5)
//		
//		while ( is.read() != -1){
//
//		} //end of while
//		
//		
//	} catch (FileNotFoundException e) {
//		// TODO Auto-generated catch block
//		e.printStackTrace();
//	}
//	
//	
	doOpen();
}

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

} // End of Class
