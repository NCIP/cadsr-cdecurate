package gov.nih.nci.cadsr.cdecurate.test;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

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

public class AllTests {
}


