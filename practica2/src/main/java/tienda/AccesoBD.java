package tienda; 
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class AccesoBD {
	private static AccesoBD instanciaUnica = null;
	private Connection conexionBD = null;

//----------------------------------------------------//
//-------METODOS PARA CONEXION Y ACCESO A LA BD-------//
//----------------------------------------------------//
    public static AccesoBD getInstance(){
		if (instanciaUnica == null){
			instanciaUnica = new AccesoBD();
		}
		return instanciaUnica;
	}

    private AccesoBD() {
		abrirConexionBD();
	}

    public void abrirConexionBD() {
    try {
        if (conexionBD == null || conexionBD.isClosed()) {
            // Probamos con el driver de MariaDB
            Class.forName("org.mariadb.jdbc.Driver");
            
            // Usamos la IP de tu captura y añadimos parámetros de seguridad
            String DB_URL = "jdbc:mariadb://127.0.0.1:3306/daw?useSSL=false&allowPublicKeyRetrieval=true";
            String USER = "root";
            String PASS = "DawLab"; 

            conexionBD = DriverManager.getConnection(DB_URL, USER, PASS);
            System.out.println("✅ CONEXIÓN EXITOSA A: " + DB_URL);
        }
    } catch (Exception e) {
        System.err.println("❌ ERROR CRÍTICO AL CONECTAR:");
        e.printStackTrace(); // Esto sacará el error real en la terminal
    }
}
    

    public boolean comprobarAcceso() {
		abrirConexionBD();
		return (conexionBD != null);
	}


//----------------------------------------------------//
//--------------METODOS PARA PRODUCTOS----------------//
//----------------------------------------------------//
//aqui obtenemos los productos por el tipo de categoria 1,2,3 => usada en abajo.jsp, accesorios.jsp, arriba.jsp
public List<ProductoBD> obtenerProductosBD(int categoria) {
    abrirConexionBD();
    List<ProductoBD> productos = new ArrayList<>();

    try {
        // Adaptamos los nombres: codProd en lugar de codigo, y stock en lugar de existencias
        String query = "SELECT codProd, nombre, descripcion, precio, stock, imagen, categoria FROM productos WHERE categoria=?"; 
        
        // Usamos PreparedStatement para que sea seguro (evita inyecciones SQL)
        java.sql.PreparedStatement s = conexionBD.prepareStatement(query);
        s.setInt(1, categoria);
        
        java.sql.ResultSet resultado = s.executeQuery();
        
        while(resultado.next()){
            ProductoBD producto = new ProductoBD();
            
            // Usamos los nombres exactos de tu HeidiSQL
            producto.setCodProd(resultado.getInt("codProd"));
            producto.setNombre(resultado.getString("nombre"));
            producto.setDescripcion(resultado.getString("descripcion"));
            producto.setPrecio(resultado.getFloat("precio"));
            producto.setStock(resultado.getInt("stock"));
            producto.setImagen(resultado.getString("imagen"));
            producto.setCategoria(resultado.getInt("categoria"));
            
            productos.add(producto);
        }
        
        resultado.close();
        s.close();
        
    } catch(Exception e) {
        System.err.println("Error ejecutando la consulta de productos por categoría");
        System.err.println(e.getMessage());
    }
    return productos;
}


//----------------------------------------------------//
//--------------METODOS PARA USUARIOS----------------//
//----------------------------------------------------//
//utilizada en varias: compra, cambiar...
public Map<String, String> obtenerPerfilUsuario(int codUsu) {
    abrirConexionBD();
    Map<String, String> perfil = new HashMap<>();
    try {
        String query = "SELECT usuario, nombre, apellidos, dni, direccion, poblacion, provincia, cp, telefono FROM usuarios WHERE codUsu=?";
        java.sql.PreparedStatement ps = conexionBD.prepareStatement(query);
        ps.setInt(1, codUsu);
        java.sql.ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            perfil.put("usuario", rs.getString("usuario"));
            perfil.put("nombre", rs.getString("nombre"));
            perfil.put("apellidos", rs.getString("apellidos"));
            perfil.put("dni", rs.getString("dni"));
            perfil.put("direccion", rs.getString("direccion"));
            perfil.put("poblacion", rs.getString("poblacion"));
            perfil.put("provincia", rs.getString("provincia"));
            perfil.put("cp", rs.getString("cp"));
            perfil.put("telefono", rs.getString("telefono"));
        }
        rs.close();
        ps.close();
    } catch (Exception e) {
        System.err.println("Error al obtener perfil: " + e.getMessage());
        e.printStackTrace();
    }
    return perfil;
}

