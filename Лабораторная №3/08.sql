/*8-9: */
/*�������� ��������� � �������� �������� ���� ������ � ���, ����� ����� ����������� � ������������ ������ ������.*/

use master  
create database MiKV_bd on primary	--��������� �������� ������
( name = N'MiKV_bd_mdf', filename = N'E:\BD\new\MiKV_bd_mdf.mdf', 
   size = 10240Kb, maxsize=UNLIMITED, filegrowth=1024Kb),
( name = N'MiKV_bd_ndf', filename = N'E:\BD\new\MiKV_bd_ndf.ndf', 
   size = 10240KB, maxsize=1Gb, filegrowth=25%),
filegroup FG1							--��������� �������� ������
( name = N'MiKV_bd_fg1_1', filename = N'E:\BD\new\MiKV_bd_fgq-1.ndf', 
   size = 10240Kb, maxsize=1Gb, filegrowth=25%),
( name = N'MiKV_bd_fg1_2', filename = N'E:\BD\new\MiKV_bd_fgq-2.ndf', 
   size = 10240Kb, maxsize=1Gb, filegrowth=25%)
log on
( name = N'MiKV_bd_log', filename=N'E:\BD\new\MiKV_bd_log.ldf',       
   size=10240Kb,  maxsize=2048Gb, filegrowth=10%)
go

USE MiKV_bd;
create table FACULTY
(    
FACULTY varchar(10) primary key,
FACULTY_NAME  varchar(50)
) ON FG1;
insert into FACULTY   (FACULTY,   FACULTY_NAME )
            values  ('����',   '���������� ���������� � �������'),
            ('���',     '����������������� ���������'),
			('���',     '���������-������������� ���������'),
			('����',    '���������� � ������� ������ ��������������'),
			('���',     '���������� ������������ �������'),
			('��',     '��������� �������������� ����������'),
			('����', '������������ ���� � ����������'); 
