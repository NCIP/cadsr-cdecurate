/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.persist.exception;



import java.util.ArrayList;


@SuppressWarnings("unchecked")
public class DBException extends PersistException {
	
	public static final String DEFAULT_ERROR_MSG = "Error in executing SQL statement";


	public DBException(ArrayList errorList) {
		super(errorList);
	}

	public DBException(String message) {
		super(message);
	}

	public DBException(Throwable cause) {
		super(cause);
	}

	public DBException(String message, Throwable cause) {
		super(message, cause);
	}

}
