class footnav extends HTMLElement {
    constructor() {
        super();
        this.innerHTML = `
        <footer class="text-center py-4 mt-auto">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-4 mb-4">
                        <h5 class="text-uppercase fw-bold">Luxury ETSE</h5>
                        <p class="small">&copy; 2026 Todos los derechos reservados.<br>Activos 24/7.</p>
                    </div>
                    
                    <div class="col-md-4 mb-4">
                        <h5 class="text-uppercase fw-bold">Contacto</h5>
                        <p class="small">
                            <i class="fas fa-phone me-2"></i>+34 600 000 000<br>
                            <a href="mailto:LuxuryETSE@etse.com" class="social-icon" style="font-size: 1rem !important;">
                                <i class="fas fa-envelope me-2"></i>LuxuryETSE@etse.com
                            </a>
                        </p>
                    </div>
                    
                    <div class="col-md-4 mb-4">
                        <h5 class="text-uppercase fw-bold">Síguenos</h5>
                        <div class="d-flex justify-content-center gap-3">
                            <a href="https://www.instagram.com" target="_blank" class="social-icon">
                                <i class="fab fa-instagram"></i>
                            </a>
                            <a href="https://www.twitter.com" target="_blank" class="social-icon">
                                <i class="fab fa-x-twitter"></i>
                            </a>
                            <a href="https://www.facebook.com" target="_blank" class="social-icon">
                                <i class="fab fa-facebook-f"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </footer>`;
    }
}

customElements.define('footer-bar', footnav);