-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         11.8.6-MariaDB - MariaDB Server
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.14.0.7165
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para daw
DROP DATABASE IF EXISTS `daw`;
CREATE DATABASE IF NOT EXISTS `daw` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci */;
USE `daw`;

-- Volcando estructura para tabla daw.categorias
DROP TABLE IF EXISTS `categorias`;
CREATE TABLE IF NOT EXISTS `categorias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla daw.categorias: ~3 rows (aproximadamente)
INSERT INTO `categorias` (`id`, `nombre`, `descripcion`) VALUES
	(1, 'Partes de Arriba', 'Camisetas, sudaderas y chaquetas luxury'),
	(2, 'Partes de Abajo', 'Pantalones, jeans y joggers de diseño'),
	(3, 'Accesorios', 'Complementos premium para tu outfit');

-- Volcando estructura para tabla daw.detalle
DROP TABLE IF EXISTS `detalle`;
CREATE TABLE IF NOT EXISTS `detalle` (
  `codDet` int(11) NOT NULL AUTO_INCREMENT,
  `codPed` int(11) DEFAULT NULL,
  `codProd` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`codDet`),
  KEY `codPed` (`codPed`),
  KEY `codProd` (`codProd`),
  CONSTRAINT `detalle_ibfk_1` FOREIGN KEY (`codPed`) REFERENCES `pedidos` (`codPed`),
  CONSTRAINT `detalle_ibfk_2` FOREIGN KEY (`codProd`) REFERENCES `productos` (`codProd`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla daw.detalle: ~12 rows (aproximadamente)
INSERT INTO `detalle` (`codDet`, `codPed`, `codProd`, `cantidad`, `precio`) VALUES
	(15, 9, 2, 1, 150.00),
	(16, 10, 8, 1, 100.00),
	(17, 10, 9, 1, 50.00),
	(19, 11, 6, 1, 90.00),
	(20, 12, 2, 4, 150.00),
	(21, 13, 3, 2, 300.00),
	(22, 13, 1, 2, 80.00),
	(24, 14, 3, 2, 300.00),
	(25, 15, 3, 1, 300.00),
	(26, 16, 3, 1, 300.00),
	(27, 17, 3, 1, 300.00),
	(28, 18, 1, 1, 80.00),
	(29, 19, 6, 1, 90.00),
	(30, 20, 5, 5, 90.00),
	(31, 20, 3, 1, 300.00);

-- Volcando estructura para tabla daw.estados
DROP TABLE IF EXISTS `estados`;
CREATE TABLE IF NOT EXISTS `estados` (
  `codEst` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`codEst`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla daw.estados: ~4 rows (aproximadamente)
INSERT INTO `estados` (`codEst`, `nombre`) VALUES
	(1, 'Pendiente'),
	(2, 'Cancelado'),
	(3, 'Enviado'),
	(4, 'Entregado');

-- Volcando estructura para tabla daw.pedidos
DROP TABLE IF EXISTS `pedidos`;
CREATE TABLE IF NOT EXISTS `pedidos` (
  `codPed` int(11) NOT NULL AUTO_INCREMENT,
  `codUsu` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `importe` decimal(10,2) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL,
  PRIMARY KEY (`codPed`),
  KEY `codUsu` (`codUsu`),
  KEY `estado` (`estado`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`codUsu`) REFERENCES `usuarios` (`codUsu`),
  CONSTRAINT `pedidos_ibfk_2` FOREIGN KEY (`estado`) REFERENCES `estados` (`codEst`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla daw.pedidos: ~11 rows (aproximadamente)
INSERT INTO `pedidos` (`codPed`, `codUsu`, `fecha`, `importe`, `estado`) VALUES
	(9, 1, '2026-04-21', 150.00, 1),
	(10, 1, '2026-04-21', 150.00, 1),
	(11, 1, '2026-04-21', 90.00, 1),
	(12, 1, '2026-04-21', 600.00, 1),
	(13, 5, '2026-04-21', 760.00, 2),
	(14, 5, '2026-04-22', 600.00, 2),
	(15, 5, '2026-04-28', 300.00, 2),
	(16, 5, '2026-04-28', 300.00, 2),
	(17, 5, '2026-05-05', 300.00, 2),
	(18, 5, '2026-05-06', 80.00, 2),
	(19, 5, '2026-05-06', 90.00, 1),
	(20, 6, '2026-05-10', 750.00, 1);

-- Volcando estructura para tabla daw.productos
DROP TABLE IF EXISTS `productos`;
CREATE TABLE IF NOT EXISTS `productos` (
  `codProd` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `categoria` int(11) DEFAULT NULL,
  PRIMARY KEY (`codProd`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla daw.productos: ~9 rows (aproximadamente)
INSERT INTO `productos` (`codProd`, `nombre`, `descripcion`, `precio`, `stock`, `imagen`, `categoria`) VALUES
	(1, 'Signature Tee', 'Camiseta de algodón orgánico de alta densidad con corte premium fit. Un básico indispensable diseñado para ofrecer máxima suavidad y durabilidad. Redefiniendo el lujo cotidiano.', 80.00, 6, 'img/tee.png', 1),
	(2, 'Signature Hoodie', 'Sudadera de alto gramaje en color negro azabache. Interior cepillado para un confort térmico superior y diseño minimalista. La pieza clave de cualquier outfit streetwear de élite.', 150.00, 0, 'img/sudadera.png', 1),
	(3, 'Signature Jacket', 'Nuestra pieza maestra de edición limitada. Confeccionada con materiales técnicos resistentes al agua y acabados metálicos. Sofisticación urbana en su máxima expresión.', 300.00, 6, 'img/jacket.png', 1),
	(4, 'Jeans', 'Vaqueros baggy fit en azul índigo clásico. Denim elástico de alta calidad que garantiza flexibilidad total y mantiene su forma tras cada uso. Estilo atemporal y resistencia.', 90.00, 5, 'img/jeans.png', 2),
	(5, 'Signature Joggers', 'La fusión perfecta entre comodidad y lujo. Pantalón de chándal anchos pero elegantes. Ideales para un estilo de vida dinámico sin sacrificar la elegancia.', 90.00, 0, 'img/chandal.png', 2),
	(6, 'Signature Cargo', 'Funcionalidad avanzada y estilo moderno. Pantalón tipo cargo con bolsillos tácticos de perfil bajo y corte ergonómico. Versatilidad pura para el explorador urbano.', 90.00, 3, 'img/cargo.png', 2),
	(7, 'Luxury Watch', 'Reloj de precisión fabricado en plata de ley con esfera minimalista. Una joya atemporal diseñada para quienes valoran la exactitud y el estatus en cada segundo.', 500.00, 5, 'img/reloj.png', 3),
	(8, 'Glasses Luxury', 'Gafas de sol estilo aviador con montura metálica ultraligera y lentes polarizadas de alta protección. El accesorio definitivo para una mirada con personalidad.', 100.00, 4, 'img/gafas.png', 3),
	(9, 'Beanie Streetwear', 'Gorro de lana de punto fino, extremadamente suave y cálido. El toque final rebelde y sofisticado necesario para los días más frescos en la ciudad.', 50.00, 4, 'img/gorro.png', 3);

-- Volcando estructura para tabla daw.usuarios
DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE IF NOT EXISTS `usuarios` (
  `codUsu` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(50) DEFAULT NULL,
  `clave` varchar(255) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellidos` varchar(100) DEFAULT NULL,
  `dni` varchar(9) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `poblacion` varchar(100) DEFAULT NULL,
  `provincia` varchar(100) DEFAULT NULL,
  `cp` varchar(5) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `nivel` int(11) DEFAULT NULL,
  PRIMARY KEY (`codUsu`),
  UNIQUE KEY `usuario` (`usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla daw.usuarios: ~5 rows (aproximadamente)
INSERT INTO `usuarios` (`codUsu`, `usuario`, `clave`, `nombre`, `apellidos`, `dni`, `direccion`, `poblacion`, `provincia`, `cp`, `telefono`, `nivel`) VALUES
	(1, 'tiguere@luxury.com', '1234', 'pedro', 'PEREZ', 'Y5781521W', 'Calle de la ETSE 1', 'Santiago', 'A Coruña', '15701', '600112233', NULL),
	(2, 'tiguere', '1234', 'Pedro', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(3, 'MaurizioCOl', '1234', 'Maurizio Andrés', 'Carrasquero', 'Y57815222', 'Generala Wladyslawa Andersa 24', 'Varsovia', NULL, '0201', NULL, 1),
	(4, 'Joselu14', '1234', 'Joseluis', 'Miranda', 'Y12345', 'JAJAJAJ', 'Madrid', NULL, '1234', NULL, 1),
	(5, 'Larita@jeje', '123', 'Lara', 'cacheda', 'Y56778', 'Rua de las rosas', 'santiago', 'Coruña', '4567', '6787567', 1),
	(6, 'mauriziocarrasquero@gmail.com', '123', 'Maurizio Andres', 'Carrasquero bellesi', '222222', 'Carrer Amics del Corpus 17 18 19', 'Valencia', 'VALENCIA', '46015', '684125798', 1);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
