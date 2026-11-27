# Oficina Mecânica — Modelagem de Banco de Dados

Projeto acadêmico de **Modelagem de Banco de Dados** que desenvolve a estrutura relacional de um sistema de gerenciamento para uma oficina mecânica. O banco foi projetado para organizar informações de clientes, veículos, funcionários, serviços, peças, estoque, fornecedores, ordens de serviço, pagamentos, despesas e avaliações.

O projeto utiliza **MySQL 8.0** e apresenta o processo completo de modelagem, desde o levantamento do domínio e a elaboração do Modelo Entidade-Relacionamento (DER) até a implementação das tabelas e a realização de consultas SQL.

> **Escopo:** este repositório documenta a modelagem e a implementação da camada de banco de dados. Não se trata de uma aplicação web ou desktop com interface gráfica.

## Objetivos do projeto

- Modelar os dados necessários para representar a rotina de uma oficina mecânica.
- Definir entidades, atributos, relacionamentos e cardinalidades.
- Transformar o modelo conceitual em um modelo lógico relacional.
- Aplicar normalização para reduzir redundâncias e evitar anomalias de inserção, atualização e exclusão.
- Implementar tabelas, chaves e restrições no MySQL.
- Inserir dados fictícios para validar a estrutura.
- Desenvolver consultas para recuperar informações operacionais e financeiras.

## Funcionalidades representadas pelo banco

A estrutura permite armazenar e relacionar informações para:

- **Cadastro de clientes e veículos:** dados dos clientes, seus contatos e os veículos sob sua responsabilidade.
- **Funcionários:** identificação dos colaboradores, seus cargos e informações de contato.
- **Agendamentos:** registro do cliente que marcou o horário, do veículo, da data e do motivo da visita.
- **Ordens de serviço:** abertura e acompanhamento dos atendimentos, com veículo, funcionário responsável, quilometragem de entrada, problema relatado e situação da ordem.
- **Catálogo de serviços:** cadastro de serviços, preços de tabela e duração estimada.
- **Peças e estoque:** cadastro de peças, quantidades disponíveis e limites mínimos para reposição.
- **Fornecedores:** cadastro de empresas fornecedoras e associação entre fornecedores e peças, incluindo preço de custo e prazo de entrega.
- **Pagamentos:** registro dos valores recebidos por ordem de serviço, permitindo representar pagamentos parcelados.
- **Despesas:** controle de gastos da oficina, como peças, aluguel, contas, salários e impostos.
- **Histórico de manutenção:** registro de manutenções realizadas, inclusive aquelas feitas antes da utilização do sistema ou em outra oficina.
- **Avaliações:** armazenamento da nota e do comentário do cliente sobre um atendimento.

## Tecnologias e ferramentas

- **SGBD:** MySQL 8.0
- **Mecanismo de armazenamento:** InnoDB
- **Ferramenta de administração e execução:** MySQL Workbench
- **Linguagem:** SQL

O MySQL foi escolhido por ser um SGBD relacional, oferecer integridade referencial, suportar restrições `CHECK` e possuir integração com tecnologias comuns de desenvolvimento e hospedagem.

## Estrutura do banco de dados

O banco criado chama-se `oficina_mecanica` e possui **18 tabelas**:

| Tabela | Responsabilidade |
|---|---|
| `CLIENTE` | Armazena os dados dos clientes. |
| `TELEFONE_CLIENTE` | Permite registrar vários telefones para um cliente. |
| `FUNCIONARIO` | Armazena os dados e o cargo dos funcionários. |
| `FORNECEDOR` | Registra as empresas fornecedoras. |
| `TELEFONE_FORNECEDOR` | Permite registrar vários telefones para um fornecedor. |
| `SERVICO` | Mantém o catálogo de serviços e seus preços de tabela. |
| `PECA` | Cadastra as peças utilizadas nos atendimentos. |
| `ESTOQUE` | Controla as quantidades disponíveis e mínimas das peças. |
| `FORNECEDOR_PECA` | Relaciona fornecedores e peças, registrando custo e prazo de entrega. |
| `VEICULO` | Registra os veículos e seus respectivos clientes responsáveis. |
| `AGENDAMENTO` | Armazena os horários e as solicitações de atendimento. |
| `ORDEM_SERVICO` | Registra os atendimentos realizados ou em andamento. |
| `ORDEM_SERVICO_SERVICO` | Relaciona serviços às ordens e registra o preço cobrado no atendimento. |
| `ORDEM_SERVICO_PECA` | Relaciona peças às ordens, com quantidade e preço praticado. |
| `PAGAMENTO` | Registra cada pagamento recebido por uma ordem. |
| `DESPESA` | Controla as despesas da oficina. |
| `HISTORICO_MANUTENCAO` | Mantém o histórico de manutenção de cada veículo. |
| `AVALIACAO` | Armazena a avaliação de um atendimento. |

### Principais relacionamentos

- Um **cliente** pode possuir vários veículos; cada veículo está associado a um cliente responsável.
- Um **veículo** pode possuir várias ordens de serviço; cada ordem pertence a um veículo e possui um funcionário responsável.
- Um **agendamento** registra separadamente quem solicitou o horário e qual veículo será atendido. Assim, quem agenda não precisa ser o proprietário do veículo.
- Uma **ordem de serviço** pode conter vários serviços e várias peças. Esses relacionamentos N:N são implementados pelas tabelas `ORDEM_SERVICO_SERVICO` e `ORDEM_SERVICO_PECA`.
- Um **fornecedor** pode fornecer várias peças, e uma peça pode ser fornecida por diferentes empresas. Esse relacionamento N:N é implementado por `FORNECEDOR_PECA`.
- Uma **ordem de serviço** pode receber vários pagamentos, permitindo o parcelamento.
- Uma ordem pode gerar um registro no histórico de manutenção e receber, no máximo, uma avaliação.