//utilizada en el login.java
public int comprobarUsuarioBD(String usuario, String clave) {
    abrirConexionBD();

    int codigo = -1;

    try {
        // CAMBIO 1: La columna se llama codUsu, no codigo
        String con = "SELECT codUsu FROM usuarios WHERE usuario=? AND clave=?";
        java.sql.PreparedStatement s = conexionBD.prepareStatement(con);
        s.setString(1, usuario);
        s.setString(2, clave);

        java.sql.ResultSet resultado = s.executeQuery();

        if (resultado.next()) {
            // CAMBIO 2: Aquí también usamos codUsu
            codigo = resultado.getInt("codUsu");
        }
        
        resultado.close();
        s.close();
    }
    catch(Exception e) {
        System.err.println("Error verificando usuario/clave");
        System.err.println(e.getMessage());
        e.printStackTrace();
    }

    return codigo;
}

// utilizado en actualizarperfil.java Método para actualizar TODO (incluida clave)
public boolean actualizarUsuarioCompleto(int id, String nom, String ape, String dir, String pob, String cla) {
    abrirConexionBD();
    try {
        String sql = "UPDATE usuarios SET nombre=?, apellidos=?, direccion=?, poblacion=?, clave=? WHERE codUsu=?";
        java.sql.PreparedStatement ps = conexionBD.prepareStatement(sql);
        ps.setString(1, nom); ps.setString(2, ape); ps.setString(3, dir);
        ps.setString(4, pob); ps.setString(5, cla); ps.setInt(6, id);
        return ps.executeUpdate() > 0;
    } catch (Exception e) { e.printStackTrace(); return false; }
}

// Método para actualizar solo datos básicos
public boolean actualizarUsuarioDatos(int id, String nom, String ape, String dir, String pob) {
    abrirConexionBD();
    try {
        String sql = "UPDATE usuarios SET nombre=?, apellidos=?, direccion=?, poblacion=? WHERE codUsu=?";
        java.sql.PreparedStatement ps = conexionBD.prepareStatement(sql);
        ps.setString(1, nom); ps.setString(2, ape); ps.setString(3, dir);
        ps.setString(4, pob); ps.setInt(5, id);
        return ps.executeUpdate() > 0;
    } catch (Exception e) { e.printStackTrace(); return false; }
}

// utilizado en registro.java Método final en AccesoBD.java
public boolean registrarNuevoUsuario(String user, String pass, String nom, String ape, String dni, String dir, String pob, String pro, String cp, String tel) {
    abrirConexionBD();
    
    // 1. Chequeo de existencia
    try {
        String checkSql = "SELECT codUsu FROM usuarios WHERE usuario = ?";
        java.sql.PreparedStatement st = conexionBD.prepareStatement(checkSql);
        st.setString(1, user);
        java.sql.ResultSet rs = st.executeQuery();
        boolean existe = rs.next();
        rs.close(); st.close();
        if (existe) return false; 
    } catch (Exception e) { e.printStackTrace(); return false; }

    // 2. INSERT con las 11 columnas (incluyendo nivel=1)
    try {
        String sql = "INSERT INTO usuarios (usuario, clave, nombre, apellidos, dni, direccion, poblacion, provincia, cp, telefono, nivel) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)";
        java.sql.PreparedStatement ps = conexionBD.prepareStatement(sql);
        
        ps.setString(1, user);
        ps.setString(2, pass);
        ps.setString(3, nom);
        ps.setString(4, ape);
        ps.setString(5, dni);
        ps.setString(6, dir);
        ps.setString(7, pob);
        ps.setString(8, pro);
        ps.setString(9, cp);
        ps.setString(10, tel);
        
        int filas = ps.executeUpdate();
        ps.close();
        return filas > 0;
    } catch (java.sql.SQLException e) {
        System.err.println("❌ ERROR SQL: " + e.getErrorCode() + " - " + e.getMessage());
        return false;
    } catch (Exception e) { e.printStackTrace(); return false; }
}


//----------------------------------------------------//
//----------------METODOS PARA PEDIDOS----------------//
//----------------------------------------------------//
//utilizada en pedidos.java
public int obtenerExistencias(int codigo) {
    abrirConexionBD();
    int existencias = 0;
    try {
        // Nombres corregidos según tu MariaDB: stock y codProd
        String query = "SELECT stock FROM productos WHERE codProd = ?";
        PreparedStatement s = conexionBD.prepareStatement(query);
        s.setInt(1, codigo);
        ResultSet resultado = s.executeQuery();

        if (resultado.next()) {
            existencias = resultado.getInt("stock");
        }
    } catch (Exception e) {
        System.err.println("❌ ERROR SQL en obtenerExistencias: " + e.getMessage());
    }
    return existencias;
}
public Connection getConexion() {
    abrirConexionBD();
    return conexionBD;
}

