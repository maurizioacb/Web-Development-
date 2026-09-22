class CabeceraAdmin extends HTMLElement {
    constructor() {
        super();
        this.innerHTML = `
        <header>
            <h1>Administración - LuxuryETSE</h1>

            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                <div class="container-fluid">
                    
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarAdmin" aria-controls="navbarAdmin" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    
                    <div class="collapse navbar-collapse" id="navbarAdmin">
                        <ul class="navbar-nav">
                            <li class="nav-item"><a class="nav-link" href="usuarios.html">Usuarios</a></li>
                            <li class="nav-item"><a class="nav-link" href="productos.html">Productos</a></li>
                            <li class="nav-item"><a class="nav-link" href="pedidos.html">Pedidos</a></li>
                            <li class="nav-item"><a class="nav-link" href="index.html">Cerrar sesión</a></li>
                        </ul>
                    </div>
                </div>
            </nav>
        </header>`;
    }
}
customElements.define('mi-cabecera-admin', CabeceraAdmin);

class PieAdmin extends HTMLElement {
    constructor() {
        super();
        this.innerHTML = `<footer></footer>`;
    }
}
customElements.define('mi-pie-admin', PieAdmin);
