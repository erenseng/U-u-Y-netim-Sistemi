<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8" />
    <title>Giriş</title>
    <link rel="stylesheet" href="style.css" />
</head>

<body>
    <br> <br> <br> <br> <br> <br> <br>
    <?php
    require('db.php');
    session_start();

    if (isset($_POST['username'])) {
        $username = stripslashes($_REQUEST['username']);
        $username = mysqli_real_escape_string($con, $username);
        $password = stripslashes($_REQUEST['password']);
        $password = mysqli_real_escape_string($con, $password);

        $query = "SELECT * FROM `users` WHERE username='$username'
 AND password='" . md5($password) . "'";
        $result = mysqli_query($con, $query) or die(mysql_error());
        $rows = mysqli_num_rows($result);
        if ($rows == 1) {
            $_SESSION['username'] = $username;

            header("Location: dashboard.php");
        } else {
            echo "<div class='form'>
 <h3>Incorrect Username/password.</h3><br/>
 <p class='link'>Click here to <a href='login.php'>Login</a>
again.</p>
 </div>";
        }
    } else {
        ?>
        <form class="form" method="post" name="login">
            <h1 class="login-title">Extrajet Havayolları</h1>
            <h2 class="login-title2">Giriş Ekranı</h2>
            <input type="text" class="logininput" name="username" placeholder="Kullanıcı adınızı girin." autofocus="true"
                required="" />
            <input type="password" class="logininput" name="password" placeholder="Şifrenizi girin." required="" />
            <input type="submit" value="Giriş Yap" name="submit" class="loginbutton" />
        </form>
        <?php
    }
    ?>
</body>

</html>