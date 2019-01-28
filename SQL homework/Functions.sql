--1 написать функцию, которая покажет список всех пользовательских баз данных SQL Server, и их общие 
--размеры в байтах
GO
CREATE FUNCTION ListDatabases2()
RETURNS TABLE AS RETURN 
(SELECT name, size/128 AS [Size,Mb]
FROM sys.master_files
WHERE name NOT IN ('master', 'tempdb','model','msdb'))

GO
SELECT *
FROM dbo.ListDatabases2()

--GO
--CREATE FUNCTION ListDatabasess()
--RETURNS TABLE 
--AS RETURN 
--(SELECT name, SUM(size) [Size,b]  
--FROM sys.databases_files
--WHERE name NOT IN ('master', 'tempdb','model','msdb')
--GROUP BY name
--)
--GO
--SELECT *
--FROM dbo.ListDatabasess()


--2 написать функцию, которая покажет список всех таблиц базы данных, название которой передано как 
--параметр, количество записей в каждой из её таблиц, и общий размер каждой таблицы в байтах

GO 
CREATE FUNCTION dbo.ListTables(@base NVARCHAR(50))
RETURNS int
 AS BEGIN
 DECLARE @sql AS NVARCHAR(50)
 set @sql='select Name,  from '+@base+'.sys.tables';
 EXEC sp_executesql @sql
 return 0
 END

 GO
DROP FUNCTION ListTables

SELECT * FROM dbo.ListTable ('Library')

--GO
--CREATE FUNCTION ListTable1(@base NVARCHAR(50))
--RETURNS TABLE 
--AS RETURN
--(SELECT TABLE_NAME 
--FROM INFORMATION_SCHEMA.TABLES 
--WHERE TABLE_TYPE = 'BASE TABLE')
--SELECT
--  *
--FROM
--  INFORMATION_SCHEMA.TABLES
--GO

GO 
CREATE FUNCTION dbo.ListTables1(@base NVARCHAR(50))
RETURNS NVARCHAR(500) 
AS BEGIN  

SET NOCOUNT ON
DECLARE @TableInfo TABLE (tablename varchar(255), rowcounts int, reserved varchar(255), DATA varchar(255), index_size varchar(255), unused varchar(255))
DECLARE @cmd1 varchar(500)
SET @cmd1 = 'exec sp_spaceused ''?'''

INSERT INTO @TableInfo (tablename,rowcounts,reserved,DATA,index_size,unused)
EXEC sp_msforeachtable @command1=@cmd1
RETURN @TableInfo
END GO
SELECT dbo.ListTables1('Library') 

ORDER BY Convert(int,Replace(DATA,' KB','')) DESC

--2 написать функцию, которая покажет список всех таблиц базы данных, название которой передано как 
--параметр, количество записей в каждой из её таблиц, и общий размер каждой таблицы в байтах
GO 
CREATE PROSEDURE AS  dbo.ListTables(@base NVARCHAR(50))
RETURNS @TableInfo TABLE
(tablename varchar(255), rowcounts int, reserved varchar(255), DATA varchar(255), index_size varchar(255), unused varchar(255))
AS BEGIN  
SET NOCOUNT ON
DECLARE @temp TABLE (tablename varchar(255), rowcounts int, reserved varchar(255), DATA varchar(255), index_size varchar(255), unused varchar(255))
DECLARE @cmd1 varchar(500)
SET @cmd1 = 'exec sp_spaceused ''?'''
INSERT INTO @TableInfo (tablename,rowcounts,reserved,DATA,index_size,unused)
--EXEC sp_msforeachtable @command1=@cmd1
RETURN
END 
GO
SELECT * FROM dbo.ListTables('Library') 

--ORDER BY Convert(int,Replace(DATA,' KB','')) DESC

CREATE PROCEDURE list_Tables AS
--SELECT tablename varchar(255), rowcounts int, reserved varchar(255), DATA varchar(255), index_size varchar(255), unused varchar(255)
SET NOCOUNT ON
DECLARE @TableInfo TABLE (tablename varchar(255), rowcounts int, reserved varchar(255), DATA varchar(255), index_size varchar(255), unused varchar(255))
DECLARE @cmd1 varchar(500)
SET @cmd1 = 'exec sp_spaceused ''?'''

INSERT INTO @TableInfo (tablename,rowcounts,reserved,DATA,index_size,unused)
EXEC sp_msforeachtable @command1=@cmd1

SELECT * FROM @TableInfo ORDER BY Convert(int,Replace(DATA,' KB','')) DESC


SELECT tablename varchar(255), rowcounts int, reserved varchar(255), DATA varchar(255), index_size varchar(255), unused varchar(255)
SET NOCOUNT ON
DECLARE @TableInfo TABLE (tablename varchar(255), rowcounts int, reserved varchar(255), DATA varchar(255), index_size varchar(255), unused varchar(255))
DECLARE @cmd1 varchar(500)
SET @cmd1 = 'exec sp_spaceused ''?'''

