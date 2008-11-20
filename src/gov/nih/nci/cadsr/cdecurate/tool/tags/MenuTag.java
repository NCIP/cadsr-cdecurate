package gov.nih.nci.cadsr.cdecurate.tool.tags;

import java.util.Vector;

import gov.nih.nci.cadsr.cdecurate.tool.Session_Data;

import javax.servlet.http.HttpSession;
import javax.servlet.jsp.tagext.TagSupport;

public class MenuTag extends TagSupport {
	String MenuAction = "";
	String selACType = "";
	Vector vCheckList = new Vector();
	String sSelectAll = "false";
	
	public void getSessionAttributes(){
		HttpSession session = pageContext.getSession();
		if (session!=null){
		 MenuAction = (String) session.getAttribute(Session_Data.SESSION_MENU_ACTION);
		}
		if(MenuAction!=null){
			if (MenuAction.equals("searchForCreate")) {
				selACType = (String) session.getAttribute("creSearchAC"); 
				vCheckList = (Vector) session.getAttribute("creCheckList");
			} else {
				selACType = (String) session.getAttribute("searchAC");
				vCheckList = (Vector) session.getAttribute("CheckList");
			}
		}
		if (!selACType.equals("ValueMeaning")) {
			if (vCheckList != null && vCheckList.size() > 0)
				sSelectAll = "true";
			else
				sSelectAll = "false";
		}
	}
	public String generateDT(String id, String jsMethod, String value){
		String tag ="<dt id = \"" + id + "\" onmouseover=\"menuItemFocus(this);\" onmouseout=\"menuItemNormal(this);\"  onclick=\"" + jsMethod + ";\">" + value ;
		return tag;
	}
	public String generateDT(String value){
		String tag ="<dt onmouseover=\"menuItemFocus(this);\" onmouseout=\"menuItemNormal(this);\">" + value;;
		return tag;
	}
	public String generateDTDisabled(String value){
		String tag ="<dt menuEnable=\"false\" onmouseover=\"menuItemFocus(this);\" onmouseout=\"menuItemNormal(this);\">" + value;
		return tag;
	}
	public String separator(){
		String tag ="</dl><div class=\"hrWrap\" align=\"center\"><hr class=\"xyz\"/></div><dl class=\"menu\">";
		return tag;
	}
	public String generateImage(){
		String tag = "<img src=\"http://cdecurate.nci.nih.gov/cdecurate/images/CheckBox.gif\" border=\"0\">";
		return tag;
		
	}

}
