CREATE OR ALTER PROCEDURE sp_buscar_vagas 
(@palavra_chave NVARCHAR(20) = NULL,
@cidade NVARCHAR(30) = NULL,
@setor NVARCHAR(30) = NULL,
@modalidade VARCHAR = NULL,
@nivel VARCHAR = NULL,
@salario_min DECIMAL = NULL, 
@empresa_id INT = NULL)
AS
SELECT @palavra_chave = '%' + RTRIM(@palavra_chave) + '%';
SELECT @setor = '%' + RTRIM(@setor) + '%';

BEGIN TRY
SELECT 
v.titulo,
e.nome AS empresa,
s.nome AS setor,
v.cidade,
v.modalidade,
v.nivel,
v.salario_min,
v.salario_max,
v.data_publicacao
FROM vagas AS v
INNER JOIN empresas AS e ON e.empresa_id = v.empresa_id
INNER JOIN setores AS s ON s.setor_id = e.fk_setor_id
WHERE 
v.ativa = 1 
AND 
(
	(titulo LIKE @palavra_chave OR v.titulo IS NULL OR @palavra_chave IS NULL)
	AND
	(s.nome LIKE @setor OR s.nome IS NULL or @setor IS NULL)
	AND
	(v.cidade = @cidade OR @cidade IS NULL)
	AND
	(v.nivel = nivel OR nivel IS NULL)

);
 
IF @salario_min <= 0 THROW 50000, 'Salário não pode ser negativo', 1;
END TRY

BEGIN CATCH
IF @salario_min <= 0 THROW 50000, 'Salário não pode ser negativo', 1;
END CATCH

EXEC sp_buscar_vagas @cidade = 'São Paulo';
EXEC sp_buscar_vagas @nivel = 'Sênior';

 
