<?php
session_start(); 
require_once(__DIR__ . '/../modelo/libBD.php');

$usuarioInput = filter_input(INPUT_POST, 'usuario');
$claveInput = filter_input(INPUT_POST, 'clave');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (empty($usuarioInput) || empty($claveInput)) {
        header('Location: ../login.php?error=vacio');
        exit();
    }

    $resultado = getClaveBD($usuarioInput);

    if ($resultado != null) {
        $fila = mysqli_fetch_assoc($resultado);
        $claveBaseDatos = $fila['clave'];
        $nivelUsuario = isset($fila['nivel']) ? (int)$fila['nivel'] : 0;

        if ($claveInput === $claveBaseDatos) {
            if ($nivelUsuario === 1) {
                $_SESSION['sesion'] = true;
                $_SESSION['usuario'] = $usuarioInput;
                $_SESSION['admin_userid'] = $usuarioInput;
                
                header("Location: ../usuarios.php"); 
                exit();
            }
        }
    }
    header('Location: ../login.php?error=bloqueado');
    exit();
}
?>