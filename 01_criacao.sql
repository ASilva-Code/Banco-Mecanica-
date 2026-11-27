-- =====================================================================
-- Modelagem de Banco de Dados - Projeto Final
-- Script 01: criação do banco (Etapa 12 + ALTER da Etapa 14)
--
-- Aluno : Alberto Mário
-- RGM   : 47813253
-- Turma : P2D
-- Tema  : Oficina Mecânica
-- SGBD  : MySQL 8.0.16 ou superior (necessário para as regras CHECK)
--
-- Como executar: rodar o arquivo inteiro com Ctrl + Shift + Enter.
-- Ordem dos CREATE TABLE: primeiro as tabelas referenciadas, depois as
-- que possuem chaves estrangeiras.
-- =====================================================================

DROP DATABASE IF EXISTS oficina_mecanica;

CREATE DATABASE oficina_mecanica
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_0900_ai_ci;

USE oficina_mecanica;


-- ---------------------------------------------------------------------
-- 1) Tabelas sem chave estrangeira (referenciadas pelas demais)
-- ---------------------------------------------------------------------

-- CLIENTE: pessoas que trazem veículos à oficina.
-- Endereço (atributo composto) foi separado em colunas.
-- Telefone (multivalorado) foi para a tabela telefone_cliente.
CREATE TABLE cliente (
    id_cliente     INT           NOT NULL AUTO_INCREMENT,
    nome           VARCHAR(120)  NOT NULL,
    cpf            CHAR(11)      NOT NULL,
    email          VARCHAR(150)  NULL,
    rua            VARCHAR(120)  NULL,
    numero         VARCHAR(10)   NULL,
    bairro         VARCHAR(80)   NULL,
    cidade         VARCHAR(80)   NULL,
    cep            CHAR(8)       NULL,
    data_cadastro  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
    CONSTRAINT uq_cliente_cpf UNIQUE (cpf),
    -- regra de domínio: CPF guardado só com os 11 dígitos, sem pontuação
    CONSTRAINT ck_cliente_cpf CHECK (cpf REGEXP '^[0-9]{11}$'),
    CONSTRAINT ck_cliente_cep CHECK (cep IS NULL OR cep REGEXP '^[0-9]{8}$')
);

-- FUNCIONARIO: pessoas que trabalham na oficina.
CREATE TABLE funcionario (
    id_funcionario    INT           NOT NULL AUTO_INCREMENT,
    nome              VARCHAR(120)  NOT NULL,
    cpf               CHAR(11)      NOT NULL,
    telefone          VARCHAR(20)   NOT NULL,
    email             VARCHAR(150)  NULL,
    cargo             VARCHAR(20)   NOT NULL,
    data_contratacao  DATE          NOT NULL,
    rua               VARCHAR(120)  NULL,
    numero            VARCHAR(10)   NULL,
    bairro            VARCHAR(80)   NULL,
    cidade            VARCHAR(80)   NULL,
    cep               CHAR(8)       NULL,
    CONSTRAINT pk_funcionario PRIMARY KEY (id_funcionario),
    CONSTRAINT uq_funcionario_cpf UNIQUE (cpf),
    CONSTRAINT ck_funcionario_cpf CHECK (cpf REGEXP '^[0-9]{11}$'),
    -- regra de domínio: só os quatro papéis descritos no domínio
    CONSTRAINT ck_funcionario_cargo
        CHECK (cargo IN ('proprietario', 'atendente', 'mecanico', 'financeiro'))
);

-- FORNECEDOR: empresas que vendem peças e materiais à oficina.
CREATE TABLE fornecedor (
    id_fornecedor  INT           NOT NULL AUTO_INCREMENT,
    razao_social   VARCHAR(150)  NOT NULL,
    cnpj           CHAR(14)      NOT NULL,
    email          VARCHAR(150)  NULL,
    rua            VARCHAR(120)  NULL,
    numero         VARCHAR(10)   NULL,
    bairro         VARCHAR(80)   NULL,
    cidade         VARCHAR(80)   NULL,
    cep            CHAR(8)       NULL,
    CONSTRAINT pk_fornecedor PRIMARY KEY (id_fornecedor),
    CONSTRAINT uq_fornecedor_cnpj UNIQUE (cnpj),
    CONSTRAINT ck_fornecedor_cnpj CHECK (cnpj REGEXP '^[0-9]{14}$')
);

