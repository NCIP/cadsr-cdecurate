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

import org.LexGrid.LexBIG.DataModel.Collections.AssociationList;
import org.LexGrid.LexBIG.DataModel.Collections.CodingSchemeRenderingList;
import org.LexGrid.LexBIG.DataModel.Collections.LocalNameList;
import org.LexGrid.LexBIG.DataModel.Collections.ResolvedConceptReferenceList;
import org.LexGrid.LexBIG.DataModel.Core.AssociatedConcept;
import org.LexGrid.LexBIG.DataModel.Core.Association;
import org.LexGrid.LexBIG.DataModel.Core.CodingSchemeVersionOrTag;
import org.LexGrid.LexBIG.DataModel.Core.ResolvedConceptReference;
import org.LexGrid.LexBIG.Exceptions.LBException;
import org.LexGrid.LexBIG.LexBIGService.CodedNodeSet;
import org.LexGrid.LexBIG.LexBIGService.LexBIGService;
import org.LexGrid.LexBIG.LexBIGService.CodedNodeSet.SearchDesignationOption;
import org.LexGrid.LexBIG.Utility.ConvenienceMethods;
import org.LexGrid.commonTypes.EntityDescription;

public class LexEVSExampleTest {
	String THES_SCHEME = "NCI Thesaurus";
	String THES_VERSION;
	LexBIGService lbs;

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		new LexEVSExampleTest().run();

	}

	public void run() {
		try {
			setUp();
			testGetSupportedCodingSchemes();
			testGetCodingSchemeConcepts();
			testGetCodingSchemeGraph();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void setUp() {
		lbs = LexEVSServiceHolder.instance().getLexEVSAppService();
	}

	public void testGetSupportedCodingSchemes() throws Exception {
		CodingSchemeRenderingList csrl = lbs.getSupportedCodingSchemes();
		System.out
		        .println("*****************************************************************");
		System.out
		        .println("PRINTING CODING SCHEMES FROM LEXEVS 6.0 PRODUCTION SERVER");
		System.out
		        .println("*****************************************************************");
		System.out.println("*");
		System.out.println("*");
		System.out.println("*");
		System.out.println("*");
		System.out.println("********************");
		for (int i = 0; i < csrl.getCodingSchemeRenderingCount(); i++) {
			System.out.println(csrl.getCodingSchemeRendering(i)
			        .getCodingSchemeSummary().getLocalName());
			System.out.println(csrl.getCodingSchemeRendering(i)
			        .getCodingSchemeSummary().getRepresentsVersion());
			System.out.println("********************");

			// get a version of the NCI Thesaurus on the server

			if (csrl.getCodingSchemeRendering(i).getCodingSchemeSummary()
			        .getFormalName().equals(THES_SCHEME)) {
				if (csrl.getCodingSchemeRendering(i).getRenderingDetail()
				        .getVersionTags().getTagCount() > 0) {
					THES_VERSION = csrl.getCodingSchemeRendering(i)
					        .getCodingSchemeSummary().getRepresentsVersion();
				}
			}
		}
	}

	public void testGetCodingSchemeConcepts() throws Exception {
		CodingSchemeVersionOrTag csvt = new CodingSchemeVersionOrTag();
		csvt.setVersion(THES_VERSION);
		CodedNodeSet cns = lbs.getCodingSchemeConcepts(THES_SCHEME, csvt);
		cns = cns.restrictToMatchingDesignations("blood",
		        SearchDesignationOption.PREFERRED_ONLY, "LuceneQuery", null);
		ResolvedConceptReferenceList rcrl = cns.resolveToList(null, null, null,
		        10);
		System.out.println("*");
		System.out.println("*");
		System.out.println("*");
		System.out.println("*");
		System.out.println("*");
		System.out
		        .println("FOR A SEARCH ON THE TEXT \"Blood\" PRINTING 1st CONCEPT IN THE LIST");
		System.out
		        .println("********************************************************************");
		System.out.print("Concept Desigation: ");
		System.out.println(rcrl.getResolvedConceptReference(0)
		        .getEntityDescription().getContent());
		System.out.print("Concept Unique Code: ");
		System.out
		        .println(rcrl.getResolvedConceptReference(0).getConceptCode());
		System.out.println(rcrl.getResolvedConceptReference(0).getEntity()
		        .getDefinition(0).getValue().getContent());
	}

	public void testGetCodingSchemeGraph() throws Exception {
		CodingSchemeVersionOrTag csvt = new CodingSchemeVersionOrTag();
		csvt.setVersion(THES_VERSION);
		System.out.println("*");
		System.out.println("*");
		System.out.println("*");
		System.out.println("*");
		System.out.println("*");
		System.out.println("PRINTING GRAPH NODES FOR DESIGNATION \"Blood\"");
		System.out.println("***********************************************");

		printTo("C12434", null, lbs, THES_SCHEME, csvt);
		printFrom("C12434", null, lbs, THES_SCHEME, csvt);
	}

	/**
	 * Display relations to the given code from other concepts.
	 * 
	 * @param code
	 * @param relation
	 * @param lbSvc
	 * @param scheme
	 * @param csvt
	 * @throws LBException
	 */
	protected void printTo(String code, String relation, LexBIGService lbSvc,
	        String scheme, CodingSchemeVersionOrTag csvt) throws LBException {
		System.out.println("Points to ...");

		ResolvedConceptReferenceList matches = lbSvc.getNodeGraph(scheme, csvt,
		        null).resolveAsList(
		        ConvenienceMethods.createConceptReference(code, scheme), true,
		        false, 1, 1, new LocalNameList(), null, null, 1024);

		// Analyze the result ...
		if (matches.getResolvedConceptReferenceCount() > 0) {
			ResolvedConceptReference ref = matches
			        .enumerateResolvedConceptReference().nextElement();

			// Print the associations
			AssociationList sourceof = ref.getSourceOf();
			Association[] associations = sourceof.getAssociation();
			for (Association assoc : associations) {
				AssociatedConcept[] acl = assoc.getAssociatedConcepts()
				        .getAssociatedConcept();
				for (AssociatedConcept ac : acl) {
					EntityDescription ed = ac.getEntityDescription();
					System.out.println("\t\t"
					        + ac.getConceptCode()
					        + "/"
					        + (ed == null ? "**No Description**" : ed
					                .getContent()));
				}
			}
		}
	}

	protected void printFrom(String code, String relation, LexBIGService lbSvc,
	        String scheme, CodingSchemeVersionOrTag csvt) throws LBException {
		// Perform the query ...
		System.out.println("Pointed at by ...");
		ResolvedConceptReferenceList matches = lbSvc.getNodeGraph(scheme, csvt,
		        null).resolveAsList(
		        ConvenienceMethods.createConceptReference(code, scheme), false,
		        true, 1, 1, new LocalNameList(), null, null, 1024);

		// Analyze the result ...
		if (matches.getResolvedConceptReferenceCount() > 0) {
			ResolvedConceptReference ref = matches
			        .enumerateResolvedConceptReference().nextElement();

			// Print the associations
			AssociationList targetof = ref.getTargetOf();
			Association[] associations = targetof.getAssociation();
			for (Association assoc : associations) {
				AssociatedConcept[] acl = assoc.getAssociatedConcepts()
				        .getAssociatedConcept();
				for (AssociatedConcept ac : acl) {
					EntityDescription ed = ac.getEntityDescription();
					System.out.println("\t\t"
					        + ac.getConceptCode()
					        + "/"
					        + (ed == null ? "**No Description**" : ed
					                .getContent()));
				}
			}
		}

	}
}
