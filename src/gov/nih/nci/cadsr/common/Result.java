package gov.nih.nci.cadsr.common;

import java.io.Serializable;

public class Result implements Serializable {

	private ResultCode resultCode;
	private String alternateMessage;   // (null if no alternate message)
	
	public Result(ResultCode resultCode, String alternateMessage) {
		this.resultCode = resultCode;
		this.alternateMessage = alternateMessage;
	}
	
	public Result(ResultCode resultCode) {
		this.resultCode = resultCode;
		alternateMessage = null;
	}
	
	public Result() {
		this.resultCode = ResultCode.NONE;
		alternateMessage = null;
	}

	public ResultCode getResultCode() {
		return resultCode;
	}

	public String getMessage() {
		if (alternateMessage != null)
			return alternateMessage;
		else
			return resultCode.userMessage();
	}
}
