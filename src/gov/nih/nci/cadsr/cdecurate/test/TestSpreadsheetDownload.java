// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/test/testdec.java,v 1.11 2008-03-13 17:57:59 chickerura Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.test;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.InvalidPropertiesFormatException;
import java.util.Iterator;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
//import com.sun.org.apache.xerces.internal.impl.xs.dom.DOMParser;
import com.sun.org.apache.xerces.internal.parsers.DOMParser;

import gov.nih.nci.cadsr.cdecurate.database.SQLHelper;
import gov.nih.nci.cadsr.cdecurate.tool.AC_CSI_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.CSI_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.ConceptAction;
import gov.nih.nci.cadsr.cdecurate.tool.ConceptForm;
import gov.nih.nci.cadsr.cdecurate.tool.CurationServlet;
import gov.nih.nci.cadsr.cdecurate.tool.DEC_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.EVS_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.InsACService;
import gov.nih.nci.cadsr.cdecurate.tool.Session_Data;
import gov.nih.nci.cadsr.cdecurate.tool.UtilService;
import gov.nih.nci.cadsr.cdecurate.tool.VMAction;
import gov.nih.nci.cadsr.cdecurate.tool.VMForm;
import gov.nih.nci.cadsr.cdecurate.tool.VM_Bean;
import gov.nih.nci.cadsr.cdecurate.util.AdministeredItemUtil;

/**
 * @author shegde
 * 
 */
public class TestSpreadsheetDownload {
	public static final Logger logger = Logger.getLogger(CurationServlet.class
			.getName());
	UtilService m_util = new UtilService();
	CurationServlet m_servlet = null;

	/**
	 * Useful SQLs -
	 * 
	 * //Following query is used to get data for excel sheet. 1. SELECT * FROM
	 * sbrext.CDE_EXCEL_GENERATOR_VIEW WHERE CDE_IDSEQ =
	 * 'E5F32266-BEFC-1A1E-E034-0003BA3F9857';
	 * 
	 * //Following is one of the query used to get values( like "???") 2. SELECT
	 * pv.VALUE,vm.long_name
	 * short_meaning,vm.preferred_definition,pv.begin_date,
	 * pv.end_date,vm.vm_id,vm.version FROM sbr.permissible_values pv,sbr.vd_pvs
	 * vp,value_meanings vm,sbr.value_domains vd,sbr.data_elements
	 * de,conceptual_domains cd,sbr.contexts vd_conte,representations_ext rep
	 * WHERE vp.vd_idseq = vd.vd_idseq AND vp.pv_idseq = pv.pv_idseq AND
	 * pv.vm_idseq = vm.vm_idseq AND de.vd_idseq = vd.vd_idseq AND
	 * vd.conte_idseq = vd_conte.conte_idseq AND vd.cd_idseq = cd.cd_idseq AND
	 * vd.rep_idseq = rep.rep_idseq(+);
	 * 
	 */
	public TestSpreadsheetDownload() {
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		TestSpreadsheetDownload download = new TestSpreadsheetDownload();
		download.SpreadsheetDownload();
		System.out.println("Excel File Created");
	}

	public void SpreadsheetDownload() {

		ArrayList<String> allHeaders = new ArrayList<String>();
		FileOutputStream fileOutputStream = null;
		String[] FirstRow = new String[] { "data1", "data2", "data3", "data4",
				"data5", "data6", "data7", "data8", "data9", "data10" };
		String[] SecondRow = new String[] { "data11", "data12", "data13",
				"data14", "data15", "data16", "data17", "data18", "data19",
				"data20" };
		ArrayList<String[]> allRows = new ArrayList<String[]>();
		allRows.add(FirstRow);
		allRows.add(SecondRow);
		String[] columns = null;

		for (int i = 1; i <= 10; i++)
			allHeaders.add("Column" + i);

		columns = allHeaders.toArray(new String[allHeaders.size()]);
		int[] colIndices = new int[columns.length];
		for (int i = 0; i < columns.length; i++) {
			String colName = columns[i];
			int temp = allHeaders.indexOf(colName);
			colIndices[i] = temp;
		}

		Workbook wb = new HSSFWorkbook();
		Sheet sheet = wb.createSheet("Test_Sheet");
		Row headerRow = sheet.createRow(0);
		headerRow.setHeightInPoints(12.75f);
		for (int i = 0; i < columns.length; i++) {
			Cell cell = headerRow.createCell(i);
			cell.setCellValue(columns[i]);
		}
		sheet.createFreezePane(0, 1);
		Row row = null;
		Cell cell;
		int rownum = 1;
		int bump = 0;
		int i = 0;
		try {
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
					cell.setCellValue(allRows.get(i)[colIndices[j]]);
				}
				bump = bump + maxBump;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		try {
			// Please specify the path below
			fileOutputStream = new FileOutputStream("C:/Test_Excel.xls");
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

}
