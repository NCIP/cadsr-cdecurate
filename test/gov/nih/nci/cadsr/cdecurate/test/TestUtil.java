package gov.nih.nci.cadsr.cdecurate.test;

import java.util.Set;

import org.openqa.selenium.WebDriver;

public class TestUtil {
	/** courtesy of http://stackoverflow.com/questions/19112209/how-to-handle-the-new-window-in-selenium-webdriver */
	public static WebDriver getHandleToWindow(WebDriver driver, String title) {

		// parentWindowHandle =
		// WebDriverInitialize.getDriver().getWindowHandle(); // save the
		// current window handle.
		WebDriver popup = null;
		Set<String> windowIterator = driver.getWindowHandles();
		System.err.println("No of windows :  " + windowIterator.size());
		for (String s : windowIterator) {
			String windowHandle = s;
			popup = driver.switchTo().window(windowHandle);
			System.out.println("Window Title : " + popup.getTitle());
			System.out.println("Window Url : " + popup.getCurrentUrl());
			if (popup.getTitle().equals(title)) {
				System.out.println("Selected Window Title : "
						+ popup.getTitle());
				return popup;
			}

		}
		System.out.println("Window Title :" + popup.getTitle());
		System.out.println();
		return popup;
	}
}
