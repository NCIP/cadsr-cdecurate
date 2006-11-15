// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/database/ACTypes.java,v 1.15 2006-11-15 04:59:29 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.database;

/**
 * This enum maps the types in the sbr.admin_componenets_view.actl_name column and other AC type
 * references and abbreviations. Update the values to reflect all possible Administered Component
 * types. The enums must match EXACTLY the value store in the database or the ACTypes.valueOf()
 * method will fail.
 * 
 * @author lhebel
 *
 */
public enum ACTypes
{
    CLASSIFICATION("Classification"),
    CONCEPT("Concept"),
    CONCEPTUALDOMAIN("Conceptual Domain"),
    DATAELEMENT("Data Element"),
    DE_CONCEPT("Data Element Concept"),
    OBJECTCLASS("Object Class"),
    OBJECTRECS("Object Recs"),
    PROPERTY("Property"),
    PROTOCOL("Protocol"),
    QUEST_CONTENT("Form/Template"),
    REPRESENTATION("Representation"),
    VALUEDOMAIN("Value Domain"),
    VALUEMEANING("Value Meaning"),
    ValueDomain("Value Domain"),
    DataElementConcept("Data Element Concept"),
    DataElement("Data Element"),
    ValueMeaning("Value Meaning"),
    UNKNOWN("UNKNOWN");
    
    private ACTypes(String name_)
    {
        _name = name_;
    }
    
    public String getName()
    {
        return _name;
    }
    
    private String _name;
}
