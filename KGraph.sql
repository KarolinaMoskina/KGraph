USE MASTER
GO
DROP DATABASE IF EXISTS KGraph
GO
CREATE DATABASE KGraph
GO
USE KGraph
GO

-- Создание таблиц узлов
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

-- Создание таблиц ребер
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

-- Заполнение таблицы Users
INSERT INTO Users (UserID, Name, Age, City, RegistrationDate) VALUES
(1, 'Алексей Петров', 28, 'Москва', '2020-01-15'),
(2, 'Мария Сидорова', 24, 'Санкт-Петербург', '2020-02-20'),
(3, 'Иван Иванов', 30, 'Новосибирск', '2020-03-10'),
(4, 'Елена Кузнецова', 22, 'Екатеринбург', '2020-04-05'),
(5, 'Дмитрий Смирнов', 35, 'Казань', '2020-05-12'),
(6, 'Ольга Васильева', 29, 'Москва', '2020-06-18'),
(7, 'Сергей Михайлов', 31, 'Санкт-Петербург', '2020-07-22'),
(8, 'Анна Федорова', 27, 'Новосибирск', '2020-08-30'),
(9, 'Павел Николаев', 33, 'Екатеринбург', '2020-09-14'),
(10, 'Юлия Павлова', 26, 'Казань', '2020-10-25'),
(11, 'Александр Белов', 40, 'Москва', '2020-11-03'),
(12, 'Татьяна Орлова', 23, 'Санкт-Петербург', '2020-12-17');

-- Заполнение таблицы Books
INSERT INTO Books (BookID, Title, Author, PublicationYear, AverageRating) VALUES
(1, 'Мастер и Маргарита', 'Михаил Булгаков', 1967, 4.8),
(2, 'Преступление и наказание', 'Федор Достоевский', 1866, 4.7),
(3, 'Война и мир', 'Лев Толстой', 1869, 4.6),
(4, '1984', 'Джордж Оруэлл', 1949, 4.5),
(5, 'Три товарища', 'Эрих Мария Ремарк', 1936, 4.7),
(6, 'Маленький принц', 'Антуан де Сент-Экзюпери', 1943, 4.9),
(7, 'Гарри Поттер и философский камень', 'Джоан Роулинг', 1997, 4.8),
(8, 'Убить пересмешника', 'Харпер Ли', 1960, 4.7),
(9, 'Тень горы', 'Грегори Дэвид Робертс', 2015, 4.6),
(10, 'Атлант расправил плечи', 'Айн Рэнд', 1957, 4.3),
(11, 'Шантарам', 'Грегори Дэвид Робертс', 2003, 4.7),
(12, 'Цветы для Элджернона', 'Дэниел Киз', 1966, 4.8),
(13, 'Портрет Дориана Грея', 'Оскар Уайльд', 1890, 4.6),
(14, 'Над пропастью во ржи', 'Джером Сэлинджер', 1951, 4.4),
(15, 'Алхимик', 'Пауло Коэльо', 1988, 4.5);

-- Заполнение таблицы Genres
INSERT INTO Genres (GenreID, Name, Description) VALUES
(1, 'Классика', 'Классическая литература'),
(2, 'Фантастика', 'Научная фантастика и фэнтези'),
(3, 'Роман', 'Художественная проза о любви'),
(4, 'Драма', 'Серьезные произведения с глубоким сюжетом'),
(5, 'Философия', 'Книги, затрагивающие философские темы'),
(6, 'Антиутопия', 'Произведения о мрачном будущем'),
(7, 'Приключения', 'Захватывающие приключенческие истории'),
(8, 'Психология', 'Книги о психологии человека'),
(9, 'Биография', 'Жизнеописания реальных людей'),
(10, 'Детская литература', 'Книги для детей');

-- 1. Дружеские связи 
INSERT INTO Friends ($from_id, $to_id, Since, FriendshipLevel) VALUES
-- Алексей (1) дружит с Марией (2) и Иваном (3)
((SELECT $node_id FROM Users WHERE UserID = 1), (SELECT $node_id FROM Users WHERE UserID = 2), '2020-03-15', 'Close'),
((SELECT $node_id FROM Users WHERE UserID = 2), (SELECT $node_id FROM Users WHERE UserID = 1), '2020-03-15', 'Close'),
((SELECT $node_id FROM Users WHERE UserID = 1), (SELECT $node_id FROM Users WHERE UserID = 3), '2020-04-20', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 3), (SELECT $node_id FROM Users WHERE UserID = 1), '2020-04-20', 'Medium'),

