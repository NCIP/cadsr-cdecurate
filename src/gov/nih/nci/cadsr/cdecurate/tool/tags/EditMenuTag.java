package gov.nih.nci.cadsr.cdecurate.tool.tags;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;

/**
 * This JSP tag library class is for Edit Menu
 * @author hveerla
 *
 */
public class EditMenuTag extends MenuTag {

	public int doEndTag() throws JspException {
		getSessionAttributes();
		JspWriter editMenu = this.pageContext.getOut();
		if (selACType != null) {
			try {
				editMenu.println("<dl class=\"menu\">");
				if ((selACType).equals("DataElement")) {
					editMenu.println(generateDT("editMenuEdit","javascript:BlockEdit()","Edit")
							         + generateDT("editMenuBlockEdit","javascript:BlockEdit()","Block Edit")
							         + generateDT("","javascript:designateRecord()","Designate")
							         + generateDT("Data Element")
							         + generateDT("Data Element Concept")
							         + generateDT("Value Domain"));
				}
				if ((selACType).equals("DataElementConcept")) {
					editMenu.println(generateDT("editMenuEdit","javascript:BlockEdit()","Edit")
					                 + generateDT("editMenuBlockEdit","javascript:BlockEdit()","Block Edit")
					                 + generateDTDisabled("Designate")
					                 + generateDT("Data Element")
					                 + generateDT("Data Element Concept")
					                 + generateDT("Value Domain"));
				}
				if ((selACType).equals("ValueDomain")) {
					editMenu.println(generateDT("editMenuEdit","javascript:BlockEdit()","Edit")
					                 + generateDT("editMenuBlockEdit","javascript:BlockEdit()","Block Edit")
					                 + generateDTDisabled("Designate")
					                 + generateDT("Data Element")
					                 + generateDT("Data Element Concept")
					                 + generateDT("Value Domain"));
				}
				if ((selACType).equals("ValueMeaning")) {
					editMenu.println(generateDT("editMenuEdit","javascript:BlockEdit()","Edit")
					                 + generateDTDisabled("Block Edit")
					                 + generateDTDisabled("Designate")
					                 + generateDT("Data Element")
					                 + generateDT("Data Element Concept")
					                 + generateDT("Value Domain"));
				}
				if ((selACType).equals("ConceptualDomain")) {
					editMenu.println(generateDTDisabled("Edit")
					                 + generateDTDisabled("Block Edit")
					                 + generateDTDisabled("Designate")
					                 + generateDT("Data Element")
					                 + generateDT("Data Element Concept")
					                 + generateDT("Value Domain"));
				}
				if ((selACType).equals("PermissibleValue")) {
					editMenu.println(generateDTDisabled("Edit")
					                 + generateDTDisabled("Block Edit")
					                 + generateDTDisabled("Designate")
					                 + generateDT("Data Element")
					                 + generateDT("Data Element Concept")
					                 + generateDT("Value Domain"));
				}
				if ((selACType).equals("ClassSchemeItems")) {
					editMenu.println(generateDTDisabled("Edit")
					                 + generateDTDisabled("Block Edit")
					                 + generateDTDisabled("Designate")
					                 + generateDT("Data Element")
					                 + generateDT("Data Element Concept")
					                 + generateDT("Value Domain"));
				}
				if ((selACType).equals("ConceptClass")) {
					editMenu.println(generateDTDisabled("Edit")
					                 + generateDTDisabled("Block Edit")
					                 + generateDTDisabled("Designate")
					                 + generateDT("Data Element")
					                 + generateDT("Data Element Concept")
					                 + generateDT("Value Domain"));
				}
				if ((selACType).equals("ObjectClass")) {
					editMenu.println(generateDTDisabled("Edit")
					                 + generateDTDisabled("Block Edit")
					                 + generateDTDisabled("Designate")
					                 + generateDT("Data Element")
					                 + generateDT("Data Element Concept")
					                 + generateDT("Value Domain"));
				}
				if ((selACType).equals("Property")) {
					editMenu.println(generateDTDisabled("Edit")
					                 + generateDTDisabled("Block Edit")
					                 + generateDTDisabled("Designate")
					                 + generateDT("Data Element")
					                 + generateDT("Data Element Concept")
					                 + generateDT("Value Domain"));
				}
				editMenu.println("</d1>");
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		return EVAL_PAGE;
	}

}


