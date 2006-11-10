// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/database/SQLSelectCSI.java,v 1.13 2006-11-10 05:40:44 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.database;

/**
 * Define the SQL and replacement arguments to retrieve a CSI lineage.
 * 
 * @author lhebel
 *
 */
public class SQLSelectCSI
{
    public static String getAlternatesCSISelect(String alias_)
    {
        return "select level, cc.cs_idseq, cs.long_name, cc.cs_csi_idseq, csi.csi_name, cs.preferred_definition, cs.version, c.name, csi.csitl_name " 
        + "from sbr.cs_csi_view cc, sbr.class_scheme_items_view csi, sbr.classification_schemes_view cs, sbr.contexts_view c " 
        + "where csi.csi_idseq = cc.csi_idseq and cs.cs_idseq(+) = cc.cs_idseq and c.conte_idseq(+) = cs.conte_idseq " 
        + "connect by prior cc.p_cs_csi_idseq = cc.cs_csi_idseq " 
        + "start with cc.cs_csi_idseq = ? and csi.csi_idseq = cc.csi_idseq and csi.csitl_name <> '" + alias_ + "'";
    }
    
    public static final int _LEVEL = 1;
    public static final int _CSIDSEQ = 2;
    public static final int _CSNAME = 3;
    public static final int _CSCSIIDSEQ = 4;
    public static final int _CSINAME = 5;
    public static final int _CSDEFIN = 6;
    public static final int _CSVERS = 7;
    public static final int _CSCONTE = 8;
    public static final int _CSITYPE = 9;
    
    public static final int _ARGCSCSIIDSEQ = 1;
}
