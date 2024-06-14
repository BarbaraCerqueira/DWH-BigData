-----------------------------------------------------------
-- Avaliação de DWH - Big Data - 2024.1
-- Grupo Formato por:
-- Carlos Henrique Ferreira Brito Filho (DRE 120081409)
-- Bárbara Rodrigues dos Santos Cerqueira (DRE 117198425)
-- Ramon de Attayde Barros de Souza (DRE 122047728)
-- Barbara Varela Bonfim (DRE 120130698)
-----------------------------------------------------------


-------------------------------------------
-- EXTRAÇÃO DO NOSSO ESQUEMA - EMPRESA 1 --
-------------------------------------------

-- Transfere dados de Cliente para StageCliente
INSERT INTO StageCliente (ID_CLIENTE, NOME, TIPO_PESSOA, CNPJ_CPF, CNH, DT_EXP_CNH, TELEFONE, EMAIL, ID_ENDERECO)
SELECT 
    ID_CLIENTE,
    NOME,
    TIPO_PESSOA,
    CNPJ_CPF,
    CNH,
    DT_EXP_CNH,
    TELEFONE,
    EMAIL,
    FK_ENDERECO
FROM 
    Empresa1.Cliente;

-- Transfere dados de Endereco para StageEndereco
INSERT INTO StageEndereco (ID_ENDERECO, LOGRADOURO, NUMERO, COMPLEMENTO, CEP, BAIRRO, CIDADE, ESTADO)
SELECT 
    e.ID_ENDERECO,
    e.LOGRADOURO,
    e.NUMERO,
    e.COMPLEMENTO,
    e.CEP,
    b.NOME_BAIRRO,
    c.NOME_CIDADE,
    es.NOME_ESTADO
FROM 
    Endereco e
JOIN 
    Bairro b ON e.FK_BAIRRO = b.ID_BAIRRO
JOIN 
    Cidade c ON b.FK_CIDADE = c.ID_CIDADE
JOIN 
    Estado es ON c.FK_ESTADO = es.ID_ESTADO;

-- Transfere dados de Patio para StagePatio
INSERT INTO StagePatio (ID_PATIO, NOME_PATIO, ID_ENDERECO)
SELECT 
    ID_PATIO,
    NOME_PATIO,
    FK_ENDERECO
FROM 
    Empresa1.Patio;

-- Transfere dados de ProtecaoAdicional para StageProtecaoAdicional
INSERT INTO StageProtecaoAdicional (ID_PROTECAO, NOME_PROTECAO, VALOR_PROTECAO)
SELECT 
    ID_PROTECAO,
    NOME_PROTECAO,
    VALOR_PROTECAO
FROM 
    Empresa1.ProtecaoAdicional;

-- Transfere dados de Veiculo para StageVeiculo
INSERT INTO StageVeiculo (ID_VEICULO, PLACA, CHASSIS, COR, MECANIZACAO, AR_CONDICIONADO, ACESSORIOS_EXTRAS, PRONTUARIO, URL_FOTOS, MODELO, CATEGORIA)
SELECT 
    v.ID_VEICULO,
    v.PLACA,
    v.CHASSIS,
    v.COR,
    tm.NOME_TIPO_MECANIZACAO,
    v.AR_CONDICIONADO,
    v.ACESSORIOS_EXTRAS,
    v.PRONTUARIO,
    v.URL_FOTOS,
    m.NOME_MODELO,
    g.NOME_CATEGORIA
FROM 
    Empresa1.Veiculo v
JOIN 
    Empresa1.TipoMecanizacao tm ON v.FK_MECANIZACAO = tm.ID_TIPO_MECANIZACAO
JOIN 
    Empresa1.Modelo m ON v.FK_MODELO = m.ID_MODELO
JOIN 
    Empresa1.Grupo g ON v.FK_CATEGORIA = g.ID_CATEGORIA;

