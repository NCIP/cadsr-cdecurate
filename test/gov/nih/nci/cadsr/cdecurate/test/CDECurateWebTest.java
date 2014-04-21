/*
 * Instructions:
 * 
 * 1. Check http://docs.seleniumhq.org/download/ for latest selenium-server-standalone-2.XXX.jar often to avoid "LOG addons.manager: Application has been upgraded"
 * 2. Make sure test/ directory is added into the running classpath
 */

package gov.nih.nci.cadsr.cdecurate.test;

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

//	@Test
	public void testCDECurateSelectionActionMenu() throws Exception {
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
	public void testCDECurateSearchConcept() throws Exception {
		driver.get(baseUrl + "/cdecurate/NCICurationServlet?reqType=homePage");
		driver.findElement(By.name("listSearchIn")).click();
		driver.findElement(By.name("listSearchFor")).click();
		new Select(driver.findElement(By.name("listSearchFor"))).selectByVisibleText("Concept Class");
//		driver.findElement(By.cssSelector("option[value=\"ValueMeaning\"]")).click();
		driver.findElement(By.name("keyword")).clear();
		driver.findElement(By.name("keyword")).sendKeys("blood*\n");
	}

	@Test
	public void testCDECurateWeb() throws Exception {
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
	public void testAlert() {
		//https://groups.google.com/forum/#!topic/selenium-users/F2c4QWP50F8
//		Alert a = driver.switchTo().alert();
//		a.confirm(); // or dismiss() if you want to hit 'cancel'
	}

	@Test
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
