-- 19.1 erro no fn e no string agg
CREATE OR ALTER VIEW vw_perfil_completo AS
SELECT 
nome,
email,
titulo_perfil,
cidade,
COUNT(c.conexao_id) AS conexoes_aceitas,
COUNT(p.post_id) AS qtd_posts,
COUNT(ct.curtida_id) AS curtidas_recebidas,
STRING_AGG(CONVERT (NVARCHAR (MAX), habilidade_id), ';')
FROM usuarios AS u
JOIN usuario_habilidades AS uh ON uh.usuario_id = u.usuario_id
JOIN conexoes AS c ON c.usuario_origem = u.usuario_id
JOIN posts AS p ON p.usuario_id = u.usuario_id
JOIN curtidas AS ct ON ct.post_id = p.post_id
WHERE c.status = 'aceita'
GROUP BY u.nome, u.email, u.titulo_perfil, u.cidade

exec fn_score_perfil @usuario_id = usuario_id 
 

-- 19.2 OK
CREATE OR ALTER vw_vagas_completas AS
SELECT 
v.vaga_id,
titulo,
e.empresa_id,
s.setor_id,
v.cidade,
v.modalidade,
v.nivel,
CONCAT('R$', salario_min, ' - R$', salario_max) AS faixa_salarial,
DATEDIFF(day, MAX(v.data_publicacao), GETDATE()) AS dias_desde_ultima_publi,
COUNT(candidatura_id) AS total_candidaturas
FROM vagas AS v
JOIN empresas AS e ON e.empresa_id = v.empresa_id
JOIN setores AS s ON s.setor_id = e.empresa_id
LEFT JOIN candidaturas AS c ON v.vaga_id = c.vaga_id
GROUP BY v.vaga_id, v.titulo, e.empresa_id, s.setor_id, v.cidade, v.modalidade, v.nivel, v.salario_min, v.salario_max   

select * from vagas
select * from candidaturas

-- 19.3 como avaliar média de dias para preenchimento? taxa bugada
CREATE OR ALTER vw_empresa_dashboard AS
SELECT 
e.nome,
e.empresa_id,
s.nome, 
e.tamanho,
(SELECT STRING_AGG(CONVERT (NVARCHAR (MAX), v.vaga_id), ';')
 FROM empresas AS e2
 JOIN vagas AS v ON v.empresa_id = e2.empresa_id 
 WHERE v.ativa = 1 AND e.empresa_id = e2.empresa_id) AS vagas_ativas,
COUNT (candidatura_id) AS total_candidaturas,
CAST((CAST((SELECT COUNT(*) FROM candidaturas AS c
JOIN vagas AS v ON c.vaga_id = v.vaga_id
JOIN empresas AS e ON e.empresa_id = v.empresa_id
WHERE c.status = 'aceita') AS DECIMAL)/NULLIF((SELECT COUNT(*) FROM candidaturas), 0)) AS DECIMAL (10,2)) AS taxa_aprovacao
FROM empresas AS e
JOIN setores AS s ON s.setor_id = e.fk_setor_id
JOIN vagas AS v ON v.empresa_id = e.empresa_id
JOIN candidaturas c ON c.vaga_id = v.vaga_id
GROUP BY e.nome, e.empresa_id, s.nome, e.tamanho

-- 20.1 OK
CREATE TABLE habilidades_mercado (
	habilidade_id INT FOREIGN KEY REFERENCES habilidades(habilidade_id),
	nome VARCHAR(30),
	demanda_vagas INT DEFAULT 0
)

MERGE habilidades_mercado AS destino
USING (
	SELECT habilidade_id FROM vaga_habilidades
) AS origem ON (destino.habilidade_id = origem.habilidade_id)
WHEN NOT MATCHED BY TARGET THEN
	INSERT(habilidade_id) 
	VALUES(origem.habilidade_id);

-- 20.2 OK
SELECT * 
FROM (
SELECT e.nome, v.modalidade
FROM vagas AS v
JOIN empresas AS e ON e.empresa_id = v.empresa_id
) AS dados
PIVOT(
COUNT(modalidade)
FOR modalidade IN (Remoto, Presencial)
) AS pvt;

-- 20.3 OK
SELECT * 
FROM (
SELECT s.nome, c.status
FROM candidaturas AS c
JOIN vagas AS v ON v.vaga_id = c.vaga_id
JOIN empresas AS e ON e.empresa_id = v.empresa_id
JOIN setores AS s ON s.setor_id = e.fk_setor_id
) AS dados
PIVOT(
COUNT(status)
FOR status IN (aceita, em_revisão, reprovada)
) AS pvt;

-- 21.1 OK

-- ORIGINAL
SET STATISTICS IO ON;
SELECT * FROM vagas 
WHERE YEAR(data_publicacao) = 2024

-- OTIMIZADA
SET STATISTICS IO ON;
SELECT * FROM vagas
WHERE (data_publicacao <= '2024-12-31' AND data_publicacao >= '2024-01-01')

-- 21.2 OK

-- ORIGINAL
SET STATISTICS IO ON;
SELECT * FROM posts 
ORDER BY visualizacoes DESC 

-- OTIMIZADA
SET STATISTICS IO ON;
DECLARE @QtdPorPagina INT = 10,
        @Pagina       INT = 1;

SELECT * FROM posts 
WHERE ativo = 1
ORDER BY visualizacoes DESC 
OFFSET (@Pagina - 1) * @QtdPorPagina rows fetch next @QtdPorPagina rows only;

-- 21.3 OK

-- ORIGINAL
SET STATISTICS IO ON;
SELECT u.nome, 
(SELECT COUNT(*) FROM conexoes 
WHERE usuario_origem = u.usuario_id) 
FROM usuarios u

-- OTIMIZADA
SET STATISTICS IO ON;
SELECT u.nome,
COUNT(c.conexao_id) 
FROM conexoes AS c
JOIN usuarios AS u ON 
(u.usuario_id = c.usuario_origem AND u.usuario_id != c.usuario_destino) 
OR (u.usuario_id != c.usuario_origem AND u.usuario_id = c.usuario_destino)
GROUP BY u.nome

-- 21.4 OK (é feito nos outros)

-- 22.1
