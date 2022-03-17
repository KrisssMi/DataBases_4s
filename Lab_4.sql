/*Создание запросов*/
use UNIVER;
--1
/*сформировать перечень кодов аудиторий и соответствующих им наименований типов аудиторий */
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPE
from AUDITORIUM_TYPE Inner Join AUDITORIUM
on AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE;


--2
/*сформировать перечень кодов аудиторий и соответствующих им наименований типов аудиторий */
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
from AUDITORIUM_TYPE Inner Join AUDITORIUM
on AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE And AUDITORIUM_TYPE.AUDITORIUM_TYPENAME Like '%компьютер%';


--3
/*два SELECT-запроса без применения INNER JOIN*/
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPE
from AUDITORIUM_TYPE, AUDITORIUM
where AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE

select T2.AUDITORIUM, T1.AUDITORIUM_TYPENAME		--через псевдонимы
from AUDITORIUM_TYPE As T1, AUDITORIUM As T2
where T1.AUDITORIUM_TYPE=T2.AUDITORIUM_TYPE And T1.AUDITORIUM_TYPENAME Like '%компьютер%';


--4
/*перечень студентов, получивших экзаменационные оценки (столбец PROGRESS.NOTE) от 6 до 8*/
select FACULTY.FACULTY, PULPIT.PULPIT, PROFESSION.PROFESSION_NAME, SUBJECT.SUBJECT_NAME, STUDENT.NAME,
case
	when (PROGRESS.NOTE=6) then 'шесть'
	when (PROGRESS.NOTE=7) then 'семь'
	when (PROGRESS.NOTE=8) then 'восемь'
	end [PROGRESS.NOTE] from PROGRESS
inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
inner join [SUBJECT] on [SUBJECT].[SUBJECT] = PROGRESS.[SUBJECT]
inner join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
inner join PROFESSION on PROFESSION.PROFESSION = GROUPS.PROFESSION
inner join PULPIT on PULPIT.PULPIT=[SUBJECT].PULPIT
inner join FACULTY on FACULTY.FACULTY = PULPIT.FACULTY
where PROGRESS.NOTE between 6 and 8

/*Результирующий набор отсортировать в порядке возрастания по столбцам FACULTY.FACULTY, PULPIT.PULPIT, PROFESSION.PROFESSION, 
STUDENT.STUDENT_NAME и в порядке убывания по столбцу PROGRESS.NOTE.*/
--asc в порядке возрастания
--desc в порядке убывания
order by PROGRESS.NOTE desc, FACULTY.FACULTY asc, PULPIT.PULPIT asc, PROFESSION.PROFESSION asc, STUDENT.NAME asc


--5
/*сначала выводятся строки с оценкой 7, затем строки с оценкой 8 и далее строки с оценкой 6:*/
select FACULTY.FACULTY, PULPIT.PULPIT, PROFESSION.PROFESSION_NAME, SUBJECT.SUBJECT_NAME, STUDENT.NAME,
case
	when (PROGRESS.NOTE=6) then 'шесть'
	when (PROGRESS.NOTE=7) then 'семь'
	when (PROGRESS.NOTE=8) then 'восемь'
	end [PROGRESS.NOTE] from PROGRESS
inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
inner join [SUBJECT] on [SUBJECT].[SUBJECT] = PROGRESS.[SUBJECT]
inner join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
inner join PROFESSION on PROFESSION.PROFESSION = GROUPS.PROFESSION
inner join PULPIT on PULPIT.PULPIT=[SUBJECT].PULPIT
inner join FACULTY on FACULTY.FACULTY = PULPIT.FACULTY
where PROGRESS.NOTE between 6 and 8
order by
(case
	when (PROGRESS.NOTE='6') then 3
	when (PROGRESS.NOTE='7') then 1
	when (PROGRESS.NOTE='8') then 2
	end);


