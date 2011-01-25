package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.OutputStream;
import java.sql.Array;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Struct;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.Vector;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.lucene.search.ReqExclScorer;
import org.apache.poi.POIDocument;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.util.SystemOutLogger;
import org.codehaus.jettison.json.JSONObject;

public class CustomDownloadServlet extends CurationServlet {

	 public static final Logger logger = Logger.getLogger(CustomDownloadServlet.class.getName());

	 public CustomDownloadServlet() {
		}

	public CustomDownloadServlet(HttpServletRequest req, HttpServletResponse res,
				ServletContext sc) {
			super(req, res, sc);
		}
    
	public void execute(ACRequestTypes reqType) throws Exception {	

			switch (reqType){
			case showDEfromSearch:
				prepDisplayPage("DE"); 
				break;
			case jsonRequest:
				returnJSONFromSession("Return");
				break;
			case jsonLayout:
				returnJSONFromSession("Layout");
				break;
			case cdlColumns:
				createDownloadColumns();
				break;
			case createExcelDownload:
				createDownload();
				break;
			case showVDfromSearch:
				prepDisplayPage("VD");; 
				break;
		}	
			
	}
	
	private void prepDisplayPage(String type) {
		
		//Set of all param names, this will have CK (checked) indexes indicating which Search ID is checked.
		Set<String> paramNames = this.m_classReq.getParameterMap().keySet();
		Vector<String> searchID= (Vector<String>) this.m_classReq.getSession().getAttribute("SearchID");
		StringBuffer whereBuffer = new StringBuffer();
		ArrayList<String> downloadID = new ArrayList<String>();
		
		for(String name:paramNames) {
			if (name.startsWith("CK")) {
				int ndx = Integer.valueOf(name.substring(2));
				downloadID.add(searchID.get(ndx));
			}
		}
		
		/*		
		Enumeration<String> attNames = this.m_classReq.getSession().getAttributeNames();
		
		System.out.println("******Session Attributes**************");
		
		while (attNames.hasMoreElements()) {
			String name = attNames.nextElement();
			System.out.print("Name: "+name);
			System.out.println("  Value: " + this.m_classReq.getSession().getAttribute(name));
		}
		*/

		
		 ResultSet rs = null;
	     PreparedStatement ps = null;
	     try
	        {
	    	 	if (getConn() == null)
	                ErrorLogin(m_classReq, m_classRes);
	            else
	            {
	            	boolean first = true;
	        		for (String id:downloadID) {
	        			
	        			if (first) {
	        				whereBuffer.append("'" + id + "'");

	        				first = false;
	        			}
	        			else
	        			{
	        				whereBuffer.append(",'" + id + "'");
	        			}
	        		}
	        		
	        		String sqlStmt =
	        			"SELECT * FROM "+type+"_EXCEL_GENERATOR_VIEW " + "WHERE "+type+"_IDSEQ IN " +
	        			" ( " + whereBuffer.toString() + " )  ";
	            
	                ps = getConn().prepareStatement(sqlStmt);
	                rs = ps.executeQuery();
	                
	                List colInfo = this.initColumnInfo();	
	                ResultSetMetaData rsmd = rs.getMetaData();
	                int numColumns = rsmd.getColumnCount();

	                ArrayList<String> columnHeaders = new ArrayList<String>();
	                ArrayList<String> columnTypes = new ArrayList<String>();
	                ArrayList<String[]> rows = new ArrayList<String[]>();
	                HashMap<String,HashMap<String,ArrayList<String[]>>> typeMap = new HashMap<String,HashMap<String,ArrayList<String[]>>>();
	                
	                // Get the column names and types; column indices start from 1
	                for (int i=1; i<numColumns+1; i++) {
	                    String columnName = rsmd.getColumnName(i);
	                    columnHeaders.add(columnName);
	                    String columnType = rsmd.getColumnTypeName(i);
	                    columnTypes.add(columnType);
	                    if (columnType.endsWith("LIST_T")) {
	                    	ArrayList<String[]> typeBreakdown = getType(columnType);
	                    	String[] typeColNames = typeBreakdown.get(0);
	                    	String[] typeColTypes = typeBreakdown.get(1);
	                    	
	                    	for (int c = 0; c<typeColNames.length; c++) {
	                    		columnHeaders.add("-"+typeColNames[c]);
	                    		columnTypes.add(typeColTypes[c]);
	                    	}
	                    }
	                }   
	                
	                while (rs.next()) {
	                	String[] row = new String[numColumns];
	                	for (int i=0; i<numColumns; i++) {
	                		row[i] = rs.getString(i+1);
	                		if (columnTypes.get(i).endsWith("LIST_T"))
	                		{}//typeMap = putInMap(columnTypes.get(i),i,rs.getObject(i+1),typeMap);
	                	}
	                	rows.add(row);
	                }
	                
	                m_classReq.getSession().setAttribute("headers",columnHeaders);
	                m_classReq.getSession().setAttribute("types", columnTypes);
	                m_classReq.getSession().setAttribute("rows", rows);
	                m_classReq.getSession().setAttribute("typeMap", typeMap);
	                
	            }
	    	 	
	    	 	rs.close();
	        	ps.close();
	        	
	        } catch (Exception e) {
	        	e.printStackTrace();
	        } 
		
		ForwardJSP(m_classReq, m_classRes, "/CustomDownload.jsp");
	}
	
	
	
