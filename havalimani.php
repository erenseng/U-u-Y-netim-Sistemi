<?php
include("auth_session.php");
$baglan = mysqli_connect("localhost", "root", "Erensen8", "2017469080");
?>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.1/
css/all.css" integrity="sha384-
vp86vTRFVJgpjF9jiIGPEEqYqlDwgyBgEF109VFjmqGmIY/Y4HV4d3Gp2irVfcrp" crossorigin="anonymous">
    <link rel="stylesheet" href="havalimani.css">
    <title>Havalimanları</title>
</head>

<body>
    <div class="navbar">
        <span class="anamenu"><strong><a href="dashboard.php">Anasayfa</a></st rong></span>
        <span class="havalimani active"><strong><a href="havalimani.php">Haval
                    imanları </a></strong></span>
        <span class="tablolar"><strong><a href="tablolar.php">Uçaklar</a></str ong></span>
        <br>
        <span class="ucakikon"><i class="fas fa-plane"></i></span>
        <span class="ucusyon">EXTRAJET UÇUŞ YÖNETİM SİSTEMİ</span>
        <span class="cikis"><a href="logout.php"><i class="fas fa-poweroff"></i>Çıkış Yap</a></span>
        <br> <br> <br>
    </div>
    <div class="varis">
        <p>Sefer Yapılmayan Havalimanları</p>
        <hr>
        <div class="varis1">
            <br>
            <table>
                <thead>
                    <tr>
                        <th>Ad</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <?php
                        $sor = "SELECT varis_havalimani.ad as havalimani_adi F
ROM varis_havalimani WHERE varis_havalimani.varis_havalimani_id not in (1,2,3,
4,5,6) ORDER BY `varis_havalimani`.`ad` DESC";
                        $ucak = mysqli_query($baglan, $sor);
                        while ($ucak_cek = mysqli_fetch_array($ucak)) { ?>
                        <tr>
                            <th><?php echo $ucak_cek['havalimani_adi'] ?></th>
                        </tr>
                    <?php }
                        ; ?>
                </tbody>
            </table>
        </div>
        <div class="varis2">
            <table>
                <thead>
                    <tr>
                        <th>
                            Adres
                        </th>
                    </tr>
                </thead>
                <tr>
                    <td>
                        Konaklar, 61010 Merkez/Trabzon
                    </td>
                </tr>
                <tr>
                    <td>
                        Yazıbaşı Mh, 58000 Yazıbaşı/Sivas Merkez/Sivas
                    </td>
                </tr>
                <tr>
                    <td>
                        Alibey Adası, 52010 Gülyalı/Ordu
                    </td>
                </tr>
                <tr>
                    <td>
                        Tuzköyü, Nevşehir Kapadokya Havaalanı Girişi, 50900 Gü
                        lşehir/Nevşehir
                    </td>
                </tr>
                <tr>
                    <td>
                        Ekinanbarı, Havalimanı Sk, 48200 Milas/Muğla
                    </td>
                </tr>
                <tr>
                    <td>
                        Kükürt, Dörtyol No:39, 32090 Keçiborlu/Isparta
                    </td>
                </tr>
                <tr>
                    <td>
                        Turhan Cemal Beriker Blv., 01000 Seyhan/Adana
                    </td>
                </tr>
            </table>
        </div>
        <div class="varis3">
            <table>
                <thead>
                    <tr>
                        <th>
                            Harita
                        </th>
                    </tr>
                </thead>
                <tr>
                    <td>
                        <a href="https://www.google.com/maps/place/Trabzon+Ulu
slararas%C4%B1+Havaliman%C4%B1/@40.9943394,39.782373,15z/data=!4m5!3m4!1s0x0:0
x7df292f5eedabe39!8m2!3d40.9943394!4d39.782373"><i class="fas fa-map-markedalt"></i></a>
                    </td>
                </tr>
                <tr>
                    <td>
                        <a href="https://www.google.com/maps/place/Sivas+Nuri+
Demira%C4%9F+Havaliman%C4%B1/@39.8021991,36.8926027,15z/data=!4m5!3m4!1s0x0:0x
218b9480d8991070!8m2!3d39.8021991!4d36.8926027"><i class="fas fa-map-markedalt"></i></a>
                    </td>
                </tr>
                <tr>
                    <td>
                        <a href="https://www.google.com/maps/place/Ordu+Giresu
n+Havaliman%C4%B1/@40.9650306,38.080446,15z/data=!4m2!3m1!1s0x0:0x20164a8c65da
bf8b?sa=X&ved=2ahUKEwio67qVgYDuAhVHyqQKHaEfDj0Q_BIwHXoECDIQBQ"><i class="fas f
a-map-marked-alt"></i></a>
                    </td>
                </tr>
                <tr>
                    <td>
                        <a href="https://www.google.com/maps/place/Nev%C5%9Feh
ir+Kapadokya+Havaliman%C4%B1/@38.7719688,34.5245521,15z/data=!4m2!3m1!1s0x0:0x
c24176cac8c928e9?sa=X&ved=2ahUKEwjr4K2pgYDuAhUQ2KQKHbywCNYQ_BIwEnoECCkQBQ"><i class="fas fa-map-marked-alt"></i></a>
                    </td>
                </tr>
                <tr>
                    <td>
                        <a href="https://www.google.com/maps/place/MilasBodrum+Havaalani/@37.248656,27.6639925,15z/data=!4m2!3m1!1s0x0:0x983b69b4d84b6
