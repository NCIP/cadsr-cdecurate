package gov.nih.nci.cadsr.cdecurate.util;

import gov.nih.nci.cadsr.cdecurate.dto.PermissibleValueBean;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Comparator;
import java.util.Date;

/**
 * Contains a list of static comparators for use in the CDE Curation Tool
 * 
 * @author pansu
 * 
 */

public class Comparators {
	public static class PermissibleValueBeanBeginDateComparator implements
			Comparator<PermissibleValueBean> {
		public int compare(PermissibleValueBean a, PermissibleValueBean b) {
			SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
			try {
				Date aDate = (Date) formatter.parse(a.getBeginDate());
				Date bDate = (Date) formatter.parse(b.getBeginDate());
				return aDate.compareTo(bDate);
			} catch (ParseException e) {
				return 0;
			}
		}
	}

	public static class PermissibleValueBeanEndDateComparator implements
			Comparator<PermissibleValueBean> {
		public int compare(PermissibleValueBean a, PermissibleValueBean b) {
			SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
			try {
				Date aDate = (Date) formatter.parse(a.getEndDate());
				Date bDate = (Date) formatter.parse(b.getEndDate());
				return aDate.compareTo(bDate);
			} catch (ParseException e) {
				return 0;
			}
		}
	}

	public static class PermissibleValueBeanValueComparator implements
			Comparator<PermissibleValueBean> {
		public int compare(PermissibleValueBean a, PermissibleValueBean b) {
			String aValue = a.getValue();
			String bValue = b.getValue();
			return aValue.compareTo(bValue);
		}
	}

	public static class PermissibleValueBeanConceptComparator implements
			Comparator<PermissibleValueBean> {
		public int compare(PermissibleValueBean a, PermissibleValueBean b) {
			String aConcepts = a.getValueMeaning().getConceptCodes();
			String bConcepts = b.getValueMeaning().getConceptCodes();
			return aConcepts.compareTo(bConcepts);
		}
	}

	public static class PermissibleValueBeanVmIdComparator implements
			Comparator<PermissibleValueBean> {
		public int compare(PermissibleValueBean a, PermissibleValueBean b) {
			String aVmId = a.getValueMeaning().getPublicId();
			String bVmId = b.getValueMeaning().getPublicId();
			String aVersion = a.getValueMeaning().getVersion();
			String bVersion = b.getValueMeaning().getVersion();
			if (aVmId.equals(bVmId)) {
				return aVersion.compareTo(bVersion);
			}
			return aVmId.compareTo(bVmId);
		}
	}

	public static class PermissibleValueBeanOriginComparator implements
			Comparator<PermissibleValueBean> {
		public int compare(PermissibleValueBean a, PermissibleValueBean b) {
			String aOrigin = a.getOrigin();
			String bOrigin = b.getOrigin();
			return aOrigin.compareTo(bOrigin);
		}
	}

	public static class PermissibleValueBeanVmLongNameComparator implements
			Comparator<PermissibleValueBean> {
		public int compare(PermissibleValueBean a, PermissibleValueBean b) {
			String aMeaning = a.getValueMeaning().getLongName();
			String bMeaning = b.getValueMeaning().getLongName();
			return aMeaning.compareTo(bMeaning);
		}
	}
}
