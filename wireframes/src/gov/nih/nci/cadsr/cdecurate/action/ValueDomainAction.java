/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.cdecurate.action;

import com.opensymphony.xwork2.ActionSupport;

public class ValueDomainAction extends ActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 8465983311827826779L;
	private String message;

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String execute() {
		message="this page contains the value domain information.";
		return SUCCESS;
	}
}
