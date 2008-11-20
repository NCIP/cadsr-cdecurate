package gov.nih.nci.cadsr.cdecurate.tool.tags;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;

/**
 * This JSP tag library class is for Search Menu
 * @author hveerla
 *
 */
public class SearchMenuTag extends MenuTag {
	
	public int doEndTag() throws JspException {
		JspWriter searchMenu = this.pageContext.getOut();
		if (selACType != null) {
		try {
			getSessionAttributes();
			searchMenu.println("<dl class=\"menu\">");
			if ((selACType).equals("DataElement")) {
				searchMenu.println(generateDT("searchMenuEdit","javascript:ShowEditSelection()","Edit")
				                   + generateDT("searchMenuBlockEdit","javascript:ShowEditSelection()","Block Edit")
				                   + generateDT("searchMenuDetails","javascript:javascript:GetDetails()","View Details")
				                   + generateDTDisabled("Get Associated DE")
				                   + generateDT("menuAssociatedDEC","javascript:getAssocDECs()","Get Associated DEC")
				                   + generateDT("menuAssociatedVD","javascript:getAssocVDs()","Get Associated VD")
				                   + generateDT("","javascript:monitorCmd()","Monitor")
				                   + generateDT("","javascript:unmonitorCmd()","Unmonitor")
				                   + separator()
				                   + generateDT("","javascript:setAppendAction()","Append"));
			}
			if ((selACType).equals("DataElementConcept")) {
				searchMenu.println(generateDT("searchMenuEdit","javascript:ShowEditSelection()","Edit")
		                           + generateDT("searchMenuBlockEdit","javascript:ShowEditSelection()","Block Edit")
		                           + generateDTDisabled("View Details")
		                           + generateDT("menuAssociatedDE","javascript:getAssocDEs()","Get Associated DE")
		                           + generateDTDisabled("Get Associated DEC")
		                           + generateDTDisabled("Get Associated VD")
		                           + generateDT("","javascript:monitorCmd()","Monitor")
		                           + generateDT("","javascript:unmonitorCmd()","Unmonitor")
		                           + separator()
		                           + generateDT("","javascript:setAppendAction()","Append"));
			}
			if ((selACType).equals("ValueDomain")) {
				searchMenu.println(generateDT("searchMenuEdit","javascript:ShowEditSelection()","Edit")
		                           + generateDT("searchMenuBlockEdit","javascript:ShowEditSelection()","Block Edit")
		                           + generateDTDisabled("View Details")
		                           + generateDT("menuAssociatedDE","javascript:getAssocDEs()","Get Associated DE")
		                           + generateDTDisabled("Get Associated DEC")
		                           + generateDTDisabled("Get Associated VD")
		                           + generateDT("","javascript:monitorCmd()","Monitor")
		                           + generateDT("","javascript:unmonitorCmd()","Unmonitor")
		                           + separator()
		                           + generateDT("","javascript:setAppendAction()","Append"));
			}
			if ((selACType).equals("ValueMeaning")) {
				searchMenu.println(generateDT("searchMenuEdit","javascript:ShowEditSelection()","Edit")
		                           + generateDTDisabled("Block Edit")
		                           + generateDTDisabled("View Details")
		                           + generateDT("menuAssociatedDE","javascript:getAssocDEs()","Get Associated DE")
		                           + generateDTDisabled("Get Associated DEC")
		                           + generateDTDisabled("Get Associated VD")
		                           + generateDTDisabled("Monitor")
		                           + generateDTDisabled("Unmonitor")
		                           + separator()
		                           + generateDTDisabled("Append"));
			}
			if ((selACType).equals("ConceptualDomain")) {
				searchMenu.println(generateDTDisabled("Edit")
		                           + generateDTDisabled("Block Edit")
		                           + generateDTDisabled("View Details")
		                           + generateDT("menuAssociatedDE","javascript:getAssocDEs()","Get Associated DE")
		                           + generateDT("menuAssociatedDEC","javascript:getAssocDECs()","Get Associated DEC")
				                   + generateDT("menuAssociatedVD","javascript:getAssocVDs()","Get Associated VD")
		                           + generateDTDisabled("Monitor")
		                           + generateDTDisabled("Unmonitor")
		                           + separator()
		                           + generateDTDisabled("Append"));
			}
			if ((selACType).equals("PermissibleValue")) {
				searchMenu.println(generateDTDisabled("Edit")
		                           + generateDTDisabled("Block Edit")
		                           + generateDTDisabled("View Details")
		                           + generateDT("menuAssociatedDE","javascript:getAssocDEs()","Get Associated DE")
		                           + generateDTDisabled("Get Associated DEC")
				                   + generateDT("menuAssociatedVD","javascript:getAssocVDs()","Get Associated VD")
		                           + generateDTDisabled("Monitor")
		                           + generateDTDisabled("Unmonitor")
		                           + separator()
		                           + generateDTDisabled("Append"));
			}
			if ((selACType).equals("ClassSchemeItems")) {
				searchMenu.println(generateDTDisabled("Edit")
		                           + generateDTDisabled("Block Edit")
		                           + generateDTDisabled("View Details")
		                           + generateDT("menuAssociatedDE","javascript:getAssocDEs()","Get Associated DE")
		                           + generateDT("menuAssociatedDEC","javascript:getAssocDECs()","Get Associated DEC")
				                   + generateDT("menuAssociatedVD","javascript:getAssocVDs()","Get Associated VD")
		                           + generateDTDisabled("Monitor")
		                           + generateDTDisabled("Unmonitor")
		                           + separator()
		                           + generateDTDisabled("Append"));
			}
			if ((selACType).equals("ConceptClass")) {
				searchMenu.println(generateDTDisabled("Edit")
		                           + generateDTDisabled("Block Edit")
		                           + generateDTDisabled("View Details")
		                           + generateDT("menuAssociatedDE","javascript:getAssocDEs()","Get Associated DE")
		                           + generateDT("menuAssociatedDEC","javascript:getAssocDECs()","Get Associated DEC")
				                   + generateDT("menuAssociatedVD","javascript:getAssocVDs()","Get Associated VD")
		                           + generateDTDisabled("Monitor")
		                           + generateDTDisabled("Unmonitor")
		                           + separator()
		                           + generateDTDisabled("Append"));
			}
			if ((selACType).equals("ObjectClass")) {
				searchMenu.println(generateDTDisabled("Edit")
		                           + generateDTDisabled("Block Edit")
		                           + generateDTDisabled("View Details")
		                           + generateDTDisabled("Get Associated DE")
		                           + generateDT("menuAssociatedDEC","javascript:getAssocDECs()","Get Associated DEC")
				                   + generateDTDisabled("Get Associated VD")
		                           + generateDTDisabled("Monitor")
		                           + generateDTDisabled("Unmonitor")
		                           + separator()
		                           + generateDTDisabled("Append"));
			}
			if ((selACType).equals("Property")) {
				searchMenu.println(generateDTDisabled("Edit")
		                           + generateDTDisabled("Block Edit")
		                           + generateDTDisabled("View Details")
		                           + generateDTDisabled("Get Associated DE")
		                           + generateDT("menuAssociatedDEC","javascript:getAssocDECs()","Get Associated DEC")
				                   + generateDTDisabled("Get Associated VD")
		                           + generateDTDisabled("Monitor")
		                           + generateDTDisabled("Unmonitor")
		                           + separator()
		                           + generateDTDisabled("Append"));
			}
			searchMenu.println(generateDT("","javascript:ShowSelectedRows(true)","Show Selected Rows")
					           + generateDT("","javascript:clearRecords()","Clear Results"));
			searchMenu.println("</d1>");
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		}
		return EVAL_PAGE;
	}

}