	private void returnJSONFromSession(String JSPName) {
		
		
		
		ForwardJSP(m_classReq, m_classRes, "/JSON"+JSPName+".jsp");
        
	}
	
	private void createDownloadColumns(){
		
		String colString = (String) this.m_classReq.getParameter("cdlColumns");
		
		ArrayList<String> allHeaders = (ArrayList<String>) m_classReq.getSession().getAttribute("headers");
		ArrayList<String> allTypes = (ArrayList<String>) m_classReq.getSession().getAttribute("types");
		ArrayList<String[]> allRows = (ArrayList<String[]>) m_classReq.getSession().getAttribute("rows");
		
		String[] columns = colString.split(",");
		int[] colIndices = new int[columns.length];
		for (int i=0; i < columns.length; i++) {
			String colName = columns[i];
			int temp = allHeaders.indexOf(colName);
			colIndices[i]=temp;
		}
		
		Workbook wb =  new HSSFWorkbook();
		
		Sheet sheet = wb.createSheet("Custom Download");

		Row headerRow = sheet.createRow(0);
        headerRow.setHeightInPoints(12.75f);
        for (int i = 0; i < columns.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(columns[i]);
           // cell.setCellStyle(styles.get("header"));
        }
		
      //freeze the first row
        sheet.createFreezePane(0, 1);
        
        Row row;
        Cell cell;
        int rownum = 1;
        for (int i = 0; i < allRows.size(); i++, rownum++) {
            row = sheet.createRow(rownum);
            if(allRows.get(i) == null) continue;

            for (int j = 0; j < colIndices.length; j++) {
                cell = row.createCell(j);
                cell.setCellValue(allRows.get(i)[colIndices[j]]);
            }
        }
        
        //group rows for each phase, row numbers are 0-based
//        sheet.groupRow(4, 6);
//        sheet.groupRow(9, 13);
//        sheet.groupRow(16, 18);

        //set column widths, the width is measured in units of 1/256th of a character width
        sheet.setColumnWidth(0, 256*6);
        sheet.setColumnWidth(1, 256*33);
        sheet.setColumnWidth(2, 256*20);
        sheet.setZoom(3, 4);


        // Write the output to response stream.
        try {
        	m_classRes.setContentType( "application/vnd.ms-excel" );
        	m_classRes.setHeader( "Content-Disposition", "attachment; filename=\"customDownload.xls\"" );
        	
	        OutputStream out = m_classRes.getOutputStream();
	        wb.write(out);
	        out.close();
        } catch (Exception e) {
        	e.printStackTrace();
        }
        
		ForwardJSP(m_classReq, m_classRes, "/DisplayColumns.jsp");
	}
	
	private void createDownload() {
		
		
		ForwardJSP(m_classReq, m_classRes, "/DownloadComplete.jsp");
	}
	
