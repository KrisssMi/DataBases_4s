use UNIVER;

--1:
-- SELECT-������, ����������� ������������, ����������� � ������� ����������� ���������, ��������� ����������� ���� ��������� � ����� ���������� ���������. 

select  min(AUDITORIUM_CAPACITY) [����������� �����������],
		max (AUDITORIUM_CAPACITY)[������������ �����������],
		avg(AUDITORIUM_CAPACITY) [������� �����������],
		sum(AUDITORIUM_CAPACITY) [��������� �����������],
		count(*) [����� ���������� ���������]
from AUDITORIUM;



--2:
-- �� �� ��� ������� ���� ���������


select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME,  
           max(AUDITORIUM_CAPACITY)  [������������ �����������], 
		   min(AUDITORIUM_CAPACITY)  [����������� �����������],
		   avg(AUDITORIUM_CAPACITY) [������� �����������],
		   sum(AUDITORIUM_CAPACITY) [��������� �����������],
           count(*)  [���������� ��������� ������� ����]
from  AUDITORIUM  Inner Join  AUDITORIUM_TYPE 
     on  AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE  
         group by AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 



--3:
-- ���������� ��������������� ������ � �������� ��������� (10, 8-9, 6-7, 4-5)

select *
from (select case 
			when NOTE=10 then '10'
			when NOTE between 8 and 9 then '8-9'
			when NOTE between 6 and 7 then '6-7'
			when NOTE between 4 and 5 then '4-5'
			end [������], count(*) [����������]
from PROGRESS group by case 
			when NOTE=10 then '10'
			when NOTE between 8 and 9 then '8-9'
			when NOTE between 6 and 7 then '6-7'
			when NOTE between 4 and 5 then '4-5'
			end) as T
order by case [������]
			when '10' then 0
			when '8-9' then 1
			when '6-7' then 2
			when '4-5' then 3
		end



--4:
-- ������ �� ������ ������ FACULTY, GROUPS, STUDENT � PROGRESS, ������� �������� ������� ��������������� ������ ��� ������� ����� ������ �������������. 
-- ������ ������������� � ������� �������� ������� ������.

select f.FACULTY, g.PROFESSION, YEAR(GETDATE()) - g.YEAR_FIRST [����], round(avg(cast(p.NOTE as float(4))),2) [������]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
group by f.FACULTY, g.PROFESSION, g.YEAR_FIRST
order by [������] desc

-- ������ ������ �� ���� � ����. ������������ WHERE:

select f.FACULTY, g.PROFESSION, YEAR(GETDATE()) - g.YEAR_FIRST [����], round(avg(cast(p.NOTE as float(4))),2) [������]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where p.SUBJECT='����' or p.SUBJECT='����'		-- �������� where
group by f.FACULTY, g.PROFESSION, g.YEAR_FIRST
order by [������] desc



--5:
-- �������������, ���������� � ������� ������ ��� ����� ��������� �� ���������� ���

select f.FACULTY [���������], g.PROFESSION [�������������], p.SUBJECT [�������], round(avg(cast(p.NOTE as float(4))),2) [������]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where g.FACULTY like '����'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
order by [������] desc


-- + ����������� ROLLUP: 

select f.FACULTY [���������], g.PROFESSION [�������������], p.SUBJECT [�������], round(avg(cast(p.NOTE as float(4))),2) [������]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where g.FACULTY like '����'
group by rollup (f.FACULTY, g.PROFESSION, p.SUBJECT)


--6:
-- SELECT-������ �.5 � �������������� CUBE-�����������. ���������������� ���������.

select  f.FACULTY [���������], g.PROFESSION [�������������], p.SUBJECT [�������], round(avg(cast(p.NOTE as float(4))),2) [������]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where g.FACULTY like '����'
group by cube (f.FACULTY, g.PROFESSION, p.SUBJECT)


--7:
-- � ������� ������ ���������� �������������, ����������, ������� ������ ��������� �� ���������� ���:
-- �������� ����������� ������, � ������� ������������ ���������� ����� ��������� �� ���������� ����:
-- ���������� ���������� ���� �������� � �������������� ���������� UNION � UNION ALL. ��������� ����������. 

														-- union ���������� ���, ��� ��������� ������-���������, ��� distinct.	union all - ������ ������������ �����������

