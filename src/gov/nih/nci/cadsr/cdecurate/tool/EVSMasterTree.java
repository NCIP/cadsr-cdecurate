// Copyright (c) 2000 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/EVSMasterTree.java,v 1.1 2006-02-08 19:11:13 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import gov.nih.nci.evs.domain.*;

import java.util.*;
import javax.servlet.http.*;
import org.apache.log4j.Logger;


/**
 * EVSMasterTree class generates trees and renders the trees as HTML.
 * @author Tom Phillips
 */
 
/*
 * The CaCORE Software License, Version 3.0 Copyright 2002-2005 ScenPro, Inc. (“ScenPro”)  
Copyright Notice.  The software subject to this notice and license includes both
human readable source code form and machine readable, binary, object code form
(“the CaCORE Software”).  The CaCORE Software was developed in conjunction with
the National Cancer Institute (“NCI”) by NCI employees and employees of SCENPRO.
To the extent government employees are authors, any rights in such works shall
be subject to Title 17 of the United States Code, section 105.    
This CaCORE Software License (the “License”) is between NCI and You.  “You (or “Your”)
shall mean a person or an entity, and all other entities that control, are 
controlled by, or are under common control with the entity.  “Control” for purposes
of this definition means (i) the direct or indirect power to cause the direction
or management of such entity, whether by contract or otherwise, or (ii) ownership
of fifty percent (50%) or more of the outstanding shares, or (iii) beneficial 
ownership of such entity.  
This License is granted provided that You agree to the conditions described below.
NCI grants You a non-exclusive, worldwide, perpetual, fully-paid-up, no-charge,
irrevocable, transferable and royalty-free right and license in its rights in the
CaCORE Software to (i) use, install, access, operate, execute, copy, modify, 
translate, market, publicly display, publicly perform, and prepare derivative 
works of the CaCORE Software; (ii) distribute and have distributed to and by 
third parties the CaCORE Software and any modifications and derivative works 
thereof; and (iii) sublicense the foregoing rights set out in (i) and (ii) to 
third parties, including the right to license such rights to further third parties.
For sake of clarity, and not by way of limitation, NCI shall have no right of 
accounting or right of payment from You or Your sublicensees for the rights 
granted under this License.  This License is granted at no charge to You.
1.	Your redistributions of the source code for the Software must retain the above
copyright notice, this list of conditions and the disclaimer and limitation of
liability of Article 6, below.  Your redistributions in object code form must
reproduce the above copyright notice, this list of conditions and the disclaimer
of Article 6 in the documentation and/or other materials provided with the 
distribution, if any.
2.	Your end-user documentation included with the redistribution, if any, must 
include the following acknowledgment: “This product includes software developed 
by SCENPRO and the National Cancer Institute.”  If You do not include such end-user
documentation, You shall include this acknowledgment in the Software itself, 
wherever such third-party acknowledgments normally appear.
3.	You may not use the names "The National Cancer Institute", "NCI" “ScenPro, Inc.”
and "SCENPRO" to endorse or promote products derived from this Software.  
This License does not authorize You to use any trademarks, service marks, trade names,
logos or product names of either NCI or SCENPRO, except as required to comply with
the terms of this License.
4.	For sake of clarity, and not by way of limitation, You may incorporate this
Software into Your proprietary programs and into any third party proprietary 
programs.  However, if You incorporate the Software into third party proprietary
programs, You agree that You are solely responsible for obtaining any permission
from such third parties required to incorporate the Software into such third party
proprietary programs and for informing Your sublicensees, including without 
limitation Your end-users, of their obligation to secure any required permissions
from such third parties before incorporating the Software into such third party
proprietary software programs.  In the event that You fail to obtain such permissions,
You agree to indemnify NCI for any claims against NCI by such third parties, 
except to the extent prohibited by law, resulting from Your failure to obtain
such permissions.
5.	For sake of clarity, and not by way of limitation, You may add Your own 
copyright statement to Your modifications and to the derivative works, and You 
may provide additional or different license terms and conditions in Your sublicenses
of modifications of the Software, or any derivative works of the Software as a 
whole, provided Your use, reproduction, and distribution of the Work otherwise 
complies with the conditions stated in this License.
6.	THIS SOFTWARE IS PROVIDED "AS IS," AND ANY EXPRESSED OR IMPLIED WARRANTIES,
(INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, 
NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR PURPOSE) ARE DISCLAIMED.  
IN NO EVENT SHALL THE NATIONAL CANCER INSTITUTE, SCENPRO, OR THEIR AFFILIATES 
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

public class EVSMasterTree
{
  // class variables
	public Hashtable m_treesHash; // nodeName, with tree of it's children
	public Hashtable m_treeNodesHash;	// holds an easy-lookup of open nodes while rendering HTML
  private Hashtable m_treesHashParent; // nodeName, with tree of it's children
	public Hashtable m_treeNodesHashParent;	// h
  public Hashtable m_treeLeafsHashParent;
  private Hashtable m_treeIDtoNameHash;
  private Hashtable m_treeIDtoNameHashParent;
  private Stack m_expandedTreeNodes;
  private Stack m_expandedTreeNodesParent;
  private Vector m_expandedTreeNodesVector;
  private String treeName;
	private String collapsedImage="plus.png";			// image for collapsed nodes
	private String openedImage="ominus.png";			// image for expanded nodes
	private String leafImage="dot.png";				// image for leaf nodes
	private String detailsImage="details.gif";				
  private HttpServletRequest m_classReq = null;
  private HttpServletResponse m_classRes = null;
  private String m_dtsVocab = "";
  private String urlSearch ="/cdecurate/NCICurationServlet?reqType=treeSearch&&keywordID="; //&&vocab=
  private String urlExpand ="/cdecurate/NCICurationServlet?reqType=treeExpand&&nodeName="; //&&vocab=
  private String urlCollapse ="/cdecurate/NCICurationServlet?reqType=treeCollapse&&nodeName="; //&&vocab=
  private int level = 1;
  private int lastNodeID = 1;
  private javax.servlet.ServletContext m_ServletContext;
 // private Vector m_vRootNames = new Vector();
 // private Vector m_vRootCodes = new Vector();
  private String sSearchAC = "";
  private NCICurationServlet m_servlet = null;
  private EVS_UserBean m_eUser = null;

  Logger logger = Logger.getLogger(EVSMasterTree.class.getName());

  /**
   * Constructs a new instance.
   * @param req   The HttpServletRequest object.
   * @param dtsVocab  Vocabulary name.
   * @param CurationServlet  The Curation Tool servlet.
   */
  public EVSMasterTree(HttpServletRequest req, String dtsVocab, NCICurationServlet CurationServlet)
  {
    m_servlet = CurationServlet;
    m_classReq = req;
    m_dtsVocab = dtsVocab;
    HttpSession session = req.getSession();
    if(session != null)
    { 
      m_eUser = (EVS_UserBean)session.getAttribute("EvsUserBean");
      if (m_eUser == null) m_eUser = new EVS_UserBean(); //to be safe use the default props
      
      m_treesHash = (Hashtable)session.getAttribute("treesHash");
      if(m_treesHash == null)
      {
        m_treesHash = new Hashtable();
        session.setAttribute("treesHash",m_treesHash);
      }
      m_treesHashParent = (Hashtable)session.getAttribute("treesHashParent");
      if(m_treesHashParent == null)
      {
        m_treesHashParent = new Hashtable();
        session.setAttribute("treesHashParent",m_treesHashParent);
      }
      m_treeNodesHashParent = (Hashtable)session.getAttribute("treeNodesHashParent");    
      if(m_treeNodesHashParent == null)
      {
        m_treeNodesHashParent = new Hashtable();
        session.setAttribute("treeNodesHashParent", m_treeNodesHashParent);
      }
      m_treeNodesHash = (Hashtable)session.getAttribute("treeNodesHash");    
      if(m_treeNodesHash == null)
      {
        m_treeNodesHash = new Hashtable();
        session.setAttribute("treeNodesHash", m_treeNodesHash);
      }
      m_treeLeafsHashParent = (Hashtable)session.getAttribute("treeLeafsHashParent");    
      if(m_treeLeafsHashParent == null)
      {
        m_treeLeafsHashParent = new Hashtable();
        session.setAttribute("treeLeafsHashParent", m_treeLeafsHashParent);
      } 
      m_treeIDtoNameHash = (Hashtable)session.getAttribute("treeIDtoNameHash"); 
      if(m_treeIDtoNameHash == null)
      {
        m_treeIDtoNameHash = new Hashtable();
        session.setAttribute("treeIDtoNameHash", m_treeIDtoNameHash);
      }
      m_treeIDtoNameHashParent = (Hashtable)session.getAttribute("treeIDtoNameHashParent");    
      if(m_treeIDtoNameHashParent == null)
      {
        m_treeIDtoNameHashParent = new Hashtable();
        session.setAttribute("treeIDtoNameHashParent", m_treeIDtoNameHashParent);
      }
      m_expandedTreeNodes = (Stack)session.getAttribute("expandedTreeNodes");    
      if(m_expandedTreeNodes == null)
      {
        m_expandedTreeNodes = new Stack();
        session.setAttribute("expandedTreeNodes", m_expandedTreeNodes);
      }
      m_expandedTreeNodesParent = (Stack)session.getAttribute("expandedTreeNodesParent");    
      if(m_expandedTreeNodesParent == null)
      {
        m_expandedTreeNodesParent = new Stack();
        session.setAttribute("expandedTreeNodesParent", m_expandedTreeNodesParent);
      }
      m_expandedTreeNodesVector = (Vector)session.getAttribute("expandedTreeNodesVector");    
      if(m_expandedTreeNodesVector == null)
      {
        m_expandedTreeNodesVector = new Vector();
        session.setAttribute("expandedTreeNodesVector", m_expandedTreeNodesVector);
      }
    }
  }
  
