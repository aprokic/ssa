<?php

//creating response array
$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    //getting value
    $type = $_GET['type'];
    $location = $_GET['location'];
    $description = $_GET['description'];
    $reserved = $_GET['reserved'];

    //including the db operation file
    require_once '../includes/DbOperation.php';

    $db = new DbOperation();
    $response = $db->scanTag($type, $location, $description, $reserved);
    $response['error'] = false;
}
else {
    $response['error'] = true;
}
echo json_encode($response);

?>