-----------------------------------------------------------
-- Avaliação de DWH - Big Data - 2024.1
-- Grupo Formato por:
-- Carlos Henrique Ferreira Brito Filho (DRE 120081409)
-- Bárbara Rodrigues dos Santos Cerqueira (DRE 117198425)
-- Ramon de Attayde Barros de Souza (DRE 122047728)
-- Barbara Varela Bonfim (DRE 120130698)
-----------------------------------------------------------


-- Table: Aluguel
CREATE TABLE Aluguel (
    ID_ALUGUEL int  NOT NULL,
    DT_RETIRADA date  NOT NULL,
    DT_DEVOLUCAO_PREVISTA date  NOT NULL,
    DT_DEVOLUCAO_REALIZADA date  NULL,
    VALOR_INICIAL float(10,2)  NOT NULL,
    VALOR_FINAL float(10,2)  NULL,
    FK_ESTADO_ENTREGA int  NOT NULL,
    FK_ESTADO_DEVOLUCAO int  NOT NULL,
    FK_CLIENTE int  NOT NULL,
    FK_VEICULO int  NOT NULL,
    FK_PATIO_RETIRADA int  NOT NULL,
    FK_PATIO_DEVOLUCAO int  NOT NULL,
    FK_PROTECOES_ADICIONAIS int  NOT NULL,
    CONSTRAINT Aluguel_pk PRIMARY KEY (ID_ALUGUEL)
);

-- Table: Bairro
CREATE TABLE Bairro (
    ID_BAIRRO int  NOT NULL,
    NOME_BAIRRO varchar(50)  NOT NULL,
    FK_CIDADE int  NOT NULL,
    CONSTRAINT Bairro_pk PRIMARY KEY (ID_BAIRRO)
);

-- Table: Cidade
CREATE TABLE Cidade (
    ID_CIDADE int  NOT NULL,
    NOME_CIDADE varchar(50)  NOT NULL,
    FK_ESTADO int  NOT NULL,
    CONSTRAINT Cidade_pk PRIMARY KEY (ID_CIDADE)
);

-- Table: Cliente
CREATE TABLE Cliente (
    ID_CLIENTE int  NOT NULL,
    NOME varchar(100)  NOT NULL,
    TIPO_PESSOA varchar(1)  NOT NULL,
    CNPJ_CPF varchar(15)  NOT NULL,
    CNH varchar(15)  NOT NULL,
    DT_EXP_CNH date  NOT NULL,
    TELEFONE varchar(20)  NULL,
    EMAIL varchar(100)  NULL,
    FK_ENDERECO int  NOT NULL,
    CONSTRAINT Cliente_pk PRIMARY KEY (ID_CLIENTE)
) COMMENT 'tipo_pessoa = F ou J';

-- Table: Endereco
CREATE TABLE Endereco (
    ID_ENDERECO int  NOT NULL,
    LOGRADOURO int  NOT NULL,
    NUMERO int  NOT NULL,
    COMPLEMENTO int  NULL,
    CEP varchar(10)  NOT NULL,
    FK_BAIRRO int  NOT NULL,
    CONSTRAINT Endereco_pk PRIMARY KEY (ID_ENDERECO)
);

-- Table: Estado
CREATE TABLE Estado (
    ID_ESTADO int  NOT NULL,
    NOME_ESTADO varchar(50)  NOT NULL,
    CONSTRAINT Estado_pk PRIMARY KEY (ID_ESTADO)
);

-- Table: EstadoVeiculo
CREATE TABLE EstadoVeiculo (
    ID_ESTADO_VEICULO int  NOT NULL,
    NOME_ESTADO_VEICULO varchar(50)  NOT NULL,
    CONSTRAINT EstadoVeiculo_pk PRIMARY KEY (ID_ESTADO_VEICULO)
);

-- Table: FatoAluguel
CREATE TABLE FatoAluguel (
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
    STATUS int  NOT NULL,
    CONSTRAINT FatoAluguel_pk PRIMARY KEY (ID_ALUGUEL)
);

-- Table: Grupo
CREATE TABLE Grupo (
    ID_CATEGORIA int  NOT NULL,
    NOME_CATEGORIA varchar(50)  NOT NULL,
    CONSTRAINT Grupo_pk PRIMARY KEY (ID_CATEGORIA)
);

-- Table: Marca
CREATE TABLE Marca (
    ID_MARCA int  NOT NULL,
    NOME_MARCA varchar(50)  NOT NULL,
    CONSTRAINT Marca_pk PRIMARY KEY (ID_MARCA)
);

-- Table: Modelo
CREATE TABLE Modelo (
    ID_MODELO int  NOT NULL,
    NOME_MODELO varchar(50)  NOT NULL,
    Marca_ID_MARCA int  NOT NULL,
    CONSTRAINT Modelo_pk PRIMARY KEY (ID_MODELO)
);

-- Table: Patio
CREATE TABLE Patio (
    ID_PATIO int  NOT NULL,
    NOME_PATIO varchar(100)  NOT NULL,
    FK_ENDERECO int  NOT NULL,
    CONSTRAINT Patio_pk PRIMARY KEY (ID_PATIO)
);

