package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.OutputStream;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Set;
import java.util.Vector;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.lucene.search.ReqExclScorer;
import org.apache.poi.POIDocument;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
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
				prepDEpage(); 
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
		}	
			
	}
	
	private void prepDEpage() {
		
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
	        			"SELECT * FROM DE_EXCEL_GENERATOR_VIEW " + "WHERE DE_IDSEQ IN " +
	        			" ( " + whereBuffer.toString() + " )  ";
	            
	                ps = getConn().prepareStatement(sqlStmt);
	                rs = ps.executeQuery();

	                ResultSetMetaData rsmd = rs.getMetaData();
	                int numColumns = rsmd.getColumnCount();

	                ArrayList<String> columnHeaders = new ArrayList<String>();
	                ArrayList<String> columnTypes = new ArrayList<String>();
	                ArrayList<String[]> rows = new ArrayList<String[]>();
	                
	                // Get the column names and types; column indices start from 1
	                for (int i=1; i<numColumns+1; i++) {
	                    String columnName = rsmd.getColumnName(i);
	                    columnHeaders.add(columnName);
	                    String columnType = rsmd.getColumnTypeName(i);
	                    columnTypes.add(columnType);
	                }   
	                
	                while (rs.next()) {
	                	String[] row = new String[numColumns];
	                	for (int i=0; i<numColumns; i++) {
	                		row[i] = rs.getString(i+1);
	                	}
	                	rows.add(row);
	                }
	                
	                m_classReq.getSession().setAttribute("headers",columnHeaders);
	                m_classReq.getSession().setAttribute("types", columnTypes);
	                m_classReq.getSession().setAttribute("rows", rows);
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
			System.out.println(colName);
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
}
