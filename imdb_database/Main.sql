--Oblig 5

--Oppgåve 1
--(Blank er ikkje med)
SELECT filmcharacter, COUNT(*) FROM Filmcharacter
WHERE filmcharacter != ''
GROUP BY filmcharacter
HAVING COUNT(*) > 2000
ORDER BY COUNT(*) DESC;

--Oppgåve 2
--a INNER JOIN
SELECT title, prodyear FROM Film f
JOIN FilmParticipation fp
      ON f.filmid = fp.filmid
JOIN Person p
      ON fp.personid = p.personid
WHERE parttype = 'director' AND firstname = 'Stanley' AND lastname = 'Kubrick';
--b NATURAL JOIN
SELECT title, prodyear FROM Film
NATURAL JOIN FilmParticipation
NATURAL JOIN Person
WHERE parttype = 'director' AND firstname = 'Stanley' AND lastname = 'Kubrick';
--c Implisitt
SELECT title, prodyear FROM Film f, FilmParticipation fp, Person p
WHERE f.filmid = fp.filmid AND fp.personid = p.personid
AND parttype = 'director' AND firstname = 'Stanley' AND lastname = 'Kubrick';

--Oppgåve 3
SELECT p.personid, CONCAT(firstname, ' ', lastname) AS full_name, title, country FROM Person p
NATURAL JOIN FilmParticipation fp
NATURAL JOIN FilmCharacter fchar
NATURAL JOIN Film f
NATURAL JOIN FilmCountry fcount
WHERE firstname = 'Ingrid' AND filmcharacter LIKE 'Ingrid';

--Oppgåve 4
SELECT f.filmid, title, COUNT(genre) FROM Film f
LEFT JOIN FilmGenre fg
     ON f.filmid = fg.filmid
WHERE title LIKE '%Antoine %'
GROUP BY f.filmid, title;

--Oppgåve 5
SELECT title, parttype, COUNT(*) FROM Film f
NATURAL JOIN FilmItem fi
NATURAL JOIN FilmParticipation fp
WHERE filmtype = 'C' AND title LIKE '%Lord of the Rings%'
GROUP BY title, parttype;

--Oppgåve 6
SELECT title, prodyear FROM Film
WHERE prodyear IN (SELECT MIN(prodyear) FROM Film);

--Oppgåve 7
SELECT title, prodyear FROM Film
NATURAL JOIN FilmGenre fg
WHERE genre = 'Film-Noir'
      AND EXISTS (
      	  SELECT * FROM FilmGenre fgSub
	  WHERE fgSub.filmid = fg.filmid AND genre = 'Comedy'
      );

--Oppgåve 8
SELECT title, prodyear FROM Film
WHERE prodyear IN (SELECT MIN(prodyear) FROM Film)
UNION ALL
SELECT title, prodyear FROM Film
NATURAL JOIN FilmGenre fg
WHERE genre = 'Film-Noir'
      AND EXISTS (
      	  SELECT * FROM FilmGenre fgSub
      	  WHERE fgSub.filmid = fg.filmid AND genre = 'Comedy'
      );

--Oppgåve 9
SELECT title, prodyear FROM Film f
NATURAL JOIN FilmParticipation fp
NATURAL JOIN Person p
WHERE firstname = 'Stanley' AND lastname = 'Kubrick' AND parttype = 'director'
      AND EXISTS (
      	  SELECT * FROM FilmParticipation fpSub
	  NATURAL JOIN Person pSub
	  WHERE fpSub.filmid = fp.filmid AND pSub.personid = p.personid
	  AND parttype = 'cast'
      );

--Oppgåve 10
WITH SeriesRating (seriesid, maintitle, rank) AS (
     SELECT seriesid, maintitle, rank FROM Series s
     JOIN FilmRating fr
     	  ON s.seriesid = fr.filmid
     WHERE votes > 1000
)
SELECT maintitle FROM SeriesRating
WHERE rank IN (SELECT MAX(rank) FROM SeriesRating);

--Oppgåve 11
SELECT country FROM FilmCountry
GROUP BY country
HAVING COUNT(*) = 1;

--Oppgåve 12
SELECT firstname, lastname, COUNT(*) FROM Person p
NATURAL JOIN FilmParticipation fp
NATURAL JOIN FilmCharacter fc
WHERE filmcharacter IN (
  SELECT filmcharacter
  FROM FilmCharacter
  GROUP BY FilmCharacter
  HAVING COUNT(*) = 1)
GROUP BY firstname, lastname
HAVING COUNT(*) > 200;

--Oppgåve 13
SELECT firstname, lastname FROM Person p
NATURAL JOIN FilmParticipation fp
NATURAL JOIN FilmRating fr
WHERE votes > 60000 AND parttype = 'director'
GROUP BY firstname, lastname
HAVING MIN(rank) >= 8;
