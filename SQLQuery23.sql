-- 23.1 (1,2,3,4,5,6)
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
	COUNT(vaga_id)
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




 




	
 
