/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.cdecurate.action;

import gov.nih.nci.cadsr.cdecurate.dto.PermissibleValueBean;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.struts2.interceptor.SessionAware;

import com.opensymphony.xwork2.ActionSupport;


public class EditPermissibleValueAction extends ActionSupport implements
		SessionAware {
	/**
	 * 
	 */
	private static final long serialVersionUID = 3719530575026525804L;
	private String oper = "";
	private Map<String, Object> session;
	private List<PermissibleValueBean> permissibleValues;
	
	public String execute() throws Exception {
		Object list = session.get("mylist");
		if (list != null) {
			permissibleValues = (List<PermissibleValueBean>) list;
		} else {
			permissibleValues = new ArrayList<PermissibleValueBean>();
		}

		PermissibleValueBean permissibleValue;

		if (oper.equalsIgnoreCase("edit")) {
			// customer = CustomerDAO.findById(myCustomers,
			// Integer.parseInt(id));
			// customer.setName(name);
			// customer.setCountry(country);
			// customer.setCity(city);
			// customer.setCreditLimit(creditLimit);
		} else if (oper.equalsIgnoreCase("del")) {
			// StringTokenizer ids = new StringTokenizer(id, ",");
			// while (ids.hasMoreTokens()) {
			// int removeId = Integer.parseInt(ids.nextToken());
			// log.debug("Delete Customer " + removeId);
			// customer = CustomerDAO.findById(myCustomers, removeId);
			// myCustomers.remove(customer);
			// }
		}

		session.put("mylist", permissibleValues);

		return SUCCESS;
	}

	// public String getId() {
	// return id;
	// }
	//
	// public void setId(String id) {
	// this.id = id;
	// }
	//
	// public String getName() {
	// return name;
	// }
	//
	// public void setName(String name) {
	// this.name = name;
	// }
	//
	// public String getCountry() {
	// return country;
	// }
	//
	// public void setCountry(String country) {
	// this.country = country;
	// }
	//
	// public String getCity() {
	// return city;
	// }
	//
	// public void setCity(String city) {
	// this.city = city;
	// }
	//
	// public double getCreditLimit() {
	// return creditLimit;
	// }
	//
	// public void setCreditLimit(double creditLimit) {
	// this.creditLimit = creditLimit;
	// }

	public void setSession(Map<String, Object> session) {
		this.session = session;
	}

	public void setOper(String oper) {
		this.oper = oper;
	}
}
