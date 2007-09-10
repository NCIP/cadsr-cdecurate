// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/EVS_METACODE_Bean.java,v 1.47 2007-09-10 17:18:21 hebell Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.Serializable;

/**
 * @author shegde
 *
 */
public class EVS_METACODE_Bean implements Serializable
{
  /**
   * 
   */
  private static final long serialVersionUID = 1L;
  private String m_CODE_KEY;
  private String m_CODE_TYPE;
  private String m_CODE_FILTER;
  
  /**
   * Constructor
   */
   public EVS_METACODE_Bean() {
   };

   /**
    * The getMETACODE_KEY method returns abbreviated key value  for this bean.
    *
    * @return String The code key
    */
   public String getMETACODE_KEY()
   {
     return m_CODE_KEY;
   }

   /**
    * The setMETACODE_KEY method sets abbreviated key value for this bean.
    *
    * @param sKey The code key to set
    */
   public void setMETACODE_KEY(String sKey)
   {
     m_CODE_KEY = sKey;
   }

   /**
    * The getMETACODE_TYPE method returns abbreviated type value  for this bean.
    *
    * @return String The code type
    */
   public String getMETACODE_TYPE()
   {
     return m_CODE_TYPE;
   }

   /**
    * The setMETACODE_TYPE method sets abbreviated type value for this bean.
    *
    * @param sType The code type to set
    */
   public void setMETACODE_TYPE(String sType)
   {
     m_CODE_TYPE = sType;
   }

   /**
    * The getMETACODE_FILTER method returns abbreviated sFilter value  for this bean.
    *
    * @return String The code sFilter
    */
   public String getMETACODE_FILTER()
   {
     return m_CODE_FILTER;
   }

   /**
    * The setMETACODE_FILTER method sets abbreviated sFilter value for this bean.
    *
    * @param sFilter The code sFilter to set
    */
   public void setMETACODE_FILTER(String sFilter)
   {
     m_CODE_FILTER = sFilter;
   }
}
