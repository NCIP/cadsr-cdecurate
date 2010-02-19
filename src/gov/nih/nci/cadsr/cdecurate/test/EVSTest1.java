// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/test/EVSTest1.java,v 1.36 2007-09-10 17:18:20 hebell Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.test;

import gov.nih.nci.cadsr.cdecurate.tool.EVSSearch;
import gov.nih.nci.cadsr.cdecurate.tool.EVS_UserBean;
import gov.nih.nci.cadsr.cdecurate.tool.GetACService;
import gov.nih.nci.cadsr.cdecurate.tool.TOOL_OPTION_Bean;
//import gov.nih.nci.evs.domain.DescLogicConcept;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.InvalidPropertiesFormatException;
import java.util.List;
import java.util.Properties;
import java.util.Vector;

import org.LexGrid.LexBIG.DataModel.Collections.ResolvedConceptReferenceList;
import org.LexGrid.LexBIG.DataModel.Core.ResolvedConceptReference;

import oracle.jdbc.pool.OracleDataSource;

/**
 * This class tests the use of the EVS API in the Curation Tool and verifies connectivity to the EVS servers.
 * 
 * @author lhebel
 *
 */
public class EVSTest1
{
    /**
     * Constructor
     *
     */
    public EVSTest1()
    {
    }
    
    /**
     * Control entry to run the tests. All output is written to logs as configured in the log4j.xml specified.
     * 
     * @param args_ [0] must be the name of the log4j.xml configuration files, [1] must the name of the EVSTest1.xml
     *      configuration properties file.
     */
    public static void main(String[] args_)
    {
        // Initialize the Log4j environment.
        if (args_.length != 2)
        {
            System.err.println("arguments: <log4j.xml> <evstest1.xml>");
            return;
        }
        _logger.initLogger(args_[0]);

        try
        {
            _logger.start();
            
            EVSTest1 var = new EVSTest1();

            // Load the properties for this test.
            var.loadProp(args_[1]);
            
            // Open a database connection to the caDSR.
            var.open();

            // Test the EVS Vocabularies.
            var.testVocabs();
            
            // Close the database connection.
            var.close();

            _logger.end();
        }
        catch (Exception ex)
        {
            _logger.fatal(ex.toString(), ex);
        }
    }

    /**
     * Load the properties from the XML file specified.
     * 
     * @param propFile_ the properties file.
     */
    private void loadProp(String propFile_)
    {
        _prop = new Properties();
        try
        {
            _logger.section("Loading properties...");
            _propFile = propFile_;
            FileInputStream in = new FileInputStream(_propFile);
            _prop.loadFromXML(in);
            in.close();
        }
        catch (FileNotFoundException ex)
        {
            _logger.fatal(ex.toString());
        }
        catch (InvalidPropertiesFormatException ex)
        {
            _logger.fatal(ex.toString());
        }
        catch (IOException ex)
        {
            _logger.fatal(ex.toString());
        }
        
    }

    /**
     * Open a database connection to the caDSR specified in the properties XML.
     * 
     * @throws SQLException
     */
    private void open() throws SQLException
    {
        // We only need one connection.
        if (_conn != null)
            return;

        _logger.section("Connecting to caDSR...");
        
        // Read the mandatory database properties.
        String dburl = _prop.getProperty("DSurl");
        if (dburl == null)
        {
            _logger.fatal("Missing DB caDSR property.");
            return;
        }
        String user = _prop.getProperty("DSusername");
        if (user == null)
        {
            _logger.fatal("Missing DB user property.");
            return;
        }
        String pswd = _prop.getProperty("DSpassword");
        if (pswd == null)
        {
            _logger.fatal("Missing DB password property.");
            return;
        }
        _logger.info("DSurl: " + dburl);
        _logger.info("DSusername: " + user);
        _logger.info("DSpassword: " + pswd);

        // Open the database connection. If the format contains colons ( : ) this will be a thin
        // client connection. Otherwise this will be a thick client connection.
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
        _conn = ods.getConnection(user, pswd);
        
        // No updates should be done using this connection.
        _conn.setAutoCommit(false);
    }

    /**
     * Close the database connection.
     * 
     * @throws SQLException
     */
    private void close() throws SQLException
    {
        _conn.close();
    }

    /**
     * Get the URL for EVS access.
     * 
     * @param acs_ the Curation GetACService instance
     * @return the EVS URL
     */
    private String getEvsURL(GetACService acs_)
    {
        _logger.section("Finding EVS URL ...");

        // Check the tool options for a Curation Tool specific EVS URL.
        Vector<TOOL_OPTION_Bean> topts = acs_.getToolOptionData(_conn, "CURATION", "EVS.URL", "");
        String evsURL = null;

        // If not found, use the caDSR Global EVS URL.
        if (topts.size() == 0)
        {
            topts = acs_.getToolOptionData(_conn, "EVS", "URL", "%");
            if (topts.size() != 0)
                evsURL = topts.get(0).getVALUE();
        }
        
        // If found, retrieve it.
        else
            evsURL = topts.get(0).getVALUE();
        
        // If we didn't find a URL in the tool options table just use the one in the EVSTest1.xml.
        if (evsURL == null)
        {
            evsURL = _prop.getProperty("evs.url");
        }
        
        // If we found a URL in the tool options, check for an override property and let the user know
        // what's happening.
        else
        {
            String temp = evsURL;
            evsURL = _prop.getProperty("evs.url");
            if (!temp.equals(evsURL))
                _logger.warn("EVS URL in properties (" + evsURL + ") supersedes the URL in tool options (" + temp + ").");
        }

        // Return whatever we found.
        return evsURL;
    }
    
