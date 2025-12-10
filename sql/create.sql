CREATE SCHEMA star;

SET
    search_path TO star;

CREATE TABLE
    Aeroporto (
        codice_IATA CHAR(3) PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        citta VARCHAR(100) NOT NULL,
        nazione VARCHAR(100) NOT NULL,
        coordinate POINT NOT NULL,
        numero_piste INTEGER NOT NULL CHECK (numero_piste >= 0),
        numero_voli_giornalieri INTEGER NOT NULL DEFAULT 0 CHECK (numero_voli_giornalieri >= 0)
    );

CREATE TABLE
    HubInternazionale (
        codice_IATA CHAR(3) PRIMARY KEY,
        numero_terminal INTEGER NOT NULL CHECK (numero_terminal >= 0),
        CONSTRAINT fk_hub_aeroporto FOREIGN KEY (codice_IATA) REFERENCES Aeroporto (codice_IATA) ON DELETE CASCADE
    );

CREATE TABLE
    Regionale (
        codice_IATA CHAR(3) PRIMARY KEY,
        lunghezza_max_pista INTEGER NOT NULL CHECK (lunghezza_max_pista > 0),
        notturno BOOLEAN NOT NULL,
        CONSTRAINT fk_regionale_aeroporto FOREIGN KEY (codice_IATA) REFERENCES Aeroporto (codice_IATA) ON DELETE CASCADE
    );

CREATE TABLE
    BaseMilitare (
        codice_IATA CHAR(3) PRIMARY KEY,
        codice_NATO VARCHAR(10) NOT NULL,
        livello_sicurezza INTEGER NOT NULL,
        CONSTRAINT fk_basem_aeroporto FOREIGN KEY (codice_IATA) REFERENCES Aeroporto (codice_IATA) ON DELETE CASCADE
    );

CREATE TABLE
    ProtocolloSicurezza (
        id_protocollo SERIAL PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        descrizione TEXT
    );

CREATE TABLE
    Applica (
        codice_IATA CHAR(3) NOT NULL,
        id_protocollo INTEGER NOT NULL,
        data_inizio DATE NOT NULL,
        PRIMARY KEY (codice_IATA, id_protocollo, data_inizio),
        CONSTRAINT fk_applica_base FOREIGN KEY (codice_IATA) REFERENCES BaseMilitare (codice_IATA) ON DELETE CASCADE,
        CONSTRAINT fk_applica_protocollo FOREIGN KEY (id_protocollo) REFERENCES ProtocolloSicurezza (id_protocollo) ON DELETE CASCADE
    );

CREATE TABLE
    Gate (
        codice_hub CHAR(3) NOT NULL,
        numero_gate INTEGER NOT NULL CHECK (numero_gate > 0),
        piano INTEGER NOT NULL,
        tunnel BOOL NOT NULL,
        PRIMARY KEY (codice_hub, numero_gate),
        CONSTRAINT fk_gate_hub FOREIGN KEY (codice_hub) REFERENCES HubInternazionale (codice_IATA) ON DELETE CASCADE
    );

CREATE TABLE
    TipoAereo (
        codice_modello VARCHAR(20) PRIMARY KEY,
        costruttore VARCHAR(100) NOT NULL,
        autonomia INTEGER NOT NULL CHECK (autonomia > 0),
        velocita_crociera INTEGER NOT NULL CHECK (velocita_crociera > 0)
    );

CREATE TABLE
    DivietoOperativo (
        codice_IATA CHAR(3) NOT NULL,
        codice_modello VARCHAR(20) NOT NULL,
        PRIMARY KEY (codice_IATA, codice_modello),
        CONSTRAINT fk_divieto_regionale FOREIGN KEY (codice_IATA) REFERENCES Regionale (codice_IATA) ON DELETE CASCADE,
        CONSTRAINT fk_divieto_tipoAereo FOREIGN KEY (codice_modello) REFERENCES TipoAereo (codice_modello) ON DELETE CASCADE
    );

CREATE TABLE
    Componente (
        codice_modello VARCHAR(20) NOT NULL,
        numero_parte INTEGER NOT NULL,
        descrizione VARCHAR(50),
        PRIMARY KEY (codice_modello, numero_parte),
        CONSTRAINT fk_comp_tipoaereo FOREIGN KEY (codice_modello) REFERENCES TipoAereo (codice_modello) ON DELETE CASCADE
    );

