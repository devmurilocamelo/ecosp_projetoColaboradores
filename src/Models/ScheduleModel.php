<?php

namespace App\Models;

use PDO;

class ScheduleModel
{
    private PDO $pdo;

    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo;
    }

    public function findByCitizenEmail(string $email): array
    {
        $sql = "SELECT
                    s.protocol,
                    s.citizen_name,
                    e.name AS ecopoint_name,
                    c.name AS category_name,
                    s.weight_kg,
                    s.ecopoints_earned,
                    s.scheduled_date,
                    s.status,
                    s.photo_path
                FROM schedules s
                INNER JOIN ecopoints  e ON e.id = s.ecopoint_id
                INNER JOIN categories c ON c.id = s.category_id
                WHERE s.citizen_email = :email
                ORDER BY s.scheduled_date DESC, s.id DESC";

        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(['email' => $email]);

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}