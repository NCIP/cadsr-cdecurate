/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.persist.common;

import gov.nih.nci.cadsr.persist.de.DeErrorCodes;

import java.sql.Timestamp;
import java.util.ArrayList;

import org.apache.log4j.Logger;

@SuppressWarnings("unchecked")
public class BaseValidator {

	protected Logger logger = Logger.getLogger(this.getClass());
	protected ArrayList errorList = new ArrayList();
	
	/**
	 * This method checks whether input string have correct length
	 * 
	 * @param fieldValue
	 * @param allowedMaxLength
	 * @return
	 */
	public boolean validateStringFieldWithMaxLength(String fieldValue, int allowedMaxLength) {
		boolean result = true;
		if (fieldValue != null && fieldValue.length() > allowedMaxLength) {
			result = false;
		}
		return result;
	}

		
	/**
	 * This method checks to see that character strings are valid
	 * 
	 * @param fieldValue
	 * @return
	 */
	public boolean validateCharacterStrings(String fieldValue) {
		boolean result = true;
		return result;
	}

	/**
	 * This method checks if end date is before begin date.
	 * 
	 * @param endDate
	 * @param beginDate
	 * @return
	 */
	public boolean validateDates(Timestamp endDate, Timestamp beginDate) {
		boolean result = false;
		try {
			if ((endDate.before(beginDate))) {
				result = true;
			}
		} catch (Exception e) {
			errorList.add(DeErrorCodes.API_DE_000);
			logger.error("Exception thrown in validateDates() method of BaseValidator "	+ e);
		}
		return result;
	}
}
