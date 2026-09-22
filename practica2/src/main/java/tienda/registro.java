package tienda;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class registro extends HttpServlet {
    // Método doPost en registro.java
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String user = request.getParameter("usuario");
    String pass = request.getParameter("clave");
    String passRep = request.getParameter("claveRep");
    String nom = request.getParameter("nombre");
    String ape = request.getParameter("apellidos");
    String dni = request.getParameter("dni");
    String dir = request.getParameter("direccion");
    String pob = request.getParameter("poblacion");
    String pro = request.getParameter("provincia");
    String cp = request.getParameter("cp");
    String tel = request.getParameter("telefono");

    if (pass != null && pass.equals(passRep)) {
        AccesoBD con = AccesoBD.getInstance();
        boolean ok = con.registrarNuevoUsuario(user, pass, nom, ape, dni, dir, pob, pro, cp, tel);
        
        if (ok) {
            request.getSession().setAttribute("mensajeOK", "¡Ya eres de los nuestros, bienvenido al equipo de LUXURY ETSE!");
            response.sendRedirect("loginUsuario.jsp");
        } else {
            request.getSession().setAttribute("mensaje", "Error: Usuario duplicado o datos incorrectos.");
            response.sendRedirect("registrar.jsp");
        }
    } else {
        request.getSession().setAttribute("mensaje", "Las claves no coinciden.");
        response.sendRedirect("registrar.jsp");
    }
}
}
