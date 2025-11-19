--lab6(Data manipulation, INSERT, UPDATE, DELETE.)
--6.1.(1) INSERT INTO czekoladki (idczekoladki, nazwa, czekolada, orzechy, nadzienie, opis, koszt, masa)
--VALUES ('W98', 'Biały kieł', 'biała', 'laskowe', 'marcepan', 'Rozpływające się w rękach i kieszeniach', 0.45, 20);
--SELECT * FROM czekoladki WHERE idczekoladki = 'W98';

--6.1.(2) INSERT INTO klienci (idklienta, nazwa, ulica, miejscowosc, kod, telefon)
-- VALUES (90, 'Matusiak Edward', 'Kropiwnickiego 6/3', 'Leningrad', '31-471', '031 423 45 38'),
--        (91, 'Matusiak Alina', 'Kropiwnickiego 6/3', 'Leningrad', '31-471', '031 423 45 38'),
--        (92, 'Kimono Franek', 'Karateków 8', 'Mistrz', '30-029', '501 498 324');
-- SELECT *
-- FROM klienci
-- WHERE idklienta >= 90;

--6.1.(3) INSERT INTO klienci (idklienta, nazwa, ulica, miejscowosc, kod, telefon)
-- VALUES (93, 'Iza Matusiak',
--         (SELECT ulica FROM klienci WHERE idklienta = 91),
--         (SELECT miejscowosc FROM klienci WHERE idklienta = 91),
--         (SELECT kod FROM klienci WHERE idklienta = 91),
--         (SELECT telefon FROM klienci WHERE idklienta = 91));
-- SELECT *
-- FROM klienci
-- WHERE idklienta >= 90;

--6.2 INSERT INTO czekoladki (idczekoladki, nazwa, czekolada, orzechy, nadzienie, opis, koszt, masa)
-- VALUES ('X91', 'Nieznana Nieznajoma', NULL, NULL, NULL, 'Niewidzialna czekoladka wspomagajaca odchudzanie.', 0.26, 0),
--        ('M98', 'Mleczny Raj', 'mleczna', NULL, NULL, ' Aksamitna mleczna czekolada w ksztalcie butelki z mlekiem.', 0.26, 36);
-- SELECT *
-- FROM czekoladki
-- WHERE idczekoladki IN ('X91', 'M98');

--6.3 DELETE
-- FROM czekoladki
-- WHERE idczekoladki IN ('X91', 'M98');
-- INSERT INTO czekoladki (idczekoladki, nazwa, czekolada, opis, koszt, masa)
-- VALUES ('X91', 'Nieznana Nieznajoma', NULL, 'Niewidzialna czekoladka wspomagajaca odchudzanie.', 0.26, 0),
--        ('M98', 'Mleczny Raj', 'mleczna', ' Aksamitna mleczna czekolada w ksztalcie butelki z mlekiem.', 0.26, 36);
-- SELECT *
-- FROM czekoladki
-- WHERE idczekoladki IN ('X91', 'M98');
-- UPDATE klienci

--6.4 SET nazwa = 'Iza Nowak'
-- WHERE nazwa = 'Iza Matusiak';
-- select * from klienci where nazwa like '%Iza%';
-- UPDATE czekoladki
-- SET koszt = koszt * 0.9
-- WHERE idczekoladki IN ('W98', 'M98', 'X91');
-- SELECT *
-- FROM czekoladki
-- WHERE idczekoladki IN ('W98', 'X91', 'M98');

-- UPDATE czekoladki
-- SET koszt = (SELECT koszt FROM czekoladki WHERE idczekoladki = 'W98')
-- WHERE nazwa = 'Nieznana Nieznajoma';

-- UPDATE klienci 
-- SET miejscowosc = 'Piotrograd'
-- WHERE miejscowosc = 'Leningrad';
-- SELECT * FROM klienci where miejscowosc like '%grad%';

-- UPDATE czekoladki cz
-- SET koszt = cz.koszt + 0.15
-- WHERE SUBSTR(cz.idczekoladki, 2, 2)::INT > 90;
-- SELECT * FROM czekoladki cz
-- WHERE SUBSTR(cz.idczekoladki, 2, 2)::INT > 90

--6.5 DELETE
-- FROM klienci
-- WHERE nazwa SIMILAR TO '%Matusiak%';
-- DELETE
-- FROM klienci
-- WHERE idklienta > 91;
-- DELETE
-- FROM czekoladki
-- WHERE koszt >= 0.45 OR masa = 0 OR masa >= 36;

--6.6 INSERT INTO pudelka (idpudelka, nazwa, cena, stan)
-- VALUES ('DBT', 'mmSMACZNE', 100, 99999),
-- 		('DBTT', 'mmNieSMAACZNE', 777, 8888);
-- select * from pudelka order by idpudelka;
-- INSERT INTO zawartosc (idpudelka, idczekoladki, sztuk)
-- VALUES
--     ('DBT', 'b01', 3),
--     ('DBT', 'b03', 2),
--     ('DBT', 'b07', 4),
--     ('DBT', 'm04', 2);
-- INSERT INTO zawartosc (idpudelka, idczekoladki, sztuk)
-- VALUES
--     ('DBTT', 'w02', 4),
--     ('DBTT', 'w06', 3),
--     ('DBTT', 'm18', 2),
--     ('DBTT', 'm17', 2);
--SELECT * from zawartosc

--6.7 OK learned about COPY
--6.8 OK learned about pg_dump and pg_restore