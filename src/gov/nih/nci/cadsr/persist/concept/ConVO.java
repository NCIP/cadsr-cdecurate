/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

/**
 * 
 */
package gov.nih.nci.cadsr.persist.concept;

/**
 * @author hveerla
 *
 */
public class ConVO {
	String conIDSEQ;
	String concept_value;
	
	
	public ConVO(){
		
	}
	/**
	 * @return the conIDSEQ
	 */
	public String getConIDSEQ() {
		return conIDSEQ;
	}
	/**
	 * @param conIDSEQ the conIDSEQ to set
	 */
	public void setConIDSEQ(String conIDSEQ) {
		this.conIDSEQ = conIDSEQ;
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

}
