/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.cdecurate.action;

import gov.nih.nci.cadsr.cdecurate.dao.ConceptDAO;
import gov.nih.nci.cadsr.cdecurate.dto.ConceptBean;

import java.util.List;

import com.opensymphony.xwork2.ActionSupport;

public class ConceptJsonTableAction extends ActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = -5600936713061463274L;
	/**
	 * 
	 */
	private List<ConceptBean> conceptModel;

	private List<ConceptBean> emptyModel;

	private List<ConceptBean> editPvConceptModel;

	private List<ConceptBean> editVmConceptModel;

	private List<ConceptBean> addedPvConceptModel;

	private List<ConceptBean> parentConceptModel;

	private List<ConceptBean> searchedConceptModel;

	private List<ConceptBean> rightLungConceptModel;

	public String execute() {
		ConceptDAO dao = new ConceptDAO();
		this.conceptModel = dao.getConceptModel();
		this.emptyModel = dao.getEmptyModel();
		this.editPvConceptModel = dao.getEditPvConceptModel();
		this.editVmConceptModel = dao.getEditVmConceptModel();
		this.addedPvConceptModel = dao.getAddedPvConceptModel();
		this.parentConceptModel = dao.getParentConceptModel();
		this.searchedConceptModel = dao.getSearchedConceptModel();
		this.rightLungConceptModel = dao.getRightLungConceptModel();
		return SUCCESS;
	}

	public List<ConceptBean> getConceptModel() {
		return conceptModel;
	}

	public List<ConceptBean> getEmptyModel() {
		return emptyModel;
	}

	public List<ConceptBean> getEditPvConceptModel() {
		return editPvConceptModel;
	}

	public List<ConceptBean> getEditVmConceptModel() {
		return editVmConceptModel;
	}

	public List<ConceptBean> getAddedPvConceptModel() {
		return addedPvConceptModel;
	}

	public List<ConceptBean> getParentConceptModel() {
		return parentConceptModel;
	}

	public List<ConceptBean> getSearchedConceptModel() {
		return searchedConceptModel;
	}

	public List<ConceptBean> getRightLungConceptModel() {
		return rightLungConceptModel;
	}

}
