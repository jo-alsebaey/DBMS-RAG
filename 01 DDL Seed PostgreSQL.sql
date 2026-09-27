-- PostgreSQL | Database-per-tenant (3 tenants)
-- Run with psql. This script is intentionally idempotent for local development.
\set ON_ERROR_STOP on
DROP DATABASE IF EXISTS hr_tenant_1;
DROP DATABASE IF EXISTS hr_tenant_2;
DROP DATABASE IF EXISTS hr_tenant_3;
CREATE DATABASE hr_tenant_1;
\connect hr_tenant_1
SET client_encoding = 'UTF8';

CREATE TABLE departments (dept_id SERIAL PRIMARY KEY, dept_name VARCHAR(100) NOT NULL, location VARCHAR(100));
CREATE TABLE roles (role_id SERIAL PRIMARY KEY, role_name VARCHAR(100) NOT NULL, role_level INT);
CREATE TABLE role_permissions (rp_id SERIAL PRIMARY KEY, role_id INT NOT NULL REFERENCES roles(role_id), resource VARCHAR(50) NOT NULL, action VARCHAR(20) NOT NULL, can_read SMALLINT DEFAULT 0, can_write SMALLINT DEFAULT 0);
CREATE TABLE employees (emp_id SERIAL PRIMARY KEY, full_name VARCHAR(150) NOT NULL, dept_id INT NOT NULL REFERENCES departments(dept_id), role_id INT NOT NULL REFERENCES roles(role_id), salary NUMERIC(10,2) NOT NULL, hire_date DATE NOT NULL, is_active SMALLINT DEFAULT 1);
CREATE TABLE attendance (att_id SERIAL PRIMARY KEY, emp_id INT NOT NULL REFERENCES employees(emp_id), work_date DATE NOT NULL, hours_worked NUMERIC(4,1) NOT NULL, is_remote SMALLINT DEFAULT 0);
CREATE TABLE employee_bank_accounts (account_id SERIAL PRIMARY KEY, emp_id INT NOT NULL REFERENCES employees(emp_id), iban VARCHAR(34), bank_name VARCHAR(100));

INSERT INTO departments(dept_id,dept_name,location) VALUES
(1,'الموارد البشرية','الرياض'),(2,'الهندسة','جدة'),(3,'المبيعات','الرياض'),(4,'المالية','جدة'),(5,'التسويق','الدمام'),(6,'أمن المعلومات','الرياض');
INSERT INTO roles(role_id,role_name,role_level) VALUES
(1,'مدير عام',5),(2,'مدير قسم',4),(3,'مهندس أول',4),(4,'محاسب',3),(5,'أخصائي موارد بشرية',3),(6,'مندوب مبيعات',2),(7,'متدرب',1);
INSERT INTO role_permissions(rp_id,role_id,resource,action,can_read,can_write) VALUES
(1,1,'employees','read',1,0),(2,1,'employees','write',0,1),(3,2,'employees','read',1,0),(4,2,'departments','read',1,0),(5,3,'attendance','read',1,0),(6,5,'employees','read',1,0),(7,6,'attendance','read',1,0),(8,4,'employees','read',1,0);
INSERT INTO employees(emp_id,full_name,dept_id,role_id,salary,hire_date,is_active) VALUES
(1,'أحمد محمود سالم',2,3,18500,'2019-03-10',1),(2,'سارة عبدالله القحطاني',1,5,9500,'2021-06-15',1),(3,'محمد إبراهيم حسن',3,6,7200,'2022-01-05',1),(4,'فاطمة الزهراء علي',4,4,8800,'2020-11-20',1),(5,'خالد سعد العتيبي',2,1,25000,'2018-07-01',1),(6,'نورة سالم الدوسري',5,4,8400,'2023-02-12',1),(7,'عمر فاروق شكري',2,3,17800,'2019-09-01',1),(8,'ريم ناصر الحربي',3,6,6900,'2023-05-20',1),(9,'يوسف كامل مراد',1,2,24000,'2018-01-15',1),(10,'هند عادل الشامي',2,3,18200,'2020-04-03',1),(11,'طارق حسن مصطفى',4,4,8600,'2022-08-14',0),(12,'لمى عبدالرحمن الغامدي',5,7,3500,'2024-03-01',1);
INSERT INTO attendance(att_id,emp_id,work_date,hours_worked,is_remote) VALUES
(1,1,'2026-09-21',8,0),(2,1,'2026-09-22',9,1),(3,1,'2026-09-23',7.5,0),(4,2,'2026-09-21',8,0),(5,2,'2026-09-24',6,1),(6,3,'2026-09-22',8,0),(7,3,'2026-09-25',4,1),(8,4,'2026-09-21',8,0),(9,4,'2026-09-22',9.5,0),(10,5,'2026-09-23',10,0),(11,5,'2026-09-24',8,1),(12,5,'2026-09-26',9,0),(13,6,'2026-09-21',8,0),(14,6,'2026-09-22',5,1),(15,7,'2026-09-23',8,0),(16,7,'2026-09-25',9,0),(17,8,'2026-09-21',7,1),(18,8,'2026-09-24',8,0),(19,9,'2026-09-22',8,0),(20,9,'2026-09-23',6,1),(21,9,'2026-09-26',8,0),(22,10,'2026-09-24',8,0),(23,10,'2026-09-25',8,1),(24,11,'2026-09-20',8,0),(25,12,'2026-09-21',6,0),(26,12,'2026-09-22',6,1);
INSERT INTO employee_bank_accounts(account_id,emp_id,iban,bank_name) VALUES
(1,1,'SA52601815908301661318','مصرف الراجحي'),(2,2,'SA60913909960308246281','بنك الرياض'),(3,3,'SA94821993518190937865','بنك ساب'),(4,4,'SA79754323194875749118','بنك البلاد'),(5,5,'SA62527601895559797114','البنك الأهلي السعودي'),(6,6,'SA71049746507529170342','مصرف الراجحي'),(7,7,'SA36671276842684656321','بنك الرياض'),(8,8,'SA22330792440268599528','بنك ساب'),(9,9,'SA90786666176031372159','بنك البلاد'),(10,10,'SA01092815901396245957','البنك الأهلي السعودي'),(11,11,'SA11777741215472803852','مصرف الراجحي'),(12,12,'SA80841485253888539336','بنك الرياض');
SELECT setval(pg_get_serial_sequence('departments','dept_id'),COALESCE((SELECT MAX(dept_id) FROM departments),1));
SELECT setval(pg_get_serial_sequence('roles','role_id'),COALESCE((SELECT MAX(role_id) FROM roles),1));
SELECT setval(pg_get_serial_sequence('role_permissions','rp_id'),COALESCE((SELECT MAX(rp_id) FROM role_permissions),1));
SELECT setval(pg_get_serial_sequence('employees','emp_id'),COALESCE((SELECT MAX(emp_id) FROM employees),1));
SELECT setval(pg_get_serial_sequence('attendance','att_id'),COALESCE((SELECT MAX(att_id) FROM attendance),1));
SELECT setval(pg_get_serial_sequence('employee_bank_accounts','account_id'),COALESCE((SELECT MAX(account_id) FROM employee_bank_accounts),1));

-- Tenants 2 and 3 use the same schema and are seeded by the companion migration.
-- Keep this file self-contained by duplicating the tenant-1 block when executing them.
