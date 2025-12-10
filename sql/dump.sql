SET search_path TO star;

INSERT INTO Aeroporto VALUES
('FCO','Roma Fiumicino','Roma','Italia','(41.800,-12.238)',3,1200),
('LIN','Milano Linate','Milano','Italia','(45.445,9.276)',2,600),
('BGY','Bergamo Orio','Bergamo','Italia','(45.668,9.700)',2,450),
('CIA','Roma Ciampino','Roma','Italia','(41.799,12.594)',2,350),
('VBT','Base VBT','Novara','Italia','(45.494,8.673)',1,80);

INSERT INTO HubInternazionale VALUES
('FCO',4);

INSERT INTO Regionale VALUES
('LIN',2400,true),
('BGY',2500,true),
('CIA',2100,false);

INSERT INTO BaseMilitare VALUES
('VBT','NATO123',5);

INSERT INTO ProtocolloSicurezza (nome,descrizione) VALUES
('STANDARD','Controlli di sicurezza regolari'),
('ALPHA','Procedure di livello intermedio'),
('OMEGA','Protocollo massimo di sicurezza');

INSERT INTO Applica VALUES
('VBT',1,'2024-01-01'),
('VBT',2,'2024-03-01'),
('VBT',3,'2024-06-01');

INSERT INTO Gate VALUES
('FCO',1,0,true),
('FCO',2,0,false),
('FCO',3,1,true),
('FCO',4,1,false);

INSERT INTO TipoAereo VALUES
('A320','Airbus',6100,840),
('B737','Boeing',5600,820),
('ATR72','ATR',1500,450),
('F16','Lockheed Martin',4200,1500);

INSERT INTO Componente VALUES
('A320',1,'Motore CFM56'),
('A320',2,'Avionica Fly-by-wire'),
('B737',1,'Motore LEAP-1B'),
('ATR72',1,'Sistema navigazione'),
('F16',1,'Radar APG-68');

INSERT INTO DivietoOperativo VALUES
('LIN','F16'),
('CIA','F16');

INSERT INTO Aereo VALUES
('IT100','2020-01-10',1500,'A320'),
('IT200','2019-06-01',3000,'A320'),
('RY300','2015-03-20',8500,'B737'),
('AZ400','2021-07-12',2000,'ATR72'),
('MIL600','2018-02-15',900,'F16');

INSERT INTO AereoDiLinea VALUES
('IT100',true,'Film, musica, TV'),
('IT200',true,'Musica, mappe interattive'),
('RY300',false,NULL),
('AZ400',false,NULL);

INSERT INTO AereoCargo VALUES
('AZ400',7500);

INSERT INTO AereoPrivato VALUES
('IT200','VIP Services S.p.A','Catering premium, lounge privata');

INSERT INTO AereoMilitare VALUES
('MIL600','INT-01','Aeronautica');

INSERT INTO CompagniaAerea VALUES
('ITA','ITA Airways','Italia','https://ita.it'),
('RYR','Ryanair','Irlanda','https://ryanair.com'),
('AZP','AeroZip','Italia','https://aerozip.com');

INSERT INTO Possesso VALUES
('ITA','IT100'),
('ITA','IT200'),
('RYR','RY300'),
('AZP','AZ400'),
('AZP','MIL600');

INSERT INTO AssegnazioneGate VALUES
('ITA','FCO',1),
('ITA','FCO',2),
('RYR','FCO',3);

INSERT INTO Personale (nome,cognome,data_nascita,data_assunzione) VALUES
('Luca','Bianchi','1980-03-12','2008-05-10'),   -- id 1
('Marco','Verdi','1985-07-21','2010-01-01'),   -- id 2
('Anna','Rossi','1990-01-02','2016-03-01'),    -- id 3
('Paolo','Conti','1975-11-11','2000-09-01'),   -- id 4
('Sara','Neri','1992-08-19','2019-08-10'),     -- id 5
('Giulio','Pini','1988-04-04','2017-10-10');   -- id 6

INSERT INTO Pilota VALUES
(1,'LIC-A320-01',1500,'2024-01-10'),
(2,'LIC-B737-09',3000,'2023-12-01');

