-- =========================================================
-- EcoSP - Dados de Teste Cego para a Banca Avaliadora
-- Módulo C: Back-End API (Injeção em Tempo de Correção)
-- Objetivo: Validar se a API é dinâmica e não possui dados mockados/hardcoded
-- =========================================================

USE `ecosp_db`;

-- Inserção de uma categoria inédita de teste
INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `points_per_kg`, `icon_name`) VALUES
(6, 'Óleo de Cozinha Usado', 'oleo-usado', 'Óleo vegetal usado acondicionado em garrafa PET.', 30, 'oil');

-- Inserção de um ecoponto inédito na Zona Leste
INSERT INTO `ecopoints` (`id`, `name`, `address`, `neighborhood`, `latitude`, `longitude`, `operating_hours`, `contact_phone`) VALUES
(6, 'Ecoponto Itaquera - Arena', 'Av. Miguel Ignácio Curi, 111', 'Itaquera', -23.545100, -46.474200, '08:00 - 17:00', '(11) 2056-6006');

-- Vinculando o novo ecoponto com as categorias 1 (Plásticos) e 6 (Óleo de Cozinha)
INSERT INTO `ecopoint_categories` (`ecopoint_id`, `category_id`) VALUES
(6, 1),
(6, 6);

-- Inserção de um agendamento novo para conferir histórico
INSERT INTO `schedules` (`protocol`, `citizen_name`, `citizen_email`, `ecopoint_id`, `category_id`, `weight_kg`, `ecopoints_earned`, `scheduled_date`, `status`) VALUES
('ECO-TEST-9999', 'Avaliador Teste', 'avaliador.teste@spskills.com.br', 6, 6, 10.00, 300, '2026-11-01', 'Concluido');