-- Table: ProtecaoAdicional
CREATE TABLE ProtecaoAdicional (
    ID_PROTECAO int  NOT NULL,
    NOME_PROTECAO varchar(255)  NOT NULL,
    VALOR_PROTECAO float(10,2)  NOT NULL,
    CONSTRAINT ProtecaoAdicional_pk PRIMARY KEY (ID_PROTECAO)
);

-- Table: ProtecaoAdicionalAluguel
CREATE TABLE ProtecaoAdicionalAluguel (
    ID_PROTECAO_ADICIONAL_ALUGUEL int  NOT NULL,
    ID_PROTECAO int  NOT NULL,
    ID_ALUGUEL int  NOT NULL,
    CONSTRAINT ProtecaoAdicionalAluguel_pk PRIMARY KEY (ID_PROTECAO_ADICIONAL_ALUGUEL)
);

-- Table: Reserva
CREATE TABLE Reserva (
    ID_RESERVA int  NOT NULL,
    DT_INICIO date  NOT NULL,
    DT_FIM date  NOT NULL,
    FK_STATUS int  NOT NULL,
    FK_CLIENTE int  NOT NULL,
    FK_VEICULO int  NOT NULL,
    FK_PATIO int  NOT NULL,
    CONSTRAINT Reserva_pk PRIMARY KEY (ID_RESERVA)
) COMMENT 'Status:
Ativa
Cancelada
Finalizada';

-- Table: TipoMecanizacao
CREATE TABLE TipoMecanizacao (
    ID_TIPO_MECANIZACAO int  NOT NULL,
    NOME_TIPO_MECANIZACAO varchar(50)  NOT NULL,
    CONSTRAINT TipoMecanizacao_pk PRIMARY KEY (ID_TIPO_MECANIZACAO)
);

-- Table: TipoStatus
CREATE TABLE TipoStatus (
    ID_TIPO_STATUS int  NOT NULL,
    NOME_TIPO_STATUS varchar(50)  NOT NULL,
    CONSTRAINT TipoStatus_pk PRIMARY KEY (ID_TIPO_STATUS)
) COMMENT 'Status:
Ativa
Cancelada
Finalizada';

-- Table: Veiculo
CREATE TABLE Veiculo (
    ID_VEICULO int  NOT NULL,
    PLACA varchar(10)  NOT NULL,
    CHASSIS varchar(50)  NOT NULL,
    COR varchar(20)  NOT NULL,
    FK_MECANIZACAO int  NOT NULL,
    AR_CONDICIONADO bool  NOT NULL,
    ACESSORIOS_EXTRAS varchar(255)  NULL,
    PRONTUARIO varchar(255)  NULL,
    URL_FOTOS text  NULL,
    FK_MODELO int  NOT NULL,
    FK_CATEGORIA int  NOT NULL,
    CONSTRAINT Veiculo_pk PRIMARY KEY (ID_VEICULO)
);

-- foreign keys
-- Reference: Aluguel_Cliente (table: Aluguel)
ALTER TABLE Aluguel ADD CONSTRAINT Aluguel_Cliente FOREIGN KEY Aluguel_Cliente (FK_CLIENTE)
    REFERENCES Cliente (ID_CLIENTE);

-- Reference: Aluguel_EstadoVeiculoDevolucao (table: Aluguel)
ALTER TABLE Aluguel ADD CONSTRAINT Aluguel_EstadoVeiculoDevolucao FOREIGN KEY Aluguel_EstadoVeiculoDevolucao (FK_ESTADO_ENTREGA)
    REFERENCES EstadoVeiculo (ID_ESTADO_VEICULO);

-- Reference: Aluguel_EstadoVeiculoEntrega (table: Aluguel)
ALTER TABLE Aluguel ADD CONSTRAINT Aluguel_EstadoVeiculoEntrega FOREIGN KEY Aluguel_EstadoVeiculoEntrega (FK_ESTADO_DEVOLUCAO)
    REFERENCES EstadoVeiculo (ID_ESTADO_VEICULO);

-- Reference: Aluguel_Patio1 (table: Aluguel)
ALTER TABLE Aluguel ADD CONSTRAINT Aluguel_Patio1 FOREIGN KEY Aluguel_Patio1 (FK_PATIO_RETIRADA)
    REFERENCES Patio (ID_PATIO);

-- Reference: Aluguel_Patio2 (table: Aluguel)
ALTER TABLE Aluguel ADD CONSTRAINT Aluguel_Patio2 FOREIGN KEY Aluguel_Patio2 (FK_PATIO_DEVOLUCAO)
    REFERENCES Patio (ID_PATIO);

-- Reference: Aluguel_ProtecaoAdicionalAluguel (table: Aluguel)
ALTER TABLE Aluguel ADD CONSTRAINT Aluguel_ProtecaoAdicionalAluguel FOREIGN KEY Aluguel_ProtecaoAdicionalAluguel (FK_PROTECOES_ADICIONAIS)
    REFERENCES ProtecaoAdicionalAluguel (ID_PROTECAO_ADICIONAL_ALUGUEL);

