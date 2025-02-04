<?php
    $con = mysqli_connect("10.2.1.100", "user1", "qwe123", "sqlDB") or die("MySQL 접속 실패 !!");
    mysqli_query($con, "set session character_set_connection=utf8mb4;");
    mysqli_query($con, "set session character_set_results=utf8mb4;");
    mysqli_query($con, "set session character_set_client=utf8mb4;");

    $userID = $_POST["userID"];
    $name = $_POST["name"];
    $birthYear = $_POST["birthYear"];
    $email = $_POST["email"];
    $mDate = date("Y-m-j");
    
    $sql = "INSERT INTO userTBL VALUES('$userID', '$name', '$birthYear', '$email', '$mDate')";
    $ret = mysqli_query($con, $sql);
?>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>신규 회원 입력 결과</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f4f4f4;
        }
        .container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 300px;
        }
        h1 {
            font-size: 24px;
            margin-bottom: 20px;
        }
        .message {
            font-size: 16px;
            margin-bottom: 15px;
        }
        .button-container {
            margin-top: 20px;
        }
        a {
            padding: 10px 20px;
            border: 1px solid black;
            border-radius: 5px;
            text-decoration: none;
            font-size: 16px;
            background-color: white;
            color: black;
        }
        a:hover {
            background-color: black;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>신규 회원 입력 결과</h1>
        <div class="message">
            <?php
                if ($ret) {
                    echo "데이터가 성공적으로 입력됨.";
                } else {
                    echo "데이터 입력 실패!!!<br>";
                    echo "실패 원인 : " . mysqli_error($con);
                }
                mysqli_close($con);
            ?>
        </div>
        <div class="button-container">
            <a href='index.html'>초기 화면</a>
        </div>
    </div>
</body>
</html>
