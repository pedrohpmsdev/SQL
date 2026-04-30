-- 23.1 (1,2,3,4,5,6) OK
WITH cte_users_tdy_vs_lw AS (
	SELECT TOP(1)
	CAST(CAST((SELECT COUNT(*) FROM usuarios
	WHERE data_cadastro <= GETDATE() AND ativo = 1) AS DECIMAL (10,2))/
	NULLIF((SELECT COUNT(*) FROM usuarios
	WHERE DATEDIFF(day, data_cadastro, GETDATE()) >= 7 AND 
	ativo = 1), 0) AS DECIMAL (10,2)) * 100 AS porcentagem
	FROM usuarios
  ),
cte_vacancy_tdy_vs_lw AS (
	SELECT TOP(1)
	(SELECT COUNT(*) FROM vagas
	WHERE data_publicacao <= GETDATE() AND ativa = 1) AS total_today,
	(NULLIF((SELECT COUNT(*) FROM vagas
	WHERE DATEDIFF(day, data_publicacao, GETDATE()) >= 7
	AND ativa = 1), 0)) AS total_last_week
	FROM vagas
),
cte_candidacy_tdy_vs_lw AS (
	SELECT TOP(1)
	(SELECT COUNT(*) FROM candidaturas
	WHERE data_candidatura <= GETDATE()) AS total_today, 
	(NULLIF((SELECT COUNT(*) FROM candidaturas
	WHERE DATEDIFF(day, data_candidatura, GETDATE()) >= 7), 0)) AS total_last_week
	FROM candidaturas
),
cte_vacancy AS (
	SELECT TOP(1)
	setores.nome,
	COUNT(vaga_id) AS total_vagas
	FROM vagas
	INNER JOIN empresas ON empresas.empresa_id = vagas.empresa_id
	INNER JOIN setores ON setores.setor_id = empresas.fk_setor_id
	GROUP BY setores.nome
	ORDER BY COUNT(vaga_id) DESC
),
cte_posts AS (
	SELECT TOP(1)
	usuarios.nome,
	COUNT(post_id) AS total_posts
	FROM posts
	INNER JOIN usuarios ON usuarios.usuario_id = posts.usuario_id
	WHERE DATEDIFF(day, data_publicacao, GETDATE()) <= 30  
	GROUP BY usuarios.nome
	ORDER BY COUNT(post_id) DESC
),
cte_conversation_rate AS (
	SELECT TOP(1)
	CAST(CAST((SELECT COUNT(*) FROM usuarios
	WHERE data_cadastro <= GETDATE()) AS DECIMAL (10,2))/
	NULLIF((SELECT COUNT(*) FROM usuarios
	WHERE DATEDIFF(day, data_cadastro, GETDATE()) >= 30), 0) AS DECIMAL (10,2)) * 100 AS conversation_rate
	FROM usuarios)
	SELECT 
	conversation_rate,
	total_vagas,
	total_posts,
	porcentagem
	FROM cte_candidacy_tdy_vs_lw, cte_conversation_rate, cte_posts, cte_users_tdy_vs_lw, cte_vacancy, cte_vacancy_tdy_vs_lw


-- 24.1 
CREATE OR ALTER VIEW vw_habilidades_comuns AS 
SELECT COUNT(vh.habilidade_id)*30 FROM vaga_habilidades AS vh
INNER JOIN vagas AS v ON v.vaga_id = vh.vaga_id  
INNER JOIN usuario_habilidades AS uh ON uh.habilidade_id = vh.habilidade_id
GROUP BY v.vaga_id
ORDER BY COUNT(vh.habilidade_id) DESC

CREATE OR ALTER VIEW vw_cidade_vaga AS 
SELECT COUNT(*) FROM vagas AS v
INNER JOIN usuarios AS u ON u.cidade = v.cidade
GROUP BY v.vaga_id
 
CREATE OR ALTER VIEW vw_conexoes AS --Lógica incompleta
SELECT COUNT(*) FROM conexoes AS c
INNER JOIN usuarios AS u ON u.usuario_id = c.usuario_origem
INNER JOIN experiencias AS ex ON ex.usuario_id = c.usuario_destino
INNER JOIN empresas AS e ON e.empresa_id = ex.empresa_id

CREATE OR ALTER PROCEDURE sp_recomendar_vagas 
@usuario_id INT, @top_n INT = 10
AS
BEGIN TRY

