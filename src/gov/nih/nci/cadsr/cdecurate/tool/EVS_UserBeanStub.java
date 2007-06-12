// Copyright (c) 2002 ScenPro, Inc.
// $Header: /CVSNT/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/EVS_UserBean.java,v 1.15 2007/01/12 21:35:07 shegde
// Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

// import gov.nih.nci.evs.domain.Source;
import java.io.Serializable;
import java.util.Hashtable;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;

/**
 * The UserBean encapsulates the EVS information from caDSR database and will be stored in the session after the user
 * has logged on.
 * <P>
 * 
 * @author Sumana
 * @version 3.0
 */
public final class EVS_UserBeanStub implements Serializable
{
    private static final long   serialVersionUID = 8161299425314596067L;

    private String              m_evsConURL;                                                // connection string

    private Vector              m_vocabNameList;                                            // index name of the vocab
                                                                                            // that are not displayed

    private Vector              m_vocabDisplayList;                                         // drop down list of names

    private String              m_vocabName;                                                // vocab name used to query
                                                                                            // cacore api

    private String              m_vocabDisplay;                                             // vocab name displayed in
                                                                                            // the jsp

    private String              m_vocabDBOrigin;                                            // vocab name stored in
                                                                                            // cadsr table as origin and
                                                                                            // vocab name in the search
                                                                                            // results

    private String              m_vocabMetaSource;                                          // Meta source to the
                                                                                            // specific vocabulary

    private boolean             m_vocabUseParent;                                           // true or false value to
                                                                                            // mark it to be used for
                                                                                            // parent search

    private String              m_SearchInName;                                             // display term for search
                                                                                            // in of name option

    private String              m_SearchInConCode;                                          // display term for search
                                                                                            // in of Concept Code option

    private String              m_SearchInMetaCode;                                         // display term for search
                                                                                            // in of MetaCode option

    private String              m_NameType;                                                 // Vocab type to search
                                                                                            // concept name

    private String              m_PropName;                                                 // evs property for concept
                                                                                            // name attribute

    private String              m_PropNameDisp;                                             // evs property for concept
                                                                                            // name attribute

    private String              m_PropDefinition;                                           // evs property for
                                                                                            // definition attribute

    private String              m_PropHDSyn;                                                // evs property for header
                                                                                            // concept attribute

    private String              m_PropRetCon;                                               // evs property for retired
                                                                                            // concept property

    private String              m_PropSemantic;                                             // evs property for Symantic
                                                                                            // Type property

    private String              m_retSearch;                                                // retired option for search
                                                                                            // filter

    private String              m_treeSearch;                                               // tree display option for
                                                                                            // search filter

    private String              m_includeMeta;                                              // retired option for search
                                                                                            // filter

    private String              m_codeType;                                                 // code types specific to
                                                                                            // each vocab

    private String              m_defDefaultValue;                                          // definition default value
                                                                                            // if value doesn't exists

    private String              m_metaDispName;                                             // meta display name used
                                                                                            // for commapring

    private String              m_dsrDispName;                                              // dsr database display name
                                                                                            // used for commapring

    private Vector              m_NCIDefSrcList;                                            // list of definition
                                                                                            // sources for NCI in the
                                                                                            // priority order

    private Hashtable           m_metaCodeType;                                             // code type for meta
                                                                                            // thesaurus with filter
                                                                                            // value

    private Hashtable           m_vocab_attr;                                               // attributes specific to
                                                                                            // vocabs

    private String              PrefVocabSrc;                                               // source of the preferred
                                                                                            // vocabulary

    private String              PrefVocab;                                                  // name of the preferred
                                                                                            // vocabulary

    private String              _vocabAccess;

    private static final Logger logger           = Logger.getLogger(EVS_UserBeanStub.class);

    /**
     * Constructor
     */
    public EVS_UserBeanStub()
    {
        logger.debug("here");
    }

    /**
     * The getEVSConURL method returns the evs connection string for this bean.
     * 
     * @return String The connection string
     */
    public String getEVSConURL()
    {
        return m_evsConURL;
    }

    /**
     * The setEVSConURL method sets the evs connection string for this bean.
     * 
     * @param evsURL
     *            The connection string to set
     */
    public void setEVSConURL(String evsURL)
    {
        m_evsConURL = evsURL;
    }

    /**
     * gets the list of vocabs from the bean
     * 
     * @return m_vocabNameList list of vocabulary names
     */
    public Vector getVocabNameList()
    {
        return m_vocabNameList;
    }

    /**
     * this sets the list of vocab names into the bean stored in database
     * 
     * @param vName
     *            list of vocab names from the database
     */
    public void setVocabNameList(Vector vName)
    {
        m_vocabNameList = vName;
    }

