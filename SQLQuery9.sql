use linkedin_db;

SELECT COUNT(*) AS qtdVagas, e.nome FROM vagas AS v
INNER JOIN empresas AS e ON v.empresa_id = e.empresa_id
WHERE v.ativa = 1 
GROUP BY e.empresa_id, e.nome, v.titulo
HAVING COUNT(*) > (SELECT COUNT(*) FROM vagas)/(SELECT COUNT(*) FROM empresas)
ORDER BY qtdVagas DESC 

SELECT 
u.nome, 
u.email, 
u.titulo_perfil,
v.titulo, 
e.nome, 
s.nome, 
v.cidade, 
v.modalidade, 
v.nivel,
c.status,
c.data_candidatura
FROM candidaturas AS c
INNER JOIN usuarios AS u ON u.usuario_id = c.usuario_id
INNER JOIN vagas AS v ON v.vaga_id = c.vaga_id
INNER JOIN empresas AS e ON e.empresa_id = v.empresa_id
INNER JOIN setores AS s ON s.setor_id = e.fk_setor_id

SELECT 
e.nome, 
e.empresa_id,
s.nome, 
COUNT(v.vaga_id) AS totalVagas, -- CORRIGIR ISSO 
COUNT(candidatura_id) AS totalCandidaturas -- CORRIGIR ISSO 
-- FALTA ÚLTIMO CAMPO
FROM empresas AS e
INNER JOIN vagas AS v ON v.empresa_id = e.empresa_id
INNER JOIN candidaturas AS c ON c.vaga_id = v.vaga_id
INNER JOIN setores AS s ON s.setor_id = e.fk_setor_id
GROUP BY e.empresa_id, e.nome, s.nome

SELECT * FROM empresas
SELECT * FROM vagas WHERE empresa_id = 2



