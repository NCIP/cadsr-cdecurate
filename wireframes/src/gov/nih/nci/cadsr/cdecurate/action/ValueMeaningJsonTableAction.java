/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.cdecurate.action;

import gov.nih.nci.cadsr.cdecurate.dao.ValueMeaningDAO;
import gov.nih.nci.cadsr.cdecurate.dto.ValueMeaningBean;

import java.util.ArrayList;
import java.util.List;

import com.opensymphony.xwork2.ActionSupport;

public class ValueMeaningJsonTableAction extends ActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 2023473954397188567L;
	private List<ValueMeaningBean> vmModel;
	private ValueMeaningBean vmDisplay;
	private List<ValueMeaningBean> matchedVmModel;
	private List<ValueMeaningBean> secondMatchedVmModel;

	public String execute() {
		vmModel = new ArrayList<ValueMeaningBean>();
		ValueMeaningBean vm1 = new ValueMeaningBean("No", "2559515", "1.0",
				"Earlier in time or order");
		vmModel.add(vm1);
		vmDisplay = vm1;

		ValueMeaningDAO vmDao = new ValueMeaningDAO();
		matchedVmModel = vmDao.getMatchedVms();
		secondMatchedVmModel = vmDao.getSecondMatchedVms();
		return SUCCESS;
	}

	public List<ValueMeaningBean> getVmModel() {
		return vmModel;
	}

	public ValueMeaningBean getVmDisplay() {
		return vmDisplay;
	}

	public List<ValueMeaningBean> getMatchedVmModel() {
		return matchedVmModel;
	}

	public List<ValueMeaningBean> getSecondMatchedVmModel() {
		return secondMatchedVmModel;
	}
}
