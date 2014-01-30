<?php
  $dataPath = dirname(dirname(dirname(__FILE__))) . DIRECTORY_SEPARATOR . 'data' . DIRECTORY_SEPARATOR . 'users.json';
  
  file_put_contents($dataPath, $HTTP_RAW_POST_DATA);
  
  header('Content-Type: application/json');
?>