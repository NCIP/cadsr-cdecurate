/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.cdecurate.dao;

import gov.nih.nci.cadsr.cdecurate.dto.ConceptBean;

import java.util.ArrayList;
import java.util.List;

public class ConceptDAO {
	private ConceptBean lungConcept;

	private ConceptBean boneConcept;

	private ConceptBean cnsConcept;

	private ConceptBean liverConcept;

	private ConceptBean evsLungConcept;

	private ConceptBean caDSRLungConcept;

	private List<ConceptBean> conceptModel;

	private List<ConceptBean> emptyModel;

	private List<ConceptBean> editPvConceptModel;

	private List<ConceptBean> editVmConceptModel;

	private List<ConceptBean> addedPvConceptModel;

	private List<ConceptBean> parentConceptModel;

	private List<ConceptBean> searchedConceptModel;

	private List<ConceptBean> rightLungConceptModel;

	public ConceptDAO() {
		conceptModel = new ArrayList<ConceptBean>();

		lungConcept = new ConceptBean(
				"Lung",
				"C12468",
				"One of a pair of viscera occupying the pulmonary cavities of the thorax, the organs of respiration in which aeration of the blood takes place. As a rule, the right lung is slightly larger than the left and is divided into three lobes (an upper, a middle, and a lower or basal), while the left has but two lobes (an upper and a lower or basal). Each lung is irregularly conical in shape, presenting a blunt upper extremity (the apex), a concave base following the curve of the diaphragm, an outer convex surface (costal surface), an inner or mediastinal surface (mediastinal surface), a thin and sharp anterior border, and a thick and rounded posterior border. ",
				"Primary", "NCI Thesaurus", 0);
		evsLungConcept = new ConceptBean(
				"Lung",
				"",
				"C12468",
				"One of a pair of viscera occupying the pulmonary cavities of the thorax, the organs of respiration in which aeration of the blood takes place. As a rule, the right lung is slightly larger than the left and is divided into three lobes (an upper, a middle, and a lower or basal), while the left has two lobes (an upper and a lower or basal). Each lung is irregularly conical in shape, presenting a blunt upper extremity (the apex), a concave base following the curve of the diaphragm, an outer convex surface (costal surface), an inner or mediastinal surface (mediastinal surface), a thin and sharp anterior border, and a thick and rounded posterior border. ",
				"NCI", "Active", "", "", "NCI Thesaurus", "");

		caDSRLungConcept = new ConceptBean(
				"Lung",
				"2202738",
				"C12468",
				"One of a pair of viscera occupying the pulmonary cavities of the thorax, the organs of respiration in which aeration of the blood takes place. As a rule, the right lung is slightly larger than the left and is divided into three lobes (an upper, a middle, and a lower or basal), while the left has but two lobes (an upper and a lower or basal). Each lung is irregularly conical in shape, presenting a blunt upper extremity (the apex), a concave base following the curve of the diaphragm, an outer convex surface (costal surface), an inner or mediastinal surface (mediastinal surface), a thin and sharp anterior border, and a thick and rounded posterior border. ",
				"NCI", "RELEASED", "", "caBIG", "caDSR", "Concept Class");
        caDSRLungConcept.setType("Primary");
		
        boneConcept = new ConceptBean(
				"Bone",
				"C12366",
				"Connective tissue that forms the skeletal components of the body.",
				"Primary", "NCI Thesaurus", 0);

		cnsConcept = new ConceptBean(
				"Central Nervous System",
				"C12438",
				"The part of the nervous system that consists of the brain, spinal cord, and meninges.",
				"Primary", "NCI Thesaurus", 0);

		liverConcept = new ConceptBean(
				"Liver",
				"C12392",
				"A triangular-shaped organ located under the diaphragm in the right hypochondrium. It is the largest internal organ of the body, weighting up to 2 kg. Metabolism and bile secretion are its main functions. It is composed of cells which have the ability to regenerate. ",
				"Primary", "NCI Thesaurus", 0);

		conceptModel.add(boneConcept);

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
		ConceptBean legConcept = new ConceptBean(
				"Leg",
				"C32974",
				"Commonly used to refer to the whole lower limb but technically only the part between the knee and ankle.",
				"Qualifier", "NCI Thesaurus", 1);
		editVmConceptModel.add(legConcept);
		editVmConceptModel.add(boneConcept);

		addedPvConceptModel = new ArrayList<ConceptBean>();
		addedPvConceptModel.add(lungConcept);

		ConceptBean rightConcept = new ConceptBean(
				"Right",
				"C25228",
				"Being or located on or directed toward the side of the body to the east when facing north.",
				"Qualifier", "NCI Thesaurus", 1);

		parentConceptModel = new ArrayList<ConceptBean>();
		ConceptBean parentConcept = new ConceptBean("Anatomic Site", "C13717",
				"Named locations of or within the body", "Primary",
				"NCI Thesaurus");
		parentConceptModel.add(parentConcept);

		searchedConceptModel = new ArrayList<ConceptBean>();
		searchedConceptModel.add(caDSRLungConcept);

		rightLungConceptModel = new ArrayList<ConceptBean>();
		rightLungConceptModel.add(rightConcept);
		rightLungConceptModel.add(lungConcept);
	}

	public ConceptBean getEvsLungConcept() {
		return evsLungConcept;
	}

	public ConceptBean getCaDSRLungConcept() {
		return caDSRLungConcept;
	}

	public List<ConceptBean> getSearchedConceptModel() {
		return searchedConceptModel;
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

	public ConceptBean getLungConcept() {
		return lungConcept;
	}

	public ConceptBean getBoneConcept() {
		return boneConcept;
	}

	public ConceptBean getCnsConcept() {
		return cnsConcept;
	}

	public ConceptBean getLiverConcept() {
		return liverConcept;
	}

	public List<ConceptBean> getRightLungConceptModel() {
		return rightLungConceptModel;
	}
}
