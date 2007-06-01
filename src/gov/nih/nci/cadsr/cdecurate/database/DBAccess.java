// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/database/DBAccess.java,v 1.33 2007-06-01 22:17:44 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.database;

import gov.nih.nci.cadsr.cdecurate.tool.AC_Bean;
import gov.nih.nci.cadsr.cdecurate.util.ToolException;
import gov.nih.nci.cadsr.cdecurate.util.Tree;
import gov.nih.nci.cadsr.cdecurate.util.TreeNode;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;
import org.apache.log4j.Logger;

/**
 * This class encapsulates the caDSR database access.
 * 
 * @author lhebel
 */
public class DBAccess
{
    /**
     * A class test method during development.
     * 
     * @param args [0] the database URL
     */
    public static void main(String[] args)
    {
        // Check the arguments.
        if (args.length != 1)
        {
            System.err.println("Missing database connection URL.");
            return;
        }

        // This is a test so it is not necessary to create a connection pool or other more elaborate obfuscations.
        try
        {
            FileOutputStream fout = new FileOutputStream("d:/temp/dbaccessout.txt");
            
            DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());

            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@" + args[0], "guest", "guest");
            DBAccess db = new DBAccess(conn);

            // Set the test AC IDSEQ.
            String ac = "F8E452D6-E410-4E12-E034-0003BA0B1A09";
            
            // Get the AC title.
            String title = db.getACtitle("UNKNOWN", ac);
            fout.write(title.getBytes());
            fout.write(Alternates._HTMLprefix.getBytes());

            // Get the Alternate Names and Definitions for the AC.
            Alternates[] alts = db.getAlternates(new String[] {ac}, true, true);

            // Output each with the desired related information.
            int flag = -1;
            for (Alternates temp : alts)
            {
                String html;
                if (flag != temp.getInstance())
                {
                    flag = temp.getInstance();
                    switch (temp.getInstance())
                    {
                    case Alternates._INSTANCEDEF:
                        fout.write("<tr><td style=\"border-top: 2px solid black\" colspan=\"4\"><p style=\"margin: 0.3in 0in 0in 0in\"><b>Definitions</b></p></td></tr>\n".getBytes());
                        break;
                    case Alternates._INSTANCENAME:
                        fout.write("<tr><td style=\"border-top: 2px solid black\" colspan=\"4\"><p style=\"margin: 0.3in 0in 0in 0in\"><b>Names</b></p></td></tr>\n".getBytes());
                        break;
                    default:
                        fout.write("<tr><td style=\"border-top: 2px solid black\" colspan=\"4\"><p style=\"margin: 0.3in 0in 0in 0in\"><b>UNKNOWN</b></p></td></tr>\n".getBytes());
                        break;
                    }
                }
                html = temp.toHTML();
                fout.write(html.getBytes());
            }
            
            Tree csi;
            csi = db.getAlternates(ac, true);
            title = Alternates._HTMLsuffix + "<hr/>\n" + Alternates._HTMLprefix + csi.toHTML(null);
            fout.write(title.getBytes());
            
            // Show the full CSI tree.
            csi = db.getCSI();
            title = Alternates._HTMLsuffix + "<hr/>\n" + Alternates._HTMLprefix + csi.toHTML(null) + Alternates._HTMLsuffix;
            fout.write(title.getBytes());

            // Close the database connection.
            conn.close();
        }
        catch (SQLException ex)
        {
            ex.printStackTrace();
        }
        catch (ToolException ex)
        {
            ex.printStackTrace();
        }
        catch (FileNotFoundException ex)
        {
            ex.printStackTrace();
        }
        catch (IOException ex)
        {
            ex.printStackTrace();
        }
    }

    /**
     * Constructor. This class doesn't care how a connection is acquired, e.g. connection pool or dedicated, it
     * relies on the caller to perform the necessary calls.
     * 
     * @param conn_ the established database connection
     */
    public DBAccess(Connection conn_)
    {
        _conn = conn_;

        // There is special processing around the UML_PACKAGE_NAME and UML_PACKAGE_ALIAS
        if (_packageAlias == null || _packageName == null)
        {
            // Get the CSI type values from the tool options. We don't care what they are called as long as we have the
            // right value.
            String select = "select property, value from sbrext.tool_options_view_ext where tool_name = 'CURATION' and property like 'CSI.%' ";
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try
            {
                pstmt = _conn.prepareStatement(select);
                rs = pstmt.executeQuery();
                
                // Set the static variables appropriately.
                while (rs.next())
                {
                    String property = rs.getString(1);
                    String value = rs.getString(2);
                    if (property.equals("CSI.PACKAGE.ALIAS"))
                        _packageAlias = value;
                    else if (property.equals("CSI.PACKAGE.NAME"))
                        _packageName = value;
                }

                rs.close();
                pstmt.close();
            }
            catch (SQLException ex)
            {
                // Log the error but keep going.
                _log.error(ex.toString());
                
                try
                {
                    if (rs != null)
                        rs.close();
                    if (pstmt != null)
                        pstmt.close();
                }
                catch (SQLException e)
                {
                }
            }
            
            // This only has to be done once. And either both are read or both are set blank.
            if (_packageAlias == null || _packageName == null)
            {
                _packageAlias = "";
                _packageName = "";
            }
        }
    }

    /**
     * A container class to simplify the data retrieval.
     * 
     * @author lhebel
     */
    private static class CSIData
    {
        /**
         * Constructor
         * @param node_ a tree node
         * @param level_ the hierarchy level
         */
        public CSIData(TreeNode node_, int level_)
        {
            _level = level_;
            _node = node_;
        }

        public int _level;
        public TreeNode _node;
    }

    /**
     * Get the Class Scheme Item hierarchy for the Alternate Name or Definition provided by the caller.
     * 
     * @param alt_ the Alternate Name or Definition for which to retrieve the Class Scheme Item hierarchy.
     * @throws ToolException 
     */
    private void getAlternatesCSI(Alternates alt_) throws ToolException
    {
        Vector<CSIData> test = getAlternatesCSI(alt_.getAltIdseq(), null);
        
        // Take the content of the Vector and turn it into arrays for use by the Tree class.
        TreeNode[] nodes = new TreeNode[test.size()];
        int[] levels = new int[nodes.length];
        for (int i = 0; i < nodes.length; ++i)
        {
            CSIData temp = test.get(i);
            nodes[i] = temp._node;
            levels[i] = temp._level;
        }

        // Create the CSI tree for this Alternate Name/Def
        alt_.addCSI(nodes, levels);
    }
    
    /**
     * This convenience class holds composite information.
     * 
     * @author lhebel
     *
     */
    private class ATTData
    {
        public ATTData(String aidseq_, String cidseq_)
        {
            _aidseq = aidseq_;
            _cidseq = cidseq_;
        }
        /**
         * The ATT_IDSEQ, database id for the record associating the CSI with the Alternate Name/Definition
         */
        public String _aidseq;
        
        /**
         * The CS_CSI_IDSEQ
         */
        public String _cidseq;
    }

    /**
     * Get the CSI references for the Alternate specified.
     * 
     * @param idseq_ the Alternate Name or Definition
     * @return the associated CSI's 
     * @throws ToolException
     */
    private Vector<ATTData> getAlternatesCSI1(String idseq_) throws ToolException
    {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String select = "select za.aca_idseq, za.cs_csi_idseq from sbrext.ac_att_cscsi_view_ext za where za.att_idseq = ?";

        try
        {
            // A simple query and storage into a vector.
            pstmt = _conn.prepareStatement(select);
            pstmt.setString(1, idseq_);
            rs = pstmt.executeQuery();
            Vector<ATTData> adata = new Vector<ATTData>();
            while (rs.next())
            {
                adata.add(new ATTData(rs.getString(1), rs.getString(2)));
            }
            rs.close();
            pstmt.close();
            
            return adata;
        }
        catch (SQLException ex)
        {
            _log.error("SQL: " + select, ex);
            try
            {
                if (rs != null)
                    rs.close();
                if (pstmt != null)
                    pstmt.close();
            }
            catch (SQLException e)
            {
            }
            throw new ToolException(ex);
        }
    }

    /**
     * Get the Class Scheme Item hierarchy for the Alternate Name or Definition provided by the caller.
     * 
     * @param idseq_ the Alternate Name or Definition database id
     * @return the CSI hierarchy
     * @throws ToolException 
     */
    private Vector<CSIData> getAlternatesCSI(String idseq_, Alternates alt_) throws ToolException
    {
        // Get the SQL select statement
        String select = SQLSelectCSI.getAlternatesCSISelect(_packageAlias);
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try
        {
            Vector<CSIData> list = new Vector<CSIData>();

            // First retrieve the intersection records.
            Vector<ATTData> adata = getAlternatesCSI1(idseq_);
            if (adata.size() == 0)
            {
                if (alt_ == null)
                    return list;
                
                // No related CSI so create an artificial group called "unclassified"
                CSIData temp = new CSIData(new TreeNodeCS("(unclassified)", "(unclassified)", "Unclassified Alternate Names and Definitions.", null, null, false), 0);
                list.add(temp);
                list.add(new CSIData(new TreeNodeAlt(alt_, alt_.getAltIdseq()), 1));
                return list;
            }
            
            // Because the retrieval is bottom-up (starts with the leaf and works up to the parent Classification Scheme) and
            // we want to show it to the user top-down we have to flip the results around. To do this we use a Vector and
            // always add the new record at the top (like a LIFO stack).
            CSIData lastStop = null;
            pstmt = _conn.prepareStatement(select);
            
            for (ATTData tdata : adata)
            {
                // Retrieve the CSI data for this Alternate Name/Def
                pstmt.setString(SQLSelectCSI._ARGCSCSIIDSEQ, tdata._cidseq);
                rs = pstmt.executeQuery();
    
                int level = 0;
                int prevLevel = 0;
                TreeNodeCSI prevTnc = null;
                String prevCSValue = "";
                String prevCSName = "";
                String prevCSDef = null;
                String prevCSVers = null;
                String prevCSConte = null;
                String csValue = "";
                String acaValue = tdata._aidseq;
                boolean extra = false;
                while (true)
                {
                    // If we didn't read anything, set the loop to terminate.
                    boolean loop = rs.next();
                    if (loop)
                    {
                        level = rs.getInt(SQLSelectCSI._LEVEL);
                        csValue = rs.getString(SQLSelectCSI._CSIDSEQ);

                        if (alt_ != null && level == 1)
                        {
                            list.add(0, new CSIData(new TreeNodeAlt(alt_, tdata._aidseq), level - 1));
                        }
                    }
                    
                    // We only do this after the first time through the loop OR said another way, skip
                    // this the first time here.
                    if (extra)
                    {
                        // Whenever the level is 1 it means we are at a new leaf. If we are at a leaf and
                        // the Classification Scheme has changed, record a new CS record. If this is
                        // the last time through the loop be sure to write a new CS record for any data
                        // holding in the stack.
                        if ((level == 1 && prevCSValue.equals(csValue) == false) || loop == false) 
                        {
                            ++prevLevel;
                            CSIData stop = new CSIData(new TreeNodeCS(prevCSName, prevCSValue, prevCSDef, prevCSVers, prevCSConte, false), prevLevel);
                            list.add(0, stop);
                            
                            // To be properly represented as levels in a hierarchy, 0 is the top (the CS record)
                            // and 'N' is a child. To sequence the numbers we use the max previous level
                            // and subtract the recorded level.
                            for (CSIData temp : list)
                            {
                                // When a level is zero, we can stop because a previous CS group is starting.
                                if (temp == lastStop)
                                    break;
                                
                                // This subtract basically "flips" the level around. A variable has to be used as
                                // there's no way to predetermine how deep a hierarchy may be.
                                temp._level = prevLevel - temp._level;
                            }
                            lastStop = stop;
                        }
                    }

                    // We have finished the data retrieval so end the loop.
                    if (loop == false)
                        break;
    
                    // Always save the data retrieved and remember this record for reference should the
                    // next record prompt the need for a CS parent record.
                    String csiType = rs.getString(SQLSelectCSI._CSITYPE);
                    String csCsiIdseq = rs.getString(SQLSelectCSI._CSCSIIDSEQ);
                    if (acaValue == null)
                        acaValue = csCsiIdseq;
                    TreeNodeCSI tnc = new TreeNodeCSI(rs.getString(SQLSelectCSI._CSINAME), acaValue, csCsiIdseq, csiType, null, false);
                    list.add(0, new CSIData(tnc, level));
                    prevCSValue = csValue;
                    prevCSName = rs.getString(SQLSelectCSI._CSNAME);
                    prevCSDef = rs.getString(SQLSelectCSI._CSDEFIN);
                    prevCSVers = rs.getString(SQLSelectCSI._CSVERS);
                    prevCSConte = rs.getString(SQLSelectCSI._CSCONTE);
                    prevLevel = level;

                    if (csiType.equals(_packageName))
                    {
                        prevTnc = tnc;
                    }
                    else if (prevTnc != null)
                    {
                        if (csiType.equals(_packageAlias))
                            prevTnc.setPackageAlias(acaValue);
                        prevTnc = null;
                    }
                    acaValue = null;
                    
                    // Flag to start processing CS records.
                    extra = true;
                }
                rs.close();
            }
            
            // Clean up the database connection.
            pstmt.close();
            
            return list;
        }
        catch (SQLException ex)
        {
            _log.error("SQL: " + select, ex);
            try
            {
                if (rs != null)
                    rs.close();
                if (pstmt != null)
                    pstmt.close();
            }
            catch (SQLException e)
            {
            }
            throw new ToolException(ex);
        }
    }

    /**
     * Get the CSI Lineage for the CSI specified
     * 
     * @param idseq_ the CS_CSI_IDSEQ for the desired CS
     * @param root_ the Tree to hold the query results
     * @throws ToolException
     */
    public void getCSILineage(String idseq_, Tree root_) throws ToolException
    {
        // Get the SQL select
        String select = SQLSelectCSI.getAlternatesCSISelect(_packageAlias);
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try
        {
            // Get the lineage (child to parent) from CSI to CS.
            pstmt = _conn.prepareStatement(select);
            pstmt.setString(SQLSelectCSI._ARGCSCSIIDSEQ, idseq_);
            rs = pstmt.executeQuery();

            // Because this returns "bottom up" each entry is added at the
            // top of the vector to change the order to "top down"
            Vector<CSIData> lineage = new Vector<CSIData>();
            String csName = null;
            String csValue = null;
            String csDef = null;
            String csVers = null;
            String csConte = null;
            TreeNodeCSI prevTnc = null;
            while (rs.next())
            {
                csName = rs.getString(SQLSelectCSI._CSNAME);
                csValue = rs.getString(SQLSelectCSI._CSIDSEQ);
                csDef = rs.getString(SQLSelectCSI._CSDEFIN);
                csVers = rs.getString(SQLSelectCSI._CSVERS);
                csConte = rs.getString(SQLSelectCSI._CSCONTE);

                String csiName = rs.getString(SQLSelectCSI._CSINAME);
                String csiValue = rs.getString(SQLSelectCSI._CSCSIIDSEQ);
                String csiType = rs.getString(SQLSelectCSI._CSITYPE);
                int level = rs.getInt(SQLSelectCSI._LEVEL);
                TreeNodeCSI tnc = new TreeNodeCSI(csiName, csiValue, csiValue, csiType, null, true);
                lineage.add(0, new CSIData(tnc, level));
                if (level == 2 && csiType.equals(_packageAlias))
                    prevTnc.setPackageAlias(csiValue);
                prevTnc = tnc;
            }
            if (csValue != null)
                lineage.add(0, new CSIData(new TreeNodeCS(csName, csValue, csDef, csVers, csConte, false), 0));
            
            rs.close();
            pstmt.close();
    
            // Take the content of the Vector and turn it into arrays for use by the Tree class. The level
            // is reset because the smallest value must appear first. Being a direct route child-to-parent only
            // 1 parent exists for each child and only 1 child exists for each parent in the result set.
            TreeNode[] nodes = new TreeNode[lineage.size()];
            int[] levels = new int[nodes.length];
            for (int i = 0; i < nodes.length; ++i)
            {
                CSIData temp = lineage.get(i);
                nodes[i] = temp._node;
                levels[i] = i;
            }
            
            // Add the hierarchy to the object Tree
            root_.addHierarchy(nodes, levels);
        }
        catch (SQLException ex)
        {
            _log.error("SQL: " + select, ex);
            try
            {
                if (rs != null)
                    rs.close();
                if (pstmt != null)
                    pstmt.close();
            }
            catch (SQLException e)
            {
            }
            throw new ToolException(ex);
        }
    }

    /**
     * Execute the SQL query to retrieve the Alternate Names and Definitions.
     * 
     * @param pstmt_ the SQL select statement
     * @param idseq_ the parent AC idseq
     * @return the results set of all Alternate Names and Definitions associated to the specified AC
     * @throws ToolException
     */
    private ResultSet getAlternates(PreparedStatement pstmt_, String idseq_) throws ToolException
    {
        ResultSet rs = null;
        try
        {
            // It is important for the data to match the values expected in the logic. This also provides a means to
            // sort the results and ensure the order is guaranteed.
            pstmt_.setInt(SQLSelectAlts._ARGDESINST, Alternates._INSTANCENAME);
            pstmt_.setString(SQLSelectAlts._ARGDESACIDSEQ, idseq_);
            pstmt_.setInt(SQLSelectAlts._ARGDEFINST, Alternates._INSTANCEDEF);
            pstmt_.setString(SQLSelectAlts._ARGDEFACIDSEQ, idseq_);
            rs = pstmt_.executeQuery();
        }
        catch (SQLException ex)
        {
            try
            {
                if (rs != null)
                    rs.close();
                pstmt_.close();
            }
            catch (SQLException e)
            {
            }
            throw new ToolException(ex);
        }
        
        return rs;
    }
    
    /**
     * Get the Alternate Names and Definitions for a specific Administered Component. The result is a
     * Tree with the Alt Name/Def subordinate to the CSI to which it is related. This is a more traditional
     * "file system" view of the Alt Name/Def with the CS as the progenator.
     * 
     * @param idseq_ the AC database it
     * @return the CSI and Alt Name/Def hierarchy.
     * @throws ToolException
     */
    public Tree getAlternates(String idseq_, boolean showMC_) throws ToolException
    {
        Tree root = new Tree(new TreeNode("Alternate Names & Definitions", null, false));
        String select = SQLSelectAlts.getAlternates(true);
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs2 = null;
        try
        {
            // It is important for the data to match the values expected in the logic. This also provides a means to
            // sort the results and ensure the order is guaranteed.
            pstmt = _conn.prepareStatement(select);
            rs = getAlternates(pstmt, idseq_);

            // Read the results.
            Vector<Alternates> altList = new Vector<Alternates>();
            while (rs.next())
            {
                altList.add(SQLSelectAlts.copyFromRS(rs, showMC_));
            }
            
            rs.close();
            pstmt.close();

            for (Alternates alt : altList)
            {
                // Get the CSI for each Alternate.
                Vector<CSIData> test = getAlternatesCSI(alt.getAltIdseq(), alt);
                
                // Take the content of the Vector and turn it into arrays for use by the Tree class.
                TreeNode[] nodes = new TreeNode[test.size()];
                int[] levels = new int[nodes.length];
                for (int i = 0; i < nodes.length; ++i)
                {
                    CSIData temp = test.get(i);
                    nodes[i] = temp._node;
                    levels[i] = temp._level;
                }
                
                // Add the hierarchy to the Alternate CSI tree.
                root.addHierarchy(nodes, levels);
            }
        }
        catch (SQLException ex)
        {
            _log.error("SQL: " + select, ex);
            try
            {
                if (rs2 != null)
                    rs2.close();
                if (pstmt2 != null)
                    pstmt2.close();
            }
            catch (SQLException e)
            {
            }
            throw new ToolException(ex);
        }
        catch (ToolException ex)
        {
            _log.error("SQL: " + select, ex);
            try
            {
                if (rs2 != null)
                    rs2.close();
                if (pstmt2 != null)
                    pstmt2.close();
            }
            catch (SQLException e)
            {
            }
            throw ex;
        }
        
        // Return the Tree (This is normally viewed on the UI from the "View by CS/CSI" tab.
        return root;
    }
    
    /**
     * Get the Alternate Names and Definitions for a specific Administered Component. The result is a
     * list which contains the Alternate and the hierarchy of CSI to which it is related.
     * 
     * @param idseq_ the AC database id
     * @param sortByName_ true to sort the results by the text for "name" and false to sort by type;
     *          in either case the results are grouped by Alt Name first then Alt Definition.
     * @return the array of Alternate Names and Definitions
     * @throws  ToolException 
     */
    public Alternates[] getAlternates(String[] idseq_, boolean sortByName_, boolean showMC_) throws ToolException
    {
        Alternates[] list = new Alternates[0];
        
        String select = SQLSelectAlts.getAlternates(sortByName_);
        try
        {
            // It is important for the data to match the values expected in the logic. This also provides a means to
            // sort the results and ensure the order is guaranteed.
            PreparedStatement pstmt = _conn.prepareStatement(select);
            
            Vector<Alternates> temp = new Vector<Alternates>();
            for (int i = 0; i < idseq_.length; ++i)
            {
                ResultSet rs = getAlternates(pstmt, idseq_[i]);
                
                // Because the ORDER BY clause ensures the order, we only need to copy the data as it's
                // read.
                while (rs.next())
                {
                    temp.add(SQLSelectAlts.copyFromRS(rs, showMC_));
                }
                rs.close();
            }
            
            // Clean up
            pstmt.close();
            
            // Convert the result Vector to an array and get the CSI hierarchy for each Alternate Name
            // or Definition.
            list = new Alternates[temp.size()];
            for (int i = 0; i < list.length; ++i)
            {
                list[i] = temp.get(i);
                getAlternatesCSI(list[i]);
            }
        }
        catch (SQLException ex)
        {
            _log.error("SQL: " + select, ex);
            throw new ToolException(ex);
        }
        catch (ToolException ex)
        {
            _log.error("SQL: " + select, ex);
            throw ex;
        }

        // Return the result list complete with CSI information.
        return list;
    }
    
    /**
     * Delete all Alternates for the AC.
     * 
     * @param idseq_ the AC database id
     * @throws SQLException
     */
    public void deleteAlternates(String idseq_) throws SQLException
    {
        String delete;
        PreparedStatement pstmt = null;
        
        try
        {
            delete = "delete from sbr.designations_view where ac_idseq = ?";
            pstmt = _conn.prepareStatement(delete);
            pstmt.setString(1, idseq_);
            pstmt.executeUpdate();
            pstmt.close();
            
            delete = "delete from sbr.definitions_view where ac_idseq = ?";
            pstmt = _conn.prepareStatement(delete);
            pstmt.setString(1, idseq_);
            pstmt.executeUpdate();
            pstmt.close();
        }
        catch (SQLException ex)
        {
            if (pstmt != null)
            {
                try
                {
                    pstmt.close();
                }
                catch (SQLException e)
                {
                }
            }
            throw ex;
        }
    }

    /**
     * Retrieve the formatted title for the specified AC. Currently the format is
     * <label>: <name> [<public id>v<version>]
     * This method ensures a consistency in display and allows for easy maintenance should
     * the format need to change.
     * 
     * @param idseq_ the AC database id
     * @return the formatted title string as described above
     * @throws ToolException
     */
    public String getACtitle(String defName_, String idseq_) throws ToolException
    {
        if (idseq_ == null || idseq_.length() == 0)
            return "NEW " + ACTypes.valueOf(defName_).getName();

        // All AC records appear in the admin_components_view in addition to the individual tables, e.g. data_elements_view. The
        // information needed for the output is contained in the one view which simplifies the SQL.
        String select = "select actl_name, long_name, public_id, version from sbr.admin_components_view where ac_idseq = ?";
        String title = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try
        {
            pstmt = _conn.prepareStatement(select);
            pstmt.setString(1, idseq_);
            rs = pstmt.executeQuery();
            
            // There will be only 1 result if any. Format and return to the caller.
            if (rs.next())
            {
                String type = rs.getString(1);
                ACTypes acType = ACTypes.valueOf(type);
                String name = rs.getString(2);
                String pid = rs.getString(3);
                String vers = rs.getString(4);
                if (vers.indexOf('.') < 0)
                    vers += ".0";
                title = acType.getName() + ": <b>" + name + "</b><br/> [" + pid + "v" + vers + "]";
            }
            rs.close();
            pstmt.close();
        }
        catch (SQLException ex)
        {
            _log.error("SQL: " + select, ex);
            try
            {
                if (rs != null)
                    rs.close();
                if (pstmt != null)
                    pstmt.close();
            }
            catch (SQLException e)
            {
            }
            throw new ToolException(ex);
        }

        // Return a formatted result or null if the AC was not found.
        return title;
    }

    /**
     * Delete the Alternate Name from the database.
     * 
     * @param idseq_ the database id
     * @throws ToolException
     */
    public void deleteAltName(String idseq_) throws ToolException
    {
        String select = "delete from sbr.designations_view where ac_idseq = ?";
        PreparedStatement pstmt = null;
        try
        {
            pstmt = _conn.prepareStatement(select);
            pstmt.setString(1, idseq_);
            pstmt.executeUpdate();
            pstmt.close();
        }
        catch (SQLException ex)
        {
            _log.error("SQL: " + select, ex);
            try
            {
                if (pstmt != null)
                    pstmt.close();
            }
            catch (SQLException e)
            {
            }
            throw new ToolException(ex);
        }
    }

    /**
     * Delete the Alternate Definition from the database.
     * 
     * @param idseq_ the database id.
     * @throws ToolException
     */
    public void deleteAltDef(String idseq_) throws ToolException
    {
        String select = "delete from sbr.definitions_view where ac_idseq = ?";
        PreparedStatement pstmt = null;
        try
        {
            pstmt = _conn.prepareStatement(select);
            pstmt.setString(1, idseq_);
            pstmt.executeUpdate();
            pstmt.close();
        }
        catch (SQLException ex)
        {
            _log.error("SQL: " + select, ex);
            try
            {
                if (pstmt != null)
                    pstmt.close();
            }
            catch (SQLException e)
            {
            }
            throw new ToolException(ex);
        }
    }
    
    /**
     * Retrieve the Class Scheme hierarchy from the caDSR.
     * 
     * @return the CSI tree for the entire caDSR
     */
    public Tree getCSI() throws ToolException
    {
        // Because the CSI is a hierarchy we can not sort it in the SQL. The Tree.add() methods will ensure the
        // syblings are sorted case insensitive.
        String select = SQLSelectCSIAll.getCSIHierarchy();
        
        Tree root = new Tree(new TreeNode("Class Scheme Items", null, false));
        
        Statement stmt = null;
        ResultSet rs = null;
        try
        {
            // Retrieve the hierarchy and add a CS record at the top of each new branch.
            stmt = _conn.createStatement();
            rs = stmt.executeQuery(select);
            
            Vector<CSIData> test = new Vector<CSIData>();
            String lastCS = "";
            String prevValue = null;
            while (rs.next())
            {
                int level = rs.getInt(SQLSelectCSIAll._LEVEL);
                if (level == 1)
                {
                    // This may be the beginning of a new branch.
                    String csIdseq = rs.getString(SQLSelectCSIAll._CSIDSEQ);
                    if (!lastCS.equals(csIdseq))
                    {
                        // It is a new branch so make the level 1 less than the current data.
                        String csName = rs.getString(SQLSelectCSIAll._CSNAME);
                        String csDefin = rs.getString(SQLSelectCSIAll._CSDEFIN);
                        String csVers = rs.getString(SQLSelectCSIAll._CSVERS);
                        String csConte = rs.getString(SQLSelectCSIAll._CSCONTE);
                        TreeNodeCS tnc = new TreeNodeCS(csName, csIdseq, csDefin, csVers, csConte, false);
                        test.add(new CSIData(tnc, level - 1));
                        lastCS = csIdseq;
                    }
                }
                
                // Add the CSI record to the cache.
                String csiName = rs.getString(SQLSelectCSIAll._CSINAME);
                String csiValue = rs.getString(SQLSelectCSIAll._CSCSIIDSEQ);
                String csiType = rs.getString(SQLSelectCSIAll._CSITYPE);
                TreeNodeCSI tnc = new TreeNodeCSI(csiName, csiValue, csiValue, csiType, prevValue, false);
                test.add(new CSIData(tnc, level));
                prevValue = (csiType.equals(_packageAlias)) ? csiValue : null;
            }
            
            // Clean up
            rs.close();
            stmt.close();

            // Convert to arrays to add to the Tree
            TreeNode[] nodes = new TreeNode[test.size()];
            int[] levels = new int[nodes.length];
            for (int i = 0; i < nodes.length; ++i)
            {
                CSIData temp = test.get(i);
                nodes[i] = temp._node;
                levels[i] = temp._level;
            }

            // Build the hierarchy in the Tree
            root.addHierarchy(nodes, levels);
        }
        catch (SQLException ex)
        {
            _log.error("SQL: " + select);
            try
            {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
            }
            catch (SQLException e)
            {
            }
            throw new ToolException(ex);
        }

        // Return the Tree root.
        return root;
    }

    /**
     * Insert an Alternate Name or Definition into the database.
     * 
     * @param alt_ the Alternate
     * @param sql_ the SQL insert
     * @throws SQLException
     */
    private void insertAlt(Alternates alt_, String sql_) throws SQLException
    {
        try
        {
            CallableStatement cstmt = _conn.prepareCall(sql_);
            cstmt.setString(1, alt_.getAcIdseq());
            cstmt.setString(2, alt_.getConteIdseq());
            cstmt.setString(3, alt_.getName());
            cstmt.setString(4, alt_.getType());
            cstmt.setString(5, alt_.getLanguage());
            cstmt.registerOutParameter(6, java.sql.Types.VARCHAR);
            cstmt.executeUpdate();
            alt_.setAltIdseq(cstmt.getString(6));
            cstmt.close();
        }
        catch (SQLException ex)
        {
            throw ex;
        }
    }

    /**
     * Insert an Alternate Name into the database
     * 
     * @param alt_ the Alternate object
     * @throws SQLException
     */
    private void insertAltName(Alternates alt_) throws SQLException
    {
        String insert = "begin insert into sbr.designations_view "
            + "(ac_idseq, conte_idseq, name, detl_name, lae_name) "
            + "values (?, ?, ?, ?, ?) return desig_idseq into ?; end;";
        
        insertAlt(alt_, insert);
    }

    /**
     * Insert an Alternate Defintion into the database
     * 
     * @param alt_ the Alternate object
     * @throws SQLException
     */
    private void insertAltDef(Alternates alt_) throws SQLException
    {
        String insert = "begin insert into sbr.definitions_view "
            + "(ac_idseq, conte_idseq, definition, defl_name, lae_name) "
            + "values (?, ?, ?, ?, ?) return defin_idseq into ?; end;";
        
        insertAlt(alt_, insert);
    }
    
    /**
     * Insert an Alternate into the database
     * 
     * @param alt_ the Alternate
     * @throws SQLException
     */
    private void insert(Alternates alt_) throws SQLException
    {
        if (alt_.isName())
            insertAltName(alt_);
        else
            insertAltDef(alt_);
    }

    /**
     * Update an Alternate
     * 
     * @param alt_ the Alternate
     * @param sql_ the SQL update
     * @throws SQLException
     */
    private void updateAlt(Alternates alt_, String sql_) throws SQLException
    {
        try
        {
            PreparedStatement pstmt = _conn.prepareStatement(sql_);
            pstmt.setString(1, alt_.getName());
            pstmt.setString(2, alt_.getType());
            pstmt.setString(3, alt_.getLanguage());
            pstmt.setString(4, alt_.getAltIdseq());
            pstmt.executeUpdate();
            
            pstmt.close();
        }
        catch (SQLException ex)
        {
            throw ex;
        }
    }

    /**
     * Update an Alternate Name
     * 
     * @param alt_ the Alternate
     * @throws SQLException
     */
    private void updateAltName(Alternates alt_) throws SQLException
    {
        String update = "update sbr.designations_view set name = ?, detl_name = ?, lae_name = ? where desig_idseq = ?";

        updateAlt(alt_, update);
    }

    /**
     * Update an Alternate Definition
     * 
     * @param alt_ the Alternate
     * @throws SQLException
     */
    private void updateAltDef(Alternates alt_) throws SQLException
    {
        String update = "update sbr.definitions_view set definition = ?, defl_name = ?, lae_name = ? where defin_idseq = ?";
        
        updateAlt(alt_, update);
    }

    /**
     * Update an Alternate
     * 
     * @param alt_ the Alternate
     * @throws SQLException
     */
    private void update(Alternates alt_) throws SQLException
    {
        if (alt_.isName())
            updateAltName(alt_);
        else
            updateAltDef(alt_);
    }

    /**
     * Save CSI and Alternate Name/Definition associations
     * 
     * @param alt_ the Alternate
     * @throws SQLException
     */
    private void saveCSI(Alternates alt_) throws SQLException
    {
        Vector<TreeNode> list;

        // Add new ones first.
        list = alt_.getCSITree().findNew();
        if (list.size() > 0)
        {
            String insert = "insert into sbrext.ac_att_cscsi_view_ext (cs_csi_idseq, att_idseq, atl_name) values (?, ?, ?)";
            
            PreparedStatement pstmt = _conn.prepareStatement(insert);

            // Prepare and insert the new associations
            for (TreeNode node : list)
            {
                if (node instanceof TreeNodeCSI)
                {
                    // Only do if we have a CSI node.
                    String atlName = (alt_.isName()) ? "DESIGNATION" : "DEFINITION";
                    pstmt.setString(1, node.getValue());
                    pstmt.setString(2, alt_.getAltIdseq());
                    pstmt.setString(3, atlName);
                    
                    pstmt.executeUpdate();
                    
                    // For UML_PACKAGE_NAME also associate to the UML_PACKAGE_ALIAS
                    TreeNodeCSI temp = (TreeNodeCSI) node;
                    if (temp.isPackageName())
                    {
                        String alias = temp.getPackageAlias();
                        pstmt.setString(1, alias);
                        pstmt.setString(2, alt_.getAltIdseq());
                        pstmt.setString(3, atlName);
                    }
                }
            }
    
            // Done with the new ones.
            pstmt.close();
        }

        // Remove ones we don't want to keep.
        list = alt_.getCSITree().findDeleted();
        if (list.size() > 0)
        {
            String insert = "delete from sbrext.ac_att_cscsi_view_ext where aca_idseq = ?";
            
            PreparedStatement pstmt = _conn.prepareStatement(insert);
            
            // Prepare and delete unwanted associations.
            for (TreeNode node : list)
            {
                if (node instanceof TreeNodeCSI)
                {
                    pstmt.setString(1, node.getValue());
                    
                    pstmt.executeUpdate();

                    // Again UML_PACKAGE_NAME is extra work.
                    TreeNodeCSI temp = (TreeNodeCSI) node;
                    if (temp.isPackageName())
                    {
                        PreparedStatement stmt = _conn.prepareStatement("delete from sbrext.ac_att_cscsi_view_ext where cs_csi_idseq = ? and att_idseq = ? and atl_name = ?");
                        stmt.setString(1, temp.getPackageAlias());
                        stmt.setString(2, alt_.getAltIdseq());
                        stmt.setString(3, "DESIGNATION");
                        stmt.executeUpdate();
                        stmt.close();
                    }
                }
            }

            // Done with deletes.
            pstmt.close();
        }
    }

    /**
     * Delete an Alternate Name/Definition
     * 
     * @param sql_ the SQL delete
     * @param idseq_ the Alternate database id
     * @throws SQLException
     */
    private void deleteAlt(String sql_, String idseq_) throws SQLException
    {
        PreparedStatement pstmt = _conn.prepareStatement(sql_);
        
        pstmt.setString(1, idseq_);
                
        pstmt.executeUpdate();

        pstmt.close();
    }

    /**
     * Delete an Alternate Name
     * 
     * @param alt_ the Alternate
     * @throws SQLException
     */
    private void deleteAltName(Alternates alt_) throws SQLException
    {
        String delete = "delete from sbr.designations_view where desig_idseq = ?";
        
        deleteAlt(delete, alt_.getAltIdseq());
    }

    /**
     * Delete an Alternate Definition
     * 
     * @param alt_ the Alternate
     * @throws SQLException
     */
    private void deleteAltDef(Alternates alt_) throws SQLException
    {
        String delete = "delete from sbr.definitions_view where defin_idseq = ?";
        
        deleteAlt(delete, alt_.getAltIdseq());
    }

    /**
     * Delete an Alternate
     * 
     * @param alt_ the Alternate
     * @throws SQLException
     */
    private void delete(Alternates alt_) throws SQLException
    {
        if (alt_.isName())
            deleteAltName(alt_);
        else
            deleteAltDef(alt_);
    }

    /**
     * Insert a USED_BY Alternate Name into the database. It doesn't matter
     * if the cause of this is an Alternate Name or Alternate Definition.
     * 
     * @param alt_ the Alternate object
     * @throws SQLException
     */
    private void insertUsedBy(Alternates alt_) throws SQLException
    {
        String insert = "begin insert into sbr.designations_view "
            + "(ac_idseq, conte_idseq, name, detl_name, lae_name) "
            + "values (?, ?, ?, ?, ?) return desig_idseq into ?; end;";
        
        CallableStatement cstmt = null;
        try
        {
            // Add the Designation.
            cstmt = _conn.prepareCall(insert);
            cstmt.setString(1, alt_.getAcIdseq());
            cstmt.setString(2, alt_.getConteIdseq());
            cstmt.setString(3, alt_.getConteName());
            cstmt.setString(4, _addDesigType);
            cstmt.setString(5, alt_.getLanguage());
            cstmt.registerOutParameter(6, java.sql.Types.VARCHAR);
            cstmt.executeUpdate();
            // At this time we don't really care about the generated desig_idseq
            // but we may in the future.
        }
        catch (SQLException ex)
        {
            // If the record already exists then great, just ignore the duplicate, otherwise
            // it's not good.
            if (ex.getErrorCode() != 1)
                throw ex;
        }
        finally
        {
            // Close the statement
            if (cstmt != null)
                cstmt.close();
        }
    }

    /**
     * Save a USED_BY Alternate Name
     * 
     * @param alt_ the Alternate
     * @throws SQLException
     */
    public void saveUsedBy(Alternates alt_) throws SQLException
    {
        // If it's deleted, don't need to do anything. We can automatically add
        // new USED_BY types but we can't delete them automatically.
        if (alt_.isDeleted())
        {
            return;
        }

        // If it's new or changed it doesn't matter if it's a Name or Definition.
        if (alt_.isNew() || alt_.isChanged())
            insertUsedBy(alt_);
    }

    /**
     * Save changes to an Alternate.
     * 
     * @param alt_ the Alternate
     * @return true the alternate is inserted/updated, false the alternate is deleted.
     * @throws SQLException
     */
    public boolean save(Alternates alt_) throws SQLException
    {
        // If it's deleted, don't need to do anything extra.
        if (alt_.isDeleted())
        {
            delete(alt_);
            return false;
        }

        // If it's new or changed be sure to record CSI changes also.
        if (alt_.isNew())
            insert(alt_);
        else if (alt_.isChanged())
            update(alt_);

        saveCSI(alt_);
        return true;
    }

    /**
     * Save block changes to Alternates.
     * 
     * @param alt_ the Alternate
     * @param idseq_ the AC id's being block edited
     * @param conteIdseq_ the matching Context ID's
     * @throws SQLException
     */
    public void save(Alternates alt_, String[] idseq_, String[] conteIdseq_) throws SQLException
    {
        // If it's deleted, don't need to do anything extra.
        if (alt_.isDeleted())
        {
            delete(alt_);
            return;
        }

        // If it's new, add to all AC's and save changes to CSI associations
        if (alt_.isNew())
        {
            for (int i = 0; i < idseq_.length; ++i)
            {
                alt_.setACIdseq(idseq_[i]);
                alt_.setConteIdseq(conteIdseq_[i]);
                insert(alt_);
                saveCSI(alt_);
            }
            return;
        }
        
        // If it's an update, remember to save CSI changes
        if (alt_.isChanged())
        {
            update(alt_);
        }

        saveCSI(alt_);
    }

    /**
     * Save version block changes to Alternates.
     * 
     * @param alt_ the Alternate
     * @param beans_ the AC_Bean parents of the Alternates
     * @param idseq_ the AC id's being block edited
     * @param conteIdseq_ the matching Context ID's
     * @throws SQLException
     */
    public void save(Alternates alt_, AC_Bean[] beans_, String[] idseq_, String[] conteIdseq_) throws SQLException
    {
        // If it's deleted there's nothing to do because this is really a massive add and delete just means
        // don't add it. And the above loop has already deleted the Alternates that may have been copied
        // outside this method.
        if (alt_.isDeleted())
        {
            return;
        }

        // If it's new, add to all new AC's and save changes to CSI associations
        if (alt_.isNew())
        {
            for (int i = 0; i < idseq_.length; ++i)
            {
                // If the AC was not Versioned for any reason, don't add the Alternates.
                String newIdseq = beans_[i].getIDSEQ();
                if (idseq_[i].equals(newIdseq))
                    continue;

                alt_.setACIdseq(newIdseq);
                alt_.setConteIdseq(beans_[i].getContextIDSEQ());
                insert(alt_);
                saveCSI(alt_);
            }
            return;
        }
        
        // Processing a single Alternate, first determine if it's Original AC has been versioned.
        int acNdx;
        String newIdseq = null;
        for (acNdx = 0; acNdx < idseq_.length; ++acNdx)
        {
            // Find the original AC for this ALT.
            String oldIdseq = alt_.getAcIdseq();
            if (oldIdseq != null && idseq_[acNdx].equals(oldIdseq))
            {
                // Now verify the new AC is not null and is not the same as the old one.
                newIdseq = beans_[acNdx].getIDSEQ();
                if (newIdseq != null && newIdseq.length() > 0 && !newIdseq.equals(oldIdseq))
                {
                    break;
                }
            }
        }
        
        // If we don't find a match there was an error and a new AC wasn't created for this one.
        if (acNdx == idseq_.length)
            return;

        // If it's an update or nothing has been done it really means just add it to a single AC and not all AC's
        alt_.setACIdseq(newIdseq);
        alt_.setConteIdseq(beans_[acNdx].getContextIDSEQ());
        insert(alt_);
        alt_.getCSITree().markNew();
        saveCSI(alt_);
        
        return;
    }

    /**
     * For a simple select, return results as a String list.
     * 
     * @param select_ the SQL select
     * @return the result set
     * @throws ToolException
     */
    private String[] getList(String select_) throws ToolException
    {
        String[] list = new String[0];
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try
        {
            pstmt = _conn.prepareStatement(select_);
            rs = pstmt.executeQuery();
            
            // There will be only 1 result if any. Format and return to the caller.
            Vector<String> temp = new Vector<String>();
            while (rs.next())
            {
                temp.add(rs.getString(1));
            }
            rs.close();
            pstmt.close();

            // Convert to an array
            list = new String[temp.size()];
            for (int i = 0; i < list.length; ++i)
                list[i] = temp.get(i);
        }
        catch (SQLException ex)
        {
            _log.error("SQL: " + select_, ex);
            try
            {
                if (rs != null)
                    rs.close();
                if (pstmt != null)
                    pstmt.close();
            }
            catch (SQLException e)
            {
            }
            throw new ToolException(ex);
        }

        // Return the result set
        return list;
    }

    /**
     * Get the Alternate Name Types.
     * 
     * @return the Alternate Name Types.
     * @throws ToolException
     */
    public String[] getDesignationTypes() throws ToolException
    {
        String select = "select detl_name from sbr.designation_types_lov_view where detl_name not in ( "
            + "select value from sbrext.tool_options_view_ext where property like 'EXCLUDE.DESIGNATION_TYPE.%' "
            +") order by upper(detl_name)";
        return getList(select);
    }
    
    /**
     * Get the Languages
     * 
     * @return the Languages
     * @throws ToolException
     */
    public String[] getLangs() throws ToolException
    {
        String select = "select name from sbr.languages_lov_view order by (name)";
        return getList(select);
    }
    
    /**
     * Get the Alternate Definition Types.
     * 
     * @return the Alternate Definition Types.
     * @throws ToolException
     */
    public String[] getDefinitionTypes(boolean showMC_) throws ToolException
    {
        String select = "select defl_name from sbrext.definition_types_lov_view_ext where defl_name not in ( "
            + "select value from sbrext.tool_options_view_ext where property like 'EXCLUDE.DEFINITION_TYPE.%' "
            + ")";
        if (!showMC_)
            select += " and defl_name <> '" + _manuallyCuratedDef + "'";
        return getList(select + " order by upper(defl_name)");
    }
    
    /**
     * Test if the CSI type provided is the special UML_PACKAGE_NAME
     * 
     * @param name_ the CSI type to test
     * @return true if this is the UML_PACKAGE_NAME type
     */
    public static boolean isPackageName(String name_)
    {
        return _packageName.equals(name_);
    }
    
    /**
     * Test if the CSI type provided is the special UML_PACKAGE_ALIAS
     * 
     * @param alias_ the CSI type to test
     * @return true if this is the UML_PACKAGE_ALIAS type
     */
    public static boolean isPackageAlias(String alias_)
    {
        return _packageAlias.equals(alias_);
    }
    
    /**
     * Get the name of the CSI type for a UML Package Alias
     * 
     * @return the package alias type name
     */
    public static String getPackageAliasName()
    {
        return _packageAlias;
    }

    /**
     * Get the default language for the caDSR
     * 
     * @return the default language
     * @throws ToolException
     */
    public String getDefaultLanguage() throws ToolException
    {
        String select = "select value from sbrext.tool_options_view_ext where tool_name = 'caDSR' and property = 'DEFAULT.LANGUAGE'";
        String[] results = getList(select);
        switch (results.length)
        {
            case 0:
                results = getLangs();
                switch (results.length)
                {
                    case 0:
                        return "";
                    case 1:
                        return results[0];
                    default:
                        return "";
                }

            case 1:
                return results[0];

            default:
                return "";
        }
    }
    
    private Connection _conn;
  
    public static final int _MAXNAMELEN = 255;
    public static final int _MAXDEFLEN = 2000;
    
    public static final String _addDesigType = "USED_BY";
    public static final String _manuallyCuratedDef = "Manually-curated";
    
    private static String _packageName = null;
    private static String _packageAlias = null;
    private static final Logger _log = Logger.getLogger(DBAccess.class);
}
