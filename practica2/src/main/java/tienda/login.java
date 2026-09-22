package tienda;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet; 
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class login extends HttpServlet { 
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // Recogemos los datos del formulario
        String usuario = request.getParameter("usuario");
        String clave = request.getParameter("clave");
        String url = request.getParameter("url");

        // Pillamos la sesión
        HttpSession session = request.getSession(true);
        AccesoBD con = AccesoBD.getInstance();

        if ((usuario != null) && (clave != null)) {
            // Llamamos al método que acabamos de crear en AccesoBD
            int codigo = con.comprobarUsuarioBD(usuario, clave);
            // Justo después de: int codigo = con.comprobarUsuarioBD(usuario, clave);

if (codigo == -1) {
    System.out.println("FALLO DE LOGIN: El usuario '" + usuario + "' no se encontró con esa clave.");
}
            if (codigo > 0) {
                session.setAttribute("usuarioID", codigo);
                session.removeAttribute("mensaje"); // Limpiamos errores previos
            } else {
                session.setAttribute("mensaje", "Usuario y/o clave incorrectos");
                session.setAttribute("usuarioID", -1);
            }
        }

        // Si por algún motivo no hay URL, lo mandamos al index por defecto
        if (url == null || url.isEmpty()) {
            url = "index.jsp";
        }

        // Redirigimos a la página que nos pidió el formulario
        response.sendRedirect(url);
    }
}