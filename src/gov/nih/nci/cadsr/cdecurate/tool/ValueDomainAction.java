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
public class ValueDomainAction extends CommonACAction
{
    Logger logger = Logger.getLogger(ValueDomainAction.class.getName());

    /**
     * 
     */
    public ValueDomainAction()
    {
        super();
    }

    /*
     * (non-Javadoc)
     * 
     * @see gov.nih.nci.cadsr.cdecurate.tool.CommonACAction#getSelect()
     */
    public String getSelect(String vmID, boolean isStatusFilter, String sOrder)
    {
        String sSelect = "SELECT vd.vd_idseq idseq" + ", vd.long_name" + ", vd.asl_name workflow" + ", c.name context "
                        + ", vd.version " + ", vd.vd_id ac_id" + ", vd.preferred_definition definition";
        String sFrom = " FROM sbr.contexts_view c, sbr.value_domains_view vd"
                        + ", sbr.vd_pvs_view vp, sbr.permissible_values_view pv  ";
        String sWhere = " WHERE vd.conte_idseq = c.conte_idseq AND vd.vd_idseq = vp.vd_idseq "
                        + " AND vp.pv_idseq = pv.pv_idseq AND pv.vm_idseq = '" + vmID + "'";
        if (isStatusFilter)
            sWhere += " AND vd.asl_name IN (" + formatArray(getStatusList()) + ")";
        if (sOrder.equals(""))
            sOrder = "long_name";
        String sSQL = sSelect + sFrom + sWhere + " ORDER BY upper(" + sOrder + ")";
        System.out.println(sSQL);
        return sSQL;
    }

    /*
     * (non-Javadoc)
     * 
     * @see gov.nih.nci.cadsr.cdecurate.tool.CommonACAction#setExtras(gov.nih.nci.cadsr.cdecurate.tool.CommonACBean)
     */
    public void setExtras(CommonACBean ac, ResultSet rs) throws SQLException
    {
        ac.setDefinition(rs.getString("definition"));
    }

    /*
     * (non-Javadoc)
     * 
     * @see gov.nih.nci.cadsr.cdecurate.tool.CommonACAction#setUsedAttributes(gov.nih.nci.cadsr.cdecurate.tool.VM_Bean,
     *      java.util.Vector, boolean)
     */
    public void setUsedAttributes(VM_Bean vm, Vector<CommonACBean> vAC, boolean statFilter, String sortField)
    {
        vm.setVM_VD_LIST(vAC);
        if (statFilter)
            vm.setVM_SHOW_RELEASED_VD(statFilter);
        if (sortField != null)
            vm.setVM_SORT_COLUMN_VD(sortField);
    }

    /*
     * (non-Javadoc)
     * 
     * @see gov.nih.nci.cadsr.cdecurate.tool.CommonACAction#sortACs(gov.nih.nci.cadsr.cdecurate.tool.VM_Bean,
     *      java.lang.String)
     */
    public void sortACs(VM_Bean vm, String sortField)
    {
        Vector<CommonACBean> vAC = vm.getVM_VD_LIST();
        // sortACsBinary(vAC, sortField);
        // setUsedAttributes(vm, vAC, false, sortField);
        Vector<CommonACBean> vSort = sortACsBubble(vAC, sortField);
        setUsedAttributes(vm, vSort, false, sortField);
    }
}
