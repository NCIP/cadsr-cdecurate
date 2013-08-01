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
 * @author hveerla
 *
 */
public class ValidationStatusBean {
	String statusMessage = "";
	boolean condrExists = false;
	boolean evsBeanExists = false;
	String condrIDSEQ = "";
	String evsBeanIDSEQ = "";
	boolean newVersion = false;
	boolean allConceptsExists = false;
	
	public ValidationStatusBean(){
	}
	/**
	 * @return the statusMessage
	 */
	public String getStatusMessage() {
		return statusMessage;
	}
	/**
	 * @param statusMessage the statusMessage to set
	 */
	public void setStatusMessage(String statusMessage) {
		this.statusMessage = statusMessage;
	}
	/**
	 * @return the condrExists
	 */
	public boolean isCondrExists() {
		return condrExists;
	}
	/**
	 * @param condrExists the condrExists to set
	 */
	public void setCondrExists(boolean condrExists) {
		this.condrExists = condrExists;
	}
	/**
	 * @return the evsBeanExists
	 */
	public boolean isEvsBeanExists() {
		return evsBeanExists;
	}
	/**
	 * @param evsBeanExists the evsBeanExists to set
	 */
	public void setEvsBeanExists(boolean evsBeanExists) {
		this.evsBeanExists = evsBeanExists;
	}
	/**
	 * @return the condrIDSEQ
	 */
	public String getCondrIDSEQ() {
		return condrIDSEQ;
	}
	/**
	 * @param condrIDSEQ the condrIDSEQ to set
	 */
	public void setCondrIDSEQ(String condrIDSEQ) {
		this.condrIDSEQ = condrIDSEQ;
	}
	/**
	 * @return the evsBeanIDSEQ
	 */
	public String getEvsBeanIDSEQ() {
		return evsBeanIDSEQ;
	}
	/**
	 * @param evsBeanIDSEQ the evsBeanIDSEQ to set
	 */
	public void setEvsBeanIDSEQ(String evsBeanIDSEQ) {
		this.evsBeanIDSEQ = evsBeanIDSEQ;
	}
	/**
	 * @return the newVersion
	 */
	public boolean isNewVersion() {
		return newVersion;
	}
	/**
	 * @param newVersion the newVersion to set
	 */
	public void setNewVersion(boolean newVersion) {
		this.newVersion = newVersion;
	}
	/**
	 * @return the allConceptsExists
	 */
	public boolean isAllConceptsExists() {
		return allConceptsExists;
	}
	/**
	 * @param allConceptsExists the allConceptsExists to set
	 */
	public void setAllConceptsExists(boolean allConceptsExists) {
		this.allConceptsExists = allConceptsExists;
	}
	

}
