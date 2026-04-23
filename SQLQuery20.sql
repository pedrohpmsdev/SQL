-- 17.1 OK
SELECT
usuario_id,
ROW_NUMBER() OVER(PARTITION BY usuario_id ORDER BY usuario_id) AS row#,
MAX(data_publicacao)  
FROM posts
GROUP BY usuario_id

SELECT * FROM posts

-- 17.3



-- 17.4
SELECT 
s.nome,  
(SELECT COUNT(*) FROM candidaturas) AS totalGeral,
(COUNT(vaga_id) OVER (PARTITION BY s.setor_id)) AS totalPorSetor,
CAST((CAST((COUNT(vaga_id) OVER (PARTITION BY s.setor_id)) AS DECIMAL)/(SELECT COUNT(*) FROM candidaturas)) AS DECIMAL (10,2)) AS percentual
FROM vagas AS v
JOIN empresas AS e ON e.empresa_id = v.empresa_id
JOIN setores AS s ON s.setor_id = e.fk_setor_id
GROUP BY s.nome, s.setor_id, v.vaga_id

SELECT s.nome FROM vagas as v
JOIN empresas AS e ON e.empresa_id = v.empresa_id
JOIN setores AS s ON s.setor_id = e.fk_setor_id

-- 17.5 OK
SELECT
CAST(data_candidatura AS DATE) AS data,
e.nome,
e.empresa_id,
COUNT(c.candidatura_id) OVER (PARTITION BY e.empresa_id ORDER BY CAST(data_candidatura AS DATE))
AS numeroCandidaturas
FROM candidaturas AS c 
JOIN vagas AS v ON v.vaga_id = c.vaga_id
JOIN empresas AS e ON e.empresa_id = v.empresa_id
GROUP BY CAST(data_candidatura AS DATE), e.empresa_id, e.nome, c.candidatura_id
ORDER BY data;

-- 18.1

 -- 18.2
WITH cte_conexoes_diretas AS (
SELECT COUNT(*) AS total1Grau, usuario_origem AS usuario_origemC1 FROM conexoes
GROUP BY usuario_origem
),
cte_conexoes_2grau AS (
SELECT 
DISTINCT COUNT(c2.conexao_id) AS total2Grau,
c1.usuario_origem AS usuario_origemC1_2,
c1.usuario_destino AS usuario_origemC2
FROM conexoes AS c1
JOIN conexoes AS c2 ON c1.usuario_destino = c2.usuario_origem
GROUP BY c1.usuario_origem, c1.usuario_destino
),
cte_premium AS (
	SELECT COUNT(*) AS quantidade FROM usuarios 
	WHERE premium = 1
)
SELECT 
total1Grau,
usuario_origemC1,
total2Grau,
usuario_origemC2,
quantidade
FROM cte_conexoes_diretas, cte_conexoes_2grau, cte_premium
GROUP BY total1Grau,
usuario_origemC1,
total2Grau,
usuario_origemC2,
quantidade

