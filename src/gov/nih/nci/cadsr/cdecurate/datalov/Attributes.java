// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/datalov/Attributes.java,v 1.13 2007-06-12 20:26:17 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.datalov;

/**
 * @author lhebel
 *
 */
public enum Attributes
{
    ALIASNAME(0, "Alias Name", "aliasName", "Name/Alias Name"),
    ALTNAME(1, "Alternate Names", "altNames", "Alternate Names"),
    COMPONENT(2, "caDSR Component", "cadsrComp", "caDSR Component"),
    CDLONGNAME(3, "Conceptual Domain", "ConDomain", "Conceptual Domain"),
    CHANGENOTE(4, "Change Note", "Comments", "Change Note"),
    COMMENT(5, "Comments", "comment", "Comments"),
    CONCEPTNAME(6, "Concept Name", "conName", "Concept Name"),
    CONTEXT(7, "Context", "context", "Context"),
    CREATEBY(8, "Creator", "creator", "Creator"),
    CREATEDATE(9, "Date Created", "creDate", "Date Created"),
    CRFNAME(10, "CRF Name", "CRFName", "CRF Name"),
    CSIDEFINITION(11, "CSI Definition", "def", "CSI Definition"),
    CSILONGNAME(12, "Class Scheme Items", "CSI", "Class Scheme Items"),
    CSINAME(13, "CSI Name", "CSIName", "CSI Name"),
    CSITYPE(14, "CSI Type", "CSITL", "CSI Type"),
    CSLONGNAME(15, "CS Long Name", "CSName", "CS Long Name"),
    DATABASE(16, "Database", "db", "Database"),
    DATATYPE(17, "Data Type", "DataType", "Data Type"),
    DECIMALPLACE(18, "Decimal Place", "Decimal", "Decimal Place"),
    DECLONGNAME(19, "Data Element Concept", "DEC", "Data Element Concept Long Name"),
    DECUSING(20, "DEC's Using", "decUse", "DEC's Using"),
    DEFINITION(21, "Definition", "def", "Definition"),
    DEFSOURCE(22, "Definition Source", "source", "Definition Source"),
    DELONGNAME(23, "DE Long Name", "DELongName", "Data Element Long Name"),
    DEPUBLICID(24, "DE Public ID", "DEPublicID", "DE Public ID"),
    DERREL(25, "Derivation Relationship", "DerRelation", "Derivation Relationship"),
    DESCSOURCE(26, "Description Source", "descSource", "Description Source"),
    DIMENSION(27, "Dimensionality", "dimension", "Dimensionality"),
    DISPLAYFORMAT(28, "Display Format", "Format", "Display Format"),
    EFFBEGINDATE(29, "Effective Begin Date", "BeginDate", "Effective Begin Date"),
    EFFENDDATE(30, "Effective End Date", "EndDate", "Effective End Date"),
    EVSIDENTIFIER(31, "EVS Identifier", "umls", "EVS Identifier"),
    HIGHLIGHTIND(32, "Highlight Indicator", "HighLight", "Highlight Indicator"),
    HIGHVALUE(33, "High Value Number", "HighNum", "High Value Number"),
    IDENTIFIER(34, "Identifier", "Ident", "Identifier"),
    LANGUAGE(35, "Language", "language", "Language"),
    LEVEL(36, "Level", "Level", "Level"),
    LONGNAME(37, "Long Name", "longName", "Long Name"),
    LONGNAMECD(38, "Long Name", "longName", "Conceptual Domain Long Name"),
    LONGNAMEDE(39, "Long Name", "longName", "Data Element Long Name"),
    LONGNAMEDEC(40, "Long Name", "longName", "Data Element Concept Long Name"),
    LONGNAMEVD(41, "Long Name", "longName", "Value Domain Long Name"),
    LOWVALUE(42, "Low Value Number", "LowNum", "Low Value Number"),
    MAXLENGTH(43, "Maximum Length", "MaxLength", "Maximum Length"),
    MINLENGTH(44, "Minimum Length", "MinLength", "Minimum Length"),
    MODIFYBY(45, "Modifier", "modifier", "Modifier"),
    MODIFYDATE(46, "Date Modified", "modDate", "Date Modified"),
    NAME(47, "Name", "name", "Short Name"),
    ORIGIN(48, "Origin", "Origin", "Origin"),
    OWNEDBY(49, "Owned By Context", "context", "Owned By Context"),
    PROTOCOLID(50, "Protocol ID", "ProtoID", "Protocol ID"),
    PUBLICID(51, "Public ID", "publicID", "Public_ID"),
    PVLONGNAME(52, "Permissible Value", "permValue", "Permissible Value"),
    QUESTIONTEXT(53, "Question Text", "QuestText", "Question Text"),
    QUESTPUBLICID(54, "Question Public ID", "minID", "Question Public ID"),
    REFDOCS(55, "Reference Documents", "refDocs", "Reference Documents"),
    REGSTATUS(56, "Registration Status", "regStatus", "Registration Status"),
    SEMANTICTYPE(57, "Semantic Type", "semantic", "Semantic Type"),
    TYPEFLAG(58, "Type Flag", "TypeFlag", "Type Flag"),
    TYPEOFNAME(59, "Type of Name", "TypeName", "Type of Name"),
    UNITOFMEASURE(60, "Unit of Measures", "UOML", "Unit of Measures"),
    USEDBY(61, "Used By Context", "UsedContext", "Used By Context"),
    VALIDVALUE(62, "Valid Values", "validValue", "Valid Value"),
    VALUE(63, "Value", "value", "Value"),
    VDLONGNAME(64, "Value Domain", "vd", "Value Domain Long Name"),
    VERSION(65, "Version", "version", "Version"),
    VMDESC(66, "Value Meaning Description", "MeanDesc", "Value Meaning Description"),
    VMLONGNAME(67, "Value Meaning", "meaning", "Value Meaning"),
    VOCABULARY(68, "Vocabulary", "db", "Vocabulary"),
    WFSTATUS(69, "Workflow Status", "asl", "Workflow Status"),
    CLASSSCHEMES(70, "Classification Schemes", "Class", "Classification Schemes"),
    PUBID(71, "Public ID", "minID", "Public_ID"),
    MEANDESC(72, "Meaning Description", "MeanDesc", "Value Meaning Description"),
    VOCAB(73, "Vocabulary", "database", "Vocabulary"),
    WFS(74, "Workflow Status", "Status", "Workflow Status");
    
    public int toInt()
    {
        return _val;
    }
    
    /**
     * The display string for the attribute name.
     * @return the display name
     */
    public String getDisplay()
    {
        return _display;
    }
    
    /**
     * Get the search results HTML TD tag element.
     * @return the HTML TD tag element
     */
    public String formatTD()
    {
        return "<th method=\"get\"><a href=\"javascript:SetSortType('"
            + _sortType
            + "')\" onHelp = \"showHelp('../Help_SearchAC.html#searchResultsForm_sort'); return false\">"
            + _colName
            + "</a></th>";
    }
    
    static public Attributes valueOf(int val_)
    {
        return values()[val_];
    }

    private Attributes(int val_, String display_, String sort_, String col_)
    {
        _val = val_;
        _display = display_;
        _sortType = sort_;
        _colName = col_;
    }
    
    private int _val;
    private String _display;
    private String _sortType;
    private String _colName;
}
