-- =====================================================================
-- Modelagem de Banco de Dados - Projeto Final
-- Script 02: carga de dados (Etapa 13)
--
-- Aluno : Alberto Mário
-- RGM   : 47813253
-- Turma : P2D
-- Tema  : Oficina Mecânica
--
-- Pré-requisito: ter executado 01_criacao.sql.
-- Ordem dos INSERT: primeiro as tabelas referenciadas.
-- Os dados contam a história da oficina entre set/2026 e nov/2026.
-- =====================================================================

USE oficina_mecanica;


-- ---------------------------------------------------------------------
-- CLIENTE (6 linhas)
-- Casos de teste:
--   * Carlos (3) não informou e-mail            -> campo opcional NULL
--   * Fernanda (4) não informou endereço         -> vários NULL
--   * João (1) tem 2 veículos                    -> "pai" com 2+ filhos
--   * Beatriz (6) acabou de se cadastrar e ainda
--     não tem veículo                            -> "pai" sem filhos
-- ---------------------------------------------------------------------
INSERT INTO cliente (id_cliente, nome, cpf, email, rua, numero, bairro, cidade, cep, data_cadastro) VALUES
(1, 'João Pedro Almeida',     '12345678901', 'joao.almeida@email.com',    'Rua das Acácias',          '120',  'Jardim Paulista',  'São Paulo',             '01452000', '2026-03-10 09:15:00'),
(2, 'Mariana Costa Ribeiro',  '23456789012', 'mariana.ribeiro@email.com', 'Avenida Brasil',           '455',  'Centro',           'Santo André',           '09010000', '2026-04-22 14:02:00'),
(3, 'Carlos Eduardo Souza',   '34567890123', NULL,                        'Rua Sete de Setembro',     '88',   'Vila Nova',        'São Bernardo do Campo', '09720000', '2026-05-05 08:40:00'),
(4, 'Fernanda Lima Oliveira', '45678901234', 'fernanda.lima@email.com',   NULL,                       NULL,   NULL,               NULL,                    NULL,       '2026-06-18 16:25:00'),
(5, 'Ricardo Nunes Pereira',  '56789012345', 'ricardo.nunes@email.com',   'Rua Augusta',              '1500', 'Consolação',       'São Paulo',             '01304001', '2026-08-30 11:10:00'),
(6, 'Beatriz Santos Moura',   '67890123456', 'beatriz.moura@email.com',   'Rua Vergueiro',            '300',  'Liberdade',        'São Paulo',             '01504000', '2026-11-20 10:05:00');

-- TELEFONE_CLIENTE (8 linhas) - atributo multivalorado
INSERT INTO telefone_cliente (id_cliente, telefone, tipo) VALUES
(1, '11987654321', 'celular'),
(1, '1133334444',  'residencial'),
(2, '11976543210', 'celular'),
(3, '11965432109', 'celular'),
(3, '1144445555',  'comercial'),
(4, '11954321098', 'celular'),
(5, '11943210987', 'celular'),
(6, '11932109876', 'celular');

-- ---------------------------------------------------------------------
-- FUNCIONARIO (6 linhas)
-- Paulo (6) foi contratado agora e ainda não tem ordens.
-- ---------------------------------------------------------------------
INSERT INTO funcionario (id_funcionario, nome, cpf, telefone, email, cargo, data_contratacao, rua, numero, bairro, cidade, cep) VALUES
(1, 'Roberto Silva Mendes',  '11122233344', '11991112222', 'roberto@oficinamendes.com.br', 'proprietario', '2015-02-01', 'Rua Domingos de Morais', '2100', 'Vila Mariana', 'São Paulo', '04036000'),
(2, 'Ana Paula Ferreira',    '22233344455', '11992223333', 'ana@oficinamendes.com.br',     'atendente',    '2021-06-14', 'Rua Cubatão',            '512',  'Paraíso',      'São Paulo', '04013001'),
(3, 'Marcos Vinícius Rocha', '33344455566', '11993334444', 'marcos@oficinamendes.com.br',  'mecanico',     '2018-09-03', 'Rua Loefgren',           '77',   'Vila Clementino', 'São Paulo', '04040000'),
(4, 'Diego Henrique Lopes',  '44455566677', '11994445555', NULL,                           'mecanico',     '2023-01-16', NULL,                     NULL,   NULL,           NULL,        NULL),
(5, 'Juliana Prado Martins', '55566677788', '11995556666', 'juliana@oficinamendes.com.br', 'financeiro',   '2022-04-04', 'Rua Tutóia',             '345',  'Vila Mariana', 'São Paulo', '04007005'),
(6, 'Paulo Sérgio Andrade',  '66677788899', '11996667777', NULL,                           'mecanico',     '2026-11-03', 'Rua Abílio Soares',      '90',   'Paraíso',      'São Paulo', '04005000');

