<?php

//creating response array
$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    //getting value
    $country = $_GET['country'];
    $state = $_GET['state'];

    //including the db operation file
    require_once '../includes/DbOperation.php';

    $db = new DbOperation();
    $response = $db->listCities($country, $state);
    $response['error'] = false;
}
else {
    $response['error'] = true;
}
echo json_encode($response);

?>