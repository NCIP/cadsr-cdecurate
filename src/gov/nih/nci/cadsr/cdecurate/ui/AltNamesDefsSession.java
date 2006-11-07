// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/ui/AltNamesDefsSession.java,v 1.10 2006-11-07 16:39:05 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.ui;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import gov.nih.nci.cadsr.cdecurate.database.Alternates;
import gov.nih.nci.cadsr.cdecurate.database.DBAccess;
import gov.nih.nci.cadsr.cdecurate.tool.AC_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.DEC_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.DE_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.VD_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.VM_Bean;
import gov.nih.nci.cadsr.cdecurate.util.Tree;

/**
 * This class maps and manges the session data needed for processing Alternate Names and Definitions.
 *  
 * @author lhebel
 *
 */
public class AltNamesDefsSession implements Serializable
{
    /**
     * Constructor
     * 
     * @param acIdseq_ the AC database id of interest
     * @param conteIdseq_ the companion Context ID
     * @param conteName_ the companion Context Name
     * @param sessType_ the session type, AltNamesDefsSession._searchDE, _searchDEC, _searchVD, _searchVM 
     */
    public AltNamesDefsSession(String acIdseq_, String conteIdseq_, String conteName_, String sessType_)
    {
        cleanBuffers();
        _acIdseq = new String[1];
        _acIdseq[0] = acIdseq_;
        _conteIdseq = new String[1];
        _conteIdseq[0] = conteIdseq_;
        _conteName = new String[1];
        _conteName[0] = conteName_;
        _sessType = sessType_;
    }

    /**
     * Constructor
     * 
     * @param acIdseq_ the AC database id list of interest
     * @param conteIdseq_ the companion Context ID list
     * @param conteName_ the companion Context Name list
     * @param sessType_ the session type, AltNamesDefsSession._searchDE, _searchDEC, _searchVD, _searchVM 
     */
    public AltNamesDefsSession(String[] acIdseq_, String[] conteIdseq_, String[] conteName_, String sessType_)
    {
        cleanBuffers();
        _acIdseq = acIdseq_;
        _conteIdseq = conteIdseq_;
        _conteName = conteName_;
        _sessType = sessType_;
    }

    /**
     * Clear the session edit buffer
     *
     */
    public void clearEdit()
    {
        _editAlt = new Alternates();
    }
    
    /**
     * Clean all session buffers
     *
     */
    public void cleanBuffers()
    {
        clearEdit();
        
        _cacheTitle = null;
        _cacheCSI = null;
        _cacheAltTypes = null;
        _cacheLangs = null;
        _cacheSort = AltNamesDefsServlet._sortName;
    }

    /**
     * Calculate a new object temporary database id
     * 
     * @return a session unique temporary identifier
     */
    public String newIdseq()
    {
        --_newIdseq;
        return _newPrefix + String.valueOf(_newIdseq);
    }

    /**
     * Get the session name. There are multiple sessions to allow the user to begin
     * work on a DE and create a DEC prior to saving the new DE.
     * 
     * @param type_ the session type, AltNamesDefsSession._searchDE, _searchDEC, _searchVD, _searchVM
     * @return the session name
     */
    private static String getSessName(String type_)
    {
        return _sessName + "." + type_;
    }

    /**
     * Clean all session buffers for all session types.
     * 
     * @param req_ the user HTTP request object
     */
    public static void cleanBuffers(HttpServletRequest req_)
    {
        HttpSession sess = req_.getSession();
        String name;
        name = getSessName(_searchDE);
        sess.removeAttribute(name);
        name = getSessName(_searchDEC);
        sess.removeAttribute(name);
        name = getSessName(_searchVD);
        sess.removeAttribute(name);
        name = getSessName(_searchVM);
        sess.removeAttribute(name);
    }

    /**
     * Clean the session buffer for a specific session type.
     * 
     * @param req_ the user HTTP request object
     * @param type_ the session type, AltNamesDefsSession._searchDE, _searchDEC, _searchVD, _searchVM
     */
    public static void cleanBuffers(HttpServletRequest req_, String type_)
    {
        HttpSession sess = req_.getSession();
        String name;
        name = getSessName(type_);
        sess.removeAttribute(name);
    }

