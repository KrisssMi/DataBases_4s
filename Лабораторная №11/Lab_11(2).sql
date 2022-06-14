--4:
-- ����� ���������� � ������� ��������������� READ COMMITED
-----B�-----
-----t2---------
begin transaction
select @@SPID
insert FACULTY values('��as','�������������� ����������');

-----t1----------
-----t2----------
rollback;


--5:
-- ����� ���������� � ������� ��������������� READ UNCOMMITED
-----B�-----
begin transaction
-----t1---------
update SUBJECT set SUBJECT_NAME = '���� ������ (��������_2)' where SUBJECT = '��';
commit tran;
-----t2---------
--rollback;


--6:
-- ����� ���������� � ������� ��������������� READ COMMITED
-----B------
begin transaction
update SUBJECT set SUBJECT_NAME ='NEW DB' where SUBJECT = '��'
commit tran;
rollback;

--7:
-- ����� ���������� � ������� ��������������� READ UNCOMMITED
-----B------
begin transaction
insert SUBJECT values('NEW' , 'NEW' , '����');
commit;
--rollback;