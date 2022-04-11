use UNIVER;

--1:
-- SELECT-запрос, вычисляющий максимальную, минимальную и среднюю вместимость аудиторий, суммарную вместимость всех аудиторий и общее количество аудиторий. 

select  min(AUDITORIUM_CAPACITY) [Минимальная вместимость],
		max (AUDITORIUM_CAPACITY)[Максимальная вместимость],
		avg(AUDITORIUM_CAPACITY) [Средняя вместимость],
		sum(AUDITORIUM_CAPACITY) [Суммарная вместимость],
		count(*) [Общее количество аудиторий]
from AUDITORIUM;



--2:
-- То же для каждого типа аудиторий


select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME,  
           max(AUDITORIUM_CAPACITY)  [Максимальная вместимость], 
		   min(AUDITORIUM_CAPACITY)  [Минимальная вместимость],
		   avg(AUDITORIUM_CAPACITY) [Средняя вместимость],
		   sum(AUDITORIUM_CAPACITY) [Суммарная вместимость],
           count(*)  [Количество аудиторий данного типа]
from  AUDITORIUM  Inner Join  AUDITORIUM_TYPE 
     on  AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE  
         group by AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 



--3:
-- Количество экзаменационных оценок в заданном интервале (10, 8-9, 6-7, 4-5)

select *
from (select case 
			when NOTE=10 then '10'
			when NOTE between 8 and 9 then '8-9'
			when NOTE between 6 and 7 then '6-7'
			when NOTE between 4 and 5 then '4-5'
			end [Оценки], count(*) [Количество]
from PROGRESS group by case 
			when NOTE=10 then '10'
			when NOTE between 8 and 9 then '8-9'
			when NOTE between 6 and 7 then '6-7'
			when NOTE between 4 and 5 then '4-5'
			end) as T
order by case [Оценки]
			when '10' then 0
			when '8-9' then 1
			when '6-7' then 2
			when '4-5' then 3
		end



--4:
-- Запрос на основе таблиц FACULTY, GROUPS, STUDENT и PROGRESS, который содержит среднюю экзаменационную оценку для каждого курса каждой специальности. 
-- Строки отсортировать в порядке убывания средней оценки.

select f.FACULTY, g.PROFESSION, YEAR(GETDATE()) - g.YEAR_FIRST [Курс], round(avg(cast(p.NOTE as float(4))),2) [Оценка]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
group by f.FACULTY, g.PROFESSION, g.YEAR_FIRST
order by [Оценка] desc

-- Оценки только по СУБД и ОАиП. Использовать WHERE:

select f.FACULTY, g.PROFESSION, YEAR(GETDATE()) - g.YEAR_FIRST [Курс], round(avg(cast(p.NOTE as float(4))),2) [Оценка]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where p.SUBJECT='СУБД' or p.SUBJECT='ОАиП'		-- добавила where
group by f.FACULTY, g.PROFESSION, g.YEAR_FIRST
order by [Оценка] desc



--5:
-- Специальность, дисциплины и средние оценки при сдаче экзаменов на факультете ТОВ

select f.FACULTY [Факультет], g.PROFESSION [Специальность], p.SUBJECT [Предмет], round(avg(cast(p.NOTE as float(4))),2) [Оценки]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where g.FACULTY like 'ИДиП'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
order by [Оценки] desc


-- + конструкцию ROLLUP: 

select f.FACULTY [Факультет], g.PROFESSION [Специальность], p.SUBJECT [Предмет], round(avg(cast(p.NOTE as float(4))),2) [Оценки]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where g.FACULTY like 'ИДиП'
group by rollup (f.FACULTY, g.PROFESSION, p.SUBJECT)


--6:
-- SELECT-запрос п.5 с использованием CUBE-группировки. Проанализировать результат.

select  f.FACULTY [Факультет], g.PROFESSION [Специальность], p.SUBJECT [Предмет], round(avg(cast(p.NOTE as float(4))),2) [Оценки]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where g.FACULTY like 'ИДиП'
group by cube (f.FACULTY, g.PROFESSION, p.SUBJECT)


