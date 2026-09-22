class elementoCarrito{
    constructor(codigo,titulo, descripcion, imagen, cantidad, precio, existencias){
        this.codigo = codigo;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.imagen = imagen;
        this.cantidad = cantidad;
        this.precio = precio;
        this.existencias = existencias;
    }
}


var carrito = null; // Variable global que almacena el carrito de la compra


function cargarCarrito(){ // Carga el carrito de la compra desde el localStorage
    if(carrito === null){
        carrito = JSON.parse(localStorage.getItem("mi-carrito-almacenado"));
        if(carrito === null){
            carrito = [];
        }
    }
}


function guardarCarrito(){ // Guarda el carrito de la compra en el localStorage
    localStorage.setItem("mi-carrito-almacenado", JSON.stringify(carrito));
}


function indiceCarrito(codigo){ // Devuelve el índice del producto en el carrito
    
    var i, indice = -1;

    cargarCarrito();

    for(i = 0; i < carrito.length; i++){
        if(carrito[i].codigo === parseInt(codigo)){ // Si el código del producto coincide con el del carrito
            indice = i;
            break;
        }
    }

    return indice;

}


function anadirCarrito(codigo,titulo, descripcion, imagen, cantidad, precio, existencias){ 

    cargarCarrito(); // Carga el carrito

    let indice = indiceCarrito(codigo); // Variable que comprueba si el producto ya está en el carrito

    if(indice !== -1){ // Ya está en el carrito
        if(carrito[indice].cantidad + parseInt(cantidad) <= parseInt(existencias)){ // Si la cantidad total no supera las existencias
            carrito[indice].cantidad += parseInt(cantidad); // Se suma la cantidad
            alert("Cantidad aumentada");
        }else{
            alert("No hay suficientes existencias");
        }
    }else{ // No está aún en el carrito
        if(parseInt(cantidad) <= parseInt(existencias)){ // Si la cantidad no supera las existencias
            let nuevoProducto = new elementoCarrito(parseInt(codigo), titulo, descripcion, imagen, parseInt(cantidad), parseFloat(precio), parseInt(existencias)); // Se crea un nuevo objeto con los datos del producto
            carrito.push(nuevoProducto);
            alert("Producto añadido al carrito");
        } else {
            alert("No hay suficientes existencias");
        }
    }

    guardarCarrito();
    location.reload();
}


function eliminarProductoCarrito(codigo){ // Elimina un producto del carrito

    cargarCarrito(); // Carga el carrito

    carrito = carrito.filter(producto => producto.codigo !== parseInt(codigo)); // Filtra el carrito para eliminar el producto (de stackoverflow)

    guardarCarrito();
    mostrarCarrito();

    alert("Producto eliminado del carrito");

    location.reload();
}


function modificarCantidadCarrito(codigo, nuevaCantidad){

    cargarCarrito();

    let indice = indiceCarrito(codigo); // Variable que comprueba si el producto ya está en el carrito

    if (indice !== -1){ // Si el producto está en el carrito 
        if (nuevaCantidad <= 0){ // Si la cantidad es 0 o menor
            eliminarProductoCarrito(codigo); // Se elimina el producto
        }else if (nuevaCantidad > carrito[indice].existencias){ // Si la cantidad es mayor que las existencias
            alert("No quedan existencias disponibles");
        }else{
            carrito[indice].cantidad = nuevaCantidad; // Se modifica la cantidad
            alert("Cantidad modificada");
        }
    }

    guardarCarrito();
    mostrarCarrito();
    location.reload();
}


function mostrarCarrito(){
    
    cargarCarrito();

    let carritoItems = document.getElementById("carrito-items"); // Contiene los productos

    if (!carritoItems) return; // Evita errores si el contenedor no existe

    carritoItems.innerHTML = ""; // Limpia el contenido previo

    carrito.forEach((producto) =>{
        let fila = document.createElement("tr");

        fila.innerHTML = `
            <td><img src="${producto.imagen}" alt="${producto.descripcion}" class="producto-img" width="100"></td>
            <td class="text-center">
                <strong>${producto.titulo}</strong><br>
                <p class="mt-2 mb-0">${producto.descripcion}</p>
            </td>
            <td>
                <div class="d-flex justify-content-center align-items-center">
                    <button class="btn btn-principal btn-sm" onclick="modificarCantidadCarrito(${producto.codigo}, ${producto.cantidad - 1})">-</button>
                    <input type="number" value="${producto.cantidad}" min="1" class="form-control text-center mx-2" onchange="modificarCantidadCarrito(${producto.codigo}, this.value)">
                    <button class="btn btn-principal btn-sm" onclick="modificarCantidadCarrito(${producto.codigo}, ${producto.cantidad + 1})">+</button>
                </div>
            </td>
            <td>
                <button class="btn btn-eliminar btn-sm" onclick="eliminarProductoCarrito(${producto.codigo})">Eliminar producto</button>
            </td>
        `;

        carritoItems.appendChild(fila);
    });

    if(carrito.length === 0){
        carritoItems.innerHTML = `<tr><td colspan="4">El carrito está vacío</td></tr>`;
    }

    const botonComprar = document.getElementById("btn-comprar"); // Desabilita el boton de compra si el carrito esta vacio
    if (botonComprar){
    botonComprar.disabled = (carrito.length === 0);
    }

}


function generarTicket(){

    cargarCarrito();

    const carritoItems = document.getElementById("carrito-items"); // Almacena los productos
    const totalCompra = document.getElementById("total-compra"); // Almacena el total de la compra

    if (!carritoItems || !totalCompra) return; // Evita errores si no hay nada almacenado

    carritoItems.innerHTML = ""; // Limpia el contenido previo
    let total = 0; // Inicializa el total a 0

    carrito.forEach(producto => { // Recorre el carrito y añade los productos a la tabla
        total += producto.cantidad * producto.precio;
    
        const fila = document.createElement("tr"); // Crea una fila para cada producto
        fila.innerHTML = `
            <td><img src="${producto.imagen}" alt="${producto.descripcion}" width="100"></td>
            <td class="text-center">
                <strong>${producto.titulo}</strong><br>
                <p class="mt-2 mb-0">${producto.descripcion}</p>
            </td>
            <td>${producto.cantidad}</td>
            <td>${(producto.precio * producto.cantidad).toFixed(2)}€</td>`;
        carritoItems.appendChild(fila);
    });
    
    totalCompra.innerText = `${total.toFixed(2)}€`;

    if(carrito.length === 0){
    carritoItems.innerHTML = `<tr><td colspan="4">El carrito está vacío</td></tr>`;
    }

}


function eliminarCarrito(){
    carrito = []; 
    guardarCarrito();
}