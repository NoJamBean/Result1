<?php
    $con = mysqli_connect("10.4.1.100", "rep", "qwe123", "sqlDB") or die("MySQL 접속 실패 !!");
    mysqli_query($con, "set session character_set_connection=utf8mb4;");
    mysqli_query($con, "set session character_set_results=utf8mb4;");
    mysqli_query($con, "set session character_set_client=utf8mb4;");
    
    $sql = "SELECT * FROM userTBL";
    $ret = mysqli_query($con, $sql);
    if (!$ret) {
        die("userTBL 데이터 조회 실패!!!<br>실패 원인: " . mysqli_error($con));
    }
?>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 조회 결과</title>
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
            width: 600px;
        }
        h1 {
            font-size: 24px;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: center;
        }
        th {
            background-color: #f4f4f4;
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
        <h1>회원 조회 결과</h1>
        <table>
            <tr>
                <th>아이디</th>
                <th>이름</th>
                <th>출생년도</th>
                <th>이메일</th>
                <th>가입일</th>
            </tr>
            <?php while ($row = mysqli_fetch_array($ret)): ?>
                <tr>
                    <td><?= htmlspecialchars($row['userID']) ?></td>
                    <td><?= htmlspecialchars($row['name']) ?></td>
                    <td><?= htmlspecialchars($row['birthYear']) ?></td>
                    <td><?= htmlspecialchars($row['email']) ?></td>
                    <td><?= htmlspecialchars($row['mDate']) ?></td>
                </tr>
            <?php endwhile; ?>
        </table>
        <?php mysqli_close($con); ?>
        <div class="button-container">
            <a href='index.html'>초기 화면</a>
        </div>
    </div>
</body>
</html>
