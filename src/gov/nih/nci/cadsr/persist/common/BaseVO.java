package gov.nih.nci.cadsr.persist.common;

import java.io.Serializable;
import java.sql.Timestamp;

@SuppressWarnings("serial")
public class BaseVO implements Serializable {

	private Timestamp date_created;
	private String created_by;
	private Timestamp date_modified;
	private String modified_by;

	public BaseVO() {
	}
	
	/**
	 * @return the date_created
	 */
	public Timestamp getDate_created() {
		return date_created;
	}

	/**
	 * @param date_created
	 *            the date_created to set
	 */
	public void setDate_created(Timestamp date_created) {
		this.date_created = date_created;
	}

	/**
	 * @return the created_by
	 */
	public String getCreated_by() {
		return created_by;
	}

	/**
	 * @param created_by
	 *            the created_by to set
	 */
	public void setCreated_by(String created_by) {
		this.created_by = created_by;
	}

	/**
	 * @return the date_modified
	 */
	public Timestamp getDate_modified() {
		return date_modified;
	}

	/**
	 * @param date_modified
	 *            the date_modified to set
	 */
	public void setDate_modified(Timestamp date_modified) {
		this.date_modified = date_modified;
	}

	/**
	 * @return the modified_by
	 */
	public String getModified_by() {
		return modified_by;
	}

	/**
	 * @param modified_by
	 *            the modified_by to set
	 */
	public void setModified_by(String modified_by) {
		this.modified_by = modified_by;
	}

}
