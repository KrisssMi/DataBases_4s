use UNIVER;
go

--1:
-- O��������� ��� �������, ������� ������� � ��:
exec SP_HELPINDEX AUDITORIUM;
exec SP_HELPINDEX AUDITORIUM_TYPE;
exec SP_HELPINDEX FACULTY;
exec SP_HELPINDEX GROUPS;
exec SP_HELPINDEX PROFESSION;
exec SP_HELPINDEX PROGRESS;
exec SP_HELPINDEX PULPIT;
exec SP_HELPINDEX STUDENT;
exec SP_HELPINDEX SUBJECT;
exec SP_HELPINDEX TEACHER;
exec SP_HELPINDEX TIMETABLE;

-- ������� ��������� ��������� �������. ��������� �� ������� (�� ����� 1000 �����).
create table #EX_1
    (
        TINT int,
        TFIELD varchar(100)
);

set nocount on; -- �� �������� ��������� � ����� �����;
declare @i int=0;
while @i<1000
begin
    insert #EX_1 (TINT, TFIELD)
    values (floor(20000*RAND()),REPLICATE('������', 10));
    if (@i%100=0) print @i; -- ������� ���������;
    set @i=@i+1;
end;

-- ����������� SELECT-������. �������� ���� ������� � ���������� ��� ���������:
SELECT * FROM #EX_1 where TINT between 1500 and 2500 order by TINT;

checkpoint;  --�������� ��
DBCC DROPCLEANBUFFERS;  --�������� �������� ���

-- C������� ����������������� �������:
CREATE clustered index #EX_1_CL on #EX_1(TINT asc)

Drop table #EX_1;
Drop index #EX_1_CL on #EX_1




--2:
-- ������� ��������� ��������� �������. ��������� �� ������� (10000 ����� ��� ������). 
create table #EX_2 
	(t_ind int,
	t_identity int identity(1,1),
	t_field varchar(100));

set nocount on;
declare @ex2_cnt int = 0;
while (@ex2_cnt < 10000)
begin
	insert into #EX_2(t_ind, t_field) values (floor(30000*rand()), replicate('string2', 10));
	if ((@ex2_cnt + 1) % 1000 = 0) 
		print '��������� �����:' + convert(varchar, @ex2_cnt + 1);
	set @ex2_cnt = @ex2_cnt + 1;
end;

-- ����������� SELECT-������. �������� ���� ������� � ���������� ��� ���������. 
select * from #EX_2;
select count(*) as '���������� �����' from #EX_2;

-- ������� ������������������ ������������ ��������� ������. 
create index #EX2_NONCLU on #EX_2(t_ind, t_identity);

-- �� ������������ ��� ���������� � ����������:
select * from #EX_2 where t_ind > 15000 and t_identity < 4500
select * from #EX_2 order by t_ind, t_identity

-- ������������ ��� ������ �� ����������� ��������:
select * from #EX_2 where t_identity = 2804

-- ������� ��������� ������ ����������.

drop index #EX2_NONCLU on #EX_2
drop table #EX_2




--3:
-- ������� ������������������ ������ ��������, ����������� ���-������ SELECT-�������
create table #EX_3
	(t_ind int,
	t_identity int identity(1,1),
	t_field varchar(100));

set nocount on;
declare @ex3_cnt int = 0;
while (@ex3_cnt < 10000)
begin
	insert into #EX_3(t_ind, t_field) values (floor(30000*rand()), replicate('string3', 10));
	if ((@ex3_cnt + 1) % 1000 = 0) 
		print '��������� �����:' + convert(varchar, @ex3_cnt + 1);
	set @ex3_cnt = @ex3_cnt + 1;
end;

select * from #EX_3;
select count(*) as '���������� �����' from #EX_3;

create index #EX3_INCL on #EX_3(t_ind) include (t_identity)
select * from #EX_3 where t_ind > 20000 and t_identity <5000;


drop index #EX3_INCL on #EX_3
drop table #EX_3



--4:
-- ������� � ��������� ��������� ��������� �������. 
create table #EX_4
	(t_rnd int,
	t_identity int identity(1,1),
	t_field varchar(100));

set nocount on;
declare @ex4_cnt int = 0;
while (@ex4_cnt < 10000)
begin
	insert into #EX_4(t_rnd, t_field) values (floor(30000*rand()), replicate('string4', 10));
	if ((@ex4_cnt + 1) % 1000 = 0) 
		print '��������� �����:' + convert(varchar, @ex4_cnt + 1);
	set @ex4_cnt = @ex4_cnt + 1;
end;

-- ����������� SELECT-������, �������� ���� ������� � ���������� ��� ���������.
select * from #EX_4 where t_rnd between 7432 and 10385;
select * from #EX_4 where t_rnd > 24862;
select count(*) as '���������� �����' from #EX_4;

-- ������� ������������������ ����������� ������, ����������� ��������� SELECT-�������.
create index #EX4_FILTER1 on #EX_4(t_rnd) where (t_rnd >= 15000 and t_rnd <= 17000)

drop index #EX4_FILTER1 on #EX_4
drop table #EX_4



--5:
-- ��������� ��������� ��������� �������. 
create table #EX_5 
	(tkey int,
	cc int identity(1,1),
	tf varchar(100));

set nocount on;
declare @ex5_cnt int = 0;
while (@ex5_cnt < 10000)
begin
	insert into #EX_5(tkey, tf) values (floor(30000*rand()), replicate('string5', 10));
	if ((@ex5_cnt + 1) % 1000 = 0) 
		print '��������� �����:' + convert(varchar, @ex5_cnt + 1);
	set @ex5_cnt = @ex5_cnt + 1;
end;

select * from #EX_5;

-- ������� ������������������ ������. ������� ������� ������������ �������. 
create index #EX5_TKEY on #EX_5(tkey);

insert top(10000) #EX_5(tkey, tf) select tkey, tf from #EX_5

-- ����������� �������� �� T-SQL, ���������� �������� �������� � ������ ������������ ������� ���� 90%. ������� ������� ������������ �������. 
select name [������],
	avg_fragmentation_in_percent [������������(%)]
	from sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),
		OBJECT_ID(N'#EX_5_TKEY'), null, null, null) ss
	join sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id
	where name is not null;

-- ��������� ��������� ������������� �������, ������� ������� ������������. 
alter index #EX5_TKEY on #EX_5 reorganize;

-- ��������� ��������� ����������� ������� � ������� ������� ������������ �������.
alter index #EX5_TKEY on #EX_5 rebuild with (online = off);




--6:
-- ����������� ������, ��������������� ���������� ��������� FILL-FACTOR ��� �������� ������������������� �������.
create index  #EX6_TKEY on #EX_5(tkey) with (fillfactor = 65);

insert top(50) percent into #EX_5(tkey,tf) select tkey, tf from #EX_5

select name [������],
	avg_fragmentation_in_percent [������������(%)]
	from sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),
		OBJECT_ID(N'#EX6_TKEY'), null, null, null) ss
	join sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id
	where name is not null;

drop index #EX5_TKEY on #EX_5
drop index #EX6_TKEY on #EX_5
drop table #EX_5