<?php
// controlador/eliminarPedido.php
session_start();

if (!isset($_SESSION['sesion']) || $_SESSION['sesion'] !== true) {
    header('Location: ../login.php');
    exit();
}

require_once(__DIR__ . '/../modelo/libBD.php');

$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);

if ($id !== false) {
    eliminarPedido($id);
    header('Location: ../pedidos.php?msg=pedido_eliminado');
    exit();
}

header('Location: ../pedidos.php');
exit();
?>