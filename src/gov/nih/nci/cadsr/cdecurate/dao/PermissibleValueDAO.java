package gov.nih.nci.cadsr.cdecurate.dao;

import gov.nih.nci.cadsr.cdecurate.dto.PermissibleValueBean;

import java.util.List;

public interface PermissibleValueDAO {
	List<PermissibleValueBean> getPermissibleValuesByValueDomainId(String id);

}
