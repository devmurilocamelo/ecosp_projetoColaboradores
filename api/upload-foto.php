<?php

header("Content-type: application/json");

#verificação de metodo
if($_SERVER["REQUEST_METHOD"] != "POST"){
    http_response_code(405);
    echo json_decode(["error" => "Metodo não permitido"]);
    exit;
}

$protocol = $_POST["protocol"] ?? null;
$photo = $_FILES["photo"] ?? null; 

if($photo["error"] != UPLOAD_ERR_OK){
    http_response_code(400);
    echo json_encode(["error" => "Falha no envio da fotografia"]);
    exit;
}

#verificação de envio
if (empty($protocol) || empty($photo)){
    http_response_code(400);
    echo json_encode(["error" => "Protocolo não informado"]);
    exit;
}


?>