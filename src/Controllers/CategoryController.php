<?php
class CategoryController{
    public function index(){
        $categorias = [
            ["id" => 1 ,
            "name" => "Plásticos e Garrafas PET",
            "slug" => "Plásticos",
            "points_per_kg" => 10,
            "icon_name" => "plastico",
            ],
        ];

        header('Content-Type: application/json; charset=utf-8');
        http_response_code(200);
        echo json_encode($categorias, JSON_UNESCAPED_UNICODE);
    }
}