CREATE TABLE
    Aereo (
        matricola VARCHAR(20) PRIMARY KEY,
        data_immatricolazione DATE NOT NULL,
        ore_volo_accumulate INTEGER DEFAULT 0 CHECK (ore_volo_accumulate >= 0),
        codice_modello VARCHAR(20) NOT NULL,
        CONSTRAINT fk_aereo_tipo FOREIGN KEY (codice_modello) REFERENCES TipoAereo (codice_modello) ON DELETE RESTRICT
    );

CREATE TABLE
    AereoDiLinea (
        matricola VARCHAR(20) PRIMARY KEY,
        wifi BOOL NOT NULL,
        intrattenimento VARCHAR(100),
        CONSTRAINT fk_linea_aereo FOREIGN KEY (matricola) REFERENCES Aereo (matricola) ON DELETE CASCADE
    );

CREATE TABLE
    AereoCargo (
        matricola VARCHAR(20) PRIMARY KEY,
        peso_carico_max INTEGER NOT NULL CHECK (peso_carico_max > 0),
        CONSTRAINT fk_cargo_aereo FOREIGN KEY (matricola) REFERENCES Aereo (matricola) ON DELETE CASCADE
    );

CREATE TABLE
    AereoPrivato (
        matricola VARCHAR(20) PRIMARY KEY,
        proprietario VARCHAR(100) NOT NULL,
        servizi_inclusi TEXT,
        CONSTRAINT fk_privato_aereo FOREIGN KEY (matricola) REFERENCES Aereo (matricola) ON DELETE CASCADE
    );

CREATE TABLE
    AereoMilitare (
        matricola VARCHAR(20) PRIMARY KEY,
        codice_missione VARCHAR(50),
        ente_operativo VARCHAR(20) NOT NULL,
        CONSTRAINT fk_militare_aereo FOREIGN KEY (matricola) REFERENCES Aereo (matricola) ON DELETE CASCADE
    );

CREATE TABLE
    CompagniaAerea (
        codice_compagnia VARCHAR(10) PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        nazione VARCHAR(100) NOT NULL,
        sito_web VARCHAR(255)
    );

CREATE TABLE
    Possesso (
        codice_compagnia VARCHAR(10) NOT NULL,
        matricola VARCHAR(20) NOT NULL,
        PRIMARY KEY (codice_compagnia, matricola),
        CONSTRAINT fk_poss_compagnia FOREIGN KEY (codice_compagnia) REFERENCES CompagniaAerea (codice_compagnia) ON DELETE CASCADE,
        CONSTRAINT fk_poss_aereo FOREIGN KEY (matricola) REFERENCES Aereo (matricola) ON DELETE CASCADE
    );

CREATE TABLE
    AssegnazioneGate (
        codice_compagnia VARCHAR(10) NOT NULL,
        codice_hub CHAR(3) NOT NULL,
        numero_gate INTEGER NOT NULL,
        PRIMARY KEY (codice_compagnia, codice_hub, numero_gate),
        CONSTRAINT fk_assg_compagnia FOREIGN KEY (codice_compagnia) REFERENCES CompagniaAerea (codice_compagnia) ON DELETE CASCADE,
        CONSTRAINT fk_assg_gate FOREIGN KEY (codice_hub, numero_gate) REFERENCES Gate (codice_hub, numero_gate) ON DELETE CASCADE
    );

CREATE TABLE
    Personale (
        id_personale SERIAL PRIMARY KEY,
        nome VARCHAR(50) NOT NULL,
        cognome VARCHAR(50) NOT NULL,
        data_nascita DATE NOT NULL,
        data_assunzione DATE
    );

CREATE TABLE
    Pilota (
        id_personale INTEGER PRIMARY KEY,
        numero_licenza VARCHAR(50) NOT NULL,
        ore_volo INTEGER NOT NULL,
        ultima_visita DATE NOT NULL,
        CONSTRAINT fk_pilota_personale FOREIGN KEY (id_personale) REFERENCES Personale (id_personale) ON DELETE CASCADE
    );

