// Copyright (c) 2007 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/EVSSearchStub.java,v 1.8 2007-06-12 20:26:17 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import gov.nih.nci.evs.domain.DescLogicConcept;
import java.io.Serializable;
import java.util.List;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;

/**
 * @author lhebel
 * 
 */
public class EVSSearchStub implements Serializable
{
    /**
     * 
     */
    private static final long serialVersionUID = 7162283077097248334L;

    /**
     * 
     */
    public EVSSearchStub()
    {
    }

    /** constant value for empty data to get the vocab attribute from the user bean according to what is needed */
    public static final int     VOCAB_NULL     = 0;

    /** constant value to return display vocab name */
    public static final int     VOCAB_DISPLAY  = 1;

    /** constant value to return database vocab orgin */
    public static final int     VOCAB_DBORIGIN = 2;

    /** constant value to return database vocab name */
    public static final int     VOCAB_NAME     = 3;

    /** constant value to recorgnize meta data */
    public static final String  META_VALUE     = "MetaValue";

    private static final Logger logger         = Logger.getLogger(EVSSearchStub.class);

    /**
     * Constructs a new instance.
     * 
     * @param req
     *            The HttpServletRequest object.
     * @param res
     *            HttpServletResponse object.
     * @param CurationServlet
     *            NCICuration servlet object.
     */
    public EVSSearchStub(HttpServletRequest req, HttpServletResponse res, CurationServlet CurationServlet)
    {
        logger.debug("here");
    }

    /**
     * Constructor
     * 
     * @param user_
     *            The EVS User Bean
     */
    public EVSSearchStub(EVS_UserBean user_)
    {
        logger.debug("here");
    }

    /**
     * does evs code search
     * 
     * @param prefName
     *            string to search for
     * @param dtsVocab
     *            string selected vocabulary name
     * @return string of evs code
     */
    public String do_getEVSCode(String prefName, String dtsVocab)
    {
        logger.debug("here");
        return "";
    }

    /**
     * does evs code search
     * 
     * @param CCode
     *            string to search for
     * @param dtsVocab
     *            string selected vocabulary name
     * @return string of evs code
     */
    public String do_getConceptName(String CCode, String dtsVocab)
    {
        logger.debug("here");
        return "";
    }

    /**
     * 
     * @param oc_condr_idseq
     *            id of condr.
     * @param m_DEC
     * @param sMenu
     * 
     * @throws Exception
     * 
     */
    public void fillOCVectors(String oc_condr_idseq, DEC_Bean m_DEC, String sMenu) throws Exception
    {
        logger.debug("here");
    }

    /**
     * 
     * @param prop_condr_idseq
     *            id of condr.
     * @param m_DEC
     * @param sMenu
     * 
     * @throws Exception
     * 
     */
    public void fillPropVectors(String prop_condr_idseq, DEC_Bean m_DEC, String sMenu) throws Exception
    {
        logger.debug("here");
    }

    /**
     * 
     * @param rep_condr_idseq
     *            id of condr.
     * @param m_VD
     * @param sMenu
     * 
     * @throws Exception
     * 
     */
    public void fillRepVectors(String rep_condr_idseq, VD_Bean m_VD, String sMenu) throws Exception
    {
        logger.debug("here");
    }

    /**
     * @param condr_idseq
     * @return sCUIString
     */
    public String getEVSIdentifierString(String condr_idseq) // returns list of Data Element Concepts
    {
        logger.debug("here");
        return "";
    }

    /**
     * 
     * @param dtsVocab
     * @return vRoot vector of Root concepts
     */
    public List getRootConcepts(String dtsVocab) // , boolean codeOrNames)
    {
        logger.debug("here");
        return null;
    }

    /**
     * This method searches EVS vocabularies and returns subconcepts, which are used to construct an EVS Tree.
     * 
     * @param dtsVocab
     *            the EVS Vocabulary
     * @param conceptCode
     *            the root concept.
     * @return vector of concept objects
     * 
     */
    @SuppressWarnings("unchecked")
    public Vector getAllSubConceptCodes(String dtsVocab, String conceptCode)
    {
        logger.debug("here");
        return new Vector();
    }

