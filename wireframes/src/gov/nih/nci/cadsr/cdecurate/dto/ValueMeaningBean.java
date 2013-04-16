package gov.nih.nci.cadsr.cdecurate.dto;

import java.util.List;

public class ValueMeaningBean {
	private String longName;
	private String publicId;
	private String version;
	private String workflowStatus;
	private String manualDefinition;
	private String systemDefinition;
	private String changeNote;
	private List<ConceptBean> concepts;

	public ValueMeaningBean(String longName, String publicId, String version,
			String manualDefinition) {
		this.longName = longName;
		this.publicId = publicId;
		this.version = version;
		this.manualDefinition = manualDefinition;
	}

	public String getLongName() {
		return longName;
	}

	public void setLongName(String longName) {
		this.longName = longName;
	}

	public String getPublicId() {
		return publicId;
	}

	public void setPublicId(String publicId) {
		this.publicId = publicId;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getWorkflowStatus() {
		return workflowStatus;
	}

	public void setWorkflowStatus(String workflowStatus) {
		this.workflowStatus = workflowStatus;
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

}
