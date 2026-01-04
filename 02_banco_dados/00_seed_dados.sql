-- =========================================================
-- Geração de dados sintéticos em escala - NovaShop
-- Volume controlado e realista
-- =========================================================

-- Limpeza prévia (opcional, para reexecução)
TRUNCATE TABLE operacional.pedido_item;

-- =========================================================
-- Parâmetros de controle
-- =========================================================
-- Total de pedidos: ~300.000
-- Cada pedido terá de 1 a 3 itens
-- Período: últimos 12 meses
-- =========================================================

WITH pedidos AS (
    SELECT
        gs AS id_pedido,
        (random() * 50000)::BIGINT + 1 AS id_cliente,
        (CURRENT_DATE - (random() * 365)::INT) AS data_pedido,
        CASE
            WHEN random() < 0.70 THEN 'FATURADO'
            WHEN random() < 0.90 THEN 'APROVADO'
            ELSE 'CANCELADO'
        END AS status_pedido,
        CASE
            WHEN random() < 0.6 THEN 'SITE'
            WHEN random() < 0.85 THEN 'APP'
            ELSE 'MARKETPLACE'
        END AS canal_venda,
        (random() * 2)::INT + 1 AS total_itens
    FROM generate_series(1, 300000) gs
),
itens AS (
    SELECT
        p.id_pedido,
        generate_series(1, p.total_itens) AS id_item,
        p.id_cliente,
        (random() * 2000)::BIGINT + 1 AS id_produto,
        (random() * 4)::INT + 1 AS quantidade,
        ROUND((random() * 4500 + 100)::NUMERIC, 2) AS preco_unitario,
        p.status_pedido,
        p.data_pedido,
        p.data_pedido + make_interval(days => (random() * 30)::int) AS data_atualizacao,
        p.canal_venda
    FROM pedidos p
)

INSERT INTO operacional.pedido_item (
    id_pedido,
    id_item,
    id_cliente,
    id_produto,
    quantidade,
    preco_unitario,
    status_pedido,
    data_pedido,
    data_atualizacao,
    canal_venda
)
SELECT
    id_pedido,
    id_item,
    id_cliente,
    id_produto,
    quantidade,
    preco_unitario,
    status_pedido,
    data_pedido,
    data_atualizacao,
    canal_venda
FROM itens;