-- ---------------------------------------------------------------------
-- FORNECEDOR (5 linhas)
-- Pneus Bom Caminho (5) ainda não forneceu nenhuma peça cadastrada.
-- ---------------------------------------------------------------------
INSERT INTO fornecedor (id_fornecedor, razao_social, cnpj, email, rua, numero, bairro, cidade, cep) VALUES
(1, 'Auto Peças Paulista Ltda',               '12345678000190', 'vendas@autopecaspaulista.com.br', 'Avenida do Estado', '4500', 'Cambuci',  'São Paulo',   '01516000'),
(2, 'Lubrificantes Rio Branco Ltda',          '23456789000101', 'pedidos@lubriobranco.com.br',     'Rua Rio Branco',    '210',  'Centro',   'Santo André', '09015000'),
(3, 'Freios & Cia Comércio de Autopeças Ltda','34567890000112', 'contato@freiosecia.com.br',       'Avenida Kennedy',   '1020', 'Jardim do Mar', 'São Bernardo do Campo', '09726000'),
(4, 'Elétrica Automotiva Faísca ME',          '45678901000123', NULL,                              'Rua do Gasômetro',  '75',   'Brás',     'São Paulo',   '03004000'),
(5, 'Pneus Bom Caminho Ltda',                 '56789012000134', 'comercial@bomcaminho.com.br',     NULL,                NULL,   NULL,       NULL,          NULL);

-- TELEFONE_FORNECEDOR (6 linhas) - atributo multivalorado
INSERT INTO telefone_fornecedor (id_fornecedor, telefone, tipo) VALUES
(1, '1132710000',  'comercial'),
(1, '11981230000', 'whatsapp'),
(2, '1144330000',  'comercial'),
(3, '1143350000',  'comercial'),
(4, '11972340000', 'celular'),
(5, '1133440000',  'comercial');

-- ---------------------------------------------------------------------
-- SERVICO (7 linhas)
-- A higienização do ar-condicionado (7) nunca foi vendida: será
-- encontrada pela consulta com LEFT JOIN ... IS NULL.
-- ---------------------------------------------------------------------
INSERT INTO servico (id_servico, nome, descricao, preco, duracao_estimada) VALUES
(1, 'Troca de óleo e filtro',              'Drenagem do óleo usado, troca do filtro e reabastecimento.', 120.00,  40),
(2, 'Revisão dos freios',                  'Inspeção de pastilhas, discos e fluido; substituição se necessário.', 180.00, 90),
(3, 'Alinhamento e balanceamento',         'Alinhamento da direção e balanceamento das quatro rodas.', 150.00, 60),
(4, 'Diagnóstico eletrônico',              NULL,                                                        100.00,  30),
(5, 'Troca de embreagem',                  'Substituição do kit de embreagem (platô, disco e rolamento).', 450.00, 240),
(6, 'Revisão do sistema de arrefecimento', 'Verificação de radiador, mangueiras, válvula termostática e aditivo.', 160.00, NULL),
(7, 'Higienização do ar-condicionado',     'Limpeza do evaporador e troca do filtro de cabine.',          130.00,  50);

