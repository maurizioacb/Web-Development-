package tienda;

public class Producto {

    private int codProd;
    private String nombre;
    private String descripcion;
    private float precio;
    private String imagen;
    private int stock;
    private int categoria;  

    public int getCodProd() {
		return codProd;
	}

	public void setCodProd(int codProd) {
		this.codProd = codProd;
	}

    public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
 		this.nombre = nombre;
	}
    
	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
 		this.descripcion = descripcion;
	}

	public float getPrecio() {
		return precio;
	}

	public void setPrecio(float precio) {
		this.precio = precio;
	}

	public String getImagen() {
		return imagen;
	}

	public void setImagen(String imagen) {
		this.imagen = imagen;
	}

	public int getStock() {
		return stock;
	}

	public void setStock(int stock) {
		this.stock = stock;
	}

	public int getCategoria() {
		return categoria;
	}

	public void setCategoria(int categoria) {
		this.categoria = categoria;
	}
}