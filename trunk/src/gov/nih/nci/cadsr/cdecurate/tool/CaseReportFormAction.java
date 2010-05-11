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
public class CaseReportFormAction extends CommonACAction
{
    Logger logger = Logger.getLogger(CaseReportFormAction.class.getName());

    /**
     * 
     */
    public CaseReportFormAction()
    {
        super();
    }

    /*
     * (non-Javadoc)
     * 
     * @see gov.nih.nci.cadsr.cdecurate.tool.CommonACAction#getSelect(java.lang.String, boolean, java.lang.String)
     */
    public String getSelect(String vmID, boolean isStatusFilter, String sOrder)
    {
        String sSelect = "SELECT crf.qc_idseq idseq " + ", crf.long_name long_name " + ", crf.qc_id ac_id"
                        + ", crf.version " + ", crf.asl_name workflow " + ", c.name context " + ", crf.qtl_name "
                        + ", crf.qcdl_name " + ", p.long_name proto_name " + ", p.protocol_id ";
        /*String sFrom = " FROM (SELECT qc.dn_crf_idseq AS ID FROM quest_contents_view_ext qc, sbr.vd_pvs_view vp,"
                        + " sbr.permissible_values_view pv WHERE vp.pv_idseq = pv.pv_idseq AND qc.vp_idseq = vp.vp_idseq"
                        + " AND pv.short_meaning = '" + vmID + "' GROUP BY qc.dn_crf_idseq) quest, "
                        + " sbrext.quest_contents_view_ext crf, sbrext.protocols_view_ext p, sbr.contexts_view c";*/
        String sFrom = " FROM (SELECT qc.dn_crf_idseq AS ID FROM quest_contents_view_ext qc, sbr.vd_pvs_view vp,"
            + " sbr.permissible_values_view pv WHERE vp.pv_idseq = pv.pv_idseq AND qc.vp_idseq = vp.vp_idseq"
            + " AND pv.vm_idseq = '" + vmID + "' GROUP BY qc.dn_crf_idseq) quest, "
            + " sbrext.quest_contents_view_ext crf, sbrext.protocols_view_ext p, sbr.contexts_view c";
        String sWhere = " WHERE crf.qc_idseq = quest.ID AND crf.proto_idseq = p.proto_idseq(+) AND crf.conte_idseq = c.conte_idseq";
        /*
         * String sFrom = " FROM sbrext.quest_contents_view_ext crf, sbrext.protocols_view_ext p, sbr.contexts_view c ";
         * String sWhere = " WHERE crf.proto_idseq = p.proto_idseq AND crf.conte_idseq = c.conte_idseq " + " AND
         * crf.qc_idseq IN (SELECT qc.dn_crf_idseq " + " FROM sbrext.quest_contents_view_ext qc, sbr.vd_pvs_view vp,
         * sbr.permissible_values_view pv " + " WHERE qc.vp_idseq = vp.vp_idseq AND vp.pv_idseq = pv.pv_idseq " + " AND
         * upper(pv.short_meaning) = upper('" + vmID + "') GROUP BY qc.dn_crf_idseq)";
         */
        if (isStatusFilter)
            sWhere += " AND crf.asl_name IN (" + formatArray(getStatusList()) + ")";
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
        ac.setType(rs.getString("qtl_name"));
        ac.setCategory(rs.getString("qcdl_name"));
        ac.setProtoName(rs.getString("proto_name"));
        ac.setProtoID(rs.getString("protocol_id"));
    }

    /*
     * (non-Javadoc)
     * 
     * @see gov.nih.nci.cadsr.cdecurate.tool.CommonACAction#setUsedAttributes(gov.nih.nci.cadsr.cdecurate.tool.VM_Bean,
     *      java.util.Vector, boolean)
     */
    public void setUsedAttributes(VM_Bean vm, Vector<CommonACBean> vAC, boolean statFilter, String sortField)
    {
        vm.setVM_CRF_LIST(vAC);
        if (statFilter)
            vm.setVM_SHOW_RELEASED_CRF(statFilter);
        if (sortField != null)
            vm.setVM_SORT_COLUMN_CRF(sortField);
    }

    /*
     * (non-Javadoc)
     * 
     * @see gov.nih.nci.cadsr.cdecurate.tool.CommonACAction#sortACs(gov.nih.nci.cadsr.cdecurate.tool.VM_Bean,
     *      java.lang.String)
     */
    public void sortACs(VM_Bean vm, String sortField)
    {
        Vector<CommonACBean> vAC = vm.getVM_CRF_LIST();
        // sortACsBinary(vAC, sortField);
        // setUsedAttributes(vm, vAC, false, sortField);
        Vector<CommonACBean> vSort = sortACsBubble(vAC, sortField);
        setUsedAttributes(vm, vSort, false, sortField);
    }
}
