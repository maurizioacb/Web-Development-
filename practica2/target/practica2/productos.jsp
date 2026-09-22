<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*, tienda.*" %>
<%
    // 1. Conectamos con la base de datos
    AccesoBD con = AccesoBD.getInstance();
    
    // 2. Creamos una lista para meter todo
    List<ProductoBD> coleccionCompleta = new ArrayList<>();
    
    // Traemos las 3 categorías y las metemos en el saco
    for(int i = 1; i <= 3; i++) {
        List<ProductoBD> categoria = con.obtenerProductosBD(i);
        if(categoria != null) {
            coleccionCompleta.addAll(categoria);
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Colección - Luxury ETSE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-dark text-white d-flex flex-column min-vh-100">
    
    <barra-nav></barra-nav>

    <main class="container my-5 flex-grow-1">
        <div class="text-center mb-5">
            <h1 class="display-4 metallic-text text-uppercase">Nuestra Colección</h1>
            <p class="text-muted">Exclusividad y estilo en cada pieza.</p>
        </div>

        <div class="row g-5">
            <% 
            if (!coleccionCompleta.isEmpty()) {
                for (ProductoBD p : coleccionCompleta) { 
            %>
                <div class="col-12 col-md-6 col-lg-4 text-center mb-5">
                    <a href="detalles_producto.jsp?id=<%= p.getCodProd() %>" class="producto-link text-decoration-none">
                        <img src="<%= p.getImagen() %>" class="img-producto-simple" alt="<%= p.getNombre() %>">
                        <h3 class="mt-3 text-white"><%= p.getNombre() %></h3>
                    </a>
                    
                    <div class="d-flex justify-content-center align-items-center gap-3">
                        <p class="precio-simple mb-0"><%= String.format("%.2f", p.getPrecio()) %>€</p>
                        
                        <button class="btn-metalico p-2" style="font-size: 0.7rem;"
                                onclick="anadirCarrito('<%= p.getCodProd() %>', '<%= p.getNombre() %>', '<%= p.getDescripcion() %>', '<%= p.getImagen() %>', 1, '<%= p.getPrecio() %>', '<%= p.getStock() %>')">
                            + CARRITO
                        </button>
                    </div>
                    <small class="text-muted d-block mt-2">Disponibles: <%= p.getStock() %></small>
                </div>
            <% 
                } 
            } else { 
            %>
                <div class="col-12 text-center">
                    <p class="lead">Parece que la colección está agotada por ahora, lo sentimos mucho.</p>
                </div>
            <% } %>
        </div>
    </main>

    <footer-bar></footer-bar>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/cabecera.js"></script>
    <script src="js/footer.js"></script>
    <script src="js/carrito.js"></script>
</body>
</html>