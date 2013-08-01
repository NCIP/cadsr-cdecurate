/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

/**
 * 
 */

package gov.nih.nci.cadsr.cdecurate.tool;

import gov.nih.nci.cadsr.cdecurate.database.SQLHelper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

/**
 * @author shegde
 * 
 */
public abstract class CommonACAction
{
    Logger             logger = Logger.getLogger(CommonACAction.class.getName());

    public HttpSession session;

    /**
     * 
     */
    public CommonACAction()
    {
        super();
    }

    // abstract methods
    abstract public String getSelect(String vmID, boolean isStatusFilter, String sOrder);

    abstract public void setExtras(CommonACBean ac, ResultSet rs) throws SQLException;

    abstract public void setUsedAttributes(VM_Bean vm, Vector<CommonACBean> vAC, boolean statFilter, String sortField);

    abstract public void sortACs(VM_Bean vm, String sortField);

    // public methods
    public Vector<CommonACBean> getAssociated(Connection conn, String vmID, boolean isStatusFilter, String sOrder)
    {
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Vector<CommonACBean> vACs = new Vector<CommonACBean>();
        try
        {
            // make sql
            String sSQL = getSelect(vmID, isStatusFilter, sOrder);
            // prepare statement
            pstmt = conn.prepareStatement(sSQL);
            // Now we are ready to call the function
            rs = pstmt.executeQuery();
            // get attributes from the recorset
            while (rs.next())
            {
                CommonACBean ac = getAttributes(rs);
                // add the element
                vACs.addElement(ac);
            }
        }
        catch (Exception e)
        {
            logger.error("ERROR - : " + e.toString(), e);
        }finally{
        	rs = SQLHelper.closeResultSet(rs);
            pstmt = SQLHelper.closePreparedStatement(pstmt);
        }
        return vACs;
    }
    

    public CommonACBean getAttributes(ResultSet rs) throws SQLException
    {
        CommonACBean ac = new CommonACBean();
        ac.setIdseq(rs.getString("idseq"));
        ac.setLongName(rs.getString("long_name"));
        ac.setPublicID(rs.getString("ac_id"));
        ac.setVersion(rs.getString("version"));
        ac.setContext(rs.getString("context"));
        ac.setWorkflowStatus(rs.getString("workflow"));
        setExtras(ac, rs);
        return ac;
    }

    public void sortACsBinary(Vector<CommonACBean> vAC, String sortField)
    {
        try
        {
            CommonACBean[] acArray = new CommonACBean[vAC.size()];
            String[] attrList = new String[vAC.size()];
            int max = 0;
            int min = 0;
            int top = 1;
            // add the first data to the array
            acArray[0] = vAC.elementAt(0);
            attrList[0] = acArray[0].getACFieldValue(sortField);
            UtilService util = new UtilService();
            // loop through the ac vector
            for (int i = 1; i < vAC.size(); i++)
            {
                max = top;
                CommonACBean curAC = vAC.elementAt(i);
                String curValue = curAC.getACFieldValue(sortField);
                int pos;
                while (true)
                {
                    pos = (min + max) / 2; // get the average
                    int compare = util.ComparedValue(sortField, curValue, attrList[pos]); // curValue.compareToIgnoreCase(attrList[pos]);
                    if (compare < 0)
                    {
                        if (max == pos)
                            break;
                        max = pos;
                    }
                    else if (compare > 0)
                    {
                        if (min == pos)
                        {
                            ++pos;
                            break;
                        }
                        min = pos;
                    }
                    else
                        break;
                }
                System.arraycopy(attrList, pos, attrList, pos + 1, top - pos);
                System.arraycopy(acArray, pos, acArray, pos + 1, top - pos);
                attrList[pos] = curValue;
                acArray[pos] = curAC;
                ++top;
            }
            // reaplce vector data with the array data
            for (int j = 0; j < acArray.length; j++)
            {
                vAC.setElementAt(acArray[j], j);
            }
        }
        catch (Exception e)
        {
            logger.error("ERROR for sortACs : ", e);
        }
    }

    public Vector<CommonACBean> sortACsBubble(Vector<CommonACBean> vAC, String sortField)
    {
        Vector<CommonACBean> vSorted = new Vector<CommonACBean>();
        try
        {
            UtilService util = new UtilService();
            // loop through the searched DE result to get the matched checked rows
            for (int i = 0; i < (vAC.size()); i++)
            {
                CommonACBean sortBean1 = (CommonACBean) vAC.elementAt(i);
                String Name1 = sortBean1.getACFieldValue(sortField);
                int tempInd = i;
                CommonACBean tempBean = sortBean1;
                String tempName = Name1;
                for (int j = i + 1; j < (vAC.size()); j++)
                {
                    CommonACBean sortBean2 = (CommonACBean) vAC.elementAt(j);
                    String Name2 = sortBean2.getACFieldValue(sortField);
                    if (util.ComparedValue(sortField, Name1, Name2) > 0)
                    {
                        if (tempInd == i)
                        {
                            tempName = Name2;
                            tempBean = sortBean2;
                            tempInd = j;
                        }
                        else if (util.ComparedValue(sortField, tempName, Name2) > 0)
                        {
                            tempName = Name2;
                            tempBean = sortBean2;
                            tempInd = j;
                        }
                    }
                }
                vAC.removeElementAt(tempInd);
                vAC.insertElementAt(sortBean1, tempInd);
                vSorted.addElement(tempBean);
            }
        }
        catch (Exception e)
        {
            logger.error("ERROR for sortACs : ", e);
        }
        return vSorted;
    }

    // protected methods
    @SuppressWarnings("unchecked")
    protected Vector<String> getStatusList()
    {
        Vector<String> vStat = (Vector) session.getAttribute(Session_Data.SESSION_ASL_FILTER);
        return vStat;
    }

    protected String formatArray(Vector vStat)
    {
        String s = "";
        for (int i = 0; i < vStat.size(); i++)
        {
            String st = (String) vStat.elementAt(i);
            if (st != null & !st.equals(""))
            {
                if (!s.equals(""))
                    s += ", "; // add comma
                s += "\'" + st + "\'"; // add string with quote
            }
        }
        return s;
    }
}