--6
/*полный перечень кафедр (если на кафедре нет преподавателя - ***) */
select PULPIT.PULPIT_NAME [Кафедра], isnull (TEACHER.TEACHER_NAME, '***') [Преподаватель]
from PULPIT left outer join TEACHER
on PULPIT.PULPIT=TEACHER.PULPIT;



--7(1)
/*поменять порядок таблиц в выражении LEFT OUTER JOIN */
select PULPIT.PULPIT_NAME [Кафедра], isnull (TEACHER.TEACHER_NAME, '***') [Преподаватель]
from TEACHER left outer join PULPIT
on PULPIT.PULPIT=TEACHER.PULPIT;
------каждый преподаватель закреплён за конкретной кафедрой, поэтому, меняя порядок, NULL-значений не будет.

--7(2)
/*Переписать запрос таким образом, чтобы получился аналогичный результат, но применялось соединение таблиц RIGHT OUTER JOIN */
select PULPIT.PULPIT_NAME as 'Кафедра', isnull(TEACHER.TEACHER_NAME, '***') as 'Преподаватель'
from TEACHER right outer join PULPIT
on PULPIT.PULPIT=TEACHER.PULPIT;



--8(1)
/*запрос, результат которого содержит данные левой (в операции FULL OUTER JOIN) таблицы и не содержит данные правой; */
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
	from AUDITORIUM_TYPE full outer Join AUDITORIUM
	on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;

SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
	from AUDITORIUM full outer Join AUDITORIUM_TYPE
	on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;

--8(2)
/*запрос, результат которого содержит данные правой таблицы и не содержащие данные левой; */
SELECT * FROM AUDITORIUM left OUTER JOIN AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE

SELECT * FROM AUDITORIUM right OUTER JOIN AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE


--8(3)
/*запрос, результат которого содержит данные правой таблицы и левой таблиц;*/
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
	from AUDITORIUM Inner Join AUDITORIUM_TYPE 
	on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;
--inner
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
	from AUDITORIUM full outer Join AUDITORIUM_TYPE 
	on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;
--full включает inner



--9
/*Разработать SELECT-запрос на основе CROSS JOIN-соединения таблиц AUDITORIUM_TYPE и AUDITORIUM, формирующего результат, аналогичный результату, полученному при выполнении запроса в задании 1*/
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPE
from AUDITORIUM cross join AUDITORIUM_TYPE 
where AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;



--11
/*Создать таблицу TIMETABLE (Группа, аудитория, предмет, преподаватель, день недели, пара), установить связи с другими таблицами, заполнить данными. 
Написать запросы на наличие свободных аудиторий на определенную пару, на определенный день недели, наличие «окон» у преподавателей и в группах.*/
use UNIVER;
create table TIMETABLE (
DAY_NAME char(2) check (DAY_NAME in('пн', 'вт', 'ср', 'чт', 'пт', 'сб')),
LESSON integer check(LESSON between 1 and 4),
TEACHER char(10)  constraint TIMETABLE_TEACHER_FK  foreign key references TEACHER(TEACHER),
AUDITORIUM char(20) constraint TIMETABLE_AUDITORIUM_FK foreign key references AUDITORIUM(AUDITORIUM),
SUBJECT char(10) constraint TIMETABLE_SUBJECT_FK  foreign key references SUBJECT(SUBJECT),
IDGROUP integer constraint TIMETABLE_GROUP_FK  foreign key references GROUPS(IDGROUP),
)

insert into TIMETABLE 
values 
('пн', 1, 'СМЛВ', '313-1', 'СУБД', 2),
('пн', 2, 'СМЛВ', '313-1', 'ОАиП', 4),
('пн', 3, 'СМЛВ', '313-1', 'ОАиП', 11),

('пн', 1, 'МРЗ', '324-1', 'СУБД', 6),
('пн', 3, 'УРБ', '324-1', 'ПИС', 4),

('пн', 1, 'УРБ', '206-1', 'ПИС', 10),
('пн', 4, 'СМЛВ', '206-1', 'ОАиП', 3),

