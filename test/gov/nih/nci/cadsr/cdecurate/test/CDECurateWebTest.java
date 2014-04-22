/*
 * Instructions:
 * 
 * 1. Check http://docs.seleniumhq.org/download/ for latest selenium-server-standalone-2.XXX.jar often to avoid "LOG addons.manager: Application has been upgraded"
 * 2. Make sure test/ directory is added into the running classpath
 */

package gov.nih.nci.cadsr.cdecurate.test;

import java.util.List;
import java.util.Set;
import java.util.regex.Pattern;
import java.util.concurrent.TimeUnit;

import org.junit.*;

import static org.junit.Assert.*;
import static org.hamcrest.CoreMatchers.*;

import org.openqa.selenium.*;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.Select;

public class CDECurateWebTest {
	private WebDriver driver;
	private String baseUrl;
	private StringBuffer verificationErrors = new StringBuffer();

	@Before
	public void setUp() throws Exception {
		driver = new FirefoxDriver();
		baseUrl = "http://localhost:8080/cdecurate/NCICurationServlet?reqType=homePage";
		driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS);
	}

	@Test
	public void testEditVD() {
		driver.get(baseUrl + "/cdecurate/NCICurationServlet?reqType=homePage");
		driver.findElement(By.linkText("Login")).click();
		driver.findElement(By.name("Username")).click();
		driver.findElement(By.name("Username")).sendKeys("GUEST");
		driver.findElement(By.name("Password")).click();
		driver.findElement(By.name("Password")).sendKeys("Nci_gue5t");
		driver.findElement(By.name("login")).click();

		driver.findElement(By.id("listSearchFor")).click();
	    new Select(driver.findElement(By.id("listSearchFor"))).selectByVisibleText("Value Domain");
	    driver.findElement(By.cssSelector("option[value=\"ValueDomain\"]")).click();
	    driver.findElement(By.id("keyword")).clear();
	    driver.findElement(By.id("keyword")).sendKeys("Anatomic Site\n");
	    driver.findElement(By.cssSelector("img.stripe")).click();
	    driver.findElement(By.cssSelector("img[alt=\"single\"]")).click();
	    driver.findElement(By.cssSelector("#vdpvstab > b")).click();

	    assertTrue(driver.findElement(By.tagName("body")).getText().indexOf("Permissible Values") > -1);
	}
	
//	@Test
	public void testSelectionActionMenu() throws Exception {
		driver.get(baseUrl + "/cdecurate/NCICurationServlet?reqType=homePage");
		driver.findElement(By.linkText("Login")).click();
		driver.findElement(By.name("Username")).click();
		driver.findElement(By.name("Username")).sendKeys("GUEST");
		driver.findElement(By.name("Password")).click();
		driver.findElement(By.name("Password")).sendKeys("Nci_gue5t");
		driver.findElement(By.name("login")).click();

		driver.findElement(By.name("keyword")).clear();
		driver.findElement(By.name("keyword")).sendKeys("blood*\n");
		driver.findElement(By.cssSelector("img.stripe")).click();
		driver.findElement(By.cssSelector("img[alt=single]")).click();
		driver.findElement(By.linkText("Logout")).click();
	}
	

//	@Test
	public void testSearchConcept() throws Exception {
		driver.get(baseUrl + "/cdecurate/NCICurationServlet?reqType=homePage");
		driver.findElement(By.name("listSearchIn")).click();
		driver.findElement(By.name("listSearchFor")).click();
		new Select(driver.findElement(By.name("listSearchFor"))).selectByVisibleText("Concept Class");
//		driver.findElement(By.cssSelector("option[value=\"ValueMeaning\"]")).click();
		driver.findElement(By.name("keyword")).clear();
		driver.findElement(By.name("keyword")).sendKeys("blood*\n");
	}

