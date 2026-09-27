# DBMS-RAG

مستودع تجريبي ومهني يضم بيانات HR متعددة المستأجرين (Multi-tenant) مع مخطط قاعدة بيانات موحد، ومجموعة جاهزة من Seed Data لأنظمة قواعد البيانات الثلاثة الشائعة: PostgreSQL، MySQL، وSQL Server.

يُستخدم هذا المشروع كقاعدة معرفية للمهام المتعلقة بـ:
- اختبار قاعدة البيانات
- تحليل المخطط (Schema Analysis)
- أنظمة RAG وAI over databases
- تدريب أو اختبار الاستعلامات SQL
- نمذجة tenant-per-database

## الهدف من المشروع

تم تصميم هذا المستودع لتوفير:
- هيكل قاعدة بيانات حقيقي بشكل عملي
- بيانات HR منطقية ومتكاملة
- دعم لبيئات متعددة المستأجرين
- إمكانية التشغيل في أكثر من محرك قاعدة بيانات
- تنسيق عربي صحيح داخل بيانات الاختبار

## هيكل المستودع

```text
DBMS-RAG/
├── README.md
├── 01 DDL Seed PostgreSQL.sql
├── 02 DDL Seed MySQL.sql
├── 03 DDL Seed SQLServer.sql
├── .gitignore
└── docs/
    └── (اختياري لاحقاً)
```

## نموذج البيانات

يحتوي كل tenant على الجداول التالية:

### 1) departments
| الحقل | النوع | الوصف |
|---|---|---|
| dept_id | INT | رقم القسم |
| dept_name | VARCHAR/NVARCHAR | اسم القسم |
| location | VARCHAR/NVARCHAR | موقع القسم |

### 2) roles
| الحقل | النوع | الوصف |
|---|---|---|
| role_id | INT | رقم الدور |
| role_name | VARCHAR/NVARCHAR | اسم الدور |
| role_level | INT | مستوى الدور |

### 3) role_permissions
| الحقل | النوع | الوصف |
|---|---|---|
| rp_id | INT | رقم الصلاحية |
| role_id | INT | معرف الدور |
| resource | VARCHAR/NVARCHAR | اسم المورد |
| action | VARCHAR/NVARCHAR | الإجراء |
| can_read | SMALLINT/TINYINT | صلاحية القراءة |
| can_write | SMALLINT/TINYINT | صلاحية الكتابة |

### 4) employees
| الحقل | النوع | الوصف |
|---|---|---|
| emp_id | INT | رقم الموظف |
| full_name | VARCHAR/NVARCHAR | الاسم الكامل |
| dept_id | INT | قسم الموظف |
| role_id | INT | دور الموظف |
| salary | DECIMAL/NUMERIC | الراتب |
| hire_date | DATE | تاريخ التعيين |
| is_active | SMALLINT/TINYINT | الحالة النشطة |

### 5) attendance
| الحقل | النوع | الوصف |
|---|---|---|
| att_id | INT | رقم الحضور |
| emp_id | INT | معرف الموظف |
| work_date | DATE | تاريخ الحضور |
| hours_worked | DECIMAL/NUMERIC | عدد الساعات |
| is_remote | SMALLINT/TINYINT | هل العمل عن بعد؟ |

### 6) employee_bank_accounts
| الحقل | النوع | الوصف |
|---|---|---|
| account_id | INT | رقم الحساب |
| emp_id | INT | معرف الموظف |
| iban | VARCHAR/NVARCHAR | رقم الحساب البنكي |
| bank_name | VARCHAR/NVARCHAR | اسم البنك |

ملاحظة مهمة:
- يتم إدراج بيانات جدول employee_bank_accounts كبيانات تجريبية فقط لغرض الاختبار والنمذجة.
- لا تُستخدم كبيانات حقيقية أو حساسة في بيئات الإنتاج.

## بنية المستأجرين

كل قاعدة بيانات تشمل 3 مستأجرين منفصلين:

- hr_tenant_1
- hr_tenant_2
- hr_tenant_3

هذا يواكب نمط tenant-per-database، حيث تكون لكل شركة/مستأجر قاعدة بيانات مستقلة بالكامل، مع نفس المخطط ونفس بنية الجداول.

## ما الذي يتوفر في المشروع

### 01 DDL Seed PostgreSQL.sql
- إنشاء قواعد البيانات الثلاث
- إنشاء الجداول
- إدراج بيانات أولية
- ضبط sequences بعد إدخال القيم الصريحة
- دعم الحروف العربية مع UTF-8

### 02 DDL Seed MySQL.sql
- إنشاء قواعد البيانات الثلاث
- استخدام utf8mb4 لدعم العربية بالكامل
- نفس المخطط مع بيانات تجريبية لكل tenant
- مناسب للتشغيل المحلي أو التطوير

### 03 DDL Seed SQLServer.sql
- إنشاء قواعد البيانات الثلاث في SQL Server
- استخدام NVARCHAR وN'...' لدعم العربية
- استخدام IDENTITY_INSERT لضبط القيم المخصصة

## كيفية التشغيل

## 1) PostgreSQL

### المتطلبات
- PostgreSQL مثبت
- أداة psql متاحة

### التنفيذ
```bash
psql -U postgres -f "01 DDL Seed PostgreSQL.sql"
```

### التحقق
```sql
SELECT datname FROM pg_database WHERE datistemplate = false;
```

ثم:
```sql
\connect hr_tenant_1
SELECT * FROM departments;
```

