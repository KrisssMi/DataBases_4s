/*3.*/ 
/*�������� ������� �� �������*/
USE UNIVERSITY;
ALTER Table Students DROP Column ����_��������;
/*���������� ������� � �������*/
ALTER Table Students ADD ����_�������� date;
ALTER Table Students ADD ��� nchar(1) default '�' check (��� in ('�', '�')); 
/*�������� ������� ��������: DROP table Students*/