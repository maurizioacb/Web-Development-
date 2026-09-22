<%@page language="java" contentType="text/html;charset=UTF-8" import="tienda.*, java.util.*" pageEncoding="UTF-8"%>
<%
    Integer idUsu = (Integer) session.getAttribute("usuarioID");
    if (idUsu == null) idUsu = (Integer) session.getAttribute("usuario");
    
    if (idUsu == null) {
        response.sendRedirect("loginUsuario.jsp?url=compra.jsp");
        return;
    }
    
    AccesoBD con = AccesoBD.getInstance();
    Map<String, String> perfil = con.obtenerPerfilUsuario(idUsu);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Resumen de Compra - Luxury ETSE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilo.css">
</head>
<body class="bg-dark text-white d-flex flex-column min-vh-100">
    
    <barra-nav></barra-nav>

    <main class="container my-5 flex-grow-1">
        
        <%
        String mensaje = (String) session.getAttribute("mensajeSinStock");
        if (mensaje != null) {
            session.removeAttribute("mensajeSinStock");
        %>
        <div class="alert alert-warning text-center fw-bold mb-4">
            <%= mensaje %>
        </div>
        <% } %>

        <h1 class="text-center mb-5 metallic-text">RESUMEN DE TU SELECCIÓN</h1>

        <div class="table-responsive shadow-sm mb-5">
            <table class="table table-dark table-bordered align-middle text-center mb-0">
                <thead class="table-secondary text-dark">
                    <tr>
                        <th>IMAGEN</th>
                        <th>DESCRIPCIÓN</th>
                        <th>UNIDADES</th>
                        <th>PRECIO UNIT.</th>
                    </tr>
                </thead>
                <tbody id="carrito-items">
                    </tbody>
                <tfoot>
                    <tr class="table-light text-dark">
                        <td colspan="3" class="text-end fw-bold py-3">TOTAL ESTIMADO:</td>
                        <td class="fw-bold py-3" id="total-compra">0.00€</td>
                    </tr>
                </tfoot>
            </table>
        </div>

        <div class="card p-4 bg-white text-dark shadow text-center">
            <h4 class="mb-4">¿Todo listo, <%= perfil.get("nombre") %>?</h4>
            <p>Al hacer clic en formalizar, validaremos el stock y prepararemos tu envío.</p>
            
            <div class="d-flex justify-content-center gap-3 mt-3">
                <button class="btn btn-outline-dark" onclick="window.location.href='carrito.html';">
                    MODIFICAR CARRITO
                </button>

                <button type="button" class="btn-metalico" onclick="EnviarCarrito('ProcesarPedido', carrito);">
                    FORMALIZAR PEDIDO
                </button>
            </div>
        </div>
    </main>

    <footer-bar></footer-bar>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/cabecera.js"></script>
    <script src="js/footer.js"></script>
    <script src="./js/libjson.js"></script>
    <script src="./js/carrito.js"></script>
    <script>
        // Carga el ticket visualmente desde localStorage
        window.onload = generarTicket;
    </script>
</body>
</html>