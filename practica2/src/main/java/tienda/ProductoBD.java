package tienda;

public class ProductoBD {
    private int codProd;
    private String nombre;
    private String descripcion;
    private float precio;
    private int stock;
    private String imagen;
    private int categoria;

    // Constructor vacío 
    public ProductoBD() {}

    // Constructor lleno (para crear productos rápido)
    public ProductoBD(int codProd, String nombre, String descripcion, float precio, int stock, String imagen, int categoria) {
        this.codProd = codProd;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.precio = precio;
        this.stock = stock;
        this.imagen = imagen;
        this.categoria = categoria;
    }

    // --- GETTERS Y SETTERS ---

    public int getCodProd() { return codProd; }
    public void setCodProd(int codProd) { this.codProd = codProd; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public float getPrecio() { return precio; }
    public void setPrecio(float precio) { this.precio = precio; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public String getImagen() { return imagen; }
    public void setImagen(String imagen) { this.imagen = imagen; }

    public int getCategoria() { return categoria; }
    public void setCategoria(int categoria) { this.categoria = categoria; }
}