INSERT INTO @TableInfo (tablename,rowcounts,reserved,DATA,index_size,unused)
EXEC sp_msforeachtable @command1=@cmd1

SELECT * FROM @TableInfo ORDER BY Convert(int,Replace(DATA,' KB','')) DESC



--DECLARE @base AS NVARCHAR(50)
--DECLARE @sql AS NVARCHAR(50)

--SET @base = 'FirstBase'

-- set @sql='select Name from '+@base+'.sys.tables';
-- EXEC sp_executesql @sql


 

--SELECT TABLE_NAME 
--FROM <DATABASE_NAME>.INFORMATION_SCHEMA.TABLES 
--WHERE TABLE_TYPE = 'BASE TABLE'


--Create TABLE #TableSize (TableName VARCHAR(200),Rows VARCHAR(20),      
--       Reserved VARCHAR(20),Data VARCHAR(20),index_size VARCHAR(20), 
--       Unused VARCHAR(20))
--exec sp_MSForEachTable 'Insert Into #TableSize Exec sp_spaceused [?]'
--Select
--    TableName, CAST(Rows AS bigint) As Rows, 
--    CONVERT(bigint,left(Reserved,len(reserved)-3)) As Size_In_KB 
--    from #TableSize order by 3 desc
--Drop Table #TableSize
--)





--3 написать функцию, которая покажет список всех полей определённой таблицы, имя которой передаётся 
--как параметр. если есть несколько одноимённых таблиц (в разных БД) - показать информацию по каждой
 --таблице. кроме названия поля указать его тип, поддержку нулевых значений и перечень всех ограничений 
 USE Library
 GO
 CREATE FUNCTION ListFields2(@nameTable AS NVARCHAR(50))
 RETURNS TABLE AS 
 RETURN
 (SELECT column_name, DATA_TYPE, character_maximum_length, column_name as [Column] , Table_catalog as [Database] 
 FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME  = 'Table_Name')
	GO
	SELECT * FROM dbo.ListFields2('Books')
 DROP  FUNCTION ListFields2

 select Table_name as [Table] , column_name as [Column] , Table_catalog as [Database], table_schema as [Schema]  from information_schema.columns
where table_schema = 'dbo'
order by Table_name,COLUMN_NAME



--3 написать функцию, которая покажет список всех полей определённой таблицы, имя которой передаётся 
--как параметр. если есть несколько одноимённых таблиц (в разных БД) - показать информацию по каждой
 --таблице. кроме названия поля указать его тип, поддержку нулевых значений и перечень всех ограничений
USE Library
CREATE TABLE #RowCountsAndSizes (TableName NVARCHAR(128),rows CHAR(11),      
       reserved VARCHAR(18),data VARCHAR(18),index_size VARCHAR(18), 
       unused VARCHAR(18))

EXEC       sp_MSForEachTable 'INSERT INTO #RowCountsAndSizes EXEC sp_spaceused ''?'' '

SELECT     TableName,CONVERT(bigint,rows) AS NumberOfRows, 
           CONVERT(bigint,left(reserved,len(reserved)-3)) AS SizeinKB
FROM       #RowCountsAndSizes 
ORDER BY   NumberOfRows DESC,SizeinKB DESC,TableName

DROP TABLE #RowCountsAndSizes


--3 написать функцию, которая покажет список всех полей определённой таблицы, имя которой передаётся 
--как параметр. если есть несколько одноимённых таблиц (в разных БД) - показать информацию по каждой
 --таблице. кроме названия поля указать его тип, поддержку нулевых значений и перечень всех ограничений
USE Library
GO
CREATE FUNCTION ListField()
RETURNS TABLE AS RETURN
(SELECT TABLE_SCHEMA ,
       TABLE_CATALOG,
	   TABLE_NAME ,
       COLUMN_NAME ,
       ORDINAL_POSITION ,
       COLUMN_DEFAULT ,
       DATA_TYPE ,
       CHARACTER_MAXIMUM_LENGTH ,
       NUMERIC_PRECISION ,
       NUMERIC_PRECISION_RADIX ,
       NUMERIC_SCALE ,
       DATETIME_PRECISION
FROM   INFORMATION_SCHEMA.COLUMNS
Where TABLE_NAME Like 'users')
GO
SELECT *
FROM dbo.ListField()
IF EXISTS(
SELECT
  			*
  		FROM
  			INFORMATION_SCHEMA.COLUMNS
  		WHERE
  			TABLE_NAME = 'users'
			)
