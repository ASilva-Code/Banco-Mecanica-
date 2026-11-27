-- =====================================================================
-- Modelagem de Banco de Dados - Projeto Final
-- Script 03: consultas (Etapas 13 e 14)
--
-- Aluno : Alberto Mário
-- RGM   : 47813253
-- Turma : P2D
-- Tema  : Oficina Mecânica
--
-- Pré-requisito: ter executado 01_criacao.sql e 02_carga_dados.sql.
-- Acima de cada consulta está a pergunta de negócio que ela responde e
-- o resultado esperado com os dados da carga.
-- =====================================================================

USE oficina_mecanica;


-- =====================================================================
-- PARTE A - Consultas sobre uma única tabela (Etapa 13)
-- =====================================================================

-- A1 (AND / OR)
-- Pergunta: quais ordens abertas em novembro/2026 ainda não foram
-- concluídas (estão "aberta" ou "em_andamento")?
-- Esperado: ordens 5 e 6.
SELECT id_ordem, id_veiculo, data_abertura, status
  FROM ordem_servico
 WHERE (status = 'aberta' OR status = 'em_andamento')
   AND data_abertura >= '2026-11-01';

-- A2 (BETWEEN)
-- Pergunta: quais veículos foram fabricados entre 2018 e 2021?
-- Esperado: Polo 2018, Argo 2019, Onix 2020, Kwid 2021.
SELECT placa, marca, modelo, ano_fabricacao
  FROM veiculo
 WHERE ano_fabricacao BETWEEN 2018 AND 2021
 ORDER BY ano_fabricacao;

-- A3 (IN)
-- Pergunta: quais despesas são de aluguel ou de contas da oficina?
-- Esperado: despesas 2, 4 e 6.
SELECT id_despesa, descricao, categoria, valor, status
  FROM despesa
 WHERE categoria IN ('aluguel', 'contas')
 ORDER BY data_despesa;

-- A4 (LIKE)
-- Pergunta: quais peças do cadastro são do sistema de freio?
-- Esperado: pastilhas (3) e disco (4).
SELECT codigo, nome, preco_unitario
  FROM peca
 WHERE nome LIKE '%freio%';

-- A5 (IS NULL)
-- Pergunta: quais clientes não informaram e-mail ou endereço? (para a
-- atendente completar o cadastro na próxima visita)
-- Esperado: Carlos (sem e-mail) e Fernanda (sem endereço).
SELECT id_cliente, nome, email, rua
  FROM cliente
 WHERE email IS NULL
    OR rua IS NULL;

-- A6 (ORDER BY com LIMIT)
-- Pergunta: quais são os 3 serviços mais caros do catálogo?
-- Esperado: troca de embreagem, revisão dos freios, revisão do arrefecimento.
SELECT nome, preco
  FROM servico
 ORDER BY preco DESC
 LIMIT 3;

-- A7 (DISTINCT)
-- Pergunta: quais formas de pagamento os clientes já usaram?
-- Esperado: 4 formas distintas (pix, cartao_debito, cartao_credito, dinheiro).
SELECT DISTINCT forma_pagamento
  FROM pagamento
 ORDER BY forma_pagamento;

-- A8 (DISTINCT)
-- Pergunta: de quais marcas são os veículos cadastrados? (Volkswagen
-- aparece duas vezes na tabela, mas uma vez no resultado)
-- Esperado: 6 marcas.
SELECT DISTINCT marca
  FROM veiculo
 ORDER BY marca;


-- =====================================================================
-- PARTE B - Consultas com JOIN (Etapa 14)
-- =====================================================================

