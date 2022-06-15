use UNIVER;
go

--1:
-- сценарий создания XML-документа в режиме PATH из таблицы TEACHER для преподавателей кафедры ИСиТ
select * from TEACHER where TEACHER.PULPIT = 'ИСиТ'
for xml PATH('TEACHER'), root('TEACHER_LIST');


--2:
-- режим AUTO, запрос к таблицам AUDITORIUM и AUDITORIUM_TYPE, найти только лекционные
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPE, AUDITORIUM.AUDITORIUM_CAPACITY
from AUDITORIUM
         inner join AUDITORIUM_TYPE
                    on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE like N'%ЛК%'
for xml AUTO, root('LECTURE_AUDITORIUMS'), elements


--3:
-- xml-док с тремя новыми дисциплинами для добавления
declare @h int = 0, @text varchar(1000) =
	'<?xml version="1.0" encoding="windows-1251"?>
	<Дисциплины>
		<Предмет код="ЭК" полностью="Экономика" кафедра="ЭТиМ"/>
		<Предмет код="ОЗИ" полностью="Основы защиты информации" кафедра="ИСиТ"/>
		<Предмет код="КГиГ" полностью="Компьютерная геометрия и графика" кафедра="ИСиТ"/>
	</Дисциплины>';
exec sp_xml_preparedocument @h output, @text;

--извлечение данных из XML-документа 
select * from openxml(@h, '/Дисциплины/Предмет',0)
	with([код] nvarchar(10), [полностью] nvarchar(70), [кафедра] nvarchar(10))

--добавление данных в XML-документ
insert SUBJECT select [код], [полностью], [кафедра]
	from openxml(@h, '/Дисциплины/Предмет',0)	--преобразование XML-данных в строки таблицы (дескриптор, выражение XPATH и целое положительное число, определяю-щее режим работы функции)
		with([код] nvarchar(10), [полностью] nvarchar(70), [кафедра] nvarchar(10))		--должна быть указана структура формируемого результата

select * from SUBJECT
delete SUBJECT where SUBJECT in('ЭК', 'ОЗИ', 'КГиГ')

exec sp_xml_removedocument @h;
go


--4:
delete STUDENT where NAME = N'Миневич Кристина Викторовна'
select * from STUDENT where NAME = N'Миневич Кристина Викторовна'

insert STUDENT(IDGROUP, NAME, BDAY, INFO)
values (19, N'Миневич Кристина Викторовна', '2003-01-29',
        N'
        <студент>
            <паспорт серия="АВ" номер="9393993" дата="01.01.2018"/>
            <телефон>7270388</телефон>
            <адрес>
                <страна>Беларусь</страна>
                <город>Минск</город>
                <улица>Белорусская</улица>
                <дом>21</дом>
                <квартира>702</квартира>
            </адрес>
        </студент>')

update STUDENT
set INFO =
        N'
        <студент>
           <паспорт серия="АВ" номер="9393993" дата="01.01.2018"/>
           <телефон>7270388</телефон>
           <адрес>
                <страна>Беларусь</страна>
                <город>Минск</город>
                <улица>Белорусская</улица>
                <дом>21</дом>
                <квартира>702</квартира>
            </адрес>
        </студент>'
where STUDENT.INFO.value(N'(/студент/адрес/дом)[1]', 'int') = 1;

select NAME,
       INFO.value(N'(студент/паспорт/@серия)[1]', 'char(2)')     'Серия паспорта',
       INFO.value(N'(студент/паспорт/@номер)[1]', 'varchar(10)') 'Номер паспорта',
       INFO.query(N'/студент/адрес')                             'Адрес'
from STUDENT where NAME = N'Миневич Кристина Викторовна'

--для проверки:
select * from STUDENT;


--5:
drop xml schema collection Student

create xml schema collection Student as
    N'<?xml version="1.0" encoding="utf-16" ?>
    <xs:schema attributeFormDefault="unqualified" elementFormDefault="qualified"
               xmlns:xs="http://www.w3.org/2001/XMLSchema">
        <xs:element name="студент">
            <xs:complexType>
                <xs:sequence>
                    <xs:element name="паспорт" maxOccurs="1" minOccurs="1">
                        <xs:complexType>
                            <xs:attribute name="серия" type="xs:string" use="required"/>
                            <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
                            <xs:attribute name="дата" use="required">
                                <xs:simpleType>
                                    <xs:restriction base="xs:string">
                                        <xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
                                    </xs:restriction>
                                </xs:simpleType>
                            </xs:attribute>
                        </xs:complexType>
                    </xs:element>
                    <xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
                    <xs:element name="адрес">
                        <xs:complexType>
                            <xs:sequence>
                                <xs:element name="страна" type="xs:string"/>
                                <xs:element name="город" type="xs:string"/>
                                <xs:element name="улица" type="xs:string"/>
                                <xs:element name="дом" type="xs:string"/>
                                <xs:element name="квартира" type="xs:string"/>
                            </xs:sequence>
                        </xs:complexType>
                    </xs:element>
                </xs:sequence>
            </xs:complexType>
        </xs:element>
    </xs:schema>'

alter table STUDENT
    alter column INFO xml(Student);

insert STUDENT(IDGROUP, NAME, BDAY, INFO)
values (19, 'test', '01.01.2000',
        N'
        <студент>
            <паспорт серия="НB" номер="1111111" дата="05.05.2005"/>
            <телефон>2434353</телефон>
            <адрес>
                <страна>Беларусь</страна>
                <город>Минск</город>
                <улица>Свердлова</улица>
                <дом>13</дом>
                <квартира>324</квартира>
            </адрес>
        </студент>')

insert STUDENT(IDGROUP, NAME, BDAY, INFO)
values (20, 'test2', '01.01.2000',
        N'
        <студент>
            <паспорт серия="НB" номер="2222222" дата="06.06.2006"/>
            <телефон>54fffffff333</телефон>
            <адрес>
                <страна>Беларусь</страна>
                <город>Минск</город>
                <улица>Белорусская</улица>
                <дом>19</дом>
                <квартира>416</квартира>
            </адрес>
        </студент>')

delete STUDENT where NAME = 'test';
delete STUDENT where NAME = 'test2';
select * from STUDENT;