    /**
     * Get the session data for this request.
     * 
     * @param req_ the user HTTP request object
     * @return the session data buffer
     * @throws Exception
     */
    public static AltNamesDefsSession getSessionData(HttpServletRequest req_) throws Exception
    {
        AltNamesDefsSession.ACBean subject = getAC(req_);
        String sessName = getSessName(subject._type);
        AltNamesDefsSession altSess = (AltNamesDefsSession) req_.getSession().getAttribute(sessName);
        
        // If no session exists.
        if (altSess == null)
        {
            altSess = new AltNamesDefsSession(subject._acIdseq, subject._conteIdseq, subject._conteName, subject._type);
        }
        
        // If the old and new sessions are singletons and the AC is different.
        else if (altSess._acIdseq.length == 1 && subject._acIdseq.length == 1)
        {
            if (altSess.sameAC(subject._acIdseq[0]) == false)
                altSess = new AltNamesDefsSession(subject._acIdseq, subject._conteIdseq, subject._conteName, subject._type);
        }
        
        // If the old session is a singleton and the new session is a block edit.
        else if (altSess._acIdseq.length == 1 && subject._acIdseq.length != 1)
        {
            altSess = new AltNamesDefsSession(subject._acIdseq, subject._conteIdseq, subject._conteName, subject._type);
        }
        
        // If the old session is a block edit and the new session is a singleton.
        else if (altSess._acIdseq.length != 1 && subject._acIdseq.length == 1)
        {
            altSess = new AltNamesDefsSession(subject._acIdseq, subject._conteIdseq, subject._conteName, subject._type);
        }
        
        // If the old session has a different count than the new session.
        else if (altSess._acIdseq.length != subject._acIdseq.length)
        {
            altSess = new AltNamesDefsSession(subject._acIdseq, subject._conteIdseq, subject._conteName, subject._type);
        }
        
        // If the old and new are block edits and not the same list.
        else
        {
            boolean flag = false;
            for (int i = 0; i < subject._acIdseq.length; ++i)
            {
                if (subject._acIdseq[i].equals(altSess._acIdseq[i]) == false)
                {
                    flag = true;
                    break;
                }
            }
            if (flag)
            {
                altSess = new AltNamesDefsSession(subject._acIdseq, subject._conteIdseq, subject._conteName, subject._type);
            }
        }

        // Set the session data, in case it was a new one.
        req_.getSession().setAttribute(sessName, altSess);
        return altSess;
    }

    /**
     * An internal class to determine the AC type and records of interest.
     * 
     * @author lhebel
     *
     */
    private static class ACBean
    {
        /**
         * Constructor
         * 
         * @param type_ the session type, AltNamesDefsSession._searchDE, _searchDEC, _searchVD, _searchVM 
         * @param acIdseq_ the AC database id of interest
         * @param conteIdseq_ the companion Context ID
         * @param conteName_ the companion Context Name
         */
        public ACBean(String type_, String acIdseq_, String conteIdseq_, String conteName_)
        {
            _type = type_;
            _acIdseq = new String[1];
            _acIdseq[0] = (acIdseq_ == null || acIdseq_.length() == 0) ? null : acIdseq_;
            _conteIdseq = new String[1];
            _conteIdseq[0] = (conteIdseq_ == null || conteIdseq_.length() == 0) ? null : conteIdseq_;
            _conteName = new String[1];
            _conteName[0] = (conteName_ == null) ? "" : conteName_;
        }
        
        /**
         * Constructor
         * 
         * @param type_ the session type, AltNamesDefsSession._searchDE, _searchDEC, _searchVD, _searchVM 
         * @param acIdseq_ the AC database id list of interest
         * @param conteIdseq_ the companion Context ID list
         * @param conteName_ the companion Context Name list
         */
        public ACBean(String type_, String[] acIdseq_, String[] conteIdseq_, String[] conteName_)
        {
            _type = type_;
            _acIdseq = acIdseq_;
            _conteIdseq = conteIdseq_;
            _conteName = conteName_;
        }

        public String[] _acIdseq;
        public String[] _conteIdseq;
        public String[] _conteName;
        public String _type;
    }

    /**
     * Get the AC records of interest.
     * 
     * @param req_ the user HTTP request
     * @return the target data for the request
     * @throws Exception
     */
    private static ACBean getAC(HttpServletRequest req_) throws Exception
    {
        // Ok this logic has nothing to do with EVS. The current field name used by
        // the curation tool is referenced for consistency.
        HttpSession session = req_.getSession();
        String launch = req_.getParameter(_searchEVS);
        ACBean rs = null;

        // This would be a problem, the environment is not right for this request.
        if (launch == null)
        {
            throw new Exception("Unknown origination page.");
        }

        @SuppressWarnings("unchecked")
        Vector<AC_Bean> acBlock = (Vector) session.getAttribute(_beanBlock);
        if (acBlock != null && acBlock.size() > 0)
        {
            String[] acIdseq = new String[acBlock.size()];
            String[] conteIdseq = new String[acIdseq.length];
            String[] conteName = new String[acIdseq.length];
            for (int i = 0; i < acIdseq.length; ++i)
            {
                AC_Bean temp = acBlock.get(i);
                acIdseq[i] = temp.getIDSEQ();
                conteIdseq[i] = temp.getContextIDSEQ();
                conteName[i] = temp.getContextName();
            }
            rs = new AltNamesDefsSession.ACBean(launch, acIdseq, conteIdseq, conteName);
        }
        else
        {
            String beanName = null;
            if (launch.equals(_searchDE))
                beanName = _beanDE;
            else if (launch.equals(_searchDEC))
                beanName = _beanDEC;
            else if (launch.equals(_searchVD))
                beanName = _beanVD;
            else if (launch.equals(_searchVM))
                beanName = _beanVM;

            AC_Bean ac = (AC_Bean)session.getAttribute(beanName);
            if (ac == null)
                throw new Exception("Missing session Bean [" + beanName + "].");
            
            rs = new AltNamesDefsSession.ACBean(launch, ac.getIDSEQ(), ac.getContextIDSEQ(), ac.getContextName());
        }

        // Set the request data for when the page is written.
        req_.setAttribute(AltNamesDefsServlet._reqIdseq, rs._acIdseq[0]);
        req_.setAttribute(_searchEVS, launch);

        return rs;
    }

