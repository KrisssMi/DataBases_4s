/*2.*/
/*�������� ������� ������*/
USE UNIVERSITY;
CREATE table Groups
( 
�������������_������ int primary key,
��������� nvarchar(5)
);

/*�������� ������� ��������*/
CREATE table Students 
( 
�����_������� int primary key,
�������_�������� nvarchar(30),
���_�������� nvarchar(20),
������ int foreign key references Groups(�������������_������),
����_�������� date
);