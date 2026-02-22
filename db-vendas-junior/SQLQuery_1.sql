-- Criar schema para organização
CREATE SCHEMA DW;
GO
 
-- Criar dimensão cliente
CREATE TABLE DW.DimCliente (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    NomeCompleto NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100),
    Telefone NVARCHAR(20),
    Cidade NVARCHAR(50),
    Estado NVARCHAR(2),
    Pais NVARCHAR(50),
    DataCadastro DATE,
    SegmentoCliente NVARCHAR(20)
);

CREATE TABLE DW.DimProduto (
    ProdutoID INT IDENTITY(1,1) PRIMARY KEY,
    NomeProduto NVARCHAR(100) NOT NULL,
    Categoria NVARCHAR(50),
    Subcategoria NVARCHAR(50),
    Marca NVARCHAR(50),
    PrecoLista DECIMAL(10,2),
    Ativo BIT DEFAULT 1
);

CREATE TABLE DW.DimTempo (
    DataID INT PRIMARY KEY, -- formato YYYYMMDD (ex: 20260101)
    Data DATE NOT NULL,
    Ano INT,
    Trimestre INT,
    Mes INT,
    MesNome NVARCHAR(20),
    Semana INT,
    DiaSemana INT,
    DiaSemaNome NVARCHAR(20),
    DiaUtil BIT
);

CREATE TABLE DW.FatoVendas (
    VendaID INT IDENTITY(1,1) PRIMARY KEY,
    DataID INT NOT NULL,
    ClienteID INT NOT NULL,
    ProdutoID INT NOT NULL,
    Quantidade INT NOT NULL,
    PrecoUnitario DECIMAL(10,2) NOT NULL,
    Desconto DECIMAL(10,2) DEFAULT 0,
    ValorTotal AS (Quantidade * PrecoUnitario - Desconto) PERSISTED,
    
    -- Foreign Keys
    CONSTRAINT FK_FatoVendas_DimTempo 
        FOREIGN KEY (DataID) REFERENCES DW.DimTempo(DataID),
    CONSTRAINT FK_FatoVendas_DimCliente 
        FOREIGN KEY (ClienteID) REFERENCES DW.DimCliente(ClienteID),
    CONSTRAINT FK_FatoVendas_DimProduto 
        FOREIGN KEY (ProdutoID) REFERENCES DW.DimProduto(ProdutoID)
);
