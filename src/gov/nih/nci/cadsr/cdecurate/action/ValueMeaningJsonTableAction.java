package gov.nih.nci.cadsr.cdecurate.action;

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
    
	public String execute() {
		vmModel = new ArrayList<ValueMeaningBean>();
		ValueMeaningBean vm1 = new ValueMeaningBean("No", "2559515", "1.0",
				"Earlier in time or order");
		vmModel.add(vm1);
		return SUCCESS;
	}

	public List<ValueMeaningBean> getVmModel() {
		return vmModel;
	}
}
