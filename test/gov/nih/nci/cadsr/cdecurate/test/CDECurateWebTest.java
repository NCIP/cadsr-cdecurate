/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
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

	@Test
	public void testCDECurateWeb() throws Exception {
		driver.get(baseUrl + "/cdecurate/NCICurationServlet?reqType=homePage");
		driver.findElement(By.name("keyword")).click();
		driver.findElement(By.name("keyword")).clear();
		driver.findElement(By.name("keyword")).sendKeys("blood*");
		driver.findElement(By.name("keyword")).click();
		driver.findElement(By.name("keyword")).click();
		driver.findElement(By.name("keyword")).clear();
		driver.findElement(By.name("keyword")).sendKeys("blood");
		driver.findElement(By.linkText("Login")).click();
		driver.findElement(By.name("login")).click();
		driver.findElement(By.name("Username")).click();
		driver.findElement(By.name("Username")).sendKeys("tanj");
		driver.findElement(By.name("Password")).click();
		driver.findElement(By.name("Password")).sendKeys("tanj");
		driver.findElement(By.name("login")).click();
		driver.findElement(By.name("keyword")).clear();
		driver.findElement(By.name("keyword")).sendKeys("blood*\n");
		driver.findElement(By.name("listSearchIn")).click();
		driver.findElement(By.name("listSearchFor")).click();
		new Select(driver.findElement(By.name("listSearchFor"))).selectByVisibleText("Value Meaning");
		driver.findElement(By.cssSelector("option[value=\"ValueMeaning\"]")).click();
		driver.findElement(By.name("keyword")).clear();
		driver.findElement(By.name("keyword")).sendKeys("blood*");
//		driver.findElement(By.cssSelector("img.white")).click();
//		driver.findElement(By.cssSelector("td.cell > img")).click();
//		driver.findElement(By.name("btnValidate")).click();
//		driver.findElement(By.name("btnBack")).click();
//		driver.findElement(By.name("btnBack")).click();
		driver.findElement(By.linkText("Logout")).click();
	}

	@After
	public void tearDown() throws Exception {
		driver.quit();
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
