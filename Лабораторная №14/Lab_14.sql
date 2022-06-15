use UNIVER;
go

--1:
-- создать таблицу TR_AUDIT
create table TR_AUDIT       -- вспомагательная таблица для отражения информации об операциях
(
    ID     int identity,    --номер
    STMT   varchar(20) check (STMT in ('INS', 'UPD', 'DEL')), --DML-оператор
    TRNAME varchar(50),     -- имя триггера
    CC     varchar(300)     -- комментарий
);

drop table TR_AUDIT;
-- Разработать AFTER-триггер с именем TR_TEACHER_INS для таблицы TEACHER, реагирующий на событие INSERT
create trigger TR_TEACHER_INS on TEACHER after INSERT as declare @a1 varchar(20), @a2 varchar(100), @a3 char(20), @a4 varchar(30), @in varchar(200);
    print 'Выполняется операция INSERT в таблице TEACHER';
    set @a1 = (select [TEACHER] from inserted);
    set @a2 = (select [TEACHER_NAME] from inserted);
    set @a3 = (select [GENDER] from inserted);
    set @a4 = (select [PULPIT] from inserted);
    set @in = @a1+''+cast(@a2 as varchar(20)) + '' +cast(@a3 as nvarchar(20))+''+cast(@a4 as nvarchar(30));
    insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS', 'TR_TEACHER_INS', @in);
    return;
--drop trigger TR_TEACHER_INS;

insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('РГЭ','Рогова Галина Эдуардовна', 'ж','ИСиТ');
select * from TR_AUDIT;

select * from TEACHER;


--2:
--Создать AFTER-триггер с именем TR_TEACHER_DEL для таблицы TEACHER, реагирующий на событие DELETE
create trigger TR_TEACHER_DEL on TEACHER after DELETE as declare @a1 varchar(20), @a2 varchar(100), @a3 char(20), @a4 varchar(30), @in varchar(200);
    print 'Выполняется операция DELETE из таблицы TEACHER';
    set @a1 = (select [TEACHER] from deleted);
    set @a2 = (select [TEACHER_NAME] from deleted);
    set @a3 = (select [GENDER] from deleted);
    set @a4 = (select [PULPIT] from deleted);
    set @in = @a1+''+cast(@a2 as varchar(20)) + '' +cast(@a3 as nvarchar(20))+''+cast(@a4 as nvarchar(30));
    insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL', @in);
    return;
--drop trigger TR_TEACHER_DEL;

delete from TEACHER where TEACHER='РГЭ';
select * from TR_AUDIT;


--3:
-- Создать AFTER-триггер с именем TR_TEACHER_UPD для таблицы TEACHER, реагирующий на событие UPDATE
create trigger TR_TEACHER_UPD on TEACHER after UPDATE as declare @a1 varchar(20), @a2 varchar(100), @a3 char(20), @a4 varchar(30), @in varchar(200);
    print 'Выполняется операция UPDATE из таблицы TEACHER';
    set @a1 = (select [TEACHER] from inserted);
    set @a2 = (select [TEACHER_NAME] from inserted);
    set @a3 = (select [GENDER] from inserted);
    set @a4 = (select [PULPIT] from inserted);
    set @in = @a1+''+cast(@a2 as varchar(20)) + '' +cast(@a3 as nvarchar(20))+''+cast(@a4 as nvarchar(30));

    set @a1 = (select [TEACHER] from deleted);
    set @a2 = (select [TEACHER_NAME] from deleted);
    set @a3 = (select [GENDER] from deleted);
    set @a4 = (select [PULPIT] from deleted);
    set @in = @a1+''+cast(@a2 as varchar(20)) + '' +cast(@a3 as nvarchar(20))+''+cast(@a4 as nvarchar(30));
    insert into TR_AUDIT (STMT, TRNAME, CC) values ('UPD', 'TR_TEACHER_UPD', @in);
    return;
--drop trigger TR_TEACHER_UPD;

update TEACHER set TEACHER_NAME = 'Ромашкова Галина Эдуардовна' where TEACHER='РГЭ';
select * from TR_AUDIT;


--4:
-- Создать AFTER-триггер с именем TR_TEACHER для таблицы TEACHER, реагирующий на события INSERT, DELETE, UPDATE
create trigger TR_TEACHER on TEACHER after INSERT, DELETE, UPDATE as declare @a1 varchar(20), @a2 varchar(100), @a3 char(20), @a4 varchar(30), @in varchar(200);
 declare @ins int = (select count(*) from inserted),
        @del int = (select count(*) from deleted);
if  @ins > 0 and  @del = 0
begin
    print 'Событие: INSERT';
    set @a1 = (select [TEACHER] from inserted);
    set @a2 = (select [TEACHER_NAME] from inserted);
    set @a3 = (select [GENDER] from inserted);
    set @a4 = (select [PULPIT] from inserted);
    set @in = @a1+''+cast(@a2 as varchar(20)) + '' +cast(@a3 as nvarchar(20))+''+cast(@a4 as nvarchar(30));
    insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS', 'TR_TEACHER', @in);
