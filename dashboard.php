<?php
include("auth_session.php");
$baglan = mysqli_connect('localhost', 'root', 'Erensen8', '2017469080');
$tercih_sinif = "SELECT COUNT(ucak_bolum.ucak_bolum_id) as ucak_sinif,ucak_bolum.ad as sinif_adi
FROM ucak_bolum,bilet
WHERE
ucak_bolum.ucak_bolum_id = bilet.ucak_bolum_id
AND
year(bilet.tarih) = '{$_POST['tarih']}'
group by ucak_bolum.ucak_bolum_id";
$tercih_sinif1 = mysqli_query($baglan, $tercih_sinif);

$cinsiyet = "SELECT COUNT(cinsiyet.cinsiyet_id)as cinsiyet,cinsiyet.cinsiyet_t
ur as tur
FROM cinsiyet,bilet,musteri
WHERE
cinsiyet.cinsiyet_id = musteri.cinsiyet_id
AND
bilet.musteri_id = musteri.musteri_id
AND
year(bilet.tarih) = '{$_POST['tarih']}'
group by cinsiyet.cinsiyet_id";

$cinsiyet_sorgu = mysqli_query($baglan, $cinsiyet);
$ulke = "SELECT COUNT(ulke.ulke_id)as ulke,ulke.ad ulke_adi
FROM ulke,musteri,bilet
WHERE
ulke.ulke_id = musteri.ulke_id
AND
bilet.musteri_id = musteri.musteri_id
AND
year(bilet.tarih) = '{$_POST['tarih']}'
GROUP by ulke.ulke_id";
$ulke_sorgu = mysqli_query($baglan, $ulke);

$ucyillik = "SELECT sum(bilet.fiyat)as bilet,year(bilet.tarih) as tarih1
FROM bilet
group by year(bilet.tarih)
order by tarih1 asc";
$ucyillik_sorgu = mysqli_query($baglan, $ucyillik);

$baglan->query("SET lc_time_names='tr_TR'");
$biryillik = "SELECT sum(bilet.fiyat)as bilet_toplam,monthname(bilet.tarih) astarih2
FROM bilet
WHERE
year(bilet.tarih) = '{$_POST['tarih']}'
GROUP by month(bilet.tarih)
ORDER BY month(bilet.tarih)";
$biryillik_sorgu = mysqli_query($baglan, $biryillik);

$havalimani = "SELECT COUNT(bilet.bilet_id)as bilet_sayi , CONCAT(kalkis_haval
imani.ad,' - ',varis_havalimani.ad) as sefer
FROM bilet,varis_havalimani,kalkis_havalimani
WHERE
bilet.varis_havalimani_id = varis_havalimani.varis_havalimani_id
AND
bilet.kalkis_havalimani_id = kalkis_havalimani.kalkis_havalimani_id
AND
year(bilet.tarih) = '{$_POST['tarih']}'
group by varis_havalimani.varis_havalimani_id,kalkis_havalimani.kalkis_havalim
ani_id
ORDER BY `bilet_sayi` DESC";

$havalimani_sorgu = mysqli_query($baglan, $havalimani);
$doluluk = "SELECT round((COUNT(bilet.bilet_id)/(SELECT sum(model.koltuk_sayi)
FROM model))*100) as kapasite
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
year(bilet.tarih) = '{$_POST['tarih']}'";
$doluluk_sorgu = mysqli_query($baglan, $doluluk);
$row7 = mysqli_fetch_array($doluluk_sorgu);
?>

<!DOCTYPE html>
<html>
<head>
 <meta charset="utf-8">

 <title>Ana Ekran</title>
 <link rel="stylesheet" href="dashboard.css" />
 <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.1/