3d2?sa=X&ved=2ahUKEwieiYi2gYDuAhWBKQKHbDVDsEQ_BIwEnoECCcQBQ"><i class="fas fa-map-marked-alt"></i></a>
                    </td>
                </tr>
                <tr>
                    <td>
                        <a href="https://www.google.com/maps/place/Isparta+S%C
3%BCleyman+Demirel+Havaliman%C4%B1/@37.8588286,30.3673697,15z/data=!4m2!3m1!1s
0x0:0xc3f00a35a440c493?sa=X&ved=2ahUKEwjVqqjGgYDuAhUQwKQKHeJ_Ac4Q_BIwCnoECBEQB
Q"><i class="fas fa-map-marked-alt"></i></a>
                    </td>
                </tr>
                <tr>
                    <td>
                        <a href="https://www.google.com/maps/place/Adana+Haval
iman%C4%B1/@36.9858545,35.2859641,17z/data=!3m1!4b1!4m5!3m4!1s0x15288615ee1d4c
15:0x3d3a00c7726ca168!8m2!3d36.9858545!4d35.2881528"><i class="fas fa-mapmarked-alt"></i></a>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="kalkis">
        <p>Sefer Yapılan Havalimanları</p>
        <hr>
        <div class="kalkis1">
            <br>
            <table>
                <thead>
                    <tr>
                        <th>Ad</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <?php
                        $sor1 = "SELECT varis_havalimani.ad as havalimani_ad F
ROM varis_havalimani WHERE varis_havalimani.varis_havalimani_id not in (7,8,9,
10,11,12,13) ORDER BY `varis_havalimani`.`ad` DESC";
                        $sorgu = mysqli_query($baglan, $sor1);
                        while ($sorgu_cek = mysqli_fetch_array($sorgu)) { ?>
                        <tr>
                            <th><?php echo $sorgu_cek['havalimani_ad'] ?></th>
                        </tr>
                    <?php }
                        ; ?>
                </tbody>
            </table>
            <div class="kalkisiki">
                <table>
                    <thead>
                        <tr>
                            <th>
                                Adres
                            </th>
                        </tr>
                    </thead>
                    <tr>
                        <td>
                            Dokuz Eylül, 35410 Gaziemir/İzmir
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Sanayi, 34906 Pendik/İstanbul
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Tayakadın Terminal Cad. No:1, 34283 Arnavutköy/İstanbu
                            l
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Gazipaşa,Anadolu Ünv. 2 Eylül Kampüsü, Tepebaşı/Eskişe
                            hir
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Balıkhisar Mh., Özal Bulvarı, Akyurt/Ankara
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Gazipaşa Antalya TR, 07900
                        </td>
                    </tr>
                </table>
            </div>
            <div class="kalkisuc">
                <table>
                    <thead>
                        <tr>
                            <th>
                                Harita
                            </th>
                        </tr>
                    </thead>
                    <tr>
                        <td>
                            <a href="https://www.google.com/maps/place/Adnan+M
enderes+Havaliman%C4%B1/@38.293763,27.1520285,15z/data=!4m2!3m1!1s0x0:0xa08bfd
d9d58f6448?sa=X&ved=2ahUKEwjj5rGNjYDuAhXF2KQKHbY5A1oQ_BIwDXoECBgQBQ"><i class="fas fa-map-pin"></i></a>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <a href="https://www.google.com/maps/place/Sabiha+
G%C3%B6k%C3%A7en+Uluslararas%C4%B1+Havaliman%C4%B1/@40.905371,29.3168603,15z/d
ata=!4m2!3m1!1s0x0:0xacefca4d8098da74?sa=X&ved=2ahUKEwjJrp2ljYDuAhUKyqQKHbA0BG
AQ_BIwCnoECBQQBQ"><i class="fas fa-map-pin"></i></a>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <a href="https://www.google.com/maps/place/%C4%B0s
tanbul+Havaliman%C4%B1/@41.2599003,28.7427288,15z/data=!4m5!3m4!1s0x0:0x380ce0
2cc824e506!8m2!3d41.2599003!4d28.7427288"><i class="fas fa-map-pin"></i></a>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <a href="https://www.google.com/maps/place/Hasan+P
olatkan+Havaliman%C4%B1/@39.8130389,30.5323259,15z/data=!4m2!3m1!1s0x0:0x65d32
1dbc79fada2?sa=X&ved=2ahUKEwjH47NjYDuAhVkIMUKHfFnD7cQ_BIwEnoECCoQBQ"><i class="fas fa-map-pin"></i></a>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <a href="https://www.google.com/maps/place/Ankara+
Esenbo%C4%9Fa+Havaliman%C4%B1/@40.1244399,32.9916726,15z/data=!4m2!3m1!1s0x0:0
xf13ed2bab75c76d6?sa=X&ved=2ahUKEwjJvuXljYDuAhWMDewKHZwECtEQ_BIwC3oECBUQBQ"><i class="fas fa-map-pin"></i></a>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <a href="https://www.google.com/maps/place/Gazipa%
C5%9Fa+-
+Alanya+Havaliman%C4%B1/@36.297388,32.3014382,15z/data=!4m2!3m1!1s0x0:0xa9a6f6
8e7b22b866?sa=X&ved=2ahUKEwj9sY32jYDuAhUDIMUKHX2rDsEQ_BIwCnoECBIQBQ"><i class="fas fa-map-pin"></i></a>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
</body>

</html>