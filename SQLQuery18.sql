--13.3
CREATE OR ALTER FUNCTION fn_vagas_recomendadas 
(@usuario_id INT)
RETURNS TABLE
AS

RETURN(
	SELECT vaga_id FROM vaga_habilidades AS vh
	JOIN usuario_habilidades AS uh ON vh.habilidade_id = uh.habilidade_id
	WHERE uh.usuario_id = @usuario_id
	GROUP BY vaga_id 
	HAVING COUNT (DISTINCT vh.habilidade_id) >= 2
);

--9.4
SELECT 
e.nome,
s.nome,
COUNT(v.vaga_id) AS totalVagas,
COUNT(c.candidatura_id) AS totalCand,
CAST(COUNT(CASE WHEN c.status = 'aceita' THEN 1 END)*1.0	
/
NULLIF(COUNT(c.candidatura_id), 0) AS DECIMAL (10,2)) AS taxaConversao
FROM empresas AS e
INNER JOIN setores AS s ON s.setor_id = e.fk_setor_id 
INNER JOIN vagas AS v ON v.empresa_id = e.empresa_id 
INNER JOIN candidaturas AS c ON c.vaga_id = v.vaga_id
GROUP BY e.empresa_id, e.nome, s.nome
ORDER BY e.empresa_id;

--9.2
SELECT DISTINCT
    c1.usuario_origem AS usuario,
    c2.usuario_destino AS sugestao
FROM conexoes c1
JOIN conexoes c2
    ON c1.usuario_destino = c2.usuario_origem
LEFT JOIN conexoes c3
    ON c3.usuario_origem = c1.usuario_origem
    AND c3.usuario_destino = c2.usuario_destino
    AND c3.status = 'aceita'
WHERE 
    c1.usuario_origem <> c2.usuario_destino  
    AND c3.usuario_origem IS NULL;   

--9.3
INSERT INTO experiencias (usuario_id, empresa_id, cargo, data_inicio, data_fim, descricao)
VALUES
(7, 10, 'Estagiário de TI', '2022-01-10', '2022-12-20', 'Manutenção de sistemas'),
(7, 12, 'Desenvolvedor Júnior', '2023-01-15', NULL, 'Desenvolvimento de APIs e manutenção de aplicações web.'),
(8, 11, 'Analista de Dados', '2021-03-01', '2023-06-30', 'Criação de dashboards'),
(9, 13, 'DevOps', '2020-07-01', NULL, 'Automação de pipelines'),
(10, 2, 'DBA', '2021-07-01', NULL, 'Gerencia de dbs'),
(11, 3, 'DevOps', '2020-07-01', NULL, 'Automação de pipelines'),
(12, 4, 'Desenvolvedor Pleno', '2021-05-10', NULL, 'Desenvolvimento de sistemas internos'),
(13, 5, 'Analista de Suporte', '2022-03-15', '2023-08-31', 'Atendimento'),
(14, 6, 'Arquiteto de Software', '2020-09-01', NULL, 'Definição de padrões'),
(15, 7, 'Desenvolvedor Sênior', '2019-11-01', '2023-12-31', 'Liderança técnica'),
(16, 8, 'Analista de Segurança', '2022-06-01', NULL, 'Monitoramento'),
(17, 9, 'Engenheiro de Dados', '2021-01-15', NULL, 'Construção de pipelines'),
(18, 10, 'Scrum Master', '2020-04-01', '2022-10-15', 'Remoção de impedimentos'),
(19, 11, 'Desenvolvedor Front-end', '2023-02-01', NULL, 'Desenvolvimento de interfaces'),
(20, 12, 'Gestor de TI', '2018-08-01', NULL, 'Gestão de equipes');

SELECT 
c.usuario_id
FROM candidaturas AS c
JOIN vagas AS v ON v.vaga_id = c.vaga_id
JOIN experiencias AS ex ON ex.usuario_id = c.usuario_id AND ex.empresa_id = v.empresa_id 
