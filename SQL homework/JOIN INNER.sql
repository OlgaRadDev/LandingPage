
--INNER JOIN
--1. Показать названия и категории товаров, поставщиками которых являются "Закуп Универсал" или "Супер закупка".
SELECT Prod.name, Cat.name, Sup.name
FROM Product Prod JOIN Category Cat ON  cat.id = Prod.id_category
JOIN Delivery Dev ON Prod.id = Dev.id_product
JOIN Supplier Sup ON Sup.id = Dev.id_supplier
WHERE Sup.name = 'Закуп универсал' OR Sup.name = 'Супер закупка'

--2. Выбрать все товары с указанием их поставщика, имя производителя которых не содержит букв [ФХС], и категория которых не "Бакалея".
SELECT Prod.name, Sup.name[Supplier], Pr.name[Producer], Cat.name[Category]
FROM Product Prod JOIN Delivery Dev ON Prod.id=Dev.id_product
JOIN Supplier Sup ON Sup.id=Dev.id_supplier
JOIN Producer Pr ON Pr.id=Prod.id_producer
JOIN Category Cat ON Cat.id=Prod.id_category
WHERE Pr.name LIKE '[^ФХC]' OR Cat.name NOT LIKE 'Мясные'

--3. Показать названия и категории товаров с указанием поставщика и страны производителя.
--Условие: страна производителя не Украина, не USA и не France, цена поставки менее 50 гривен, а 
--дата поставки от 10.10.2018 и по сей день.
SELECT Prod.name[Product], Cat.name[Category], Sup.name[Supplier], Co.name[Country], Dev.date_of_delivery
FROM Product Prod JOIN Category Cat ON Cat.id=Prod.id_category
JOIN Delivery Dev ON Prod.id=Dev.id_product
JOIN Supplier Sup ON Sup.id=Dev.id_supplier
JOIN Address Ad ON Ad.id=Sup.id_address
JOIN City Ci ON Ci.id=Ad.id_city
JOIN Region Reg ON Reg.id=Ci.id_region
JOIN Country Co ON Co.id=Reg.id_country
WHERE Co.name NOT LIKE 'Ukraine' AND Co.name NOT LIKE'USA' AND Co.name NOT LIKE 'France' 
AND Dev.price<50
AND Dev.date_of_delivery BETWEEN '2018-10-10' AND GETDATE()

--4. Показать все молочные и мясные товары, которых было продано более 1000. Показать информацию о поставщике и производителе.
SELECT Cat.name[CategoryProduct], Prod.name[Product], Sup.name[Supplier], Pr.name[Producer], Dev.price*Dev.quantity[Profit]
FROM Product Prod JOIN Category Cat ON Cat.id=Prod.id_category
JOIN Delivery Dev ON Prod.id=Dev.id_product
JOIN Supplier Sup ON Sup.id=Dev.id_supplier
JOIN Producer Pr ON Pr.id=Prod.id_producer
WHERE Dev.price*Dev.quantity>1000

--5. Сделать запрос на выборку информации о поставке товаров в следующем виде: название товара и его поставщика, 
--категории, дата поставки и общую стоимость поставленных товаров. 
--Условие: только трёх указанных в запросе поставщиков. Отсортировать названия товаров в алфавитном порядке.
SELECT TOP 3 Prod.name[Product], Sup.name[Supplier], Cat.name[Category], Dev.date_of_delivery, Dev.price*Dev.quantity[Profit,UAH]
FROM Product Prod JOIN Category Cat ON Cat.id=Prod.id_category
JOIN Delivery Dev ON Prod.id=Dev.id_product
JOIN Supplier Sup ON Sup.id=Dev.id_supplier
ORDER BY Prod.name ASC

--6. Сделать запрос на выборку о продажах товаров в следующем виде: название товара и его производителя, 
--полный адрес (страна, город, улица) производителя в одной ячейке, категории, дате продажи и общей 
--стоимости продажи. Условие: выведенная информация не должна касаться двух указанных в запросе производителей. 
--Отсортировать общую стоимость продаж в порядке убывания.
SELECT Prod.name[Product], Pr.name[Producer], Ad.street+' '+ Ci.name+' '+Reg.name+' '+Co.name[Full Address],Cat.name[Category], sa.date_of_sale, sa.price*sa.quantity[Total]
FROM Product Prod JOIN Producer Pr ON Pr.id=Prod.id_producer
JOIN Category Cat ON Cat.id=Prod.id_category
JOIN Address Ad ON Ad.id=Pr.id_address
JOIN City Ci ON Ci.id=Ad.id_city
JOIN Region Reg ON Reg.id=Ci.id_region
JOIN Country Co ON Co.id=Reg.id_country
JOIN Sale Sa ON Prod.id=Sa.id_product
WHERE Pr.name NOT IN ('Супер крупа','Глав рыба')
ORDER BY sa.date_of_sale, sa.price*sa.quantity DESC