-- B1 (JOIN com 4 tabelas)
-- Pergunta: que nota cada cliente deu, para qual veículo e em qual
-- atendimento? (avaliacao -> ordem_servico -> veiculo -> cliente)
-- Esperado: 5 linhas, uma por avaliação.
SELECT c.nome           AS cliente,
       v.placa,
       v.modelo,
       o.id_ordem,
       a.nota,
       a.comentario
  FROM avaliacao a
  JOIN ordem_servico o ON o.id_ordem   = a.id_ordem
  JOIN veiculo v       ON v.id_veiculo = o.id_veiculo
  JOIN cliente c       ON c.id_cliente = v.id_cliente
 ORDER BY a.nota DESC, c.nome;

-- B2 (LEFT JOIN com IS NULL)
-- Pergunta: quais clientes estão cadastrados mas ainda não têm nenhum
-- veículo? (cliente "pai" sem "filhos")
-- Esperado: Beatriz Santos Moura.
SELECT c.id_cliente, c.nome, c.data_cadastro
  FROM cliente c
  LEFT JOIN veiculo v ON v.id_cliente = c.id_cliente
 WHERE v.id_veiculo IS NULL;

-- B3 (LEFT JOIN com IS NULL)
-- Pergunta: quais serviços do catálogo nunca foram vendidos?
-- Esperado: Higienização do ar-condicionado.
SELECT s.id_servico, s.nome, s.preco
  FROM servico s
  LEFT JOIN ordem_servico_servico oss ON oss.id_servico = s.id_servico
 WHERE oss.id_ordem IS NULL;

-- B4 (JOIN com WHERE e ORDER BY)
-- Pergunta: quais veículos estão na oficina agora (ordem não concluída),
-- com o mecânico responsável, da ordem mais antiga para a mais nova?
-- Esperado: ordem 5 (Corolla, Marcos) e ordem 6 (Kwid, Diego).
SELECT o.id_ordem,
       o.data_abertura,
       v.placa,
       v.modelo,
       f.nome  AS mecanico,
       o.status,
       o.problema_relatado
  FROM ordem_servico o
  JOIN veiculo v     ON v.id_veiculo     = o.id_veiculo
  JOIN funcionario f ON f.id_funcionario = o.id_funcionario
 WHERE o.status IN ('aberta', 'em_andamento')
 ORDER BY o.data_abertura;


-- =====================================================================
-- PARTE C - Consultas com agregação (Etapa 14)
-- =====================================================================

-- C1 (agregação sem GROUP BY)
-- Pergunta: quantos pagamentos a oficina recebeu, quanto entrou no total
-- e qual o maior e o menor pagamento?
-- Esperado: 7 pagamentos, total R$ 2.526,50, maior 666,50, menor 50,00.
SELECT COUNT(*)         AS qtd_pagamentos,
       SUM(valor_pago)  AS total_recebido,
       MAX(valor_pago)  AS maior_pagamento,
       MIN(valor_pago)  AS menor_pagamento
  FROM pagamento;

-- C2 (agregação sem GROUP BY)
-- Pergunta: qual a nota média dos atendimentos avaliados?
-- Esperado: 4,40 (5 avaliações).
SELECT COUNT(*)            AS qtd_avaliacoes,
       ROUND(AVG(nota), 2) AS nota_media
  FROM avaliacao;

-- C3 (GROUP BY)
-- Pergunta: quanto a oficina gastou em cada categoria de despesa?
-- Esperado: aluguel 7000,00; pecas 3010,00; contas 612,35.
SELECT categoria,
       COUNT(*)   AS qtd_despesas,
       SUM(valor) AS total_gasto
  FROM despesa
 GROUP BY categoria
 ORDER BY total_gasto DESC;

-- C4 (JOIN + GROUP BY + HAVING)
-- Pergunta: quais clientes já pagaram mais de R$ 500,00 à oficina?
-- (cliente -> veiculo -> ordem_servico -> pagamento)
-- Esperado: Carlos (1460,00) e João (866,50).
SELECT c.id_cliente,
       c.nome,
       COUNT(p.id_pagamento) AS qtd_pagamentos,
       SUM(p.valor_pago)     AS total_pago
  FROM cliente c
  JOIN veiculo v       ON v.id_cliente = c.id_cliente
  JOIN ordem_servico o ON o.id_veiculo = v.id_veiculo
  JOIN pagamento p     ON p.id_ordem   = o.id_ordem
 GROUP BY c.id_cliente, c.nome
