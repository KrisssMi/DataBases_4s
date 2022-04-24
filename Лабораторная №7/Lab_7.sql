use UNIVER;

--1:
-- Разработать представление с именем Преподаватель

create view [Преподаватель]
as select TEACHER.TEACHER [Код],
		TEACHER.TEACHER_NAME [Имя преподавателя],
		TEACHER.GENDER [Пол],
		TEACHER.PULPIT [Код кафедры]
from TEACHER;

-- Удаление представления:
--drop view [Преподаватель]



--2:
-- Разработать и создать представление с именем Количество кафедр

create view [Количество кафедр]
	as select FACULTY.FACULTY_NAME [Факультет],
			count(PULPIT.PULPIT)[Количество кафедр]
			from FACULTY inner join PULPIT
			on FACULTY.FACULTY=PULPIT.FACULTY
			group by FACULTY_NAME

select * from [Количество кафедр];



--3:
-- Разработать и создать представление с именем Аудитории.

create view [Аудитории]
	as select AUDITORIUM.AUDITORIUM [Код],
				AUDITORIUM.AUDITORIUM_NAME [Наименование аудитории]
			from AUDITORIUM
			where AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%';

alter view [Аудитории]
	as select AUDITORIUM.AUDITORIUM [Код],
				AUDITORIUM.AUDITORIUM_NAME [Наименование аудитории],
				AUDITORIUM.AUDITORIUM_TYPE [Тип аудитории]
			from AUDITORIUM
			where AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%';

--select * from [Аудитории];



--4:
-- Разработать и создать представление с именем Лекционные_аудитории

create view [Лекционные аудитории]
	as select AUDITORIUM.AUDITORIUM [Код],
				AUDITORIUM.AUDITORIUM_NAME [Наименование аудитории]
			from AUDITORIUM
			where AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%' WITH CHECK OPTION;
			go

--select * from [Лекционные аудитории]
--insert [Лекционные аудитории] values ('301-1', '301-1');



--5:
-- Разработать представление с именем Дисциплины

create view [Дисциплины] (Код, Наименование, Кафедра)
	as select TOP 150 SUBJECT, SUBJECT_NAME, SUBJECT.PULPIT
			from SUBJECT
				order by SUBJECT;

--select * from Дисциплины;



--6:
-- Изменить представление Количество_кафедр, созданное в задании 2 так, 
-- чтобы оно было привязано к базовым таблицам.
-- Опция SCHEMABINDING устанавливает запрещение на операции с таблицами и представлениями, которые могут привести к нарушению работоспособности представления)

alter view [Количество кафедр] with schemabinding
	as select FACULTY.FACULTY_NAME [факультет],
			count(PULPIT.FACULTY) [количество]
		from dbo.FACULTY join dbo.PULPIT
			on FACULTY.FACULTY = PULPIT.FACULTY
		group by FACULTY.FACULTY_NAME
go

select * from [Количество кафедр]



--7:
-- Разработать представление для таблицы TIMETABLE (лабораторная работа 6) в виде расписания. 
-- Изучить оператор PIVOT и использовать его.

-- PIVOT(агрегатная функция
-- FOR столбец, содержащий значения, которые станут именами столбцов
-- IN ([значения по горизонтали],…)
-- ) AS псевдоним таблицы (обязательно)

create view Расписание
	as select top(100) [День], [Пара], [1 группа], [2 группа], [4 группа], [5 группа], [6 группа], [7 группа], [8 группа], [9 группа], [10 группа]
		from (select top(100) DAY_NAME [День],
				convert(varchar, LESSON) [Пара],
				convert(varchar, IDGROUP) + ' группа' [Группа],
				[SUBJECT] + ' ' + AUDITORIUM [Дисциплина и аудитория]
			from TIMETABLE) tbl
		pivot
			(max([Дисциплина и аудитория]) 
			for [Группа]
			in ([1 группа], [2 группа], [4 группа], [5 группа], [6 группа], [7 группа], [8 группа], [9 группа], [10 группа])
			) as pvt
			order by 
				(case
					 when [День] like 'пн' then 1
					 when [День] like 'вт' then 2
					 when [День] like 'ср' then 3
					 when [День] like 'чт' then 4
					 when [День] like 'пт' then 5
					 when [День] like 'сб' then 6
				 end), [Пара] asc
go
select * from Расписание