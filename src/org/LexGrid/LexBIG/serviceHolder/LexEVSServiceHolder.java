/*******************************************************************************
 * Copyright: (c) 2004-2009 Mayo Foundation for Medical Education and 
 * Research (MFMER). All rights reserved. MAYO, MAYO CLINIC, and the
 * triple-shield Mayo logo are trademarks and service marks of MFMER.
 * 
 * Except as contained in the copyright notice above, or as used to identify 
 * MFMER as the author of this software, the trade names, trademarks, service
 * marks, or product names of the copyright holder shall not be used in
 * advertising, promotion or otherwise in connection with this software without
 * prior written authorization of the copyright holder.
 *   
 * Licensed under the Eclipse Public License, Version 1.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at 
 *   
 *  		http://www.eclipse.org/legal/epl-v10.html
 * 
 *  		
 *******************************************************************************/
package org.LexGrid.LexBIG.serviceHolder;

import gov.nih.nci.system.applicationservice.ApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;

import org.LexGrid.LexBIG.caCore.interfaces.LexEVSApplicationService;

public class LexEVSServiceHolder {
	private static LexEVSServiceHolder sh_;
	private ApplicationService appService = null;
	private static final String serviceUrl = " http://lexevsapi60-qa.nci.nih.gov/lexevsapi60";
	private LexEVSApplicationService lexevsAppService;
	public static final String _service = "EvsServiceInfo";

	/**
	 * Use this to get an instance of the LexEVSServiceHolder. If
	 * 'configureForSingleConfig' has not been called, this will run the tests
	 * on all configured databases in the testConfig.props file.
	 * 
	 * @return the EVS query service holder
	 */
	public static LexEVSServiceHolder instance() {
		if (sh_ == null) {
			configure();
		}
		return sh_;

	}

	/**
	 * Use this to set up the tests for end user enviroment validation. Only
	 * runs the tests once, using their normal config file.
	 * 
	 */
	public static void configure() {

		sh_ = new LexEVSServiceHolder();

	}

	/**
	 * Instantiates a new eVS query service holder.
	 * 
	 */
	private LexEVSServiceHolder() {
		try {
			appService = ApplicationServiceProvider
			        .getApplicationServiceFromUrl(serviceUrl, "EvsServiceInfo");
			lexevsAppService = (LexEVSApplicationService) ApplicationServiceProvider
			        .getApplicationServiceFromUrl(serviceUrl, "EvsServiceInfo");
		} catch (Exception e) {
			System.err.println("Problem initiating Test config");
			e.printStackTrace();
			System.exit(-1);
		}
	}

	/**
	 * Gets the uRL.
	 * 
	 * @return the uRL
	 */
	public static String getURL() {
		return serviceUrl;
	}

	/**
	 * Gets the app service.
	 * 
	 * @return an instance of the app service
	 */
	public ApplicationService getAppService() {
		return appService;
	}

	/**
	 * Gets the app service.
	 * 
	 * @return an instance of the app service
	 */
	public LexEVSApplicationService getLexEVSAppService() {
		return lexevsAppService;
	}

	public LexEVSApplicationService getFreshLexEVSAppService() {
		try {
			return lexevsAppService = (LexEVSApplicationService) ApplicationServiceProvider
			        .getApplicationServiceFromUrl(serviceUrl, "EvsServiceInfo");
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

}