-- PECA (8 linhas)
INSERT INTO peca (id_peca, codigo, nome, descricao, preco_unitario) VALUES
(1, 'OLE-5W30-1L',   'Óleo de motor 5W30 sintético 1L', 'Óleo sintético API SP.',            42.90),
(2, 'FIL-OLEO-01',   'Filtro de óleo',                  NULL,                                35.00),
(3, 'PAS-FREIO-D01', 'Jogo de pastilhas de freio dianteiro', 'Jogo com 4 pastilhas.',        159.90),
(4, 'DIS-FREIO-D01', 'Disco de freio dianteiro (par)',  NULL,                               289.00),
(5, 'KIT-EMB-01',    'Kit de embreagem',                'Platô, disco e rolamento.',        690.00),
(6, 'VEL-IGN-04',    'Jogo de velas de ignição (4)',    NULL,                               120.00),
(7, 'ADT-RAD-1L',    'Aditivo para radiador 1L',        'Concentrado, cor rosa.',            29.90),
(8, 'PAL-LIMP-01',   'Palheta do limpador (par)',       NULL,                                45.00);

-- ESTOQUE (8 linhas: um registro por peça)
-- Pastilhas (3) e kit de embreagem (5) estão abaixo do mínimo.
INSERT INTO estoque (id_estoque, id_peca, quantidade_disponivel, quantidade_minima) VALUES
(1, 1, 36, 12),
(2, 2, 10,  5),
(3, 3,  3,  4),
(4, 4,  4,  2),
(5, 5,  1,  2),
(6, 6,  6,  3),
(7, 7, 14,  6),
(8, 8,  8,  4);

-- FORNECEDOR_PECA (9 linhas) - associativa do N:N
-- A pastilha (3) e o disco (4) têm dois fornecedores cada.
INSERT INTO fornecedor_peca (id_fornecedor, id_peca, preco_custo, prazo_entrega_dias) VALUES
(1, 2,  18.00, 2),
(1, 3,  98.00, 3),
(1, 4, 175.00, 3),
(1, 5, 560.00, 5),
(2, 1,  23.50, 1),
(2, 7,  14.90, 1),
(3, 3,  92.00, NULL),
(3, 4, 168.00, NULL),
(4, 6,  60.00, 4);

-- ---------------------------------------------------------------------
-- VEICULO (7 linhas)
-- João (1) tem 2 veículos e Carlos (3) também. Beatriz (6) não tem nenhum.
-- O Corolla (5) está sem cor informada (NULL).
-- ---------------------------------------------------------------------
INSERT INTO veiculo (id_veiculo, placa, marca, modelo, ano_fabricacao, cor, quilometragem, id_cliente) VALUES
(1, 'ABC1D23', 'Volkswagen', 'Gol',     2015, 'Prata',    99800, 1),
(2, 'BRA2E19', 'Chevrolet',  'Onix',    2020, 'Branco',   45000, 1),
(3, 'FGH3I45', 'Fiat',       'Argo',    2019, 'Vermelho', 60500, 2),
(4, 'JKL4M56', 'Honda',      'Civic',   2017, 'Preto',    87000, 3),
(5, 'MNO5P67', 'Toyota',     'Corolla', 2022, NULL,       30500, 4),
(6, 'QRS6T78', 'Renault',    'Kwid',    2021, 'Branco',   38900, 5),
(7, 'TUV7W89', 'Volkswagen', 'Polo',    2018, 'Cinza',    72300, 3);

