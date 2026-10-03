# Control Mapping and Risk Register

This document maps the technical controls in this project to common security frameworks, then lists the risks that remain. It is a learning exercise based on a fictional hospital database.

> Control references are given at a high level. Always check the current official text of each framework before relying on them.

## 1. Control mapping

| # | Control in this project | Where | Security goal | NIST SP 800-53 Rev. 5 | ISO/IEC 27001:2022 Annex A | HIPAA Security Rule | GDPR |
|---|---|---|---|---|---|---|---|
| 1 | Role-based access (receptionist, doctor, auditor) | `04_roles.sql` | Confidentiality | AC-2, AC-3 | 5.15, 5.18, 8.3 | 164.312(a)(1) | Art. 32 |
| 2 | Least privilege (each role gets only what it needs) | `04_roles.sql` | Confidentiality | AC-6 | 8.2, 8.3 | 164.308(a)(4) | Art. 5(1)(c), Art. 25 |
| 3 | Separation of duties (auditors cannot edit data) | `04_roles.sql` | Integrity, accountability | AC-5 | 5.3 | 164.308(a)(4) | Art. 32 |
| 4 | Trigger-based audit logging | `03_audit.sql` | Accountability | AU-2, AU-3, AU-12 | 8.15 | 164.312(b) | Art. 5(2), Art. 32 |
| 5 | Log protected from users (SECURITY DEFINER, no write access) | `03_audit.sql`, `04_roles.sql` | Integrity of evidence | AU-9 | 8.15 | 164.312(b), 164.312(c)(1) | Art. 32 |
| 6 | Foreign keys, NOT NULL, primary keys | `01_schema.sql` | Data integrity | SI-7 (related) | 8.3 | 164.312(c)(1) | Art. 5(1)(d), Art. 5(1)(f) |
| 7 | No DELETE permission on medical records | `04_roles.sql` | Integrity, availability | AC-6 | 8.3 | 164.312(c)(1) | Art. 5(1)(f) |
| 8 | Audit review queries (deletes, off-hours activity) | `05_queries.sql` | Detection | AU-6, SI-4 | 8.16 | 164.308(a)(1)(ii)(D) | Art. 32 |

**Note on GDPR:** health data is a special category of personal data (Art. 9), which means stricter protection is expected.

## 2. Control types

| Control | Type |
|---|---|
| Roles and least privilege | Preventive |
| Constraints and foreign keys | Preventive |
| Audit trigger | Detective |
| Audit review queries | Detective |
| No DELETE permission | Preventive |

## 3. Risk register (residual risks)

Likelihood and impact are rated Low / Medium / High.

| ID | Risk | Likelihood | Impact | Rating | Recommended control |
|---|---|---|---|---|---|
| R1 | Data stolen from disk or backups because it is not encrypted at rest | Medium | High | High | Encrypt at rest (disk or database level) |
| R2 | Data intercepted in transit | Medium | High | High | Enforce TLS for all connections |
| R3 | Weak or shared passwords (demo passwords in the repo) | High | High | High | Secrets manager, password policy, MFA |
| R4 | Doctors can read all patients, not only their own (need-to-know gap) | High | Medium | High | Row-level security |
| R5 | Reads (SELECT) are not logged, so snooping on records is invisible | Medium | High | High | Enable read auditing (for example the pgaudit extension) |
| R6 | Database owner or superuser can alter the audit log | Low | High | Medium | Ship logs to a separate, write-once system |
| R7 | No backups or recovery plan | Medium | High | High | Scheduled backups, tested restores |
| R8 | No alerting on suspicious log entries | Medium | Medium | Medium | Automated monitoring and alerts |

## 4. Summary

The project meets its basic goals for access control, accountability and integrity. The biggest gaps are encryption, strong authentication, need-to-know access, and logging of read access. In a real organisation these would be treated and tracked through a risk treatment plan.

## 5. Assumptions and scope

- Single PostgreSQL instance, fictional data
- No application layer, so authentication is handled by database accounts only
- No physical, network or organisational controls are assessed
