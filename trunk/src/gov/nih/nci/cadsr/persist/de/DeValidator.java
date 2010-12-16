package gov.nih.nci.cadsr.persist.de;

import java.sql.Connection;

import gov.nih.nci.cadsr.persist.ac.Admin_Components_Mgr;
import gov.nih.nci.cadsr.persist.common.BaseValidator;
import gov.nih.nci.cadsr.persist.common.DBConstants;
import gov.nih.nci.cadsr.persist.exception.DBException;
import gov.nih.nci.cadsr.persist.exception.ValidationException;
import gov.nih.nci.cadsr.persist.utils.Utils;

@SuppressWarnings("unchecked")
public class DeValidator extends BaseValidator {

	/**
	 * This method checks if string parameters(preferred_name,
	 * preferred_definiton, long_name, asl_name, change_note) have correct
	 * length and checks if character strings(preferred_name,
	 * preferred_definition,long_name) are valid and also checks if begin and
	 * end dates are valid dates and end date is before begin date.
	 * 
	 * @param deVO
	 * @throws ValidationException
	 */
	public void validate(DeVO deVO) throws ValidationException {

		// version_indicator can only be yes or no
		if (deVO.getLastest_version_ind() != null) {
			if ((!deVO.getLastest_version_ind().equals(DBConstants.LATEST_VERSION_IND_YES))&&(!deVO.getLastest_version_ind().equals(DBConstants.LATEST_VERSION_IND_NO))) {
				errorList.add(DeErrorCodes.API_DE_005);
			}
		}
		// check if preferred name has correct length
		if (deVO.getPrefferred_name() != null && !(this.validateStringFieldWithMaxLength(deVO.getPrefferred_name(), DeValidationConstants.DE_PREFERRED_NAME_LENGTH))) {
			errorList.add(DeErrorCodes.API_DE_111);
		}
		// check if preferred definition has correct length
		if (deVO.getPrefferred_def() != null && !(this.validateStringFieldWithMaxLength(deVO.getPrefferred_def(), DeValidationConstants.DE_PREFERRED_DEF_LENGTH))) {
			errorList.add(DeErrorCodes.API_DE_113);
		}
		// check if long name has correct length
		if (deVO.getLong_name() != null	&& !(this.validateStringFieldWithMaxLength(deVO.getLong_name(),	DeValidationConstants.DE_LONG_NAME_LENGTH))) {
			errorList.add(DeErrorCodes.API_DE_114);
		}
		// check if asl name(work flow status) has correct length
		if (deVO.getAsl_name() != null && !(this.validateStringFieldWithMaxLength(deVO.getAsl_name(), DeValidationConstants.DE_ASL_NAME_LENGTH))) {
			errorList.add(DeErrorCodes.API_DE_115);
		}
		// check if change note has correct length
		if (deVO.getChange_note() != null && !(this.validateStringFieldWithMaxLength(deVO.getChange_note(),	DeValidationConstants.DE_CHANGE_NOTE_LENGTH))) {
			errorList.add(DeErrorCodes.API_DE_128);
		}

		// check if preferred name has valid characters
		if (deVO.getPrefferred_name() != null && !(this.validateCharacterStrings(deVO.getPrefferred_name()))) {
			errorList.add(DeErrorCodes.API_DE_130);
		}
		// check if preferred definition has valid characters
		if (deVO.getPrefferred_def() != null && !(this.validateCharacterStrings(deVO.getPrefferred_def()))) {
			errorList.add(DeErrorCodes.API_DE_133);
		}
		// check if long name has valid characters
		if (deVO.getLong_name() != null	&& !(this.validateCharacterStrings(deVO.getLong_name()))) {
			errorList.add(DeErrorCodes.API_DE_134);
		}

		// check whether begin date is null if end date is null
		// Begin date cannot be null when end date is null
		if (deVO.getEnd_date() == null) {
			if (deVO.getBegin_date() == null) {
				errorList.add(DeErrorCodes.API_DE_211);
			}
		}
		// check if end date is before begin date
		if ((deVO.getBegin_date() != null && deVO.getEnd_date() != null && this.validateDates(deVO.getEnd_date(), deVO.getBegin_date()))) {
			errorList.add(DeErrorCodes.API_DE_210);
		}

		if (errorList != null && errorList.size() > 0) {
			Utils.logDe(errorList);
			throw new ValidationException(this.errorList);
		}
	}

