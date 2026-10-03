# Hospital Database with Access Control and Audit Logging

A PostgreSQL database for a fictional hospital, built as a database course project and extended with security controls (role-based access control and audit logging) to practice GRC (Governance, Risk and Compliance) concepts.

> **All data in this project is fictional.** No real patient information is used.

## Goals

- Design a relational database in Third Normal Form (3NF)
- Apply the principle of least privilege with database roles
- Provide accountability with automatic audit logging
- Map technical controls to common security frameworks
- Identify the gaps and risks that remain

## Tools

- PostgreSQL
- SQL / PL/pgSQL
- dbdiagram.io (ER diagram)

## Database design

![ER Diagram](docs/er-diagram.png)

| Table | Purpose |
|---|---|
| `patients` | Basic patient details |
| `doctors` | Doctors and their specialties |
| `appointments` | Links patients and doctors at a given time |
| `medical_records` | Diagnoses and notes (sensitive data) |
| `audit_log` | Record of every change to medical records |

The schema is in 3NF: each table stores one kind of thing, there is no repeated data, and every column depends on its table's primary key. Foreign keys and `NOT NULL` constraints protect data integrity.

## Security features

**1. Role-based access control (least privilege)**

| Role | Can do | Cannot do |
|---|---|---|
| `receptionist_role` | Manage patients and appointments, view doctors | See medical records or the audit log |
| `doctor_role` | Read patients and appointments, read and write medical records | Delete records or see the audit log |
| `auditor_role` | Read the audit log | Change any data |

**2. Audit logging**

A trigger records every INSERT, UPDATE and DELETE on `medical_records`, storing the table, action, record ID, the login user, and a timestamp. The audit function runs with `SECURITY DEFINER`, so normal users never need write access to the log, and no one except the table owner can alter its history.

**3. Separation of duties**

The people who change medical data (doctors) are different from the people who review the log (auditors), and neither can edit the other's area.

## How to run

Run the files in this order (replace `hospital` with your database name):

```bash
createdb hospital
psql -d hospital -f sql/01_schema.sql
psql -d hospital -f sql/02_seed.sql
psql -d hospital -f sql/03_audit.sql
psql -d hospital -f sql/04_roles.sql
psql -d hospital -f sql/05_queries.sql
```

## Repository structure

```
hospital-db-security/
├── README.md
├── docs/
│   ├── er-diagram.png
│   └── control-mapping.md
└── sql/
    ├── 01_schema.sql
    ├── 02_seed.sql
    ├── 03_audit.sql
    ├── 04_roles.sql
    └── 05_queries.sql
```

## Compliance mapping

The technical controls are mapped to security frameworks (access control, audit and accountability, integrity) in [docs/control-mapping.md](docs/control-mapping.md).

## Limitations and risks

This is a learning project. A real system would also need:

- Encryption at rest and in transit
- A secrets manager and password policy (the passwords in `04_roles.sql` are demo placeholders)
- Backups and disaster recovery
- Row-level security so doctors only see their own patients
- Monitoring and alerts on suspicious audit log entries
- Audit logging of reads (SELECT), not only changes

## What I learned

- How database permissions implement least privilege and separation of duties
- How triggers provide accountability
- How technical controls connect to compliance requirements
