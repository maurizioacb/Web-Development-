<?php
// modelo/libBD.php

// =========================================================================
// 1. FUNCIONES CORE DE CONEXIÓN
// =========================================================================

function conectar(){
    $SERVER = "127.0.0.1"; // El truquito pa' que no falle en Windows
    $BBDD = "daw";
    $BBDD_CHARSET = "utf8";
    $USER = "root";
    $PASS = "DawLab"; // Si falla, prueba dejándolo vacío: ""

    $bbdd = mysqli_connect($SERVER, $USER, $PASS, $BBDD);

    if(mysqli_connect_error()){
        echo "Error conectando a la base de datos: " . mysqli_connect_error();
        exit();
    } else {
        // ¡Esta es la línea clave pa' saber si coronamos!
        //echo "¡Klk compai! Conexión a la base de datos '$BBDD' exitosa. Tamo ready.";
    }

    // Retornamos la variable para poder usar la conexión en otros archivos
    return $bbdd; 
}

//conectar(); // Llamada inicial para probar la conexión al cargar el archivo


function desconectar($bbdd){
    mysqli_close($bbdd);
}

// =========================================================================
// 2. SEGURIDAD Y ACCESO (LOGIN)
// =========================================================================

function getClaveBD($usuario){
    $bbdd = conectar();
    $resultado = null;
    
    // Consulta preparada adaptada a tus columnas reales: clave y nivel
    $consulta = mysqli_prepare($bbdd, "SELECT clave, nivel FROM usuarios WHERE usuario=?");
    if($consulta){
        mysqli_stmt_bind_param($consulta, "s", $usuario);
        mysqli_stmt_execute($consulta);
        $resultado = mysqli_stmt_get_result($consulta);
        mysqli_stmt_close($consulta);
    }
    desconectar($bbdd);
    return $resultado;
}

// =========================================================================
// 3. GESTIÓN DE USUARIOS
// =========================================================================

function getUsuarios(): array {
    $bbdd = conectar();
    $usuarios = [];
    // Mapeado a tus campos reales: codUsu y nivel
    $sql = "SELECT codUsu AS codigo, usuario, nombre, apellidos, nivel FROM usuarios";

    if ($consulta = mysqli_prepare($bbdd, $sql)) {
        mysqli_stmt_execute($consulta);
        $res = mysqli_stmt_get_result($consulta);
        while ($fila = mysqli_fetch_assoc($res)) {
            $usuarios[] = $fila;
        }
        mysqli_stmt_close($consulta);
        mysqli_free_result($res);
    }
    desconectar($bbdd);
    return $usuarios;
}

function cambiarActivoUsuario(int $codigoUsuario, int $nuevoEstado): bool {
    $bbdd = conectar();
    $cambiar = false;
    // Como no tienes campo activo, usamos la columna nivel (NULL o 0 = Inactivo, 1 = Activo)
    $sql = "UPDATE usuarios SET nivel = ? WHERE codUsu = ?";

    if ($consulta = mysqli_prepare($bbdd, $sql)) {
        mysqli_stmt_bind_param($consulta, "ii", $nuevoEstado, $codigoUsuario);
        $cambiar = mysqli_stmt_execute($consulta);
        $consulta->close();
    }
    desconectar($bbdd);
    return $cambiar;
}

function actualizarUsuario(int $codigo, string $nombre, string $apellidos): bool {
    $bbdd = conectar();
    $actualizar = false;
    $sql = "UPDATE usuarios SET nombre = ?, apellidos = ? WHERE codUsu = ?";

    if ($consulta = mysqli_prepare($bbdd, $sql)) {
        mysqli_stmt_bind_param($consulta, "ssi", $nombre, $apellidos, $codigo);
        $actualizar = mysqli_stmt_execute($consulta);
        mysqli_stmt_close($consulta);
    }
    desconectar($bbdd);
    return $actualizar;
}

function usuarioEnPedidos(int $codigoUsuario): bool {
    $bbdd = conectar();
    $tiene = false;
    // Adaptado a tu columna real: codUsu
    $sql = "SELECT COUNT(*) AS cnt FROM pedidos WHERE codUsu = ?";
    if ($consulta = mysqli_prepare($bbdd, $sql)) {
        mysqli_stmt_bind_param($consulta, "i", $codigoUsuario);
        mysqli_stmt_execute($consulta);
        mysqli_stmt_bind_result($consulta, $cnt);
        if (mysqli_stmt_fetch($consulta)) {
            $tiene = ($cnt > 0);
        }
        mysqli_stmt_close($consulta);
    }
    desconectar($bbdd);
    return $tiene;
}

function borrarUsuario(int $codigoUsuario): bool {
    $bbdd = conectar();
    $borrar = false;
    $sql = "DELETE FROM usuarios WHERE codUsu = ?";
    
    if ($consulta = mysqli_prepare($bbdd, $sql)) {
        mysqli_stmt_bind_param($consulta, "i", $codigoUsuario);
        $borrar = mysqli_stmt_execute($consulta);
        mysqli_stmt_close($consulta);
    }
    desconectar($bbdd);
    return $borrar;
}