## 2) MySQL

### المتطلبات
- MySQL أو MariaDB
- أداة mysql متاحة

### التنفيذ
```bash
mysql -u root -p < "02 DDL Seed MySQL.sql"
```

### التحقق
```sql
SHOW DATABASES LIKE 'hr_tenant%';
USE hr_tenant_1;
SHOW TABLES;
SELECT * FROM departments;
```

## 3) SQL Server

### المتطلبات
- SQL Server Management Studio (SSMS) أو sqlcmd

### التنفيذ
```bash
sqlcmd -S localhost -d master -i "03 DDL Seed SQLServer.sql"
```

أو من داخل SSMS:
- افتح الملف
- شغّل السكربت بالكامل

### التحقق
```sql
SELECT name FROM sys.databases WHERE name LIKE 'hr_tenant%';
USE hr_tenant_1;
SELECT * FROM departments;
```

## أمثلة استعلامات شائعة

### 1) عدد الموظفين حسب القسم
```sql
SELECT d.dept_name, COUNT(e.emp_id) AS total_employees
FROM hr_tenant_1.departments d
LEFT JOIN hr_tenant_1.employees e ON e.dept_id = d.dept_id
GROUP BY d.dept_name
ORDER BY total_employees DESC;
```

### 2) متوسط الراتب حسب الدور
```sql
SELECT r.role_name, AVG(e.salary) AS avg_salary
FROM hr_tenant_1.employees e
JOIN hr_tenant_1.roles r ON r.role_id = e.role_id
GROUP BY r.role_name
ORDER BY avg_salary DESC;
```

### 3) قائمة الحضور في تاريخ محدد
```sql
SELECT e.full_name, a.work_date, a.hours_worked, a.is_remote
FROM hr_tenant_1.employees e
JOIN hr_tenant_1.attendance a ON a.emp_id = e.emp_id
WHERE a.work_date = '2026-09-21';
```

### 4) الموظفون الذين يعملون عن بعد
```sql
SELECT e.full_name, COUNT(*) AS remote_days
FROM hr_tenant_1.attendance a
JOIN hr_tenant_1.employees e ON e.emp_id = a.emp_id
WHERE a.is_remote = 1
GROUP BY e.full_name;
```

## استخدامات هذا المشروع في RAG / AI

هذا المستودع مناسب جدًا لأنظمة:
- SQL-to-text
- Schema-aware question answering
- Database metadata extraction
- RAG over relational data
- تحليل العلاقات بين الجداول
- تدريب النماذج على استكشاف المخطط

أمثلة على الأسئلة التي يمكن الإجابة عنها باستخدام هذه البيانات:
- ما هي الجداول الأساسية في النظام؟
- ما هي العلاقة بين الموظفين والأقسام؟
- ما هو متوسط راتب مدير القسم؟
- ما هي أيام العمل عن بعد؟
- ما هي الصلاحيات لكل دور؟

## ملاحظات مهمة

### دعم اللغة العربية
- في PostgreSQL: يتم استخدام UTF-8
- في MySQL: يجب استخدام utf8mb4
- في SQL Server: يجب استخدام NVARCHAR وN'' للحقول النصية العربية

### إعادة التشغيل/إعادة التنفيذ
- تم تجهيز السكربتات بحيث يمكن تنفيذها مجدداً محلياً مع حذف قواعد البيانات القديمة أولاً (حيثما كان ذلك مناسباً)
- في PostgreSQL/MySQL تم استخدام `DROP DATABASE IF EXISTS`
- في SQL Server تم استخدام `IF DB_ID(...) IS NOT NULL DROP DATABASE ...`

## أفضل الممارسات

- لا تستخدم هذه البيانات في بيئة الإنتاج دون تنظيفها
- لا تعرّض بيانات الحسابات البنكية في بيئات مشتركة
- استخدم هذا المشروع في بيئة التطوير أو التدريب أو الاختبار
- استخدم أذونات محددة عند التشغيل في بيئات حقيقية

## الملفات والتكوينات الموصى بها مستقبلاً

يمكن تطوير هذا المشروع لاحقاً ليشمل:
- مجلد `sql/postgresql`
- مجلد `sql/mysql`
- مجلد `sql/sqlserver`
- ملف `docker-compose.yml`
- ملف `ERD.md` أو Mermaid chart
- ملف `schema.md` لوصف العلاقات
- إحصاءات إضافية وبيانات أكثر عمقاً

## الترخيص

هذا المشروع مخصص للاستخدام التعليمي، التجريبي، والبحثي.

## المؤلف / المشروع

DBMS-RAG

تم تصميم هذا المستودع بهدف توفير بيانات جاهزة ومتكاملة لاختبار أنظمة قواعد البيانات، تحليل المخطط، واستعمالها في تطبيقات RAG وAI.

## الخلاصة

إذا كنت تبحث عن:
- قاعدة بيانات HR متعددة المستأجرين
- بيانات جاهزة للاختبار
- مخطط موحد في PostgreSQL / MySQL / SQL Server
- نموذج مناسب للتدريب على RAG وSQL Analysis

فهذا المستودع يوفر لك نقطة انطلاق قوية جدًا.

---

إذا رغبت، أستطيع في الخطوة التالية أن أجهز لك:
- ملف `docker-compose.yml` لتشغيل القواعد الثلاث محلياً
- ملف `ERD` بصيغة Mermaid
- README باللغة الإنجليزية أيضاً
- مجلدات منظمة بشكل احترافي داخل المشروع
