package gov.nih.nci.cadsr.cdecurate.dao;

import gov.nih.nci.cadsr.cdecurate.dto.ConceptBean;

import java.util.ArrayList;
import java.util.List;

public class ConceptDAO {
	private List<ConceptBean> conceptModel;

	private List<ConceptBean> emptyModel;

	private List<ConceptBean> editPvConceptModel;

	private List<ConceptBean> editVmConceptModel;

	private List<ConceptBean> addedPvConceptModel;

	private List<ConceptBean> parentConceptModel;

	public ConceptDAO() {
		conceptModel = new ArrayList<ConceptBean>();
		ConceptBean lungConcept = new ConceptBean(
				"Lung",
				"C12468",
				"One of a pair of viscera occupying the pulmonary cavities of the thorax, the organs of respiration in which aeration of the blood takes place. As a rule, the right lung is slightly larger than the left and is divided into three lobes (an upper, a middle, and a lower or basal), while the left has but two lobes (an upper and a lower or basal). Each lung is irregularly conical in shape, presenting a blunt upper extremity (the apex), a concave base following the curve of the diaphragm, an outer convex surface (costal surface), an inner or mediastinal surface (mediastinal surface), a thin and sharp anterior border, and a thick and rounded posterior border. ",
				"Primary", "NCI Thesaurus");
		ConceptBean concept1 = new ConceptBean(
				"Bone",
				"C12366",
				"Connective tissue that forms the skeletal components of the body.",
				"Primary", "NCI Thesaurus");
		conceptModel.add(concept1);
		
		emptyModel = new ArrayList<ConceptBean>();
		editPvConceptModel = new ArrayList<ConceptBean>();
		ConceptBean concept2 = new ConceptBean(
				"Bone Marrow",
				"C12431",
				"The tissue occupying the spaces of bone. It consists of blood vessel sinuses and a network of hematopoietic cells which give rise to the red cells, white cells, and megakaryocytes",
				"Primary", "NCI Thesaurus");
		// editPvConceptModel.add(concept1);
		editPvConceptModel.add(concept2);
		editVmConceptModel = new ArrayList<ConceptBean>();
		editVmConceptModel.add(concept1);
		editVmConceptModel.add(lungConcept);
		addedPvConceptModel = new ArrayList<ConceptBean>();
		addedPvConceptModel.add(lungConcept);

		parentConceptModel = new ArrayList<ConceptBean>();
		ConceptBean parentConcept = new ConceptBean("Anatomic Site", "C13717",
				"Named locations of or within the body", "Primary",
				"NCI Thesaurus");
		parentConceptModel.add(parentConcept);
	}

	public List<ConceptBean> getConceptModel() {
		return conceptModel;
	}

	public void setConceptModel(List<ConceptBean> conceptModel) {
		this.conceptModel = conceptModel;
	}

	public List<ConceptBean> getEmptyModel() {
		return emptyModel;
	}

	public void setEmptyModel(List<ConceptBean> emptyModel) {
		this.emptyModel = emptyModel;
	}

	public List<ConceptBean> getEditPvConceptModel() {
		return editPvConceptModel;
	}

	public void setEditPvConceptModel(List<ConceptBean> editPvConceptModel) {
		this.editPvConceptModel = editPvConceptModel;
	}

	public List<ConceptBean> getEditVmConceptModel() {
		return editVmConceptModel;
	}

	public void setEditVmConceptModel(List<ConceptBean> editVmConceptModel) {
		this.editVmConceptModel = editVmConceptModel;
	}

	public List<ConceptBean> getAddedPvConceptModel() {
		return addedPvConceptModel;
	}

	public void setAddedPvConceptModel(List<ConceptBean> addedPvConceptModel) {
		this.addedPvConceptModel = addedPvConceptModel;
	}

	public List<ConceptBean> getParentConceptModel() {
		return parentConceptModel;
	}

	public void setParentConceptModel(List<ConceptBean> parentConceptModel) {
		this.parentConceptModel = parentConceptModel;
	}
}
