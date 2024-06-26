-----------------------------------------------------------
-- Avaliação de DWH - Big Data - 2024.1
-- Grupo Formato por:
-- Carlos Henrique Ferreira Brito Filho (DRE 120081409)
-- Bárbara Rodrigues dos Santos Cerqueira (DRE 117198425)
-- Ramon de Attayde Barros de Souza (DRE 122047728)
-- Barbara Varela Bonfim (DRE 120130698)
-----------------------------------------------------------


-- Carregar DimCliente a partir de StageCliente
INSERT INTO DimCliente (ID_CLIENTE, NOME, TIPO_PESSOA, CNPJ_CPF, CNH, DT_EXP_CNH, TELEFONE, EMAIL, ID_ENDERECO)
SELECT ID_CLIENTE, NOME, TIPO_PESSOA, CNPJ_CPF, CNH, DT_EXP_CNH, TELEFONE, EMAIL, ID_ENDERECO
FROM StageCliente;

-- Carregar DimEndereco a partir de StageEndereco
INSERT INTO DimEndereco (ID_ENDERECO, LOGRADOURO, NUMERO, COMPLEMENTO, CEP, BAIRRO, CIDADE, ESTADO)
SELECT ID_ENDERECO, LOGRADOURO, NUMERO, COMPLEMENTO, CEP, BAIRRO, CIDADE, ESTADO
FROM StageEndereco;

-- Carregar DimPatio a partir de StagePatio
INSERT INTO DimPatio (ID_PATIO, NOME_PATIO, ID_ENDERECO)
SELECT ID_PATIO, NOME_PATIO, ID_ENDERECO
FROM StagePatio;

-- Carregar DimProtecaoAdicional a partir de StageProtecaoAdicional
INSERT INTO DimProtecaoAdicional (ID_PROTECAO, NOME_PROTECAO, VALOR_PROTECAO)
SELECT ID_PROTECAO, NOME_PROTECAO, VALOR_PROTECAO
FROM StageProtecaoAdicional;

-- Carregar DimTempo a partir de StageTempo
INSERT INTO DimTempo (ID_TEMPO, DATA, ANO, MES, DIA, TRIMESTRE, SEMANA, DIA_DA_SEMANA)
SELECT ID_TEMPO, DATA, ANO, MES, DIA, TRIMESTRE, SEMANA, DIA_DA_SEMANA
FROM StageTempo;

-- Carregar DimVeiculo a partir de StageVeiculo
INSERT INTO DimVeiculo (ID_VEICULO, PLACA, CHASSIS, COR, MECANIZACAO, AR_CONDICIONADO, ACESSORIOS_EXTRAS, PRONTUARIO, URL_FOTOS, MODELO, CATEGORIA)
SELECT ID_VEICULO, PLACA, CHASSIS, COR, MECANIZACAO, AR_CONDICIONADO, ACESSORIOS_EXTRAS, PRONTUARIO, URL_FOTOS, MODELO, CATEGORIA
FROM StageVeiculo;

-- Carregar FatoAluguel a partir de StageAluguel e Dimensões relacionadas
INSERT INTO FatoAluguel (ID_ALUGUEL, ID_TEMPO_RETIRADA, ID_TEMPO_DEVOLUCAO_PREVISTA, ID_TEMPO_DEVOLUCAO_REALIZADA, VALOR_INICIAL, VALOR_FINAL, ID_CLIENTE, ID_VEICULO, ID_PATIO_RETIRADA, ID_PATIO_DEVOLUCAO, ID_PROTECAO)
SELECT sa.ID_ALUGUEL, 
       dt_ret.ID_TEMPO AS ID_TEMPO_RETIRADA, 
       dt_dev_prev.ID_TEMPO AS ID_TEMPO_DEVOLUCAO_PREVISTA, 
       dt_dev_real.ID_TEMPO AS ID_TEMPO_DEVOLUCAO_REALIZADA, 
       sa.VALOR_INICIAL, 
       sa.VALOR_FINAL, 
       sa.FK_CLIENTE AS ID_CLIENTE, 
       sa.FK_VEICULO AS ID_VEICULO, 
       sa.FK_PATIO_RETIRADA AS ID_PATIO_RETIRADA, 
       sa.FK_PATIO_DEVOLUCAO AS ID_PATIO_DEVOLUCAO, 
       sa.FK_PROTECOES_ADICIONAIS AS ID_PROTECAO
FROM StageAluguel sa
JOIN DimTempo dt_ret ON sa.DT_RETIRADA = dt_ret.DATA
JOIN DimTempo dt_dev_prev ON sa.DT_DEVOLUCAO_PREVISTA = dt_dev_prev.DATA
JOIN DimTempo dt_dev_real ON sa.DT_DEVOLUCAO_REALIZADA = dt_dev_real.DATA;