-- Мария (2) дружит с Еленой (4)
((SELECT $node_id FROM Users WHERE UserID = 2), (SELECT $node_id FROM Users WHERE UserID = 4), '2020-05-12', 'Close'),
((SELECT $node_id FROM Users WHERE UserID = 4), (SELECT $node_id FROM Users WHERE UserID = 2), '2020-05-12', 'Close'),

-- Иван (3) дружит с Дмитрием (5)
((SELECT $node_id FROM Users WHERE UserID = 3), (SELECT $node_id FROM Users WHERE UserID = 5), '2020-06-18', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 5), (SELECT $node_id FROM Users WHERE UserID = 3), '2020-06-18', 'Medium'),

-- Елена (4) дружит с Ольгой (6)
((SELECT $node_id FROM Users WHERE UserID = 4), (SELECT $node_id FROM Users WHERE UserID = 6), '2020-07-30', 'Close'),
((SELECT $node_id FROM Users WHERE UserID = 6), (SELECT $node_id FROM Users WHERE UserID = 4), '2020-07-30', 'Close'),

-- Дмитрий (5) дружит с Сергеем (7)
((SELECT $node_id FROM Users WHERE UserID = 5), (SELECT $node_id FROM Users WHERE UserID = 7), '2020-08-22', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 7), (SELECT $node_id FROM Users WHERE UserID = 5), '2020-08-22', 'Medium'),

-- Анна (8) дружит с Павлом (9)
((SELECT $node_id FROM Users WHERE UserID = 8), (SELECT $node_id FROM Users WHERE UserID = 9), '2020-08-22', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 9), (SELECT $node_id FROM Users WHERE UserID = 8), '2020-08-22', 'Medium'),

-- Юлия (10) дружит с Дмитрием (5), Александром (11)
((SELECT $node_id FROM Users WHERE UserID = 10), (SELECT $node_id FROM Users WHERE UserID = 5), '2020-08-22', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 5), (SELECT $node_id FROM Users WHERE UserID = 10), '2020-08-22', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 10), (SELECT $node_id FROM Users WHERE UserID = 11), '2020-08-22', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 11), (SELECT $node_id FROM Users WHERE UserID = 10), '2020-08-22', 'Medium'),

-- Татьяна (12) дружит с Иваном (3) и Анной (8)
((SELECT $node_id FROM Users WHERE UserID = 12), (SELECT $node_id FROM Users WHERE UserID = 3), '2020-08-22', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 3), (SELECT $node_id FROM Users WHERE UserID = 12), '2020-08-22', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 12), (SELECT $node_id FROM Users WHERE UserID = 8), '2020-08-22', 'Medium'),
((SELECT $node_id FROM Users WHERE UserID = 8), (SELECT $node_id FROM Users WHERE UserID = 12), '2020-08-22', 'Medium');

-- 2. Книги, прочитанные пользователями 
INSERT INTO ReadBooks ($from_id, $to_id, ReadDate, Rating, Review) VALUES
-- Алексей (1) читал книги 1, 2, 7
((SELECT $node_id FROM Users WHERE UserID = 1), (SELECT $node_id FROM Books WHERE BookID = 1), '2020-02-15', 5, 'Шедевр'),
((SELECT $node_id FROM Users WHERE UserID = 1), (SELECT $node_id FROM Books WHERE BookID = 2), '2020-03-20', 4, 'Глубоко'),
((SELECT $node_id FROM Users WHERE UserID = 1), (SELECT $node_id FROM Books WHERE BookID = 7), '2020-08-10', 5, 'Увлекательно'),

-- Мария (2) читала книги 4, 6
((SELECT $node_id FROM Users WHERE UserID = 2), (SELECT $node_id FROM Books WHERE BookID = 4), '2020-04-25', 5, 'Актуально'),
((SELECT $node_id FROM Users WHERE UserID = 2), (SELECT $node_id FROM Books WHERE BookID = 6), '2020-06-30', 5, 'Трогательно'),

-- Иван (3) читал книги 3, 5
((SELECT $node_id FROM Users WHERE UserID = 3), (SELECT $node_id FROM Books WHERE BookID = 3), '2020-05-18', 5, 'Эпично'),
((SELECT $node_id FROM Users WHERE UserID = 3), (SELECT $node_id FROM Books WHERE BookID = 5), '2020-07-22', 4, 'О дружбе'),

-- Елена (4) читала книги 1, 2
((SELECT $node_id FROM Users WHERE UserID = 4), (SELECT $node_id FROM Books WHERE BookID = 1), '2020-06-05', 5, 'Важно'),
((SELECT $node_id FROM Users WHERE UserID = 4), (SELECT $node_id FROM Books WHERE BookID = 2), '2020-08-20', 5, 'Трогательно'),