CREATE TABLE
    ControlloreVolo (
        id_personale INTEGER PRIMARY KEY,
        livello_certificazione VARCHAR(50),
        scadenza_abilitazione DATE NOT NULL,
        CONSTRAINT fk_ctrl_personale FOREIGN KEY (id_personale) REFERENCES Personale (id_personale) ON DELETE CASCADE
    );

CREATE TABLE
    Manutentore (
        id_personale INTEGER PRIMARY KEY,
        qualifica VARCHAR(100) NOT NULL,
        CONSTRAINT fk_manut_personale FOREIGN KEY (id_personale) REFERENCES Personale (id_personale) ON DELETE CASCADE
    );

CREATE TABLE
    AbilitazioneVolo (
        id_personale INTEGER NOT NULL,
        codice_modello VARCHAR(20) NOT NULL,
        data_conseguimento DATE NOT NULL,
        data_scadenza DATE NOT NULL,
        PRIMARY KEY (id_personale, codice_modello),
        CONSTRAINT fk_abil_pilota FOREIGN KEY (id_personale) REFERENCES Pilota (id_personale) ON DELETE CASCADE,
        CONSTRAINT fk_abil_modello FOREIGN KEY (codice_modello) REFERENCES TipoAereo (codice_modello) ON DELETE CASCADE,
        CONSTRAINT ck_abil_date CHECK (data_scadenza >= data_conseguimento)
    );

CREATE TABLE
    RottaPianificata (
        id_rotta SERIAL PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        distanza INTEGER NOT NULL CHECK (distanza > 0),
        durata_stimata INTEGER NOT NULL CHECK (durata_stimata > 0),
        consumo_previsto INTEGER NOT NULL CHECK (consumo_previsto > 0),
        aeroporto_origine CHAR(3) NOT NULL,
        aeroporto_destinazione CHAR(3) NOT NULL,
        CONSTRAINT fk_rotta_origine FOREIGN KEY (aeroporto_origine) REFERENCES Aeroporto (codice_IATA) ON DELETE RESTRICT,
        CONSTRAINT fk_rotta_dest FOREIGN KEY (aeroporto_destinazione) REFERENCES Aeroporto (codice_IATA) ON DELETE RESTRICT,
        CONSTRAINT ck_rotta_verso CHECK (aeroporto_origine <> aeroporto_destinazione)
    );

CREATE TABLE
    FasciaOraria (
        id_slot SERIAL PRIMARY KEY,
        codice_IATA CHAR(3) NOT NULL,
        ora_inizio TIME NOT NULL,
        ora_fine TIME NOT NULL,
        tipologia VARCHAR(20) NOT NULL,
        CONSTRAINT fk_fascia_aeroporto FOREIGN KEY (codice_IATA) REFERENCES Aeroporto (codice_IATA) ON DELETE CASCADE,
        CONSTRAINT ck_fascia_ora CHECK (ora_fine > ora_inizio)
    );

CREATE TABLE
    Volo (
        id_volo SERIAL PRIMARY KEY,
        codice_volo VARCHAR(20) NOT NULL,
        data_ora_programmata TIMESTAMPTZ NOT NULL,
        data_ora_effettiva TIMESTAMPTZ,
        stato VARCHAR(30) NOT NULL,
        peso_totale_carico INTEGER DEFAULT 0 CHECK (peso_totale_carico >= 0),
        matricola VARCHAR(20) NOT NULL,
        aeroporto_partenza CHAR(3) NOT NULL,
        aeroporto_arrivo CHAR(3) NOT NULL,
        id_rotta INTEGER,
        slot_decollo INTEGER,
        slot_atterraggio INTEGER,
        CONSTRAINT fk_volo_aereo FOREIGN KEY (matricola) REFERENCES Aereo (matricola) ON DELETE RESTRICT,
        CONSTRAINT fk_volo_dep FOREIGN KEY (aeroporto_partenza) REFERENCES Aeroporto (codice_IATA) ON DELETE RESTRICT,
        CONSTRAINT fk_volo_arr FOREIGN KEY (aeroporto_arrivo) REFERENCES Aeroporto (codice_IATA) ON DELETE RESTRICT,
        CONSTRAINT fk_volo_rotta FOREIGN KEY (id_rotta) REFERENCES RottaPianificata (id_rotta) ON DELETE SET NULL,
        CONSTRAINT fk_volo_fascia_dec FOREIGN KEY (slot_decollo) REFERENCES FasciaOraria (id_slot) ON DELETE SET NULL,
        CONSTRAINT fk_volo_fascia_att FOREIGN KEY (slot_atterraggio) REFERENCES FasciaOraria (id_slot) ON DELETE SET NULL,
        CONSTRAINT ck_volo_aeroporti CHECK (aeroporto_partenza <> aeroporto_arrivo)
    );

