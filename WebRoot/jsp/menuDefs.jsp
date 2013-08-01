<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

        <%@taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
         
        <!-- Menu Definitions -->
        <div id="menuDefs" class="xyz">
            <div id="linksMenu" class="menu">
              <curate:linksMenu/>  
            </div>
            <div id="createMenu" class="menu">
               <curate:createMenu/>   
            </div>
            <div id="objMenu" class="menu" menuType="float">
               <curate:objMenu/>
            </div>
        </div>
         
         
        