end;
    else
    if  @ins = 0 and  @del > 0
    begin
        print 'Событие: DELETE';
        set @a1 = (select [TEACHER] from deleted);
        set @a2 = (select [TEACHER_NAME] from deleted);
        set @a3 = (select [GENDER] from deleted);
        set @a4 = (select [PULPIT] from deleted);
        set @in = @a1+''+cast(@a2 as varchar(20)) + '' +cast(@a3 as nvarchar(20))+''+cast(@a4 as nvarchar(30));
    insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER', @in);
    end;
    else
    if  @ins > 0 and  @del > 0
    begin
        print 'Событие: UPDATE';
        set @a1 = (select [TEACHER] from inserted);
        set @a2 = (select [TEACHER_NAME] from inserted);
        set @a3 = (select [GENDER] from inserted);
        set @a4 = (select [PULPIT] from inserted);
        set @in = @a1+''+cast(@a2 as varchar(20)) + '' +cast(@a3 as nvarchar(20))+''+cast(@a4 as nvarchar(30));

    set @a1 = (select [TEACHER] from deleted);
    set @a2 = (select [TEACHER_NAME] from deleted);
    set @a3 = (select [GENDER] from deleted);
    set @a4 = (select [PULPIT] from deleted);
    set @in = @a1+''+cast(@a2 as varchar(20)) + '' +cast(@a3 as nvarchar(20))+''+cast(@a4 as nvarchar(30));
    insert into TR_AUDIT (STMT, TRNAME, CC) values ('UPD', 'TR_TEACHER', @in);
    end;
    return;
--drop trigger TR_TEACHER;

    insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('ЛВН','Лоборева Валентина Николаевна', 'ж','ИСиТ');
    insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('ВНВ','Валова Наталья Владимировна', 'ж','ИСиТ');
    delete from TEACHER where TEACHER = 'ЛВН';
    update TEACHER set TEACHER_NAME = 'Левковская Валентина Николаевна' where TEACHER = 'ЛВН';

select * from TR_AUDIT;


--5:
-- Разработать сценарий, который демонстрирует на примере базы данных X_UNIVER, что проверка ограничения целостности выполняется до срабатывания AFTER-триггера
-- (у таблицы TEACHER ограничение по внешнему ключу)
update TEACHER set PULPIT = 'pulpit' where TEACHER = 'ВНВ';
select * from TR_AUDIT;
go


--6:
-- Создать для таблицы TEACHER три AFTER-триггера с именами: TR_TEACHER_DEL1, TR_TEACHER_DEL2 и TR_TEACHER_DEL3. Триггеры должны реагировать на событие DELETE и формировать соответствующие строки в таблицу TR_AUDIT.  Получить список триггеров таблицы TEACHER
create trigger TR_TEACHER_DEL1 on TEACHER after DELETE
       as print 'AFTER_TR_TEACHER_DEL1';
 return;
go

create trigger TR_TEACHER_DEL2 on TEACHER after DELETE
       as print 'AFTER_TR_TEACHER_DEL2';
return;
go
create trigger TR_TEACHER_DEL3 on TEACHER after DELETE
       as print 'AFTER_TR_TEACHER_DEL3';
 return;
go

delete TEACHER where TEACHER = 'РГЭ';
select * from TR_AUDIT;
go

--Проверка порядка выполнения триггеров:
  select t.name, e.type_desc
         from sys.triggers  t join  sys.trigger_events e
                  on t.object_id = e.object_id
                            where OBJECT_NAME(t.parent_id) = 'TEACHER' and e.type_desc = 'DELETE' ;

-- Изменение порядка выполнения триггеров:
exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3',
    @order = 'First', @stmttype = 'DELETE';

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2',
    @order = 'Last', @stmttype = 'DELETE';


--7:
-- Разработать сценарий, демонстрирующий на примере базы данных X_UNIVER утверждение: AFTER-триггер является частью транзакции, в рамках которого выполняется оператор, активизировавший триггер
create trigger EX7_AUDITORIUM on AUDITORIUM after INSERT, UPDATE
	as declare @c int = (select sum(AUDITORIUM_CAPACITY) from AUDITORIUM);
	if (@c > 700)
		begin
			raiserror('Общая вместимость аудиторий не может быть>700', 10, 1);
			rollback;
		end;
	return;
go

select sum(AUDITORIUM_CAPACITY) from AUDITORIUM; -- проверка суммарной вместимости уже созданных аудиторий;

insert AUDITORIUM values ('151-1', 'ЛК', 394, '151-1');
-- ошибка: при добавлении строки, условие AFTER-триггера нарушается (вместимость аудиторий=800);
select * from AUDITORIUM;
go


--8:
-- Для таблицы FACULTY создать INSTEAD OF-триггер, запрещающий удаление строк в таблице
create trigger FAC_INSTEAD_OF on FACULTY instead of DELETE as raiserror (N'Удаление запрещено', 10, 1);
    return;

-- Операция удаления строки не будет выполнена:
delete from FACULTY where FACULTY = 'ЛФХ';


--9:
-- Создать DDL-триггер, реагирующий на все DDL-события в БД UNIVER. 
-- Триггер должен запрещать создавать новые таблицы и удалять существующие. Свое выполнение триггер должен сопровождать сообщением, 
-- которое содержит: тип события, имя и тип объекта, а также пояснительный текст, в случае запрещения выполнения оператора.
create trigger TR_DDL_UNIVER
    on database for DDL_DATABASE_LEVEL_EVENTS
    as declare
    @ev_type varchar(50) = eventdata().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
declare @obj_name varchar(50) = eventdata().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
declare @obj_type varchar(50) = eventdata().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)');

if (@ev_type = 'CREATE_TABLE')
    begin
        raiserror ('Cant create table', 16, 1);
        rollback;
    end;
if (@ev_type = 'DROP_TABLE')
    begin
        raiserror ('Cant delete table', 16, 1);
        rollback;
    end;
go

create table TESTING
(
    value int
)
drop table TR_AUDIT;
go

drop trigger TR_DDL_UNIVER on database;