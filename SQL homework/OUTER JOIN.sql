
--OUTER JOIN

--1) показать названия товаров и их производителей, но и в том числе тех производителей, у которых нет товаров
SELECT Pr.name[Producer], Prod.name[Product]
FROM Product Prod RIGHT JOIN Producer Pr ON Pr.id=Prod.id_producer

--2) показать только те категории, к которым не относится ни один товар
SELECT Cat.name[Category]
FROM Product RIGHT JOIN Category Cat ON Cat.id=Product.id_category
WHERE Product.name IS NULL

--3) показать названия товаров, даты их поставки и поставщиков, в том числе тех поставщиков, которые ничего 
--не успели поставить
SELECT Sup.name[Supplier], Prod.name[Product], Dev.date_of_delivery
FROM Product Prod JOIN Delivery Dev ON Prod.id=Dev.id_product
RIGHT JOIN Supplier Sup ON Sup.id=Dev.id_supplier

--4) показать области (регионы), в которых нет ни одного производителя
SELECT Reg.name[Region]
FROM Producer Pr JOIN Address Ad ON Ad.id=Pr.id_address
JOIN City Ci ON Ci.id=Ad.id_city
RIGHT JOIN Region Reg ON Reg.id=Ci.id_region
WHERE Pr.name IS NULL

--5) показать те названия категорий, где нет товаров торговой марки «Roshen» производитель не супер крупа и не Глав рыба
SELECT Cat.name[Category], Pr.name[Producer]
FROM Product Prod RIGHT JOIN Category Cat ON Cat.id=Prod.id_category
JOIN Producer Pr ON Pr.id=Prod.id_producer
WHERE Pr.name NOT LIKE 'Супер крупа' AND Pr.name<>'Глав рыба'

--6) показать производителей, которые не выпускают продукты молочной категории
SELECT Pr.name[Producer], Cat.name[Category]
FROM Product Prod JOIN Category Cat ON Cat.id=Prod.id_category
RIGHT JOIN Producer Pr ON Pr.id=Prod.id_producer
WHERE Cat.name<>'Молочные'