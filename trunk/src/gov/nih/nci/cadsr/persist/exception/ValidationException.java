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
