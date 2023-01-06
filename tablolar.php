<?php
include("auth_session.php");
$baglan = mysqli_connect("localhost", "root", "Erensen8", "2017469080");
?>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <title>Uçaklar</title>
    <link rel="stylesheet" href="tablolar.css" />
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.1/
css/all.css" integrity="sha384-
55
vp86vTRFVJgpjF9jiIGPEEqYqlDwgyBgEF109VFjmqGmIY/Y4HV4d3Gp2irVfcrp" crossorigin="anonymous">
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
pt >
</head >
     <body>
         <div class="navbar">
             <span class="anamenu"><strong><a href="dashboard.php">Anasayfa</a></st
rong></span>
             <span class="havalimani"><strong><a href="havalimani.php">Havalimanlar
                 ı </a></strong></span>
             <span class="tablolar active"><strong><a href="tablolar.php">Uçaklar</
             a></strong></span>
             <br>
                 <span class="ucakikon"><i class="fas fa-plane"></i></span>
                 <span class="ucusyon">EXTRAJET UÇUŞ YÖNETİM SİSTEMİ</span>
                 <span class="cikis"><a href="logout.php"><i class="fas fa-poweroff"></i>Çıkış Yap</a></span>
                 <br> <br> <br>
                 </div>
                     <div class="kut8">
                         <br>
                             <p>Uçak Bilgileri</p>
                             <br>
                                 <table class="ucaklar">
                                     <tr class="baslik1">
                                         <th style="color: #ffffff; font-size:19px">Model</th>
                                         <th style="color: #ffffff; font-size:19px">Marka</th>
                                         <th style="color: #ffffff; font-size:19px">Üretim Tarihi</th>
                                         <th style="color: #ffffff; font-size:19px">Uçak Durumu</th>
                                     </tr>
                                     <tr>
                                         <?php
                                         $sor = "SELECT year(model.uretim_tarihi)as tarih,marka.marka_a
d,model.ad,model.koltuk_sayi
 FROM marka,model
 WHERE
 marka.marka_id = model.marka_id";
                                         $ucak = mysqli_query($baglan, $sor);
                                         while ($ucak_cek = mysqli_fetch_array($ucak)) { ?>
     <tr>
     <th class=""><?php echo $ucak_cek['ad'] ?></th>
     <th><?php echo $ucak_cek['marka_ad'] ?></th>
     <th><?php echo $ucak_cek['tarih'] ?></th>
     <th><?php
     if ($ucak_cek['tarih'] < 1993) {
         echo '<i class="fas fa-exclamation-triangle"></i>';
     } else {
         echo '<i class="fas fa-check-square"></i>';
     }
     ?></th>
     </tr>
 <?php }
                                         ; ?>
                                     </tr>
                                 </table>
                             </div>
                             <div class="kut9">
                                 <br>
                                     <p>Alınabilecek Uçaklar ve Bilgileri</p>
                                     <br>
                                         <table class="alınacak">
                                             <tr class="baslik">
                                                 <th>Model</th>
                                                 <th>Marka</th>
                                                 <th>Üretim Tarihi</th>
                                                 <th>Fiyatı</th>
                                             </tr>
                                             <tr>
                                                 <th>A320</th>
                                                 <th>Airbus</th>
                                                 <th>1994</th>
                                                 57
                                                 <th>150.000</th>
                                             </tr>
                                             <tr>
                                                 <th>A380F</th>
                                                 <th>Airbus</th>
                                                 <th>2009</th>
                                                 <th>250.000</th>
                                             </tr>
                                             <tr>
                                                 <th>A330F</th>
                                                 <th>Airbus</th>
                                                 <th>2010</th>
                                                 <th>200.000</th>
                                             </tr>
                                             <tr>
                                                 <th>A400M</th>
                                                 <th>Airbus</th>
                                                 <th>2011</th>
                                                 <th>220.000</th>
                                             </tr>
                                             <tr>
                                                 <th>737</th>
                                                 <th>Boeing</th>
                                                 <th>2011</th>
                                                 <th>270.000</th>
                                             </tr>
                                             <tr>
                                                 <th>AN-225</th>
                                                 <th>Antonov</th>
                                                 <th>2002</th>
                                                 <th>290.000</th>
                                             </tr>
                                             <tr>
                                                 <th>MiG</th>
                                                 <th>MiG-35</th>
                                                 <th>2010</th>
                                                 <th>310.000</th>
                                             </tr>
                                         </div>