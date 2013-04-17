package gov.nih.nci.cadsr.cdecurate.dto;

public class ConceptBean {
	private String name;
	private String publicId;
	private String evsId;
	private String definition;
	private String definitionSource;
	private String workflowStatus;
	private String semanticType;
	private String context;
	private String vocabulary;
	private String caDSRComponent;
	private String type;
	private int order = 0;

	public ConceptBean(String evsId) {
		this.evsId = evsId;
	}

	public ConceptBean(String name, String evsId, String defintion,
			String type, String vocabulary) {
		this.name = name;
		this.evsId = evsId;
		this.definition = defintion;
		this.type = type;
		this.vocabulary = vocabulary;
	}

	public ConceptBean(String name, String evsId, String defintion,
			String type, String vocabulary, int order) {
		this.name = name;
		this.evsId = evsId;
		this.definition = defintion;
		this.type = type;
		this.vocabulary = vocabulary;
		this.order = order;
	}

	public ConceptBean(String name, String publicId, String evsId,
			String defintion, String definitionSource, String workflowStatus,
			String semanticType, String context, String vocabulary,
			String caDSRComponent) {
		super();
		this.name = name;
		this.publicId = publicId;
		this.evsId = evsId;
		this.definition = defintion;
		this.definitionSource = definitionSource;
		this.workflowStatus = workflowStatus;
		this.semanticType = semanticType;
		this.context = context;
		this.vocabulary = vocabulary;
		this.caDSRComponent = caDSRComponent;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPublicId() {
		return publicId;
	}

	public void setPublicId(String publicId) {
		this.publicId = publicId;
	}

	public String getEvsId() {
		return evsId;
	}

	public void setEvsId(String evsId) {
		this.evsId = evsId;
	}

	public String getDefinition() {
		return definition;
	}

	public void setDefinition(String definition) {
		this.definition = definition;
	}

	public String getDefinitionSource() {
		return definitionSource;
	}

	public void setDefinitionSource(String definitionSource) {
		this.definitionSource = definitionSource;
	}

	public String getWorkflowStatus() {
		return workflowStatus;
	}

	public void setWorkflowStatus(String workflowStatus) {
		this.workflowStatus = workflowStatus;
	}

	public String getSemanticType() {
		return semanticType;
	}

	public void setSemanticType(String semanticType) {
		this.semanticType = semanticType;
	}

	public String getContext() {
		return context;
	}

	public void setContext(String context) {
		this.context = context;
	}

	public String getVocabulary() {
		return vocabulary;
	}

	public void setVocabulary(String vocabulary) {
		this.vocabulary = vocabulary;
	}

	public String getCaDSRComponent() {
		return caDSRComponent;
	}

	public void setCaDSRComponent(String caDSRComponent) {
		this.caDSRComponent = caDSRComponent;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public int getOrder() {
		return order;
	}

	public void setOrder(int order) {
		this.order = order;
	}
}
