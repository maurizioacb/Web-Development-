<?php
session_start();
if (!isset($_SESSION['admin_userid'])) {
    header('Location: ../index.php');
    exit();
}

require_once(__DIR__ . '/../modelo/libBD.php');

$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);

if ($id !== false) {
    if (!usuarioEnPedidos($id)) {
        borrarUsuario($id);
        header('Location: ../usuarios.php');
    } else {
        header('Location: ../usuarios.php?error=tiene_pedidos');
    }
    exit();
}

header('Location: ../usuarios.php');
exit();