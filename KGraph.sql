USE MASTER
GO
DROP DATABASE IF EXISTS KGraph
GO
CREATE DATABASE KGraph
GO
USE KGraph
GO

-- �������� ������ �����
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Age INT,
    City NVARCHAR(100),
    RegistrationDate DATE
) AS NODE;

CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title NVARCHAR(100) NOT NULL,
    Author NVARCHAR(100),
    PublicationYear INT,
    AverageRating DECIMAL(3,2)
) AS NODE;

CREATE TABLE Genres (
    GenreID INT PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Description NVARCHAR(255)
) AS NODE;

-- �������� ������ �����
CREATE TABLE Friends (
    Since DATE,
    FriendshipLevel NVARCHAR(20)
) AS EDGE;

CREATE TABLE ReadBooks (
    ReadDate DATE,
    Rating INT,
    Review NVARCHAR(MAX)
) AS EDGE;

CREATE TABLE BookGenres (
    IsPrimaryGenre BIT
) AS EDGE;

-- ���������� ������� Users
INSERT INTO Users (UserID, Name, Age, City, RegistrationDate) VALUES
(1, '������� ������', 28, '������', '2020-01-15'),
(2, '����� ��������', 24, '�����-���������', '2020-02-20'),
(3, '���� ������', 30, '�����������', '2020-03-10'),
(4, '����� ���������', 22, '������������', '2020-04-05'),
(5, '������� �������', 35, '������', '2020-05-12'),
(6, '����� ���������', 29, '������', '2020-06-18'),
(7, '������ ��������', 31, '�����-���������', '2020-07-22'),
(8, '���� ��������', 27, '�����������', '2020-08-30'),
(9, '����� ��������', 33, '������������', '2020-09-14'),
(10, '���� �������', 26, '������', '2020-10-25'),
(11, '��������� �����', 40, '������', '2020-11-03'),
(12, '������� ������', 23, '�����-���������', '2020-12-17');

-- ���������� ������� Books
INSERT INTO Books (BookID, Title, Author, PublicationYear, AverageRating) VALUES
(1, '������ � ���������', '������ ��������', 1967, 4.8),
(2, '������������ � ���������', '����� �����������', 1866, 4.7),
(3, '����� � ���', '��� �������', 1869, 4.6),
(4, '1984', '������ ������', 1949, 4.5),
(5, '��� ��������', '���� ����� ������', 1936, 4.7),
(6, '��������� �����', '������ �� ����-��������', 1943, 4.9),
(7, '����� ������ � ����������� ������', '����� �������', 1997, 4.8),
(8, '����� ������������', '������ ��', 1960, 4.7),
(9, '���� ����', '������� ����� �������', 2015, 4.6),
(10, '������ ��������� �����', '��� ����', 1957, 4.3),
(11, '��������', '������� ����� �������', 2003, 4.7),
(12, '����� ��� ����������', '������ ���', 1966, 4.8),
(13, '������� ������� ����', '����� ������', 1890, 4.6),
(14, '��� ��������� �� ���', '������ ���������', 1951, 4.4),
(15, '�������', '����� ������', 1988, 4.5);

-- ���������� ������� Genres
INSERT INTO Genres (GenreID, Name, Description) VALUES
(1, '��������', '������������ ����������'),
(2, '����������', '������� ���������� � �������'),
(3, '�����', '�������������� ����� � �����'),
(4, '�����', '��������� ������������ � �������� �������'),
(5, '���������', '�����, ������������� ����������� ����'),
(6, '����������', '������������ � ������� �������'),
(7, '�����������', '������������� ��������������� �������'),
(8, '����������', '����� � ���������� ��������'),
(9, '���������', '������������� �������� �����'),
(10, '������� ����������', '����� ��� �����');

