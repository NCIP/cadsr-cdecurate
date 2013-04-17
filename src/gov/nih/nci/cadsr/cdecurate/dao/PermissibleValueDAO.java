package gov.nih.nci.cadsr.cdecurate.dao;

import gov.nih.nci.cadsr.cdecurate.dto.ConceptBean;
import gov.nih.nci.cadsr.cdecurate.dto.PermissibleValueBean;
import gov.nih.nci.cadsr.cdecurate.dto.ValueMeaningBean;

import java.util.ArrayList;
import java.util.List;

public class PermissibleValueDAO {
	private List<PermissibleValueBean> pvModel;
	private List<PermissibleValueBean> emptyModel;
	private List<PermissibleValueBean> addedPvModel;
	private List<PermissibleValueBean> editedPvModel;
	private List<PermissibleValueBean> editedPvModelWithEditedVm;
	private List<PermissibleValueBean> pvModelFromParent;

	public PermissibleValueDAO() {
		pvModel = new ArrayList<PermissibleValueBean>();
		PermissibleValueBean pv1 = new PermissibleValueBean("Bone", "",
				"02/11/2002", "");
		PermissibleValueBean pv2 = new PermissibleValueBean("CNS", "",
				"02/11/2002", "");
		PermissibleValueBean pv3 = new PermissibleValueBean("Liver", "",
				"03/31/2004", "");
		PermissibleValueBean pv4 = new PermissibleValueBean("Lung", "",
				"11/27/2012", "");

		PermissibleValueBean pv5 = new PermissibleValueBean("Bone Marrow", "",
				"11/27/2012", "");
		ValueMeaningBean vm1 = new ValueMeaningBean("Bone", "2567236", "1.0",
				"Connective tissue that forms the skeletal components of the body. ");

		ConceptDAO conDao = new ConceptDAO();
		List<ConceptBean> vm1Concepts = new ArrayList<ConceptBean>();
		vm1Concepts.add(conDao.getBoneConcept());
		vm1.setConcepts(vm1Concepts);

		ValueMeaningBean vm2 = new ValueMeaningBean(
				"Central Nervous System",
				"2558476",
				"1.0",
				"The main information-processing organs of the nervous system, consisting of the brain, spinal cord, and meninges.");
		List<ConceptBean> vm2Concepts = new ArrayList<ConceptBean>();
		vm2Concepts.add(conDao.getCnsConcept());
		vm2.setConcepts(vm2Concepts);

		ValueMeaningBean vm3 = new ValueMeaningBean(
				"Liver",
				"2567243",
				"1.0",
				"A large organ located in the upper abdomen. The liver cleanses the blood and aids in digestion by secreting bile. ");
		List<ConceptBean> vm3Concepts = new ArrayList<ConceptBean>();
		vm3Concepts.add(conDao.getLiverConcept());
		vm3.setConcepts(vm3Concepts);

		ValueMeaningBean vm4 = new ValueMeaningBean(
				"Lung",
				"2873883",
				"1.0",
				"One of a pair of viscera occupying the pulmonary cavities of the thorax, the organs of respiration in which aeration of the blood takes place. As a rule, the right lung is slightly larger than the left and is divided into three lobes (an upper, a middle, and a lower or basal), while the left has but two lobes (an upper and a lower or basal). Each lung is irregularly conical in shape, presenting a blunt upper extremity (the apex), a concave base following the curve of the diaphragm, an outer convex surface (costal surface), an inner or mediastinal surface (mediastinal surface), a thin and sharp anterior border, and a thick and rounded posterior border. SYN pulmo. ");

		List<ConceptBean> vm4Concepts = new ArrayList<ConceptBean>();
		vm4Concepts.add(conDao.getLungConcept());
		vm4.setConcepts(vm4Concepts);

		ValueMeaningBean vm5 = new ValueMeaningBean(
				"Bone Marrow",
				"2581613",
				"1.0",
				"The tissue occupying the spaces of bone. It consists of blood vessel sinuses and a network of hematopoietic cells which give rise to the red cells, white cells, and megakaryocytes. ");

		pv1.setValueMeaning(vm1);
		pv2.setValueMeaning(vm2);
		pv3.setValueMeaning(vm3);
		pv4.setValueMeaning(vm4);
		pv5.setValueMeaning(vm5);
		pvModel.add(pv1);
		pvModel.add(pv2);
		pvModel.add(pv3);
		emptyModel = new ArrayList<PermissibleValueBean>();
		addedPvModel = new ArrayList<PermissibleValueBean>();
		addedPvModel.add(pv4);
		addedPvModel.add(pv1);
		addedPvModel.add(pv2);
		addedPvModel.add(pv3);

		editedPvModel = new ArrayList<PermissibleValueBean>();
		editedPvModel.add(pv5);
		editedPvModel.add(pv2);
		editedPvModel.add(pv3);

		pvModelFromParent = new ArrayList<PermissibleValueBean>();
		PermissibleValueBean pv6 = new PermissibleValueBean("Microchip Site",
				"", "12/4/2012", "", "Anatomic Site");
		PermissibleValueBean pv7 = new PermissibleValueBean("Infusion Site",
				"", "12/4/2012", " ", "Anatomic Site");

		ValueMeaningBean microChipSiteVm = new ValueMeaningBean(
				"Microchip Site", "", "",
				"The anatomic site at which a microchip is implanted.");
		ConceptBean mcConcept = new ConceptBean("C77682");
		List<ConceptBean> mcConcepts = new ArrayList<ConceptBean>();
		mcConcepts.add(mcConcept);
		microChipSiteVm.setConcepts(mcConcepts);
		
		ValueMeaningBean infusionSiteVm = new ValueMeaningBean("Infusion Site",
				"", "",
				"The anatomic site through which fluid is introduced into the body.");
		ConceptBean isConcept = new ConceptBean("C77679");
		List<ConceptBean> isConcepts = new ArrayList<ConceptBean>();
		isConcepts.add(isConcept);
		infusionSiteVm.setConcepts(isConcepts);

		pv6.setValueMeaning(microChipSiteVm);

		pv7.setValueMeaning(infusionSiteVm);
		pvModelFromParent.add(pv6);
		pvModelFromParent.add(pv7);

		PermissibleValueBean pv8 = new PermissibleValueBean("Bone", "",
				"02/11/2002", "");
		ValueMeaningBean v8 = new ValueMeaningBean(
				"Leg Bone",
				"",
				"",
				"Commonly used to refer to the whole lower limb but technically only the part between the knee and ankle.: Connective tissue that forms the skeletal components of the body.");
		editedPvModelWithEditedVm = new ArrayList<PermissibleValueBean>();
		pv8.setValueMeaning(v8);
		editedPvModelWithEditedVm.add(pv8);
		editedPvModelWithEditedVm.add(pv2);
		editedPvModelWithEditedVm.add(pv3);
	}

