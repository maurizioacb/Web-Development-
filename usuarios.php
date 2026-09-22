<?php
session_start();

if (!isset($_SESSION['sesion']) || $_SESSION['sesion'] !== true) {
    header('Location: ./login.php');
    exit();
}

require_once(__DIR__ . '/modelo/libBD.php');
$listaUsuarios = getUsuarios();
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel - Gestión de Usuarios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="bg-dark text-white">
    
    <nav class="navbar navbar-expand-lg navbar-dark bg-black border-bottom border-secondary">
        <div class="container-fluid px-4">
            <div class="navbar-nav w-100 d-flex gap-3">
                <a class="nav-link active text-warning fw-bold" href="usuarios.php">Usuarios</a>
                <a class="nav-link" href="productos.php">Productos</a>
                <a class="nav-link" href="pedidos.php">Pedidos</a>
                <a class="nav-link text-danger ms-auto fw-bold" href="controlador/logout.php">Cerrar sesión</a>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <h2 class="text-center text-warning text-uppercase mb-4">Manejo de Usuarios</h2>

        <?php if (isset($_GET['msg'])): ?>
            <?php if ($_GET['msg'] === 'borrado_completo'): ?>
                <div class="alert alert-success text-center shadow fw-bold">¡Usuario eliminado por completo!</div>
            <?php elseif ($_GET['msg'] === 'desactivado_por_pedidos'): ?>
                <div class="alert alert-warning text-center shadow fw-bold text-dark">Tiene pedidos asociados. Se dejó inactivo.</div>
            <?php elseif ($_GET['msg'] === 'activado'): ?>
                <div class="alert alert-info text-center shadow fw-bold text-dark">¡Usuario activado correctamente!</div>
            <?php elseif ($_GET['msg'] === 'usuario_actualizado'): ?>
                <div class="alert alert-success text-center shadow fw-bold text-dark">¡Datos del cliente actualizados!</div>
            <?php endif; ?>
        <?php endif; ?>

        <div class="table-responsive shadow-lg rounded border border-secondary mb-5">
            <table class="table table-dark table-hover text-center align-middle mb-0">
                <thead class="table-active border-bottom border-secondary">
                    <tr>
                        <th>ID</th>
                        <th>Usuario</th>
                        <th>Nombre</th>
                        <th>Apellidos</th>
                        <th>Privilegios</th>
                        <th>Historial</th>
                        <th>Estado</th>
                        <th>Acción</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($listaUsuarios as $u): 
                        $nivel = (int)$u['nivel'];
                        $esAdmin = ($nivel === 1);
                        $estaActivo = ($nivel !== 0); 
                        $tienePedidos = usuarioEnPedidos((int)$u['codigo']);
                    ?>
                        <tr>
                            <td class="text-info font-monospace">#<?= htmlspecialchars($u['codigo']) ?></td>
                            <td><strong><?= htmlspecialchars($u['usuario']) ?></strong></td>
                            <td><?= htmlspecialchars($u['nombre']) ?></td>
                            <td><?= htmlspecialchars($u['apellidos']) ?></td>
                            
                            <td>
                                <?= $esAdmin ? '<span class="badge bg-warning text-black fw-bold">ADMIN</span>' : '<span class="badge bg-secondary">CLIENTE</span>' ?>
                            </td>

                            <td>
                                <?= $tienePedidos ? '<span class="badge bg-danger p-2">Con Pedidos en curso</span>' : '<span class="badge bg-success p-2">Sin Pedidos en curso</span>' ?>
                            </td>

                            <td>
                                <?= $estaActivo ? '<span class="text-success fw-bold">Activo</span>' : '<span class="text-danger fw-bold">Inactivo</span>' ?>
                            </td>

                            <td>
                                <?php if (!$esAdmin): ?>
                                    <div class="d-flex gap-2 justify-content-center">
                                        <button type="button" class="btn btn-sm btn-primary fw-bold" data-bs-toggle="modal" data-bs-target="#modalEditar<?= $u['codigo'] ?>">
                                            Editar
                                        </button>

                                        <form method="POST" action="controlador/changeActive.php" style="margin: 0;">
                                            <input type="hidden" name="codUsu" value="<?= $u['codigo'] ?>">
                                            <?php if ($estaActivo): ?>
                                                <input type="hidden" name="nuevoEstado" value="0">
                                                <button type="submit" class="btn btn-sm btn-danger fw-bold" onclick="return confirm('<?= $tienePedidos ? '¿Desactivar usuario (tiene pedidos)?' : '¿Eliminar usuario?' ?>');">Baja</button>
                                            <?php else: ?>
                                                <input type="hidden" name="nuevoEstado" value="2">
                                                <button type="submit" class="btn btn-sm btn-success fw-bold">Activar</button>
                                            <?php endif; ?>
                                        </form>
                                    </div>

                                    <div class="modal fade text-start" id="modalEditar<?= $u['codigo'] ?>" tabindex="-1" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content bg-dark border-secondary">
                                                <div class="modal-header border-secondary">
                                                    <h5 class="modal-title text-warning"> Editar a <?= htmlspecialchars($u['usuario']) ?></h5>
                                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <form method="POST" action="controlador/changeUser.php">
                                                    <div class="modal-body">
                                                        <input type="hidden" name="codUsu" value="<?= $u['codigo'] ?>">
                                                        <div class="mb-3">
                                                            <label class="form-label text-info">Nombre</label>
                                                            <input type="text" name="nombre" class="form-control bg-black text-white border-secondary" value="<?= htmlspecialchars($u['nombre']) ?>" required>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label text-info">Apellidos</label>
                                                            <input type="text" name="apellidos" class="form-control bg-black text-white border-secondary" value="<?= htmlspecialchars($u['apellidos']) ?>" required>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer border-secondary">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                        <button type="submit" class="btn btn-primary fw-bold">Guardar Cambios</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                <?php else: ?>
                                    <span class="text-muted small">Intocable</span>
                                <?php endif; ?>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>