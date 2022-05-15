use UNIVER;
go

-- #1:
-- ��������, ����������� ������ ���-������ �� ������� ����. � ����� ������ ���� �������� ������� �������� (���� SUBJECT) �� ������� SUBJECT � ���� ������ ����� �������:

declare @subj_list char(50), @subj_name char(100)='';
declare discipline cursor for select SUBJECT from SUBJECT where SUBJECT.PULPIT='����';

open discipline;
fetch discipline into @subj_list;       -- ��������� ������ �� ���. ������ � ���������� ��������� �� ����. ������.
print '���������� �� ������� ����: ';
while @@fetch_status=0                  ---- ���������� ���. ������� (1 ���� ����� ������, 2 ���� ������ �� ����������)
begin
   set @subj_name=rtrim(@subj_list)+', '+@subj_name;    -- ��������� � ���������� �������� �� ������ �� ���. ������
   fetch discipline into @subj_list;
end;
    print @subj_name;
close discipline;


-- #2:
-- ������� ����������� ������� �� ����������:

-- ��������� ������:
declare Puls cursor LOCAL for select PULPIT, FACULTY from PULPIT;

declare @pul nvarchar(10), @fac nvarchar(4);
open Puls;
	fetch Puls into @pul, @fac;
    print rtrim(@pul)+' �� ���������� >  '+ @fac;

-- ������ ������������� ����������� �������:
declare Puls cursor GLOBAL for select PULPIT, FACULTY from PULPIT;
declare @pul1 nvarchar(10), @fac1 nvarchar(4);
open Puls;
    fetch Puls into @pul1, @fac1;
    print rtrim(@pul1)+' �� ���������� > '+ @fac1;

	declare @pul2 nvarchar(10), @fac2 nvarchar(4);
	fetch  Puls into @pul2, @fac2;
    print rtrim(@pul2)+' �� ���������� > '+ @fac2;

    declare @pul3 nvarchar(10), @fac3 nvarchar(4);
    fetch  Puls into @pul3, @fac3;
    print rtrim(@pul3)+' �� ���������� > '+ @fac3;

    declare @pul4 nvarchar(10), @fac4 nvarchar(4);
    fetch  Puls into @pul4, @fac4;
    print rtrim(@pul4)+' �� ���������� > '+ @fac4;
close Puls;
deallocate Puls;        -- ����������� ������ �� �������


-- #3:
-- ������� ����������� �������� �� ������������:

declare @pul char(10), @gen char(2), @name char(30);
declare Teachers cursor LOCAL dynamic for select PULPIT, GENDER, TEACHER_NAME from TEACHER where PULPIT='����';
open Teachers;
print '���������� �����: '+cast(@@CURSOR_ROWS as varchar(5));
insert into TEACHER values ('���', '���������', '�', '����');
		update TEACHER set TEACHER_NAME = '��������� ��������� ����������' where TEACHER = '���';
fetch Teachers into @pul, @gen, @name;
print '�������������: '+rtrim(@pul)+' '+rtrim(@gen)+' '+rtrim(@name);
while @@FETCH_STATUS=0
begin
    fetch Teachers into @pul, @gen, @name;
    print '�������������: '+rtrim(@pul)+' '+rtrim(@gen)+' '+rtrim(@name);
end;
    close Teachers;
    delete TEACHER where TEACHER = '���';


-- #4:
-- ��������, ��������������� �������� ��������� � �������������� ������ ������� � ��������� SCROLL:

