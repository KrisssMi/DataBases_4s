use UNIVER;
go

--1:
-- ������� ������� TR_AUDIT
create table TR_AUDIT       -- ��������������� ������� ��� ��������� ���������� �� ���������
(
    ID     int identity,    --�����
    STMT   varchar(20) check (STMT in ('INS', 'UPD', 'DEL')), --DML-��������
    TRNAME varchar(50),     -- ��� ��������
    CC     varchar(300)     -- �����������
);

drop table TR_AUDIT;
-- ����������� AFTER-������� � ������ TR_TEACHER_INS ��� ������� TEACHER, ����������� �� ������� INSERT
create trigger TR_TEACHER_INS on TEACHER after INSERT as declare @a1 varchar(20), @a2 varchar(100), @a3 char(20), @a4 varchar(30), @in varchar(200);
    print '����������� �������� INSERT � ������� TEACHER';
    set @a1 = (select [TEACHER] from inserted);
    set @a2 = (select [TEACHER_NAME] from inserted);
    set @a3 = (select [GENDER] from inserted);
    set @a4 = (select [PULPIT] from inserted);
    set @in = @a1+''+cast(@a2 as varchar(20)) + '' +cast(@a3 as nvarchar(20))+''+cast(@a4 as nvarchar(30));
    insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS', 'TR_TEACHER_INS', @in);
    return;
--drop trigger TR_TEACHER_INS;

insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('���','������ ������ ����������', '�','����');
select * from TR_AUDIT;

select * from TEACHER;


--2:
--������� AFTER-������� � ������ TR_TEACHER_DEL ��� ������� TEACHER, ����������� �� ������� DELETE
create trigger TR_TEACHER_DEL on TEACHER after DELETE as declare @a1 varchar(20), @a2 varchar(100), @a3 char(20), @a4 varchar(30), @in varchar(200);
    print '����������� �������� DELETE �� ������� TEACHER';
    set @a1 = (select [TEACHER] from deleted);
    set @a2 = (select [TEACHER_NAME] from deleted);
    set @a3 = (select [GENDER] from deleted);
    set @a4 = (select [PULPIT] from deleted);
    set @in = @a1+''+cast(@a2 as varchar(20)) + '' +cast(@a3 as nvarchar(20))+''+cast(@a4 as nvarchar(30));
    insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL', @in);
    return;
--drop trigger TR_TEACHER_DEL;

delete from TEACHER where TEACHER='���';
select * from TR_AUDIT;


--3:
-- ������� AFTER-������� � ������ TR_TEACHER_UPD ��� ������� TEACHER, ����������� �� ������� UPDATE
create trigger TR_TEACHER_UPD on TEACHER after UPDATE as declare @a1 varchar(20), @a2 varchar(100), @a3 char(20), @a4 varchar(30), @in varchar(200);
    print '����������� �������� UPDATE �� ������� TEACHER';
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

update TEACHER set TEACHER_NAME = '��������� ������ ����������' where TEACHER='���';
select * from TR_AUDIT;


--4:
-- ������� AFTER-������� � ������ TR_TEACHER ��� ������� TEACHER, ����������� �� ������� INSERT, DELETE, UPDATE
create trigger TR_TEACHER on TEACHER after INSERT, DELETE, UPDATE as declare @a1 varchar(20), @a2 varchar(100), @a3 char(20), @a4 varchar(30), @in varchar(200);
 declare @ins int = (select count(*) from inserted),
        @del int = (select count(*) from deleted);
if  @ins > 0 and  @del = 0
begin
    print '�������: INSERT';
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
        print '�������: DELETE';
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
        print '�������: UPDATE';
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

    insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('���','�������� ��������� ����������', '�','����');
    insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('���','������ ������� ������������', '�','����');
    delete from TEACHER where TEACHER = '���';
    update TEACHER set TEACHER_NAME = '���������� ��������� ����������' where TEACHER = '���';

select * from TR_AUDIT;


--5:
-- ����������� ��������, ������� ������������� �� ������� ���� ������ X_UNIVER, ��� �������� ����������� ����������� ����������� �� ������������ AFTER-��������
-- (� ������� TEACHER ����������� �� �������� �����)
update TEACHER set PULPIT = 'pulpit' where TEACHER = '���';
select * from TR_AUDIT;
go


--6:
-- ������� ��� ������� TEACHER ��� AFTER-�������� � �������: TR_TEACHER_DEL1, TR_TEACHER_DEL2 � TR_TEACHER_DEL3. �������� ������ ����������� �� ������� DELETE � ����������� ��������������� ������ � ������� TR_AUDIT.  �������� ������ ��������� ������� TEACHER
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

delete TEACHER where TEACHER = '���';
select * from TR_AUDIT;
go

--�������� ������� ���������� ���������:
  select t.name, e.type_desc
         from sys.triggers  t join  sys.trigger_events e
                  on t.object_id = e.object_id
                            where OBJECT_NAME(t.parent_id) = 'TEACHER' and e.type_desc = 'DELETE' ;

-- ��������� ������� ���������� ���������:
exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3',
    @order = 'First', @stmttype = 'DELETE';

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2',
    @order = 'Last', @stmttype = 'DELETE';


--7:
-- ����������� ��������, ��������������� �� ������� ���� ������ X_UNIVER �����������: AFTER-������� �������� ������ ����������, � ������ �������� ����������� ��������, ���������������� �������
create trigger EX7_AUDITORIUM on AUDITORIUM after INSERT, UPDATE
	as declare @c int = (select sum(AUDITORIUM_CAPACITY) from AUDITORIUM);
	if (@c > 700)
		begin
			raiserror('����� ����������� ��������� �� ����� ����>700', 10, 1);
			rollback;
		end;
	return;
go

select sum(AUDITORIUM_CAPACITY) from AUDITORIUM; -- �������� ��������� ����������� ��� ��������� ���������;

insert AUDITORIUM values ('151-1', '��', 394, '151-1');
-- ������: ��� ���������� ������, ������� AFTER-�������� ���������� (����������� ���������=800);
select * from AUDITORIUM;
go


--8:
-- ��� ������� FACULTY ������� INSTEAD OF-�������, ����������� �������� ����� � �������
create trigger FAC_INSTEAD_OF on FACULTY instead of DELETE as raiserror (N'�������� ���������', 10, 1);
    return;

-- �������� �������� ������ �� ����� ���������:
delete from FACULTY where FACULTY = '���';


--9:
-- ������� DDL-�������, ����������� �� ��� DDL-������� � �� UNIVER. 
-- ������� ������ ��������� ��������� ����� ������� � ������� ������������. ���� ���������� ������� ������ ������������ ����������, 
-- ������� ��������: ��� �������, ��� � ��� �������, � ����� ������������� �����, � ������ ���������� ���������� ���������.
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