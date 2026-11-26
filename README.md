# EcoSP Core API — Módulo C

API RESTful para gerenciamento de categorias de resíduos, ecopontos, agendamentos de descarte, fotos e histórico de EcoPoints.

## Tecnologias

- PHP 8.1 ou superior
- MySQL 8.0 ou superior
- PDO para conexão e consultas ao banco
- Servidor Apache (por exemplo, XAMPP)

## Banco de dados

O banco utilizado obrigatoriamente é `ecosp_db`.

### Como criar e popular o banco

1. Inicie o MySQL no XAMPP.
2. Abra o phpMyAdmin (`http://localhost/phpmyadmin`) ou um cliente MySQL.
3. Importe o arquivo `schema_inicial.sql`.

Alternativamente, pelo terminal:

```bash
mysql -u root -p < schema_inicial.sql
```

O script cria o banco `ecosp_db`, as tabelas e alguns registros demonstrativos.

## Estrutura das tabelas

- `categories`: categorias de resíduos e pontos por quilo.
- `ecopoints`: dados dos postos de coleta.
- `ecopoint_categories`: categorias aceitas por cada ecoponto (relacionamento N:N).
- `schedules`: agendamentos, protocolo, peso, pontos, status e caminho da foto.

Os ecopontos inseridos no SQL são exemplos demonstrativos. Substitua-os pelos dados oficiais fornecidos para a avaliação, se houver.

## Configuração da conexão PDO

Crie um arquivo de conexão (por exemplo, `config/database.php`) e ajuste usuário e senha conforme seu MySQL:

```php
<?php
$host = 'localhost';
$dbname = 'ecosp_db';
$user = 'root';
$password = '';

try {
    $pdo = new PDO(
        "mysql:host={$host};dbname={$dbname};charset=utf8mb4",
        $user,
        $password,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false
        ]
    );
} catch (PDOException $e) {
    http_response_code(500);
    exit('Erro ao conectar ao banco de dados.');
}
```

Não publique credenciais reais no repositório.

## Rotas exigidas na atividade

| Método | Rota | Função |
|---|---|---|
| GET | `/api/categories` | Listar categorias e pontuação por quilo |
| GET | `/api/ecopoints` | Listar ecopontos; aceitar filtros `category_id` e `neighborhood` |
| POST | `/api/schedules` | Validar e criar agendamento, calcular EcoPoints e gerar protocolo |
| POST | `/api/schedules/upload-photo` | Receber foto via `multipart/form-data` e vincular ao protocolo |
| GET | `/api/schedules/citizen/{email}` | Consultar histórico, total de pontos e quilos reciclados |

## Regras importantes da atividade

- Todos os campos do agendamento são obrigatórios.
- Validar o formato do e-mail.
- `weight_kg` deve ser maior que zero; caso contrário, responder com HTTP 422.
- `scheduled_date` não pode ser anterior à data atual.
- O ecoponto deve aceitar a categoria escolhida.
- Calcular os pontos com `round(weight_kg * points_per_kg)`.
- Gerar protocolo único no formato `ECO-2026-XXXXX`.
- Salvar o novo agendamento com status `Pendente`.
- No upload, procurar o agendamento pelo protocolo; se não existir, responder 404.
- Salvar a imagem em `uploads/`, preservando o nome original, e atualizar `photo_path`.
- Se o cidadão não tiver histórico, responder 404.

## Pasta de uploads

Na raiz do projeto, crie a pasta `uploads/` e conceda ao servidor permissão de escrita nela.

Exemplo de caminho salvo no banco:

```text
uploads/foto_residuo.png
```

## Exemplo de organização do projeto

```text
ecosp-api/
├── config/
│   └── database.php
├── controllers/
├── models/
├── routes/
├── uploads/
├── schema_inicial.sql
├── README.md
└── index.php
```

A organização acima é uma sugestão; mantenha o caminho de publicação exigido pelos avaliadores.

## Execução

1. Coloque o projeto na pasta pública do Apache.
2. Inicie Apache e MySQL.
3. Importe `schema_inicial.sql`.
4. Configure as credenciais em seu arquivo PDO.
5. Crie a pasta `uploads/` com permissão de escrita.
6. Inicie e teste as rotas com Postman, Insomnia ou `curl`.

A prova exige que a API seja acessível no caminho:

```text
http://IP_DO_SERVIDOR/XXX_modulo_c/api/
```

Substitua `IP_DO_SERVIDOR` pelo IP informado pelos avaliadores e `XXX` pelo CFP da unidade.

## Observação

Este `schema_inicial.sql` é uma implementação inicial elaborada a partir dos requisitos descritos no enunciado da prova. Ele não é o arquivo SQL oficial de apoio, que não foi disponibilizado nesta conversa. Se a organização fornecer o `schema_inicial.sql` original, utilize-o como referência principal e ajuste o código à estrutura real dele.
