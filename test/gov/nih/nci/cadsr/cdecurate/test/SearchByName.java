/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.cdecurate.test;

import gov.nih.nci.system.client.ApplicationServiceProvider;

import java.util.Vector;

import org.LexGrid.LexBIG.DataModel.Collections.ConceptReferenceList;
import org.LexGrid.LexBIG.DataModel.Collections.LocalNameList;
import org.LexGrid.LexBIG.DataModel.Collections.NameAndValueList;
import org.LexGrid.LexBIG.DataModel.Collections.ResolvedConceptReferenceList;
import org.LexGrid.LexBIG.DataModel.Collections.SortOptionList;
import org.LexGrid.LexBIG.DataModel.Core.CodingSchemeVersionOrTag;
import org.LexGrid.LexBIG.DataModel.Core.ConceptReference;
import org.LexGrid.LexBIG.DataModel.Core.NameAndValue;
import org.LexGrid.LexBIG.DataModel.Core.ResolvedConceptReference;
import org.LexGrid.LexBIG.Exceptions.LBException;
import org.LexGrid.LexBIG.Impl.LexBIGServiceImpl;
import org.LexGrid.LexBIG.LexBIGService.CodedNodeSet;
import org.LexGrid.LexBIG.LexBIGService.CodedNodeSet.ActiveOption;
import org.LexGrid.LexBIG.LexBIGService.LexBIGService;
import org.LexGrid.LexBIG.Utility.Constructors;
import org.LexGrid.LexBIG.Utility.ConvenienceMethods;
import org.LexGrid.LexBIG.Utility.Iterators.ResolvedConceptReferencesIterator;
import org.LexGrid.LexBIG.caCore.interfaces.LexEVSApplicationService;
import org.LexGrid.commonTypes.Property;
import org.LexGrid.concepts.Entity;

/**
 * Setup -
 * You need to 
 * 
 * 1. add all libraries under testlib/LexEVS_60_client_lib/
 * 2. add conf/ directory (it needs application-config-client.xml)
 * 
 * Sample output -
 * 
searchByName ... TX
ALGORITHM: nonLeadingWildcardLiteralSubString
*** Sort alphabetically...
Number of matches: 211
(1) Adenosarcoma pTX TNM Finding v7(C89609)
(2) Adrenal Cancer pTX TNM Finding v7(C89399)
(3) Altretamine/Cyclophosphamide/Fluorouracil/Methotrexate(C9598)
(4) Altretamine/Cyclophosphamide/Methotrexate(C10044)
(5) Altretamine/Doxorubicin/Methotrexate(C10092)
(6) Altretamine/Lomustine/Methotrexate(C10061)
(7) Ampulla of Vater Cancer pTX TNM Finding v7(C90267)
(8) Anal Cancer pTX TNM Finding(C67536)
(9) Anti-thymocyte Globulin/Cyclophosphamide(C11298)
(10) Antineoplaston A10/Methotrexate(C11481)
(11) Appendiceal Carcinoid pTX TNM Finding v7(C89923)
(12) Appendiceal Carcinoma pTX TNM Finding v7(C89895)
(13) Asparaginase/Cyclophosphamide/Cytarabine(C10248)
(14) Asparaginase/Cyclophosphamide/Cytarabine/Mercaptopurine/Methotrexate(C10300)
(15) Asparaginase/Cyclophosphamide/Cytarabine/Methotrexate(C10413)
(16) Asparaginase/Cyclophosphamide/Mercaptopurine/Methotrexate(C10738)
(17) Asparaginase/Cytarabine/Mercaptopurine/Methotrexate(C11532)
(18) Asparaginase/Cytarabine/Methotrexate(C11124)
(19) Asparaginase/Daunorubicin/Dexamethasone/Ifosfamide/Mercaptopurine/Methotrexate/Vindesine(C10682)
(20) Asparaginase/Ifosfamide/Methotrexate(C9931)
(21) Asparaginase/Leucovorin Calcium/Mercaptopurine/Methotrexate(C11535)
(22) Asparaginase/Mercaptopurine/Methotrexate(C10643)
(23) Asparaginase/Methotrexate(C10024)
(24) Bladder Cancer pTX TNM Finding(C61205)
(25) Bleomycin/Cisplatin/Methotrexate(C9609)
(26) Bleomycin/Cyclophosphamide/Fluorouracil/Methotrexate(C9553)
(27) Bleomycin/Lomustine/Methotrexate(C9772)
(28) Bone Cancer pTX TNM Finding v7(C88425)
(29) Breast Cancer pTX TNM Finding(C48972)
(30) Busulfan/Ciprofloxacin/Cyclophosphamide/Pentoxifylline(C10790)
... (truncated for simplicity) ...
(209) Vaginal Cancer pTX TNM Finding v7(C89458)
(210) Vulvar Cancer pTX TNM Finding v7(C89419)
(211) ZIC3 wt Allele(C75543)
 */