CREATE TABLE
    Equipaggio (
        id_personale INTEGER NOT NULL,
        id_volo INTEGER NOT NULL,
        ruolo VARCHAR(50) NOT NULL,
        ore_servizio INTEGER NOT NULL,
        PRIMARY KEY (id_personale, id_volo),
        CONSTRAINT fk_equip_volo FOREIGN KEY (id_volo) REFERENCES Volo (id_volo) ON DELETE CASCADE,
        CONSTRAINT fk_equip_personale FOREIGN KEY (id_personale) REFERENCES Personale (id_personale) ON DELETE RESTRICT
    );

CREATE TABLE
    Monitoraggio (
        id_personale INTEGER NOT NULL,
        id_volo INTEGER NOT NULL,
        fase_volo VARCHAR(30) NOT NULL,
        PRIMARY KEY (id_personale, id_volo),
        CONSTRAINT fk_mon_ctrl FOREIGN KEY (id_personale) REFERENCES ControlloreVolo (id_personale) ON DELETE CASCADE,
        CONSTRAINT fk_mon_volo FOREIGN KEY (id_volo) REFERENCES Volo (id_volo) ON DELETE CASCADE
    );

CREATE TABLE
    Presidio (
        id_personale INTEGER NOT NULL,
        codice_IATA VARCHAR(3) NOT NULL,
        data_inizio TIMESTAMPTZ NOT NULL,
        data_fine TIMESTAMPTZ,
        settore VARCHAR(30) NOT NULL,
        PRIMARY KEY (id_personale, codice_IATA, data_inizio),
        CONSTRAINT fk_presidio_ctrl FOREIGN KEY (id_personale) REFERENCES ControlloreVolo (id_personale) ON DELETE CASCADE,
        CONSTRAINT fk_presidio_settore FOREIGN KEY (codice_IATA) REFERENCES Aeroporto (codice_IATA) ON DELETE CASCADE,
        CONSTRAINT ck_presidio_date CHECK (
            data_fine IS NULL
            OR data_fine >= data_inizio
        )
    );

CREATE TABLE
    Container (
        codice_container VARCHAR(30) PRIMARY KEY,
        peso_tara INTEGER NOT NULL CHECK (peso_tara > 0),
        tipologia VARCHAR(30) NOT NULL
    );

CREATE TABLE
    ImbarcoMerce (
        id_volo INTEGER NOT NULL,
        codice_container VARCHAR(30) NOT NULL,
        peso_registrato INTEGER NOT NULL CHECK (peso_registrato >= 0),
        data_imbarco DATE NOT NULL,
        contenuto TEXT,
        PRIMARY KEY (id_volo, codice_container),
        CONSTRAINT fk_imbarco_volo FOREIGN KEY (id_volo) REFERENCES Volo (id_volo) ON DELETE CASCADE,
        CONSTRAINT fk_imbarco_container FOREIGN KEY (codice_container) REFERENCES Container (codice_container) ON DELETE RESTRICT
    );

CREATE TABLE
    ClassePasseggeri (
        id_classe SERIAL PRIMARY KEY,
        nome_commerciale VARCHAR(50) NOT NULL,
        priorita_imbarco INTEGER DEFAULT 0,
        descrizione TEXT
    );

CREATE TABLE
    Configurazione (
        matricola VARCHAR(20) NOT NULL,
        id_classe INTEGER NOT NULL,
        numero_posti INTEGER NOT NULL CHECK (numero_posti >= 0),
        spazio_gambe INTEGER NOT NULL CHECK (spazio_gambe >= 0),
        PRIMARY KEY (matricola, id_classe),
        CONSTRAINT fk_config_aereo FOREIGN KEY (matricola) REFERENCES AereoDiLinea (matricola) ON DELETE CASCADE,
        CONSTRAINT fk_config_classe FOREIGN KEY (id_classe) REFERENCES ClassePasseggeri (id_classe) ON DELETE CASCADE
    );

