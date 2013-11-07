package gov.nih.nci.cadsr.cdecurate.util;

import java.util.Vector;

import org.LexGrid.LexBIG.DataModel.Collections.LocalNameList;
import org.LexGrid.LexBIG.DataModel.Collections.NameAndValueList;
import org.LexGrid.LexBIG.DataModel.Collections.ResolvedConceptReferenceList;
import org.LexGrid.LexBIG.DataModel.Core.NameAndValue;
import org.LexGrid.LexBIG.DataModel.Core.ResolvedConceptReference;
import org.LexGrid.LexBIG.Exceptions.LBException;
import org.LexGrid.LexBIG.LexBIGService.CodedNodeSet;
import org.LexGrid.LexBIG.LexBIGService.LexBIGService;
import org.LexGrid.LexBIG.LexBIGService.CodedNodeSet.PropertyType;
import org.LexGrid.LexBIG.Utility.Constructors;
import org.LexGrid.LexBIG.Utility.LBConstants;
import org.LexGrid.LexBIG.serviceHolder.LexEVSServiceHolder;

public class LexEVSHelper {

	/** Taken from /LexEVS_Test_60/src/org/LexGrid/LexBIG/testUtil/ServiceTestCase.java
	 * (https://ncisvn.nci.nih.gov/WebSVN/filedetails.php?repname=evsops&path=%2FLexEVS_Test_60%2Ftrunk%2Fsrc%2Forg%2FLexGrid%2FLexBIG%2FtestUtil%2FServiceTestCase.java) */
	public final static String THES_SCHEME = /*properties.getProperty("THES_SCHEME");*/ "NCI_Thesaurus";
	private static LexBIGService lbSvc = null;
	private CodedNodeSet matches;


	public CodedNodeSet getMatches() {
		return matches;
	}

//	public long getMetathesaurusMapping(LexBIGService lbSvc, String term) throws Exception {
//		if (lbSvc == null) {
//			throw new Exception("LexBIGService can not be NULL or empty.");
//		}
//		LexEVSHelper.lbSvc = lbSvc;
//
//		long count = 0;
//
//		CodedNodeSet nodeSet;
//		try {
//			nodeSet = lbSvc.getNodeSet("NCI MetaThesaurus", null, null);
//
//			// Tell the api that you want to get back only the PRESENTATION type
//			// properties
//			CodedNodeSet.PropertyType[] types = new CodedNodeSet.PropertyType[1];
//			types[0] = CodedNodeSet.PropertyType.PRESENTATION;
//
//			// Now create a qualifier list containing the code you wish to
//			// search
//			NameAndValueList qualifierList = new NameAndValueList();
//			NameAndValue nv = new NameAndValue();
//			nv.setName("source-code");
//			nv.setContent(term);
//			qualifierList.addNameAndValue(nv);
//
//			nodeSet = nodeSet.restrictToProperties(null, types, null, null,
//					qualifierList);
//			nodeSet = nodeSet.restrictToProperties(null, types, Constructors.createLocalNameList("LNC"), null,
//					null);
//			ResolvedConceptReferenceList rcrl = nodeSet.resolveToList(null,
//					null, null, 10);
//			Vector<String> metaCUIs = new Vector<String>();
//			for (int i = 0; i < rcrl.getResolvedConceptReferenceCount(); i++) {
//				ResolvedConceptReference rcr = rcrl
//						.getResolvedConceptReference(i);
//				String metaCUI = rcr.getCode();
//				metaCUIs.add(metaCUI);
//			}
//
//			LocalNameList lnl = new LocalNameList();
//			lnl.addEntry("UMLS_CUI");
//			lnl.addEntry("NCI_META_CUI");
//			for (String metaCUI : metaCUIs) {
//				count++;
//				boolean found = matchAttributeValue(lnl, metaCUI);
//				System.out.println("found count " + count);
//			}
//
//		} catch (LBException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		return count;
//	}

