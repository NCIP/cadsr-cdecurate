package gov.nih.nci.cadsr.cdecurate.util;

import gov.nih.nci.cadsr.cdecurate.tool.EVS_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.PV_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.VM_Bean;
import java.util.Vector;

public class ClassUtil {

	private static String constructCDRName(PV_Bean pv) {
		String cdrName = "";
		if(pv != null && pv.getPV_VM() != null) {
			VM_Bean vm = pv.getPV_VM();
			Vector<EVS_Bean> nameCon = vm.getVM_CONCEPT_LIST();
			if (nameCon.size() > 0)
			{
				for (int i = 0; i < nameCon.size(); i++) {
					EVS_Bean nBean = nameCon.elementAt(i);
					//=== construct the concepts based on the ID and the source
					cdrName += nBean.getCONCEPT_IDENTIFIER() + ":" + nBean.getEVS_DATABASE();
				}
			}
			System.out.println("AdministeredItemUtil:constructCDRName Concepts size of pv [" + pv.getPV_VALUE() + "] vm [" + vm.getVM_LONG_NAME() + "] vm def [" + vm.getVM_PREFERRED_DEFINITION() + "] = " + vm.getVM_CONCEPT_LIST().size() + " CDR name [" + cdrName + "]");
		}
		
		return cdrName;
	}
	
	public static boolean isSimilarPV(PV_Bean pv1, PV_Bean pv2) {
		boolean retVal = false;
		boolean isSimilar1, isSimilar2;
		StringBuffer pv1string, pv2string;
		
		//GF33185 constructing the new CDR string
		String n1 = constructCDRName(pv1);
		String n2 = constructCDRName(pv2);

		//=== check 1 by CDR name
		System.out.println("\nAdministeredItemUtil:isSimilarPV comparing [" + n1 + "] with [" + n2 + "]");
		if(!n1.equals(n2)) {
			isSimilar1 = false;
			System.out.println("AdministeredItemUtil:isSimilarPV 1 different!");
		} else {
			isSimilar1 = true;
			System.out.println("AdministeredItemUtil:isSimilarPV 1 similar!");
		}

		//=== check 2 by vm desc/def
		String vmDesc1 = "";
		if(pv1 != null && pv1.getPV_VM() != null) {
			vmDesc1 = pv1.getPV_VM().getVM_PREFERRED_DEFINITION();
		}
		String vmDesc2 = "";
		if(pv2 != null && pv2.getPV_VM() != null) {
			vmDesc2 = pv2.getPV_VM().getVM_PREFERRED_DEFINITION();
		}
		if(vmDesc1 != null && vmDesc2 != null && !vmDesc1.equals(vmDesc2)) {
			isSimilar2 = false;
			System.out.println("AdministeredItemUtil:isSimilarPV 2 different!");
		} else {
			isSimilar2 = true;
			System.out.println("AdministeredItemUtil:isSimilarPV 2 similar!");
		}
		
		//=== final check
		if(isSimilar1 && isSimilar2) {
			retVal = true;
		}
		System.out.println("AdministeredItemUtil:isSimilarPV returning " + retVal);
		
		return retVal;
	}

}