//----------------------------------------------------//
//-------------METODOS PARA ACTUALIZAR CLAVE----------//
//----------------------------------------------------//
//utilizadas en actualizarclave.java
public String obtenerClave(int idUsuario) {
    abrirConexionBD();
    String claveActual = "";
    try {
        // Usamos 'codUs' que es tu columna real
        String query = "SELECT clave FROM usuarios WHERE codUsu = ?";
        java.sql.PreparedStatement ps = conexionBD.prepareStatement(query);
        ps.setInt(1, idUsuario);
        java.sql.ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            claveActual = rs.getString("clave");
        }
        rs.close();
        ps.close();
    } catch (Exception e) {
        System.err.println("Error al obtener la clave: " + e.getMessage());
    }
    return claveActual;
}

public boolean actualizarClave(int codigoUsuario, String nuevaClave) {
    // 1. Abrimos la conexión con el barrio (BD)
    abrirConexionBD();

    try {
        // 2. SQL ajustado: 'codUs' es tu columna real de ID
        String query = "UPDATE usuarios SET clave = ? WHERE codUsu = ?";
        java.sql.PreparedStatement ps = conexionBD.prepareStatement(query);
        
        // 3. Pasamos los datos limpios
        ps.setString(1, nuevaClave); 
        ps.setInt(2, codigoUsuario); 
        
        // 4. Ejecutamos y verificamos si hubo cambios
        int filas = ps.executeUpdate();
        
        ps.close(); // Cerramos el grifo
        return filas > 0;

    } catch (Exception e) {
        System.err.println("Error al actualizar la clave del tiguere: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}


//utilizada en pedidos.jsp 
public List<Map<String, Object>> obtenerPedidosUsuario(int codUsu) {
    abrirConexionBD();
    List<Map<String, Object>> pedidos = new ArrayList<>();
    try {
        // SQL real basado en tu tabla: codPed, fecha, importe, estado
        String sql = "SELECT codPed, fecha, importe, estado FROM pedidos WHERE codUsu=? ORDER BY codPed DESC";
        java.sql.PreparedStatement ps = conexionBD.prepareStatement(sql);
        ps.setInt(1, codUsu);
        java.sql.ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, Object> p = new HashMap<>();
            p.put("id", rs.getInt("codPed"));
            p.put("fecha", rs.getDate("fecha"));
            p.put("total", rs.getDouble("importe")); // Importe es decimal
            p.put("estado", rs.getInt("estado"));   // 1=Pendiente, 2=Cancelado...
            pedidos.add(p);
        }
        rs.close(); ps.close();
    } catch (Exception e) { e.printStackTrace(); }
    return pedidos;
}

public ProductoBD obtenerProductoPorID(int id) {
    abrirConexionBD();
    ProductoBD p = null;
    
    // Usamos tus nombres de columna: codProd, stock, etc.
    String query = "SELECT codProd, nombre, descripcion, precio, stock, imagen, categoria FROM productos WHERE codProd = ?";
    
    try (java.sql.PreparedStatement ps = conexionBD.prepareStatement(query)) {
        ps.setInt(1, id);
        try (java.sql.ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                p = new ProductoBD();
                p.setCodProd(rs.getInt("codProd"));
                p.setNombre(rs.getString("nombre"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setPrecio(rs.getFloat("precio"));
                p.setStock(rs.getInt("stock"));
                p.setImagen(rs.getString("imagen"));
                p.setCategoria(rs.getInt("categoria"));
            }
        }
    } catch (java.sql.SQLException e) {
        System.err.println("❌ Error al obtener producto por ID: " + e.getMessage());
    }
    return p;
}

public List<Map<String, Object>> obtenerDetallesPedido(int codPed) {
    abrirConexionBD();
    List<Map<String, Object>> detalles = new ArrayList<>();
    // Cruzamos la tabla 'detalle' con 'productos' para sacar el nombre
    String sql = "SELECT d.cantidad, d.precio, p.nombre " +
                 "FROM detalle d INNER JOIN productos p ON d.codProd = p.codProd " +
                 "WHERE d.codPed = ?";

    try (PreparedStatement ps = conexionBD.prepareStatement(sql)) {
        ps.setInt(1, codPed);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> linea = new HashMap<>();
                linea.put("cantidad", rs.getInt("cantidad"));
                linea.put("precioUnidad", rs.getDouble("precio"));
                linea.put("nombreProd", rs.getString("nombre"));
                detalles.add(linea);
            }
        }
    } catch (SQLException e) {
        System.err.println("❌ Error al obtener detalles: " + e.getMessage());
    }
    return detalles;
}
}

