<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro - Luxury ETSE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="d-flex flex-column min-vh-100">
    
    <barra-nav></barra-nav>

    <main class="container my-5 flex-grow-1">
        <h1 class="text-center mb-4">REGISTRO DE USUARIOS</h1>

        <%-- Sistema de alertas para mensajes de error o éxito --%>
        <%
            String msj = (String) session.getAttribute("mensaje");
            if (msj != null) {
        %>
            <div class="alert alert-danger text-center mx-auto" style="max-width: 600px;">
                <i class="fas fa-exclamation-triangle"></i> <%= msj %>
            </div>
        <% 
            session.removeAttribute("mensaje");
            } 
        %>

        <div class="row justify-content-center">
            <div class="col-md-8 contacto-form p-4 shadow-lg rounded"> 
                
                <form action="probarRegistro" method="POST">
                    
                    <%-- SECCIÓN 1: DATOS DE ACCESO --%>
                    <div class="mb-4">
                        <label class="form-label fw-bold">USUARIO / EMAIL</label>
                        <input type="email" name="usuario" class="form-control" placeholder="ejemplo@luxury.com" required>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <label class="form-label fw-bold">CLAVE</label>
                            <input type="password" name="clave" class="form-control" required>
                        </div>
                        <div class="col-md-6 mb-4">
                            <label class="form-label fw-bold">REPITE CLAVE</label>
                            <input type="password" name="claveRep" class="form-control" required>
                        </div>
                    </div>

                    <hr class="my-4" style="border-top: 1px solid #555;">

                    <%-- SECCIÓN 2: DATOS PERSONALES --%>
                    <div class="row">
                        <div class="col-md-4 mb-4">
                            <label class="form-label fw-bold">NOMBRE</label>
                            <input type="text" name="nombre" class="form-control" placeholder="Maurizio" required>
                        </div>
                        <div class="col-md-4 mb-4">
                            <label class="form-label fw-bold">APELLIDOS</label>
                            <input type="text" name="apellidos" class="form-control" placeholder="Carrasquero" required>
                        </div>
                        <div class="col-md-4 mb-4">
                            <label class="form-label fw-bold">DNI</label>
                            <input type="text" name="dni" class="form-control" placeholder="12345678X" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold">DIRECCIÓN / DOMICILIO</label>
                        <input type="text" name="direccion" class="form-control" placeholder="Calle, número, puerta..." required>
                    </div>

                    <div class="row">
                        <div class="col-md-4 mb-4">
                            <label class="form-label fw-bold">POBLACIÓN</label>
                            <input type="text" name="poblacion" class="form-control" required>
                        </div>
                        <div class="col-md-3 mb-4">
                            <label class="form-label fw-bold">PROVINCIA</label>
                            <input type="text" name="provincia" class="form-control" required>
                        </div>
                        <div class="col-md-2 mb-4">
                            <label class="form-label fw-bold">CP</label>
                            <input type="text" name="cp" class="form-control" maxlength="5" required>
                        </div>
                        <div class="col-md-3 mb-4">
                            <label class="form-label fw-bold">TELÉFONO</label>
                            <input type="text" name="telefono" class="form-control">
                        </div>
                    </div>

                    <div class="text-center mt-4">
                        <button type="submit" class="btn-metalico w-100 mb-3 py-2">CREAR CUENTA</button>
                        <button type="reset" class="btn btn-outline-secondary w-100" style="color: #ccc; border-color: #555;">LIMPIAR FORMULARIO</button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <footer-bar></footer-bar>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/cabecera.js"></script>
    <script src="js/footer.js"></script>
</body>
</html>