//	@Test
	public void testSearchVM() throws Exception {
		driver.get(baseUrl + "/cdecurate/NCICurationServlet?reqType=homePage");
		driver.findElement(By.linkText("Login")).click();
		driver.findElement(By.name("Username")).click();
		driver.findElement(By.name("Username")).sendKeys("GUEST");
		driver.findElement(By.name("Password")).click();
		driver.findElement(By.name("Password")).sendKeys("Nci_gue5t");
		driver.findElement(By.name("login")).click();
		driver.findElement(By.name("keyword")).clear();
		driver.findElement(By.name("keyword")).sendKeys("blood*\n");
		driver.findElement(By.name("listSearchIn")).click();
		driver.findElement(By.name("listSearchFor")).click();
		new Select(driver.findElement(By.name("listSearchFor"))).selectByVisibleText("Value Meaning");
		driver.findElement(By.cssSelector("option[value=\"ValueMeaning\"]")).click();
		driver.findElement(By.name("keyword")).clear();
		driver.findElement(By.name("keyword")).sendKeys("anal canal\n");
		driver.findElement(By.cssSelector("img.stripe")).click();
		driver.findElement(By.cssSelector("img[alt=single]")).click();
//		driver.findElement(By.cssSelector("img.white")).click();
//		driver.findElement(By.cssSelector("td.cell > img")).click();
//		driver.findElement(By.name("btnValidate")).click();
//		driver.findElement(By.name("btnBack")).click();
//		driver.findElement(By.name("btnBack")).click();
		driver.findElement(By.linkText("Logout")).click();
	}

//	@Test
	public void testCreateDEC() {
		driver.get(baseUrl + "/cdecurate/NCICurationServlet?reqType=homePage");
		driver.findElement(By.linkText("Login")).click();
		driver.findElement(By.name("Username")).click();
		driver.findElement(By.name("Username")).sendKeys("GUEST");
		driver.findElement(By.name("Password")).click();
		driver.findElement(By.name("Password")).sendKeys("Nci_gue5t");
		driver.findElement(By.name("login")).click();
		//===click the the first level menu
		driver.findElement(By.xpath("//td[@onclick=\"menuShow(this, event, 'no');\"]")).click();
		//===choose Create DEC
	    driver.findElement(By.xpath("(//dt[@id=''])[15]")).click();
		//===choose the TEST context
	    new Select(driver.findElement(By.name("selContext"))).selectByVisibleText("TEST");
	    //===save the current window handle (Create NEW DEC form UI)
	    String parentWindow= driver.getWindowHandle();
	    
	    //===choose an OC primary concept (second box from the left) - this will open an EVS pop up search window
	    driver.findElement(By.xpath("(//a[contains(text(),'Search')])[2]")).click();
	    //===after the link is clicked, need to switch to the search window now
	    TestUtil.getHandleToWindow(driver, "CDE Curation: Search");
	    enterEVSSearch("blood\n");
	    //driver.close();
	    driver.switchTo().window(parentWindow);
	    
	    //===choose an Prop primary concept (4th box from the left) - this will open an EVS pop up search window
	    driver.findElement(By.xpath("(//a[contains(text(),'Search')])[4]")).click();
	    //===after the link is clicked, need to switch to the search window now
	    TestUtil.getHandleToWindow(driver, "CDE Curation: Search");
	    enterEVSSearch("cell\n");
	    //driver.close();
	    driver.switchTo().window(parentWindow);

	    //===choose an OC qualifier 1 (1st box from the left) - this will open an EVS pop up search window
	    driver.findElement(By.xpath("(//a[contains(text(),'Search')])[1]")).click();
	    //===after the link is clicked, need to switch to the search window now
	    TestUtil.getHandleToWindow(driver, "CDE Curation: Search");
	    enterEVSSearch("major\n");
	    //driver.close();
	    driver.switchTo().window(parentWindow);

	    //===choose an OC qualifier 2 (1st box from the left) - this will open an EVS pop up search window
	    driver.findElement(By.xpath("(//a[contains(text(),'Search')])[1]")).click();
	    //===after the link is clicked, need to switch to the search window now
	    TestUtil.getHandleToWindow(driver, "CDE Curation: Search");
	    enterEVSSearch("repeat\n");
	    //driver.close();
	    driver.switchTo().window(parentWindow);

	    //===choose an Prop qualifier 1 (3rd box from the left) - this will open an EVS pop up search window
	    driver.findElement(By.xpath("(//a[contains(text(),'Search')])[3]")).click();
	    //===after the link is clicked, need to switch to the search window now
	    TestUtil.getHandleToWindow(driver, "CDE Curation: Search");
	    enterEVSSearch("red\n");
	    //driver.close();
	    driver.switchTo().window(parentWindow);

	    //===choose an Prop qualifier 2 (3rd box from the left) - this will open an EVS pop up search window
	    driver.findElement(By.xpath("(//a[contains(text(),'Search')])[3]")).click();
	    //===after the link is clicked, need to switch to the search window now
	    TestUtil.getHandleToWindow(driver, "CDE Curation: Search");
	    enterEVSSearch("vessel\n");
	    //driver.close();
	    driver.switchTo().window(parentWindow);

	    //===choose a Concept Domain - this will open an EVS pop up search window
	    driver.findElement(By.xpath("(//a[contains(text(),'Search')])[5]")).click();
	    //===after the link is clicked, need to switch to the search window now
	    TestUtil.getHandleToWindow(driver, "CDE Curation: Search");
	    //===just pick the first one out of the results
	    driver.findElement(By.name("CK0")).click();
	    //===click on Link Concept button
	    driver.findElement(By.name("editSelectedBtn")).click();
	    //driver.close();
	    driver.switchTo().window(parentWindow);

	    driver.findElement(By.name("btnValidate")).click();
//	    driver.findElement(By.name("btnBack")).click();

	    driver.findElement(By.cssSelector("img[alt=\"Logout\"]")).click();
	    assertTrue(confirmLogout().matches("^Are you sure you want to logout[\\s\\S]$"));
//		driver.findElement(By.linkText("Logout")).click();
	}

	private void enterEVSSearch(String keyword) {
	    driver.findElement(By.name("keyword")).clear();
	    driver.findElement(By.name("keyword")).sendKeys(keyword);
	    //===pick the first results
	    driver.findElement(By.name("CK0")).click();
	    //===click on Link Concept button
	    driver.findElement(By.name("editSelectedBtn")).click();
	}