-- 1. ��������� ����� 
INSERT INTO Friends ($from_id, $to_id, Since, FriendshipLevel) VALUES
-- ������� (1) ������ � ������ (2) � ������ (3)
((SELECT $node_id FROM Users WHERE UserID = 1), (SELECT $node_id FROM Users WHERE UserID = 2), '2020-03-15', 'Close'),
((SELECT $node_id FROM Users WHERE UserID = 2), (SELECT $node_id FROM Users WHERE UserID = 1), '2020-03-15', 'Close'),
((SELECT $node_id FROM Users WHERE UserID = 1), (SELECT $node_id FROM Users WHERE UserID = 3), '2020-04-20', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 3), (SELECT $node_id FROM Users WHERE UserID = 1), '2020-04-20', 'Medium'),

-- ����� (2) ������ � ������ (4)
((SELECT $node_id FROM Users WHERE UserID = 2), (SELECT $node_id FROM Users WHERE UserID = 4), '2020-05-12', 'Close'),
((SELECT $node_id FROM Users WHERE UserID = 4), (SELECT $node_id FROM Users WHERE UserID = 2), '2020-05-12', 'Close'),

-- ���� (3) ������ � �������� (5)
((SELECT $node_id FROM Users WHERE UserID = 3), (SELECT $node_id FROM Users WHERE UserID = 5), '2020-06-18', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 5), (SELECT $node_id FROM Users WHERE UserID = 3), '2020-06-18', 'Medium'),

-- ����� (4) ������ � ������ (6)
((SELECT $node_id FROM Users WHERE UserID = 4), (SELECT $node_id FROM Users WHERE UserID = 6), '2020-07-30', 'Close'),
((SELECT $node_id FROM Users WHERE UserID = 6), (SELECT $node_id FROM Users WHERE UserID = 4), '2020-07-30', 'Close'),

-- ������� (5) ������ � ������� (7)
((SELECT $node_id FROM Users WHERE UserID = 5), (SELECT $node_id FROM Users WHERE UserID = 7), '2020-08-22', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 7), (SELECT $node_id FROM Users WHERE UserID = 5), '2020-08-22', 'Medium'),

-- ���� (8) ������ � ������ (9)
((SELECT $node_id FROM Users WHERE UserID = 8), (SELECT $node_id FROM Users WHERE UserID = 9), '2020-08-22', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 9), (SELECT $node_id FROM Users WHERE UserID = 8), '2020-08-22', 'Medium'),

-- ���� (10) ������ � �������� (5), ����������� (11)
((SELECT $node_id FROM Users WHERE UserID = 10), (SELECT $node_id FROM Users WHERE UserID = 5), '2020-08-22', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 5), (SELECT $node_id FROM Users WHERE UserID = 10), '2020-08-22', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 10), (SELECT $node_id FROM Users WHERE UserID = 11), '2020-08-22', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 11), (SELECT $node_id FROM Users WHERE UserID = 10), '2020-08-22', 'Medium'),

-- ������� (12) ������ � ������ (3) � ����� (8)
((SELECT $node_id FROM Users WHERE UserID = 12), (SELECT $node_id FROM Users WHERE UserID = 3), '2020-08-22', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 3), (SELECT $node_id FROM Users WHERE UserID = 12), '2020-08-22', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 12), (SELECT $node_id FROM Users WHERE UserID = 8), '2020-08-22', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 8), (SELECT $node_id FROM Users WHERE UserID = 12), '2020-08-22', 'Medium');

-- 2. �����, ����������� �������������� 
INSERT INTO ReadBooks ($from_id, $to_id, ReadDate, Rating, Review) VALUES
-- ������� (1) ����� ����� 1, 2, 7
((SELECT $node_id FROM Users WHERE UserID = 1), (SELECT $node_id FROM Books WHERE BookID = 1), '2020-02-15', 5, '������'),
((SELECT $node_id FROM Users WHERE UserID = 1), (SELECT $node_id FROM Books WHERE BookID = 2), '2020-03-20', 4, '�������'),
((SELECT $node_id FROM Users WHERE UserID = 1), (SELECT $node_id FROM Books WHERE BookID = 7), '2020-08-10', 5, '������������'),

