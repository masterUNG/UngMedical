<?php
header("content-type:text/javascript;charset=utf-8");
error_reporting(0);
error_reporting(E_ERROR | E_PARSE);
$link = mysqli_connect('localhost', 'student1', 'Abc12345', "tvdirect");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}

if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
				
		$urlpic = $_GET['urlpic'];
		$title = $_GET['title'];
		$detail = $_GET['detail'];
		$lat = $_GET['lat'];
		$lng = $_GET['lng'];
		$qrcode = $_GET['qrcode'];
		
							
		$sql = "INSERT INTO `product`(`id`, `urlpic`, `title`, `detail`, `lat`, `lng`, `qrcode`) VALUES (Null,'$urlpic','$title','$detail','$lat','$lng','$qrcode')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Master UNG";
   
}
	mysqli_close($link);
?>