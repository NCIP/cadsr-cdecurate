// Copyright (c) 2000 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/UtilService.java,v 1.45 2007-06-04 18:09:10 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Vector;
import javax.servlet.http.HttpSession;

/**
 * The UtilService supplies various utility methods to be used by other classes.
 *
 * <P>
 * @author Joe Zhou
 * @version 3.0
 *
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

public class UtilService implements Serializable
{
  /**
   * 
   */
  private static final long serialVersionUID = 1L;

  /**
  * The setMultSelection method: ID's from sSelList are looped through and added
  * to vTarget
  * @param vSource A Vector of the Sources.
  * @param vTarget  A Vector of targets.
  * @param sSelList  A string array selection list.
  *
  */
  public void setMultSelection(Vector<String> vSource, Vector<String> vTarget, String sSelList[])
  {
    int i = 0;
    try
    {
        for(;;)
        {
           if(sSelList[i] != null)
           {
              Integer Idx = new Integer(sSelList[i]);
              String sID = (String)vSource.elementAt(Idx.intValue());
              vTarget.add(sID);
           }
           i++;
        }
    }
    catch(Exception e)
    {
        System.out.println("setMultSelection, size: " + i);
    }
  } //end setMultSelection

  /**
  * The setMultSelectionByIDs method: get Names from a list by passing in ID's
  *
  *
  * @param vIDs A Vector of the IDs.
  * @param vNames  A Vector of names.
  * @param vSrcIDs A Vector of the Source ID's.
  * @param vSrcNames  A Vector of Source Names.
  * @param sIDs  A string array of ID's.
  *
  */
  public void setMultSelectionByIDs(Vector<String> vIDs,
                                    Vector<String> vNames,
                                    Vector<String> vSrcIDs,
                                    Vector<String> vSrcNames,
                                    String sIDs[])
  {
    // get size of sIDs
    int iID_Size = 0;
    try
    {
        for(;;)
        {
           if(sIDs[iID_Size] != null)
              iID_Size++;
           else
              break;
        }
    }
    catch(Exception e)
    {
        System.out.println("setMultSelectionByIDs, size: " + iID_Size);
    }

    try
    {
      String sID, sName;
      for(int i=0; i<vSrcIDs.size(); i++)
      {
          sID = (String)vSrcIDs.elementAt(i);
          for(int j=0; j<iID_Size; j++)
          {
             if(sID.equals(sIDs[j]))
             {
                 vIDs.add(sID);
                 sName = (String)vSrcNames.elementAt(i);
                 vNames.add(sName);
             }
          }
     }
    }
    catch(Exception e)
    {
        System.out.println("Error in setMultSelectionByIDs: " + e);
    }
  } //end setMultSelectionByIDs

  /**
  * The getName method: pass in index as string, pick its name from source
  * vector and return it
  *
  * @param vSource A Vector of the Sources.
  * @param sIdx string index
  * @return String
  *
  */
  public String getName(Vector vSource, String sIdx)
  {
    String sName = "";
    try
    {
        Integer Idx = new Integer(sIdx);
        sName = (String)vSource.elementAt(Idx.intValue());
    }
    catch(Exception e)
    {
        System.out.println("Error in getName: " + e);
        return null;
    }
    
    return sName;
  } //end setMultSelection

  /**
  * The getNameByID method: pass in index as string, pick its name from source
  * vector and return it
  *
  * @param vName  A Vector of names.
  * @param vID A Vector of ID's.
  * @param sID String value for ID
  * @return String value for name
  *
  */
  public String getNameByID(Vector vName, Vector vID, String sID)
  {
    String sName = "";
    int i=0;
    try
    {
        for(i=0; i<vID.size(); i++)
        {
          if(sID.equals(vID.elementAt(i)))
            break;
        }
        sName = (String)vName.elementAt(i);
    }
    catch(Exception e)
    {
       // System.out.println("Error in getNameByID: " + e);
        return null;
    }

    return sName;
  } //end getNameByID

  /**
  * The getIDByName method: pass in index as string, pick its ID from source
  * vector and return it
  * @param vSource Vector of string value
  * @param sIdx string value for index
  *
  * @return String of ID
  *
  */
  public String getIDByName(Vector vSource, String sIdx)  // returns ID
  {
    String sIDSEQ = "";
    try
    {
        Integer Idx = new Integer(sIdx);
        sIDSEQ = (String)vSource.elementAt(Idx.intValue());
    }
    catch(Exception e)
    {
        System.out.println("Error in getIDByName: " + e);
        return null;
    }
    
    return sIDSEQ;
  } //end getIDBYName

  /**
  * The getOracleDate method: returns date in DD-MON-YYYY format
  *
  * @param sDate  A date string.
  *
  * @return A string date is returned, in Oracle format.
  */
  public String getOracleDate(String sDate)  //
  {
    String sOraDate;
    String sDay = "";
    String sMon = "";
    String sYr = "";
    String sOraMon = "";

    if(sDate == null || sDate.length() < 1)
      return sDate;

    try
    {
    int idx1 = sDate.indexOf('/', 0);
    sMon = sDate.substring(0, idx1);
    int idx2 = sDate.indexOf('/', idx1+1);
    sDay = sDate.substring(idx1+1, idx2);
    sYr = sDate.substring(idx2+1);

    Integer iMon = new Integer(sMon);
    switch(iMon.intValue())
    {
      case 1:
        sOraMon = "JAN";
        break;
      case 2:
        sOraMon = "FEB";
        break;
      case 3:
        sOraMon = "MAR";
        break;
      case 4:
        sOraMon = "APR";
        break;
      case 5:
        sOraMon = "MAY";
        break;
      case 6:
        sOraMon = "JUN";
        break;
      case 7:
        sOraMon = "JUL";
        break;
      case 8:
        sOraMon = "AUG";
        break;
      case 9:
        sOraMon = "SEP";
        break;
      case 10:
        sOraMon = "OCT";
        break;
      case 11:
        sOraMon = "NOV";
        break;
      case 12:
        sOraMon = "DEC";
        break;
    }

    sOraDate = sDay + "-" + sOraMon + "-" + sYr;
    }
    catch(Exception e)
    {
        System.out.println("Error in getOracleDate: " + e);
        return null;
    }

    return sOraDate;
  } //end setMultSelection

   /**
  * The getCurationDate method: returns date in MM/DD/YYYY format
  *
  * @param sDate  A date string.
  *
  * @return A string date is returned, in Curation format.
  */
  public String getCurationDate(String sDate)
  {
    if(sDate == null) sDate = "";
    //String sOraDate;
    String sDay = "";
    String sMon = "";
    String sYr = "";
    //String sOraMon = "";
    if(sDate.length() < 1)
      return sDate;

    try
    {
      if (sDate.charAt(4) == '-')
      {
        int idx1 = sDate.indexOf('-', 0);
        sYr = sDate.substring(0, idx1);
        int idx2 = sDate.indexOf('-', idx1+1);
        sMon = sDate.substring(idx1+1, idx2);
        sDay = sDate.substring(idx2+1, idx2+3);
        sDate = sMon + "/" + sDay + "/" + sYr;
      }
      else if (sDate.charAt(2) == '-' && sDate.length() > 9) // For year in format "yyyy"
      {
        sDay = sDate.substring(0, 2);
        sMon = sDate.substring(3, 6);
        sYr = sDate.substring(7, sDate.length());
        if(sMon.equals("JAN")) sMon = "01";
        if(sMon.equals("FEB")) sMon = "02";
        if(sMon.equals("MAR")) sMon = "03";
        if(sMon.equals("APR")) sMon = "04";
        if(sMon.equals("MAY")) sMon = "05";
        if(sMon.equals("JUN")) sMon = "06";
        if(sMon.equals("JUL")) sMon = "07";
        if(sMon.equals("AUG")) sMon = "08";
        if(sMon.equals("SEP")) sMon = "09";
        if(sMon.equals("OCT")) sMon = "10";
        if(sMon.equals("NOV")) sMon = "11";
        if(sMon.equals("DEC")) sMon = "12";
        sDate = sMon + "/" + sDay + "/" + sYr;
      }
      else if (sDate.charAt(2) == '-' && sDate.length() < 10) // For year in format "yy"
      {
        sDay = sDate.substring(0, 2);
        sMon = sDate.substring(3, 6);
        sYr = sDate.substring(7, 9);
        if(sMon.equals("JAN")) sMon = "01";
        if(sMon.equals("FEB")) sMon = "02";
        if(sMon.equals("MAR")) sMon = "03";
        if(sMon.equals("APR")) sMon = "04";
        if(sMon.equals("MAY")) sMon = "05";
        if(sMon.equals("JUN")) sMon = "06";
        if(sMon.equals("JUL")) sMon = "07";
        if(sMon.equals("AUG")) sMon = "08";
        if(sMon.equals("SEP")) sMon = "09";
        if(sMon.equals("OCT")) sMon = "10";
        if(sMon.equals("NOV")) sMon = "11";
        if(sMon.equals("DEC")) sMon = "12";
        if(sYr.equals("01") || sYr.equals("02") || sYr.equals("03") || sYr.equals("04") ||
                      sYr.equals("05") || sYr.equals("06") || sYr.equals("07")
                      || sYr.equals("08") || sYr.equals("09") || sYr.equals("00"))
          sYr = "20" + sYr;
        else
          sYr = "19" + sYr;
        sDate = sMon + "/" + sDay + "/" + sYr;
      }
    }
    catch(Exception e)
    {
        System.out.println("Error in getCurationDate: " + e);
        return null;
    }
    return sDate;
  } //end setMultSelection

   /**
  * The insertCacheVector method: insert String s into Vector v in proper sorted
  * position
  *
  * @param v  A Vector.
  * @param s  A string.
  * @return int 
  *
  */
  //
  public int insertCacheVector(Vector<String> v, String s)
  {
      String sPrev;
      String sNext;
      int i = 0;
      if(v == null || v.isEmpty())
        return 0;
      for(i=1; i<v.size(); i++)
      {
          sPrev = (String)v.elementAt(i-1);
          sNext = (String)v.elementAt(i);
          if(s.compareTo(sPrev) > 0 && s.compareTo(sNext) < 0)
          {
            v.add(i, s);
            break;
          }
      }
      return i;
  }

  /**
   * parse the string with double quote
   * @param sPrName
   * @return fomated string
   */
    public String parsedStringDoubleQuoteJSP(String sPrName)
    {
      int index = 0;
      if (sPrName != null && !sPrName.equals(""))
      {
        do
        {
          if (index > 0)
            index = sPrName.indexOf('"',index);
          else
            index = sPrName.indexOf('"');

          if (index > -1)
          {
            sPrName = sPrName.substring(0, index) + "&#34" + sPrName.substring(index+1);
            index = index + 3;
          }
        }
        while (index > 0);
      }
      return sPrName;
    }

  /**
   * parse the string for single quote
   * @param sPrName string to format
   * @return formatted string
   */
    public String parsedStringSingleQuote(String sPrName)
    {
      int index = 0;
      if (sPrName != null && !sPrName.equals(""))
      {
        do
        {
          if (index > 0)
            index = sPrName.indexOf('\'',index);
          else
            index = sPrName.indexOf('\'');

          if (index > -1)
          {
            sPrName = sPrName.substring(0, index) + "\\'" + sPrName.substring(index+1);
            index = index + 3;
          }
        }
        while (index > 0);
      }
      //System.out.println("string " + sPrName);
      return sPrName;
    }
    
  /**
   * parse the string for single quote
   * @param sPrName string to format
   * @return formatted string
   */
    public String parsedStringSingleQuoteToStar(String sPrName)
    {
      int index = 0;
      if (sPrName != null && !sPrName.equals(""))
      {
        index = sPrName.indexOf('\'');
        if (index > -1)
          sPrName = sPrName.substring(0, index-1) + "*";
      }
      return sPrName;
    }

  /**
   * parse the string for double quote for javascript
   * @param sPrName string to format
   * @return formatted string
   */
    public String parsedStringDoubleQuote(String sPrName)
    {
      int index = 0;
      if (sPrName != null && !sPrName.equals(""))
      {
        do
        {
          if (index > 0)
            index = sPrName.indexOf('"',index);
          else
            index = sPrName.indexOf('"');

          if (index > -1)
          {
            sPrName = sPrName.substring(0, index) + "\\" + sPrName.substring(index);
            index = index + 2;
          }
        }
        while (index > 0);
      }
      return sPrName;
    }

  /**
   * parse the string for single quote
   * @param sPrName string to format
   * @return formatted string
   */
    public String parsedStringSingleQuoteOracle(String sPrName)
    {
      int index = 0;
      if (sPrName != null && !sPrName.equals(""))
      {
        do
        {
          if (index > 0)
            index = sPrName.indexOf('\'',index);
          else
            index = sPrName.indexOf('\'');

          if (index > -1)
          {
            sPrName = sPrName.substring(0, index) + "''" + sPrName.substring(index+1);
            index = index + 3;
          }
        }
        while (index > 0);
      }
      //System.out.println("string " + sPrName);
      return sPrName;
    }

  /**
   * remove newline character from the string
   * @param sValue string to format
   * @return formatted string
   */  
    public String removeNewLineChar(String sValue)
    {
      if (sValue != null && !sValue.equals(""))
      {
        sValue = sValue.replaceAll("[\\r][\\n]", " ");
        sValue = sValue.replaceAll("[\\s]", " ");
        sValue = sValue.trim();
        //sValue = sValue.replace('\n', ' ');
        //sValue = sValue.replace('\r', ' ');
        //sValue = sValue.replace('\f', ' ');
        return sValue;
      }
      //else
        return "";
    }
    
  /**
   * remove newline character from the string for javascript alert messages to make sure new line characters from oracle is fixed properly.
   * @param sPrName
   * @return fomated string
   */
    public String parsedStringAlertNewLine(String sPrName)
    {
      int index = 0;
      if (sPrName != null && !sPrName.equals(""))
      {
        do
        {
          if (index > 0)
          {
            index = sPrName.indexOf('\f',index);
            if (index < 0)
              index = sPrName.indexOf('\r',index);
            if (index < 0)
              index = sPrName.indexOf('\n',index);            
          }
          else
          {
            index = sPrName.indexOf('\f');
            if (index < 0)
              index = sPrName.indexOf('\r');
            if (index < 0)
              index = sPrName.indexOf('\n');            
          }
          if (index > -1)
          {
            sPrName = sPrName.substring(0, index) + "\\n\\t" + sPrName.substring(index+1);
            index = index + 3;
          }
        }
        while (index > 0);
      }
      return sPrName;
    }
  /**
   * remove double backslash from newline character from the string for success messages.
   * @param sMsg
   * @return fomated string
   */
    public String parsedStringMsgNewLine(String sMsg)
    {
      int index = 0;
      if (sMsg != null && !sMsg.equals(""))
      {
        do
        {
          if (index > 0)
            index = sMsg.indexOf('\n',index);
          else
            index = sMsg.indexOf('\n');
        //System.out.println(index + " msg " + sMsg);
          if (index > -1)
          {
            sMsg = sMsg.substring(0, index) + " " + sMsg.substring(index+2);
            index = index + 3;
          }
        }
        while (index > 0);
      }
      return sMsg;
    } 
  /**
   * remove tab and new line from teh vector from the string for success messages.
   * @param sMsg
   * @return fomated string
   */
    public String parsedStringMsgVectorTabs(String sMsg)
    {
      int index = 0;
      if (sMsg != null && !sMsg.equals(""))
      {
        //do the new line character
        do
        {
          if (index > 0)
            index = sMsg.indexOf("\\n",index);
          else
            index = sMsg.indexOf("\\n");
     //   System.out.println(index + " msg newline " + sMsg);
          if (index > -1)
          {
            sMsg = sMsg.substring(0, index) + " " + sMsg.substring(index+2);
            index = index + 3;
          }
        }
        while (index > 0);
        //do the tab character
        do
        {
          if (index > 0)
            index = sMsg.indexOf("\\t",index);
          else
            index = sMsg.indexOf("\\t");
   //     System.out.println(index + " msg tab " + sMsg);
          if (index > -1)
          {
            sMsg = sMsg.substring(0, index) + " " + sMsg.substring(index+2);
            index = index + 3;
          }
        }
        while (index > 0);    
      }
      return sMsg;
    } 
    /**
     * remove tab and new line from teh vector from the string for success messages.
     * @param sMsg string message to append
     * @param vMsg vector of string message
     * @return fomated string
     */
  public String parsedStringMsgVectorTabs(String sMsg, Vector<String> vMsg)
  {
    int index = 0;

    if (sMsg != null && !sMsg.equals(""))
    {
      //do the new line character adding it to vector with indent if tab existed
      String newMsg = "";
      do
      {
       // if (index > 0)
       //   index = sMsg.indexOf("\\n",index);
       // else
          index = sMsg.indexOf("\\n");
   //   System.out.println(index + " msg newline " + sMsg);
        if (index > -1)
        {
          newMsg = sMsg.substring(0, index);  //substring up to the new line
          newMsg = newMsg.trim();
          if (!newMsg.equals(""))
          {
              //put indent for the tab at the begginning of the msg for vector.
              int iTab = newMsg.indexOf("\\t");
              if (iTab > -1 && iTab < 5)
                  newMsg = "<ul>".concat(newMsg.substring(2));  //.concat("</ul>"); 
              //sMsg = sMsg.substring(0, index) + " " + sMsg.substring(index+2);
              vMsg.addElement(newMsg);
          }
          sMsg = sMsg.substring(index+2).trim();  //remove earlier line; starts from 0 always
        }
      }
      while (index > 0);
      //if the message has no new line but just tabs
      int iTab = sMsg.indexOf("\\t");
      if (iTab > -1 && iTab < 5)
          sMsg = "<ul>".concat(sMsg.substring(2));  //.concat("</ul>"); //one side is needed for the jsp to mark tab

      //do the tab character
      index =0;
      do
      {
        if (index > 0)
          index = sMsg.indexOf("\\t",index);
        else
          index = sMsg.indexOf("\\t");
 //     System.out.println(index + " msg tab " + sMsg);
        if (index > -1)
        {
          sMsg = sMsg.substring(0, index) + " " + sMsg.substring(index+2);
          index = index + 3;
        }
      }
      while (index > 0);    
    }
    return sMsg;
  } 
  /**
  * sort DE Component vectors against last vector: vDECompOrder
  *
  * @param vDEComp  A Vector.
  * @param vDECompID  A Vector.
  * @param vDECompRelID 
  * @param vDECompOrder  A Vector.
  * @return int
  *
  */
  public int sortDEComps(Vector<String> vDEComp, Vector<String> vDECompID, Vector<String> vDECompRelID, Vector<String> vDECompOrder)
  {
          int iMinIndex = 0;
          int iMin = 1000;
          String sTmp = "";
          int len = vDECompOrder.size();
          for(int i=0; i<len; i++)
          {
              String sOrder1 = (String)vDECompOrder.elementAt(i);
              Integer IOrder1 = new Integer(sOrder1);
              int iOrder1 = IOrder1.intValue();
              iMin = iOrder1;
              iMinIndex = i;
              for(int j=i+1; j<len; j++)
              {
                  String sOrder2 = (String)vDECompOrder.elementAt(j);
                  Integer IOrder2 = new Integer(sOrder2);
                  int iOrder2 = IOrder2.intValue();
                  if(iOrder2 < iMin)
                  {
                      iMin = iOrder2;
                      iMinIndex = j;
                  }
              }
              if(iMinIndex != i) //swap
              {
                  sTmp = (String)vDEComp.elementAt(i);
                  vDEComp.setElementAt((String)vDEComp.elementAt(iMinIndex), i);
                  vDEComp.setElementAt(sTmp, iMinIndex);
                  sTmp = (String)vDECompID.elementAt(i);
                  vDECompID.setElementAt((String)vDECompID.elementAt(iMinIndex), i);
                  vDECompID.setElementAt(sTmp, iMinIndex);
                  sTmp = (String)vDECompRelID.elementAt(i);
                  vDECompRelID.setElementAt((String)vDECompRelID.elementAt(iMinIndex), i);
                  vDECompRelID.setElementAt(sTmp, iMinIndex);
                  sTmp = (String)vDECompOrder.elementAt(i);
                  vDECompOrder.setElementAt((String)vDECompOrder.elementAt(iMinIndex), i);
                  vDECompOrder.setElementAt(sTmp, iMinIndex);
              }
          }  // end of for i
          return 0;
  }  // end of sortDEComps

  /**
   * checks for some validity for these attributes in VD submit
   * @param sAct
   * @param sField
   * @param newVD
   * @param oldVD
   * @return String of new value
   */
  public String formatStringVDSubmit(String sAct, String sField, VD_Bean newVD, VD_Bean oldVD)
  {
    if (sField.equals("EndDate") || sField.equals("BeginDate"))
    {
      String sDate = "", oldDate = "";
      if (oldVD != null)
      {
        if (sField.equals("BeginDate")) oldDate  = this.getOracleDate(oldVD.getVD_BEGIN_DATE());
        if (sField.equals("EndDate")) oldDate  = this.getOracleDate(oldVD.getVD_END_DATE());
      }
      if (sField.equals("BeginDate")) sDate = this.getOracleDate(newVD.getVD_BEGIN_DATE());
      if (sField.equals("EndDate")) sDate = this.getOracleDate(newVD.getVD_END_DATE());
       // if date is removed, pass in empty string
      if (sDate == null) sDate = "";
      if (oldDate == null) oldDate = "";
      if (sDate.equals("") && sAct.equals("UPD") && !sDate.equals(oldDate))
        sDate = " ";
      //return the string
      return sDate;
    }
    else if (sField.equals("Source") || sField.equals("ChangeNote") || sField.equals("UOMLName") 
         || sField.equals("UOMLDesc") || sField.equals("FORMLName") || sField.equals("LowValue")
         || sField.equals("HighValue") || sField.equals("RepTerm"))
    {
       String sNewName = "", sOldName = "";
       //get the old value
       if(oldVD != null)
       {
          if (sField.equals("Source")) sOldName  = oldVD.getVD_SOURCE();
          if (sField.equals("ChangeNote")) sOldName  = oldVD.getVD_CHANGE_NOTE();
          if (sField.equals("UOMLName")) sOldName  = oldVD.getVD_UOML_NAME();
          if (sField.equals("UOMLDesc")) sOldName  = oldVD.getVD_UOML_DESCRIPTION();
          if (sField.equals("FORMLName")) sOldName  = oldVD.getVD_FORML_NAME();
          if (sField.equals("LowValue")) sOldName  = oldVD.getVD_LOW_VALUE_NUM();
          if (sField.equals("HighValue")) sOldName  = oldVD.getVD_HIGH_VALUE_NUM();
          if (sField.equals("RepTerm")) sOldName  = oldVD.getVD_REP_TERM();
       }
       //get the new value
       if (sField.equals("Source")) sNewName = newVD.getVD_SOURCE();
       if (sField.equals("ChangeNote")) sNewName = newVD.getVD_CHANGE_NOTE();
       if (sField.equals("UOMLName")) sNewName = newVD.getVD_UOML_NAME();
       if (sField.equals("UOMLDesc")) sNewName = newVD.getVD_UOML_DESCRIPTION();
       if (sField.equals("FORMLName")) sNewName = newVD.getVD_FORML_NAME();
       if (sField.equals("LowValue")) sNewName = newVD.getVD_LOW_VALUE_NUM();
       if (sField.equals("HighValue")) sNewName = newVD.getVD_HIGH_VALUE_NUM();
       if (sField.equals("RepTerm")) sNewName = newVD.getVD_REP_TERM();
       
       //check for validity
       if(sOldName == null) sOldName = "";
       if(sNewName == null) sNewName = "";
       if (sNewName.equals("") && sAct.equals("UPD")&& !sNewName.equals(sOldName))
         sNewName = " ";
       else if (sField.equals("RepTerm"))
         sNewName = newVD.getVD_REP_IDSEQ();
       //return string
       return sNewName;
    }
    else if (sField.equals("MaxLen") || sField.equals("MinLen") || sField.equals("Decimal"))
    {
       String sNewName = "", sOldName = "";
       //get the old value
       if(oldVD != null)
       {
          if (sField.equals("MaxLen")) sOldName  = oldVD.getVD_MAX_LENGTH_NUM();
          if (sField.equals("MinLen")) sOldName  = oldVD.getVD_MIN_LENGTH_NUM();
          if (sField.equals("Decimal")) sOldName  = oldVD.getVD_DECIMAL_PLACE();
       }
       //get the new value
       if (sField.equals("MaxLen")) sNewName = newVD.getVD_MAX_LENGTH_NUM();
       if (sField.equals("MinLen")) sNewName = newVD.getVD_MIN_LENGTH_NUM();
       if (sField.equals("Decimal")) sNewName = newVD.getVD_DECIMAL_PLACE();
       
       //check for validity
       if(sOldName == null) sOldName = "";
       if (sNewName == null) sNewName = "";
       if(sNewName.equals("") && sAct.equals("UPD")&& !sNewName.equals(sOldName))
         sNewName = "-1"; 
       //return string
       return sNewName;
    }
    return "";  //incase
  }
  
  /**
   * makes the log message so can be used by jsp too.
   * @param session
   * @param sMethod
   * @param endMsg
   * @param bDate
   * @param eDate
   * @return string log message
   */
  public String makeLogMessage(HttpSession session, String sMethod, String endMsg,
     java.util.Date bDate, java.util.Date eDate) 
  {
    String sMsg = "";
    try
    {
      //add Method name
      sMsg += "Function: " + sMethod;      
      //add user
      String sUser = (String)session.getAttribute("Username");
      if (sUser == null) sUser = "";
      sMsg += "; User: " + sUser;      
      //add session id
      String ssID = session.getId();
      if (ssID == null) ssID = "";
      sMsg += "; Session-ID: " + ssID;      
      //add duration
      //java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat ("MM/dd/yyyy");
      long lDur = eDate.getTime() - bDate.getTime();
      if (lDur > 1000)
        sMsg += "; Duration: " + (lDur/1000) + " seconds";
      else
        sMsg += "; Duration: " + lDur + " milliseconds";
      //add end message
      sMsg += "; " + endMsg;      
    }
    catch (Exception e)
    {
      System.out.println("Unable to get the log message - " + sMsg);
    }
    return sMsg;
  }

  /**
   * To set the valid page vector with attribute, data and message, called from setValidatePageValuesDE,
   * setValidatePageValuesDEC, setValidatePageValuesVD, setValidatePageValuesPV, setValidatePageValuesVM methods.
   * Attribute Name and Data added to the vector.
   * Checks if satisfies mandatory, length limit valid and adds the appropriate messages along with earlier message to the vecotr.
   * @param vb validate bean vector to display data on the page.
   * @param sItem Name of the attribute.
   * @param sContent input value of the attribute.
   * @param bMandatory true if attribute is a mandatory for submit.
   * @param iLengLimit integer value for length limit if any for the attribute.
   * @param strInValid invalid messages from other validation checks.
   * @param sOriginAction String origin action
   *
   */
    public static void setValPageVector(Vector<ValidateBean> vb, String sItem, String sContent, 
        boolean bMandatory, int iLengLimit, String strInValid, String sOriginAction)
    {
       String sValid = "Valid";
       String sNoChange = "No Change";
       String sMandatory = "This field is Mandatory. \n";
       if(sItem.equals("Effective End Date"))
         sMandatory = "Effective End Date field is Mandatory for this workflow status. \n";
       
       String attCon = "";
       String attStatus = "";
       if(sContent == null || sContent.equals("") || sContent.length() < 1)   // content emplty
       {
           attCon = "";  // content           
           if(bMandatory)
           {
               attStatus = sMandatory + strInValid;   //status, required field
               
           }
           else if(strInValid.equals(""))
           {
               if (sOriginAction.equals("BlockEditDE") || sOriginAction.equals("BlockEditDEC") || sOriginAction.equals("BlockEditVD"))
                 attStatus = sNoChange;   //status, OK, even empty, not require
               else
                 attStatus = sValid;
           }
           else
             attStatus = strInValid;
       }
       else                      // have something in content
       {
           attCon = sContent;   // content
           if(iLengLimit > 0)    // has length limit
           {
               if(sContent.length() > iLengLimit)  // not valid
               {
                 attStatus = sItem + " is too long. \n" + strInValid;
               }
               else
               {
                 if (strInValid.equals(""))
                   attStatus = sValid;   //status, OK, not exceed limit
                 else
                   attStatus = strInValid;
               }
           }
           else
           {
             if(strInValid.equals(""))
               attStatus = sValid;   //status, OK, not exceed limit
             else
               attStatus = strInValid;
           }
       }
       //fill in the bean
       ValidateBean vdBean = new ValidateBean();
       vdBean.setACAttribute(sItem);
       vdBean.setAttributeContent(attCon);
       vdBean.setAttributeStatus(attStatus);
       vb.addElement(vdBean);
   }

    /**
     * To get compared value to sort.
     * empty strings are considered as strings.
     * according to the fields, converts the string object into integer, double or dates.
     * @param sField 
     * @param firstName first name to compare.
     * @param SecondName second name to compare.
     *
     * @return int ComparedValue using compareto method of the object.
     *
     * @throws Exception
     */
    public int ComparedValue(String sField, String firstName, String SecondName)
            throws Exception
    {
        firstName = firstName.trim();
        SecondName = SecondName.trim();
        //this allows to put empty cells at the bottom by specify the return 
        if (firstName.equals(""))
           return 1;
        else if (SecondName.equals(""))
           return -1;
        String sFieldType = getFieldType(sField);
        if (sFieldType.equals("Integer"))
        {
           Integer iName1 = new Integer(firstName);
           Integer iName2 = new Integer(SecondName);
           return iName1.compareTo(iName2);
        }
        else if (sFieldType.equals("Double"))
        {
           Double dName1 = new Double(firstName);
           Double dName2 = new Double(SecondName);
           return dName1.compareTo(dName2);
        }
        else if (sFieldType.equals("Date"))        
        {
           SimpleDateFormat dteFormat = new SimpleDateFormat("MM/dd/yyyy");
           java.util.Date dtName1 = dteFormat.parse(firstName);
           java.util.Date dtName2 = dteFormat.parse(SecondName);
           return dtName1.compareTo(dtName2);
        }
        else
        {
           return firstName.compareToIgnoreCase(SecondName);
        }
    }

    private String getFieldType(String sField)
    {
      String stype = "";
      if (sField.equalsIgnoreCase("Public_ID"))
        stype = "Integer";
      else if (sField.equalsIgnoreCase("Version"))
        stype = "Double";
      return stype;
    }
    /**
     * @param pv PV bean object
     * @return string evs id
     */
    public static String getVMConcepts(PV_Bean pv)
    {
      String evsID = "";
      VM_Bean vm = pv.getPV_VM();
      Vector vmCon = vm.getVM_CONCEPT_LIST();
      for (int cc =0; cc < vmCon.size(); cc++)
      {
        EVS_Bean conBean = (EVS_Bean)vmCon.elementAt(cc);
        if (!evsID.equals("")) 
          evsID += "; &nbsp;";
        String conDB = conBean.getEVS_DATABASE();
        if (conDB.equals(EVSSearch.META_VALUE)) // "MetaValue")) 
          conDB = conBean.getEVS_ORIGIN();
        String conID = conBean.getCONCEPT_IDENTIFIER();
        if (conID != null && !conID.equals("")) 
          evsID += conID + "&nbsp;&nbsp;" + conDB;        
      }
      return evsID;
    }

    //close the class
}
