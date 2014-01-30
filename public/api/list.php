<?php
  $dataPath = dirname(dirname(dirname(__FILE__))) . DIRECTORY_SEPARATOR . 'data' . DIRECTORY_SEPARATOR . 'users.json';
  $users = file_get_contents($dataPath);
  header('Content-Type: application/json');
  echo $users;
?>