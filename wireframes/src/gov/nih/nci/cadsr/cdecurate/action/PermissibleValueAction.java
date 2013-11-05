/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.cdecurate.action;

import com.opensymphony.xwork2.ActionSupport;

public class PermissibleValueAction extends ActionSupport {

	/**
	 * 	
	 */
	private static final long serialVersionUID = 2719019049463882884L;
	private String message;

	public String execute() throws Exception {
		return SUCCESS;
	}

	public String createNew() throws Exception {
		return SUCCESS;
	}

	public String createListFromParent() throws Exception {
		System.out.println("parent: " + SUCCESS);
		return SUCCESS;
	}

	public String createListFromConcepts() throws Exception {
		System.out.println(SUCCESS);
		return SUCCESS;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String addPv() throws Exception {
		return SUCCESS;
	}

	public String addPvFromParent() throws Exception {
		return SUCCESS;
	}

	public String editPv() throws Exception {
		return SUCCESS;
	}

	public String pvDetailsWithParent() throws Exception {
		return SUCCESS;
	}

	public String parentConceptListGrid() throws Exception {
		return SUCCESS;
	}

	public String editPvWithEditedVm() throws Exception {
		return SUCCESS;
	}
	
	public String searchConcepts() throws Exception {
		return SUCCESS;
	}
}