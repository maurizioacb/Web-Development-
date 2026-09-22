<%@page language="java" contentType="text/html;charset=UTF-8" import="tienda.*, java.util.*" pageEncoding="UTF-8"%>
<%
    // 1. SEGURIDAD: Verificamos que el tiguere esté logueado
    Integer idUsu = (Integer) session.getAttribute("usuarioID");
    if (idUsu == null || idUsu <= 0) {
        response.sendRedirect("loginUsuario.jsp");
        return;
    }

    // 2. DATA: Pedimos los pedidos a la BD
    AccesoBD con = AccesoBD.getInstance();
    List<Map<String, Object>> listaPedidos = con.obtenerPedidosUsuario(idUsu);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis Pedidos - Luxury ETSE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .detalle-row { background-color: rgba(0,0,0,0.3); }
        .btn-ver { color: #aaa; cursor: pointer; transition: 0.3s; }
        .btn-ver:hover { color: #fff; }
    </style>
</head>
<body class="d-flex flex-column min-vh-100 bg-dark text-white">

    <barra-nav></barra-nav>

    <main class="container my-5 flex-grow-1">
        <h1 class="text-center mb-5 metallic-text">HISTORIAL DE PEDIDOS</h1>

        <% if (listaPedidos == null || listaPedidos.isEmpty()) { %>
            <div class="alert alert-dark text-center shadow-lg py-5">
                <i class="fas fa-box-open fa-3x mb-3 text-muted"></i>
                <p class="fs-4">Todavía no has hecho ninguna compra, compai.</p>
                <a href="index.jsp" class="btn-metalico mt-3">Ir a la tienda</a>
            </div>
        <% } else { %>
            <div class="table-responsive shadow-lg rounded">
                <table class="table table-dark table-hover align-middle text-center mb-0">
                    <thead class="table-active border-secondary">
                        <tr>
                            <th class="py-3">PEDIDO #</th>
                            <th>FECHA</th>
                            <th>TOTAL (€)</th>
                            <th>ESTADO</th>
                            <th>ACCIONES</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, Object> pedido : listaPedidos) { 
                            int idPed = (Integer)pedido.get("id");
                            int est = (Integer)pedido.get("estado");
                        %>
                            <tr class="border-secondary">
                                <td class="fw-bold text-info font-monospace">
                                    #<%= idPed %>
                                    <br>
                                    <span class="btn-ver small" data-bs-toggle="collapse" data-bs-target="#det<%= idPed %>">
                                        <i class="fas fa-search-plus me-1"></i>Ver productos
                                    </span>
                                </td>
                                <td><%= pedido.get("fecha") %></td>
                                <td class="text-success fw-bold"><%= String.format("%.2f", (Double)pedido.get("total")) %>€</td>
                                <td>
                                    <% if(est == 1) { %>
                                        <span class="badge bg-warning text-dark">Pendiente</span>
                                    <% } else if(est == 2) { %>
                                        <span class="badge bg-danger">Cancelado</span>
                                    <% } else { %>
                                        <span class="badge bg-success">Finalizado</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if(est == 1) { %>
                                        <button class="btn btn-outline-danger btn-sm" 
                                                data-id="<%= idPed %>" 
                                                onclick="confirmarCancelacion(this.getAttribute('data-id'))">
                                            <i class="fas fa-trash-alt me-1"></i> Cancelar
                                        </button>
                                    <% } else { %>
                                        <span class="text-muted small italic">No editable</span>
                                    <% } %>
                                </td>
                            </tr>
                            
                            <!-- FILA COLAPSABLE PARA LOS DETALLES -->
                            <tr class="collapse detalle-row" id="det<%= idPed %>">
                                <td colspan="5" class="text-start p-4">
                                    <h6 class="text-info border-bottom border-secondary pb-2 mb-3">Artículos del pedido:</h6>
                                    <ul class="list-unstyled mb-0">
                                        <% 
                                            // Llamada al método que cruza detalle con productos
                                            List<Map<String, Object>> detalles = con.obtenerDetallesPedido(idPed);
                                            for (Map<String, Object> d : detalles) {
                                        %>
                                            <li class="mb-2">
                                                <i class="fas fa-caret-right text-muted me-2"></i>
                                                <span class="fw-bold"><%= d.get("cantidad") %>x</span> 
                                                <%= d.get("nombreProd") %> 
                                                <span class="text-muted small ms-2">
                                                    (<%= String.format("%.2f", (Double)d.get("precioUnidad")) %>€/ud)
                                                </span>
                                            </li>
                                        <% } %>
                                    </ul>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>

        <div class="text-center mt-5">
            <a href="usuario.jsp" class="btn-metalico">
                <i class="fas fa-user me-2"></i>VOLVER AL PERFIL
            </a>
        </div>
    </main>

    <footer-bar></footer-bar>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/cabecera.js"></script>
    <script src="js/footer.js"></script>

    <script>
        function confirmarCancelacion(idPedido) {
            const mensaje = "¿Seguro que quieres cancelar el pedido #" + idPedido + ", panita?";
            if (confirm(mensaje)) {
                window.location.href = "CancelarPedido?id=" + idPedido;
            }
        }
    </script>
</body>
</html>