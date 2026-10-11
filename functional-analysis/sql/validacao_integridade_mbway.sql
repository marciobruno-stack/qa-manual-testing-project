-- ==============================================================================
-- PROJETO DE ANÁLISE FUNCIONAL & QA: VALIDAÇÃO DE TRANSAÇÕES MB WAY
-- Autor: Márcio Bruno Santos
-- Objetivo: Scripts SQL para validação de regras de negócio e integridade de dados
-- ==============================================================================

-- 1. ESTRUTURA DAS TABELAS SIMULADAS (DDL)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS clientes (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telemovel VARCHAR(15) NOT NULL
);

CREATE TABLE IF NOT EXISTS encomendas (
    id INT PRIMARY KEY,
    cliente_id INT NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    status VARCHAR(30) NOT NULL, -- 'PENDENTE_PAGAMENTO', 'PAGO', 'CANCELADO_TIMEOUT', 'CANCELADO_RECUSADO'
    metodo_pagamento VARCHAR(20) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE IF NOT EXISTS transacoes_mbway (
    id INT PRIMARY KEY,
    encomenda_id INT NOT NULL,
    telemovel_pagamento VARCHAR(15) NOT NULL,
    valor_cobrado DECIMAL(10, 2) NOT NULL,
    referencia_gateway VARCHAR(50) UNIQUE,
    status_transacao VARCHAR(30) NOT NULL, -- 'WAITING_AUTH', 'SUCCESS', 'EXPIRED', 'REJECTED'
    mensagem_retorno VARCHAR(255),
    data_expiracao TIMESTAMP,
    data_confirmacao TIMESTAMP,
    FOREIGN KEY (encomenda_id) REFERENCES encomendas(id)
);

-- ------------------------------------------------------------------------------
-- 2. QUERIES DE VALIDAÇÃO FUNCIONAL (TESTES DE NEGÓCIO VIA BANCO DE DADOS)
-- ------------------------------------------------------------------------------

-- CENÁRIO 1: Validação do Caminho Feliz (Status PAGO e Valores Conciliados)
-- O Analista Funcional/QA valida se o valor cobrado na transação do gateway
-- é idêntico ao valor registrado no cabeçalho da encomenda.
SELECT 
    e.id AS encomenda_id,
    c.nome AS cliente,
    e.valor_total AS valor_encomenda,
    t.valor_cobrado AS valor_mbway,
    e.status AS status_encomenda,
    t.status_transacao AS status_mbway,
    t.referencia_gateway,
    t.data_confirmacao
FROM encomendas e
INNER JOIN transacoes_mbway t ON e.id = t.encomenda_id
INNER JOIN clientes c ON e.cliente_id = c.id
WHERE e.id = 1001
  AND e.status = 'PAGO'
  AND t.status_transacao = 'SUCCESS';


-- CENÁRIO 2: Validação de Expiração por Timeout (4 minutos)
-- Garante que transações expiradas no gateway refletem corretamente no estado da encomenda.
SELECT 
    e.id AS encomenda_id,
    e.status AS status_encomenda,
    t.status_transacao AS status_gateway,
    t.data_expiracao,
    TIMESTAMPDIFF(MINUTE, e.data_criacao, t.data_expiracao) AS minutos_decorridos
FROM encomendas e
INNER JOIN transacoes_mbway t ON e.id = t.encomenda_id
WHERE e.status = 'CANCELADO_TIMEOUT'
  AND t.status_transacao = 'EXPIRED';


-- ------------------------------------------------------------------------------
-- 3. AUDITORIA DE INTEGRIDADE RELACIONAL (A "QUERY CAÇADORA DE BUGS")
-- ------------------------------------------------------------------------------

-- BUG AUDIT 1: Encomendas marcadas como 'PAGO', mas cuja transação NÃO foi confirmada
-- (Detecta brecha financeira crítica onde o cliente leva o produto sem pagar)
SELECT 
    e.id AS encomenda_id,
    e.valor_total,
    e.status AS status_encomenda,
    t.status_transacao AS status_real_gateway
FROM encomendas e
LEFT JOIN transacoes_mbway t ON e.id = t.encomenda_id
WHERE e.status = 'PAGO'
  AND (t.status_transacao IS NULL OR t.status_transacao <> 'SUCCESS');


-- BUG AUDIT 2: Divergência entre o valor da encomenda e o valor enviado ao MB Way
-- (Detecta erros de cálculo ou arredondamento de impostos no checkout)
SELECT 
    e.id AS encomenda_id,
    e.valor_total AS valor_sistema,
    t.valor_cobrado AS valor_cobrado_gateway,
    (e.valor_total - t.valor_cobrado) AS diferenca_valor
FROM encomendas e
INNER JOIN transacoes_mbway t ON e.id = t.encomenda_id
WHERE e.valor_total <> t.valor_cobrado;