-- Transfere dados das Tabelas para StageTempo
INSERT INTO StageTempo (DATA, ANO, MES, DIA, TRIMESTRE, SEMANA, DIA_DA_SEMANA)
SELECT -- ID_TEMPO é PK gerada sequencialmente
    DATA,
    YEAR(DATA) AS ANO,
    MONTH(DATA) AS MES,
    DAY(DATA) AS DIA,
    QUARTER(DATA) AS TRIMESTRE,
    WEEK(DATA) AS SEMANA,
    DAYNAME(DATA) AS DIA_DA_SEMANA
FROM 
    (SELECT DISTINCT 
        DT_RETIRADA AS DATA FROM Empresa1.Aluguel
        UNION 
        SELECT DT_DEVOLUCAO_PREVISTA AS DATA FROM Empresa1.Aluguel
        UNION 
        SELECT DT_DEVOLUCAO_REALIZADA AS DATA FROM Empresa1.Aluguel
        UNION 
        SELECT DT_INICIO AS DATA FROM Empresa1.Reserva
        UNION 
        SELECT DT_FIM AS DATA FROM Empresa1.Reserva) AS DistinctDates;

-- Transfere dados de Aluguel para StageAluguel
INSERT INTO StageAluguel (ID_ALUGUEL, ID_TEMPO_RETIRADA, ID_TEMPO_DEVOLUCAO_PREVISTA, ID_TEMPO_DEVOLUCAO_REALIZADA, VALOR_INICIAL, VALOR_FINAL, ID_CLIENTE, ID_VEICULO, ID_PATIO_RETIRADA, ID_PATIO_DEVOLUCAO, ID_PROTECAO)
SELECT 
    a.ID_ALUGUEL,
    (SELECT ID_TEMPO FROM StageTempo WHERE DATA = a.DT_RETIRADA) AS ID_TEMPO_RETIRADA,
    (SELECT ID_TEMPO FROM StageTempo WHERE DATA = a.DT_DEVOLUCAO_PREVISTA) AS ID_TEMPO_DEVOLUCAO_PREVISTA,
    (SELECT ID_TEMPO FROM StageTempo WHERE DATA = a.DT_DEVOLUCAO_REALIZADA) AS ID_TEMPO_DEVOLUCAO_REALIZADA,
    a.VALOR_INICIAL,
    a.VALOR_FINAL,
    a.FK_CLIENTE,
    a.FK_VEICULO,
    a.FK_PATIO_RETIRADA,
    a.FK_PATIO_DEVOLUCAO,
    a.FK_PROTECOES_ADICIONAIS
FROM 
    Empresa1.Aluguel a;

-- Transfere dados de Reserva para StageReserva
INSERT INTO StageReserva (ID_RESERVA, ID_TEMPO_INICIO, ID_TEMPO_FIM, STATUS, ID_CLIENTE, ID_VEICULO, ID_PATIO)
SELECT 
    r.ID_RESERVA,
    (SELECT ID_TEMPO FROM StageTempo WHERE DATA = r.DT_INICIO) AS ID_TEMPO_INICIO,
    (SELECT ID_TEMPO FROM StageTempo WHERE DATA = r.DT_FIM) AS ID_TEMPO_FIM,
    ts.NOME_TIPO_STATUS,
    r.FK_CLIENTE,
    r.FK_VEICULO,
    r.FK_PATIO
FROM 
    Empresa1.Reserva r
JOIN 
    Empresa1.TipoStatus ts ON r.FK_STATUS = ts.ID_TIPO_STATUS;

------------------------------------------------- Integração de Outros Trabalhos --------------------------------------------------


--------------------------------------
-- EXTRAÇÃO DO ESQUEMA DA EMPRESA 2 --
--------------------------------------

-- Transfere dados das Tabelas para StageTempo
INSERT INTO StageTempo (DATA, ANO, MES, DIA, TRIMESTRE, SEMANA, DIA_DA_SEMANA)
SELECT -- ID_TEMPO é PK gerada sequencialmente
    DATA,
    YEAR(DATA) AS ANO,
    MONTH(DATA) AS MES,
    DAY(DATA) AS DIA,
    DATEPART(QUARTER, DATA) AS TRIMESTRE,
    DATEPART(WEEK, DATA) AS SEMANA,
    DATENAME(WEEKDAY, DATA) AS DIA_DA_SEMANA
