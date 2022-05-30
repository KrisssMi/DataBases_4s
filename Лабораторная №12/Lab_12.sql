use UNIVER;
go

--1:
-- хранимая процедура без параметров, формирует результирующий набор на основе таблицы SUBJECT
create procedure PSUBJECT
as
begin 
declare @k int=(select COUNT(*) from SUBJECT);
select SUBJECT [КОД], SUBJECT_NAME [ДИСЦИПЛИНА], PULPIT [КАФЕДРА] from SUBJECT;
return @k;
end;
--DROP procedure PSUBJECT;

declare @i int=0;
exec @i=PSUBJECT;
print 'Количество предметов: '+cast(@i as varchar(3));


--2:
-- изменить + параметры
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[PSUBJECT] @p varchar(20), @c int output
as
begin 
declare @k int=(select COUNT(*) from SUBJECT);
print 'Параметры: @p='+@p+', @c='+cast(@c as varchar(3));
select SUBJECT [КОД], SUBJECT_NAME [ДИСЦИПЛИНА], PULPIT [КАФЕДРА] from SUBJECT where PULPIT = @p;
set @c=@@ROWCOUNT;
return @k;
end;

declare @temp_2 int = 0, @out_2 int = 0;
exec @temp_2 = PSUBJECT 'ИСиТ', @out_2 output;
print 'Дисциплин всего: ' + convert(varchar, @temp_2);
print 'Дисциплин на кафедре ИСиТ: ' + convert(varchar, @out_2);
go


--3:
-- временная локальная таблица, изменить процедуру, insert

-- изменения в процедуру с помощью ALTER:
ALTER procedure PSUBJECT @p varchar(20)
as begin
	SELECT * from SUBJECT where SUBJECT = @p;
end;
--drop procedure PSUBJECT;

-- создание временной таблицы:
CREATE table #SUBJECTs
(
	Код_предмета varchar(20),
	Название_предмета varchar(100),
	Кафедра varchar(20)
);
--drop table #SUBJECTs;

-- INSERT добавляет строки во временную таблицу:
INSERT #SUBJECTs EXEC PSUBJECT @p = 'ПОиТ';
INSERT #SUBJECTs EXEC PSUBJECT @p = 'ПОиБМС';

-- Просмотреть содержимое временной таблицы:  
SELECT * from #SUBJECTs;
go


--4:
-- Процедура 4 вх.парам (значения столбцов), доб. строку в табл.AUDITORIUM
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
	print 'Номер ошибки: ' + cast(error_number() as varchar(6));
	print 'Сообщение: ' + error_message();
	print 'Уровень: ' + cast(error_severity() as varchar(6));
	print 'Метка: ' + cast(error_state() as varchar(8));
	print 'Номер строки: ' + cast(error_line() as varchar(8));
	if error_procedure() is not null   
	print 'Имя процедуры: ' + error_procedure();
	return -1;
end catch;

-- удалить процедуру:
drop procedure PAUDITORIUM_INSERT;

DECLARE @rc int; 
exec @rc=PAUDITORIUM_INSERT @a='500-1', @n='ЛК', @c=60, @t='500-1';
print 'Код ошибки: '+cast(@rc as varchar(3));

-- удалить добавленную строку:
delete AUDITORIUM where AUDITORIUM='500-1';

-- просмотреть все аудитории:
select * from AUDITORIUM;


--5:
-- вывести дисциплины на кафедре через запятую:
create procedure SUBJECT_REPORT
	@p char(10)
	as declare @rc int = 0;
	begin try
		if not exists (select SUBJECT from SUBJECT where PULPIT = @p)
			raiserror('Ошибка в параметрах', 11, 1);
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
			print 'Дисциплины на кафедре ' + rtrim(@p) + ':';
			print rtrim(@subs_list);
		close SUBJECTS_LAB12;
		deallocate SUBJECTS_LAB12;
		return @rc;
	end try
	begin catch
		print 'Номер ошибки: ' + convert(varchar, error_number());
		print 'Сообщение: ' + error_message();
		print 'Уровень: ' + convert(varchar, error_severity());
		print 'Метка: ' + convert(varchar, error_state());
		print 'Номер строки: ' + convert(varchar, error_line());
		if error_procedure() is not null
			print 'Имя процедуры: ' + error_procedure();
		return @rc;
	end catch;
go
--drop procedure SUBJECT_REPORT

declare @temp_5 int;
exec @temp_5 = SUBJECT_REPORT 'ИСиТ';
print 'Количество дисциплин: ' + convert(varchar, @temp_5);
go


--6:
-- транзакция serializable; @tn для AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
drop procedure PAUDITORIUM_INSERTX;
delete AUDITORIUM where AUDITORIUM_TYPE = 'ЛК-П';
delete AUDITORIUM_TYPE where AUDITORIUM_TYPE = 'ЛК-П';
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
		print 'Номер ошибки: ' + convert(varchar, error_number());
		print 'Сообщение: ' + error_message();
		print 'Уровень: ' + convert(varchar, error_severity());
		print 'Метка: ' + convert(varchar, error_state());
		print 'Номер строки: ' + convert(varchar, error_line());
		if error_procedure() is not null
			print 'Имя процедуры: ' + error_procedure();
		if @@TRANCOUNT > 0
			rollback tran;
		return -1;
	end catch;
go

declare @temp_6 int;
exec @temp_6 = PAUDITORIUM_INSERTX '136-1', '136-1', 36, 'ЛК-K', 'Поточная аудитория для лекций';
print 'Итог выполнения процедуры: ' + convert(varchar, @temp_6);
go