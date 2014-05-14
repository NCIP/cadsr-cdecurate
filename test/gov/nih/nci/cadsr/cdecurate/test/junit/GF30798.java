package gov.nih.nci.cadsr.cdecurate.test.junit;

import static org.junit.Assert.assertEquals;

import java.io.File;
import java.io.IOException;
import java.util.concurrent.TimeUnit;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
//import org.openqa.selenium.WebDriverBackedSelenium;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriverService;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.firefox.FirefoxProfile;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;

import com.thoughtworks.selenium.Selenium;

/**
  * https://code.google.com/p/selenium/wiki/ChromeDriver
  * Setup:
  * sudo chmod 755 /Users/ag/demo/cdecurate/lib/webdriver/chromedriver
  */
public class GF30798 {
//	public static final String baseUrl = "https://cdecurate-dev.nci.nih.gov";
	public static final String baseUrl = "http://localhost:8080";
	public static final String p = "Te$t1239";
	
	public static enum BROWSER_TYPE {
		CHROME, FIREFOX, IE, SAFARI, OPERA
	}

//	public static final BROWSER_TYPE BTYPE = BROWSER_TYPE.CHROME;
	public static final BROWSER_TYPE BTYPE = BROWSER_TYPE.FIREFOX;

	private static ChromeDriverService service;
	private static Selenium selenium;
	private WebDriver driver;

	@BeforeClass
	public static void createAndStartService() throws IOException {
		if (BTYPE == BROWSER_TYPE.CHROME) {
			service = new ChromeDriverService.Builder()
					.usingDriverExecutable(
							new File("lib/webdriver/chromedriver"))
					.usingAnyFreePort().build();
			service.start();
		}
	}

	@AfterClass
	public static void createAndStopService() {
//		if (BTYPE == BROWSER_TYPE.CHROME) {
//			service.stop();
//		}
	}

	@Before
	public void createDriver() {
		if (BTYPE == BROWSER_TYPE.CHROME) {
			driver = new RemoteWebDriver(service.getUrl(),
					DesiredCapabilities.chrome());
		} else //if (BTYPE == BROWSER_TYPE.FIREFOX) 
		{
			FirefoxProfile fp = new FirefoxProfile();
			fp.setPreference("webdriver.load.strategy", "unstable"); // As of
																		// 2.19.
																		// from
																		// 2.9
																		// -
																		// 2.18
																		// use
																		// 'fast'
			// fp.setPreference("webdriver_enable_native_events", true);
			// fp.setEnableNativeEvents(true);
			driver = new FirefoxDriver(fp);
		}
//		selenium = new WebDriverBackedSelenium(driver,
//				"http://localhost:8888");
//		driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS);
		
		LogoutLogin();
	}

	@After
	public void quitDriver() {
//		driver.quit();
	}

	//@Test
	public void checkGoogleSearch() {
		driver.get("http://www.google.com");
		WebElement searchBox = driver.findElement(By.name("q"));
		searchBox.sendKeys("webdriver");
		searchBox.clear();
		assertEquals("Google", driver.getTitle());
	}

	  public void LogoutLogin() {
	    driver.get(baseUrl + "/cdecurate");
//	    driver.findElement(By.linkText("Logout")).click();
	    driver.findElement(By.linkText("Login")).click();
		driver.findElement(By.name("Username")).sendKeys("tanj");
		driver.findElement(By.name("Password")).sendKeys(p+Keys.ENTER);	    
	    driver.findElement(By.name("login")).click();
	  }
	  
  public void waitForPopUp(long miliseconds) throws InterruptedException {
    for (String handle : driver.getWindowHandles()) {
        driver.switchTo().window(handle);
	}
    Thread.sleep(miliseconds);
  }
  
  @Test
  public void testGF30798OCQOCPropQPropSelected() throws Exception {
    driver.get(baseUrl + "/cdecurate/NCICurationServlet?reqType=login");
    driver.findElement(By.xpath("//td[@onclick=\"menuShow(this, event, 'no');\"]")).click();
    driver.findElement(By.xpath("(//dt[@id=''])[15]")).click();
    driver.findElement(By.linkText("Search")).click();
    waitForPopUp(3000);
    driver.findElement(By.name("keyword")).sendKeys("minor"+Keys.ENTER);
    driver.findElement(By.name("CK0")).click();
    driver.findElement(By.name("editSelectedBtn")).click();
    // ERROR: Caught exception [ERROR: Unsupported command [selectWindow | null | ]]
    driver.findElement(By.xpath("(//a[contains(text(),'Search')])[3]")).click();
    // ERROR: Caught exception [ERROR: Unsupported command [waitForPopUp | BlockSearch | 30000]]
    // ERROR: Caught exception [ERROR: Unsupported command [selectWindow | name=BlockSearch | ]]
    driver.findElement(By.name("keyword")).sendKeys("major");
    driver.findElement(By.name("CK1")).click();
    driver.findElement(By.name("editSelectedBtn")).click();
    // ERROR: Caught exception [ERROR: Unsupported command [selectWindow | null | ]]
    driver.findElement(By.xpath("(//a[contains(text(),'Search')])[2]")).click();
    // ERROR: Caught exception [ERROR: Unsupported command [waitForPopUp | BlockSearch | 30000]]
    // ERROR: Caught exception [ERROR: Unsupported command [selectWindow | name=BlockSearch | ]]
    driver.findElement(By.name("keyword")).sendKeys("monkey");
    driver.findElement(By.name("CK1")).click();
    driver.findElement(By.name("editSelectedBtn")).click();
    // ERROR: Caught exception [ERROR: Unsupported command [selectWindow | null | ]]
    driver.findElement(By.xpath("(//a[contains(text(),'Search')])[4]")).click();
    // ERROR: Caught exception [ERROR: Unsupported command [waitForPopUp | BlockSearch | 30000]]
    // ERROR: Caught exception [ERROR: Unsupported command [selectWindow | name=BlockSearch | ]]
    driver.findElement(By.name("keyword")).sendKeys("less");
    driver.findElement(By.name("CK0")).click();
    driver.findElement(By.name("editSelectedBtn")).click();
    // ERROR: Caught exception [ERROR: Unsupported command [selectWindow | null | ]]
    driver.findElement(By.name("btnValidate")).click();
  }

//  private boolean isElementPresent(By by) {
//    try {
//      driver.findElement(by);
//      return true;
//    } catch (NoSuchElementException e) {
//      return false;
//    }
//  }
//
//  private boolean isAlertPresent() {
//    try {
//      driver.switchTo().alert();
//      return true;
//    } catch (NoAlertPresentException e) {
//      return false;
//    }
//  }
//
//  private String closeAlertAndGetItsText() {
//    try {
//      Alert alert = driver.switchTo().alert();
//      String alertText = alert.getText();
//      if (acceptNextAlert) {
//        alert.accept();
//      } else {
//        alert.dismiss();
//      }
//      return alertText;
//    } finally {
//      acceptNextAlert = true;
//    }
//  }
}
