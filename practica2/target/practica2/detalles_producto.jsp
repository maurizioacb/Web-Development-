<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="tienda.*" %>
<%
    String idStr = request.getParameter("id");
    ProductoBD p = null;

    if (idStr != null) {
        int id = Integer.parseInt(idStr);
        AccesoBD con = AccesoBD.getInstance();
        p = con.obtenerProductoPorID(id);
    }

    if (p == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title><%= p.getNombre() %> - Luxury ETSE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilo.css">
</head>
<body class="bg-dark text-white d-flex flex-column min-vh-100">
    
    <barra-nav></barra-nav>

    <main class="container my-5 flex-grow-1">
        <div class="row g-5 align-items-center">
            <!-- Imagen del producto -->
            <div class="col-md-6 text-center">
                <img src="<%= p.getImagen() %>" class="img-fluid rounded shadow-lg border border-secondary" style="max-height: 500px;" alt="<%= p.getNombre() %>">
            </div>

            <!-- Info del producto -->
            <div class="col-md-6">
                <h1 class="display-4 metallic-text mb-3"><%= p.getNombre() %></h1>
                <p class="fs-3 text-info fw-bold"><%= String.format("%.2f", p.getPrecio()) %>€</p>
                <hr class="border-secondary">
                <p class="lead text-white"><%= p.getDescripcion() %></p>
                <p class="mb-4"><strong>Stock VIP:</strong> <%= p.getStock() %> unidades disponibles</p>
                
                <!-- Botonera -->
                <div class="d-flex gap-3">
                    <button class="btn-metalico py-3 px-5 fw-bold" 
                            onclick="anadirCarrito('<%= p.getCodProd() %>', '<%= p.getNombre() %>', '<%= p.getDescripcion() %>', '<%= p.getImagen() %>', 1, '<%= p.getPrecio() %>', '<%= p.getStock() %>')">
                        <i class="fas fa-cart-plus me-2"></i> AÑADIR AL CARRITO
                    </button>
                </div>
                
                <div class="mt-5">
                    <a href="javascript:history.back()" class="text-white-50 text-decoration-none">
                        <i class="fas fa-chevron-left me-2"></i> Volver a la colección
                    </a>
                </div>
            </div>
        </div>
    </main>

    <footer-bar></footer-bar>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/cabecera.js"></script>
    <script src="js/footer.js"></script>
    <script src="js/carrito.js"></script>
</body>
</html>