FROM 
    (SELECT DISTINCT 
        CAST(Dt_Validade_CNH AS DATE) AS DATA FROM Empresa2.Cliente
        UNION
        SELECT CAST(Dt_Data_Retirada_Prevista AS DATE) AS DATA FROM Empresa2.Locacao
        UNION 
        SELECT CAST(Dt_Data_Devolucao_Prevista AS DATE) AS DATA FROM Empresa2.Locacao
        UNION 
        SELECT CAST(Dt_Data_Devolucao_Realizada AS DATE) AS DATA FROM Empresa2.Locacao
        UNION 
        SELECT CAST(Dt_Reserva AS DATE) AS DATA FROM Empresa2.Reserva
        UNION 
        SELECT CAST(Dt_Entrega AS DATE) AS DATA FROM Empresa2.Reserva
        UNION 
        SELECT CAST(Dt_Devolucao AS DATE) AS DATA FROM Empresa2.Reserva) AS DistinctDates;

-- Transfere dados da tabela Cliente para StageCliente
INSERT INTO StageCliente (ID_CLIENTE, NOME, TIPO_PESSOA, CNPJ_CPF, CNH, DT_EXP_CNH, TELEFONE, EMAIL, ID_ENDERECO)
SELECT
    Cd_Cliente AS ID_CLIENTE,
    Nm_Nome AS NOME,
    CASE
        WHEN LEN(Cd_CNPJ_CPF) = 11 THEN 'F'
        WHEN LEN(Cd_CNPJ_CPF) = 14 THEN 'J'
        ELSE NULL
    END AS TIPO_PESSOA,
    Cd_CNPJ_CPF AS CNPJ_CPF,
    Nu_CNH AS CNH,
    Dt_Validade_CNH AS DT_EXP_CNH,
    Nu_Telefone AS TELEFONE,
    Ds_Email AS EMAIL,
    NULL AS ID_ENDERECO -- Endereço é uma string na tabela de origem, exigiria tratamento para normalizar
FROM Empresa2.Cliente;

-- Transfere dados da tabela Veiculo para StageVeiculo
INSERT INTO StageVeiculo (ID_VEICULO, PLACA, CHASSIS, COR, MECANIZACAO, AR_CONDICIONADO, ACESSORIOS_EXTRAS, PRONTUARIO, URL_FOTOS, MODELO, CATEGORIA)
SELECT
    Cd_Carro AS ID_VEICULO,
    Nu_Placa AS PLACA,
    Nu_Chassi AS CHASSIS,
    Nm_Cor AS COR,
    Ds_Mecanizacao AS MECANIZACAO,
    Ds_Ar_Condicionado AS AR_CONDICIONADO,
    NULL AS ACESSORIOS_EXTRAS,
    NULL AS PRONTUARIO, 
    Ds_Foto AS URL_FOTOS, 
    Nm_Modelo AS MODELO,
    (SELECT Nm_Categoria FROM Empresa2.Categoria WHERE Empresa2.Categoria.Cd_Categoria = Empresa2.Veiculo.Cd_Categoria) AS CATEGORIA
FROM Empresa2.Veiculo;

