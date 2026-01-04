-- =========================================================
-- Schema Operacional - NovaShop
-- Objetivo: Suportar o estado atual dos pedidos e seus itens
-- =========================================================

-- Criação do schema operacional
'''sql
CREATE SCHEMA IF NOT EXISTS operacional;
'''

-- =========================================================
-- Tabela: pedido_item
-- Grão: 1 linha representa um item de pedido no estado atual
-- Estratégia: atualização in-place
-- =========================================================

CREATE TABLE IF NOT EXISTS operacional.pedido_item (
    id_pedido        BIGINT      NOT NULL,
    id_item          INTEGER     NOT NULL,
    id_cliente       BIGINT      NOT NULL,
    id_produto       BIGINT      NOT NULL,
    quantidade       INTEGER     NOT NULL CHECK (quantidade > 0),
    preco_unitario   NUMERIC(10,2) NOT NULL CHECK (preco_unitario >= 0),
    status_pedido    VARCHAR(20) NOT NULL,
    data_pedido      DATE        NOT NULL,
    data_atualizacao TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    canal_venda      VARCHAR(50) NOT NULL,

    CONSTRAINT pk_pedido_item PRIMARY KEY (id_pedido, id_item),

    CONSTRAINT ck_status_pedido
        CHECK (status_pedido IN ('PENDENTE', 'APROVADO', 'FATURADO', 'CANCELADO'))
);

-- =========================================================
-- Índices Operacionais
-- =========================================================

-- Suporte a consultas por status (ex: faturamento, cancelamentos)
CREATE INDEX IF NOT EXISTS idx_pedido_item_status
    ON operacional.pedido_item (status_pedido);

-- Suporte a consultas por data do pedido
CREATE INDEX IF NOT EXISTS idx_pedido_item_data_pedido
    ON operacional.pedido_item (data_pedido);

-- Suporte a consultas por cliente
CREATE INDEX IF NOT EXISTS idx_pedido_item_cliente
    ON operacional.pedido_item (id_cliente);

-- Suporte a consultas por produto
CREATE INDEX IF NOT EXISTS idx_pedido_item_produto
    ON operacional.pedido_item (id_produto);

-- =========================================================
-- Observações:
-- - Histórico não é mantido nesta tabela
-- - Alterações sobrescrevem o estado anterior
-- - A camada analítica é responsável por histórico e métricas
-- =========================================================