/**
   * Sets the tree name
   * @param str   The Tree name.
*/
  public void	setTreeName(String str) 
  { 
    this.treeName = str; 
  }
	
  /**
   * Uses dtsVocab to retrieve the root nodes of that vocab, checks whether each
   * is a node or a leaf (no children) then displays the Tree, with appropriate gif
   * for node or leaf.
   * This creates a new Tree, dtsTree, then creates Node objects for each Root
   * and adds the node to dtsTree, then at the end stores dtsTree in m_treesHash
   * with the name of the vocab. Each Node is given a nodeID and put in m_treeNodesHash,
   * with ID as the name. The ID of the node is related to its name in m_treeIDtoNameHash
   * Each nodeID is put in m_treeHash with its child tree. 
   * ( m_treesHash.put(sNodeID, tn.getChildren()), with nodeID as the name of tree
   * 
   * (pass in the name, retrieve the ID).
   * @param dtsVocab    The Vocabulary name.
   * @return rendHTML   The string of html which displays the Tree.
   */
	public String populateTreeRoots(String dtsVocab) 
  {	
		Tree dtsTree = new Tree("dtsTree");
    HttpSession session = m_classReq.getSession();
    
    m_treesHashParent = (Hashtable)session.getAttribute("treesHashParent");
    if(m_treesHashParent == null) 
      m_treesHashParent = new Hashtable();
     m_treeNodesHashParent = (Hashtable)session.getAttribute("treeNodesHashParent");    
    if(m_treeNodesHashParent == null) 
      m_treeNodesHashParent = new Hashtable();
     m_treeLeafsHashParent = (Hashtable)session.getAttribute("treeLeafsHashParent");    
    if(m_treeLeafsHashParent == null) 
      m_treeLeafsHashParent = new Hashtable();
     m_treeIDtoNameHashParent = (Hashtable)session.getAttribute("treeIDtoNameHashParent");    
    if(m_treeIDtoNameHashParent == null) 
      m_treeIDtoNameHashParent = new Hashtable();
     m_expandedTreeNodesParent = (Stack)session.getAttribute("expandedTreeNodesParent");    
    if(m_expandedTreeNodesParent == null) 
      m_expandedTreeNodesParent = new Stack();

   // dtsVocab = filterName(dtsVocab, "js");
    GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, m_servlet);
    EVSSearch evs = new EVSSearch(m_classReq, m_classRes, m_servlet); 
    String sSearchAC = (String)session.getAttribute("creSearchAC");
    if(sSearchAC == null) sSearchAC = "";
    Vector vRoot = new Vector();
    Vector vSubConceptNames = new Vector();
    Vector vSubConcepts2 = new Vector();
    boolean moreChildren = true;
    String rendHTML = "";
    Integer id = new Integer(0);
    if(sSearchAC.equals("ParentConceptVM"))
      id = (Integer)m_treesHashParent.get("lastNodeID");
    else
      id = (Integer)m_treesHash.get("lastNodeID"); // for new nodes will need the last used nodeID
    if(id == null) id = new Integer(0);
    int lastNodeID = id.intValue();
  //  if(dtsVocab == null || dtsVocab.equals(""))
  //    dtsVocab = m_dtsVocab;
		try 
    {    
      // See if this Vocab's tree already has been built and stored in ServletContext
      Tree vocabTree = (Tree)m_treesHash.get(dtsVocab);
      if(vocabTree != null)
      {
// System.out.println("popTree  vocabTree != null");
        rendHTML = renderHTML(vocabTree);
      }
      else
      {  
logger.debug(dtsVocab + " popTree  vocabTree == null " + rendHTML);
        // Get the Root concepts, names and codes.
       // m_vRootNames = evs.getRootConcepts(dtsVocab, true);
       // m_vRootCodes = evs.getRootConcepts(dtsVocab, false);
        List vRoots = evs.getRootConcepts(dtsVocab);
  logger.debug("popTree  done getRootConcepts");
        // For each Root, get the Subconcepts. If subconcepts exist, build a Node
        // object, else build a Leaf object
        if (vRoots != null)
        {
          for(int j=0; j < vRoots.size(); j++) 
          {           
            //vSubConceptNames = evs.getSubConceptNames(dtsVocab, (String)m_vRootNames.elementAt(j), "", (String)m_vRootCodes.elementAt(j), "");              
            //if(vSubConceptNames.size()>0)
            DescLogicConcept oDLC = (DescLogicConcept)vRoots.get(j);
            if (oDLC != null)
            {
              logger.debug(oDLC.getName() + " - " + oDLC.getHasChildren().booleanValue());
              String sDispName = evs.getDisplayName(dtsVocab, oDLC, oDLC.getName());
              if (oDLC.getHasChildren().booleanValue())
              {
                //TreeNode tn = new TreeNode(lastNodeID++, (String)m_vRootNames.elementAt(j), (String)m_vRootCodes.elementAt(j), level);
                TreeNode tn = new TreeNode(lastNodeID++, oDLC.getName(), sDispName, oDLC.getCode(), level);
                tn.setExpanded(false);
                tn.setVisible(true);
                tn.getChildren().setLevel(level+1);
                tn.getChildren().setParentNodeID(tn.getId());
                //Each node is added to the vocab tree
                dtsTree.addChild(tn);
                //Every node created is stored in m_treeNodesHash, for quick retrieval
                Integer iNodeID = new Integer(tn.getId());
                String sNodeID = iNodeID.toString();
                if(sSearchAC.equals("ParentConceptVM"))
                {
                  m_treeNodesHashParent.put(tn.getName(), tn);
                  m_treesHashParent.put(tn.getName(), tn.getChildren()); 
                }
                else
                {
                  m_treeNodesHash.put(sNodeID, tn);
                  fillTreeIDtoNameHash(tn.getName(), sNodeID); //m_treeIDtoNameHash.put(tn.getName(), sNodeID);          
                  m_treesHash.put(sNodeID, tn.getChildren()); //add the node's children tree to hash table      
                }
              }
              else
              { 
                TreeLeaf tl = new TreeLeaf(lastNodeID++, oDLC.getName(), sDispName, oDLC.getCode(), level);
                //Each leaf is added to the vocab tree
                dtsTree.addChild(tl);
                tl.setVisible(true);
              }
            }
          } 
        }
        // Store the tree then render the html
        this.setTreeName(dtsVocab);   
        dtsTree.setName(dtsVocab); 
        //Put the vocab tree in m_treesHash 
        m_treesHash.put(treeName, dtsTree);	// Store the tree in the static Hashtable 
        //Keep track of number of nodes in m_treesHash (nodeID is incremented above, each time new node is created
        Integer nodeid = new Integer(lastNodeID);    
        m_treesHash.put("lastNodeID", nodeid);
//System.out.println("popTree 7");
        if(dtsTree != null)
        {  
          rendHTML = renderHTML(dtsTree);  
        } 
        if(session != null)
        {
          session.setAttribute("treesHash", m_treesHash);
          session.setAttribute("treeNodesHash", m_treeNodesHash);
          session.setAttribute("treeIDtoNameHash", m_treeIDtoNameHash);
        }
      }
		} 
    catch(Exception e) 
    {
			System.out.println("Error in populateTreeRoots: " + e.toString());
      logger.debug("Error in populateTreeRoots: " + e.toString());
		}
