-----------------------------------------------------------
-- Avaliação de DWH - Big Data - 2024.1
-- Grupo Formato por:
-- Carlos Henrique Ferreira Brito Filho (DRE 120081409)
-- Bárbara Rodrigues dos Santos Cerqueira (DRE 117198425)
-- Ramon de Attayde Barros de Souza (DRE 122047728)
-- Barbara Varela Bonfim (DRE 120130698)
-----------------------------------------------------------


-- Table: DimCliente
CREATE TABLE DimCliente (
    ID_CLIENTE int  NOT NULL,
    NOME varchar(100)  NOT NULL,
    TIPO_PESSOA varchar(1)  NOT NULL,
    CNPJ_CPF varchar(15)  NOT NULL,
    CNH varchar(15)  NOT NULL,
    DT_EXP_CNH date  NOT NULL,
    TELEFONE varchar(20)  NULL,
    EMAIL varchar(100)  NULL,
    ID_ENDERECO int  NOT NULL,
    CONSTRAINT DimCliente_pk PRIMARY KEY (ID_CLIENTE)
) COMMENT 'tipo_pessoa = F ou J';

-- Table: DimEndereco
CREATE TABLE DimEndereco (
    ID_ENDERECO int  NOT NULL,
    LOGRADOURO int  NOT NULL,
    NUMERO int  NOT NULL,
    COMPLEMENTO varchar(255)  NULL,
    CEP varchar(10)  NOT NULL,
    BAIRRO varchar(50)  NOT NULL,
    CIDADE varchar(50)  NOT NULL,
    ESTADO varchar(50)  NOT NULL,
    CONSTRAINT DimEndereco_pk PRIMARY KEY (ID_ENDERECO)
);

-- Table: DimPatio
CREATE TABLE DimPatio (
    ID_PATIO int  NOT NULL,
    NOME_PATIO varchar(100)  NOT NULL,
    ID_ENDERECO int  NOT NULL,
    CONSTRAINT DimPatio_pk PRIMARY KEY (ID_PATIO)
);

-- Table: DimProtecaoAdicional
CREATE TABLE DimProtecaoAdicional (
    ID_PROTECAO int  NOT NULL,
    NOME_PROTECAO varchar(255)  NOT NULL,
    VALOR_PROTECAO float(10,2)  NOT NULL,
    CONSTRAINT DimProtecaoAdicional_pk PRIMARY KEY (ID_PROTECAO)
);

-- Table: DimReserva
CREATE TABLE DimReserva (
    ID_RESERVA int  NOT NULL,
    ID_TEMPO_INICIO int  NOT NULL,
    ID_TEMPO_FIM int  NOT NULL,
    STATUS varchar(100)  NOT NULL,
    ID_CLIENTE int  NOT NULL,
    ID_VEICULO int  NOT NULL,
    ID_PATIO int  NOT NULL,
    CONSTRAINT DimReserva_pk PRIMARY KEY (ID_RESERVA)
) COMMENT 'Status:
Ativa
Cancelada
Finalizada';

-- Table: DimTempo
CREATE TABLE DimTempo (
    ID_TEMPO int  NOT NULL,
    DATA date  NOT NULL,
    ANO int  NOT NULL,
    MES int  NOT NULL,
    DIA int  NOT NULL,
    TRIMESTRE int  NOT NULL,
    SEMANA int  NOT NULL,
    DIA_DA_SEMANA varchar(10)  NOT NULL,
    CONSTRAINT DimTempo_pk PRIMARY KEY (ID_TEMPO)
);

-- Table: DimVeiculo
CREATE TABLE DimVeiculo (
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
    CONSTRAINT DimVeiculo_pk PRIMARY KEY (ID_VEICULO)
);

-- Reference: DimCliente_DimEndereco (table: DimCliente)
ALTER TABLE DimCliente ADD CONSTRAINT DimCliente_DimEndereco FOREIGN KEY DimCliente_DimEndereco (ID_ENDERECO)
    REFERENCES DimEndereco (ID_ENDERECO);

-- Reference: DimPatio_DimEndereco (table: DimPatio)
ALTER TABLE DimPatio ADD CONSTRAINT DimPatio_DimEndereco FOREIGN KEY DimPatio_DimEndereco (ID_ENDERECO)
    REFERENCES DimEndereco (ID_ENDERECO);

