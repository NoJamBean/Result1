<?php
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>신규 회원 입력</title>
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
        .form-group {
            margin-bottom: 10px;
            text-align: left;
        }
        label {
            display: block;
            font-weight: bold;
        }
        input {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid black;
            border-radius: 5px;
            box-sizing: border-box;
        }
        .submit-btn {
            margin-top: 20px;
            padding: 10px 20px;
            border: 1px solid black;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            background-color: white;
            color: black;
            width: 100%;
        }
        .submit-btn:hover {
            background-color: black;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>신규 회원 입력</h1>
        <form method="post" action="sp_result.php">
            <div class="form-group">
                <label for="userID">아이디:</label>
                <input type="text" name="userID" id="userID" required>
            </div>
            <div class="form-group">
                <label for="name">이름:</label>
                <input type="text" name="name" id="name" required>
            </div>
            <div class="form-group">
                <label for="birthYear">출생년도:</label>
                <input type="text" name="birthYear" id="birthYear" required>
            </div>
            <div class="form-group">
                <label for="email">이메일:</label>
                <input type="email" name="email" id="email" required>
            </div>
            <input type="submit" value="회원 입력" class="submit-btn">
        </form>
    </div>
</body>
</html>
?>
