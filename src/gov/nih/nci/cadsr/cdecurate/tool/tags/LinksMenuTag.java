package gov.nih.nci.cadsr.cdecurate.tool.tags;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;

public class LinksMenuTag extends MenuTag {
	
	public int doEndTag() throws JspException {
		JspWriter linksMenu = this.pageContext.getOut();
		
		try {
			linksMenu.println("<dl class=\"menu\">"
					          + generateDT("","window.open('https://cdebrowser-stage2.nci.nih.gov/CDEBrowser/', '_blank')","CDE Browser")
					          + generateDT("","window.open('http://freestyle-stage2.nci.nih.gov/freestyle/', '_blank')","caDSR Freestyle")
					          + generateDT("","window.open('https://cadsrsentinel-stage2.nci.nih.gov/cadsrsentinel/', '_blank')","caDSR Sentinel Tool")
					          + generateDT("","window.open('http://umlmodelbrowser-stage2.nci.nih.gov/umlmodelbrowser/', '_blank')","UML Model Browser")
					          + generateDTDisabled("Admin Tool")
					          + separator()
					          + generateDT("","window.open('http://cadsrapi-stage2.nci.nih.gov/cadsrapi40/', '_blank')","caDSR API Home")
					          + generateDT("","window.open('https://wiki.nci.nih.gov', '_blank')","NCICB Wiki")
					          + generateDT("","window.open('https://gforge.nci.nih.gov', '_blank')","NCICB GForge")
					          +"</dl>");
		} catch (IOException e) {
			e.printStackTrace();
		}

		return EVAL_PAGE;
	}
}




