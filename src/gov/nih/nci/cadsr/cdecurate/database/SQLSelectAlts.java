// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/database/SQLSelectAlts.java,v 1.24 2007-01-24 06:12:11 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.database;

/**
 * Define the SQL and replacement arguments to retrieve Alternates.
 * 
 * @author lhebel
 *
 */
public class SQLSelectAlts
{
    public static String getAlternates(boolean sortByName_)
    {
        String select =
            "select * from ("
            + "select ? as inst, d.name as aname, d.detl_name as dtype, d.lae_name, d.ac_idseq, d.desig_idseq, d.conte_idseq, c.name "
            + "from sbr.designations_view d, sbr.contexts_view c "
            + "where d.ac_idseq = ? and d.detl_name not in ('USED_BY') and c.conte_idseq = d.conte_idseq "
            + "union all "
            + "select ? as inst, d.definition as aname, d.defl_name as dtype, d.lae_name, d.ac_idseq, d.defin_idseq, d.conte_idseq, c.name "
            + "from sbr.definitions_view d, sbr.contexts_view c "
            + "where d.ac_idseq = ? and c.conte_idseq = d.conte_idseq) hits ";
        if (sortByName_)
            select += "order by hits.inst asc, lower(hits.aname) asc, lower(hits.dtype) asc";
        else
            select += "order by hits.inst asc, lower(hits.dtype) asc, lower(hits.aname) asc";
        
        return select;
    }
    
    public static final int _INSTANCE = 1;
    public static final int _NAMEDEF = 2;
    public static final int _TYPE = 3;
    public static final int _LANGUAGE = 4;
    public static final int _ACIDSEQ = 5;
    public static final int _ALTIDSEQ = 6;
    public static final int _CONTEIDSEQ = 7;
    public static final int _CONTEXT = 8;
    
    public static final int _ARGDESINST = 1;
    public static final int _ARGDESACIDSEQ = 2;
    public static final int _ARGDEFINST = 3;
    public static final int _ARGDEFACIDSEQ = 4;
}
