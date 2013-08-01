/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.persist.exception;

import java.util.ArrayList;

@SuppressWarnings("unchecked")

public class ValidationException extends PersistException {
	
	

	public ValidationException(ArrayList errorList) {
		super(errorList);
	}
	
	public ValidationException(String message) {
		super(message);
	}

	public ValidationException(Throwable cause) {
		super(cause);
	}

	public ValidationException(String message, Throwable cause) {
		super(message, cause);
	}


	

}