-- Transfere dados da tabela Locacao para StageAluguel
INSERT INTO StageAluguel (ID_ALUGUEL, ID_TEMPO_RETIRADA, ID_TEMPO_DEVOLUCAO_PREVISTA, ID_TEMPO_DEVOLUCAO_REALIZADA, VALOR_INICIAL, VALOR_FINAL, ID_CLIENTE, ID_VEICULO, ID_PATIO_RETIRADA, ID_PATIO_DEVOLUCAO, ID_PROTECAO)
SELECT
    Cd_Locacao AS ID_ALUGUEL,
    (SELECT ID_TEMPO FROM StageTempo WHERE StageTempo.DATA = Empresa2.Locacao.Dt_Data_Retirada_Prevista) AS ID_TEMPO_RETIRADA,
    (SELECT ID_TEMPO FROM StageTempo WHERE StageTempo.DATA = Empresa2.Locacao.Dt_Data_Devolucao_Prevista) AS ID_TEMPO_DEVOLUCAO_PREVISTA,
    (SELECT ID_TEMPO FROM StageTempo WHERE StageTempo.DATA = Empresa2.Locacao.Dt_Data_Devolucao_Realizada) AS ID_TEMPO_DEVOLUCAO_REALIZADA,
    NULL AS VALOR_INICIAL, -- Não tem no modelo de origem
    NULL AS VALOR_FINAL, -- Não tem no modelo de origem
    Cd_Cliente AS ID_CLIENTE,
    NULL AS ID_VEICULO, -- Não tem no modelo de origem
    Cd_Patio_Saida AS ID_PATIO_RETIRADA,
    Cd_Patio_Entrada AS ID_PATIO_DEVOLUCAO,
    CASE
        WHEN Empresa2.Ds_Protecao_de_Farol = 1 THEN 1
        WHEN Empresa2.Ds_Protecao_de_Vidro = 1 THEN 2
        ELSE 0
    END AS ID_PROTECAO
FROM Empresa2.Locacao;

-- Preenche a tabela StageProtecaoAdicional
INSERT INTO StageProtecaoAdicional (ID_PROTECAO, NOME_PROTECAO, VALOR_PROTECAO)
SELECT
    1 AS ID_PROTECAO,
    'Proteção de Farol' AS NOME_PROTECAO,
    NULL AS VALOR_PROTECAO -- Não tem no modelo de origem
UNION
SELECT
    2 AS ID_PROTECAO,
    'Proteção de Vidro' AS NOME_PROTECAO,
    NULL AS VALOR_PROTECAO; -- Não tem no modelo de origem

-- Transfere dados da tabela Reserva para StageReserva
INSERT INTO StageReserva (ID_RESERVA, ID_TEMPO_INICIO, ID_TEMPO_FIM, STATUS, ID_CLIENTE, ID_VEICULO, ID_PATIO)
SELECT
    Cd_Reserva AS ID_RESERVA,
    (SELECT ID_TEMPO FROM StageTempo WHERE StageTempo.DATA = Empresa2.Reserva.Dt_Reserva) AS ID_TEMPO_INICIO,
    (SELECT ID_TEMPO FROM StageTempo WHERE StageTempo.DATA = Empresa2.Reserva.Dt_Entrega) AS ID_TEMPO_FIM,
    Cd_Situacao AS STATUS,
    Cd_Cliente AS ID_CLIENTE,
    Cd_Carro AS ID_VEICULO,
    NULL AS ID_PATIO -- Não tem no modelo de origem
FROM Empresa2.Reserva;

-- Transfere dados da tabela Patio para StagePatio
INSERT INTO StagePatio (ID_PATIO, NOME_PATIO, ID_ENDERECO)
SELECT
    Cd_Patio AS ID_PATIO,
    Nm_Patio AS NOME_PATIO,
    NULL AS ID_ENDERECO -- Não tem no modelo de origem
FROM Empresa2.Patio;


--------------------------------------
-- EXTRAÇÃO DO ESQUEMA DA EMPRESA 3 --
--------------------------------------

-- Insert data into StageTempo
INSERT INTO StageTempo (DATA, ANO, MES, DIA, TRIMESTRE, SEMANA, DIA_DA_SEMANA)
SELECT DISTINCT
    DATA,
    YEAR(DATA) AS ANO,
    MONTH(DATA) AS MES,
    DAY(DATA) AS DIA,
    DATEPART(QUARTER, DATA) AS TRIMESTRE,
    DATEPART(WEEK, DATA) AS SEMANA,
    DATENAME(WEEKDAY, DATA) AS DIA_DA_SEMANA
