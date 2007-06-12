// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/ValidateBean.java,v 1.9 2007-06-12 20:26:18 hegdes Exp $
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
