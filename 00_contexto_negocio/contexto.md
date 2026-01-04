## Contexto do Negócio — NovaShop

A **NovaShop** é um e-commerce B2C especializado na venda de produtos de informática, atendendo clientes finais em todo o território nacional.

O portfólio de produtos inclui desde itens de maior valor agregado, como **notebooks e computadores**, até produtos de compra recorrente, como **periféricos, acessórios e componentes**. Essa combinação gera um comportamento de compra com **frequência moderada**, variando de acordo com o perfil do cliente e o tipo de produto adquirido.

### Ciclo de Vida do Pedido

O pedido na NovaShop passa pelos seguintes estados:

* **PENDENTE**: pedido criado, aguardando aprovação ou confirmação de pagamento.
* **APROVADO**: pagamento aprovado e pedido elegível para faturamento.
* **FATURADO**: pedido faturado e contabilizado como venda.
* **CANCELADO**: pedido cancelado, podendo ocorrer antes ou após o faturamento.

Uma venda é considerada **válida para fins analíticos** somente quando o pedido atinge o estado **FATURADO**. Cancelamentos realizados após o faturamento são tratados como eventos de reversão, impactando os indicadores analíticos.

### Considerações de Volume

O negócio foi modelado considerando um volume significativo de dados, com centenas de milhares de pedidos distribuídos ao longo de um período de 12 meses. Esse volume permite avaliar, de forma realista, decisões de modelagem, indexação, particionamento e impacto de regras de negócio tanto na camada operacional quanto analítica.