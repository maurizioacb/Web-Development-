<?php
session_start();

if (!isset($_SESSION['sesion']) || $_SESSION['sesion'] !== true) {
    header('Location: ../login.php');
    exit();
}

require_once(__DIR__ . '/../modelo/libBD.php');

$idPed = filter_input(INPUT_POST, 'id_pedido', FILTER_VALIDATE_INT);
$nuevoEst = filter_input(INPUT_POST, 'nuevo_estado', FILTER_VALIDATE_INT);

if ($idPed !== false && $nuevoEst !== false) {
    if ($nuevoEst === 2) { 
        restaurarStockPedido($idPed);
    }
    cambiarEstadoPedido($idPed, $nuevoEst);
    header('Location: ../pedidos.php?msg=estado_actualizado');
    exit();
}

header('Location: ../pedidos.php');
exit();
?>