    /**
     * gets the list of vocabs from the bean
     * 
     * @return m_vocabDisplayList list of vocabulary Display names
     */
    public Vector getVocabDisplayList()
    {
        return m_vocabDisplayList;
    }

    /**
     * this sets the list of vocab Display names into the bean stored in database
     * 
     * @param vDisplay
     *            list of vocab Display names from the database
     */
    public void setVocabDisplayList(Vector vDisplay)
    {
        m_vocabDisplayList = vDisplay;
    }

    /**
     * The getVocabName method returns the name of the vocab used for quering the cacore api.
     * 
     * @return String The name of the vocab
     */
    public String getVocabName()
    {
        return m_vocabName;
    }

    /**
     * The setVocabName method sets the name of the vocab for querying the cacore api.
     * 
     * @param sName
     *            The name of the vocab
     */
    public void setVocabName(String sName)
    {
        m_vocabName = sName;
    }

    /**
     * The getVocabDisplay method returns the Display of the vocab used for quering the cacore api.
     * 
     * @return String The Display of the vocab
     */
    public String getVocabDisplay()
    {
        return m_vocabDisplay;
    }

    /**
     * The setVocabDisplay method sets the Display of the vocab for querying the cacore api.
     * 
     * @param sDisplay
     *            The Display of the vocab
     */
    public void setVocabDisplay(String sDisplay)
    {
        m_vocabDisplay = sDisplay;
    }

    /**
     * The getVocabDBOrigin method returns the DBOrigin of the vocab used for quering the cacore api.
     * 
     * @return String The DBOrigin of the vocab
     */
    public String getVocabDBOrigin()
    {
        return m_vocabDBOrigin;
    }

    /**
     * The setVocabDBOrigin method sets the DBOrigin of the vocab for querying the cacore api.
     * 
     * @param sDBOrigin
     *            The DBOrigin of the vocab
     */
    public void setVocabDBOrigin(String sDBOrigin)
    {
        m_vocabDBOrigin = sDBOrigin;
    }

    /**
     * The getVocabMetaSource method returns the MetaSource of the vocab used for quering the cacore api.
     * 
     * @return String The MetaSource of the vocab
     */
    public String getVocabMetaSource()
    {
        return m_vocabMetaSource;
    }

    /**
     * The setVocabMetaSource method sets the MetaSource of the vocab for querying the cacore api.
     * 
     * @param sMetaSource
     *            The MetaSource of the vocab
     */
    public void setVocabMetaSource(String sMetaSource)
    {
        m_vocabMetaSource = sMetaSource;
    }

    /**
     * The getVocabUseParent method returns the the true or false value to use as vocab parent.
     * 
     * @return boolean true or false value The parent use of the vocab
     */
    public boolean getVocabUseParent()
    {
        return m_vocabUseParent;
    }

    /**
     * The setVocabUseParent method sets the true or false value to use as vocab parent.
     * 
     * @param bUseParent
     *            The True or False value to use the vocab as parent
     */
    public void setVocabUseParent(boolean bUseParent)
    {
        m_vocabUseParent = bUseParent;
    }

    /**
     * gets the display name for the Name option of evs searchin
     * 
     * @return m_SearchInName display name option of evs searchin
     */
    public String getSearchInName()
    {
        return m_SearchInName;
    }

    /**
     * this sets the display name for the Name option of evs searchin into the bean stored in database
     * 
     * @param sData
     *            the display name for the Name option of evs searchin from the database
     */
    public void setSearchInName(String sData)
    {
        m_SearchInName = sData;
    }

    /**
     * gets the display name for the Concept Code option of evs searchin
     * 
     * @return m_SearchInName display Concept Code option of evs searchin
     */
    public String getSearchInConCode()
    {
        return m_SearchInConCode;
    }

    /**
     * this sets the display name for the Concept Code option of evs searchin into the bean stored in database
     * 
     * @param sData
     *            the display name for the Concept Code option of evs searchin from the database
     */
    public void setSearchInConCode(String sData)
    {
        m_SearchInConCode = sData;
    }

    /**
     * gets the display name for the Meta Code option of evs searchin
     * 
     * @return m_SearchInName display Meta Code option of evs searchin
     */
    public String getSearchInMetaCode()
    {
        return m_SearchInMetaCode;
    }

    /**
     * this sets the display name for the Meta Code option of evs searchin into the bean stored in database
     * 
     * @param sData
     *            the display name for the Meta Code option of evs searchin from the database
     */
    public void setSearchInMetaCode(String sData)
    {
        m_SearchInMetaCode = sData;
    }

    /**
     * The getNameType method returns the Type for name search in for the vocab for this bean.
     * 
     * @return String the Type for name search in for the vocab
     */
    public String getNameType()
    {
        return m_NameType;
    }

