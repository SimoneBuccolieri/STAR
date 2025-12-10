--Piloti con il maggior numero di modelli di aereo abilitati
SELECT 
    p.id_personale,
    p.nome,
    p.cognome,
    COUNT(a.codice_modello) AS numero_modelli
FROM star.Personale p
JOIN star.Pilota pl ON p.id_personale = pl.id_personale
JOIN star.AbilitazioneVolo a ON pl.id_personale = a.id_personale
GROUP BY p.id_personale, p.nome, p.cognome
ORDER BY numero_modelli DESC;

--Aeroporti con più traffico totale (arrivi + partenze)
SELECT 
    a.codice_IATA,
    a.nome,
    COUNT(v1.id_volo) AS partenze,
    COUNT(v2.id_volo) AS arrivi,
    COUNT(v1.id_volo) + COUNT(v2.id_volo) AS traffico_totale
FROM star.Aeroporto a
LEFT JOIN star.Volo v1 ON v1.aeroporto_partenza = a.codice_IATA
LEFT JOIN star.Volo v2 ON v2.aeroporto_arrivo = a.codice_IATA
GROUP BY a.codice_IATA, a.nome
ORDER BY traffico_totale DESC;

--Compagnie con il numero totale di aerei posseduti
SELECT 
    c.codice_compagnia,
    c.nome,
    COUNT(p.matricola) AS numero_aerei
FROM star.CompagniaAerea c
JOIN star.Possesso p ON c.codice_compagnia = p.codice_compagnia
GROUP BY c.codice_compagnia, c.nome
HAVING COUNT(p.matricola) > 1
ORDER BY numero_aerei DESC;

--Velocità media reale di ogni volo con almeno due rilevazioni GPS
SELECT 
    v.id_volo,
    v.codice_volo,
    AVG(l.velocita) AS velocita_media
FROM star.Volo v
JOIN star.LogGPS l ON v.id_volo = l.id_volo
GROUP BY v.id_volo, v.codice_volo
HAVING COUNT(l.timestamp_rilevazione) >= 2
ORDER BY velocita_media DESC;

--Aerei più utilizzati: totale ore di volo reali per aereo
SELECT
    a.matricola,
    t.codice_modello,
    EXTRACT(EPOCH FROM (MAX(l.timestamp_rilevazione) - MIN(l.timestamp_rilevazione))) / 3600
        AS ore_volo_registrate
FROM Aereo a
JOIN star.TipoAereo t ON a.codice_modello = t.codice_modello
JOIN star.LogGPS l ON l.id_volo IN (
    SELECT id_volo FROM star.Volo WHERE matricola = a.matricola
)
GROUP BY a.matricola, t.codice_modello
ORDER BY ore_volo_registrate DESC;

--indice per query 2
CREATE INDEX idx_volo_partenza ON star.Volo(aeroporto_partenza);
CREATE INDEX idx_volo_arrivo ON star.Volo(aeroporto_arrivo);
