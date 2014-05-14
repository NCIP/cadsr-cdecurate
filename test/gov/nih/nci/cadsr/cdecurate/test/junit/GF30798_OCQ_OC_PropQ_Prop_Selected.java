package gov.nih.nci.cadsr.cdecurate.test.junit;

import static org.junit.Assert.assertEquals;

import java.io.File;
import java.io.IOException;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
//import org.openqa.selenium.WebDriverBackedSelenium;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeDriverService;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;

import com.thoughtworks.selenium.Selenium;

/**
  * https://code.google.com/p/selenium/wiki/ChromeDriver
  * Setup:
  * sudo chmod 755 /Users/ag/demo/cdecurate/lib/webdriver/chromedriver
  */
public class GF30798_OCQ_OC_PropQ_Prop_Selected {
  private WebDriver driver;
  private String baseUrl;
  private boolean acceptNextAlert = true;
  private StringBuffer verificationErrors = new StringBuffer();

//begin jt
	private static ChromeDriverService service;

	  @BeforeClass
	  public static void createAndStartService() throws IOException {
	    service = new ChromeDriverService.Builder()
	        .usingDriverExecutable(new File("lib/webdriver/chromedriver"))
	        .usingAnyFreePort()
	        .build();
	    service.start();
	  }

	  @AfterClass
	  public static void createAndStopService() {
	    service.stop();
	  }

	  @Before
	  public void createDriver() {
		    driver = new RemoteWebDriver(service.getUrl(),
			        DesiredCapabilities.chrome());
//	    baseUrl = "https://cdecurate-dev.nci.nih.gov/cdecurate/NCICurationServlet?reqType=homePage";
//	    driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS);
	    
	  }

	  @After
	  public void quitDriver() {
	    driver.quit();
	  }
	  
//	  @Test
	  public void testGoogleSearch() {
	    driver.get("http://www.google.com");
	    WebElement searchBox = driver.findElement(By.name("q"));
	    searchBox.sendKeys("webdriver");
	    searchBox.clear();
	    assertEquals("Google", driver.getTitle());
	  }
//end jt	  



//  @Test
  public void testGF30798OCQOCPropQPropSelected() throws Exception {
    driver.get(baseUrl + "/cdecurate/NCICurationServlet?reqType=login");
    driver.findElement(By.xpath("//td[@onclick=\"menuShow(this, event, 'no');\"]")).click();
    driver.findElement(By.xpath("(//dt[@id=''])[15]")).click();
    driver.findElement(By.linkText("Search")).click();
    // ERROR: Caught exception [ERROR: Unsupported command [waitForPopUp | BlockSearch | 30000]]
    // ERROR: Caught exception [ERROR: Unsupported command [selectWindow | name=BlockSearch | ]]
    driver.findElement(By.name("keyword")).sendKeys("minor");
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
