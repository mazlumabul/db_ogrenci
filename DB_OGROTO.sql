--CREATE DATABASE DB_OGROTO

--USE DB_OGROTO;

--FAKÜLTE TABLOSU
CREATE TABLE FAKULTE
(
    FNo   INT           IDENTITY (100, 100) PRIMARY KEY,
    Ad    NVARCHAR (32) NOT NULL,
    Konum NVARCHAR (64)
);

--BÖLÜM TABLOSU
CREATE TABLE BOLUM
(
    BNo INT           IDENTITY (10, 10) PRIMARY KEY,
    Ad  NVARCHAR (50) NOT NULL,
    FNo INT           NOT NULL,
    FOREIGN KEY (FNo) REFERENCES FAKULTE (FNo) ON DELETE CASCADE ON UPDATE NO ACTION
);

--ÖÐRETÝM ELEMANLARI-AKADEMÝSYENLER
CREATE TABLE AKADEMISYEN
(
    AkaNo NVARCHAR (11) PRIMARY KEY,
    Ad    NVARCHAR (20) NOT NULL,
    Soyad NVARCHAR (20) NOT NULL,
    Unvan NVARCHAR (20),
    Maas  MONEY        ,
    BNo   INT          ,
    FOREIGN KEY (BNo) REFERENCES BOLUM (BNo) ON DELETE SET NULL ON UPDATE NO ACTION
); --bölüm silindiðinde personel kalsýn istiyoruz

--ÖÐRENCÝ TABLOSU
CREATE TABLE OGRENCI
(
    OgrNo NVARCHAR (11) NOT NULL,
    Ad    NVARCHAR (20) NOT NULL,
    Soyad NVARCHAR (20) NOT NULL,
    DTar  DATE         ,
    Cins  BIT          ,
    Foto  IMAGE        ,
    Harc  MONEY        ,
    GNO   FLOAT        , --Genel Not Ortalamasý
    BNo   INT           NOT NULL,
    PRIMARY KEY (OgrNo),
    FOREIGN KEY (BNo) REFERENCES BOLUM (BNo) ON DELETE CASCADE ON UPDATE NO ACTION
); --bölüm silindiðinde öðrenci de silinsin

CREATE TABLE DANISMAN
(
    AkaNo NVARCHAR (11),
    OgrNo NVARCHAR (11) PRIMARY KEY,
    FOREIGN KEY (AkaNo) REFERENCES AKADEMISYEN (AkaNo) ON DELETE SET NULL ON UPDATE NO ACTION,
    FOREIGN KEY (OgrNo) REFERENCES OGRENCI (OgrNo) ON DELETE CASCADE ON UPDATE NO ACTION
);

--DERSLER TABLOSU
CREATE TABLE DERS
(
    DersNo NVARCHAR (10) PRIMARY KEY,
    Ad     NVARCHAR (30) NOT NULL,
    Teo    INT          ,
    Uyg    INT          ,
    Krd    FLOAT        ,
    AKTS   INT          ,
    BNo    INT          ,
    FOREIGN KEY (BNo) REFERENCES BOLUM (BNo) ON DELETE SET NULL ON UPDATE NO ACTION
);

--DÖNEM TABLOSU
CREATE TABLE DONEM
(
    DersNo  NVARCHAR (10) ,
    DonemNo NVARCHAR (10) ,
    Yil     NUMERIC (4, 0) CHECK (yil > 2001
                                  AND yil < 2100),
    DonemAd NVARCHAR (10)  CHECK (DonemAd IN ('Güz', 'Bahar', 'Yaz Okulu')),
    Sube    NVARCHAR (4)  ,
    PRIMARY KEY (DersNo, DonemNo, Yil),
    FOREIGN KEY (DersNo) REFERENCES DERS (DersNo) ON DELETE CASCADE ON UPDATE NO ACTION
);

