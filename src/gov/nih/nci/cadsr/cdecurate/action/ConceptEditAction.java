package gov.nih.nci.cadsr.cdecurate.action;

import gov.nih.nci.cadsr.cdecurate.dao.ConceptDAO;
import gov.nih.nci.cadsr.cdecurate.dto.ConceptBean;

import java.util.List;
import java.util.Map;

import org.apache.struts2.interceptor.SessionAware;

import com.opensymphony.xwork2.ActionSupport;

public class ConceptEditAction extends ActionSupport implements SessionAware {
	/**
	 * 
	 */
	private static final long serialVersionUID = 931810323420585969L;
	private String oper = "";
	private Map<String, Object> session;
	private List<ConceptBean> myConcepts;

	public String execute() throws Exception {
		ConceptDAO dao = new ConceptDAO();
		myConcepts = dao.getEditVmConceptModel();

		if (oper.equalsIgnoreCase("del")) {
			myConcepts.remove(0);
		}

		session.put("mylist", myConcepts);
		return NONE;
	}

	public void setSession(Map<String, Object> session) {
		this.session = session;
	}

	public void setOper(String oper) {
		this.oper = oper;
	}

}
