-- Popular DimTempo para o ano de 2026
DECLARE @DataInicio DATE = '2026-01-01';
DECLARE @DataFim DATE = '2026-12-31';
DECLARE @DataAtual DATE = @DataInicio;
 
WHILE @DataAtual <= @DataFim
BEGIN
    INSERT INTO DW.DimTempo (DataID, Data, Ano, Trimestre, Mes, MesNome, Semana, DiaSemana, DiaSemaNome, DiaUtil)
    VALUES (
        CAST(FORMAT(@DataAtual, 'yyyyMMdd') AS INT), -- DataID
        @DataAtual, -- Data
        YEAR(@DataAtual), -- Ano
        DATEPART(QUARTER, @DataAtual), -- Trimestre
        MONTH(@DataAtual), -- Mes
        FORMAT(@DataAtual, 'MMMM', 'pt-BR'), -- MesNome
        DATEPART(WEEK, @DataAtual), -- Semana
        DATEPART(WEEKDAY, @DataAtual), -- DiaSemana
        FORMAT(@DataAtual, 'dddd', 'pt-BR'), -- DiaSemaNome
        CASE WHEN DATEPART(WEEKDAY, @DataAtual) IN (1,7) THEN 0 ELSE 1 END -- DiaUtil (0=fds, 1=util)
    );
    
    SET @DataAtual = DATEADD(DAY, 1, @DataAtual);
END;
 
-- Verificar
SELECT TOP 10 * FROM DW.DimTempo ORDER BY DataID;

INSERT INTO DW.DimCliente (NomeCompleto, Email, Telefone, Cidade, Estado, Pais, DataCadastro, SegmentoCliente)
VALUES 
    ('João Silva', 'joao.silva@email.com', '11987654321', 'São Paulo', 'SP', 'Brasil', '2025-01-15', 'Premium'),
    ('Maria Santos', 'maria.santos@email.com', '21987654321', 'Rio de Janeiro', 'RJ', 'Brasil', '2025-03-22', 'Regular'),
    ('Pedro Oliveira', 'pedro.oliveira@email.com', '31987654321', 'Belo Horizonte', 'MG', 'Brasil', '2025-05-10', 'VIP'),
    ('Ana Costa', 'ana.costa@email.com', '11976543210', 'São Paulo', 'SP', 'Brasil', '2025-08-05', 'Regular'),
    ('Carlos Ferreira', 'carlos.ferreira@email.com', '41987654321', 'Curitiba', 'PR', 'Brasil', '2025-11-20', 'Básico');
 
SELECT * FROM DW.DimCliente;

INSERT INTO DW.DimProduto (NomeProduto, Categoria, Subcategoria, Marca, PrecoLista, Ativo)
VALUES 
    ('Notebook Dell Inspiron 15', 'Informática', 'Notebooks', 'Dell', 3500.00, 1),
    ('Mouse Logitech MX Master 3', 'Informática', 'Periféricos', 'Logitech', 450.00, 1),
    ('Teclado Mecânico Razer', 'Informática', 'Periféricos', 'Razer', 650.00, 1),
    ('Monitor LG 27” 4K', 'Informática', 'Monitores', 'LG', 1800.00, 1),
    ('Webcam Logitech C920', 'Informática', 'Periféricos', 'Logitech', 350.00, 1);
 
SELECT * FROM DW.DimProduto;

INSERT INTO DW.FatoVendas (DataID, ClienteID, ProdutoID, Quantidade, PrecoUnitario, Desconto)
VALUES 
    (20260101, 1, 1, 2, 3500.00, 200.00), -- João comprou 2 notebooks
    (20260101, 2, 2, 3, 450.00, 0.00),    -- Maria comprou 3 mouses
    (20260102, 3, 4, 1, 1800.00, 100.00), -- Pedro comprou 1 monitor
    (20260103, 1, 3, 1, 650.00, 0.00),    -- João comprou 1 teclado
    (20260103, 4, 5, 2, 350.00, 50.00),   -- Ana comprou 2 webcams
    (20260104, 2, 1, 1, 3500.00, 150.00), -- Maria comprou 1 notebook
    (20260105, 5, 2, 5, 450.00, 100.00);  -- Carlos comprou 5 mouses
 
SELECT * FROM DW.FatoVendas;


SELECT 
    c.NomeCompleto,
    c.Cidade,
    c.SegmentoCliente,
    COUNT(fv.VendaID) AS TotalCompras,
    SUM(fv.Quantidade) AS TotalItens,
    SUM(fv.ValorTotal) AS ReceitaTotal
FROM DW.FatoVendas fv
INNER JOIN DW.DimCliente c ON fv.ClienteID = c.ClienteID
GROUP BY c.NomeCompleto, c.Cidade, c.SegmentoCliente
ORDER BY ReceitaTotal DESC;

