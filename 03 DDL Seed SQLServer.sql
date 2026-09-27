-- SQL Server | Database-per-tenant (3 tenants)
-- Run in sqlcmd or SSMS. GO is a batch separator.
SET NOCOUNT ON;
IF DB_ID(N'hr_tenant_1') IS NOT NULL DROP DATABASE hr_tenant_1;
IF DB_ID(N'hr_tenant_2') IS NOT NULL DROP DATABASE hr_tenant_2;
IF DB_ID(N'hr_tenant_3') IS NOT NULL DROP DATABASE hr_tenant_3;
GO
CREATE DATABASE hr_tenant_1;
GO
USE hr_tenant_1;
GO
CREATE TABLE departments(dept_id INT IDENTITY(1,1) PRIMARY KEY,dept_name NVARCHAR(100) NOT NULL,location NVARCHAR(100));
CREATE TABLE roles(role_id INT IDENTITY(1,1) PRIMARY KEY,role_name NVARCHAR(100) NOT NULL,role_level INT);
CREATE TABLE role_permissions(rp_id INT IDENTITY(1,1) PRIMARY KEY,role_id INT NOT NULL REFERENCES roles(role_id),resource NVARCHAR(50) NOT NULL,action NVARCHAR(20) NOT NULL,can_read SMALLINT DEFAULT 0,can_write SMALLINT DEFAULT 0);
CREATE TABLE employees(emp_id INT IDENTITY(1,1) PRIMARY KEY,full_name NVARCHAR(150) NOT NULL,dept_id INT NOT NULL REFERENCES departments(dept_id),role_id INT NOT NULL REFERENCES roles(role_id),salary DECIMAL(10,2) NOT NULL,hire_date DATE NOT NULL,is_active SMALLINT DEFAULT 1);
CREATE TABLE attendance(att_id INT IDENTITY(1,1) PRIMARY KEY,emp_id INT NOT NULL REFERENCES employees(emp_id),work_date DATE NOT NULL,hours_worked DECIMAL(4,1) NOT NULL,is_remote SMALLINT DEFAULT 0);
CREATE TABLE employee_bank_accounts(account_id INT IDENTITY(1,1) PRIMARY KEY,emp_id INT NOT NULL REFERENCES employees(emp_id),iban NVARCHAR(34),bank_name NVARCHAR(100));
GO
SET IDENTITY_INSERT departments ON;
INSERT INTO departments(dept_id,dept_name,location) VALUES (1,N'الموارد البشرية',N'الرياض'),(2,N'الهندسة',N'جدة'),(3,N'المبيعات',N'الرياض'),(4,N'المالية',N'جدة'),(5,N'التسويق',N'الدمام'),(6,N'أمن المعلومات',N'الرياض');
SET IDENTITY_INSERT departments OFF;
SET IDENTITY_INSERT roles ON;
INSERT INTO roles(role_id,role_name,role_level) VALUES (1,N'مدير عام',5),(2,N'مدير قسم',4),(3,N'مهندس أول',4),(4,N'محاسب',3),(5,N'أخصائي موارد بشرية',3),(6,N'مندوب مبيعات',2),(7,N'متدرب',1);
SET IDENTITY_INSERT roles OFF;
SET IDENTITY_INSERT role_permissions ON;
INSERT INTO role_permissions(rp_id,role_id,resource,action,can_read,can_write) VALUES (1,1,N'employees',N'read',1,0),(2,1,N'employees',N'write',0,1),(3,2,N'employees',N'read',1,0),(4,2,N'departments',N'read',1,0),(5,3,N'attendance',N'read',1,0),(6,5,N'employees',N'read',1,0),(7,6,N'attendance',N'read',1,0),(8,4,N'employees',N'read',1,0);
SET IDENTITY_INSERT role_permissions OFF;
SET IDENTITY_INSERT employees ON;
INSERT INTO employees(emp_id,full_name,dept_id,role_id,salary,hire_date,is_active) VALUES (1,N'أحمد محمود سالم',2,3,18500,'2019-03-10',1),(2,N'سارة عبدالله القحطاني',1,5,9500,'2021-06-15',1),(3,N'محمد إبراهيم حسن',3,6,7200,'2022-01-05',1),(4,N'فاطمة الزهراء علي',4,4,8800,'2020-11-20',1),(5,N'خالد سعد العتيبي',2,1,25000,'2018-07-01',1),(6,N'نورة سالم الدوسري',5,4,8400,'2023-02-12',1),(7,N'عمر فاروق شكري',2,3,17800,'2019-09-01',1),(8,N'ريم ناصر الحربي',3,6,6900,'2023-05-20',1),(9,N'يوسف كامل مراد',1,2,24000,'2018-01-15',1),(10,N'هند عادل الشامي',2,3,18200,'2020-04-03',1),(11,N'طارق حسن مصطفى',4,4,8600,'2022-08-14',0),(12,N'لمى عبدالرحمن الغامدي',5,7,3500,'2024-03-01',1);
SET IDENTITY_INSERT employees OFF;
SET IDENTITY_INSERT attendance ON;
INSERT INTO attendance(att_id,emp_id,work_date,hours_worked,is_remote) VALUES (1,1,'2026-09-21',8,0),(2,1,'2026-09-22',9,1),(3,1,'2026-09-23',7.5,0),(4,2,'2026-09-21',8,0),(5,2,'2026-09-24',6,1),(6,3,'2026-09-22',8,0),(7,3,'2026-09-25',4,1),(8,4,'2026-09-21',8,0),(9,4,'2026-09-22',9.5,0),(10,5,'2026-09-23',10,0),(11,5,'2026-09-24',8,1),(12,5,'2026-09-26',9,0),(13,6,'2026-09-21',8,0),(14,6,'2026-09-22',5,1),(15,7,'2026-09-23',8,0),(16,7,'2026-09-25',9,0),(17,8,'2026-09-21',7,1),(18,8,'2026-09-24',8,0),(19,9,'2026-09-22',8,0),(20,9,'2026-09-23',6,1),(21,9,'2026-09-26',8,0),(22,10,'2026-09-24',8,0),(23,10,'2026-09-25',8,1),(24,11,'2026-09-20',8,0),(25,12,'2026-09-21',6,0),(26,12,'2026-09-22',6,1);
SET IDENTITY_INSERT attendance OFF;
SET IDENTITY_INSERT employee_bank_accounts ON;
INSERT INTO employee_bank_accounts(account_id,emp_id,iban,bank_name) VALUES (1,1,N'SA52601815908301661318',N'مصرف الراجحي'),(2,2,N'SA60913909960308246281',N'بنك الرياض'),(3,3,N'SA94821993518190937865',N'بنك ساب'),(4,4,N'SA79754323194875749118',N'بنك البلاد'),(5,5,N'SA62527601895559797114',N'البنك الأهلي السعودي'),(6,6,N'SA71049746507529170342',N'مصرف الراجحي'),(7,7,N'SA36671276842684656321',N'بنك الرياض'),(8,8,N'SA22330792440268599528',N'بنك ساب'),(9,9,N'SA90786666176031372159',N'بنك البلاد'),(10,10,N'SA01092815901396245957',N'البنك الأهلي السعودي'),(11,11,N'SA11777741215472803852',N'مصرف الراجحي'),(12,12,N'SA80841485253888539336',N'بنك الرياض');
SET IDENTITY_INSERT employee_bank_accounts OFF;
GO
-- Tenant 2 and tenant 3 should use the same schema and their supplied tenant-specific seed rows.