## Modelagem e decisões de projeto

### Normalização

O modelo foi revisado para atender à **3ª Forma Normal (3FN)**, com uma exceção consciente no histórico de manutenção, que mantém uma fotografia dos dados do reparo e também aceita registros antigos sem uma ordem cadastrada no sistema.

Entre as decisões aplicadas estão:

- Telefones de clientes e fornecedores foram separados em tabelas próprias, evitando armazenar vários números em um único campo.
- Os relacionamentos muitos-para-muitos foram resolvidos com tabelas associativas.
- As quantidades de peças foram centralizadas em `ESTOQUE`, evitando duplicidade de informação.
- O cliente não é repetido em `ORDEM_SERVICO`: ele pode ser identificado pelo relacionamento entre ordem, veículo e cliente.
- O valor total da ordem, o valor pendente e a necessidade de reposição são calculados por consultas, em vez de serem armazenados como dados duplicados.

### Chaves e integridade

- As entidades principais utilizam identificadores artificiais (`id_...`) como chaves primárias.
- Chaves naturais, como CPF, CNPJ, placa e código da peça, são protegidas por restrições `UNIQUE` quando aplicável.
- Tabelas associativas e de telefones utilizam chaves primárias compostas.
- Chaves estrangeiras garantem a integridade dos relacionamentos.
- Restrições `NOT NULL`, `UNIQUE` e `CHECK` validam obrigatoriedade, unicidade e regras de domínio, como valores não negativos e situações permitidas.
- As políticas `ON DELETE` variam conforme a relação: `CASCADE` é usado quando o registro dependente não faz sentido sem o registro principal; `RESTRICT` protege dados históricos e financeiros; `SET NULL` é aplicado em referências opcionais.

Um exemplo importante é o relacionamento entre `PAGAMENTO` e `ORDEM_SERVICO`: a exclusão de uma ordem que possui pagamentos é bloqueada por `RESTRICT`, preservando o histórico financeiro.

## Organização dos arquivos

O projeto é acompanhado por três scripts SQL, que devem ser executados nesta ordem:

| Arquivo | Descrição |
|---|---|
| `01_criacao.sql` | Cria o banco `oficina_mecanica` e suas 18 tabelas, define chaves primárias e estrangeiras, restrições `UNIQUE`, `NOT NULL` e 30 regras `CHECK`, além das políticas de exclusão e de um ajuste com `ALTER TABLE`. |
| `02_carga_dados.sql` | Insere de 5 a 10 registros por tabela, executa exemplos de `UPDATE` e `DELETE` com consultas de conferência e inclui testes comentados de violações de chave estrangeira. |
| `03_consultas.sql` | Reúne 19 consultas comentadas: 8 consultas sobre uma tabela, 4 com `JOIN`, 5 com agregações e 2 para calcular atributos derivados. |

## Como executar

### Requisitos

- MySQL Server 8.0.16 ou superior, para suporte às restrições `CHECK` utilizadas no projeto.
- MySQL Workbench ou outra ferramenta capaz de executar scripts SQL.

### Passo a passo

1. Abra o MySQL Workbench e conecte-se ao servidor MySQL.
2. Abra o arquivo `01_criacao.sql` e execute o script para criar o banco e as tabelas.
3. Abra `02_carga_dados.sql` e execute-o para inserir os dados de teste.
4. Abra `03_consultas.sql` e execute as consultas para visualizar e analisar os dados.

**Importante:** execute os arquivos na sequência indicada. O script de criação prepara a estrutura, o script de carga depende das tabelas existentes e o script de consultas utiliza os dados inseridos.

## Testes realizados

De acordo com o relatório, os três scripts foram executados em sequência no MySQL 8.0, após a remoção prévia do banco, sem erros — inclusive com o modo **Safe Updates** do MySQL Workbench ativado.

A carga de dados também foi utilizada para verificar regras do modelo. Entre os casos testados estão a inclusão de referências inexistentes e a tentativa de excluir uma ordem que possui pagamentos, operações que devem ser recusadas pelas restrições de integridade referencial (erros MySQL 1452 e 1451, respectivamente).

Os dados utilizados são fictícios e têm finalidade acadêmica, para demonstrar o funcionamento e validar a estrutura proposta.

## Consultas disponíveis

O arquivo `03_consultas.sql` contém consultas para explorar os dados em diferentes níveis:

- Consultas individuais para visualizar registros das tabelas.
- Consultas com `JOIN` para combinar informações relacionadas, como clientes, veículos e ordens de serviço.
- Consultas com funções de agregação para produzir totais e indicadores.
- Consultas para calcular o valor total e o valor pendente das ordens, além de identificar a necessidade de reposição de peças.

## Possíveis evoluções

O relatório identifica como possível evolução o registro de vários mecânicos por serviço executado. Na versão atual, cada ordem de serviço possui um único funcionário responsável pelo atendimento.

## Autor

**Alberto Mário**  
Projeto Final — Modelagem de Banco de Dados  
Turma: P2D  
Data do relatório: 27 de novembro de 2026
