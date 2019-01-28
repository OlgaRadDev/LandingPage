
--SUBQUERIES
--1. ѕоказать самый попул€рный товар магазина (больше всего раз продавалс€)
SELECT Prod.name, Sa.quantity
FROM Product AS Prod JOIN Sale AS Sa ON Prod.id=Sa.id_product
WHERE Sa.quantity=(SELECT MAX(quantity) FROM Sale);

--2. ≈сли общее количество товаров всех категорий прин€ть за 100%, необходимо посчитать, сколько товаров 
--каждой категории (в процентном отношении) было продано
SELECT Cat.name[Category], COUNT(*) AS prod, 
cast(ROUND (cast(COUNT(Cat.name) AS float)/(SELECT COUNT(*) FROM Sale)*100,2) as nvarchar)+' %'[Count Product]
FROM Product AS Prod 
JOIN Category Cat ON Cat.id=Prod.id_category 
JOIN Sale AS Sa ON Prod.id=Sa.id_product
GROUP BY Cat.name

--3. ѕоказать названи€ поставщиков, которые не поставл€ли йогурт
SELECT Sup.name
FROM Delivery Dev JOIN Product Prod ON Prod.id=Dev.id_product
JOIN Supplier Sup ON Sup.id=Dev.id_supplier
EXCEPT
SELECT DISTINCT Sup.name
FROM Delivery Dev JOIN Product Prod ON Prod.id=Dev.id_product
JOIN Supplier Sup ON Sup.id=Dev.id_supplier
WHERE Prod.name LIKE '…огурт' 

--4*. ѕоказать на экран список производителей, которые живут в той же стране, что и „ѕ "‘ерма".
SELECT Pr.name[Producer], Co.name[Country]
FROM Producer Pr JOIN Address Ad ON Ad.id = Pr.id_address
JOIN City Ci ON Ci.id=Ad.id_city
JOIN Region Reg ON Reg.id=Ci.id_region
JOIN Country Co ON Co.id=Reg.id_country
WHERE Co.name =  (SELECT Co.name
FROM Producer Pr JOIN Address Ad ON Ad.id = Pr.id_address
JOIN City Ci ON Ci.id=Ad.id_city
JOIN Region Reg ON Reg.id=Ci.id_region
JOIN Country Co ON Co.id=Reg.id_country WHERE Pr.name = '‘ерма');

--5. ѕоказать всех производителей, количество наименований товаров которых в магазине больше, 
--чем количество наименований всех товаров производител€ "Ћасунка".
SELECT Pr.name FROM Producer AS Pr 
JOIN Product AS Prod ON Pr.id=Prod.id_producer GROUP BY Pr.name 
HAVING Count(*) > (
SELECT  Count(*) FROM Producer AS Pr 
JOIN Product AS Prod ON Pr.id=Prod.id_producer GROUP BY Pr.name HAVING Pr.name = '—упер крупа') 

--6. ѕоказать общее количество продаж по каждому дню, начина€ от 15.04.2018, и по сей день. ќтсортировать по 
--убыванию даты.
SELECT Sa.date_of_sale, COUNT(Sa.quantity)
FROM Sale AS Sa
GROUP BY Sa.date_of_sale
HAVING Sa.date_of_sale BETWEEN '2018-04-15' AND GETDATE()
ORDER BY Sa.date_of_sale DESC
 
--7*. ¬ычислить количество товаров каждой категории, которые пора списать (их количество известно, и они не 
--продавались вот уже три мес€ца).
SELECT Cat.name[Category], COUNT (*)[Count Product]
FROM Product AS Prod JOIN Category AS Cat ON Cat.id=Prod.id_category
JOIN Sale Sa ON Sa.id_product=Prod.id 
WHERE DATEDIFF(DAYOFYEAR,Sa.date_of_sale,GETDATE()) > 90
GROUP BY Cat.name