    /**
     * Determine if the specified AC idseq is the subject of this session.
     * 
     * @param idseq_ the AC idseq
     * @return true if this session focuses on the AC
     */
    private boolean sameAC(String idseq_)
    {
        if (_acIdseq.length > 1)
        {
            return true;
        }

        if (_acIdseq[0] == null)
        {
            return (idseq_ == null);
        }
        
        return _acIdseq[0].equals(idseq_);
    }

    /**
     * Save the session data to the database.
     * 
     * @param conn_ the database connection
     * @param sess_ the HTTP session
     * @param type_ the session type, AltNamesDefsSession._searchDE, _searchDEC, _searchVD, _searchVM
     * @param idseq_ the subject AC, for an Edit this wouldn't change, for an Add/New this is now a valid idseq
     * @param conteIdseq_ the companion Context idseq
     * @throws SQLException
     */
    public static void save(Connection conn_, HttpSession sess_, String type_, String idseq_, String conteIdseq_) throws SQLException
    {
        // Get the session buffer.
        AltNamesDefsSession sess;
        String sessName = getSessName(type_);
        sess = (AltNamesDefsSession) sess_.getAttribute(sessName);
        if (sess == null)
            return;

        // Open a database connection.
        DBAccess db = new DBAccess(conn_);
        Alternates[] alts = sess._alts;

        // For single edits
        if (sess._acIdseq.length == 1)
        {
            // Verify this request applies to this AC
            if (sess._acIdseq[0] != null && sess._acIdseq[0].length() > 0 && sess._acIdseq[0].equals(idseq_) == false)
                return;
            
            // Save all the alternates
            for (int i = 0; i < alts.length; ++i)
            {
                if (alts[i].getAcIdseq() == null)
                    alts[i].setACIdseq((sess._acIdseq[0] == null) ? idseq_ : sess._acIdseq[0]);
                if (alts[i].getConteIdseq() == null)
                    alts[i].setConteIdseq((sess._conteIdseq[0] == null) ? conteIdseq_ : sess._conteIdseq[0]);
                db.save(alts[i]);
            }
        }
        
        // For block edit
        else
        {
            // Apply the alternate objects to the appropriate AC
            for (int i = 0; i < sess._acIdseq.length; ++i)
            {
                db.save(alts[i], sess._acIdseq, sess._conteIdseq);
            }
        }

        // Wipe the buffer, it's in the database now.
        sess_.removeAttribute(sessName);
    }

    /**
     * Get the session type.
     * 
     * @return the session type, AltNamesDefsSession._searchDE, _searchDEC, _searchVD, _searchVM
     */
    public String getSessType()
    {
        return _sessType;
    }

    private static final String _beanDE = "m_DE";
    private static final String _beanDEC = "m_DEC";
    private static final String _beanVD = "m_VD";
    private static final String _beanVM = "m_VM";
    private static final String  _beanBlock = "vBEResult";
    public static final String _searchEVS = "searchEVS";
    public static final String _searchVD = "ValueDomain";
    public static final String _searchDEC = "DataElementConcept";
    public static final String _searchDE = "DataElement";
    public static final String _searchVM = "ValueMeaning";

    public Alternates[] _alts;
    public String[] _acIdseq;
    public String[] _conteIdseq;
    public String[] _conteName;
    public String _sessType;
    public Alternates _editAlt;
    public String _jsp;
    public String _viewJsp;
    private int _newIdseq;
    
    public String _cacheSort;
    public String _cacheTitle;
    public Tree _cacheCSI;
    public String[] _cacheAltTypes;
    public String[] _cacheDefTypes;
    public String[] _cacheLangs;
    
    public static final String _newPrefix = "$";

    private static final String _sessName = AltNamesDefsSession.class.getName();
    private static final long serialVersionUID = 1092782526671820593L;
}
