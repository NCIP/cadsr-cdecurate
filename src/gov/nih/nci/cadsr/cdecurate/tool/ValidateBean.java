/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/ValidateBean.java,v 1.10 2007-09-10 17:18:21 hebell Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.Serializable;

/**
 * @author shegde
 *
 */
public class ValidateBean implements Serializable
{
  private String ACAttribute;
  private String AttributeContent;
  private String AttributeStatus;
  
  /**
   * 
   */
  public ValidateBean()
  {
  }

  /**
   * @return Returns the aCAttribute.
   */
  public String getACAttribute()
  {
    return (ACAttribute == null) ? "" : ACAttribute;
  }

  /**
   * @param attribute The aCAttribute to set.
   */
  public void setACAttribute(String attribute)
  {
    ACAttribute = attribute;
  }

  /**
   * @return Returns the attributeContent.
   */
  public String getAttributeContent()
  {
    return (AttributeContent == null) ? "" : AttributeContent;
  }

  /**
   * @param attributeContent The attributeContent to set.
   */
  public void setAttributeContent(String attributeContent)
  {
    AttributeContent = attributeContent;
  }

  /**
   * @return Returns the attributeStatus.
   */
  public String getAttributeStatus()
  {
    return (AttributeStatus == null) ? "" : AttributeStatus;
  }

  /**
   * @param attributeStatus The attributeStatus to set.
   */
  public void setAttributeStatus(String attributeStatus)
  {
    AttributeStatus = attributeStatus;
  }

}
