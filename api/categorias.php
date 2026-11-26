<?php
// para trazer o código que está em 'CategoryController' pra cá
require_once __DIR__ . '/../src/Controllers/CategoryController.php';

// para verificar qual o método
if ($_SERVER['REQUEST_METHOD']==='GET'){
    // aqui cria o objeto e executa a função index
    $controller = new CategoryController();
    $controller ->index();
}
else{
    // para caso o metódo seja diferente de GET
    header('Content-Type: applications/json; charset=utf-8');
    http_response_code(405);
    echo json_encode(['error' =>'Não é possível utilizar esse método'], JSON_UNESCAPED_UNICODE);
}