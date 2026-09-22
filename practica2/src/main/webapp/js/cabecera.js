class BarraNav extends HTMLElement {
    constructor() {
        super();
        this.innerHTML = `
        <nav class="navbar navbar-expand-lg sticky-top">
            <div class="container">
                <a class="navbar-brand text-light" href="index.jsp" style="color: #e6e6e6 !important;">Luxury ETSE</a>

                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item"><a class="nav-link" href="index.jsp">Inicio</a></li>
                        <li class="nav-item"><a class="nav-link" href="empresa.html">Empresa</a></li>
                        
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Productos
                            </a>
                            <ul class="dropdown-menu dropdown-menu-dark">
                                <li><a class="dropdown-item" href="productos.jsp">VER TODO</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="arriba.jsp">PARTES DE ARRIBA</a></li>
                                <li><a class="dropdown-item" href="abajo.jsp">PARTES DE ABAJO</a></li>
                                <li><a class="dropdown-item" href="accesorios.jsp">ACCESORIOS</a></li>
                            </ul>
                        </li>

                        <li class="nav-item"><a class="nav-link" href="carrito.html">Carrito</a></li>
                        <li class="nav-item"><a class="nav-link" href="contacto.html">Contacto</a></li>
                        <li class="nav-item"><a class="nav-link" href="loginUsuario.jsp">Usuario</a></li>
                    </ul>
                </div>
            </div>
        </nav>
        `;
    }
}
customElements.define('barra-nav', BarraNav);