/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.Serializable;
import java.util.Vector;

/**
 * @author shegde
 *
 */
public class AC_CONTACT_Bean implements Serializable
{

  private static final long serialVersionUID = -6843359664552627140L;

//Attributes
  private String RETURN_CODE;
  private String AC_CONTACT_IDSEQ;
  private String ORG_IDSEQ;
  private String ORG_NAME;
  private String PERSON_IDSEQ;
  private String PERSON_NAME;
  private String AC_IDSEQ;
  private String AC_LONG_NAME;
  private String RANK_ORDER;
  private String CONTACT_ROLE;
  private String CS_CSI_IDSEQ;
  private String CS_IDSEQ;
  private String ACC_SUBMIT_ACTION;
  private Vector ACC_COMM_List;
  private Vector ACC_ADDR_List;
  

  /**
   * construct the bean
   */
  public AC_CONTACT_Bean()  {
  }

  /**
   * @return Returns the RETURN_CODE.
   */
  public String getRETURN_CODE()
  {
    return RETURN_CODE;
  }

  /**
   * @param return_code The RETURN_CODE to set.
   */
  public void setRETURN_CODE(String return_code)
  {
    RETURN_CODE = return_code;
  }

  /**
   * @return Returns the aC_CONTACT_IDSEQ.
   */
  public String getAC_CONTACT_IDSEQ()
  {
    return AC_CONTACT_IDSEQ;
  }

  /**
   * @param ac_contact_idseq The aC_CONTACT_IDSEQ to set.
   */
  public void setAC_CONTACT_IDSEQ(String ac_contact_idseq)
  {
    AC_CONTACT_IDSEQ = ac_contact_idseq;
  }

  /**
   * @return Returns the aC_IDSEQ.
   */
  public String getAC_IDSEQ()
  {
    return AC_IDSEQ;
  }

  /**
   * @param ac_idseq The aC_IDSEQ to set.
   */
  public void setAC_IDSEQ(String ac_idseq)
  {
    AC_IDSEQ = ac_idseq;
  }

  /**
   * @return Returns the aC_LONG_NAME.
   */
  public String getAC_LONG_NAME()
  {
    return AC_LONG_NAME;
  }

  /**
   * @param ac_long_name The aC_LONG_NAME to set.
   */
  public void setAC_LONG_NAME(String ac_long_name)
  {
    AC_LONG_NAME = ac_long_name;
  }

  /**
   * @return Returns the ACC_SUBMIT_ACTION.
   */
  public String getACC_SUBMIT_ACTION()
  {
    return ACC_SUBMIT_ACTION;
  }

  /**
   * @param acc_submit_action The ACC_SUBMIT_ACTION to set.
   */
  public void setACC_SUBMIT_ACTION(String acc_submit_action)
  {
    ACC_SUBMIT_ACTION = acc_submit_action;
  }

  /**
   * @return Returns the cONTACT_ROLE.
   */
  public String getCONTACT_ROLE()
  {
    return CONTACT_ROLE;
  }

  /**
   * @param contact_role The cONTACT_ROLE to set.
   */
  public void setCONTACT_ROLE(String contact_role)
  {
    CONTACT_ROLE = contact_role;
  }

  /**
   * @return Returns the cS_CSI_IDSEQ.
   */
  public String getCS_CSI_IDSEQ()
  {
    return CS_CSI_IDSEQ;
  }

  /**
   * @param cs_csi_idseq The cS_CSI_IDSEQ to set.
   */
  public void setCS_CSI_IDSEQ(String cs_csi_idseq)
  {
    CS_CSI_IDSEQ = cs_csi_idseq;
  }

  /**
   * @return Returns the cS_IDSEQ.
   */
  public String getCS_IDSEQ()
  {
    return CS_IDSEQ;
  }

  /**
   * @param cs_idseq The cS_IDSEQ to set.
   */
  public void setCS_IDSEQ(String cs_idseq)
  {
    CS_IDSEQ = cs_idseq;
  }

  /**
   * @return Returns the oRG_IDSEQ.
   */
  public String getORG_IDSEQ()
  {
    return ORG_IDSEQ;
  }

  /**
   * @param org_idseq The oRG_IDSEQ to set.
   */
  public void setORG_IDSEQ(String org_idseq)
  {
    ORG_IDSEQ = org_idseq;
  }

  /**
   * @return Returns the oRG_NAME.
   */
  public String getORG_NAME()
  {
    return ORG_NAME;
  }

  /**
   * @param org_name The oRG_NAME to set.
   */
  public void setORG_NAME(String org_name)
  {
    ORG_NAME = org_name;
  }

  /**
   * @return Returns the pERSON_IDSEQ.
   */
  public String getPERSON_IDSEQ()
  {
    return PERSON_IDSEQ;
  }

  /**
   * @param person_idseq The pERSON_IDSEQ to set.
   */
  public void setPERSON_IDSEQ(String person_idseq)
  {
    PERSON_IDSEQ = person_idseq;
  }

  /**
   * @return Returns the pERSON_NAME.
   */
  public String getPERSON_NAME()
  {
    return PERSON_NAME;
  }

  /**
   * @param person_name The pERSON_NAME to set.
   */
  public void setPERSON_NAME(String person_name)
  {
    PERSON_NAME = person_name;
  }

  /**
   * @return Returns the rANK_ORDER.
   */
  public String getRANK_ORDER()
  {
    return RANK_ORDER;
  }

  /**
   * @param rank_order The rANK_ORDER to set.
   */
  public void setRANK_ORDER(String rank_order)
  {
    RANK_ORDER = rank_order;
  }

  /**
   * @return Returns the aCC_ADDR_List.
   */
  public Vector getACC_ADDR_List()
  {
    return ACC_ADDR_List;
  }

  /**
   * @param list The aCC_ADDR_List to set.
   */
  public void setACC_ADDR_List(Vector list)
  {
    ACC_ADDR_List = list;
  }

  /**
   * @return Returns the aCC_COMM_List.
   */
  public Vector getACC_COMM_List()
  {
    return ACC_COMM_List;
  }

  /**
   * @param list The aCC_COMM_List to set.
   */
  public void setACC_COMM_List(Vector list)
  {
    ACC_COMM_List = list;
  }
  
}
