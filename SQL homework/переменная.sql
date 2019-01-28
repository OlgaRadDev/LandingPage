--показать среднее арифметическое трех вещественных чисел
DECLARE @one float =10.8
DECLARE @two float = 17.4
DECLARE @three float = 20.5
DECLARE @result float
SET @result=(@one+@two+@three)/3
PRINT 'Result = ' + cast(@result AS nvarchar)
--показать количество цифр числа, хран€щегос€ в переменной. 
--число может быть вещественным
DECLARE @number int = 15478758
DECLARE @resultCount int = 0
	WHILE @number!=0
	BEGIN
		SET @resultCount+=1
		SET @number/=10
	END
PRINT @resultCount

--показать горизонтальную линию из звЄздочек длиной @L
DECLARE @length int = 10
DECLARE @count int = 0
DECLARE @res nvarchar(50) = ''
WHILE @count <@length
	BEGIN
		SET @res = @res+'*'+''
		SET @count+=1
	END
PRINT @res

--скрипт провер€ет, какое сейчас врем€ суток, и выдаЄт приветствие 
--"добрый вечер!" или "добрый день!"
DECLARE @time int = DATEPART(HOUR, GETDATE())
	IF @time BETWEEN 6 AND 18
		BEGIN PRINT 'ƒобрый день!'
		END
	IF @time BETWEEN 19 AND 23 OR @time BETWEEN 1 AND 5  
		BEGIN
		PRINT 'ƒобрый вечер!'
		END

--скрипт генерирует случайный сложный пароль длиной от @M до @N
DECLARE @passwordLength int = 20
DECLARE @countPas int = 0
DECLARE @symbol float 
DECLARE @resultPas nvarchar(100)= ''
WHILE @countPas<@passwordLength
	BEGIN
		SELECT @symbol = RAND()
		SET @symbol = @symbol*255
		SET @resultPas =@resultPas+CHAR(@symbol)+''
		SET @countPas+=1
	END
PRINT @resultPas
 
--показать факториалы всех чисел от 0 до 25
DECLARE @factorial numeric(38,0) = 1
DECLARE @countF int = 1
DECLARE @resFactorial nvarchar(1000) = ''
WHILE @countF <=25
	BEGIN
		SET @factorial*=@countF
		SET @resFactorial =@resFactorial+cast(@factorial AS nvarchar)+','
		SET @countF+=1
	END
PRINT @resFactorial

--показать все простые числа от 3 до 1 000 000
DECLARE @i int = 3
DECLARE @j int = 3
DECLARE @isPrime int = 1
DECLARE @resPrime nvarchar(2000)=''
	WHILE (@i<=1000000)
	BEGIN 
		WHILE(@j<=1000000)
		BEGIN IF ((@i<>@j) AND (@i%@j=0))
		BEGIN SET @isPrime=0
		BREAK
		END ELSE
			BEGIN SET @j=@j+1
			END 
	END
	IF (@isPrime=1)
	BEGIN
	SELECT @resPrime=@resPrime+cast(@i AS nvarchar)+','
	END
	SET @isPrime=1
	SET @i=@i+1
	SET @j=2
	END
	PRINT @resPrime

--показать все римские числа от 1 до 3999
CREATE TABLE #RomanNumerals
(
	Id INT PRIMARY KEY IDENTITY (1,1),
	ArabicNumbers INT,
	RomeNumbers NVARCHAR(50)
)
INSERT #RomanNumerals
VALUES(1,'I'),
	  (4,'IV'),
	  (5,'V'),
	  (9,'IX'),
	  (10,'X'),
	  (40,'XL'),
	  (50,'L'),
	  (90,'XC'),
	  (100,'C'),
	  (400,'CD'),
	  (500,'D'),
	  (900,'CM'),
	  (1000,'M')

DECLARE @indexRome INT = 3999
WHILE (@indexRome<>0)
BEGIN
	DECLARE @arabNum INT = @indexRome
    DECLARE @resultRome NVARCHAR(50) = ''
    WHILE (@arabNum > 0) 
		BEGIN
			DECLARE @id INT
			SELECT TOP 1 @resultRome += RomeNumbers, @id = Id FROM #RomanNumerals WHERE @arabNum >=ArabicNumbers ORDER BY ArabicNumbers DESC
			SELECT @arabNum -= ArabicNumbers FROM #RomanNumerals WHERE Id = @id
    END
    PRINT @resultRome
	SET @indexRome -= 1
END
 DROP TABLE #RomanNumerals

--показать таблицу пифагора (результаты - как одна таблица, полученна€ селектом)
BEGIN
DECLARE @TempTable TABLE ("1" INT, "2" INT, "3" INT, "4" INT, "5" INT, "6" INT, "7" INT, "8" INT, "9" INT, "10" INT)
DECLARE @jMult INT = 1
            WHILE (@jMult <= 10)
            BEGIN
                        INSERT INTO @TempTable
						SELECT 1 * @jMult,  2 * @jMult, 3 *@jMult, 4*@jMult,5 *@jMult,6 *@jMult,7 *@jMult,8 *@jMult,9 *@jMult,10 *@jMult
                        SET @jMult = @jMult + 1
            END
            SELECT * FROM @TempTable;

END
 --показать номера всех счастливых трамвайных билетов
DECLARE @firstPart INT = 999
WHILE (@firstPart <> 0)
	BEGIN
	DECLARE @secondPart INT = 999
		WHILE (@secondPart <> 0)
			BEGIN
				IF((@firstPart%10 + @firstPart/10 + @firstPart/100) = (@secondPart%10 + @secondPart/10 + @secondPart/100))
				BEGIN
					PRINT IIF(@firstPart/10 = 0,'0','')+IIF(@firstPart/100 = 0,'0','')+CAST(@firstPart AS NVARCHAR) + ' ' + IIF(@secondPart/10 = 0,'0','')+ IIF(@secondPart/100 = 0,'0','')+CAST(@secondPart AS NVARCHAR)
				END
				SET @secondPart -= 1
			END
		SET @firstPart -= 1
	END
