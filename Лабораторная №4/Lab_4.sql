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

select T1.AUDITORIUM, T2.AUDITORIUM_TYPENAME						--����� ����������
from AUDITORIUM_TYPE T2, AUDITORIUM T1
where T2.AUDITORIUM_TYPE=T1.AUDITORIUM_TYPE And T2.AUDITORIUM_TYPENAME Like '%���������%';


--4
/*�������� ���������, ���������� ��������������� ������ (������� PROGRESS.NOTE) �� 6 �� 8*/
select FACULTY.FACULTY, PULPIT.PULPIT, PROFESSION.PROFESSION_NAME, SUBJECT.SUBJECT_NAME, STUDENT.NAME,
case
	when (PROGRESS.NOTE=6) then '�����'
	when (PROGRESS.NOTE=7) then '����'
	when (PROGRESS.NOTE=8) then '������'
	end [PROGRESS.NOTE]
	from PROGRESS
inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
inner join SUBJECT on SUBJECT.SUBJECT = PROGRESS.SUBJECT
inner join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
inner join PROFESSION on PROFESSION.PROFESSION = GROUPS.PROFESSION
inner join PULPIT on PULPIT.PULPIT=SUBJECT.PULPIT
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
inner join SUBJECT on SUBJECT.SUBJECT = PROGRESS.SUBJECT
inner join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
inner join PROFESSION on PROFESSION.PROFESSION = GROUPS.PROFESSION
inner join PULPIT on PULPIT.PULPIT=SUBJECT.PULPIT
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
--������� isnull ���������� ������ ��������, �� ������ NULL.
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
select PULPIT.FACULTY, PULPIT.PULPIT, PULPIT.PULPIT_NAME
from PULPIT full outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT
where TEACHER.TEACHER is null


--8(2)
/*������, ��������� �������� �������� ������ ������ ������� � �� ���������� ������ �����; */
select TEACHER.TEACHER_NAME, TEACHER.TEACHER, TEACHER.PULPIT, TEACHER.GENDER
from PULPIT full outer join TEACHER
on PULPIT.PULPIT=TEACHER.PULPIT
where TEACHER.TEACHER is not null


--8(3)
/*������, ��������� �������� �������� ������ ������ ������� � ����� ������;*/
select * from TEACHER full outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT
--full �������� inner


--��������������:

--���������� FULL OUTER JOIN ���� ������ �������� ������������� ���������
select NAME, YEAR_FIRST from STUDENT full outer join GROUPS G on STUDENT.IDGROUP = G.IDGROUP
except
select NAME, YEAR_FIRST from GROUPS full outer join STUDENT S on GROUPS.IDGROUP = S.IDGROUP


--�������� ������������ LEFT OUTER JOIN � RIGHT OUTER JOIN ���������� ���� ������:
select NAME, STUDENT.IDGROUP from STUDENT left outer join GROUPS
on STUDENT.IDGROUP=GROUPS.IDGROUP
union							-- ��� ����������� ��������������� ������ ������ ���������� ��������, � ������ �������� ������� ������ ���������� ������ � ��������
select NAME, STUDENT.IDGROUP from STUDENT right outer join GROUPS
on STUDENT.IDGROUP=GROUPS.IDGROUP
except
(select NAME, STUDENT.IDGROUP from STUDENT full outer join GROUPS
on STUDENT.IDGROUP=GROUPS.IDGROUP);


--�������� ���������� INNER JOIN ���� ������:
select NAME, BDAY from STUDENT inner join GROUPS G on STUDENT.IDGROUP = G.IDGROUP
 except							-- ���������� ������ �� ������ �������� �������, ������� ��� � ������ ������� �������
(select NAME, BDAY from STUDENT full outer join GROUPS G  on STUDENT.IDGROUP = G.IDGROUP);


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


--1: ������� ��������� ��������� �� ������������ ����
select AUDITORIUM as '���������, ��������� �� 1 ���� � ��'
from AUDITORIUM a
except					--���������� ��� ��������� ��������, ������������ ��������, ��������� ����� �� ���������
						--��� �������� ������������, ���� ��� ����������� � ����������� ���������� ������� �������
	(select a.AUDITORIUM
	from TIMETABLE T1, AUDITORIUM a
	where T1.DAY_NAME = '��' and T1.LESSON = 1 and a.AUDITORIUM = T1.AUDITORIUM)
order by AUDITORIUM asc


--2: �� ������������ ���� ������
select AUDITORIUM as '���������, ��������� � ��'
from AUDITORIUM a
except 
	(select a.AUDITORIUM
	from TIMETABLE T1, AUDITORIUM a
	where T1.DAY_NAME = '��' and a.AUDITORIUM = T1.AUDITORIUM)
order by AUDITORIUM asc


select * from TIMETABLE;
--3: ������� ����� � ��������������
select distinct TEACHER_NAME, DAY_NAME, case
           when ( count(*)= 0) then 4
           when ( count(*)= 1) then 3
           when ( count(*)= 2) then 2
           when ( count(*)= 3) then 1
           when ( count(*)= 4) then 0
           end [���-�� ����]
from  TEACHER inner join dbo.TIMETABLE T 
on TEACHER.TEACHER = T.TEACHER
group by TEACHER_NAME, DAY_NAME				-- ���������� ���������� ���������� SELECT � ������������ �� ���������� � ������ ������ ��� ���������� ��������� ��������
order by TEACHER_NAME


--4: ���� � �����
select * from TIMETABLE;
select distinct GROUPS.IDGROUP, DAY_NAME, case
           when ( count(*)= 0) then 4		-- � ������� ������� count �������� ���������� ������� � ������
           when ( count(*)= 1) then 3
           when ( count(*)= 2) then 2
           when ( count(*)= 3) then 1
           when ( count(*)= 4) then 0
           end [���-�� ����]
from  GROUPS inner join dbo.TIMETABLE T 
on GROUPS.IDGROUP = T.IDGROUP
group by GROUPS.IDGROUP, DAY_NAME
order by GROUPS.IDGROUP asc, [���-�� ����] asc;