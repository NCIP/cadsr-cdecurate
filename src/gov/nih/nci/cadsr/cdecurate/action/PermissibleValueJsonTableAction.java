package gov.nih.nci.cadsr.cdecurate.action;

import gov.nih.nci.cadsr.cdecurate.dao.PermissibleValueDAOImpl;
import gov.nih.nci.cadsr.cdecurate.dto.ConceptBean;
import gov.nih.nci.cadsr.cdecurate.dto.PermissibleValueBean;
import gov.nih.nci.cadsr.cdecurate.dto.ValueMeaningBean;
import gov.nih.nci.cadsr.cdecurate.tool.EVS_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.PV_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.VD_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.VM_Bean;
import gov.nih.nci.cadsr.cdecurate.util.Comparators;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.apache.struts2.interceptor.SessionAware;

import com.opensymphony.xwork2.ActionSupport;

public class PermissibleValueJsonTableAction extends ActionSupport implements
		SessionAware {
	private Map<String, Object> session;
	private static final long serialVersionUID = -1222865833756493707L;
	private List<PermissibleValueBean> permissibleValues;
	private List<PermissibleValueBean> pvModel = new ArrayList<PermissibleValueBean>();
	// get how many rows we want to have into the grid - rowNum attribute in the
	// grid
	private Integer rows = 0;

	// Get the requested page. By default grid sets this to 1.
	private Integer page = 0;

	// sorting order - asc or desc
	private String sord;

	// get index row - i.e. user click to sort.
	private String sidx;

	// Limit the result when using local data, value form attribute rowTotal
	private Integer totalrows;

	// Your Total Pages
	private Integer total = 0;

	// All Records
	private Integer records = 0;

	private boolean loadonce = false;

	private List<PermissibleValueBean> emptyModel;
	private List<PermissibleValueBean> addedPvModel;
	private List<PermissibleValueBean> editedPvModel;
	private List<PermissibleValueBean> pvModelFromParent;
	private List<PermissibleValueBean> editedPvModelWithEditedVm;

	public String execute() {
		PermissibleValueDAOImpl dao = new PermissibleValueDAOImpl();
		// populate PVs stored in the session
		VD_Bean thisVD = (VD_Bean) session.get("m_VD");
		// TODO manage pvList when session is null
		java.util.Vector<PV_Bean> pvList = thisVD.getVD_PV_List();
		permissibleValues = new ArrayList<PermissibleValueBean>();
		for (PV_Bean pv : pvList) {
			String value = pv.getPV_VALUE();
			String origin = pv.getPV_VALUE_ORIGIN();
			String beginDate = pv.getPV_BEGIN_DATE();
			String endDate = pv.getPV_END_DATE();
			VM_Bean vm = pv.getPV_VM();
			Vector<EVS_Bean> concepts = vm.getVM_CONCEPT_LIST();
			ValueMeaningBean vmBean = new ValueMeaningBean(
					vm.getVM_LONG_NAME(), vm.getVM_ID(), vm.getVM_VERSION(),
					vm.getVM_PREFERRED_DEFINITION());
			List<ConceptBean> conceptBeans = new ArrayList<ConceptBean>();

			for (EVS_Bean concept : concepts) {
				ConceptBean conceptBean = new ConceptBean(
						concept.getCONCEPT_NAME(),
						concept.getCONCEPT_IDENTIFIER(),
						concept.getPREFERRED_DEFINITION(),
						concept.getPRIMARY_FLAG(),
						concept.getEVS_CONCEPT_SOURCE());
				conceptBeans.add(conceptBean);
			}
			vmBean.setConcepts(conceptBeans);
			PermissibleValueBean pvBean = new PermissibleValueBean(value,
					origin, beginDate, endDate);
			pvBean.setValueMeaning(vmBean);
			pvBean.setId(pv.getPV_PV_IDSEQ());
			permissibleValues.add(pvBean);
		}

		// set parameters needed for paging and sorting in the grid
		setParameters(permissibleValues);

		if (permissibleValues.size() == 0) {
			session.put("hasExistingPVs", 0);
		} else {
			session.put("pvList", permissibleValues);
		}
		// this.pvModel = dao.getPvModel();
//		this.emptyModel = dao.getEmptyModel();
//		this.addedPvModel = dao.getAddedPvModel();
//		this.editedPvModel = dao.getEditedPvModel();
//		this.pvModelFromParent = dao.getPvModelFromParent();
//		this.editedPvModelWithEditedVm = dao.getEditedPvModelWithEditedVm();
		return SUCCESS;
	}

	private void setParameters(List<PermissibleValueBean> permissibleValues) {
		// Handle Sorting
		if (sidx != null && !sidx.equals("")) {
			if (sidx.equals("value")) {
				Collections.sort(permissibleValues,
						new Comparators.PermissibleValueBeanValueComparator());
				if (sord != null && sord.equals("desc"))
					Collections.reverse(permissibleValues);
			} else if (sidx.equals("beginDate")) {
				Collections
						.sort(permissibleValues,
								new Comparators.PermissibleValueBeanBeginDateComparator());
				if (sord != null && sord.equals("desc"))
					Collections.reverse(permissibleValues);
			} else if (sidx.equals("endDate")) {
				Collections
						.sort(permissibleValues,
								new Comparators.PermissibleValueBeanEndDateComparator());
				if (sord != null && sord.equals("desc"))
					Collections.reverse(permissibleValues);
			} else if (sidx.equals("concepts")) {
				Collections
						.sort(permissibleValues,
								new Comparators.PermissibleValueBeanConceptComparator());
				if (sord != null && sord.equals("desc"))
					Collections.reverse(permissibleValues);
			} else if (sidx.equals("vmId")) {
				Collections.sort(permissibleValues,
						new Comparators.PermissibleValueBeanVmIdComparator());
				if (sord != null && sord.equals("desc"))
					Collections.reverse(permissibleValues);
			} else if (sidx.equals("vmLongName")) {
				Collections
						.sort(permissibleValues,
								new Comparators.PermissibleValueBeanVmLongNameComparator());
				if (sord != null && sord.equals("desc"))
					Collections.reverse(permissibleValues);
			} else if (sidx.equals("origin")) {
				Collections.sort(permissibleValues,
						new Comparators.PermissibleValueBeanOriginComparator());
				if (sord != null && sord.equals("desc"))
					Collections.reverse(permissibleValues);
			}
		}

		/*
		 * if (sord != null && sord.equalsIgnoreCase("asc")) {
		 * Collections.sort(permissibleValues); } if (sord != null &&
		 * sord.equalsIgnoreCase("desc")) { Collections.sort(permissibleValues);
		 * Collections.reverse(permissibleValues); }
		 */
		records = permissibleValues.size();

		if (totalrows != null) {
			records = totalrows;
		}

		// Calculate until rows are selected
		int to = (rows * page);

		// Calculate the first row to read
		int from = to - rows;

		// Set to = max rows
		if (to > records)
			to = records;

		if (loadonce) {
			if (totalrows != null && totalrows > 0) {
				setPvModel(permissibleValues.subList(0, totalrows));
			} else {
				// All
				setPvModel(permissibleValues);
			}
		} else {
			setPvModel(permissibleValues.subList(from, to));
		}

		// Calculate total Pages
		total = (int) Math.ceil((double) records / (double) rows);
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

	public List<PermissibleValueBean> getEditedPvModelWithEditedVm() {
		return editedPvModelWithEditedVm;
	}

	public void setSession(Map<String, Object> session) {
		this.session = session;
	}

	public Map<String, Object> getSession() {
		return session;
	}

	public Integer getRows() {
		return rows;
	}

	public void setRows(Integer rows) {
		this.rows = rows;
	}

	public Integer getPage() {
		return page;
	}

	public void setPage(Integer page) {
		this.page = page;
	}

	public String getSord() {
		return sord;
	}

	public void setSord(String sord) {
		this.sord = sord;
	}

	public String getSidx() {
		return sidx;
	}

	public void setSidx(String sidx) {
		this.sidx = sidx;
	}

	public Integer getTotalrows() {
		return totalrows;
	}

	public void setTotalrows(Integer totalrows) {
		this.totalrows = totalrows;
	}

	public Integer getTotal() {
		return total;
	}

	public void setTotal(Integer total) {
		this.total = total;
	}

	public Integer getRecords() {
		return records;
	}

	public void setRecords(Integer records) {
		this.records = records;

		if (this.records > 0 && this.rows > 0) {
			this.total = (int) Math.ceil((double) this.records
					/ (double) this.rows);
		} else {
			this.total = 0;
		}
	}

	public boolean isLoadonce() {
		return loadonce;
	}

	public void setLoadonce(boolean loadonce) {
		this.loadonce = loadonce;
	}

	public void setPvModel(List<PermissibleValueBean> pvModel) {
		this.pvModel = pvModel;
	}
}
