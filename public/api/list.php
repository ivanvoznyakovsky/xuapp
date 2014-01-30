<?php
  require_once 'Services/JSON.php';
  $json = new Services_JSON(SERVICES_JSON_LOOSE_TYPE);
  
  if (isset($_REQUEST['fake'])) {
    $c = array('b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'z');
    $w = array('a', 'e', 'i', 'o', 'u', 'y');
    $users = array();
    
    for ($ii = 0; $ii < 55; $ii++) {
      $f =  strtoupper($c[rand(0, 19)]) . $w[rand(0,5)] . $c[rand(0, 19)] . $w[rand(0,5)] . $c[rand(0, 19)];
      $user = array(
        'firstname' => $f,
        'lastname' => strtoupper($c[rand(0, 19)]) . $w[rand(0,5)] . $c[rand(0, 19)] . $w[rand(0,5)] . $c[rand(0, 19)] . $w[rand(0,5)],
        'age' => rand (18,70),
        'email' => strtolower($f) . '@gmail.com',
        'created_on' => (time() - rand(0, 504800)) * 1000,
        'last_edited' => (time() - rand(0, 504800)) * 1000,
        'active' => rand (0,1) == 0 ? true : false
      );
      
      array_push($users, $user);
    }
    
    echo $json->encode (array(
      "users" => $users
    ));
    
  } else {
    $dataPath = dirname(dirname(dirname(__FILE__))) . DIRECTORY_SEPARATOR . 'data' . DIRECTORY_SEPARATOR . 'users.json';
    $users = file_get_contents($dataPath);
    header('Content-Type: application/json');
    echo $users;
  }
?>