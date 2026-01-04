-- =========================================================
-- Simulação de cancelamento pós-faturamento (~3%)
-- =========================================================

-- UPDATE operacional.pedido_item
-- SET
--     status_pedido = 'CANCELADO',
--     data_atualizacao = CURRENT_TIMESTAMP
-- WHERE status_pedido = 'FATURADO'
--   AND random() < 0.03;