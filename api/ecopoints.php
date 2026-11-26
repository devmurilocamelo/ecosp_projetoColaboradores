<?php

declare(strict_types=1)

header('Content-Type: application/json; charset=utf-8');

// BLOCO 1: validar método HTTP (apenas GET)
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(['error' => 'Método não permitido.']);
    exit;
}