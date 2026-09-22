<%@ page language="java" contentType="text/html; charset=UTF-8" import="java.util.List,tienda.*" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury ETSE - Gracias por su compra</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilo.css"> 
</head>
<body class="bg-dark text-white">

    <barra-nav></barra-nav>

    <%
    if (session.getAttribute("usuario") == null && session.getAttribute("usuarioID") == null) {
        response.sendRedirect("loginUsuario.jsp?url=index.html");
        return;
    }
    %>

    <%
    Integer codigoPedido = (Integer) session.getAttribute("codigoPedido");
    if (codigoPedido != null) {
        // Quitamos los datos de la sesión para que no se dupliquen pedidos
        session.removeAttribute("codigoPedido"); 
        session.removeAttribute("carritoJSON");
    }
    %>
    
    <div class="container mt-5 text-center" style="padding-top: 100px; padding-bottom: 100px;">
        <h2 class="metallic-text display-4">¡GRACIAS POR TU COMPRA!</h2>
        <p class="mt-4 fs-5">Tu pedido ha sido procesado exitosamente en nuestra boutique.</p>
        
        <% if (codigoPedido != null) { %>
            <div class="alert alert-light d-inline-block mt-3 px-5">
                <span class="text-dark fw-bold">CÓDIGO DE PEDIDO: #<%= codigoPedido %></span>
            </div>
        <% } %>
        
        <p class="mt-4 text-muted">En breve recibirás un correo con los detalles de tu compra Luxury.</p>
        
        <button class="btn-metalico mt-4 px-5" onclick="window.location.href='index.jsp';">
            CONFIRMAR Y VOLVER
        </button>
    </div>
    
    <footer-bar></footer-bar>
    
    <script src="js/cabecera.js"></script>
    <script src="js/footer.js"></script>
    <script src="js/carrito.js"></script>

    <script>
        // 3. LÓGICA DE LIMPIEZA EN CLIENTE (Llamada literal al bueno)
        // Esto borra el localStorage para que el carrito aparezca vacío
        window.onload = eliminarCarrito; 
    </script>
</body>
</html>