    /**
     * This method searches EVS vocabularies and returns subconcepts, which are used to construct an EVS Tree.
     * 
     * @param dtsVocab
     *            the EVS Vocabulary
     * @param conceptName
     *            the root concept.
     * @param type
     * @param conceptCode
     *            the root concept.
     * @param defSource
     * @return vector of concept objects
     * 
     */
    @SuppressWarnings("unchecked")
    public Vector getSubConceptNames(String dtsVocab, String conceptName, String type, String conceptCode,
                    String defSource)
    {
        logger.debug("here");
        return new Vector();
    }

    /**
     * This method returns all subconcepts of a concept
     * 
     * @param dtsVocab
     *            the EVS Vocabulary
     * @param stringArray
     *            array of strings
     * @param vSub
     *            vector of subs
     * @return stringArray
     * 
     */
    @SuppressWarnings("unchecked")
    public String[] getAllSubConceptNames(String dtsVocab, String[] stringArray, Vector vSub)
    {
        logger.debug("here");
        return stringArray;
    }

    /**
     * This method searches EVS vocabularies and returns superconcepts name of subconcepts on level below concept in
     * heirarchy
     * 
     * @param dtsVocab
     *            the EVS Vocabulary
     * @param conceptName
     *            the root concept.
     * @param conceptCode
     * @return vSub
     */
    @SuppressWarnings("unchecked")
    public Vector getSuperConceptNamesImmediate(String dtsVocab, String conceptName, String conceptCode)
    {
        logger.debug("here");
        return new Vector();
    }

    /**
     * This method searches EVS vocabularies and returns superconcepts, which are used to construct an EVS Tree.
     * 
     * @param dtsVocab
     *            the EVS Vocabulary
     * @param conceptName
     * @param conceptCode
     * @return vSub
     */
    @SuppressWarnings("unchecked")
    public Vector getSuperConceptNames(String dtsVocab, String conceptName, String conceptCode)
    {
        logger.debug("here");
        return new Vector();
    }

    /**
     * To get final result vector of selected attributes/rows to display for Object Class component, called from
     * getACKeywordResult, getACSortedResult and getACShowResult methods. gets the selected attributes from session
     * vector 'selectedAttr'. loops through the OCBean vector 'vACSearch' and adds the selected fields to result vector.
     * 
     * @param req
     *            The HttpServletRequest object.
     * @param res
     *            HttpServletResponse object.
     * @param vResult
     *            output result vector.
     * @param refresh
     * 
     */
    public void get_Result(HttpServletRequest req, HttpServletResponse res, Vector vResult, String refresh)
    {
        logger.debug("here");
    }

    /**
     * To get final result vector of selected attributes/rows to display for Rep Term component, gets the selected
     * attributes from session vector 'selectedAttr'. loops through the RepBean vector 'vACSearch' and adds the selected
     * fields to result vector.
     * 
     */
    public void getMetaSources()
    {
        logger.debug("here");
    }

    /**
     * various search for concept method including name, cui etc for all vocabularies stores the results in EVS bean
     * which then stored in the vector to send back.
     * 
     * @param vConList
     *            vector existing vector of concepts
     * @param termStr
     *            String search term
     * @param dtsVocab
     *            STring vocabulary name
     * @param sSearchIn
     *            String search in attribute
     * @param namePropIn
     *            String property name to search in
     * @param sSearchAC
     *            String AC name for the search
     * @param sIncludeRet
     *            String include or exclude the retired search
     * @param sMetaSource
     *            String meta source selected
     * @param iMetaLimit
     *            int meta search result limit
     * @param isMetaSearch
     *            boolean to meta search or not
     * @param ilevel
     *            int current level of the concept
     * @param subConType
     *            String immediate or all sub concepts to return
     * @return VEctor of concept bean
     */
    public Vector<EVS_Bean> doVocabSearch(Vector<EVS_Bean> vConList, String termStr, String dtsVocab, String sSearchIn,
                    String namePropIn, String sSearchAC, String sIncludeRet, String sMetaSource, int iMetaLimit,
                    boolean isMetaSearch, int ilevel, String subConType)
    {
        logger.debug("here");
        // do not continue if empty string search.
        if (termStr == null || termStr.equals(""))
            return vConList;
        // check if the concept name property exists for the vocab
        if (vConList == null)
            vConList = new Vector<EVS_Bean>();
        return vConList;
    }

