
--INNER JOIN
--1. �������� �������� � ��������� �������, ������������ ������� �������� "����� ���������" ��� "����� �������".
SELECT Prod.name, Cat.name, Sup.name
FROM Product Prod JOIN Category Cat ON  cat.id = Prod.id_category
JOIN Delivery Dev ON Prod.id = Dev.id_product
JOIN Supplier Sup ON Sup.id = Dev.id_supplier
WHERE Sup.name = '����� ���������' OR Sup.name = '����� �������'

--2. ������� ��� ������ � ��������� �� ����������, ��� ������������� ������� �� �������� ���� [���], � ��������� ������� �� "�������".
SELECT Prod.name, Sup.name[Supplier], Pr.name[Producer], Cat.name[Category]
FROM Product Prod JOIN Delivery Dev ON Prod.id=Dev.id_product
JOIN Supplier Sup ON Sup.id=Dev.id_supplier
JOIN Producer Pr ON Pr.id=Prod.id_producer
JOIN Category Cat ON Cat.id=Prod.id_category
WHERE Pr.name LIKE '[^��C]' OR Cat.name NOT LIKE '������'

--3. �������� �������� � ��������� ������� � ��������� ���������� � ������ �������������.
--�������: ������ ������������� �� �������, �� USA � �� France, ���� �������� ����� 50 ������, � 
--���� �������� �� 10.10.2018 � �� ��� ����.
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

--4. �������� ��� �������� � ������ ������, ������� ���� ������� ����� 1000. �������� ���������� � ���������� � �������������.
SELECT Cat.name[CategoryProduct], Prod.name[Product], Sup.name[Supplier], Pr.name[Producer], Dev.price*Dev.quantity[Profit]
FROM Product Prod JOIN Category Cat ON Cat.id=Prod.id_category
JOIN Delivery Dev ON Prod.id=Dev.id_product
JOIN Supplier Sup ON Sup.id=Dev.id_supplier
JOIN Producer Pr ON Pr.id=Prod.id_producer
WHERE Dev.price*Dev.quantity>1000

--5. ������� ������ �� ������� ���������� � �������� ������� � ��������� ����: �������� ������ � ��� ����������, 
--���������, ���� �������� � ����� ��������� ������������ �������. 
--�������: ������ ��� ��������� � ������� �����������. ������������� �������� ������� � ���������� �������.
SELECT TOP 3 Prod.name[Product], Sup.name[Supplier], Cat.name[Category], Dev.date_of_delivery, Dev.price*Dev.quantity[Profit,UAH]
FROM Product Prod JOIN Category Cat ON Cat.id=Prod.id_category
JOIN Delivery Dev ON Prod.id=Dev.id_product
JOIN Supplier Sup ON Sup.id=Dev.id_supplier
ORDER BY Prod.name ASC

--6. ������� ������ �� ������� � �������� ������� � ��������� ����: �������� ������ � ��� �������������, 
--������ ����� (������, �����, �����) ������������� � ����� ������, ���������, ���� ������� � ����� 
--��������� �������. �������: ���������� ���������� �� ������ �������� ���� ��������� � ������� ��������������. 
--������������� ����� ��������� ������ � ������� ��������.
SELECT Prod.name[Product], Pr.name[Producer], Ad.street+' '+ Ci.name+' '+Reg.name+' '+Co.name[Full Address],Cat.name[Category], sa.date_of_sale, sa.price*sa.quantity[Total]
FROM Product Prod JOIN Producer Pr ON Pr.id=Prod.id_producer
JOIN Category Cat ON Cat.id=Prod.id_category
JOIN Address Ad ON Ad.id=Pr.id_address
JOIN City Ci ON Ci.id=Ad.id_city
JOIN Region Reg ON Reg.id=Ci.id_region
JOIN Country Co ON Co.id=Reg.id_country
JOIN Sale Sa ON Prod.id=Sa.id_product
WHERE Pr.name NOT IN ('����� �����','���� ����')
ORDER BY sa.date_of_sale, sa.price*sa.quantity DESC
