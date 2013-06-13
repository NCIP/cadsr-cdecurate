package gov.nih.nci.cadsr.cdecurate.action;

 
import gov.nih.nci.cadsr.cdecurate.tool.NCICurationServlet;

import java.sql.Connection;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import org.apache.struts2.ServletActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class PermissibleValueAction extends ActionSupport {

	/**
	 * 	
	 */
	private static final long serialVersionUID = 2719019049463882884L;
	private String message;

	public String execute() throws Exception {
		return SUCCESS;
	}

	public String createNew() throws Exception {
		return SUCCESS;
	}

	public String createListFromParent() throws Exception {
		System.out.println("parent: " + SUCCESS);
		return SUCCESS;
	}

	public String createListFromConcepts() throws Exception {
		System.out.println(SUCCESS);
		return SUCCESS;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String addPv() throws Exception {
		return SUCCESS;
	}

	public String addPvFromParent() throws Exception {
		return SUCCESS;
	}

	public String editPv() throws Exception {
		System.out.println("PermissibleValueAction.editPv()....");
		return SUCCESS;
	}
    private Connection getConnFromDS()
    {
        // Use tool database pool.
        Context envContext = null;
        DataSource ds = null;
        String user_;
        String pswd_;
        try
        {
            envContext = new InitialContext();
            ds = (DataSource) envContext.lookup(NCICurationServlet._dataSourceName);
            user_ = NCICurationServlet._userName;
            pswd_ = NCICurationServlet._password;
        }
        catch (Exception ex)
        {
            String stErr = "Error creating database pool[" + ex.getMessage() + "].";
            System.out.println("PermissibleValueAction.getConnFromDS()..:"+stErr);
            return null;
        }
        // Open connection
        Connection con = null;
        try
        {
            con = ds.getConnection(user_, pswd_);
        }
        catch (Exception e)
        {
//            logger.fatal("Could not open database connection.", e);
            e.printStackTrace();
            return null;
        }
        return con;
    }
    
	public String deletePv( ) throws Exception {
		System.out.println("PermissibleValueAction.deletePv()..NCICurationServlet._dataSourceName="+NCICurationServlet._dataSourceName);
		System.out.println("PermissibleValueAction.deletePv()..NCICurationServlet._userName="+NCICurationServlet._userName);
		System.out.println("PermissibleValueAction.deletePv()..NCICurationServlet._password="+NCICurationServlet._password);
		
		InitialContext ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:jdbc/CDECurateDS");
		System.out.println("PermissibleValueAction.deletePv()..dataSource:"+ds);
		Connection con=getConnFromDS();
		System.out.println("PermissibleValueAction.deletePv()..conn:"+con);
		con.close();
 		String paramValue = ServletActionContext.getRequest().getParameter("pvId");
		System.out.println("PermissibleValueAction.deletePv()..pvId="+paramValue);
		return SUCCESS;
	}

	public String pvDetailsWithParent() throws Exception {
		return SUCCESS;
	}

	public String parentConceptListGrid() throws Exception {
		return SUCCESS;
	}

	public String editPvWithEditedVm() throws Exception {
		return SUCCESS;
	}
	
	public String searchConcepts() throws Exception {
		return SUCCESS;
	}
}