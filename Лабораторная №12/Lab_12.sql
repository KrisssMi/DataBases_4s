use UNIVER;
go

--1:
-- �������� ��������� ��� ����������, ��������� �������������� ����� �� ������ ������� SUBJECT
create procedure PSUBJECT
as
begin 
declare @k int=(select COUNT(*) from SUBJECT);
select SUBJECT [���], SUBJECT_NAME [����������], PULPIT [�������] from SUBJECT;
return @k;
end;
--DROP procedure PSUBJECT;

declare @i int=0;
exec @i=PSUBJECT;
print '���������� ���������: '+cast(@i as varchar(3));


--2:
-- �������� + ���������
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[PSUBJECT] @p varchar(20), @c int output
as
begin 
declare @k int=(select COUNT(*) from SUBJECT);
print '���������: @p='+@p+', @c='+cast(@c as varchar(3));
select SUBJECT [���], SUBJECT_NAME [����������], PULPIT [�������] from SUBJECT where PULPIT = @p;
set @c=@@ROWCOUNT;
return @k;
end;

declare @temp_2 int = 0, @out_2 int = 0;
exec @temp_2 = PSUBJECT '����', @out_2 output;
print '��������� �����: ' + convert(varchar, @temp_2);
print '��������� �� ������� ����: ' + convert(varchar, @out_2);
go


--3:
-- ��������� ��������� �������, �������� ���������, insert

-- ��������� � ��������� � ������� ALTER:
ALTER procedure PSUBJECT @p varchar(20)
as begin
	SELECT * from SUBJECT where SUBJECT = @p;
end;
--drop procedure PSUBJECT;

-- �������� ��������� �������:
CREATE table #SUBJECTs
(
	���_�������� varchar(20),
	��������_�������� varchar(100),
	������� varchar(20)
);
--drop table #SUBJECTs;

-- INSERT ��������� ������ �� ��������� �������:
INSERT #SUBJECTs EXEC PSUBJECT @p = '����';
INSERT #SUBJECTs EXEC PSUBJECT @p = '������';

-- ����������� ���������� ��������� �������:  
SELECT * from #SUBJECTs;
go


--4:
-- ��������� 4 ��.����� (�������� ��������), ���. ������ � ����.AUDITORIUM
create procedure PAUDITORIUM_INSERT
	@a char(20), 
	@n varchar(50), 
	@c int=0, 
	@t char(10)
as 
begin try
insert into AUDITORIUM(AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY, AUDITORIUM_NAME)
values (@a, @n, @c, @t)
return 1;
end try
begin catch
	print '����� ������: ' + cast(error_number() as varchar(6));
	print '���������: ' + error_message();
	print '�������: ' + cast(error_severity() as varchar(6));
	print '�����: ' + cast(error_state() as varchar(8));
	print '����� ������: ' + cast(error_line() as varchar(8));
	if error_procedure() is not null   
	print '��� ���������: ' + error_procedure();
	return -1;
end catch;

-- ������� ���������:
drop procedure PAUDITORIUM_INSERT;

DECLARE @rc int; 
exec @rc=PAUDITORIUM_INSERT @a='500-1', @n='��', @c=60, @t='500-1';
print '��� ������: '+cast(@rc as varchar(3));

-- ������� ����������� ������:
delete AUDITORIUM where AUDITORIUM='500-1';

-- ����������� ��� ���������:
select * from AUDITORIUM;


--5:
-- ������� ���������� �� ������� ����� �������:
create procedure SUBJECT_REPORT
	@p char(10)
	as declare @rc int = 0;
	begin try
		if not exists (select SUBJECT from SUBJECT where PULPIT = @p)
			raiserror('������ � ����������', 11, 1);
		declare @subs_list char(300) = '', @sub char(10);
		declare SUBJECTS_LAB12 cursor for
			select SUBJECT from SUBJECT where PULPIT = @p;
		open SUBJECTS_LAB12;
			fetch SUBJECTS_LAB12 into @sub;
			while (@@FETCH_STATUS = 0)
				begin
					set @subs_list = rtrim(@sub) + ', ' + @subs_list;
					set @rc += 1;
					fetch SUBJECTS_LAB12 into @sub;
				end;
			print '���������� �� ������� ' + rtrim(@p) + ':';
			print rtrim(@subs_list);
		close SUBJECTS_LAB12;
		deallocate SUBJECTS_LAB12;
		return @rc;
	end try
	begin catch
		print '����� ������: ' + convert(varchar, error_number());
		print '���������: ' + error_message();
		print '�������: ' + convert(varchar, error_severity());
		print '�����: ' + convert(varchar, error_state());
		print '����� ������: ' + convert(varchar, error_line());
		if error_procedure() is not null
			print '��� ���������: ' + error_procedure();
		return @rc;
	end catch;
go
--drop procedure SUBJECT_REPORT

declare @temp_5 int;
exec @temp_5 = SUBJECT_REPORT '����';
print '���������� ���������: ' + convert(varchar, @temp_5);
go


--6:
-- ���������� serializable; @tn ��� AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
drop procedure PAUDITORIUM_INSERTX;
delete AUDITORIUM where AUDITORIUM_TYPE = '��-�';
delete AUDITORIUM_TYPE where AUDITORIUM_TYPE = '��-�';
go
create procedure PAUDITORIUM_INSERTX
	@a char(20), @n varchar(20), @c int = 0, @t char(10), @tn varchar(50)
	as declare @rc int = 1;
	begin try
		set transaction isolation level SERIALIZABLE
		begin tran
			insert into AUDITORIUM_TYPE values (@t, @tn);
			exec @rc = PAUDITORIUM_INSERT @a, @n, @c, @t;
		commit tran
		return @rc
	end try
	begin catch
		print '����� ������: ' + convert(varchar, error_number());
		print '���������: ' + error_message();
		print '�������: ' + convert(varchar, error_severity());
		print '�����: ' + convert(varchar, error_state());
		print '����� ������: ' + convert(varchar, error_line());
		if error_procedure() is not null
			print '��� ���������: ' + error_procedure();
		if @@TRANCOUNT > 0
			rollback tran;
		return -1;
	end catch;
go

declare @temp_6 int;
exec @temp_6 = PAUDITORIUM_INSERTX '136-1', '136-1', 36, '��-K', '�������� ��������� ��� ������';
print '���� ���������� ���������: ' + convert(varchar, @temp_6);
go