	/**
	 * This method validates everything that is required to perform insert
	 * operation
	 * 
	 * @param deVO
	 * @param conn
	 * @throws ValidationException
	 * @throws DBException
	 */
	public void validateForInsert(DeVO deVO, Connection conn) throws ValidationException, DBException {

		Admin_Components_Mgr acMgr = new Admin_Components_Mgr();

		// check id de_IDSEQ is null. It should be null. For inserts, ID is
		// generated
		if (deVO.getDe_IDSEQ() != null) {
			errorList.add(DeErrorCodes.API_DE_100);
		}

		// check if preferred_name, contex_idseq,
		// preferred_Definiton,vd_idseq,dec_idseq is null
		if (deVO.getPrefferred_name() == null) {
			errorList.add(DeErrorCodes.API_DE_101);
		}
		if (deVO.getConte_IDSEQ() == null) {
			errorList.add(DeErrorCodes.API_DE_102);
		}
		if (deVO.getPrefferred_def() == null) {
			errorList.add(DeErrorCodes.API_DE_103);
		}
		if (deVO.getVd_IDSEQ() == null) {
			errorList.add(DeErrorCodes.API_DE_104);
		}
		if (deVO.getDec_IDSEQ() == null) {
			errorList.add(DeErrorCodes.API_DE_106);
		}

		this.validate(deVO);

		// check if DE with the same preferredName, context,version does not
		// already exist
		if (acMgr.isAcExists(deVO.getPrefferred_name(), deVO.getConte_IDSEQ(), deVO.getVersion(), DBConstants.ASTL_NAME_DATA_ELEMENT, conn)) {
			errorList.add(DeErrorCodes.API_DE_300);
			Utils.logDe(errorList);
			throw new ValidationException(this.errorList);
		}

		if (errorList != null && errorList.size() > 0) {
			Utils.logDe(errorList);
			throw new ValidationException(this.errorList);
		}
	}

	/**
	 * This method validates everything that is required to perform update
	 * 
	 * @param deVO
	 * @param conn
	 * @throws ValidationException
	 */

	public void validateForUpdate(DeVO deVO, Connection conn)
			throws ValidationException, DBException {

		Data_Elements_Mgr deMgr = new Data_Elements_Mgr();
		Admin_Components_Mgr acMgr = new Admin_Components_Mgr();

		// check if deIDSEQ is null
		if (deVO.getDe_IDSEQ() == null) {
			errorList.add(DeErrorCodes.API_DE_400);
			Utils.logDe(errorList);
			throw new ValidationException(this.errorList);
		}
		// check if DE already exists in the database
		if (!(acMgr.isAcExists(deVO.getDe_IDSEQ(), conn))) {
			errorList.add(DeErrorCodes.API_DE_005);
			Utils.logDe(errorList);
			throw new ValidationException(this.errorList);
		}
		// check the work-flow status. If it is 'Released' then Preferred name
		// and context cannot be updated
		String aslName = deMgr.getDeAslNameByIdseq(deVO.getDe_IDSEQ(), conn);
		if (((deVO.getPrefferred_name() != null) || (deVO.getConte_IDSEQ() != null)) && (aslName).equals(DBConstants.ASL_NAME_RELEASED)) {
			errorList.add(DeErrorCodes.API_DE_401);
			Utils.logDe(errorList);
			throw new ValidationException(this.errorList);
		}
		this.validate(deVO);

		// check if version equals to retrieved version. If retrieved version
		// not equals to version
		// then throw exception since version cannot be updated
		if (deVO.getVersion() > 0) {
			double version = deMgr.getDeVersionByIdseq(deVO.getDe_IDSEQ(), conn);
			if (version != deVO.getVersion()){
				errorList.add(DeErrorCodes.API_DE_402);
				Utils.logDe(errorList);
				throw new ValidationException(this.errorList);
			}
		}

		if (errorList != null && errorList.size() > 0) {
			Utils.logDe(errorList);
			throw new ValidationException(this.errorList);
		}

	}

	/**
	 * This method validates everything that is required to perform delete
	 * operation
	 * 
	 * @param deIDSEQ
	 * @param conn
	 * @throws ValidationException
	 * @throws DBException
	 */
	public void validateForDelete(String deIDSEQ, Connection conn)
			throws ValidationException, DBException {

		Admin_Components_Mgr acMgr = new Admin_Components_Mgr();

		// check if de_IDSEQ is null
		if (deIDSEQ == null) {
			errorList.add(DeErrorCodes.API_DE_400);
		} else {
			// check if de exists in database
			if (!(acMgr.isAcExists(deIDSEQ, conn))) {
				errorList.add(DeErrorCodes.API_DE_005);
			}
		}
		if (errorList != null && errorList.size() > 0) {
			Utils.logDe(errorList);
			throw new ValidationException(this.errorList);
		}
	}

}
