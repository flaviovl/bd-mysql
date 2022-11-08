-- --------------------------------------------------------------
--
--                    SCRIPT FISICO
--
-- Data Criacao ...........: 07/11/2022
-
-- PROJETO => 01 Base de Dados
--         => 09 Tabelas
--

-- --------------------------------------------------------------
-- BASE DE DADOS
-- --------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS aula1exer2evolucao3;
USE aula1exer2evolucao3;


-- --------------------------------------------------------------
-- Tabela PESSOA
-- --------------------------------------------------------------
CREATE TABLE PESSOA (
    cpf BIGINT NOT NULL,
    nome VARCHAR(64) NOT NULL,
    senha VARCHAR(32) NOT NULL,
    CONSTRAINT PESSOA_PK PRIMARY KEY (cpf)
) ENGINE = INNODB;


-- --------------------------------------------------------------
-- Tabela GERENTE
-- --------------------------------------------------------------
CREATE TABLE GERENTE (
    cpfGerente BIGINT NOT NULL,
    formacaoEscolar ENUM('P', 'M', 'S') NOT NULL,
    email VARCHAR(128) NOT NULL,
    CONSTRAINT PESSOA_GERENTE_FK FOREIGN KEY (cpfGerente)
        REFERENCES PESSOA (cpf)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = INNODB;


-- --------------------------------------------------------------
-- Tabela EMPREGADO
-- --------------------------------------------------------------
CREATE TABLE EMPREGADO (
    cpfEmpregado BIGINT NOT NULL,
    matricula INT NOT NULL,
    rua VARCHAR(32) NOT NULL,
    numero INT UNSIGNED,
    bairro VARCHAR(32) NOT NULL,
    cidade VARCHAR(32) NOT NULL,
    estado VARCHAR(2) NOT NULL,
    cep INT UNSIGNED NOT NULL,
    CONSTRAINT EMPREGADO_PK PRIMARY KEY (cpfEmpregado),
    CONSTRAINT EMPREGADO_UK UNIQUE KEY (matricula), 
    CONSTRAINT PESSOA_EMPREGADO_FK FOREIGN KEY (cpfEmpregado)
        REFERENCES PESSOA (cpf)
		ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = INNODB;


-- --------------------------------------------------------------
-- Tabela telefone (atributo multivalorado)
-- --------------------------------------------------------------
CREATE TABLE telefone (
    cpfEmpregado BIGINT NOT NULL,
    numero BIGINT NOT NULL,
    CONSTRAINT telefone_UK UNIQUE KEY (cpfEmpregado, numero),
    CONSTRAINT telefone_PESSOA_FK FOREIGN KEY (cpfEmpregado)
        REFERENCES EMPREGADO (cpfEmpregado)
		ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = INNODB;


-- --------------------------------------------------------------
-- Tabela VENDA
-- --------------------------------------------------------------
CREATE TABLE VENDA (
    idVenda SERIAL NOT NULL,
    dtVenda DATE NOT NULL,
    cpfEmpregado BIGINT NOT NULL,
    CONSTRAINT VENDA_PK PRIMARY KEY (idVenda),
    CONSTRAINT VENDA_EMPREGADO_FK FOREIGN KEY (cpfEmpregado)
        REFERENCES EMPREGADO (cpfEmpregado)
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
) ENGINE = INNODB AUTO_INCREMENT = 1;


-- --------------------------------------------------------------
-- Tabela AREA_VENDA
-- --------------------------------------------------------------
CREATE TABLE AREA_VENDA (
    idArea TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nomeArea VARCHAR(32) NOT NULL,
    cpfGerente BIGINT NOT NULL, 
    CONSTRAINT AREA_VENDA_PK PRIMARY KEY (idArea),
	CONSTRAINT AREA_VENDA_GERENTE_FK FOREIGN KEY (cpfGerente)
        REFERENCES GERENTE (cpfGerente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = INNODB AUTO_INCREMENT = 1;


-- --------------------------------------------------------------
-- Tabela alocado (relacionamento n:m)
-- --------------------------------------------------------------
CREATE TABLE alocado (
    idArea TINYINT UNSIGNED NOT NULL,
    cpfEmpregado BIGINT NOT NULL,
	CONSTRAINT telefone_UK UNIQUE KEY (cpfEmpregado, idArea),
    CONSTRAINT alocado_EMPREGADO_FK FOREIGN KEY (cpfEmpregado)
        REFERENCES EMPREGADO (cpfEmpregado)
		ON DELETE RESTRICT
        ON UPDATE CASCADE,
	CONSTRAINT alocado_AREA_VENDA_FK FOREIGN KEY (idArea)
        REFERENCES AREA_VENDA (idArea)
		ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = INNODB;


-- --------------------------------------------------------------
-- Tabela PRODUTO
-- --------------------------------------------------------------
CREATE TABLE PRODUTO (
    codProduto SERIAL NOT NULL,
    descricao VARCHAR(64) NOT NULL,
    precoUnit DECIMAL(7,2) NOT NULL,
    idArea TINYINT UNSIGNED NOT NULL,
    CONSTRAINT PRODUTO_PK PRIMARY KEY (codProduto),
    CONSTRAINT PRODUTO_AREA_VENDA_FK FOREIGN KEY (idArea)
        REFERENCES AREA_VENDA (idArea)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = INNODB AUTO_INCREMENT = 1;


-- --------------------------------------------------------------
-- Tabela contem (relacionamento n:m)
-- --------------------------------------------------------------
CREATE TABLE contem (
	codProduto BIGINT UNSIGNED NOT NULL,
    idVenda BIGINT UNSIGNED NOT NULL,
    qtdProduto INT NOT NULL, 
    CONSTRAINT contem_UK UNIQUE KEY(codProduto, idVenda),
    CONSTRAINT contem_PRODUTO_FK FOREIGN KEY (codProduto)
        REFERENCES PRODUTO (codProduto)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,
    CONSTRAINT contem_VENDA_FK FOREIGN KEY (idVenda)
        REFERENCES VENDA (idVenda)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE = INNODB;


