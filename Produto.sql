CREATE DATABASE produto
GO
USE produto

CREATE TABLE produto(
codigo        INT         NOT NULL,
nome          VARCHAR(50) NOT NULL,
valor         DECIMAL(7,2)   NOT NULL
PRIMARY KEY (codigo)
)

CREATE TABLE entrada(
cod_transacao      INT         NOT NULL,
cod_produto        INT         NOT NULL,
quantidade         INT         NOT NULL,
valor_total        INT  NOT NULL
PRIMARY KEY (cod_transacao)
FOREIGN KEY (cod_produto) REFERENCES produto(codigo)
)

CREATE TABLE saida(
cod_transacao      INT         NOT NULL,
cod_produto        INT         NOT NULL,
quantidade         INT         NOT NULL,
valor_total        INT   NOT NULL
PRIMARY KEY (cod_transacao)
FOREIGN KEY (cod_produto) REFERENCES produto(codigo)
)

SELECT e.cod_transacao, e.cod_produto, e.quantidade, e.valor_total
FROM entrada e, produto p
WHERE e.cod_produto = p.codigo

SELECT s.cod_transacao, s.cod_produto, s.quantidade, s.valor_total
FROM saida s, produto p
WHERE s.cod_produto = p.codigo

DECLARE @query	VARCHAR(200),
		@codigo		INT,
		@nome	VARCHAR(40),
		@valor	DECIMAL(7,2)
SET @codigo = 2
SET @nome = 'sdjf Lenovo'
SET @valor = 1.500
/*Query Dinâmica*/
SET @query = 'INSERT INTO produto VALUES ('+CAST(@codigo AS VARCHAR(5))
				+','''+ @nome + ''', ' + CAST(@valor AS VARCHAR(10)) + ')'
PRINT @query
EXEC (@query)
 
CREATE PROCEDURE sp_tabela (
    @codigo CHAR(1),
    @codigoTransacao INT,
    @codigoProduto INT,
    @quantidade INT,
    @erro VARCHAR(100) OUTPUT
)
AS
BEGIN
    DECLARE @valorTotal DECIMAL(7,2)
    -- Verifica se o código é válido ('e' para entrada ou 's' para saída)
    IF @codigo NOT IN ('e', 's')
    BEGIN
        SET @erro = 'Código inválido.'
        RETURN
    END
    -- Calcula o valor total da transação
    SET @valorTotal = (SELECT valor * @quantidade FROM produto WHERE codigo = @codigoProduto)
    -- Insere na tabela de entrada se o código for 'e', senão, insere na tabela de saída
    IF @codigo = 'e'
    BEGIN
        INSERT INTO entrada (cod_transacao, cod_produto, quantidade, valor_total)
        VALUES (@codigoTransacao, @codigoProduto, @quantidade, @valorTotal)
    END
    ELSE
    BEGIN
        INSERT INTO saida (cod_transacao, cod_produto, quantidade, valor_total)
        VALUES (@codigoTransacao, @codigoProduto, @quantidade, @valorTotal)
    END
    SET @erro = NULL
END
 
DECLARE @out1 VARCHAR(100)
EXEC sp_tabela 'e', 15, 1, 5, @out1 OUTPUT
PRINT @out1
 
DECLARE @out2 VARCHAR(100)
EXEC sp_tabela 's', 2, 2, 3, @out2 OUTPUT
PRINT @out2

SELECT * FROM  produto