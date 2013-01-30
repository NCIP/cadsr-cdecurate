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
        String formBuilderLink = "window.open('" + ToolURL.getFormBuilderUrl(this.pageContext) +"', '_blank')";
        String formBuilderDName = ToolURL.getFormBuilderDisplayName(this.pageContext);
        String evsBioPortalLink = "window.open('" + ToolURL.getEVSBioPortalUrl(this.pageContext) +"', '_blank')";
        String evsBioPortalDName = ToolURL.getEVSBioPortalDisplayName(this.pageContext);
        String passwordChangeStationLink = "window.open('" + ToolURL.getPasswordChangeStationURL(this.pageContext) +"', '_blank')";//GF32153
        String passwordChangeStationLinkDName = ToolURL.getPasswordChangeStationDispalyName(this.pageContext);//GF32153
		try {
			linksMenu.println("<dl class=\"menu\">"
					          + generateDT("",adminToolLink,adminToolDName)  
					          + generateDT("",cadsrApiLink,cadsrApiDName)
					          + generateDT("",freeStyleLink,freeStyleDName)
					          + generateDT("",sentinelToolLink,sentinelToolDName)
					          + generateDT("",cdeBrowserLink,cdeBrowserDName)
					          + generateDT("",formBuilderLink,formBuilderDName)
					          + generateDT("",umlBrowserLink,umlBrowserDName)
					          + separator()
					          + generateDT("",evsBioPortalLink,evsBioPortalDName)
					          + separator()
					          + generateDT("",passwordChangeStationLink,passwordChangeStationLinkDName)//GF32153
					          + generateDT("","window.open('https://gforge.nci.nih.gov', '_blank')","NCI GForge")
					          + generateDT("","window.open('https://wiki.nci.nih.gov', '_blank')","NCI Wiki")
					          +"</dl>");
		} catch (IOException e) {
			e.printStackTrace();
		}
		return EVAL_PAGE;
	}
}




