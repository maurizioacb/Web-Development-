package tienda;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class Tramitacion extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("carritoJSON") == null) {
            response.sendRedirect("carrito.html?msg=sesion_vacia");
            return;
        }

        // Pillamos el ID del tiguere
        Integer idUsu = (Integer) session.getAttribute("usuario");
        if (idUsu == null) idUsu = (Integer) session.getAttribute("usuarioID");
        
        ArrayList<Producto> carrito = (ArrayList<Producto>) session.getAttribute("carritoJSON");
        AccesoBD con = AccesoBD.getInstance();

        try (Connection conexion = con.getConexion()) {
            conexion.setAutoCommit(false); 

            float totalCalculado = 0;
            for (Producto p : carrito) totalCalculado += p.getPrecio() * p.getStock();

            // 1. INSERT PEDIDOS (Columnas: codUsu, fecha, importe, estado)
            String sqlPed = "INSERT INTO pedidos (codUsu, fecha, importe, estado) VALUES (?, CURRENT_DATE, ?, 1)";
            PreparedStatement psPed = conexion.prepareStatement(sqlPed, Statement.RETURN_GENERATED_KEYS);
            psPed.setInt(1, idUsu);
            psPed.setFloat(2, totalCalculado);
            psPed.executeUpdate();

            // Obtenemos el codPed que acaba de nacer
            ResultSet keys = psPed.getGeneratedKeys();
            int codPedGenerado = (keys.next()) ? keys.getInt(1) : -1;

            // 2. INSERT DETALLE (Columnas: codPed, codProd, cantidad, precio)
            String sqlDet = "INSERT INTO detalle (codPed, codProd, cantidad, precio) VALUES (?, ?, ?, ?)";
            PreparedStatement psDet = conexion.prepareStatement(sqlDet);

            // 3. UPDATE STOCK (Columnas: stock, codProd)
            String sqlStk = "UPDATE productos SET stock = stock - ? WHERE codProd = ?";
            PreparedStatement psStk = conexion.prepareStatement(sqlStk);

            for (Producto p : carrito) {
                // Detalle del pedido
                psDet.setInt(1, codPedGenerado); 
                psDet.setInt(2, p.getCodProd());
                psDet.setInt(3, p.getStock()); 
                psDet.setFloat(4, p.getPrecio());
                psDet.addBatch();

                // Descontar del inventario
                psStk.setInt(1, p.getStock()); 
                psStk.setInt(2, p.getCodProd());
                psStk.addBatch();
            }
            psDet.executeBatch();
            psStk.executeBatch();

            conexion.commit(); // ¡Venta cerrada!
            
            session.setAttribute("codigoPedido", codPedGenerado);
            session.removeAttribute("carritoJSON"); 
            
            response.sendRedirect("pedidoFinalizado.jsp");

        } catch (SQLException e) {
            System.err.println("❌ ERROR SQL EN TRAMITACIÓN: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("procesar.jsp?error=sql");
        }
    }
}