-- SERVICO: catálogo de serviços oferecidos.
CREATE TABLE servico (
    id_servico        INT            NOT NULL AUTO_INCREMENT,
    nome              VARCHAR(100)   NOT NULL,
    descricao         TEXT           NULL,
    preco             DECIMAL(10,2)  NOT NULL,
    duracao_estimada  SMALLINT       NULL,   -- em minutos
    CONSTRAINT pk_servico PRIMARY KEY (id_servico),
    CONSTRAINT uq_servico_nome UNIQUE (nome),
    CONSTRAINT ck_servico_preco CHECK (preco >= 0),
    CONSTRAINT ck_servico_duracao CHECK (duracao_estimada IS NULL OR duracao_estimada > 0)
);

-- PECA: cadastro das peças. A quantidade em estoque NÃO fica aqui
-- (ajuste da normalização): ela está somente na tabela estoque.
CREATE TABLE peca (
    id_peca         INT            NOT NULL AUTO_INCREMENT,
    codigo          VARCHAR(30)    NOT NULL,
    nome            VARCHAR(100)   NOT NULL,
    descricao       TEXT           NULL,
    preco_unitario  DECIMAL(10,2)  NOT NULL,
    CONSTRAINT pk_peca PRIMARY KEY (id_peca),
    CONSTRAINT uq_peca_codigo UNIQUE (codigo),
    CONSTRAINT ck_peca_preco CHECK (preco_unitario >= 0)
);


-- ---------------------------------------------------------------------
-- 2) Tabelas de atributos multivalorados
-- ---------------------------------------------------------------------

-- TELEFONE_CLIENTE: um cliente pode ter vários telefones (multivalorado).
-- PK composta: o mesmo número não se repete para o mesmo cliente.
CREATE TABLE telefone_cliente (
    id_cliente  INT          NOT NULL,
    telefone    VARCHAR(20)  NOT NULL,
    tipo        VARCHAR(20)  NOT NULL,
    CONSTRAINT pk_telefone_cliente PRIMARY KEY (id_cliente, telefone),
    CONSTRAINT ck_telefone_cliente_tipo
        CHECK (tipo IN ('celular', 'residencial', 'comercial', 'recado')),
    -- CASCADE: o telefone só existe em função do cliente; se o cliente
    -- for excluído, seus telefones não têm mais sentido e saem junto.
    CONSTRAINT fk_telefone_cliente_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- TELEFONE_FORNECEDOR: um fornecedor pode ter vários telefones.
CREATE TABLE telefone_fornecedor (
    id_fornecedor  INT          NOT NULL,
    telefone       VARCHAR(20)  NOT NULL,
    tipo           VARCHAR(20)  NOT NULL,
    CONSTRAINT pk_telefone_fornecedor PRIMARY KEY (id_fornecedor, telefone),
    CONSTRAINT ck_telefone_fornecedor_tipo
        CHECK (tipo IN ('celular', 'comercial', 'whatsapp')),
    -- CASCADE: mesmo motivo do telefone_cliente, o telefone depende
    -- totalmente do fornecedor.
    CONSTRAINT fk_telefone_fornecedor_fornecedor FOREIGN KEY (id_fornecedor)
        REFERENCES fornecedor (id_fornecedor)
        ON DELETE CASCADE ON UPDATE CASCADE
);


-- ---------------------------------------------------------------------
-- 3) Tabelas com chave estrangeira
-- ---------------------------------------------------------------------

