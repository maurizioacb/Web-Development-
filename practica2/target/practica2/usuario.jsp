<%@page language="java" contentType="text/html;charset=UTF-8" import="tienda.*, java.util.*" pageEncoding="UTF-8"%>
<%
    Integer idUsu = (Integer) session.getAttribute("usuarioID");
    if (idUsu == null || idUsu <= 0) {
        response.sendRedirect("loginUsuario.jsp");
        return;
    }

    AccesoBD con = AccesoBD.getInstance();
    Map<String, String> perfil = con.obtenerPerfilUsuario(idUsu);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Perfil de Usuario - Luxury ETSE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="d-flex flex-column min-vh-100 bg-dark text-white">
    
    <barra-nav></barra-nav>

    <main class="container my-5 flex-grow-1">
        <%-- BLOQUE DE MENSAJES: Feedback para el tiguere --%>
        <% if (session.getAttribute("mensajeOK") != null) { %>
            <div class="alert alert-success text-center shadow-sm">
                <i class="fas fa-check-circle me-2"></i><%= session.getAttribute("mensajeOK") %>
            </div>
            <% session.removeAttribute("mensajeOK"); %>
        <% } %>
        <% if (session.getAttribute("mensaje") != null) { %>
            <div class="alert alert-danger text-center shadow-sm">
                <i class="fas fa-exclamation-triangle me-2"></i><%= session.getAttribute("mensaje") %>
            </div>
            <% session.removeAttribute("mensaje"); %>
        <% } %>

        <h1 class="text-center mb-2 metallic-text">PERFIL DE USUARIO</h1>
        <p class="text-center text-muted mb-5">Cliente VIP #<%= idUsu %></p>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <%-- DATOS DEL PERFIL --%>
                <div class="table-responsive shadow-lg mb-5">
                    <table class="table table-dark-luxury mb-0">
                        <tbody>
                            <tr>
                                <th class="py-3 px-4" style="width: 30%;"><i class="fas fa-user-circle me-2"></i>USUARIO:</th>
                                <td class="py-3 px-4 text-info font-monospace"><%= perfil.getOrDefault("usuario", "Sin login") %></td>
                            </tr>
                            <tr><th>NOMBRE:</th><td><%= perfil.getOrDefault("nombre", "No definido") %></td></tr>
                            <tr><th>APELLIDOS:</th><td><%= perfil.getOrDefault("apellidos", "") %></td></tr>
                            <tr><th>DNI:</th><td><%= perfil.getOrDefault("dni", "---") %></td></tr>
                            <tr><th>DOMICILIO:</th><td><%= perfil.getOrDefault("direccion", "No registrada") %></td></tr>
                            <tr><th>POBLACIÓN:</th><td><%= perfil.getOrDefault("poblacion", "") %></td></tr>
                            <tr><th>PROVINCIA:</th><td><%= perfil.getOrDefault("provincia", "") %></td></tr>
                            <tr><th>C.P.:</th><td><%= perfil.getOrDefault("cp", "") %></td></tr>
                            <tr><th>TELÉFONO:</th><td><%= perfil.getOrDefault("telefono", "---") %></td></tr>
                        </tbody>
                    </table>
                </div>

        
                </div>

                <%-- BOTONERA --%>
                <div class="d-flex flex-wrap justify-content-center gap-3 mt-4">
                    <a href="cambiar.jsp" class="btn-metalico">
                        <i class="fas fa-edit me-2"></i>CAMBIAR DATOS
                    </a>
                    <a href="pedidos.jsp" class="btn-metalico">
                        <i class="fas fa-shopping-bag me-2"></i>MIS PEDIDOS
                    </a>
                    <form action="logout" method="POST" style="display:inline;">
                        <button type="submit" class="btn-metalico" style="background: #800000 !important;">
                            <i class="fas fa-sign-out-alt me-2"></i>CERRAR SESIÓN
                        </button>
                    </form>
                    <a href="cambiarclave.jsp" class="btn-metalico">
                        <i class="fas fa-key me-2"></i>CAMBIAR CLAVE
                    </a>
                </div>
            </div>
        </div>
    </main>

    <footer-bar></footer-bar>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/cabecera.js"></script>
    <script src="js/footer.js"></script>
</body>
</html>