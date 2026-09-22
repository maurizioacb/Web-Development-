<?php
session_start();

if (isset($_SESSION['sesion']) && $_SESSION['sesion'] === true) {
    header('Location: ./usuarios.php');
} else {
    header('Location: ./login.php'); 
}
exit();
?>