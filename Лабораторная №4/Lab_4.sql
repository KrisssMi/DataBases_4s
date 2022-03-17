/*�������� ��������*/
use UNIVER;
--1
/*������������ �������� ����� ��������� � ��������������� �� ������������ ����� ��������� */
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPE
from AUDITORIUM_TYPE Inner Join AUDITORIUM
on AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE;


--2
/*������������ �������� ����� ��������� � ��������������� �� ������������ ����� ��������� */
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
from AUDITORIUM_TYPE Inner Join AUDITORIUM
on AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE And AUDITORIUM_TYPE.AUDITORIUM_TYPENAME Like '%���������%';


--3
/*��� SELECT-������� ��� ���������� INNER JOIN*/
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPE
from AUDITORIUM_TYPE, AUDITORIUM
where AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE

select T2.AUDITORIUM, T1.AUDITORIUM_TYPENAME		--����� ����������
from AUDITORIUM_TYPE As T1, AUDITORIUM As T2
where T1.AUDITORIUM_TYPE=T2.AUDITORIUM_TYPE And T1.AUDITORIUM_TYPENAME Like '%���������%';


--4
/*�������� ���������, ���������� ��������������� ������ (������� PROGRESS.NOTE) �� 6 �� 8*/
select FACULTY.FACULTY, PULPIT.PULPIT, PROFESSION.PROFESSION_NAME, SUBJECT.SUBJECT_NAME, STUDENT.NAME,
case
	when (PROGRESS.NOTE=6) then '�����'
	when (PROGRESS.NOTE=7) then '����'
	when (PROGRESS.NOTE=8) then '������'
	end [PROGRESS.NOTE] from PROGRESS
inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
inner join [SUBJECT] on [SUBJECT].[SUBJECT] = PROGRESS.[SUBJECT]
inner join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
inner join PROFESSION on PROFESSION.PROFESSION = GROUPS.PROFESSION
inner join PULPIT on PULPIT.PULPIT=[SUBJECT].PULPIT
inner join FACULTY on FACULTY.FACULTY = PULPIT.FACULTY
where PROGRESS.NOTE between 6 and 8

/*�������������� ����� ������������� � ������� ����������� �� �������� FACULTY.FACULTY, PULPIT.PULPIT, PROFESSION.PROFESSION, 
STUDENT.STUDENT_NAME � � ������� �������� �� ������� PROGRESS.NOTE.*/
--asc � ������� �����������
--desc � ������� ��������
order by PROGRESS.NOTE desc, FACULTY.FACULTY asc, PULPIT.PULPIT asc, PROFESSION.PROFESSION asc, STUDENT.NAME asc


--5
/*������� ��������� ������ � ������� 7, ����� ������ � ������� 8 � ����� ������ � ������� 6:*/
select FACULTY.FACULTY, PULPIT.PULPIT, PROFESSION.PROFESSION_NAME, SUBJECT.SUBJECT_NAME, STUDENT.NAME,
case
	when (PROGRESS.NOTE=6) then '�����'
	when (PROGRESS.NOTE=7) then '����'
	when (PROGRESS.NOTE=8) then '������'
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
/*������ �������� ������ (���� �� ������� ��� ������������� - ***) */
select PULPIT.PULPIT_NAME [�������], isnull (TEACHER.TEACHER_NAME, '***') [�������������]
from PULPIT left outer join TEACHER
on PULPIT.PULPIT=TEACHER.PULPIT;



--7(1)
/*�������� ������� ������ � ��������� LEFT OUTER JOIN */
select PULPIT.PULPIT_NAME [�������], isnull (TEACHER.TEACHER_NAME, '***') [�������������]
from TEACHER left outer join PULPIT
on PULPIT.PULPIT=TEACHER.PULPIT;
------������ ������������� �������� �� ���������� ��������, �������, ����� �������, NULL-�������� �� �����.

--7(2)
/*���������� ������ ����� �������, ����� ��������� ����������� ���������, �� ����������� ���������� ������ RIGHT OUTER JOIN */
select PULPIT.PULPIT_NAME as '�������', isnull(TEACHER.TEACHER_NAME, '***') as '�������������'
from TEACHER right outer join PULPIT
on PULPIT.PULPIT=TEACHER.PULPIT;



--8(1)
/*������, ��������� �������� �������� ������ ����� (� �������� FULL OUTER JOIN) ������� � �� �������� ������ ������; */
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
	from AUDITORIUM_TYPE full outer Join AUDITORIUM
	on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;

SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
	from AUDITORIUM full outer Join AUDITORIUM_TYPE
	on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;

--8(2)
/*������, ��������� �������� �������� ������ ������ ������� � �� ���������� ������ �����; */
SELECT * FROM AUDITORIUM left OUTER JOIN AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE

SELECT * FROM AUDITORIUM right OUTER JOIN AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE


--8(3)
/*������, ��������� �������� �������� ������ ������ ������� � ����� ������;*/
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
	from AUDITORIUM Inner Join AUDITORIUM_TYPE 
	on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;
--inner
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
	from AUDITORIUM full outer Join AUDITORIUM_TYPE 
	on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;
--full �������� inner