//logger.debug("popTree done");
  return rendHTML;	
	}

	/**
	 * Renders the specified tree as HTML by iterating over all it's children. Will call itself
	 * recursively for any visible node children.
   * @param tree    The Tree object to render.
   * @return buf.toString()   The string buffer of html
	 */
	public String renderHTML(Tree tree) 
  {
//System.out.println("renderHTML tree.size: " + tree.size() + " tree.name: " + tree.getName());
    if(tree == null)
      return "";
    String sSearchAC = "";
    String displayName1 = "";
    String displayName2 = "";
    try
    {
      if(m_classReq != null && m_classReq.getSession() != null)
      {
        HttpSession session2 = m_classReq.getSession();
        if(session2 != null)
          sSearchAC = (String)session2.getAttribute("creSearchAC");
        if(sSearchAC == null) sSearchAC = "";
      }
    }
    catch(Exception e) 
    {
			System.out.println("Error in renderHTML: " + e.toString());
		}
		StringBuffer buf = new StringBuffer();
    boolean moreChildren = true;
    int numChildren = 0;
    
    Tree nodeTree = new Tree("nodeTree");
  //  if(m_dtsVocab != null)
  //    displayName1 = filterName(m_dtsVocab, "display");
  /*  if(displayName1 != null)
    {
      if(displayName1.equals("Thesaurus/Metathesaurus"))
        displayName1 = "Thesaurus";
    } */
  //  m_dtsVocab = filterName(m_dtsVocab, "js");
    //Build the html in a string buffer
    EVS_Bean eBean = new EVS_Bean();
    displayName1 = eBean.getVocabAttr(m_eUser, m_dtsVocab, "vocabName", "vocabDBOrigin"); 
    displayName2 = " Root Concepts";
    if(sSearchAC.equals("ParentConceptVM"))
      displayName2 =  " Parent Concept";  
		buf.append("\n<TABLE width=\"100%\" border=\"0\"");
		buf.append(">\n");
    buf.append("<tr></tr>");
    String jsEnd = "');\"";
    String js = "\"javascript:refreshTree('";
    String sRefresh = js + m_dtsVocab + jsEnd;
    if(!sSearchAC.equals("ParentConceptVM"))
    {
      buf.append( "<a ");
      buf.append("href=").append(sRefresh).append(">");
      buf.append(displayName1).append("</a>").append(displayName2);
    }
    else
       buf.append(displayName1).append(displayName2);
		for(int i=0; i < tree.size(); i++) 
    {
			TreeObject treeObject = tree.getChild(i);
			if(treeObject.getType() == Tree.NODE ) 
      {
				TreeNode node = (TreeNode)treeObject;
        if(node.isVisible())
        {     
          // render root level 1xxxxxxxxxxxxxxxxxxxxxxxxxxxx
          buf.append(renderNodeHTML(node));
          nodeTree = node.getChildren();
          numChildren = nodeTree.size();
          if(numChildren > 0)
          {
            for(int j=0;j<numChildren;j++)
            {
              if(nodeTree.getChild(j).getType() == Tree.NODE)
              {
               TreeNode tn = (TreeNode)nodeTree.getChild(j);
               if(tn.isVisible())
                buf.append(renderNodeHTML(tn));   
               // render root level 2 and beyond yyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
               Tree nodeTree2 = tn.getChildren();
               int numChildren2 = nodeTree2.size();
               if(numChildren2 > 0) // if children have been created, it will render them
                  renderSubNodes(tn, buf);
               // end level 2 yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
              }
              else if(nodeTree.getChild(j).getType() == Tree.LEAF)
              {
                TreeLeaf tl = (TreeLeaf)nodeTree.getChild(j);
                if(tl.isVisible())
                  buf.append(renderLeafHTML(tl));
              }
              // end level 1 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
            }
          }
        }
			}
			else 
      {
        TreeLeaf leaf = (TreeLeaf)treeObject;
        if(leaf.isVisible())
          buf.append(renderLeafHTML(leaf));
			}
		}
		buf.append("\n</TABLE>\n");
		return buf.toString();
	}
  
