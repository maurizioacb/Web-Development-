<?php
session_start();

if (!isset($_SESSION['sesion']) || $_SESSION['sesion'] !== true) {
    header('Location: ../login.php');
    exit();
}

require_once(__DIR__ . '/../modelo/libBD.php');

$codigo = filter_input(INPUT_POST, 'codigo');
$titulo = filter_input(INPUT_POST, 'titulo');
$descripcion = filter_input(INPUT_POST, 'descripcion');
$precio = filter_input(INPUT_POST, 'precio', FILTER_VALIDATE_FLOAT);
$existencias = filter_input(INPUT_POST, 'existencias', FILTER_VALIDATE_INT);
$imagen = filter_input(INPUT_POST, 'imagen');
$categoria = filter_input(INPUT_POST, 'categoria');

if ($codigo && $titulo && $descripcion && $precio !== false && $existencias !== false) {
    actualizarProducto($codigo, $titulo, $descripcion, $precio, $existencias, $imagen, $categoria);
    header('Location: ../productos.php?msg=actualizado');
} else {
    header('Location: ../productos.php');
}
exit();
?>