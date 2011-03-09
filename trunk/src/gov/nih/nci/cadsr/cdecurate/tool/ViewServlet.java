/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author hveerla
 *
 */
public class ViewServlet extends HttpServlet {
	
	public void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException, IOException {
		String publicId = (String)req.getParameter("publicId");
		String version = (String)req.getParameter("version");
		String path = "/NCICurationServlet?reqType=view&publicId=" + publicId +"&version=" + version;
		RequestDispatcher rd = this.getServletContext().getRequestDispatcher(path);
		rd.forward(req, res);
		return;
	}
}