css/all.css" integrity="sha384-
vp86vTRFVJgpjF9jiIGPEEqYqlDwgyBgEF109VFjmqGmIY/Y4HV4d3Gp2irVfcrp" crossorigin=
"anonymous">
 <meta name="viewport" content="width=device-width, initialscale=1.0, maximum-scale=1.0" />
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min
.js"></script>
 <script>
 window.jQuery || document.write(decodeURIComponent('%3Cscript src="js/
jquery.min.js"%3E%3C/script%3E'))
 </script>
 <link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/j
slib/20.2.4/css/dx.common.css" />
 <link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/j
slib/20.2.4/css/dx.light.css" />
 <script src="https://cdn3.devexpress.com/jslib/20.2.4/js/dx.all.js"></scri
pt>
</head>
<body>
 <div class="navbar">
 <span class="anamenu"><strong><a class="active" href="dashboard.php">A
nasayfa</a></strong></span>
 <span class="havalimani"><strong><a href="havalimani.php">Havalimanlar
ı </a></strong></span>
 <span class="tablolar"><strong><a href="tablolar.php">Uçaklar</a></str
ong></span>
 <br>
 <span class="ucakikon"><i class="fas fa-plane"></i></span>
 <span class="ucusyon">EXTRAJET UÇUŞ YÖNETİM SİSTEMİ</span>
 <span class="cikis"><a href="logout.php"><i class="fas fa-poweroff"></i>Çıkış Yap</a></span>
 <br> <br> <br>
 </div>
 <div class="secme">
 <form action="" method="post">
 <select id="secme1" name="tarih">
 <option value="2018">2018</option>
 <option value="2019">2019</option>
 <option value="2020">2020</option>
 </select>
 <button name="kayit">Sorgula</button>

 </form>
 </div>
 <div class="kut1"></div>
 <script>
 $(function() {
 var dataSource = [<?php
 while ($row1 = mysqli_fetch_array($tercih_sinif1)) {
     $ucak_sinif = $row1["ucak_sinif"];
     $sinif_adi = $row1["sinif_adi"];
     echo "" . '{' . "" . 'ad' . "" . ':' . ""
         . '"' . "" . $sinif_adi . "" . '"' . "" . ',' . "" . 'sinif' . "" . ':' . "" .
         $ucak_sinif . "" . '},' . "";
 } ?>];
 $(".kut1").dxPieChart({
 diameter: 0.5,
 size: {
 width: 400
 },
 palette: "bright",
 dataSource: dataSource,
 series: [{
 argumentField: "ad",
 valueField: "sinif",
 label: {
 visible: true,
 connector: {
 visible: true,
 width: 1
 }
 }
 }],
 title: "<?php echo $_POST['tarih'] ?> Yılında Sınıf Dağılımı",
 "export": {
 enabled: false
 },
 onPointClick: function(e) {
 var point = e.target;
 toggleVisibility(point);
 },
 onLegendClick: function(e) {
 var arg = e.target;

 toggleVisibility(this.getAllSeries()[0].getPointsByArg(arg
)[0]);
 }
 });
 function toggleVisibility(item) {
 if (item.isVisible()) {
 item.hide();
 } else {
 item.show();
 }
 }
 });
 </script>
 <div class="kut2"></div>
 <script>
 $(function() {
 var dataSource = [<?php
 while ($row2 = mysqli_fetch_array($cinsiyet_sorgu)) {
     $cinsiyet = $row2["cinsiyet"];
     $tur = $row2["tur"];
     echo "" . '{' . "" . 'tur' . "" . ':' . ""
         . '"' . "" . $tur . "" . '"' . "" . ',' . "" . 'cinsiyet' . "" . ':' . "" . $cinsiyet . "" . '},' . "";
 } ?>];
 $(".kut2").dxPieChart({
 diameter: 0.5,
 size: {
 width: 400
 },
 palette: "dark",
 dataSource: dataSource,
 series: [{
 argumentField: "tur",
 valueField: "cinsiyet",
 label: {
 visible: true,
 connector: {
 visible: true,
 width: 1
 }
 }
 }],
 title: " <?php echo $_POST['tarih'] ?> Yılı Cinsiyet Dağılım
ı",
 "export": {

 enabled: false
 },
 onPointClick: function(e) {
 var point = e.target;
 toggleVisibility(point);
 },
 onLegendClick: function(e) {
 var arg = e.target;
 toggleVisibility(this.getAllSeries()[0].getPointsByArg(arg
)[0]);
 }
 });
 function toggleVisibility(item) {
 if (item.isVisible()) {
 item.hide();
 } else {
 item.show();
 }
 }
 });
 </script>
 <div class="kut3"></div>
 <script>
 $(function() {
 var dataSource = [<?php
 while (
     $row3 = mysqli_fetch_array($ulke_sorgu)
 ) {
     $ulke = $row3["ulke"];
     $ulke_adi = $row3["ulke_adi"];
     echo "" . '{' . "" . 'ulke_adi' . "" . ':'
         . "" . '"' . "" . $ulke_adi . "" . '"' . "" . ',' . "" . 'ulke' . "" . ':' .
         "" . $ulke . "" . '},' . "";
 } ?>];
 $(".kut3").dxPieChart({
 diameter: 0.5,
 size: {
 width: 500
 },
 palette: "light",
 dataSource: dataSource,
 series: [{
 argumentField: "ulke_adi",

 valueField: "ulke",
 label: {
 visible: true,
 connector: {
 visible: true,
 width: 1
 }
 }
 }],
 title: "<?php echo $_POST['tarih'] ?> Yılında Yolcuların Ülke
Dağılımı",
 "export": {
 enabled: false
 },
 onPointClick: function(e) {
 var point = e.target;
 toggleVisibility(point);
 },
 onLegendClick: function(e) {
 var arg = e.target;
 toggleVisibility(this.getAllSeries()[0].getPointsByArg(arg
)[0]);
 }
 });
 function toggleVisibility(item) {
 if (item.isVisible()) {
 item.hide();
 } else {
 item.show();
 }
 }
 });
 </script>
 <div class="kut4"></div>
 <script>
 $(function() {
 var dataSource = [<?php
 while ($row4 = mysqli_fetch_array($ucyillik_sorgu)) {
     $tarih1 = $row4["tarih1"];
     $bilet = $row4["bilet"];

     echo "" . '{' . "" . 'tarih1' . "" . ':' .
         "" . '"' . "" . $tarih1 . "" . '"' . "" . ',' . "" . 'bilet' . "" . ':' . ""
         . $bilet . "" . '},' . "";
 } ?>];
 $(".kut4").dxChart({
 dataSource: dataSource,
 series: {
 argumentField: "tarih1",
 valueField: "bilet",
 name: "Satış Rakamları (TL) ",
 type: "line",
 color: '#02548E'
 },
 title: {
 text: "Yıllar Bazında Satış Rakamları",
 font: {
 size: 28
 }
 },
 });
 });
 </script>
 <div class="kut5"></div>
 <script>
 $(function() {
 var dataSource = [<?php
 while ($row5 = mysqli_fetch_array($biryillik_sorgu)) {
     $tarih2 = $row5["tarih2"];
     $bilet_toplam = $row5["bilet_toplam"];
     echo "" . '{' . "" . 'tarih2' . "" . ':' .
         "" . '"' . "" . $tarih2 . "" . '"' . "" . ',' . "" . 'bilet_toplam' . "" . ':
' . "" . $bilet_toplam . "" . '},' . "";
 } ?>];
 var highAverage = 800;
 $(".kut5").dxChart({
 dataSource: dataSource,
 customizePoint: function() {
 if (this.value >= highAverage) {
 return {
 color: "#8DD862",
 hoverStyle: {
 color: "#FFA200"
 }
 };

 }
 },
 customizeLabel: function() {
 if (this.value >= highAverage) {
 return {
 visible: true,
 backgroundColor: "#377016 ",
 customizeText: function() {
 return this.valueText + "";
 }
 };
 } else if (this.value <= highAverage) {
 return {
 visible: true,
 backgroundColor: "#eb1034 ",
 customizeText: function() {
 return this.valueText + "";
 }
 };
 }
 },
 "export": {
 enabled: false
 },
 valueAxis: {
 visualRange: {
 startValue: 100
 },
 maxValueMargin: 0.1,
 label: {
 },
 constantLines: [{
 label: {
 text: "Satış Hedefi",
 textStyle: {
 color: "#000000"
 }
 },
width: 1,
 value: highAverage,
 color: "#000000",
 dashStyle: "dash"
 }]
 },
 series: [{
 argumentField: "tarih2",
 valueField: "bilet_toplam",
 type: "bar",

 color: "#eb1034"
 }],
 title: {
 text: "<?php echo $_POST['tarih'] ?> Yılında Aylık Satışla
r"
 },
 legend: {
 visible: false
 }
 });
 });
 </script>
 <div class="kut6"></div>
 <script>
 var dataSource = [<?php
 while ($row6 = mysqli_fetch_array($havalimani_sorgu)) {
     $sefer = $row6["sefer"];
     $bilet_sayi = $row6["bilet_sayi"];
     echo "" . '{' . "" . 'sefer' . "" . ':' . "" .
         '"' . "" . $sefer . "" . '"' . "" . ',' . "" . 'bilet_sayi' . "" . ':' . "" .
         $bilet_sayi . "" . '},' . "";
 } ?>];
 $(function() {
 $(".kut6").dxPieChart({
 size: {
 },
 diameter: 0.5,
 margin: {
 top: 10,
 },
 palette: "bright",
 dataSource: dataSource,
 series: [{
 argumentField: "sefer",
 valueField: "bilet_sayi",
 label: {
 visible: true,
 connector: {
 visible: true,
 width: 1
 }
 }
 }],

 title: "<?php echo $_POST['tarih'] ?> Yılında En Çok Bilet Alı
nan Seferler",
 "export": {
 enabled: false
 },
 onPointClick: function(e) {
 var point = e.target;
 toggleVisibility(point);
 },
 onLegendClick: function(e) {
 var arg = e.target;
 toggleVisibility(this.getAllSeries()[0].getPointsByArg(arg
)[0]);
 }
 });
 function toggleVisibility(item) {
 if (item.isVisible()) {
 item.hide();
 } else {
 item.show();
 }
 }
 });
 </script>
 <div class="kut7"></div>
 <script>
 $(function() {
 $(".kut7").dxCircularGauge({
 scale: {
 startValue: 0,
 endValue: 100,
 tickInterval: 5,
 label: {
 customizeText: function(arg) {
 return arg.valueText + " %";
 }
 }
 },
 subvalueIndicator: {
 type: "textcloud",
 text: {
 color: '#ffffff',
 format: {
 type: "",
 precision: 1
 },
customizeText: function(arg) {
 return arg.valueText + " %";
 }
 }
 },
 "export": {
 enabled: false
 },
 title: {
 text: "<?php echo $_POST['tarih'] ?> Yılı Uçak Kapasite Do
luluk Oranı",
 font: {
 size: 28
 }
 },
 value: <?php echo $row7["kapasite"]; ?>,
 subvalues: [<?php echo $row7["kapasite"]; ?>]
 });
 });
 </script>
</body>
</html>
