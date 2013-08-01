/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.cdecurate.dto;

public class PermissibleValueBean {
	private String value;
	private String origin;
	private String beginDate;
	private String endDate;
	private ValueMeaningBean valueMeaning;
	private String parentConcept;

	public String getParentConcept() {
		return parentConcept;
	}

	public PermissibleValueBean() {
	}

	public PermissibleValueBean(String value, String origin, String beginDate,
			String endDate) {
		super();
		this.value = value;
		this.origin = origin;
		this.beginDate = beginDate;
		this.endDate = endDate;
	}

	public PermissibleValueBean(String value, String origin, String beginDate,
			String endDate, String parentConcept) {
		this(value, origin, beginDate, endDate);
		this.parentConcept = parentConcept;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getBeginDate() {
		return beginDate;
	}

	public void setBeginDate(String beginDate) {
		this.beginDate = beginDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public ValueMeaningBean getValueMeaning() {
		return valueMeaning;
	}

	public void setValueMeaning(ValueMeaningBean valueMeaning) {
		this.valueMeaning = valueMeaning;
	}
}
