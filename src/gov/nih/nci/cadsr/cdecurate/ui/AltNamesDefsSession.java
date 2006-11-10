// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/ui/AltNamesDefsSession.java,v 1.13 2006-11-10 05:45:19 hegdes Exp $
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
import gov.nih.nci.cadsr.cdecurate.tool.PV_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.VD_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.VM_Bean;
import gov.nih.nci.cadsr.cdecurate.util.ToolException;
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
        _dbClearNamesDefs = false;
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
        _dbClearNamesDefs = false;
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
            return altSess;
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
        if (vmID == null)
        {
            throw new Exception("Missing required request parameter \"" + _beanVMID + "\".");
        }

        // Have to keep this around.
        req_.setAttribute(_beanVMID, vmID);

        // Be sure we can get the VM and the class types are right.
        AC_Bean temp = (AC_Bean)session_.getAttribute(_beanVD);
        if (temp != null && temp instanceof VD_Bean)
        {
            VD_Bean vd = (VD_Bean) temp;
            Vector<PV_Bean> pvs = vd.getVD_PV_List();
            int vmid = Integer.parseInt(vmID);
            if (pvs.size() == 0 || vmid < 0 || pvs.size() <= vmid)
            {
                throw new Exception("VM_Bean can not be found.");
            }

            // Get the VM and it's data buffer.
            PV_Bean pv = pvs.get(vmid);
            VM_Bean vm = pv.getPV_VM();
            altSess = vm.getAlternates();

            // The VM hasn't been used before so create a new buffer.
            if (altSess == null)
            {
                altSess = new AltNamesDefsSession(vm.getIDSEQ(), vm.getContextIDSEQ(), vm.getContextName(), _searchVM);
                vm.setAlternates(altSess);
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

        while (true)
        {
            // For block edit we will keep a separate session attribute. WARNING this first getAttribute
            // is for the Curation Tool block edit buffer and NOT the Alt Name/Def block edit buffer.
            String sessName = getSessName(_beanBlock);
            @SuppressWarnings("unchecked")
            Vector<AC_Bean> acBlock = (Vector) session.getAttribute(_beanBlock);
            if (acBlock != null && acBlock.size() > 0)
            {
                altSess = getSessionDataBlockEdit(session, sessName, acBlock);
                break;
            }

            // Remove any old Block edit buffer.
            session.removeAttribute(sessName);

            // Value Meanings are different than other AC's.
            if (launch.equals(_searchVM))
            {
                altSess = getSessionDataVM(session, req_);
                break;
            }

            // Get the data buffer for this AC.
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
     * @param conn_ the database connection
     * @param idseq_ the subject AC, for an Edit this wouldn't change, for an Add/New this is now a valid idseq
     * @param conteIdseq_ the companion Context idseq
     * @throws SQLException
     */
    public void save(Connection conn_, String idseq_, String conteIdseq_) throws SQLException
    {
        // Save all the alternates
        DBAccess db = new DBAccess(conn_);
        
        if (_dbClearNamesDefs)
            db.deleteAlternates(idseq_);

        for (int i = 0; i < _alts.length; ++i)
        {
            if (_alts[i].getAcIdseq() == null)
                _alts[i].setACIdseq(idseq_);
            if (_alts[i].getConteIdseq() == null)
                _alts[i].setConteIdseq(conteIdseq_);
            db.save(_alts[i]);
        }
    }
    
    public static void save(HttpSession session_, Connection conn_, String idseq_, String conteIdseq_) throws SQLException
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
            for (int i = 0; i < sess._alts.length; ++i)
            {
                db.save(sess._alts[i], sess._acIdseq, sess._conteIdseq);
            }

            session_.removeAttribute(sessName);
            return;
        }
    }
    
    /**
     * Create and load a data buffer marking everything as new, i.e. "create using". This will discard any
     * existing data buffer in the AC Bean and replace it with a new buffer. The AC IDSEQ is cleared, the
     * Context IDSEQ is retained.
     * 
     * @param conn_
     * @param ac_
     */
    public static void loadAsNew(Connection conn_, AC_Bean ac_) throws Exception
    {
        // Determine the type of buffer.
        String launch = null;
        if (ac_ instanceof DE_Bean)
            launch = _searchDE;
        else if (ac_ instanceof DEC_Bean)
            launch = _searchDEC;
        else if (ac_ instanceof VD_Bean)
            launch = _searchVD;
        else if (ac_ instanceof VM_Bean)
            launch = _searchVM;

        // Create the new data buffer
        AltNamesDefsSession buffer = new AltNamesDefsSession(null, ac_.getContextIDSEQ(), ac_.getContextName(), launch);
        ac_.setAlternates(buffer);
        buffer._dbClearNamesDefs = true;
        
        // Load the data buffer with existing data marking everything as "new"
        DBAccess db = new DBAccess(conn_);
        String[] acIdseq = new String[1];
        acIdseq[0] = ac_.getIDSEQ();
        try
        {
            buffer._alts = db.getAlternates(acIdseq, true);
            
            // Make all the alternates "new"
            for (int i = 0; i < buffer._alts.length; ++i)
            {
                buffer._alts[i].markNew(buffer.newIdseq());
                buffer._alts[i].setACIdseq(null);
            }
        }
        catch (ToolException ex)
        {
            throw new Exception(ex.toString());
        }
    }
    
    /**
     * Same as loadAsNew(...) but for Block Edit
     * 
     * @param session_
     * @param conn_
     * @param ac_
     */
    public static void loadAsNew(HttpSession session_, Connection conn_, Vector<AC_Bean> ac_)
    {
        if (ac_.size() == 0)
            return;

        // Determine the type of buffer.
        String launch = null;
        AC_Bean temp = ac_.get(0);
        if (temp instanceof DE_Bean)
            launch = _searchDE;
        else if (temp instanceof DEC_Bean)
            launch = _searchDEC;
        else if (temp instanceof VD_Bean)
            launch = _searchVD;
        else if (temp instanceof VM_Bean)
            launch = _searchVM;

        // Setup the buffer
        String[] acIdseq = new String[ac_.size()];
        String[] conteIdseq = new String[acIdseq.length];
        String[] conteName = new String[acIdseq.length];
        for (int i = 0; i < acIdseq.length; ++i)
        {
            acIdseq[i] = ac_.get(i).getIDSEQ();
            conteIdseq[i] = ac_.get(i).getContextIDSEQ();
            conteName[i] = ac_.get(i).getContextName();
        }
        AltNamesDefsSession alt = new AltNamesDefsSession(acIdseq, conteIdseq, conteName,  launch);
        
        // Save the buffer in the session - this MUST be done for all the Alt Names/Defs to appear on a single screen.
        String sessName = getSessName(_beanBlock);
        session_.setAttribute(sessName, alt);
        
        // Load the data as new
        for (int i = 0; i < alt._acIdseq.length; ++i)
        {
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
    public static final String _beanVMID = "vmID";
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
    private boolean _dbClearNamesDefs;

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