declare @num int, @rn char(50);
declare Primer4 cursor local dynamic SCROLL for select row_number() over (order by NAME) N, NAME from STUDENT where NAME like '�%'
open Primer4;
fetch FIRST from Primer4 into @num, @rn;
print '������ ������: '+cast(@num as varchar(3))+') '+rtrim(@rn);
fetch NEXT from Primer4 into @num, @rn;
print '��������� ������ �� �������: '+cast(@num as varchar(3))+') '+rtrim(@rn);
fetch PRIOR from Primer4 into @num, @rn;
print '���������� ������ �� �������: '+cast(@num as varchar(3))+') '+rtrim(@rn);
fetch ABSOLUTE 3 from Primer4 into @num, @rn;
print '������ ������ �� ������: '+cast(@num as varchar(3))+') '+rtrim(@rn);
fetch ABSOLUTE -3 from Primer4 into @num, @rn;
print '������ ������ �� �����: '+cast(@num as varchar(3))+') '+rtrim(@rn);
fetch RELATIVE 2 from Primer4 into @num, @rn;
print '������ ������ ������ �� �������: '+cast(@num as varchar(3))+') '+rtrim(@rn);
fetch RELATIVE -2 from Primer4 into @num, @rn;
print '������ ������ ����� �� �������: '+cast(@num as varchar(3))+') '+rtrim(@rn);
fetch LAST from Primer4 into @num, @rn;
print '��������� ������: '+cast(@num as varchar(3))+') '+rtrim(@rn);
close Primer4;



-- #5:
-- ������� ������, ��������������� ���������� ����������� CURRENT OF � ������ WHERE � �������������� ���������� UPDATE � DELETE:

insert into FACULTY (FACULTY, FACULTY_NAME)
values ('Test', 'testing current of');

declare EX_5_CURRENT cursor local scroll dynamic for select FACULTY, FACULTY_NAME from FACULTY for update;
declare @fac varchar(5), @full varchar(50);
open EX_5_CURRENT
fetch first from EX_5_CURRENT into @fac, @full;
		print @fac + ' ' + @full;
		update FACULTY set FACULTY = 'NEW' where current of EX_5_CURRENT;
		fetch first from EX_5_CURRENT into @fac, @full;
		print @fac + ' ' + @full;
		--delete FACULTY where current of EX_5_CURRENT;
	close EX_5_CURRENT;
go

select * from FACULTY;



-- #6_1:
-- �� ������� PROGRESS ��������� ������ � �������� <4  (����������� PROGRESS, STUDENT, GROUPS)
insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE) values
	('��',   1026,  '06.05.2013',3),
	('��',   1027,  '06.05.2013',2),
	('��',   1028,  '06.05.2013',2),
	('��',   1029,  '06.05.2013',3),
	('��',   1030,  '06.05.2013',1),
	('��',   1031,  '06.05.2013',3)

select * from PROGRESS -- �������� ������� � ������������ �������� �����


select NAME, NOTE
from PROGRESS
	inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where NOTE < 4

declare EX6_1 cursor local
	for	select NAME, NOTE
	from PROGRESS
		inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
	where NOTE < 4
declare @student nvarchar(20), @mark int;
	open EX6_1;
		fetch  EX6_1 into @student, @mark;
		while @@FETCH_STATUS = 0
			begin
				delete PROGRESS where current of EX6_1;
				fetch  EX6_1 into @student, @mark;
			end
	close EX6_1;

insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE) values ('��',   1025,  '06.05.2013',3)
select NAME, NOTE from PROGRESS inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT where NOTE<4
go




-- #6_2:
-- SELECT-������, � ������� �������� � ������� PROGRESS ��� �������� � ���������� ������� IDSTUDENT �������������� ������ (������������� �� �������):

-- ���������� ������� �������� �� �������:
declare EX6_2 cursor local for select NAME, NOTE from PROGRESS inner join STUDENT S on PROGRESS.IDSTUDENT = S.IDSTUDENT
where PROGRESS.IDSTUDENT=1025;
declare @student nvarchar(20), @mark int;
open EX6_2;
fetch EX6_2 into @student, @mark;
update PROGRESS set NOTE = NOTE + 1 where current of EX6_2;
close EX6_2;


select * from PROGRESS;

-- ���������� ������� �������� �� ���� �������:
select NAME, NOTE
from PROGRESS inner join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where PROGRESS.IDSTUDENT = 1025

update PROGRESS set NOTE = NOTE - 1 where IDSTUDENT = 1025;
go




