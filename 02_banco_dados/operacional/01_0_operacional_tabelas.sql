-- =========================================================
-- BLOCO 1: CRIAÇÃO TABELAS COM CONSTRAINTS DE UNICIDADE
-- =========================================================

CREATE SCHEMA IF NOT EXISTS operacional;

-- ---------------------------------------------------------
-- 1.1 CLIENTES - CADASTRO ÚNICO
-- ---------------------------------------------------------
CREATE TABLE operacional.clientes (
    id_cliente   BIGSERIAL PRIMARY KEY,
    nome         VARCHAR(100) NOT NULL,
    cpf_cnpj     VARCHAR(20) UNIQUE NOT NULL,  -- ÚNICO e válido
    tipo_pessoa  CHAR(2) NOT NULL CHECK (tipo_pessoa IN ('PF', 'PJ')),
    sexo         CHAR(1) NOT NULL CHECK (sexo IN ('M', 'F', 'O')),
    estado       CHAR(2) NOT NULL,
    cidade       VARCHAR(50) NOT NULL,
    data_nascimento DATE NOT NULL,
    
    -- Para garantir unicidade real: nome + documento para PJ
    CONSTRAINT uk_cliente_pj_nome_doc UNIQUE (nome, cpf_cnpj) 
        DEFERRABLE INITIALLY DEFERRED,
    -- Garantir sexo F, M, O consistente com tipo pessoa
    CONSTRAINT ck_sexo_pf CHECK ((tipo_pessoa = 'PF' AND sexo IN ('M', 'F', 'O')) OR (tipo_pessoa = 'PJ' AND sexo = 'O')),
    
    data_cadastro  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    flag_ativo   BOOLEAN DEFAULT TRUE
);

COMMENT ON TABLE operacional.clientes IS 'Cadastro ÚNICO de clientes - CPF/CNPJ não se repetem';

-- ---------------------------------------------------------
-- 1.2 PRODUTOS - CADASTRO ÚNICO
-- ---------------------------------------------------------
CREATE TABLE operacional.produtos (
    id_produto   BIGSERIAL PRIMARY KEY,
    sku          VARCHAR(50) UNIQUE NOT NULL,  -- ÚNICO no sistema
    nome_produto VARCHAR(150) NOT NULL,
    categoria    VARCHAR(50) NOT NULL,
    subcategoria VARCHAR(50),
    marca        VARCHAR(50) NOT NULL,
    modelo       VARCHAR(50),  -- Adicionado para diferenciar produtos similares
    
    -- Para evitar produtos "iguais" com SKUs diferentes
    CONSTRAINT uk_produto_nome_marca_modelo UNIQUE (nome_produto, marca, modelo) 
        DEFERRABLE INITIALLY DEFERRED,
    
    preco_custo  NUMERIC(10,2),
    preco_venda_sugerido NUMERIC(10,2),
    
    data_cadastro  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status       VARCHAR(20) DEFAULT 'ATIVO'
);

COMMENT ON TABLE operacional.produtos IS 'Cadastro ÚNICO de produtos - SKU único, combinação nome+marca+modelo única';

-- ---------------------------------------------------------
-- 1.3 PEDIDO_ITEM (mantém igual)
-- ---------------------------------------------------------
CREATE TABLE operacional.pedido_item (
    id_pedido        BIGINT NOT NULL,
    id_item          INTEGER NOT NULL,
    id_cliente       BIGINT NOT NULL,
    id_produto       BIGINT NOT NULL,
    quantidade       INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario   NUMERIC(10,2) NOT NULL CHECK (preco_unitario >= 0),
    valor_total_item NUMERIC(12,2) GENERATED ALWAYS AS (quantidade * preco_unitario) STORED,
    status_pedido    VARCHAR(20) NOT NULL,
    data_pedido      TIMESTAMP NOT NULL,
    data_atualizacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    canal_venda      VARCHAR(20) NOT NULL,
    
    CONSTRAINT pk_pedido_item PRIMARY KEY (id_pedido, id_item),
    CONSTRAINT ck_status_pedido CHECK (status_pedido IN ('PENDENTE', 'APROVADO', 'FATURADO'))
);

-- ---------------------------------------------------------
-- 1.4 ÍNDICES PARA PERFORMANCE
-- ---------------------------------------------------------
CREATE INDEX idx_pedido_item_status ON operacional.pedido_item(status_pedido);
CREATE INDEX idx_pedido_item_data ON operacional.pedido_item(data_pedido);
CREATE INDEX idx_pedido_item_cliente ON operacional.pedido_item(id_cliente);
CREATE INDEX idx_pedido_item_produto ON operacional.pedido_item(id_produto);
CREATE INDEX idx_pedido_item_canal ON operacional.pedido_item(canal_venda);

CREATE INDEX idx_clientes_cpf_cnpj ON operacional.clientes(cpf_cnpj);
CREATE INDEX idx_clientes_estado ON operacional.clientes(estado);
CREATE INDEX idx_produtos_sku ON operacional.produtos(sku);
CREATE INDEX idx_produtos_categoria ON operacional.produtos(categoria);
CREATE INDEX idx_produtos_marca ON operacional.produtos(marca);