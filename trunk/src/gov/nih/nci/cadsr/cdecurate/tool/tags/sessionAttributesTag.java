/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.tool.tags;

import gov.nih.nci.cadsr.cdecurate.tool.Session_Data;

import java.util.Stack;
import java.util.Vector;

import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

/**
 * @author hveerla
 *
 */
public class sessionAttributesTag extends TagSupport {

	public int doEndTag() throws JspException {
		HttpSession session = pageContext.getSession();

		String sMenuAction4 = (String) session.getAttribute(Session_Data.SESSION_MENU_ACTION);
		String sSelAC4 = "";
		String sSearchAC4 = "";
		Vector vACAttr4 = new Vector();
		Vector vSelAttr4 = new Vector();

		if (sMenuAction4.equals("searchForCreate")) {
			sSearchAC4 = (String) session.getAttribute("creSearchAC");
			sSelAC4 = (String) session.getAttribute("creSearchAC");
			vACAttr4 = (Vector) session.getAttribute("creAttributeList");
		} else {
			sSearchAC4 = (String) session.getAttribute("searchAC");
			sSelAC4 = (String) session.getAttribute("searchAC");
			vACAttr4 = (Vector) session.getAttribute("serAttributeList");
		}
		String sBackFromGetAssociated2 = (String) session.getAttribute("backFromGetAssociated");
		if (sBackFromGetAssociated2 == null)
			sBackFromGetAssociated2 = "";
		String sSecondBackFromGetAssociated2 = (String) session.getAttribute("SecondBackFromGetAssociated");
		if (sSecondBackFromGetAssociated2 == null)
			sSecondBackFromGetAssociated2 = "";
		if (sBackFromGetAssociated2.equals("backFromGetAssociated")) {
			Stack sSearchACStack = (Stack) session.getAttribute("sSearchACStack");
			if (sSearchACStack != null && sSearchACStack.size() > 0){
				sSearchAC4 = (String) sSearchACStack.pop();
				sSelAC4 = sSearchAC4;
			}
			if (sSearchACStack != null && sSearchACStack.size() > 0 ){
				sSearchAC4 = (String) sSearchACStack.pop();
				sSelAC4 = sSearchAC4;
				sSearchACStack.push(sSelAC4);
				session.setAttribute("sSearchACStack", sSearchACStack);
				session.setAttribute("searchAC", sSelAC4);
			}
			session.setAttribute("searchAC", sSearchAC4);
			Stack vCompAttrStack = (Stack) session.getAttribute("vCompAttrStack");
			if (vCompAttrStack != null && vCompAttrStack.size() > 0){
				vSelAttr4 = (Vector) vCompAttrStack.pop();
			}
			if (vCompAttrStack != null && vCompAttrStack.size() > 0) {
				vSelAttr4 = (Vector) vCompAttrStack.pop();
				vCompAttrStack.push(vSelAttr4);
				session.setAttribute("vCompAttrStack", vCompAttrStack);
				session.setAttribute("selectedAttr", vSelAttr4);
			}
			Stack vAttributeListStack = (Stack) session.getAttribute("vAttributeListStack");
			if (vAttributeListStack != null && vAttributeListStack.size() > 0){
				vACAttr4 = (Vector) vAttributeListStack.pop();
			}
			if (vAttributeListStack != null && vAttributeListStack.size() > 0) {
				vACAttr4 = (Vector) vAttributeListStack.pop();
				vAttributeListStack.push(vACAttr4);
				session.setAttribute("vAttributeListStack",	vAttributeListStack);
				session.setAttribute("serAttributeList", vACAttr4);
			}
		}

		return EVAL_PAGE;
	}

}