-- ����� (2) ������ ����� 4, 6
((SELECT $node_id FROM Users WHERE UserID = 2), (SELECT $node_id FROM Books WHERE BookID = 4), '2020-04-25', 5, '���������'),
((SELECT $node_id FROM Users WHERE UserID = 2), (SELECT $node_id FROM Books WHERE BookID = 6), '2020-06-30', 5, '�����������'),

-- ���� (3) ����� ����� 3, 5
((SELECT $node_id FROM Users WHERE UserID = 3), (SELECT $node_id FROM Books WHERE BookID = 3), '2020-05-18', 5, '������'),
((SELECT $node_id FROM Users WHERE UserID = 3), (SELECT $node_id FROM Books WHERE BookID = 5), '2020-07-22', 4, '� ������'),

-- ����� (4) ������ ����� 1, 2
((SELECT $node_id FROM Users WHERE UserID = 4), (SELECT $node_id FROM Books WHERE BookID = 1), '2020-06-05', 5, '�����'),
((SELECT $node_id FROM Users WHERE UserID = 4), (SELECT $node_id FROM Books WHERE BookID = 2), '2020-08-20', 5, '�����������'),

-- ������� (5) ����� ����� 9, 10
((SELECT $node_id FROM Users WHERE UserID = 5), (SELECT $node_id FROM Books WHERE BookID = 9), '2020-07-15', 4, '���������'),
((SELECT $node_id FROM Users WHERE UserID = 5), (SELECT $node_id FROM Books WHERE BookID = 10), '2020-09-28', 3, '������'),

-- ����� (6) ������ ����� 1
((SELECT $node_id FROM Users WHERE UserID = 6), (SELECT $node_id FROM Books WHERE BookID = 1), '2020-08-25', 5, '�������');

-- 3. ����� ���� � ������� 
INSERT INTO BookGenres ($from_id, $to_id, IsPrimaryGenre) VALUES
-- ������ � ��������� (1) - �������� (1), ����� (4)
((SELECT $node_id FROM Books WHERE BookID = 1), (SELECT $node_id FROM Genres WHERE GenreID = 1), 1),
((SELECT $node_id FROM Books WHERE BookID = 1), (SELECT $node_id FROM Genres WHERE GenreID = 4), 0),

-- ������������ � ��������� (2) - �������� (1), ����� (4)
((SELECT $node_id FROM Books WHERE BookID = 2), (SELECT $node_id FROM Genres WHERE GenreID = 1), 1),
((SELECT $node_id FROM Books WHERE BookID = 2), (SELECT $node_id FROM Genres WHERE GenreID = 4), 0),

-- ����� � ��� (3) - �������� (1)
((SELECT $node_id FROM Books WHERE BookID = 3), (SELECT $node_id FROM Genres WHERE GenreID = 1), 1),

-- 1984 (4) - ���������� (6), ���������� (2)
((SELECT $node_id FROM Books WHERE BookID = 4), (SELECT $node_id FROM Genres WHERE GenreID = 6), 1),
((SELECT $node_id FROM Books WHERE BookID = 4), (SELECT $node_id FROM Genres WHERE GenreID = 2), 0),

-- ��� �������� (5) - ����� (3), ����� (4)
((SELECT $node_id FROM Books WHERE BookID = 5), (SELECT $node_id FROM Genres WHERE GenreID = 3), 1),
((SELECT $node_id FROM Books WHERE BookID = 5), (SELECT $node_id FROM Genres WHERE GenreID = 4), 0),

-- ��������� ����� (6) - ������� (10), ��������� (5)
((SELECT $node_id FROM Books WHERE BookID = 6), (SELECT $node_id FROM Genres WHERE GenreID = 10), 1),
((SELECT $node_id FROM Books WHERE BookID = 6), (SELECT $node_id FROM Genres WHERE GenreID = 5), 0),

-- ����� ������ (7) - ���������� (2)
((SELECT $node_id FROM Books WHERE BookID = 7), (SELECT $node_id FROM Genres WHERE GenreID = 2), 1);

-- ����� ������ ������������ � id = 1
SELECT 
    u1.Name AS UserName,
    u2.Name AS FriendName,
    f.Since AS FriendsSince,
    f.FriendshipLevel
