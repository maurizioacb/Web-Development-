<?php
session_start();
require_once(__DIR__ . '/../modelo/libBD.php');

if (!isset($_SESSION['sesion']) || $_SESSION['sesion'] !== true) {
    header('Location: ../login.php');
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $codigo = filter_input(INPUT_POST, 'codUsu', FILTER_VALIDATE_INT);
    $nombre = filter_input(INPUT_POST, 'nombre');
    $apellidos = filter_input(INPUT_POST, 'apellidos');

    if ($codigo !== false && $nombre && $apellidos) {
        actualizarUsuario($codigo, $nombre, $apellidos);
        header('Location: ../usuarios.php?msg=usuario_actualizado');
        exit();
    }
}

header('Location: ../usuarios.php');
exit();
?>