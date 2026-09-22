<?php
// login.php (En la raíz del proyecto)
session_start();

// Si el tiguere ya se logueó, no lo dejamos volver a ver el login
if (isset($_SESSION['sesion']) && $_SESSION['sesion'] === true) {
    header('Location: ./usuarios.php');
    exit();
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Tienda Luxury - Acceso Mantenimiento</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-black text-white d-flex align-items-center justify-content-center" style="height: 100vh;">
    <div class="card bg-dark border-secondary p-4 shadow-lg" style="width: 400px;">
        <h3 class="text-warning text-center text-uppercase mb-4">Administración VIP</h3>
        
        <?php if (isset($_GET['error'])): ?>
            <div class="alert alert-danger text-center small"> Usuario, contraseña incorrectos o cuenta sin permisos de administrador.</div>
        <?php endif; ?>

        <form method="post" action="controlador/login.php">
            <div class="mb-3">
                <label class="form-label text-info fw-bold">Usuario</label>
                <input type="text" name="usuario" class="form-control bg-black text-white border-secondary" required>
            </div>
            <div class="mb-4">
                <label class="form-label text-info fw-bold">Contraseña</label>
                <input type="password" name="clave" class="form-control bg-black text-white border-secondary" required>
            </div>
            <button type="submit" class="btn btn-outline-warning w-100 fw-bold text-uppercase">Entrar al panel</button>
        </form>
    </div>
</body>
</html>