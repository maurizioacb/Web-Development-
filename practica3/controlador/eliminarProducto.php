<?php
session_start();

if (!isset($_SESSION['sesion']) || $_SESSION['sesion'] !== true) {
    header('Location: ../login.php');
    exit();
}

require_once(__DIR__ . '/../modelo/libBD.php');

$id = filter_input(INPUT_GET, 'id');

if ($id !== null && $id !== false) {
    if (!productoEnPedidos($id)) {
        borrarProducto($id);
        header('Location: ../productos.php?msg=borrado');
    } else {
        header('Location: ../productos.php?error=tiene_pedidos');
    }
    exit();
}

header('Location: ../productos.php');
exit();
?>