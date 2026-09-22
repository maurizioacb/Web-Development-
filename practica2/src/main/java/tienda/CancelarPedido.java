package tienda;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CancelarPedido extends HttpServlet {

    // Soporte para GET ya que el JSP usa window.location.href
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        // Usamos usuarioID que es el estándar que hemos llevado hoy
        Integer idUsuario = (Integer) (session != null ? session.getAttribute("usuarioID") : null);

        if (idUsuario == null) {
            response.sendRedirect("loginUsuario.jsp");
            return;
        }

        // El parámetro en tu JSP es 'id'
        String idPedidoStr = request.getParameter("id");
        if (idPedidoStr == null) { response.sendRedirect("pedidos.jsp"); return; }

        int idPedido = Integer.parseInt(idPedidoStr);
        AccesoBD con = AccesoBD.getInstance();

        try (Connection conexion = con.getConexion()) {
            conexion.setAutoCommit(false);

            // 1. Verificar que el pedido sea del tiguere y esté Pendiente (estado 1)
            String sqlCheck = "SELECT estado FROM pedidos WHERE codPed = ? AND codUsu = ?";
            PreparedStatement psCheck = conexion.prepareStatement(sqlCheck);
            psCheck.setInt(1, idPedido);
            psCheck.setInt(2, idUsuario);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next() && rs.getInt("estado") == 1) {
                // 2. Cambiar estado a 2 (Cancelado) - Según tu lógica
                String sqlUpd = "UPDATE pedidos SET estado = 2 WHERE codPed = ?";
                PreparedStatement psUpd = conexion.prepareStatement(sqlUpd);
                psUpd.setInt(1, idPedido);
                psUpd.executeUpdate();

                // 3. Devolver el stock (usando 'cantidad' como en Tramitacion)
                String sqlDet = "SELECT codProd, cantidad FROM detalle WHERE codPed = ?";
                PreparedStatement psDet = conexion.prepareStatement(sqlDet);
                psDet.setInt(1, idPedido);
                ResultSet rsDet = psDet.executeQuery();

                String sqlStk = "UPDATE productos SET stock = stock + ? WHERE codProd = ?";
                PreparedStatement psStk = conexion.prepareStatement(sqlStk);

                while (rsDet.next()) {
                    psStk.setInt(1, rsDet.getInt("cantidad"));
                    psStk.setInt(2, rsDet.getInt("codProd"));
                    psStk.addBatch();
                }
                psStk.executeBatch();
                conexion.commit();
            }
            response.sendRedirect("pedidos.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("pedidos.jsp?error=sql");
        }
    }
}