--ÖÐRENCÝ NOTLARI TABLOSU
CREATE TABLE OGRNOT
(
    OgrNo   NVARCHAR (11) ,
    DersNo  NVARCHAR (10) ,
    DonemNo NVARCHAR (10) ,
    Yil     NUMERIC (4, 0),
    Vize    INT           ,
    Final   INT           ,
    But     INT           ,
    Harf    CHAR (2)      ,
    PRIMARY KEY (OgrNo, DersNo, DonemNo, Yil),
    FOREIGN KEY (DersNo, DonemNo, Yil) REFERENCES DONEM (DersNo, DonemNo, Yil) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (OgrNo) REFERENCES OGRENCI (OgrNo) ON DELETE CASCADE ON UPDATE NO ACTION
);

--ÖÐRETÝM ELEMANLARI DERS ETKÝNLÝÐÝ TABLOSU
CREATE TABLE AKADERS
(
    AkaDersNo NVARCHAR (11) ,
    DersNo    NVARCHAR (10) ,
    DonemNo   NVARCHAR (10) ,
    Yil       NUMERIC (4, 0),
    PRIMARY KEY (AkaDersNo, DersNo, DonemNo, Yil),
    FOREIGN KEY (DersNo, DonemNo, Yil) REFERENCES DONEM (DersNo, DonemNo, Yil) ON DELETE CASCADE ON UPDATE NO ACTION,
    FOREIGN KEY (AkaDersNo) REFERENCES AKADEMISYEN (AkaNo) ON DELETE CASCADE ON UPDATE NO ACTION
);

