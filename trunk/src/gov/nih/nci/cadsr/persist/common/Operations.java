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