-- ESTOQUE: um registro por peça (relacionamento 1:1 com PECA).
-- A FK fica em estoque e recebe UNIQUE para garantir o 1:1.
-- "necessidade_reposicao" é derivado e NÃO é armazenado: é calculado
-- na consulta (quantidade_disponivel <= quantidade_minima).
CREATE TABLE estoque (
    id_estoque             INT  NOT NULL AUTO_INCREMENT,
    id_peca                INT  NOT NULL,
    quantidade_disponivel  INT  NOT NULL DEFAULT 0,
    quantidade_minima      INT  NOT NULL DEFAULT 0,
    CONSTRAINT pk_estoque PRIMARY KEY (id_estoque),
    CONSTRAINT uq_estoque_peca UNIQUE (id_peca),
    CONSTRAINT ck_estoque_qtd CHECK (quantidade_disponivel >= 0),
    CONSTRAINT ck_estoque_minimo CHECK (quantidade_minima >= 0),
    -- CASCADE: o registro de estoque não existe sem a peça. Na prática a
    -- exclusão de uma peça já usada em ordens é barrada pela FK de
    -- ordem_servico_peca (RESTRICT).
    CONSTRAINT fk_estoque_peca FOREIGN KEY (id_peca)
        REFERENCES peca (id_peca)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- FORNECEDOR_PECA: associativa do N:N "fornecedor fornece peça".
-- preco_custo e prazo_entrega_dias são atributos do relacionamento:
-- dependem do par (fornecedor, peça), não de um dos dois sozinho.
CREATE TABLE fornecedor_peca (
    id_fornecedor       INT            NOT NULL,
    id_peca             INT            NOT NULL,
    preco_custo         DECIMAL(10,2)  NOT NULL,
    prazo_entrega_dias  SMALLINT       NULL,
    CONSTRAINT pk_fornecedor_peca PRIMARY KEY (id_fornecedor, id_peca),
    CONSTRAINT ck_fornecedor_peca_custo CHECK (preco_custo >= 0),
    -- CASCADE: se o fornecedor sai do cadastro, a lista do que ele
    -- fornecia deixa de valer.
    CONSTRAINT fk_fornecedor_peca_fornecedor FOREIGN KEY (id_fornecedor)
        REFERENCES fornecedor (id_fornecedor)
        ON DELETE CASCADE ON UPDATE CASCADE,
    -- CASCADE: se a peça sai do cadastro, ninguém mais a fornece.
    CONSTRAINT fk_fornecedor_peca_peca FOREIGN KEY (id_peca)
        REFERENCES peca (id_peca)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- VEICULO: cada veículo tem exatamente um cliente responsável (1,1).
-- quilometragem = última quilometragem conhecida do veículo; a
-- quilometragem de cada visita fica em ordem_servico.km_entrada.
CREATE TABLE veiculo (
    id_veiculo      INT          NOT NULL AUTO_INCREMENT,
    placa           VARCHAR(10)  NOT NULL,
    marca           VARCHAR(50)  NOT NULL,
    modelo          VARCHAR(80)  NOT NULL,
    ano_fabricacao  SMALLINT     NOT NULL,
    cor             VARCHAR(30)  NULL,
    quilometragem   INT          NOT NULL,
    id_cliente      INT          NOT NULL,
    CONSTRAINT pk_veiculo PRIMARY KEY (id_veiculo),
    CONSTRAINT uq_veiculo_placa UNIQUE (placa),
    CONSTRAINT ck_veiculo_ano CHECK (ano_fabricacao BETWEEN 1950 AND 2100),
    CONSTRAINT ck_veiculo_km CHECK (quilometragem >= 0),
    -- RESTRICT: não se apaga um cliente que ainda tem veículos
    -- cadastrados; isso apagaria o histórico do carro na oficina.
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- AGENDAMENTO: guarda id_cliente E id_veiculo de propósito: quem marca
-- o horário pode não ser o dono do carro (ex.: cônjuge que leva o carro).
CREATE TABLE agendamento (
    id_agendamento  INT          NOT NULL AUTO_INCREMENT,
    id_cliente      INT          NOT NULL,
    id_veiculo      INT          NOT NULL,
    data_hora       DATETIME     NOT NULL,
    motivo          TEXT         NOT NULL,
    status          VARCHAR(20)  NOT NULL DEFAULT 'marcado',
    observacoes     TEXT         NULL,
    CONSTRAINT pk_agendamento PRIMARY KEY (id_agendamento),
    CONSTRAINT ck_agendamento_status
        CHECK (status IN ('marcado', 'confirmado', 'realizado', 'cancelado')),
    -- RESTRICT: o agendamento registra quem pediu o atendimento; o
    -- cliente não pode sumir enquanto houver agendamentos dele.
    CONSTRAINT fk_agendamento_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    -- RESTRICT: idem para o veículo que será atendido.
    CONSTRAINT fk_agendamento_veiculo FOREIGN KEY (id_veiculo)
        REFERENCES veiculo (id_veiculo)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ORDEM_SERVICO: cada atendimento. "valor_total" é derivado e NÃO é
-- armazenado (ajuste da normalização): é a soma de preco_cobrado dos
-- serviços + quantidade * preco_unitario_cobrado das peças.
CREATE TABLE ordem_servico (
    id_ordem           INT          NOT NULL AUTO_INCREMENT,
    id_veiculo         INT          NOT NULL,
    id_funcionario     INT          NOT NULL,
    data_abertura      DATETIME     NOT NULL,
    data_conclusao     DATETIME     NULL,
    problema_relatado  TEXT         NOT NULL,
    status             VARCHAR(20)  NOT NULL DEFAULT 'aberta',
    observacoes        TEXT         NULL,
    CONSTRAINT pk_ordem_servico PRIMARY KEY (id_ordem),
    CONSTRAINT ck_ordem_status
        CHECK (status IN ('aberta', 'em_andamento', 'concluida', 'cancelada')),
    -- regra de domínio com duas colunas: não se conclui antes de abrir
    CONSTRAINT ck_ordem_datas
        CHECK (data_conclusao IS NULL OR data_conclusao >= data_abertura),
    -- RESTRICT: a ordem é o histórico do veículo; o veículo com ordens
    -- não pode ser excluído.
    CONSTRAINT fk_ordem_veiculo FOREIGN KEY (id_veiculo)
        REFERENCES veiculo (id_veiculo)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    -- RESTRICT: o funcionário responsável precisa continuar identificado;
    -- quem sai da oficina não deve ser apagado do cadastro.
    CONSTRAINT fk_ordem_funcionario FOREIGN KEY (id_funcionario)
        REFERENCES funcionario (id_funcionario)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ORDEM_SERVICO_SERVICO: associativa do N:N "ordem inclui serviço".
-- preco_cobrado guarda o preço do dia do atendimento: se o preço do
-- catálogo mudar depois, a ordem antiga continua com o valor correto.
CREATE TABLE ordem_servico_servico (
    id_ordem       INT            NOT NULL,
    id_servico     INT            NOT NULL,
    preco_cobrado  DECIMAL(10,2)  NOT NULL,
    CONSTRAINT pk_ordem_servico_servico PRIMARY KEY (id_ordem, id_servico),
    CONSTRAINT ck_oss_preco CHECK (preco_cobrado >= 0),
    -- CASCADE: os itens fazem parte da ordem; sem a ordem, não existem.
    CONSTRAINT fk_oss_ordem FOREIGN KEY (id_ordem)
        REFERENCES ordem_servico (id_ordem)
        ON DELETE CASCADE ON UPDATE CASCADE,
    -- RESTRICT: um serviço já vendido não pode sair do catálogo, senão
    -- as ordens antigas perderiam a descrição do que foi feito.
    CONSTRAINT fk_oss_servico FOREIGN KEY (id_servico)
        REFERENCES servico (id_servico)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ORDEM_SERVICO_PECA: associativa do N:N "ordem utiliza peça".
CREATE TABLE ordem_servico_peca (
    id_ordem                INT            NOT NULL,
    id_peca                 INT            NOT NULL,
    quantidade              INT            NOT NULL,
    preco_unitario_cobrado  DECIMAL(10,2)  NOT NULL,
    CONSTRAINT pk_ordem_servico_peca PRIMARY KEY (id_ordem, id_peca),
    CONSTRAINT ck_osp_quantidade CHECK (quantidade > 0),
    CONSTRAINT ck_osp_preco CHECK (preco_unitario_cobrado >= 0),
    -- CASCADE: as peças lançadas fazem parte da ordem.
    CONSTRAINT fk_osp_ordem FOREIGN KEY (id_ordem)
        REFERENCES ordem_servico (id_ordem)
        ON DELETE CASCADE ON UPDATE CASCADE,
    -- RESTRICT: peça já usada em atendimento não pode ser apagada
    -- (evita a anomalia de exclusão descrita no relatório).
    CONSTRAINT fk_osp_peca FOREIGN KEY (id_peca)
        REFERENCES peca (id_peca)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- PAGAMENTO: cada linha é um pagamento efetivamente recebido. Pagamento
-- parcelado = várias linhas para a mesma ordem. "valor_pendente" e a
-- situação (pendente/parcial/pago) são derivados e calculados na consulta.
CREATE TABLE pagamento (
    id_pagamento     INT            NOT NULL AUTO_INCREMENT,
    id_ordem         INT            NOT NULL,
    data_pagamento   DATETIME       NOT NULL,
    valor_pago       DECIMAL(10,2)  NOT NULL,
    forma_pagamento  VARCHAR(30)    NOT NULL,
    observacoes      TEXT           NULL,
    CONSTRAINT pk_pagamento PRIMARY KEY (id_pagamento),
    CONSTRAINT ck_pagamento_valor CHECK (valor_pago > 0),
    CONSTRAINT ck_pagamento_forma
        CHECK (forma_pagamento IN ('dinheiro', 'pix', 'cartao_debito',
                                   'cartao_credito', 'boleto')),
    -- RESTRICT (política escolhida na Etapa 9): uma ordem com pagamento
    -- registrado não pode ser excluída, preservando o histórico financeiro.
    CONSTRAINT fk_pagamento_ordem FOREIGN KEY (id_ordem)
        REFERENCES ordem_servico (id_ordem)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- DESPESA: gastos da oficina. id_fornecedor é opcional (0,1): aluguel,
-- contas e salários não têm fornecedor cadastrado.
CREATE TABLE despesa (
    id_despesa     INT            NOT NULL AUTO_INCREMENT,
    descricao      VARCHAR(150)   NOT NULL,
    categoria      VARCHAR(50)    NOT NULL,
    data_despesa   DATE           NOT NULL,
    valor          DECIMAL(10,2)  NOT NULL,
    id_fornecedor  INT            NULL,
    status         VARCHAR(20)    NOT NULL DEFAULT 'pendente',
    observacoes    TEXT           NULL,
    CONSTRAINT pk_despesa PRIMARY KEY (id_despesa),
    CONSTRAINT ck_despesa_valor CHECK (valor > 0),
    CONSTRAINT ck_despesa_categoria
        CHECK (categoria IN ('pecas', 'aluguel', 'contas', 'salarios',
                             'impostos', 'outros')),
    CONSTRAINT ck_despesa_status CHECK (status IN ('pendente', 'paga')),
    -- SET NULL: a despesa continua valendo para o controle financeiro
    -- mesmo que o fornecedor seja removido; só perde a referência.
    -- Possível porque a FK é opcional.
    CONSTRAINT fk_despesa_fornecedor FOREIGN KEY (id_fornecedor)
        REFERENCES fornecedor (id_fornecedor)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- HISTORICO_MANUTENCAO: registro consolidado de cada manutenção do
-- veículo. Pode vir de uma ordem concluída (id_ordem preenchido, no
-- máximo um histórico por ordem -> UNIQUE) ou de uma manutenção antiga /
-- feita em outra oficina (id_ordem NULL).
CREATE TABLE historico_manutencao (
    id_historico      INT            NOT NULL AUTO_INCREMENT,
    id_veiculo        INT            NOT NULL,
    id_ordem          INT            NULL,
    data_servico      DATETIME       NOT NULL,
    descricao_reparo  TEXT           NOT NULL,
    quilometragem     INT            NOT NULL,
    custo_total       DECIMAL(10,2)  NOT NULL,
    observacoes       TEXT           NULL,
    CONSTRAINT pk_historico_manutencao PRIMARY KEY (id_historico),
    CONSTRAINT uq_historico_ordem UNIQUE (id_ordem),
    CONSTRAINT ck_historico_km CHECK (quilometragem >= 0),
    CONSTRAINT ck_historico_custo CHECK (custo_total >= 0),
    -- RESTRICT: o histórico é a "ficha" do veículo; enquanto existir
    -- histórico, o veículo não é excluído.
    CONSTRAINT fk_historico_veiculo FOREIGN KEY (id_veiculo)
        REFERENCES veiculo (id_veiculo)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    -- SET NULL: se a ordem de origem for excluída, o registro do reparo
    -- continua no histórico do veículo, só sem o vínculo. FK opcional.
    CONSTRAINT fk_historico_ordem FOREIGN KEY (id_ordem)
        REFERENCES ordem_servico (id_ordem)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- AVALIACAO: opinião do cliente sobre UM atendimento específico (ajuste
-- da Etapa 8: antes apontava só para o tipo de serviço). No máximo uma
-- avaliação por ordem (UNIQUE). O cliente é obtido por
-- ordem -> veículo -> cliente, por isso id_cliente não é repetido aqui.
CREATE TABLE avaliacao (
    id_avaliacao    INT       NOT NULL AUTO_INCREMENT,
    id_ordem        INT       NOT NULL,
    nota            TINYINT   NOT NULL,
    comentario      TEXT      NULL,
    data_avaliacao  DATETIME  NOT NULL,
    CONSTRAINT pk_avaliacao PRIMARY KEY (id_avaliacao),
    CONSTRAINT uq_avaliacao_ordem UNIQUE (id_ordem),
    -- regra de domínio: nota de 1 a 5
    CONSTRAINT ck_avaliacao_nota CHECK (nota BETWEEN 1 AND 5),
    -- CASCADE: a avaliação só faz sentido junto do atendimento avaliado.
    CONSTRAINT fk_avaliacao_ordem FOREIGN KEY (id_ordem)
        REFERENCES ordem_servico (id_ordem)
        ON DELETE CASCADE ON UPDATE CASCADE
);


-- ---------------------------------------------------------------------
-- 4) ALTER TABLE (Etapa 14)
-- ---------------------------------------------------------------------
-- Problema encontrado no teste do modelo lógico (Etapa 10): a
-- quilometragem estava só em VEICULO, mas ela muda a cada visita. Assim,
-- ao atualizar a km do carro, perdíamos a km de entrada das ordens
-- antigas (não dava para saber com quantos km o carro chegou em cada
-- atendimento). A km da visita depende da ORDEM, não do veículo.
-- Solução: nova coluna km_entrada em ordem_servico, com regra CHECK.
ALTER TABLE ordem_servico
    ADD COLUMN km_entrada INT NOT NULL AFTER data_conclusao,
    ADD CONSTRAINT ck_ordem_km_entrada CHECK (km_entrada >= 0);


-- ---------------------------------------------------------------------
-- Conferência (checkpoint da Etapa 12)
-- ---------------------------------------------------------------------
SHOW TABLES;
DESCRIBE ordem_servico;
