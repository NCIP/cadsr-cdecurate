package gov.nih.nci.cadsr.persist.exception;

import gov.nih.nci.cadsr.persist.de.DeErrorCodes;

import java.util.ArrayList;

@SuppressWarnings("unchecked")
public class PersistException extends Throwable {
	
	private ArrayList<DeErrorCodes> errorList;
	
	
	/**
	 * @return the errorList
	 */
	public ArrayList getErrorList() {
		return errorList;
	}
	
	public PersistException() {
		super();
	}
	
	public PersistException(ArrayList<DeErrorCodes> errorList) {
		super();
		this.errorList = errorList;
	}

	public void addErrorCode(DeErrorCodes error) {
		if(this.errorList == null) {
			this.errorList = new ArrayList<DeErrorCodes>();
		}
		this.errorList.add(error);
	}
	public PersistException(String message) {
		super(message);
	}

	public PersistException(Throwable cause) {
		super(cause);
	}

	public PersistException(String message, Throwable cause) {
		super(message, cause);
	}
}
