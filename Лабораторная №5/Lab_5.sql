use UNIVER;
--1
/*На основе таблиц FACULTY, PULPIT и PROFESSION сформировать список наименований кафедр (столбец PULPIT_NAME), 
которые находятся на факультете (таблица FACULTY), обеспечивающем подготовку по специальности, 
в наименовании (столбец PROFESSION_NAME) которого содержится слово технология или технологии. 
Примечание: использовать в секции WHERE предикат IN c некоррелированным подзапросом к таблице PROFESSION. */

SELECT PULPIT.PULPIT_NAME, FACULTY.FACULTY_NAME
FROM PULPIT, FACULTY
WHERE PULPIT.FACULTY=FACULTY.FACULTY and PULPIT.FACULTY In (
SELECT PROFESSION.FACULTY 
FROM PROFESSION 
WHERE (PROFESSION_NAME Like '%технология%' or PROFESSION_NAME like '%технологии%'))


--2 
/*тот же подзапрос был записан в конструкции INNER JOIN секции FROM внешнего запроса. 
При этом результат выполнения запроса должен быть аналогичным результату исходного запроса*/

SELECT PULPIT.PULPIT_NAME, FACULTY.FACULTY_NAME
FROM PULPIT INNER JOIN FACULTY
ON PULPIT.FACULTY=FACULTY.FACULTY 
WHERE PULPIT.FACULTY In (
SELECT PROFESSION.FACULTY 
FROM PROFESSION 
WHERE (PROFESSION_NAME Like '%технология%' or PROFESSION_NAME like '%технологии%'))


--3
/*Переписать запрос, реализующий 1 пункт без использования подзапроса. 
Примечание: использовать соединение INNER JOIN трех таблиц.*/

SELECT distinct PULPIT.PULPIT_NAME, FACULTY.FACULTY_NAME
FROM PULPIT INNER JOIN FACULTY
ON PULPIT.FACULTY=FACULTY.FACULTY 
INNER JOIN PROFESSION
ON PROFESSION.FACULTY=PULPIT.FACULTY
WHERE (PROFESSION_NAME Like '%технология%' or PROFESSION_NAME like '%технологии%')


--4 
/*На основе таблицы AUDITORIUM сформировать список аудиторий самых больших вместимостей (столбец AUDITORI-UM_CAPACITY) 
для каждого типа аудитории (AUDITORIUM_TYPE). При этом результат следует отсортировать в порядке убывания вместимости. 
Примечание: использовать коррелируемый подзапрос c секциями TOP и ORDER BY. */

SELECT * FROM AUDITORIUM a
WHERE  AUDITORIUM_CAPACITY = (
	SELECT TOP(1) AUDITORIUM_CAPACITY FROM AUDITORIUM aa
	WHERE aa.AUDITORIUM_TYPE=a.AUDITORIUM_TYPE 
	ORDER BY AUDITORIUM_CAPACITY desc)
ORDER BY AUDITORIUM_CAPACITY desc


--5
/*На основе таблиц FACULTY и PULPIT сформировать список наименований факультетов (столбец FACULTY_NAME), на котором нет ни одной кафедры (таблица PULPIT). 
Примечание: использовать предикат EXISTS и коррелированный подза-прос. */

SELECT FACULTY.FACULTY_NAME [Факультеты без кафедр]
FROM FACULTY
WHERE not exists (SELECT * FROM PULPIT
WHERE PULPIT.FACULTY=FACULTY.FACULTY)

SELECT FACULTY.FACULTY_NAME [Факультеты с кафедрами]
FROM FACULTY
WHERE exists (SELECT * FROM PULPIT
WHERE PULPIT.FACULTY=FACULTY.FACULTY)


--6
/*На основе таблицы PROGRESS сформировать строку, содержащую средние значения оценок (столбец NOTE) по дисциплинам, 
имеющим следующие коды: ОАиП, БД и СУБД. Примечание: использовать три некоррелированных подзапроса в списке SELECT; 
в подзапросах применить агрегатные функции AVG. */

SELECT TOP 1
(SELECT avg(PROGRESS.NOTE) FROM PROGRESS
		WHERE PROGRESS.SUBJECT like 'ОАиП')[ОАиП],
(SELECT avg(PROGRESS.NOTE) FROM PROGRESS
		WHERE PROGRESS.SUBJECT like 'БД')[БД],
(SELECT avg(PROGRESS.NOTE) FROM PROGRESS
		WHERE PROGRESS.SUBJECT like 'СУБД')[СУБД]
FROM PROGRESS


--7
/*Разработать SELECT-запрос, демонстрирующий принцип применения ALL совместно с подзапросом.*/
--дисциплина: ОАиП, отметки >= макс. из  PROGRESS.NOTE<=5

SELECT NAME, SUBJECT, NOTE
FROM STUDENT, PROGRESS
WHERE  PROGRESS.SUBJECT like 'ОАиП' and NOTE>=all (SELECT PROGRESS.NOTE FROM PROGRESS
	WHERE PROGRESS.NOTE<=5)


--8
/*Разработать SELECT-запрос, демонстрирующий принцип применения ANY совместно с подзапросом.*/
--список аудиторий, где вместимость > хотя бы 1 из %ЛК%

SELECT * FROM AUDITORIUM
WHERE AUDITORIUM_CAPACITY > ANY(SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM
			WHERE AUDITORIUM_TYPE LIKE '%ЛК%')
ORDER BY AUDITORIUM_CAPACITY asc


--10
/*Найти в таблице STUDENT студентов, у которых день рождения в один день. Объяснить решение.*/

SELECT distinct s1.IDSTUDENT, s1.NAME, s1.BDAY 
FROM STUDENT s1 inner join STUDENT s2
	ON (s1.BDAY = s2.BDAY and s1.IDSTUDENT != s2.IDSTUDENT)
ORDER BY s1.BDAY desc