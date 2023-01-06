-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1:3306
-- Üretim Zamanı: 31 Oca 2021, 22:12:12
-- Sunucu sürümü: 5.7.31
-- PHP Sürümü: 7.3.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `2017469080`
--

DELIMITER $$
--
-- Yordamlar
--
DROP PROCEDURE IF EXISTS `bir_yildaki_aylik_satislar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bir_yildaki_aylik_satislar` (IN `sayi` INT(11))  NO SQL
SELECT SUM(bilet.fiyat)as bilet_toplam,monthname(bilet.tarih)as tarih2 
FROM bilet
WHERE
year(bilet.tarih) = sayi
group by month(bilet.tarih)
order by month(bilet.tarih)$$

DROP PROCEDURE IF EXISTS `cift-parametreli-yillik_seferler_bazinda_satilan_biletler`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cift-parametreli-yillik_seferler_bazinda_satilan_biletler` (IN `sayi` INT(11), IN `sayi1` INT(11))  NO SQL
SELECT COUNT(bilet.bilet_id)as bilet_sayi,CONCAT(
kalkis_havalimani.ad,' - ',varis_havalimani.ad)as sefer
FROM bilet,varis_havalimani,kalkis_havalimani
WHERE
bilet.varis_havalimani_id = varis_havalimani.varis_havalimani_id
AND
bilet.kalkis_havalimani_id = kalkis_havalimani.kalkis_havalimani_id
AND
year(bilet.tarih) = sayi
GROUP by varis_havalimani.varis_havalimani_id,kalkis_havalimani.kalkis_havalimani_id
having bilet_sayi > sayi1
order by bilet_sayi desc$$

DROP PROCEDURE IF EXISTS `mevcut_ucak_listesi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mevcut_ucak_listesi` ()  NO SQL
SELECT year(model.uretim_tarihi)as tarih,marka.marka_ad,model.ad,model.koltuk_sayi
FROM marka,model
WHERE
marka.marka_id = model.marka_id$$

DROP PROCEDURE IF EXISTS `ortalama_yildan_kucuk_olan_ucaklar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ortalama_yildan_kucuk_olan_ucaklar` ()  NO SQL
SELECT *
FROM model,marka
WHERE
model.marka_id = marka.marka_id
AND
year(model.uretim_tarihi) > (SELECT year(AVG(model.uretim_tarihi))
FROM model)$$

DROP PROCEDURE IF EXISTS `satislar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `satislar` ()  NO SQL
SELECT SUM(bilet.fiyat)as yillik_bilet_satisi,year(bilet.tarih) as tarih1
FROM bilet
group by year(bilet.tarih)
order by tarih1 asc$$

DROP PROCEDURE IF EXISTS `ulkeler_bazinda_satis`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ulkeler_bazinda_satis` ()  NO SQL
SELECT sum(bilet.fiyat)as fiyat,ulke.ad
FROM bilet,musteri,ulke
WHERE
bilet.musteri_id = musteri.musteri_id
AND
ulke.ulke_id = musteri.ulke_id
GROUP BY ulke.ulke_id$$

DROP PROCEDURE IF EXISTS `yillik_bazda_ucak_doluluk_orani`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `yillik_bazda_ucak_doluluk_orani` (IN `sayi` INT(11))  NO SQL
SELECT round((count(bilet.bilet_id)/(SELECT SUM(model.koltuk_sayi)FROM model))*100)as kapasite
FROM bilet,model,ucak_bolum,bolum,ucak
WHERE
bilet.ucak_bolum_id = ucak_bolum.ucak_bolum_id
AND
bolum.ucak_bolum_id = ucak_bolum.ucak_bolum_id
AND
bolum.ucak_id = ucak.ucak_id
AND
ucak.model_id = model.model_id
AND
year(bilet.tarih) = sayi$$

DROP PROCEDURE IF EXISTS `yil_bazinda_cinsiyet_dagilimi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `yil_bazinda_cinsiyet_dagilimi` (IN `sayi` INT(11))  NO SQL
SELECT COUNT(cinsiyet.cinsiyet_id)as cinsiyet,cinsiyet.cinsiyet_tur as tur
FROM cinsiyet,bilet,musteri
WHERE
cinsiyet.cinsiyet_id = musteri.cinsiyet_id
AND
bilet.musteri_id = musteri.musteri_id
AND
year(bilet.tarih) = sayi
group by cinsiyet.cinsiyet_id$$

DROP PROCEDURE IF EXISTS `yil_bazinda_sinif_dagilimi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `yil_bazinda_sinif_dagilimi` (IN `sayi` INT(11))  NO SQL
SELECT COUNT(ucak_bolum.ucak_bolum_id)as ucak_sinif,ucak_bolum.ad as sinif_adi
FROM ucak_bolum,bilet
WHERE
ucak_bolum.ucak_bolum_id = bilet.ucak_bolum_id
AND
year(bilet.tarih) = sayi
group by ucak_bolum.ucak_bolum_id$$

DROP PROCEDURE IF EXISTS `yil_bazinda_ulke_dagilimi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `yil_bazinda_ulke_dagilimi` (IN `sayi` INT(11))  NO SQL
SELECT COUNT(ulke.ulke_id)as ulke,ulke.ad as ulke_adi
FROM ulke,musteri,bilet
WHERE
ulke.ulke_id = musteri.ulke_id
AND
bilet.musteri_id = musteri.musteri_id
AND
year(bilet.tarih) = sayi
group by ulke.ulke_id
ORDER by ulke desc$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `bilet`
--