--9
/*����������� SELECT-������ �� ������ CROSS JOIN-���������� ������ AUDITORIUM_TYPE � AUDITORIUM, ������������ ���������, ����������� ����������, ����������� ��� ���������� ������� � ������� 1*/
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPE
from AUDITORIUM cross join AUDITORIUM_TYPE 
where AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;



--11
/*������� ������� TIMETABLE (������, ���������, �������, �������������, ���� ������, ����), ���������� ����� � ������� ���������, ��������� �������. 
�������� ������� �� ������� ��������� ��������� �� ������������ ����, �� ������������ ���� ������, ������� ����� � �������������� � � �������.*/
use UNIVER;
create table TIMETABLE (
DAY_NAME char(2) check (DAY_NAME in('��', '��', '��', '��', '��', '��')),
LESSON integer check(LESSON between 1 and 4),
TEACHER char(10)  constraint TIMETABLE_TEACHER_FK  foreign key references TEACHER(TEACHER),
AUDITORIUM char(20) constraint TIMETABLE_AUDITORIUM_FK foreign key references AUDITORIUM(AUDITORIUM),
SUBJECT char(10) constraint TIMETABLE_SUBJECT_FK  foreign key references SUBJECT(SUBJECT),
IDGROUP integer constraint TIMETABLE_GROUP_FK  foreign key references GROUPS(IDGROUP),
)

insert into TIMETABLE 
values 
('��', 1, '����', '313-1', '����', 2),
('��', 2, '����', '313-1', '����', 4),
('��', 3, '����', '313-1', '����', 11),

('��', 1, '���', '324-1', '����', 6),
('��', 3, '���', '324-1', '���', 4),

('��', 1, '���', '206-1', '���', 10),
('��', 4, '����', '206-1', '����', 3),

('��', 1, '�����', '301-1', '����', 7),
('��', 4, '�����', '301-1', '����', 7),

('��', 2, '�����', '413-1', '����', 8),

('��', 2, '���', '423-1', '����', 7),
('��', 4, '���', '423-1', '����', 2),

('��', 1, '����', '313-1', '����', 2),
('��', 2, '����', '313-1', '����', 4),

('��', 3, '���', '324-1', '���', 4),
('��', 4, '����', '206-1', '����', 3);

-- ex 1: ������� ��������� ��������� �� ������������ ����
select AUDITORIUM as '���������, ��������� �� 1 ���� � ��'
from AUDITORIUM a
except 
	(select a.AUDITORIUM
	from TIMETABLE T1, AUDITORIUM a
	where T1.DAY_NAME = '��' and T1.LESSON = 1 and a.AUDITORIUM = T1.AUDITORIUM)
order by AUDITORIUM asc

-- ex 2: �� ������������ ���� ������
select AUDITORIUM as '���������, ��������� � ��'
from AUDITORIUM a
except 
	(select a.AUDITORIUM
	from TIMETABLE T1, AUDITORIUM a
	where T1.DAY_NAME = '��' and a.AUDITORIUM = T1.AUDITORIUM)
order by AUDITORIUM asc

-- ex3: ������� ����� � ��������������
select distinct T.TEACHER_NAME as '�������������', T1.DAY_NAME as '���� ������', T1.LESSON as '������� ����'
from TEACHER T, TIMETABLE T1, TIMETABLE T2
where T.TEACHER = T1.TEACHER and T1.DAY_NAME = T2.DAY_NAME and T1.LESSON != T2.LESSON
order by T.TEACHER_NAME asc, T1.DAY_NAME desc, T1.LESSON asc

select distinct T.TEACHER_NAME as '�������������', T1.DAY_NAME as '���� ������', T1.LESSON as '"����"'
from TEACHER T, TIMETABLE T1, TIMETABLE T2
except 
	(select distinct T.TEACHER_NAME, T1.DAY_NAME, T1.LESSON
	from TEACHER T, TIMETABLE T1, TIMETABLE T2
	where T.TEACHER = T1.TEACHER and T1.DAY_NAME = T2.DAY_NAME and T1.LESSON != T2.LESSON)
order by T.TEACHER_NAME asc, T1.DAY_NAME desc, T1.LESSON asc


-- ex 4: ���� � �����
select distinct GROUPS.IDGROUP as '������', T1.DAY_NAME as '���� ������', T1.LESSON as '������� ����'
from GROUPS, TIMETABLE T1, TIMETABLE T2
where GROUPS.IDGROUP = T1.IDGROUP and T1.DAY_NAME = T2.DAY_NAME and T1.LESSON != T2.LESSON
order by GROUPS.IDGROUP asc, T1.DAY_NAME desc, T1.LESSON asc

select distinct GROUPS.IDGROUP as '������', T1.DAY_NAME as '���� ������', T1.LESSON as '"����"'
from GROUPS, TIMETABLE T1, TIMETABLE T2
except
	(select distinct GROUPS.IDGROUP, T1.DAY_NAME, T1.LESSON
	from GROUPS, TIMETABLE T1, TIMETABLE T2
	where GROUPS.IDGROUP = T1.IDGROUP and T1.DAY_NAME = T2.DAY_NAME and T1.LESSON != T2.LESSON)
order by GROUPS.IDGROUP asc, T1.DAY_NAME desc, T1.LESSON asc