/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.persist.concept;

import gov.nih.nci.cadsr.persist.common.BaseVO;

public class ComponentConceptsVO extends BaseVO {
	private String cc_IDSEQ;
	private String condr_IDSEQ;
	private String con_IDSEQ;
	private int display_order;
	private String primary_flag_ind;
	private String concept_Value;
	
	public ComponentConceptsVO() {
		super();
	}
	/**
	 * @return the cc_IDSEQ
	 */
	public String getCc_IDSEQ() {
		return cc_IDSEQ;
	}
	/**
	 * @param cc_IDSEQ the cc_IDSEQ to set
	 */
	public void setCc_IDSEQ(String cc_IDSEQ) {
		this.cc_IDSEQ = cc_IDSEQ;
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
	 * @return the con_IDSEQ
	 */
	public String getCon_IDSEQ() {
		return con_IDSEQ;
	}
	/**
	 * @param con_IDSEQ the con_IDSEQ to set
	 */
	public void setCon_IDSEQ(String con_IDSEQ) {
		this.con_IDSEQ = con_IDSEQ;
	}
	/**
	 * @return the display_order
	 */
	public int getDisplay_order() {
		return display_order;
	}
	/**
	 * @param display_order the display_order to set
	 */
	public void setDisplay_order(int display_order) {
		this.display_order = display_order;
	}
	/**
	 * @return the primary_flag_ind
	 */
	public String getPrimary_flag_ind() {
		return primary_flag_ind;
	}
	/**
	 * @param primary_flag_ind the primary_flag_ind to set
	 */
	public void setPrimary_flag_ind(String primary_flag_ind) {
		this.primary_flag_ind = primary_flag_ind;
	}
	/**
	 * @return the concept_Value
	 */
	public String getConcept_Value() {
		return concept_Value;
	}
	/**
	 * @param concept_Value the concept_Value to set
	 */
	public void setConcept_Value(String concept_Value) {
		this.concept_Value = concept_Value;
	}
	

}
