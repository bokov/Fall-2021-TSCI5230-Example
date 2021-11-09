/*
This script can be found in a ready-to-run form (i.e. with an accompanying
anonymous database connection) here...
https://dbfiddle.uk/?rdbms=sqlserver_2019&fiddle=9f43020f3ab0c5804a859b7e98e70746
*/

-- schema
CREATE TABLE Departments (
    Id INT NOT NULL IDENTITY(1,1),
    Name VARCHAR(25) NOT NULL,
    PRIMARY KEY(Id)
);

CREATE TABLE Employees (
    Id INT NOT NULL IDENTITY(1,1),
    FName VARCHAR(35) NOT NULL,
    LName VARCHAR(35) NOT NULL,
    PhoneNumber VARCHAR(11),
    ManagerId INT,
    DepartmentId INT NOT NULL,
    Salary INT NOT NULL,
    HireDate DATETIME NOT NULL,
    PRIMARY KEY(Id),
    FOREIGN KEY (ManagerId) REFERENCES Employees(Id),
    FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);

CREATE TABLE Customers (
    Id INT NOT NULL IDENTITY(1,1),
    FName VARCHAR(35) NOT NULL,
    LName VARCHAR(35) NOT NULL,
    Email varchar(100) NOT NULL,
    PhoneNumber VARCHAR(11),
    PreferredContact VARCHAR(5) NOT NULL,
    PRIMARY KEY(Id)
);

CREATE TABLE Cars (
    Id INT NOT NULL IDENTITY(1,1),
    CustomerId INT NOT NULL,
    EmployeeId INT ,--NOT NULL,
    Model varchar(50) NOT NULL,
    Status varchar(25) NOT NULL,
    TotalCost INT NOT NULL,
    PRIMARY KEY(Id),
    FOREIGN KEY (CustomerId) REFERENCES Customers(Id),
    FOREIGN KEY (EmployeeId) REFERENCES Employees(Id)
);

SET IDENTITY_INSERT Departments ON;

-- data
INSERT INTO Departments
    (Id, Name)
VALUES
    (1, 'HR'),
    (2, 'Sales'),
    (3, 'Tech')
;

SET IDENTITY_INSERT Departments OFF;

SET IDENTITY_INSERT Employees   ON;

INSERT INTO Employees
    (Id, FName, LName, PhoneNumber, ManagerId, DepartmentId, Salary, HireDate)
VALUES
    (1, 'James', 'Smith', 1234567890, NULL, 1, 1000,    convert(datetime, '01-01-2002', 103)), -- dd/mm/yyyy
    (2, 'John', 'Johnson', 2468101214, '1', 1, 400,     convert(datetime, '23-03-2005', 103)),
    (3, 'Michael', 'Williams', 1357911131, '1', 2, 600, convert(datetime, '12-05-2009', 103)),
    (4, 'Johnathon', 'Smith', 1212121212, '2', 1, 500,  convert(datetime, '24-07-2016', 103))
;

SET IDENTITY_INSERT Employees   OFF;

SET IDENTITY_INSERT Customers   ON;

INSERT INTO Customers
    (Id, FName, LName, Email, PhoneNumber, PreferredContact)
VALUES
    (1, 'William', 'Jones', 'william.jones@example.com', '3347927472', 'PHONE'),
    (2, 'David', 'Miller', 'dmiller@example.net', '2137921892', 'EMAIL'),
    (3, 'Richard', 'Davis', 'richard0123@example.com', NULL, 'EMAIL')
;

SET IDENTITY_INSERT Customers   OFF;

SET IDENTITY_INSERT Cars        ON;

INSERT INTO Cars
    (Id, CustomerId, EmployeeId, Model, Status, TotalCost)
VALUES
    ('1', '1', '2', 'Ford F-150', 'READY', '230'),
    ('2', '1', '2', 'Ford F-150', 'READY', '200'),
    ('3', '2', '1', 'Ford Mustang', 'WAITING', '100'),
    ('4', '3', '3', 'Toyota Prius', 'WORKING', '1254'),
    ('5', '3', NULL, 'Tesla Grandstander', 'PENDING', '9254')
;

SET IDENTITY_INSERT Cars        OFF;





/*
This is what a 'generic' SQL query looks like:

SELECT
[ColumnName],[ColumnName], ...
FROM
[TableName]
WHERE ...
(optional)
AND ...
OR ...
(etc.)

Logical operators to use in your WHERE clause:
A = B : A is equal to B
A <> B : A is unequal to B
A >= B, A <= B, A > B, A < B : same as in other languages
A IN NULL : true if A is missing, false otherwise
A IN (1,2,3) : true if A is equal to any of the values on the right
A LIKE '%W%' : A matches the string on the right with
               %s s wildcards
*/

-- What about every department EXCEPT 1?
SELECT * FROM [Employees] WHERE [DepartmentID] <> 1;

-- Select all columns but only for department 1 employees
SELECT * FROM [Employees] WHERE [DepartmentID] = 1;

-- Select just the last name and department ID from Employees
SELECT LName, DepartmentId FROM Employees;

-- Select everything from the Employees table
SELECT * FROM Employees;

-- Select everything from the Departments table
SELECT * FROM Departments;

-- Select everything from the Cars tabls
SELECT * FROM Cars;




