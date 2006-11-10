// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/RefDocMultipartForm.java,v 1.24 2006-11-10 18:23:48 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

/**
 * Parse the input from the RefDocUpload.jsp when a file upload is performed.
 * This is indicated by the content-type multipart/form-data.
 * 
 * @author lhebel
 *
 */
public class RefDocMultipartForm {

    /**
     * Constructor.
     *
     */
	public RefDocMultipartForm()
	{
		_refDocs = new Vector<String>();
        _parms = new Vector<String>();
        _values = new Vector<String>();
	}
	
    /**
     * Parse the input stream from the http request.
     * 
     * @param req_ The request with the content-type multipart.
     * @param fileCache_ The local path to hold the file data. 
     */
	public void parse(HttpServletRequest req_, String fileCache_)
	{
        try
        {
            // Setup variables.
            OutputStream out = null;
            byte buff[] = new byte[8192];
            boolean fileData = false;
            String border = null;
            String parmName = null;
            String parts[] = null;
            String temp;
            int offset = 0;
            int expect = 0;
            int fileSize = 0;
            int buffLen;

            // Open the input stream.
            int totalLen = req_.getContentLength();
            InputStream in = req_.getInputStream();
            
            // Process until we have exhausted the request input.
            while (totalLen > 0)
            {
                // Read from the request and allow for the last read to be less
                // than the buffer size. Only read the number of bytes needed to
                // fill the buffer.
                if ((buffLen = in.read(buff, offset, buff.length - offset)) < 0)
                    buffLen = offset;
                else
                    buffLen += offset;
                
                // When reading file data from the request we only want to watch for the
                // border marker.
                offset = 0;
                int ndx;
                if (fileData)
                {
                    for (ndx = 0; ndx < buffLen; ++ndx)
                    {
                        // A '\r' is the key byte. If it's followed by a '\n' then we want to
                        // check the whole border string.
                        if (buff[ndx] == '\r')
                        {
                            if ((ndx + 1) == buffLen)
                                break;
                            else if (buff[ndx + 1] == '\n')
                            {
                                // Here's the deal, it's possible the file size is such the
                                // border string is not completely within the buffer unless we
                                // move the "\r\n" to position zero (0).
                                int remaining = buffLen - ndx - 4;
                                if (remaining < border.length())
                                    break;

                                temp = new String(buff, ndx + 2, border.length());
                                if (temp.equals(border))
                                {
                                    out.write(buff, 0, ndx);
                                    _fileSize = fileSize + ndx;
                                    fileData = false;
                                    ndx += 4 + border.length();
                                    out.close();
                                    out = null;
                                    break;
                                }
                            }
                        }
                    }
                    if (fileData)
                    {
                        fileSize += ndx;
                        out.write(buff, 0, ndx);
                    }
                }
                else
                {
                    // Ok we are not processing file data so this is control information.
                    for (ndx = 0; ndx < buffLen; ++ndx)
                    {
                        // Look for a '\r\n'
                        if (buff[ndx] == '\r' && (ndx + 1) < buffLen && buff[ndx + 1] == '\n')
                        {
                            switch (expect)
                            {
                                // Get the border string - this is the first thing in the stream.
                                case 0:
                                    expect = 1;
                                    border = new String(buff, 0, ndx);
                                    break;
                                    
                                // Get Content-Disposition
                                case 1:
                                    // Break apart the string into it's components.
                                    expect = 2;
                                    parmName = null;
                                    temp = new String(buff, 0, ndx);
                                    parts = temp.split(";");
                                    
                                    // This is not control information it's the "--" tag at
                                    // the end of the stream OR something's really wrong.
                                    if (parts.length == 1)
                                        break;
                                    
                                    // Look at each part and break into sub-parts of parameter
                                    // and value.
                                    for (int cnt = 0; cnt < parts.length; ++cnt)
                                    {
                                        // It's always of the form parm="value"
                                        String pairs[] = parts[cnt].split("[=\"]");
                                        for (int pcnt = 0; pcnt < pairs.length; ++pcnt)
                                        {
                                            // Keep the name of the parm for future reference.
                                            if (pairs[pcnt].equals(" name"))
                                            {
                                                while (pairs[++pcnt].length() == 0)
                                                    ;
                                                parmName = new String(pairs[pcnt]);
                                            }
                                            
                                            // Keep the file name for the data transfer soon to come.
                                            else if (pairs[pcnt].equals(" filename"))
                                            {
                                                while (pairs[++pcnt].length() == 0)
                                                    ;
                                                _fileName = new String(pairs[pcnt]);
                                                expect = 3;
                                            }
                                        }
                                    }
                                    break;
                                    
                                // Blank line.
                                case 2:
                                    expect = 4;
                                    if (parmName.equals("uploadfile"))
                                    {
                                        // If the last parm was uploadfile we need to open
                                        // the working output file and spool the data to
                                        // the local hard drive.
                                        fileSize = 0;
                                        fileData = true;
                                        parts = _fileName.split("[\\\\/]");
                                        _fileName = new String(parts[parts.length - 1]);
                                        out = new FileOutputStream(fileCache_ + _fileName);
                                        expect = 1;
                                    }
                                    break;
                                    
                                // Content-Type
                                case 3:
                                    // The MIME defines this as the content-type but internally
                                    // we refer to it as the mime type, e.g. text/plain, image/gif, etc.
                                    expect = 2;
                                    temp = new String(buff, 0, ndx);
                                    parts = temp.split(" ");
                                    _mimeType = new String(parts[1]);
                                    break;
                                    
                                // Get parameter value.
                                case 4:
                                    // For future use and debugging keep all the parm
                                    // value pairs.
                                    expect = 5;
                                    _parms.add(parmName);
                                    temp = new String(buff, 0, ndx);
                                    _values.add(temp);

                                    // If this is a checkbox we don't keep the value just
                                    // the number associated with the name.
                                    if (parmName.startsWith("ck"))
                                    {
                                        temp = parmName.substring(2);
                                        _refDocs.add(temp);
                                    }
                                    break;
                                    
                                // Look for border.
                                case 5:
                                    // We don't really need to compare the string to the border here.
                                    expect = 1;
                                    break;
                            }
                            // Move the counter because of the matching "\r\n" bytes.
                            ndx += 2;
                            break;
                        }
                    }
                }
                // If the current index into the buffer is less than the content length
                // shift everything left and return to the top of the loop to back fill
                // the buffer.
                if (ndx < buffLen)
                {
                    offset = ndx;
                    totalLen -= offset;
                    System.arraycopy(buff, offset, buff, 0, buffLen - offset);
                    offset = buffLen - offset;
                }
                
                // If the index has exhausted the buffer content then try to fill it.
                else
                {
                    offset = 0;
                    totalLen -= buffLen;
                }
            }
        }
        catch (IOException e)
        {
        	_logger.fatal(e.toString(), e);
        }
	}

