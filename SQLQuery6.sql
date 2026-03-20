use linkedin_db;

SELECT * FROM posts WHERE ativo = 0;
SELECT * FROM curtidas AS c WHERE (SELECT ativo FROM posts AS p WHERE c.post_id = p.post_id) = 0;
SELECT * FROM posts;
SELECT * FROM curtidas;
DELETE FROM curtidas 
	WHERE (
		SELECT ativo FROM posts AS p 
		WHERE curtidas.post_id = p.post_id
	) = 0;

SELECT * FROM posts AS p 
	WHERE DATEDIFF(day, data_publicacao, GETDATE()) >= 30 
	AND 
	(
	SELECT COUNT(*) FROM curtidas AS c 
		WHERE p.post_id = c.post_id
	) >= 1; 
UPDATE posts SET visualizacoes = visualizacoes + 1 
	WHERE DATEDIFF(day, data_publicacao, GETDATE()) >= 30 
	AND 
	(SELECT COUNT(*) FROM curtidas AS c 
		WHERE posts.post_id = c.post_id) >= 1;  

SELECT 
v.titulo, 
e.nome, 
s.nome,
v.cidade, 
v.modalidade, 
v.nivel, 
CONCAT('R$ ', salario_min, ' - R$ ', salario_max) as faixa_salarial 
FROM vagas v
INNER JOIN empresas e ON v.empresa_id = e.empresa_id
INNER JOIN setores s ON e.fk_setor_id = s.setor_id

SELECT 
u.nome,
v.titulo,
e.nome,
c.status,
c.data_candidatura
FROM candidaturas AS c
INNER JOIN usuarios u ON c.usuario_id = u.usuario_id
INNER JOIN vagas v ON v.vaga_id = c.vaga_id
INNER JOIN empresas e ON e.empresa_id = v.empresa_id

SELECT 
e.empresa_id, 
e.nome, 
e.pais, 
v.vaga_id,
v.titulo, 
v.ativa 
FROM empresas AS e
LEFT JOIN vagas AS v ON e.empresa_id = v.empresa_id
WHERE v.ativa = 0;

SELECT 
u.nome,
COUNT(*) AS qtd_conexoes   
FROM usuarios AS u
INNER JOIN conexoes c ON c.usuario_destino = u.usuario_id OR c.usuario_origem = u.usuario_id
WHERE c.status = 'aceita'
GROUP BY u.nome;

