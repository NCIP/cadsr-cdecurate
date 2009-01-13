package gov.nih.nci.cadsr.cdecurate.tool.tags;

import gov.nih.nci.cadsr.cdecurate.util.ToolURL;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;

/**
 * This JSP tag library class is for Links Menu
 * @author hveerla
 *
 */
public class LinksMenuTag extends MenuTag {
	
	public int doEndTag() throws JspException {
		JspWriter linksMenu = this.pageContext.getOut();
		String cdeBrowserLink = "window.open('" + ToolURL.getBrowserUrl(this.pageContext) +"', '_blank')";
		String cdeBrowserDName = ToolURL.getBrowserDispalyName(this.pageContext);
		String sentinelToolLink = "window.open('" + ToolURL.getSentinelUrl(this.pageContext) +"', '_blank')";
		String sentinelToolDName = ToolURL.getSentinelDispalyName(this.pageContext);
        String umlBrowserLink = "window.open('" + ToolURL.getUmlBrowserUrl(this.pageContext) +"', '_blank')";
        String umlBrowserDName =ToolURL.getUmlBrowserDispalyName(this.pageContext);
        String freeStyleLink = "window.open('" + ToolURL.getFreeStyleUrl(this.pageContext) +"', '_blank')";
        String freeStyleDName = ToolURL.getFreeStyleDispalyName(this.pageContext);
        String adminToolLink = "window.open('" + ToolURL.getAdminToolUrl(this.pageContext) +"', '_blank')";
        String adminToolDName = ToolURL.getAdminToolDispalyName(this.pageContext);
        String cadsrApiLink = "window.open('" + ToolURL.getCadsrAPIUrl(this.pageContext) +"', '_blank')";
        String cadsrApiDName = ToolURL.getCadsrAPIDispalyName(this.pageContext);
		try {
			linksMenu.println("<dl class=\"menu\">"
					          + generateDT("",adminToolLink,adminToolDName)         
					          + generateDT("",cdeBrowserLink,cdeBrowserDName)
					          + generateDT("",freeStyleLink,freeStyleDName)
					          + generateDT("",sentinelToolLink,sentinelToolDName)
					          + generateDT("",umlBrowserLink,umlBrowserDName)
					          + separator()
					          + generateDT("",cadsrApiLink,cadsrApiDName)
					          + generateDT("","window.open('https://wiki.nci.nih.gov', '_blank')","NCI Wiki")
					          + generateDT("","window.open('https://gforge.nci.nih.gov', '_blank')","NCI GForge")
					          +"</dl>");
		} catch (IOException e) {
			e.printStackTrace();
		}
		return EVAL_PAGE;
	}
}




