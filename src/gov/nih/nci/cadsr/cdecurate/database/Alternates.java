// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/database/Alternates.java,v 1.1 2006-10-27 15:04:05 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.database;

import gov.nih.nci.cadsr.cdecurate.ui.AltNamesDefsServlet;
import gov.nih.nci.cadsr.cdecurate.ui.AltNamesDefsSession;
import gov.nih.nci.cadsr.cdecurate.util.ToolException;
import gov.nih.nci.cadsr.cdecurate.util.Tree;
import gov.nih.nci.cadsr.cdecurate.util.TreeNode;
import java.sql.SQLException;

/**
 * @author lhebel
 *
 */
public class Alternates
{
    public static void main(String[] args_)
    {
    }
    
    public Alternates dupl()
    {
        Alternates temp = new Alternates(this);
        
        return temp;
    }

    private Alternates(Alternates old_)
    {
        _instance = old_._instance;
        _name = old_._name;
        _type = old_._type;
        _language = old_._language;
        _altIdseq = old_._altIdseq;
        _acIdseq = old_._acIdseq;
        _conteIdseq = old_._conteIdseq;
        _conteName = old_._conteName;
        _HTMLformat1 = old_._HTMLformat1;
        _HTMLformat2 = old_._HTMLformat2;
        _changed = old_._changed;
        _delete = old_._delete;
        _root = old_._root.dupl();
    }

    public Alternates()
    {
        clear();
    }
    
    public Alternates(int instance_, String name_, String type_, String lang_, String ac_, String desig_, String conte_, String conteName_)
    {
        _instance = instance_;
        setName(name_);
        setType(type_);
        setLanguage(lang_);
        setConteName(conteName_);
        _acIdseq = ac_;
        _altIdseq = desig_;
        _conteIdseq = conte_;
        _HTMLformat1 = _defHTMLformat1;
        _HTMLformat2 = _defHTMLformat2;
        _root = new Tree(new TreeNode("root", null, false));
        _changed = false;
        _delete = false;
    }

    public void clear()
    {
        _name = "";
        _type = "";
        _language = "";
        _conteName = "";
        _language = "ENGLISH";
        _HTMLformat1 = _defHTMLformat1;
        _HTMLformat2 = _defHTMLformat2;
        _root = new Tree(new TreeNode("root", null, false));
        _changed = false;
        _delete = false;
    }
    
    public Tree getCSITree()
    {
        return _root;
    }
    
    public void setName(String name_)
    {
        if (_name != null && _name.equals(name_))
            return;

        _name = (name_ == null) ? "" : name_;
        _changed = true;
    }
    
    public void setType(String type_)
    {
        if (_type != null && _type.equals(type_))
            return;

        _type = (type_ == null) ? "" : type_;
        _changed = true;
    }

    public void setLanguage(String lang_)
    {
        if (_language != null && _language.equals(lang_))
            return;

        _language = (lang_ == null) ? "" : lang_;
        _changed = true;
    }
    
    public void setACIdseq(String idseq_)
    {
        _acIdseq = idseq_;
    }
    
    public void setConteIdseq(String idseq_)
    {
        _conteIdseq = idseq_;
    }
    
    public void setConteName(String name_)
    {
        _conteName = (name_ == null) ? "" : name_;
    }
    
    public void toBeDeleted()
    {
        _delete = true;
    }
    
    public void markToKeep()
    {
        _delete = false;
    }
    
    public boolean isName()
    {
        return (_INSTANCENAME == _instance);
    }
    
    public boolean isIdseq(String idseq_)
    {
        return _altIdseq.equals(idseq_);
    }
    
    public boolean isDef()
    {
        return (_INSTANCEDEF == _instance);
    }
    
    public boolean isNew()
    {
        return (_altIdseq == null || _altIdseq.charAt(0) == AltNamesDefsSession._newPrefix.charAt(0));
    }
    
    public boolean isChanged()
    {
        return _changed;
    }
    
    public boolean isDeleted()
    {
        return _delete;
    }

    public int validateCheck()
    {
        if (_acIdseq == null)
        {
            return _MISSINGAC;
        }
        if (_conteIdseq == null)
        {
            return _MISSINGCONTE;
        }
        if (_type == null)
        {
            return _MISSINGTYPE;
        }
        if (_name == null)
        {
            return _MISSINGNAME;
        }
        return 0;
    }
    
