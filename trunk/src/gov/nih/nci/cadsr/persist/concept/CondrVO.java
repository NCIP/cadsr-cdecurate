package gov.nih.nci.cadsr.persist.concept;

import gov.nih.nci.cadsr.persist.common.BaseVO;

public class CondrVO extends BaseVO {
	
	private String condr_IDSEQ;
	private String crtl_name;
	private String  name;
	
	public CondrVO() {
		super();
	}
	
	/**
	 * @return the condr_IDSEQ
	 */
	public String getCondr_IDSEQ() {
		return condr_IDSEQ;
	}
	/**
	 * @param condr_IDSEQ the condr_IDSEQ to set
	 */
	public void setCondr_IDSEQ(String condr_IDSEQ) {
		this.condr_IDSEQ = condr_IDSEQ;
	}
	/**
	 * @return the crtl_name
	 */
	public String getCrtl_name() {
		return crtl_name;
	}
	/**
	 * @param crtl_name the crtl_name to set
	 */
	public void setCrtl_name(String crtl_name) {
		this.crtl_name = crtl_name;
	}
	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}
	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}

}
