use UNIVER;
go

-- #1:
-- сценарий, формирующий список дис-циплин на кафедре ИСиТ. В отчет должны быть выведены краткие названия (поле SUBJECT) из таблицы SUBJECT в одну строку через запятую:

declare @subj_list char(50), @subj_name char(100)='';
declare discipline cursor for select SUBJECT from SUBJECT where SUBJECT.PULPIT='ИСиТ';

open discipline;
fetch discipline into @subj_list;       -- считывает строку из рез. набора и продвигает указатель на след. строку.
print 'Дисциплины на кафедре ИСиТ: ';
while @@fetch_status=0                  ---- считывание вып. успешно (1 если конец набора, 2 если строки не существует)
begin
   set @subj_name=rtrim(@subj_list)+', '+@subj_name;    -- добавляет к переменной значение из строки из рез. набора
   fetch discipline into @subj_list;
end;
    print @subj_name;
close discipline;


-- #2:
-- отличие глобального курсора от локального:

-- локальный курсор:
declare Puls cursor LOCAL for select PULPIT, FACULTY from PULPIT;

declare @pul nvarchar(10), @fac nvarchar(4);
open Puls;
	fetch Puls into @pul, @fac;
    print rtrim(@pul)+' на факультете >  '+ @fac;

-- пример использования глобального курсора:
declare Puls cursor GLOBAL for select PULPIT, FACULTY from PULPIT;
declare @pul1 nvarchar(10), @fac1 nvarchar(4);
open Puls;
    fetch Puls into @pul1, @fac1;
    print rtrim(@pul1)+' на факультете > '+ @fac1;

	declare @pul2 nvarchar(10), @fac2 nvarchar(4);
	fetch  Puls into @pul2, @fac2;
    print rtrim(@pul2)+' на факультете > '+ @fac2;

    declare @pul3 nvarchar(10), @fac3 nvarchar(4);
    fetch  Puls into @pul3, @fac3;
    print rtrim(@pul3)+' на факультете > '+ @fac3;

    declare @pul4 nvarchar(10), @fac4 nvarchar(4);
    fetch  Puls into @pul4, @fac4;
    print rtrim(@pul4)+' на факультете > '+ @fac4;
close Puls;
deallocate Puls;        -- освобождает память от курсора


-- #3:
-- отличие статических курсоров от динамических:

declare @pul char(10), @gen char(2), @name char(30);
declare Teachers cursor LOCAL dynamic for select PULPIT, GENDER, TEACHER_NAME from TEACHER where PULPIT='ИСиТ';
open Teachers;
print 'Количество строк: '+cast(@@CURSOR_ROWS as varchar(5));
insert into TEACHER values ('КВД', 'Владислав', 'м', 'ИСиТ');
		update TEACHER set TEACHER_NAME = 'Кириленко Владислав Дмитриевич' where TEACHER = 'КВД';
fetch Teachers into @pul, @gen, @name;
print 'Преподаватель: '+rtrim(@pul)+' '+rtrim(@gen)+' '+rtrim(@name);
while @@FETCH_STATUS=0
begin
    fetch Teachers into @pul, @gen, @name;
    print 'Преподаватель: '+rtrim(@pul)+' '+rtrim(@gen)+' '+rtrim(@name);
end;
    close Teachers;
    delete TEACHER where TEACHER = 'КВД';


-- #4:
-- сценарий, демонстрирующий свойства навигации в результирующем наборе курсора с атрибутом SCROLL:

declare @num int, @rn char(50);
declare Primer4 cursor local dynamic SCROLL for select row_number() over (order by NAME) N, NAME from STUDENT where NAME like 'К%'
open Primer4;
fetch FIRST from Primer4 into @num, @rn;
print 'Первая строка: '+cast(@num as varchar(3))+') '+rtrim(@rn);
fetch NEXT from Primer4 into @num, @rn;
print 'Следующая строка за текущей: '+cast(@num as varchar(3))+') '+rtrim(@rn);
fetch PRIOR from Primer4 into @num, @rn;
print 'Предыдущая строка от текущей: '+cast(@num as varchar(3))+') '+rtrim(@rn);
fetch ABSOLUTE 3 from Primer4 into @num, @rn;
print 'Третья строка от начала: '+cast(@num as varchar(3))+') '+rtrim(@rn);
fetch ABSOLUTE -3 from Primer4 into @num, @rn;
print 'Третья строка от конца: '+cast(@num as varchar(3))+') '+rtrim(@rn);
fetch RELATIVE 2 from Primer4 into @num, @rn;
print 'Вторая строка вперед от текущей: '+cast(@num as varchar(3))+') '+rtrim(@rn);
fetch RELATIVE -2 from Primer4 into @num, @rn;
print 'Вторая строка назад от текущей: '+cast(@num as varchar(3))+') '+rtrim(@rn);
fetch LAST from Primer4 into @num, @rn;
print 'Последняя строка: '+cast(@num as varchar(3))+') '+rtrim(@rn);
close Primer4;



-- #5:
-- Создать курсор, демонстрирующий применение конструкции CURRENT OF в секции WHERE с использованием операторов UPDATE и DELETE:

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
-- из таблицы PROGRESS удаляются строки с оценками <4  (объединение PROGRESS, STUDENT, GROUPS)
insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE) values
	('КГ',   1026,  '06.05.2013',3),
	('КГ',   1027,  '06.05.2013',2),
	('КГ',   1028,  '06.05.2013',2),
	('КГ',   1029,  '06.05.2013',3),
	('КГ',   1030,  '06.05.2013',1),
	('КГ',   1031,  '06.05.2013',3)

select * from PROGRESS -- проверка вставки и последующего удаления строк


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

insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE) values ('КГ',   1025,  '06.05.2013',3)
select NAME, NOTE from PROGRESS inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT where NOTE<4
go




-- #6_2:
-- SELECT-запрос, с помощью которого в таблице PROGRESS для студента с конкретным номером IDSTUDENT корректируется оценка (увеличивается на единицу):

-- увеличение отметки студента на единицу:
declare EX6_2 cursor local for select NAME, NOTE from PROGRESS inner join STUDENT S on PROGRESS.IDSTUDENT = S.IDSTUDENT
where PROGRESS.IDSTUDENT=1025;
declare @student nvarchar(20), @mark int;
open EX6_2;
fetch EX6_2 into @student, @mark;
update PROGRESS set NOTE = NOTE + 1 where current of EX6_2;
close EX6_2;


select * from PROGRESS;

-- уменьшение отметки студента на одну единицу:
select NAME, NOTE
from PROGRESS inner join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where PROGRESS.IDSTUDENT = 1025

update PROGRESS set NOTE = NOTE - 1 where IDSTUDENT = 1025;
go




