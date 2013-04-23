package gov.nih.nci.cadsr.persist.de;


public enum DeErrorCodes {
	API_DE_000("Generic Error"),
	API_DE_001("Invalid Input Object"),
	API_DE_002("Connection object is null"),
	
	API_DE_100("For insert, ID is generated"), 
	API_DE_101("Preferred Name is required"),
	API_DE_102("Contex_IDSEQ is required"),
	API_DE_103("Preferred Definition is required"),
	API_DE_104("Vd_IDSEQ is required"),
	API_DE_105("Version_Indicator can only be 'Yes' or 'No'"),
	API_DE_106("Dec_IDSEQ is required"),
	
	API_DE_111("Length of Preferred Name exceeds the maximum length of 30"),
	API_DE_113("Length of Preferred Definition exceeds the maximum length of 2000"),
	API_DE_114("Length of Long Name exceeds the maximum length of 255"),
	API_DE_115("Length of Asl Name exceeds the maximum length of 20"),
	API_DE_128("Change_note exceeds the maximum length of 2000"),
	
	API_DE_130("Preferred Name has invalid characters"),
	API_DE_133("Preferred Definition has invalid characters"),
	API_DE_134("Long Name has invalid characters"),
	
	API_DE_210("End date is before Begin date"),
	API_DE_211("Begin date cannot be null when End date is null"),
		
	API_DE_400("DE_IDSEQ is required"),
	API_DE_401("Preferred Name and Context cannot be updated since work-flow status is Released"),
	API_DE_402("Version can NOT be updated. It can only be created"),
	API_DE_005("Data Element does not exist in the database"),
		
	API_DE_300("Data Element already Exists"),
	
	API_DE_500("Error insering the Data Element"),
	API_DE_501("Error updating the Data Element"),
	API_DE_502("Error deleting the Data Element"),
	API_DE_503("Error updating latest_version_indicator"),
	API_DE_504("Error creating History"),
	
	API_DE_700("Invalid Action"),
	ERROR("Could not complete the requested operation");
		
	
   
	DeErrorCodes(String errorMessage){
		this.errorMessage = errorMessage;
	}
	public String getErrorMessage(){
		return errorMessage;
		
	}
	private String errorMessage;
}
