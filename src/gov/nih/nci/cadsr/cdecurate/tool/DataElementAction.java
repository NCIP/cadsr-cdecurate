/**
 * 
 */

package gov.nih.nci.cadsr.cdecurate.tool;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;
import org.apache.log4j.Logger;

/**
 * @author shegde
 * 
 */
public class DataElementAction extends CommonACAction
{
    private String browserURL;

    Logger         logger = Logger.getLogger(DataElementAction.class.getName());

    /**
     * 
     */
    public DataElementAction()
    {
        super();
    }

    /**
     * @param bUrl
     */
    public DataElementAction(String bUrl)
    {
        super();
        browserURL = bUrl;
    }

    /*
     * (non-Javadoc)
     * 
     * @see gov.nih.nci.cadsr.cdecurate.tool.CommonACAction#getSelect(java.lang.String, boolean, java.lang.String)
     */
    public String getSelect(String vmID, boolean isStatusFilter, String sOrder)
    {
        String sSelect = "SELECT de.de_idseq idseq" + ", de.long_name" + ", de.asl_name workflow" + ", c.name context"
                        + ", de.version " + ", de.cde_id ac_id " + ", de.preferred_definition definition";
        String sFrom = " FROM sbr.data_elements_view de, sbr.contexts_view c, sbr.value_domains_view vd"
                        + ", sbr.vd_pvs_view vp, sbr.permissible_values_view pv ";
        /*String sWhere = " WHERE de.conte_idseq = c.conte_idseq AND de.vd_idseq = vd.vd_idseq "
                        + " AND vd.vd_idseq = vp.vd_idseq AND vp.pv_idseq = pv.pv_idseq " + " AND pv.short_meaning = '"
                        + vmID + "'";*/
        String sWhere = " WHERE de.conte_idseq = c.conte_idseq AND de.vd_idseq = vd.vd_idseq "
            + " AND vd.vd_idseq = vp.vd_idseq AND vp.pv_idseq = pv.pv_idseq " + " AND pv.vm_idseq = '"
            + vmID + "'";
        if (isStatusFilter)
            sWhere += " AND de.asl_name IN (" + formatArray(getStatusList()) + ")";
        if (sOrder.equals(""))
            sOrder = "long_name";
        String sSQL = sSelect + sFrom + sWhere + " ORDER BY upper(" + sOrder + ")";
        return sSQL;
    }

    /*
     * (non-Javadoc)
     * 
     * @see gov.nih.nci.cadsr.cdecurate.tool.CommonACAction#setExtras(gov.nih.nci.cadsr.cdecurate.tool.CommonACBean,
     *      java.sql.ResultSet)
     */
    public void setExtras(CommonACBean ac, ResultSet rs) throws SQLException
    {
        ac.setDefinition(rs.getString("definition"));
        ac.setBrowserURL(browserURL);
    }

    /*
     * (non-Javadoc)
     * 
     * @see gov.nih.nci.cadsr.cdecurate.tool.CommonACAction#setUsedAttributes(gov.nih.nci.cadsr.cdecurate.tool.VM_Bean,
     *      java.util.Vector, boolean)
     */
    public void setUsedAttributes(VM_Bean vm, Vector<CommonACBean> vAC, boolean statFilter, String sortField)
    {
        vm.setVM_DE_LIST(vAC);
        if (statFilter)
            vm.setVM_SHOW_RELEASED_DE(statFilter);
        if (sortField != null)
            vm.setVM_SORT_COLUMN_DE(sortField);
    }

    /*
     * (non-Javadoc)
     * 
     * @see gov.nih.nci.cadsr.cdecurate.tool.CommonACAction#sortACs(gov.nih.nci.cadsr.cdecurate.tool.VM_Bean,
     *      java.lang.String)
     */
    public void sortACs(VM_Bean vm, String sortField)
    {
        Vector<CommonACBean> vAC = vm.getVM_DE_LIST();
        // sortACsBinary(vAC, sortField);
        // setUsedAttributes(vm, vAC, false, sortField);
        Vector<CommonACBean> vSort = sortACsBubble(vAC, sortField);
        setUsedAttributes(vm, vSort, false, sortField);
    }
}
