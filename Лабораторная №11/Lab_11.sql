--1:
-- Режим неявной транзакции
-- транзакция начинается, если выполняется один из следующих операторов: 
-- CREATE, DROP; ALTER TABLE; INSERT, DELETE, UPDATE, SELECT, TRUNCATE TABLE; OPEN, FETCH; GRANT; REVOKE 

set nocount on;
if exists (select * from sys.objects where OBJECT_ID = object_id(N'dbo.EX1_T')) -- таблица есть?
	drop table EX1_T;

declare @c int, @flag char = 'r';		-- если с->r, таблица не сохр
set implicit_transactions on;			-- включ. режим неявной транзакции
create table EX1_T (val int);			-- начало транзакции 
insert EX1_T values (1), (2), (3);
set @c = (select count(*) from EX1_T);
print 'Кол-во строк в таблице EX1_T: ' + convert(varchar, @c);
if @flag = 'c'							-- завершение транзакции: фиксация 
	commit;				
else 
	rollback;							-- завершение транзакции: откат  
set implicit_transactions off;			-- выключ. режим неявной транзакции

if exists (select * from sys.objects where OBJECT_ID = object_id(N'dbo.EX1_T'))
	print 'Таблица EX1_T есть';
else
	print 'Таблицы EX1_T нет';


--2:
-- Атомарность явной транзакции
delete AUDITORIUM where AUDITORIUM_NAME = '222-1';
insert into AUDITORIUM values('222-1','ЛБ-К','15','222-1');

begin try
	begin tran									-- начало явной транзакции
		delete AUDITORIUM where AUDITORIUM_NAME = '222-1';
		print '* Аудитория удалена';
		insert into AUDITORIUM values('222-1','ЛБ-К','15','222-1');
		print '* Аудитория добавлена';
		update AUDITORIUM set AUDITORIUM_CAPACITY = '30' where AUDITORIUM_NAME='222-1';
		print '* Аудитория изменена';
	commit tran;								-- фиксация транзакции
end try
begin catch
	print 'ОШИБКА: ' + case
		when ERROR_NUMBER() = 2627 and PATINDEX('%AUDITORIUM_PK%', ERROR_MESSAGE()) > 0		-- определяет в строке позицию первого символа подстроки, заданную шаблоном
			then 'Дубликат'
			else 'НЕИЗВЕСТНАЯ ОШИБКА: ' + CAST(ERROR_NUMBER() as varchar(5)) + ERROR_MESSAGE()
		end;
	if @@TRANCOUNT > 0 rollback tran;
end catch;


--3:
-- Сценарий, демонстрирующий применение оператора SAVE TRAN (транзакция состоит из нескольких независимых блоков операторов T-SQL)
delete AUDITORIUM where AUDITORIUM_NAME = '333-1'
insert into AUDITORIUM values ('333-1', N'ЛБ-К', 15, '333-1')

declare @point varchar(32)
begin try
    begin tran
        delete AUDITORIUM where AUDITORIUM_NAME = '333-1'
        print 'Auditorium 333-1 deleted'
        set @point = 'p1'		
        save tran @point		-- контрольная точка

        insert into AUDITORIUM values ('333-1', N'ЛБ-К', 15, '333-1')
        print 'Auditorium 333-1 inserted'
        set @point = 'p2'
        save tran @point		-- контрольная точка

        update AUDITORIUM set AUDITORIUM_CAPACITY = 30 where AUDITORIUM_NAME = '333-1'
        print 'Auditorium 333-1 capacity updated'
        insert into AUDITORIUM values ('333-1', N'ЛБ-К', 15, '333-1')
    commit tran
end try

begin catch
    print 'Error: ' + case
        when error_number() = 547 then 'Auditorium 333-1 does not exist'
        when error_number() = 2627 then 'Auditorium 333-1 already exists'
        else 'Unknown error ' + convert(varchar, error_number()) + ': ' + error_message()
    end
    if @@trancount > 0			-- ур.вложенности транзакции>0 =>  транз не завершена 
    begin
        rollback tran @point
        commit tran
    end
end catch


--4:
------A------
--явную транзакцию с уровнем изолированности READ UNCOMMITED,
--кот. допуск неподтвержд, неповтор. и фантомное чтение
set transaction isolation level READ UNCOMMITTED
begin transaction
-----t1---------
select @@SPID, 'insert FACULTY' 'результат', *
from FACULTY;
--commit;
rollback;


--5: Неповторяющееся чтение
------A------
set transaction isolation level READ COMMITTED
begin transaction
select * from SUBJECT where SUBJECT = 'БД';
------t1----------
------t2----------
select * from SUBJECT where SUBJECT = 'БД';
commit tran;
rollback;


--6:
-- Явная транзакция с уровнем изолированности REPEATABLE READ
------A------
set transaction isolation level REPEATABLE READ
begin transaction
select * from SUBJECT where SUBJECT = 'БД';
------t1-----------
------t2-----------
select count(*) from SUBJECT where SUBJECT = 'БД';
rollback;


--7:
-- Явная транзакция с уровнем изолированности SERIALIZABLE
------A------
set transaction isolation level Serializable 
begin transaction
select * from SUBJECT;
------t1-----------
------t2-----------
rollback;


--8:
--Вложенная транзакция
drop table #table_8;

CREATE TABLE #table_8(A INT, B INT);
INSERT #table_8 VALUES(1,100);
BEGIN TRAN						-- начало внутренней транзакции
INSERT #table_8 VALUES(10,10)	-- вставка во внутреннюю транзакцию
	BEGIN TRAN
	UPDATE #table_8 SET A = 1 WHERE B = 333
	COMMIT;						-- фиксация внутренней транзакции (действует только на внутренние операции)
IF @@TRANCOUNT > 0				-- определяем уровень вложенности
ROLLBACK;						-- ROLLBACK внешней транзакции отменяет зафиксированные операции внутренней транзакции

SELECT * FROM #table_8;