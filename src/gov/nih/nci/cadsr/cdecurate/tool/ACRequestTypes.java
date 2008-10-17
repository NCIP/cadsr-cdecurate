package gov.nih.nci.cadsr.cdecurate.tool;

public enum ACRequestTypes {
	
	//DE Requests
	DataElement("gov.nih.nci.cadsr.cdecurate.tool.DataElementServlet"),
	newDEFromMenu("gov.nih.nci.cadsr.cdecurate.tool.DataElementServlet"),
	newDEfromForm("gov.nih.nci.cadsr.cdecurate.tool.DataElementServlet"),
	editDE("gov.nih.nci.cadsr.cdecurate.tool.DataElementServlet"),
	validateDEFromForm("gov.nih.nci.cadsr.cdecurate.tool.DataElementServlet"),
	getDDEDetails("gov.nih.nci.cadsr.cdecurate.tool.DataElementServlet"),
	
	//DEC Requests
	DataElementConcept("gov.nih.nci.cadsr.cdecurate.tool.DataElementConceptServlet"),
	newDECFromMenu("gov.nih.nci.cadsr.cdecurate.tool.DataElementConceptServlet"),
	newDECfromForm("gov.nih.nci.cadsr.cdecurate.tool.DataElementConceptServlet"),
	editDEC("gov.nih.nci.cadsr.cdecurate.tool.DataElementConceptServlet"),
	createNewDEC("gov.nih.nci.cadsr.cdecurate.tool.DataElementConceptServlet"),
	validateDECFromForm("gov.nih.nci.cadsr.cdecurate.tool.DataElementConceptServlet"),
	
	//VD Requests
	ValueDomain("gov.nih.nci.cadsr.cdecurate.tool.ValueDomainServlet"),
	newVDFromMenu("gov.nih.nci.cadsr.cdecurate.tool.ValueDomainServlet"),
	newVDfromForm("gov.nih.nci.cadsr.cdecurate.tool.ValueDomainServlet"),
	editVD("gov.nih.nci.cadsr.cdecurate.tool.ValueDomainServlet"),
	createNewVD("gov.nih.nci.cadsr.cdecurate.tool.ValueDomainServlet"),
	validateVDFromForm("gov.nih.nci.cadsr.cdecurate.tool.ValueDomainServlet"),

	//search Requests
	homePage("gov.nih.nci.cadsr.cdecurate.tool.SearchServlet"),
	Search("gov.nih.nci.cadsr.cdecurate.tool.SearchServlet"),
	searchACs("gov.nih.nci.cadsr.cdecurate.tool.SearchServlet"),
	showResult("gov.nih.nci.cadsr.cdecurate.tool.SearchServlet"),
	showBEDisplayResult("gov.nih.nci.cadsr.cdecurate.tool.SearchServlet"),
	showDECDetail("gov.nih.nci.cadsr.cdecurate.tool.SearchServlet"),
	doSortBlocks("gov.nih.nci.cadsr.cdecurate.tool.SearchServlet"),
	getSearchFilter("gov.nih.nci.cadsr.cdecurate.tool.SearchServlet"),
	doSortCDE("gov.nih.nci.cadsr.cdecurate.tool.SearchServlet"),
	searchBlocks("gov.nih.nci.cadsr.cdecurate.tool.SearchServlet"),
	actionFromMenu("gov.nih.nci.cadsr.cdecurate.tool.SearchServlet");

	private String className;

	private ACRequestTypes(String sType) {
		className = sType;
	}
	
	public String getClassName() {
		return className;
	}
}
