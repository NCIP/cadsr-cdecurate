        <%@taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
         
        <!-- Menu Definitions -->
        <div id="menuDefs" class="xyz">
            <div id="linksMenu" class="menu">
              <curate:linksMenu/>  
            </div>
            <div id="createMenu" class="menu">
               <curate:createMenu/>   
            </div>
            <div id="editMenu" class="menu">
               <curate:editMenu/>  
            </div>
            <div id="searchMenu" class="menu">
               <curate:searchMenu/> 
            </div>
            <div id="objMenu" class="menu" menuType="float">
               <curate:objMenu/>
            </div>
        </div>
         
         
        