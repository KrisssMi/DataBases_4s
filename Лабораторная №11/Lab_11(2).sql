--4:
-- Явная транзакция с уровнем изолированности READ COMMITED
-----B–-----
-----t2---------
begin transaction
select @@SPID
insert FACULTY values('ИТas','Информационных технологий');

-----t1----------
-----t2----------
rollback;


--5:
-- Явная транзакция с уровнем изолированности READ UNCOMMITED
-----B–-----
begin transaction
-----t1---------
update SUBJECT set SUBJECT_NAME = 'Базы данных (изменено_2)' where SUBJECT = 'БД';
commit tran;
-----t2---------
--rollback;


--6:
-- Явная транзакция с уровнем изолированности READ COMMITED
-----B------
begin transaction
update SUBJECT set SUBJECT_NAME ='NEW DB' where SUBJECT = 'БД'
commit tran;
rollback;

--7:
-- Явная транзакция с уровнем изолированности READ UNCOMMITED
-----B------
begin transaction
insert SUBJECT values('NEW' , 'NEW' , 'ИСиТ');
commit;
--rollback;