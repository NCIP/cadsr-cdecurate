/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.cdecurate.test;

import static org.junit.Assert.fail;

import java.io.File;
import java.util.concurrent.TimeUnit;

import org.junit.After;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.openqa.selenium.By;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.ie.InternetExplorerDriver;

import junit.framework.JUnit4TestAdapter;
import junit.framework.Test;
import junit.framework.TestSuite;

/**
 * Please do not forget to add server jar (e.g. lib/selenium-server-standalone-2.25.0.jar
 * into your classpath before running this.
 *
 */
@RunWith(Suite.class)
@Suite.SuiteClasses({
	CDECurateWebTest.class
})

public class AllTestsIE {
	private static WebDriver driver;
	private static String baseUrl;
	private StringBuffer verificationErrors = new StringBuffer();

	public static void init() {
		baseUrl = "http://localhost:8080/cdecurate/NCICurationServlet?reqType=homePage";
		driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS);
	}

	@BeforeClass
	public static void setUp() throws Exception {
		File file = new File("C:\\Users\\ag\\demo\\cadsr-cdecurate\\testlib\\junit\\IEDriverServer_Win32_2.29.1\\IEDriverServer.exe");
        System.setProperty("webdriver.ie.driver", file.getAbsolutePath());
		driver = new InternetExplorerDriver();
		init();
		CDECurateWebTest.setDriver(driver);
		CDECurateWebTest.setBaseUrl(baseUrl);
	}
	
	@After
	public void tearDown() throws Exception {
		driver.quit();	//close it once done
		String verificationErrorString = verificationErrors.toString();
		if (!"".equals(verificationErrorString)) {
			fail(verificationErrorString);
		}
	}

	private boolean isElementPresent(By by) {
		try {
			driver.findElement(by);
			return true;
		} catch (NoSuchElementException e) {
			return false;
		}
	}

	public static void main (String[] args) {
		junit.textui.TestRunner.run (suite());
    }
	
	public static junit.framework.Test suite() {
		return new JUnit4TestAdapter(AllTestsIE.class);
    }
}


