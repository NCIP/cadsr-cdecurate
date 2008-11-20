package gov.nih.nci.cadsr.cdecurate.tool.tags;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;

public class CreateMenuTag extends MenuTag {
	public int doEndTag() throws JspException {
		JspWriter createMenu = this.pageContext.getOut();
		
		try {
			createMenu.println("<div class=\"popMenu\">"
					            +"<b>Data Element</b>"
					            +"<dl class=\"menu2\">"
					            +generateDT("New")
					            +generateDT("New Using Existing")
					            +generateDT("New Version")
					            +"</dl>"
					            +"<b>Data Element Concept</b>"
					            +"<dl class=\"menu2\">"
					            +generateDT("New")
					            +generateDT("New Using Existing")
					            +generateDT("New Version")
					            +"</dl>"
					            +"<b>Value Domain</b>"
					            +"<dl class=\"menu2\">"
					            +generateDT("New")
					            +generateDT("New Using Existing")
					            +generateDT("New Version")
					            +"</dl></div>");
		} catch (IOException e) {
			e.printStackTrace();
		}

		return EVAL_PAGE;
	}

}





   



    