/**
	* Renders the subNodes, given a Node. Attaches the html to the StringBuffer passed in.
  * @param tn    TreeNode object.
  * @param buf   StringBuffer
*/
private void renderSubNodes(TreeNode tn, StringBuffer buf) 
{
    Tree nodeTree2 = tn.getChildren();
    int numChildren2 = nodeTree2.size();
    if(numChildren2 > 0) //
    {
      for(int k=0;k<numChildren2;k++)
      {
        if(nodeTree2.getChild(k).getType() == 0)  // node
        {
          TreeNode tn2 = (TreeNode)nodeTree2.getChild(k);
          String name = tn2.getName();
          if(tn2.isVisible())
            buf.append(renderNodeHTML(tn2));
          Tree nodeTree3 = tn2.getChildren(); //next level of recursion
          if(nodeTree3.size()>0)
            renderSubNodes(tn2, buf);
        }
        else if(nodeTree2.getChild(k).getType() == 1) // leaf
        {
          TreeLeaf tl2 = (TreeLeaf)nodeTree2.getChild(k);
          if(tl2.isVisible())
            buf.append(renderLeafHTML(tl2));
        }
      }
    }  
}
  
  
	/**
	 * Renders the specified tree node as HTML.
   * @param node    TreeNode object.
   * @return buf.toString()   The stringbuffer
	 */
	private String renderNodeHTML(TreeNode node)
  {
//System.out.println("renderNodeHTML m_dtsVocab: " + m_dtsVocab);
		StringBuffer buf = new StringBuffer();
    String sSearch = "";
    String sExpand = "";
    String sCollapse = "";
    String nodeCCode = node.getCode();
    int nodeID = node.getId();
    Integer iNodeID = new Integer(nodeID);
    String sNodeID = iNodeID.toString();
    String sNodeName = node.getName();
    String sJSName = sNodeName;  // filterName(sNodeName, "js");
    UtilService util = new UtilService();
//System.out.println(sJSName + " single " + util.parsedStringSingleQuote(sJSName) + " double " + util.parsedStringDoubleQuoteJSP(sJSName));
    sJSName = util.parsedStringSingleQuote(sJSName);
    sJSName = util.parsedStringDoubleQuoteJSP(sJSName);
  //  m_dtsVocab = filterName(m_dtsVocab, "js");
    String displayName = node.getDispName();  // filterName(sNodeName, "display");
    // Handle the 'GO' exception, which actually displays "_" of Root concepts
 //   if(displayName.equals("Gene Ontology")) displayName = "Gene_Ontology";
		buf.append( "<tr><td>");
    // This gives the correct indentation between levels of the tree
    if(node.getLevel() ==2) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(node.getLevel() ==3) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(node.getLevel() ==4) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(node.getLevel() ==5) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(node.getLevel() ==6) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(node.getLevel() ==7) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(node.getLevel() ==8) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(node.getLevel() ==9) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(node.getLevel() ==10) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(node.getLevel() ==11) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(node.getLevel() ==12) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    String js = "\"javascript:doTreeAction('search','";
    String jsEnd = "');\"";
    String nodeLvl = String.valueOf(node.getLevel()-2);
    sSearch = js + nodeCCode + "','" + m_dtsVocab + "','" + sJSName + "','" + sNodeID + "','" + nodeLvl + jsEnd;
    buf.append( "<a ");
		if(node.isExpanded())
    {
      js = "\"javascript:doTreeAction('collapse','";
      sCollapse = js + nodeCCode + "','" + m_dtsVocab + "','" + sJSName + "','" + sNodeID + "','" + nodeLvl + jsEnd;
      buf.append("href=").append(sCollapse).append(" >");
      buf.append( "<img src='../../cdecurate/Assets/").append(openedImage).append("' border='0'>" );
    }
    else
    {
      js = "\"javascript:doTreeAction('expand','";
      sExpand = js + nodeCCode + "','" + m_dtsVocab + "','" + sJSName + "','" + sNodeID + "','" + nodeLvl + jsEnd;
      buf.append("href=").append(sExpand).append(" >");
      buf.append( "<img src='../../cdecurate/Assets/").append(collapsedImage).append("' border='0'>" );
    }
		buf.append( "</a>" ); 
    buf.append( "&nbsp;");
    buf.append( "<a ");
    buf.append("href=").append(sSearch).append(">");
    if(node.isBold())
      buf.append( " " ).append("<b>").append(displayName).append("</b>");
    else
      buf.append( " " ).append(displayName);
		buf.append( "</a>" );
		buf.append( "</td></tr>" );
		return buf.toString();
	}
  
  /**
	 * Puts in and takes out "_"
   *  @param nodeName   The name of node.
   *  @param type       'display' with no underscores between words, or 'js' with underscores.
   *  @return nodeName  The new name of the node
	 */
	private String filterName(String nodeName, String type)
  {
//System.out.println("filterName0: " + nodeName);
    if(type.equals("display"))
    {
    //  nodeName = nodeName.replaceAll("__","q9");
      nodeName = nodeName.replaceAll("_"," ");
   //   nodeName = nodeName.replaceAll("q9","_");
    }
    else if(type.equals("js"))
    {
  //    nodeName = nodeName.replaceAll("_","__");
      nodeName = nodeName.replaceAll(" ","_");
    }
      return nodeName;
  }


	/**
	 * Renders the specified tree leaf as HTML.
   *  @param TreeLeaf leaf
   *  @return buf.toString()   The stringbuffer
   */
	private final String renderLeafHTML(TreeLeaf leaf) 
  {
//System.out.println("renderLeafHTML");
    StringBuffer buf = new StringBuffer();
    int leafID = leaf.getId();
    Integer iLeafID = new Integer(leafID);
    String sLeafID = iLeafID.toString();
    String nodeCCode = leaf.getCode();
    String sLeafName = leaf.getName();
 //   m_dtsVocab = filterName(m_dtsVocab, "js");
    String sJSName = sLeafName;  // filterName(sLeafName, "js");
    UtilService util = new UtilService();
    sJSName = util.parsedStringSingleQuote(sJSName);
    sJSName = util.parsedStringDoubleQuoteJSP(sJSName);
    String displayName = leaf.getDispName();  // filterName(sLeafName, "display");
     // Handle the 'GO' exception, which actually displays "_" of Root concepts on DTS Browser
//    if(displayName.equals("is a")) displayName = "is_a";
 //   else if(displayName.equals("part of")) displayName = "part_of";
		buf.append( "<tr><td>");
    // This gives the correct indentation between levels of the tree
    if(leaf.getLevel() ==2) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(leaf.getLevel() ==3) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(leaf.getLevel() ==4) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(leaf.getLevel() ==5) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(leaf.getLevel() ==6) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(leaf.getLevel() ==7) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(leaf.getLevel() ==8) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(leaf.getLevel() ==9) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(leaf.getLevel() ==10) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(leaf.getLevel() ==11) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    else if(leaf.getLevel() ==12) buf.append( "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    String js = "\"javascript:doTreeAction('search','";
    String jsEnd = "');\"";
    String leafLvl = String.valueOf(leaf.getLevel()-2);
    String sSearch = js + nodeCCode + "','" + m_dtsVocab + "','" + sJSName + "','" + sLeafID + "','" + leafLvl + jsEnd;
		buf.append( "<img src='../../cdecurate/Assets/").append(leafImage).append("' border='0'>" );
    buf.append( "&nbsp;");
    buf.append( "<a ");
    buf.append("href=").append(sSearch).append(">");
    if(leaf.isBold())
      buf.append( " " ).append("<b>").append(displayName).append("</b>");
    else
      buf.append( " " ).append(displayName);
		buf.append( "</a>" );
		buf.append( "</td></tr>" );
		return buf.toString();
	}
  
  
  /**
	 * When user clicks on the node's + sign, this method checks if the node's children
   * tree already exists, if so, it sets them visible. Otherwise it retrieves them,
   * then renders html.
   * If a tree node is clicked on: the vocab, nodeName, and nodeID are passed in from
   * ui. If no nodeID, the nodeName is used to retrieve nodeID
   * from m_treeIDtoNameHash. Duplicate nodenames (same concept in different places in tree) are put into m_treeIDtoNameHash
   * by adding a '1' etc. onto the end of the nodename. When a nodeID is retrieved,
   * we check for duplicate names and then retrieve the node with the id closest to the superconcept id.
   * So we have a nodeID to expand.
   * Using nodeID, the nodeChildrenTree is retrieved from m_treesHash
   * nodeChildrenTree = (Tree)m_treesHash.get(nodeID); There should always be a nodeChildrenTree
   * (not null) because when the node is created its childtree is put 
   * in m_treesHash. If the nodeTreeChildren has child nodes already,
   * they are setVisible. If no child nodes, the nodes are created with getSubConceptNames
   * , setVisible. Each Node is given a nodeID and put in m_treeNodesHash,
   * with ID as the name. The ID of the node is related to its nodename in m_treeIDtoNameHash
   * Each nodeID is put in m_treeHash with its child tree. 
   * At the end, m_treesHash.put(nodeID, nodeChildrenTree); so tree is stored with nodeid.
   * Finally, baseTree is retrieved from baseTree = (Tree)m_treesHash.get(dtsVocab);
   * and it is passed to renderHTML, which loops through tree.size() and retrieves
   * all the child objects (nodes or leafs) and then renders them in order down the baseTree.
   * 
   *  @param nodeName            The name of node.
   *  @param dtsVocab            The Vocabulary of the node.
   *  @param strRenderHTML       'Yes' to render as html, 'No' to not.
   *  @param nodeCode            The concept code of the node
   *  @param sCodeToFindInTree   Used to expand the node to a certain subconcept, then stop
   *  @param nodeLevelToFind     next level to find
   *  @param nodeID               node id
   *  @return rendHTML           The rendered html.
*/
  public String expandNode(String nodeName, String dtsVocab, String strRenderHTML,
          String nodeCode, String sCodeToFindInTree, int nodeLevelToFind, String nodeID) 
  {
//System.out.println("AAAAAAAAAAAAA Very TOP expandNode top, nodeID: " + nodeID + " nodeName: " 
//+ nodeName + " nodeLevelToFind: " + nodeLevelToFind + " dtsVocab: " + dtsVocab + "sCodeToFindInTree: " + sCodeToFindInTree);
    HttpSession session = m_classReq.getSession();
    EVSSearch evs = new EVSSearch(m_classReq, m_classRes, m_servlet);
    String nodeNameJS = "";
    int localNodeLevel = 0;
    String[] nodeNameArray = new String[10000];
    String[] nodeIdArray = new String[10000];
    Vector vNodeBean = new Vector();
    String rendHTML = "";
    Vector vRoot = new Vector();
    Vector vSubNames = new Vector();
    Vector vSubCodes = new Vector();
    Vector vSubConcepts = new Vector();
    Vector vSubConcepts2 = new Vector();
    int nodeLevel = 0;
    int numChildren = 0;
    String subNodeCode = ""; 
    String subNodeName = ""; 
    
    String sSearchAC = (String)session.getAttribute("creSearchAC");
    if(sSearchAC == null) sSearchAC = "";
    Integer id = new Integer(0);
    String foundCodeInTree = "false";
logger.debug("expandNode get lastNodeid");
    if(sSearchAC.equals("ParentConceptVM"))
      id = (Integer)m_treesHashParent.get("lastNodeID");
    else
      id = (Integer)m_treesHash.get("lastNodeID"); // for new nodes will need the last used nodeID
    if(id == null) id = new Integer(0);
 logger.debug("expandNode got lastNodeid: " + id);  
    int newNodeID = id.intValue();
    
    GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, m_servlet);
    if(nodeCode.equals("") && !nodeName.equals(""))
     nodeCode = evs.do_getEVSCode(nodeName, dtsVocab);   
	 
    String sLastNodeIDExpanded = (String)session.getAttribute("LastNodeIDExpanded");
    if (sLastNodeIDExpanded == null) sLastNodeIDExpanded = "0";
    session.setAttribute("LastNodeIDExpanded", null);
    
  try
  {
    if(nodeID == null || nodeID.equals(""))
    {
      if(sSearchAC.equals("ParentConceptVM"))
        nodeID = (String)m_treeIDtoNameHashParent.get(nodeName);
      else
        nodeID = (String)m_treeIDtoNameHash.get(nodeName);
    }
    if(nodeID == null) nodeID = "";
logger.debug("expandNode  nodeID: " + nodeID + " nodeName: " + nodeName);  
    // check to see if its the right nodeID 
    Tree nodeChildrenTree = new Tree(1);
    String sTreeParentID = "";
    int iTreeParentID = 0;
    if(!nodeID.equals(""))
    {
      if(sSearchAC.equals("ParentConceptVM"))
        nodeChildrenTree = (Tree)m_treesHashParent.get(nodeName);
      else
        nodeChildrenTree = (Tree)m_treesHash.get(nodeID);      
    }
    
    // Get the parent's id of the node being expanded
    int iExName = 0;
    int iID = 0;
    if(!nodeID.equals(""))
    {
      TreeNode exNode =  (TreeNode)m_treeNodesHash.get(nodeID);
      if(exNode != null)  
        iExName = exNode.getParentNodeID();
logger.debug("expandNode  nodeID: " + nodeID); 
      // Get the node id of the previous node expanded (which is the parent of the current node
      // if the mode is 'expandTreeToConcept' i.e. nodeLevelToFind > 0)
      Integer iNodeID = new Integer(nodeID);
      Integer iLastNodeIDExpanded = new Integer(sLastNodeIDExpanded);
      iID = iNodeID.intValue();
      int iLast = iLastNodeIDExpanded.intValue();
      String nodeIDOriginal = nodeID;
    // Do this to get the correct nodeTreeChildren, not one currently cached by same name
      if(iExName != iLast && nodeLevelToFind>0)
      {
logger.debug("expandNode6 nodeID: " + nodeID);
      nodeID = getCorrectNodeID(nodeName, iLast);
      if(nodeID.equals("none"))
        nodeID = nodeIDOriginal;
      nodeChildrenTree = (Tree)m_treesHash.get(nodeID);
      }
      iNodeID = new Integer(nodeID);
      iID = iNodeID.intValue();
  }
logger.debug("expandNode33 nodeID: " + nodeID);    
    if(nodeLevelToFind>0) //only set this on expandTreeToConcept
      session.setAttribute("LastNodeIDExpanded", nodeID); 
    if(nodeChildrenTree == null)
      nodeChildrenTree = new Tree(1);  
    
    // Get a node object for the expanded node
    TreeNode expandedNode = new TreeNode(1, "", "", "",1);
    if(m_treeNodesHash != null)
    {
logger.debug("expandNode m_treeNodesHash != null nodeID: " + nodeID);
      if(sSearchAC.equals("ParentConceptVM"))
        expandedNode = (TreeNode)m_treeNodesHashParent.get(nodeName);
      else
        expandedNode = (TreeNode)m_treeNodesHash.get(nodeID);
    } 

    // Set expanded true so node will be displayed in expanded fashion in tree, 
    // push onto expanded node stack
    if(expandedNode != null)
    {
        nodeLevel = expandedNode.getLevel();
        expandedNode.setExpanded(true);
        if(sSearchAC.equals("ParentConceptVM"))
           m_expandedTreeNodesParent.push(nodeName);
        else
          m_expandedTreeNodes.push(nodeID);
    } 
    
    if(nodeChildrenTree != null) //will never be null because of new Tree stmt
        numChildren = nodeChildrenTree.size(); 
logger.debug("expandNode numChildren: " + numChildren);
    if(numChildren > 0) //children already exist, set them visible
    {
        for(int i=0;i<numChildren;i++)
        {
          if(nodeChildrenTree.getChild(i).getType() == 0) //node
          {
            TreeNode tn = (TreeNode)nodeChildrenTree.getChild(i);
            tn.setExpanded(false);
            tn.setVisible(true);

            if(nodeLevelToFind>0)
              tn.setParentNodeID(iID);
            if(!sCodeToFindInTree.equals(""))
            {
              subNodeCode = tn.getCode();
              if(subNodeCode == null || subNodeCode.equals("")
              && foundCodeInTree.equals("false") && tn.getName() != null && !tn.getName().equals(""))
                subNodeCode = evs.do_getEVSCode(tn.getName(), dtsVocab);
              if(subNodeCode != null)
                tn.setCode(subNodeCode);
//System.out.println("expandNode tn.getCode(): " + tn.getCode() + " sCodeToFindInTree: " + sCodeToFindInTree);
              if(tn.getCode().equals(sCodeToFindInTree))  // || tn.getName().equals(nodeName))
              {
                foundCodeInTree = "true";
                tn.setBold(true);
              }
            }
          }
          else if(nodeChildrenTree.getChild(i).getType() == 1) // leaf
          {
            TreeLeaf tl = (TreeLeaf)nodeChildrenTree.getChild(i);
            tl.setVisible(true);
             if(!sCodeToFindInTree.equals(""))
             {
                subNodeCode = tl.getCode();
                // do not do this for > 40 subconcepts, because slows down performance too much
                if(subNodeCode == null || subNodeCode.equals("")
                && foundCodeInTree.equals("false") && tl.getName() != null && !tl.getName().equals(""))
                  subNodeCode = evs.do_getEVSCode(tl.getName(), dtsVocab);
                if(subNodeCode != null)
                  tl.setCode(subNodeCode);
                if(tl.getCode().equals(sCodeToFindInTree) || tl.getName().equals(nodeName))
                {
                  foundCodeInTree = "true";
                  tl.setBold(true);
                }
             }
          }
        }
      }
      else // numChildren == 0; nodes not stored so create
      {
        vSubNames = evs.getSubConceptNames(dtsVocab, nodeName, "", nodeCode, "");
        if(vSubNames != null && vSubNames.size()>0 && vSubNames.size()<20)
        {
          for(int j=0; j < vSubNames.size(); j++) 
          { 
            subNodeName = (String)vSubNames.elementAt(j);
//System.out.println(dtsVocab + " expandNode subNodeName: " + subNodeName);
            subNodeCode = evs.do_getEVSCode(subNodeName, dtsVocab); 
            vSubConcepts2 = evs.getSubConceptNames(dtsVocab, subNodeName, "", subNodeCode, "");
//System.out.println(subNodeCode + " expandNode subNodeName: " + subNodeName);
            //TreeNode tn = new TreeNode(1, "", "", "",1);
            String subDispName = evs.getDisplayName(dtsVocab, null, subNodeName);
            if(vSubConcepts2.size()>0) 
            {
              TreeNode tn = new TreeNode(newNodeID++, subNodeName, subDispName, subNodeCode, nodeLevel+1);
              tn.getChildren().setLevel(nodeLevel+2);
              tn.setExpanded(false);
              tn.setVisible(true);
              if(nodeLevelToFind>0)
                tn.setParentNodeID(iID);
              tn.getChildren().setParentNodeID(tn.getId());  
              Integer iNodeID2 = new Integer(tn.getId());
              String sNodeID = iNodeID2.toString();
              if(!sCodeToFindInTree.equals(""))
                if(tn.getCode().equals(sCodeToFindInTree))// || tn.getName().equals(nodeName))
                  tn.setBold(true);
              nodeChildrenTree.addChild(tn);
              if(sSearchAC.equals("ParentConceptVM"))
              {
//  System.out.println("expandNode m_treeNodesHashParent.put(tn.getName(): " + tn.getName());
                m_treeNodesHashParent.put(tn.getName(), tn);
                m_treeIDtoNameHashParent.put(tn.getName(), sNodeID); 
                m_treesHashParent.put(tn.getName(), tn.getChildren()); 
              }
              else
              {
//  System.out.println("expandNode m_treeNodesHash.put nodeID: " + nodeID);
                m_treeNodesHash.put(sNodeID, tn);
                fillTreeIDtoNameHash(tn.getName(), sNodeID); //m_treeIDtoNameHash.put(tn.getName(), sNodeID);          
                m_treesHash.put(sNodeID, tn.getChildren()); //add the node's children tree to hash table      
              }
            }
            else
            {
              //TreeLeaf tl = new TreeLeaf(1, "", "", "", 1);
              TreeLeaf tl = new TreeLeaf(lastNodeID++, subNodeName, subDispName, subNodeCode, nodeLevel+1);
              tl.setLevel(nodeLevel+1);
              nodeChildrenTree.addChild(tl);
              tl.setVisible(true);
              if(!sCodeToFindInTree.equals(""))
              {
                if(tl.getCode().equals(sCodeToFindInTree) || tl.getName().equals(nodeName))
                  tl.setBold(true);
              }
              if(sSearchAC.equals("ParentConceptVM"))
                m_treeLeafsHashParent.put(tl.getName(), tl);
            }
          } 
        }
        else if(vSubNames != null && vSubNames.size()>19 && nodeName.equals("OrphanConcepts")) //MGED OrphanConcepts should all be leafs
        {
          for(int n=0; n < vSubNames.size(); n++) 
          { 
            subNodeName = (String)vSubNames.elementAt(n);
            subNodeCode = evs.do_getEVSCode(subNodeName, dtsVocab);  
            //TreeLeaf tl = new TreeLeaf(1, "", "", 1);
            String subDispName = evs.getDisplayName(dtsVocab, null, subNodeName);
            TreeLeaf tl = new TreeLeaf(lastNodeID++, subNodeName, subDispName, subNodeCode, nodeLevel+1);
            tl.setLevel(nodeLevel+1);
            nodeChildrenTree.addChild(tl);
            tl.setVisible(true);
            if(!sCodeToFindInTree.equals(""))
            {
              if(tl.getCode().equals(sCodeToFindInTree) || tl.getName().equals(nodeName))
                tl.setBold(true);
            }
            if(sSearchAC.equals("ParentConceptVM"))
                m_treeLeafsHashParent.put(tl.getName(), tl);
          }
        }
        else if(vSubNames != null && vSubNames.size()>19)
        {
          for(int j=0; j < vSubNames.size(); j++) 
          { 
            subNodeName = (String)vSubNames.elementAt(j);
            subNodeCode = "";  //serAC.do_getEVSCode(subNodeName, dtsVocab);   
            //TreeNode tn = new TreeNode(1, "", "",1);
            String subDispName = evs.getDisplayName(dtsVocab, null, subNodeName);
            TreeNode tn = new TreeNode(newNodeID++, subNodeName, subDispName, subNodeCode, nodeLevel+1);
            tn.getChildren().setLevel(nodeLevel+2);
            tn.setExpanded(false);
            tn.setVisible(true);
            if(nodeLevelToFind>0)
              tn.setParentNodeID(iID);
            tn.getChildren().setParentNodeID(tn.getId());  
            if(!sCodeToFindInTree.equals(""))
            {
              subNodeCode = tn.getCode();
              if(subNodeCode == null || subNodeCode.equals("")
              && foundCodeInTree.equals("false"))
                subNodeCode = evs.do_getEVSCode(tn.getName(), dtsVocab);
              if(subNodeCode != null)
                tn.setCode(subNodeCode);
              if(tn.getCode().equals(sCodeToFindInTree)) //|| tn.getName().equals(nodeName))
              {
                foundCodeInTree = "true";
                tn.setBold(true);
              }
            }
            Integer iNodeID3 = new Integer(tn.getId());
            String sNodeID = iNodeID3.toString();
            nodeChildrenTree.addChild(tn);
            if(sSearchAC.equals("ParentConceptVM"))
            {
              m_treeNodesHashParent.put(tn.getName(), tn);
              m_treeIDtoNameHashParent.put(tn.getName(), sNodeID);
              m_treesHashParent.put(tn.getName(), tn.getChildren()); 
            }
            else
            {
              m_treeNodesHash.put(sNodeID, tn);
              m_treeIDtoNameHash.put(tn.getName(), sNodeID);         
              m_treesHash.put(sNodeID, tn.getChildren()); //add the node's children tree to hash table      
            }
          }
        } 
        else  // no subConcepts, vSubNames.size()==0
        {
          String dispName = evs.getDisplayName(dtsVocab, null, nodeName);
          TreeLeaf tl = new TreeLeaf(lastNodeID++, nodeName, dispName, nodeCode, nodeLevel+1);
          nodeChildrenTree.addChild(tl);
          tl.setVisible(true);
           if(!sCodeToFindInTree.equals(""))
           {
              subNodeCode = tl.getCode();
              if(subNodeCode == null || subNodeCode.equals("")
              && foundCodeInTree.equals("false"))
                subNodeCode = evs.do_getEVSCode(tl.getName(), dtsVocab);
              if(subNodeCode != null)
                tl.setCode(subNodeCode);
              if(tl.getCode().equals(sCodeToFindInTree) || tl.getName().equals(nodeName))
              {
                foundCodeInTree = "true";
                tl.setBold(true);
              }
           }
           if(sSearchAC.equals("ParentConceptVM"))
                m_treeLeafsHashParent.put(tl.getName(), tl);
        }
    }
    if(nodeChildrenTree != null)
    {
      Tree baseTree = (Tree)m_treesHash.get(dtsVocab);   
 logger.debug(baseTree.getName() + " expandNode got baseTree dtsVocab: " + dtsVocab);
// System.out.println("expandNode got baseTree.name: " + baseTree.getName());
      if(sSearchAC.equals("ParentConceptVM"))
      {
        m_treesHashParent.put(nodeName, nodeChildrenTree);	// Store the tree in the static Hashtable
        Integer nodeid = new Integer(newNodeID);
        m_treesHashParent.put("lastNodeID", nodeid);   
      }
      else
      {
        m_treesHash.put(nodeID, nodeChildrenTree);	// Store the tree in the static Hashtable
        Integer nodeid = new Integer(newNodeID);
        m_treesHash.put("lastNodeID", nodeid);        
        if(baseTree == null)
        {
logger.debug("expandNode got baseTree == null " + m_dtsVocab);
        //  m_dtsVocab = filterName(m_dtsVocab, "display");  
          baseTree = new Tree(m_dtsVocab);
          if(baseTree == null)
          {
            //m_dtsVocab = filterName(m_dtsVocab, "js");  
            baseTree = new Tree(m_dtsVocab);
          }
        }
      }
      // Expand a node in Parent Concept Tree 
      if(sSearchAC.equals("ParentConceptVM"))
      {
        nodeName= (String)session.getAttribute("ParentConcept");
        if(nodeName != null && !nodeName.equals(""))
        {
          baseTree = (Tree)m_treesHashParent.get("parentTree" + nodeName);  
          if(baseTree == null)
          {
            baseTree = new Tree("parentTree" + nodeName);
          }
          m_treesHashParent.put("parentTree" + nodeName, baseTree);
        }
    }
    if(!strRenderHTML.equals("No")  && !strRenderHTML.equals("Last"))
    { 
        rendHTML = renderHTML(baseTree); 
    }
    }
  } 
  catch(Exception e) 
  {
    System.out.println("ERROR expandNode: " + e.toString());
    logger.debug("ERROR expandNode: " + e.toString());
  }
  return rendHTML;	
}

