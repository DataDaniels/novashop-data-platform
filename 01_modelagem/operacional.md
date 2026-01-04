### Modelagem Operacional — NovaShop

A camada operacional da NovaShop tem como objetivo suportar os processos transacionais do negócio, refletindo sempre o **estado atual** dos pedidos e seus itens. Essa camada é utilizada por sistemas de apoio à operação, faturamento e atendimento ao cliente.

#### Grão da Tabela

A modelagem foi definida com o seguinte grão:

> **Uma linha representa um item de um pedido no seu estado atual.**

Essa escolha permite que atributos como quantidade, preço e status sejam controlados no nível mais granular da transação, refletindo com precisão a operação do negócio.

#### Estratégia de Persistência

A tabela operacional utiliza **atualização in-place**, ou seja, alterações de status, preço ou quantidade sobrescrevem o registro existente. Essa decisão foi tomada porque:

* O interesse da camada operacional é o estado corrente do pedido.
* Histórico de mudanças não é necessário para suportar os processos operacionais.
* A manutenção de histórico é responsabilidade da camada analítica.

#### Estrutura Lógica

A tabela operacional principal é denominada `pedido_item` e contém, entre outras, as seguintes colunas:

* `id_pedido`
* `id_item`
* `id_cliente`
* `id_produto`
* `quantidade`
* `preco_unitario`
* `status_pedido`
* `data_pedido`
* `data_atualizacao`
* `canal_venda`

A chave primária é composta por (`id_pedido`, `id_item`), garantindo a unicidade de cada item dentro de um pedido.

#### Considerações Técnicas

* A tabela não contém agregações ou métricas derivadas.
* Campos técnicos ou de auditoria são mantidos apenas para suportar a operação.
* O modelo prioriza clareza e simplicidade, facilitando manutenção e uso operacional.