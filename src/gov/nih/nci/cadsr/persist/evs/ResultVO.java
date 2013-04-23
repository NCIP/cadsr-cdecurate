package gov.nih.nci.cadsr.persist.evs;

public class ResultVO {
	
	String condr_IDSEQ;
	String iDSEQ;
	String long_name;
	String publicId;
	String version;
	String asl_name;
	String context;
	
	public ResultVO() {
		super();
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
	 * @return the publicId
	 */
	public String getPublicId() {
		return publicId;
	}
	/**
	 * @param publicId the publicId to set
	 */
	public void setPublicId(String publicId) {
		this.publicId = publicId;
	}
	/**
	 * @return the version
	 */
	public String getVersion() {
		return version;
	}
	/**
	 * @param version the version to set
	 */
	public void setVersion(String version) {
		this.version = version;
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
	 * @return the context
	 */
	public String getContext() {
		return context;
	}
	/**
	 * @param context the context to set
	 */
	public void setContext(String context) {
		this.context = context;
	}
	@Override
	public String toString() {
		return "ResultVO [condr_IDSEQ=" + condr_IDSEQ + ", iDSEQ=" + iDSEQ
				+ ", long_name=" + long_name + ", publicId=" + publicId
				+ ", version=" + version + ", asl_name=" + asl_name
				+ ", context=" + context + "]";
	}
	
}
