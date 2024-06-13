-----------------------------------------------------------
-- Avaliação de DWH - Big Data - 2024.1
-- Grupo Formato por:
-- Carlos Henrique Ferreira Brito Filho (DRE 120081409)
-- Bárbara Rodrigues dos Santos Cerqueira (DRE 117198425)
-- Ramon de Attayde Barros de Souza (DRE 122047728)
-- Barbara Varela Bonfim (DRE 120130698)
-----------------------------------------------------------


-- Table: StageAluguel
CREATE TABLE StageAluguel (
    ID_ALUGUEL int  NOT NULL,
    ID_TEMPO_RETIRADA int  NOT NULL,
    ID_TEMPO_DEVOLUCAO_PREVISTA int  NOT NULL,
    ID_TEMPO_DEVOLUCAO_REALIZADA int  NOT NULL,
    VALOR_INICIAL float(10,2)  NOT NULL,
    VALOR_FINAL float(10,2)  NOT NULL,
    ID_CLIENTE int  NOT NULL,
    ID_VEICULO int  NOT NULL,
    ID_PATIO_RETIRADA int  NOT NULL,
    ID_PATIO_DEVOLUCAO int  NOT NULL,
    ID_PROTECAO int  NOT NULL,
    CONSTRAINT StageAluguel_pk PRIMARY KEY (ID_ALUGUEL)
);

-- Table: StageCliente
CREATE TABLE StageCliente (
    ID_CLIENTE int  NOT NULL,
    NOME varchar(100)  NOT NULL,
    TIPO_PESSOA varchar(1)  NOT NULL,
    CNPJ_CPF varchar(15)  NOT NULL,
    CNH varchar(15)  NOT NULL,
    DT_EXP_CNH date  NOT NULL,
    TELEFONE varchar(20)  NULL,
    EMAIL varchar(100)  NULL,
    ID_ENDERECO int  NOT NULL,
    CONSTRAINT StageCliente_pk PRIMARY KEY (ID_CLIENTE)
) COMMENT 'tipo_pessoa = F ou J';

-- Table: StageEndereco
CREATE TABLE StageEndereco (
    ID_ENDERECO int  NOT NULL,
    LOGRADOURO int  NOT NULL,
    NUMERO int  NOT NULL,
    COMPLEMENTO varchar(255)  NULL,
    CEP varchar(10)  NOT NULL,
    BAIRRO varchar(50)  NOT NULL,
    CIDADE varchar(50)  NOT NULL,
    ESTADO varchar(50)  NOT NULL,
    CONSTRAINT StageEndereco_pk PRIMARY KEY (ID_ENDERECO)
);

-- Table: StagePatio
CREATE TABLE StagePatio (
    ID_PATIO int  NOT NULL,
    NOME_PATIO varchar(100)  NOT NULL,
    ID_ENDERECO int  NOT NULL,
    CONSTRAINT StagePatio_pk PRIMARY KEY (ID_PATIO)
);

-- Table: StageProtecaoAdicional
CREATE TABLE StageProtecaoAdicional (
    ID_PROTECAO int  NOT NULL,
    NOME_PROTECAO varchar(255)  NOT NULL,
    VALOR_PROTECAO float(10,2)  NOT NULL,
    CONSTRAINT StageProtecaoAdicional_pk PRIMARY KEY (ID_PROTECAO)
);

-- Table: StageReserva
CREATE TABLE StageReserva (
    ID_RESERVA int  NOT NULL,
    ID_TEMPO_INICIO int  NOT NULL,
    ID_TEMPO_FIM int  NOT NULL,
    STATUS varchar(100)  NOT NULL,
    ID_CLIENTE int  NOT NULL,
    ID_VEICULO int  NOT NULL,
    ID_PATIO int  NOT NULL,
    CONSTRAINT StageReserva_pk PRIMARY KEY (ID_RESERVA)
);

-- Table: StageTempo
CREATE TABLE StageTempo (
    ID_TEMPO int  NOT NULL,
    DATA date  NOT NULL,
    ANO int  NOT NULL,
    MES int  NOT NULL,
    DIA int  NOT NULL,
    TRIMESTRE int  NOT NULL,
    SEMANA int  NOT NULL,
    DIA_DA_SEMANA varchar(10)  NOT NULL,
    CONSTRAINT StageTempo_pk PRIMARY KEY (ID_TEMPO)
);

-- Table: StageVeiculo
CREATE TABLE StageVeiculo (
    ID_VEICULO int  NOT NULL,
    PLACA varchar(10)  NOT NULL,
    CHASSIS varchar(50)  NOT NULL,
    COR varchar(20)  NOT NULL,
    MECANIZACAO varchar(50)  NOT NULL,
    AR_CONDICIONADO bool  NOT NULL,
    ACESSORIOS_EXTRAS varchar(255)  NULL,
    PRONTUARIO varchar(255)  NULL,
    URL_FOTOS text  NULL,
    MODELO varchar(50)  NOT NULL,
    CATEGORIA varchar(50)  NOT NULL,
    CONSTRAINT StageVeiculo_pk PRIMARY KEY (ID_VEICULO)
);

