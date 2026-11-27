<?php

namespace App\Controllers;

use App\Models\ScheduleModel;

class HistoryController
{
    private ScheduleModel $model;

    public function __construct(ScheduleModel $model)
    {
        $this->model = $model;
    }

    public function show(string $email): void
    {
        $email = rawurldecode($email);

        $rows = $this->model->findByCitizenEmail($email);

        if (empty($rows)) {
            $this->json(404, [
                'message' => 'Nenhum agendamento encontrado para o e-mail informado.'
            ]);
            return;
        }

        $totalPoints = 0;
        $totalWeight = 0.0;
        $history = [];

        foreach ($rows as $row) {
            $points = (int) $row['ecopoints_earned'];
            $weight = (float) $row['weight_kg'];

            $totalPoints += $points;
            $totalWeight += $weight;

            $history[] = [
                'protocol'         => $row['protocol'],
                'ecopoint_name'    => $row['ecopoint_name'],
                'category_name'    => $row['category_name'],
                'weight_kg'        => $weight,
                'ecopoints_earned' => $points,
                'scheduled_date'   => $row['scheduled_date'],
                'status'           => $row['status'],
                'photo_path'       => $row['photo_path'],
            ];
        }

        $this->json(200, [
            'citizen_email'            => $email,
            'citizen_name'             => $rows[0]['citizen_name'],
            'total_ecopoints'          => $totalPoints,
            'total_weight_recycled_kg' => round($totalWeight, 2),
            'schedules_count'          => count($rows),
            'history'                  => $history,
        ]);
    }

    private function json(int $status, array $data): void
    {
        http_response_code($status);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode($data, JSON_PRESERVE_ZERO_FRACTION | JSON_UNESCAPED_UNICODE);
    }
}