// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/ui/AltNamesDefsSession.java,v 1.11 2006-11-08 05:00:11 hegdes Exp $
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
import gov.nih.nci.cadsr.cdecurate.tool.PV_Bean;
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
        _acIdseq[0] = (acIdseq_ == null || acIdseq_.length() == 0) ? null : acIdseq_;
        _conteIdseq = new String[1];
        _conteIdseq[0] = (conteIdseq_ == null || conteIdseq_.length() == 0) ? null : conteIdseq_;
        _conteName = new String[1];
        _conteName[0] = (conteName_ == null) ? "" : conteName_;
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
        name = getSessName(_beanBlock);
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
     * Get the data buffer for a block edit.
     * 
     * @param session_
     * @param sessName_
     * @param acBlock_
     * @return the block edit alt names/defs buffer
     * @throws Exception
     */
    private static AltNamesDefsSession getSessionDataBlockEdit(HttpSession session_, String sessName_, Vector<AC_Bean> acBlock_) throws Exception
    {
        AltNamesDefsSession altSess = null;

        // Get the block edit selections.
        String[] acIdseq = new String[acBlock_.size()];
        String[] conteIdseq = new String[acIdseq.length];
        String[] conteName = new String[acIdseq.length];
        for (int i = 0; i < acIdseq.length; ++i)
        {
            AC_Bean temp = acBlock_.get(i);
            acIdseq[i] = temp.getIDSEQ();
            conteIdseq[i] = temp.getContextIDSEQ();
            conteName[i] = temp.getContextName();
        }

        // If no block edit buffer exists, create one.
        altSess = (AltNamesDefsSession) session_.getAttribute(sessName_);
        if (altSess == null)
        {
            altSess = new AltNamesDefsSession(acIdseq, conteIdseq, conteName, _beanBlock);
            session_.setAttribute(sessName_, altSess);
        }
        
        // The existing block edit buffer must be validated to ensure we haven't changed the AC
        // list.
        boolean flag = false;
        for (int i = 0; i < acIdseq.length; ++i)
        {
            if (acIdseq[i].equals(altSess._acIdseq[i]) == false)
            {
                flag = true;
                break;
            }
        }
        
        // The buffer isn't correct for the list so create a new one.
        if (flag)
        {
            altSess = new AltNamesDefsSession(acIdseq, conteIdseq, conteName, _beanBlock);
            session_.setAttribute(sessName_, altSess);
        }
        
        return altSess;
    }

    /**
     * Get the data buffer for a VM
     * 
     * @param session_
     * @param req_
     * @return the alt name/def buffer
     * @throws Exception
     */
    private static AltNamesDefsSession getSessionDataVM(HttpSession session_, HttpServletRequest req_) throws Exception
    {
        // We identify the VM for the VD by an index value.
        AltNamesDefsSession altSess = null;
        String vmID = req_.getParameter(_beanVMID);
        if (vmID != null)
        {
            // Be sure we can get the VM and the class types are right.
            AC_Bean temp = (AC_Bean)session_.getAttribute(_beanVD);
            if (temp != null && temp instanceof VD_Bean)
            {
                VD_Bean vd = (VD_Bean) temp;
                Vector<PV_Bean> pvs = vd.getVD_PV_List();
                int vmid = Integer.parseInt(vmID);
                VM_Bean vm = null;
                if (pvs.size() > 0 && 0 <= vmid && vmid < pvs.size())
                {
                    PV_Bean pv = pvs.get(vmid);
                    vm = pv.getPV_VM();
                    altSess = vm.getAlternates();
                }
                
                // The VM hasn't been used before so create a new buffer.
                if (altSess == null)
                {
                    altSess = new AltNamesDefsSession(vm.getIDSEQ(), vm.getContextIDSEQ(), vm.getContextName(), _searchVM);
                    vm.setAlternates(altSess);
                }
            }
        }
        
        return altSess;
    }
    
    /**
     * Get the data buffer for AC's except a VM
     * 
     * @param session_
     * @param launch_
     * @return the alt name/def buffer
     * @throws Exception
     */
    private static AltNamesDefsSession getSessionDataAC(HttpSession session_, String launch_) throws Exception
    {
        // Determine the bean which holds the data.
        AltNamesDefsSession altSess = null;
        String beanName = null;
        if (launch_.equals(_searchDE))
            beanName = _beanDE;
        else if (launch_.equals(_searchDEC))
            beanName = _beanDEC;
        else if (launch_.equals(_searchVD))
            beanName = _beanVD;

        // Get the AC bean.
        AC_Bean ac = (AC_Bean)session_.getAttribute(beanName);
        if (ac == null)
            throw new Exception("Missing session Bean [" + beanName + "].");

        // If it hasn't been used before, create a new buffer.
        altSess = ac.getAlternates();
        if (altSess == null)
        {
            altSess = new AltNamesDefsSession(ac.getIDSEQ(), ac.getContextIDSEQ(), ac.getContextName(), launch_);
            ac.setAlternates(altSess);
        }
        
        return altSess;
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
        // Ok this logic has nothing to do with EVS. The current field name used by
        // the curation tool is referenced for consistency.
        HttpSession session = req_.getSession();
        String launch = req_.getParameter(_searchEVS);

        // This would be a problem, the environment is not right for this request.
        if (launch == null)
        {
            throw new Exception("Unknown origination page.");
        }

        AltNamesDefsSession altSess = null;
        String sessName = getSessName(_beanBlock);

        while (true)
        {
            // For block edit we will keep a separate session attribute. WARNING this first getAttribute
            // is for the Curation Tool block edit buffer and NOT the Alt Name/Def block edit buffer.
            @SuppressWarnings("unchecked")
            Vector<AC_Bean> acBlock = (Vector) session.getAttribute(_beanBlock);
            if (acBlock != null && acBlock.size() > 0)
            {
                altSess = getSessionDataBlockEdit(session, sessName, acBlock);
                break;
            }

            // Remove any old Block edit buffer.
            session.removeAttribute(sessName);

            if (launch.equals(_searchVM))
            {
                altSess = getSessionDataVM(session, req_);
                break;
            }
    
            altSess = getSessionDataAC(session, launch);
            break;
        }
        
        if (altSess == null)
            throw new Exception("Unable to find or create a data buffer.");

        // Set the request data for when the page is written.
        req_.setAttribute(AltNamesDefsServlet._reqIdseq, altSess._acIdseq[0]);
        req_.setAttribute(_searchEVS, launch);
        
        return altSess;
    }

    /**
     * Save the session data to the database.
     * 
     * @param session_ the HTTP session
     * @param conn_ the database connection
     * @param idseq_ the subject AC, for an Edit this wouldn't change, for an Add/New this is now a valid idseq
     * @param conteIdseq_ the companion Context idseq
     * @throws SQLException
     */
    public void save(HttpSession session_, Connection conn_, String idseq_, String conteIdseq_) throws SQLException
    {
        // Get the session buffer.
        AltNamesDefsSession sess;
        String sessName = getSessName(_beanBlock);
        sess = (AltNamesDefsSession) session_.getAttribute(sessName);

        // Open a database connection.
        DBAccess db = new DBAccess(conn_);
        if (sess != null)
        {
            // Apply the alternate objects to the appropriate AC
            for (int i = 0; i < sess._acIdseq.length; ++i)
            {
                db.save(_alts[i], sess._acIdseq, sess._conteIdseq);
            }
            
            session_.removeAttribute(sessName);
            return;
        }

        // Save all the alternates
        for (int i = 0; i < _alts.length; ++i)
        {
            if (_alts[i].getAcIdseq() == null)
                _alts[i].setACIdseq((sess._acIdseq[0] == null) ? idseq_ : sess._acIdseq[0]);
            if (_alts[i].getConteIdseq() == null)
                _alts[i].setConteIdseq((sess._conteIdseq[0] == null) ? conteIdseq_ : sess._conteIdseq[0]);
            db.save(_alts[i]);
        }
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
    private static final String _beanVMID = "vmID";
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