DROP TABLE IF EXISTS `bilet`;
CREATE TABLE IF NOT EXISTS `bilet` (
  `bilet_id` int(11) NOT NULL,
  `musteri_id` int(11) NOT NULL,
  `varis_havalimani_id` int(11) NOT NULL,
  `kalkis_havalimani_id` int(11) NOT NULL,
  `ucak_bolum_id` int(11) NOT NULL,
  `fiyat` int(11) NOT NULL,
  `tarih` date NOT NULL,
  PRIMARY KEY (`bilet_id`),
  KEY `musteri_id` (`musteri_id`),
  KEY `varis_havalimani` (`varis_havalimani_id`),
  KEY `kalkis_havalimani` (`kalkis_havalimani_id`),
  KEY `ucak_bolum_id` (`ucak_bolum_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `bilet`
--

INSERT INTO `bilet` (`bilet_id`, `musteri_id`, `varis_havalimani_id`, `kalkis_havalimani_id`, `ucak_bolum_id`, `fiyat`, `tarih`) VALUES
(1, 1, 4, 6, 1, 100, '2020-01-15'),
(2, 2, 4, 6, 1, 100, '2020-01-15'),
(3, 3, 4, 6, 2, 200, '2020-01-15'),
(4, 4, 4, 6, 1, 100, '2020-01-15'),
(5, 5, 4, 6, 1, 100, '2020-01-15'),
(6, 6, 4, 6, 2, 200, '2020-01-15'),
(7, 7, 4, 6, 1, 100, '2020-01-15'),
(8, 8, 4, 6, 1, 100, '2020-01-15'),
(9, 9, 4, 6, 2, 200, '2020-01-15'),
(10, 10, 4, 6, 1, 100, '2020-01-15'),
(11, 11, 4, 6, 1, 100, '2020-01-15'),
(12, 12, 4, 6, 2, 200, '2020-01-15'),
(13, 13, 4, 6, 1, 100, '2020-01-15'),
(14, 14, 4, 6, 1, 100, '2020-01-15'),
(15, 15, 4, 6, 2, 200, '2020-01-15'),
(16, 16, 4, 2, 2, 200, '2020-02-11'),
(17, 17, 4, 2, 2, 200, '2020-02-11'),
(18, 18, 4, 2, 2, 200, '2020-02-11'),
(19, 19, 4, 2, 1, 100, '2020-02-11'),
(20, 20, 4, 2, 1, 100, '2020-02-11'),
(21, 21, 4, 2, 1, 100, '2020-02-11'),
(22, 22, 4, 2, 1, 100, '2020-02-11'),
(23, 23, 4, 2, 1, 100, '2020-02-11'),
(24, 24, 3, 4, 2, 200, '2020-03-23'),
(25, 25, 3, 4, 2, 200, '2020-03-23'),
(26, 26, 3, 4, 2, 200, '2020-03-23'),
(27, 27, 3, 4, 2, 200, '2020-03-23'),
(28, 28, 3, 4, 2, 200, '2020-03-23'),
(29, 29, 3, 4, 1, 100, '2020-03-23'),
(30, 30, 3, 4, 1, 100, '2020-03-23'),
(31, 31, 1, 4, 1, 100, '2020-04-28'),
(32, 32, 1, 4, 1, 100, '2020-04-28'),
(33, 33, 1, 4, 1, 100, '2020-04-28'),
(34, 34, 1, 4, 1, 100, '2020-04-28'),
(35, 35, 1, 4, 2, 200, '2020-04-28'),
(36, 36, 1, 4, 1, 100, '2020-04-28'),
(37, 37, 1, 4, 2, 200, '2020-04-28'),
(38, 38, 5, 6, 1, 150, '2020-05-30'),
(39, 39, 5, 6, 1, 150, '2020-05-30'),
(40, 40, 5, 6, 2, 400, '2020-05-30'),
(41, 41, 2, 6, 2, 200, '2020-06-17'),
(42, 42, 2, 6, 1, 100, '2020-06-17'),
(43, 43, 2, 6, 1, 100, '2020-06-17'),
(44, 44, 2, 6, 1, 100, '2020-06-17'),
(45, 45, 2, 6, 1, 100, '2020-06-17'),
(46, 46, 2, 6, 1, 100, '2020-06-17'),
(47, 47, 2, 6, 1, 100, '2020-06-17'),
(48, 48, 2, 4, 2, 200, '2020-07-01'),
(49, 49, 2, 4, 2, 200, '2020-07-01'),
(50, 50, 2, 4, 1, 100, '2020-07-01'),
(51, 51, 2, 4, 1, 100, '2020-07-01'),
(52, 52, 2, 4, 1, 100, '2020-07-01'),
(53, 53, 2, 4, 1, 100, '2020-07-01'),
(54, 54, 3, 6, 2, 200, '2020-08-04'),
(55, 55, 3, 6, 2, 200, '2020-08-04'),
(56, 56, 3, 6, 2, 200, '2020-08-04'),
(57, 57, 3, 6, 1, 100, '2020-08-04'),
(58, 58, 3, 6, 1, 100, '2020-08-04'),
(59, 59, 3, 6, 1, 100, '2020-08-04'),
(60, 60, 3, 6, 1, 100, '2020-08-04'),
(61, 61, 1, 5, 1, 150, '2020-09-08'),
(62, 62, 1, 5, 2, 450, '2020-09-08'),
(63, 63, 1, 5, 1, 150, '2020-09-08'),
(64, 64, 6, 2, 2, 200, '2020-10-10'),
(65, 65, 6, 2, 2, 200, '2020-10-10'),
(66, 66, 6, 2, 2, 200, '2020-10-10'),
(67, 67, 6, 2, 2, 200, '2020-10-10'),
(68, 68, 6, 2, 2, 200, '2020-10-10'),
(69, 69, 6, 2, 2, 200, '2020-10-10'),
(70, 70, 6, 2, 2, 200, '2020-10-10'),
(71, 71, 6, 2, 2, 200, '2020-10-10'),
(72, 72, 6, 2, 2, 200, '2020-10-10'),
(73, 73, 6, 2, 2, 200, '2020-10-10'),
(74, 74, 6, 2, 1, 100, '2020-10-10'),
(75, 75, 6, 2, 1, 100, '2020-10-10'),
(76, 76, 6, 2, 1, 100, '2020-10-10'),
(77, 77, 6, 2, 1, 100, '2020-10-10'),
(78, 78, 6, 2, 1, 100, '2020-10-10'),
(79, 79, 6, 2, 1, 100, '2020-10-10'),
(80, 80, 6, 2, 1, 100, '2020-10-10'),
(81, 81, 6, 2, 1, 100, '2020-10-10'),
(82, 82, 6, 2, 1, 100, '2020-10-10'),
(83, 83, 6, 2, 1, 100, '2020-10-10'),
(84, 84, 6, 2, 1, 100, '2020-10-10'),
(85, 85, 6, 2, 1, 100, '2020-10-10'),
(86, 86, 6, 5, 2, 200, '2020-11-27'),
(87, 87, 6, 5, 1, 100, '2020-11-27'),
(88, 88, 6, 5, 1, 100, '2020-11-27'),
(89, 89, 6, 5, 1, 100, '2020-11-27'),
(90, 90, 6, 5, 1, 100, '2020-11-27'),
(91, 91, 3, 5, 1, 100, '2020-12-12'),
(92, 92, 3, 5, 1, 100, '2020-12-12'),
(93, 93, 3, 5, 1, 100, '2020-12-12'),
(94, 94, 3, 5, 1, 100, '2020-12-12'),
(95, 95, 3, 5, 1, 100, '2020-12-12'),
(96, 96, 3, 5, 1, 100, '2020-12-12'),
(97, 97, 3, 5, 2, 200, '2020-12-12'),
(98, 98, 3, 5, 2, 200, '2020-12-12'),
(99, 99, 3, 5, 2, 200, '2020-12-12'),
(100, 100, 3, 5, 2, 200, '2020-12-12'),
(101, 101, 1, 3, 2, 200, '2019-01-01'),
(102, 102, 1, 3, 1, 100, '2019-01-01'),
(103, 103, 1, 3, 2, 200, '2019-01-01'),
(104, 104, 1, 3, 1, 100, '2019-01-01'),
(105, 105, 1, 3, 1, 100, '2019-01-01'),
(106, 106, 1, 3, 1, 100, '2019-01-01'),
(107, 107, 1, 3, 2, 200, '2019-01-01'),
(108, 108, 2, 5, 1, 100, '2019-02-14'),
(109, 109, 2, 5, 2, 200, '2019-02-14'),
(110, 110, 2, 5, 1, 100, '2019-02-14'),
(111, 111, 2, 5, 2, 200, '2019-02-14'),
(112, 112, 2, 5, 1, 100, '2019-02-14'),
(113, 113, 3, 4, 1, 100, '2019-02-14'),
(114, 114, 4, 5, 1, 100, '2019-03-28'),
(115, 115, 4, 5, 1, 100, '2019-03-28'),
(116, 116, 4, 5, 2, 200, '2019-03-28'),
(117, 117, 4, 5, 1, 100, '2019-03-28'),
(118, 118, 4, 5, 2, 200, '2019-03-28'),
(119, 119, 4, 5, 1, 100, '2019-03-28'),
(120, 120, 6, 2, 2, 200, '2019-04-13'),
(121, 121, 6, 2, 1, 100, '2019-04-13'),
(122, 122, 6, 2, 1, 100, '2019-04-13'),
(123, 123, 6, 2, 1, 100, '2019-04-13'),
(124, 124, 6, 2, 1, 100, '2019-04-13'),
(125, 125, 5, 1, 1, 100, '2019-05-18'),
(126, 126, 5, 1, 1, 100, '2019-05-18'),
(127, 127, 5, 1, 2, 200, '2019-05-18'),
(128, 128, 5, 1, 2, 200, '2019-05-18'),
(129, 129, 5, 1, 2, 200, '2019-05-18'),
(130, 130, 5, 1, 1, 100, '2019-05-18'),
(131, 131, 5, 1, 1, 100, '2019-05-18'),
(132, 132, 5, 1, 2, 200, '2019-05-18'),
(133, 133, 5, 1, 2, 200, '2019-05-18'),
(134, 134, 3, 6, 2, 200, '2019-06-09'),
(135, 135, 3, 6, 2, 200, '2019-06-09'),
(136, 136, 3, 6, 1, 100, '2019-06-09'),
(137, 137, 3, 6, 1, 100, '2019-06-09'),
(138, 138, 3, 6, 1, 100, '2019-06-09'),
(139, 139, 3, 6, 1, 100, '2019-06-09'),
(140, 140, 3, 6, 1, 100, '2019-06-09'),
(141, 141, 3, 6, 1, 100, '2019-06-09'),
(142, 142, 3, 6, 2, 200, '2019-06-09'),
(143, 143, 3, 6, 1, 100, '2019-06-09'),
(144, 144, 3, 6, 2, 200, '2019-06-09'),
(145, 145, 1, 4, 1, 100, '2019-07-13'),
(146, 146, 1, 4, 2, 200, '2019-07-13'),
(147, 147, 1, 4, 2, 200, '2019-07-13'),
(148, 148, 1, 4, 2, 200, '2019-07-13'),
(149, 149, 1, 4, 1, 100, '2019-07-13'),
(150, 150, 1, 4, 1, 100, '2019-07-13'),
(151, 151, 1, 4, 1, 100, '2019-07-13'),
(152, 152, 1, 4, 1, 100, '2019-07-13'),
(153, 153, 1, 4, 2, 200, '2019-07-13'),
(154, 154, 1, 4, 2, 200, '2019-07-13'),
(155, 155, 1, 4, 2, 200, '2019-07-13'),
(156, 156, 3, 1, 1, 100, '2019-08-10'),
(157, 157, 3, 1, 2, 200, '2019-08-10'),
(158, 158, 3, 1, 2, 200, '2019-08-10'),
(159, 159, 3, 1, 1, 100, '2019-08-10'),
(160, 160, 3, 1, 1, 100, '2019-08-10'),
(161, 161, 3, 1, 1, 100, '2019-08-10'),
(162, 162, 3, 1, 2, 200, '2019-08-10'),
(163, 163, 3, 1, 2, 200, '2019-08-10'),
(164, 164, 3, 1, 1, 100, '2019-08-10'),
(165, 165, 3, 1, 1, 100, '2019-08-10'),
(166, 166, 3, 1, 2, 200, '2019-08-10'),
(167, 167, 3, 1, 1, 100, '2019-08-10'),
(168, 168, 3, 1, 1, 100, '2019-08-10'),
(169, 169, 3, 1, 2, 200, '2019-08-10'),
(170, 170, 3, 1, 2, 200, '2019-08-10'),
(171, 171, 3, 1, 2, 200, '2019-08-10'),
(172, 172, 5, 3, 1, 100, '2019-09-27'),
(173, 173, 5, 3, 2, 200, '2019-09-27'),
(174, 174, 5, 3, 1, 100, '2019-09-27'),
(175, 175, 5, 3, 2, 200, '2019-09-27'),
(176, 176, 5, 4, 1, 100, '2019-10-20'),
(177, 177, 5, 4, 2, 200, '2019-10-20'),
(178, 178, 5, 4, 2, 200, '2019-10-20'),
(179, 179, 5, 2, 1, 100, '2019-11-11'),
(180, 180, 5, 2, 2, 200, '2019-11-11'),
(181, 181, 5, 2, 1, 100, '2019-11-11'),
(182, 182, 4, 3, 1, 100, '2019-12-31'),
(183, 183, 4, 3, 2, 200, '2019-12-31'),
(184, 184, 4, 3, 2, 200, '2019-12-31'),
(185, 185, 1, 3, 1, 100, '2018-01-21'),
(186, 186, 1, 3, 1, 100, '2018-01-21'),
(187, 187, 1, 3, 2, 200, '2018-01-21'),
(188, 188, 2, 3, 1, 100, '2018-02-22'),
(189, 189, 2, 3, 2, 200, '2018-02-22'),
(190, 190, 2, 3, 2, 200, '2018-02-22'),
(191, 191, 2, 3, 1, 100, '2018-02-22'),
(192, 192, 3, 4, 1, 100, '2018-03-14'),
(193, 193, 3, 4, 1, 100, '2018-03-14'),
(194, 194, 3, 4, 2, 200, '2018-03-14'),
(195, 195, 3, 4, 1, 100, '2018-03-14'),
(196, 196, 3, 4, 2, 200, '2018-03-14'),
(197, 197, 4, 5, 1, 100, '2018-04-02'),
(198, 198, 4, 5, 2, 200, '2018-04-02'),
(199, 199, 4, 5, 1, 100, '2018-04-02'),
(200, 200, 4, 5, 1, 100, '2018-04-02'),
(201, 201, 4, 5, 2, 200, '2018-04-02'),
(202, 202, 4, 5, 1, 100, '2018-04-02'),
(203, 203, 6, 2, 1, 100, '2018-05-09'),
(204, 204, 6, 2, 1, 100, '2018-05-09'),
(205, 205, 6, 2, 2, 200, '2018-05-09'),
(206, 206, 6, 2, 1, 100, '2018-05-09'),
(207, 207, 6, 2, 2, 200, '2018-05-09'),
(208, 208, 6, 2, 1, 100, '2018-05-09'),
(209, 209, 6, 2, 1, 100, '2018-05-09'),
(210, 210, 6, 2, 2, 200, '2018-05-09'),
(211, 211, 5, 1, 1, 100, '2018-06-24'),
(212, 212, 5, 1, 2, 200, '2018-06-24'),
(213, 213, 5, 1, 1, 100, '2018-06-24'),
(214, 214, 5, 1, 2, 200, '2018-06-24'),
(215, 215, 5, 1, 2, 200, '2018-06-24'),
(216, 216, 5, 1, 2, 200, '2018-06-24'),
(217, 217, 5, 1, 1, 100, '2018-06-24'),
(218, 218, 3, 6, 1, 100, '2018-07-10'),
(219, 219, 3, 6, 1, 100, '2018-07-10'),
(220, 220, 3, 6, 2, 200, '2018-07-10'),
(221, 221, 1, 4, 1, 100, '2018-08-31'),
(222, 222, 1, 4, 1, 100, '2018-08-31'),
(223, 223, 1, 4, 2, 200, '2018-08-31'),
(224, 224, 1, 4, 1, 100, '2018-08-31'),
(225, 225, 1, 4, 2, 200, '2018-08-31'),
(226, 226, 1, 4, 1, 100, '2018-08-31'),
(227, 227, 1, 4, 1, 100, '2018-08-31'),
(228, 228, 1, 4, 1, 100, '2018-09-24'),
(229, 229, 1, 4, 2, 200, '2018-09-24'),
(230, 230, 1, 4, 1, 100, '2018-09-24'),
(231, 231, 1, 4, 1, 100, '2018-09-24'),
(232, 232, 3, 1, 1, 100, '2018-10-12'),
(233, 233, 3, 1, 2, 200, '2018-10-12'),
(234, 234, 3, 1, 2, 200, '2018-10-12'),
(235, 235, 3, 1, 1, 100, '2018-10-12'),
(236, 236, 5, 3, 1, 100, '2018-11-23'),
(237, 237, 5, 3, 2, 200, '2018-11-23'),
(238, 238, 5, 3, 1, 100, '2018-11-23'),
(239, 239, 5, 3, 2, 200, '2018-11-23'),
(240, 240, 5, 3, 1, 100, '2018-11-23'),
(241, 241, 5, 2, 1, 100, '2018-12-17'),
(242, 242, 5, 2, 2, 200, '2018-12-17'),
(243, 243, 5, 2, 1, 100, '2018-12-17'),
(244, 244, 5, 5, 2, 200, '2018-12-17');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `bolum`
--

DROP TABLE IF EXISTS `bolum`;
CREATE TABLE IF NOT EXISTS `bolum` (
  `ucak_id` int(11) NOT NULL,
  `ucak_bolum_id` int(11) NOT NULL,
  KEY `ucak_id` (`ucak_id`),
  KEY `ucak_bolum_id` (`ucak_bolum_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `bolum`
--

INSERT INTO `bolum` (`ucak_id`, `ucak_bolum_id`) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 2),
(3, 1),
(3, 2),
(4, 1),
(4, 2),
(5, 1),
(5, 2),
(6, 1),
(6, 2),
(7, 1),
(7, 2),
(8, 1),
(8, 2);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `cinsiyet`
--

DROP TABLE IF EXISTS `cinsiyet`;
CREATE TABLE IF NOT EXISTS `cinsiyet` (
  `cinsiyet_id` int(11) NOT NULL,
  `cinsiyet_tur` varchar(255) COLLATE utf8_turkish_ci NOT NULL,
  PRIMARY KEY (`cinsiyet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `cinsiyet`
--

INSERT INTO `cinsiyet` (`cinsiyet_id`, `cinsiyet_tur`) VALUES
(1, 'Erkek'),
(2, 'Kadın');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `guncel_ucak_sayisi`
--

DROP TABLE IF EXISTS `guncel_ucak_sayisi`;
CREATE TABLE IF NOT EXISTS `guncel_ucak_sayisi` (
  `sayi` int(11) NOT NULL,
  `tarih` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `guncel_ucak_sayisi`
--

INSERT INTO `guncel_ucak_sayisi` (`sayi`, `tarih`) VALUES
(9, '2021-01-31');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `kalkis_havalimani`
--

DROP TABLE IF EXISTS `kalkis_havalimani`;
CREATE TABLE IF NOT EXISTS `kalkis_havalimani` (
  `kalkis_havalimani_id` int(11) NOT NULL,
  `ad` varchar(255) COLLATE utf8_turkish_ci NOT NULL,
  PRIMARY KEY (`kalkis_havalimani_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `kalkis_havalimani`
--

INSERT INTO `kalkis_havalimani` (`kalkis_havalimani_id`, `ad`) VALUES
(1, 'İzmir Adnan Menderes Havalimanı'),
(2, 'İstanbul Sabiha Gökçen Havalimanı'),
(3, 'İstanbul Havalimanı'),
(4, 'Eskişehir Hasan Polatkan Havalimanı'),
(5, 'Ankara Esenboğa Havalimanı'),
(6, 'Alanya Gazipaşa Havalimanı'),
(7, 'Trabzon Havalimanı'),
(8, 'Sivas Nuri Demirağ Havalimanı'),
(9, 'Ordu-Giresun Havalimanı'),
(10, 'Nevşehir Kapadokya Havalimanı'),
(11, 'Milas-Bodrum Havalimanı'),
(12, 'Isparta Süleyman Demirel Havalimanı'),
(13, 'Adana Şakirpaşa Havalimanı');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `marka`
--

DROP TABLE IF EXISTS `marka`;
CREATE TABLE IF NOT EXISTS `marka` (
  `marka_id` int(11) NOT NULL,
  `marka_ad` varchar(255) COLLATE utf8_turkish_ci NOT NULL,
  PRIMARY KEY (`marka_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `marka`
--

INSERT INTO `marka` (`marka_id`, `marka_ad`) VALUES
(1, 'AIRBUS'),
(2, 'BOEING');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `model`
--

DROP TABLE IF EXISTS `model`;
CREATE TABLE IF NOT EXISTS `model` (
  `model_id` int(11) NOT NULL,
  `marka_id` int(11) NOT NULL,
  `uretim_tarihi` date NOT NULL,
  `ad` varchar(255) COLLATE utf8_turkish_ci NOT NULL,
  `koltuk_sayi` int(11) NOT NULL,
  PRIMARY KEY (`model_id`),
  KEY `marka_id` (`marka_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `model`
--

INSERT INTO `model` (`model_id`, `marka_id`, `uretim_tarihi`, `ad`, `koltuk_sayi`) VALUES
(1, 1, '1974-11-21', 'A300', 100),
(2, 1, '1985-01-02', 'A310', 120),
(3, 1, '2013-08-04', 'A350', 110),
(4, 1, '2007-11-22', 'A380', 100),
(5, 2, '1998-02-03', '717', 130),
(6, 2, '1992-09-04', '777', 105),
(7, 2, '1978-03-10', '767', 110),
(8, 2, '1970-05-21', '747', 110),
(9, 1, '2011-04-28', 'A900', 120);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `musteri`
--

DROP TABLE IF EXISTS `musteri`;
CREATE TABLE IF NOT EXISTS `musteri` (
  `musteri_id` int(11) NOT NULL,
  `cinsiyet_id` int(11) NOT NULL,
  `ulke_id` int(11) NOT NULL,
  `musteri_ad` varchar(255) COLLATE utf8_turkish_ci NOT NULL,
  `musteri_soyad` varchar(255) COLLATE utf8_turkish_ci NOT NULL,
  PRIMARY KEY (`musteri_id`),
  KEY `cinsiyet_id` (`cinsiyet_id`),
  KEY `ulke_id` (`ulke_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `musteri`
--

INSERT INTO `musteri` (`musteri_id`, `cinsiyet_id`, `ulke_id`, `musteri_ad`, `musteri_soyad`) VALUES
(1, 1, 1, 'Eren ', 'Şengül'),
(2, 1, 1, 'Talha ', 'Uyanık'),
(3, 1, 1, 'Ali', 'Bayram'),
(4, 2, 1, 'Melisa', 'Uyar'),
(5, 2, 1, 'Serpil', 'Yıldırım'),
(6, 2, 1, 'Dilek', 'Çalıpınar'),
(7, 1, 7, 'İlham', 'Aliyev'),
(8, 2, 7, 'Mehriban ', 'Aliyeva'),
(9, 2, 7, 'Sultan', 'Aliyeva'),
(10, 1, 1, 'Mehmet', 'Barlas'),
(11, 1, 2, 'Mario ', 'Gomez'),
(12, 1, 2, 'Sebastian ', 'Vettel'),
(13, 2, 2, 'Angela', 'Merkel'),
(14, 2, 2, 'Sophie', 'Hoffmann'),
(15, 1, 1, 'Gökay', 'Çermikli'),
(16, 1, 1, 'Hasan ', 'Kadir'),
(17, 1, 2, 'Manuel', 'Neuer'),
(18, 1, 2, 'Leon ', 'Goretzka'),
(19, 1, 2, 'Serge', 'Gnabry'),
(20, 1, 3, 'Vladimir', 'Putin'),
(21, 1, 3, 'Joseph', 'Stalin'),
(22, 1, 3, 'Vladimir', 'Lenin'),
(23, 1, 3, 'Sergey', 'Lavrov'),
(24, 1, 3, 'Leon', 'Trotsky'),
(25, 2, 4, 'Amy', 'Santiago'),
(26, 1, 4, 'Rosa', 'Diaz'),
(27, 1, 4, 'Jake', 'Peralta'),
(28, 1, 4, 'Raymond', 'Holt'),
(29, 1, 4, 'Charles', 'Boyle'),
(30, 2, 4, 'Robin', 'Scherbatsky'),
(31, 2, 4, 'Lily', 'Aldrin'),
(32, 1, 5, 'Francesco', 'Totti'),
(33, 1, 5, 'Andrea ', 'Pirlo'),
(34, 1, 5, 'Silvio', 'Berlusconi'),
(35, 1, 5, 'Gianluigi ', 'Buffon'),
(36, 1, 5, 'Andrea', 'Belotti'),
(37, 1, 5, 'Ciro', 'Immobile'),
(38, 1, 6, 'Dayot', 'Upamecano'),
(39, 1, 6, 'Antoine', 'Griezmann'),
(40, 1, 6, 'Eric', 'Cantona'),
(41, 1, 6, 'Zinedine', 'Zidane'),
(42, 2, 8, 'Nevin', 'Çölbe'),
(43, 2, 8, 'Zerrin ', 'Çakır'),
(44, 2, 8, 'Dilek', 'Gülcan'),
(45, 2, 8, 'Tuğçe ', 'Gül'),
(46, 2, 8, 'Suzan ', 'Güven'),
(47, 1, 1, 'Ömer', 'Altay'),
(48, 1, 1, 'Kasım', 'Çetinkor'),
(49, 2, 1, 'Yonca', 'Baysal'),
(50, 1, 1, 'Serhan', 'Variyenli'),
(51, 1, 1, 'Ercan', 'Sürücü'),
(52, 2, 1, 'Feyza', 'Karabaşı'),
(53, 1, 1, 'Mehmet', 'Eryavuz'),
(54, 1, 1, 'Doğan', 'Savran'),
(55, 2, 1, 'Derya', 'Akten'),
(56, 1, 1, 'Andaç', 'Tombul'),
(57, 1, 1, 'Atılgan', 'Kahveci'),
(58, 2, 1, 'Gizem', 'Lokumcu'),
(59, 1, 1, 'Kıvanç', 'Sevdiyar'),
(60, 1, 1, 'Fırat', 'Karatürk'),
(61, 2, 1, 'Nesrin ', 'Cüreoğlu'),
(62, 1, 1, 'Hasan', 'Tek'),
(63, 1, 1, 'Ali', 'Seyit'),
(64, 2, 1, 'Eliz', 'Saraçlı'),
(65, 1, 1, 'Abdulaziz', 'Arga'),
(66, 1, 1, 'Kemal Kürşat', 'Cömert'),
(67, 2, 1, 'Şeyma', 'Doğangüzel'),
(68, 1, 1, 'Benan', 'Tamir'),
(69, 1, 1, 'Muhammet', 'Durmuş'),
(70, 2, 1, 'Ada', 'Bostanoğlu'),
(71, 1, 1, 'Furkan', 'Candemir'),
(72, 1, 1, 'Mustafa', 'Fişek'),
(73, 2, 1, 'Semina', 'Gençtürk'),
(74, 1, 1, 'Bilgi', 'Hüseyinoğlu'),
(75, 1, 1, 'Hidayet', 'Büyükdoğan'),
(76, 2, 1, 'Ayşen', 'Güven'),
(77, 1, 1, 'Muammer', 'Mendeş'),
(78, 1, 1, 'Sezgi', 'Keskin'),
(79, 2, 1, 'Gülberat', 'Numanoğlu'),
(80, 1, 1, 'Halil İbrahim ', 'Soytaş'),
(81, 1, 1, 'Bilal', 'Çakır'),
(82, 2, 1, 'Sevgül', 'Kızmaz'),
(83, 1, 1, 'Iraz', 'Tunçer'),
(84, 1, 1, 'Hacı', 'Gölge'),
(85, 2, 1, 'Özlem', 'Çetin'),
(86, 1, 1, 'Ali Rıza', 'Kızıl'),
(87, 1, 1, 'Nevzat', 'Ünlü'),
(88, 2, 1, 'Zübeyde', 'Aksakal'),
(89, 1, 1, 'Ali', 'Servi'),
(90, 1, 1, 'Ahmet', 'Ediz'),
(91, 2, 1, 'Demet', 'Serap'),
(92, 1, 1, 'Kenan', 'Tuğan'),
(93, 1, 1, 'Mert Metin', 'Buğraz'),
(94, 2, 1, 'İlayda', 'Sertel'),
(95, 1, 1, 'Ahmet Gökhan', 'Turp'),
(96, 1, 1, 'Talha', 'Karatoprak'),
(97, 2, 1, 'Sezen', 'Fettahoğlu'),
(98, 1, 1, 'İsmail', 'Suzan'),
(99, 1, 1, 'Yüksel', 'Uslubaş'),
(100, 2, 1, 'Yaprak', 'Uslubaş'),
(101, 1, 1, 'Tunga ', 'Yardımcı'),
(102, 2, 4, 'Amy', 'Diego'),
(103, 2, 2, 'Lea', 'Goretzka'),
(104, 1, 1, 'İrfan', 'Sarı'),
(105, 2, 1, 'Aybüke', 'Türk'),
(106, 1, 1, 'Doğu', 'Perinçek'),
(107, 1, 6, 'Nicholas', 'Sarkozy'),
(108, 1, 4, 'Joe', 'Biden'),
(109, 1, 4, 'Donald', 'Trump'),
(110, 1, 1, 'Ertuğrul', 'Kürkçü'),
(111, 1, 2, 'Oliver', 'Kahn'),
(112, 1, 1, 'Sergen', 'Yalçın'),
(113, 2, 1, 'Mevhibe', 'Yalçın'),
(114, 1, 1, 'Ersin', 'Destanoğlu'),
(115, 1, 1, 'Rıdvan', 'Yılmaz'),
(116, 2, 1, 'Ayşe', 'Yılmaz'),
(117, 1, 1, 'Kemal', 'Kılıçdaroğlu'),
(118, 2, 1, 'Selvi', 'Kılıçdaroğlu'),
(119, 1, 1, 'Devlet', 'Bahçeli'),
(120, 2, 1, 'Meral', 'Akşener'),
(121, 2, 3, 'Maria', 'Sharapova'),
(122, 1, 3, 'Artem', 'Dzyuba'),
(123, 1, 3, 'Mario', 'Fernandes'),
(124, 1, 5, 'Alessandro', 'Di Stefano'),
(125, 1, 5, 'Mattia', 'Binotto'),
(126, 1, 4, 'Lewis', 'Hamilton'),
(127, 1, 1, 'Gene', 'Haas'),
(128, 1, 6, 'Pascal', 'Nouma'),
(129, 1, 1, 'Oktay', 'Vural'),
(130, 1, 1, 'Mehmet', 'Şahin'),
(131, 1, 1, 'Muharrem', 'İnce'),
(132, 1, 1, 'Merve', 'İnce'),
(133, 1, 1, 'Arda', 'Turan'),
(134, 1, 1, 'Semih', 'Kaya'),
(135, 1, 1, 'Mert', 'Yeşilbaş'),
(136, 2, 1, 'Serap', 'Çakır'),
(137, 2, 1, 'Habibe', 'Çakır'),
(138, 2, 4, 'Melissa', 'Fuerro'),
(139, 2, 1, 'Ted', 'Mosby'),
(140, 1, 4, 'Marshall', 'Eriksen'),
(141, 1, 8, 'Şahin', 'Güçlü'),
(142, 1, 1, 'Abbas', 'Güçlü'),
(143, 2, 1, 'Cemile ', 'Meraş'),
(144, 1, 1, 'Umut', 'Meraş'),
(145, 1, 1, 'Mert', 'Meraş'),
(146, 2, 1, 'Kamuran', 'Ayhan'),
(147, 1, 1, 'Kaan', 'Ayhan'),
(148, 1, 6, 'Charles', 'Leclerc'),
(149, 2, 6, 'Charlotte', 'Leclerc'),
(150, 1, 1, 'Sönmez', 'Ateş'),
(151, 1, 1, 'Tosun', 'Kaya'),
(152, 2, 1, 'Dilara', 'Kaya'),
(153, 2, 1, 'Sultan', 'Kaya'),
(154, 1, 1, 'Çetin', 'Tekindor'),
(155, 2, 1, 'Ayça', 'Servet'),
(156, 1, 1, 'Baran', 'Karadaş'),
(157, 1, 1, 'Mert Gökhan', 'Dönmez'),
(158, 1, 1, 'Tunahan', 'Öztürk'),
(159, 2, 4, 'Mia', 'Malkova'),
(160, 1, 8, 'Eren', 'Çetin'),
(161, 1, 8, 'Mustafa', 'Çetin'),
(162, 1, 1, 'Tevfik', 'Fikret'),
(163, 2, 1, 'Şahika', 'Fikret'),
(164, 1, 1, 'Tansu', 'Akşit'),
(165, 2, 1, 'Bengühan', 'İskender'),
(166, 2, 1, 'Berna', 'Tunaoğlu'),
(167, 1, 1, 'Emin ', 'Turan'),
(168, 1, 1, 'Hatice', 'Barut'),
(169, 1, 1, 'Fatma', 'Esra'),
(170, 1, 1, 'Halil İbrahim', 'Özlü'),
(171, 2, 1, 'Derya', 'Gedik'),
(172, 1, 1, 'Kenan', 'Işık'),
(173, 2, 4, 'Maggie', 'Jackson'),
(174, 2, 4, 'Zoey', 'Atkinson'),
(175, 2, 8, 'Berfin', 'Yorgun'),
(176, 1, 1, 'Nafiz', 'Zeyli'),
(177, 1, 1, 'Erdal', 'Erzincan'),
(178, 2, 1, 'Mercan', 'Erzincan'),
(179, 2, 1, 'Sema', 'Şengül'),
(180, 1, 1, 'Ali ', 'Özden'),
(181, 1, 4, 'Barney', 'Stinson'),
(182, 1, 1, 'Neil Patrick', 'Harris'),
(183, 2, 1, 'Buse', 'Kaya'),
(184, 1, 1, 'Ahmet', 'Kaya'),
(185, 1, 1, 'Mehmet', 'Kaya'),
(186, 2, 2, 'Mesut', 'Özil'),
(187, 2, 2, 'Leona', 'Kramaric'),
(188, 1, 2, 'Thomas', 'Müller'),
(189, 1, 4, 'Terry', 'Crowe'),
(190, 2, 4, 'Chelsea', 'Sainz'),
(191, 2, 1, 'Begüm', 'Önder'),
(192, 1, 1, 'Himmet', 'Çepni'),
(193, 1, 1, 'Ayhan', 'Olmuş'),
(194, 1, 1, 'Cafer', 'Bostancı'),
(195, 2, 1, 'Kübra', 'Çamur'),
(196, 1, 1, 'Sefa', 'Çamur'),
(197, 2, 1, 'Azra', 'Akın'),
(198, 2, 1, 'Alara', 'Aksu'),
(199, 1, 1, 'Mustafa', 'Tarkan'),
(200, 1, 1, 'Tunahan', 'Özel'),
(201, 1, 1, 'Emre', 'Baltaoğlu'),
(202, 1, 1, 'Erdi', 'Özüağ'),
(203, 1, 1, 'Barış', 'Özcan'),
(204, 1, 1, 'Volkan ', 'Öge'),
(205, 2, 1, 'Melis', 'Öge'),
(206, 1, 1, 'Ahmet', 'Çakar'),
(207, 1, 1, 'Sinan', 'Engin'),
(208, 2, 1, 'Ayşe', 'Engin'),
(209, 1, 1, 'Rasim Ozan', 'Kütahyalı'),
(210, 2, 1, 'Nagehan', 'Alçı'),
(211, 1, 1, 'Hülya', 'Hökenek'),
(212, 2, 1, 'Çiğdem', 'Tarhan'),
(213, 2, 1, 'Alara', 'Şolt'),
(214, 1, 1, 'İbrahim', 'Halil'),
(215, 1, 1, 'Deniz', 'Çeçen'),
(216, 2, 4, 'Emma', 'Diaz'),
(217, 1, 1, 'Ahmet', 'Demirkol'),
(218, 1, 1, 'Eren', 'Yalçın'),
(219, 1, 1, 'Can', 'Gürer'),
(220, 1, 1, 'Fahri', 'Güner'),
(221, 2, 1, 'Aysel', 'Yar'),
(222, 1, 1, 'Vahap', 'Tecim'),
(223, 1, 1, 'Yılmaz', 'Gökşen'),
(224, 2, 1, 'Ceyda', 'Ünal'),
(225, 1, 1, 'Kutan', 'Koruyan'),
(226, 1, 1, 'Kaan', 'Yaralıoğlu'),
(227, 1, 1, 'Kalender', 'Göre'),
(228, 2, 1, 'Mine', 'Çete'),
(229, 1, 1, 'Fırat', 'Aras'),
(230, 1, 1, 'Fırat', 'Çetiner'),
(231, 1, 1, 'Hüsnü', 'Saatçi'),
(232, 1, 6, 'Kevin', 'N\'Koudou'),
(233, 1, 6, 'Valentin', 'Rosier'),
(234, 2, 1, 'Nilay', 'Şencan'),
(235, 2, 1, 'Ayten', 'Alpman'),
(236, 2, 1, 'Seval', 'Coşkun'),
(237, 2, 1, 'Tuğçe', 'Yücedağ'),
(238, 1, 1, 'Murat', 'Yücedağ'),
(239, 1, 1, 'Can', 'Koru'),
(240, 1, 1, 'Mustafa', 'Ferhat'),
(241, 1, 1, 'Teyfik', 'Kılıç'),
(242, 1, 1, 'Fatih', 'Portakal'),
(243, 1, 1, 'Yavuz', 'Ağıralioğlu'),
(244, 1, 1, 'Mustafa', 'Gök'),
(245, 2, 1, 'Şerban', 'Gök');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `ucak`
--

DROP TABLE IF EXISTS `ucak`;
CREATE TABLE IF NOT EXISTS `ucak` (
  `ucak_id` int(11) NOT NULL,
  `model_id` int(11) NOT NULL,
  PRIMARY KEY (`ucak_id`),
  KEY `model_id` (`model_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `ucak`
--

INSERT INTO `ucak` (`ucak_id`, `model_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9);

--
-- Tetikleyiciler `ucak`
--
DROP TRIGGER IF EXISTS `guncel_ucak_sayisi`;
DELIMITER $$
CREATE TRIGGER `guncel_ucak_sayisi` AFTER INSERT ON `ucak` FOR EACH ROW INSERT INTO guncel_ucak_sayisi values ((SELECT COUNT(*) FROM ucak),now())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `ucak_bolum`
--

DROP TABLE IF EXISTS `ucak_bolum`;
CREATE TABLE IF NOT EXISTS `ucak_bolum` (
  `ucak_bolum_id` int(11) NOT NULL,
  `ad` varchar(255) COLLATE utf8_turkish_ci NOT NULL,
  PRIMARY KEY (`ucak_bolum_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `ucak_bolum`
--

INSERT INTO `ucak_bolum` (`ucak_bolum_id`, `ad`) VALUES
(1, 'Ekonomi'),
(2, 'Business');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `ulke`
--

DROP TABLE IF EXISTS `ulke`;
CREATE TABLE IF NOT EXISTS `ulke` (
  `ulke_id` int(11) NOT NULL,
  `ad` varchar(255) COLLATE utf8_turkish_ci NOT NULL,
  PRIMARY KEY (`ulke_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `ulke`
--

INSERT INTO `ulke` (`ulke_id`, `ad`) VALUES
(1, 'Türkiye'),
(2, 'Almanya'),
(3, 'Rusya Federasyonu'),
(4, 'Amerika Birleşik Devletleri'),
(5, 'İtalya'),
(6, 'Fransa'),
(7, 'Azerbaycan'),
(8, 'Kuzey Kıbrıs Türk Cumhuriyeti');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `varis_havalimani`
--

DROP TABLE IF EXISTS `varis_havalimani`;
CREATE TABLE IF NOT EXISTS `varis_havalimani` (
  `varis_havalimani_id` int(11) NOT NULL,
  `ad` varchar(255) COLLATE utf8_turkish_ci NOT NULL,
  PRIMARY KEY (`varis_havalimani_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `varis_havalimani`
--

INSERT INTO `varis_havalimani` (`varis_havalimani_id`, `ad`) VALUES
(1, 'İzmir Adnan Menderes Havalimanı'),
(2, 'İstanbul Sabiha Gökçen Havalimanı'),
(3, 'İstanbul Havalimanı'),
(4, 'Eskişehir Hasan Polatkan Havalimanı'),
(5, 'Ankara Esenboğa Havalimanı'),
(6, 'Alanya Gazipaşa Havalimanı'),
(7, 'Trabzon Havalimanı'),
(8, 'Sivas Nuri Demirağ Havalimanı'),
(9, 'Ordu-Giresun Havalimanı'),
(10, 'Nevşehir Kapadokya Havalimanı'),
(11, 'Milas-Bodrum Havalimanı'),
(12, 'Isparta Süleyman Demirel Havalimanı'),
(13, 'Adana Şakirpaşa Havalimanı');

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `bilet`
--
ALTER TABLE `bilet`
  ADD CONSTRAINT `bilet_ibfk_1` FOREIGN KEY (`musteri_id`) REFERENCES `musteri` (`musteri_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `bilet_ibfk_2` FOREIGN KEY (`ucak_bolum_id`) REFERENCES `ucak_bolum` (`ucak_bolum_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `bilet_ibfk_3` FOREIGN KEY (`kalkis_havalimani_id`) REFERENCES `kalkis_havalimani` (`kalkis_havalimani_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `bilet_ibfk_4` FOREIGN KEY (`varis_havalimani_id`) REFERENCES `varis_havalimani` (`varis_havalimani_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `bolum`
--
ALTER TABLE `bolum`
  ADD CONSTRAINT `bolum_ibfk_1` FOREIGN KEY (`ucak_id`) REFERENCES `ucak` (`ucak_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `bolum_ibfk_2` FOREIGN KEY (`ucak_bolum_id`) REFERENCES `ucak_bolum` (`ucak_bolum_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `model`
--
ALTER TABLE `model`
  ADD CONSTRAINT `model_ibfk_1` FOREIGN KEY (`marka_id`) REFERENCES `marka` (`marka_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `musteri`
--
ALTER TABLE `musteri`
  ADD CONSTRAINT `musteri_ibfk_1` FOREIGN KEY (`cinsiyet_id`) REFERENCES `cinsiyet` (`cinsiyet_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `musteri_ibfk_2` FOREIGN KEY (`ulke_id`) REFERENCES `ulke` (`ulke_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `ucak`
--
ALTER TABLE `ucak`
  ADD CONSTRAINT `ucak_ibfk_1` FOREIGN KEY (`model_id`) REFERENCES `model` (`model_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
