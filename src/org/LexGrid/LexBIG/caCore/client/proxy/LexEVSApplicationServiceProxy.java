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
package org.LexGrid.LexBIG.caCore.client.proxy;

import gov.nih.nci.evs.security.SecurityToken;
import gov.nih.nci.system.applicationservice.ApplicationService;
import gov.nih.nci.system.client.proxy.ApplicationServiceProxy;
import gov.nih.nci.system.client.proxy.ProxyHelper;

import java.io.Serializable;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.HashMap;

import net.sf.cglib.proxy.Enhancer;

import org.LexGrid.LexBIG.Exceptions.LBException;
import org.LexGrid.LexBIG.caCore.applicationservice.annotations.DataServiceLazyLoadable;
import org.LexGrid.LexBIG.caCore.interfaces.LexEVSApplicationService;
import org.aopalliance.intercept.MethodInvocation;
import org.apache.log4j.Logger;
import org.springframework.aop.framework.Advised;

/**
 * Application Service proxy for LexEVS.
 * Certain methods are overridden to
 * provide LexEVS-specific proxying functionality.
 *
 * @author <a href="mailto:ongki@mail.nih.gov">Kim L. Ong</a>
 * @author <a href="mailto:rajasimhah@mail.nih.gov">Harsha Karur Rajasimha</a>
 * @author <a href="mailto:kevin.peterson@mayo.edu">Kevin Peterson</a>
 * 
 */
public class LexEVSApplicationServiceProxy extends ApplicationServiceProxy {
    private static Logger log = Logger.getLogger(LexEVSApplicationServiceProxy.class.getName());

    private LexEVSApplicationService eas;

	protected HashMap<String, SecurityToken> securityToken_map = new HashMap<String, SecurityToken>();
	
	private ProxyHelper dataServiceProxyHelper;
  
	@Override
	public Object invoke(MethodInvocation invocation) throws Throwable {
		//This is for Spring -- if it tries to call methods (like set the LexEVSApplicationService,
		//'toString', etc, on the creation of the bean. If we haven't set up the LexEVSApplicationService,
		//we can't do any of the remoting anyway.
		if(eas == null){
			return invocation.proceed();
		}
		
		Object bean = invocation.getThis();
        Method method = invocation.getMethod();
        String methodName = method.getName();
   
        Object[] args = invocation.getArguments();
        Class implClass = bean.getClass();

        SecurityToken securityToken = null;
        String vocabulary = null;
        
		if(methodName.equals("getSecurityToken_map")) {
			return securityToken_map;
		}
	
	    // Check if the invocation.methodName is registerToken
		if(methodName.equals("registerSecurityToken")) {

		   /* User needs to determine which vocabulary to register
		    * User needs to pass vocabulary name and token string.
		    * registerSecurityToken(String vocabulary, String token)
		    * First argument is assumed to be vocabulary name
		    */
		   vocabulary = (String) args[0];

	       // Second parameter of registerSecurityToken method is assumed to be SecurityToken
	       securityToken = (SecurityToken) args[1];
	       
	       if((vocabulary.equals(null)) || (vocabulary == "")) {
	    	   throw new IllegalArgumentException("vocabulary is null..args");
	       }
	    	   
	       if(securityToken == null) {
	    	   throw new IllegalArgumentException("Security token arg is null... ");
	       }
	       
		   // insert them in the securityToken_map hashmap if not already present
	       securityToken_map.put(vocabulary, securityToken);
	       
	       // return Boolean.TRUE or Boolean.FALSE
		   return true;
		}

		
		/* Check if the method is annotated as requiring security token
		 * (e.g., resolveCodingScheme() and handle it aptly
		 * whether the coding scheme itself requires a security token (determined by configuration file)
 		 */
		if(methodName.equals("executeSecurely")) {
			if(isDataServiceLazyLoadable(args)){
				return invokeDataService(invocation);
			}
			return super.invoke(invocation);
		}
		else {

	        Method methodImpl = implClass.getMethod(methodName,
	        						method.getParameterTypes());

	        if(args != null){
	        	for(int i=0; i<args.length; i++) {
	        		if (args[i] != null) {
	        			if (Enhancer.isEnhanced(args[i].getClass())) {
	        				args[i] = unwrap(args[i]);
	        			}
	        		}
	        	}
	        }
            try {
				return eas.executeSecurely(methodImpl.getName(), method.getAnnotations(), getParameterTypes(methodImpl), args, securityToken_map);
			} catch (Exception e) {
				// throw e;
				throw digOutRealExceptionAndThrowIt(e);
				// throw new LBException("Something went wrong.");
				// digOutRealExceptionAndThrowIt();
			}
		}
	}
	/*
	 * method: digOutRealExceptionAndThrowIt
	 * purpose: return the lowest level LexBIG exception.
	 *          In the distributed environment the exception stacks can get lengthy.
	 *          The idea behind this method is to eliminate the extra exceptions that 
	 *          are not actually related to the problem.
	 *          
	 * algorithm:  (1) method gets passed the topmost exception 
	 *             (2) go through all passed exception's 'causes'
	 *             (3) examine each cause exception; see if it is from the package: org.LexGrid.LexBIG.Exceptions
	 *             (4) if so, set it as our new return exception 
	 *             (5) if we don't find any exceptions from our desired package, use the original exception
	 */
	public static Exception digOutRealExceptionAndThrowIt(Exception e) throws Exception {
		Throwable lbiEx = null;
		Throwable next = null;
		Throwable cur  = e;
		boolean lexBigExceptionFound = false;
		boolean done = false;
		int i = 1;
		int max = 500;  // a limit so we won't ever be in endless loop
		if(isLexBigException(cur) == true) {
			lexBigExceptionFound = true;
			lbiEx = cur;
		}
		while(!done) {
			next = cur.getCause();
			++i;
			if(next == null) {				
				done = true;
			} else {				
				cur = next;
				if(isLexBigException(cur) == true) {
					lexBigExceptionFound = true;
					lbiEx = cur;
				}
				if(i == max) {
					done = true;
					log.error("digOutRealExceptionAndThrowIt: reached max depth of: " + max);
				}
			}
		}
		Exception returnException = null;
		if(lexBigExceptionFound == true) {
			returnException = new LBException(lbiEx.getMessage());
			returnException.setStackTrace(lbiEx.getStackTrace());
		} else {
			returnException = e;
		}
		return returnException;
	}	
	
