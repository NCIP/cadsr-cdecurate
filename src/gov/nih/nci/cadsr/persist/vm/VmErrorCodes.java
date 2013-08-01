/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.persist.vm;

public enum VmErrorCodes{

	API_VM_000("Generic Error"),
	API_VM_002("Connection object is null"),
	API_VM_0011("Invalid Input Object"),
	
	API_VM_700("Invalid Action"),
	API_VM_701("Null Action"),
	API_VM_101("For Inserts, ID is generated"),
	API_VM_102("VM_IDSEQ is required"),
	API_VM_005("VM not found"),
	
	API_VM_001("Short_Meaning must be provided"),
	
	API_VM_105("VM not found based VM_IDSEQ"),
	//API_VM_001("VM not found based on Long_name"),
	API_VM_205("VM not found based on VM_ID , Version"),
	
	API_VM_111("Length of Short_Meaning(Long_Name) exceeds maximum length of 255"),
	API_VM_113("Length of Description(preferred_Definition) exceeds maximum length of 2000"),
	API_VM_114("Length of Comments(Change_Note) exceeds maximum length of 2000"),
	
	API_VM_130("Value Meaning Short Meaning(Long_Name) has invalid characters"),
	API_VM_133("Value Meaning Description(preferred_Definition) has invalid characters"),
	API_VM_134("Value Meaning Comments(Change_Note) has invalid characters"),
	API_VM_600("Begin Date is invalid"),
	API_VM_601("End Date is invalid"),
	API_VM_210("End date is before Begin date"),
	API_VM_402("Version can NOT be updated. It can only be created"),
	
	API_VM_500("Error inserting Value Meaning"),
	API_VM_501("Error updating value meaning");
	
	VmErrorCodes(String errorMessage){
		this.errorMessage = errorMessage;
	}
	public String getErrorMessage(){
		return errorMessage;
		
	}
	private String errorMessage;

}
