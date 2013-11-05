/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.cdecurate.dto;

import java.util.ArrayList;
import java.util.List;

public class ValueMeaningBean extends AdministeredComponentBean {
	private String manualDefinition;
	private String systemDefinition;
	private String changeNote;
	private List<ConceptBean> concepts = new ArrayList<ConceptBean>();
	private List<ConceptualDomainBean> conceptualDomains = new ArrayList<ConceptualDomainBean>();
	private String conceptCodes = "";
	private String reason;

	private String[] displayColumns = new String[] { "VM Long Name:",
			"VM Public ID Version: ", "VM Description/Definition:",
			"VM Concepts:" };

	public ValueMeaningBean(String longName, String publicId, String version,
			String workflowStatus, String conceptCodes, String manualDefinition) {
		super(longName, publicId, version, workflowStatus);
		this.conceptCodes = conceptCodes;
		this.manualDefinition = manualDefinition;
		// TODO Auto-generated constructor stub
	}

	public ValueMeaningBean(String longName, String publicId, String version,
			String manualDefinition) {
		this.setLongName(longName);
		this.setPublicId(publicId);
		this.setVersion(version);
		this.manualDefinition = manualDefinition;
	}

	public String getManualDefinition() {
		return manualDefinition;
	}

	public void setManualDefinition(String manualDefinition) {
		this.manualDefinition = manualDefinition;
	}

	public String getSystemDefinition() {
		return systemDefinition;
	}

	public void setSystemDefinition(String systemDefinition) {
		this.systemDefinition = systemDefinition;
	}

	public String getChangeNote() {
		return changeNote;
	}

	public void setChangeNote(String changeNote) {
		this.changeNote = changeNote;
	}

	public List<ConceptBean> getConcepts() {
		return concepts;
	}

	public void setConcepts(List<ConceptBean> concepts) {
		this.concepts = concepts;
	}

	public List<ConceptualDomainBean> getConceptualDomains() {
		return conceptualDomains;
	}

	public void setConceptualDomains(
			List<ConceptualDomainBean> conceptualDomains) {
		this.conceptualDomains = conceptualDomains;
	}

	public String[] getDisplayColumns() {
		return displayColumns;
	}

	public String getConceptCodes() {
		return conceptCodes;
	}

	public void setConceptCodes(String conceptCodes) {
		this.conceptCodes = conceptCodes;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}
}
