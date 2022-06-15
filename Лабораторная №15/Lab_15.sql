use UNIVER;
go

--1:
-- �������� �������� XML-��������� � ������ PATH �� ������� TEACHER ��� �������������� ������� ����
select * from TEACHER where TEACHER.PULPIT = '����'
for xml PATH('TEACHER'), root('TEACHER_LIST');


--2:
-- ����� AUTO, ������ � �������� AUDITORIUM � AUDITORIUM_TYPE, ����� ������ ����������
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPE, AUDITORIUM.AUDITORIUM_CAPACITY
from AUDITORIUM
         inner join AUDITORIUM_TYPE
                    on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE like N'%��%'
for xml AUTO, root('LECTURE_AUDITORIUMS'), elements


--3:
-- xml-��� � ����� ������ ������������ ��� ����������
declare @h int = 0, @text varchar(1000) =
	'<?xml version="1.0" encoding="windows-1251"?>
	<����������>
		<������� ���="��" ���������="���������" �������="����"/>
		<������� ���="���" ���������="������ ������ ����������" �������="����"/>
		<������� ���="����" ���������="������������ ��������� � �������" �������="����"/>
	</����������>';
exec sp_xml_preparedocument @h output, @text;

--���������� ������ �� XML-��������� 
select * from openxml(@h, '/����������/�������',0)
	with([���] nvarchar(10), [���������] nvarchar(70), [�������] nvarchar(10))

--���������� ������ � XML-��������
insert SUBJECT select [���], [���������], [�������]
	from openxml(@h, '/����������/�������',0)	--�������������� XML-������ � ������ ������� (����������, ��������� XPATH � ����� ������������� �����, ���������-��� ����� ������ �������)
		with([���] nvarchar(10), [���������] nvarchar(70), [�������] nvarchar(10))		--������ ���� ������� ��������� ������������ ����������

select * from SUBJECT
delete SUBJECT where SUBJECT in('��', '���', '����')

exec sp_xml_removedocument @h;
go


--4:
delete STUDENT where NAME = N'������� �������� ����������'
select * from STUDENT where NAME = N'������� �������� ����������'

insert STUDENT(IDGROUP, NAME, BDAY, INFO)
values (19, N'������� �������� ����������', '2003-01-29',
        N'
        <�������>
            <������� �����="��" �����="9393993" ����="01.01.2018"/>
            <�������>7270388</�������>
            <�����>
                <������>��������</������>
                <�����>�����</�����>
                <�����>�����������</�����>
                <���>21</���>
                <��������>702</��������>
            </�����>
        </�������>')

update STUDENT
set INFO =
        N'
        <�������>
           <������� �����="��" �����="9393993" ����="01.01.2018"/>
           <�������>7270388</�������>
           <�����>
                <������>��������</������>
                <�����>�����</�����>
                <�����>�����������</�����>
                <���>21</���>
                <��������>702</��������>
            </�����>
        </�������>'
where STUDENT.INFO.value(N'(/�������/�����/���)[1]', 'int') = 1;

select NAME,
       INFO.value(N'(�������/�������/@�����)[1]', 'char(2)')     '����� ��������',
       INFO.value(N'(�������/�������/@�����)[1]', 'varchar(10)') '����� ��������',
       INFO.query(N'/�������/�����')                             '�����'
from STUDENT where NAME = N'������� �������� ����������'

--��� ��������:
select * from STUDENT;


--5:
drop xml schema collection Student

create xml schema collection Student as
    N'<?xml version="1.0" encoding="utf-16" ?>
    <xs:schema attributeFormDefault="unqualified" elementFormDefault="qualified"
               xmlns:xs="http://www.w3.org/2001/XMLSchema">
        <xs:element name="�������">
            <xs:complexType>
                <xs:sequence>
                    <xs:element name="�������" maxOccurs="1" minOccurs="1">
                        <xs:complexType>
                            <xs:attribute name="�����" type="xs:string" use="required"/>
                            <xs:attribute name="�����" type="xs:unsignedInt" use="required"/>
                            <xs:attribute name="����" use="required">
                                <xs:simpleType>
                                    <xs:restriction base="xs:string">
                                        <xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
                                    </xs:restriction>
                                </xs:simpleType>
                            </xs:attribute>
                        </xs:complexType>
                    </xs:element>
                    <xs:element maxOccurs="3" name="�������" type="xs:unsignedInt"/>
                    <xs:element name="�����">
                        <xs:complexType>
                            <xs:sequence>
                                <xs:element name="������" type="xs:string"/>
                                <xs:element name="�����" type="xs:string"/>
                                <xs:element name="�����" type="xs:string"/>
                                <xs:element name="���" type="xs:string"/>
                                <xs:element name="��������" type="xs:string"/>
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
        <�������>
            <������� �����="�B" �����="1111111" ����="05.05.2005"/>
            <�������>2434353</�������>
            <�����>
                <������>��������</������>
                <�����>�����</�����>
                <�����>���������</�����>
                <���>13</���>
                <��������>324</��������>
            </�����>
        </�������>')

insert STUDENT(IDGROUP, NAME, BDAY, INFO)
values (20, 'test2', '01.01.2000',
        N'
        <�������>
            <������� �����="�B" �����="2222222" ����="06.06.2006"/>
            <�������>54fffffff333</�������>
            <�����>
                <������>��������</������>
                <�����>�����</�����>
                <�����>�����������</�����>
                <���>19</���>
                <��������>416</��������>
            </�����>
        </�������>')

delete STUDENT where NAME = 'test';
delete STUDENT where NAME = 'test2';
select * from STUDENT;