FROM (
    SELECT Dt_Data_Retirada_Prevista AS DATA FROM Locacao
    UNION
    SELECT Dt_Data_Devolucao_Prevista AS DATA FROM Locacao
    UNION
    SELECT Dt_Data_Devolucao_Realizada AS DATA FROM Locacao
    UNION
    SELECT Dt_Data_Retirada_Realizada AS DATA FROM Locacao
    UNION
    SELECT Dt_Reserva AS DATA FROM Reserva
    UNION
    SELECT Dt_Entrega AS DATA FROM Reserva
    UNION
    SELECT Dt_Devolucao AS DATA FROM Reserva
    UNION
    SELECT Dt_Validade_CNH AS DATA FROM Cliente
) AS CombinedDates
WHERE DATA IS NOT NULL;

-- Insert data into StageCliente
INSERT INTO StageCliente (ID_CLIENTE, NOME, TIPO_PESSOA, CNPJ_CPF, CNH, DT_EXP_CNH, TELEFONE, EMAIL, ID_ENDERECO)
SELECT Cd_Cliente AS ID_CLIENTE,
       Nm_Nome AS NOME,
       CASE WHEN Ds_Tipo = 'Física' THEN 'F' ELSE 'J' END AS TIPO_PESSOA,
       Cd_CNPJ_CPF AS CNPJ_CPF,
       Nu_CNH AS CNH,
       Dt_Validade_CNH AS DT_EXP_CNH,
       Nu_Telefone AS TELEFONE,
       Ds_Email AS EMAIL,
       NULL AS ID_ENDERECO -- Endereço é uma string na tabela de origem, exigiria tratamento para normalizar
FROM Empresa3.Cliente;

-- Insert data into StagePatio
INSERT INTO StagePatio (ID_PATIO, NOME_PATIO, ID_ENDERECO)
SELECT Cd_Patio AS ID_PATIO,
       Nm_Patio AS NOME_PATIO,
       NULL AS ID_ENDERECO
FROM Empresa3.Patio;

-- Insert data into StageVeiculo
INSERT INTO StageVeiculo (ID_VEICULO, PLACA, CHASSIS, COR, MECANIZACAO, AR_CONDICIONADO, ACESSORIOS_EXTRAS, PRONTUARIO, URL_FOTOS, MODELO, CATEGORIA)
SELECT Cd_Carro AS ID_VEICULO,
       Nu_Placa AS PLACA,
       Nu_Chassi AS CHASSIS,
       Nm_Cor AS COR,
       Ds_Mecanizacao AS MECANIZACAO,
       Ds_Ar_Condicionado AS AR_CONDICIONADO,
       NULL AS ACESSORIOS_EXTRAS,
       NULL AS PRONTUARIO,
       NULL AS URL_FOTOS,
       Nm_Modelo AS MODELO,
       (SELECT Nm_Categoria FROM Empresa3.Categoria WHERE Empresa3.Categoria.Cd_Categoria = Empresa3.Veiculo.Cd_Categoria) AS CATEGORIA
FROM Empresa3.Veiculo;

-- Insert data into StageAluguel
INSERT INTO StageAluguel (ID_ALUGUEL, ID_TEMPO_RETIRADA, ID_TEMPO_DEVOLUCAO_PREVISTA, ID_TEMPO_DEVOLUCAO_REALIZADA, VALOR_INICIAL, VALOR_FINAL, ID_CLIENTE, ID_VEICULO, ID_PATIO_RETIRADA, ID_PATIO_DEVOLUCAO, ID_PROTECAO)
SELECT Cd_Locacao AS ID_ALUGUEL,
        (SELECT ID_TEMPO FROM StageTempo WHERE StageTempo.DATA = Empresa3.Locacao.Dt_Data_Retirada_Prevista) AS ID_TEMPO_RETIRADA,
        (SELECT ID_TEMPO FROM StageTempo WHERE StageTempo.DATA = Empresa3.Locacao.Dt_Data_Devolucao_Prevista) AS ID_TEMPO_DEVOLUCAO_PREVISTA,
        (SELECT ID_TEMPO FROM StageTempo WHERE StageTempo.DATA = Empresa3.Locacao.Dt_Data_Devolucao_Realizada) AS ID_TEMPO_DEVOLUCAO_REALIZADA,
       NULL AS VALOR_INICIAL,
       NULL AS VALOR_FINAL, 
       Cd_Cliente AS ID_CLIENTE,
       NULL AS ID_VEICULO,
       Cd_Patio_Entrada AS ID_PATIO_RETIRADA,
       Cd_Patio_Saida AS ID_PATIO_DEVOLUCAO
       CASE WHEN Ds_Protecao_de_Farol = 1 OR Ds_Protecao_de_Vidro = 1 THEN 1 ELSE 0 END AS ID_PROTECAO
