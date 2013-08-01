/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

/**
 * 
 */
package gov.nih.nci.cadsr.persist.evs;

import java.sql.Timestamp;
import gov.nih.nci.cadsr.persist.common.BaseVO;

/**
 * @author hveerla
 *
 */
@SuppressWarnings("serial")
public class EvsVO extends BaseVO {
	
	private String iDSEQ;
	private double version;
	private String conte_IDSEQ;
	private String prefferred_name;
	private String prefferred_def;
	private String asl_name;
	private String long_name;
	private String lastest_version_ind;
	private String deleted_ind;
	private Timestamp begin_date;
	private Timestamp end_date;
	private String change_note;
	private String origin;
	private String definition_source;
	private long public_ID;
	private String condr_IDSEQ;
	private String evs_source;
	
	public EvsVO() {
		super();
	}
	/**
	 * @return the iDSEQ
	 */
	public String getIDSEQ() {
		return iDSEQ;
	}
	/**
	 * @param idseq the iDSEQ to set
	 */
	public void setIDSEQ(String idseq) {
		iDSEQ = idseq;
	}
	/**
	 * @return the version
	 */
	public double getVersion() {
		return version;
	}
	/**
	 * @param version the version to set
	 */
	public void setVersion(double version) {
		this.version = version;
	}
	/**
	 * @return the conte_IDSEQ
	 */
	public String getConte_IDSEQ() {
		return conte_IDSEQ;
	}
	/**
	 * @param conte_IDSEQ the conte_IDSEQ to set
	 */
	public void setConte_IDSEQ(String conte_IDSEQ) {
		this.conte_IDSEQ = conte_IDSEQ;
	}
	/**
	 * @return the prefferred_name
	 */
	public String getPrefferred_name() {
		return prefferred_name;
	}
	/**
	 * @param prefferred_name the prefferred_name to set
	 */
	public void setPrefferred_name(String prefferred_name) {
		this.prefferred_name = prefferred_name;
	}
	/**
	 * @return the prefferred_def
	 */
	public String getPrefferred_def() {
		return prefferred_def;
	}
	/**
	 * @param prefferred_def the prefferred_def to set
	 */
	public void setPrefferred_def(String prefferred_def) {
		this.prefferred_def = prefferred_def;
	}
	/**
	 * @return the asl_name
	 */
	public String getAsl_name() {
		return asl_name;
	}
	/**
	 * @param asl_name the asl_name to set
	 */
	public void setAsl_name(String asl_name) {
		this.asl_name = asl_name;
	}
	/**
	 * @return the long_name
	 */
	public String getLong_name() {
		return long_name;
	}
	/**
	 * @param long_name the long_name to set
	 */
	public void setLong_name(String long_name) {
		this.long_name = long_name;
	}
	/**
	 * @return the lastest_version_ind
	 */
	public String getLastest_version_ind() {
		return lastest_version_ind;
	}
	/**
	 * @param lastest_version_ind the lastest_version_ind to set
	 */
	public void setLastest_version_ind(String lastest_version_ind) {
		this.lastest_version_ind = lastest_version_ind;
	}
	/**
	 * @return the deleted_ind
	 */
	public String getDeleted_ind() {
		return deleted_ind;
	}
	/**
	 * @param deleted_ind the deleted_ind to set
	 */
	public void setDeleted_ind(String deleted_ind) {
		this.deleted_ind = deleted_ind;
	}
	/**
	 * @return the begin_date
	 */
	public Timestamp getBegin_date() {
		return begin_date;
	}
	/**
	 * @param begin_date the begin_date to set
	 */
	public void setBegin_date(Timestamp begin_date) {
		this.begin_date = begin_date;
	}
	/**
	 * @return the end_date
	 */
	public Timestamp getEnd_date() {
		return end_date;
	}
	/**
	 * @param end_date the end_date to set
	 */
	public void setEnd_date(Timestamp end_date) {
		this.end_date = end_date;
	}
	/**
	 * @return the change_note
	 */
	public String getChange_note() {
		return change_note;
	}
	/**
	 * @param change_note the change_note to set
	 */
	public void setChange_note(String change_note) {
		this.change_note = change_note;
	}
	/**
	 * @return the origin
	 */
	public String getOrigin() {
		return origin;
	}
	/**
	 * @param origin the origin to set
	 */
	public void setOrigin(String origin) {
		this.origin = origin;
	}
	/**
	 * @return the definition_source
	 */
	public String getDefinition_source() {
		return definition_source;
	}
	/**
	 * @param definition_source the definition_source to set
	 */
	public void setDefinition_source(String definition_source) {
		this.definition_source = definition_source;
	}
	/**
	 * @return the public_ID
	 */
	public long getPublic_ID() {
		return public_ID;
	}
	/**
	 * @param public_ID the public_ID to set
	 */
	public void setPublic_ID(long public_ID) {
		this.public_ID = public_ID;
	}
	/**
	 * @return the condr_IDSEQ
	 */
	public String getCondr_IDSEQ() {
		return condr_IDSEQ;
	}
	/**
	 * @param condr_IDSEQ the condr_IDSEQ to set
	 */
	public void setCondr_IDSEQ(String condr_IDSEQ) {
		this.condr_IDSEQ = condr_IDSEQ;
	}
	/**
	 * @return the evs_source
	 */
	public String getEvs_source() {
		return evs_source;
	}
	/**
	 * @param evs_source the evs_source to set
	 */
	public void setEvs_source(String evs_source) {
		this.evs_source = evs_source;
	}

}
