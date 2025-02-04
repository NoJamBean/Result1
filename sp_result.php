<?php
   $con=mysqli_connect("db.idcseoul.internal", "user1", "qwe123", "sqlDB") or die("MySQL 접속 실패 !!");
   mysqli_query($con, "set session character_set_connection=utf8mb4;");
   mysqli_query($con, "set session character_set_results=utf8mb4;");
   mysqli_query($con, "set session character_set_client=utf8mb4;");
   $sql ="SELECT * FROM userTBL";
   $userID = $_POST["userID"];
   $name = $_POST["name"];
   $birthYear = $_POST["birthYear"];
   $email = $_POST["email"];
   $mDate = date("Y-m-j");
   
   $sql =" INSERT INTO userTBL VALUES('".$userID."','".$name."','".$birthYear."','".$email."','".$mDate."')";
   
   $ret = mysqli_query($con, $sql);
 
    echo "<h1> 신규 회원 입력 결과 </h1>";
   if($ret) {
	   echo "데이터가 성공적으로 입력됨.";
   }
   else {
	   echo "데이터 입력 실패!!!"."<br>";
	   echo "실패 원인 :".mysqli_error($con);
   } 
   mysqli_close($con);
   
   echo "<br> <a href='index.html'> <--초기 화면</a> ";
	?>