/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/test/TestVM.java,v 1.11 2008-03-13 17:57:59 chickerura Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.test;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Collection;
import java.util.Enumeration;
import java.util.InvalidPropertiesFormatException;
import java.util.Properties;
import java.util.Vector;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
//import com.sun.org.apache.xerces.internal.impl.xs.dom.DOMParser;
import com.sun.org.apache.xerces.internal.parsers.DOMParser;
import gov.nih.nci.cadsr.cdecurate.tool.ConceptAction;
import gov.nih.nci.cadsr.cdecurate.tool.ConceptForm;
import gov.nih.nci.cadsr.cdecurate.tool.CurationServlet;
import gov.nih.nci.cadsr.cdecurate.tool.EVS_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.VMAction;
import gov.nih.nci.cadsr.cdecurate.tool.VMForm;
import gov.nih.nci.cadsr.cdecurate.tool.VM_Bean;

/**
 * @author shegde
 *
 */
public class TestVM
{
  /**
   * 
   */
  public TestVM()
  {
  }
  /**
   * @param args
   */
  public static void main(String[] args)
  {
    // Initialize the Log4j environment.
    String logXML = "log4j.xml";
    if (args.length > 0)
    {
        logXML = args[0];
    }
//    logger.initLogger(logXML);
    //initialize connection
    String connXML = "";
    if (args.length > 1)
      connXML = args[1];
    varCon = new TestConnections(connXML, logger);
    VMForm vmdata = new VMForm();
    try {
		vmdata.setDBConnection(varCon.openConnection());
		CurationServlet cdeserv = new CurationServlet(); 
		cdeserv.setConn(varCon.openConnection());
		vmdata.setCurationServlet(cdeserv);
	} catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
    TestVM testvm = new TestVM();
//    logger.start();
//    logger.info("started vm test");
    
//    if (args.length >2) 
//      VMpropFile = args[2];
  VMpropFile = "/Users/ag/demo/cdecurate/src/gov/nih/nci/cadsr/cdecurate/test/TestVMCase.xml";

    //load properties with prop file name from input parameter
  //  if (args.length >2)      
  //    testvm.loadProp(args[2]);
    
    //call the search method
  //  testvm.doSearchVMValues(vmdata); 
    
    //call the validate method
    testvm.doValidateValues(vmdata);
  //  testvm.getConceptDerivation();
    
  //  testvm.switchCaseEx(2);
    //end the logger
//    logger.end();
  }

  private void doValidateValues(VMForm vmdata)
  {
    try
    {
       //check if test data is avialable
       if (VMpropFile != null && !VMpropFile.equals(""))
       {
         //open teh cadsr connection
         Connection conn = varCon.openConnection();      
         vmdata.setDBConnection(conn); 
         //get the root data
         Element node = parseXMLData(VMpropFile);
         StringBuffer sVM = new StringBuffer();
         this.exploreNode(node, sVM, vmdata);
       }       
       varCon.closeConnection();   //close the connection      
    }
    catch (Exception e)
    {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }    
  }
  