    /**
     * Test the Vocabularies and availability.
     *
     */
    @SuppressWarnings("unchecked")
    private void testVocabs()
    {
        // Get the EVS URL for the API.
        GetACService acs = new GetACService();
        String evsURL = getEvsURL(acs);
        if (evsURL == null)
        {
            _logger.fatal("Missing EVS URL.");
            return;
        }

        // Set the EVS URL for the tests.
        EVS_UserBean user = new EVS_UserBean();
        user.setEVSConURL(evsURL);
        
        _logger.info("EVS: " + user.getEVSConURL());
        
        // Attempt to use every Vocabulary defined in the properties and match it to the Curation Tool
        // defined Vocabularies.
        EVSSearch evs = new EVSSearch(user);
        
        Vector<TOOL_OPTION_Bean> topts = acs.getToolOptionData(_conn, "CURATION", "EVS.VOCAB.%.EVSNAME", "");
        
        String msg;
        for (int index = 0; true; ++index)
        {
            // The vocab, name and code are always entered in the properties as a set designated by
            // a number. When a vocabulary can not be found the test is complete. THEREFORE, there can
            // be no gaps in the numbering of the sets. See EVSTest1.xml for more.
            String vocab = _prop.getProperty("vocab." + index);
            if (vocab == null)
                break;
            boolean metaFlag = vocab.equals(EVSSearch.META_VALUE);

            String name = _prop.getProperty("name." + index);
            if (name == null)
            {
                _logger.fatal("Missing 'name' property for Vocabulary " + vocab);
                return;
            }
            String code = _prop.getProperty("code." + index);
            if (code == null)
            {
                _logger.fatal("Missing 'code' property for Vocabulary " + vocab);
                return;
            }
            
            _logger.section("Vocab: " + vocab);

            // Check the property vocabulary against the Curation Tool vocabularies.
            boolean notFound = true;
            for (TOOL_OPTION_Bean obj : topts)
            {
                if (obj.getVALUE().equals(vocab))
                {
                    topts.remove(obj);
                    notFound = false;
                    break;
                }
            }
            
            // We are processing a vocabulary not used by the Curation Tool.
            if (notFound)
            {
                if (metaFlag)
                    notFound = false;
                else
                    _logger.warn("Vocabulary " + vocab + " is not used by the Curation Tool.");
            }

            // Check the connectivity by getting the root concepts.
            ResolvedConceptReferenceList vals = evs.getRootConcepts(vocab);
            if (metaFlag == false && vals == null)
            {
                _logger.fatal("No Root Concepts - CHECK CONNECTIVITY");
                continue;
            }

            // The code must match the name for the vocabulary in the set.
            String result = evs.do_getEVSCode(name, vocab);
            msg = name + " in " + vocab;
            if (result == null || result.length() == 0)
            {
                _logger.fatal("Failed: " + msg + " : CHECK CONNECTIVITY!");
            }
            else if (result.equals(code))
                _logger.info("Ok: " + msg);
            else
                _logger.fatal("Failed: " + msg);
            
            // The name must match the code for the vocabulary in the set.
            result = evs.do_getConceptName(code, vocab);
            msg = code + " in " + vocab;
            if (result.equals(name))
                _logger.info("Ok: " + msg);
            else
                _logger.fatal("Failed: " + msg);

            // Get the super concepts for our test data.
            Vector<String> sup;
    
            sup = evs.getSuperConceptNamesImmediate(vocab, name, code);
            for (String snam : sup)
            {
                _logger.info("Super Concept: " + snam);
            }
    
            sup = evs.getSuperConceptNames(vocab, name, code, new HashMap<String,String>());
            for (String snam : sup)
            {
                _logger.info("Super Concept: " + snam);
            }

            // Get subconcepts for our test data.
            boolean getSub = true;
            String propGetSub = _prop.getProperty("getAllSubConceptCodes." + index);
            if (propGetSub != null && !propGetSub.equals("true"))
                getSub = false;
            if (vals != null)
            {
                for (int i = 0; i < vals.getResolvedConceptReferenceCount(); i++)
                {
                	ResolvedConceptReference concept = vals.getResolvedConceptReference(i);
                    _logger.info("Concept: " + concept.getEntityDescription() + " : " + concept.getCode());
                    if (getSub)
                    {
                        Vector<String> subs = evs.getAllSubConceptCodes(vocab, concept.getCode());
                        int cnt = 0;
                        for (String snam : subs)
                        {
                            if (++cnt > 2)
                                break;
                            result = evs.do_getConceptName(snam, vocab);
                            _logger.info("Sub Concepts: " + result + " : " + snam);
                        }
                    }
                }
            }
        }
        
        // If anything remains in the Curation Tool list, we haven't performed a complete test and the properties
        // need to be enhanced appropriately.
        if (topts.size() != 0)
        {
            _logger.section("Untested Vocabularies ...");
            _logger.warn("The following Vocabularies are used by the Curation Tool and were not tested by the properties provided (" + _propFile + ")...");
            for (TOOL_OPTION_Bean obj : topts)
            {
                _logger.warn(obj.getVALUE());
            }
        }
    }

    private static Connection _conn;
    
    private static Properties _prop;
    
    private static String _propFile;
    
    private static final CurationTestLogger _logger = new CurationTestLogger(EVSTest1.class);
}