	private ArrayList<String[]> getType(String type) throws Exception {
		
		ArrayList<String[]> colNamesAndTypes = new ArrayList<String[]>();
		
		ResultSet rsType = null;
	     PreparedStatement ps = null;
	     String sqlStmt =
			"SELECT attr_name, " +
			"attr_type_name, length, " +
			"precision, scale FROM all_type_attrs " +
			"WHERE type_name = ?";

	    ps = getConn().prepareStatement(sqlStmt);
	   	ps.setString(1, type);
	   	rsType = ps.executeQuery();
	   	
	   	ArrayList<String> attrName = new ArrayList<String>();
	   	ArrayList<String> attrTypeName = new ArrayList<String>();
	   	
	   	while (rsType.next()) {
	   		attrName.add(rsType.getString("attr_name"));
	   		attrTypeName.add(rsType.getString("attr_type_name"));
	   	}
	   	
	   	String[] attrNames = new String[attrName.size()];
	   	String[] attrTypeNames = new String[attrTypeName.size()];
	   	
	   	for (int i=0; i < attrName.size(); i++) {
	   		attrNames[i] = attrName.get(i);
	   		attrTypeNames[i] = attrTypeName.get(i);
	   	}
	   	
	   	colNamesAndTypes.add(attrNames);
	   	colNamesAndTypes.add(attrTypeNames);
	   	rsType.close();
    	ps.close();
	   	return colNamesAndTypes;
	}
	