  private void doValidateValuesProp(VMForm vmdata)
  {
    try
    {
       //check if test data is avialable
       if (VMprop != null)
       {
         String sProp = VMprop.getProperty("vm0");
      System.out.println("got the key " + sProp);
         //open teh cadsr connection
         Connection conn = varCon.openConnection();      
         vmdata.setDBConnection(conn); 
         //loop through the data to test one by one
         for (int i=1; true; ++i)
         {
           //setting up the data
           VM_Bean vm = new VM_Bean();
           VM_Bean selvm = new VM_Bean();
           
           //edited value meaning from the page 
           String curvmname = VMprop.getProperty("current.vmname." + i);
           if (curvmname == null || curvmname.equals(""))
             break;
           
           if (curvmname != null)
             vm.setVM_LONG_NAME(curvmname);
           String curvmdesc = VMprop.getProperty("current.vmdesc." + i);
           if (curvmdesc != null)
             vm.setVM_PREFERRED_DEFINITION(curvmdesc);
           String curvmln = VMprop.getProperty("current.vmlongname." + i);
           if (curvmln != null)
             vm.setVM_LONG_NAME(curvmln);
           
           //concept associated with the edited value meaning
           String connm = VMprop.getProperty("current.conname." + i);
           if (connm != null)
           {
             Vector<EVS_Bean> conList = new Vector<EVS_Bean>();
             EVS_Bean vmCon = new EVS_Bean();
             vmCon.setLONG_NAME(connm);
             String conid = VMprop.getProperty("current.conid." + i);
             if (conid != null)
               vmCon.setCONCEPT_IDENTIFIER(conid);
             String condefn = VMprop.getProperty("current.condefn." + i);
             if (condefn != null)
               vmCon.setPREFERRED_DEFINITION(condefn);
             String conorgn = VMprop.getProperty("current.conorigin." + i);
             if (conorgn != null)
               vmCon.setEVS_ORIGIN(conorgn);
             String consrc = VMprop.getProperty("current.consrc." + i);
             if (consrc != null)
               vmCon.setEVS_DEF_SOURCE(consrc);
             String conidseq = VMprop.getProperty("current.conidseq." + i);
             if (conidseq != null)
               vmCon.setIDSEQ(conidseq);
             //add the concept bean to conlist vector and to the vm bean
             conList.addElement(vmCon);
             vm.setVM_CONCEPT_LIST(conList);
           }
           //selected value meaning before the change
           String selvmname = VMprop.getProperty("selected.vmname." + i);
           if (selvmname != null)
           {
             selvm.setVM_LONG_NAME(selvmname);
             String selvmdesc = VMprop.getProperty("selected.vmdesc." + i);
             if (selvmdesc != null)
               selvm.setVM_PREFERRED_DEFINITION(selvmdesc);
             String selvmln = VMprop.getProperty("selected.vmlongname." + i);
             if (selvmln != null)
               selvm.setVM_LONG_NAME(selvmln);
             String selvmid = VMprop.getProperty("selected.vmidseq." + i);
             if (selvmid != null)
               selvm.setVM_IDSEQ(selvmid);
             String selvmcondr = VMprop.getProperty("selected.vmcondr." + i);
             if (selvmcondr != null)
               selvm.setVM_CONDR_IDSEQ(selvmcondr);
             
             //add teh selected vm to the vm data
             vmdata.setSelectVM(selvm);
           }
           
    
           //add the beans to data object
           vmdata.setVMBean(vm);
           logger.info(i + " Validating VM for " + vm.getVM_LONG_NAME() + " : desc : " + vm.getVM_PREFERRED_DEFINITION() + " conlist " + vm.getVM_CONCEPT_LIST().size());
           
           //do the search;
           VMAction vmact = new VMAction();
           vmact.validateVMData(vmdata);  //doChangeVM(vmdata);
         }
       }       
       varCon.closeConnection();   //close the connection
      
    }
    catch (Exception e)
    {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    
  }
  
  private void doValidateValuesOld(VMForm vmdata)
  {
    try
    {
      //setting up the data
      VM_Bean vm = new VM_Bean();
     // vm.setVM_SHORT_MEANING("Nanomaterials");
    //  vm.setVM_SHORT_MEANING("Metastatic");
    //  vm.setVM_SHORT_MEANING("Dose");
    //  vm.setVM_SHORT_MEANING("Fludeoxyglucose F 18");
    //  vm.setVM_SHORT_MEANING("Adverse Event");
     // vm.setVM_SHORT_MEANING("Adverse Event Domain");
    //  vm.setVM_SHORT_MEANING("Adverse Event Capture");
     //   vm.setVM_SHORT_MEANING("Low");
        vm.setVM_LONG_NAME("Hypersensitivity");
        

     // vm.setVM_DESCRIPTION("need definiton");
    //  vm.setVM_DESCRIPTION("Any unfavorable and unintended sign (including an abnormal laboratory finding), symptom, syndrome, or disease, temporally associated with the use of a medical product or procedure, regardless of whether or not it is considered related to the product or procedure (attribution of unrelated, unlikely, possible, probable, or definite). The concept refers to events that could be medical product related, dose related, route related, patient related, caused by an interaction with another therapy or procedure, or caused by opioid initiation or dose escalation. The term also is referred to as an adverse experience. The old term Side Effect is retired and should not be used.");
      //vm.setVM_DESCRIPTION("No Value Exists.");
     // vm.setVM_DESCRIPTION("The Adverse Events dataset includes. Adverse events may be captured either as free text or a pre-specified list of terms.");
     // vm.setVM_DESCRIPTION("Adverse events may be captured either as free text or a pre-specified list of terms.");
    //  vm.setVM_DESCRIPTION("A procedure that uses ultrasonic waves directed over the chest wall to obtain a graphic record of the heart's position, motion of the walls, or internal parts such as the valves.");
     // vm.setVM_DESCRIPTION("The amount of medicine taken, or radiation given, at one time.");
    //  vm.setVM_DESCRIPTION("(MET-uh-STAT-ik) Having to do with metastasis, which is the spread of cancer from one part of the body to another.");
     //  vm.setVM_DESCRIPTION("Metastatic");
     //  vm.setVM_DESCRIPTION("Research aimed at discovery of novel nanoscale and nanostructured materials and at a comprehensive understanding of the properties of nanomaterials (ranging across length scales, and including interface interactions). Also, R&D leading to the ability to design and synthesize, in a controlled manner, nanostructured materials with targeted properties.");
     //   vm.setVM_DESCRIPTION("Lower than reference range");
        vm.setVM_PREFERRED_DEFINITION("Hypersensitivity");

       //get concepts for vm
       Vector<EVS_Bean> conList = new Vector<EVS_Bean>();
       EVS_Bean vmCon = new EVS_Bean();
       vmCon.setLONG_NAME("Hypersensitivity");  //("Low");   //("Metastatic");  //("Nanomaterials");
       vmCon.setCONCEPT_IDENTIFIER("C3114");   //("C54722");    //("C14174");  //  ("C53671");
       vmCon.setPREFERRED_DEFINITION("Hypersensitivity; a local or general reaction of an organism following contact with a specific allergen to which it has been previously exposed and to which it has become sensitized.");
           //("A minimum level or position or degree; less than normal in degree or intensity or amount.");
           //("(MET-uh-STAT-ik) Having to do with metastasis, which is the spread of cancer from one part of the body to another.");
           //("Research aimed at discovery of novel nanoscale and nanostructured materials and at a comprehensive understanding of the properties of nanomaterials (ranging across length scales, and including interface interactions). Also, R&D leading to the ability to design and synthesize, in a controlled manner, nanostructured materials with targeted properties.");
       vmCon.setEVS_ORIGIN("NCI Thesaurus");
       vmCon.setEVS_DEF_SOURCE("NCI");   //("NCI-GLOSS");
       vmCon.setIDSEQ("F37D0428-B65C-6787-E034-0003BA3F9857"); //(""); //("F37D0428-DE70-6787-E034-0003BA3F9857");
       conList.addElement(vmCon);
     //  vmdata.setConceptVMList(conceptVMList)
       vm.setVM_CONCEPT_LIST(conList);
       
       vmdata.setVMBean(vm);
       
      VM_Bean selvm = new VM_Bean();
      selvm.setVM_LONG_NAME("Hypersensitivity");  //("Adverse Event Domain");
      selvm.setVM_PREFERRED_DEFINITION("Hypersensitivity");   //("need definiton");
      vmdata.setSelectVM(selvm);
      logger.info("Validating VM for " + vm.getVM_LONG_NAME() + " : desc : " + vm.getVM_PREFERRED_DEFINITION());
      //open teh cadsr connection
      Connection conn = varCon.openConnection();      
      vmdata.setDBConnection(conn);      
      //do the search;
      VMAction vmact = new VMAction();
      vmact.validateVMData(vmdata);  //doChangeVM(vmdata);
      varCon.closeConnection();   //close the connection
      
    }
    catch (Exception e)
    {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    
  }
  
  /*private void doSearchVMValues(VMForm vmdata)
  {
    try
    {
      //test data to store from form
      vmdata.setSearchTerm("*blood*");  //search term
      //vmdata.setSearchFilterCD("");  //cd id for filtering      
      Vector<String> vmSelAttr = new Vector<String>();  //pick attributes to display
      vmSelAttr.addElement("Value Meaning");
      vmSelAttr.addElement("Meaning Description");
      vmSelAttr.addElement("Conceptual Domain");
      vmSelAttr.addElement("EVS Identifier");
      vmdata.setSelAttrList(vmSelAttr);
      vmdata.setSortField("MeanDesc");  //column heading id for sorting
      
      //open teh cadsr connection
      Connection conn = varCon.openConnection();      
      logger.info("searching VM for " + vmdata.getSearchTerm() + " : " + vmdata.getSearchFilterCD() + " : sort : " + vmdata.getSortField());
      vmdata.setDBConnection(conn);      
      //do the search
      VMAction vmact = new VMAction();
      vmact.searchVMValues(vmdata);
      varCon.closeConnection();   //close the connection
      //print out the results
      Vector vmlist = vmdata.getVMList();
      if (vmlist == null || vmlist.size() < 1)
        logger.info("no results found ");
      else
      {
        logger.info("VM Found " + vmlist.size());
        //get the results to be displayed
        vmact.getVMResult(vmdata);
        Vector vmdisp = vmdata.getResultList();
        if (vmdisp == null || vmdisp.size() < 1)
          logger.info("none is added to the display");
        else
          logger.info("total entries in the display " + vmdisp.size());

        //call sort method
        vmact.getVMSortedRows(vmdata);
        vmlist = vmdata.getVMList();
        if (vmlist == null || vmlist.size() < 1)
          logger.info("no results found after sort");
        else
        {
          logger.info("VM count after sort " + vmlist.size());
          //get the results to be displayed
          vmact.getVMResult(vmdata);
          vmdisp = vmdata.getResultList();
          if (vmdisp == null || vmdisp.size() < 1)
            logger.info("none is added to the display after sort");
          else
            logger.info("total entries in the display after sort " + vmdisp.size());
        }        
      }
    }
    catch (SQLException e)
    {
      e.printStackTrace();
      logger.fatal("search vm ");
    }
  }*/

  private void getConceptDerivation()
  {
    try
    {
      ConceptForm condata = new ConceptForm();
      Vector<EVS_Bean> vCon = new Vector<EVS_Bean>();
      EVS_Bean eBean = new EVS_Bean();
      eBean.setIDSEQ("F37D0428-B66C-6787-E034-0003BA3F9857");  //("11F45981-C7AC-5747-E044-0003BA0B1A09");
      vCon.addElement(eBean);
      eBean = new EVS_Bean();
      eBean.setIDSEQ("17B24111-A29F-73AC-E044-0003BA0B1A09");
      vCon.addElement(eBean);
      
      condata.setConceptList(vCon);
      //open teh cadsr connection
      Connection conn = varCon.openConnection();
      condata.setDBConnection(conn);
      ConceptAction conact = new ConceptAction();
      String condr = conact.getConDerivation(condata);
      varCon.closeConnection();   //close the connection      
    }
    catch (SQLException e)
    {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }      
    
  }

  /**
   * Load the properties from the XML file specified.
   * 
   * @param propFile the properties file.
   */
  private void loadProp(String propFile)
  {
      VMprop = new Properties();
      try
      {
          logger.section("Loading VM test case properties...");
          VMpropFile = propFile;
          FileInputStream in = new FileInputStream(VMpropFile);
          VMprop.loadFromXML(in);
          in.close();
      }
      catch (FileNotFoundException ex)
      {
          logger.fatal(ex.toString());
      }
      catch (InvalidPropertiesFormatException ex)
      {
          logger.fatal(ex.toString());
      }
      catch (IOException ex)
      {
          logger.fatal(ex.toString());
      }
      
  }

  private static CurationTestLogger logger = new CurationTestLogger(TestVM.class);

  private static TestConnections varCon;

  private static Properties VMprop;
  private static String VMpropFile;

  @SuppressWarnings("unchecked")
  private void switchCaseEx(int argc)
  {
    switch (argc)     /* Switch evaluates an expression (argc)  */
    {
          /* If expression resolves to 1, jump here */
    case 1:
      System.out.println("Only the command was entered.");
      /* break;            /* break - cases the execution to jump
             out of the 'switch' block.             */
     
          /* If expression resolves to 2, jump here */
    case 2:
      System.out.println("Command plus one parm entered");
      //break;
     
          /* If expression resolves to 3, jump here */
    case 3:
      System.out.println("Command plus two parm entered");
      break;

          /* Any other value jumps here.            */
    default:
      System.out.println("Command plus %d parms entered\n");
      break;
    }    
    //test number combinations
    Vector comb = new Vector();
    int i = 10;
    do
    {
      int j = 1;
      do
      {
        int k = i + j;
        System.out.println(i + " + " + j + " = " + k);
        if (comb.contains(k))
          System.out.println("Already exists : " + k);
        comb.addElement(k);
        j += 1;
      } while (j < 10);
      i += 10;
    } while (i < 150);
    
    //setting up the data
    VM_Bean vm = new VM_Bean();
   // vm.setVM_SHORT_MEANING("Nanomaterials");
  //  vm.setVM_SHORT_MEANING("Metastatic");
  //  vm.setVM_SHORT_MEANING("Dose");
  //  vm.setVM_SHORT_MEANING("Fludeoxyglucose F 18");
  //  vm.setVM_SHORT_MEANING("Adverse Event");
   // vm.setVM_SHORT_MEANING("Adverse Event Domain");
  //  vm.setVM_SHORT_MEANING("Adverse Event Capture");
   //   vm.setVM_SHORT_MEANING("Low");
      vm.setVM_LONG_NAME("Hypersensitivity");
      

   // vm.setVM_DESCRIPTION("need definiton");
  //  vm.setVM_DESCRIPTION("Any unfavorable and unintended sign (including an abnormal laboratory finding), symptom, syndrome, or disease, temporally associated with the use of a medical product or procedure, regardless of whether or not it is considered related to the product or procedure (attribution of unrelated, unlikely, possible, probable, or definite). The concept refers to events that could be medical product related, dose related, route related, patient related, caused by an interaction with another therapy or procedure, or caused by opioid initiation or dose escalation. The term also is referred to as an adverse experience. The old term Side Effect is retired and should not be used.");
    //vm.setVM_DESCRIPTION("No Value Exists.");
   // vm.setVM_DESCRIPTION("The Adverse Events dataset includes. Adverse events may be captured either as free text or a pre-specified list of terms.");
   // vm.setVM_DESCRIPTION("Adverse events may be captured either as free text or a pre-specified list of terms.");
  //  vm.setVM_DESCRIPTION("A procedure that uses ultrasonic waves directed over the chest wall to obtain a graphic record of the heart's position, motion of the walls, or internal parts such as the valves.");
   // vm.setVM_DESCRIPTION("The amount of medicine taken, or radiation given, at one time.");
  //  vm.setVM_DESCRIPTION("(MET-uh-STAT-ik) Having to do with metastasis, which is the spread of cancer from one part of the body to another.");
   //  vm.setVM_DESCRIPTION("Metastatic");
   //  vm.setVM_DESCRIPTION("Research aimed at discovery of novel nanoscale and nanostructured materials and at a comprehensive understanding of the properties of nanomaterials (ranging across length scales, and including interface interactions). Also, R&D leading to the ability to design and synthesize, in a controlled manner, nanostructured materials with targeted properties.");
   //   vm.setVM_DESCRIPTION("Lower than reference range");
      vm.setVM_PREFERRED_DEFINITION("Hypersensitivity");

     //get concepts for vm
     Vector<EVS_Bean> conList = new Vector<EVS_Bean>();
     EVS_Bean vmCon = new EVS_Bean();
     vmCon.setLONG_NAME("Hypersensitivity");  //("Low");   //("Metastatic");  //("Nanomaterials");
     vmCon.setCONCEPT_IDENTIFIER("C3114");   //("C54722");    //("C14174");  //  ("C53671");
     vmCon.setPREFERRED_DEFINITION("Hypersensitivity; a local or general reaction of an organism following contact with a specific allergen to which it has been previously exposed and to which it has become sensitized.");
         //("A minimum level or position or degree; less than normal in degree or intensity or amount.");
         //("(MET-uh-STAT-ik) Having to do with metastasis, which is the spread of cancer from one part of the body to another.");
         //("Research aimed at discovery of novel nanoscale and nanostructured materials and at a comprehensive understanding of the properties of nanomaterials (ranging across length scales, and including interface interactions). Also, R&D leading to the ability to design and synthesize, in a controlled manner, nanostructured materials with targeted properties.");
     vmCon.setEVS_ORIGIN("NCI Thesaurus");
     vmCon.setEVS_DEF_SOURCE("NCI");   //("NCI-GLOSS");
     vmCon.setIDSEQ("F37D0428-B65C-6787-E034-0003BA3F9857"); //(""); //("F37D0428-DE70-6787-E034-0003BA3F9857");
     conList.addElement(vmCon);
   //  vmdata.setConceptVMList(conceptVMList)
     vm.setVM_CONCEPT_LIST(conList);
     
    // vmdata.setVMBean(vm);
     
    VM_Bean selvm = new VM_Bean();
    selvm.setVM_LONG_NAME("Hypersensitivity");  //("Adverse Event Domain");
    selvm.setVM_PREFERRED_DEFINITION("Hypersensitivity");   //("need definiton");
  //  vmdata.setSelectVM(selvm);
    
  }

  private Element parseXMLData(String fileName)
  {
    Element root = null;
    try
    {
      DOMParser parser = new DOMParser();
      parser.parse(fileName);
      Document doc = parser.getDocument();
      root = doc.getDocumentElement();
    }
    catch (SAXException e)
    {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    catch (IOException e)
    {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    return root;
  }
  private void readVMdata(NamedNodeMap attr, VMForm vmdata, boolean readMore)
  {
    VM_Bean vm = vmdata.getVMBean(); 
    VM_Bean selvm = vmdata.getSelectVM();
    //validate the old vm first before reading the next vm data
    if (vm != null && !vm.getVM_LONG_NAME().equals(""))
    {
      //do the search;
      VMAction vmact = new VMAction();
      vmact.validateVMData(vmdata);  //doChangeVM(vmdata);
    }
    if (readMore)
    {
      //reset the vm
      vm = new VM_Bean();
      selvm = new VM_Bean();
      //get teh next vm data
      for (int i=0; i<attr.getLength(); i++)
      {
        String attName = attr.item(i).getNodeName();
        String attValue = attr.item(i).getNodeValue();
        
        if (attName != null && !attName.equals(""))
        {
          if (attName.equals("editvmname"))
           // vm.setVM_SHORT_MEANING(attValue);
        	  vm.setVM_LONG_NAME(attValue);
          else if (attName.equals("editvmlongname"))
            vm.setVM_LONG_NAME(attValue);
          else if (attName.equals("editvmdesc"))
            vm.setVM_PREFERRED_DEFINITION(attValue);
          else if (attName.equals("selvmname"))
            //selvm.setVM_SHORT_MEANING(attValue);
        	  selvm.setVM_LONG_NAME(attValue);
        	  else if (attName.equals("selvmlongname"))
            selvm.setVM_LONG_NAME(attValue);
          else if (attName.equals("selvmdesc"))
            selvm.setVM_PREFERRED_DEFINITION(attValue);
          else if (attName.equals("selvmidseq"))
            selvm.setVM_IDSEQ(attValue);
          else if (attName.equals("selvmcondr"))
            selvm.setVM_CONDR_IDSEQ(attValue);
        }
        //add the beans to data object
        vmdata.setVMBean(vm);
        vmdata.setSelectVM(selvm);
      //  logger.info(i + " Validating VM for " + vm.getVM_SHORT_MEANING() + " : desc : " + vm.getVM_DESCRIPTION() + " conlist " + vm.getVM_CONCEPT_LIST().size());
      }
    }
  }
  
  private void readConData(NamedNodeMap attr, VMForm data)
  {
    VM_Bean vm = data.getVMBean();
    EVS_Bean vmCon = new EVS_Bean();
    Vector<EVS_Bean> conList = vm.getVM_CONCEPT_LIST();
    for (int i=0; i<attr.getLength(); i++)
    {
      //System.out.println(i + " ConAttr : " + attr.item(i).getNodeName() + " value " + attr.item(i).getNodeValue());          

      String attName = attr.item(i).getNodeName();
      String attValue = attr.item(i).getNodeValue();
      
      if (attName != null && !attName.equals(""))
      {
        if (attName.equals("conname"))
          vmCon.setLONG_NAME(attValue);
        else if (attName.equals("conid"))
          vmCon.setCONCEPT_IDENTIFIER(attValue);
        else if (attName.equals("condefn"))
          vmCon.setPREFERRED_DEFINITION(attValue);
        else if (attName.equals("condefnsrc"))
          vmCon.setEVS_DEF_SOURCE(attValue);
        else if (attName.equals("conorigin"))
          vmCon.setEVS_ORIGIN(attValue);
        else if (attName.equals("consrc"))
          vmCon.setEVS_CONCEPT_SOURCE(attValue);
        else if (attName.equals("conidseq"))
          vmCon.setIDSEQ(attValue);
      }
    }
    conList.addElement(vmCon);
    vm.setVM_CONCEPT_LIST(conList);
  }
  
  public void exploreNode(Node node, StringBuffer sVM, VMForm data)
  {
    try
    {
      if (node.getNodeType() == Node.ELEMENT_NODE)
      {
        NamedNodeMap attr = node.getAttributes();
        if (node.getNodeName().equals("valuemeaning")) 
        {
          sVM.delete(0, sVM.length());
          sVM.append(attr.getNamedItem("editvmname").getNodeValue());
          //call teh vm to validate other vm and store new one
          readVMdata(attr, data, true);
        }
        System.out.println(">>>concept vm " + sVM.toString());
        if (node.getNodeName().equals("concept") && attr.getNamedItem("vm") != null && attr.getNamedItem("vm").getNodeValue().equals(sVM.toString()))
        {
          System.out.println("get concepts vector " + attr.getNamedItem("vm").getNodeValue());
          //call con method to validate con and store it back in the data
          readConData(attr, data);
        }
        //validate the last VM
        if (node.getNodeName().equals("property") && attr.getNamedItem("vmid") != null && attr.getNamedItem("vmid").getNodeValue().equals("vmend"))
        {
          //call teh vm to validate other vm and store new one
          readVMdata(attr, data, false);
        }
        //go to next child
        NodeList children = node.getChildNodes();
        for (int x=0; x<children.getLength(); x++)
        {
           System.out.println(x + " parent " + node.getNodeName() + " child : " + children.item(x).getNodeName());
           if (children.item(x) != null)
           {
             System.out.println(" explore node called ");
             exploreNode(children.item(x), sVM, data);
           }
        } 
      }
    }
    catch (DOMException e)
    {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }    
  }
  
}