    /**
     * The setType method sets the Type for name search in for the vocab for this bean.
     * 
     * @param sNType
     *            the sNType for name search in for the vocab
     */
    public void setNameType(String sNType)
    {
        m_NameType = sNType;
    }

    /**
     * The getPropName method returns the concept property string for concept for this bean.
     * 
     * @return String The property string for concept name
     */
    public String getPropName()
    {
        return m_PropName;
    }

    /**
     * The setPropName method sets the concept property string used to search concept name for this bean.
     * 
     * @param sName
     *            The property string for concept name to set
     */
    public void setPropName(String sName)
    {
        m_PropName = sName;
    }

    /**
     * The getPropNameDisp method returns the concept name disp property string for concept for this bean.
     * 
     * @return String The property string for concept name disp
     */
    public String getPropNameDisp()
    {
        return m_PropNameDisp;
    }

    /**
     * The setPropNameDisp method sets the concept property string used to search concept name for this bean.
     * 
     * @param sName
     *            The property string for concept name display to set
     */
    public void setPropNameDisp(String sName)
    {
        m_PropNameDisp = sName;
    }

    /**
     * The getPropDefinition method returns the concept property string for concept for this bean.
     * 
     * @return String The property string for concept Definition
     */
    public String getPropDefinition()
    {
        return m_PropDefinition;
    }

    /**
     * The setPropDefinition method sets the concept property string used to search concept Definition for this bean.
     * 
     * @param sDefinition
     *            The property string for concept Definition to set
     */
    public void setPropDefinition(String sDefinition)
    {
        m_PropDefinition = sDefinition;
    }

    /**
     * The getPropHDSyn method returns the concept property string for concept for this bean.
     * 
     * @return String The property string for concept header concept
     */
    public String getPropHDSyn()
    {
        return m_PropHDSyn;
    }

    /**
     * The setPropHDSyn method sets the concept property string used to search concept header concept for this bean.
     * 
     * @param sHDSyn
     *            The property string for concept header concept to set
     */
    public void setPropHDSyn(String sHDSyn)
    {
        m_PropHDSyn = sHDSyn;
    }

    /**
     * The getPropRetCon method returns the concept property string for concept for this bean.
     * 
     * @return String The property string for retired concept
     */
    public String getPropRetCon()
    {
        return m_PropRetCon;
    }

    /**
     * The setPropRetCon method sets the concept property string used to search retired concept for this bean.
     * 
     * @param sRetCon
     *            The property string for retired concept to set
     */
    public void setPropRetCon(String sRetCon)
    {
        m_PropRetCon = sRetCon;
    }

    /**
     * The getPropSemantic method returns the concept property string for concept for this bean.
     * 
     * @return String The property string for concept Semantic Type
     */
    public String getPropSemantic()
    {
        return m_PropSemantic;
    }

    /**
     * The setPropSemantic method sets the concept property string used to search concept Semantic Type for this bean.
     * 
     * @param sSemantic
     *            The property string for concept Semantic Type to set
     */
    public void setPropSemantic(String sSemantic)
    {
        m_PropSemantic = sSemantic;
    }

    /**
     * The getRetSearch method returns the RetSearch status for this bean.
     * 
     * @return String Whether this vocab is to display is a RetSearch or not
     */
    public String getRetSearch()
    {
        return m_retSearch;
    }

    /**
     * The setRetSearch method sets the RetSearch status for this bean.
     * 
     * @param isRetSearch
     *            The RetSearch option for the vocabulary for JSP
     */
    public void setRetSearch(String isRetSearch)
    {
        m_retSearch = isRetSearch;
    }

    /**
     * @return Returns the m_treeSearch.
     */
    public String getTreeSearch()
    {
        return m_treeSearch;
    }

    /**
     * @param search
     *            The m_treeSearch to set.
     */
    public void setTreeSearch(String search)
    {
        m_treeSearch = search;
    }

    /**
     * The getIncludeMeta method returns the IncludeMeta vocabulary name for this bean.
     * 
     * @return String Whether this vocab is associated with another vocab like Meta thesarus
     */
    public String getIncludeMeta()
    {
        return (m_includeMeta == null) ? "" : m_includeMeta;
    }

    /**
     * The setIncludeMeta method sets the IncludeMeta vocabulary name for this bean.
     * 
     * @param sMetaName
     *            The Meta vocab name associated with another vocab
     */
    public void setIncludeMeta(String sMetaName)
    {
        m_includeMeta = sMetaName;
    }

    /**
     * The getCode_Type method returns the concept code type (altname type or evs source) specific to the vocabulary.
     * 
     * @return String m_codeType is a string
     */
    public String getVocabCodeType()
    {
        return m_codeType;
    }

