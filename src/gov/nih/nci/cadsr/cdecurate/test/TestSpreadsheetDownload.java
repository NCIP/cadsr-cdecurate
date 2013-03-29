// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/test/testdec.java,v 1.11 2008-03-13 17:57:59 chickerura Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.test;

import gov.nih.nci.cadsr.cdecurate.util.AdministeredItemUtil;
import gov.nih.nci.cadsr.common.TestUtil;

import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Array;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Struct;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import oracle.sql.Datum;
import oracle.sql.STRUCT;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

/**
 * @author shegde
 * @useful sqls -
 * --getting a DE with all columns populated
select 
 "DE Long Name",
 "DE Public ID",
 OC_CONCEPTS,
 PROP_CONCEPTS,
 VD_CONCEPTS,
 REP_CONCEPTS,
 VALID_VALUES,
 CLASSIFICATIONS,
 DESIGNATIONS,
 REFERENCE_DOCS,
 DE_DERIVATION
from CDE_EXCEL_GENERATOR_VIEW
WHERE
 OC_CONCEPTS  IS NOT EMPTY and
 PROP_CONCEPTS  IS NOT EMPTY and
 VD_CONCEPTS  IS NOT EMPTY and
 REP_CONCEPTS  IS NOT EMPTY and
 VALID_VALUES  IS NOT EMPTY and
 CLASSIFICATIONS  IS NOT EMPTY and
 DESIGNATIONS  IS NOT EMPTY and
 REFERENCE_DOCS   IS NOT EMPTY and
 DE_DERIVATION  IS NOT NULL
-- desc DERIVED_DATA_ELEMENT_T
 * --checking specific columns
 * select "DE Preferred Definition","VD Short Name" ,"VD Long Name" from cde_excel_generator_view where cde_idseq = 'E0F50D35-0EBD-1078-E034-0003BA12F5E7';
 * --spreadsheet columns sqls
--AI to AN in Excel sheet (Exist in customDownload.sql at line 362)
SELECT con.preferred_name,
                                 con.long_name,
                                 con.con_id,
                                 con.definition_source,
                                 con.origin,
                                 con.evs_source,
                                 com.primary_flag_ind,
                                 com.display_order
                          FROM component_concepts_ext com, properties_ext prop,concepts_ext con
                          WHERE prop.condr_idseq = com.condr_idseq(+)
                                AND com.con_idseq = con.con_idseq(+)
                          ORDER BY display_order DESC;

--BT to CB in Excel sheet (Exist in customDownload.sql at line 403)
SELECT pv.VALUE, 
       vm.long_name short_meaning, 
       vm.preferred_definition, 
       sbrext_common_routines.get_concepts(vm.condr_idseq) meaningconcepts,
       pv.begin_date,
       pv.end_date,
       vm.vm_id,
       vm.version,
       defs.definition --GF32647
      FROM sbr.permissible_values pv,
           sbr.vd_pvs vp,
           sbr.definitions_view defs,--GF32647
           value_meanings vm,
           sbr.value_domains vd,
           representations_ext rep,
           sbr.contexts vd_conte,
           sbr.data_elements de,
           conceptual_domains cd
      WHERE  vp.vd_idseq = vd.vd_idseq
             AND vp.pv_idseq = pv.pv_idseq
             AND pv.vm_idseq = vm.vm_idseq
             AND vm.vm_idseq = defs.ac_idseq(+) --GF32647
             AND de.vd_idseq = 'EAA9208F-77F2-5AA0-E034-0003BA3F9857'
             AND vd.conte_idseq = vd_conte.conte_idseq
             AND vd.cd_idseq = cd.cd_idseq
             AND vd.rep_idseq = rep.rep_idseq(+);

--CK to CO in Excel sheet  (Exist in customDownload.sql at line 466)
SELECT des_conte.name,
                                 des_conte.version,
                                 des.name,
                                 des.detl_name,
                                 des.lae_name
                          FROM sbr.designations des, sbr.data_elements de,sbr.contexts des_conte
                          WHERE de.de_idseq = des.ac_idseq(+)
                                AND des.conte_idseq = des_conte.conte_idseq(+);
 *
 * @table
SQL> desc CDE_EXCEL_GENERATOR_VIEW;   
 Name					   Null?    Type
 ----------------------------------------- -------- ----------------------------
 CDE_IDSEQ				   NOT NULL CHAR(36)
 DE Short Name				   NOT NULL VARCHAR2(30)
 DE Long Name					    VARCHAR2(255)
 DE Preferred Question Text			    VARCHAR2(4000)
 DE Preferred Definition		   NOT NULL VARCHAR2(2000)
 DE Version				   NOT NULL NUMBER(4,2)
 DE Context Name			   NOT NULL VARCHAR2(30)
 DE Context Version			   NOT NULL NUMBER(4,2)
 DE Public ID				   NOT NULL NUMBER
 DE Workflow Status			   NOT NULL VARCHAR2(20)
 DE Registration Status 			    VARCHAR2(50)
 DE Begin Date					    DATE
 DE Source					    VARCHAR2(240)
 DEC Public ID				   NOT NULL NUMBER
 DEC Short Name 			   NOT NULL VARCHAR2(30)
 DEC Long Name					    VARCHAR2(255)
 DEC Version				   NOT NULL NUMBER(4,2)
 DEC Context Name			   NOT NULL VARCHAR2(30)
 DEC Context Version			   NOT NULL NUMBER(4,2)
 OC Public ID					    NUMBER
 OC Long Name					    VARCHAR2(255)
 OC Short Name					    VARCHAR2(30)
 OC Context Name				    VARCHAR2(30)
 OC Version					    NUMBER(4,2)
 OC_CONCEPTS					    CONCEPTS_LIST_T
 Property Public ID				    NUMBER
 Property Long Name				    VARCHAR2(255)
 Property Short Name				    VARCHAR2(30)
 Property Context Name				    VARCHAR2(30)
 Property Version				    NUMBER(4,2)
 PROP_CONCEPTS					    CONCEPTS_LIST_T
 VD Public ID				   NOT NULL NUMBER
 VD Short Name				   NOT NULL VARCHAR2(30)
 VD Long Name					    VARCHAR2(255)
 VD Version				   NOT NULL NUMBER(4,2)
 VD Context Name			   NOT NULL VARCHAR2(30)
 VD Context Version			   NOT NULL NUMBER(4,2)
 VD Type					    VARCHAR2(14)
 VD Datatype				   NOT NULL VARCHAR2(20)
 VD Min Length					    NUMBER(8)
 VD Max Length					    NUMBER(8)
 VD Min value					    VARCHAR2(255)
 VD Max Value					    VARCHAR2(255)
 VD Decimal Place				    NUMBER(2)
 VD Format					    VARCHAR2(20)
 VD_CONCEPTS					    CONCEPTS_LIST_T
 Representation Public ID			    NUMBER
 Representation Long Name			    VARCHAR2(255)
 Representation Short Name			    VARCHAR2(30)
 Representation Context Name			    VARCHAR2(30)
 Representation Version 			    NUMBER(4,2)
 REP_CONCEPTS					    CONCEPTS_LIST_T
 VALID_VALUES					    VALID_VALUE_LIST_T
 CLASSIFICATIONS				    CDEBROWSER_CSI_LIST_T
 DESIGNATIONS					    DESIGNATIONS_LIST_T
 REFERENCE_DOCS 				    CDEBROWSER_RD_LIST_T
 DE_DERIVATION					    DERIVED_DATA_ELEMENT_T
 CD Public ID				   NOT NULL NUMBER
 CD Short Name				   NOT NULL VARCHAR2(30)
 CD Version				   NOT NULL NUMBER(4,2)
 CD Context Name			   NOT NULL VARCHAR2(30)
 * 
 */
