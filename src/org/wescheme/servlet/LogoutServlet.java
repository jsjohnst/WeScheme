package org.wescheme.servlet;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.wescheme.user.SessionManager;

public class LogoutServlet extends HttpServlet {
	private static final long serialVersionUID = 5271225589190489583L;
	
	public void service(HttpServletRequest req, HttpServletResponse resp)	throws IOException 
	{	
		SessionManager sm = new SessionManager();
		sm.logout(req, resp);
		if (req.getParameter("dest") != null)
		    resp.sendRedirect(req.getParameter("dest"));
		else {
		    resp.sendRedirect("/");
		}
	}
	
	
}
