<?php

class DbOperation {
    private $conn;

    //Constructor
    function __construct() {
        require_once dirname(__FILE__) . '/Config.php';
        require_once dirname(__FILE__) . '/DbConnect.php';
        // opening db connection
        $db = new DbConnect();
        $this->conn = $db->connect();
    }

    //SEPARATE FUNCTIONS FOR EACH FIELD, FOR EACH TABLE
    //Functions to query zip codes
    public function queryZipLocations($zip) {
        $sql = "select * from locations where zip = $zip";
        $result = mysqli_query($this->conn, $sql);
        $rows = array();
        while ($r = mysqli_fetch_assoc($result)) {
            $rows[] = $r;
        }
        $rows["size"] = mysqli_num_rows($result);
        mysqli_close($this->conn);
        return $rows;
    }

    public function queryZipDescriptions($zip) {
        $sql = "select d.lid, d.did, d.description, d.price from descriptions d join locations l on d.lid = l.lid where l.zip = $zip";
        $result = mysqli_query($this->conn, $sql);
        $rows = array();
        while ($r = mysqli_fetch_assoc($result)) {
            $rows[] = $r;
        }
        $rows["size"] = mysqli_num_rows($result);
        mysqli_close($this->conn);
        return $rows;
    }

    public function queryZipTags($zip) {
        $sql = "select t.type, t.location, t.description, t.reserved from tags t join locations l on t.location = l.lid where l.zip = $zip";
        $result = mysqli_query($this->conn, $sql);
        $rows = array();
        while ($r = mysqli_fetch_assoc($result)) {
            $rows[] = $r;
        }
        $rows["size"] = mysqli_num_rows($result);
        mysqli_close($this->conn);
        return $rows;
    }

    public function queryCityLocations($city) {
        $sql = "select * from locations where city = '$city'";
        $result = mysqli_query($this->conn, $sql);
        $rows = array();
        while ($r = mysqli_fetch_assoc($result)) {
            $rows[] = $r;
        }
        $rows["size"] = mysqli_num_rows($result);
        mysqli_close($this->conn);
        return $rows;
    }

    public function queryCityDescriptions($city) {
        $sql = "select d.lid, d.did, d.description, d.price from descriptions d join locations l on d.lid = l.lid where l.city = '$city'";
        $result = mysqli_query($this->conn, $sql);
        $rows = array();
        while ($r = mysqli_fetch_assoc($result)) {
            $rows[] = $r;
        }
        $rows["size"] = mysqli_num_rows($result);
        mysqli_close($this->conn);
        return $rows;
    }

    public function queryCityTags($city) {
        $sql = "select t.type, t.location, t.description, t.reserved from tags t join locations l on t.location = l.lid where l.city = '$city'";
        $result = mysqli_query($this->conn, $sql);
        $rows = array();
        while ($r = mysqli_fetch_assoc($result)) {
            $rows[] = $r;
        }
        $rows["size"] = mysqli_num_rows($result);
        mysqli_close($this->conn);
        return $rows;
    }

    public function queryStateLocations($state) {
        $sql = "select * from locations where state_province_region = '$state'";
        $result = mysqli_query($this->conn, $sql);
        $rows = array();
        while ($r = mysqli_fetch_assoc($result)) {
            $rows[] = $r;
        }
        $rows["size"] = mysqli_num_rows($result);
        mysqli_close($this->conn);
        return $rows;
    }

    public function queryStateDescriptions($state) {
        $sql = "select d.lid, d.did, d.description, d.price from descriptions d join locations l on d.lid = l.lid where l.state_province_region = '$state'";
        $result = mysqli_query($this->conn, $sql);
        $rows = array();
        while ($r = mysqli_fetch_assoc($result)) {
            $rows[] = $r;
        }
        $rows["size"] = mysqli_num_rows($result);
        mysqli_close($this->conn);
        return $rows;
    }

    public function queryStateTags($state) {
        $sql = "select t.type, t.location, t.description, t.reserved from tags t join locations l on t.location = l.lid where l.state_province_region = '$state'";
        $result = mysqli_query($this->conn, $sql);
        $rows = array();
        while ($r = mysqli_fetch_assoc($result)) {
            $rows[] = $r;
        }
        $rows["size"] = mysqli_num_rows($result);
        mysqli_close($this->conn);
        return $rows;
    }

    public function listCountries() {
        $sql = "select distinct country from locations";
        $result = mysqli_query($this->conn, $sql);
        $rows = array();
        while ($r = mysqli_fetch_assoc($result)) {
            $rows[] = $r;
        }
        $rows["size"] = mysqli_num_rows($result);
        mysqli_close($this->conn);
        return $rows;
    }

    public function listStates($country) {
        $sql = "select distinct state_province_region from locations where country = '$country'";
        $result = mysqli_query($this->conn, $sql);
        $rows = array();
        while ($r = mysqli_fetch_assoc($result)) {
            $rows[] = $r;
        }
        $rows["size"] = mysqli_num_rows($result);
        mysqli_close($this->conn);
        return $rows;
    }

    public function listCities($country, $state) {
        $sql = "select distinct city from locations where country = '$country' and state_province_region = '$state'";
        $result = mysqli_query($this->conn, $sql);
        $rows = array();
        while ($r = mysqli_fetch_assoc($result)) {
            $rows[] = $r;
        }
        $rows["size"] = mysqli_num_rows($result);
        mysqli_close($this->conn);
        return $rows;
    }

    public function queryLocations($country, $state, $city) {
        $sql = "select * from locations where country = '$country' and state_province_region = '$state' and city = '$city'";
        $result = mysqli_query($this->conn, $sql);
        $rows = array();
        while ($r = mysqli_fetch_assoc($result)) {
            $rows[] = $r;
        }
        $rows["size"] = mysqli_num_rows($result);
        mysqli_close($this->conn);
        return $rows;
    }

    public function queryDescriptions($country, $state, $city) {
        $sql = "select d.lid, d.did, d.description, d.price from descriptions d join locations l on d.lid = l.lid where l.country = '$country' and l.state_province_region = '$state' and l.city = '$city'";
        $result = mysqli_query($this->conn, $sql);
        $rows = array();
        while ($r = mysqli_fetch_assoc($result)) {
            $rows[] = $r;
        }
        $rows["size"] = mysqli_num_rows($result);
        mysqli_close($this->conn);
        return $rows;
    }

    public function queryTags($country, $state, $city) {
        $sql = "select t.type, t.location, t.description, t.reserved from tags t join locations l on t.location = l.lid where l.country = '$country' and l.state_province_region = '$state' and l.city = '$city'";
        $result = mysqli_query($this->conn, $sql);
        $rows = array();
        while ($r = mysqli_fetch_assoc($result)) {
            $rows[] = $r;
        }
        $rows["size"] = mysqli_num_rows($result);
        mysqli_close($this->conn);
        return $rows;
    }
}

?>