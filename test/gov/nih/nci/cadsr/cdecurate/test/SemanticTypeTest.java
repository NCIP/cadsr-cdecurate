package gov.nih.nci.cadsr.cdecurate.test;

import gov.nih.nci.system.client.ApplicationServiceProvider;

import java.util.List;
import java.util.Vector;

import org.LexGrid.LexBIG.DataModel.Collections.ConceptReferenceList;
import org.LexGrid.LexBIG.DataModel.Collections.LocalNameList;
import org.LexGrid.LexBIG.DataModel.Collections.NameAndValueList;
import org.LexGrid.LexBIG.DataModel.Collections.ResolvedConceptReferenceList;
import org.LexGrid.LexBIG.DataModel.Core.NameAndValue;
import org.LexGrid.LexBIG.DataModel.Core.ResolvedConceptReference;
import org.LexGrid.LexBIG.LexBIGService.CodedNodeSet;
import org.LexGrid.LexBIG.LexBIGService.CodedNodeSet.PropertyType;
import org.LexGrid.LexBIG.LexBIGService.LexBIGService;
import org.LexGrid.LexBIG.Utility.Constructors;
import org.LexGrid.LexBIG.Utility.ConvenienceMethods;
import org.LexGrid.commonTypes.Property;
import org.LexGrid.commonTypes.Source;
import org.LexGrid.concepts.Definition;
import org.LexGrid.concepts.Presentation;
import org.apache.log4j.Logger;
//import gov.nih.nci.cadsr.cdecurate.tool.EVSSearch;

public class SemanticTypeTest {
	Logger logger = Logger.getLogger(SemanticTypeTest.class.getName());
	LexBIGService evsService = null;
	String url = null;

	public static void main(String[] args){
		SemanticTypeTest test = new SemanticTypeTest();
		System.out.println("Testing by term");
		test.doMetaSearch("egg", "", "NCI", 100, "NCI");
		test.doMetaSearch("blood", "", "NCI", 100, "NCI");
		System.out.println("Testing by cui");
		test.doMetaSearch("C0029045", "MetaCode", "NCI", 100, "NCI");
		System.out.println("Meta source code search");
		test.doMetaSearch("C12598","sourceCode","NCI",100,"NCI");
	}

	public SemanticTypeTest(){
		initialize();
	}

	private void initialize(){
		try{
			url = "http://lexevsapi60-stage.nci.nih.gov/lexevsapi60";
			evsService = (LexBIGService) ApplicationServiceProvider.getApplicationServiceFromUrl(url, "EvsServiceInfo");

		}
		catch (Exception e){

		}
	}

	private Vector<String> doMetaSearch(
			String termStr, String sSearchIn, String sMetaSource,
			int iMetaLimit, String sVocab) {

		ResolvedConceptReferenceList concepts = null;

		Vector<String> vList = null;
		List metaResults = null;

		try {
			CodedNodeSet nodeSet = evsService.getNodeSet("NCI MetaThesaurus", null, null);
			if (sSearchIn.equalsIgnoreCase("MetaCode")) { 

				//query.searchSourceByAtomCode(termStr, sMetaSource);

				CodedNodeSet.PropertyType[] types = new CodedNodeSet.PropertyType[1];
				types[0] = CodedNodeSet.PropertyType.PRESENTATION;

				nodeSet = nodeSet.restrictToProperties(
						null,
						types,
						Constructors.createLocalNameList(sMetaSource),
						null,
						null);


				ConceptReferenceList crl = new ConceptReferenceList();
				crl.addConceptReference(ConvenienceMethods.createConceptReference(termStr, "NCI MetaThesaurus"));
				nodeSet = nodeSet.restrictToCodes(crl);

			}
			else if (sSearchIn.equalsIgnoreCase("sourceCode")) //source-code search
				//do meta code specific to vocabulary source
				// In the NCI MetaThesaurus, fidning the 'source' of an 'Atom' is equivalent to finding the
				//'source' of a given Property of an Entity. Each CUI (which is equivalent to an Entity in
				//LexEVS) may contain several Presentation Properties (Atoms or AUI's of that CUI).
				//Each of these Presentation Properties is Qualified by a 'source-code' Qualifier,
				//which reflects the code of this Atom in its original source, and a 'source' qualifier,
				//which states the source itself that this Atom came from
			{
				CodedNodeSet.PropertyType[] types = new CodedNodeSet.PropertyType[1];
				types[0] = CodedNodeSet.PropertyType.PRESENTATION;
				NameAndValueList qualifierList = new NameAndValueList();
				NameAndValue nv = new NameAndValue();
				nv.setName("source-code");
				nv.setContent(termStr);
				qualifierList.addNameAndValue(nv);
				LocalNameList LnL = new LocalNameList();
				LnL.addEntry(sMetaSource);
				nodeSet = nodeSet.restrictToProperties(null,types,LnL,null, qualifierList);
			}
			else {
				nodeSet = nodeSet.restrictToMatchingDesignations(termStr, //the text to match
						CodedNodeSet.SearchDesignationOption.PREFERRED_ONLY,  //whether to search all designation, only Preferred or only Non-Preferred
						"nonLeadingWildcardLiteralSubString", //the match algorithm to use
						null); //the language to match (null matches all)
			}



			concepts = nodeSet.resolveToList(
					null, //Sorts used to sort results (null means sort by match score)
					null, //PropertyNames to resolve (null resolves all)
					null,  //PropertyTypess to resolve (null resolves all)
					iMetaLimit   //cap the number of results returned (-1 resolves all)
					);

		} catch (Exception ex) {
			logger.error("doMetaSearch evsSearch: " + ex.toString(), ex); //JT - lexvs error here!!!
			System.out.println("Well, something bad happened");
		}
		if (concepts != null && concepts.getResolvedConceptReferenceCount() > 0) {
			String sConName = "";
			String sConID = "";
			String sCodeType = "";
			String sSemantic = "";
			String sCodeSrc = "";
			int iLevel = 0;
			for (int i = 0; i < concepts.getResolvedConceptReferenceCount(); i++) {
				// Do this so only one result is returned on Meta code search (API is dupicating a result)
				if (sSearchIn.equals("MetaCode") && i > 0) {
					break;
				}
				//get concept properties
				//				ResolvedConceptReference rcr = concepts.getResolvedConceptReference(i);
				ResolvedConceptReference rcr = concepts.enumerateResolvedConceptReference().nextElement();
				if (rcr != null) {
					Property[] props = rcr.getEntity().getProperty();
					Presentation[] presentations = rcr.getEntity().getPresentation();
					Definition[] definitions = rcr.getEntity().getDefinition();

					sConName = rcr.getEntityDescription().getContent();
					sConID = rcr.getCode();
					System.out.println(sConID + " [" + sConName + "]");

					//					sCodeType = this.getNCIMetaCodeType(sConID, "byID");

					//get semantic types
					sSemantic = this.getMetaSemantics(props); //TBD - JT "Semantic Type" might be empty here?
					//get preferred source code from atom collection
					sCodeSrc = this.getPrefMetaCode(presentations);

					//get definition attributes
					String sDefSource = "";
					//					String sDefinition = m_eUser.getDefDefaultValue();
					//add sepeate record for each definition
					//					if (definitions != null && definitions.length > 0) {
					//						for (Definition defType: definitions) {
					//							sDefinition = defType.getValue().getContent();
					//							sDefSource = defType.getSource()[0].getContent();
					//
					//							EVS_Bean conBean = new EVS_Bean();
					//							conBean.setEVSBean(sDefinition, sDefSource,
					//									sConName, sConName, sCodeType, sConID,
					//									sVocab, sVocab, iLevel, "", "", "", "",
					//									sSemantic, "", "");
					//							conBean.setPREF_VOCAB_CODE(sCodeSrc); //store pref code in the bean
					//							vList.addElement(conBean); //add concept bean to vector
					//						}
					//					} else {
					//						EVS_Bean conBean = new EVS_Bean();
					//						conBean.setEVSBean(sDefinition, sDefSource,
					//								sConName, sConName, sCodeType, sConID,
					//								sVocab, sVocab, iLevel, "", "", "", "",
					//								sSemantic, "", "");
					//						conBean.setPREF_VOCAB_CODE(sCodeSrc); //store pref code in the bean
					//						vList.addElement(conBean); //add concept bean to vector
					//					}
				}
			}
		}
		return vList;
	}