('пн', 1, 'БРКВЧ', '301-1', 'СУБД', 7),
('пн', 4, 'БРКВЧ', '301-1', 'ОАиП', 7),

('пн', 2, 'БРКВЧ', '413-1', 'СУБД', 8),

('пн', 2, 'ДТК', '423-1', 'СУБД', 7),
('пн', 4, 'ДТК', '423-1', 'ОАиП', 2),

('вт', 1, 'СМЛВ', '313-1', 'СУБД', 2),
('вт', 2, 'СМЛВ', '313-1', 'ОАиП', 4),

('вт', 3, 'УРБ', '324-1', 'ПИС', 4),
('вт', 4, 'СМЛВ', '206-1', 'ОАиП', 3);

-- ex 1: наличие свободных аудиторий на определенную пару
select AUDITORIUM as 'Аудитория, свободные на 1 паре в пн'
from AUDITORIUM a
except 
	(select a.AUDITORIUM
	from TIMETABLE T1, AUDITORIUM a
	where T1.DAY_NAME = 'пн' and T1.LESSON = 1 and a.AUDITORIUM = T1.AUDITORIUM)
order by AUDITORIUM asc

-- ex 2: на определенный день недели
select AUDITORIUM as 'Аудитории, свободные в пн'
from AUDITORIUM a
except 
	(select a.AUDITORIUM
	from TIMETABLE T1, AUDITORIUM a
	where T1.DAY_NAME = 'пн' and a.AUDITORIUM = T1.AUDITORIUM)
order by AUDITORIUM asc

-- ex3: наличие «окон» у преподавателей
select distinct T.TEACHER_NAME as 'Преподаватель', T1.DAY_NAME as 'День недели', T1.LESSON as 'Занятая пара'
from TEACHER T, TIMETABLE T1, TIMETABLE T2
where T.TEACHER = T1.TEACHER and T1.DAY_NAME = T2.DAY_NAME and T1.LESSON != T2.LESSON
order by T.TEACHER_NAME asc, T1.DAY_NAME desc, T1.LESSON asc

select distinct T.TEACHER_NAME as 'Преподаватель', T1.DAY_NAME as 'День недели', T1.LESSON as '"окна"'
from TEACHER T, TIMETABLE T1, TIMETABLE T2
except 
	(select distinct T.TEACHER_NAME, T1.DAY_NAME, T1.LESSON
	from TEACHER T, TIMETABLE T1, TIMETABLE T2
	where T.TEACHER = T1.TEACHER and T1.DAY_NAME = T2.DAY_NAME and T1.LESSON != T2.LESSON)
order by T.TEACHER_NAME asc, T1.DAY_NAME desc, T1.LESSON asc


-- ex 4: окна у групп
select distinct GROUPS.IDGROUP as 'Группа', T1.DAY_NAME as 'День недели', T1.LESSON as 'Занятая пара'
from GROUPS, TIMETABLE T1, TIMETABLE T2
where GROUPS.IDGROUP = T1.IDGROUP and T1.DAY_NAME = T2.DAY_NAME and T1.LESSON != T2.LESSON
order by GROUPS.IDGROUP asc, T1.DAY_NAME desc, T1.LESSON asc

select distinct GROUPS.IDGROUP as 'Группа', T1.DAY_NAME as 'День недели', T1.LESSON as '"окна"'
from GROUPS, TIMETABLE T1, TIMETABLE T2
except
	(select distinct GROUPS.IDGROUP, T1.DAY_NAME, T1.LESSON
	from GROUPS, TIMETABLE T1, TIMETABLE T2
	where GROUPS.IDGROUP = T1.IDGROUP and T1.DAY_NAME = T2.DAY_NAME and T1.LESSON != T2.LESSON)
order by GROUPS.IDGROUP asc, T1.DAY_NAME desc, T1.LESSON asc