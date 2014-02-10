package gov.nih.nci.cadsr.common;

import org.apache.log4j.Logger;

public class LogUtil {

//	private static boolean directConsoleOutput = false;
	private static boolean directConsoleOutput = true;
	private static Logger logger = null;
	
	public static Logger getLogger() {
		return logger;
	}

	public static void setLogger(Logger log) {
		logger = log;
	}
	
	public static boolean isDirectConsoleOutput() {
		return directConsoleOutput;
	}

	public static void setDirectConsoleOutput(boolean directConsoleOutput) {
		directConsoleOutput = directConsoleOutput;
	}
	
	public static void log(String message) {
		if(directConsoleOutput) {
			System.out.println(message);
		} else {
			if(logger != null) {
				logger.debug(message);
			}
		}
	}
	
}
