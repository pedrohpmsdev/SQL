use linkedin_db;

SELECT 
e.nome,
s.nome,
COUNT(v.vaga_id) AS totalVagas,
COUNT(c.candidatura_id) AS totalCand,
NULLIF(
(SELECT COUNT(*) FROM candidaturas
 WHERE candidaturas.status = 'aceita')
/
(SELECT COUNT(*) FROM candidaturas), 0) AS taxaConversao
FROM empresas AS e
INNER JOIN setores AS s ON s.setor_id = e.fk_setor_id 
INNER JOIN vagas AS v ON v.empresa_id = e.empresa_id 
INNER JOIN candidaturas AS c ON c.vaga_id = v.vaga_id
GROUP BY e.nome, s.nome, v.empresa_id, e.empresa_id
ORDER BY e.empresa_id

