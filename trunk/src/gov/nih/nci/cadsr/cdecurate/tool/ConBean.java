/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.tool;

/**
 * @author hveerla
 *
 */
public class ConBean {
	
	String con_IDSEQ;
	String concept_value;
	int display_order;
		
	public ConBean() {
		super();
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
	 * @return the concept_value
	 */
	public String getConcept_value() {
		return concept_value;
	}
	/**
	 * @param concept_value the concept_value to set
	 */
	public void setConcept_value(String concept_value) {
		this.concept_value = concept_value;
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

}
