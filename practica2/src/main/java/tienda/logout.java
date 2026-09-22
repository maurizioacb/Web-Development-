package tienda;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class logout extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Pillamos la sesión actual
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Borramos todo lo que haya en la sesión
        }

        // Leemos a qué URL quiere volver el usuario (pasada por campo oculto)
        String url = request.getParameter("url");
        if (url == null || url.isEmpty()) {
            url = "index.jsp"; // Por defecto al inicio
        }

        response.sendRedirect(url);
    }
}
