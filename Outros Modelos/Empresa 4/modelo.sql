-- INTEGRANTES:
-- Alex Teixeira, DRE: 117036607
-- Felipe Augusto de Miranda Villela, DRE: 114080437
-- Felipe Pêpe da Silva Oliveira, DRE: 123589472
-- João Pedro Martins Filipe Figueiredo Matos Menezes Pereira, DRE: 123642929
-- Karen Silva Pacheco, DRE: 123476904
-- Lucas Tavares, DRE: 120152739


CREATE TABLE Cliente (
  ClienteID INT PRIMARY KEY,
  Nome VARCHAR(255) NOT NULL,
  CPF_CNPJ VARCHAR(20) NOT NULL UNIQUE,
  Endereco VARCHAR(255),
  Telefone VARCHAR(20),
  Email VARCHAR(255),
  Tipo VARCHAR(10) CHECK (Tipo IN ('Física', 'Jurídica'))
);

CREATE TABLE Condutor (
  CondutorID INT PRIMARY KEY,
  ClienteID INT NOT NULL,
  Nome VARCHAR(255) NOT NULL,
  CNH VARCHAR(20) NOT NULL UNIQUE,
  DataExpiracaoCNH DATE NOT NULL,
  FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID)
);

CREATE TABLE Locacao (
  LocacaoID INT PRIMARY KEY,
  ReservaID INT NOT NULL,
  ClienteID INT NOT NULL,
  VeiculoID INT NOT NULL,
  CondutorID INT,
  Retirada TIMESTAMP NOT NULL,
  DevolucaoPrevista TIMESTAMP NOT NULL,
  DevolucaoRealizada TIMESTAMP,
  PatioRetiradaID INT NOT NULL,
  PatioDevolucaoID INT NOT NULL,
  EstadoEntrega TEXT,
  EstadoDevolucao TEXT,
  ProtecoesAdicionais JSON,
  ValorInicial DECIMAL(10, 2) NOT NULL,
  ValorFinal DECIMAL(10, 2),
  FOREIGN KEY (ReservaID) REFERENCES Reserva(ReservaID),
  FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID),
  FOREIGN KEY (VeiculoID) REFERENCES Veículo(VeiculoID),
  FOREIGN KEY (CondutorID) REFERENCES Condutor(CondutorID),
  FOREIGN KEY (PatioRetiradaID) REFERENCES Patio(PatioID),
  FOREIGN KEY (PatioDevolucaoID) REFERENCES Patio(PatioID)
);

CREATE TABLE Patio (
  PatioID INT PRIMARY KEY,
  Nome VARCHAR(255) NOT NULL,
  Endereco VARCHAR(255) NOT NULL
);

CREATE TABLE Reserva (
  ReservaID INT PRIMARY KEY,
  DataReserva DATE NOT NULL,
  DataInicio DATE NOT NULL,
  DataFim DATE NOT NULL,
  Grupo VARCHAR(50) NOT NULL,
  ClienteID INT NOT NULL,
  VeiculoID INT,
  Status VARCHAR(20) CHECK (Status IN ('Ativa', 'Concluída', 'Cancelada')),
  Observacoes TEXT,
  FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID),
  FOREIGN KEY (VeiculoID) REFERENCES Veículo(VeiculoID)
);

CREATE TABLE Veículo (
  VeiculoID INT PRIMARY KEY,
  Placa VARCHAR(10) NOT NULL UNIQUE,
  Marca VARCHAR(50) NOT NULL,
  Modelo VARCHAR(50) NOT NULL,
  Cor VARCHAR(20),
  Grupo VARCHAR(50) NOT NULL,
  ArCondicionado BOOLEAN NOT NULL,
  Cadeirinha BOOLEAN NOT NULL,
  Chassis VARCHAR(17) NOT NULL UNIQUE,
  Dimensoes VARCHAR(255),
  Acessorios JSON,
  Fotos JSON,
  EstadoConservacao TEXT,
  Revisoes TEXT,
  CaracteristicasRodagemSeguranca TEXT,
  Mecanizacao VARCHAR(20) CHECK (Mecanizacao IN ('Manual', 'Automática')),
);