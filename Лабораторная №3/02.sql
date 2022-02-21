/*2.*/
/*Создание таблицы Группы*/
USE UNIVERSITY;
CREATE table Groups
( 
Идентификатор_группы int primary key,
Факультет nvarchar(5)
);

/*Создание таблицы Студенты*/
CREATE table Students 
( 
Номер_зачетки int primary key,
Фамилия_студента nvarchar(30),
Имя_студента nvarchar(20),
Группа int foreign key references Groups(Идентификатор_группы),
Дата_рождения date
);