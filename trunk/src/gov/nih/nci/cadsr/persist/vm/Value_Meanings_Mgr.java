package gov.nih.nci.cadsr.persist.vm;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.log4j.Logger;

import gov.nih.nci.cadsr.cdecurate.database.SQLHelper;
import gov.nih.nci.cadsr.persist.common.DBConstants;
import gov.nih.nci.cadsr.persist.common.DBManager;
import gov.nih.nci.cadsr.persist.vm.VmErrorCodes;
import gov.nih.nci.cadsr.persist.exception.DBException;
import gov.nih.nci.cadsr.persist.utils.Utils;


@SuppressWarnings("unchecked")
public class Value_Meanings_Mgr extends DBManager{
	
	private Logger logger = Logger.getLogger(this.getClass());

/**
 * Returns VM based on the vm_IDSEQ, long_name, version, vm_ID
 * @param vm_IDSEQ
 * @param long_name
 * @param version
 * @param vm_ID
 * @param conn
 * @return
 */
	public VmVO getVm(String vm_IDSEQ, String long_name, double version, String vm_ID, Connection conn) throws DBException{
		PreparedStatement stmt = null;
		ResultSet rs = null;
		VmVO vmvo = null;
		try {
			
			if (vm_IDSEQ != null){
				String sql = "select * from value_meanings_view where vm_idseq = ?";
			    stmt = conn.prepareStatement(sql);
				stmt.setString(1, vm_IDSEQ);
			}else if ((long_name != null) && !(long_name.equals(""))){
				String sql = "select * from value_meanings_view where vm_idseq = ?";
			    stmt = conn.prepareStatement(sql);
				stmt.setString(1, vm_IDSEQ);
    		}else if ((vm_ID != null)&& !((vm_ID).equals("")) && (version > 0)){
    			String sql = "select * from value_meanings_view where vm_id = ? and version = ?";
			    stmt = conn.prepareStatement(sql);
				stmt.setString(1, vm_ID);
				stmt.setDouble(2, version);
    		}else{
    			errorList.add(VmErrorCodes.API_VM_001);
    			throw new DBException(errorList);
    		}
			rs = stmt.executeQuery();
			while (rs.next()) {
				vmvo = new VmVO();
				vmvo.setVm_IDSEQ(rs.getString("VM_IDSEQ"));
				vmvo.setPrefferred_name(rs.getString("PREFERRED_NAME"));
				vmvo.setLong_name(rs.getString("LONG_NAME"));
				vmvo.setPrefferred_def(rs.getString("PREFERRED_DEFINITION"));
				vmvo.setConte_IDSEQ(rs.getString("CONTE_IDSEQ"));
				vmvo.setAsl_name(rs.getString("ASL_NAME"));
				vmvo.setVersion(rs.getDouble("VERSION"));
				vmvo.setVm_ID(rs.getLong("VM_ID"));
				vmvo.setLatest_version_ind(rs.getString("LATEST_VERSION_IND"));
				vmvo.setCondr_IDSEQ(rs.getString("CONDR_IDSEQ"));
				vmvo.setDefinition_source(rs.getString("DEFINITION_SOURCE"));
				vmvo.setOrigin(rs.getString("ORIGIN"));
				vmvo.setChange_note(rs.getString("CHANGE_NOTE"));
				vmvo.setBegin_date(rs.getTimestamp("BEGIN_DATE"));
				vmvo.setEnd_date(rs.getTimestamp("END_DATE"));
				vmvo.setCreated_by(rs.getString("CREATED_BY"));
				vmvo.setDate_created(rs.getTimestamp("DATE_CREATED"));
				vmvo.setModified_by(rs.getString("MODIFIED_BY"));
				vmvo.setDate_modified(rs.getTimestamp("DATE_MODIFIED"));
			}
		} catch (SQLException e) {
			logger.error(DBException.DEFAULT_ERROR_MSG+ " in getVm() method of Data_Elements_Mgr class " + e);
			errorList.add(VmErrorCodes.API_VM_000);
			throw new DBException(errorList);
		} finally {
			try {
				rs = SQLHelper.closeResultSet(rs);
				stmt = SQLHelper.closePreparedStatement(stmt);
			} catch (Exception e) {
			}
		}
		return vmvo;
	}
	
	
	/**
	 * Checks to see that Value Meaning with same IDSEQ already exists if exists,
	 * returns true else returns false
	 * 
	 * @param vm_IDSEQ
	 * @param conn
	 * @return
	 * @throws DBException
	 */
	public boolean isVmExists(String vm_IDSEQ, Connection conn)	throws DBException {
		boolean isExists;

		StringBuffer sql = new StringBuffer();
		sql.append("select  COUNT(*) as count from value_meanings_view ");
		sql.append("where (vm_idseq = '").append(vm_IDSEQ);
		isExists = this.isExists(sql.toString(), conn);
		return isExists;
	}
	