HAVING SUM(p.valor_pago) > 500
 ORDER BY total_pago DESC;

-- C5 (JOIN + GROUP BY + HAVING)
-- Pergunta: quais mecânicos já foram responsáveis por mais de 3 ordens
-- e qual o valor médio de mão de obra das ordens deles?
-- Esperado: Marcos e Diego, com 4 ordens cada. Paulo (sem ordens) não aparece.
SELECT f.nome                              AS mecanico,
       COUNT(DISTINCT o.id_ordem)          AS qtd_ordens,
       ROUND(SUM(oss.preco_cobrado) / COUNT(DISTINCT o.id_ordem), 2) AS mao_de_obra_media
  FROM funcionario f
  JOIN ordem_servico o           ON o.id_funcionario = f.id_funcionario
  JOIN ordem_servico_servico oss ON oss.id_ordem     = o.id_ordem
 WHERE f.cargo = 'mecanico'
 GROUP BY f.id_funcionario, f.nome
HAVING COUNT(DISTINCT o.id_ordem) > 3;


-- =====================================================================
-- PARTE D - Atributos derivados calculados na consulta
-- (decisão da normalização: valor_total, valor_pendente e
--  necessidade_reposicao não são armazenados, são calculados aqui)
-- =====================================================================

-- D1
-- Pergunta: qual o valor total de cada ordem, quanto já foi pago e
-- quanto ainda falta receber?
-- Os serviços e as peças são somados em subconsultas separadas para não
-- multiplicar linhas no JOIN.
-- Esperado: pendências nas ordens 4 (126,60), 5 (170,00), 6 (219,80) e 8 (150,00).
SELECT o.id_ordem,
       v.placa,
       o.status,
       COALESCE(s.total_servicos, 0) + COALESCE(pc.total_pecas, 0)  AS valor_total,
       COALESCE(pg.total_pago, 0)                                   AS valor_pago,
       COALESCE(s.total_servicos, 0) + COALESCE(pc.total_pecas, 0)
         - COALESCE(pg.total_pago, 0)                               AS valor_pendente
  FROM ordem_servico o
  JOIN veiculo v ON v.id_veiculo = o.id_veiculo
  LEFT JOIN (SELECT id_ordem, SUM(preco_cobrado) AS total_servicos
               FROM ordem_servico_servico
              GROUP BY id_ordem) s  ON s.id_ordem  = o.id_ordem
  LEFT JOIN (SELECT id_ordem, SUM(quantidade * preco_unitario_cobrado) AS total_pecas
               FROM ordem_servico_peca
              GROUP BY id_ordem) pc ON pc.id_ordem = o.id_ordem
  LEFT JOIN (SELECT id_ordem, SUM(valor_pago) AS total_pago
               FROM pagamento
              GROUP BY id_ordem) pg ON pg.id_ordem = o.id_ordem
 ORDER BY o.id_ordem;

-- D2
-- Pergunta: quais peças precisam de reposição e de quem posso comprar,
-- do fornecedor mais barato para o mais caro?
-- Esperado: pastilhas (2 fornecedores) e kit de embreagem (1 fornecedor).
SELECT p.codigo,
       p.nome,
       e.quantidade_disponivel,
       e.quantidade_minima,
       f.razao_social AS fornecedor,
       fp.preco_custo
  FROM estoque e
  JOIN peca p                 ON p.id_peca        = e.id_peca
  LEFT JOIN fornecedor_peca fp ON fp.id_peca      = p.id_peca
  LEFT JOIN fornecedor f       ON f.id_fornecedor = fp.id_fornecedor
 WHERE e.quantidade_disponivel <= e.quantidade_minima
 ORDER BY p.nome, fp.preco_custo;
