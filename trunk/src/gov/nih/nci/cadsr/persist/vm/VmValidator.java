package gov.nih.nci.cadsr.persist.vm;

import java.sql.Connection;

import gov.nih.nci.cadsr.persist.common.BaseValidator;
import gov.nih.nci.cadsr.persist.exception.DBException;
import gov.nih.nci.cadsr.persist.exception.ValidationException;
import gov.nih.nci.cadsr.persist.utils.Utils;
import gov.nih.nci.cadsr.persist.vm.VmValidationConstants;

@SuppressWarnings("unchecked")
public class VmValidator extends BaseValidator{
	
	/**
	 * This method checks if string parameters(short_meaning,
	 * description, comments) have correct length and 
	 * checks if character strings(short_meaning, description, 
	 * comments) are valid and also checks if end date is before begin date.
	
	 * @param vmVO
	 * @throws ValidationException
	 */
	public void validate(VmVO vmVO) throws ValidationException{
		
		// check if long_name has correct length
		if (vmVO.getLong_name() != null && !(this.validateStringFieldWithMaxLength(vmVO.getLong_name(), VmValidationConstants.VM_LONG_NAME_LENGTH))) {
			errorList.add(VmErrorCodes.API_VM_111);
		}
		// check if preferred_definition has correct length
		if (vmVO.getPrefferred_def() != null && !(this.validateStringFieldWithMaxLength(vmVO.getPrefferred_def(), VmValidationConstants.VM_PREFERRED_DEF_LENGTH))) {
			errorList.add(VmErrorCodes.API_VM_113);
		}
		// check if change_note has correct length
		if (vmVO.getChange_note() != null && !(this.validateStringFieldWithMaxLength(vmVO.getChange_note(), VmValidationConstants.VM_CHANGE_NOTE_LENGTH))) {
			errorList.add(VmErrorCodes.API_VM_114);
		}
		
		
		// check if long_name has valid characters
		if (vmVO.getLong_name() != null && !(this.validateCharacterStrings(vmVO.getLong_name()))) {
			errorList.add(VmErrorCodes.API_VM_130);
		}
		// check if preferred_definition has valid characters
		if (vmVO.getPrefferred_def() != null && !(this.validateCharacterStrings(vmVO.getPrefferred_def()))) {
			errorList.add(VmErrorCodes.API_VM_133);
		}
		// check if change_note has valid characters
		if (vmVO.getChange_note()  != null && !(this.validateCharacterStrings(vmVO.getChange_note() ))) {
			errorList.add(VmErrorCodes.API_VM_134);
		}
	
		// check if end date is before begin date
		if ((vmVO.getBegin_date() != null && vmVO.getEnd_date() != null && this.validateDates(vmVO.getEnd_date(), vmVO.getBegin_date()))) {
			errorList.add(VmErrorCodes.API_VM_210);
		}

		
		if (errorList != null && errorList.size() > 0) {
			Utils.logVm(errorList);
			throw new ValidationException(this.errorList);
		}
	}
	
	
	
	/**
	 * This method validates everything that is required to perform insert operation
	 *
	 * @param vmVO
	 * @param conn
	 * @throws ValidationException
	 * @throws DBException
	 */
	public void validateForInsert(VmVO vmVO, Connection conn) throws ValidationException{
		
		 //check id vm_IDSEQ is null. It should be null. For inserts, ID is generated
			if (vmVO.getVm_IDSEQ() != null){
				errorList.add(VmErrorCodes.API_VM_101);
			}
			this.validate(vmVO);
			if (errorList != null && errorList.size() > 0) {
				Utils.logVm(errorList);
				throw new ValidationException(this.errorList);
			}
	}
	
	/**
	 * This method validates everything  that is required to perform update 
	 * @param vmVO
	 * @param conn
	 * @throws ValidationException
	 */

	public void validateForUpdate(VmVO vmVO, Connection conn) throws ValidationException, DBException {
		
		Value_Meanings_Mgr vmMgr = new Value_Meanings_Mgr();
		
		// check if vmIDSEQ is null
		if (vmVO.getVm_IDSEQ() == null) {
			errorList.add(VmErrorCodes.API_VM_102);
			Utils.logVm(errorList);
			throw new ValidationException(this.errorList);
		}
		
		//check if VM already exists in the database
		if (!(vmMgr.isVmExists(vmVO.getVm_IDSEQ(), conn))) {
			errorList.add(VmErrorCodes.API_VM_005);
			Utils.logVm(errorList);
			throw new ValidationException(this.errorList);
		}
		
		this.validate(vmVO);
		
		//check if version equals to retrieved version. If retrieved version not equals to version
		//then throw exception since version cannot be updated
		if (vmVO.getVersion()>0) {
			double version = vmMgr.getVmVersionByIdseq(vmVO.getVm_IDSEQ(), conn);
			if (version != vmVO.getVersion()) {
				errorList.add(VmErrorCodes.API_VM_402);
				Utils.logVm(errorList);
				throw new ValidationException(this.errorList);
			}
		}
		
		if (errorList != null && errorList.size() > 0) {
			Utils.logVm(errorList);
			throw new ValidationException(this.errorList);
		}
		
	}
}


