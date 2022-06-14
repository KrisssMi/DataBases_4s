--1:
-- ����� ������� ����������
-- ���������� ����������, ���� ����������� ���� �� ��������� ����������: 
-- CREATE, DROP; ALTER TABLE; INSERT, DELETE, UPDATE, SELECT, TRUNCATE TABLE; OPEN, FETCH; GRANT; REVOKE 

set nocount on;
if exists (select * from sys.objects where OBJECT_ID = object_id(N'dbo.EX1_T')) -- ������� ����?
	drop table EX1_T;

declare @c int, @flag char = 'r';		-- ���� �->r, ������� �� ����
set implicit_transactions on;			-- �����. ����� ������� ����������
create table EX1_T (val int);			-- ������ ���������� 
insert EX1_T values (1), (2), (3);
set @c = (select count(*) from EX1_T);
print '���-�� ����� � ������� EX1_T: ' + convert(varchar, @c);
if @flag = 'c'							-- ���������� ����������: �������� 
	commit;				
else 
	rollback;							-- ���������� ����������: �����  
set implicit_transactions off;			-- ������. ����� ������� ����������

if exists (select * from sys.objects where OBJECT_ID = object_id(N'dbo.EX1_T'))
	print '������� EX1_T ����';
else
	print '������� EX1_T ���';


--2:
-- ����������� ����� ����������
delete AUDITORIUM where AUDITORIUM_NAME = '222-1';
insert into AUDITORIUM values('222-1','��-�','15','222-1');

begin try
	begin tran									-- ������ ����� ����������
		delete AUDITORIUM where AUDITORIUM_NAME = '222-1';
		print '* ��������� �������';
		insert into AUDITORIUM values('222-1','��-�','15','222-1');
		print '* ��������� ���������';
		update AUDITORIUM set AUDITORIUM_CAPACITY = '30' where AUDITORIUM_NAME='222-1';
		print '* ��������� ��������';
	commit tran;								-- �������� ����������
end try
begin catch
	print '������: ' + case
		when ERROR_NUMBER() = 2627 and PATINDEX('%AUDITORIUM_PK%', ERROR_MESSAGE()) > 0		-- ���������� � ������ ������� ������� ������� ���������, �������� ��������
			then '��������'
			else '����������� ������: ' + CAST(ERROR_NUMBER() as varchar(5)) + ERROR_MESSAGE()
		end;
	if @@TRANCOUNT > 0 rollback tran;
end catch;


--3:
-- ��������, ��������������� ���������� ��������� SAVE TRAN (���������� ������� �� ���������� ����������� ������ ���������� T-SQL)
delete AUDITORIUM where AUDITORIUM_NAME = '333-1'
insert into AUDITORIUM values ('333-1', N'��-�', 15, '333-1')

declare @point varchar(32)
begin try
    begin tran
        delete AUDITORIUM where AUDITORIUM_NAME = '333-1'
        print 'Auditorium 333-1 deleted'
        set @point = 'p1'		
        save tran @point		-- ����������� �����

        insert into AUDITORIUM values ('333-1', N'��-�', 15, '333-1')
        print 'Auditorium 333-1 inserted'
        set @point = 'p2'
        save tran @point		-- ����������� �����

        update AUDITORIUM set AUDITORIUM_CAPACITY = 30 where AUDITORIUM_NAME = '333-1'
        print 'Auditorium 333-1 capacity updated'
        insert into AUDITORIUM values ('333-1', N'��-�', 15, '333-1')
    commit tran
end try

begin catch
    print 'Error: ' + case
        when error_number() = 547 then 'Auditorium 333-1 does not exist'
        when error_number() = 2627 then 'Auditorium 333-1 already exists'
        else 'Unknown error ' + convert(varchar, error_number()) + ': ' + error_message()
    end
    if @@trancount > 0			-- ��.����������� ����������>0 =>  ����� �� ��������� 
    begin
        rollback tran @point
        commit tran
    end
end catch


--4:
------A------
--����� ���������� � ������� ��������������� READ UNCOMMITED,
--���. ������ �����������, ��������. � ��������� ������
set transaction isolation level READ UNCOMMITTED
begin transaction
-----t1---------
select @@SPID, 'insert FACULTY' '���������', *
from FACULTY;
--commit;
rollback;


--5: ��������������� ������
------A------
set transaction isolation level READ COMMITTED
begin transaction
select * from SUBJECT where SUBJECT = '��';
------t1----------
------t2----------
select * from SUBJECT where SUBJECT = '��';
commit tran;
rollback;


--6:
-- ����� ���������� � ������� ��������������� REPEATABLE READ
------A------
set transaction isolation level REPEATABLE READ
begin transaction
select * from SUBJECT where SUBJECT = '��';
------t1-----------
------t2-----------
select count(*) from SUBJECT where SUBJECT = '��';
rollback;


--7:
-- ����� ���������� � ������� ��������������� SERIALIZABLE
------A------
set transaction isolation level Serializable 
begin transaction
select * from SUBJECT;
------t1-----------
------t2-----------
rollback;


--8:
--��������� ����������
drop table #table_8;

CREATE TABLE #table_8(A INT, B INT);
INSERT #table_8 VALUES(1,100);
BEGIN TRAN						-- ������ ���������� ����������
INSERT #table_8 VALUES(10,10)	-- ������� �� ���������� ����������
	BEGIN TRAN
	UPDATE #table_8 SET A = 1 WHERE B = 333
	COMMIT;						-- �������� ���������� ���������� (��������� ������ �� ���������� ��������)
IF @@TRANCOUNT > 0				-- ���������� ������� �����������
ROLLBACK;						-- ROLLBACK ������� ���������� �������� ��������������� �������� ���������� ����������

SELECT * FROM #table_8;