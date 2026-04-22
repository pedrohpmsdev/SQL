-- 17.1
SELECT
ROW_NUMBER() OVER(PARTITION BY usuario_id ORDER BY usuario_id),
MAX(data_publicacao) AS row#
FROM posts
GROUP BY usuario_id, post_id

SELECT * FROM posts

-- 17.2
SELECT u.usuario_id, u.nome, COUNT(curtida_id) AS totalCurtidas,
DENSE_RANK() OVER(ORDER BY COUNT(curtida_id) DESC)
FROM usuarios AS u
JOIN curtidas AS c ON u.usuario_id = c.usuario_id
WHERE DATEDIFF(day, c.data_curtida, GETDATE()) <= 30
GROUP BY u.usuario_id, u.nome
ORDER BY totalCurtidas DESC

-- 17.3

-- 17.4
SELECT 
s.nome,  
(COUNT(vaga_id) OVER (PARTITION BY s.setor_id))/(COUNT(vaga_id) OVER (PARTITION BY v.vaga_id)) AS totalPorSetor
FROM vagas AS v
JOIN empresas AS e ON e.empresa_id = v.empresa_id
JOIN setores AS s ON s.setor_id = e.fk_setor_id
GROUP BY s.nome, s.setor_id, v.vaga_id

SELECT s.nome FROM vagas as v
JOIN empresas AS e ON e.empresa_id = v.empresa_id
JOIN setores AS s ON s.setor_id = e.fk_setor_id
