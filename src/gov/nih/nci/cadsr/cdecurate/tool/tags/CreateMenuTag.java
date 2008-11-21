package gov.nih.nci.cadsr.cdecurate.tool.tags;

import java.io.IOException;

import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;

import org.apache.commons.lang.StringEscapeUtils;

/**
 * This JSP tag library class is for Create Menu
 * @author hveerla
 *
 */
public class CreateMenuTag extends MenuTag {
	public int doEndTag() throws JspException {
		JspWriter createMenu = this.pageContext.getOut();
		HttpSession session = pageContext.getSession();
		String userName = null;
		if (session != null) {
		   userName = (String) session.getAttribute("Username");
		}
		try {
			createMenu.println("<div class=\"popMenu\">"
					            +"<b>Data Element</b>"
					            +"<dl class=\"menu2\">"
					            +generateDT("","javascript:callDENew('"+StringEscapeUtils.escapeJavaScript(userName)+"')","New")
					            +generateDT("New Using Existing")
					            +generateDT("New Version")
					            +"</dl>"
					            +"<b>Data Element Concept</b>"
					            +"<dl class=\"menu2\">"
					            +generateDT("","javascript:callDECNew('"+StringEscapeUtils.escapeJavaScript(userName)+"')","New")
					            +generateDT("New Using Existing")
					            +generateDT("New Version")
					            +"</dl>"
					            +"<b>Value Domain</b>"
					            +"<dl class=\"menu2\">"
					            +generateDT("","javascript:callVDNew('"+StringEscapeUtils.escapeJavaScript(userName)+"')","New")
					            +generateDT("New Using Existing")
					            +generateDT("New Version")
					            +"</dl></div>");
			createMenu.println("<form name=\"newDEForm\" method=\"post\" action=\"../../cdecurate/NCICurationServlet?reqType=newDEFromMenu\"></form>"
                    + "<form name=\"newDECForm\" method=\"post\" action=\"../../cdecurate/NCICurationServlet?reqType=newDECFromMenu\"></form>"
                    + "<form name=\"newVDForm\" method=\"post\" action=\"../../cdecurate/NCICurationServlet?reqType=newVDFromMenu\"></form>");
		} catch (IOException e) {
			e.printStackTrace();
		}

		return EVAL_PAGE;
	}

}





   



    