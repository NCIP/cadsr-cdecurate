package gov.nih.nci.cadsr.persist.de;

import java.sql.Connection;
import java.util.ArrayList;

import org.apache.log4j.Logger;

import gov.nih.nci.cadsr.persist.ac.Ac_Histories_Mgr;
import gov.nih.nci.cadsr.persist.ac.Admin_Components_Mgr;
import gov.nih.nci.cadsr.persist.common.DBConstants;
import gov.nih.nci.cadsr.persist.common.Operations;
import gov.nih.nci.cadsr.persist.exception.PersistException;
import gov.nih.nci.cadsr.persist.exception.DBException;

@SuppressWarnings("unchecked")
public class DeComp {

	private Logger logger = Logger.getLogger(this.getClass());

	/**
	 * Inserts or updates or deletes Data Element
	 * 
	 * @param deVO
	 * @param action
	 * @param conn
	 * @return
	 */
	public ArrayList<DeErrorCodes> setDe(DeVO deVO, String action, Connection conn) {

		DeValidator validator = new DeValidator();
		Data_Elements_Mgr deMgr = new Data_Elements_Mgr();
		Admin_Components_Mgr acMgr = new Admin_Components_Mgr();
		Ac_Histories_Mgr hisMgr = new Ac_Histories_Mgr();
		ArrayList<DeErrorCodes> errorList = new ArrayList<DeErrorCodes>();
		boolean newVersion = false;
		String sourceIDSEQ = null;

		try {
			if (action == null) {
				errorList.add(DeErrorCodes.API_DE_700);
			} else if (conn == null) {
				errorList.add(DeErrorCodes.API_DE_002);
			} else if (deVO == null) {
				errorList.add(DeErrorCodes.API_DE_001);
			} else if (action != null && action.equals(Operations.INSERT.getOperation())) {
				initialize(deVO, conn);
				// perform validation
				validator.validateForInsert(deVO, conn);
				// check if prior version already exist
				if (acMgr.isAcVersionExists(deVO.getPrefferred_name(), deVO.getConte_IDSEQ(), DBConstants.ASTL_NAME_DATA_ELEMENT, conn)) {
					newVersion = true;
					sourceIDSEQ = deMgr.getSourceIdseq(deVO.getPrefferred_name(), deVO.getConte_IDSEQ(), conn);
				}
				// perform insert operation
				String de_IDSEQ = deMgr.insert(deVO, conn);
				// if latest_version_indicator = 'yes' then
				// update so that all other versions have the indicator set to
				// 'No'
				if ((deVO.getLastest_version_ind() != null) && (deVO.getLastest_version_ind().equals(DBConstants.LATEST_VERSION_IND_YES))) {
					deMgr.setDeLatestVersionIndicator(deVO.getDe_IDSEQ(), conn);
				}
				if (newVersion) {
					// create history record with prior version
					hisMgr.createAcHistory(sourceIDSEQ, de_IDSEQ, DBConstants.AL_NAME_VERSIONED,
							deVO.getCreated_by(), conn);
				}

			} else if (action != null && action.equals(Operations.UPDATE.getOperation())) {
				// perform validation
				validator.validateForUpdate(deVO, conn);
				// perform update operation
				deMgr.update(deVO, conn);
				if (logger.isDebugEnabled()) {
					logger.debug("Updated DE");
				}
				// if latest_version_indicator = 'yes' then
				// update so that all other versions have the indicator set to
				// 'No'
				if ((deVO.getLastest_version_ind() != null) && (deVO.getLastest_version_ind().equals(DBConstants.LATEST_VERSION_IND_YES))){
					deMgr.setDeLatestVersionIndicator(deVO.getDe_IDSEQ(), conn);
				}
			} else if (action != null && action.equals(Operations.DELETE.getOperation())) {
				// perform validation
				validator.validateForDelete(deVO.getDe_IDSEQ(), conn);
				// perform delete operation
				deMgr.delete(deVO.getDe_IDSEQ(), deVO.getModified_by(), conn);
			}
		} catch (PersistException e) {
			if (e.getErrorList() != null && e.getErrorList().size() > 0) {
				errorList = e.getErrorList();
			} else {
				errorList.add(DeErrorCodes.API_DE_000);
			}
		}

		return errorList;
	}

	/**
	 * Call Initialize method only for inserting DE
	 * 
	 * @param deVO
	 * @throws DBException
	 */
	private void initialize(DeVO deVO, Connection conn) throws DBException {
		// Initialize the object
		Data_Elements_Mgr deMgr = new Data_Elements_Mgr();

		// set the work-flow status(asl_name) to 'DRAFT_NEW' if it is null
		if (deVO.getAsl_name() == null) {
			deVO.setAsl_name(DBConstants.DEFALULT_ASL_INSERT);
		}
		// set the version if it is 0
		if (deVO.getVersion() == 0) {
			deVO.setVersion(deMgr.getDeVersion(deVO.getPrefferred_name(), deVO.getConte_IDSEQ(), conn) + 1);
		}
		// set latest_version_ind to 'NO' if is null
		if (deVO.getLastest_version_ind() == null) {
			deVO.setLastest_version_ind(DBConstants.LATEST_VERSION_IND_NO);
		}
	}

}
