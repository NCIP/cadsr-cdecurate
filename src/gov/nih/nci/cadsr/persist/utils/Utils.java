/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.persist.utils;

import gov.nih.nci.cadsr.persist.de.DeErrorCodes;
import gov.nih.nci.cadsr.persist.vm.VmErrorCodes;

import java.util.ArrayList;
import java.util.Iterator;

import org.apache.log4j.Logger;

@SuppressWarnings("unchecked")
public class Utils {

	private static Logger logger = Logger.getLogger(Utils.class);

	public Utils() {
	}

	/**
	 * 
	 * @param errorList
	 */
	public static void logDe(ArrayList errorList) {
		errorList.add(DeErrorCodes.ERROR);
		if (logger.isDebugEnabled()) {
			Iterator it = errorList.iterator();
			while (it.hasNext()) {
				DeErrorCodes errorCode = (DeErrorCodes) it.next();
				logger.debug(errorCode.toString() + " -----> "+ errorCode.getErrorMessage());
			}
		}

	}
	/*
	 * @param errorList
	 */
	public static void logVm(ArrayList errorList) {
		errorList.add(DeErrorCodes.ERROR);
		if (logger.isDebugEnabled()) {
			Iterator it = errorList.iterator();
			while (it.hasNext()) {
				VmErrorCodes errorCode = (VmErrorCodes) it.next();
				logger.debug(errorCode.toString() + " -----> "+ errorCode.getErrorMessage());
			}
		}

	}

}