-- Reference: StageAluguel_StageCliente (table: StageAluguel)
ALTER TABLE StageAluguel ADD CONSTRAINT StageAluguel_StageCliente FOREIGN KEY StageAluguel_StageCliente (ID_CLIENTE)
    REFERENCES StageCliente (ID_CLIENTE);

-- Reference: StageAluguel_StagePatioDevolucao (table: StageAluguel)
ALTER TABLE StageAluguel ADD CONSTRAINT StageAluguel_StagePatioDevolucao FOREIGN KEY StageAluguel_StagePatioDevolucao (ID_PATIO_DEVOLUCAO)
    REFERENCES StagePatio (ID_PATIO);

-- Reference: StageAluguel_StagePatioRetirada (table: StageAluguel)
ALTER TABLE StageAluguel ADD CONSTRAINT StageAluguel_StagePatioRetirada FOREIGN KEY StageAluguel_StagePatioRetirada (ID_PATIO_RETIRADA)
    REFERENCES StagePatio (ID_PATIO);

-- Reference: StageAluguel_StageProtecaoAdicional (table: StageAluguel)
ALTER TABLE StageAluguel ADD CONSTRAINT StageAluguel_StageProtecaoAdicional FOREIGN KEY StageAluguel_StageProtecaoAdicional (ID_PROTECAO)
    REFERENCES StageProtecaoAdicional (ID_PROTECAO);

-- Reference: StageAluguel_StageTempoDevRealizada (table: StageAluguel)
ALTER TABLE StageAluguel ADD CONSTRAINT StageAluguel_StageTempoDevRealizada FOREIGN KEY StageAluguel_StageTempoDevRealizada (ID_TEMPO_DEVOLUCAO_REALIZADA)
    REFERENCES StageTempo (ID_TEMPO);

-- Reference: StageAluguel_StageVeiculo (table: StageAluguel)
ALTER TABLE StageAluguel ADD CONSTRAINT StageAluguel_StageVeiculo FOREIGN KEY StageAluguel_StageVeiculo (ID_VEICULO)
    REFERENCES StageVeiculo (ID_VEICULO);

-- Reference: StageAluguel_TempoDevolucaoPrevista (table: StageAluguel)
ALTER TABLE StageAluguel ADD CONSTRAINT StageAluguel_TempoDevolucaoPrevista FOREIGN KEY StageAluguel_TempoDevolucaoPrevista (ID_TEMPO_DEVOLUCAO_PREVISTA)
    REFERENCES StageTempo (ID_TEMPO);

-- Reference: StageAluguel_TempoRetirada (table: StageAluguel)
ALTER TABLE StageAluguel ADD CONSTRAINT StageAluguel_TempoRetirada FOREIGN KEY StageAluguel_TempoRetirada (ID_TEMPO_RETIRADA)
    REFERENCES StageTempo (ID_TEMPO);

-- Reference: StageCliente_StageEndereco (table: StageCliente)
ALTER TABLE StageCliente ADD CONSTRAINT StageCliente_StageEndereco FOREIGN KEY StageCliente_StageEndereco (ID_ENDERECO)
    REFERENCES StageEndereco (ID_ENDERECO);

-- Reference: StagePatio_StageEndereco (table: StagePatio)
ALTER TABLE StagePatio ADD CONSTRAINT StagePatio_StageEndereco FOREIGN KEY StagePatio_StageEndereco (ID_ENDERECO)
    REFERENCES StageEndereco (ID_ENDERECO);

-- Reference: StageReserva_StageCliente (table: StageReserva)
ALTER TABLE StageReserva ADD CONSTRAINT StageReserva_StageCliente FOREIGN KEY StageReserva_StageCliente (ID_CLIENTE)
    REFERENCES StageCliente (ID_CLIENTE);

-- Reference: StageReserva_StageTempoFim (table: StageReserva)
ALTER TABLE StageReserva ADD CONSTRAINT StageReserva_StageTempoFim FOREIGN KEY StageReserva_StageTempoFim (ID_TEMPO_FIM)
    REFERENCES StageTempo (ID_TEMPO);

-- Reference: StageReserva_StageTempoInicio (table: StageReserva)
ALTER TABLE StageReserva ADD CONSTRAINT StageReserva_StageTempoInicio FOREIGN KEY StageReserva_StageTempoInicio (ID_TEMPO_INICIO)
    REFERENCES StageTempo (ID_TEMPO);

-- Reference: StageReserva_StageVeiculo (table: StageReserva)
ALTER TABLE StageReserva ADD CONSTRAINT StageReserva_StageVeiculo FOREIGN KEY StageReserva_StageVeiculo (ID_VEICULO)
    REFERENCES StageVeiculo (ID_VEICULO);