public class SearchByName {

    private static String CODE_SEARCH_ALGORITHM = "exactMatch";


    public static LexBIGService createLexBIGService()
    {
		String serviceUrl = "http://lexevsapi60.nci.nih.gov/lexevsapi60";

        try {
            if (serviceUrl == null || serviceUrl.compareTo("") == 0)
            {
                LexBIGService lbSvc = new LexBIGServiceImpl();
                return lbSvc;
            }

            LexEVSApplicationService lexevsService = (LexEVSApplicationService)ApplicationServiceProvider.getApplicationServiceFromUrl(serviceUrl, "EvsServiceInfo");
            return (LexBIGService) lexevsService;
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }


    public static CodedNodeSet getNodeSet(LexBIGService lbSvc, String scheme, CodingSchemeVersionOrTag versionOrTag)
        throws Exception {
		CodedNodeSet cns = null;
		try {
			cns = lbSvc.getCodingSchemeConcepts(scheme, versionOrTag);
			CodedNodeSet.AnonymousOption restrictToAnonymous = CodedNodeSet.AnonymousOption.NON_ANONYMOUS_ONLY;
			//6.0 mod (KLO, 101810)
			cns = cns.restrictToAnonymous(restrictToAnonymous);
	    } catch (Exception ex) {
			ex.printStackTrace();
		}
		return cns;
	}

    public static LocalNameList vector2LocalNameList(Vector<String> v) {
        if (v == null)
            return null;
        LocalNameList list = new LocalNameList();
        for (int i = 0; i < v.size(); i++) {
            String vEntry = (String) v.elementAt(i);
            list.addEntry(vEntry);
        }
        return list;
    }

    protected static NameAndValueList createNameAndValueList(Vector names,
        Vector values) {
        if (names == null)
            return null;
        NameAndValueList nvList = new NameAndValueList();
        for (int i = 0; i < names.size(); i++) {
            String name = (String) names.elementAt(i);
            String value = (String) values.elementAt(i);
            NameAndValue nv = new NameAndValue();
            nv.setName(name);
            if (value != null) {
                nv.setContent(value);
            }
            nvList.addNameAndValue(nv);
        }
        return nvList;
    }


    public static CodedNodeSet restrictToSource(CodedNodeSet cns, String source) {
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
            new CodedNodeSet.PropertyType[] { CodedNodeSet.PropertyType.PRESENTATION };
        try {
            cns =
                cns.restrictToProperties(propertyLnL, types, sourceLnL,
                    contextList, qualifierList);
        } catch (Exception ex) {
                  return null;
        }
        return cns;
    }



    public ResolvedConceptReferencesIteratorWrapper searchByName(
        String scheme, String version, String matchText,
        String matchAlgorithm, boolean ranking, int maxToReturn) {
        return searchByName(scheme, version, matchText, null, matchAlgorithm,
            ranking, maxToReturn);
    }

    public ResolvedConceptReferencesIteratorWrapper searchByName(
        String scheme, String version, String matchText, String source,
        String matchAlgorithm, boolean ranking, int maxToReturn) {
        Vector<String> schemes = new Vector<String>();
        schemes.add(scheme);
        Vector<String> versions = new Vector<String>();
        versions.add(version);
        return searchByName(schemes, versions, matchText, source,
            matchAlgorithm, ranking, maxToReturn);
    }

    public ResolvedConceptReferencesIteratorWrapper searchByName(
        Vector<String> schemes, Vector<String> versions, String matchText,
        String matchAlgorithm, boolean ranking, int maxToReturn) {
        return searchByName(schemes, versions, matchText, null,
            matchAlgorithm, ranking, maxToReturn);
    }


    public String findBestContainsAlgorithm(String matchText) {
        if (matchText == null)
            return "nonLeadingWildcardLiteralSubString";
        matchText = matchText.trim();
        if (matchText.length() == 0)
            return "nonLeadingWildcardLiteralSubString"; // or null
        if (matchText.length() > 1)
            return "nonLeadingWildcardLiteralSubString";
        char ch = matchText.charAt(0);
        if (Character.isDigit(ch))
            return "literal";
        else if (Character.isLetter(ch))
            return "LuceneQuery";
        else
            return "literalContains";
    }



    public ResolvedConceptReferencesIteratorWrapper searchByName(
        Vector<String> schemes, Vector<String> versions, String matchText,
        String source, String matchAlgorithm, boolean ranking, int maxToReturn) {
        try {
            if (matchText == null || matchText.trim().length() == 0)
                return null;
            boolean debug_flag = false;

            matchText = matchText.trim();
            System.out.println("searchByName ... " + matchText);

            if (matchAlgorithm.compareToIgnoreCase("contains") == 0)
            {
                matchAlgorithm = findBestContainsAlgorithm(matchText);
            }

            System.out.println("ALGORITHM: " + matchAlgorithm);

            LexBIGService lbSvc = createLexBIGService();
            Vector<CodedNodeSet> cns_vec = new Vector<CodedNodeSet>();
            for (int i = 0; i < schemes.size(); i++) {
                //stopWatch.start();
                String scheme = (String) schemes.elementAt(i);
                CodingSchemeVersionOrTag versionOrTag =
                    new CodingSchemeVersionOrTag();
                String version = (String) versions.elementAt(i);
                if (version != null)
                    versionOrTag.setVersion(version);

                CodedNodeSet cns = getNodeSet(lbSvc, scheme, versionOrTag);
                if (cns != null) {
                    cns =
                        cns.restrictToMatchingDesignations(matchText,
                            null, matchAlgorithm, null);
                    cns = restrictToSource(cns, source);
                }

                if (cns != null)
                    cns_vec.add(cns);


            }

            SortOptionList sortCriteria = null;
            LocalNameList restrictToProperties = new LocalNameList();
            boolean resolveConcepts = false;
            if (ranking) {
                sortCriteria = null;// Constructors.createSortOptionList(new
                                    // String[]{"matchToQuery"});
            } else {
                sortCriteria = Constructors .createSortOptionList(
                    new String[] { "entityDescription" }); // code
                System.out.println("*** Sort alphabetically...");
            }

            //stopWatch.start();
            if (debug_flag)
                System.out.println("Calling cns.resolve to resolve the union CNS ... ");
            ResolvedConceptReferencesIterator iterator =
                new QuickUnionIterator(cns_vec, sortCriteria, null,
                    restrictToProperties, null, resolveConcepts);

            return new ResolvedConceptReferencesIteratorWrapper(iterator);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }



    public static ConceptReferenceList createConceptReferenceList(
        String[] codes, String codingSchemeName) {
        if (codes == null) {
            return null;
        }
        ConceptReferenceList list = new ConceptReferenceList();
        for (int i = 0; i < codes.length; i++) {
            ConceptReference cr = new ConceptReference();
            cr.setCodingSchemeName(codingSchemeName);
            cr.setConceptCode(codes[i]);
            list.addConceptReference(cr);
        }
        return list;
    }



    public static ResolvedConceptReferencesIterator filterIterator(
        ResolvedConceptReferencesIterator iterator, String scheme,
        String version, String code) {
        if (iterator == null)
            return null;
        try {
            int num = iterator.numberRemaining();
            if (num <= 1)
                return iterator;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        try {
            while (iterator.hasNext()) {
                try {
                    ResolvedConceptReference[] refs =
                        iterator.next(100).getResolvedConceptReference();
                    for (ResolvedConceptReference ref : refs) {
                        if (ref.getConceptCode().compareTo(code) == 0) {
                            long ms0 = System.currentTimeMillis(), delay0 = 0;
                            LexBIGService lbSvc =
                                createLexBIGService();
                            if (lbSvc == null) {
                                return null;
                            }
                            CodingSchemeVersionOrTag versionOrTag =
                                new CodingSchemeVersionOrTag();
                            if (version != null)
                                versionOrTag.setVersion(version);

                            ConceptReferenceList crefs =
                                createConceptReferenceList(
                                    new String[] { code }, scheme);

                            CodedNodeSet cns = null;
                            try {
                                try {
                                    cns =
                                        lbSvc.getNodeSet(scheme, versionOrTag,
                                            null);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    return null;
                                }

                                if (cns == null) {

                                    return null;
                                }

                                cns = cns.restrictToCodes(crefs);
                                return cns.resolve(null, null, null);
                            } catch (Exception ex) {

                            }
                        }
                    }
                } catch (Exception ex) {
                    break;
                }
            }
        } catch (Exception ex) {

        }
        return null;
    }

    /**
     * Display properties for the given code.
     * 
     * @param code
     * @param lbSvc
     * @param scheme
     * @param csvt
     * @return
     * @throws LBException
     */
    public static boolean printProps(String code, LexBIGService lbSvc, String scheme, CodingSchemeVersionOrTag csvt)
            throws LBException {
        // Perform the query ...
        ConceptReferenceList crefs = ConvenienceMethods.createConceptReferenceList(new String[] { code }, scheme);

        ResolvedConceptReferenceList matches = lbSvc.getCodingSchemeConcepts(scheme, csvt).restrictToStatus(
                ActiveOption.ALL, null).restrictToCodes(crefs).resolveToList(null, null, null, 1);

        // Analyze the result ...
        if (matches.getResolvedConceptReferenceCount() > 0) {
            ResolvedConceptReference ref = (ResolvedConceptReference) matches.enumerateResolvedConceptReference()
                    .nextElement();

            Entity node = ref.getEntity();

            Property[] props = node.getProperty();
            for (int i = 0; i < props.length; i++) {
                Property prop = props[i];
//                Util.displayMessage(new StringBuffer().append("\tProperty name: ").append(prop.getPropertyName())
//                        .append(" text: ").append(prop.getValue().getContent()).toString());
              System.out.println(new StringBuffer().append("\tProperty name: ").append(prop.getPropertyName())
              .append(" text: ").append(prop.getValue().getContent()).toString());
            }

        } else {
//            Util.displayMessage("No match found!");
        	System.out.println("No match found!");
            return false;
        }

    	System.out.println("Version 1");
        
        
        return true;
    }

    public static void main(String[] args) {
		String scheme = null;
		String version = null;
		String code = null;

		scheme = "NCI Thesaurus";
		version = "12.10e";
		code = "C37927";

		String matchText = "TX";	//GF29786 Leading wildcard when searching for EVS concepts for Object Class, Property, Permissible Values does not work properly
		String matchAlgorithm = "contains";
		boolean ranking = false;
		int maxToReturn = 1000;

        try {

			ResolvedConceptReferencesIteratorWrapper wrapper = new SearchByName().searchByName(
				scheme, version, matchText,
				matchAlgorithm, ranking, maxToReturn);
			if (wrapper == null) {
				System.out.println("wrapper == null???");
			} else {
				ResolvedConceptReferencesIterator iterator = wrapper.getIterator();
				try {
					int numberRemaining = iterator.numberRemaining();
					System.out.println("Number of matches: " + numberRemaining);
					int lcv = 0;

					while (iterator.hasNext()) {
					    ResolvedConceptReference rcr = iterator.next();
					    String name = rcr.getEntityDescription().getContent();
					    String concept_code = rcr.getConceptCode();
					    lcv++;
					    System.out.println("(" + lcv + ") " + name + "(" + concept_code + ")");
					}


				} catch (Exception ex) {
					ex.printStackTrace();
				}

			}


        } catch (Exception e) {
            e.printStackTrace();
        }
    }



}