-- Reference: DimReserva_DimCliente (table: DimReserva)
ALTER TABLE DimReserva ADD CONSTRAINT DimReserva_DimCliente FOREIGN KEY DimReserva_DimCliente (ID_CLIENTE)
    REFERENCES DimCliente (ID_CLIENTE);

-- Reference: DimReserva_DimTempoFim (table: DimReserva)
ALTER TABLE DimReserva ADD CONSTRAINT DimReserva_DimTempoFim FOREIGN KEY DimReserva_DimTempoFim (ID_TEMPO_FIM)
    REFERENCES DimTempo (ID_TEMPO);

-- Reference: DimReserva_DimTempoInicio (table: DimReserva)
ALTER TABLE DimReserva ADD CONSTRAINT DimReserva_DimTempoInicio FOREIGN KEY DimReserva_DimTempoInicio (ID_TEMPO_INICIO)
    REFERENCES DimTempo (ID_TEMPO);

-- Reference: DimReserva_DimVeiculo (table: DimReserva)
ALTER TABLE DimReserva ADD CONSTRAINT DimReserva_DimVeiculo FOREIGN KEY DimReserva_DimVeiculo (ID_VEICULO)
    REFERENCES DimVeiculo (ID_VEICULO);

-- Reference: FatoAluguel_DimCliente (table: FatoAluguel)
ALTER TABLE FatoAluguel ADD CONSTRAINT FatoAluguel_DimCliente FOREIGN KEY FatoAluguel_DimCliente (ID_CLIENTE)
    REFERENCES DimCliente (ID_CLIENTE);

-- Reference: FatoAluguel_DimPatioDevolucao (table: FatoAluguel)
ALTER TABLE FatoAluguel ADD CONSTRAINT FatoAluguel_DimPatioDevolucao FOREIGN KEY FatoAluguel_DimPatioDevolucao (ID_PATIO_DEVOLUCAO)
    REFERENCES DimPatio (ID_PATIO);

-- Reference: FatoAluguel_DimPatioRetirada (table: FatoAluguel)
ALTER TABLE FatoAluguel ADD CONSTRAINT FatoAluguel_DimPatioRetirada FOREIGN KEY FatoAluguel_DimPatioRetirada (ID_PATIO_RETIRADA)
    REFERENCES DimPatio (ID_PATIO);

-- Reference: FatoAluguel_DimProtecaoAdicional (table: FatoAluguel)
ALTER TABLE FatoAluguel ADD CONSTRAINT FatoAluguel_DimProtecaoAdicional FOREIGN KEY FatoAluguel_DimProtecaoAdicional (ID_PROTECAO)
    REFERENCES DimProtecaoAdicional (ID_PROTECAO);

-- Reference: FatoAluguel_DimTempo (table: FatoAluguel)
ALTER TABLE FatoAluguel ADD CONSTRAINT FatoAluguel_DimTempo FOREIGN KEY FatoAluguel_DimTempo (ID_TEMPO_DEVOLUCAO_REALIZADA)
    REFERENCES DimTempo (ID_TEMPO);

-- Reference: FatoAluguel_DimTempoDevolucaoPrevista (table: FatoAluguel)
ALTER TABLE FatoAluguel ADD CONSTRAINT FatoAluguel_DimTempoDevolucaoPrevista FOREIGN KEY FatoAluguel_DimTempoDevolucaoPrevista (ID_TEMPO_DEVOLUCAO_PREVISTA)
    REFERENCES DimTempo (ID_TEMPO);

-- Reference: FatoAluguel_DimTempoRetirada (table: FatoAluguel)
ALTER TABLE FatoAluguel ADD CONSTRAINT FatoAluguel_DimTempoRetirada FOREIGN KEY FatoAluguel_DimTempoRetirada (ID_TEMPO_RETIRADA)
    REFERENCES DimTempo (ID_TEMPO);

-- Reference: FatoAluguel_DimVeiculo (table: FatoAluguel)
ALTER TABLE FatoAluguel ADD CONSTRAINT FatoAluguel_DimVeiculo FOREIGN KEY FatoAluguel_DimVeiculo (ID_VEICULO)
    REFERENCES DimVeiculo (ID_VEICULO);