/**
	 * When user clicks on the node's - sign, this method iterates the node's children
   * tree, sets them not visible, then renders as html.
   *  @param nodeID 
   *  @param nodeName       The name of node.
   *  @param dtsVocab       The name of vocabulary.
   *  @param shouldRender   'Yes' should, 'No' not.
   *  @return rendHTML      Html string
*/
public String collapseNode(String nodeID, String dtsVocab, String shouldRender, String nodeName) 
{
//System.out.println("collapseNode top nodeID: " + nodeID + " nodeName: " + nodeName + " dtsVocab: " + dtsVocab);
	  HttpSession session = m_classReq.getSession();
    String rendHTML = "";
    String sSearchAC = (String)session.getAttribute("creSearchAC");
    if(sSearchAC == null) sSearchAC = "";
     if(nodeID == null || nodeID.equals(""))
    {
       if(sSearchAC.equals("ParentConceptVM"))
        nodeID = (String)m_treeIDtoNameHashParent.get(nodeName);
      else
        nodeID = (String)m_treeIDtoNameHash.get(nodeName);
    }
    boolean isExpanded;

    session = m_classReq.getSession();
    TreeNode expandedNode = new TreeNode(1, "", "", "",1);
    if(sSearchAC.equals("ParentConceptVM"))
      expandedNode = (TreeNode)m_treeNodesHashParent.get(nodeName);
    else
      expandedNode = (TreeNode)m_treeNodesHash.get(nodeID);

    if(expandedNode != null)
      expandedNode.setExpanded(false);
    Tree nodeChildrenTree = new Tree(1);
    try 
    { 
      if(sSearchAC.equals("ParentConceptVM"))
        nodeChildrenTree = (Tree)m_treesHashParent.get(nodeName);
      else
        nodeChildrenTree = (Tree)m_treesHash.get(nodeID);
   
      int numChildren = 0;
      if(nodeChildrenTree != null)
        numChildren = nodeChildrenTree.size();
      if(numChildren > 0) //children already exist, set them visible
      {
        for(int i=0;i<numChildren;i++)
        {
          if(nodeChildrenTree.getChild(i).getType() == 0) //node
          {
            TreeNode tn = (TreeNode)nodeChildrenTree.getChild(i);
            tn.setExpanded(false);
            tn.setVisible(false);
            Integer id = new Integer(tn.getId());
            String sID = id.toString();
            collapseNode(sID, dtsVocab, "false", tn.getName());
          }
          else
          {
            TreeLeaf tl = (TreeLeaf)nodeChildrenTree.getChild(i);
            tl.setVisible(false);
          }
        }
      }
      if(sSearchAC.equals("ParentConceptVM"))
         m_treesHashParent.put(nodeName, nodeChildrenTree);
      else
        m_treesHash.put(nodeID, nodeChildrenTree);	// Store the tree in the static Hashtable
      Tree baseTree = (Tree)m_treesHash.get(dtsVocab);
      if(sSearchAC.equals("ParentConceptVM"))
      {
        nodeName= (String)session.getAttribute("ParentConcept");
        if(nodeName != null && !nodeName.equals(""))
        {
          baseTree = (Tree)m_treesHashParent.get("parentTree" + nodeName);
          if(baseTree == null)
          {
            //nodeName = filterName(nodeName, "js");
            baseTree = (Tree)m_treesHashParent.get("parentTree" + nodeName);
            if(baseTree == null)
            {
              baseTree = new Tree("parentTree" + nodeName);
            }
          }   
        }
      }
      if(!shouldRender.equals("false") && baseTree != null)
      {
        rendHTML = renderHTML(baseTree);          
      }
		} 
    catch(Exception e) 
    {
			System.out.println(e.toString());
      logger.debug(e.toString());
		}
  return rendHTML;	
}