	//initiate the column information as per the source
	private List initColumnInfo() {
		List<ColumnInfo> columnInfo = new ArrayList<ColumnInfo>();

		columnInfo.add(
				new ColumnInfo("PREFERRED_NAME", "Data Element Short Name", "String"));
		columnInfo.add(
				new ColumnInfo("LONG_NAME", "Data Element Long Name", "String"));
		columnInfo.add(
				new ColumnInfo("DOC_TEXT", "Data Element Preferred Question Text", "String"));
		columnInfo.add(
				new ColumnInfo(
						"PREFERRED_DEFINITION", "Data Element Preferred Definition", "String"));
		columnInfo.add(new ColumnInfo("VERSION", "Data Element Version", "String"));
		columnInfo.add(
				new ColumnInfo("DE_CONTE_NAME", "Data Element Context Name", "String"));
		columnInfo.add(
				new ColumnInfo(
						"DE_CONTE_VERSION", "Data Element Context Version", "Number"));
		columnInfo.add(
				new ColumnInfo("CDE_ID", "Data Element Public ID", "Number"));    
		////The deSearch condition is added for the new version of excel files
		
			columnInfo.add(
					new ColumnInfo("DE_WK_FLOW_STATUS", "Data Element Workflow Status", "String"));
			columnInfo.add(
					new ColumnInfo("REGISTRATION_STATUS", "Data Element Registration Status", "Number"));
			columnInfo.add(new ColumnInfo("BEGIN_DATE", "Data Element Begin Date", "Date"));
			columnInfo.add(new ColumnInfo("ORIGIN", "Data Element Source", "String"));
		

		//data element concept
		columnInfo.add(
				new ColumnInfo("DEC_ID", "Data Element Concept Public ID", "Number"));
		columnInfo.add(
				new ColumnInfo(
						"DEC_PREFERRED_NAME", "Data Element Concept Short Name", "String"));
		columnInfo.add(
				new ColumnInfo(
						"DEC_LONG_NAME", "Data Element Concept Long Name", "String"));
		columnInfo.add(
				new ColumnInfo("DEC_VERSION", "Data Element Concept Version", "Number"));
		columnInfo.add(
				new ColumnInfo(
						"DEC_CONTE_NAME", "Data Element Concept Context Name", "String"));
		columnInfo.add(
				new ColumnInfo(
						"DEC_CONTE_VERSION", "Data Element Concept Context Version", "Number"));

		//object class concept
		columnInfo.add(new ColumnInfo("OC_ID", "Object Class Public ID", "String"));
		columnInfo.add(
				new ColumnInfo("OC_LONG_NAME", "Object Class Long Name", "String"));
		columnInfo.add(
				new ColumnInfo(
						"OC_PREFERRED_NAME", "Object Class Short Name", "String"));
		columnInfo.add(
				new ColumnInfo("OC_CONTE_NAME", "Object Class Context Name", "String"));
		columnInfo.add(
				new ColumnInfo("OC_VERSION", "Object Class Version", "String"));

		List<ColumnInfo> ocConceptInfo = new ArrayList<ColumnInfo>();
		ocConceptInfo.add(new ColumnInfo(1, "Name"));
		ocConceptInfo.add(new ColumnInfo(0, "Code"));
		ocConceptInfo.add(new ColumnInfo(2, "Public ID", "Number"));
		ocConceptInfo.add(new ColumnInfo(3, "Definition Source"));    
		ocConceptInfo.add(new ColumnInfo(5, "EVS Source"));
		ocConceptInfo.add(new ColumnInfo(6, "Primary Flag"));

		ColumnInfo ocConcepts =
			new ColumnInfo("oc_concepts", "Object Class Concept ", "Array");
		ocConcepts.nestedColumns = ocConceptInfo;
		columnInfo.add(ocConcepts);

		//property concept
		columnInfo.add(new ColumnInfo("PROP_ID", "Property Public ID", "String"));
		columnInfo.add(
				new ColumnInfo("PROP_LONG_NAME", "Property Long Name", "String"));
		columnInfo.add(
				new ColumnInfo(
						"PROP_PREFERRED_NAME", "Property Short Name", "String"));
		columnInfo.add(
				new ColumnInfo("PROP_CONTE_NAME", "Property Context Name", "String"));
		columnInfo.add(
				new ColumnInfo("PROP_VERSION", "Property Version", "String"));

		List<ColumnInfo> propConceptInfo = new ArrayList<ColumnInfo>();
		propConceptInfo.add(new ColumnInfo(1, "Name"));
		propConceptInfo.add(new ColumnInfo(0, "Code"));
		propConceptInfo.add(new ColumnInfo(2, "Public ID", "Number"));
		propConceptInfo.add(new ColumnInfo(3, "Definition Source"));
		propConceptInfo.add(new ColumnInfo(5, "EVS Source"));
		propConceptInfo.add(new ColumnInfo(6, "Primary Flag"));

		ColumnInfo propConcepts =
			new ColumnInfo("prop_concepts", "Property Concept ", "Array");
		propConcepts.nestedColumns = propConceptInfo;
		columnInfo.add(propConcepts);

		//value domain
		columnInfo.add(new ColumnInfo("VD_ID", "Value Domain Public ID", "Number"));
		columnInfo.add(
				new ColumnInfo(
						"VD_PREFERRED_NAME", "Value Domain Short Name", "String"));
		columnInfo.add(
				new ColumnInfo("VD_LONG_NAME", "Value Domain Long Name", "String"));
		columnInfo.add(
				new ColumnInfo("VD_VERSION", "Value Domain Version", "Number"));
		columnInfo.add(
				new ColumnInfo("VD_CONTE_NAME", "Value Domain Context Name", "String"));
		columnInfo.add(
				new ColumnInfo(
						"VD_CONTE_VERSION", "Value Domain Context Version", "Number"));
		columnInfo.add(new ColumnInfo("VD_TYPE", "Value Domain Type", "String"));
		columnInfo.add(
				new ColumnInfo("DTL_NAME", "Value Domain Datatype", "String"));
		columnInfo.add(
				new ColumnInfo("MIN_LENGTH_NUM", "Value Domain Min Length", "Number"));
		columnInfo.add(
				new ColumnInfo("MAX_LENGTH_NUM", "Value Domain Max Length", "Number"));
		columnInfo.add(
				new ColumnInfo("LOW_VALUE_NUM", "Value Domain Min Value", "Number"));
		columnInfo.add(
				new ColumnInfo("HIGH_VALUE_NUM", "Value Domain Max Value", "Number"));
		columnInfo.add(
				new ColumnInfo("DECIMAL_PLACE", "Value Domain Decimal Place", "Number"));
		columnInfo.add(
				new ColumnInfo("FORML_NAME", "Value Domain Format", "String"));

		//Value Domain Concept
		List<ColumnInfo> vdConceptInfo = new ArrayList<ColumnInfo>();
		vdConceptInfo.add(new ColumnInfo(1, "Name"));
		vdConceptInfo.add(new ColumnInfo(0, "Code"));
		vdConceptInfo.add(new ColumnInfo(2, "Public ID", "Number"));
		vdConceptInfo.add(new ColumnInfo(3, "Definition Source"));
		vdConceptInfo.add(new ColumnInfo(5, "EVS Source"));
		vdConceptInfo.add(new ColumnInfo(6, "Primary Flag"));

		ColumnInfo vdConcepts =
			new ColumnInfo("vd_concepts", "Value Domain Concept ", "Array");
		vdConcepts.nestedColumns = vdConceptInfo;
		columnInfo.add(vdConcepts);    
		//representation concept
		//The deSearch condition is added to support both the old and the new version of excel files
		    	
			columnInfo.add(new ColumnInfo("REP_ID", "Representation Public ID", "String"));
			columnInfo.add(
					new ColumnInfo("REP_LONG_NAME", "Representation Long Name", "String"));
			columnInfo.add(
					new ColumnInfo(
							"REP_PREFERRED_NAME", "Representation Short Name", "String"));
			columnInfo.add(
					new ColumnInfo("REP_CONTE_NAME", "Representation Context Name", "String"));
			columnInfo.add(
					new ColumnInfo("REP_VERSION", "Representation Version", "String"));

			List<ColumnInfo> repConceptInfo = new ArrayList<ColumnInfo>();
			repConceptInfo.add(new ColumnInfo(1, "Name"));
			repConceptInfo.add(new ColumnInfo(0, "Code"));
			repConceptInfo.add(new ColumnInfo(2, "Public ID", "Number"));
			repConceptInfo.add(new ColumnInfo(3, "Definition Source"));
			repConceptInfo.add(new ColumnInfo(5, "EVS Source"));
			repConceptInfo.add(new ColumnInfo(6, "Primary Flag"));

			ColumnInfo repConcepts =
				new ColumnInfo("rep_concepts", "Representation Concept ", "Array");
			repConcepts.nestedColumns = repConceptInfo;
			columnInfo.add(repConcepts);
		    

		//Valid Value
		List<ColumnInfo> validValueInfo = new ArrayList<ColumnInfo>();
		validValueInfo.add(new ColumnInfo(0, "Valid Values"));
		//The deSearch condition is added to support both the (3.2.0.1) old and the (3.2.0.2)new version of excel files
		
			validValueInfo.add(new ColumnInfo(1, "Value Meaning Name"));
			validValueInfo.add(new ColumnInfo(2, "Value Meaning Description"));
			validValueInfo.add(new ColumnInfo(3, "Value Meaning Concepts"));
			//*	Added for 4.0	
			validValueInfo.add(new ColumnInfo(4, "PVBEGINDATE","PV Begin Date", "Date"));
			validValueInfo.add(new ColumnInfo(5, "PVENDDATE","PV End Date", "Date"));
			validValueInfo.add(new ColumnInfo(6, "VMPUBLICID", "Value Meaning PublicID", "Number"));
			validValueInfo.add(new ColumnInfo(7, "VMVERSION", "Value Meaning Version", "Number"));
			//	Added for 4.0	*/
		
		ColumnInfo validValue = new ColumnInfo("VALID_VALUES", "", "Array");
		validValue.nestedColumns = validValueInfo;
		columnInfo.add(validValue);

		//Classification Scheme
		List<ColumnInfo> csInfo = new ArrayList<ColumnInfo>();
		/*if ("deSearch".equals(source)|| "cdeCart".equals(source)){
    	csInfo.add(new ColumnInfo(0, 3, "Preferred Name", "String"));
    }else{*/
		csInfo.add(new ColumnInfo(0, 3, "Short Name", "String"));
		//}
		csInfo.add(new ColumnInfo(0, 4, "Version","Number"));
		csInfo.add(new ColumnInfo(0, 1, "Context Name", "String"));
		csInfo.add(new ColumnInfo(0, 2, "Context Version","Number"));
		csInfo.add(new ColumnInfo(1, "Item Name"));
		csInfo.add(new ColumnInfo(2, "Item Type Name"));
		//	Added for 4.0 
		csInfo.add(new ColumnInfo(3, "CsiPublicId","Item Public Id", "Number"));
		csInfo.add(new ColumnInfo(4, "CsiVersion","Item Version", "Number"));
		//	Added for 4.0	
		ColumnInfo classification =
			new ColumnInfo("CLASSIFICATIONS", "Classification Scheme ", "Array");
		classification.nestedColumns = csInfo;
		columnInfo.add(classification);

		//Alternate name
		List<ColumnInfo> altNameInfo = new ArrayList<ColumnInfo>();
		altNameInfo.add(new ColumnInfo(0, "Context Name"));
		altNameInfo.add(new ColumnInfo(1, "Context Version", "Number"));
		altNameInfo.add(new ColumnInfo(2, ""));
		altNameInfo.add(new ColumnInfo(3, "Type"));
		ColumnInfo altNames;
		altNames = new ColumnInfo("designations", "Data Element Alternate Name ", "Array");
		
		altNames.nestedColumns = altNameInfo;
		columnInfo.add(altNames);

		//Reference Document
		List<ColumnInfo> refDocInfo = new ArrayList<ColumnInfo>();
		refDocInfo.add(new ColumnInfo(3, ""));
		refDocInfo.add(new ColumnInfo(0, "Name"));
		refDocInfo.add(new ColumnInfo(2, "Type"));

		ColumnInfo refDoc = new ColumnInfo("reference_docs", "Document ", "Array");
		refDoc.nestedColumns = refDocInfo;
		columnInfo.add(refDoc);

		//Derived data elements
		columnInfo.add(
				new ColumnInfo(0, "DE_DERIVATION", "Derivation Type", "Struct"));
		columnInfo.add(
				new ColumnInfo(2, "DE_DERIVATION", "Derivation Method", "Struct"));
		columnInfo.add(
				new ColumnInfo(3, "DE_DERIVATION", "Derivation Rule", "Struct"));
		columnInfo.add(
				new ColumnInfo(4, "DE_DERIVATION", "Concatenation Character", "Struct"));

		List<ColumnInfo> dedInfo = new ArrayList<ColumnInfo>();
		dedInfo.add(new ColumnInfo(0, "Public ID", "Number"));
		dedInfo.add(new ColumnInfo(1, "Long Name"));
		dedInfo.add(new ColumnInfo(4, "Version", "Number"));
		dedInfo.add(new ColumnInfo(5, "Workflow Status"));
		dedInfo.add(new ColumnInfo(6, "Context"));
		dedInfo.add(new ColumnInfo(7, "Display Order", "Number"));

		ColumnInfo deDrivation =
			new ColumnInfo(5, "DE_DERIVATION", "DDE ", "StructArray");
		deDrivation.nestedColumns = dedInfo;
		columnInfo.add(deDrivation);    

		return columnInfo;
	}
	
