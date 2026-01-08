# Modelagem Operacional — NovaShop

A camada operacional da NovaShop tem como objetivo suportar os processos transacionais do negócio, refletindo sempre o estado atual dos pedidos e seus itens. Essa camada é utilizada por sistemas de apoio à operação, faturamento e atendimento ao cliente.

## Grão da Tabela
A modelagem foi definida com o seguinte grão:

**Uma linha representa um item de um pedido no seu estado atual.**

Essa escolha permite que atributos como quantidade, preço e status sejam controlados no nível mais granular da transação, refletindo com precisão a operação do negócio.

## Estratégia de Persistência
A tabela operacional utiliza **atualização in-place**, ou seja, alterações de status, preço ou quantidade sobrescrevem o registro existente. Essa decisão foi tomada porque:

* O interesse da camada operacional é o **estado corrente** do pedido.
* Histórico de mudanças não é necessário para suportar os processos operacionais.
* A manutenção de histórico é responsabilidade da **camada analítica**.

## Estrutura Lógica

### Tabela `pedido_item`
A tabela operacional principal contém as seguintes colunas:
Columns
├── id_pedido bigint
├── id_item integer
├── id_cliente bigint
├── id_produto bigint
├── quantidade integer
├── preco_unitario numeric
├── valor_total_item numeric
├── status_pedido character varying
├── data_pedido timestamp without time zone
├── data_atualizacao timestamp without time zone
└── canal_venda character varying

text

**Chave primária:** `(id_pedido, id_item)`  
*Garante a unicidade de cada item dentro de um pedido.*

---

### Tabela `clientes`
Estrutura de suporte para dados dos clientes:
Columns
├── id_cliente bigint
├── nome character varying
├── email character varying
├── telefone character varying
├── data_cadastro timestamp without time zone
└── status character varying

text

---

### Tabela `produtos`
Estrutura de suporte para dados dos produtos:
Columns
├── id_produto bigint
├── nome character varying
├── categoria character varying
├── preco_base numeric
├── estoque integer
├── data_cadastro timestamp without time zone
└── ativo boolean

text

## Considerações Técnicas
* A tabela não contém agregações ou métricas derivadas.
* Campos técnicos ou de auditoria são mantidos apenas para suportar a operação.
* O modelo prioriza clareza e simplicidade, facilitando manutenção e uso operacional.

## Relacionamentos
clientes (1) ---- () pedido_item () ---- (1) produtos

text

* Um cliente pode ter vários itens de pedido
* Um produto pode aparecer em vários itens de pedido
* Cada item de pedido pertence a um único cliente e um único produto