<%@ page language="java" contentType="text/html; charset=UTF-8" import="java.util.*,tienda.*" pageEncoding="UTF-8" %>
<%
    // 1. BLOQUEO DE SEGURIDAD (Igual al bueno pero aceptando tus dos posibles nombres de sesión)
    if (session.getAttribute("usuario") == null && session.getAttribute("usuarioID") == null) {
        response.sendRedirect("loginUsuario.jsp?url=procesar.jsp");
        return;
    }

    // 2. RECUPERACIÓN DE DATOS (Mantenemos tu Map y tu Lista)
    Map<String, String> usuario = (Map<String, String>) session.getAttribute("datosUsuario");
    List<Producto> carrito = (List<Producto>) session.getAttribute("carritoJSON");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Formalizar Pedido - Luxury ETSE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilo.css">
    <style>
        .metodo-pago td { padding: 15px !important; vertical-align: middle; }
        .tarjeta-inputs input { width: 50px; display: inline-block; text-align: center; }
    </style>
</head>
<body class="bg-dark text-white">
    
    <barra-nav></barra-nav>

    <div class="container mt-5">
        <h2 class="text-center mb-4 metallic-text">RESUMEN DE TU COMPRA</h2>
        
        <table class="table table-dark table-bordered text-center align-middle shadow">
            <thead class="table-secondary text-dark">
                <tr><th>IMAGEN</th><th>DESCRIPCIÓN</th><th>UNIDADES</th><th>PRECIO</th></tr>
            </thead>
            <tbody>
            <% float total = 0;
               if (carrito != null) {
                 for (Producto p : carrito) {
                     float subtotal = p.getStock() * p.getPrecio();
                     total += subtotal;
            %>
                <tr>
                    <td><img src="<%= p.getImagen() %>" width="80" class="rounded shadow-sm"></td>
                    <td><strong><%= p.getNombre() %></strong></td>
                    <td><%= p.getStock() %></td>
                    <td><%= String.format("%.2f", subtotal) %> €</td>
                </tr>
            <%   } 
               } %>
            </tbody>
            <tfoot class="table-light text-dark">
                <tr class="fw-bold">
                    <td colspan="3" class="text-end">TOTAL A PAGAR:</td>
                    <td><%= String.format("%.2f", total) %> €</td>
                </tr>
            </tfoot>
        </table>

        <div class="card p-4 text-dark mt-5 mb-5 shadow-lg">
            <form method="post" action="Tramitacion">
                <h4 class="text-center text-primary mb-4 border-bottom pb-2">DIRECCIÓN DE ENVÍO</h4>
                
                <div class="mb-3">
                    <label class="form-label fw-bold">Nombre Completo:</label>
                    <input type="text" class="form-control" name="nombre" value="<%= usuario.get("nombre") %>" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label fw-bold">Domicilio:</label>
                    <input type="text" class="form-control" name="domicilio" value="<%= usuario.get("direccion") %>" required>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold">Código Postal:</label>
                        <input type="text" class="form-control" name="cp" value="<%= usuario.get("cp") %>" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold">Población:</label>
                        <input type="text" class="form-control" name="poblacion" value="<%= usuario.get("poblacion") %>" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold">Provincia:</label>
                        <input type="text" class="form-control" name="provincia" value="<%= usuario.get("provincia") %>" required>
                    </div>
                </div>

                <h4 class="text-center text-primary mt-4 border-bottom pb-2">MÉTODO DE PAGO</h4>
                
                <table class="table table-bordered mt-3 metodo-pago">
                    <tbody>
                        <tr>
                            <td width="40%">
                                <input type="radio" name="metodo-pago" id="tarjeta" value="tarjeta" checked>
                                <label for="tarjeta" class="fw-bold ms-2">💳 Tarjeta de Crédito</label>
                            </td>
                            <td>
                                <div class="tarjeta-inputs">
                                    <input type="text" maxlength="4" class="form-control form-control-sm">
                                    <input type="text" maxlength="4" class="form-control form-control-sm">
                                    <input type="text" maxlength="4" class="form-control form-control-sm">
                                    <input type="text" maxlength="4" class="form-control form-control-sm">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="radio" name="metodo-pago" id="transferencia" value="transferencia">
                                <label for="transferencia" class="fw-bold ms-2">🏦 Transferencia Bancaria</label>
                            </td>
                            <td class="small text-muted">
                                IBAN: ES12 3456 7890 1234 5678 9012<br>
                                Indique su nombre en el concepto.
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="radio" name="metodo-pago" id="bizum" value="bizum">
                                <label for="bizum" class="fw-bold ms-2">📲 Bizum</label>
                            </td>
                            <td class="small text-muted">Teléfono: 600 000 000</td>
                        </tr>
                    </tbody>
                </table>

                <div class="d-grid gap-2 mt-4">
                    <button type="submit" class="btn-metalico btn-lg">FORMALIZAR COMPRA</button>
                    <a href="carrito.html" class="btn btn-outline-secondary btn-sm">Volver al carrito</a>
                </div>
            </form>
        </div>
    </div>

    <footer-bar></footer-bar>

    <script src="js/cabecera.js"></script>
    <script src="js/footer.js"></script>
</body>
</html>