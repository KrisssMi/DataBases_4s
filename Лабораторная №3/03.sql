/*3.*/ 
/*Удаление столбца из таблицы*/
USE UNIVERSITY;
ALTER Table Students DROP Column Дата_рождения;
/*Добавление столбца в таблицу*/
ALTER Table Students ADD Дата_рождения date;
ALTER Table Students ADD Пол nchar(1) default 'м' check (Пол in ('м', 'ж')); 
/*Удаление таблицы Студенты: DROP table Students*/