	/**
	 * Returns the version of a DE based on deIDSEQ
	 * 
	 * @param vmIDSEQ
	 * @param conn
	 * @return
	 * @throws DBException
	 */
	public double getVmVersionByIdseq(String vmIDSEQ, Connection conn) throws DBException {

		PreparedStatement stmt = null;
		ResultSet rs = null;
		double version = 0;
		try {
			StringBuffer sql = new StringBuffer();
			sql.append("select version from value_meanings_view where de_idseq = ?");
			stmt = conn.prepareStatement(sql.toString());
			stmt.setString(1, vmIDSEQ);
			rs = stmt.executeQuery();
			while (rs.next()) {
				version = rs.getDouble(1);
			}
		} catch (SQLException e) {
			logger.error(DBException.DEFAULT_ERROR_MSG + " in getDeVersionByIdseq() method in Data_Elements_Mgr "+ e);
			errorList.add(VmErrorCodes.API_VM_000);
			throw new DBException(errorList);
		} finally {
			rs = SQLHelper.closeResultSet(rs);
			stmt = SQLHelper.closePreparedStatement(stmt);
		}
		return version;

	}
	
	/**
	 * Inserts a single row of Value Meanings list of value and returns primary key vm_IDSEQ
	 * 
	 * @param vmVO
	 * @param conn
	 * @return
	 * @throws DBException
	 */
	public String insert(VmVO vmVO, Connection conn) throws DBException {

		PreparedStatement statement = null;
		String primaryKey = null;
		//generate vm_IDSEQ(primary key) and cde_ID(publicID)
		vmVO.setVm_IDSEQ(this.generatePrimaryKey(conn));
		vmVO.setDeleted_ind(DBConstants.RECORD_DELETED_NO);
		vmVO.setDate_created(new java.sql.Timestamp(new java.util.Date().getTime()));
		try {
			StringBuffer sqlBuf = new StringBuffer();

			sqlBuf.append("insert into value_meanings_view( ");
			sqlBuf.append("vm_idseq, preferred_name, conte_idseq, version, preferred_definition, ");
			sqlBuf.append("long_name, asl_name, latest_version_ind, begin_date, end_date, change_note, ");
			sqlBuf.append("created_by, date_created, modified_by,  date_modified, deleted_ind,condr_idseq, origin )");
			sqlBuf.append("values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

			int column = 0;
			statement = conn.prepareStatement(sqlBuf.toString());
			statement.setString(++column, vmVO.getVm_IDSEQ());
			statement.setString(++column, vmVO.getPrefferred_name());
			statement.setString(++column, vmVO.getConte_IDSEQ());
			statement.setDouble(++column, vmVO.getVersion());
			statement.setString(++column, vmVO.getPrefferred_def());
			statement.setString(++column, vmVO.getLong_name());
			statement.setString(++column, vmVO.getAsl_name());
			statement.setString(++column, vmVO.getLatest_version_ind());
			statement.setTimestamp(++column, vmVO.getBegin_date());
			statement.setTimestamp(++column, vmVO.getEnd_date());
			statement.setString(++column, vmVO.getChange_note());
			statement.setString(++column, vmVO.getCreated_by());
			statement.setTimestamp(++column, vmVO.getDate_created());
			statement.setString(++column, vmVO.getModified_by());
			statement.setTimestamp(++column, vmVO.getDate_modified());
			statement.setString(++column, vmVO.getDeleted_ind());
			statement.setString(++column, vmVO.getCondr_IDSEQ());
			statement.setString(++column, vmVO.getOrigin());
			
			int count = statement.executeUpdate();
			if (count == 0) {
				throw new Exception("Unable to insert the record");
			} else {
				primaryKey = vmVO.getVm_IDSEQ();
			}

		} catch (Exception e) {
			logger.error("Error inserting Data Element " + e);
			errorList.add(VmErrorCodes.API_VM_500);
			throw new DBException(errorList);
		} finally {
			statement = SQLHelper.closePreparedStatement(statement);
		}
		return primaryKey;
	}
	
	/**
	 * Updates single row of Value Meaning
	 * 
	 * @param vmVO
	 * @param conn
	 * @throws DBException
	 */
	public void update(VmVO vmVO, Connection conn) throws DBException {

		Statement statement = null;
		vmVO.setDeleted_ind(DBConstants.RECORD_DELETED_NO);
		vmVO.setDate_modified(new java.sql.Timestamp(new java.util.Date().getTime()));

		// logger.debug("updateClient()");
		try {
			StringBuffer sql = new StringBuffer();
			sql.append(" update value_meanings_view ");
			sql.append(" set date_modified ='" + vmVO.getDate_modified() + "'");
			sql.append(", modified_by = '" + vmVO.getModified_by() + "'");
			sql.append(", deleted_ind = '" + vmVO.getDeleted_ind() + "'");

			if (vmVO.getPrefferred_name() != null) {
				sql.append(", preferred_name = '" + vmVO.getPrefferred_name()
						+ "'");
			}
			if (vmVO.getConte_IDSEQ() != null) {
				sql.append(", conte_idseq = '" + vmVO.getConte_IDSEQ() + "'");
			}
			if (vmVO.getPrefferred_def() != null) {
				sql.append(", preferred_definition = '"
						+ vmVO.getPrefferred_def().replace("'","\"") + "'");
			}
			if (vmVO.getLong_name() != null) {
				sql.append(", long_name = '" + vmVO.getLong_name() + "'");
			}
			if (vmVO.getAsl_name() != null) {
				sql.append(", asl_name = '" + vmVO.getAsl_name() + "'");
			}
			
			if (vmVO.getCondr_IDSEQ() != null) {
				sql.append(", vd_idseq = '" + vmVO.getCondr_IDSEQ() + "'");
			}
			if (vmVO.getLatest_version_ind() != null) {
				sql.append(", latest_version_ind = '"
						+ vmVO.getLatest_version_ind() + "'");
			}
			if (vmVO.getBegin_date() != null) {
				sql.append(", begin_date = '" + vmVO.getBegin_date() + "'");
			}else{	
				//allow null update
		    	sql.append(", begin_date = ''");
			}
			if (vmVO.getEnd_date() != null) {
				sql.append(",  end_date = '" + vmVO.getEnd_date() + "'");
			}else{	
				//allow null update
			 	sql.append(",  end_date = ''");
			}
			if (vmVO.getChange_note() != null) {
				//allow null updates
				if (vmVO.getChange_note() == "") {
					sql.append(",  change_note = ''");
				} else {
					sql.append(",  change_note = '" + vmVO.getChange_note().replace("'","\"")	+ "'");
				}
			}
			if (vmVO.getOrigin() != null) {
				//allow null updates
				if (vmVO.getOrigin() == "") {
					sql.append(",  origin= ''");
				} else {
					sql.append(",  origin= '" + vmVO.getOrigin() + "'");
				}
			}
	
			sql.append(" where vm_idseq = '" + vmVO.getVm_IDSEQ() + "'");

			statement = conn.createStatement();
			int result = statement.executeUpdate(sql.toString());

			if (result == 0) {
				throw new Exception("Unable to Update");
			} 
			
		} catch (Exception e) {
			logger.error("Error updating Data Element " + vmVO.getVm_IDSEQ() + e);
			errorList.add(VmErrorCodes.API_VM_501);
			throw new DBException(errorList);
		} finally {
			statement = SQLHelper.closeStatement(statement);
		}

	}
	
	
}