-- ---------------------------------------------------------------------
-- AGENDAMENTO (7 linhas)
-- O agendamento 6 foi feito por Fernanda (4) para o Civic do Carlos (3):
-- é o motivo de a tabela guardar cliente e veículo separadamente.
-- O agendamento 7 foi cancelado e será removido no DELETE abaixo.
-- ---------------------------------------------------------------------
INSERT INTO agendamento (id_agendamento, id_cliente, id_veiculo, data_hora, motivo, status, observacoes) VALUES
(1, 1, 1, '2026-09-02 08:30:00', 'Troca de óleo e barulho ao frear',          'realizado',  NULL),
(2, 2, 3, '2026-09-15 09:00:00', 'Volante puxando para a direita',            'realizado',  NULL),
(3, 4, 5, '2026-11-18 10:00:00', 'Luz da injeção acesa no painel',            'realizado',  'Cliente vai aguardar na oficina.'),
(4, 5, 6, '2026-11-25 08:30:00', 'Motor esquentando em subidas',              'realizado',  NULL),
(5, 1, 2, '2026-12-02 09:00:00', 'Revisão do ar-condicionado',                'confirmado', NULL),
(6, 4, 4, '2026-12-04 14:00:00', 'Revisão de rotina',                         'marcado',    'Fernanda é esposa do Carlos e levará o carro.'),
(7, 2, 3, '2026-11-28 10:00:00', 'Troca das palhetas do limpador',            'cancelado',  'Cliente viajou e pediu para cancelar.');

-- ---------------------------------------------------------------------
-- ORDEM_SERVICO (8 linhas)
-- Ordens 5 e 6 ainda não foram concluídas: data_conclusao NULL.
-- Marcos (3) e Diego (4) têm várias ordens; Paulo (6) nenhuma.
-- ---------------------------------------------------------------------
INSERT INTO ordem_servico (id_ordem, id_veiculo, id_funcionario, data_abertura, data_conclusao, km_entrada, problema_relatado, status, observacoes) VALUES
(1, 1, 3, '2026-09-02 08:30:00', '2026-09-02 11:00:00', 98100, 'Barulho ao frear e óleo com troca vencida.',   'concluida',    NULL),
(2, 3, 4, '2026-09-15 09:00:00', '2026-09-15 10:30:00', 60500, 'Volante puxando para a direita.',              'concluida',    NULL),
(3, 4, 3, '2026-10-05 08:00:00', '2026-10-07 17:00:00', 87000, 'Embreagem patinando nas trocas de marcha.',    'concluida',    'Peça chegou do fornecedor no dia 06/10.'),
(4, 2, 4, '2026-10-20 14:00:00', '2026-10-20 15:00:00', 45000, 'Revisão dos 45 mil km.',                       'concluida',    NULL),
(5, 5, 3, '2026-11-18 10:00:00', NULL,                  30500, 'Luz da injeção eletrônica acesa no painel.',   'em_andamento', 'Aguardando teste de rodagem.'),
(6, 6, 4, '2026-11-25 08:45:00', NULL,                  38900, 'Motor esquentando em subidas.',                'aberta',       NULL),
(7, 7, 4, '2026-11-10 09:00:00', '2026-11-10 10:30:00', 72300, 'Carro falhando na partida pela manhã.',        'concluida',    NULL),
(8, 1, 3, '2026-11-21 08:00:00', '2026-11-21 09:30:00', 99800, 'Alinhamento após troca de pneus.',             'concluida',    NULL);

-- ORDEM_SERVICO_SERVICO (10 linhas) - associativa do N:N
-- A ordem 1 tem dois serviços; o serviço 1 aparece em duas ordens.
INSERT INTO ordem_servico_servico (id_ordem, id_servico, preco_cobrado) VALUES
(1, 1, 120.00),
(1, 2, 180.00),
(2, 3, 150.00),
(3, 4, 100.00),
(3, 5, 450.00),
(4, 1, 120.00),
(5, 4, 100.00),
(6, 6, 160.00),
(7, 4, 100.00),
(8, 3, 150.00);

-- ORDEM_SERVICO_PECA (9 linhas) - associativa do N:N
INSERT INTO ordem_servico_peca (id_ordem, id_peca, quantidade, preco_unitario_cobrado) VALUES
(1, 1, 4,  42.90),
(1, 2, 1,  35.00),
(1, 3, 1, 159.90),
(3, 5, 1, 690.00),
(4, 1, 4,  42.90),
(4, 2, 1,  35.00),
(5, 6, 1, 120.00),
(6, 7, 2,  29.90),
(7, 6, 1, 120.00);