INSERT INTO ControlloreVolo VALUES
(3,'LIVELLO2','2025-12-31'),
(4,'LIVELLO3','2025-06-30');

INSERT INTO Manutentore VALUES
(5,'Avionica'),
(6,'Strutture meccaniche');

INSERT INTO AbilitazioneVolo VALUES
(1,'A320','2010-02-02','2030-02-02'),
(2,'B737','2011-03-03','2031-03-03');

INSERT INTO RottaPianificata (nome,distanza,durata_stimata,consumo_previsto,aeroporto_origine,aeroporto_destinazione)
VALUES
('Roma–Milano',570,75,1400,'FCO','LIN'),
('Bergamo–Roma',480,65,1300,'BGY','FCO'),
('Roma–Bergamo',480,60,1350,'CIA','BGY');

INSERT INTO FasciaOraria (codice_IATA,ora_inizio,ora_fine,tipologia) VALUES
('FCO','08:00','08:30','DECOLLO'),
('FCO','10:00','10:30','DECOLLO'),
('LIN','09:00','09:30','ATTERRAGGIO'),
('BGY','11:00','11:30','ATTERRAGGIO');

INSERT INTO Volo (codice_volo,data_ora_programmata,stato,matricola,aeroporto_partenza,aeroporto_arrivo,id_rotta,slot_decollo,slot_atterraggio)
VALUES
('AZ100','2024-02-01 08:15','PROGRAMMATO','IT100','FCO','LIN',1,1,3),
('AZ200','2024-02-01 10:10','PROGRAMMATO','IT200','FCO','BGY',3,2,4),
('RY500','2024-02-01 08:20','PROGRAMMATO','RY300','LIN','BGY',2,NULL,4);

INSERT INTO Equipaggio VALUES
(1,1,'Comandante',5),
(2,1,'Primo Ufficiale',5),
(1,2,'Comandante',4);

INSERT INTO Monitoraggio VALUES
(3,1,'DECOLLO'),
(4,2,'CROCIERA');

INSERT INTO Presidio VALUES
(3,'FCO','2024-01-01 08:00',NULL,'Torre Nord'),
(4,'FCO','2024-01-01 08:00','2024-01-01 16:00','Torre Sud');

INSERT INTO Container VALUES
('C100',200,'Standard'),
('C200',150,'Refrigerato'),
('C300',80,'Posta');

INSERT INTO ImbarcoMerce VALUES
(2,'C100',1500,'2024-02-01','Materiale tecnico'),
(2,'C200',1200,'2024-02-01','Prodotti deperibili'),
(3,'C300',500,'2024-02-01','Posta aerea');

INSERT INTO ClassePasseggeri (nome_commerciale,priorita_imbarco,descrizione) VALUES
('Economy',1,'Classe base'),
('Business',2,'Comfort avanzato'),
('First',3,'Top di gamma');

INSERT INTO Configurazione VALUES
('IT100',1,150,76),
('IT100',2,20,90),
('IT200',1,200,78),
('RY300',1,160,75);

INSERT INTO ServizioAggiuntivo VALUES
(2,'Champagne','Selezione premium'),
(3,'Lounge Privata','Accesso VIP');

INSERT INTO LogGPS VALUES
(1,'2024-02-01 08:20',41.900,-12.300,3000,260),
(1,'2024-02-01 08:40',43.000,10.000,9000,450);

INSERT INTO LogDatiVolo VALUES
(1,'2024-02-01 08:20',3000,260,5000,1010,21),
(1,'2024-02-01 08:40',9000,450,4200,1005,20);

INSERT INTO LogErrori VALUES
(2,'2024-02-01 10:15',5000,430,'WARN01','Pressione anomala',2),
(2,'2024-02-01 10:20',4800,420,'ERR12','Surriscaldamento motore',3);

INSERT INTO GestioneAlert VALUES
(5,2,'2024-02-01 10:20','IN LAVORAZIONE','2024-02-01'),
(6,2,'2024-02-01 10:20','RISOLTO','2024-02-01');

INSERT INTO CertificazioneManutenzione VALUES
(5,'IT100','2024-01-10','2026-01-10'),
(6,'RY300','2024-01-15','2025-01-15');