--ÖN KOÞUL TABLOSU
CREATE TABLE ONKOSUL
(
    OnKosulDersNo NVARCHAR (10),
    DersNo        NVARCHAR (10),
    PRIMARY KEY (DersNo, OnKosulDersNo),
    FOREIGN KEY (DersNo) REFERENCES Ders (DersNo) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (OnKosulDersNo) REFERENCES Ders (DersNo) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-------------------------ÖRNEK VERÝLER----------------------------------
SET IDENTITY_INSERT FAKULTE ON; --IDENTITY deðerlerini biz belirleyelim
INSERT  FAKULTE (FNo, Ad, Konum) VALUES (100, N'MÜHENDÝSLÝK', N'MERKEZ');
INSERT  FAKULTE (FNo, Ad, Konum) VALUES (200, N'EÐÝTÝM', N'A KAMPÜS');
SET IDENTITY_INSERT FAKULTE OFF;

SET IDENTITY_INSERT BOLUM ON;
INSERT  BOLUM (BNo, Ad, FNo) VALUES (10, N'BÝLGÝSAYAR', 100);
INSERT  BOLUM (BNo, Ad, FNo) VALUES (20, N'MAKÝNE', 100);
INSERT  BOLUM (BNo, Ad, FNo) VALUES (30, N'BÖTE', 200);
INSERT  BOLUM (BNo, Ad, FNo) VALUES (40, N'MATEMATÝK', 200);
INSERT  BOLUM (BNo, Ad, FNo) VALUES (50, N'ELEKTRONÝK', 100);
SET IDENTITY_INSERT BOLUM OFF;

INSERT  OGRENCI (OgrNo, Ad, Soyad, DTar, Cins, Foto, Harc, GNO, BNo)
VALUES         (N'1020001', N'BUSE NUR', N'ÇETÝN', CAST (N'2004-01-01' AS DATE), 0, NULL, 300, 2.46, 10);
INSERT  OGRENCI (OgrNo, Ad, Soyad, DTar, Cins, Foto, Harc, GNO, BNo)
VALUES         (N'1020002', N'BÝRCAN', N'ÇETMEN', CAST (N'2005-01-02' AS DATE), 0, NULL, 150, 2.25, 10);
INSERT  OGRENCI (OgrNo, Ad, Soyad, DTar, Cins, Foto, Harc, GNO, BNo)
VALUES         (N'1020003', N'SERHAN', N'NARLI', CAST (N'2006-03-02' AS DATE), 1, NULL, NULL, 3.4, 10);
INSERT  OGRENCI (OgrNo, Ad, Soyad, DTar, Cins, Foto, Harc, GNO, BNo)
VALUES         (N'1020004', N'TUÐÇE', N'DEMÝR', CAST (N'2006-01-02' AS DATE), 0, NULL, 250, 2.32, 10);
INSERT  OGRENCI (OgrNo, Ad, Soyad, DTar, Cins, Foto, Harc, GNO, BNo)
VALUES         (N'2010003', N'AHMET', N'KARA', CAST (N'2001-01-01' AS DATE), 1, NULL, 550, 2.55, 20);
INSERT  OGRENCI (OgrNo, Ad, Soyad, DTar, Cins, Foto, Harc, GNO, BNo)
VALUES         (N'3020004', N'FATÝH', N'DAÞDEMÝR', CAST (N'2000-01-01' AS DATE), 1, NULL, 600, 3.06, 30);
INSERT  OGRENCI (OgrNo, Ad, Soyad, DTar, Cins, Foto, Harc, GNO, BNo)
VALUES         (N'3020005', N'AHMET', N'DEMÝR', CAST (N'1998-01-01' AS DATE), 1, NULL, 600, 2.2, 30);
INSERT  OGRENCI (OgrNo, Ad, Soyad, DTar, Cins, Foto, Harc, GNO, BNo)
VALUES         (N'4010001', N'ALÝ', N'OKUR', CAST (N'2005-03-05' AS DATE), 1, NULL, 0, 2.22, 40);
INSERT  OGRENCI (OgrNo, Ad, Soyad, DTar, Cins, Foto, Harc, GNO, BNo)
VALUES         (N'5020001', N'VELÝ', N'YAZAR', CAST (N'2005-08-08' AS DATE), 1, NULL, 100, 1.98, 50);

INSERT  AKADEMISYEN (AkaNo, Ad, Soyad, Unvan, Maas, BNo)
VALUES             (N'10001', N'YAÞAR', N'DAÞDEMÝR', N'DR.', 3000, 10);
INSERT  AKADEMISYEN (AkaNo, Ad, Soyad, Unvan, Maas, BNo)
VALUES             (N'10002', N'YAKUP', N'HAMEÞ', N'PROF.DR.', 6000, 50);
INSERT  AKADEMISYEN (AkaNo, Ad, Soyad, Unvan, Maas, BNo)
VALUES             (N'10003', N'YAKUP', N'KUTLU', N'DOÇ.DR.', 5000, 10);
INSERT  AKADEMISYEN (AkaNo, Ad, Soyad, Unvan, Maas, BNo)
VALUES             (N'10004', N'FATÝH', N'BALABAN', N'DR.', 3000, 30);
INSERT  AKADEMISYEN (AkaNo, Ad, Soyad, Unvan, Maas, BNo)
VALUES             (N'10005', N'KAAN', N'BALTA', N'DOÇ.DR', 4500, 20);
INSERT  AKADEMISYEN (AkaNo, Ad, Soyad, Unvan, Maas, BNo)
VALUES             (N'10006', N'SERTAN', N'ALTAN', N'DOÇ.DR', 4000, 40);

INSERT  DANISMAN (AkaNo, OgrNo) VALUES(N'10001', N'1020001');
INSERT  DANISMAN (AkaNo, OgrNo) VALUES(N'10001', N'1020002');
INSERT  DANISMAN (AkaNo, OgrNo) VALUES(N'10003', N'1020004');
INSERT  DANISMAN (AkaNo, OgrNo) VALUES(N'10002', N'5020001');

INSERT  DERS (DersNo, Ad, Teo, Uyg, Krd, AKTS, BNo)
VALUES      (N'B001', N'DBMS', 3, 1, 4, 8, 10);
INSERT  DERS (DersNo, Ad, Teo, Uyg, Krd, AKTS, BNo)
VALUES      (N'B002', N'OTOMATLAR', 3, 0, 3, 6, 10);
INSERT  DERS (DersNo, Ad, Teo, Uyg, Krd, AKTS, BNo)
VALUES      (N'E001', N'DEVRELER', 3, 1, 4, 8, 50);
INSERT  DERS (DersNo, Ad, Teo, Uyg, Krd, AKTS, BNo)
VALUES      (N'M001', N'MATEMATÝK', 3, 0, 3, 5, 40);

INSERT  DONEM (DersNo, DonemNo, DonemAd, Yil, Sube)
VALUES       (N'B001', N'1', N'GÜZ', CAST (2016 AS NUMERIC (4, 0)), N'3');
INSERT  DONEM (DersNo, DonemNo, DonemAd, Yil, Sube)
VALUES       (N'B001', N'2', N'GÜZ', CAST (2017 AS NUMERIC (4, 0)), N'3');
INSERT  DONEM (DersNo, DonemNo, DonemAd, Yil, Sube)
VALUES    (N'E001', N'3', N'BAHAR', CAST (2016 AS NUMERIC (4, 0)), N'2');
INSERT  DONEM (DersNo, DonemNo, DonemAd, Yil, Sube)
VALUES       (N'M001', N'3', N'GÜZ', CAST (2019 AS NUMERIC (4, 0)), N'1');
INSERT  DONEM (DersNo, DonemNo, DonemAd, Yil, Sube)
VALUES    (N'B002', N'2', N'BAHAR', CAST (2020 AS NUMERIC (4, 0)), N'2');

INSERT  AKADERS (AkaDersNo, DersNo, DonemNo, Yil)
VALUES         (N'10001', N'B001', N'1', CAST (2016 AS NUMERIC (4, 0)));
INSERT  AKADERS (AkaDersNo, DersNo, DonemNo, Yil)
VALUES         (N'10001', N'B001', N'2', CAST (2017 AS NUMERIC (4, 0)));
INSERT  AKADERS (AkaDersNo, DersNo, DonemNo, Yil)
VALUES         (N'10002', N'E001', N'3', CAST (2016 AS NUMERIC (4, 0)));
INSERT  AKADERS (AkaDersNo, DersNo, DonemNo, Yil)
VALUES         (N'10006', N'M001', N'3', CAST (2019 AS NUMERIC (4, 0)));

INSERT  OGRNOT (OgrNo, DersNo, DonemNo, Yil, Vize, Final, But, Harf)
VALUES        (N'1020001', N'B001', N'1', CAST (2016 AS NUMERIC (4, 0)), 66, 70, NULL, N'BB');
INSERT  OGRNOT (OgrNo, DersNo, DonemNo, Yil, Vize, Final, But, Harf)
VALUES        (N'5020001', N'E001', N'3', CAST (2016 AS NUMERIC (4, 0)), 50, 35, 80, N'CB');
INSERT  OGRNOT (OgrNo, DersNo, DonemNo, Yil, Vize, Final, But, Harf)
VALUES        (N'4010001', N'M001', N'3', CAST (2019 AS NUMERIC (4, 0)), 30, 55, 85, N'CC');
INSERT  OGRNOT (OgrNo, DersNo, DonemNo, Yil, Vize, Final, But, Harf)
VALUES        (N'1020001', N'B002', N'2', CAST (2020 AS NUMERIC (4, 0)), 80, 90, NULL, N'BA');

INSERT  ONKOSUL (OnKosulDersNo, DersNo) VALUES (N'B001', N'B002');
INSERT  ONKOSUL (OnKosulDersNo, DersNo) VALUES (N'B001', N'M001');
INSERT  ONKOSUL (OnKosulDersNo, DersNo) VALUES (N'B002', N'M001');