/**
	 * This method retrieves all open nodes from a stack, then sets them not visible
*/
public void collapseAllNodes() 
{
//System.out.println("collapseAllNodes!!!");
  HttpSession session = m_classReq.getSession();
  String sSearchAC = (String)session.getAttribute("creSearchAC");
  Stack m_expandedTreeNodes = (Stack)session.getAttribute("expandedTreeNodes");
  Stack m_expandedTreeNodesParent = (Stack)session.getAttribute("expandedTreeNodesParent");
  Hashtable m_treeNodesHash = (Hashtable)session.getAttribute("treeNodesHash");
  Hashtable m_treeNodesHashParent = (Hashtable)session.getAttribute("treeNodesHashParent");
  Hashtable m_treesHash = (Hashtable)session.getAttribute("treesHash");
  Hashtable m_treesHashParent = (Hashtable)session.getAttribute("treesHashParent");
  if(m_expandedTreeNodes == null) m_expandedTreeNodes = new Stack();
  if(m_expandedTreeNodesParent == null) m_expandedTreeNodesParent = new Stack();
  if(m_treeNodesHash == null) m_treeNodesHash = new Hashtable();
  if(m_treeNodesHashParent == null) m_treeNodesHashParent = new Hashtable();
  if(m_treesHash == null) m_treesHash = new Hashtable();
  if(m_treesHashParent == null) m_treesHashParent = new Hashtable();

  if(sSearchAC == null) sSearchAC = "";
  String nodeName = "";
  TreeNode expandedNode = new TreeNode(1, "", "", "",1);
  try 
  { 
    if(!sSearchAC.equals("ParentConceptVM"))
    {
      while(m_expandedTreeNodes.size()>0)
      {    
        nodeName = (String)m_expandedTreeNodes.pop();
        if(m_treeNodesHash != null)
            expandedNode = (TreeNode)m_treeNodesHash.get(nodeName);
        // if null, look for the nodeName with "_"
        if(expandedNode == null)
        {
          //nodeName = filterName(nodeName, "js");
          expandedNode = (TreeNode)m_treeNodesHash.get(nodeName);
        }
        if(expandedNode != null)
          expandedNode.setExpanded(false);       
        Tree nodeChildrenTree = new Tree(1);
        nodeChildrenTree = (Tree)m_treesHash.get(nodeName);
        int numChildren = nodeChildrenTree.size();
        if(numChildren > 0) //children already exist, set them visible
        {
          for(int i=0;i<numChildren;i++)
          {
            if(nodeChildrenTree.getChild(i).getType() == 0) //node
            {
              TreeNode tn = (TreeNode)nodeChildrenTree.getChild(i);
              tn.setExpanded(false);
              tn.setVisible(false);
              tn.setBold(false);
            }
            else
            {
              TreeLeaf tl = (TreeLeaf)nodeChildrenTree.getChild(i);
              tl.setVisible(false);
              tl.setBold(false);
            }
          }
        }
        m_treesHash.put(nodeName, nodeChildrenTree);	// Store the tree in the static Hashtable
        if(session != null)
        {
            session.setAttribute("expandedTreeNodes", m_expandedTreeNodes);
        }
      }
    }
    else
    {
      while(m_expandedTreeNodesParent.size()>0)
      {
         if(sSearchAC.equals("ParentConceptVM"))
         {
          nodeName = (String)m_expandedTreeNodesParent.pop();
          if(m_treeNodesHashParent != null)
            expandedNode = (TreeNode)m_treeNodesHashParent.get(nodeName);
         }
        // if null, look for the nodeName with "_"
        if(expandedNode == null)
        {
          //nodeName = filterName(nodeName, "js");
          if(sSearchAC.equals("ParentConceptVM"))
            expandedNode = (TreeNode)m_treeNodesHashParent.get(nodeName);
        }
        if(expandedNode != null)
          expandedNode.setExpanded(false);       
        Tree nodeChildrenTree = new Tree(1);
        if(sSearchAC.equals("ParentConceptVM"))
          nodeChildrenTree = (Tree)m_treesHashParent.get(nodeName);
      
        int numChildren = nodeChildrenTree.size();
        if(numChildren > 0) //children already exist, set them visible
        {
          for(int i=0;i<numChildren;i++)
          {
            if(nodeChildrenTree.getChild(i).getType() == 0) //node
            {
              TreeNode tn = (TreeNode)nodeChildrenTree.getChild(i);
              tn.setExpanded(false);
              tn.setVisible(false);
              tn.setBold(false);
            }
            else
            {
              TreeLeaf tl = (TreeLeaf)nodeChildrenTree.getChild(i);
              tl.setVisible(false);
              tl.setBold(false);
            }
          }
        }
        if(sSearchAC.equals("ParentConceptVM"))
           m_treesHashParent.put(nodeName, nodeChildrenTree);
      
       if(session != null)
        {
          if(sSearchAC.equals("ParentConceptVM"))
            session.setAttribute("expandedTreeNodesParent", m_expandedTreeNodesParent);
        }
      }
    }
  } 
  catch(Exception e) 
  {
    System.out.println(e.toString());
    logger.debug(e.toString());
  } 
 }
  
