package gov.nih.nci.cadsr.cdecurate.dto;

public class ConceptualDomainBean extends AdministeredComponentBean {
	private String context;

	public ConceptualDomainBean(String longName, String publicId,
			String version, String workflowStatus, String context) {
		super(longName, publicId, version, workflowStatus);
		this.context = context;
		// TODO Auto-generated constructor stub
	}

	public String getContext() {
		return context;
	}

	public void setContext(String context) {
		this.context = context;
	}

}