FROM Empresa3.Locacao;

-- Insert data into StageReserva
INSERT INTO StageReserva (ID_RESERVA, ID_TEMPO_INICIO, ID_TEMPO_FIM, STATUS, ID_CLIENTE, ID_VEICULO, ID_PATIO)
SELECT Cd_Reserva AS ID_RESERVA,
        (SELECT ID_TEMPO FROM StageTempo WHERE StageTempo.DATA = Empresa3.Reserva.Dt_Reserva) AS ID_TEMPO_INICIO,
        (SELECT ID_TEMPO FROM StageTempo WHERE StageTempo.DATA = Empresa3.Reserva.Dt_Devolucao) AS ID_TEMPO_FIM,
       Cd_Situacao AS STATUS,
       Cd_Cliente AS ID_CLIENTE,
       Cd_Carro AS ID_VEICULO,
       NULL AS ID_PATIO
FROM Empresa3.Reserva;

-- Insert data into StageProtecaoAdicional
INSERT INTO StageProtecaoAdicional (ID_PROTECAO, NOME_PROTECAO, VALOR_PROTECAO)
SELECT
    1 AS ID_PROTECAO,
    'Proteção de Farol' AS NOME_PROTECAO,
    NULL AS VALOR_PROTECAO
UNION
SELECT
    2 AS ID_PROTECAO,
    'Proteção de Vidro' AS NOME_PROTECAO,
    NULL AS VALOR_PROTECAO; 


--------------------------------------
-- EXTRAÇÃO DO ESQUEMA DA EMPRESA 4 --
--------------------------------------

-- Transfer Cliente to StageCliente
INSERT INTO StageCliente (
    ID_CLIENTE, NOME, TIPO_PESSOA, CNPJ_CPF, CNH, DT_EXP_CNH, TELEFONE, EMAIL, ID_ENDERECO
)
SELECT 
    ClienteID,
    Nome,
    CASE Tipo 
        WHEN 'Física' THEN 'F'
        WHEN 'Jurídica' THEN 'J'
    END AS TIPO_PESSOA,
    CPF_CNPJ,
    CNH,
    DataExpiracaoCNH,
    Telefone,
    Email,
    NULL AS ID_ENDERECO 
FROM 
    Empresa4.Cliente
JOIN
    Empresa4.Condutor ON Empresa4.Cliente.ClienteID = Empresa4.Condutor.ClienteID;

-- Transfer Patio to StagePatio
INSERT INTO StagePatio (
    ID_PATIO, NOME_PATIO, ID_ENDERECO
)
SELECT 
    PatioID,
    Nome,
    NULL AS ID_ENDERECO
FROM 
    Empresa4.Patio;

-- Transfer Veículo to StageVeiculo
INSERT INTO StageVeiculo (
    ID_VEICULO, PLACA, CHASSIS, COR, MECANIZACAO, AR_CONDICIONADO, ACESSORIOS_EXTRAS, PRONTUARIO, URL_FOTOS, MODELO, CATEGORIA
)
SELECT 
    VeiculoID,
    Placa,
    Chassis,
    Cor,
    Mecanizacao,
    ArCondicionado,
    Acessorios,
    Revisoes,
    Fotos,
    Modelo,
    Grupo AS CATEGORIA
FROM 
    Empresa4.Veículo;

