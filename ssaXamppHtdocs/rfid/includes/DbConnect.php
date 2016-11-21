<?php

class DbConnect {
    private $conn;

    function __construct() {}

    /**
    * Establishing database connection
    * return database connection handler
    */
    function connect() {
        require_once 'Config.php';

        // Connecting to mysql database
        $this->conn = mysqli_connect(DB_HOST, DB_USERNAME, DB_PASSWORD, DB_NAME);

        // Check for database connection error
        if (!$this->conn) {
            die("Connection failed: " . mysqli_connect_error());
        }

        // returing connection resource
        return $this->conn;
    }
}

?>