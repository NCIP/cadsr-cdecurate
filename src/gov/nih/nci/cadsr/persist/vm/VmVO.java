/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.persist.vm;

import java.sql.Timestamp;

import gov.nih.nci.cadsr.persist.common.BaseVO;


	@SuppressWarnings("serial")
	public class VmVO extends BaseVO {
		
		private String short_meaning;
		private String description;
		private String comments;
		private Timestamp begin_date;
		private Timestamp end_date;
		private String condr_IDSEQ;
		private String vm_IDSEQ;
		private String prefferred_name;
		private String prefferred_def;
		private String long_name;
		private String conte_IDSEQ;
		private String asl_name;
		private double version;
		private long vm_ID;
		private String latest_version_ind;
		private String deleted_ind;
		private String origin;
		private String change_note;
		private String definition_source;
		
		public VmVO(){
			super();
		}
		
		/**
		 * @return the short_meaning
		 */
		public String getShort_meaning() {
			return short_meaning;
		}
		/**
		 * @param short_meaning the short_meaning to set
		 */
		public void setShort_meaning(String short_meaning) {
			this.short_meaning = short_meaning;
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
		 * @return the vm_IDSEQ
		 */
		public String getVm_IDSEQ() {
			return vm_IDSEQ;
		}
		/**
		 * @param vm_IDSEQ the vm_IDSEQ to set
		 */
		public void setVm_IDSEQ(String vm_IDSEQ) {
			this.vm_IDSEQ = vm_IDSEQ;
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
		 * @return the vm_ID
		 */
		public long getVm_ID() {
			return vm_ID;
		}
		/**
		 * @param vm_ID the vm_ID to set
		 */
		public void setVm_ID(long vm_ID) {
			this.vm_ID = vm_ID;
		}
		/**
		 * @return the latest_version_ind
		 */
		public String getLatest_version_ind() {
			return latest_version_ind;
		}
		/**
		 * @param latest_version_ind the latest_version_ind to set
		 */
		public void setLatest_version_ind(String latest_version_ind) {
			this.latest_version_ind = latest_version_ind;
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
		
	 
	}



