USE master

CREATE DATABASE BD2Obligatorio

USE BD2Obligatorio

CREATE TABLE TREN
(
	NumeroTren numeric(5) not null,
	Descripcion varchar(100) not null,
	Letra char(1) not null,
	CONSTRAINT PK_Tren PRIMARY KEY(NumeroTren),
	CONSTRAINT UK_LetraTren UNIQUE (Letra)
)


CREATE TABLE VAGON
(
	CodigoVagon numeric(5) not null,
	Capacidad numeric(5) not null,
	NumeroTren numeric(5) not null,
	CONSTRAINT PK_Vagon PRIMARY KEY(CodigoVagon),
	CONSTRAINT FEFK_VagonNumTren FOREIGN KEY(NumeroTren) REFERENCES TREN(NumeroTren),
	CONSTRAINT CK_CapacidadVagon CHECK(Capacidad <= 40)
)
CREATE INDEX IDX_NumeroTren on VAGON(NumeroTren)

CREATE TABLE ESTACION
(
	CodigoEstacion numeric(5) not null,
	Descripcion varchar(100) not null,
	Barrio varchar(25) not null,
	CONSTRAINT PK_Estacion PRIMARY KEY(CodigoEstacion)
)

CREATE TABLE COLOR
(
	CodigoColor numeric(2) not null,
	Nombre varchar(20) not null,
	CONSTRAINT PK_Color PRIMARY KEY(CodigoColor),
	CONSTRAINT CK_NombreColor CHECK(Nombre in ('Rojo', 'Azul', 'Amarillo', 'Naranja', 'Verde', 'Negro'))
)

CREATE TABLE LINEA
(
	NumeroLinea numeric(5) not null,
	Descripcion varchar(100) not null,
	Longitud numeric(3) not null,
	CodigoColor numeric(2) not null,
	CONSTRAINT PK_Linea PRIMARY KEY(NumeroLinea),
	CONSTRAINT FK_LineaCodColor FOREIGN KEY(CodigoColor) REFERENCES COLOR (CodigoColor),
	CONSTRAINT CK_LongitudLinea CHECK (Longitud >= 1)
)
CREATE INDEX IDX_LineaCodColor on LINEA(CodigoColor)

CREATE TABLE LINEA_ESTACION
(
	IdLineaEstacion numeric(5) not null identity(1,1),
	CodigoEstacion numeric(5) not null,
	NumeroLinea numeric(5) not null,
	CONSTRAINT PK_LineaEstacion PRIMARY KEY(IdLineaEstacion),
	CONSTRAINT FK_LineaEstacionCodEstacion FOREIGN KEY(CodigoEstacion) REFERENCES ESTACION (CodigoEstacion),
	CONSTRAINT FK_LineaEstacionNumLinea FOREIGN KEY(NumeroLinea) REFERENCES LINEA (NumeroLinea),
	CONSTRAINT UK_ExClavePrimariaLineaEstacion UNIQUE (CodigoEstacion, NumeroLinea)
)
CREATE INDEX IDX_LineaEstacionCodEstacion on LINEA_ESTACION(CodigoEstacion)
CREATE INDEX IDX_LineaEstacionNumLinea on LINEA_ESTACION(NumeroLinea)

CREATE TABLE TREN_LINEA_ESTACION
(
	IdTrenLineaEstacion numeric(5) not null Identity(1,1),
	NumeroTren numeric(5) not null,
	IdLineaEstacion numeric not null,
	Fecha smalldatetime not null,

	CONSTRAINT PK_TrenLineaEstacion PRIMARY KEY (IdTrenLineaEstacion),
	CONSTRAINT FK_Tren FOREIGN KEY (NumeroTren) REFERENCES Tren (NumeroTren),
	CONSTRAINT FK_EstacionLinea FOREIGN KEY (IdLineaEstacion) REFERENCES LINEA_ESTACION (IdLineaEstacion),
	CONSTRAINT UK_ExClavePrimariaTrenLineaEstacion UNIQUE (NumeroTren, IdLineaEstacion)
)
CREATE INDEX IDX_Tren on TREN_LINEA_ESTACION(NumeroTren)
CREATE INDEX IDX_EstacionLinea on TREN_LINEA_ESTACION(IdLineaEstacion)

CREATE TABLE DESTINO
(
	NumeroLinea numeric(5) not null,
	CodigoEstacion numeric(5) not null,
	CONSTRAINT PK_Destino PRIMARY KEY (NumeroLinea),
	CONSTRAINT FK_DestinoNumeroLinea FOREIGN KEY (NumeroLinea) REFERENCES LINEA (NumeroLinea),
	CONSTRAINT FK_DestinoCodigoEstacion FOREIGN KEY (CodigoEstacion) REFERENCES ESTACION (CodigoEstacion)
)
CREATE INDEX IDX_DestinoNumeroLinea on DESTINO(NumeroLinea)
CREATE INDEX IDX_DestinoCodigoEstacion on DESTINO(CodigoEstacion)

CREATE TABLE ORIGEN
(
	NumeroLinea numeric(5) not null,
	CodigoEstacion numeric(5) not null,
	CONSTRAINT PK_Origen PRIMARY KEY (NumeroLinea),
	CONSTRAINT FK_OrigenNumeroLinea FOREIGN KEY (NumeroLinea) REFERENCES Linea (NumeroLinea),
	CONSTRAINT FK_ORIGEN_CODIGOESTACION FOREIGN KEY (CodigoEstacion) REFERENCES Estacion (CodigoEstacion)
)
CREATE INDEX IDX_OrigenNumeroLinea on ORIGEN(NumeroLinea)
CREATE INDEX IDX_OrigenCodigoEstacion on ORIGEN(CodigoEstacion)

SELECT
	T.*
FROM
	Tren T,
	Tren_Linea_Estacion TLE
WHERE
T.NumeroTren = TLE.NumeroTren AND TLE.IdLineaEstacion = 1


/*ALTER TABLE TREN_LINEA_ESTACION DROP COLUMN FECHA;
ALTER TABLE TREN_LINEA_ESTACION DROP COLUMN HORA;


SELECT *
FROM TREN_LINEA_ESTACION

ALTER TABLE TREN_LINEA_ESTACION DROP COLUMN FechaHora;

ALTER TABLE TREN_LINEA_ESTACION ADD FechaHora smalldatetime not null;

delete from TREN_LINEA_ESTACION WHERE TREN_LINEA_ESTACION.IdTrenLineaEstacion = 1
*/