	private static boolean isLexBigException(Throwable th) {
		if(th.toString().indexOf("org.LexGrid.LexBIG.Exceptions") != -1) {
			return true;
		} else {
			return false;
		}
	}
	
     /**
      * Returns a list of class names that are parameters to the given method.
      * @param methodImpl
      * @return list of fully-qualified class names
      */
     private String[] getParameterTypes(Method methodImpl) {
         String[] paramClasses =
             new String[methodImpl.getParameterTypes().length];
         int i = 0;
         for(Class paramClass : methodImpl.getParameterTypes()) {
             if (paramClass == null) continue;
             paramClasses[i++] = paramClass.getName();
         }
         return paramClasses;
     }

 	public Object invokeDataService(MethodInvocation invocation) throws Throwable {
		Object value = invocation.proceed();
		value = dataServiceProxyHelper.convertToProxy(eas, value);
		return value;
	}
 	
 	/*
 	 * Determine if the method had any Annotations
 	 */
    protected boolean isDataServiceLazyLoadable(Object[] args) {
    	for(Object arg : args){
    		if(arg instanceof Annotation[]){
    			for(Annotation annotation : (Annotation[])arg){
    				if(annotation instanceof DataServiceLazyLoadable){
    					return true;
    				}
    			}
    		}
    	}
      return false;
    }

   /**
    * Returns the underlying object that the specified proxy is advising.
    *
    * @param proxy the proxy
    *
    * @return the object
    *
    * @throws Exception the exception
    */
   private Object unwrap(Object proxy) throws Exception {
       Object interceptor = null;
       int i = 0;
       while (true) {
           Field field = proxy.getClass().getDeclaredField("CGLIB$CALLBACK_"+i);
           field.setAccessible(true);
           Object value = field.get(proxy);
           if (value.getClass().getName().contains("EqualsInterceptor")) {
               interceptor = value;
               break;
           }
           i++;
       }

       Field field = interceptor.getClass().getDeclaredField("advised");
       field.setAccessible(true);
       Advised advised = (Advised)field.get(interceptor);
       Object realObject = advised.getTargetSource().getTarget();
       return realObject;
   }
   
   public ProxyHelper getDataServiceProxyHelper() {
		return dataServiceProxyHelper;
	}


	public void setDataServiceProxyHelper(ProxyHelper dataServiceProxyHelper) {
		this.dataServiceProxyHelper = dataServiceProxyHelper;
	}

	@Override
	public void setApplicationService(ApplicationService as) {
		eas = (LexEVSApplicationService) as;
		super.setApplicationService(eas);
	}
	
    public HashMap getSecurityToken_map()
    {
		return securityToken_map;
	}

}