SELECT TABLE_SCHEMA ,
       TABLE_CATALOG,
	   TABLE_NAME ,
       COLUMN_NAME ,
       ORDINAL_POSITION ,
       COLUMN_DEFAULT ,
       DATA_TYPE ,
       CHARACTER_MAXIMUM_LENGTH ,
       NUMERIC_PRECISION ,
       NUMERIC_PRECISION_RADIX ,
       NUMERIC_SCALE ,
       DATETIME_PRECISION AS search_result FROM   INFORMATION_SCHEMA.COLUMNS  ELSE SELECT 'not found' AS search_result


DROP FUNCTION ListField1

USE Library
GO
CREATE FUNCTION ListField1()
RETURNS TABLE AS RETURN
(SELECT TABLE_SCHEMA ,
       TABLE_NAME ,
       COLUMN_NAME ,
       ORDINAL_POSITION ,
       COLUMN_DEFAULT ,
       DATA_TYPE ,
       CHARACTER_MAXIMUM_LENGTH ,
       NUMERIC_PRECISION ,
       NUMERIC_PRECISION_RADIX ,
       NUMERIC_SCALE ,
       DATETIME_PRECISION
FROM   INFORMATION_SCHEMA.COLUMNS
Where TABLE_CATALOG Like 'Library')
GO
SELECT *
FROM dbo.ListField()
DROP FUNCTION ListFields

















--4 написать функцию, которая покажет количество присоединённых к серверу пользователей
GO 
CREATE FUNCTION ListUsers()
RETURNS TABLE AS
RETURN
(SELECT DP1.name AS DatabaseRoleName,   
   isnull (DP2.name, 'No members') AS DatabaseUserName   
 FROM sys.database_role_members AS DRM  
 RIGHT OUTER JOIN sys.database_principals AS DP1  
   ON DRM.role_principal_id = DP1.principal_id  
 LEFT OUTER JOIN sys.database_principals AS DP2  
   ON DRM.member_principal_id = DP2.principal_id  
WHERE DP1.type = 'R'
)
GO 
SELECT * FROM dbo.ListUsers()

--ORDER BY DP1.name



USE Library
GO
CREATE PROCEDURE listTable 
AS 
SELECT
s.Name AS SchemaName,
t.Name AS TableName,
p.rows AS RowCounts,
CAST(ROUND((SUM(a.used_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Used_MB,
CAST(ROUND((SUM(a.total_pages) - SUM(a.used_pages)) / 128.00, 2) AS NUMERIC(36, 2)) AS Unused_MB,
CAST(ROUND((SUM(a.total_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Total_MB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
GROUP BY t.Name, s.Name, p.Rows
ORDER BY s.Name, t.Name
EXEC listTable
GO
DROP PROCEDURE listTable

USE Library
GO
SET NOCOUNT ON
DECLARE @TableInfo TABLE (tablename varchar(255), rowcounts int, reserved varchar(255), DATA varchar(255), index_size varchar(255), unused varchar(255))
DECLARE @cmd1 varchar(500)
SET @cmd1 = 'exec sp_spaceused ''?'''
INSERT INTO @TableInfo (tablename,rowcounts,reserved,DATA,index_size,unused)
EXEC sp_msforeachtable @command1=@cmd1
SELECT * FROM @TableInfo ORDER BY Convert(int,Replace(DATA,' KB','')) DESC


USE Library
GO
CREATE FUNCTION ListField()
RETURNS TABLE AS RETURN
(SELECT TABLE_SCHEMA ,
       TABLE_CATALOG,
	   TABLE_NAME ,
       COLUMN_NAME ,
       ORDINAL_POSITION ,
       COLUMN_DEFAULT ,
       DATA_TYPE ,
       CHARACTER_MAXIMUM_LENGTH ,
       NUMERIC_PRECISION ,
       NUMERIC_PRECISION_RADIX ,
       NUMERIC_SCALE ,
       DATETIME_PRECISION
FROM   INFORMATION_SCHEMA.COLUMNS
Where TABLE_NAME Like 'users')
GO
SELECT *
FROM dbo.ListField()
IF EXISTS(
SELECT
  			*
  		FROM
  			INFORMATION_SCHEMA.COLUMNS
  		WHERE
  			TABLE_NAME = 'users'
			)
SELECT TABLE_SCHEMA ,
       TABLE_CATALOG,
	   TABLE_NAME ,
       COLUMN_NAME ,
       ORDINAL_POSITION ,
       COLUMN_DEFAULT ,
       DATA_TYPE ,
       CHARACTER_MAXIMUM_LENGTH ,
       NUMERIC_PRECISION ,
       NUMERIC_PRECISION_RADIX ,
       NUMERIC_SCALE ,
       DATETIME_PRECISION AS search_result FROM INFORMATION_SCHEMA.COLUMNS  ELSE SELECT 'not found' AS search_result