CREATE TABLE
    ServizioAggiuntivo (
        id_classe INTEGER NOT NULL,
        nome_servizio VARCHAR(100) NOT NULL,
        descrizione TEXT,
        PRIMARY KEY (id_classe, nome_servizio),
        CONSTRAINT fk_serv_classe FOREIGN KEY (id_classe) REFERENCES ClassePasseggeri (id_classe) ON DELETE CASCADE
    );

CREATE TABLE
    LogGPS (
        id_volo INTEGER NOT NULL,
        timestamp_rilevazione TIMESTAMPTZ NOT NULL,
        latitudine NUMERIC(9, 6) NOT NULL,
        longitudine NUMERIC(9, 6) NOT NULL,
        altitudine NUMERIC(10, 2) NOT NULL,
        velocita NUMERIC(10, 2) NOT NULL,
        PRIMARY KEY (id_volo, timestamp_rilevazione),
        CONSTRAINT fk_loggps_volo FOREIGN KEY (id_volo) REFERENCES Volo (id_volo) ON DELETE CASCADE
    );

CREATE TABLE
    LogDatiVolo (
        id_volo INTEGER NOT NULL,
        timestamp_rilevazione TIMESTAMPTZ NOT NULL,
        altitudine NUMERIC(10, 2) NOT NULL,
        velocita NUMERIC(10, 2) NOT NULL,
        livello_carburante NUMERIC(10, 2) NOT NULL,
        pressione NUMERIC(10, 2) NOT NULL,
        temperatura NUMERIC(10, 2) NOT NULL,
        PRIMARY KEY (id_volo, timestamp_rilevazione),
        CONSTRAINT fk_logdati_volo FOREIGN KEY (id_volo) REFERENCES Volo (id_volo) ON DELETE CASCADE
    );

CREATE TABLE
    LogErrori (
        id_volo INTEGER NOT NULL,
        timestamp_rilevazione TIMESTAMPTZ NOT NULL,
        altitudine NUMERIC(10, 2) NOT NULL,
        velocita NUMERIC(10, 2) NOT NULL,
        codice_errore VARCHAR(50) NOT NULL,
        messaggio TEXT,
        severita INTEGER NOT NULL,
        PRIMARY KEY (id_volo, timestamp_rilevazione),
        CONSTRAINT fk_logerr_volo FOREIGN KEY (id_volo) REFERENCES Volo (id_volo) ON DELETE CASCADE
    );

CREATE TABLE
    GestioneAlert (
        id_personale INTEGER NOT NULL,
        id_volo INTEGER NOT NULL,
        timestamp_rilevazione TIMESTAMPTZ NOT NULL,
        stato VARCHAR(30) NOT NULL,
        data_presa_carico DATE,
        PRIMARY KEY (id_personale, id_volo, timestamp_rilevazione),
        CONSTRAINT fk_ga_manutentore FOREIGN KEY (id_personale) REFERENCES Manutentore (id_personale) ON DELETE CASCADE,
        CONSTRAINT fk_ga_logerrore FOREIGN KEY (id_volo, timestamp_rilevazione) REFERENCES LogErrori (id_volo, timestamp_rilevazione) ON DELETE CASCADE
    );

CREATE TABLE
    CertificazioneManutenzione (
        id_personale INTEGER NOT NULL,
        matricola VARCHAR(20) NOT NULL,
        data_certificazione DATE NOT NULL,
        data_scadenza DATE NOT NULL,
        PRIMARY KEY (id_personale, matricola, data_certificazione),
        CONSTRAINT fk_cert_manutentore FOREIGN KEY (id_personale) REFERENCES Manutentore (id_personale) ON DELETE CASCADE,
        CONSTRAINT fk_cert_aereo FOREIGN KEY (matricola) REFERENCES Aereo (matricola) ON DELETE CASCADE,
        CONSTRAINT ck_cert_date CHECK (data_scadenza > data_certificazione)
    );