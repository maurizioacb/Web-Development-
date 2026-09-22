<%@page language="java" contentType="text/html;charset=UTF-8" import="tienda.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Cuenta - Luxury ETSE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="d-flex flex-column min-vh-100">

    <barra-nav></barra-nav>

    <main class="container d-flex flex-column justify-content-center align-items-center flex-grow-1">
        <h1 class="text-center mb-4">MI CUENTA</h1>

        <%-- 1. GESTIÓN DE MENSAJES DE ERROR --%>
        <%
            String mensaje = (String)session.getAttribute("mensaje");
            if (mensaje != null) {
                session.removeAttribute("mensaje");
        %>
            <div class="alert alert-danger mb-4" role="alert" style="border-radius: 0;">
                <i class="fas fa-exclamation-triangle me-2"></i> <%= mensaje %>
            </div>
        <% } %>

        <%-- 2. CONTROL DE SESIÓN --%>
        <%
            if ((session.getAttribute("usuarioID") == null) || ((Integer)session.getAttribute("usuarioID") <= 0)) {
        %>
            
            <%-- FORMULARIO CON TU DISEÑO --%>
            <div class="card p-4 shadow-lg" style="max-width: 400px; width: 100%; background: white; border-radius: 0;">
                <form action="login" method="POST">
                    <input type="hidden" name="url" value="./loginUsuario.jsp">

                    <div class="mb-3">
                        <label class="form-label" style="color: black !important; font-weight: 500;">USUARIO / EMAIL:</label>
                        <input type="text" name="usuario" class="form-control" placeholder="Tu usuario" required style="border-radius: 0;">
                    </div>

                    <div class="mb-3">
                        <label class="form-label" style="color: black !important; font-weight: 500;">CONTRASEÑA:</label>
                        <input type="password" name="clave" class="form-control" required style="border-radius: 0;">
                    </div>

                    <div class="mb-3">
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="tipoAcceso" value="Acceso" checked>
                            <label class="form-check-label">Acceso</label>
                        </div>
                    </div>

                    <div class="d-grid mt-4">
                        <button type="submit" class="btn-metalico w-100">ENTRAR</button>
                    </div>

                    <div class="text-center mt-4">
                        <a href="registrar.jsp" style="color: black; text-decoration: underline; font-size: 0.9rem;">Crear una cuenta nueva</a>
                    </div>
                </form>
            </div>

        <% 
            } else { 
                // Si ya está logueado y venía para comprar, mándalo a compra
                String urlDestino = request.getParameter("url");
                if (urlDestino != null) {
                    response.sendRedirect(urlDestino);
                } else {
                    response.sendRedirect("./usuario.jsp");
                }
            } 
        %>
    </main>

    <footer-bar></footer-bar>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/cabecera.js"></script>
    <script src="js/footer.js"></script>
</body>
</html>