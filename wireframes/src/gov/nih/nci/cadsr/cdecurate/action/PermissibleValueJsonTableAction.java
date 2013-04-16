package gov.nih.nci.cadsr.cdecurate.action;

import gov.nih.nci.cadsr.cdecurate.dao.PermissibleValueDAO;
import gov.nih.nci.cadsr.cdecurate.dto.PermissibleValueBean;

import java.util.List;

import com.opensymphony.xwork2.ActionSupport;

public class PermissibleValueJsonTableAction extends ActionSupport {
	private static final long serialVersionUID = -1222865833756493707L;
	private List<PermissibleValueBean> pvModel;
	private List<PermissibleValueBean> emptyModel;
	private List<PermissibleValueBean> addedPvModel;
	private List<PermissibleValueBean> editedPvModel;
	private List<PermissibleValueBean> pvModelFromParent;

	public String execute() {
		PermissibleValueDAO dao = new PermissibleValueDAO();
		this.pvModel = dao.getPvModel();
		this.emptyModel = dao.getEmptyModel();
		this.addedPvModel = dao.getAddedPvModel();
		this.editedPvModel = dao.getEditedPvModel();
		this.pvModelFromParent = dao.getPvModelFromParent();
		return SUCCESS;
	}

	public List<PermissibleValueBean> getPvModel() {
		return pvModel;
	}

	public List<PermissibleValueBean> getEmptyModel() {
		return emptyModel;
	}

	public List<PermissibleValueBean> getAddedPvModel() {
		return addedPvModel;
	}

	public List<PermissibleValueBean> getEditedPvModel() {
		return editedPvModel;
	}

	public List<PermissibleValueBean> getPvModelFromParent() {
		return pvModelFromParent;
	}
}
