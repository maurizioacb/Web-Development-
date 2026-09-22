<?php
session_start();

if (!isset($_SESSION['sesion']) || $_SESSION['sesion'] !== true) {
    header('Location: ./login.php');
    exit();
}

require_once(__DIR__ . '/modelo/libBD.php');

$error = "";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $titulo = filter_input(INPUT_POST, 'titulo');
    $descripcion = filter_input(INPUT_POST, 'descripcion');
    $precio = filter_input(INPUT_POST, 'precio', FILTER_VALIDATE_FLOAT);
    $existencias = filter_input(INPUT_POST, 'existencias', FILTER_VALIDATE_INT);
    $imagen = filter_input(INPUT_POST, 'imagen');
    $categoria = filter_input(INPUT_POST, 'categoria', FILTER_VALIDATE_INT);

    if ($titulo && $descripcion && $precio !== false && $existencias !== false && $categoria) {
        $ok = insertarProducto($titulo, $descripcion, $precio, $existencias, $imagen, $categoria);
        if ($ok) {
            header('Location: ./productos.php?msg=insertado'); 
            exit();
        } else {
            $error = "Error interno al registrar el artículo.";
        }
    } else {
        $error = "Todos los campos son requeridos y el precio/stock deben ser numéricos.";
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Administración - Insertar Producto</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark text-white">

    <div class="container mt-5" style="max-width: 800px;">
        <h2 class="text-center text-warning mb-4 text-uppercase">Añadir Nuevo Producto</h2>
        
        <?php if (!empty($error)): ?>
            <div class="alert alert-danger text-center shadow fw-bold"><?= $error ?></div>
        <?php endif; ?>
        
        <form method="post" action="insertar.php" class="card bg-black border-secondary p-4 shadow-lg">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label text-info fw-bold">Nombre del Producto</label>
                    <input type="text" name="titulo" class="form-control bg-dark text-white border-secondary" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label text-info fw-bold">Categoría</label>
                    <select name="categoria" class="form-control bg-dark text-white border-secondary" required>
                        <option value="1">Partes de Arriba</option>
                        <option value="2">Partes de Abajo</option>
                        <option value="3">Accesorios</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label text-info fw-bold">Precio (€)</label>
                    <input type="number" name="precio" class="form-control bg-dark text-white border-secondary" step="0.01" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label text-info fw-bold">Stock Inicial</label>
                    <input type="number" name="existencias" class="form-control bg-dark text-white border-secondary" required>
                </div>
                <div class="col-12">
                    <label class="form-label text-info fw-bold">Nombre de la Imagen (ej: reloj.png)</label>
                    <input type="text" name="imagen" class="form-control bg-dark text-white border-secondary" value="img/" required>
                </div>
                <div class="col-12">
                    <label class="form-label text-info fw-bold">Descripción</label>
                    <textarea name="descripcion" class="form-control bg-dark text-white border-secondary" rows="2" required></textarea>
                </div>
            </div>

            <div class="mt-4 d-flex gap-3 justify-content-center">
                <button type="submit" class="btn btn-warning fw-bold px-4">Guardar Producto</button>
                <a href="productos.php" class="btn btn-secondary fw-bold px-4">Volver Atrás</a>
            </div>
        </form>
    </div>
</body>
</html>