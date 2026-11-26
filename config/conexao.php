<?php
$host    = 'localhost';
$usuario = 'root';
$senha   = '';
$banco   = 'eco_sp';

try {
    $conn = new PDO(
        "mysql:host=$host;dbname=$banco;charset=utf8mb4",
        $usuario,
        $senha,
        [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ]
    );
} catch (PDOException $e) {
    die('Não foi possível conectar ao banco: ' . $e->getMessage());
}