--1.„тобы при вз€тии определенной книги ее кол-во уменьшалось на 1, а сам факт выдачи фиксировалс€ в 
--таблице Issued (в нее нужно записывать фамилию и им€ студента/преподавател€, название книги. дату выдачи).
 
CREATE TABLE Issued (
id INT PRIMARY KEY Identity(1,1) NOT NULL,
firstName NVARCHAR(50),
lastname NVARCHAR(50),
bookName NVARCHAR(100),
dateOut Date );
GO
USE Library
GO
CREATE TRIGGER takingBookStudent 
ON S_Cards
FOR DELETE 
AS
	IF @@ROWCOUNT = 0
	RETURN
	SET NOCOUNT ON

	UPDATE Books
	SET Quantity = b.Quantity - 1
	FROM Books b JOIN deleted d
	ON b.Id=d.Id_Book
INSERT INTO Issued(id, firstName,lastname,bookName,dateOut)
SELECT b.Id, st.FirstName,st.LastName, b.Name, d.DateOut
FROM Books b JOIN deleted d ON b.Id = d.Id_Book
JOIN Students st ON st.Id = d.Id_Student

GO
CREATE TRIGGER takingBookTeacher
ON T_Cards
FOR DELETE
AS
	IF @@ROWCOUNT = 0
	RETURN
	SET NOCOUNT ON

	UPDATE Books
	SET Quantity = b.Quantity - 1 
	FROM Books b JOIN deleted d 
	ON b.Id = d.Id_Book 
		
INSERT INTO Issued(id, firstName,lastname,bookName,dateOut)
SELECT b.Id, t.FirstName, t.LastName, b.Name, d.DateOut
FROM Books b JOIN deleted d ON b.Id = d.Id_Book
JOIN Teachers t ON t.Id = d.Id_Teacher

--2.—делать так, чтобы нельз€ было выдать книгу, которой уже нет в библиотеке (по кол-ву)
GO
CREATE TRIGGER forbiddenOutBook1
ON S_Cards
FOR INSERT 
AS
DECLARE @countIns INT
SELECT @countIns = COUNT(Id_Book)FROM inserted
DECLARE @countBook INT
SELECT @countBook = COUNT(Id) FROM Books
DECLARE @countQnt INT
SELECT @countQnt = COUNT(Quantity)FROM Books

	DECLARE cur1 CURSOR SCROLL FOR SELECT Id_Book FROM inserted
	OPEN cur1
	DECLARE @getIdBook INT
	WHILE @countIns >0
	BEGIN
	FETCH ABSOLUTE @countIns FROM cur1 INTO @getIdBook
	SET @countIns = @countIns-1
		DECLARE cur2 CURSOR SCROLL FOR SELECT Id FROM Books WHERE Quantity=0
		OPEN cur2
		DECLARE @getId INT
		WHILE @countBook>0
		BEGIN
		FETCH ABSOLUTE @countBook FROM cur2 INTO @getId
		SET @countBook = @countBook-1
			
			IF @getIdBook = @getId 
				BEGIN
				PRINT 'Books are absent'
				rollback tran
			END
		END
		CLOSE cur2
		DEALLOCATE cur2
	END
	CLOSE cur1
	DEALLOCATE cur1
	DROP TRIGGER forbiddenOutBook1

GO
CREATE TRIGGER forbiddenOutBook2
ON T_Cards
FOR INSERT 
AS
DECLARE @countIns INT
SELECT @countIns = COUNT(Id_Book)FROM inserted
DECLARE @countBook INT
SELECT @countBook = COUNT(Id) FROM Books
DECLARE @countQnt INT
SELECT @countQnt = COUNT(Quantity)FROM Books

	DECLARE curT1 CURSOR SCROLL FOR SELECT Id_Book FROM inserted
	OPEN curT1
	DECLARE @getIdBook INT
	WHILE @countIns >0
	BEGIN
	FETCH ABSOLUTE @countIns FROM curT1 INTO @getIdBook
	SET @countIns = @countIns-1
		DECLARE curT2 CURSOR SCROLL FOR SELECT Id FROM Books WHERE Quantity=0
		OPEN curT2
		DECLARE @getId INT
		WHILE @countBook>0
		BEGIN
		FETCH ABSOLUTE @countBook FROM curT2 INTO @getId
		SET @countBook = @countBook-1
			
			IF @getIdBook = @getId 
				BEGIN
				PRINT 'Books are absent'
				rollback tran
			END
		END
		CLOSE curT2
		DEALLOCATE curT2
	END
	CLOSE curT1
	DEALLOCATE curT1
	DROP TRIGGER forbiddenOutBook2

--3.„тобы при возврате определенной книги, ее кол-во увеличивалось на 1 и это фиксировалось в таблице Returned
GO
CREATE TABLE Returned (
id INT PRIMARY KEY Identity(1,1) NOT NULL,
firstName NVARCHAR(50),
lastname NVARCHAR(50),
bookName NVARCHAR(100),
dateIn Date )
USE Library
GO
CREATE TRIGGER returnedBookStudent 
ON S_Cards
FOR INSERT 
AS
	IF @@ROWCOUNT = 0
	RETURN
	SET NOCOUNT ON

	UPDATE Books
	SET Quantity = b.Quantity + 1
	FROM Books b JOIN inserted i
	ON b.Id=i.Id_Book
