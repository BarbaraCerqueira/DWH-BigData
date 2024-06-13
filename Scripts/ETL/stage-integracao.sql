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
    Cliente;

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
    Patio;

-- Transfere dados de ProtecaoAdicional para StageProtecaoAdicional
INSERT INTO StageProtecaoAdicional (ID_PROTECAO, NOME_PROTECAO, VALOR_PROTECAO)
SELECT 
    ID_PROTECAO,
    NOME_PROTECAO,
    VALOR_PROTECAO
FROM 
    ProtecaoAdicional;

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
    Veiculo v
JOIN 
    TipoMecanizacao tm ON v.FK_MECANIZACAO = tm.ID_TIPO_MECANIZACAO
JOIN 
    Modelo m ON v.FK_MODELO = m.ID_MODELO
JOIN 
    Grupo g ON v.FK_CATEGORIA = g.ID_CATEGORIA;

-- Transfere dados das Tabelas para StageTempo
INSERT INTO StageTempo (ID_TEMPO, DATA, ANO, MES, DIA, TRIMESTRE, SEMANA, DIA_DA_SEMANA)
SELECT 
    ID_TEMPO, -- ID_TEMPO é PK gerada sequencialmente
    DATA,
    YEAR(DATA) AS ANO,
    MONTH(DATA) AS MES,
    DAY(DATA) AS DIA,
    QUARTER(DATA) AS TRIMESTRE,
    WEEK(DATA) AS SEMANA,
    DAYNAME(DATA) AS DIA_DA_SEMANA
FROM 
    (SELECT DISTINCT 
        DT_RETIRADA AS DATA FROM Aluguel
        UNION 
        SELECT DT_DEVOLUCAO_PREVISTA AS DATA FROM Aluguel
        UNION 
        SELECT DT_DEVOLUCAO_REALIZADA AS DATA FROM Aluguel
        UNION 
        SELECT DT_INICIO AS DATA FROM Reserva
        UNION 
        SELECT DT_FIM AS DATA FROM Reserva) AS DistinctDates;

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
    Aluguel a;

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
    Reserva r
JOIN 
    TipoStatus ts ON r.FK_STATUS = ts.ID_TIPO_STATUS;
