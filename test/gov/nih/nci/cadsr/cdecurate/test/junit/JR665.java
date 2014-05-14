package gov.nih.nci.cadsr.cdecurate.test.junit;

import static org.junit.Assert.assertTrue;
import gov.nih.nci.cadsr.cdecurate.tool.html.RendererUtil;

import java.util.Vector;

import org.junit.Test;
//import org.openqa.selenium.WebDriverBackedSelenium;

/**
  * https://tracker.nci.nih.gov/browse/CURATNTOOL-665
  */
public class JR665 {
	@Test
	public void start() {
		String sReg = "";	//current element
		String sRegStatus = "status2";	//user selected value in session
		Vector vRegStatus = new Vector();
		vRegStatus.add("status1");
		vRegStatus.add("status2");
		vRegStatus.add("status3");
		String ret = "";
        if (vRegStatus != null)
        {
            for (int i = 0; vRegStatus.size()>i; i++)
            {
                sReg = (String)vRegStatus.elementAt(i);
                ret += RendererUtil.toSelectOption(sReg, sRegStatus);
            }
        }
        assertTrue(ret.contains("<option value=\"status2\" selected=\"selected\">status2</option>"));
	}

}