	public List<PermissibleValueBean> getPvModel() {
		return pvModel;
	}

	public void setPvModel(List<PermissibleValueBean> pvModel) {
		this.pvModel = pvModel;
	}

	public List<PermissibleValueBean> getEmptyModel() {
		return emptyModel;
	}

	public void setEmptyModel(List<PermissibleValueBean> emptyModel) {
		this.emptyModel = emptyModel;
	}

	public List<PermissibleValueBean> getAddedPvModel() {
		return addedPvModel;
	}

	public void setAddedPvModel(List<PermissibleValueBean> addedPvModel) {
		this.addedPvModel = addedPvModel;
	}

	public List<PermissibleValueBean> getEditedPvModel() {
		return editedPvModel;
	}

	public void setEditedPvModel(List<PermissibleValueBean> editedPvModel) {
		this.editedPvModel = editedPvModel;
	}

	public List<PermissibleValueBean> getPvModelFromParent() {
		return pvModelFromParent;
	}

	public void setPvModelFromParent(
			List<PermissibleValueBean> pvModelFromParent) {
		this.pvModelFromParent = pvModelFromParent;
	}

	public List<PermissibleValueBean> getEditedPvModelWithEditedVm() {
		return editedPvModelWithEditedVm;
	}

	public void setEditedPvModelWithEditedVm(
			List<PermissibleValueBean> editedPvModelWithEditedVm) {
		this.editedPvModelWithEditedVm = editedPvModelWithEditedVm;
	}
}
