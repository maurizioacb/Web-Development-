<%@ page language="java" contentType="text/html; charset=UTF-8" import="tienda.*, java.util.*" pageEncoding="UTF-8" %>
<% 
    Integer idUsu = (Integer) session.getAttribute("usuarioID");
    if (idUsu == null || idUsu <= 0) {
        response.sendRedirect("loginUsuario.jsp");
        return;
    }

    AccesoBD con = AccesoBD.getInstance();
    Map<String, String> perfil = con.obtenerPerfilUsuario(idUsu);
    String loginTiguere = (perfil != null) ? perfil.getOrDefault("usuario", "Usuario VIP") : "Usuario";
    String mensajeError = (String) session.getAttribute("mensaje");
    session.removeAttribute("mensaje"); 
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>LUXURY ETSE - Cambiar Clave</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-dark text-white d-flex flex-column min-vh-100">

    <barra-nav></barra-nav>

    <div class="container mt-5 flex-grow-1">
        <h2 class="text-center metallic-text mb-4">CAMBIAR CONTRASEÑA</h2>

        <% if (mensajeError != null) { %>
            <div class="alert alert-danger text-center shadow-sm">
                <i class="fas fa-exclamation-circle me-2"></i><%= mensajeError %>
            </div>
        <% } %>

        <div class="row justify-content-center">
            <div class="col-lg-6">
                <form method="post" action="ActualizarClave">
                    <div class="card bg-dark border-secondary shadow-lg">
                        <div class="card-body p-4">
                            <div class="mb-4">
                                <label class="form-label text-info">Usuario:</label>
                                <input type="text" class="form-control bg-black text-white border-secondary" value="<%= loginTiguere %>" readonly>
                            </div>
                            <hr class="border-secondary">
                            
                            <%-- CAMPO CLAVE VIEJA: Sin esto, el Servlet siempre dará error --%>
                            <div class="mb-4">
                                <label class="form-label">Contraseña Antigua:</label>
                                <input type="password" class="form-control" name="claveVieja" placeholder="Escribe tu clave actual" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Nueva Contraseña:</label>
                                <input type="password" class="form-control" name="claveNueva" placeholder="Nueva clave" required>
                            </div>

                            <div class="mb-4">
                                <label class="form-label">Repite la Nueva Contraseña:</label>
                                <input type="password" class="form-control" name="claveRepite" placeholder="Repite la nueva clave" required>
                            </div>

                            <button type="submit" class="btn-metalico w-100 py-3 fw-bold">ACTUALIZAR SEGURIDAD</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <footer-bar></footer-bar>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/cabecera.js"></script>
    <script src="js/footer.js"></script>
</body>
</html>