--LAB 5(funkcje agregujace)
--5.1.1select count(*) as liczba_czekoladek from czekoladki

--5.1.2select count(*) as liczba_czekoladek from czekoladki cz where cz.nadzienie is not null;
--one more way: select count(cz.nadzienie) as lb_cz_na from czekoladki cz;

--5.1.3  
-- select idpudelka from zawartosc group by idpudelka
-- having sum(sztuk) = ( select max(suma)
--     from (
--         select sum(sztuk) AS suma
--         from zawartosc
--         group by idpudelka
--     ) as pod
-- ); okay thats interesting

--5.1.4select idpudelka, nazwa, sum(sztuk) as suma
-- 	from pudelka join zawartosc using(idpudelka)
-- 	group by idpudelka
-- 	order by suma desc

-- 5.1.5select 
-- 	p.idpudelka, 
-- 	sum(CASE WHEN c.orzechy IS NULL THEN z.sztuk ELSE 0 END) AS bez_orzechow
-- from pudelka p left join zawartosc z using (idpudelka) left join czekoladki c using (idczekoladki)
-- group by p.idpudelka order by p.idpudelka;

--5.2.1 select z.idpudelka, sum(cz.masa*z.sztuk) as mass from zawartosc z join czekoladki cz using(idczekoladki) group by z.idpudelka order by mass desc

--5.2.2 select z.idpudelka, sum(cz.masa*z.sztuk) as mass from zawartosc z join czekoladki cz using(idczekoladki) 
-- group by z.idpudelka having sum(cz.masa*z.sztuk) = ( select max(suma)
--     from (
--         select sum(cz.masa*z.sztuk) AS suma
--         from zawartosc join czekoladki using(idczekoladki)
--         group by idpudelka
--     ) as pod
-- )
-- order by mass desc; not sure why this doesnt work
-- WITH masa AS (
--   SELECT idpudelka, SUM(cz.masa*z.sztuk) AS mass
--   FROM zawartosc z
--   JOIN czekoladki cz USING(idczekoladki)
--   GROUP BY idpudelka
-- )
-- SELECT idpudelka, mass
-- FROM masa
-- WHERE mass = (SELECT MAX(mass) FROM masa)
-- ORDER BY mass DESC; THIS WORKS tho

-- 5.2.3SELECT 
--     AVG(masa_pudelka) AS srednia_masa_pudelka
-- FROM (
--     SELECT SUM(z.sztuk * c.masa) AS masa_pudelka
--     FROM zawartosc z
--     JOIN czekoladki c USING (idczekoladki)
--     GROUP BY z.idpudelka
-- ) AS pod;

-- 5.3.1 select count(*) as num_per_date, datarealizacji from zamowienia group by datarealizacji order by datarealizacji asc

-- 5.3.2 select count(*) as cnt_zamowien from zamowienia 

-- 5.3.3 select sum(art.sztuk * p.cena) as orders_value from artykuly art join pudelka p using(idpudelka);

-- 5.3.4 select k.idklienta, k.nazwa, count(z.idzamowienia) as order_cnt, coalesce(sum(a.sztuk * p.cena), 0) as value 
-- from klienci k left join zamowienia z using(idklienta) left join artykuly a using(idzamowienia) left join pudelka p using(idpudelka)
-- group by k.idklienta--,a.idpudelka
-- order by value desc

-- 5.4.1 select count(idpudelka) as cnt, idczekoladki from zawartosc group by idczekoladki order by cnt desc limit 1 -- !wrong! cuz violates rule that all should be retrieved if multiple match
-- with max_cnt as ( -- right, but can be better
-- 	SELECT MAX(ile_pudelek) as max_val FROM (
--         SELECT COUNT(*) AS ile_pudelek
--         FROM zawartosc
--         GROUP BY idczekoladki
-- 	)
-- )
-- SELECT idczekoladki, count(idpudelka) as cnt FROM zawartosc
-- group by idczekoladki
-- having count(idpudelka) = (select max_val from max_cnt) 
-- WITH counts AS ( -- probably best
--     SELECT idczekoladki, COUNT(*) AS ile_pudelek
--     FROM zawartosc
--     GROUP BY idczekoladki
-- )
-- SELECT idczekoladki, ile_pudelek
-- FROM counts
-- WHERE ile_pudelek = (SELECT MAX(ile_pudelek) FROM counts);

-- 5.4.2 with cnt_no_nuts as (
-- 	select z.idpudelka, sum(case when c.orzechy is null then z.sztuk else 0 end) as no_nuts
-- 	from zawartosc z join czekoladki c using(idczekoladki)
-- 	group by z.idpudelka
-- )
-- select idpudelka, no_nuts 
-- from cnt_no_nuts
-- where no_nuts = (select max(no_nuts) from cnt_no_nuts)
-- select * -- to check
-- from cnt_no_nuts join zawartosc using(idpudelka) join czekoladki using(idczekoladki)
-- where no_nuts = (select max(no_nuts) from cnt_no_nuts)
-- order by idpudelka

-- 5.5.1 SELECT 
--     extract(year from datarealizacji) AS rok,
--     extract(QUARTER from datarealizacji) AS kwartal,
--     COUNT(*) AS liczba_zamowien
-- FROM zamowienia
-- GROUP BY rok, kwartal
-- ORDER BY rok, kwartal;

-- 5.5.2 SELECT 
--     EXTRACT(YEAR FROM datarealizacji) AS rok,
--     EXTRACT(MONTH FROM datarealizacji) AS miesiac,
--     COUNT(*) AS liczba_zamowien
-- FROM zamowienia
-- GROUP BY rok, miesiac
-- ORDER BY rok, miesiac;

-- 5.6.1 with manufacture_cost as ( --1ST option
-- 	select idpudelka, sum(z.sztuk * c.koszt) as manuf_cost
-- 	from zawartosc z join czekoladki c using(idczekoladki)
-- 	group by idpudelka
-- )
-- -- select * from monufacture_cost
-- select distinct idpudelka, p.cena - manuf_cost as profit
-- from pudelka p join zawartosc using(idpudelka) join manufacture_cost using(idpudelka)
-- order by profit desc

-- SELECT -- 2ND option
--     p.idpudelka,
--     p.cena,
--     SUM(z.sztuk * c.koszt) AS koszt_wytworzenia,
--     p.cena - SUM(z.sztuk * c.koszt) AS zysk_na_pudelku
-- FROM pudelka p
-- JOIN zawartosc z ON p.idpudelka = z.idpudelka
-- JOIN czekoladki c ON z.idczekoladki = c.idczekoladki
-- GROUP BY p.idpudelka, p.cena
-- ORDER BY zysk_na_pudelku DESC;

--5.6.2 with manufacture_cost as ( --1ST option
-- 	select idpudelka, sum(z.sztuk * c.koszt) as manuf_cost
-- 	from zawartosc z join czekoladki c using(idczekoladki)
-- 	group by idpudelka
-- )

-- SELECT pz.idzamowienia, SUM((p.cena - k.manuf_cost) * a.sztuk) AS profit_from_order
-- FROM zamowienia pz JOIN artykuly a ON pz.idzamowienia = a.idzamowienia JOIN pudelka p ON a.idpudelka = p.idpudelka JOIN manufacture_cost k ON p.idpudelka = k.idpudelka
-- GROUP BY pz.idzamowienia
-- ORDER BY profit_from_order desc;

-- 5.7 oh nonono
-- 5.8 eewww