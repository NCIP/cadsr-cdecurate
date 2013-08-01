/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.persist.ac;

public class DataTypeVO {
	private String dtl_name;
	private String description;
	private String comments;
	private String scheme_reference;
	private String annotation;
	
	public DataTypeVO(){
		super();
	}

	/**
	 * @return the dtl_name
	 */
	public String getDtl_name() {
		return dtl_name;
	}

	/**
	 * @param dtl_name the dtl_name to set
	 */
	public void setDtl_name(String dtl_name) {
		this.dtl_name = dtl_name;
	}

	/**
	 * @return the description
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * @param description the description to set
	 */
	public void setDescription(String description) {
		this.description = description;
	}

	/**
	 * @return the comments
	 */
	public String getComments() {
		return comments;
	}

	/**
	 * @param comments the comments to set
	 */
	public void setComments(String comments) {
		this.comments = comments;
	}

	/**
	 * @return the scheme_reference
	 */
	public String getScheme_reference() {
		return scheme_reference;
	}

	/**
	 * @param scheme_reference the scheme_reference to set
	 */
	public void setScheme_reference(String scheme_reference) {
		this.scheme_reference = scheme_reference;
	}

	/**
	 * @return the annotation
	 */
	public String getAnnotation() {
		return annotation;
	}

	/**
	 * @param annotation the annotation to set
	 */
	public void setAnnotation(String annotation) {
		this.annotation = annotation;
	}
	

}