INSERT INTO Returned (id, firstName,lastname,bookName,dateIn)
SELECT b.Id, st.FirstName,st.LastName, b.Name, i.DateIn
FROM Books b JOIN inserted i ON b.Id = i.Id_Book
JOIN Students st ON st.Id = i.Id_Student
GO
CREATE TRIGGER retunedBookTeacher
ON T_Cards
FOR INSERT
AS
	IF @@ROWCOUNT = 0
	RETURN
	SET NOCOUNT ON

	UPDATE Books
	SET Quantity = b.Quantity + 1 
	FROM Books b JOIN inserted i 
	ON b.Id = i.Id_Book 
		
INSERT INTO Returned (id, firstName,lastname,bookName,dateIn)
SELECT b.Id, t.FirstName, t.LastName, b.Name, i.DateIn
FROM Books b JOIN INSERTED i ON b.Id = i.Id_Book
JOIN Teachers t ON t.Id = i.Id_Teacher

--4.—делать так, чтобы нельз€ было вернуть больше книг, чем их было изначально
GO
CREATE TRIGGER returnBook 
ON S_Cards 
FOR INSERT 
AS
DECLARE @count INT
SELECT @count = COUNT(Id_Book)FROM inserted
DECLARE @countBook INT
SELECT @countBook = COUNT(Id) FROM Books
DECLARE cur1 CURSOR SCROLL FOR SELECT Id_Book FROM inserted
OPEN cur1

DECLARE @idBook INT
WHILE @count>0
BEGIN
	FETCH ABSOLUTE @count FROM cur1 INTO @idBook
	SET @count = @count - 1
	DECLARE @countIdBook INT
	SELECT @countIdBook = COUNT(@idBook)FROM inserted
		DECLARE cur2 CURSOR SCROLL FOR SELECT Id FROM Books WHERE Quantity<=@countIdBook
		OPEN cur2
		DECLARE @book INT
		WHILE @countBook>0
		BEGIN
			FETCH ABSOLUTE @countBook FROM cur2 INTO @book
			SET @countBook = @countBook-1

				IF @idBook <> @book
				BEGIN
				PRINT 'Books are more than them were at first'
				rollback tran
				END
		END
		CLOSE cur2
		DEALLOCATE cur2
END
CLOSE cur1
DEALLOCATE cur1

DROP TRIGGER returnBook

GO
CREATE TRIGGER returnBook 
ON T_Cards 
FOR INSERT 
AS
DECLARE @count INT
SELECT @count = COUNT(Id_Book)FROM inserted
DECLARE @countBook INT
SELECT @countBook = COUNT(Id) FROM Books
DECLARE cur1 CURSOR SCROLL FOR SELECT Id_Book FROM inserted
OPEN cur1
DECLARE @idBook INT
WHILE @count>0
BEGIN
	FETCH ABSOLUTE @count FROM cur1 INTO @idBook
	SET @count = @count - 1
	DECLARE @countIdBook INT
	SELECT @countIdBook = COUNT(@idBook)FROM inserted
		DECLARE cur2 CURSOR SCROLL FOR SELECT Id FROM Books WHERE Quantity<=@countIdBook
		OPEN cur2
		DECLARE @book INT
		WHILE @countBook>0
		BEGIN
			FETCH ABSOLUTE @countBook FROM cur2 INTO @book
			SET @countBook = @countBook-1

				IF @idBook <> @book
				BEGIN
				PRINT 'Books are more than them were at first'
				rollback tran
				END
		END
		CLOSE cur2
		DEALLOCATE cur2
END
CLOSE cur1
DEALLOCATE cur1

DROP TRIGGER returnBook

--5.„тобы нельз€ было выдать более трех книг одному студенту (имеетс€ в виду кол-во книг на руках 
--студента)
SELECT Id_Student, COUNT (Id_Student)[COUNT] FROM S_Cards
GROUP BY Id_Student

GO
CREATE TRIGGER issueBookToStudent
ON S_Cards
FOR DELETE
AS
DECLARE @countBooks INT
SELECT @countBooks = COUNT(Id_Student) FROM deleted

DECLARE cur CURSOR SCROLL FOR SELECT Id_Student FROM deleted
OPEN cur
DECLARE @idStudent INT
WHILE  @countBooks>0
BEGIN
	FETCH ABSOLUTE @countBooks FROM cur INTO @idStudent
	SET @countBooks = @countBooks - 1
	
	SELECT Id_Student, COUNT(Id_Student)[CountId]
	INTO #tempTable
	FROM deleted
	GROUP BY Id_Student
			DECLARE @count INT
			SELECT @count = COUNT(CountId)FROM #tempTable
			DECLARE cur1 CURSOR SCROLL FOR SELECT Id_Student FROM #tempTable
			OPEN cur1
			DECLARE @countId INT
			WHILE @count>0
			BEGIN
				FETCH ABSOLUTE @count FROM cur1 INTO @countId
				SET @count = @count-1

				IF @countId>3
				BEGIN
				PRINT 'Do not give the book' 
				ROLLBACK TRAN
				END
			END
			CLOSE cur1
			DEALLOCATE cur1