	/**
	 * to get the semantic value for meta thesarurs concept from the collection
	 * @param mtcCon MetaThesaurusConcept object
	 * @return sSemantic
	 */
	private String getMetaSemantics(Property[] properties) {
		String sSemantic = "";

		for (Property prop: properties) {
			String name = prop.getPropertyName();
			if (name != null && name.equals("Semantic_Type")) {
				if (!sSemantic.equals("")) {
					sSemantic += "; ";
				}
				sSemantic += prop.getValue().getContent();
			}
		}
		return sSemantic;
	}

	/**
	 * to get the NCI thesaurus code from the atom collection
	 * @param mtcCon MetaThesaurusConcept object
	 * @return sCode
	 */
	private String getPrefMetaCode(Presentation[] presentations) {
		String sCode = "";
		String prefSrc = "";
		for (Presentation pres: presentations) {
			Source[] sources = pres.getSource();
			//			prefSrc = m_eUser.getPrefVocabSrc();
			prefSrc = "NCI";
			if (prefSrc != null) {
				for (Source src : sources) {
					String sConSrc = src.getContent();
					if (src != null && !sConSrc.equals("")) {
						//						if (sConSrc.contains(prefSrc))
						//							System.out.println("GOT THE PREFSRC");
						if (sCode == null) {
							sCode = "";
						}
					}
				}
			}
		}
		return sCode;
	}

	public CodedNodeSet restrictToSource(CodedNodeSet cns, String source) {
		if (cns == null)
			return cns;
		if (source == null || source.compareTo("*") == 0
				|| source.compareTo("") == 0 || source.compareTo("ALL") == 0)
			return cns;

		LocalNameList contextList = null;
		LocalNameList sourceLnL = null;
		NameAndValueList qualifierList = null;

		Vector<String> w2 = new Vector<String>();
		w2.add(source);
		sourceLnL = vector2LocalNameList(w2);
		LocalNameList propertyLnL = null;
		CodedNodeSet.PropertyType[] types =
				new PropertyType[] { PropertyType.PRESENTATION };
		try {
			cns =
					cns.restrictToProperties(propertyLnL, types, sourceLnL,
							contextList, qualifierList);
		} catch (Exception ex) {
			logger.error("restrictToSource throws exceptions.");
			return null;
		}
		return cns;
	}

	public static LocalNameList vector2LocalNameList(Vector<String> v) {
		if (v == null)
			return null;
		LocalNameList list = new LocalNameList();
		for (int i = 0; i < v.size(); i++) {
			String vEntry = v.elementAt(i);
			list.addEntry(vEntry);
		}
		return list;
	}
}
