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
				searchMenu.println(generateDT("searchMenuEdit","performAction('edit')","Edit")
				                   + generateDT("searchMenuBlockEdit","performAction('blockEdit')","Block Edit")
				                   + generateDT("searchMenuDetails","GetDetails()","View Details")
				                   + generateDTDisabled("Get Associated DE")
				                   + generateDT("menuAssociatedDEC","getAssocDECs()","Get Associated DEC")
				                   + generateDT("menuAssociatedVD","getAssocVDs()","Get Associated VD")
				                   + generateDT("","performAction('monitor')","Monitor")
				                   + generateDT("","performAction('unmonitor')","Unmonitor")
				                   + separator()
				                   + generateDT("","performAction('append')","Append"));
			}
			if ((selACType).equals("DataElementConcept")) {
				searchMenu.println(generateDT("searchMenuEdit","performAction('edit')","Edit")
		                           + generateDT("searchMenuBlockEdit","performAction('blockEdit')","Block Edit")
		                           + generateDTDisabled("View Details")
		                           + generateDT("menuAssociatedDE","getAssocDEs()","Get Associated DE")
		                           + generateDTDisabled("Get Associated DEC")
		                           + generateDTDisabled("Get Associated VD")
		                           + generateDT("","performAction('monitor')","Monitor")
		                           + generateDT("","performAction('unmonitor')","Unmonitor")
		                           + separator()
		                           + generateDT("","performAction('append')","Append"));
			}
			if ((selACType).equals("ValueDomain")) {
				searchMenu.println(generateDT("searchMenuEdit","performAction('edit')","Edit")
		                           + generateDT("searchMenuBlockEdit","performAction('blockEdit')","Block Edit")
		                           + generateDTDisabled("View Details")
		                           + generateDT("menuAssociatedDE","getAssocDEs()","Get Associated DE")
		                           + generateDTDisabled("Get Associated DEC")
		                           + generateDTDisabled("Get Associated VD")
		                           + generateDT("","performAction('monitor')","Monitor")
		                           + generateDT("","performAction('unmonitor')","Unmonitor")
		                           + separator()
		                           + generateDT("","performAction('append')","Append"));
			}
			if ((selACType).equals("ValueMeaning")) {
				searchMenu.println(generateDT("searchMenuEdit","performAction('edit')","Edit")
		                           + generateDTDisabled("Block Edit")
		                           + generateDTDisabled("View Details")
		                           + generateDT("menuAssociatedDE","getAssocDEs()","Get Associated DE")
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
		                           + generateDT("menuAssociatedDE","getAssocDEs()","Get Associated DE")
		                           + generateDT("menuAssociatedDEC","getAssocDECs()","Get Associated DEC")
				                   + generateDT("menuAssociatedVD","getAssocVDs()","Get Associated VD")
		                           + generateDTDisabled("Monitor")
		                           + generateDTDisabled("Unmonitor")
		                           + separator()
		                           + generateDTDisabled("Append"));
			}
			if ((selACType).equals("PermissibleValue")) {
				searchMenu.println(generateDTDisabled("Edit")
		                           + generateDTDisabled("Block Edit")
		                           + generateDTDisabled("View Details")
		                           + generateDT("menuAssociatedDE","getAssocDEs()","Get Associated DE")
		                           + generateDTDisabled("Get Associated DEC")
				                   + generateDT("menuAssociatedVD","getAssocVDs()","Get Associated VD")
		                           + generateDTDisabled("Monitor")
		                           + generateDTDisabled("Unmonitor")
		                           + separator()
		                           + generateDTDisabled("Append"));
			}
			if ((selACType).equals("ClassSchemeItems")) {
				searchMenu.println(generateDTDisabled("Edit")
		                           + generateDTDisabled("Block Edit")
		                           + generateDTDisabled("View Details")
		                           + generateDT("menuAssociatedDE","getAssocDEs()","Get Associated DE")
		                           + generateDT("menuAssociatedDEC","getAssocDECs()","Get Associated DEC")
				                   + generateDT("menuAssociatedVD","getAssocVDs()","Get Associated VD")
		                           + generateDTDisabled("Monitor")
		                           + generateDTDisabled("Unmonitor")
		                           + separator()
		                           + generateDTDisabled("Append"));
			}
			if ((selACType).equals("ConceptClass")) {
				searchMenu.println(generateDTDisabled("Edit")
		                           + generateDTDisabled("Block Edit")
		                           + generateDTDisabled("View Details")
		                           + generateDT("menuAssociatedDE","getAssocDEs()","Get Associated DE")
		                           + generateDT("menuAssociatedDEC","getAssocDECs()","Get Associated DEC")
				                   + generateDT("menuAssociatedVD","getAssocVDs()","Get Associated VD")
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
		                           + generateDT("menuAssociatedDEC","getAssocDECs()","Get Associated DEC")
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
		                           + generateDT("menuAssociatedDEC","getAssocDECs()","Get Associated DEC")
				                   + generateDTDisabled("Get Associated VD")
		                           + generateDTDisabled("Monitor")
		                           + generateDTDisabled("Unmonitor")
		                           + separator()
		                           + generateDTDisabled("Append"));
			}
			searchMenu.println(generateDT("","ShowSelectedRows(true)","Show Selected Rows")
					           + generateDT("","clearRecords()","Clear Results"));
			searchMenu.println("</d1>");
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		}
		return EVAL_PAGE;
	}

}
