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
    <title>Editar Perfil - Luxury ETSE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="d-flex flex-column min-vh-100">

    <barra-nav></barra-nav>

    <main class="container my-5 flex-grow-1">
        <h1 class="text-center">EDITAR CUENTA</h1>
        
        <div class="row justify-content-center mt-5">
            <div class="col-lg-8">
                <%-- IMPORTANTE: Cambiamos a un FORM real para enviar los datos --%>
                <form action="actualizarPerfil" method="POST">
                    <div class="table-responsive shadow-lg">
                        <table class="table table-dark-luxury align-middle">
                            <tbody> 
                                <%-- CAMPO BLOQUEADO: El usuario no se toca --%>
                                <tr class="opacity-75">
                                    <th>USUARIO (Login):</th>
                                    <td>
                                        <input type="text" name="usuario" class="form-control bg-dark text-info border-secondary" 
                                            value="<%= perfil.getOrDefault("usuario", "tiguere_vip") %>" readonly>
                                        <small class="text-muted" style="font-size: 0.7rem;">* Este campo no es editable por seguridad.</small>
                                    </td>
                                </tr>

                                <%-- CAMPOS EDITABLES --%>
                                <tr><th>NOMBRE:</th><td><input type="text" name="nombre" class="form-control" value="<%= perfil.getOrDefault("nombre", "") %>"></td></tr>
                                <tr><th>APELLIDOS:</th><td><input type="text" name="apellidos" class="form-control" value="<%= perfil.getOrDefault("apellidos", "") %>"></td></tr>
                                <tr><th>DNI:</th><td><input type="text" name="dni" class="form-control" value="<%= perfil.getOrDefault("dni", "") %>"></td></tr>
                                <tr><th>DOMICILIO:</th><td><input type="text" name="direccion" class="form-control" value="<%= perfil.getOrDefault("direccion", "") %>"></td></tr>
                                <tr><th>POBLACIÓN:</th><td><input type="text" name="poblacion" class="form-control" value="<%= perfil.getOrDefault("poblacion", "") %>"></td></tr>
                                <tr><th>PROVINCIA:</th><td><input type="text" name="provincia" class="form-control" value="<%= perfil.getOrDefault("provincia", "") %>"></td></tr>
                                <tr><th>TELÉFONO:</th><td><input type="text" name="telefono" class="form-control" value="<%= perfil.getOrDefault("telefono", "") %>"></td></tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="d-flex justify-content-center gap-3 mt-4">
                        <button type="submit" class="btn-metalico">GUARDAR CAMBIOS</button>
                        <a href="usuario.jsp" class="btn-metalico" style="opacity: 0.7; text-decoration: none;">CANCELAR</a>
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