    /**
     * stores the vocab code type in the bean
     * 
     * @param sType
     *            evs source type or altname type of the vocabulary
     */
    public void setVocabCodeType(String sType)
    {
        m_codeType = sType;
    }

    /**
     * @return boolean to mark web access
     */
    public boolean vocabIsSecure()
    {
        return _vocabAccess != null;
    }

    /**
     * @return string code of we access
     */
    public String getVocabAccess()
    {
        return _vocabAccess;
    }

    /**
     * @param code_
     *            string code of we access
     */
    public void setVocabAccess(String code_)
    {
        _vocabAccess = code_;
    }

    /**
     * The getDefDefaultValue method returns the default definition value.
     * 
     * @return String m_defDefaultValue is a string
     */
    public String getDefDefaultValue()
    {
        return m_defDefaultValue;
    }

    /**
     * stores the default value for the defiinition used if definition from api is empty
     * 
     * @param sDef
     *            default definition
     */
    public void setDefDefaultValue(String sDef)
    {
        m_defDefaultValue = sDef;
    }

    /**
     * The getMetaDispName method returns the meta thesaurs name display.
     * 
     * @return String m_metaDispName is a string
     */
    public String getMetaDispName()
    {
        return m_metaDispName;
    }

    /**
     * stores the meta name for display
     * 
     * @param sName
     *            meta name
     */
    public void setMetaDispName(String sName)
    {
        m_metaDispName = sName;
    }

    /**
     * The getDSRDispName method returns the DSR name display.
     * 
     * @return String m_dsrDispName is a string
     */
    public String getDSRDispName()
    {
        return m_dsrDispName;
    }

    /**
     * stores the DSR name for display
     * 
     * @param sName
     *            DSR name
     */
    public void setDSRDispName(String sName)
    {
        m_dsrDispName = sName;
    }

    /**
     * gets the list of NCI definition sources to filter out
     * 
     * @return m_NCIDefSrcList list of defintion sources
     */
    public Vector getNCIDefSrcList()
    {
        return m_NCIDefSrcList;
    }

    /**
     * this sets the list of NCI definition sources to filter out
     * 
     * @param vName
     *            list of NCI definition sources
     */
    public void setNCIDefSrcList(Vector vName)
    {
        m_NCIDefSrcList = vName;
    }

    /**
     * The getVocab_Attr method returns the attributes specific to the vocabulary.
     * 
     * @return Hashtable m_vocab_attr is a hash table with
     */
    public Hashtable getVocab_Attr()
    {
        return m_vocab_attr;
    }

    /**
     * stores the vocab specific attributes in the hash table
     * 
     * @param vocAttr
     *            hashtable with vocab name and user bean as objects
     */
    public void setVocab_Attr(Hashtable vocAttr)
    {
        m_vocab_attr = vocAttr;
    }

    /**
     * The getMetaCodeType method returns code type for the meta thesaurus.
     * 
     * @return Hashtable m_metaCodeType is a hash table with code type and filter value
     */
    public Hashtable getMetaCodeType()
    {
        return m_metaCodeType;
    }

    /**
     * stores the vocab specific attributes in the hash table
     * 
     * @param metaType
     *            hashtable with vocab name and user bean as objects
     */
    public void setMetaCodeType(Hashtable metaType)
    {
        m_metaCodeType = metaType;
    }

    /**
     * @return Returns the prefVocabSrc.
     */
    public String getPrefVocabSrc()
    {
        return PrefVocabSrc;
    }

    /**
     * @param prefVocabSrc
     *            The prefVocabSrc to set.
     */
    public void setPrefVocabSrc(String prefVocabSrc)
    {
        PrefVocabSrc = prefVocabSrc;
    }

    /**
     * @return Returns the prefVocab.
     */
    public String getPrefVocab()
    {
        return PrefVocab;
    }

    /**
     * @param prefVocab
     *            The prefVocab to set.
     */
    public void setPrefVocab(String prefVocab)
    {
        PrefVocab = prefVocab;
    }

    public java.util.List getEVSVocabs(String eURL)
    {
        logger.debug("here");
        return null;
    }

    /**
     * gets EVS related data from tools options table at login instead of hardcoding
     * 
     * @param req
     *            request object
     * @param res
     *            rsponse object
     * @param servlet
     *            servlet object
     */
    public void getEVSInfoFromDSR(HttpServletRequest req, HttpServletResponse res, CurationServlet servlet)
    {
        logger.debug("here");
    }

    public EVS_UserBean storeVocabAttr(EVS_UserBean vuBean, Vector vAttr)
    {
        logger.debug("here");
        return vuBean;
    }
}
