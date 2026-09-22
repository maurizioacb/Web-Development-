<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inicio - Luxury ETSE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>


<body class="d-flex flex-column min-vh-100">
    <barra-nav></barra-nav>


    <header class="container mt-5">
        <div class="text-center mb-5">
            <h1 class="display-3">BIENVENIDO A LUXURYY ETSE</h1>
            <p class="lead">Exclusividad y estilo en cada prenda. Descubre nuestra nueva coleccion.</p>
        </div>
    </header>


    <div id="carruselLuxury" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="img/tienda3.png" alt="Fachada Luxury ETSE">
            </div>
            <div class="carousel-item">
                <img src="img/modelo.png" alt="Colección LuxETSE">
            </div>
            <div class="carousel-item">
                <img src="img/luxuryetse_portada.png" alt="Accesorios de lujo">
            </div>
        </div>
       
        <button class="carousel-control-prev" type="button" data-bs-target="#carruselLuxury" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Anterior</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#carruselLuxury" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Siguiente</span>
        </button>
    </div>


    <main class="container my-5 flex-grow-1">
        <div class="text-center mt-5">
            <a href="productos.jsp" class="btn-metalico">Ver Coleccion Completa</a>
        </div>
    </main>


    <footer-bar></footer-bar>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/cabecera.js"></script>
    <script src="js/footer.js"></script>
</body>
</html>