-- Reference: Aluguel_Veiculo (table: Aluguel)
ALTER TABLE Aluguel ADD CONSTRAINT Aluguel_Veiculo FOREIGN KEY Aluguel_Veiculo (FK_VEICULO)
    REFERENCES Veiculo (ID_VEICULO);

-- Reference: BAIRRO_CIDADE (table: Bairro)
ALTER TABLE Bairro ADD CONSTRAINT BAIRRO_CIDADE FOREIGN KEY BAIRRO_CIDADE (FK_CIDADE)
    REFERENCES Cidade (ID_CIDADE);

-- Reference: CIDADE_ESTADO (table: Cidade)
ALTER TABLE Cidade ADD CONSTRAINT CIDADE_ESTADO FOREIGN KEY CIDADE_ESTADO (FK_ESTADO)
    REFERENCES Estado (ID_ESTADO);

-- Reference: Cliente_Endereco (table: Cliente)
ALTER TABLE Cliente ADD CONSTRAINT Cliente_Endereco FOREIGN KEY Cliente_Endereco (FK_ENDERECO)
    REFERENCES Endereco (ID_ENDERECO);

-- Reference: Endereco_BAIRRO (table: Endereco)
ALTER TABLE Endereco ADD CONSTRAINT Endereco_BAIRRO FOREIGN KEY Endereco_BAIRRO (FK_BAIRRO)
    REFERENCES Bairro (ID_BAIRRO);

-- Reference: Modelo_Marca (table: Modelo)
ALTER TABLE Modelo ADD CONSTRAINT Modelo_Marca FOREIGN KEY Modelo_Marca (Marca_ID_MARCA)
    REFERENCES Marca (ID_MARCA);

-- Reference: Patio_Endereco (table: Patio)
ALTER TABLE Patio ADD CONSTRAINT Patio_Endereco FOREIGN KEY Patio_Endereco (FK_ENDERECO)
    REFERENCES Endereco (ID_ENDERECO);

-- Reference: ProtecaoAdicionalAluguel_Aluguel (table: ProtecaoAdicionalAluguel)
ALTER TABLE ProtecaoAdicionalAluguel ADD CONSTRAINT ProtecaoAdicionalAluguel_Aluguel FOREIGN KEY ProtecaoAdicionalAluguel_Aluguel (ID_ALUGUEL)
    REFERENCES Aluguel (ID_ALUGUEL);

-- Reference: ProtecaoAdicionalReserva_ProtecaoAdicional (table: ProtecaoAdicionalAluguel)
ALTER TABLE ProtecaoAdicionalAluguel ADD CONSTRAINT ProtecaoAdicionalReserva_ProtecaoAdicional FOREIGN KEY ProtecaoAdicionalReserva_ProtecaoAdicional (ID_PROTECAO)
    REFERENCES ProtecaoAdicional (ID_PROTECAO);

-- Reference: Reserva_Cliente (table: Reserva)
ALTER TABLE Reserva ADD CONSTRAINT Reserva_Cliente FOREIGN KEY Reserva_Cliente (FK_CLIENTE)
    REFERENCES Cliente (ID_CLIENTE);

-- Reference: Reserva_Patio (table: Reserva)
ALTER TABLE Reserva ADD CONSTRAINT Reserva_Patio FOREIGN KEY Reserva_Patio (FK_PATIO)
    REFERENCES Patio (ID_PATIO);

-- Reference: Reserva_TipoStatus (table: Reserva)
ALTER TABLE Reserva ADD CONSTRAINT Reserva_TipoStatus FOREIGN KEY Reserva_TipoStatus (FK_STATUS)
    REFERENCES TipoStatus (ID_TIPO_STATUS);

-- Reference: Reserva_Veiculo (table: Reserva)
ALTER TABLE Reserva ADD CONSTRAINT Reserva_Veiculo FOREIGN KEY Reserva_Veiculo (FK_VEICULO)
    REFERENCES Veiculo (ID_VEICULO);

-- Reference: Veiculo_Grupo (table: Veiculo)
ALTER TABLE Veiculo ADD CONSTRAINT Veiculo_Grupo FOREIGN KEY Veiculo_Grupo (FK_CATEGORIA)
    REFERENCES Grupo (ID_CATEGORIA);

-- Reference: Veiculo_Modelo (table: Veiculo)
ALTER TABLE Veiculo ADD CONSTRAINT Veiculo_Modelo FOREIGN KEY Veiculo_Modelo (FK_MODELO)
    REFERENCES Modelo (ID_MODELO);

-- Reference: Veiculo_TipoMecanizacao (table: Veiculo)
ALTER TABLE Veiculo ADD CONSTRAINT Veiculo_TipoMecanizacao FOREIGN KEY Veiculo_TipoMecanizacao (FK_MECANIZACAO)
    REFERENCES TipoMecanizacao (ID_TIPO_MECANIZACAO);