    public void validate() throws SQLException
    {
        switch (validateCheck())
        {
        case _MISSINGAC:
            throw new SQLException(this.getClass().getName() + ": AC IDSEQ is null, use method setACIdseq().");
        case _MISSINGCONTE:
            throw new SQLException(this.getClass().getName() + ": Context IDSEQ is null, use method setConteIdseq().");
        case _MISSINGTYPE:
            throw new SQLException(this.getClass().getName() + ": Type is null, use method setType().");
        case _MISSINGNAME:
            throw new SQLException(this.getClass().getName() + ": Name is null, use method setName().");
        }
    }
    
    public void save() throws SQLException
    {
        validate();
        if (isNew())
            ;
    }
    
    public String getName()
    {
        return _name;
    }
    
    public String getType()
    {
        return _type;
    }
    
    public String getLanguage()
    {
        return _language;
    }
    
    public String getAltIdseq()
    {
        return _altIdseq;
    }
    
    public void setAltIdseq(String idseq_)
    {
        _altIdseq = idseq_;
    }
    
    public String getAcIdseq()
    {
        return (_acIdseq == null || _acIdseq.length() == 0) ? null : _acIdseq;
    }
    
    public String getConteIdseq()
    {
        return (_conteIdseq == null || _conteIdseq.length() == 0) ? null : _conteIdseq;
    }
    
    public String getConteName()
    {
        return _conteName;
    }

    public void setHTMLformat1(String format_)
    {
        _HTMLformat1 = format_;
    }

    public void setHTMLformat2(String format_)
    {
        _HTMLformat1 = format_;
    }
    
    public String getHTMLformat1()
    {
        return _HTMLformat1;
    }
    
    public String getHTMLformat2()
    {
        return _HTMLformat2;
    }
    
    public int getInstance()
    {
        return _instance;
    }
    
    public void setInstance(int instance_)
    {
        _instance = instance_;
    }
    
    public String toHTML()
    {
        String[] formats = new String[3];
        formats[AltNamesDefsServlet._classTypeAlt] = "(not used)";
        formats[AltNamesDefsServlet._classTypeCSI] = AltNamesDefsServlet._formatHTMLcsiView;
        formats[AltNamesDefsServlet._classTypeCS] = AltNamesDefsServlet._formatHTMLcsView;

        String text = _HTMLformat1;
        text = text.replace("{[NTITLE]}", (_instance == _INSTANCENAME) ? "Alternate Name" : "Alternate Definition");
        text = text.replace("{[NAME]}", _name.trim().replaceAll("[\\n]", "<br/>"));
        text = text.replace("{[TYPE]}", _type.replaceAll(" ", "&nbsp;"));
        text = text.replace("{[LANG]}", _language.replaceAll(" ", "&nbsp;"));
        text = text.replace("{[CONTEXT]}", _conteName.trim().replaceAll(" ", "&nbsp;"));
        text = text.replace("{[CSI]}", _root.toHTML(formats));
        text = text.replace("{[NODELEVEL]}", "0");
        text = text.replace("{[NODEVALUE]}",_altIdseq);
        text = text.replace("{[CLASSTYPE]}", String.valueOf(_instance));
        if(_delete)
        {
            text = text.replace("{[DELFLAG]}", "line-through");
            text = text.replace("{[DELGLYPH]}", "<span class=\"restore\" title=\"Restore\" onclick=\"doRestore(this);\"/>&#81;</span>");
        }
        else
        {
            text = text.replace("{[DELFLAG]}", "none");
            text = text.replace("{[DELGLYPH]}", "<img src=\"Assets/delete.gif\" title=\"Delete\" onclick=\"doDelete(this);\"/>");
        }
        
        return text;
    }
    
    public String toHTML2(int indent_)
    {
        String instance = (_instance == _INSTANCENAME) ? "Name" : "Definition";
        String text = _HTMLformat2;
        text = text.replace("{[NTITLE]}", (_instance == _INSTANCENAME) ? "Alternate Name" : "Alternate Definition");
        text = text.replace("{[INSTANCE]}", instance);
        text = text.replace("{[NAME]}", _name.trim().replaceAll("[\\n]", "<br/>"));
        text = text.replace("{[TYPE]}", _type.replaceAll(" ", "&nbsp;"));
        text = text.replace("{[LANG]}", _language.replaceAll(" ", "&nbsp;"));
        text = text.replace("{[CONTEXT]}", _conteName.trim().replaceAll(" ", "&nbsp;"));
        text = text.replace("{[MARGIN]}",String.valueOf(indent_));
        text = text.replace("{[NODELEVEL]}",String.valueOf(indent_));
        text = text.replace("{[NODEVALUE]}",_altIdseq);
        text = text.replace("{[CLASSTYPE]}", String.valueOf(_instance));
        if(_delete)
        {
            text = text.replace("{[DELFLAG]}", "line-through");
            text = text.replace("{[DELGLYPH]}", "<span class=\"restore\" title=\"Restore\" onclick=\"doRestore(this);\"/>&#81;</span>");
        }
        else
        {
            text = text.replace("{[DELFLAG]}", "none");
            text = text.replace("{[DELGLYPH]}", "<img src=\"Assets/delete.gif\" title=\"Delete\" onclick=\"doDelete(this);\"/>");
        }

        return text;
    }

