<?php

//creating response array
$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    //getting values
    $country = $_GET['country'];
    $state = $_GET['state'];
    $city = $_GET['city'];

    //including the db operation file
    require_once '../includes/DbOperation.php';

    $db = new DbOperation();
    $response = $db->getCount($country, $state, $city);
    $response['error'] = false;
}
else {
    $response['error'] = true;
}
echo json_encode($response);

?>