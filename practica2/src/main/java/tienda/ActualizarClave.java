package tienda;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ActualizarClave extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);
    // Asegúrate de que en el Login usaste "usuarioID"
    Integer idUsu = (Integer) (session != null ? session.getAttribute("usuarioID") : null);

    if (idUsu == null) {
        response.sendRedirect("loginUsuario.jsp");
        return;
    }

    // Pillamos los parámetros del JSP corregido
    String viejaIngresada = request.getParameter("claveVieja");
    String nueva = request.getParameter("claveNueva");
    String repite = request.getParameter("claveRepite");

    AccesoBD con = AccesoBD.getInstance();
    String claveActualEnBD = con.obtenerClave(idUsu);

    // 1. VALIDACIÓN CLAVE ANTIGUA
    if (viejaIngresada == null || !viejaIngresada.trim().equals(claveActualEnBD.trim())) {
        session.setAttribute("mensaje", "❌ La clave anterior es incorrecta.");
        response.sendRedirect("cambiarclave.jsp");
        return;
    }

    // 2. VALIDACIÓN NUEVAS COINCIDEN
    if (nueva == null || !nueva.equals(repite)) {
        session.setAttribute("mensaje", "❌ Las nuevas contraseñas no coinciden!!");
        response.sendRedirect("cambiarclave.jsp");
        return;
    }

    // 3. ACTUALIZAR
    if (con.actualizarClave(idUsu, nueva)) {
        session.setAttribute("mensajeOK", "✅ cambiada correctamente");
        response.sendRedirect("usuario.jsp");
    } else {
        session.setAttribute("mensaje", "❌ Error al guardar en la base de datos.");
        response.sendRedirect("cambiarclave.jsp");
    }
}
}   