--7:
-- В запросе должны отражаться специальности, дисциплины, средние оценки студентов на факультете ТОВ:
-- Отдельно разработать запрос, в котором определяются результаты сдачи экзаменов на факультете ХТиТ:
-- Объединить результаты двух запросов с использованием операторов UNION и UNION ALL. Объяснить результаты. 

														-- union отличается тем, что исключает строки-дупликаты, как distinct.	union all - просто механическое объединение

select f.FACULTY [Факультет], g.PROFESSION [Специальность], p.SUBJECT [Предмет], round(avg(cast(p.NOTE as float(4))),2) [Оценки]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where g.FACULTY like 'ИДиП'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
		union
		--union all
select f.FACULTY [Факультет], g.PROFESSION [Специальность], p.SUBJECT [Предмет], round(avg(cast(p.NOTE as float(4))),2) [Оценки]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where g.FACULTY like 'ХТиТ'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
				


--8:
-- Получить пересечение двух множеств строк - INTERSECT (пересечений в этих таблицах нет, поэтому пусто)

select f.FACULTY [Факультет], g.PROFESSION [Специальность], p.SUBJECT [Предмет], round(avg(cast(p.NOTE as float(4))),2) [Оценки]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where g.FACULTY like 'ИДиП'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
		intersect
select f.FACULTY [Факультет], g.PROFESSION [Специальность], p.SUBJECT [Предмет], round(avg(cast(p.NOTE as float(4))),2) [Оценки]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where g.FACULTY like 'ХТиТ'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
				


--9:
-- Получить разницу между множеством строк - EXCEPT (рез. набор = строки 1-ой таблицы кроме строк 2-ой таблицы)

select f.FACULTY [Факультет], g.PROFESSION [Специальность], p.SUBJECT [Предмет], round(avg(cast(p.NOTE as float(4))),2) [Оценки]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where g.FACULTY like 'ИДиП'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
		except
select f.FACULTY [Факультет], g.PROFESSION [Специальность], p.SUBJECT [Предмет], round(avg(cast(p.NOTE as float(4))),2) [Оценки]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where g.FACULTY like 'ХТиТ'
group by f.FACULTY, g.PROFESSION, p.SUBJECT



--10:
-- Определить для каждой дисциплины кол-во студентов, получивших 8 и 9

select p1.SUBJECT [Предмет], p1.NOTE,
	(select count(*)  from PROGRESS p2
	where p2.SUBJECT=p1.SUBJECT and p2.NOTE=p1.NOTE) [Количество студентов]
	from PROGRESS p1
		group by p1.SUBJECT, p1.NOTE
		having NOTE in('8','9')
		order by NOTE desc



--11:
-- Подсчитать количество студентов в каждой группе, на каждом факультете и всего в университете одним запросом. 

select GROUPS.FACULTY as 'Факультет', 
	STUDENT.IDGROUP as 'Группа',
	count(STUDENT.IDSTUDENT) as 'Кол-во студентов'
from STUDENT, GROUPS
where GROUPS.IDGROUP = STUDENT.IDGROUP
group by rollup (GROUPS.FACULTY, STUDENT.IDGROUP)


-- Подсчитать количество аудиторий по типам и суммарной вместимости в корпусах и всего одним запросом.

select AUDITORIUM_TYPE as 'Тип аудитории', 
	AUDITORIUM_CAPACITY as 'Вместимость',
	case 
		when AUDITORIUM.AUDITORIUM like '%-1' then '1'
		when AUDITORIUM.AUDITORIUM like '%-2' then '2'
		when AUDITORIUM.AUDITORIUM like '%-3' then '3'
		when AUDITORIUM.AUDITORIUM like '%-3a' then '3a'
		when AUDITORIUM.AUDITORIUM like '%-4' then '4'
	end 'Корпус', 
	count(*) as 'Количество'
from AUDITORIUM 
group by AUDITORIUM_TYPE, AUDITORIUM_CAPACITY,
	case 
		when AUDITORIUM.AUDITORIUM like '%-1' then '1'
		when AUDITORIUM.AUDITORIUM like '%-2' then '2'
		when AUDITORIUM.AUDITORIUM like '%-3' then '3'
		when AUDITORIUM.AUDITORIUM like '%-3a' then '3a'
		when AUDITORIUM.AUDITORIUM like '%-4' then '4'
	end with rollup