/**
	 * This method takes the CCode and vocab, and calls method getSuperConcepts until
   * there are no more superconcepts(i.e. is a Root). Each concept returned is put on a stack.
   * When a root is reached, concepts are popped off the stack one by one, and expandNode is 
   * called until the beginning concept is visible.
   *  @param stackSuperConcepts 
   *  @param sCCode       The concept code.
   *  @param sCCodeDB     The vocab.
   *  @param vStackVector 
   *  @return rendHTML    The rendered html string.
*/
  public Vector buildVectorOfSuperConceptStacks(Stack stackSuperConcepts, String sCCodeDB,
  String sCCode, Vector vStackVector) 
  {
    String sSuperConceptName = "";
    String sSuperConceptNameImmediate = "";
    String dtsVocab = sCCodeDB;
    String sCCodeName = "";
    
    Vector vSuperConceptNames = new Vector();
    Vector vSuperConceptVectors = new Vector();
    Vector vSuperConceptVector = new Vector();
    Vector vSuperConceptNamesImmediate = new Vector();
    Vector vSuperImmediate = new Vector();
    if(m_classReq != null && m_classReq.getSession() != null)
    {
      HttpSession session = m_classReq.getSession();
      vSuperImmediate = (Vector)session.getAttribute("vSuperImmediate");
    }
    if(vSuperImmediate == null) 
      vSuperImmediate = new Vector();
   
 /*   if(sCCodeDB.equals("Thesaurus/Metathesaurus") || sCCodeDB.equals("")
     || sCCodeDB.equals("NCI Thesaurus") || sCCodeDB.equals("NCI_Thesaurus"))
      sCCodeDB = m_servlet.m_VOCAB_NCI; */
     String sName = "";
     EVSSearch evs = new EVSSearch(m_classReq, m_classRes, m_servlet); 
     sCCodeName= evs.do_getConceptName(sCCode, sCCodeDB);
   
        do
        {
          vSuperConceptNamesImmediate = evs.getSuperConceptNamesImmediate(sCCodeDB, sCCodeName, sCCode, "");   
          if(vSuperConceptNamesImmediate.size()==1)
          {
            sCCodeName = (String)vSuperConceptNamesImmediate.elementAt(0);
            if(!sCCodeName.equals("") && sCCodeName != null)
            {
              sCCode = evs.do_getEVSCode(sCCodeName, dtsVocab); 
              stackSuperConcepts.push(sCCodeName);
             // if(sCCodeName.equals("Gene_Ontology"))
             //  break;
            }
           }
          else if(vSuperConceptNamesImmediate.size()>1)
          {
            break;
          }
        }while(vSuperConceptNamesImmediate.size()>0);
        
        if(stackSuperConcepts != null && stackSuperConcepts.size()>0 && vSuperConceptNamesImmediate.size()<2)
        {
          String firstConcept = (String)stackSuperConcepts.elementAt(0);
          String sSuperImmediate = "";
          for (int k = 0; k < vSuperImmediate.size(); k++)
          {
            sSuperImmediate = (String)vSuperImmediate.elementAt(k);       
            if(firstConcept.equals(sSuperImmediate))
            {       
              vStackVector.addElement(stackSuperConcepts);
              stackSuperConcepts = new Stack();
            }
          } 
        } 
        
        //breaks out and comes to here
        if(vSuperConceptNamesImmediate.size()>1)
        {
          for (int i = 0; i < vSuperConceptNamesImmediate.size(); i++)
          {
            Stack stackSuperConcepts2 = new Stack();
            for (int m = 0; m < stackSuperConcepts.size(); m++)
            {
                stackSuperConcepts2.addElement(stackSuperConcepts.elementAt(m));
            }
            sCCodeName = (String)vSuperConceptNamesImmediate.elementAt(i);
            Vector vStackVector2 = new Vector();
            if(!sCCodeName.equals("") && sCCodeName != null)
            {
              sCCode = evs.do_getEVSCode(sCCodeName, dtsVocab);
              stackSuperConcepts2.push(sCCodeName);
            /*  if(sCCodeName.equals("Gene_Ontology"))
                break;
              else */
                vStackVector2 = this.buildVectorOfSuperConceptStacks(stackSuperConcepts2, sCCodeDB, sCCode, vStackVector);
            }
          }
        }
//if(vStackVector != null)
//System.out.println("build vector vStackVector.size: " + vStackVector.size());
    return vStackVector;
}   
    
    
/**
	 * This method looks for a Parent tree (a tree where the Parent concept is the single
   * root node); if the parent tree has not been created, it creates one, then renders as html.
   *  @param sCCode       The concept code.
   *  @param sCCodeDB     The vocab.
   *  @param sCCodeName   The name of code.
   *  @return rendHTML    The rendered html string.
*/
  public String showParentConceptTree(String sCCode, String sCCodeDB, String sCCodeName) 
  {
// System.out.println("showParentConceptTree");
  /*  if(sCCodeDB.equals("NCI Thesaurus") || sCCodeDB.equals("Thesaurus/Metathesaurus") ||
    sCCodeDB.equals("NCI_Thesaurus") || sCCodeDB.equals(""))
    {
      sCCodeName = filterName(sCCodeName, "js");
    //  sCCodeDB = m_servlet.m_VOCAB_NCI; 
    } */
    Tree parentTree = new Tree("parentTree" + sCCodeName);
    parentTree.setName("parentTree" + sCCodeName);
    EVSSearch evs = new EVSSearch(m_classReq, m_classRes, m_servlet); 
    Vector vRoot = new Vector();
    Vector vSubConceptNames = new Vector();
    Vector vSubConcepts2 = new Vector();
    boolean moreChildren = true;
    String rendHTML = "";
		try 
    {     
      parentTree = (Tree)m_treesHashParent.get("parentTree" + sCCodeName);
      if(parentTree != null)
      {  
        rendHTML = renderHTML(parentTree);        
      }
      else
      {  
          parentTree = new Tree("parentTree" + sCCodeName);
          vSubConceptNames = evs.getSubConceptNames(sCCodeDB, sCCodeName, "", sCCode, ""); 
          String dispName = evs.getDisplayName(sCCodeDB, null, sCCodeName);
          if(vSubConceptNames.size()>0)
          {            
            TreeNode tn = new TreeNode(lastNodeID++, sCCodeName, dispName, sCCode, level);
            tn.setExpanded(false);
            tn.setVisible(true);
            tn.getChildren().setLevel(level);
            parentTree.addChild(tn);
            m_treeNodesHashParent.put(sCCodeName, tn);
            m_treesHashParent.put(sCCodeName, tn.getChildren()); //add the node's children tree to hash table
          }
          else
          { 
            TreeLeaf tl = new TreeLeaf(lastNodeID++, sCCodeName, dispName, sCCode, level);
            parentTree.addChild(tl);
            tl.setVisible(true);
          }
     
        m_treesHashParent.put("parentTree" + sCCodeName, parentTree);	// Store the tree in the static Hashtable
        Integer nodeid = new Integer(lastNodeID);
        m_treesHashParent.put("lastNodeID", nodeid);
        rendHTML = renderHTML(parentTree);
 // System.out.println("showParentConceptTree1");
        HttpSession session = m_classReq.getSession();
        if(session != null)
        {
          session.setAttribute("treesHashParent", m_treesHashParent);
          session.setAttribute("treeNodesHashParent", m_treeNodesHashParent);
        }
      }
		} 
    catch(Exception e) 
    {
			System.out.println(e.toString());
      logger.debug(e.toString());
		}
  return rendHTML;	
  }
   
  /**
	 *  This method takes a stack of conceptNames, with Root concept on top, and one
   *  by one expands the tree, using each conceptName from stack as a node.
   *  @param stackSuperConcepts     A stack of superconcept names.
   *  @param sCCodeDB               The dtsVocab.
   *  @param sCodeToFindInTree      The code of the concept to find in tree.
   *  @return rendHTML              The string of html
*/
  public String expandTreeToConcept(Stack stackSuperConcepts, String sCCodeDB, String sCodeToFindInTree) 
  {
    String rendHTML = "";
    String sMatch = "false";
    String sSuperConceptName = "";
    int nodeLevel = 1;
    HttpSession session = m_classReq.getSession();
    session.setAttribute("LastNodeIDExpanded", null);
    String sSearchAC = (String)session.getAttribute("creSearchAC");
    if(sSearchAC == null) sSearchAC = "";
    String sTopOfStack = "";
    Tree baseTree = new Tree(1);
    String nodeCode = "";
    EVSSearch evs = new EVSSearch(m_classReq, m_classRes, m_servlet);
    while(stackSuperConcepts.size()>0)
    {
      sSuperConceptName = (String)stackSuperConcepts.pop();
      if(nodeLevel == 1)
        sTopOfStack = sSuperConceptName;
 //System.out.println("expandTreeToConcept sSuperConceptName: " + sSuperConceptName); 
      if(sSuperConceptName != null && !sSuperConceptName.equals(""))
      {
        nodeCode = evs.do_getEVSCode(sSuperConceptName, sCCodeDB); 
        if(stackSuperConcepts.size()>0)
        {
        rendHTML = this.expandNode(sSuperConceptName, sCCodeDB, "No", nodeCode, sCodeToFindInTree, nodeLevel, "");  
        }
        else
        {
          rendHTML = this.expandNode(sSuperConceptName, sCCodeDB, "Last", nodeCode, sCodeToFindInTree, nodeLevel, "");
          if(sSearchAC.equals("ParentConceptVM"))
            baseTree = (Tree)m_treesHashParent.get(sCCodeDB);  
          else
            baseTree = (Tree)m_treesHash.get(sCCodeDB);   
          if(baseTree != null)
          {
            rendHTML = renderHTML(baseTree);
          }
          else
          {
            baseTree = (Tree)m_treesHash.get(sCCodeDB);
            if(baseTree != null)
              rendHTML = renderHTML(baseTree);
          }
        }
      }
      nodeLevel++;
    }
    return rendHTML;
  }
  