//	@Test
	public void testFeatureRequiresLogin() {
		//https://groups.google.com/forum/#!topic/selenium-users/F2c4QWP50F8
		driver.get(baseUrl + "/cdecurate/NCICurationServlet?reqType=homePage");
		driver.findElement(By.xpath("//td[@onclick=\"menuShow(this, event, 'no');\"]")).click();
	    driver.findElement(By.xpath("(//dt[@id=''])[15]")).click();
	    assertEquals("Please Login to use this feature.", confirmLogin());
//	    Alert a = driver.switchTo().alert();
//		a.accept(); // or dismiss() if you want to hit 'cancel'
	}

	private String confirmLogin() {
		boolean acceptNextAlert = true;
		try {
			Alert alert = driver.switchTo().alert();
			String alertText = alert.getText();
			if (acceptNextAlert) {
				alert.accept();
			} else {
				alert.dismiss();
			}
			return alertText;
		} finally {
			acceptNextAlert = true;
		}
	}

	private String confirmLogout() {
		boolean acceptNextAlert = true;
		try {
			Alert alert = driver.switchTo().alert();
			String alertText = alert.getText();
			if (acceptNextAlert) {
				alert.accept();
			} else {
				alert.dismiss();
			}
			return alertText;
		} finally {
			acceptNextAlert = true;
		}
	}

//	@Test
	public void testWindows() {
		//http://stackoverflow.com/questions/19117747/how-to-switch-between-two-windows-in-browser-using-selenium-java
	}
		
	@After
	public void tearDown() throws Exception {
//		driver.quit();	//close it once done
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
}
