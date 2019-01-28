--1 Ќаписать хранимую процедуру, котора€ показывает количество вз€тых книг по каждой из групп, и по 
--каждой из кафедр (Departments)
GO
CREATE PROCEDURE take_book AS
SELECT book.quantity[Books], gr.name[Group], dep.name [Department]
FROM Books book JOIN S_Cards sc ON book.id = sc.Id_Book
JOIN Students st ON st.Id = sc.Id_Student
JOIN Groups gr ON gr.Id = st.Id_Group
JOIN T_Cards tc ON book.Id = tc.Id_Book
JOIN Teachers tech ON tech.Id = tc.Id_Teacher
JOIN Departments dep ON dep.Id = tech.Id_Dep
GROUP BY book.Quantity, gr.Name, dep.Name
GO
EXEC take_book

--2 Ќаписать хранимую процедуру, показывающую список книг, отвечающих набору критериев.  ритерии: 
--им€ автора, фамили€ автора, тематика, категори€.  роме того, список должен быть отсортирован по 
--номеру пол€, указанному в 5-м параметре, в направлении, указанном в 6-м параметре (sp_executesql)
GO
CREATE PROCEDURE sp_list_books AS
SELECT book.name[Books], aut.FirstName, aut.LastName, th.name[Themes], cat.name[Category]
FROM Books book JOIN Authors aut ON aut.Id = book.Id_Author
JOIN Themes th ON th.Id = book.Id_Themes
JOIN Categories cat ON cat.Id = book.Id_Category 
ORDER BY 5 ASC
GO
EXEC sp_list_books

--3 Ќаписать хранимую процедуру, котора€ показывает список библиотекарей, и количество выданных 
--каждым из них книг
 GO
 CREATE PROCEDURE sp_list_librarian AS 
 SELECT lib.FirstName, COUNT(b.name)[Count books]
 FROM Libs lib JOIN T_Cards tc ON lib.Id = tc.Id_Lib
 JOIN S_Cards sc ON lib.Id = sc.Id_Lib
 JOIN Books b ON b.Id = sc.Id_Book
 GROUP BY lib.FirstName
 GO
 EXEC sp_list_librarian

  

