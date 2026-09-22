<?php
session_start();
require_once(__DIR__ . '/../modelo/libBD.php');

if (!isset($_SESSION['sesion']) || $_SESSION['sesion'] !== true) {
    header('Location: ../login.php');
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $codigoUsuario = filter_input(INPUT_POST, 'codUsu', FILTER_VALIDATE_INT);
    $nuevoEstado = filter_input(INPUT_POST, 'nuevoEstado', FILTER_VALIDATE_INT);
    
    if ($codigoUsuario !== false && $nuevoEstado !== false) {
        
        if ($nuevoEstado === 0) {
            if (!usuarioEnPedidos($codigoUsuario)) {
                borrarUsuario($codigoUsuario);
                header('Location: ../usuarios.php?msg=borrado_completo');
                exit();
            } else {
                cambiarActivoUsuario($codigoUsuario, 0);
                header('Location: ../usuarios.php?msg=desactivado_por_pedidos');
                exit();
            }
        } else {
            cambiarActivoUsuario($codigoUsuario, $nuevoEstado);
            header('Location: ../usuarios.php?msg=activado');
            exit();
        }
    }
}

header('Location: ../usuarios.php');
exit();
?>