    /**
     * Return the SQL content type of the file. Currently this is
     * always "BLOB"
     * 
     * @return "BLOB"
     */
	public String getContentType()
	{
		return _contentType;
	}

    /**
     * Return the character set used for the file. Currently this is
     * always "ascii".
     * 
     * @return "ascii"
     */
	public String getCharSet()
	{
		return _charSet;
	}

    /**
     * Return the file size of the uploaded data.
     * 
     * @return The file size in bytes.
     */
	public int getFileSize()
	{
		return _fileSize;
	}
	
    /**
     * Return the mime type of the file. This is retrieved from the
     * input stream.
     * 
     * @return The file mime type.
     */
	public String getMimeType()
	{
		return _mimeType;
	}

    /**
     * Return the file name. This is the file name stripped of the
     * original path/directory information.
     * 
     * @return The name of the uploaded file.
     */
	public String getFileName()
	{
		return _fileName;
	}
	
    /**
     * Return the reference documents selected by the user. These will be
     * numeric values with the "CK" prefix stripped off.
     * 
     * @return The reference document selected indices.
     */
	public Vector<String> getSelectedRefDocs()
	{
		return _refDocs;
	}
	
	private String _fileName;
	private String _mimeType;
	private static final String _charSet = "ascii";
	private static final String _contentType = "BLOB";
	private int _fileSize;
	private Vector<String> _refDocs;
    private Vector<String> _parms;
    private Vector<String> _values;
    Logger _logger = Logger.getLogger(RefDocMultipartForm.class.getName());
}