	public long getMetathesaurusMapping(LexBIGService lbSvc, String term, String source) throws Exception {
		if (lbSvc == null) {
			throw new Exception("LexBIGService can not be NULL or empty.");
		}
		LexEVSHelper.lbSvc = lbSvc;

		long count = 0;

		CodedNodeSet nodeSet;
		try {
			nodeSet = lbSvc.getNodeSet("NCI MetaThesaurus", null, null);

			// Tell the api that you want to get back only the PRESENTATION type
			// properties
			CodedNodeSet.PropertyType[] types = new CodedNodeSet.PropertyType[1];
			types[0] = CodedNodeSet.PropertyType.PRESENTATION;

			// Now create a qualifier list containing the code you wish to
			// search
			NameAndValueList qualifierList = new NameAndValueList();
			NameAndValue nv = new NameAndValue();
			nv.setName("source-code");
			nv.setContent(term);
			qualifierList.addNameAndValue(nv);

			nodeSet = nodeSet.restrictToProperties(null, types, null, null,
					qualifierList);
			if(source != null) {
				if(source.equals("LOINC")) {
					source = "LNC";
				}     

				nodeSet = nodeSet.restrictToProperties(null, types, Constructors.createLocalNameList(source), null,
					null);
			}
			ResolvedConceptReferenceList rcrl = nodeSet.resolveToList(null,
					null, null, 10);
			Vector<String> metaCUIs = new Vector<String>();
			for (int i = 0; i < rcrl.getResolvedConceptReferenceCount(); i++) {
				ResolvedConceptReference rcr = rcrl
						.getResolvedConceptReference(i);
				String metaCUI = rcr.getCode();
				metaCUIs.add(metaCUI);
			}

			LocalNameList lnl = new LocalNameList();
			lnl.addEntry("UMLS_CUI");
			lnl.addEntry("NCI_META_CUI");
			for (String metaCUI : metaCUIs) {
				count++;
				boolean found = matchAttributeValue(lnl, metaCUI);
				System.out.println("found count " + count);
			}

		} catch (LBException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return count;
	}

	
	
	/**
	 * Taken from
	 * /LexEVS_Test_60/src/org.LexGrid.LexBIG.distributed.test.function
	 * .query/TestAttributeValueMatch.java
	 * (https://ncisvn.nci.nih.gov/WebSVN/filedetails
	 * .php?repname=evsops&path=%2F
	 * LexEVS_Test_60%2Ftrunk%2Fsrc%2Forg%2FLexGrid%2F
	 * LexBIG%2Fdistributed%2Ftest
	 * %2Ffunction%2Fquery%2FTestAttributeValueMatch.java)
	 */
	private boolean matchAttributeValue(String prop, String value)
			throws LBException {

		CodedNodeSet cns = LexEVSServiceHolder.instance().getLexEVSAppService()
				.getCodingSchemeConcepts(THES_SCHEME, null);

		LocalNameList lnl = new LocalNameList();
		lnl.addEntry(prop);
		CodedNodeSet matches = cns.restrictToMatchingProperties(lnl, null,
				value, "contains", null);
		int count = matches.resolveToList(null, null, null, 0)
				.getResolvedConceptReferenceCount();
		return (count > 0);
	}

	/**
	 * Taken from
	 * /LexEVS_Test_60/src/org.LexGrid.LexBIG.distributed.test.function
	 * .query/TestAttributeValueMatch.java
	 * (https://ncisvn.nci.nih.gov/WebSVN/filedetails
	 * .php?repname=evsops&path=%2F
	 * LexEVS_Test_60%2Ftrunk%2Fsrc%2Forg%2FLexGrid%2F
	 * LexBIG%2Fdistributed%2Ftest
	 * %2Ffunction%2Fquery%2FTestAttributeValueMatch.java)
	 */
	private boolean matchAttributeValueType(PropertyType prop, String value)
			throws LBException {

		CodedNodeSet cns = LexEVSServiceHolder.instance().getLexEVSAppService()
				.getCodingSchemeConcepts(THES_SCHEME, null);
		CodedNodeSet matches = cns.restrictToMatchingProperties(null,
				new PropertyType[] { prop }, value, "contains", null);
		int count = matches.resolveToList(null, null, null, 0)
				.getResolvedConceptReferenceCount();
		return (count > 0);
	}

	private boolean matchAttributeValue(LocalNameList lnl, String value) throws Exception {
		if (lbSvc == null) {
			throw new Exception("LexBIGService can not be NULL or empty.");
		}
		try {
			CodedNodeSet cns = lbSvc.getCodingSchemeConcepts(
					"NCI_Thesaurus", null);
			matches = cns.restrictToMatchingProperties(lnl, null,
					value, LBConstants.MatchAlgorithms.contains.name(), null);
			int count = matches.resolveToList(null, null, null, 0)
					.getResolvedConceptReferenceCount();
			if (count > 0)
				return true;
			return false;
		} catch (LBException e) {
			return false;
		}
	}

}