use UNIVER;

--1:
-- ����������� ������������� � ������ �������������

create view [�������������]
as select TEACHER.TEACHER [���],
		TEACHER.TEACHER_NAME [��� �������������],
		TEACHER.GENDER [���],
		TEACHER.PULPIT [��� �������]
from TEACHER;

-- �������� �������������:
--drop view [�������������]



--2:
-- ����������� � ������� ������������� � ������ ���������� ������

create view [���������� ������]
	as select FACULTY.FACULTY_NAME [���������],
			count(PULPIT.PULPIT)[���������� ������]
			from FACULTY inner join PULPIT
			on FACULTY.FACULTY=PULPIT.FACULTY
			group by FACULTY_NAME

select * from [���������� ������];



--3:
-- ����������� � ������� ������������� � ������ ���������.

create view [���������]
	as select AUDITORIUM.AUDITORIUM [���],
				AUDITORIUM.AUDITORIUM_NAME [������������ ���������]
			from AUDITORIUM
			where AUDITORIUM.AUDITORIUM_TYPE like '��%';

alter view [���������]
	as select AUDITORIUM.AUDITORIUM [���],
				AUDITORIUM.AUDITORIUM_NAME [������������ ���������],
				AUDITORIUM.AUDITORIUM_TYPE [��� ���������]
			from AUDITORIUM
			where AUDITORIUM.AUDITORIUM_TYPE like '��%';

--select * from [���������];



--4:
-- ����������� � ������� ������������� � ������ ����������_���������

create view [���������� ���������]
	as select AUDITORIUM.AUDITORIUM [���],
				AUDITORIUM.AUDITORIUM_NAME [������������ ���������]
			from AUDITORIUM
			where AUDITORIUM.AUDITORIUM_TYPE like '��%' WITH CHECK OPTION;
			go

--select * from [���������� ���������]
--insert [���������� ���������] values ('301-1', '301-1');



--5:
-- ����������� ������������� � ������ ����������

create view [����������] (���, ������������, �������)
	as select TOP 150 SUBJECT, SUBJECT_NAME, SUBJECT.PULPIT
			from SUBJECT
				order by SUBJECT;

--select * from ����������;



--6:
-- �������� ������������� ����������_������, ��������� � ������� 2 ���, 
-- ����� ��� ���� ��������� � ������� ��������.
-- ����� SCHEMABINDING ������������� ���������� �� �������� � ��������� � ���������������, ������� ����� �������� � ��������� ����������������� �������������)

alter view [���������� ������] with schemabinding
	as select FACULTY.FACULTY_NAME [���������],
			count(PULPIT.FACULTY) [����������]
		from dbo.FACULTY join dbo.PULPIT
			on FACULTY.FACULTY = PULPIT.FACULTY
		group by FACULTY.FACULTY_NAME
go

select * from [���������� ������]



--7:
-- ����������� ������������� ��� ������� TIMETABLE (������������ ������ 6) � ���� ����������. 
-- ������� �������� PIVOT � ������������ ���.

-- PIVOT(���������� �������
-- FOR �������, ���������� ��������, ������� ������ ������� ��������
-- IN ([�������� �� �����������],�)
-- ) AS ��������� ������� (�����������)

create view ����������
	as select top(100) [����], [����], [1 ������], [2 ������], [4 ������], [5 ������], [6 ������], [7 ������], [8 ������], [9 ������], [10 ������]
		from (select top(100) DAY_NAME [����],
				convert(varchar, LESSON) [����],
				convert(varchar, IDGROUP) + ' ������' [������],
				[SUBJECT] + ' ' + AUDITORIUM [���������� � ���������]
			from TIMETABLE) tbl
		pivot
			(max([���������� � ���������]) 
			for [������]
			in ([1 ������], [2 ������], [4 ������], [5 ������], [6 ������], [7 ������], [8 ������], [9 ������], [10 ������])
			) as pvt
			order by 
				(case
					 when [����] like '��' then 1
					 when [����] like '��' then 2
					 when [����] like '��' then 3
					 when [����] like '��' then 4
					 when [����] like '��' then 5
					 when [����] like '��' then 6
				 end), [����] asc
go
select * from ����������