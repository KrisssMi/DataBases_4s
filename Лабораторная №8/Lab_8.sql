use UNIVER;

-- 1:
declare @a char='П',
    @b varchar(20)='Hello world',
    @c datetime,
    @d time,
    @e int,
    @f smallint,
    @g tinyint,         --без инициализации
    @h numeric(12, 5);  --(p,s) позволяет непосредственно задать и точность, и масштаб (по умолчанию (12,6)

set @c=getdate();
select @d='12:34:56';
select @e=count(*) from STUDENT;
select @f=@e+count(*) from STUDENT;
select @h=convert(numeric(12, 5), 12345.6789);

select @a a, @b b, @c c, @d d;
print 'В базе данных '+cast(@e as varchar(10))+' студентов';
print 'В базе данных '+cast(@f as varchar(10))+'  студентов, включая повторных';
print 'Тип NUMERIC(12,5): '+cast(@h as varchar(12));



--2:
declare @y1 int = (select sum(AUDITORIUM.AUDITORIUM_CAPACITY) from AUDITORIUM),
        @y2 real,
        @y3 numeric(8,3),
        @y4 real,
        @y5 real;

if @y1>=200
begin
	set @y2 = (select count(*) from AUDITORIUM)
    set @y3=(select avg(AUDITORIUM_CAPACITY) from AUDITORIUM);
    set @y4=(select cast(count(*) as numeric(8,3)) from AUDITORIUM where AUDITORIUM_CAPACITY<=@y3);
    set @y5=100*(cast(@y4 as float)/cast(@y2 as float));
    select @y2 'Количество аудиторий с площадью более 200 м2: ', @y3 'Средняя вместимость аудиторий: ', @y4 'Количество аудиторий с площадью менее средней площади', @y5 'Процент аудиторий с площадью менее средней площади';

end
else if @y1<200
    select @y1  'Cуммарная вместимость';



--3:
print 'число обработанных строк: ' + cast(@@rowcount as varchar(10));
print 'версия SQL Server: ' + cast(@@version as varchar(10));
print 'системный идентификатор процесса, назначенный сервером текущему подключению: ' + cast(@@spid as varchar(10));
print 'код последней ошибки: ' + cast(@@error as varchar(10));
print 'имя сервера: ' + cast(@@servername as varchar(10));
print 'уровень вложенности транзакции: ' + cast(@@trancount as varchar(10));
print 'print: ' + cast(@@fetch_status as varchar(10));
print 'уровень вложенности текущей процедуры: ' + cast(@@nestlevel as varchar(10));



--4:
-- вычисление значений переменной z на основе значений переменных x и y
declare @t float=0.5, @x int=8, @z float;
if @t>@x
set @z=round(sin(@t),2);
else
if @t<@x
set @z=4*(@t+@x)
else
set @z=1-exp(round(@x,2));
print 'Значение переменной z: ' + cast(@z as varchar(10));


-- преобразование полного ФИО студента в сокращенное (например, Макейчик Татьяна Леонидовна в Макейчик Т. Л.);
select SUBSTRING(NAME, 1, CHARINDEX(' ', NAME)+1)+'.'
      +SUBSTRING(NAME, CHARINDEX(' ', NAME, CHARINDEX(' ', NAME)+1)+1, 1) [Инициалы студентов] from STUDENT;


-- поиск студентов, у которых день рождения в следующем месяце, и определение их возраста;
select NAME as 'Имя студента', 2022-YEAR(BDAY) as 'Возраст'		--у кого др в след.месяце
	from STUDENT
	where MONTH(BDAY)=MONTH(getdate())+1;


-- поиск дня недели, в который студенты некоторой группы сдавали экзамен по СУБД:
select PDATE, DATENAME(WEEKDAY, PDATE) as [День_недели]
	from PROGRESS
		where SUBJECT = 'СУБД'


--5:
--Продемонстрировать конструкцию IF… ELSE:
if ((select count(*) from AUDITORIUM) > 10)
    begin
	print 'Аудиторий менее 10-ти';
	end
else
    begin
	print 'Аудиторий больше 10-ти';
	end



--6:











