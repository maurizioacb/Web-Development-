<?php
// pedidos.php
session_start();

if (!isset($_SESSION['sesion']) || $_SESSION['sesion'] !== true) {
    header('Location: ./login.php');
    exit();
}

require_once(__DIR__ . '/modelo/libBD.php');

// Recogemos los campos del formulario por GET de manera limpia
$f_user = filter_input(INPUT_GET, 'f_usuario') ?? '';
$f_prod = filter_input(INPUT_GET, 'f_producto') ?? '';
$f_igual = filter_input(INPUT_GET, 'f_igual') ?? '';
$f_menor = filter_input(INPUT_GET, 'f_menor') ?? '';
$f_mayor = filter_input(INPUT_GET, 'f_mayor') ?? '';

// Cargamos la lista aplicando los filtros avanzados cruzados de la BBDD
$listaPedidos = getPedidosFiltrados($f_user, $f_prod, $f_igual, $f_menor, $f_mayor);

// Cargamos opciones para los desplegables (Punto de rúbrica)
$estadosDisponibles = getEstados(); 
$listaUsuarios = getUsuarios();
$listaProductos = getProductos();
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administración - Pedidos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-dark text-white">

    <nav class="navbar navbar-expand-lg navbar-dark bg-black border-bottom border-secondary">
        <div class="container-fluid px-4">
            <div class="navbar-nav w-100 d-flex gap-3">
                <a class="nav-link" href="usuarios.php">Usuarios</a>
                <a class="nav-link" href="productos.php">Productos</a>
                <a class="nav-link active text-warning fw-bold" href="pedidos.php">Pedidos</a>
                <a class="nav-link text-danger ms-auto fw-bold" href="controlador/logout.php">Cerrar sesión</a>
            </div>
        </div>
    </nav>

    <div class="container-fluid px-4 mt-5 mb-5">
        <h2 class="text-center text-warning mb-4 text-uppercase">Gestión de Pedidos</h2>

        <!-- Alertas de los Controladores -->
        <?php if (isset($_GET['msg']) && $_GET['msg'] === 'estado_actualizado'): ?>
            <div class="alert alert-success text-center shadow fw-bold">¡Estado del pedido actualizado y notificado!</div>
        <?php elseif (isset($_GET['msg']) && $_GET['msg'] === 'pedido_eliminado'): ?>
            <div class="alert alert-danger text-center shadow fw-bold">¡Pedido cancelado borrado del sistema limpiamente!</div>
        <?php endif; ?>

        <h4 class="mt-4 text-info"><i class="fas fa-filter me-2"></i>Filtrar Pedidos</h4>
        <form method="get" action="pedidos.php" class="row g-3 mb-4 bg-black p-3 rounded border border-secondary shadow">
            <div class="col-md-2">
                <label class="form-label small fw-bold text-secondary">Usuario</label>
                <!-- Convertido a desplegable -->
                <select name="f_usuario" class="form-select bg-dark text-white border-secondary form-select-sm">
                    <option value="">Todos los usuarios</option>
                    <?php foreach ($listaUsuarios as $u): ?>
                        <option value="<?= htmlspecialchars($u['usuario']) ?>" <?= $f_user === $u['usuario'] ? 'selected' : '' ?>>
                            <?= htmlspecialchars($u['usuario']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label small fw-bold text-secondary">Producto</label>
                <!-- Convertido a desplegable -->
                <select name="f_producto" class="form-select bg-dark text-white border-secondary form-select-sm">
                    <option value="">Todos los productos</option>
                    <?php foreach ($listaProductos as $p): ?>
                        <option value="<?= htmlspecialchars($p['titulo']) ?>" <?= $f_prod === $p['titulo'] ? 'selected' : '' ?>>
                            <?= htmlspecialchars($p['titulo']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label small fw-bold text-secondary">Fecha (=)</label>
                <input type="date" name="f_igual" class="form-control bg-dark text-white border-secondary form-control-sm" value="<?= htmlspecialchars($f_igual) ?>">
            </div>
            <div class="col-md-2">
                <label class="form-label small fw-bold text-secondary">Fecha (≤ Menor)</label>
                <input type="date" name="f_menor" class="form-control bg-dark text-white border-secondary form-control-sm" value="<?= htmlspecialchars($f_menor) ?>">
            </div>
            <div class="col-md-2">
                <label class="form-label small fw-bold text-secondary">Fecha (≥ Mayor)</label>
                <input type="date" name="f_mayor" class="form-control bg-dark text-white border-secondary form-control-sm" value="<?= htmlspecialchars($f_mayor) ?>">
            </div>
            <div class="col-md-2 d-flex align-items-end gap-2">
                <button type="submit" class="btn btn-warning btn-sm w-100 fw-bold">Filtrar</button>
                <a href="pedidos.php" class="btn btn-outline-secondary btn-sm w-100">Limpiar</a>
            </div>
        </form>

        <div class="table-responsive shadow-lg rounded border border-secondary">
            <table class="table table-dark table-hover align-middle text-center mb-0">
                <thead class="table-active border-bottom border-secondary">
                    <tr>
                        <th>Pedido #</th>
                        <th>Usuario</th>
                        <th class="text-start">Detalle de Productos</th>
                        <th>Fecha</th>
                        <th>Importe Total</th>
                        <th>Estado Actual</th>
                        <th>Acción</th> <!-- Nueva columna pa' borrar -->
                    </tr>
                </thead>
                <tbody>
                    <?php if (empty($listaPedidos)): ?>
                        <tr><td colspan="7" class="text-warning py-4 fw-bold">No hay registros con los filtros seleccionados.</td></tr>
                    <?php else: ?>
                        <?php foreach ($listaPedidos as $ped): ?>
                            <tr>
                                <td class="font-monospace text-info fs-5">#<?= $ped['codigo'] ?></td>
                                <td><strong><?= htmlspecialchars($ped['nombre_usuario']) ?></strong></td>
                                <td class="text-start small">
                                    <ul class="mb-0 ps-3">
                                        <?php 
                                        $articulos = getDetalle((int)$ped['codigo']);
                                        foreach ($articulos as $art):
                                        ?>
                                            <li>
                                                <span class="text-warning fw-bold"><?= $art['unidades'] ?>x</span> 
                                                <?= htmlspecialchars($art['titulo']) ?> 
                                                <span class="text-muted font-monospace">(<?= number_format($art['precio_unitario'], 2) ?>€/u)</span>
                                            </li>
                                        <?php endforeach; ?>
                                    </ul>
                                </td>
                                <td><?= date('d/m/Y', strtotime($ped['fecha'])) ?></td>
                                <td class="text-success fw-bold fs-6"><?= number_format($ped['importe'], 2) ?>€</td>
                                <td>
                                    <!-- El desplegable que cambia el estado solo con tocarlo -->
                                    <form method="post" action="controlador/changeEstado.php" style="margin:0;">
                                        <input type="hidden" name="id_pedido" value="<?= $ped['codigo'] ?>">
                                        <select name="nuevo_estado" class="form-select form-select-sm bg-dark text-white border-secondary text-center fw-bold" onchange="this.form.submit()">
                                            <?php foreach ($estadosDisponibles as $est): ?>
                                                <option value="<?= $est['codigo'] ?>" <?= (int)$ped['estado'] === (int)$est['codigo'] ? 'selected' : '' ?>>
                                                    <?= htmlspecialchars($est['descripcion']) ?>
                                                </option>
                                            <?php endforeach; ?>
                                        </select>
                                    </form>
                                </td>
                                <td>
                                    <!-- Regla del profe: Solo se puede eliminar si está CANCELADO (Asumimos ID 2 = Cancelado) -->
                                    <?php if ((int)$ped['estado'] === 2): ?>
                                        <a href="controlador/eliminarPedido.php?id=<?= $ped['codigo'] ?>" class="btn btn-sm btn-danger fw-bold shadow" onclick="return confirm('¿Seguro que quieres borrar este pedido cancelado para siempre?');">
                                            Eliminar
                                        </a>
                                    <?php else: ?>
                                        <span class="badge bg-secondary text-dark">Protegido</span>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>