// Copyright (c) 2005 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/AC_ADDR_Bean.java,v 1.47 2007-09-10 17:18:20 hebell Exp $
// $Name: not supported by cvs2svn $


/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.Serializable;

/**
 * @author shegde
 *
 */
public class AC_ADDR_Bean implements Serializable
{
  private static final long serialVersionUID = 2003565784182626034L;

//Attributes
  private String RETURN_CODE;
  private String AC_ADDR_IDSEQ;
  private String ORG_IDSEQ;
  private String PERSON_IDSEQ;
  private String ATL_NAME;
  private String RANK_ORDER;
  private String ADDR_LINE1;
  private String ADDR_LINE2;
  private String CITY;
  private String STATE_PROV;
  private String POSTAL_CODE;
  private String COUNTRY;
  private String ADDR_SUBMIT_ACTION;
    

  /**
   * construct the bean
   */
  public AC_ADDR_Bean() {
  }

  /**
   * @param fBean to copy from
   * @return AC_ADDR_Bean
   */
  public AC_ADDR_Bean copyAddress(AC_ADDR_Bean fBean)
  {
    if (fBean != null)
    {
      this.setAC_ADDR_IDSEQ(fBean.getAC_ADDR_IDSEQ());
      this.setADDR_LINE1(fBean.getADDR_LINE1());
      this.setADDR_LINE2(fBean.getADDR_LINE2());
      this.setADDR_SUBMIT_ACTION(fBean.getADDR_SUBMIT_ACTION());
      this.setATL_NAME(fBean.getATL_NAME());
      this.setCITY(fBean.getCITY());
      this.setCOUNTRY(fBean.getCOUNTRY());
      this.setORG_IDSEQ(fBean.getORG_IDSEQ());
      this.setPERSON_IDSEQ(fBean.getPERSON_IDSEQ());
      this.setPOSTAL_CODE(fBean.getPOSTAL_CODE());
      this.setRANK_ORDER(fBean.getRANK_ORDER());
      this.setSTATE_PROV(fBean.getSTATE_PROV());
    }
    return this;
  }
  /**
   * @return Returns the aC_ADDR_IDSEQ.
   */
  public String getAC_ADDR_IDSEQ()
  {
    return AC_ADDR_IDSEQ;
  }


  /**
   * @param ac_addr_idseq The aC_ADDR_IDSEQ to set.
   */
  public void setAC_ADDR_IDSEQ(String ac_addr_idseq)
  {
    AC_ADDR_IDSEQ = ac_addr_idseq;
  }


  /**
   * @return Returns the aDDR_LINE1.
   */
  public String getADDR_LINE1()
  {
    return ADDR_LINE1;
  }


  /**
   * @param addr_line1 The aDDR_LINE1 to set.
   */
  public void setADDR_LINE1(String addr_line1)
  {
    ADDR_LINE1 = addr_line1;
  }


  /**
   * @return Returns the aDDR_LINE2.
   */
  public String getADDR_LINE2()
  {
    return ADDR_LINE2;
  }


  /**
   * @param addr_line2 The aDDR_LINE2 to set.
   */
  public void setADDR_LINE2(String addr_line2)
  {
    ADDR_LINE2 = addr_line2;
  }


  /**
   * @return Returns the aDDR_SUBMIT_ACTION.
   */
  public String getADDR_SUBMIT_ACTION()
  {
    return ADDR_SUBMIT_ACTION;
  }


  /**
   * @param addr_submit_action The aDDR_SUBMIT_ACTION to set.
   */
  public void setADDR_SUBMIT_ACTION(String addr_submit_action)
  {
    ADDR_SUBMIT_ACTION = addr_submit_action;
  }


  /**
   * @return Returns the aTL_NAME.
   */
  public String getATL_NAME()
  {
    return ATL_NAME;
  }


  /**
   * @param atl_name The aTL_NAME to set.
   */
  public void setATL_NAME(String atl_name)
  {
    ATL_NAME = atl_name;
  }


  /**
   * @return Returns the cITY.
   */
  public String getCITY()
  {
    return CITY;
  }


  /**
   * @param city The cITY to set.
   */
  public void setCITY(String city)
  {
    CITY = city;
  }


  /**
   * @return Returns the cOUNTRY.
   */
  public String getCOUNTRY()
  {
    return COUNTRY;
  }


  /**
   * @param country The cOUNTRY to set.
   */
  public void setCOUNTRY(String country)
  {
    COUNTRY = country;
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
   * @return Returns the pOSTAL_CODE.
   */
  public String getPOSTAL_CODE()
  {
    return POSTAL_CODE;
  }


  /**
   * @param postal_code The pOSTAL_CODE to set.
   */
  public void setPOSTAL_CODE(String postal_code)
  {
    POSTAL_CODE = postal_code;
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


  /**
   * @return Returns the sTATE_PROV.
   */
  public String getSTATE_PROV()
  {
    return STATE_PROV;
  }


  /**
   * @param state_prov The sTATE_PROV to set.
   */
  public void setSTATE_PROV(String state_prov)
  {
    STATE_PROV = state_prov;
  }

  
}
