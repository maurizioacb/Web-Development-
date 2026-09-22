package tienda;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class actualizarPerfil extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // 1. Verificamos que el tiguere sigue logueado
        if (session == null || session.getAttribute("usuarioID") == null) {
            response.sendRedirect("loginUsuario.jsp");
            return;
        }

        int idUsu = (int) session.getAttribute("usuarioID");

        // 2. Recogemos los datos del formulario (usando los 'name' que pusimos en el JSP)
        String nombre = request.getParameter("nombre");
        String apellidos = request.getParameter("apellidos");
        String direccion = request.getParameter("direccion");
        String poblacion = request.getParameter("poblacion");
        String clave = request.getParameter("clave");
        String claveRep = request.getParameter("claveRep");

        AccesoBD con = AccesoBD.getInstance();
        boolean exito = false;

    
        exito = con.actualizarUsuarioDatos(idUsu, nombre, apellidos, direccion, poblacion);

        // 4. Feedback para el panita
        if (exito) {
            session.setAttribute("mensajeOK", "¡Datos actualizados!");
        } else {
            session.setAttribute("mensaje", "Error al actualizar los datos.");
        }

        // 5. Volvemos al perfil para que vea los cambios
        response.sendRedirect("usuario.jsp");
    }
}