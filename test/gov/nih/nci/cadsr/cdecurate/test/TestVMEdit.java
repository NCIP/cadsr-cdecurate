/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.test;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import oracle.jdbc.pool.OracleDataSource;

/**
 * @author shegde
 *
 */
public class TestVMEdit
{
    public Connection mConn;
    /**
     * 
     */
    public TestVMEdit()
    {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * @param args
     */
    public static void main(String[] args)
    {
        try
        {
            TestVMEdit vmt = new TestVMEdit();
            //get connection
            vmt.getConnection();
            //assign value for edit vm
            String conArray = null;
            String vmName = "Abdominal organs"; 
            String vmDesc = "changed defintion for Abdominal organs "; 
            String chgNote = "update change note for Abdominal organs"; 
            String condr = ""; 
            String sAct = "UPD";
            
/*            String conArray = "F65E9E1A-9B88-398B-E034-0003BA0B1A09";
            String vmName = "Site of relative exclusion";  
            String vmDesc = "changed defintion for Site of relative exclusion agian"; 
            String chgNote = "update change note for Site of relative exclusion again"; 
            String condr = ""; 
            String sAct = "UPD";
*/            
            //call method to edit vm
            String errMsg = vmt.setVM(conArray, vmName, vmDesc, chgNote, condr, sAct);
            System.out.println("Error message: " + errMsg);
            
            //close connection
            vmt.freeConnection();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }
    
    public void getConnection() throws Exception
    {
        String dburl = "cbiodb2-d.nci.nih.gov:1521:CBDEV";
        String user = "sbrext";
        String pswd = "jjuser";
        OracleDataSource ods = new OracleDataSource();
        if (dburl.indexOf(':') > 0)
        {
            String parts[] = dburl.split("[:]");
            ods.setDriverType("thin");
            ods.setServerName(parts[0]);
            ods.setPortNumber(Integer.parseInt(parts[1]));
            ods.setServiceName(parts[2]);
        }
        else
        {
            ods.setDriverType("oci8");
            ods.setTNSEntryName(dburl);
        }
        mConn = ods.getConnection(user, pswd);
    }
    
    public void freeConnection() throws Exception
    {
        if (mConn != null && !mConn.isClosed())
            mConn.close();
    }
    public String setVM(String conArray, String vmName, String vmDesc, String chgNote, String condr, String sAct)
    {
      ResultSet rs = null;
      CallableStatement cstmt = null;
      String stMsg = ""; // out
      try    
      {
        if (sAct == null) sAct = "INS";
        //get the connection from data if exists (used for testing)
        if (mConn != null && !mConn.isClosed())
        {
          cstmt = mConn.prepareCall("{call SBREXT.SCENPRO_CDE_CURATOR_PKG.SET_VM(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
          // register the Out parameters
          cstmt.registerOutParameter(1, java.sql.Types.VARCHAR); // return code
          cstmt.registerOutParameter(2, java.sql.Types.VARCHAR); // action
          cstmt.registerOutParameter(4, java.sql.Types.VARCHAR); // vm_idseq
          cstmt.registerOutParameter(5, java.sql.Types.VARCHAR); // preferred name
          cstmt.registerOutParameter(6, java.sql.Types.VARCHAR); // long name
          cstmt.registerOutParameter(7, java.sql.Types.VARCHAR); // preferred definition
          cstmt.registerOutParameter(8, java.sql.Types.VARCHAR); // context idseq
          cstmt.registerOutParameter(9, java.sql.Types.VARCHAR); // asl name
          cstmt.registerOutParameter(10, java.sql.Types.VARCHAR); // version
          cstmt.registerOutParameter(11, java.sql.Types.VARCHAR); // vm_id
          cstmt.registerOutParameter(12, java.sql.Types.VARCHAR); // latest version ind
          cstmt.registerOutParameter(13, java.sql.Types.VARCHAR); // condr idseq
          cstmt.registerOutParameter(14, java.sql.Types.VARCHAR); // definition source
          cstmt.registerOutParameter(15, java.sql.Types.VARCHAR); // origin
          cstmt.registerOutParameter(16, java.sql.Types.VARCHAR); // change note
          cstmt.registerOutParameter(17, java.sql.Types.VARCHAR); // begin date
          cstmt.registerOutParameter(18, java.sql.Types.VARCHAR); // end date
          cstmt.registerOutParameter(19, java.sql.Types.VARCHAR); // created by
          cstmt.registerOutParameter(20, java.sql.Types.VARCHAR); // date created
          cstmt.registerOutParameter(21, java.sql.Types.VARCHAR); // modified by
          cstmt.registerOutParameter(22, java.sql.Types.VARCHAR); // date modified

          // Set the In parameters (which are inherited from the PreparedStatement class)
          cstmt.setString(2, sAct);          
          cstmt.setString(3, conArray);
          //cstmt.setNull(3, java.sql.Types.VARCHAR);
          // set value meaning if action is to update
          if (sAct.equals("UPD") || conArray.equals(""))
            cstmt.setString(6, vmName);
          //definition and change note
          cstmt.setString(7, vmDesc);
          cstmt.setString(16, chgNote);
          //remove the concepts
          if (condr.equals(" "))
              cstmt.setString(13, null);
          
          System.out.println("before execture - ");
          System.out.println(" Name: " + vmName + ";");
          System.out.println(" Desc: " + vmDesc + ";");
          System.out.println(" change note: " + chgNote + ";");
          System.out.println(" condr: " + condr + ";");
          System.out.println(" conarray: " + conArray + ";");
          System.out.println(" action: " + sAct + ";");
          
          cstmt.execute();
          String sRet = cstmt.getString(1);
          if (sRet != null && !sRet.equals("") && !sRet.equals("API_VM_300"))
          {
            stMsg = "\\t" + sRet + " : Unable to update the Value Meaning - "
                + vmName + ".";
          }
          else
          {
            // store the vm attributes created by stored procedure in the bean
              System.out.println("Returned Results - " + sRet + " - ");
              System.out.println(" Name: " + cstmt.getString(6));
              System.out.println(" Desc: " + cstmt.getString(7));
              System.out.println(" change note: " + cstmt.getString(16));
              System.out.println(" condr: " + cstmt.getString(13));
              System.out.println(" vmidseq: " + cstmt.getString(4));
              System.out.println(" context: " + cstmt.getString(8));
              System.out.println(" asl: " + cstmt.getString(9));
              System.out.println(" ver: " + cstmt.getString(10));
              System.out.println(" vmid: " + cstmt.getString(11));
          }
        }
      }
      catch (Exception e)
      {
        stMsg += "\\tException : Unable to update VM attributes.";
        e.printStackTrace();
      }
      try
      {
        if (rs != null) rs.close();
        if (cstmt != null) cstmt.close();
      }
      catch (Exception ee)
      {
        stMsg += "\\tException : Unable to update VM attributes.";
        ee.printStackTrace();
      }
      return stMsg;
    }
    
}