public class TestSpreadsheetDownload {
	public static final Logger logger = Logger
			.getLogger(TestSpreadsheetDownload.class.getName());

	protected static Connection m_conn = null;
	private static final int GRID_MAX_DISPLAY = 10;
	FileOutputStream fileOutputStream = null;
	ArrayList<String> columnHeaders = new ArrayList<String>();
	ArrayList<String> columnTypes = new ArrayList<String>();
	HashMap<String, ArrayList<String[]>> typeMap = new HashMap<String, ArrayList<String[]>>();
	HashMap<String, String> arrayColumnTypes = new HashMap<String, String>();
	ArrayList<String> allExpandedColumnHeaders = new ArrayList<String>();
	ArrayList<HashMap<String, List<String[]>>> arrayData = new ArrayList<HashMap<String, List<String[]>>>();

	//=======================================================================
	public static void main1(String[] args) {
		String type = "CDE";
		PreparedStatement stmt = null;
		ResultSet rset = null;
		String value = null;
		Array array1 = null;	ResultSet nestedRs1;	oracle.sql.STRUCT s1 = null;
		Array array2 = null;	ResultSet nestedRs2;	oracle.sql.STRUCT s2 = null;
		STRUCT array3 = null;	/*ResultSet nestedRs3;*/	oracle.sql.STRUCT s3 = null;
		Array array3_1 = null;	ResultSet nestedRs3_1;	oracle.sql.STRUCT s3_1 = null;
		
		try {
			connectDB(args[0], args[1]);
	        logger.debug("connected");

	        //e.g. select OC_CONCEPTS from CDE_EXCEL_GENERATOR_VIEW --type is CONCEPTS_LIST_T
			String qry = "SELECT OC_CONCEPTS, VALID_VALUES, DE_DERIVATION FROM " + type
					+ "_EXCEL_GENERATOR_VIEW"
					+ " where "
//					+ "rownum < 11"
//					+ "\"DE Public ID\" = 3124888"	//test case for ORA-01403: no data found" 
//					+ "\"DE Public ID\" = 2341940"	//get by entering *derived* in DE search based on Name and Def
					+ "\"DE Public ID\" = 2341940"	//DERIVATION METHOD test, created by Denise
					;
			stmt = m_conn.prepareStatement(qry);
			// _EXCEL_GENERATOR_VIEW.OC_CONCEPTS:
			/*
			SQL> desc CONCEPTS_LIST_T;          
			 CONCEPTS_LIST_T TABLE OF CONCEPT_DETAIL_T
			 Name					   Null?    Type
			 ----------------------------------------- -------- ----------------------------
			 PREFERRED_NAME 				    VARCHAR2(30)
			 LONG_NAME					    VARCHAR2(255)
			 CON_ID 					    NUMBER
			 DEFINITION_SOURCE				    VARCHAR2(2000)
			 ORIGIN 					    VARCHAR2(240)
			 EVS_SOURCE					    VARCHAR2(255)
			 PRIMARY_FLAG_IND				    VARCHAR2(3)
			 DISPLAY_ORDER					    NUMBER
			
			SQL> 
			SQL> desc VALID_VALUE_LIST_T;
			 VALID_VALUE_LIST_T TABLE OF VALID_VALUE_T
			 Name					   Null?    Type
			 ----------------------------------------- -------- ----------------------------
			 VALIDVALUE					    VARCHAR2(255)
			 VALUEMEANING					    VARCHAR2(255)
			 MEANINGDESCRIPTION				    VARCHAR2(2000)
			 MEANINGCONCEPTS				    VARCHAR2(2000)
			 PVBEGINDATE					    DATE
			 PVENDDATE					    DATE
			 VMPUBLICID					    NUMBER
			 VMVERSION					    NUMBER(4,2)
			 VMALTERNATEDEFINITIONS 			    VARCHAR2(2000)
			
			SQL> 
			SQL> desc DERIVED_DATA_ELEMENT_T;
			 Name					   Null?    Type
			 ----------------------------------------- -------- ----------------------------
			 DerivationType 				    VARCHAR2(30)
			 DerivationTypeDescription			    VARCHAR2(200)
			 Methods					    VARCHAR2(4000)
			 Rule						    VARCHAR2(4000)
			 ConcatenationCharacter 			    VARCHAR2(1)
			 ComponentDataElementsList			    DATA_ELEMENT_DERIVATION_LIST
									    _T
			
			SQL> 
			SQL> desc DATA_ELEMENT_DERIVATION_LIST_T;
			 DATA_ELEMENT_DERIVATION_LIST_T TABLE OF DATA_ELEMENT_DERIVATION_T
			 Name					   Null?    Type
			 ----------------------------------------- -------- ----------------------------
			 PublicId					    NUMBER
			 LongName					    VARCHAR2(255)
			 PreferredName					    VARCHAR2(30)
			 PreferredDefinition				    VARCHAR2(2000)
			 Version					    NUMBER(4,2)
			 WorkflowStatus 				    VARCHAR2(20)
			 ContextName					    VARCHAR2(30)
			 DisplayOrder					    NUMBER
			
			SQL> 
			*/
			rset = stmt.executeQuery();
			int rowcount = 0;
			while (rset.next()) {
				System.out.println("************************************** start ROW " + ++rowcount + " **************************************");
				array1 = rset.getArray(1);
				nestedRs1 = array1.getResultSet();
				array2 = rset.getArray(2);
				nestedRs2 = array2.getResultSet();
				array3 = /*rset.getArray(3); //cause oracle.sql.STRUCT cannot be cast to oracle.sql.ARRAY */  ((oracle.sql.STRUCT)rset.getObject(3));
				
///*
				while (nestedRs1.next())
				{ 
					System.out.println("************************************** start CONCEPT_DETAIL_T " + rowcount + " **************************************");
					//System.out.println("Current value[0] = [" + nestedRs.getObject(1) + "]");
					//System.out.println("Current value[1] = [" + nestedRs.getObject(2) + "]");
					try {
						s1 = (oracle.sql.STRUCT) nestedRs1.getObject(2);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				  
				  if (s1 != null) 
				  { 
				    String sqlname = s1.getSQLTypeName(); 
					Datum[] attrs = s1.getOracleAttributes();
			
				    if (sqlname.equals ("SBREXT.CONCEPT_DETAIL_T"))
				    { 
					      System.out.println ("PREFERRED_NAME=" + AdministeredItemUtil.handleSpecialCharacters((attrs[0].getBytes())));
					      System.out.println ("LONG_NAME=" + AdministeredItemUtil.handleSpecialCharacters((attrs[1].getBytes())));
					      System.out.println ("CON_ID=" + attrs[2].intValue());
				    }
				    else 
				      throw new Exception ("Invalid type name: "+sqlname + " in parent");
				  }
					System.out.println("************************************** end CONCEPT_DETAIL_T " + rowcount + " **************************************");
				}
//*/

///*
				while (nestedRs2.next())
				{
					System.out.println("************************************** start VALID_VALUE_T " + rowcount + " **************************************");
					//System.out.println("Current value[0] = [" + nestedRs.getObject(1) + "]");
					//System.out.println("Current value[1] = [" + nestedRs.getObject(2) + "]");
					try {
						s2 = (oracle.sql.STRUCT) nestedRs2.getObject(2);	//cause "java.sql.SQLException: ORA-01403: no data found" for empty VALID_VALUE_LIST_T
					} catch (Exception e) {
						//e.printStackTrace();
						System.out.println("Error while retriving VALID_VALUE_T, error was = [" + e.getMessage() + "]");
					}

				  
				  if (s2 != null) 
				  { 
				    String sqlname = s2.getSQLTypeName(); 
					Datum[] attrs = s2.getOracleAttributes();

				    if (sqlname.equals ("SBREXT.VALID_VALUE_T"))
				    {
					      System.out.println ("VALIDVALUE=" + AdministeredItemUtil.handleSpecialCharacters(attrs[0].getBytes()));
					      System.out.println ("PVBEGINDATE=" + attrs[4].dateValue());
					      System.out.println ("VMPUBLICID=" + attrs[6].intValue());
				    }
				    else 
				      throw new Exception ("Invalid type name: "+sqlname + " in parent");
				  }				  
					System.out.println("************************************** end VALID_VALUE_T " + rowcount + " **************************************");
				}
	
//				while (nestedRs3.next())
			  if (array3 != null) 
			  {
					System.out.println("************************************** start DERIVED_DATA_ELEMENT_T " + rowcount + " **************************************");
					//TEST SQL:
					/*
					SELECT DE_DERIVATION FROM CDE_EXCEL_GENERATOR_VIEW where "DE Public ID" = 2341940;
					*/
					String sqlname = array3.getSQLTypeName();

				    if (sqlname.equals ("SBREXT.DERIVED_DATA_ELEMENT_T"))
				    {
						Datum[] valueDatum = array3.getOracleAttributes();
						String[] values = new String[valueDatum.length];
						for (int a = 0; a < valueDatum.length; a++) {
							if (valueDatum[a] != null) {
								Class c = valueDatum[a].getClass();
								if(c.getName().equals("oracle.sql.CHAR")) {
									values[a]= new String(valueDatum[a].getBytes());	//valueDatum[a].toString();	//should not do toString(), it will cause "???" in the value!
									System.out.println("Current colum type = [" + c.getName() + "]");
//									System.out.println("Current colum name = [" + c.getCanonicalName() + "]");	//TBD not sure how to get the column name
									System.out.println("Current value[" + a + "] = [" + values[a] + "]");
									System.out.println("--- end of column ---");
								} else {
									System.out.println ("what are you my child=" + valueDatum[a]);
									if(c.getName().equals("oracle.sql.ARRAY")) {
										int childCount = 0;
										array3_1 = ((oracle.sql.ARRAY)valueDatum[a]);
										nestedRs3_1 = array3_1.getResultSet();
										while (nestedRs3_1.next())
										{ 
											System.out.println("************************************** start DATA_ELEMENT_DERIVATION_LIST_T " + rowcount + " **************************************");
											//System.out.println("Current value[0] = [" + nestedRs.getObject(1) + "]");
											//System.out.println("Current value[1] = [" + nestedRs.getObject(2) + "]");
											try {
												s3_1 = (oracle.sql.STRUCT) nestedRs3_1.getObject(2);
											} catch (Exception e) {
												// TODO Auto-generated catch block
												e.printStackTrace();
											}
										  
										  if (s3_1 != null) 
										  { 
										    String sqlname3_1 = s3_1.getSQLTypeName(); 
											Datum[] attrs = s3_1.getOracleAttributes();
									
										    if (sqlname3_1.equals ("SBREXT.DATA_ELEMENT_DERIVATION_T"))
										    { 
										    	childCount++;
											  System.out.println ("PublicId=" + attrs[0].intValue());
											  System.out.println ("LongName=" + AdministeredItemUtil.handleSpecialCharacters((attrs[1].getBytes())));
											  System.out.println ("PreferredName=" + AdministeredItemUtil.handleSpecialCharacters((attrs[2].getBytes())));
											  System.out.println ("PreferredDefinition=" + AdministeredItemUtil.handleSpecialCharacters((attrs[3].getBytes())));
											  System.out.println ("Version=" + attrs[4].intValue());
											  System.out.println ("WorkflowStatus=" + AdministeredItemUtil.handleSpecialCharacters((attrs[5].getBytes())));
											  System.out.println ("ContextName=" + AdministeredItemUtil.handleSpecialCharacters((attrs[6].getBytes())));
											  System.out.println ("DisplayOrder=" + attrs[7].intValue());
												System.out.println("************************************** child " + childCount + " of DATA_ELEMENT_DERIVATION_LIST_T " + rowcount + " **************************************");
										    }
										    else 
										      throw new Exception ("Invalid type name: "+sqlname + " in child");
										  }
										System.out.println("************************************** end DATA_ELEMENT_DERIVATION_LIST_T " + rowcount + " **************************************");
										}
									} else {
										System.out.println ("what are you my child=" + valueDatum[a]);
									}
								}
							} else {
								System.out.println("Current value[" + a + "] is NULL or empty.");
								System.out.println("--- end of column ---");
							}
						}
				    }
				    else 
				      throw new Exception ("Invalid type name: "+sqlname + " in parent");

				    System.out.println("************************************** end DERIVED_DATA_ELEMENT_T " + rowcount + " **************************************");
//				}
				System.out.println("************************************** end ROW " + rowcount + " **************************************");
			}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally { 
			try {
				rset.close ();
				stmt.close (); 
				m_conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public static void connectDB(String username, String password) {
		try {
			//DO NOT HARD CODE the user/password and check in SVN/Git please!
			setConn(TestUtil.getConnection(username, password));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) {
		connectDB(args[0], args[1]);
		TestSpreadsheetDownload download = new TestSpreadsheetDownload();
		download.setColHeadersAndTypes("CDE");
		ArrayList<String[]> downloadRows = download.getRecords(false, false);
		download.createDownloadColumns(downloadRows);
	}

	//=======================================================================
	
	public void get_m_conn() {
		// get the connection
		if (m_conn == null) {
			m_conn = connectDB1();
			setConn(m_conn);
		}
	}

	//=======================================================================
	
	/**
	 * @param ub_
	 * @return Connection
	 */
	public Connection connectDB1() {
		Connection SBRDb_conn = null;
		try {
			try {
				SBRDb_conn = this.getConnFromDS();
			} catch (Exception e) {
				logger.error("Servlet error: no pool connection.", e);
			}
		} catch (Exception e) {
			logger.error("Servlet connectDB : " + e.toString(), e);
		}
		return SBRDb_conn;
	}

	//=======================================================================
	
	/**
	 * Start in the /conf/template.cdecurate-oracle-ds.xml file. Notice the
	 * <jndi-name>. This name is used by JBoss to create and identify the
	 * connection pool. We copied this name to the /conf/template.web.xml file
	 * in the <param-value> element. The <param-name> for this initialization
	 * value appears in the code NCICurationServlet.initOracleConnect() method.
	 * The data source pool name is then saved in a class variable
	 * "_dataSourceName". * The variable is used by the
	 * CurationServlet.getConnFromDS() method which is used by the
	 * CurationServlet.connectDB() method.
	 * 
	 * @return
	 */
	public Connection getConnFromDS() {
		// Use tool database pool.
		Context envContext = null;
		DataSource ds = null;
		String user_;
		String pswd_;
		try {
			envContext = new InitialContext();
			ds = (DataSource) envContext.lookup("jdbc/CDECurateDS");
			user_ = "cdebrowser";
			pswd_ = "cdeuser";
		} catch (Exception e) {
			String stErr = "Error creating database pool[" + e.getMessage()
					+ "].";
			logger.fatal(stErr, e);
			return null;
		}
		// Open connection
		Connection con = null;
		try {
			con = ds.getConnection(user_, pswd_);
		} catch (Exception e) {
			logger.fatal("Could not open database connection.", e);
			return null;
		}
		return con;
	}

	//=======================================================================
	
	/**
	 * @return the m_conn
	 */
	public Connection getConn() {
		return m_conn;

	}

	//=======================================================================
	
	/**
	 * @param m_conn
	 *            the m_conn to set
	 */
	public static void setConn(Connection conn) {
		m_conn = conn;
	}

	//=======================================================================
	
	private void setColHeadersAndTypes(String type) {
		String sList = new String();
		PreparedStatement ps = null;
		ResultSet rs = null;

		if (sList == "")
			sList = "CDE_IDSEQ,DEC_IDSEQ,VD_IDSEQ,Conceptual Domain Public ID,Conceptual Domain Short Name,Conceptual Domain Version,Conceptual Domain Context Name";

		ArrayList<String> excluded = new ArrayList<String>();

		for (String col : sList.split(",")) {
			excluded.add(col);
		}

		try {
			String qry = "SELECT * FROM " + type
					+ "_EXCEL_GENERATOR_VIEW where 1=2";
			ps = getConn().prepareStatement(qry);
//			Object[] inputValues = new Object[columnNames.length];
//		    inputValues[0] = new java.math.BigDecimal(100);
//		    inputValues[1] = new String("String Value");
//		    inputValues[2] = new String("This is my resume.");
//		    inputValues[3] = new Timestamp((new java.util.Date()).getTime());
//
//		    // prepare blob object from an existing binary column
//		    String insert = "insert into resume (id, name, content, date_created ) values(?, ?, ?, ?)";
//		    pstmt = conn.prepareStatement(insert);
//
//		    pstmt.setObject(1, inputValues[0]);
//		    pstmt.setObject(2, inputValues[1]);
//		    pstmt.setObject(3, inputValues[2]);
//		    pstmt.setObject(4, inputValues[3]);
		    
			rs = ps.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			int numColumns = rsmd.getColumnCount();
			// Get the column names and types; column indices start from 1
			for (int i = 1; i < numColumns + 1; i++) {
				String columnName = rsmd.getColumnName(i);
				columnName = prettyName(columnName);
				columnHeaders.add(columnName);

				String columnType = rsmd.getColumnTypeName(i);

				if (columnType.endsWith("_T")
						&& !typeMap.containsKey(columnType)) {
					String typeKey = i + ":" + columnType;

					columnTypes.add(typeKey);
					ArrayList<String[]> typeBreakdown = getType(typeKey,
							columnName, type);
					typeMap.put(i + ":" + columnType, typeBreakdown);

					if (typeBreakdown.size() > 0) {
						String[] typeColNames = typeBreakdown.get(0);

						String[] orderedTypeColNames = getOrderedTypeNames(
								typeKey, columnName, type);
						for (int c = 0; c < orderedTypeColNames.length; c++) {
							arrayColumnTypes.put(typeColNames[c], typeKey);
							allExpandedColumnHeaders
									.add(orderedTypeColNames[c]); 
						}
					} else
						allExpandedColumnHeaders.add(columnName);

				} else {
					columnTypes.add(columnType);
					allExpandedColumnHeaders.add(columnName);
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (Exception e) {
				}
			if (ps != null)
				try {
					ps.close();
				} catch (Exception e) {
				}
		}
	}

	//=======================================================================
	
	private String prettyName(String name) {

		if (name.startsWith("DE "))
			return name.replace("DE ", "Data Element ");
		else if (name.startsWith("DEC "))
			return name.replace("DEC ", "Data Element Concept ");
		else if (name.startsWith("VD "))
			return name.replace("VD ", "Value Domain ");
		else if (name.startsWith("OC "))
			return name.replace("OC ", "Object Class ");
		else if (name.startsWith("CD "))
			return name.replace("CD ", "Conceptual Domain ");

		return name;
	}

	//=======================================================================
	
	private ArrayList<String[]> getType(String type, String name,
			String download) {

		ArrayList<String[]> colNamesAndTypes = new ArrayList<String[]>();

		ArrayList<String> attrName = new ArrayList<String>();
		ArrayList<String> attrTypeName = new ArrayList<String>();

		PreparedStatement ps = null;
		ResultSet rs = null;
		String sqlStmt = "select * from sbrext.custom_download_types c where UPPER(c.type_name) = ? order by c.column_index";
		String[] splitType = type.split("\\.");
		
		type = splitType[1];

		try {
			ps = getConn().prepareStatement(sqlStmt);
			ps.setString(1, type);
			rs = ps.executeQuery();
			int i = 0;
			while (rs.next()) {
				i++;
				String col = rs.getString("DISPLAY_NAME");
				String ctype = rs.getString("DISPLAY_TYPE");
				if (type.toUpperCase().contains("CONCEPT")) {
					if (name.toUpperCase().startsWith("REP"))
						name = "Representation Concept";
					else if (name.toUpperCase().startsWith("VD"))
						name = "Value Domain Concept";
					else if (name.toUpperCase().startsWith("OC"))
						name = "Object Class Concept";
					else if (name.startsWith("PROP"))
						name = "Property Concept";

					col = name + " " + col;
				}
				if (type.toUpperCase().contains("DESIGNATION")) {
					if (download.equals("CDE"))
						download = "Data Element";
					else if (download.equals("VD"))
						download = "Value Domain";
					else if (download.equals("DEC"))
						download = "Data Element Concept";

					col = download + " " + col;
				}

				attrName.add(col);
				attrTypeName.add(ctype);
			}
			// System.out.println(type + " "+i);
			rs.close();
			ps.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		String[] attrNames = new String[attrName.size()];
		String[] attrTypeNames = new String[attrTypeName.size()];

		for (int i = 0; i < attrName.size(); i++) {
			attrNames[i] = attrName.get(i);
			attrTypeNames[i] = attrTypeName.get(i);
		}
		colNamesAndTypes.add(attrNames);
		colNamesAndTypes.add(attrTypeNames);

		return colNamesAndTypes;
	}

	//=======================================================================
	
	private String[] getOrderedTypeNames(String type, String name,
			String download) {

		ArrayList<String> attrName = new ArrayList<String>();

		PreparedStatement ps = null;
		ResultSet rs = null;
		String sqlStmt = "select * from sbrext.custom_download_types c where UPPER(c.type_name) = ? order by c.display_column_index";
		String[] splitType = type.split("\\.");

		type = splitType[1];

		try {
			ps = getConn().prepareStatement(sqlStmt);
			ps.setString(1, type);
			rs = ps.executeQuery();
			int i = 0;
			while (rs.next()) {
				i++;
				String col = rs.getString("DISPLAY_NAME");
				String ctype = rs.getString("DISPLAY_TYPE");
				if (type.toUpperCase().contains("CONCEPT")) {
					if (name.toUpperCase().startsWith("REP"))
						name = "Representation Concept";
					else if (name.toUpperCase().startsWith("VD"))
						name = "Value Domain Concept";
					else if (name.toUpperCase().startsWith("OC"))
						name = "Object Class Concept";
					else if (name.startsWith("PROP"))
						name = "Property Concept";

					col = name + " " + col;
				}
				if (type.toUpperCase().contains("DESIGNATION")) {
					if (download.equals("CDE"))
						download = "Data Element";
					else if (download.equals("VD"))
						download = "Value Domain";
					else if (download.equals("DEC"))
						download = "Data Element Concept";

					col = download + " " + col;
				}

				attrName.add(col);
			}
			// System.out.println(type + " "+i);
			rs.close();
			ps.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		String[] attrNames = new String[attrName.size()];

		for (int i = 0; i < attrName.size(); i++) {
			attrNames[i] = attrName.get(i);

		}
		return attrNames;

	}

	//=======================================================================
	
	private ArrayList<String[]> getRecords(boolean full, boolean restrict) {

		ArrayList<String[]> rows = new ArrayList<String[]>();

		ResultSet rs = null;
		PreparedStatement ps = null;
		try {
			if (getConn() == null) {
				logger.error("Cannot get DB Connection");
			} else {
				int rowNum = 0;
				List<String> sqlStmts = getSQLStatements(full, restrict);
				for (String sqlStmt : sqlStmts) {
					ps = getConn().prepareStatement(sqlStmt);
					rs = ps.executeQuery();

					ResultSetMetaData rsmd = rs.getMetaData();
					int numColumns = rsmd.getColumnCount();

					while (rs.next()) {
						String[] row = new String[numColumns];
						HashMap<String, List<String[]>> typeArrayData = null;

						for (int i = 0; i < numColumns; i++) {
							if (columnTypes.get(i).endsWith("_T")) {
								List<String[]> rowArrayData = getRowArrayData(
										rs, columnTypes.get(i), i);

								if (typeArrayData == null) {
									typeArrayData = new HashMap<String, List<String[]>>();
								}
								typeArrayData.put(columnTypes.get(i),
										rowArrayData);
							} else {
								 //truncate timestamp
								if (columnTypes.get(i).equalsIgnoreCase("Date")) {
									row[i] = AdministeredItemUtil
											.truncateTime(rs.getString(i + 1));
								} else {
									row[i] = rs.getString(i + 1);	//??? getString() even for STRUCT ???
								}
								// System.out.println("rs.getString(i+1) = " +
								// rs.getString(i+1));
							}
						}
						// If there were no arrayData added, add null to keep
						// parity with rows.
						if (typeArrayData == null) {
							arrayData.add(null);
						} else {
							arrayData.add(rowNum, typeArrayData);
						}

						rows.add(row);
						rowNum++;
					}
				}

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (Exception e) {
				}
			if (ps != null)
				try {
					ps.close();
				} catch (Exception e) {
				}
		}

		return rows;
	}

	//=======================================================================
	
	private Sheet fillInBump(Sheet sheet, int originalRow, int rownum,
			int bump, ArrayList<String[]> allRows, ArrayList<String> allTypes,
			int[] colIndices) {
		String temp = null;
		for (int a = rownum; a < rownum + bump; a++) {
			Row row = sheet.getRow(a);

			for (int j = 0; j < colIndices.length; j++) {

				String currentType = allTypes.get(colIndices[j]);
				if (currentType.endsWith("_T")) {
					// Do nothing
				} else {
					Cell cell = row.createCell(j);
					temp = allRows.get(originalRow)[colIndices[j]];
					logger.debug("at line 481 of TestSpreadsheetDownload.java*****"
							+ temp + currentType);
					if (currentType.equalsIgnoreCase("Date")) { 
						temp = AdministeredItemUtil.truncateTime(temp);
					}
					cell.setCellValue(temp);
				}

			}
		}
		return sheet;
	}

	//=======================================================================
	//*** REPLACE THIS METHOD with the real on in CustomDownloadServlet!!! ***
	private List<String[]> getRowArrayData(ResultSet rs, String columnType, int index) throws Exception{
		List<String[]> rowArrayData = new ArrayList<String[]>();
		Array array = null;
		//Special case: first row has info on derivation, others on data elements
		if (columnType.indexOf("DERIVED") > 0) {
			Object derivedObject = rs.getObject(index+1);
			STRUCT struct = (STRUCT) derivedObject;
			Datum[] valueStruct = struct.getOracleAttributes();
			//Fifth entry is the array with DE's 
			array = (Array) valueStruct[5];

			if (array != null){
				String[] derivationInfo = new String[5];
				for (int z = 0; z < 5; z++){
					if (valueStruct[z] != null) {
						Class c = valueStruct[z].getClass();
						String s = c.getName();
						if (c.getName().toUpperCase().contains("NUMBER")) { 
							derivationInfo[z] = Integer.toString(valueStruct[z].intValue()); 
						}else if (c.getName().toUpperCase().contains("DATE")) {
							derivationInfo[z] = valueStruct[z].dateValue().toString();
							derivationInfo[z] = AdministeredItemUtil.truncateTime(derivationInfo[z]);
						} else{
							derivationInfo[z] = AdministeredItemUtil.handleSpecialCharacters(valueStruct[z].getBytes());
						}
//					derivationInfo[z] =(valueStruct[z] != null)? valueStruct[z].toString(): "";
					}
				}
					logger.debug("At line 272 of CustomDownloadServlet.java" +"****" + Arrays.asList(derivationInfo));
					rowArrayData.add(derivationInfo);

					ResultSet nestedRs = array.getResultSet(); 

					while (nestedRs.next()) {
						STRUCT deStruct = (STRUCT) nestedRs.getObject(2);
						Datum[] valueDatum = deStruct.getOracleAttributes();
						String[] values = new String[valueDatum.length];

						for (int a = 0; a < valueDatum.length; a++) {
							if (valueDatum[a] != null) {
								Class c = valueDatum[a].getClass();
								String s = c.getName();
								if (c.getName().toUpperCase().contains("NUMBER")) { 
									values[a] = Integer.toString(valueDatum[a].intValue()); 
								}else if (c.getName().toUpperCase().contains("DATE")) {
									values[a] = valueDatum[a].dateValue().toString();
									values[a] = AdministeredItemUtil.truncateTime(values[a]);
								} else{
									values[a] = AdministeredItemUtil.handleSpecialCharacters(valueDatum[a].getBytes());
								}
//								values[a]= valueDatum[a].toString();	
							} 
						}
						logger.debug("At line 297 of CustomDownloadServlet.java" +"****" + Arrays.asList(values));
						rowArrayData.add(values);
					}
			}
		} else {
			array = rs.getArray(index+1);
			if (array != null) {
				ResultSet nestedRs = array.getResultSet(); 

				while (nestedRs.next()) {
					STRUCT valueStruct = (STRUCT) nestedRs.getObject(2); //GF30779
					Datum[] valueDatum = valueStruct.getOracleAttributes(); //GF30779
					String[] values = new String[valueDatum.length];
					int slide = 0;
					for (int a = 0; a < valueDatum.length; a++) {
						if (valueDatum[a] != null) {
							Class c = valueDatum[a].getClass();
							String s = c.getName();
							String truncatedTimeStamp = null; //GF30799

							if (c.getName().toUpperCase().contains("STRUCT")) {
								STRUCT str = (STRUCT) valueDatum[a]; //GF30779
								Datum[] strValues = str.getOracleAttributes(); //GF30779
								logger.debug("At line 298 of CustomDownloadServlet.java" +"***" + Arrays.asList(strValues)+ "****" + Arrays.asList(str.getAttributes()));
								values = new String[valueDatum.length+strValues.length-1]; 
								slide = -1;
								for (int b = 0; b < strValues.length; b++){
									if (strValues[b] != null) {
										Class structClass = strValues[b].getClass();
										String className = structClass.getName();
//									truncatedTimeStamp = strValues[b].toString(); //begin GF30779
//									logger.debug("At line 299 of CustomDownloadServlet.java" + truncatedTimeStamp);
										 if (className.toUpperCase().contains("NUMBER")) { //GF30779======START
											 truncatedTimeStamp = Integer.toString(strValues[b].intValue());	//caused java.sql.SQLException: Conversion to integer failed
										}else if (className.toUpperCase().contains("DATE")) {
											truncatedTimeStamp = strValues[b].dateValue().toString();
											truncatedTimeStamp = AdministeredItemUtil.truncateTime(truncatedTimeStamp);
										} else  {
											truncatedTimeStamp = AdministeredItemUtil.handleSpecialCharacters(strValues[b].getBytes()); 
										}//GF30779=============END
//									truncatedTimeStamp = AdministeredItemUtil.handleSpecialCharacters(strValues[b].getBytes()); // GF30779
									logger.debug("At line 316 of CustomDownloadServlet.java" + "***" + truncatedTimeStamp + "***" + className + "***" + valueDatum[a]+ "***" + strValues[b]);
//									if (columnType.contains("VALID_VALUE") && truncatedTimeStamp != null && truncatedTimeStamp.contains(":")) {
//										truncatedTimeStamp = AdministeredItemUtil.truncateTime(truncatedTimeStamp);
//										logger.debug("At line 304 of CustomDownloadServlet.java" + truncatedTimeStamp);
//									} //end GF30779
									values[b] = truncatedTimeStamp;
									slide++;
								}
								}
							} else {
								if (c.getName().toUpperCase().contains("NUMBER")) { //GF30779===START
									truncatedTimeStamp = Integer.toString(valueDatum[a].intValue()); 
								}else if (c.getName().toUpperCase().contains("DATE")) {
									truncatedTimeStamp = valueDatum[a].dateValue().toString();
									truncatedTimeStamp = AdministeredItemUtil.truncateTime(truncatedTimeStamp);
								} else{
									truncatedTimeStamp = AdministeredItemUtil.handleSpecialCharacters(valueDatum[a].getBytes());
								}//GF30779=============END
//								truncatedTimeStamp = valueDatum[a].toString(); //begin GF30779
								logger.debug("At line 335 of CustomDownloadServlet.java" +"****" + truncatedTimeStamp +"*****" + s);
//								truncatedTimeStamp = AdministeredItemUtil.toASCIICode(truncatedTimeStamp); // GF30779
//								logger.debug("At line 313 of CustomDownloadServlet.java" + truncatedTimeStamp + s + valueDatum[a]);
//								if (columnType.contains("VALID_VALUE") && truncatedTimeStamp != null && truncatedTimeStamp.contains(":")) {
//									truncatedTimeStamp = AdministeredItemUtil.truncateTime(truncatedTimeStamp);
//									logger.debug("At line 316 of CustomDownloadServlet.java" + truncatedTimeStamp);
//								} //end GF30779
								values[a+slide]= truncatedTimeStamp;
							}

						} else {
							values[a]= "";
						}	
					}
					rowArrayData.add(values);
				}
			}
		}
		return rowArrayData;
	}
	//=======================================================================
	
	private List<String> getSQLStatements(boolean full, boolean restrict) {
		List<String> sqlStmts = new ArrayList<String>();
		ArrayList<String> downloadIDs = new ArrayList<String>();
		//useful SQL
		/*
		SELECT 
		CDE_IDSEQ,
		--OC_CONCEPTS, VALID_VALUES,
		DE_DERIVATION 
		FROM CDE_EXCEL_GENERATOR_VIEW
		where
		--CDE_IDSEQ = 'C67194F6-BFC9-53D6-E034-0003BA12F5E7'
		"DE Public ID" = 2341940
		*/
//		downloadIDs.add("C67194F6-BFC9-53D6-E034-0003BA12F5E7"); // CDE_IDSEQ of DE with Long name is DNA Index Value and Public ID is 64516
		downloadIDs.add("FCF89106-22D3-2D93-E034-0003BA3F9857"); // CDE_IDSEQ of DE with Long name is DNA Index Value and Public ID is 2341940
//		+ "\"DE Public ID\" = 3124888"	//test case for ORA-01403: no data found" 
//		+ "\"DE Public ID\" = 2341940"	//get by entering *derived* in DE search based on Name and Def
		
		String type = "CDE";

		String sqlStmt = null;
		if (!full) {
			StringBuffer[] whereBuffers = getWhereBuffers(downloadIDs);
			for (StringBuffer wBuffer : whereBuffers) {
				sqlStmt = "SELECT * FROM " + type + "_EXCEL_GENERATOR_VIEW "
						+ "WHERE " + type + "_IDSEQ IN " + " ( "
						+ wBuffer.toString() + " )  ";
				if (restrict) {
					sqlStmt += " and ROWNUM <= " + GRID_MAX_DISPLAY;
					sqlStmts.add(sqlStmt);
					break;
				} else {
					sqlStmts.add(sqlStmt);
				}
			}
		} else {
			sqlStmt = "SELECT * FROM " + type + "_EXCEL_GENERATOR_VIEW";
			if (restrict)
				sqlStmt += " where ROWNUM <= " + GRID_MAX_DISPLAY;

			sqlStmts.add(sqlStmt);
		}

		return sqlStmts;
	}

	//=======================================================================
	
	private StringBuffer[] getWhereBuffers(ArrayList<String> downloadIds) {
		StringBuffer whereBuffer = null;
		List<StringBuffer> whereBuffers = null;

		if (downloadIds.size() <= 1000) { // make sure that there are no more
											// than 1000 ids in each 'IN' clause
			whereBuffer = new StringBuffer();
			for (String id : downloadIds) {
				whereBuffer.append("'" + id + "',");
			}
			whereBuffer.deleteCharAt(whereBuffer.length() - 1);
		} else {
			whereBuffers = new ArrayList<StringBuffer>();
			int counter = 0;
			whereBuffer = new StringBuffer();

			for (String id : downloadIds) {
				whereBuffer.append("'" + id + "',");

				counter++;

				if (counter % 1000 == 0) {
					whereBuffer.deleteCharAt(whereBuffer.length() - 1);
					whereBuffers.add(whereBuffer);
					whereBuffer = new StringBuffer();
				}
			}

			// add the final chunk to the list
			if (whereBuffer.length() > 0) {
				whereBuffer.deleteCharAt(whereBuffer.length() - 1);
				whereBuffers.add(whereBuffer);
			}
		}

		if (whereBuffers == null) {
			whereBuffers = new ArrayList<StringBuffer>(1);
			whereBuffers.add(whereBuffer);
		}

		return whereBuffers.toArray(new StringBuffer[0]);
	}

	//=======================================================================
	
	private void createDownloadColumns(ArrayList<String[]> allRows) {
		final int MAX_ROWS = 65000;

		String sheetName = "Custom Download";
		int sheetNum = 1;
		String fillIn = "true";
		String[] columns = null;
		
			ArrayList<String> defaultHeaders = new ArrayList<String>();

			for (String cName : allExpandedColumnHeaders) {
				if (cName.endsWith("IDSEQ") || cName.startsWith("CD ")
						|| cName.startsWith("Conceptual Domain")) { /* skip */
				} else {
					System.out.println("cName = " + cName);
					defaultHeaders.add(cName);
				}
			}
			columns = defaultHeaders.toArray(new String[defaultHeaders.size()]);

		int[] colIndices = new int[columns.length];
		for (int i = 0; i < columns.length; i++) {
			String colName = columns[i];
			if (columnHeaders.indexOf(colName) < 0) {
				String tempType = arrayColumnTypes.get(colName);
				int temp = columnTypes.indexOf(tempType);
				colIndices[i] = temp;
			} else {
				int temp = columnHeaders.indexOf(colName);
				colIndices[i] = temp;
			}
		}

		Workbook wb = new HSSFWorkbook();

		Sheet sheet = wb.createSheet(sheetName);
		Font font = wb.createFont();
		font.setBoldweight(Font.BOLDWEIGHT_BOLD);
		CellStyle boldCellStyle = wb.createCellStyle();
		boldCellStyle.setFont(font);
		boldCellStyle.setAlignment(CellStyle.ALIGN_GENERAL);

		Row headerRow = sheet.createRow(0);
		headerRow.setHeightInPoints(12.75f);
		String temp;
		for (int i = 0; i < columns.length; i++) {
			Cell cell = headerRow.createCell(i);
			temp = columns[i];
			cell.setCellValue(temp);
			cell.setCellStyle(boldCellStyle);
		}

		// freeze the first row
		sheet.createFreezePane(0, 1);

		Row row = null;
		Cell cell;
		int rownum = 1;
		int bump = 0;
		int i = 0;
		try {
			System.out.println("Total CDEs to download [" + allRows.size()
					+ "]");
			for (i = 0; i < allRows.size(); i++, rownum++) {
				// Check if row already exists
				int maxBump = 0;
				if (sheet.getRow(rownum + bump) == null) {
					row = sheet.createRow(rownum + bump);
				}

				if (allRows.get(i) == null)
					continue;

				for (int j = 0; j < colIndices.length; j++) {

					cell = row.createCell(j);
					String currentType = columnTypes.get(colIndices[j]);
					if (currentType.endsWith("_T")) {
						// Deal with CS/CSI
						String[] originalArrColNames = typeMap.get(currentType)
								.get(0);

						// Find current column in original data

						int originalColumnIndex = -1;
						for (int a = 0; a < originalArrColNames.length; a++) {
							if (columns[j].equals(originalArrColNames[a])) {
								originalColumnIndex = a;
								break;
							}
						}
						// ArrayList<HashMap<String,ArrayList<String[]>>>
						// arrayData1 =
						// (ArrayList<HashMap<String,ArrayList<String[]>>>)arrayData;
						HashMap<String, List<String[]>> typeArrayData = arrayData
								.get(i);
						ArrayList<String[]> rowArrayData = (ArrayList<String[]>) typeArrayData
								.get(currentType);

						if (rowArrayData != null) {
							int tempBump = 0;
							for (int nestedRowIndex = 0; nestedRowIndex < rowArrayData
									.size(); nestedRowIndex++) {

								String[] nestedData = rowArrayData
										.get(nestedRowIndex);
								String data = "";
								if (currentType.contains("DERIVED")) {
									// Derived data element is special double
									// nested, needs to be modified to be more
									// general.

									// General DDE information is in the first 4
									// columns, but contained in the first row
									// of the Row Array Data
									if (originalColumnIndex < 5) {
										if (nestedRowIndex == 0)
											data = (originalColumnIndex > 0) ? nestedData[originalColumnIndex]
													: nestedData[originalColumnIndex + 1]; 
									} else {
										if (nestedRowIndex + 1 < rowArrayData
												.size()) {
											data = rowArrayData
													.get(nestedRowIndex + 1)[originalColumnIndex - 5];
										}
									}

								} else
									data = nestedData[originalColumnIndex];
								logger.debug("at line 828 of TestSpreadsheetDownload.java*****"
										+ data + currentType);
								if (currentType.contains("VALID_VALUE")) { 
									data = AdministeredItemUtil
											.truncateTime(data);
								}
								cell.setCellValue(data);

								tempBump++;

								if (nestedRowIndex < rowArrayData.size() - 1) {
									row = sheet
											.getRow(rownum + bump + tempBump);
									if (row == null) {
										if (rownum + bump + tempBump >= MAX_ROWS) {
											sheet = wb.createSheet(sheetName
													+ "_" + sheetNum);
											sheetNum++;
											rownum = 1;
											bump = 0;
											tempBump = 0;
										}
										row = sheet.createRow(rownum + bump
												+ tempBump);
									}

									cell = row.createCell(j);

								} else {
									// Go back to top row
									row = sheet.getRow(rownum + bump);
									if (tempBump > maxBump)
										maxBump = tempBump;
								}
							}
						}
					} else {
						temp = allRows.get(i)[colIndices[j]];
						logger.debug("at line 866 of TestSpreadsheetDownload.java*****"
								+ temp + currentType);
						if (currentType.equalsIgnoreCase("Date")) {
							temp = AdministeredItemUtil.truncateTime(temp);
						}
						cell.setCellValue(temp);
					}

				}

				bump = bump + maxBump;

				if (fillIn != null
						&& (fillIn.equals("true") || fillIn.equals("yes")
								&& bump > 0)) {
					sheet = fillInBump(sheet, i, rownum, bump, allRows,
							columnTypes, colIndices);
					rownum = rownum + bump;
					bump = 0;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			// Please specify the path below if needed, otherwise it will create in the root/dir where this test class is run
			fileOutputStream = new FileOutputStream("Test_Excel.xls");
			wb.write(fileOutputStream);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			/**
			 * Close the fileOutputStream.
			 */
			try {
				if (fileOutputStream != null) {
					fileOutputStream.close();
				}
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
	}
	
	//=======================================================================
}
