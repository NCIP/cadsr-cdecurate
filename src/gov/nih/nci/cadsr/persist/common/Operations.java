/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.persist.common;

public enum Operations {
	INSERT("INS"),
	UPDATE("UPD"),
	DELETE("DEL");
	
	Operations(String operation){
		this.operation = operation;
	}
	public String getOperation(){
		return operation;
		
	}
	private String operation;
	

}