-- Transfer Locacao to StageAluguel
INSERT INTO StageAluguel (
    ID_ALUGUEL, ID_TEMPO_RETIRADA, ID_TEMPO_DEVOLUCAO_PREVISTA, ID_TEMPO_DEVOLUCAO_REALIZADA, VALOR_INICIAL, VALOR_FINAL, ID_CLIENTE, ID_VEICULO, ID_PATIO_RETIRADA, ID_PATIO_DEVOLUCAO, ID_PROTECAO
)
SELECT 
    LocacaoID,
    (SELECT ID_TEMPO FROM StageTempo WHERE StageTempo.DATA = Empresa4.Locacao.UNIX_TIMESTAMP(Retirada) ) AS ID_TEMPO_RETIRADA,
    (SELECT ID_TEMPO FROM StageTempo WHERE StageTempo.DATA = Empresa4.Locacao.UNIX_TIMESTAMP(DevolucaoPrevista)) AS ID_TEMPO_DEVOLUCAO_PREVISTA,
    (SELECT ID_TEMPO FROM StageTempo WHERE StageTempo.DATA = Empresa4.Locacao.UNIX_TIMESTAMP(DevolucaoRealizada)) AS ID_TEMPO_DEVOLUCAO_REALIZADA,
    ValorInicial,
    ValorFinal,
    ClienteID,
    VeiculoID,
    PatioRetiradaID,
    PatioDevolucaoID,
    ProtecoesAdicionais->'$.ID_PROTECAO' -- JSON extract
FROM 
    Empresa4.Locacao;

-- Transfer Reserva to StageReserva
INSERT INTO StageReserva (
    ID_RESERVA, ID_TEMPO_INICIO, ID_TEMPO_FIM, STATUS, ID_CLIENTE, ID_VEICULO, ID_PATIO
)
SELECT 
    ReservaID,
    (SELECT ID_TEMPO FROM StageTempo WHERE StageTempo.DATA = Empresa4.Locacao.UNIX_TIMESTAMP(DataInicio) ) AS ID_TEMPO_INICIO,
    (SELECT ID_TEMPO FROM StageTempo WHERE StageTempo.DATA = Empresa4.Locacao.UNIX_TIMESTAMP(DataFim)) AS ID_TEMPO_FIM,
    Status,
    ClienteID,
    VeiculoID,
    NULL
FROM 
    Empresa4.Reserva;

-- Populate StageTempo
INSERT INTO StageTempo (
    DATA, ANO, MES, DIA, TRIMESTRE, SEMANA, DIA_DA_SEMANA
)
SELECT 
    DataReserva AS DATA,
    YEAR(DataReserva) AS ANO,
    MONTH(DataReserva) AS MES,
    DAY(DataReserva) AS DIA,
    QUARTER(DataReserva) AS TRIMESTRE,
    WEEKOFYEAR(DataReserva) AS SEMANA,
    DAYNAME(DataReserva) AS DIA_DA_SEMANA
FROM 
    Empresa4.Reserva
UNION
SELECT 
    Retirada AS DATA,
    YEAR(Retirada) AS ANO,
    MONTH(Retirada) AS MES,
    DAY(Retirada) AS DIA,
    QUARTER(Retirada) AS TRIMESTRE,
    WEEKOFYEAR(Retirada) AS SEMANA,
    DAYNAME(Retirada) AS DIA_DA_SEMANA
FROM 
    Empresa4.Locacao
UNION
SELECT
    DevolucaoPrevista AS DATA,
    YEAR(DevolucaoPrevista) AS ANO,
    MONTH(DevolucaoPrevista) AS MES,
    DAY(DevolucaoPrevista) AS DIA,
    QUARTER(DevolucaoPrevista) AS TRIMESTRE,
    WEEKOFYEAR(DevolucaoPrevista) AS SEMANA,
    DAYNAME(DevolucaoPrevista) AS DIA_DA_SEMANA
FROM 
    Empresa4.Locacao
UNION
SELECT
    DevolucaoRealizada AS DATA,
    YEAR(DevolucaoRealizada) AS ANO,
    MONTH(DevolucaoRealizada) AS MES,
    DAY(DevolucaoRealizada) AS DIA,
    QUARTER(DevolucaoRealizada) AS TRIMESTRE,
    WEEKOFYEAR(DevolucaoRealizada) AS SEMANA,
    DAYNAME(DevolucaoRealizada) AS DIA_DA_SEMANA
FROM 
    Empresa4.Locacao;
