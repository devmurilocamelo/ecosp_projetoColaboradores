-- =========================================================
-- EcoSP - Plataforma de Sustentabilidade e Reciclagem
-- Módulo C: Back-End API (Banco de Dados Inicial)
-- Banco de Dados: ecosp_db
-- =========================================================

CREATE DATABASE IF NOT EXISTS `ecosp_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `ecosp_db`;

-- Desabilita checagem de chaves estrangeiras para permitir DROP e recriação limpa
SET FOREIGN_KEY_CHECKS = 0;

-- Limpeza de tabelas existentes (Idempotência garantida)
DROP TABLE IF EXISTS `schedules`;
DROP TABLE IF EXISTS `ecopoint_categories`;
DROP TABLE IF EXISTS `ecopoints`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `market_lots`;

-- ---------------------------------------------------------
-- 1. Tabela: categories (Categorias de Resíduos)
-- ---------------------------------------------------------
CREATE TABLE `categories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `slug` VARCHAR(100) NOT NULL UNIQUE,
    `description` TEXT NULL,
    `points_per_kg` INT NOT NULL DEFAULT 10,
    `icon_name` VARCHAR(50) DEFAULT 'recycle',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `points_per_kg`, `icon_name`) VALUES
(1, 'Plásticos e Garrafas PET', 'plasticos', 'Polímeros, recipientes e garrafas limpas e secas.', 15, 'plastic'),
(2, 'Papéis e Papelão', 'papeis', 'Jornais, revistas, caixas desmontadas e secas.', 10, 'box'),
(3, 'Metais e Alumínio', 'metais', 'Latas, esquadrias e componentes metálicos sem óleo.', 25, 'metal'),
(4, 'Vidros e Frascos', 'vidros', 'Garrafas, potes de conserva e vidros inteiros.', 12, 'glass'),
(5, 'Eletrônicos e Baterias', 'eletronicos', 'Celulares, cabos, placas e pilhas usadas.', 50, 'cpu');

-- ---------------------------------------------------------
-- 2. Tabela: ecopoints (Pontos de Coleta Cadastrados)
-- ---------------------------------------------------------
CREATE TABLE `ecopoints` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(150) NOT NULL,
    `address` VARCHAR(255) NOT NULL,
    `neighborhood` VARCHAR(100) NOT NULL,
    `latitude` DECIMAL(10, 7) NOT NULL,
    `longitude` DECIMAL(10, 7) NOT NULL,
    `operating_hours` VARCHAR(100) NOT NULL DEFAULT 'Segunda a Sábado, das 08h às 17h',
    `contact_phone` VARCHAR(20) DEFAULT '(11) 3333-0000',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `ecopoints` (`id`, `name`, `address`, `neighborhood`, `latitude`, `longitude`, `operating_hours`, `contact_phone`) VALUES
(1, 'Ecoponto Pinheiros - Marginal', 'Praça Victor Civita, 100', 'Pinheiros', -23.561414, -46.697582, '08:00 - 18:00', '(11) 3031-1001'),
(2, 'Ecoponto Mooca - Bresser', 'Rua dos Trilhos, 800', 'Mooca', -23.551220, -46.602150, '08:00 - 17:00', '(11) 2292-2002'),
(3, 'Ecoponto Santana - Cruzeiro', 'Av. Zaki Narchi, 500', 'Santana', -23.508900, -46.621400, '08:00 - 18:00', '(11) 2977-3003'),
(4, 'Ecoponto Tatuapé - Radial', 'Rua Melo Freire, 120', 'Tatuapé', -23.541100, -46.575000, '08:00 - 17:00', '(11) 2091-4004'),
(5, 'Ecoponto Santo Amaro - Santo Dias', 'Rua Arquiteto Roberto, 350', 'Santo Amaro', -23.652100, -46.708900, '08:00 - 18:00', '(11) 5521-5005');

-- ---------------------------------------------------------
-- 3. Tabela N:N: ecopoint_categories (Categorias aceitas por Ecoponto)
-- ---------------------------------------------------------
CREATE TABLE `ecopoint_categories` (
    `ecopoint_id` INT NOT NULL,
    `category_id` INT NOT NULL,
    PRIMARY KEY (`ecopoint_id`, `category_id`),
    CONSTRAINT `fk_ecopoint_cat_ecopoint` FOREIGN KEY (`ecopoint_id`) REFERENCES `ecopoints`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_ecopoint_cat_category` FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `ecopoint_categories` (`ecopoint_id`, `category_id`) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), -- Pinheiros aceita tudo
(2, 1), (2, 2), (2, 3),                 -- Mooca aceita plástico, papel, metal
(3, 1), (3, 2), (3, 4), (3, 5),         -- Santana aceita quase tudo (menos metal)
(4, 2), (4, 3), (4, 5),                 -- Tatuapé aceita papel, metal, eletrônico
(5, 1), (5, 2), (5, 3), (5, 4), (5, 5); -- Santo Amaro aceita tudo

-- ---------------------------------------------------------
-- 4. Tabela: schedules (Agendamentos e Descarte de Resíduos)
-- ---------------------------------------------------------
CREATE TABLE `schedules` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `protocol` VARCHAR(30) NOT NULL UNIQUE,
    `citizen_name` VARCHAR(150) NOT NULL,
    `citizen_email` VARCHAR(150) NOT NULL,
    `ecopoint_id` INT NOT NULL,
    `category_id` INT NOT NULL,
    `weight_kg` DECIMAL(8, 2) NOT NULL,
    `ecopoints_earned` INT NOT NULL,
    `scheduled_date` DATE NOT NULL,
    `status` ENUM('Pendente', 'Concluido', 'Cancelado') NOT NULL DEFAULT 'Pendente',
    `photo_path` VARCHAR(255) NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_schedules_ecopoint` FOREIGN KEY (`ecopoint_id`) REFERENCES `ecopoints`(`id`),
    CONSTRAINT `fk_schedules_category` FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `schedules` (`protocol`, `citizen_name`, `citizen_email`, `ecopoint_id`, `category_id`, `weight_kg`, `ecopoints_earned`, `scheduled_date`, `status`, `photo_path`) VALUES
('ECO-2026-1001', 'Carlos Silva', 'carlos@email.com', 1, 1, 4.00, 60, '2026-10-15', 'Concluido', NULL),
('ECO-2026-1002', 'Carlos Silva', 'carlos@email.com', 1, 5, 2.00, 100, '2026-10-18', 'Concluido', NULL),
('ECO-2026-1003', 'Mariana Souza', 'mariana@email.com', 2, 3, 3.50, 88, '2026-10-20', 'Pendente', NULL);

-- Restaura checagem de chaves estrangeiras
SET FOREIGN_KEY_CHECKS = 1;
