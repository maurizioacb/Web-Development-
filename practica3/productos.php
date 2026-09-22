<?php
session_start();

if (!isset($_SESSION['sesion']) || $_SESSION['sesion'] !== true) {
    header('Location: ./login.php');
    exit();
}

require_once(__DIR__ . '/modelo/libBD.php');

$mensaje = "";
$error = "";

if (isset($_GET['msg'])) {
    if ($_GET['msg'] === 'insertado') {
        $mensaje = "¡Producto añadido con éxito a la base de datos!";
    } elseif ($_GET['msg'] === 'borrado') {
        $mensaje = "Producto eliminado del catálogo correctamente.";
    } elseif ($_GET['msg'] === 'actualizado') {
        $mensaje = "¡Producto actualizado nítido!";
    }
}
if (isset($_GET['error']) && $_GET['error'] === 'tiene_pedidos') {
    $error = "No se puede eliminar este producto porque se encuentra en algún pedido en curso.";
}

$listaProductos = getProductos();
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Administración - Productos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-dark text-white">

    <nav class="navbar navbar-expand-lg navbar-dark bg-black border-bottom border-secondary">
        <div class="container-fluid px-4">
            <div class="navbar-nav w-100 d-flex gap-3">
                <a class="nav-link" href="usuarios.php">Usuarios</a>
                <a class="nav-link active text-warning fw-bold" href="productos.php">Productos</a>
                <a class="nav-link" href="pedidos.php">Pedidos</a>
                <a class="nav-link text-danger ms-auto fw-bold" href="controlador/logout.php">Cerrar sesión</a>
            </div>
        </div>
    </nav>

    <div class="container-fluid px-4 mt-5 mb-5">
        <h2 class="text-center text-warning mb-4 text-uppercase">Gestión de Productos</h2>
        
        <?php if (!empty($mensaje)): ?>
            <div class="alert alert-success text-center shadow fw-bold"><?= $mensaje ?></div>
        <?php endif; ?>
        <?php if (!empty($error)): ?>
            <div class="alert alert-danger text-center shadow fw-bold"><?= $error ?></div>
        <?php endif; ?>
        
        <div class="table-responsive shadow-lg rounded border border-secondary">
            <table class="table table-dark table-hover align-middle text-center mb-0">
                <thead class="table-active border-bottom border-secondary">
                    <tr>
                        <th>ID</th>
                        <th>Foto</th>
                        <th>Ruta Imagen</th> <th>Categoría</th> <th>Nombre</th>
                        <th>Descripción</th>
                        <th>Precio (€)</th>
                        <th>Stock</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($listaProductos as $p): 
                        $tienePedidos = productoEnPedidos($p['codigo']);
                    ?>
                        <tr>
                            <form method="POST" action="controlador/changeProduct.php">
                                <td>
                                    <input type="text" name="codigo" value="<?= $p['codigo'] ?>" class="form-control bg-secondary text-white border-0 text-center" style="width: 50px;" readonly>
                                </td>

                                <td>
                                    <img src="<?= htmlspecialchars($p['imagen']) ?>" alt="Producto" class="rounded border border-secondary shadow-sm" style="width: 80px; height: 80px; object-fit: cover;">
                                </td>
                                
                                <td>
                                    <input type="text" name="imagen" value="<?= htmlspecialchars($p['imagen']) ?>" class="form-control bg-dark text-white border-secondary text-center" style="min-width: 120px;">
                                </td>

                                <td>
                                    <select name="categoria" class="form-select bg-dark text-white border-secondary" style="min-width: 160px;">
                                        <option value="1" <?= $p['categoria'] == 1 ? 'selected' : '' ?>>Partes de Arriba</option>
                                        <option value="2" <?= $p['categoria'] == 2 ? 'selected' : '' ?>>Partes de Abajo</option>
                                        <option value="3" <?= $p['categoria'] == 3 ? 'selected' : '' ?>>Accesorios</option>
                                    </select>
                                </td>
                                
                                <td>
                                    <input type="text" name="titulo" value="<?= htmlspecialchars($p['titulo']) ?>" class="form-control bg-dark text-white border-secondary" style="min-width: 150px;">
                                </td>
                                
                                <td>
                                    <input type="text" name="descripcion" value="<?= htmlspecialchars($p['descripcion']) ?>" class="form-control bg-dark text-white border-secondary" style="min-width: 180px;">
                                </td>
                                
                                <td>
                                    <input type="number" name="precio" value="<?= $p['precio'] ?>" step="0.01" class="form-control bg-dark text-white border-secondary text-center" style="width: 85px;">
                                </td>
                                
                                <td>
                                    <input type="number" name="existencias" value="<?= $p['existencias'] ?>" class="form-control bg-dark text-white border-secondary text-center" style="width: 80px;">
                                </td>
                                
                                <td>
                                    <?php if ($tienePedidos): ?>
                                        <span class="badge bg-danger p-2 text-uppercase" style="font-size: 10px;">En Pedidos en curso</span>
                                    <?php else: ?>
                                        <span class="badge bg-success p-2 text-uppercase" style="font-size: 10px;">Libre de pedidos</span>
                                    <?php endif; ?>
                                </td>
                                
                                <td>
                                    <div class="d-flex gap-2 justify-content-center">
                                        <button type="submit" class="btn btn-sm btn-success fw-bold">Actualizar</button>
                                        
                                        <a href="controlador/eliminarProducto.php?id=<?= $p['codigo'] ?>" 
                                           class="btn btn-sm btn-danger fw-bold"
                                           onclick="return confirm('<?= $tienePedidos ? 'Este artículo está enlazado a pedidos en curso. ' : '¿Seguro que quieres quitar este artículo del catálogo?' ?>')">
                                           Borrar
                                        </a>
                                    </div>
                                </td>
                            </form>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>

        <div class="mt-4 text-start">
            <a href="insertar.php" class="btn btn-warning fw-bold px-4 py-2">
                <i class="fas fa-plus-circle me-2"></i>Añadir Producto
            </a>
        </div>
    </div>
</body>
</html>