-- ---------------------------------------------------------------------
-- PAGAMENTO (7 linhas)
-- Valores totais das ordens (calculados a partir dos itens):
--   O1 = 666,50  O2 = 150,00  O3 = 1240,00  O4 = 326,60
--   O5 = 220,00  O6 = 219,80  O7 = 220,00   O8 = 150,00
-- A ordem 3 foi paga em 2 parcelas (pai com 2 filhos).
-- A ordem 4 e a 5 estão parcialmente pagas; a 6 e a 8 sem pagamento.
-- ---------------------------------------------------------------------
INSERT INTO pagamento (id_pagamento, id_ordem, data_pagamento, valor_pago, forma_pagamento, observacoes) VALUES
(1, 1, '2026-09-02 11:10:00', 666.50, 'pix',            NULL),
(2, 2, '2026-09-15 10:40:00', 150.00, 'cartao_debito',  NULL),
(3, 3, '2026-10-07 17:20:00', 620.00, 'cartao_credito', '1ª parcela; restante combinado para novembro.'),
(4, 3, '2026-11-07 10:00:00', 620.00, 'pix',            '2ª parcela; ordem quitada.'),
(5, 4, '2026-10-20 15:10:00', 200.00, 'dinheiro',       'Cliente pagará o restante na próxima visita.'),
(6, 5, '2026-11-18 10:30:00',  50.00, 'pix',            'Sinal para iniciar o diagnóstico.'),
(7, 7, '2026-11-10 10:40:00', 220.00, 'cartao_credito', NULL);

-- ---------------------------------------------------------------------
-- DESPESA (7 linhas)
-- Despesas de aluguel e contas não têm fornecedor: id_fornecedor NULL.
-- ---------------------------------------------------------------------
INSERT INTO despesa (id_despesa, descricao, categoria, data_despesa, valor, id_fornecedor, status, observacoes) VALUES
(1, 'Compra de óleos e aditivos',            'pecas',   '2026-09-01',  850.00, 2,    'paga',     NULL),
(2, 'Aluguel do galpão - setembro',          'aluguel', '2026-09-05', 3500.00, NULL, 'paga',     NULL),
(3, 'Kit de embreagem para o Civic (OS 3)',  'pecas',   '2026-10-03',  560.00, 1,    'paga',     'Compra feita sob encomenda.'),
(4, 'Conta de energia elétrica - outubro',   'contas',  '2026-10-10',  612.35, NULL, 'paga',     NULL),
(5, 'Pastilhas e discos de freio',           'pecas',   '2026-10-15', 1240.00, 3,    'paga',     NULL),
(6, 'Aluguel do galpão - novembro',          'aluguel', '2026-11-05', 3500.00, NULL, 'pendente', 'Vence dia 10.'),
(7, 'Velas de ignição',                      'pecas',   '2026-11-12',  360.00, 4,    'pendente', NULL);

-- ---------------------------------------------------------------------
-- HISTORICO_MANUTENCAO (8 linhas)
-- 6 registros vêm de ordens concluídas; 2 são manutenções antigas ou de
-- outra oficina, sem ordem no sistema (id_ordem NULL).
-- ---------------------------------------------------------------------
INSERT INTO historico_manutencao (id_historico, id_veiculo, id_ordem, data_servico, descricao_reparo, quilometragem, custo_total, observacoes) VALUES
(1, 1, NULL, '2025-11-12 10:00:00', 'Troca da correia dentada.',                               82000, 780.00, 'Registro transcrito da caderneta de revisões do cliente.'),
(2, 7, NULL, '2026-05-20 15:00:00', 'Troca da bateria em outra oficina.',                       68000, 520.00, NULL),
(3, 1, 1,    '2026-09-02 11:00:00', 'Troca de óleo e filtro; troca das pastilhas dianteiras.', 98100, 666.50, NULL),
(4, 3, 2,    '2026-09-15 10:30:00', 'Alinhamento e balanceamento.',                            60500, 150.00, NULL),
(5, 4, 3,    '2026-10-07 17:00:00', 'Troca do kit de embreagem após diagnóstico.',             87000, 1240.00, NULL),
(6, 2, 4,    '2026-10-20 15:00:00', 'Revisão dos 45 mil km com troca de óleo e filtro.',       45000, 326.60, NULL),
(7, 7, 7,    '2026-11-10 10:30:00', 'Diagnóstico e troca das velas de ignição.',               72300, 220.00, NULL),
(8, 1, 8,    '2026-11-21 09:30:00', 'Alinhamento e balanceamento após troca de pneus.',        99800, 150.00, NULL);

