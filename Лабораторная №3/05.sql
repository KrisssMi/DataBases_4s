/*5.*/
/*������������� ��������� SELECT*/
/*����� ���� ���������� �� �������*/
USE UNIVERSITY;
SELECT * From Students;

/*����� ����������� ���� ��������*/
SELECT �����_�������, �������_��������  From Students;

/*������� ���������� ���� ����� � �����-���� �������*/
SELECT count(*)[���������� ���������] From Students; 

/*����� ������� ���� ��������� �� 4 ������, ��� ���� ������� ����������� ���������� �������� ����*/
SELECT �������_�������� [�������� ����] From Students
	Where ������=4
/* !!! ���� ������������ ���� �������� ������ �������, �� ��� ����������� � ���������� ������.*/

/*����� ���� ����� �������� ������������_������ � ����_������� �� ������� ������. ���������� ������������� �� �����������, ������������� ������ �� ���������*/
SELECT Distinct Top(7)  �������_��������, ���_��������
From Students Order by �������_�������� ASC;