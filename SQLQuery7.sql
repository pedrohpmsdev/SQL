use linkedin_db

SELECT * FROM vagas AS v
INNER JOIN candidaturas c ON v.vaga_id = c.candidatura_id
WHERE NOT EXISTS (SELECT * FROM vagas WHERE c.usuario_id = 7);

INSERT INTO habilidades(nome, categoria)
VALUES
('JS', 'hard')

INSERT INTO usuario_habilidades(usuario_id, habilidade_id, nivel)
VALUES
(7, 1003, 'Avançado'),
(8, 1003, 'Especialista'),
(9, 1003, 'Especialista'),
(10, 1003, 'Avançado'),
(11, 1003, 'Avançado'),
(12, 1003, 'Especialista'),
(13, 1003, 'Avançado'),
(14, 1003, 'Avançado'),
(15, 1003, 'Especialista'),
(16, 1003, 'Avançado'),
(17, 1003, 'Especialista'),
(18, 1003, 'Avançado')

SELECT * FROM usuarios AS u
LEFT JOIN usuario_habilidades AS uh 
ON uh.usuario_id = u.usuario_id
LEFT JOIN habilidades AS h 
ON h.habilidade_id = uh.habilidade_id	
WHERE uh.nivel IN ('Avançado', 'Especialista') AND h.nome = 'SQL';
 
--SELECT p.post_id, p.conteudo, p.ativo FROM posts AS p
--INNER JOIN curtidas AS c ON c.post_id = p.post_id
--WHERE DATEDIFF(day, c.data_curtida, GETDATE()) <= 7
--GROUP BY p.post_id, p.conteudo, p.ativo
--HAVING COUNT(c.usuario_id) >= 3;

--SELECT * FROM posts
--SELECT * FROM curtidas

----------------------------

--SELECT * FROM empresas AS e
--INNER JOIN vagas AS v ON v.empresa_id = e.empresa_id
--WHERE (SELECT COUNT(*) FROM vagas WHERE vagas.empresa_id = e.empresa_id) > AVG(SELECT COUNT(*) FROM vagas WHERE vagas.empresa_id = e.empresa_id)
--GROUP BY e.empresa_id

----------------------------

SELECT usuario_id, nome, DATEDIFF(day, data_cadastro, GETDATE()) AS idade FROM usuarios 
ORDER BY idade DESC;

SELECT TOP(1) count(*) AS qtdCadastros, YEAR(data_cadastro) AS ano, MONTH(data_cadastro) AS mes FROM usuarios  
GROUP BY data_cadastro
ORDER BY qtdCadastros DESC

SELECT TOP (5) count(*) AS qtdAssociacoes, habilidade_id FROM usuario_habilidades 
GROUP BY habilidade_id
ORDER BY qtdAssociacoes DESC
--FALTA PORCENTAGEM
 
 
