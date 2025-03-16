package note.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;


public class HealthCheckServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();

        out.println("<html><body>");
        out.println("<h1>NoteSaver Application Health Check</h1>");

        // Context information
        out.println("<h2>Context Information</h2>");
        out.println("<ul>");
        out.println("<li>Context Path: " + req.getContextPath() + "</li>");
        out.println("<li>Servlet Path: " + req.getServletPath() + "</li>");
        out.println("<li>Path Info: " + req.getPathInfo() + "</li>");
        out.println("<li>Query String: " + req.getQueryString() + "</li>");
        out.println("<li>Request URI: " + req.getRequestURI() + "</li>");
        out.println("<li>Request URL: " + req.getRequestURL() + "</li>");
        out.println("</ul>");

        // Headers
        out.println("<h2>Request Headers</h2>");
        out.println("<ul>");
        Enumeration<String> headerNames = req.getHeaderNames();
        while (headerNames.hasMoreElements()) {
            String headerName = headerNames.nextElement();
            out.println("<li>" + headerName + ": " + req.getHeader(headerName) + "</li>");
        }
        out.println("</ul>");

        // Servlet information
        out.println("<h2>Servlet Registration</h2>");
        out.println("<p>Check if NotesServlet is registered: " +
                (getServletContext().getServletRegistration("NotesServlet") != null ? "Yes" : "No") +
                "</p>");

        // Link to test other endpoints
        out.println("<h2>Test Links</h2>");
        out.println("<ul>");
        out.println("<li><a href='" + req.getContextPath() + "/api/notes'>Test /api/notes endpoint</a></li>");
        out.println("<li><a href='" + req.getContextPath() + "/test'>Test /test endpoint</a></li>");
        out.println("</ul>");

        out.println("</body></html>");
    }
}
