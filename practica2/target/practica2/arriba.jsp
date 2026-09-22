<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.List, tienda.*" %>
<%
    AccesoBD con = AccesoBD.getInstance();
    List<ProductoBD> listaProductos = con.obtenerProductosBD(1); 
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Partes de Arriba - Luxury ETSE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilo.css">
</head>
<body class="bg-dark text-white d-flex flex-column min-vh-100">
    <barra-nav></barra-nav>

    <main class="container my-5 flex-grow-1">
        <div class="text-center mb-5">
            <h1 class="metallic-text">PARTES DE ARRIBA  </h1>
        </div>

        <div class="row justify-content-center">
            <% 
            if (listaProductos != null && !listaProductos.isEmpty()) {
                for (ProductoBD p : listaProductos) { 
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
                    <p class="small text-muted mt-2">Disponibles en almacén: <%= p.getStock() %></p>
                </div>
            <% 
                } 
            } else { 
            %>
                <div class="col-12 text-center">
                    <p class="lead">No hay partes de arriba en stock ahora mismo, lo sentimos mucho.</p>
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