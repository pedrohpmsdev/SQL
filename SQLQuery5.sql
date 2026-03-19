use linkedin_db

SELECT usuario_id, nome,
	CASE
		WHEN (SELECT COUNT(*) FROM usuario_habilidades AS h WHERE u.usuario_id = h.usuario_id) <= 1 THEN 'Iniciante'
		WHEN 
		(SELECT COUNT(*) FROM usuario_habilidades AS h WHERE u.usuario_id = h.usuario_id) <= 3
		AND (SELECT COUNT(*) FROM usuario_habilidades AS h WHERE u.usuario_id = h.usuario_id) >= 2 THEN 'Em crescimento'
		WHEN (SELECT COUNT(*) FROM usuario_habilidades AS h WHERE u.usuario_id = h.usuario_id) >= 4 THEN 'Experiente'
		END AS 'Senioridade'
	FROM usuarios AS u;

SELECT * FROM usuario_habilidades WHERE usuario_id = 1003;
INSERT INTO usuarios (nome, email, titulo_perfil, cidade, data_cadastro, linkedin_url)
VALUES
('CR7', 'CR7@gmail.com', 'Jogador de futebol', 'Lisboa', 'PT', '01/01/2020', 'cr7.linkedin.com.br');
SELECT * FROM usuarios;
INSERT INTO usuario_habilidades (usuario_id, habilidade_id, nivel)
VALUES
(1003, 1, 1),
(1003, 2, 2);

SELECT * FROM empresas AS e1 
	WHERE 
		(SELECT nome FROM setores AS e2 WHERE e2.setor_id = e1.fk_setor_id) = 'Tecnologia' 
		AND (e1.nome LIKE '%Tech%' OR e1.nome LIKE '%Digital%')
		;

SELECT * FROM vagas WHERE DATEDIFF(day, data_expiracao, GETDATE()) >= 0 AND ativa = 1;
UPDATE vagas SET ativa = 0 WHERE DATEDIFF(day, data_expiracao, GETDATE()) >= 0 AND ativa = 1;

SELECT * FROM candidaturas AS c WHERE (SELECT ativa FROM vagas AS v WHERE v.vaga_id = c.vaga_id) = 0 AND (status = 'em_revisao' OR status = 'enviada');
UPDATE candidaturas SET candidaturas.status = 'reprovada' WHERE (SELECT ativa FROM vagas AS v WHERE v.vaga_id =  candidaturas.vaga_id) = 0 AND (status = 'em_revisao' OR status = 'enviada');

SELECT * FROM posts WHERE ativo = 0;
SELECT * FROM curtidas WHERE post_id = (SELECT * FROM posts WHERE ativo = 0).post_id;
-- DELETE FROM curtidas WHERE post_id = (SELECT * FROM posts WHERE ativo = 0).post_id; 
