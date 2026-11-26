<?php
$protocol = $_POST["protocol"] ?? null;
$photo = $_FILES["photo"] ?? null; 

#exibir protocolo
echo "$protocol";

#info. fotografia
print_r($photo);

#verificação de envio
if (empty($protocol) || empty($photo)){
    echo "Dados Obrigatórios não informados";
    exit;
}

?>