	//various column formats
	private class ColumnInfo {
		String rsColumnName;
		int rsIndex;
		int rsSubIndex = -1;
		String displayName;
		String type;
		List nestedColumns;

		/**
		 * Constructor for a regular column that maps to one result set column
		 */
		ColumnInfo(
				String rsColName,
				String excelColName,
				String colType) {
			super();

			rsColumnName = rsColName;
			displayName = excelColName;
			type = colType;
		}

		/**
		 * Constructor for a column that maps to one result set object column,
		 * e.g., the Derived Data Element columns
		 */
		ColumnInfo(
				int colIdx,
				String rsColName,
				String excelColName,
				String colType) {
			super();

			rsIndex = colIdx;
			rsColumnName = rsColName;
			displayName = excelColName;
			type = colType;
		}

		/**
		 * Constructor for a regular column that maps to one column inside an Aarry
		 * of type String
		 */
		ColumnInfo(
				int rsIdx,
				String excelColName) {
			super();

			rsIndex = rsIdx;
			displayName = excelColName;
			type = "String";
		}

		/**
		 * Constructor for a regular column that maps to one column inside an Aarry
		 */
		ColumnInfo(
				int rsIdx,
				String excelColName,
				String colClass) {
			super();

			rsIndex = rsIdx;
			displayName = excelColName;
			type = colClass;
		}

		/**
		 * Constructor for a regular column that maps to one column inside an
		 * Object of the Aarry type.  E.g., the classification scheme information
		 */
		ColumnInfo(
				int rsIdx,
				int rsSubIdx,
				String excelColName,
				String colType) {
			super();

			rsIndex = rsIdx;
			rsSubIndex = rsSubIdx;
			displayName = excelColName;
			type = colType;
		}
	}
}
