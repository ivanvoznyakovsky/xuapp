<?php
  $dataPath = dirname(dirname(dirname(__FILE__))) . DIRECTORY_SEPARATOR . 'data' . DIRECTORY_SEPARATOR . 'users.json';
  
  echo file_put_contents($dataPath, $HTTP_RAW_POST_DATA);
?>