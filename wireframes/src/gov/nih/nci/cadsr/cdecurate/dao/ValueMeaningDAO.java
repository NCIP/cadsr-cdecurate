/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.cdecurate.dao;

import gov.nih.nci.cadsr.cdecurate.dto.ValueMeaningBean;

import java.util.ArrayList;
import java.util.List;

public class ValueMeaningDAO {
	List<ValueMeaningBean> matchedVms = new ArrayList<ValueMeaningBean>();
	List<ValueMeaningBean> secondMatchedVms = new ArrayList<ValueMeaningBean>();

	public ValueMeaningDAO() {

		ValueMeaningBean lung1Vm = new ValueMeaningBean("Bronchus And Lung",
				"3394018", "1.0", "RELEASED", "C12683: C37912: C12468: C13717",
				"");
		ValueMeaningBean lung2Vm = new ValueMeaningBean("Lung", "2567244",
				"1.0", "RELEASED", "C12468", "");
		ValueMeaningBean lung3Vm = new ValueMeaningBean("Lung", "2873883",
				"1.0", "RELEASED", "C12468", "");

		ValueMeaningBean lung4Vm = new ValueMeaningBean("And Bronchus Lung",
				"2798717", "1.0", "DRAFT NEW", "C37912: C12683: C12468", "");

		ValueMeaningBean lung5Vm = new ValueMeaningBean("And Lung Bronchus",
				"2861015", "1.0", "DRAFT NEW", "C37912: C12468: C12683", "");

		ValueMeaningBean lung6Vm = new ValueMeaningBean("Bone And Lung",
				"3438548", "1.0", "DRAFT NEW", "C12366: C37912: C12468", "");

		ValueMeaningBean rightLungVm = new ValueMeaningBean(
				"Right Lung",
				"3412542 ",
				"1.0",
				"DRAFT NEW",
				"C25228: C12468",
				"Right; being or located on or directed toward the side of the body to the east when facing north.: O…ne of a pair of viscera occupying the pulmonary cavities of the thorax, the organs of respiration in which aeration of the blood takes place. As a rule, the right lung is slightly larger than the left and is divided into three lobes (an upper, a middle, and a lower or basal), while the left has but two lobes (an upper and a lower or basal). Each lung is irregularly conical in shape, presenting a blunt upper extremity (the apex), a concave base following the curve of the diaphragm, an outer convex surface (costal surface), an inner or mediastinal surface (mediastinal surface), a thin and sharp anterior border, and a thick and rounded posterior border.");
		rightLungVm.setReason("name matches");
		ValueMeaningBean rightLung2Vm = new ValueMeaningBean(
				"Right Lung",
				"2721630  ",
				"1.0",
				"DRAFT NEW",
				"C25228: C12468",
				"Right; being or located on or directed toward the side of the body to the east when facing north.: O…ne of a pair of viscera occupying the pulmonary cavities of the thorax, the organs of respiration in which aeration of the blood takes place. As a rule, the right lung is slightly larger than the left and is divided into three lobes (an upper, a middle, and a lower or basal), while the left has but two lobes (an upper and a lower or basal). Each lung is irregularly conical in shape, presenting a blunt upper extremity (the apex), a concave base following the curve of the diaphragm, an outer convex surface (costal surface), an inner or mediastinal surface (mediastinal surface), a thin and sharp anterior border, and a thick and rounded posterior border. SYN pulmo.");
		rightLung2Vm.setReason("name matches");
		matchedVms.add(lung1Vm);
		matchedVms.add(lung2Vm);
		matchedVms.add(lung3Vm);
		matchedVms.add(lung4Vm);
		matchedVms.add(lung5Vm);
		matchedVms.add(lung6Vm);

		secondMatchedVms.add(rightLungVm);
		secondMatchedVms.add(rightLung2Vm);
	}

	public List<ValueMeaningBean> getMatchedVms() {
		return matchedVms;
	}

	public List<ValueMeaningBean> getSecondMatchedVms() {
		return secondMatchedVms;
	}
}
