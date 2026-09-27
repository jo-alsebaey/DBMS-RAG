# ERD Schema

This document captures the database schema shown in the supplied diagram and stores it in the repository for reference and reuse.

```mermaid
erDiagram
    DEPARTMENTS ||--o{ EMPLOYEES : contains
    ROLES ||--o{ EMPLOYEES : assigns
    ROLES ||--o{ ROLE_PERMISSIONS : grants
    EMPLOYEES ||--o{ ATTENDANCE : records
    EMPLOYEES ||--o{ EMPLOYEE_BANK_ACCOUNTS : owns

    DEPARTMENTS {
        int department_id PK
        string department_name
        string location
        int tenant_id
    }

    ROLES {
        int role_id PK
        string role_title
        int level
        int tenant_id
    }

    ROLE_PERMISSIONS {
        int permission_id PK
        int role_id FK
        string permission_name
        string access_level
        int tenant_id
    }

    EMPLOYEES {
        int employee_id PK
        int department_id FK
        int role_id FK
        string email
        string first_name
        string last_name
        date hire_date
        boolean is_active
        decimal salary
        int tenant_id
    }

    ATTENDANCE {
        int attendance_id PK
        int employee_id FK
        date work_date
        decimal hours_worked
        string status
        int tenant_id
    }

    EMPLOYEE_BANK_ACCOUNTS {
        int account_id PK
        int employee_id FK
        string account_number
        string bank_name
        int tenant_id
    }
```

## Notes
- This is the visual schema attached in the request.
- It represents a multi-tenant HR model where each table includes a `tenant_id` for tenant isolation.
- The field naming may differ slightly from the SQL seed scripts in this repository, but the conceptual structure remains the same.
