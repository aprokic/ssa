<?php

//creating response array
$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    //getting value
    $zip = $_GET['zip'];

    //including the db operation file
    require_once '../includes/DbOperation.php';

    $db = new DbOperation();
    $response = $db->queryZipLocations($zip);
    $response['error'] = false;
}
else {
    $response['error'] = true;
}
echo json_encode($response);

?>