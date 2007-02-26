/**
 * 
 */
package com.scenpro.NCICuration;

import java.io.Serializable;

/**
 * @author shegde
 *
 */
public class AC_COMM_Bean implements Serializable
{
  private static final long serialVersionUID = 4616445221743290168L;
//Attributes
  private String RETURN_CODE;
  private String AC_COMM_IDSEQ;
  private String ORG_IDSEQ;
  private String PERSON_IDSEQ;
  private String CTL_NAME;
  private String RANK_ORDER;
  private String CYBER_ADDR;
  private String COMM_SUBMIT_ACTION;
    
  public AC_COMM_Bean() {
  }

  /**
   * @return Returns the aC_COMM_IDSEQ.
   */
  public String getAC_COMM_IDSEQ()
  {
    return AC_COMM_IDSEQ;
  }

  /**
   * @param ac_comm_idseq The aC_COMM_IDSEQ to set.
   */
  public void setAC_COMM_IDSEQ(String ac_comm_idseq)
  {
    AC_COMM_IDSEQ = ac_comm_idseq;
  }

  /**
   * @return Returns the COMM_SUBMIT_ACTION.
   */
  public String getCOMM_SUBMIT_ACTION()
  {
    return COMM_SUBMIT_ACTION;
  }

  /**
   * @param COMM_submit_action The COMM_SUBMIT_ACTION to set.
   */
  public void setCOMM_SUBMIT_ACTION(String COMM_submit_action)
  {
    COMM_SUBMIT_ACTION = COMM_submit_action;
  }

  /**
   * @return Returns the cTL_NAME.
   */
  public String getCTL_NAME()
  {
    return CTL_NAME;
  }

  /**
   * @param ctl_name The cTL_NAME to set.
   */
  public void setCTL_NAME(String ctl_name)
  {
    CTL_NAME = ctl_name;
  }

  /**
   * @return Returns the cYBER_ADDR.
   */
  public String getCYBER_ADDR()
  {
    return CYBER_ADDR;
  }

  /**
   * @param cyber_addr The cYBER_ADDR to set.
   */
  public void setCYBER_ADDR(String cyber_addr)
  {
    CYBER_ADDR = cyber_addr;
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
   * @return Returns the rETURN_CODE.
   */
  public String getRETURN_CODE()
  {
    return RETURN_CODE;
  }

  /**
   * @param return_code The rETURN_CODE to set.
   */
  public void setRETURN_CODE(String return_code)
  {
    RETURN_CODE = return_code;
  }
  

  
}