END
CLOSE cur
DEALLOCATE cur
 
--6.„тобы при удалении книг, данные о ней копировались в таблицу LibDeleted
GO
CREATE TABLE LibDeleted (
	Id INT PRIMARY KEY Identity(1,1) NOT NULL,
	Name NVARCHAR(50),
	Pages INT,
	YearPress INT,
	Id_Themes INT,
	Id_Category INT,
	Id_Author INT,
	Id_Press INT,
	Comment NVARCHAR(50),
	Quantity INT);

GO
CREATE TRIGGER DataDeletedBooks
ON Books
FOR DELETE
AS
INSERT INTO LibDeleted (Id,Name,Pages,YearPress,Id_Themes,Id_Category,Id_Author,Id_Press,Comment,Quantity)
SELECT *
FROM deleted

--7. ≈сли нова€ книга добавл€етс€ в базу, она должна быть удалена из таблицы LibDeleted(если она в 
--ней есть)
GO
CREATE TRIGGER addNewBook 
ON Books 
FOR INSERT
AS
DECLARE @nameIns NVARCHAR(100)
SELECT @nameIns = Name FROM inserted
DECLARE @nameLibDel NVARCHAR(100)
SELECT @nameLibDel = Name FROM LibDeleted
DELETE  FROM LibDeleted
WHERE @nameIns = @nameLibDel

--8. Ќельз€ выдать новую книгу студенту, если в прошлый раз он читал книгу дольше 2 мес€цев!
GO 
CREATE TRIGGER giveNewBookToStudent
ON S_Cards
FOR DELETE
AS
	DECLARE @dateIN DATE 
	SELECT @dateIN = DateIn FROM inserted
	DECLARE @dateOUT DATE
	SELECT @dateOUT = DateOut FROM inserted
	DECLARE @longTime DATE 
	SELECT @longTime =  DATEDIFF(month, @dateIN, @dateOUT)
IF @longTime>60
PRINT 'Must not give the book'

--9. ≈сли студента зовут јлександр, он получает две одинаковые книги вместо одной (если конечно, 
--второй экземпл€р в наличии)
GO
CREATE TRIGGER twoSameBooks
ON S_Cards
FOR DELETE
AS
DECLARE @id_Student INT
SELECT @id_Student = Id FROM Students WHERE FirstName LIKE 'јлександр'
DECLARE @qntBook INT
SELECT @qntBook = Id FROM Books WHERE Quantity>=2

IF EXISTS (SELECT * FROM deleted WHERE Id_Student = @id_Student AND Id_Book = @qntBook)
PRINT 'You are given the same two books' 

--10.≈сли нет книги, которую хочет вз€ть преподаватель, выдать ему одну случайную книгу. 
--¬ случае, если книги в библиотеке совсем закончились - выдать сообщение об этом
GO
CREATE TRIGGER bookToTeacher 
ON T_Cards
FOR INSERT
AS
DECLARE @countBookReqTeach INT
SELECT @countBookReqTeach = COUNT(Id_Book) FROM inserted
DECLARE @countBookFromTableBooks INT
SELECT @countBookFromTableBooks = COUNT(Id) FROM Books

	DECLARE cur1 CURSOR SCROLL FOR SELECT Id_Book FROM inserted 
	OPEN cur1
	DECLARE @idBookreqTeach INT
	WHILE @countBookReqTeach>0
	BEGIN
		FETCH ABSOLUTE @countBookReqTeach FROM cur1 INTO @idBookreqTeach
		SET @countBookReqTeach = @countBookReqTeach-1
			DECLARE cur2 CURSOR SCROLL FOR SELECT Id FROM Books WHERE Quantity = 0
			OPEN cur2
			DECLARE @idBookFromTableBooks INT
			WHILE @countBookFromTableBooks>0
			BEGIN
				
				FETCH ABSOLUTE @countBookFromTableBooks FROM cur2 INTO @idBookFromTableBooks
				SET @countBookFromTableBooks = @countBookFromTableBooks-1

				IF @idBookreqTeach = @idBookFromTableBooks
				BEGIN
				PRINT 'Books are absent'
				rollback tran
				END
				ELSE
				DECLARE @randBook INT
				SELECT @randBook = RAND()*(@idBookFromTableBooks)+1
				FETCH ABSOLUTE @randBook FROM cur2 INTO @idBookFromTableBooks
			END
			CLOSE cur2
			DEALLOCATE cur2
	END
	CLOSE cur1
	DEALLOCATE cur1

	INSERT T_Cards VALUES (7, @idBookFromTableBooks, 2018-01-01, NULL,2)	
	DROP TRIGGER bookToTeacher





















