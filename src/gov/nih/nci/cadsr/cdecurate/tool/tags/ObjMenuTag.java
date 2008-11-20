/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.tool.tags;

import java.io.IOException;

import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;

/**
 * This JSP tag library class is for action Menu
 * @author hveerla
 *
 */
public class ObjMenuTag extends MenuTag {
		
	public int doEndTag() throws JspException {
		
		getSessionAttributes();
		HttpSession session = pageContext.getSession();
		int rowsChecked = 0;
		if (vCheckList!=null){
		    rowsChecked = vCheckList.size();
		}
		JspWriter objMenu = this.pageContext.getOut();
		if (selACType != null) {
			try {
				objMenu.println("<p style=\"margin: 0px 0px 5px 0px; color: red\"><span id=\"selCnt\">" + rowsChecked + "</span> Record(s) Selected</p>");
				objMenu.println("<dl class=\"menu\">");
				if ((selACType).equals("DataElement")) {
					objMenu.println(generateDT("edit","javascript:performAction('edit')","Edit")
									  + generateDT("blockEdit","javascript:performAction('blockEdit')","Block Edit")
									  + generateDT("","javascript:performAction('designate');","Designate")
									  + generateDT("details","javascript:GetDetails()","View Details")
									  + generateDT("associatedDEC","javascript:getAssocDECs()","Get Associated DEC")
									  + generateDT("associatedVD","javascript:getAssocVDs()","Get Associated VD")
									  + generateDT("uploadDoc","javascript:performAction('uploadDoc')","Upload Document(s)")
									  + generateDT("","javascript:performAction('monitor');","Monitor")
									  + generateDT("","javascript:performAction('unmonitor')","Unmonitor")
									  + separator()
									  + generateDT("newUE","javascript:createNew('newUsingExisting')","New Using Existing")
									  + generateDT("newVersion","javascript:createNew('newVersion')","New Version")
									  + separator()
									  + generateDT("","javascript:performAction('append')","Append"));
				}
				if ((selACType).equals("DataElementConcept")) {
					objMenu.println(generateDT("edit","javascript:performAction('edit')","Edit")
									  + generateDT("blockEdit","javascript:performAction('blockEdit')","Block Edit")
									  + generateDT("associatedDE","javascript:getAssocDEs()","Get Associated DE")
									  + generateDT("uploadDoc","javascript:performAction('uploadDoc')","Upload Document(s)")
									  + generateDT("","javascript:performAction('monitor');","Monitor")
									  + generateDT("","javascript:performAction('unmonitor')","Unmonitor")
									  + separator()
									  + generateDT("newUE","javascript:createNew('newUsingExisting')","New Using Existing")
									  + generateDT("newVersion","javascript:createNew('newVersion')","New Version")
									  + separator()
									  + generateDT("","javascript:performAction('append')","Append"));
				}
				if ((selACType).equals("ValueDomain")) {
					objMenu.println(generateDT("edit","javascript:performAction('edit')","Edit")
									  + generateDT("blockEdit","javascript:performAction('blockEdit')","Block Edit")
									  + generateDT("associatedDE","javascript:getAssocDEs()","Get Associated DE")
									  + generateDT("uploadDoc","javascript:performAction('uploadDoc')","Upload Document(s)")
									  + generateDT("","javascript:performAction('monitor');","Monitor")
									  + generateDT("","javascript:performAction('unmonitor')","Unmonitor")
									  + separator()
									  + generateDT("newUE","javascript:createNew('newUsingExisting')","New Using Existing")
									  + generateDT("newVersion","javascript:createNew('newVersion')","New Version")
									  + separator()
									  + generateDT("","javascript:performAction('append')","Append"));
				}
				if ((selACType).equals("ConceptualDomain")) {
					objMenu.println(generateDT("associatedDE","javascript:getAssocDEs()","Get Associated DE")
							          + generateDT("associatedDEC","javascript:getAssocDECs()","Get Associated DEC")
							          + generateDT("associatedVD","javascript:getAssocVDs()","Get Associated VD")
							          + separator());
				}
				if ((selACType).equals("PermissibleValue")) {
					objMenu.println(generateDT("associatedDE","javascript:getAssocDEs()","Get Associated DE")
							          + generateDT("associatedVD","javascript:getAssocVDs()","Get Associated VD")
							          + separator());
				}
				if ((selACType).equals("ClassSchemeItems")){
					objMenu.println(generateDT("associatedDE","javascript:getAssocDEs()","Get Associated DE")
							          + generateDT("associatedDEC","javascript:getAssocDECs()","Get Associated DEC")
							          + generateDT("associatedVD","javascript:getAssocVDs()","Get Associated VD")
							          + separator());
				}          
				if ((selACType).equals("ValueMeaning")) {
					objMenu.println(generateDT("edit","javascript:performAction('edit')","Edit")
							          + generateDT("associatedDE","javascript:getAssocDEs()","Get Associated DE")
							          + generateDT("associatedVD","javascript:getAssocVDs()","Get Associated VD")
							          + separator());
				}
				if ((selACType).equals("ConceptClass")) {
					objMenu.println(generateDT("associatedDE","javascript:getAssocDEs()","Get Associated DE")
							          + generateDT("associatedDEC","javascript:getAssocDECs()","Get Associated DEC")
							          + generateDT("associatedVD","javascript:getAssocVDs()","Get Associated VD")
							          + separator());
				}
				if ((selACType).equals("ObjectClass")){
					objMenu.println(generateDT("associatedDEC","javascript:getAssocDECs()","Get Associated DEC")
							          + separator());
				}
				if ((selACType).equals("Property")) {
					objMenu.println(generateDT("associatedDEC","javascript:getAssocDECs()","Get Associated DEC")
							          + separator());
				}
				
				objMenu.println(generateDT("","javascript:ShowSelectedRows(true)","Show Selected Rows")
						          + separator());
				if (sSelectAll.equals("true")){
					objMenu.println(generateDT("","javascript:SelectAllCheckBox()","Clear All") 
							          +generateImage());
                 }else{
                	 objMenu.println(generateDT("","javascript:SelectAllCheckBox()","Select All") 
					                   +generateImage());  
                 }
				objMenu.println("</dl>");

			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return EVAL_PAGE;
	}
	
}