    /**
     * gets the display name of the concepts
     * 
     * @param dtsVocab
     *            STring vocabulary name
     * @param dlc
     *            concepts desclogicobject from the API call
     * @param sName
     *            name of the concept
     * @return String display name
     */
    public String getDisplayName(String dtsVocab, DescLogicConcept dlc, String sName)
    {
        logger.debug("here");
        return sName;
    }

    /**
     * gets request parameters to store the selected values in the session according to what the menu action is
     * 
     * @throws Exception
     */
    public void doGetSuperConcepts() throws Exception
    {
        logger.debug("here");
    }

    /**
     * to show the concept in a tree
     * 
     * @param actType
     *            String action type
     */
    public void showConceptInTree(String actType)
    {
        logger.debug("here");
    }

    /**
     * gets request parameters to store the selected values in the session according to what the menu action is
     * 
     * @param sConceptName
     *            string concept name
     * @param sConceptID
     *            string concept identifier
     * @param strForward
     *            string true or false values to forward the page or not
     * @param dtsVocab
     *            string vocab name
     * 
     * @throws Exception
     */
    public void doTreeSearchRequest(String sConceptName, String sConceptID, String strForward, String dtsVocab)
                    throws Exception
    {
        logger.debug("here");
    }

    /**
     * 
     * @param actType
     *            String type of filter a simple or advanced
     * @param searchType
     *            String type of filter a simple or advanced
     * 
     * @throws Exception
     */
    public void doTreeSearch(String actType, String searchType) throws Exception
    {
        logger.debug("here");
    }

    /**
     * to collapse all the nodes of the tree
     * 
     * @param dtsVocab
     *            String vocabulary name
     * @throws Exception
     */
    public void doCollapseAllNodes(String dtsVocab) throws Exception
    {
        logger.debug("here");
    }

    /**
     * gets request parameters to store the selected values in the session according to what the menu action is
     * 
     * @throws Exception
     */
    public void doTreeRefreshRequest() throws Exception
    {
        logger.debug("here");
    }

    /**
     * gets request parameters to store the selected values in the session according to what the menu action is forwards
     * JSP 'SearchResultsPage.jsp' if the action is not searchForCreate. if action is searchForCreate forwards
     * OpenSearchWindow.jsp
     * 
     * @throws Exception
     */
    public void doTreeExpandRequest() throws Exception
    {
        logger.debug("here");
    }

    /**
     * gets request parameters to store the selected values in the session according to what the menu action is forwards
     * JSP 'SearchResultsPage.jsp' if the action is not searchForCreate. if action is searchForCreate forwards
     * OpenSearchWindow.jsp
     * 
     * @throws Exception
     */
    public void doTreeCollapseRequest() throws Exception
    {
        logger.debug("here");
    }

    /**
     * gets request parameters to store the selected values in the session according to what the menu action is
     * 
     * 
     * @throws Exception
     */
    public void doGetSubConcepts() throws Exception
    {
        logger.debug("here");
    }

    /**
     * to open the tree to the selected concept
     * 
     * @param actType
     *            String action type
     */
    public void openTreeToConcept(String actType)
    {
        logger.debug("here");
    }

    /**
     * to get the matching thesaurus concept
     * 
     * @param eBean
     *            EVS Bean of the concept
     * @return return the EVS_Bean
     */
    public EVS_Bean getThesaurusConcept(EVS_Bean eBean)
    {
        logger.debug("here");
        return new EVS_Bean();
    }
}
