<html>
<body>


<?php
$myfile = fopen("data/name.uc", "w") or die("Unable to open file!");
$name = $_POST["name"];
$msg = $_POST["msg"];

fwrite($myfile, $name);
fwrite($myfile, ": ");
fwrite($myfile, $msg);
fwrite($myfile, "\n");
fclose($myfile);

# go to final page instead of first
include "fin.php"
?>

</body>
</html>