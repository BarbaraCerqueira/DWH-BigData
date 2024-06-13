-- Tabela Cliente
CREATE TABLE [Cliente]
(
    [Cd_Cliente] integer NOT NULL,
    [Nm_Nome] varchar(18) NULL,
    [Ds_Tipo] varchar(18) NULL,
    [Cd_CNPJ_CPF] varchar(20) NULL,
    [Ds_Endereco] varchar(255) NULL,
    [Nu_Telefone] varchar(20) NULL,
    [Ds_Email] varchar(80) NULL,
    [Nu_CNH] varchar(20) NULL,
    [Dt_Validade_CNH] datetime NULL
)
go

-- Tabela Categoria
CREATE TABLE [Categoria]
(
    [Cd_Categoria] integer NOT NULL,
    [Nm_Categoria] varchar(30) NULL,
    [Vl_Valor_por_Dia] decimal(5,2) NULL
)
go

-- Tabela Locacao
CREATE TABLE [Locacao]
(
    [Cd_Locacao] integer NOT NULL,
    [Dt_Data_Retirada_Prevista] datetime NULL,
    [Dt_Data_Devolucao_Prevista] datetime NULL,
    [Dt_Data_Devolucao_Realizada] datetime NULL,
    [Dt_Data_Retirada_Realizada] datetime NULL,
    [Cd_Patio_Saida] integer NULL,
    [Cd_Patio_Entrada] integer NULL,
    [Cd_Cliente] integer NULL,
    [Ds_Protecao_de_Farol] bit NULL,
    [Ds_Protecao_de_Vidro] bit NULL
)
go

-- Tabela Patio
CREATE TABLE [Patio]
(
    [Cd_Patio] integer NOT NULL,
    [Nm_Patio] varchar(20) NULL
)
go

-- Tabela Reserva
CREATE TABLE [Reserva]
(
    [Cd_Reserva] integer NOT NULL,
    [Dt_Reserva] datetime NULL,
    [Dt_Entrega] datetime NULL,
    [Dt_Devolucao] datetime NULL,
    [Cd_Cliente] integer NULL,
    [Cd_Carro] integer NULL,
    [Cd_Situacao] varchar(20) NULL
)
go

-- Tabela Veiculo
CREATE TABLE [Veiculo]
(
    [Cd_Carro] integer NOT NULL,
    [Nm_Marca] varchar(30) NULL,
    [Nm_Motor] varchar(30) NULL,
    [Ds_Mecanizacao] varchar(20) NULL,
    [Nm_Modelo] varchar(20) NULL,
    [Ds_Ar_Condicionado] bit NULL,
    [Nm_Cor] varchar(20) NULL,
    [Nu_Altura] decimal(5,1) NULL,
    [Nu_Tamanho] decimal(38) NULL,
    [Nu_Largura] decimal(5,1) NULL,
    [Ds_Foto] image NULL,
    [Nu_Placa] varchar(15) NULL,
    [Nu_Chassi] varchar(30) NULL,
    [Nm_Combustivel] varchar(20) NULL,
    [Nm_Pneu] varchar(30) NULL,
    [Cd_Categoria] integer NULL,
    [Nu_Pressao_Pneu] integer NULL
)
go