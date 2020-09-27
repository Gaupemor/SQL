-- Oblig3 IN2090 Selmafs
-- Har gjeve namn på kolonnane for aggregatverdiar for å gjera resultatet meir leseleg.

-- Oppg. 2
-- a) Timelistelinjer for timelistenr 3
SELECT * FROM Timelistelinje
WHERE timelistenr = 3;
-- b) Tal på timelister
SELECT COUNT(*) ant_timelister FROM Timeliste;
-- c) Tal på timelister som det ikkje har vorte utbeltalt
SELECT COUNT(*) ant_ubetalte FROM Timeliste
WHERE utbetalt IS NULL;
-- d) Tal på timelister per status
SELECT status, COUNT(*) ant_timelister FROM Timeliste
GROUP BY status;
-- e) Tal på timelistelinjer OG tal på timelistelinjer med pauseverdi
SELECT COUNT(*) ant_linjer FROM Timelistelinje;
SELECT COUNT(*) ant_linjer_m_pause FROM Timelistelinje
WHERE pause IS NOT NULL;
-- f) Tal på timelistelinjer uten pauseverdi
SELECT COUNT(*) ant_linjer_u_pause FROM Timelistelinje
WHERE pause IS NULL;

--Oppg. 3
-- a) Tal på timar som ikkje har vorte utbetalt
SELECT SUM(timeantall) ant_ubetalte_timer FROM Timeantall ta
JOIN Timeliste t
  ON ta.timelistenr = t.timelistenr
WHERE utbetalt IS NULL;
-- b) Timelister med linjeskildring som inneheld 'test' - særeigne. timelistenr, beskrivelse
SELECT DISTINCT timelistenr, beskrivelse FROM Timelistelinje
WHERE beskrivelse LIKE '%test%' OR beskrivelse LIKE '%Test%';
-- c) Dei 5 timelistelinjene med lengst varigheit. timelistenr, linjenr, varighet, beskrivelse
SELECT tl.timelistenr, tl.linjenr, varighet, beskrivelse FROM Timelistelinje tl
JOIN Varighet v
  ON tl.timelistenr = v.timelistenr
ORDER BY varighet DESC
LIMIT 5;
-- d) Tal på linjer per timeliste, òg dei med 0 - tok med ORDER BY for leselegheit
SELECT t.timelistenr, COUNT(linjenr) ant_linjer FROM Timeliste t
LEFT JOIN Timelistelinje tl
  ON t.timelistenr = tl.timelistenr
GROUP BY t.timelistenr
ORDER BY t.timelistenr ASC;
-- e) Kor mykje penger som har vorte utbetalt når utbetalinga er 200 kr per time
SELECT SUM(timeantall * 200) total_utbetalt_sum FROM Timeantall ta
JOIN Timeliste t
  ON ta.timelistenr = t.timelistenr
WHERE t.utbetalt IS NOT NULL;
-- f) Tal på linjer som ikkje har pauseverdi per timeliste
SELECT tl.timelistenr, COUNT(*) ant_linjer_u_pause FROM Timelistelinje tl
JOIN Timeliste t
  ON tl.timelistenr = t.timelistenr
WHERE pause IS NULL
GROUP BY tl.timelistenr
HAVING COUNT(*) >= 4;
