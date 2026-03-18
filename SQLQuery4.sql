USE linkedin_db;
SELECT * FROM usuarios;
SELECT * FROM usuarios WHERE premium = 1 AND data_cadastro >= '2025-09-18T07:50:00.0000000' ORDER BY nome ASC; 
SELECT * FROM usuarios WHERE data_cadastro >= DATEADD(month, -6, GETDATE());

UPDATE usuarios SET data_cadastro='2024-05-02T19:58:47.1234567' WHERE data_cadastro='2020-01-01 00:00:00.0000000'; 
SELECT * FROM vagas;

UPDATE vagas SET salario_max=25000 WHERE modalidade='Sênior';
SELECT titulo, empresa_id, cidade, modalidade, salario_max FROM vagas ORDER BY salario_max DESC;
SELECT * FROM conexoes WHERE status = 'pendente' AND DATEDIFF(day, data_solicitacao, GETDATE()) <= 7;
SELECT * FROM conexoes;
UPDATE conexoes SET data_solicitacao = '2026-02-16 13:09:55.4900000' WHERE data_solicitacao = '2026-03-16 13:09:55.4900000';

SELECT * FROM posts;
UPDATE posts SET visualizacoes = 10 WHERE visualizacoes = 0;
SELECT * FROM posts WHERE visualizacoes > 100 ORDER BY visualizacoes DESC;
SELECT * FROM usuario_habilidades;

SELECT * FROM usuarios AS u WHERE NOT EXISTS (SELECT * FROM usuario_habilidades AS p WHERE p.usuario_id = u.usuario_id);

DECLARE @QtdPorPagina INT = 10,
        @Pagina       INT = 3;

SELECT * FROM posts ORDER BY data_publicacao ASC
OFFSET (@Pagina - 1) * @QtdPorPagina rows fetch next @QtdPorPagina rows only;

SELECT * FROM vagas;
SELECT * FROM vagas WHERE salario_min >= 5000 AND salario_max <= 15000 AND modalidade='remoto' AND (nivel='Pleno' OR nivel='Sênior');

SELECT COUNT(*) FROM vagas WHERE salario_min >= 5000 AND salario_max <= 15000 AND modalidade='remoto' AND (nivel='Pleno' OR nivel='Sênior');

SELECT COUNT(*) FROM vagas WHERE salario_max <= 5000;
SELECT COUNT(*) FROM vagas WHERE salario_max <= 10000 AND salario_min >= 5000;
SELECT COUNT(*) FROM vagas WHERE salario_max <= 20000 AND salario_min >= 10000;
SELECT COUNT(*) FROM vagas WHERE salario_max >= 20000;


SELECT vaga_id, modalidade, nivel,
    CASE 
        WHEN salario_max <= 5000 THEN 'Até 5k'
        WHEN salario_max <= 10000 AND salario_min >= 5000 THEN 'Entre 5k e 10k'
        WHEN salario_max <= 20000 AND salario_min >= 10000 THEN 'Entre 10k e 20k'
        WHEN salario_max >= 20000 THEN 'Mais de 20k'
        ELSE 'Fora das faixas citadas'
        END AS 'Faixa salarial'
    FROM vagas;

SELECT vaga_id, modalidade, nivel, salario_min, salario_max FROM vagas;




 
    
