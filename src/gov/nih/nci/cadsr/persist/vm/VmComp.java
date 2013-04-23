package gov.nih.nci.cadsr.persist.vm;

import gov.nih.nci.cadsr.persist.common.Operations;
import gov.nih.nci.cadsr.persist.exception.PersistException;

import java.sql.Connection;
import java.util.ArrayList;

import org.apache.log4j.Logger;

@SuppressWarnings("unchecked")
public class VmComp {
	
	private Logger logger = Logger.getLogger(this.getClass());
	/**
	 * Inserts or updates Value Meaning
	 * 
	 * @param vmVO
	 * @param action
	 * @param conn
	 * @return
	 */
public ArrayList<VmErrorCodes> setVm(VmVO vmVO, String action, String con_array, Connection conn){
		
		ArrayList<VmErrorCodes> errorList = new ArrayList<VmErrorCodes>();
		Value_Meanings_Mgr vmMgr = new Value_Meanings_Mgr();

		VmValidator validator = new VmValidator();
	
		try {
			if (action == null) {
				errorList.add(VmErrorCodes.API_VM_701);
			} else if (conn == null) {
				errorList.add(VmErrorCodes.API_VM_002);
			} else if (vmVO == null) {
				errorList.add(VmErrorCodes.API_VM_0011);
			} else if (action != null && action.equals(Operations.INSERT.getOperation())) {
				validator.validateForInsert(vmVO, conn);
				// perform insert operation
				String vm_IDSEQ = vmMgr.insert(vmVO, conn);
				if (logger.isDebugEnabled()) {
					logger.debug("Inserted VM --->" +vm_IDSEQ);
				}
		    }else if (action != null && action.equals(Operations.UPDATE.getOperation())){
				validator.validateForUpdate(vmVO, conn);
				vmMgr.update(vmVO, conn);
				if (logger.isDebugEnabled()) {
					logger.debug("Updated VM");
				}
			}
		}catch (PersistException e) {
				if (e.getErrorList() != null && e.getErrorList().size() > 0) {
					errorList = e.getErrorList();
				} else {
					errorList.add(VmErrorCodes.API_VM_000);
				}
		}
	return errorList;
}
}