select f.FACULTY [���������], g.PROFESSION [�������������], p.SUBJECT [�������], round(avg(cast(p.NOTE as float(4))),2) [������]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where g.FACULTY like '����'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
		union
		--union all
select f.FACULTY [���������], g.PROFESSION [�������������], p.SUBJECT [�������], round(avg(cast(p.NOTE as float(4))),2) [������]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where g.FACULTY like '����'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
				


--8:
-- �������� ����������� ���� �������� ����� - INTERSECT (����������� � ���� �������� ���, ������� �����)

select f.FACULTY [���������], g.PROFESSION [�������������], p.SUBJECT [�������], round(avg(cast(p.NOTE as float(4))),2) [������]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where g.FACULTY like '����'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
		intersect
select f.FACULTY [���������], g.PROFESSION [�������������], p.SUBJECT [�������], round(avg(cast(p.NOTE as float(4))),2) [������]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where g.FACULTY like '����'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
				


--9:
-- �������� ������� ����� ���������� ����� - EXCEPT (���. ����� = ������ 1-�� ������� ����� ����� 2-�� �������)

select f.FACULTY [���������], g.PROFESSION [�������������], p.SUBJECT [�������], round(avg(cast(p.NOTE as float(4))),2) [������]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where g.FACULTY like '����'
group by f.FACULTY, g.PROFESSION, p.SUBJECT
		except
select f.FACULTY [���������], g.PROFESSION [�������������], p.SUBJECT [�������], round(avg(cast(p.NOTE as float(4))),2) [������]
from FACULTY f inner join GROUPS g
	on f.FACULTY=g.FACULTY
	inner join STUDENT s
		on g.IDGROUP=s.IDGROUP
			inner join PROGRESS p
				on p.IDSTUDENT=s.IDSTUDENT
where g.FACULTY like '����'
group by f.FACULTY, g.PROFESSION, p.SUBJECT



--10:
-- ���������� ��� ������ ���������� ���-�� ���������, ���������� 8 � 9

select p1.SUBJECT [�������], p1.NOTE,
	(select count(*)  from PROGRESS p2
	where p2.SUBJECT=p1.SUBJECT and p2.NOTE=p1.NOTE) [���������� ���������]
	from PROGRESS p1
		group by p1.SUBJECT, p1.NOTE
		having NOTE in('8','9')
		order by NOTE desc



--11:
-- ���������� ���������� ��������� � ������ ������, �� ������ ���������� � ����� � ������������ ����� ��������. 

select GROUPS.FACULTY as '���������', 
	STUDENT.IDGROUP as '������',
	count(STUDENT.IDSTUDENT) as '���-�� ���������'
from STUDENT, GROUPS
where GROUPS.IDGROUP = STUDENT.IDGROUP
group by rollup (GROUPS.FACULTY, STUDENT.IDGROUP)


-- ���������� ���������� ��������� �� ����� � ��������� ����������� � �������� � ����� ����� ��������.

select AUDITORIUM_TYPE as '��� ���������', 
	AUDITORIUM_CAPACITY as '�����������',
	case 
		when AUDITORIUM.AUDITORIUM like '%-1' then '1'
		when AUDITORIUM.AUDITORIUM like '%-2' then '2'
		when AUDITORIUM.AUDITORIUM like '%-3' then '3'
		when AUDITORIUM.AUDITORIUM like '%-3a' then '3a'
		when AUDITORIUM.AUDITORIUM like '%-4' then '4'
	end '������', 
	count(*) as '����������'
from AUDITORIUM 
group by AUDITORIUM_TYPE, AUDITORIUM_CAPACITY,
	case 
		when AUDITORIUM.AUDITORIUM like '%-1' then '1'
		when AUDITORIUM.AUDITORIUM like '%-2' then '2'
		when AUDITORIUM.AUDITORIUM like '%-3' then '3'
		when AUDITORIUM.AUDITORIUM like '%-3a' then '3a'
		when AUDITORIUM.AUDITORIUM like '%-4' then '4'
	end with rollup