    public void addCSI(TreeNode[] nodes_, int[] levels_) throws ToolException
    {
        _root.addHierarchy(nodes_, levels_);
    }
    
    private int _instance;
    private String _name;
    private String _type;
    private String _language;
    private String _altIdseq;
    private String _acIdseq;
    private String _conteIdseq;
    private String _conteName;
    private String _HTMLformat1;
    private String _HTMLformat2;
    private boolean _changed;
    private boolean _delete;
    private Tree _root;

    private static final String _defHTMLformat1 = "<tr " + TreeNode._nodeName + "=\"{[NAME]}\" " + TreeNode._nodeLevel + "=\"{[NODELEVEL]}\" " + TreeNode._nodeValue + "=\"{[NODEVALUE]}\">\n"
        + "<td class=\"alt0\" title=\"{[NTITLE]}\">"
            + "<table><tr>"
            + "<td class=\"alt9\"><img src=\"Assets/edit.gif\" title=\"Edit\" onclick=\"doEdit(this);\"/></td>"
            + "<td class=\"alt9\">{[DELGLYPH]}</td>"
            + "<td><span style=\"text-decoration: {[DELFLAG]}\"><b>{[NAME]}</b></span></td>"
            + "</tr></table></td>\n"
        + "<td class=\"alt1\" title=\"Context\"><b>{[CONTEXT]}</b></td>\n"
        + "<td class=\"alt1\" title=\"Alternate Type\"><b>{[TYPE]}</b></td>\n"
        + "<td class=\"alt1\" title=\"Language\"><b>{[LANG]}</b></td>\n"
        + "</tr>\n{[CSI]}";
    private static final String _defHTMLformat2 = "<tr " + TreeNode._nodeName + "=\"{[NAME]}\" " + TreeNode._nodeLevel + "=\"{[NODELEVEL]}\" " + TreeNode._nodeValue + "=\"{[NODEVALUE]}\">\n"
        + "<td class=\"ind{[MARGIN]}\" title=\"{[NTITLE]}\">"
            + "<table><tr>"
            + "<td class=\"alt9\"><img src=\"Assets/edit.gif\" title=\"Edit\" onclick=\"doEdit(this);\"/></td>"
            + "<td class=\"alt9\">{[DELGLYPH]}</td>"
            + "<td>{[INSTANCE]}:&nbsp;<span style=\"text-decoration: {[DELFLAG]}\">{[NAME]}</span></td>"
            + "</tr></table></td>\n"
        + "<td class=\"alt2\" title=\"Context\">{[CONTEXT]}</td>\n"
        + "<td class=\"alt2\" title=\"Alternate Type\">{[TYPE]}</td>\n"
        + "<td class=\"alt3\" title=\"Language\">{[LANG]}</td>\n"
        + "</tr>\n";
    public static final String _HTMLprefix = "<table>\n";
    public static final String _HTMLsuffix = "</table>\n";

    public static final int _MISSINGAC = -1;
    public static final int _MISSINGCONTE = -2;
    public static final int _MISSINGTYPE = -3;
    public static final int _MISSINGNAME = -4;
    public static final int _INSTANCENAME = 0;
    public static final int _INSTANCEDEF = 1;
    public static final String _INSTANCEDEFTITLE = "<tr><td colspan=\"4\"><p style=\"margin: 0.3in 0in 0in 0in\"><b>Definitions</b></p></td></tr>\n";
    public static final String _INSTANCENAMETITLE = "<tr><td colspan=\"4\"><p style=\"margin: 0.3in 0in 0in 0in\"><b>Names</b></p></td></tr>\n";
    public static final String _INSTANCEUNKTITLE = "<tr><td colspan=\"4\"><p style=\"margin: 0.3in 0in 0in 0in\"><b>UNKNOWN</b></p></td></tr>\n";
}