-- Дмитрий (5) читал книги 9, 10
((SELECT $node_id FROM Users WHERE UserID = 5), (SELECT $node_id FROM Books WHERE BookID = 9), '2020-07-15', 4, 'Интересно'),
((SELECT $node_id FROM Users WHERE UserID = 5), (SELECT $node_id FROM Books WHERE BookID = 10), '2020-09-28', 3, 'Сложно'),

-- Ольга (6) читала книгу 1
((SELECT $node_id FROM Users WHERE UserID = 6), (SELECT $node_id FROM Books WHERE BookID = 1), '2020-08-25', 5, 'Любимая');

-- 3. Связи книг с жанрами 
INSERT INTO BookGenres ($from_id, $to_id, IsPrimaryGenre) VALUES
-- Мастер и Маргарита (1) - Классика (1), Драма (4)
((SELECT $node_id FROM Books WHERE BookID = 1), (SELECT $node_id FROM Genres WHERE GenreID = 1), 1),
((SELECT $node_id FROM Books WHERE BookID = 1), (SELECT $node_id FROM Genres WHERE GenreID = 4), 0),

-- Преступление и наказание (2) - Классика (1), Драма (4)
((SELECT $node_id FROM Books WHERE BookID = 2), (SELECT $node_id FROM Genres WHERE GenreID = 1), 1),
((SELECT $node_id FROM Books WHERE BookID = 2), (SELECT $node_id FROM Genres WHERE GenreID = 4), 0),

-- Война и мир (3) - Классика (1)
((SELECT $node_id FROM Books WHERE BookID = 3), (SELECT $node_id FROM Genres WHERE GenreID = 1), 1),

-- 1984 (4) - Антиутопия (6), Фантастика (2)
((SELECT $node_id FROM Books WHERE BookID = 4), (SELECT $node_id FROM Genres WHERE GenreID = 6), 1),
((SELECT $node_id FROM Books WHERE BookID = 4), (SELECT $node_id FROM Genres WHERE GenreID = 2), 0),

-- Три товарища (5) - Роман (3), Драма (4)
((SELECT $node_id FROM Books WHERE BookID = 5), (SELECT $node_id FROM Genres WHERE GenreID = 3), 1),
((SELECT $node_id FROM Books WHERE BookID = 5), (SELECT $node_id FROM Genres WHERE GenreID = 4), 0),

-- Маленький принц (6) - Детская (10), Философия (5)
((SELECT $node_id FROM Books WHERE BookID = 6), (SELECT $node_id FROM Genres WHERE GenreID = 10), 1),
((SELECT $node_id FROM Books WHERE BookID = 6), (SELECT $node_id FROM Genres WHERE GenreID = 5), 0),

-- Гарри Поттер (7) - Фантастика (2)
((SELECT $node_id FROM Books WHERE BookID = 7), (SELECT $node_id FROM Genres WHERE GenreID = 2), 1);

-- Найти друзей пользователя с id = 1
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

-- Найти книги, которые читали друзья пользователя с ID=2
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


-- Найти книги определенного жанра ("Классика"), которые читал пользователь с ID=3
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
    AND g.Name = 'Классика'
ORDER BY 
    rb.Rating DESC;


-- Найти рекомендуемые книги (которые читали друзья пользователя с ID=5)
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

-- Кто из друзей пользователя (ID=2) читал книгу "Мастер и Маргарита"?
SELECT f.Name AS FriendName, rb.Rating, rb.ReadDate
FROM Users u, Friends fr, Users f, ReadBooks rb, Books b
WHERE MATCH(u-(fr)->f-(rb)->b)
AND u.UserID = 2
AND b.Title = 'Мастер и Маргарита'
ORDER BY rb.Rating DESC;

SELECT u1.Name AS PersonName,
       STRING_AGG(u2.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS FriendsChain
FROM Users AS u1,
     Friends FOR PATH AS f,
     Users FOR PATH AS u2
WHERE MATCH(SHORTEST_PATH(u1(-(f)->u2)+))
  AND u1.Name = 'Алексей Петров';

  SELECT u1.Name AS PersonName,
       STRING_AGG(u2.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS FriendsChain
FROM Users AS u1,
     Friends FOR PATH AS f,
     Users FOR PATH AS u2
WHERE MATCH(SHORTEST_PATH(u1(-(f)->u2){1,2}))
  AND u1.Name = 'Елена Кузнецова';


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