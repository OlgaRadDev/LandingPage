
--OUTER JOIN

--1) �������� �������� ������� � �� ��������������, �� � � ��� ����� ��� ��������������, � ������� ��� �������
SELECT Pr.name[Producer], Prod.name[Product]
FROM Product Prod RIGHT JOIN Producer Pr ON Pr.id=Prod.id_producer

--2) �������� ������ �� ���������, � ������� �� ��������� �� ���� �����
SELECT Cat.name[Category]
FROM Product RIGHT JOIN Category Cat ON Cat.id=Product.id_category
WHERE Product.name IS NULL

--3) �������� �������� �������, ���� �� �������� � �����������, � ��� ����� ��� �����������, ������� ������ 
--�� ������ ���������
SELECT Sup.name[Supplier], Prod.name[Product], Dev.date_of_delivery
FROM Product Prod JOIN Delivery Dev ON Prod.id=Dev.id_product
RIGHT JOIN Supplier Sup ON Sup.id=Dev.id_supplier

--4) �������� ������� (�������), � ������� ��� �� ������ �������������
SELECT Reg.name[Region]
FROM Producer Pr JOIN Address Ad ON Ad.id=Pr.id_address
JOIN City Ci ON Ci.id=Ad.id_city
RIGHT JOIN Region Reg ON Reg.id=Ci.id_region
WHERE Pr.name IS NULL

--5) �������� �� �������� ���������, ��� ��� ������� �������� ����� �Roshen� ������������� �� ����� ����� � �� ���� ����
SELECT Cat.name[Category], Pr.name[Producer]
FROM Product Prod RIGHT JOIN Category Cat ON Cat.id=Prod.id_category
JOIN Producer Pr ON Pr.id=Prod.id_producer
WHERE Pr.name NOT LIKE '����� �����' AND Pr.name<>'���� ����'

--6) �������� ��������������, ������� �� ��������� �������� �������� ���������
SELECT Pr.name[Producer], Cat.name[Category]
FROM Product Prod JOIN Category Cat ON Cat.id=Prod.id_category
RIGHT JOIN Producer Pr ON Pr.id=Prod.id_producer
WHERE Cat.name<>'��������'