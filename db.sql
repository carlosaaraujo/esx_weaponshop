-- --------------------------------------------------------
-- Servidor:                     localhost
-- Versão do servidor:           10.4.18-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              11.2.0.6213
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for table es_extended.weashops
CREATE TABLE IF NOT EXISTS `weashops` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zone` varchar(255) NOT NULL,
  `item` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  `desc` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela es_extended.weashops: ~0 rows (aproximadamente)
DELETE FROM `weashops`;
/*!40000 ALTER TABLE `weashops` DISABLE KEYS */;
INSERT INTO `weashops` (`id`, `zone`, `item`, `price`, `desc`) VALUES
	(1, 'GunShop', 'WEAPON_PISTOL', 300, 'Generic description'),
	(3, 'GunShop', 'WEAPON_VINTAGEPISTOL', 60, 'Generic description'),
	(5, 'GunShop', 'WEAPON_HATCHET', 90, 'Generic description'),
	(9, 'GunShop', 'WEAPON_DAGGER', 100, 'Generic description'),
	(11, 'GunShop', 'WEAPON_KNIFE', 50, 'Generic description'),
	(13, 'GunShop', 'WEAPON_SWITCHBLADE', 1400, 'Generic description'),
	(15, 'GunShop', 'WEAPON_FLASHLIGHT', 3400, 'Generic description'),
	(17, 'GunShop', 'WEAPON_HAMMER', 10000, 'Generic description'),
	(23, 'GunShop', 'WEAPON_CROWBAR', 18000, 'Generic description'),
	(24, 'GunShop', 'WEAPON_BAT', 100, 'Generic description');
/*!40000 ALTER TABLE `weashops` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