-- ---------------------------------------------------------------------
-- AVALIACAO (5 linhas) - uma por ordem concluída e avaliada
-- A avaliação 3 tem só a nota (comentario NULL).
-- A ordem 8 ainda não foi avaliada.
-- ---------------------------------------------------------------------
INSERT INTO avaliacao (id_avaliacao, id_ordem, nota, comentario, data_avaliacao) VALUES
(1, 1, 5, 'Atendimento rápido e explicaram tudo o que foi trocado.', '2026-09-03 19:20:00'),
(2, 2, 4, 'Resolveu o problema, mas atrasou meia hora.',             '2026-09-16 08:05:00'),
(3, 3, 5, NULL,                                                      '2026-10-08 12:47:00'),
(4, 4, 3, 'Preço justo, mas esperei bastante na recepção.',          '2026-10-21 09:30:00'),
(5, 7, 5, 'O carro voltou a pegar de primeira.',                     '2026-11-11 18:12:00');


-- =====================================================================
-- UPDATE com a rotina de três passos (SELECT -> UPDATE -> SELECT)
-- Situação: João (cliente 1) trocou de e-mail. Como o e-mail está só na
-- tabela cliente, basta alterar UMA linha (é justamente a anomalia de
-- atualização que a normalização evitou).
-- =====================================================================
SELECT id_cliente, nome, email FROM cliente WHERE id_cliente = 1;

UPDATE cliente
   SET email = 'joaopedro.almeida@email.com'
 WHERE id_cliente = 1;

SELECT id_cliente, nome, email FROM cliente WHERE id_cliente = 1;


-- =====================================================================
-- DELETE com a rotina de três passos (SELECT -> DELETE -> SELECT)
-- Situação: o agendamento 7 foi cancelado e não precisa mais ser guardado.
-- Nenhuma tabela referencia agendamento, então a exclusão é segura.
-- =====================================================================
SELECT id_agendamento, id_cliente, data_hora, status FROM agendamento WHERE id_agendamento = 7;

DELETE FROM agendamento
 WHERE id_agendamento = 7;

SELECT id_agendamento, id_cliente, data_hora, status FROM agendamento WHERE id_agendamento = 7;
-- (resultado esperado: nenhuma linha)


-- =====================================================================
-- Experimentos que o MySQL DEVE RECUSAR
-- Ficam comentados para o script rodar inteiro sem erro. Para testar,
-- tire o "-- " da linha do comando e execute só ela.
-- =====================================================================

-- Experimento 1: INSERT com chave estrangeira inexistente.
-- Não existe cliente com id 999, então o veículo não pode apontar para ele.
-- Deve falhar com o erro 1452
-- (Cannot add or update a child row: a foreign key constraint fails).
-- INSERT INTO veiculo (placa, marca, modelo, ano_fabricacao, cor, quilometragem, id_cliente) VALUES ('ZZZ9Z99', 'Fiat', 'Uno', 2010, 'Azul', 150000, 999);

-- Experimento 2: DELETE bloqueado por RESTRICT.
-- A ordem 3 tem dois pagamentos e fk_pagamento_ordem usa ON DELETE RESTRICT.
-- Deve falhar com o erro 1451
-- (Cannot delete or update a parent row: a foreign key constraint fails).
-- DELETE FROM ordem_servico WHERE id_ordem = 3;
