<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administración - Iniciar Sesión</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body class="admin-login d-flex align-items-center justify-content-center vh-100">
    <div class="card p-4 shadow" style="width: 300px;">
        <h4 class="text-center">Iniciar Sesión</h4>
        <form>
            <div class="mb-3">
                <label for="usuario" class="form-label">Usuario:</label>
                <input type="text" class="form-control" id="usuario" placeholder="Ingrese su usuario">
            </div>
            <div class="mb-3">
                <label for="clave" class="form-label">Clave:</label>
                <input type="password" class="form-control" id="clave" placeholder="Ingrese su clave">
            </div>
            <div class="d-flex justify-content-center">
                <button type="button" class="btn btn-principal" onclick="window.location.href='usuarios.html';">Acceder</button>
            </div>
        </form>
    </div>
</body>
</html>