-- Every employee whose last name begins with S
SELECT * FROM Employees WHERE LName LIKE 'S%';

-- Every employee whose last name CONTAINS S
SELECT * FROM Employees WHERE LName LIKE '%S%';

-- Every employee whose last name CONTAINS S
SELECT * FROM Employees WHERE LName LIKE '%S';

-- Every employee whose last name contains two I's two spaces apart
SELECT * FROM Employees WHERE LName LIKE '%I__I%';



/* Persisting results to tables */
-- Normal table
DROP TABLE IF EXISTS MyTable00;
SELECT *
INTO MyTable00
FROM CARS
WHERE Status = 'WAITING'
;

-- Temporary table for duration of this session
DROP TABLE IF EXISTS #MyTable00;
SELECT *
INTO #MyTable00
FROM CARS
WHERE Status = 'WAITING'
;

-- Temporary table for duration of this session
DROP TABLE IF EXISTS ##MyTable00;
SELECT *
INTO ##MyTable00
FROM CARS
WHERE Status = 'WAITING'
;




/*
A generic query with multiple WITH statements

WITH firstResultSet AS ( ... SQL query goes here ... ),
     secondResultSet AS (... SQL query goes here ... ),
     ...
     lastResultSet AS (... SQL query goes here ... )
... your final SQL query ... ;


*/



-- In memory using a WITH clause
WITH
temp0 AS (
  SELECT Id,LName,ManagerId,DepartmentId,Salary,HireDate
  FROM Employees),
temp1 AS (
  SELECT * FROM temp0 WHERE DepartmentID <> 2),
temp3 AS (
  SELECT 'Hello World' Message)
SELECT * FROM temp1
;





-- If your query uses only static values, you dont' need a FROM (in Microsoft SQL Server)
SELECT 1;



-- Transforming some columns
SELECT Id
      ,UPPER(LName) AS LNAME
      ,LName + ', ' + FName  AS FullName
      ,ManagerId
      ,DepartmentId
      ,Salary * 4.0 AS MonthlyPay
      ,HireDate
FROM Employees


/************************************************************************************


RELATIONAL DATABASE OPERATIONS!!!!


A generic MULTI-table query

SELECT
[ColumnName],[ColumnName], ...
FROM
[TableName1] JOIN [TableName2] ON ...
WHERE ...


************************************************************************************/
-- Inner Join
SELECT Employees.Id
      ,Employees.FName
      ,Employees.LName
      ,Employees.DepartmentId
      ,Departments.Name AS Department
      ,Cars.Model
      ,Cars.Status
FROM
  Employees
  JOIN Departments ON Employees.DepartmentId = Departments.Id
  JOIN Cars ON Cars.EmployeeId = Employees.Id





-- Left join: keep everything on the left side and any matches from the right
SELECT Employees.Id
      ,Employees.FName
      ,Employees.LName
      ,Employees.DepartmentId
      ,Departments.Name AS Department
      ,Cars.Model
      ,Cars.Status
FROM
  Employees
  JOIN Departments ON Employees.DepartmentId = Departments.Id
  LEFT JOIN Cars ON Cars.EmployeeId = Employees.Id




-- Right join: keep everything on the left side and any matches from the right
-- Since all the cars are assigned to somebody, in THIS case it's just like the regular join
SELECT Employees.Id
      ,Employees.FName
      ,Employees.LName
      ,Employees.DepartmentId
      ,Departments.Name AS Department
      ,Cars.Model
      ,Cars.Status
FROM
  Employees
  JOIN Departments ON Employees.DepartmentId = Departments.Id
  RIGHT JOIN Cars ON Cars.EmployeeId = Employees.Id




-- outer join: keep everything from both sides
SELECT Employees.Id
      ,Employees.FName
      ,Employees.LName
      ,Employees.DepartmentId
      ,Departments.Name AS Department
      ,Cars.Model
      ,Cars.Status
FROM
  Employees
  JOIN Departments ON Employees.DepartmentId = Departments.Id
  FULL OUTER JOIN Cars ON Cars.EmployeeId = Employees.Id





/* Selection criteria for queries that use joins */
SELECT Employees.Id
      ,Employees.FName
      ,Employees.LName
      ,Employees.DepartmentId
      ,Departments.Name AS Department
      ,Cars.Model
      ,Cars.Status
      ,ROUND(Cars.TotalCost,-2) AS Cost
FROM
  Employees
  JOIN Departments ON Employees.DepartmentId = Departments.Id
  FULL OUTER JOIN Cars ON Cars.EmployeeId = Employees.Id
WHERE
  Cars.Status = 'READY'
  --AND Departments.Name = 'HR'
  AND ROUND(Cars.TotalCost,-2) >= 200






/* Selection criteria for queries that use joins */
SELECT Employees.Id
      ,Employees.FName
      ,Employees.LName
      ,Employees.DepartmentId
      ,Departments.Name AS Department
      ,Cars.Model
      ,Cars.Status
      ,ROUND(Cars.TotalCost,-2) AS Cost
FROM
  Employees
  JOIN Departments
    ON Employees.DepartmentId = Departments.Id
  LEFT JOIN Cars
    ON Cars.EmployeeId = Employees.Id
       AND Cars.Status <> 'READY'