FROM 
    Users u1, Friends f, Users u2
WHERE 
    MATCH(u1-(f)->u2)
    AND u1.UserID = 1
ORDER BY 
    f.FriendshipLevel DESC, f.Since;

-- ����� �����, ������� ������ ������ ������������ � ID=2
SELECT DISTINCT
    u.Name AS FriendName,
    b.Title AS BookTitle,
    b.Author,
    rb.Rating,
    rb.ReadDate
FROM 
    Users mainUser, Friends f, Users u, ReadBooks rb, Books b
WHERE 
    MATCH(mainUser-(f)->u-(rb)->b)
    AND mainUser.UserID = 2
ORDER BY 
    rb.Rating DESC, rb.ReadDate;


-- ����� ����� ������������� ����� ("��������"), ������� ����� ������������ � ID=3
SELECT 
    b.Title AS BookTitle,
    g.Name AS Genre,
    rb.Rating,
    rb.ReadDate
FROM 
    Users u, ReadBooks rb, Books b, BookGenres bg, Genres g
WHERE 
    MATCH(u-(rb)->b-(bg)->g)
    AND u.UserID = 3
    AND g.Name = '��������'
ORDER BY 
    rb.Rating DESC;


-- ����� ������������� ����� (������� ������ ������ ������������ � ID=5)
SELECT DISTINCT
    b.Title AS RecommendedBook,
    b.Author,
    STRING_AGG(u.Name, ', ') AS RecommendedByFriends
FROM 
    Users mainUser, Friends f, Users u, ReadBooks rb, Books b
WHERE 
    MATCH(mainUser-(f)->u-(rb)->b)
    AND mainUser.UserID = 5
GROUP BY 
    b.Title, b.Author
ORDER BY 
    RecommendedBook;

-- ��� �� ������ ������������ (ID=2) ����� ����� "������ � ���������"?
SELECT f.Name AS FriendName, rb.Rating, rb.ReadDate
FROM Users u, Friends fr, Users f, ReadBooks rb, Books b
WHERE MATCH(u-(fr)->f-(rb)->b)
AND u.UserID = 2
AND b.Title = '������ � ���������'
ORDER BY rb.Rating DESC;

SELECT u1.Name AS PersonName,
       STRING_AGG(u2.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS FriendsChain
FROM Users AS u1,
     Friends FOR PATH AS f,
     Users FOR PATH AS u2
WHERE MATCH(SHORTEST_PATH(u1(-(f)->u2)+))
  AND u1.Name = '������� ������';

  SELECT u1.Name AS PersonName,
       STRING_AGG(u2.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS FriendsChain
FROM Users AS u1,
     Friends FOR PATH AS f,
     Users FOR PATH AS u2
WHERE MATCH(SHORTEST_PATH(u1(-(f)->u2){1,2}))
  AND u1.Name = '����� ���������';


SELECT U1.UserId AS IdFirst
	, U1.name AS First
	, CONCAT(N'user (', U1.UserId, ')') AS [First image name]
	, U2.UserId AS IdSecond
	, U2.name AS Second
	, CONCAT(N'user (', U2.UserId, ')') AS [Second image name]
FROM Users AS U1
	, Friends AS f
	, Users AS U2
WHERE MATCH(U1-(f)->U2)

SELECT B.BookId AS IdSecond
	, B.title AS Second
	, CONCAT(N'book (', B.BookId, ')') AS [Second image name]
	, G.GenreId AS IdFirst
	, G.name AS First
	, CONCAT(N'genre (', G.GenreId, ')') AS [First image name]
FROM Books AS B
	, BookGenres AS bg
	, Genres AS G
WHERE MATCH(B-(bg)->G)

SELECT U.UserId AS IdFirst
	, U.name AS First
	, CONCAT(N'user (', U.UserId, ')') AS [First image name]
	, B.BookId AS IdSecond
	, B.title AS Second
	, CONCAT(N'book (', B.BookId, ')') AS [Second image name]
FROM Users AS U
	, ReadBooks AS rb
	, Books AS B
WHERE MATCH(U-(rb)->B)