// =========================================================================
// 4. GESTIÓN DE PEDIDOS
// =========================================================================

function getPedidos(): array {
    $bbdd = conectar();
    $pedidos = [];
    // Adaptado a tus columnas reales: codPed, codUsu y estado
    $sql = "SELECT p.codPed AS codigo, u.usuario AS nombre_usuario, p.fecha, p.importe, p.estado
            FROM pedidos p
            JOIN usuarios u ON p.codUsu = u.codUsu";

    if ($consulta = mysqli_prepare($bbdd, $sql)) {
        mysqli_stmt_execute($consulta);
        $res = mysqli_stmt_get_result($consulta);
        while ($fila = mysqli_fetch_assoc($res)) {
            $pedidos[] = $fila;
        }
        mysqli_stmt_close($consulta);
        mysqli_free_result($res);
    }
    desconectar($bbdd);
    return $pedidos;
}

function getDetalle(int $codigo): array {
    $bbdd = conectar();
    $detalle = [];
    // Sincronizado con tus tablas reales: codPed y codProd
    $sql = "SELECT d.codProd AS codigo_producto, p.nombre AS titulo, d.cantidad AS unidades, d.precio AS precio_unitario
            FROM detalle d
            JOIN productos p ON d.codProd = p.codProd
            WHERE d.codPed = ?";

    if ($consulta = mysqli_prepare($bbdd, $sql)) {
        mysqli_stmt_bind_param($consulta, "i", $codigo);
        mysqli_stmt_execute($consulta);
        $res = mysqli_stmt_get_result($consulta);
        while ($fila = mysqli_fetch_assoc($res)) {
            $detalle[] = $fila;
        }
        mysqli_stmt_close($consulta);
        mysqli_free_result($res);
    }
    desconectar($bbdd);
    return $detalle;
}

function getEstados(): array {
    $bbdd = conectar();
    $estados = [];
    $sql = "SELECT codEst AS codigo, nombre AS descripcion FROM estados";
    if ($consulta = mysqli_prepare($bbdd, $sql)) {
        mysqli_stmt_execute($consulta);
        $res = mysqli_stmt_get_result($consulta);
        while ($fila = mysqli_fetch_assoc($res)) {
            $estados[] = $fila;
        }
        mysqli_stmt_close($consulta);
        mysqli_free_result($res);
    }
    desconectar($bbdd);
    return $estados;
}

function cambiarEstadoPedido(int $codigo, int $estado): bool {
    $bbdd = conectar();
    $cambiar = false;
    $sql = "UPDATE pedidos SET estado = ? WHERE codPed = ?";
    if ($consulta = mysqli_prepare($bbdd, $sql)) {
        mysqli_stmt_bind_param($consulta, "ii", $estado, $codigo);
        $cambiar = mysqli_stmt_execute($consulta);
        mysqli_stmt_close($consulta);
    }
    desconectar($bbdd);
    return $cambiar;
}

function restaurarStockPedido(int $codigoPedido): void {
    $bbdd = conectar();
    $sql = "SELECT codProd, cantidad FROM detalle WHERE codPed = ?";
    if ($consulta = mysqli_prepare($bbdd, $sql)) {
        mysqli_stmt_bind_param($consulta, "i", $codigoPedido);
        mysqli_stmt_execute($consulta);
        $res = mysqli_stmt_get_result($consulta);

        while ($fila = mysqli_fetch_assoc($res)) {
            $sql2 = "UPDATE productos SET stock = stock + ? WHERE codProd = ?";
            if ($stmt2 = mysqli_prepare($bbdd, $sql2)) {
                mysqli_stmt_bind_param($stmt2, "ii", $fila['cantidad'], $fila['codProd']);
                mysqli_stmt_execute($stmt2);
                mysqli_stmt_close($stmt2);
            }
        }
        mysqli_stmt_close($consulta);
        mysqli_free_result($res);
    }
    desconectar($bbdd);
}

function eliminarPedido(int $codigo): bool {
    $bbdd = conectar();
    $eliminar = false;

    $sqlDetalle = "DELETE FROM detalle WHERE codPed = ?";
    if ($consulta = mysqli_prepare($bbdd, $sqlDetalle)) {
        mysqli_stmt_bind_param($consulta, "i", $codigo);
        mysqli_stmt_execute($consulta);
        mysqli_stmt_close($consulta);
    }

    $sqlPedido = "DELETE FROM pedidos WHERE codPed = ?";
    if ($consulta = mysqli_prepare($bbdd, $sqlPedido)) {
        mysqli_stmt_bind_param($consulta, "i", $codigo);
        $eliminar = mysqli_stmt_execute($consulta);
        mysqli_stmt_close($consulta);
    }

    desconectar($bbdd);
    return $eliminar;
}

