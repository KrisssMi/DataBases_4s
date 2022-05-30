use UNIVER;
go

--1
-- ����������� ��������� ������� � ������ COUNT_STUDENTS, ������� ��������� ���������� ��������� �� ����������:
create function COUNT_STUDENTS (@faculty nvarchar(20)) returns int as
begin
    declare @count int=0;
    set @count=(select count(STUDENT.IDSTUDENT)
    from FACULTY
	inner join GROUPS on GROUPS.FACULTY = FACULTY.FACULTY
	inner join STUDENT on STUDENT.IDGROUP = GROUPS.IDGROUP
	where FACULTY.FACULTY = @faculty)
    return @count;
end;
go
--drop function COUNT_STUDENTS;

declare @temp_1 int = dbo.COUNT_STUDENTS('����');
print '���������� ��������� �� ���������� ' +cast(@temp_1 as nvarchar(20))+ ' �������.';

select FACULTY '���������',
	dbo.COUNT_STUDENTS(FACULTY) '���-�� ���������'
from FACULTY
go

-- ������ ��������� � ����� ������� � ������� ��������� ALTER � ���, ����� ������� ��������� ������ �������� @prof:
alter function COUNT_STUDENTS (@faculty nvarchar(20), @prof nvarchar(20)) returns int as
begin
    declare @count int=0;
    set @count=(select count(STUDENT.IDSTUDENT)
    from FACULTY
    inner join GROUPS on GROUPS.FACULTY = FACULTY.FACULTY
    inner join STUDENT on STUDENT.IDGROUP = GROUPS.IDGROUP
    where FACULTY.FACULTY = @faculty and GROUPS.PROFESSION = @prof)
    return @count;
end;
go

declare @temp_1 int = dbo.COUNT_STUDENTS('����', '1-40 01 02');
print '���������� ���������: ' + convert(varchar, @temp_1);

select FACULTY.FACULTY '���������',
	GROUPS.PROFESSION '�������������',
	dbo.COUNT_STUDENTS(FACULTY.FACULTY, GROUPS.PROFESSION) '���-�� ���������'
from FACULTY
	inner join GROUPS on GROUPS.FACULTY = FACULTY.FACULTY
group by FACULTY.FACULTY, GROUPS.PROFESSION
go


--2
-- ����������� ��������� ������� � ������ FSUBJECTS, ����������� �������� @p ���� VARCHAR(20), �������� �������� ������ ��� ������� (������� SUBJECT.PULPIT).
-- ������� ������ ���������� ������ ���� VARCHAR(300) � �������� ��������� � ������:
create function FSUBJECTS (@p nvarchar(20)) returns nvarchar(300) as
begin
    declare @list varchar(300) = '����������: ', @sub varchar(20);
    declare SUBJECT_CURSOR cursor local for
    select SUBJECT.SUBJECT '����������'
    from SUBJECT
    where SUBJECT.PULPIT = @p
    open SUBJECT_CURSOR
    fetch next from SUBJECT_CURSOR into @sub
    while @@FETCH_STATUS = 0
        begin
            set @list=@list+rtrim(@sub)+', ';
            fetch SUBJECT_CURSOR into @sub
        end;
    return @list;
end;
-- drop function FSUBJECTS;

print dbo.FSUBJECTS('����');
-- ��������� � �������:
select PULPIT '�������', dbo.FSUBJECTS(PULPIT) '����������' from PULPIT;
go


--3
-- ����������� ��������� ������� FFACPUL, ���������� ������ ������� ������������������ �� ������� ����.
-- ������� ��������� ��� ���������, �������� ��� ���������� (������� FACULTY.FACULTY) � ��� ������� (������� PULPIT.PULPIT). ���������� SELECT-������ c ����� ������� ����������� ����� ��������� FACULTY � PULPIT:
create function FFACPUL(@fac varchar(10), @pul varchar(10)) returns table
    as return
    select FACULTY.FACULTY, PULPIT.PULPIT
    from FACULTY left outer join PULPIT
    on FACULTY.FACULTY = PULPIT.FACULTY
where FACULTY.FACULTY=isnull(@fac, FACULTY.FACULTY) and PULPIT.PULPIT=isnull(@pul, PULPIT.PULPIT);
go
--drop function dbo.FFACPUL;

select * from dbo.FFACPUL(null,null);
select * from dbo.FFACPUL('����',null);
select * from dbo.FFACPUL(null,'����');
select * from dbo.FFACPUL('����','�����');
select * from dbo.FFACPUL('no','no');
go


--4
-- ������� ��������� ���� ��������, �������� ��� �������. ������� ���������� ���������� �������������� �� �������� ���������� �������. ���� �������� ����� NULL, �� ������������ ����� ���������� ��������������.

create function FCTEACHER(@pul nvarchar(10)) returns int as
    begin
        declare @count int=(select count(*) from TEACHER
        where PULPIT=isnull(@pul, PULPIT));
        return @count;
    end;
go
-- drop function FCTEACHER;

-- ��������� � �������:
select PULPIT, dbo.FCTEACHER(PULPIT) [���������� ��������������] from PULPIT;

select dbo.FCTEACHER(null) [����� ��������������];


--6
-- ���������� ������, ���������� �����, ���������� ��������� � ���������� �������������� ����������� ���������� ���������� ���������:

--drop function dbo.FACULTY_REPORT;
--drop function dbo.COUNT_PULPIT;
--drop function dbo.COUNT_GROUPS;
--drop function dbo.COUNT_PROFESSIONS;
create function COUNT_PULPIT(@faculty nvarchar(10)) returns int
as begin
    declare @rc int=0;
    set @rc=(select count(*) from PULPIT
        where PULPIT.FACULTY=@faculty)
    return @rc;
end;
----drop function COUNT_PULPIT;
go

create function COUNT_GROUPS(@faculty nvarchar(10)) returns int
as begin
    declare @rc int=0;
    set @rc=(select count(*) from GROUPS
        where GROUPS.FACULTY=@faculty)
    return @rc;
end;
--drop function COUNT_GROUPS;
go

create function COUNT_PROFESSION(@faculty varchar(20)) returns int
	as begin
		declare @rc int = 0;
		set @rc = (select count(*) from PROFESSION
			where PROFESSION.FACULTY = @faculty)
		return @rc;
	end;
--drop function COUNT_PROFESSION;
go

create function FACULTY_REPORT(@c int) returns @fr table
	([���������] varchar(50),
	[���������� ������] int,
	[���������� �����] int,
	[���������� ���������] int,
	[���������� ��������������] int)
	as begin
		declare cc cursor local static for
			select FACULTY from FACULTY where dbo.COUNT_STUDENTS(FACULTY.FACULTY) > @c;
		declare @f varchar(30);
		open cc;
			fetch cc into @f;
		while @@fetch_status = 0
			begin
				insert @fr values(
				@f,
				dbo.COUNT_PULPIT(@f),
	            dbo.COUNT_GROUPS(@f),
				dbo.COUNT_STUDENTS(@f),
				dbo.COUNT_PROFESSION(@f));
	            fetch cc into @f;
			end;
		close cc;
		deallocate cc;
		return;
	end;
go

select * from dbo.FACULTY_REPORT(0);
go


