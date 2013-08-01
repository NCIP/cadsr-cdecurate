/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.tool;

/**
 * @author shegde
 *
 */
public class CommonACBean
{
  //common to most ACs
  private String idseq;
  private String publicID;
  private String longName;
  private String definition;
  private String version;
  private String context;
  private String workflowStatus;
  
  //non common attributes
  private String type;
  private String category;
  private String protoName;
  private String protoID;
  
  private String browserURL;
  /**
   * 
   */
  public CommonACBean()
  {
    super();
  }
  /**
   * @return Returns the browserURL.
   */
  public String getBrowserURL()
  {
    return browserURL;
  }
  /**
   * @param browserURL The browserURL to set.
   */
  public void setBrowserURL(String browserURL)
  {
    this.browserURL = browserURL + "search?dataElementDetails=9&p_de_idseq=" + this.getIdseq() + "&PageId=DataElementsGroup&queryDE=yes&FirstTimer=0";
  }
  /**
   * @return Returns the category.
   */
  public String getCategory()
  {
    return (category == null) ? "" : category;
  }
  /**
   * @param category The category to set.
   */
  public void setCategory(String category)
  {
    this.category = category;
  }
  /**
   * @return Returns the context.
   */
  public String getContext()
  {
    return (context == null) ? "" : context;
  }
  /**
   * @param context The context to set.
   */
  public void setContext(String context)
  {
    this.context = context;
  }
  /**
   * @return Returns the definition.
   */
  public String getDefinition()
  {
    return (definition == null) ? "" : definition;
  }
  /**
   * @param definition The definition to set.
   */
  public void setDefinition(String definition)
  {
    this.definition = definition;
  }
  /**
   * @return Returns the idseq.
   */
  public String getIdseq()
  {
    return (idseq == null) ? "" : idseq;
  }
  /**
   * @param idseq The idseq to set.
   */
  public void setIdseq(String idseq)
  {
    this.idseq = idseq;
  }
  /**
   * @return Returns the longName.
   */
  public String getLongName()
  {
    return (longName == null) ? "" : longName;
  }
  /**
   * @param longName The longName to set.
   */
  public void setLongName(String longName)
  {
    this.longName = longName;
  }
  /**
   * @return Returns the protoID.
   */
  public String getProtoID()
  {
    return (protoID == null) ? "" : protoID;
  }
  /**
   * @param protoID The protoID to set.
   */
  public void setProtoID(String protoID)
  {
    this.protoID = protoID;
  }
  /**
   * @return Returns the protoName.
   */
  public String getProtoName()
  {
    return (protoName == null) ? "" : protoName;
  }
  /**
   * @param protoName The protoName to set.
   */
  public void setProtoName(String protoName)
  {
    this.protoName = protoName;
  }
  /**
   * @return Returns the publicID.
   */
  public String getPublicID()
  {
    return (publicID == null) ? "" : publicID;
  }
  /**
   * @param publicID The publicID to set.
   */
  public void setPublicID(String publicID)
  {
    this.publicID = publicID;
  }
  /**
   * @return Returns the type.
   */
  public String getType()
  {
    return (type == null) ? "" : type;
  }
  /**
   * @param type The type to set.
   */
  public void setType(String type)
  {
    this.type = type;
  }
  /**
   * @return Returns the version.
   */
  public String getVersion()
  {
    return (version == null) ? "" : version;
  }
  /**
   * @param version The version to set.
   */
  public void setVersion(String version)
  {
    if (version != null && version.indexOf('.') < 0)
      version += ".0";
    this.version = version;
  }
  /**
   * @return Returns the workflowStatus.
   */
  public String getWorkflowStatus()
  {
    return (workflowStatus == null) ? "" : workflowStatus;
  }
  /**
   * @param workflowStatus The workflowStatus to set.
   */
  public void setWorkflowStatus(String workflowStatus)
  {
    this.workflowStatus = workflowStatus;
  }

//constant values
  public static final String COLUMN_LONG_NAME = "Long Name";
  public static final String COLUMN_PUBLIC_ID = "Public_ID";
  public static final String COLUMN_VERSION = "Version";
  public static final String COLUMN_STATUS = "Workflow Status";
  public static final String COLUMN_CONTEXT = "Context";
  public static final String COLUMN_TYPE = "Type";
  public static final String COLUMN_CATEGORY = "Category";
  public static final String COLUMN_PROTO_NAME = "Protocol Long Name";
  public static final String COLUMN_PROTO_ID = "Protocol ID";

  public String getACFieldValue(String curField) throws Exception
  {
      if (curField.equals(CommonACBean.COLUMN_LONG_NAME))
        return getLongName();
      else if (curField.equals(CommonACBean.COLUMN_PUBLIC_ID))
        return getPublicID();
      else if (curField.equals(CommonACBean.COLUMN_VERSION))
        return getVersion();
      else if (curField.equals(CommonACBean.COLUMN_STATUS))
        return getWorkflowStatus();
      else if (curField.equals(CommonACBean.COLUMN_CONTEXT))
        return getContext();
      else if (curField.equals(CommonACBean.COLUMN_TYPE))
        return getType();
      else if (curField.equals(CommonACBean.COLUMN_CATEGORY))
        return getCategory();
      else if (curField.equals(CommonACBean.COLUMN_PROTO_NAME))
        return getProtoName();
      else if (curField.equals(CommonACBean.COLUMN_PROTO_ID))
        return getProtoID();
      else
        return "";
  }
  
}