function getPedidosFiltrados(string $usuario, string $producto, string $f_igual, string $f_menor, string $f_mayor): array {
    $bbdd = conectar();
    $pedidos = [];

    $sql = "SELECT DISTINCT p.codPed AS codigo, u.usuario AS nombre_usuario, p.fecha, p.importe, p.estado
            FROM pedidos p
            JOIN usuarios u ON p.codUsu = u.codUsu
            JOIN detalle d ON p.codPed = d.codPed
            JOIN productos pr ON d.codProd = pr.codProd
            WHERE 1=1";
    
    $parametros = [];
    $tipos = "";

    if ($usuario !== '') {
        $sql .= " AND u.usuario LIKE ?";
        $parametros[] = "%$usuario%";
        $tipos .= "s";
    }

    if ($producto !== '') {
        $sql .= " AND pr.nombre LIKE ?";
        $parametros[] = "%$producto%";
        $tipos .= "s";
    }

    if ($f_igual !== '') {
        $sql .= " AND p.fecha = ?";
        $parametros[] = $f_igual;
        $tipos .= "s";
    }

    if ($f_menor !== '') {
        $sql .= " AND p.fecha <= ?";
        $parametros[] = $f_menor;
        $tipos .= "s";
    }

    if ($f_mayor !== '') {
        $sql .= " AND p.fecha >= ?";
        $parametros[] = $f_mayor;
        $tipos .= "s";
    }

    $consulta = mysqli_prepare($bbdd, $sql);
    if ($consulta) {
        if (!empty($parametros)) {
            mysqli_stmt_bind_param($consulta, $tipos, ...$parametros);
        }
        mysqli_stmt_execute($consulta);
        $res = mysqli_stmt_get_result($consulta);
        while ($fila = mysqli_fetch_assoc($res)) {
            $pedidos[] = $fila;
        }
        mysqli_stmt_close($consulta);
        mysqli_free_result($res);
    }

    desconectar($bbdd);
    return $pedidos;
}

// =========================================================================
// 5. GESTIÓN DE PRODUCTOS
// =========================================================================

function getProductos(): array {
    $bbdd = conectar();
    $productos = [];
    $sql = "SELECT codProd AS codigo, nombre AS titulo, descripcion, precio, stock AS existencias, imagen, categoria FROM productos";

    if ($consulta = mysqli_prepare($bbdd, $sql)) {
        mysqli_stmt_execute($consulta);
        $res = mysqli_stmt_get_result($consulta);
        while ($fila = mysqli_fetch_assoc($res)) {
            $productos[] = $fila;
        }
        mysqli_stmt_close($consulta);
        mysqli_free_result($res);
    }
    desconectar($bbdd);
    return $productos;
}

function productoEnPedidos(string $codigo): bool {
    $bbdd = conectar();
    $esta = false;
    $sql = "SELECT COUNT(*) AS cnt FROM detalle WHERE codProd = ?";
    
    if ($consulta = mysqli_prepare($bbdd, $sql)) {
        mysqli_stmt_bind_param($consulta, "i", $codigo);
        mysqli_stmt_execute($consulta);
        $res = mysqli_stmt_get_result($consulta);
        if ($fila = mysqli_fetch_assoc($res)) {
            $esta = ((int)$fila['cnt'] > 0);
        }
        mysqli_free_result($res);
        mysqli_stmt_close($consulta);
    }
    desconectar($bbdd);
    return $esta;
}

function borrarProducto(string $codigo): bool {
    $bbdd = conectar();
    $borrar = false;
    $sql = "DELETE FROM productos WHERE codProd = ?";

    if ($consulta = mysqli_prepare($bbdd, $sql)) {
        mysqli_stmt_bind_param($consulta, "i", $codigo);
        $borrar = mysqli_stmt_execute($consulta);
        mysqli_stmt_close($consulta);
    }
    desconectar($bbdd);
    return $borrar;
}

function actualizarProducto(string $codigo, string $titulo, string $descripcion, float $precio, int $existencias, string $imagen, string $categoria): bool {
    $bbdd = conectar();
    $actualizar = false;
    $sql = "UPDATE productos SET nombre = ?, descripcion = ?, precio = ?, stock = ?, imagen = ?, categoria = ? WHERE codProd = ?";

    if ($consulta = mysqli_prepare($bbdd, $sql)) {
        mysqli_stmt_bind_param($consulta, "ssdisii", $titulo, $descripcion, $precio, $existencias, $imagen, $categoria, $codigo);
        $actualizar = mysqli_stmt_execute($consulta);
        mysqli_stmt_close($consulta);
    }
    desconectar($bbdd);
    return $actualizar;
}

function insertarProducto(string $titulo, string $descripcion, float $precio, int $existencias, string $imagen, int $categoria): bool {
    $bbdd = conectar();
    $insertar = false;
    $sql = "INSERT INTO productos(nombre, descripcion, precio, stock, imagen, categoria) VALUES (?, ?, ?, ?, ?, ?)";
    
    if ($consulta = mysqli_prepare($bbdd, $sql)) {
        mysqli_stmt_bind_param($consulta, "ssdisi", $titulo, $descripcion, $precio, $existencias, $imagen, $categoria);
        $insertar = mysqli_stmt_execute($consulta);
        mysqli_stmt_close($consulta);
    }
    desconectar($bbdd);
    return $insertar;
}
?>