/**
   * Removes the Vocab's tree from Hashtable, then recreates tree and stores it
   * @param dtsVocab   The Vocabulary name
   * @param sRender 
   * @return rendHTML  The string of html
   */
	public String refreshTree(String dtsVocab, String sRender) 
  {		
//System.out.println("refreshTree: dtsVocab: " + dtsVocab + " sRender: " + sRender);
		Tree dtsTree = new Tree("dtsTree");
    GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, m_servlet);  
    String rendHTML = "";
    
    HttpSession session = m_classReq.getSession();
    m_treesHash = new Hashtable();
    m_treeNodesHash = new Hashtable();
    m_treeIDtoNameHash = new Hashtable();
    m_expandedTreeNodes = new Stack();
    m_treesHashParent = new Hashtable();
    m_treeNodesHashParent = new Hashtable();
    m_treeLeafsHashParent = new Hashtable();
    m_treeIDtoNameHashParent = new Hashtable();
    m_expandedTreeNodesParent = new Stack();
    if(session != null)
    {
//System.out.println("refreshTree: session != null");
        session.setAttribute("treesHash", m_treesHash);
        session.setAttribute("treeNodesHash", m_treeNodesHash);
        session.setAttribute("treeIDtoNameHash", m_treeIDtoNameHash);
        session.setAttribute("expandedTreeNodes", m_expandedTreeNodes);
        session.setAttribute("expandedTreeNodesParent", m_expandedTreeNodesParent);
        session.setAttribute("treesHashParent", m_treesHashParent);
        session.setAttribute("treeNodesHashParent", m_treeNodesHashParent);
        session.setAttribute("treeLeafsHashParent", m_treeLeafsHashParent);
        session.setAttribute("treeIDtoNameHashParent", m_treeIDtoNameHashParent);
    }
    
		try 
    {     
    //  Tree vocabTree = (Tree)m_treesHash.remove(dtsVocab);
      if(!sRender.equals("false"))
        rendHTML = this.populateTreeRoots(dtsVocab);
    }
    catch(Exception e) 
    {
			System.out.println(e.toString());
      logger.debug(e.toString());
		}
    return rendHTML;
  } 
  
  /**
   * Relates nodename to nodeID in m_treeIDtoNameHash Hash table. Check first if nodeName
   * is already there, if so add '1' onto
   * @param nodeName   The node name
   * @param sNodeID   The node ID
   */
public void fillTreeIDtoNameHash(String nodeName, String sNodeID) 
{		
  try 
  { 
    String nodeName1 = nodeName;
    String sRetNodeID = "";
    sRetNodeID = (String)m_treeIDtoNameHash.get(nodeName);
    if(sRetNodeID == null || sRetNodeID.equals(""))
      m_treeIDtoNameHash.put(nodeName, sNodeID); 
    else
    {
      String found = "false";
      int x = 1;
      do
      {
        Integer i = new Integer(x);
        String sI = i.toString();
        nodeName = nodeName1 + sI;
        sRetNodeID = (String)m_treeIDtoNameHash.get(nodeName); 
        if(sRetNodeID == null || sRetNodeID.equals(""))
        {
          m_treeIDtoNameHash.put(nodeName, sNodeID);
          found = "true";
        }
        x++;
        if (x > 50) break;
      }while(found.equals("false"));
    }
  }
  catch(Exception e) 
  {
		System.out.println("Error in fillTreeIDtoNameHash: " + e.toString());
    logger.debug("Error in fillTreeIDtoNameHash: " + e.toString());
	}
} 

 /**
   * For nodes with the same concept name, gets the correct one by comparing the node's parentId 
   * with the id of the last node expanded (used in 'expandTreeToConcept')
   * @param nodeName   The node name
   * @param iLast last level
   * @return string 
   */
public String getCorrectNodeID(String nodeName, int iLast) 
{	
//System.out.println("XXXXXXXXXXXXXXXXXXXXXXin getCorrectNodeIDXXXXXXXXXXXXXXXXXX");
  String sRetNodeID = "";
  String sRetNodeIDTemp = "none";
  String found = "false";
  String  nodeName2 = "";
  String nodeName1 = nodeName;
  if(nodeName == null)
    return "";
  try 
  { 
    int x = 1;
    int iPar = 0;
    do
    {
      Integer i = new Integer(x);
      String sI = i.toString();
      nodeName2 = nodeName1 + sI;
      sRetNodeID = (String)m_treeIDtoNameHash.get(nodeName2);
      if(sRetNodeID == null)
      {
        if(x ==1)
          sRetNodeID = (String)m_treeIDtoNameHash.get(nodeName1);
        else
          sRetNodeID = sRetNodeIDTemp;
        break;
      }
      else
      { 
        TreeNode exNode =  (TreeNode)m_treeNodesHash.get(sRetNodeID);
        if(exNode != null)  
          iPar = exNode.getParentNodeID();      
        if(iLast == iPar)
        {     
         found = "true";
        }
        else
        {
          sRetNodeIDTemp = sRetNodeID;
        }
      }
      x++;
      if (x > 50) break;
    }while(found.equals("false"));
   
  }
  catch(Exception e) 
  {
		System.out.println("Error in getCorrectNodeID: " + e.toString());
    logger.debug("Error in getCorrectNodeID: " + e.toString());
	}   
  return sRetNodeID;
} 

}

