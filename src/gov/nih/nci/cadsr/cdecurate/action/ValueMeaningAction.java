package gov.nih.nci.cadsr.cdecurate.action;

import com.opensymphony.xwork2.ActionSupport;

public class ValueMeaningAction extends ActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 7903293839636154286L;

	private String message;
	private String searchBy;

	public String getSearchBy() {
		return searchBy;
	}

	public void setSearchBy(String searchBy) {
		this.searchBy = searchBy;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String execute() {
		message = "this page contains the value meaning information.";
		return SUCCESS;
	}

	public String vmDetails() throws Exception {
		return SUCCESS;
	}

	public String editVm() throws Exception {
		return SUCCESS;
	}

	public String searchExistingVm() throws Exception {
		return SUCCESS;
	}

	public String searchEVSConcept() throws Exception {
		return SUCCESS;
	}

	public String searchExistingVmEditPv() throws Exception {
		return SUCCESS;
	}

	public String searchEVSConceptEditPv() throws Exception {
		return SUCCESS;
	}

	public String searchEVSConceptEditVm() throws Exception {
		return SUCCESS;
	}

	public String selectedVmResult() throws Exception {
		return SUCCESS;
	}

	public String selectedVmResultEditPv() throws Exception {
		return SUCCESS;
	}

	public String createNewVm() throws Exception {
		return SUCCESS;
	}

	public String conceptualDomainsVm() throws Exception {
		return SUCCESS;
	}

	public String editedVm() throws Exception {
		return SUCCESS;
	}

}
