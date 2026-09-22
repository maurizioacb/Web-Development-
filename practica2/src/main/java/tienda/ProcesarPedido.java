package tienda;

import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Map;

import jakarta.json.Json;
import jakarta.json.JsonArray;
import jakarta.json.JsonObject;
import jakarta.json.JsonReader;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ProcesarPedido extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(true);
        AccesoBD con = AccesoBD.getInstance();

        // 1. Limpieza de sesión (Igual al bueno)
        if (sesion.getAttribute("carritoJSON") != null) {
            sesion.removeAttribute("carritoJSON");
        }

        ArrayList<Producto> carritoJSON = new ArrayList<>();

        // 2. Lectura del JSON (Igual al bueno)
        JsonReader jsonReader = Json.createReader(new InputStreamReader(request.getInputStream(), "utf-8"));
        JsonArray jobj = jsonReader.readArray();

        for (int i = 0; i < jobj.size(); i++) {
            JsonObject prod = jobj.getJsonObject(i);
            Producto nuevo = new Producto();

            // USAMOS TUS NOMBRES (setCodProd, setNombre, etc.)
            nuevo.setCodProd(prod.getInt("codigo"));
            nuevo.setNombre(prod.getString("titulo"));
            nuevo.setDescripcion(prod.getString("descripcion"));
            nuevo.setImagen(prod.getString("imagen"));
            nuevo.setPrecio(Float.parseFloat(prod.get("precio").toString()));

            int cantidad = prod.getInt("cantidad");
            
            // USAMOS TU FUNCIÓN: con.obtenerExistencias
            int existencias = con.obtenerExistencias(nuevo.getCodProd());

            if (cantidad > existencias) {
                cantidad = existencias;
            }

            if (cantidad > 0) {
                // USAMOS TU NOMBRE: setStock (que es donde guardas la cantidad a comprar)
                nuevo.setStock(cantidad); 
                carritoJSON.add(nuevo);
            }
        }

        // 3. LA LÓGICA DE SALTO (Aquí está el secreto)
        if (carritoJSON.size() > 0) {
            sesion.setAttribute("carritoJSON", carritoJSON);

            // Buscamos el ID del tiguere
            Integer id = (Integer) sesion.getAttribute("usuarioID");
            if (id == null) id = (Integer) sesion.getAttribute("usuario");

            // USAMOS TU FUNCIÓN: obtenerPerfilUsuario (que devuelve el Map)
            Map<String, String> datosUsuario = con.obtenerPerfilUsuario(id);
            sesion.setAttribute("datosUsuario", datosUsuario);

            // REDIRECCIÓN LITERAL (Esto hace que el libjson.js funcione)
            response.sendRedirect("./procesar.jsp");

        } else {
            sesion.setAttribute("mensajeSinStock", "Ninguno de los productos tiene stock suficiente.");
            // Si no hay stock, lo mandamos de vuelta a la página de compra
            response.sendRedirect("compra.jsp");
        }
    }
}